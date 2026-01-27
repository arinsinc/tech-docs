# Spring Bean Lifecycle

## Table of Contents
- [What is a Spring Bean?](#what-is-a-spring-bean)
- [Bean Scopes](#bean-scopes)
- [Bean Lifecycle](#bean-lifecycle)
- [Bean Configuration Methods](#bean-configuration-methods)
- [Component Scanning](#component-scanning)
- [Lifecycle Callbacks](#lifecycle-callbacks)

---

## What is a Spring Bean?

A **Spring Bean** is an object that is instantiated, assembled, and managed by the Spring IoC container. Beans are the backbone of a Spring application.

### Characteristics of Spring Beans

1. **Container-Managed**: Created and managed by Spring
2. **Configurable**: Behavior defined through configuration
3. **Injectable**: Can be injected into other beans
4. **Lifecycle-Aware**: Hooks for initialization and destruction

### Creating a Bean

```java
// Simple POJO
public class UserService {
    private String serviceName;
    
    public void setServiceName(String serviceName) {
        this.serviceName = serviceName;
    }
    
    public void processUser() {
        System.out.println("Processing user with " + serviceName);
    }
}

// Make it a Spring bean
@Service
public class UserService {
    // Now managed by Spring
}
```

### Bean Naming

```java
// Default bean name: userService (class name with first letter lowercase)
@Service
public class UserService { }

// Custom bean name
@Service("customUserService")
public class UserService { }

// Multiple names
@Service(value = {"userService", "userSvc"})
public class UserService { }

// Java config bean naming
@Configuration
public class AppConfig {
    @Bean  // Default name: userService (method name)
    public UserService userService() {
        return new UserService();
    }
    
    @Bean(name = "customUserService")
    public UserService customNamedService() {
        return new UserService();
    }
}
```

---

## Bean Scopes

Bean scope defines the lifecycle and visibility of beans in the container.

### 1. Singleton (Default Scope)

One instance per Spring IoC container.

```java
@Service
@Scope("singleton")  // Default, can be omitted
public class UserService {
    private int counter = 0;
    
    public void incrementCounter() {
        counter++;
    }
    
    public int getCounter() {
        return counter;
    }
}

// Usage
UserService service1 = context.getBean(UserService.class);
UserService service2 = context.getBean(UserService.class);

service1.incrementCounter(); // counter = 1
System.out.println(service2.getCounter()); // Prints: 1 (same instance!)
System.out.println(service1 == service2); // true
```

**Characteristics:**
- ✅ Created when container starts (eager initialization)
- ✅ Single instance shared across application
- ✅ Thread-safety considerations needed
- ✅ Better performance (reuse)

**Use Cases:**
- Stateless services
- Shared resources (connection pools, caches)
- Configuration beans

### 2. Prototype

New instance every time it's requested.

```java
@Service
@Scope("prototype")
public class ShoppingCart {
    private List<Item> items = new ArrayList<>();
    
    public void addItem(Item item) {
        items.add(item);
    }
}

// Usage
ShoppingCart cart1 = context.getBean(ShoppingCart.class);
ShoppingCart cart2 = context.getBean(ShoppingCart.class);

cart1.addItem(new Item("Book"));
System.out.println(cart2.getItems().size()); // Prints: 0 (different instance!)
System.out.println(cart1 == cart2); // false
```

**Characteristics:**
- ✅ Created on demand (lazy initialization)
- ✅ New instance for each request
- ✅ Spring doesn't manage destruction
- ✅ No shared state issues

**Use Cases:**
- Stateful beans
- User-specific data
- Temporary objects

### 3. Request (Web Applications)

One instance per HTTP request.

```java
@Component
@Scope(value = WebApplicationContext.SCOPE_REQUEST, proxyMode = ScopedProxyMode.TARGET_CLASS)
public class LoginContext {
    private String username;
    private LocalDateTime loginTime;
    
    public void setUsername(String username) {
        this.username = username;
        this.loginTime = LocalDateTime.now();
    }
}

@RestController
public class UserController {
    @Autowired
    private LoginContext loginContext; // Different for each request
    
    @GetMapping("/login")
    public String login(@RequestParam String username) {
        loginContext.setUsername(username);
        return "Logged in: " + username;
    }
}
```

**Characteristics:**
- Created for each HTTP request
- Destroyed after request completes
- Requires proxy for injection into singleton beans

### 4. Session (Web Applications)

One instance per HTTP session.

```java
@Component
@Scope(value = WebApplicationContext.SCOPE_SESSION, proxyMode = ScopedProxyMode.TARGET_CLASS)
public class ShoppingCart {
    private List<Product> products = new ArrayList<>();
    
    public void addProduct(Product product) {
        products.add(product);
    }
}

@RestController
public class CartController {
    @Autowired
    private ShoppingCart cart; // Same instance throughout session
    
    @PostMapping("/cart/add")
    public String addToCart(@RequestBody Product product) {
        cart.addProduct(product);
        return "Added to cart";
    }
}
```

### 5. Application

One instance per ServletContext.

```java
@Component
@Scope(value = WebApplicationContext.SCOPE_APPLICATION, proxyMode = ScopedProxyMode.TARGET_CLASS)
public class ApplicationConfig {
    private Map<String, String> settings = new HashMap<>();
    
    @PostConstruct
    public void init() {
        settings.put("version", "1.0");
        settings.put("environment", "production");
    }
}
```

### 6. WebSocket

One instance per WebSocket session.

```java
@Component
@Scope(scopeName = "websocket", proxyMode = ScopedProxyMode.TARGET_CLASS)
public class ChatSession {
    private String sessionId;
    private List<Message> messages = new ArrayList<>();
}
```

### Scope Comparison Table

| Scope | Instances | Created When | Destroyed When | Use Case |
|-------|-----------|--------------|----------------|----------|
| **Singleton** | One | Container starts | Container shuts down | Stateless services |
| **Prototype** | Many | Each request | Manually or GC | Stateful objects |
| **Request** | One per request | HTTP request starts | Request ends | Request-specific data |
| **Session** | One per session | HTTP session starts | Session expires | User session data |
| **Application** | One per ServletContext | Context starts | Context ends | Application-wide config |
| **WebSocket** | One per WS session | WS connection | WS disconnection | WebSocket data |

### Injecting Different Scopes

**Problem: Injecting prototype into singleton**
```java
@Service // Singleton
public class SingletonService {
    @Autowired
    private PrototypeBean prototypeBean; // Only created once!
}
```

**Solution 1: Method Injection**
```java
@Service
public class SingletonService {
    @Autowired
    private ApplicationContext context;
    
    public void doSomething() {
        PrototypeBean bean = context.getBean(PrototypeBean.class); // New instance
    }
}
```

**Solution 2: @Lookup**
```java
@Service
public abstract class SingletonService {
    public void doSomething() {
        PrototypeBean bean = createPrototypeBean(); // New instance
    }
    
    @Lookup
    protected abstract PrototypeBean createPrototypeBean();
}
```

**Solution 3: Provider**
```java
@Service
public class SingletonService {
    @Autowired
    private Provider<PrototypeBean> prototypeBeanProvider;
    
    public void doSomething() {
        PrototypeBean bean = prototypeBeanProvider.get(); // New instance
    }
}
```

**Solution 4: Scoped Proxy**
```java
@Component
@Scope(value = "prototype", proxyMode = ScopedProxyMode.TARGET_CLASS)
public class PrototypeBean { }

@Service
public class SingletonService {
    @Autowired
    private PrototypeBean prototypeBean; // Proxy that creates new instance
}
```

---

## Bean Lifecycle

The Spring Bean lifecycle consists of several phases from creation to destruction.

### Complete Lifecycle Diagram

```
1. Container Started
   ↓
2. Bean Definition Loaded (from @Component, @Bean, XML)
   ↓
3. BeanFactoryPostProcessor (modify bean definitions)
   ↓
4. Bean Instantiation (constructor called)
   ↓
5. Property/Dependency Injection (@Autowired)
   ↓
6. BeanNameAware.setBeanName()
   ↓
7. BeanClassLoaderAware.setBeanClassLoader()
   ↓
8. BeanFactoryAware.setBeanFactory()
   ↓
9. ApplicationContextAware.setApplicationContext()
   ↓
10. BeanPostProcessor.postProcessBeforeInitialization()
   ↓
11. @PostConstruct annotated method
   ↓
12. InitializingBean.afterPropertiesSet()
   ↓
13. Custom init-method
   ↓
14. BeanPostProcessor.postProcessAfterInitialization()
   ↓
15. Bean Ready for Use
   ↓
16. Container Shutdown
   ↓
17. @PreDestroy annotated method
   ↓
18. DisposableBean.destroy()
   ↓
19. Custom destroy-method
   ↓
20. Bean Destroyed
```

### Detailed Example

```java
@Component
public class LifecycleBean implements 
    BeanNameAware, 
    BeanFactoryAware,
    ApplicationContextAware, 
    InitializingBean, 
    DisposableBean {
    
    private String beanName;
    
    // 1. Constructor
    public LifecycleBean() {
        System.out.println("1. Constructor called");
    }
    
    // 2. Dependency injection
    @Autowired
    public void setDependency(SomeDependency dependency) {
        System.out.println("2. Dependencies injected");
    }
    
    // 3. BeanNameAware
    @Override
    public void setBeanName(String name) {
        this.beanName = name;
        System.out.println("3. BeanNameAware.setBeanName(): " + name);
    }
    
    // 4. BeanFactoryAware
    @Override
    public void setBeanFactory(BeanFactory beanFactory) {
        System.out.println("4. BeanFactoryAware.setBeanFactory()");
    }
    
    // 5. ApplicationContextAware
    @Override
    public void setApplicationContext(ApplicationContext context) {
        System.out.println("5. ApplicationContextAware.setApplicationContext()");
    }
    
    // 6. @PostConstruct
    @PostConstruct
    public void postConstruct() {
        System.out.println("6. @PostConstruct method called");
    }
    
    // 7. InitializingBean
    @Override
    public void afterPropertiesSet() {
        System.out.println("7. InitializingBean.afterPropertiesSet()");
    }
    
    // 8. Custom init method
    public void customInit() {
        System.out.println("8. Custom init method called");
    }
    
    // Bean is ready for use here
    
    // 9. @PreDestroy
    @PreDestroy
    public void preDestroy() {
        System.out.println("9. @PreDestroy method called");
    }
    
    // 10. DisposableBean
    @Override
    public void destroy() {
        System.out.println("10. DisposableBean.destroy()");
    }
    
    // 11. Custom destroy method
    public void customDestroy() {
        System.out.println("11. Custom destroy method called");
    }
}

// Configuration
@Configuration
public class AppConfig {
    @Bean(initMethod = "customInit", destroyMethod = "customDestroy")
    public LifecycleBean lifecycleBean() {
        return new LifecycleBean();
    }
}
```

### BeanPostProcessor

Process beans before and after initialization.

```java
@Component
public class CustomBeanPostProcessor implements BeanPostProcessor {
    
    @Override
    public Object postProcessBeforeInitialization(Object bean, String beanName) {
        System.out.println("Before initialization of: " + beanName);
        return bean; // Return modified bean if needed
    }
    
    @Override
    public Object postProcessAfterInitialization(Object bean, String beanName) {
        System.out.println("After initialization of: " + beanName);
        
        // Can return a proxy here
        if (bean instanceof UserService) {
            return Proxy.newProxyInstance(
                bean.getClass().getClassLoader(),
                bean.getClass().getInterfaces(),
                (proxy, method, args) -> {
                    System.out.println("Method called: " + method.getName());
                    return method.invoke(bean, args);
                }
            );
        }
        return bean;
    }
}
```

### BeanFactoryPostProcessor

Modify bean definitions before beans are created.

```java
@Component
public class CustomBeanFactoryPostProcessor implements BeanFactoryPostProcessor {
    
    @Override
    public void postProcessBeanFactory(ConfigurableListableBeanFactory beanFactory) {
        // Modify bean definitions
        BeanDefinition beanDef = beanFactory.getBeanDefinition("userService");
        beanDef.setScope(BeanDefinition.SCOPE_PROTOTYPE);
        
        // Add new bean definition
        BeanDefinition newBean = new RootBeanDefinition(MyService.class);
        ((DefaultListableBeanFactory) beanFactory).registerBeanDefinition("myService", newBean);
    }
}
```

---

## Bean Configuration Methods

### 1. XML Configuration (Legacy)

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
       http://www.springframework.org/schema/beans/spring-beans.xsd">
    
    <!-- Simple bean -->
    <bean id="userService" class="com.example.UserService"/>
    
    <!-- Bean with dependencies -->
    <bean id="orderService" class="com.example.OrderService">
        <property name="userService" ref="userService"/>
        <property name="timeout" value="30"/>
    </bean>
    
    <!-- Constructor injection -->
    <bean id="productService" class="com.example.ProductService">
        <constructor-arg ref="productRepository"/>
        <constructor-arg value="Production"/>
    </bean>
    
    <!-- Lifecycle methods -->
    <bean id="dataSource" 
          class="com.example.DataSource"
          init-method="connect"
          destroy-method="disconnect"/>
    
    <!-- Scope -->
    <bean id="shoppingCart" 
          class="com.example.ShoppingCart"
          scope="prototype"/>
</beans>
```

### 2. Java Configuration (Modern)

```java
@Configuration
public class AppConfig {
    
    // Simple bean
    @Bean
    public UserService userService() {
        return new UserService();
    }
    
    // Bean with dependencies
    @Bean
    public OrderService orderService(UserService userService) {
        return new OrderService(userService);
    }
    
    // Bean with properties
    @Bean
    public DataSource dataSource(@Value("${db.url}") String url) {
        DataSource ds = new DataSource();
        ds.setUrl(url);
        return ds;
    }
    
    // Lifecycle methods
    @Bean(initMethod = "connect", destroyMethod = "disconnect")
    public DatabaseConnection dbConnection() {
        return new DatabaseConnection();
    }
    
    // Scope
    @Bean
    @Scope("prototype")
    public ShoppingCart shoppingCart() {
        return new ShoppingCart();
    }
    
    // Conditional bean
    @Bean
    @Profile("prod")
    public EmailService emailService() {
        return new SmtpEmailService();
    }
}
```

### 3. Annotation-Based Configuration (Most Common)

```java
// Component scanning
@Configuration
@ComponentScan(basePackages = "com.example")
public class AppConfig { }

// Stereotype annotations
@Component  // Generic component
public class GenericComponent { }

@Service    // Business logic
public class UserService { }

@Repository // Data access
public class UserRepository { }

@Controller // Web controller
public class UserController { }

@RestController // REST controller
public class UserRestController { }

@Configuration // Configuration class
public class AppConfig { }
```

---

## Component Scanning

### Basic Component Scanning

```java
@Configuration
@ComponentScan(basePackages = "com.example")
public class AppConfig { }

// Spring Boot does this automatically
@SpringBootApplication // Includes @ComponentScan
public class Application { }
```

### Advanced Component Scanning

```java
@Configuration
@ComponentScan(
    basePackages = {"com.example.service", "com.example.repository"},
    basePackageClasses = {UserService.class, OrderService.class},
    includeFilters = @Filter(type = FilterType.ANNOTATION, classes = CustomComponent.class),
    excludeFilters = @Filter(type = FilterType.REGEX, pattern = ".*Test.*")
)
public class AppConfig { }
```

### Filter Types

```java
// Annotation filter
@ComponentScan(
    includeFilters = @Filter(
        type = FilterType.ANNOTATION,
        classes = {Service.class, Repository.class}
    )
)

// Assignable type filter
@ComponentScan(
    includeFilters = @Filter(
        type = FilterType.ASSIGNABLE_TYPE,
        classes = {UserService.class, OrderService.class}
    )
)

// Regex filter
@ComponentScan(
    excludeFilters = @Filter(
        type = FilterType.REGEX,
        pattern = "com\\.example\\..*Test"
    )
)

// Custom filter
public class CustomTypeFilter implements TypeFilter {
    @Override
    public boolean match(MetadataReader reader, MetadataReaderFactory factory) {
        return reader.getClassMetadata().getClassName().contains("Custom");
    }
}

@ComponentScan(
    includeFilters = @Filter(
        type = FilterType.CUSTOM,
        classes = CustomTypeFilter.class
    )
)
```

### Component Index

Improve startup performance:

```xml
<!-- Add dependency -->
<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-context-indexer</artifactId>
    <optional>true</optional>
</dependency>
```

This generates `META-INF/spring.components` at compile time.

---

## Lifecycle Callbacks

### 1. @PostConstruct and @PreDestroy (Recommended)

```java
@Service
public class UserService {
    
    @PostConstruct
    public void init() {
        System.out.println("Service initialized");
        // Load configuration
        // Initialize resources
    }
    
    @PreDestroy
    public void cleanup() {
        System.out.println("Service destroying");
        // Release resources
        // Close connections
    }
}
```

### 2. InitializingBean and DisposableBean

```java
@Service
public class UserService implements InitializingBean, DisposableBean {
    
    @Override
    public void afterPropertiesSet() {
        System.out.println("InitializingBean: afterPropertiesSet");
    }
    
    @Override
    public void destroy() {
        System.out.println("DisposableBean: destroy");
    }
}
```

### 3. Custom Init and Destroy Methods

```java
@Configuration
public class AppConfig {
    
    @Bean(initMethod = "customInit", destroyMethod = "customDestroy")
    public UserService userService() {
        return new UserService();
    }
}

public class UserService {
    public void customInit() {
        System.out.println("Custom init method");
    }
    
    public void customDestroy() {
        System.out.println("Custom destroy method");
    }
}
```

### Real-World Examples

#### Database Connection Pool

```java
@Component
public class DatabaseConnectionPool implements DisposableBean {
    
    private HikariDataSource dataSource;
    
    @PostConstruct
    public void initialize() {
        HikariConfig config = new HikariConfig();
        config.setJdbcUrl("jdbc:mysql://localhost:3306/mydb");
        config.setUsername("user");
        config.setPassword("password");
        config.setMaximumPoolSize(10);
        
        dataSource = new HikariDataSource(config);
        System.out.println("Connection pool initialized");
    }
    
    @Override
    public void destroy() {
        if (dataSource != null) {
            dataSource.close();
            System.out.println("Connection pool closed");
        }
    }
    
    public Connection getConnection() throws SQLException {
        return dataSource.getConnection();
    }
}
```

#### Cache Initialization

```java
@Service
public class CacheService {
    
    private Map<String, Object> cache;
    
    @PostConstruct
    public void loadCache() {
        cache = new ConcurrentHashMap<>();
        // Load frequently accessed data
        System.out.println("Cache loaded");
    }
    
    @PreDestroy
    public void flushCache() {
        if (cache != null) {
            cache.clear();
            System.out.println("Cache flushed");
        }
    }
}
```

#### Scheduled Task Cleanup

```java
@Service
public class ScheduledTaskService {
    
    private ScheduledExecutorService executor;
    
    @PostConstruct
    public void startScheduler() {
        executor = Executors.newScheduledThreadPool(5);
        executor.scheduleAtFixedRate(
            this::performTask,
            0, 1, TimeUnit.HOURS
        );
        System.out.println("Scheduler started");
    }
    
    @PreDestroy
    public void stopScheduler() {
        if (executor != null) {
            executor.shutdown();
            try {
                if (!executor.awaitTermination(60, TimeUnit.SECONDS)) {
                    executor.shutdownNow();
                }
            } catch (InterruptedException e) {
                executor.shutdownNow();
            }
            System.out.println("Scheduler stopped");
        }
    }
    
    private void performTask() {
        System.out.println("Executing scheduled task");
    }
}
```

---

## Summary

**Key Takeaways:**

1. **Beans** are objects managed by Spring IoC container
2. **Singleton** is the default scope (one instance per container)
3. **Prototype** creates new instance on each request
4. **Lifecycle** has multiple phases with hooks for customization
5. **@PostConstruct** and **@PreDestroy** are recommended for callbacks
6. **Component scanning** automatically discovers beans
7. **Java configuration** with @Bean is more flexible than XML

**Best Practices:**
- ✅ Use singleton for stateless beans
- ✅ Use prototype for stateful beans
- ✅ Use @PostConstruct for initialization logic
- ✅ Use @PreDestroy for cleanup logic
- ✅ Prefer Java configuration over XML
- ✅ Use component scanning for automatic bean discovery
- ✅ Make beans immutable when possible

