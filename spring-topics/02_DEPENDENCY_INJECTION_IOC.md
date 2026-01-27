# Dependency Injection & Inversion of Control

## Table of Contents
- [What is Dependency Injection?](#what-is-dependency-injection)
- [What is Inversion of Control?](#what-is-inversion-of-control)
- [Types of Dependency Injection](#types-of-dependency-injection)
- [DI Annotations](#di-annotations)
- [Handling Circular Dependencies](#handling-circular-dependencies)

---

## What is Dependency Injection?

**Dependency Injection (DI)** is a design pattern where objects receive their dependencies from external sources rather than creating them internally. It's a specific form of Inversion of Control (IoC).

### The Problem DI Solves

**Without DI (Tight Coupling):**
```java
public class UserService {
    private UserRepository repository;
    
    public UserService() {
        // Hard-coded dependency - tight coupling
        this.repository = new UserRepositoryImpl();
    }
    
    public User findUser(Long id) {
        return repository.findById(id);
    }
}
```

**Problems:**
1. ❌ Cannot change implementation without modifying code
2. ❌ Difficult to unit test (can't mock repository)
3. ❌ Violates Single Responsibility Principle
4. ❌ Tight coupling to concrete implementation

**With DI (Loose Coupling):**
```java
@Service
public class UserService {
    private final UserRepository repository;
    
    // Dependency injected via constructor
    @Autowired
    public UserService(UserRepository repository) {
        this.repository = repository;
    }
    
    public User findUser(Long id) {
        return repository.findById(id);
    }
}
```

**Benefits:**
1. ✅ Easy to change implementations
2. ✅ Easy to test with mocks
3. ✅ Loose coupling
4. ✅ Follows SOLID principles

### Core Benefits of Dependency Injection

#### 1. Loose Coupling

```java
// Repository Interface
public interface UserRepository {
    User findById(Long id);
    void save(User user);
}

// Multiple implementations
@Repository
public class JpaUserRepository implements UserRepository {
    @PersistenceContext
    private EntityManager em;
    
    @Override
    public User findById(Long id) {
        return em.find(User.class, id);
    }
}

@Repository
@Profile("test")
public class InMemoryUserRepository implements UserRepository {
    private Map<Long, User> users = new HashMap<>();
    
    @Override
    public User findById(Long id) {
        return users.get(id);
    }
}

// Service works with any implementation
@Service
public class UserService {
    private final UserRepository repository;
    
    public UserService(UserRepository repository) {
        this.repository = repository; // Can be any implementation
    }
}
```

#### 2. Testability

```java
public class UserServiceTest {
    
    @Test
    public void testFindUser() {
        // Create mock dependency
        UserRepository mockRepository = mock(UserRepository.class);
        User expectedUser = new User(1L, "John");
        when(mockRepository.findById(1L)).thenReturn(expectedUser);
        
        // Inject mock
        UserService service = new UserService(mockRepository);
        
        // Test
        User actualUser = service.findUser(1L);
        
        assertEquals(expectedUser, actualUser);
        verify(mockRepository).findById(1L);
    }
}
```

#### 3. Reusability

```java
@Service
public class EmailService {
    private final EmailProvider provider;
    
    public EmailService(EmailProvider provider) {
        this.provider = provider;
    }
}

// Can be reused with different providers
EmailService gmailService = new EmailService(new GmailProvider());
EmailService sendGridService = new EmailService(new SendGridProvider());
```

#### 4. Maintainability

```java
// Easy to add new dependencies without changing existing code
@Service
public class OrderService {
    private final OrderRepository orderRepository;
    private final EmailService emailService;
    private final PaymentService paymentService;
    
    // All dependencies injected
    public OrderService(
        OrderRepository orderRepository,
        EmailService emailService,
        PaymentService paymentService
    ) {
        this.orderRepository = orderRepository;
        this.emailService = emailService;
        this.paymentService = paymentService;
    }
}
```

---

## What is Inversion of Control?

**Inversion of Control (IoC)** is a design principle where the control of object creation and lifecycle is inverted from the application code to a framework or container.

### Traditional Flow vs IoC

**Traditional Flow (You control everything):**
```java
public class Application {
    public static void main(String[] args) {
        // You create and manage all objects
        UserRepository repository = new UserRepositoryImpl();
        EmailService emailService = new EmailService();
        UserService userService = new UserService(repository, emailService);
        
        // You control the flow
        User user = userService.createUser("John");
    }
}
```

**IoC Flow (Framework controls objects):**
```java
@SpringBootApplication
public class Application {
    public static void main(String[] args) {
        // Spring creates and manages all objects
        ApplicationContext context = SpringApplication.run(Application.class, args);
        
        // You just request what you need
        UserService userService = context.getBean(UserService.class);
        User user = userService.createUser("John");
    }
}
```

### Spring IoC Container

The Spring IoC container is responsible for:
1. **Creating objects** (beans)
2. **Wiring dependencies** together
3. **Managing lifecycle** (initialization, destruction)
4. **Configuring objects**

```
┌─────────────────────────────────┐
│     Spring IoC Container        │
│                                 │
│  ┌──────────┐  ┌──────────┐   │
│  │  Bean 1  │  │  Bean 2  │   │
│  └──────────┘  └──────────┘   │
│         ↓           ↓          │
│  ┌─────────────────────────┐  │
│  │   Dependency Injection  │  │
│  └─────────────────────────┘  │
└─────────────────────────────────┘
```

### How Spring Implements IoC

#### 1. Configuration Metadata

Tell Spring what beans to create:

**XML Configuration:**
```xml
<beans>
    <bean id="userRepository" class="com.example.UserRepositoryImpl"/>
    <bean id="userService" class="com.example.UserService">
        <constructor-arg ref="userRepository"/>
    </bean>
</beans>
```

**Java Configuration:**
```java
@Configuration
public class AppConfig {
    @Bean
    public UserRepository userRepository() {
        return new UserRepositoryImpl();
    }
    
    @Bean
    public UserService userService(UserRepository repository) {
        return new UserService(repository);
    }
}
```

**Annotation Configuration:**
```java
@Repository
public class UserRepositoryImpl implements UserRepository { }

@Service
public class UserService {
    @Autowired
    private UserRepository repository;
}
```

#### 2. Bean Instantiation

Spring creates instances based on configuration:

```java
// Spring does this internally
UserRepository repository = new UserRepositoryImpl();
UserService service = new UserService(repository);
```

#### 3. Dependency Resolution

Spring wires dependencies automatically:

```java
@Service
public class OrderService {
    private final UserService userService;
    private final ProductService productService;
    private final PaymentService paymentService;
    
    // Spring automatically injects all dependencies
    @Autowired
    public OrderService(
        UserService userService,
        ProductService productService,
        PaymentService paymentService
    ) {
        this.userService = userService;
        this.productService = productService;
        this.paymentService = paymentService;
    }
}
```

### IoC Benefits

#### 1. Separation of Concerns

```java
// Business logic doesn't worry about object creation
@Service
public class OrderService {
    private final OrderRepository repository;
    
    @Autowired
    public OrderService(OrderRepository repository) {
        this.repository = repository;
    }
    
    // Focus only on business logic
    public Order createOrder(OrderRequest request) {
        Order order = new Order(request);
        return repository.save(order);
    }
}
```

#### 2. Configuration Flexibility

```java
// Development configuration
@Configuration
@Profile("dev")
public class DevConfig {
    @Bean
    public EmailService emailService() {
        return new MockEmailService(); // Mock in dev
    }
}

// Production configuration
@Configuration
@Profile("prod")
public class ProdConfig {
    @Bean
    public EmailService emailService() {
        return new SmtpEmailService(); // Real in prod
    }
}
```

#### 3. Lifecycle Management

```java
@Component
public class DatabaseConnection {
    
    @PostConstruct
    public void init() {
        // Spring calls this after construction
        System.out.println("Opening database connection");
    }
    
    @PreDestroy
    public void cleanup() {
        // Spring calls this before destruction
        System.out.println("Closing database connection");
    }
}
```

---

## Types of Dependency Injection

Spring supports three types of dependency injection:

### 1. Constructor Injection (Recommended ✅)

Dependencies injected through constructor parameters.

```java
@Service
public class UserService {
    private final UserRepository userRepository;
    private final EmailService emailService;
    
    // Constructor injection
    @Autowired // Optional if only one constructor
    public UserService(UserRepository userRepository, EmailService emailService) {
        this.userRepository = userRepository;
        this.emailService = emailService;
    }
    
    public User createUser(User user) {
        User savedUser = userRepository.save(user);
        emailService.sendWelcomeEmail(savedUser);
        return savedUser;
    }
}
```

**Advantages:**
- ✅ **Immutability**: Dependencies can be `final`
- ✅ **Required dependencies**: Ensures all dependencies are provided
- ✅ **Testability**: Easy to instantiate in tests
- ✅ **Thread-safety**: Immutable dependencies are thread-safe
- ✅ **Fail-fast**: Application won't start if dependencies missing

**Example:**
```java
// Easy to test
@Test
public void testCreateUser() {
    UserRepository mockRepo = mock(UserRepository.class);
    EmailService mockEmail = mock(EmailService.class);
    
    UserService service = new UserService(mockRepo, mockEmail);
    // Test service...
}
```

### 2. Setter Injection

Dependencies injected through setter methods.

```java
@Service
public class UserService {
    private UserRepository userRepository;
    private EmailService emailService;
    
    // Setter injection
    @Autowired
    public void setUserRepository(UserRepository userRepository) {
        this.userRepository = userRepository;
    }
    
    @Autowired
    public void setEmailService(EmailService emailService) {
        this.emailService = emailService;
    }
    
    public User createUser(User user) {
        User savedUser = userRepository.save(user);
        emailService.sendWelcomeEmail(savedUser);
        return savedUser;
    }
}
```

**Advantages:**
- ✅ **Optional dependencies**: Can have default values
- ✅ **Reconfiguration**: Dependencies can be changed after construction
- ✅ **Legacy code**: Easier to add to existing classes

**Use Cases:**
```java
@Component
public class ReportGenerator {
    private Formatter formatter;
    
    // Optional dependency with default
    @Autowired(required = false)
    public void setFormatter(Formatter formatter) {
        this.formatter = formatter != null ? formatter : new DefaultFormatter();
    }
}
```

**Disadvantages:**
- ❌ Not immutable
- ❌ Dependencies might not be set
- ❌ Harder to test (must remember to call setters)

### 3. Field Injection

Dependencies injected directly into fields.

```java
@Service
public class UserService {
    
    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private EmailService emailService;
    
    public User createUser(User user) {
        User savedUser = userRepository.save(user);
        emailService.sendWelcomeEmail(savedUser);
        return savedUser;
    }
}
```

**Advantages:**
- ✅ **Concise**: Less boilerplate code
- ✅ **Quick**: Faster to write

**Disadvantages:**
- ❌ **Cannot be final**: Not immutable
- ❌ **Hard to test**: Requires reflection or Spring test context
- ❌ **Hides dependencies**: Not obvious what dependencies exist
- ❌ **Violates encapsulation**: Direct field access

**Testing Difficulty:**
```java
@Test
public void testCreateUser() {
    UserService service = new UserService();
    
    // Cannot inject dependencies without reflection
    // Must use Spring test context
    // OR use reflection:
    ReflectionTestUtils.setField(service, "userRepository", mockRepo);
}
```

### Comparison Table

| Feature | Constructor | Setter | Field |
|---------|------------|--------|-------|
| **Immutability** | ✅ Yes | ❌ No | ❌ No |
| **Required Dependencies** | ✅ Yes | ❌ No | ❌ No |
| **Testability** | ✅ Easy | ⚠️ Medium | ❌ Hard |
| **Circular Dependencies** | ❌ Fails | ✅ Works | ✅ Works |
| **Null Safety** | ✅ Guaranteed | ❌ Can be null | ❌ Can be null |
| **Code Verbosity** | ⚠️ More code | ⚠️ More code | ✅ Concise |
| **Best Practice** | ✅ Recommended | ⚠️ Optional deps | ❌ Avoid |

### Spring's Recommendation

**Use constructor injection for:**
- Required dependencies
- Dependencies that shouldn't change
- New code

**Use setter injection for:**
- Optional dependencies
- Dependencies with reasonable defaults
- Reconfigurable dependencies

**Avoid field injection except for:**
- Very simple cases
- Prototypes or quick experiments

### Complete Example

```java
@Service
public class OrderService {
    // Required dependencies - constructor injection
    private final OrderRepository orderRepository;
    private final PaymentService paymentService;
    
    // Optional dependency - setter injection
    private NotificationService notificationService;
    
    // Constructor for required dependencies
    @Autowired
    public OrderService(
        OrderRepository orderRepository,
        PaymentService paymentService
    ) {
        this.orderRepository = orderRepository;
        this.paymentService = paymentService;
    }
    
    // Setter for optional dependency
    @Autowired(required = false)
    public void setNotificationService(NotificationService notificationService) {
        this.notificationService = notificationService;
    }
    
    public Order processOrder(OrderRequest request) {
        Order order = new Order(request);
        paymentService.processPayment(order);
        Order savedOrder = orderRepository.save(order);
        
        // Optional notification
        if (notificationService != null) {
            notificationService.notify(savedOrder);
        }
        
        return savedOrder;
    }
}
```

---

## DI Annotations

### @Autowired

Spring's primary annotation for dependency injection.

```java
@Service
public class UserService {
    
    // Constructor injection (preferred)
    @Autowired // Optional in Spring 4.3+ if single constructor
    public UserService(UserRepository repository) {
        this.repository = repository;
    }
    
    // Field injection
    @Autowired
    private UserRepository repository;
    
    // Setter injection
    @Autowired
    public void setRepository(UserRepository repository) {
        this.repository = repository;
    }
    
    // Method injection (any method)
    @Autowired
    public void init(UserRepository repository, EmailService emailService) {
        this.repository = repository;
        this.emailService = emailService;
    }
}
```

**Optional Dependencies:**
```java
@Service
public class NotificationService {
    
    @Autowired(required = false)
    private SmsProvider smsProvider;
    
    public void notify(String message) {
        if (smsProvider != null) {
            smsProvider.send(message);
        } else {
            System.out.println("SMS provider not available");
        }
    }
}
```

**Collections:**
```java
@Service
public class PaymentProcessor {
    
    @Autowired
    private List<PaymentGateway> gateways; // Injects all beans of this type
    
    public void processPayment(Payment payment) {
        for (PaymentGateway gateway : gateways) {
            if (gateway.supports(payment)) {
                gateway.process(payment);
                break;
            }
        }
    }
}
```

### @Qualifier

Resolves ambiguity when multiple beans of same type exist.

```java
// Multiple implementations
@Repository
@Qualifier("mysql")
public class MySqlUserRepository implements UserRepository { }

@Repository
@Qualifier("mongo")
public class MongoUserRepository implements UserRepository { }

// Specify which to inject
@Service
public class UserService {
    private final UserRepository repository;
    
    @Autowired
    public UserService(@Qualifier("mysql") UserRepository repository) {
        this.repository = repository;
    }
}
```

**With Field Injection:**
```java
@Service
public class DataService {
    
    @Autowired
    @Qualifier("primary")
    private DataSource primaryDataSource;
    
    @Autowired
    @Qualifier("secondary")
    private DataSource secondaryDataSource;
}
```

### @Primary

Marks a bean as the default choice when multiple candidates exist.

```java
@Repository
@Primary // This will be injected by default
public class MySqlUserRepository implements UserRepository { }

@Repository
public class MongoUserRepository implements UserRepository { }

@Service
public class UserService {
    
    @Autowired
    private UserRepository repository; // MySqlUserRepository injected
}
```

**Override with @Qualifier:**
```java
@Service
public class AnalyticsService {
    
    @Autowired
    @Qualifier("mongo")
    private UserRepository repository; // MongoUserRepository injected
}
```

### @Inject (JSR-330)

Standard Java annotation for dependency injection.

```java
import javax.inject.Inject;
import javax.inject.Named;

@Named // Equivalent to @Component
public class UserService {
    
    @Inject // Equivalent to @Autowired
    private UserRepository repository;
    
    @Inject
    public UserService(UserRepository repository) {
        this.repository = repository;
    }
}
```

**@Autowired vs @Inject:**

| Feature | @Autowired | @Inject |
|---------|-----------|---------|
| **Source** | Spring-specific | JSR-330 standard |
| **required attribute** | ✅ Yes | ❌ No |
| **@Qualifier** | Spring @Qualifier | JSR @Named |
| **Provider** | Spring only | Any JSR-330 container |

### @Resource (JSR-250)

Injection by name rather than type.

```java
import javax.annotation.Resource;

@Service
public class UserService {
    
    @Resource(name = "mysqlUserRepository")
    private UserRepository repository;
}
```

**Difference from @Autowired:**
- `@Autowired`: By type first, then by name
- `@Resource`: By name first, then by type

### @Value

Inject values from properties files.

```java
@Component
public class AppConfig {
    
    @Value("${app.name}")
    private String appName;
    
    @Value("${app.version:1.0}") // Default value
    private String version;
    
    @Value("${app.features}")
    private List<String> features;
    
    @Value("#{systemProperties['user.home']}")
    private String userHome;
    
    @Value("#{${app.timeout} * 1000}")
    private long timeoutInMillis;
}
```

**SpEL Expressions:**
```java
@Component
public class PricingService {
    
    @Value("#{${base.price} * ${tax.rate}}")
    private double finalPrice;
    
    @Value("#{T(java.lang.Math).random() * 100}")
    private double randomValue;
    
    @Value("#{orderService.getDiscount()}")
    private double discount;
}
```

### Complete Example

```java
// Configuration
@Configuration
public class AppConfig {
    
    @Bean
    @Primary
    public PaymentGateway stripeGateway() {
        return new StripeGateway();
    }
    
    @Bean
    @Qualifier("paypal")
    public PaymentGateway paypalGateway() {
        return new PaypalGateway();
    }
}

// Service using all annotations
@Service
public class CheckoutService {
    
    // Constructor injection with @Primary
    private final PaymentGateway primaryGateway;
    
    // Constructor injection with @Qualifier
    private final PaymentGateway secondaryGateway;
    
    // Field injection with @Value
    @Value("${checkout.timeout}")
    private int timeout;
    
    // Optional dependency
    private DiscountService discountService;
    
    @Autowired
    public CheckoutService(
        PaymentGateway primaryGateway,
        @Qualifier("paypal") PaymentGateway secondaryGateway
    ) {
        this.primaryGateway = primaryGateway;
        this.secondaryGateway = secondaryGateway;
    }
    
    @Autowired(required = false)
    public void setDiscountService(DiscountService discountService) {
        this.discountService = discountService;
    }
    
    public Order checkout(Cart cart) {
        if (discountService != null) {
            discountService.applyDiscounts(cart);
        }
        
        try {
            return primaryGateway.process(cart);
        } catch (PaymentException e) {
            return secondaryGateway.process(cart);
        }
    }
}
```

---

## Handling Circular Dependencies

### What is a Circular Dependency?

When two or more beans depend on each other, creating a cycle.

```java
@Service
public class ServiceA {
    @Autowired
    private ServiceB serviceB; // ServiceA depends on ServiceB
}

@Service
public class ServiceB {
    @Autowired
    private ServiceA serviceA; // ServiceB depends on ServiceA
}

// Results in: BeanCurrentlyInCreationException
```

### Why It's a Problem

```
1. Spring tries to create ServiceA
2. ServiceA needs ServiceB
3. Spring tries to create ServiceB
4. ServiceB needs ServiceA
5. ServiceA is still being created (not ready)
6. CIRCULAR DEPENDENCY!
```

### Solutions

#### 1. Redesign (Best Solution ✅)

Eliminate the circular dependency by refactoring:

```java
// Extract common functionality
@Service
public class SharedService {
    public void doSomething() {
        // Shared logic
    }
}

@Service
public class ServiceA {
    @Autowired
    private SharedService sharedService;
}

@Service
public class ServiceB {
    @Autowired
    private SharedService sharedService;
}
```

#### 2. @Lazy Annotation

Delay initialization until first use:

```java
@Service
public class ServiceA {
    private final ServiceB serviceB;
    
    @Autowired
    public ServiceA(@Lazy ServiceB serviceB) {
        this.serviceB = serviceB;
    }
}

@Service
public class ServiceB {
    private final ServiceA serviceA;
    
    @Autowired
    public ServiceB(ServiceA serviceA) {
        this.serviceA = serviceA;
    }
}
```

**How it works:**
```
1. Spring creates proxy for ServiceB
2. ServiceA is created with ServiceB proxy
3. ServiceB is created with ServiceA (already exists)
4. Proxy is resolved when first method is called
```

#### 3. Setter Injection

Use setter instead of constructor injection:

```java
@Service
public class ServiceA {
    private ServiceB serviceB;
    
    @Autowired
    public void setServiceB(ServiceB serviceB) {
        this.serviceB = serviceB;
    }
}

@Service
public class ServiceB {
    private ServiceA serviceA;
    
    @Autowired
    public void setServiceA(ServiceA serviceA) {
        this.serviceA = serviceA;
    }
}
```

**Why it works:**
```
1. Spring creates ServiceA (empty)
2. Spring creates ServiceB (empty)
3. Spring sets ServiceB in ServiceA
4. Spring sets ServiceA in ServiceB
```

#### 4. @PostConstruct

Initialize dependencies after construction:

```java
@Service
public class ServiceA {
    @Autowired
    private ServiceB serviceB;
    
    @PostConstruct
    public void init() {
        serviceB.setServiceA(this);
    }
}

@Service
public class ServiceB {
    private ServiceA serviceA;
    
    public void setServiceA(ServiceA serviceA) {
        this.serviceA = serviceA;
    }
}
```

#### 5. ApplicationContextAware

Manually retrieve bean from context:

```java
@Service
public class ServiceA implements ApplicationContextAware {
    private ApplicationContext context;
    
    @Override
    public void setApplicationContext(ApplicationContext context) {
        this.context = context;
    }
    
    public void doSomething() {
        ServiceB serviceB = context.getBean(ServiceB.class);
        serviceB.execute();
    }
}

@Service
public class ServiceB {
    @Autowired
    private ServiceA serviceA;
}
```

### Best Practices to Avoid Circular Dependencies

1. **Use interfaces** and dependency inversion
2. **Extract shared logic** into a new service
3. **Event-driven architecture** instead of direct calls
4. **One-way dependencies** (service → repository, not both ways)
5. **Proper layering** (controller → service → repository)

### Example: Proper Design

**Before (Circular Dependency):**
```java
@Service
public class OrderService {
    @Autowired
    private CustomerService customerService;
    
    public void createOrder(Order order) {
        customerService.updateCustomer(order.getCustomer());
    }
}

@Service
public class CustomerService {
    @Autowired
    private OrderService orderService;
    
    public void updateCustomer(Customer customer) {
        List<Order> orders = orderService.getOrdersByCustomer(customer);
        // Update logic
    }
}
```

**After (Event-Driven):**
```java
@Service
public class OrderService {
    @Autowired
    private ApplicationEventPublisher eventPublisher;
    
    public void createOrder(Order order) {
        eventPublisher.publishEvent(new OrderCreatedEvent(order));
    }
}

@Service
public class CustomerService {
    @EventListener
    public void handleOrderCreated(OrderCreatedEvent event) {
        updateCustomer(event.getOrder().getCustomer());
    }
}
```

### Detection and Debugging

```java
// Spring will throw this exception
BeanCurrentlyInCreationException: 
  Error creating bean with name 'serviceA': 
  Requested bean is currently in creation: 
  Is there an unresolvable circular reference?
```

**Enable debug logging:**
```properties
logging.level.org.springframework.beans.factory=DEBUG
```

---

## Summary

**Key Takeaways:**

1. **Dependency Injection** promotes loose coupling and testability
2. **IoC Container** manages object lifecycle and dependencies
3. **Constructor Injection** is the recommended approach
4. Use **@Qualifier** to resolve ambiguity, **@Primary** for defaults
5. **Avoid circular dependencies** through proper design
6. **@Lazy** can break circular dependencies but redesign is better

**Best Practices:**
- ✅ Use constructor injection for required dependencies
- ✅ Use setter injection for optional dependencies
- ✅ Avoid field injection in production code
- ✅ Keep dependencies immutable with `final`
- ✅ Design to avoid circular dependencies
- ✅ Use interfaces for flexibility
- ✅ Test with mocks, not the Spring container

