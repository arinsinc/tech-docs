# Spring AOP (Aspect-Oriented Programming)

## Table of Contents
- [What is AOP?](#what-is-aop)
- [AOP Core Concepts](#aop-core-concepts)
- [Advice Types](#advice-types)
- [Pointcut Expressions](#pointcut-expressions)
- [Spring AOP vs AspectJ](#spring-aop-vs-aspectj)
- [Proxies in Spring AOP](#proxies-in-spring-aop)
- [Real-World Use Cases](#real-world-use-cases)

---

## What is AOP?

**Aspect-Oriented Programming (AOP)** is a programming paradigm that aims to increase modularity by allowing separation of cross-cutting concerns. It complements Object-Oriented Programming (OOP).

### The Problem AOP Solves

**Without AOP (Code Duplication):**
```java
@Service
public class UserService {
    
    public void createUser(User user) {
        // Logging - duplicated in every method
        System.out.println("Starting createUser");
        long start = System.currentTimeMillis();
        
        try {
            // Security check - duplicated
            if (!SecurityContext.hasPermission("CREATE_USER")) {
                throw new SecurityException("Access denied");
            }
            
            // Actual business logic
            userRepository.save(user);
            
            // Logging - duplicated
            long time = System.currentTimeMillis() - start;
            System.out.println("createUser completed in " + time + "ms");
        } catch (Exception e) {
            // Error handling - duplicated
            System.err.println("Error in createUser: " + e.getMessage());
            throw e;
        }
    }
    
    public void updateUser(User user) {
        // Same logging, security, error handling code repeated!
        System.out.println("Starting updateUser");
        // ... duplicate code
    }
}
```

**With AOP (Clean Separation):**
```java
@Service
public class UserService {
    
    public void createUser(User user) {
        // Only business logic - clean!
        userRepository.save(user);
    }
    
    public void updateUser(User user) {
        // Only business logic - clean!
        userRepository.update(user);
    }
}

@Aspect
@Component
public class LoggingAspect {
    
    @Around("execution(* com.example.service.*.*(..))")
    public Object logExecutionTime(ProceedingJoinPoint joinPoint) throws Throwable {
        long start = System.currentTimeMillis();
        System.out.println("Starting " + joinPoint.getSignature().getName());
        
        Object result = joinPoint.proceed();
        
        long time = System.currentTimeMillis() - start;
        System.out.println(joinPoint.getSignature().getName() + " completed in " + time + "ms");
        return result;
    }
}
```

### Cross-Cutting Concerns

Common concerns that cut across multiple modules:

1. **Logging**: Method entry/exit, execution time
2. **Security**: Authentication, authorization
3. **Transaction Management**: Begin, commit, rollback
4. **Caching**: Cache results of expensive operations
5. **Error Handling**: Catch and handle exceptions
6. **Performance Monitoring**: Track method execution times
7. **Auditing**: Track who did what and when
8. **Validation**: Input validation

### Benefits of AOP

- ✅ **DRY Principle**: Don't Repeat Yourself
- ✅ **Separation of Concerns**: Business logic separate from infrastructure
- ✅ **Maintainability**: Changes in one place
- ✅ **Cleaner Code**: Business logic is more readable
- ✅ **Reusability**: Aspects can be reused across applications

---

## AOP Core Concepts

### 1. Aspect

A module that encapsulates a cross-cutting concern.

```java
@Aspect
@Component
public class LoggingAspect {
    // This is an aspect - handles logging concern
}
```

### 2. Join Point

A point during execution where an aspect can be applied (method execution, exception thrown, etc.).

```java
// Every method execution is a potential join point
public void createUser(User user) { } // Join point
public User findUser(Long id) { }      // Join point
```

### 3. Advice

Action taken by an aspect at a particular join point.

```java
@Before("execution(* com.example.service.*.*(..))")
public void logBefore(JoinPoint joinPoint) {
    // This is the advice - what to do
    System.out.println("Before: " + joinPoint.getSignature().getName());
}
```

### 4. Pointcut

A predicate that matches join points. Defines WHERE advice should be applied.

```java
@Pointcut("execution(* com.example.service.*.*(..))")
public void serviceMethods() { }
// This pointcut matches all methods in service package
```

### 5. Target Object

The object being advised (proxied).

```java
@Service
public class UserService {
    // This is the target object
}
```

### 6. AOP Proxy

Object created by AOP framework to implement aspect contracts.

```java
// Spring creates a proxy that wraps UserService
UserService proxy = context.getBean(UserService.class);
// proxy intercepts calls and applies aspects
```

### 7. Weaving

Process of linking aspects with other application types to create advised objects.

- **Compile-time weaving**: AspectJ compiler
- **Load-time weaving**: When classes are loaded
- **Runtime weaving**: Spring AOP (using proxies)

### Complete Example

```java
// Target Object
@Service
public class OrderService {
    public Order createOrder(OrderRequest request) {
        // Business logic
        return new Order();
    }
}

// Aspect
@Aspect
@Component
public class TransactionAspect {
    
    // Pointcut
    @Pointcut("execution(* com.example.service.*.*(..))")
    public void serviceMethods() { }
    
    // Advice
    @Around("serviceMethods()")
    public Object manageTransaction(ProceedingJoinPoint joinPoint) throws Throwable {
        System.out.println("Begin transaction");
        try {
            Object result = joinPoint.proceed(); // Execute method
            System.out.println("Commit transaction");
            return result;
        } catch (Exception e) {
            System.out.println("Rollback transaction");
            throw e;
        }
    }
}
```

---

## Advice Types

### 1. @Before

Runs before the join point (method execution).

```java
@Aspect
@Component
public class SecurityAspect {
    
    @Before("execution(* com.example.service.*.*(..))")
    public void checkSecurity(JoinPoint joinPoint) {
        System.out.println("Security check before: " + joinPoint.getSignature().getName());
        
        // Check authentication
        if (!isAuthenticated()) {
            throw new SecurityException("Not authenticated");
        }
        
        // Check authorization
        if (!hasPermission(joinPoint.getSignature().getName())) {
            throw new SecurityException("Access denied");
        }
    }
}
```

**Characteristics:**
- Cannot prevent method execution
- Cannot change method arguments
- Cannot access return value
- Can throw exception to prevent execution

### 2. @After (Finally)

Runs after the join point, regardless of outcome.

```java
@Aspect
@Component
public class ResourceAspect {
    
    @After("execution(* com.example.service.FileService.*(..))")
    public void cleanupResources(JoinPoint joinPoint) {
        System.out.println("Cleanup after: " + joinPoint.getSignature().getName());
        // Always executes, like finally block
        // Release resources, close connections, etc.
    }
}
```

**Characteristics:**
- Always executes (success or exception)
- Like `finally` block
- Cannot access return value
- Cannot prevent exception propagation

### 3. @AfterReturning

Runs after successful method execution.

```java
@Aspect
@Component
public class CacheAspect {
    
    @AfterReturning(
        pointcut = "execution(* com.example.service.UserService.findUser(..))",
        returning = "result"
    )
    public void cacheResult(JoinPoint joinPoint, Object result) {
        System.out.println("Caching result: " + result);
        
        Object[] args = joinPoint.getArgs();
        Long userId = (Long) args[0];
        cache.put(userId, result);
    }
}
```

**Characteristics:**
- Only runs if method returns normally
- Can access return value
- Cannot modify return value (without tricks)
- Cannot prevent exception

### 4. @AfterThrowing

Runs if method throws an exception.

```java
@Aspect
@Component
public class ExceptionHandlingAspect {
    
    @AfterThrowing(
        pointcut = "execution(* com.example.service.*.*(..))",
        throwing = "exception"
    )
    public void handleException(JoinPoint joinPoint, Exception exception) {
        System.err.println("Exception in: " + joinPoint.getSignature().getName());
        System.err.println("Exception: " + exception.getMessage());
        
        // Log to monitoring system
        // Send alert
        // Record metrics
    }
}
```

**Characteristics:**
- Only runs if method throws exception
- Can access the exception
- Cannot prevent exception propagation
- Cannot modify the exception

### 5. @Around (Most Powerful)

Wraps the join point, full control over execution.

```java
@Aspect
@Component
public class PerformanceAspect {
    
    @Around("execution(* com.example.service.*.*(..))")
    public Object measurePerformance(ProceedingJoinPoint joinPoint) throws Throwable {
        String methodName = joinPoint.getSignature().getName();
        
        // Before method execution
        System.out.println("Starting: " + methodName);
        long start = System.currentTimeMillis();
        
        Object result = null;
        try {
            // Execute the actual method
            result = joinPoint.proceed();
            
            // After successful execution
            long time = System.currentTimeMillis() - start;
            System.out.println(methodName + " completed in " + time + "ms");
            
            return result;
        } catch (Exception e) {
            // Handle exception
            System.err.println(methodName + " failed: " + e.getMessage());
            throw e;
        }
    }
}
```

**Characteristics:**
- Full control over method execution
- Can prevent method execution
- Can modify arguments
- Can modify return value
- Can catch and handle exceptions
- Can retry execution
- **Must call `proceed()` to execute the method**

### @Around Advanced Examples

#### Modify Arguments
```java
@Around("execution(* com.example.service.UserService.createUser(..))")
public Object sanitizeInput(ProceedingJoinPoint joinPoint) throws Throwable {
    Object[] args = joinPoint.getArgs();
    User user = (User) args[0];
    
    // Sanitize input
    user.setEmail(user.getEmail().toLowerCase().trim());
    user.setName(user.getName().trim());
    
    // Proceed with modified arguments
    return joinPoint.proceed(new Object[]{user});
}
```

#### Modify Return Value
```java
@Around("execution(* com.example.service.ProductService.getPrice(..))")
public Object addTax(ProceedingJoinPoint joinPoint) throws Throwable {
    BigDecimal price = (BigDecimal) joinPoint.proceed();
    
    // Add 10% tax
    BigDecimal tax = price.multiply(new BigDecimal("0.10"));
    return price.add(tax);
}
```

#### Retry Logic
```java
@Around("@annotation(Retryable)")
public Object retry(ProceedingJoinPoint joinPoint) throws Throwable {
    int maxAttempts = 3;
    int attempt = 0;
    
    while (attempt < maxAttempts) {
        try {
            return joinPoint.proceed();
        } catch (Exception e) {
            attempt++;
            if (attempt >= maxAttempts) {
                throw e;
            }
            Thread.sleep(1000 * attempt); // Exponential backoff
        }
    }
    throw new RuntimeException("Max retry attempts reached");
}
```

#### Conditional Execution
```java
@Around("execution(* com.example.service.*.*(..))")
public Object cache(ProceedingJoinPoint joinPoint) throws Throwable {
    String key = generateKey(joinPoint);
    
    // Check cache
    Object cached = cache.get(key);
    if (cached != null) {
        System.out.println("Returning from cache");
        return cached;
    }
    
    // Execute method and cache result
    Object result = joinPoint.proceed();
    cache.put(key, result);
    return result;
}
```

### Advice Execution Order

```java
@Around  // Outer wrapper
@Before  // Before method
Method Execution
@AfterReturning / @AfterThrowing  // Based on outcome
@After   // Finally
@Around  // Return from wrapper
```

**With multiple aspects:**
```java
@Aspect
@Order(1)  // Executes first
public class SecurityAspect { }

@Aspect
@Order(2)  // Executes second
public class LoggingAspect { }

@Aspect
@Order(3)  // Executes last
public class TransactionAspect { }
```

---

## Pointcut Expressions

Pointcut expressions define where advice should be applied.

### Execution Pointcut

Most common pointcut designator.

**Syntax:**
```
execution(modifiers? return-type declaring-type?.method-name(parameters) throws?)
```

**Examples:**

```java
// All public methods
@Pointcut("execution(public * *(..))")

// All methods returning User
@Pointcut("execution(com.example.User *(..))")

// All methods in UserService
@Pointcut("execution(* com.example.service.UserService.*(..))")

// All methods starting with "find"
@Pointcut("execution(* find*(..))")

// Methods with specific parameters
@Pointcut("execution(* *(Long, String))")

// Methods with any number of parameters
@Pointcut("execution(* *(..))")

// Methods with at least one parameter
@Pointcut("execution(* *(*,..))")

// Methods in service package and subpackages
@Pointcut("execution(* com.example.service..*.*(..))")
```

### Within Pointcut

Match all methods within certain types.

```java
// All methods in UserService
@Pointcut("within(com.example.service.UserService)")

// All methods in service package
@Pointcut("within(com.example.service.*)")

// All methods in service package and subpackages
@Pointcut("within(com.example.service..*)")

// All methods in classes implementing UserRepository
@Pointcut("within(com.example.repository.UserRepository+)")
```

### This Pointcut

Match based on proxy type.

```java
// Proxy implements UserService
@Pointcut("this(com.example.service.UserService)")
```

### Target Pointcut

Match based on target object type.

```java
// Target object implements UserService
@Pointcut("target(com.example.service.UserService)")
```

### Args Pointcut

Match based on method arguments.

```java
// Method takes Long as first argument
@Pointcut("args(Long,..)")

// Method takes User
@Pointcut("args(com.example.model.User)")

// Bind argument to advice parameter
@Before("execution(* com.example.service.*.*(..)) && args(user)")
public void logUser(User user) {
    System.out.println("User: " + user.getName());
}
```

### @annotation Pointcut

Match methods with specific annotation.

```java
// Custom annotation
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public @interface Audited { }

// Pointcut for annotated methods
@Pointcut("@annotation(Audited)")
public void auditedMethods() { }

// Usage
@Service
public class UserService {
    @Audited
    public void deleteUser(Long id) {
        // This method will be advised
    }
}
```

### @within Pointcut

Match methods in classes with specific annotation.

```java
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
public @interface Monitored { }

@Pointcut("@within(Monitored)")
public void monitoredClasses() { }

@Service
@Monitored
public class UserService {
    public void createUser() { } // Advised
    public void updateUser() { } // Advised
}
```

### @target Pointcut

Similar to @within but for runtime type.

```java
@Pointcut("@target(org.springframework.stereotype.Service)")
public void serviceClasses() { }
```

### @args Pointcut

Match methods where arguments have specific annotations.

```java
@Target(ElementType.PARAMETER)
@Retention(RetentionPolicy.RUNTIME)
public @interface Validated { }

@Pointcut("@args(com.example.Validated)")
public void validatedArgs() { }
```

### Bean Pointcut (Spring-specific)

Match specific bean names.

```java
// Specific bean
@Pointcut("bean(userService)")

// Wildcard pattern
@Pointcut("bean(*Service)")

// Exclude certain beans
@Pointcut("bean(*Service) && !bean(systemService)")
```

### Combining Pointcuts

Use logical operators to combine pointcuts.

```java
@Aspect
@Component
public class CombinedAspect {
    
    // Define reusable pointcuts
    @Pointcut("execution(* com.example.service.*.*(..))")
    public void serviceMethods() { }
    
    @Pointcut("execution(public * *(..))")
    public void publicMethods() { }
    
    @Pointcut("@annotation(Transactional)")
    public void transactionalMethods() { }
    
    // AND - both conditions must match
    @Before("serviceMethods() && publicMethods()")
    public void adviceOne() { }
    
    // OR - either condition can match
    @Before("serviceMethods() || transactionalMethods()")
    public void adviceTwo() { }
    
    // NOT - negation
    @Before("serviceMethods() && !publicMethods()")
    public void adviceThree() { }
    
    // Complex combination
    @Around("serviceMethods() && (args(Long,..)) && !@annotation(NoLogging)")
    public Object complexAdvice(ProceedingJoinPoint joinPoint) throws Throwable {
        return joinPoint.proceed();
    }
}
```

### Pointcut Parameter Binding

```java
@Aspect
@Component
public class ParameterBindingAspect {
    
    // Bind method argument
    @Before("execution(* com.example.service.*.create*(..)) && args(entity)")
    public void logEntity(Object entity) {
        System.out.println("Creating: " + entity);
    }
    
    // Bind annotation
    @Around("@annotation(cacheable)")
    public Object cache(ProceedingJoinPoint joinPoint, Cacheable cacheable) throws Throwable {
        String cacheName = cacheable.value();
        // Use annotation values
        return joinPoint.proceed();
    }
    
    // Multiple bindings
    @Before("execution(* com.example.service.*.update*(..)) && args(id, entity)")
    public void logUpdate(Long id, Object entity) {
        System.out.println("Updating " + id + " with " + entity);
    }
}
```

---

## Spring AOP vs AspectJ

### Comparison Table

| Feature | Spring AOP | AspectJ |
|---------|-----------|---------|
| **Implementation** | Proxy-based | Bytecode weaving |
| **Weaving Time** | Runtime | Compile-time or Load-time |
| **Join Points** | Method execution only | Methods, constructors, fields, etc. |
| **Performance** | Slight overhead | Faster (no proxy) |
| **Ease of Use** | Easy (Spring integration) | More complex setup |
| **Pointcut Syntax** | Subset of AspectJ | Full AspectJ syntax |
| **Proxy Types** | JDK or CGLIB | Not needed |
| **Private Methods** | ❌ Cannot advise | ✅ Can advise |
| **Final Classes** | ⚠️ CGLIB only | ✅ Can advise |
| **Self-invocation** | ❌ Not advised | ✅ Advised |
| **Spring Integration** | ✅ Native | ⚠️ Requires configuration |

### Spring AOP Limitations

```java
@Service
public class UserService {
    
    // ✅ Can be advised (public method, called externally)
    public void publicMethod() {
        // Advice applies here
    }
    
    // ❌ Cannot be advised (private method)
    private void privateMethod() {
        // Spring AOP cannot advise this
    }
    
    // ❌ Self-invocation not advised
    public void methodA() {
        methodB(); // This call is NOT advised!
    }
    
    public void methodB() {
        // Business logic
    }
}

// External call - ADVISED
@Autowired
UserService service;
service.methodB(); // ✅ Advice applies

// Internal call - NOT ADVISED
service.methodA(); // methodA is advised
// but the call to methodB inside methodA is NOT advised
```

**Why self-invocation doesn't work:**
```java
// What Spring does
UserService proxy = new UserServiceProxy(realUserService);

// External call
proxy.methodB(); // Goes through proxy - ADVISED

// Internal call
proxy.methodA() {
    // Inside methodA, "this" refers to real object, not proxy
    this.methodB(); // Direct call, bypasses proxy - NOT ADVISED
}
```

**Solution for self-invocation:**
```java
@Service
public class UserService {
    @Autowired
    private ApplicationContext context;
    
    public void methodA() {
        // Get the proxy
        UserService proxy = context.getBean(UserService.class);
        proxy.methodB(); // Now advised!
    }
    
    public void methodB() {
        // Business logic
    }
}
```

### When to Use AspectJ

Use AspectJ when you need:
- Advising private/protected methods
- Advising final classes
- Advising static methods
- Advising constructors
- Field access interception
- Maximum performance
- Self-invocation support

**AspectJ Setup:**
```xml
<!-- Maven dependency -->
<dependency>
    <groupId>org.aspectj</groupId>
    <artifactId>aspectjweaver</artifactId>
</dependency>

<dependency>
    <groupId>org.aspectj</groupId>
    <artifactId>aspectjrt</artifactId>
</dependency>
```

```java
@Configuration
@EnableLoadTimeWeaving
public class AspectJConfig {
    @Bean
    public LoadTimeWeaver loadTimeWeaver() {
        return new InstrumentationLoadTimeWeaver();
    }
}
```

---

## Proxies in Spring AOP

Spring AOP uses proxies to implement aspects.

### JDK Dynamic Proxy

Used when target implements at least one interface.

```java
// Interface
public interface UserService {
    void createUser(User user);
}

// Implementation
@Service
public class UserServiceImpl implements UserService {
    @Override
    public void createUser(User user) {
        // Business logic
    }
}

// Spring creates JDK dynamic proxy
// Proxy implements UserService interface
```

**How it works:**
```java
// Spring internally does something like this
UserService proxy = (UserService) Proxy.newProxyInstance(
    UserService.class.getClassLoader(),
    new Class[]{UserService.class},
    new InvocationHandler() {
        @Override
        public Object invoke(Object proxy, Method method, Object[] args) {
            // Apply advice before
            Object result = method.invoke(realObject, args);
            // Apply advice after
            return result;
        }
    }
);
```

**Characteristics:**
- ✅ Based on interfaces
- ✅ Part of Java (no external dependency)
- ❌ Requires interface
- ❌ Only interface methods can be advised

### CGLIB Proxy

Used when target doesn't implement interface.

```java
// No interface
@Service
public class UserService {
    public void createUser(User user) {
        // Business logic
    }
}

// Spring creates CGLIB proxy
// Proxy extends UserService class
```

**Characteristics:**
- ✅ Can proxy classes without interfaces
- ✅ Creates subclass of target
- ❌ Cannot proxy final classes
- ❌ Cannot proxy final methods
- ❌ Requires CGLIB library (included in Spring)

### Force CGLIB Proxy

```java
@Configuration
@EnableAspectJAutoProxy(proxyTargetClass = true)
public class AopConfig {
    // Forces CGLIB for all beans
}

// Or in Spring Boot
@SpringBootApplication
@EnableAspectJAutoProxy(proxyTargetClass = true)
public class Application { }
```

### Expose Proxy

Access current proxy from within target object.

```java
@Service
public class UserService {
    public void methodA() {
        // Get current proxy
        UserService proxy = (UserService) AopContext.currentProxy();
        proxy.methodB(); // Now advised!
    }
    
    public void methodB() {
        // Business logic
    }
}

// Enable proxy exposure
@Configuration
@EnableAspectJAutoProxy(exposeProxy = true)
public class AopConfig { }
```

---

## Real-World Use Cases

### 1. Logging

```java
@Aspect
@Component
@Slf4j
public class LoggingAspect {
    
    @Around("@annotation(Loggable)")
    public Object logMethodExecution(ProceedingJoinPoint joinPoint) throws Throwable {
        String className = joinPoint.getTarget().getClass().getSimpleName();
        String methodName = joinPoint.getSignature().getName();
        
        log.info("→ {}.{} - Starting", className, methodName);
        
        long start = System.currentTimeMillis();
        try {
            Object result = joinPoint.proceed();
            long executionTime = System.currentTimeMillis() - start;
            
            log.info("← {}.{} - Completed in {}ms", className, methodName, executionTime);
            return result;
        } catch (Exception e) {
            log.error("✗ {}.{} - Failed: {}", className, methodName, e.getMessage());
            throw e;
        }
    }
}

// Usage
@Service
public class OrderService {
    @Loggable
    public Order createOrder(OrderRequest request) {
        return orderRepository.save(new Order(request));
    }
}
```

### 2. Performance Monitoring

```java
@Aspect
@Component
public class PerformanceMonitoringAspect {
    
    private final MeterRegistry meterRegistry;
    
    @Autowired
    public PerformanceMonitoringAspect(MeterRegistry meterRegistry) {
        this.meterRegistry = meterRegistry;
    }
    
    @Around("execution(* com.example.service.*.*(..))")
    public Object monitorPerformance(ProceedingJoinPoint joinPoint) throws Throwable {
        String methodName = joinPoint.getSignature().toShortString();
        
        Timer.Sample sample = Timer.start(meterRegistry);
        try {
            Object result = joinPoint.proceed();
            sample.stop(Timer.builder("method.execution.time")
                    .tag("method", methodName)
                    .tag("status", "success")
                    .register(meterRegistry));
            return result;
        } catch (Exception e) {
            sample.stop(Timer.builder("method.execution.time")
                    .tag("method", methodName)
                    .tag("status", "error")
                    .register(meterRegistry));
            throw e;
        }
    }
}
```

### 3. Security/Authorization

```java
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public @interface RequiresRole {
    String[] value();
}

@Aspect
@Component
public class SecurityAspect {
    
    @Autowired
    private SecurityContext securityContext;
    
    @Before("@annotation(requiresRole)")
    public void checkAuthorization(JoinPoint joinPoint, RequiresRole requiresRole) {
        User currentUser = securityContext.getCurrentUser();
        
        if (currentUser == null) {
            throw new SecurityException("Not authenticated");
        }
        
        String[] requiredRoles = requiresRole.value();
        boolean hasRole = Arrays.stream(requiredRoles)
                .anyMatch(role -> currentUser.hasRole(role));
        
        if (!hasRole) {
            throw new SecurityException("Access denied. Required roles: " + 
                    Arrays.toString(requiredRoles));
        }
    }
}

// Usage
@Service
public class AdminService {
    @RequiresRole({"ADMIN", "SUPER_ADMIN"})
    public void deleteUser(Long userId) {
        userRepository.deleteById(userId);
    }
}
```

### 4. Caching

```java
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public @interface Cacheable {
    String value();
    int ttl() default 3600;
}

@Aspect
@Component
public class CachingAspect {
    
    private final Map<String, CacheEntry> cache = new ConcurrentHashMap<>();
    
    @Around("@annotation(cacheable)")
    public Object cache(ProceedingJoinPoint joinPoint, Cacheable cacheable) throws Throwable {
        String key = generateKey(joinPoint, cacheable.value());
        
        CacheEntry entry = cache.get(key);
        if (entry != null && !entry.isExpired()) {
            System.out.println("Cache hit: " + key);
            return entry.getValue();
        }
        
        System.out.println("Cache miss: " + key);
        Object result = joinPoint.proceed();
        cache.put(key, new CacheEntry(result, cacheable.ttl()));
        return result;
    }
    
    private String generateKey(ProceedingJoinPoint joinPoint, String prefix) {
        String method = joinPoint.getSignature().toShortString();
        String args = Arrays.toString(joinPoint.getArgs());
        return prefix + ":" + method + ":" + args;
    }
    
    @Scheduled(fixedRate = 60000)
    public void evictExpiredEntries() {
        cache.entrySet().removeIf(entry -> entry.getValue().isExpired());
    }
}

// Usage
@Service
public class ProductService {
    @Cacheable(value = "products", ttl = 300)
    public Product getProduct(Long id) {
        return productRepository.findById(id);
    }
}
```

### 5. Retry Logic

```java
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public @interface Retry {
    int maxAttempts() default 3;
    long delay() default 1000;
    Class<? extends Exception>[] retryFor() default {Exception.class};
}

@Aspect
@Component
@Slf4j
public class RetryAspect {
    
    @Around("@annotation(retry)")
    public Object retry(ProceedingJoinPoint joinPoint, Retry retry) throws Throwable {
        int attempt = 0;
        Throwable lastException = null;
        
        while (attempt < retry.maxAttempts()) {
            try {
                attempt++;
                return joinPoint.proceed();
            } catch (Throwable e) {
                lastException = e;
                
                if (!shouldRetry(e, retry.retryFor())) {
                    throw e;
                }
                
                if (attempt < retry.maxAttempts()) {
                    log.warn("Attempt {} failed, retrying in {}ms: {}",
                            attempt, retry.delay(), e.getMessage());
                    Thread.sleep(retry.delay() * attempt); // Exponential backoff
                }
            }
        }
        
        log.error("All {} attempts failed", retry.maxAttempts());
        throw lastException;
    }
    
    private boolean shouldRetry(Throwable e, Class<? extends Exception>[] retryFor) {
        return Arrays.stream(retryFor)
                .anyMatch(clazz -> clazz.isInstance(e));
    }
}

// Usage
@Service
public class PaymentService {
    @Retry(maxAttempts = 5, delay = 2000, retryFor = {TimeoutException.class})
    public Payment processPayment(PaymentRequest request) {
        return externalPaymentGateway.process(request);
    }
}
```

### 6. Auditing

```java
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public @interface Audited {
    String action();
}

@Aspect
@Component
public class AuditingAspect {
    
    @Autowired
    private AuditLogRepository auditLogRepository;
    
    @Autowired
    private SecurityContext securityContext;
    
    @AfterReturning(pointcut = "@annotation(audited)", returning = "result")
    public void audit(JoinPoint joinPoint, Audited audited, Object result) {
        User currentUser = securityContext.getCurrentUser();
        
        AuditLog log = AuditLog.builder()
                .user(currentUser != null ? currentUser.getUsername() : "anonymous")
                .action(audited.action())
                .method(joinPoint.getSignature().toShortString())
                .arguments(Arrays.toString(joinPoint.getArgs()))
                .result(result != null ? result.toString() : "void")
                .timestamp(LocalDateTime.now())
                .ipAddress(getClientIpAddress())
                .build();
        
        auditLogRepository.save(log);
    }
    
    private String getClientIpAddress() {
        RequestAttributes attrs = RequestContextHolder.getRequestAttributes();
        if (attrs instanceof ServletRequestAttributes) {
            HttpServletRequest request = ((ServletRequestAttributes) attrs).getRequest();
            return request.getRemoteAddr();
        }
        return "unknown";
    }
}

// Usage
@Service
public class UserService {
    @Audited(action = "USER_CREATED")
    public User createUser(User user) {
        return userRepository.save(user);
    }
    
    @Audited(action = "USER_DELETED")
    public void deleteUser(Long userId) {
        userRepository.deleteById(userId);
    }
}
```

### 7. Exception Translation

```java
@Aspect
@Component
@Slf4j
public class ExceptionTranslationAspect {
    
    @AfterThrowing(
        pointcut = "execution(* com.example.service.*.*(..))",
        throwing = "exception"
    )
    public void translateException(JoinPoint joinPoint, Exception exception) {
        log.error("Exception in {}: {}", 
                joinPoint.getSignature().toShortString(), 
                exception.getMessage());
        
        // Translate technical exceptions to business exceptions
        if (exception instanceof SQLException) {
            throw new DataAccessException("Database error occurred", exception);
        } else if (exception instanceof IOException) {
            throw new FileProcessingException("File processing failed", exception);
        } else if (exception instanceof TimeoutException) {
            throw new ServiceUnavailableException("Service timeout", exception);
        }
    }
}
```

### 8. Validation

```java
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public @interface ValidateParams { }

@Aspect
@Component
public class ValidationAspect {
    
    @Autowired
    private Validator validator;
    
    @Before("@annotation(ValidateParams)")
    public void validateParameters(JoinPoint joinPoint) {
        Object[] args = joinPoint.getArgs();
        
        for (Object arg : args) {
            if (arg != null) {
                Set<ConstraintViolation<Object>> violations = validator.validate(arg);
                
                if (!violations.isEmpty()) {
                    throw new ValidationException(
                        violations.stream()
                            .map(ConstraintViolation::getMessage)
                            .collect(Collectors.joining(", "))
                    );
                }
            }
        }
    }
}

// Usage
@Service
public class UserService {
    @ValidateParams
    public User createUser(@Valid User user) {
        return userRepository.save(user);
    }
}
```

---

## Best Practices

1. **Keep Aspects Focused**: One aspect, one concern
2. **Use Specific Pointcuts**: Avoid overly broad pointcuts
3. **Consider Performance**: @Around adds overhead
4. **Document Aspects**: Aspects can be hard to debug
5. **Test Aspects**: Write unit tests for advice logic
6. **Avoid Complex Logic**: Keep advice simple
7. **Order Matters**: Use @Order when multiple aspects apply
8. **Be Careful with State**: Aspects are singletons

---

## Summary

**Key Takeaways:**

1. **AOP** separates cross-cutting concerns from business logic
2. **@Around** is most powerful but use sparingly
3. **Pointcut expressions** define where advice applies
4. **Spring AOP** uses proxies (JDK or CGLIB)
5. **AspectJ** more powerful but more complex
6. **Self-invocation** doesn't work with Spring AOP
7. **Real-world uses**: Logging, security, caching, monitoring

**Common Use Cases:**
- ✅ Logging and monitoring
- ✅ Security and authorization
- ✅ Transaction management
- ✅ Caching
- ✅ Error handling
- ✅ Performance tracking
- ✅ Auditing
- ✅ Validation

