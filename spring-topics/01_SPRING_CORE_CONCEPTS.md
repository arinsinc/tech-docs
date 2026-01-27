# Spring Core Concepts

## Table of Contents
- [What is Spring Framework?](#what-is-spring-framework)
- [Main Modules of Spring](#main-modules-of-spring)
- [Spring vs Spring Boot](#spring-vs-spring-boot)
- [Advantages of Spring Framework](#advantages-of-spring-framework)
- [Spring Application Context](#spring-application-context)

---

## What is Spring Framework?

Spring Framework is a comprehensive, lightweight, open-source Java application framework that provides infrastructure support for developing Java applications. It was created by Rod Johnson in 2003 to address the complexity of enterprise Java development.

### Core Features

1. **Lightweight and Modular**
   - Small core container (around 2MB)
   - Use only what you need
   - No heavyweight dependencies

2. **Inversion of Control (IoC)**
   - Container manages object lifecycle
   - Dependency injection
   - Loose coupling

3. **Aspect-Oriented Programming (AOP)**
   - Cross-cutting concerns (logging, security, transactions)
   - Separation of business logic and system services

4. **Transaction Management**
   - Consistent programming model
   - Supports both programmatic and declarative transactions
   - Works with JTA, JDBC, Hibernate, JPA

5. **MVC Framework**
   - Web application development
   - Clean separation of concerns
   - Flexible and extensible

### Why Was Spring Created?

Spring was created to solve several problems in enterprise Java development:

1. **Complexity of J2EE**: Early J2EE was overly complex with heavyweight containers
2. **Testability**: EJBs were difficult to test outside containers
3. **Tight Coupling**: Applications were tightly coupled to specific APIs
4. **Boilerplate Code**: Too much repetitive configuration and code
5. **Limited Flexibility**: Hard to swap implementations

### Problems Spring Solves

```java
// Before Spring (Tight Coupling)
public class OrderService {
    private OrderRepository repository = new OrderRepositoryImpl();
    
    public void createOrder(Order order) {
        repository.save(order);
    }
}

// With Spring (Loose Coupling)
@Service
public class OrderService {
    private final OrderRepository repository;
    
    @Autowired
    public OrderService(OrderRepository repository) {
        this.repository = repository;
    }
    
    public void createOrder(Order order) {
        repository.save(order);
    }
}
```

### Key Benefits

- **POJO-Based Development**: Plain Old Java Objects, no special interfaces
- **Testability**: Easy to unit test with mock objects
- **Flexible Configuration**: XML, Java, or annotations
- **Integration**: Easy integration with other frameworks
- **Community Support**: Large, active community

---

## Main Modules of Spring

Spring Framework is organized into approximately 20 modules, grouped into several categories:

### 1. Core Container

The foundation of the Spring Framework.

#### **Spring Core**
- Fundamental parts of the framework
- IoC and Dependency Injection features
- BeanFactory (basic container)

#### **Spring Beans**
- BeanFactory implementation
- Bean configuration and lifecycle management

#### **Spring Context**
- ApplicationContext interface
- Enterprise services (JNDI, EJB, scheduling)
- Internationalization (i18n)
- Event propagation

#### **Spring Expression Language (SpEL)**
- Powerful expression language
- Query and manipulate object graphs at runtime

```java
@Value("#{systemProperties['user.home']}")
private String userHome;

@Value("#{orderBean.total > 1000 ? 'Premium' : 'Standard'}")
private String customerType;
```

### 2. Data Access/Integration

Provides support for database operations.

#### **Spring JDBC**
- JDBC abstraction layer
- Eliminates verbose JDBC code
- JdbcTemplate class

```java
@Repository
public class UserDao {
    @Autowired
    private JdbcTemplate jdbcTemplate;
    
    public User findById(Long id) {
        return jdbcTemplate.queryForObject(
            "SELECT * FROM users WHERE id = ?",
            new UserRowMapper(),
            id
        );
    }
}
```

#### **Spring ORM**
- Integration with ORM frameworks
- Hibernate, JPA, JDO
- Exception translation

#### **Spring OXM**
- Object/XML Mapping
- JAXB, Castor, XStream

#### **Spring JMS**
- Java Message Service abstraction
- Simplifies JMS API usage

#### **Spring Transactions**
- Consistent transaction management
- Declarative and programmatic support
- Works with JDBC, JPA, Hibernate

### 3. Web Layer

For building web applications.

#### **Spring Web**
- Basic web-oriented integration features
- Multipart file upload
- IoC container initialization using servlet listeners

#### **Spring WebMVC**
- Model-View-Controller implementation
- Web application framework
- REST API support

```java
@RestController
@RequestMapping("/api/users")
public class UserController {
    @GetMapping("/{id}")
    public ResponseEntity<User> getUser(@PathVariable Long id) {
        // Implementation
    }
}
```

#### **Spring WebSocket**
- WebSocket support
- STOMP protocol
- SockJS fallback

#### **Spring WebFlux**
- Reactive web framework
- Non-blocking, asynchronous
- Functional programming model

### 4. AOP and Instrumentation

#### **Spring AOP**
- Aspect-Oriented Programming
- Method interception
- Declarative services

#### **Spring Aspects**
- Integration with AspectJ
- Powerful AOP features

#### **Spring Instrument**
- Class instrumentation support
- Classloader implementations

### 5. Messaging

#### **Spring Messaging**
- Message-based applications
- STOMP protocol support
- WebSocket message handling

### 6. Test

#### **Spring Test**
- Unit and integration testing
- Mock objects
- TestContext framework
- Spring MVC Test framework

```java
@SpringBootTest
@AutoConfigureMockMvc
public class UserControllerTest {
    @Autowired
    private MockMvc mockMvc;
    
    @Test
    public void testGetUser() throws Exception {
        mockMvc.perform(get("/api/users/1"))
               .andExpect(status().isOk())
               .andExpect(jsonPath("$.name").value("John"));
    }
}
```

### Module Dependencies

```
Core Container (Core, Beans, Context, SpEL)
    ↓
AOP, Aspects, Instrumentation
    ↓
Data Access (JDBC, ORM, Transactions)
    ↓
Web (Web, WebMVC, WebSocket, WebFlux)
    ↓
Test
```

---

## Spring vs Spring Boot

### Spring Framework

**Traditional Spring** requires explicit configuration:

```xml
<!-- applicationContext.xml -->
<beans>
    <bean id="dataSource" class="org.apache.commons.dbcp2.BasicDataSource">
        <property name="driverClassName" value="com.mysql.jdbc.Driver"/>
        <property name="url" value="jdbc:mysql://localhost:3306/mydb"/>
        <property name="username" value="root"/>
        <property name="password" value="password"/>
    </bean>
    
    <bean id="sessionFactory" class="org.springframework.orm.hibernate5.LocalSessionFactoryBean">
        <property name="dataSource" ref="dataSource"/>
        <!-- More configuration -->
    </bean>
</beans>
```

### Spring Boot

**Spring Boot** provides auto-configuration:

```properties
# application.properties
spring.datasource.url=jdbc:mysql://localhost:3306/mydb
spring.datasource.username=root
spring.datasource.password=password
spring.jpa.hibernate.ddl-auto=update
```

### Key Differences

| Aspect | Spring Framework | Spring Boot |
|--------|-----------------|-------------|
| **Configuration** | Manual XML/Java configuration | Auto-configuration |
| **Dependency Management** | Manually manage versions | Starter dependencies with compatible versions |
| **Embedded Server** | Requires external server (Tomcat) | Embedded server (Tomcat, Jetty, Undertow) |
| **Deployment** | WAR file to server | Standalone JAR with embedded server |
| **Setup Time** | Time-consuming | Quick start |
| **Production Features** | Need to configure manually | Actuator for monitoring |
| **Annotation** | Multiple annotations | @SpringBootApplication |
| **Development Speed** | Slower | Faster |
| **Learning Curve** | Steeper | Gentler |

### Configuration Comparison

**Spring Framework:**
```java
@Configuration
@EnableWebMvc
@EnableTransactionManagement
@ComponentScan(basePackages = "com.example")
public class AppConfig {
    
    @Bean
    public DataSource dataSource() {
        DriverManagerDataSource dataSource = new DriverManagerDataSource();
        dataSource.setDriverClassName("com.mysql.jdbc.Driver");
        dataSource.setUrl("jdbc:mysql://localhost:3306/mydb");
        dataSource.setUsername("root");
        dataSource.setPassword("password");
        return dataSource;
    }
    
    @Bean
    public LocalSessionFactoryBean sessionFactory() {
        LocalSessionFactoryBean sessionFactory = new LocalSessionFactoryBean();
        sessionFactory.setDataSource(dataSource());
        sessionFactory.setPackagesToScan("com.example.model");
        // More configuration...
        return sessionFactory;
    }
}
```

**Spring Boot:**
```java
@SpringBootApplication
public class Application {
    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }
}
```

### Embedded Server

**Spring Boot** includes embedded servers:
```java
// No configuration needed!
// Tomcat starts automatically on port 8080

// To change server:
// application.properties
server.port=9090
```

**Spring Framework** requires external server deployment:
- Package as WAR
- Deploy to Tomcat/Jetty
- Server configuration separate from application

### Starter Dependencies

**Spring Boot Starters** bundle related dependencies:

```xml
<!-- Spring Boot -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
</dependency>
<!-- Includes: Spring MVC, Tomcat, Jackson, Validation, etc. -->

<!-- Traditional Spring -->
<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-webmvc</artifactId>
    <version>5.3.20</version>
</dependency>
<dependency>
    <groupId>org.apache.tomcat.embed</groupId>
    <artifactId>tomcat-embed-core</artifactId>
    <version>9.0.62</version>
</dependency>
<!-- Many more dependencies... -->
```

### When to Use What?

**Use Spring Framework When:**
- Need fine-grained control over configuration
- Working with legacy systems
- Very specific requirements
- Team has deep Spring knowledge

**Use Spring Boot When:**
- Starting new projects
- Need rapid development
- Building microservices
- Want production-ready features out of the box
- Prefer convention over configuration

---

## Advantages of Spring Framework

### 1. Lightweight and Non-Invasive

```java
// Simple POJO - No Spring-specific interfaces required
public class UserService {
    private UserRepository repository;
    
    public UserService(UserRepository repository) {
        this.repository = repository;
    }
    
    public User findUser(Long id) {
        return repository.findById(id);
    }
}

// Make it a Spring bean by just adding an annotation
@Service
public class UserService {
    // Same code as above
}
```

### 2. Dependency Injection (Loose Coupling)

**Without DI (Tight Coupling):**
```java
public class OrderService {
    private EmailService emailService = new EmailService(); // Hard-coded dependency
    private PaymentService paymentService = new PaymentService();
    
    public void processOrder(Order order) {
        paymentService.processPayment(order);
        emailService.sendConfirmation(order);
    }
}
```

**With DI (Loose Coupling):**
```java
@Service
public class OrderService {
    private final EmailService emailService;
    private final PaymentService paymentService;
    
    @Autowired
    public OrderService(EmailService emailService, PaymentService paymentService) {
        this.emailService = emailService;
        this.paymentService = paymentService;
    }
    
    public void processOrder(Order order) {
        paymentService.processPayment(order);
        emailService.sendConfirmation(order);
    }
}
```

### 3. Easy Testability

```java
// Easy to test with mock dependencies
@Test
public void testProcessOrder() {
    // Arrange
    EmailService mockEmailService = mock(EmailService.class);
    PaymentService mockPaymentService = mock(PaymentService.class);
    OrderService orderService = new OrderService(mockEmailService, mockPaymentService);
    Order order = new Order();
    
    // Act
    orderService.processOrder(order);
    
    // Assert
    verify(mockPaymentService).processPayment(order);
    verify(mockEmailService).sendConfirmation(order);
}
```

### 4. Declarative Programming

**Transaction Management:**
```java
// No manual transaction handling
@Service
public class BankService {
    
    @Transactional
    public void transferMoney(Account from, Account to, BigDecimal amount) {
        from.withdraw(amount);
        to.deposit(amount);
        // Automatic commit or rollback on exception
    }
}
```

**Caching:**
```java
@Service
public class ProductService {
    
    @Cacheable("products")
    public Product getProduct(Long id) {
        // Method result automatically cached
        return productRepository.findById(id);
    }
}
```

**Security:**
```java
@RestController
public class AdminController {
    
    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/admin/users")
    public List<User> getAllUsers() {
        return userService.getAllUsers();
    }
}
```

### 5. AOP Support

```java
@Aspect
@Component
public class LoggingAspect {
    
    @Around("execution(* com.example.service.*.*(..))")
    public Object logExecutionTime(ProceedingJoinPoint joinPoint) throws Throwable {
        long start = System.currentTimeMillis();
        Object result = joinPoint.proceed();
        long executionTime = System.currentTimeMillis() - start;
        
        System.out.println(joinPoint.getSignature() + " executed in " + executionTime + "ms");
        return result;
    }
}
```

### 6. Comprehensive Transaction Management

```java
@Service
public class OrderService {
    
    @Transactional(
        propagation = Propagation.REQUIRED,
        isolation = Isolation.READ_COMMITTED,
        rollbackFor = Exception.class
    )
    public void createOrder(Order order) {
        orderRepository.save(order);
        inventoryService.updateStock(order.getItems());
        emailService.sendOrderConfirmation(order);
    }
}
```

### 7. Exception Translation

```java
// Spring translates database exceptions to DataAccessException hierarchy
@Repository
public class UserRepository {
    
    @Autowired
    private JdbcTemplate jdbcTemplate;
    
    public User findById(Long id) {
        try {
            return jdbcTemplate.queryForObject(
                "SELECT * FROM users WHERE id = ?",
                new UserRowMapper(),
                id
            );
        } catch (EmptyResultDataAccessException e) {
            // Spring's specific exception instead of SQLException
            return null;
        }
    }
}
```

### 8. Integration with Other Frameworks

Spring integrates seamlessly with:
- **ORM**: Hibernate, JPA, MyBatis
- **Web**: Struts, JSF, Thymeleaf
- **Messaging**: JMS, RabbitMQ, Kafka
- **Security**: Spring Security
- **Validation**: Hibernate Validator
- **Testing**: JUnit, Mockito, TestNG

### 9. Modular Architecture

Use only what you need:
```xml
<!-- Only Spring Core and Context -->
<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-context</artifactId>
</dependency>

<!-- Add web support when needed -->
<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-webmvc</artifactId>
</dependency>
```

### 10. Consistent API

Consistent abstractions across different technologies:

```java
// JdbcTemplate
jdbcTemplate.query("SELECT * FROM users", new UserRowMapper());

// JpaTemplate (similar API)
jpaTemplate.find(User.class);

// RestTemplate (similar API)
restTemplate.getForObject("http://api.example.com/users", User[].class);
```

---

## Spring Application Context

### What is ApplicationContext?

`ApplicationContext` is the central interface in a Spring application. It represents the Spring IoC container and is responsible for:
- Instantiating beans
- Configuring beans
- Assembling beans
- Managing bean lifecycle
- Providing enterprise services

### ApplicationContext vs BeanFactory

| Feature | BeanFactory | ApplicationContext |
|---------|-------------|-------------------|
| **Bean Creation** | Lazy (on first request) | Eager (on startup) |
| **Internationalization** | ❌ No | ✅ Yes |
| **Event Publication** | ❌ No | ✅ Yes |
| **AOP** | Manual | Automatic |
| **Resource Loading** | Limited | Full support |
| **Annotation Support** | Manual | Automatic |
| **Use Case** | Resource-constrained environments | Enterprise applications |

### Types of ApplicationContext

#### 1. AnnotationConfigApplicationContext

For Java-based configuration:

```java
@Configuration
@ComponentScan("com.example")
public class AppConfig {
    @Bean
    public UserService userService() {
        return new UserService();
    }
}

// Usage
public class Main {
    public static void main(String[] args) {
        ApplicationContext context = 
            new AnnotationConfigApplicationContext(AppConfig.class);
        
        UserService service = context.getBean(UserService.class);
        service.createUser(new User());
    }
}
```

#### 2. ClassPathXmlApplicationContext

For XML-based configuration:

```xml
<!-- applicationContext.xml -->
<beans>
    <bean id="userService" class="com.example.UserService">
        <property name="userRepository" ref="userRepository"/>
    </bean>
    
    <bean id="userRepository" class="com.example.UserRepository"/>
</beans>
```

```java
public class Main {
    public static void main(String[] args) {
        ApplicationContext context = 
            new ClassPathXmlApplicationContext("applicationContext.xml");
        
        UserService service = context.getBean("userService", UserService.class);
    }
}
```

#### 3. FileSystemXmlApplicationContext

Loads configuration from file system:

```java
ApplicationContext context = 
    new FileSystemXmlApplicationContext("/path/to/applicationContext.xml");
```

#### 4. WebApplicationContext

For web applications:

```java
@Configuration
public class WebConfig implements WebApplicationInitializer {
    @Override
    public void onStartup(ServletContext servletContext) {
        AnnotationConfigWebApplicationContext context = 
            new AnnotationConfigWebApplicationContext();
        context.register(AppConfig.class);
        
        DispatcherServlet servlet = new DispatcherServlet(context);
        ServletRegistration.Dynamic registration = 
            servletContext.addServlet("dispatcher", servlet);
        registration.setLoadOnStartup(1);
        registration.addMapping("/");
    }
}
```

#### 5. Spring Boot Application Context

Spring Boot automatically configures:

```java
@SpringBootApplication
public class Application {
    public static void main(String[] args) {
        ApplicationContext context = SpringApplication.run(Application.class, args);
        
        // Access beans
        UserService service = context.getBean(UserService.class);
    }
}
```

### ApplicationContext Features

#### 1. Bean Retrieval

```java
// By type
UserService service = context.getBean(UserService.class);

// By name
UserService service = (UserService) context.getBean("userService");

// By name and type
UserService service = context.getBean("userService", UserService.class);

// Get all beans of a type
Map<String, UserService> beans = context.getBeansOfType(UserService.class);
```

#### 2. Environment Access

```java
Environment env = context.getEnvironment();
String port = env.getProperty("server.port");
String[] activeProfiles = env.getActiveProfiles();
```

#### 3. Resource Loading

```java
Resource resource = context.getResource("classpath:config.properties");
Resource[] resources = context.getResources("classpath*:*.xml");
```

#### 4. Event Publication

```java
// Custom event
public class UserCreatedEvent extends ApplicationEvent {
    private User user;
    
    public UserCreatedEvent(Object source, User user) {
        super(source);
        this.user = user;
    }
}

// Publisher
@Service
public class UserService implements ApplicationEventPublisherAware {
    private ApplicationEventPublisher publisher;
    
    @Override
    public void setApplicationEventPublisher(ApplicationEventPublisher publisher) {
        this.publisher = publisher;
    }
    
    public void createUser(User user) {
        // Save user...
        publisher.publishEvent(new UserCreatedEvent(this, user));
    }
}

// Listener
@Component
public class UserCreatedListener {
    @EventListener
    public void handleUserCreated(UserCreatedEvent event) {
        System.out.println("User created: " + event.getUser().getName());
    }
}
```

#### 5. Internationalization

```java
// messages.properties
greeting=Hello

// messages_fr.properties
greeting=Bonjour

// Usage
@Service
public class GreetingService {
    @Autowired
    private MessageSource messageSource;
    
    public String greet(Locale locale) {
        return messageSource.getMessage("greeting", null, locale);
    }
}
```

### Application Context Lifecycle

```
1. Bean Definitions Loaded
   ↓
2. BeanFactoryPostProcessors Invoked
   ↓
3. Beans Instantiated
   ↓
4. Dependencies Injected
   ↓
5. BeanPostProcessors (before initialization)
   ↓
6. InitializingBean.afterPropertiesSet()
   ↓
7. Custom init-method
   ↓
8. BeanPostProcessors (after initialization)
   ↓
9. Beans Ready for Use
   ↓
10. Context Shutdown
   ↓
11. DisposableBean.destroy()
   ↓
12. Custom destroy-method
```

### Best Practices

1. **Use Constructor Injection**: Preferred over field injection
2. **Avoid Circular Dependencies**: Use `@Lazy` if necessary
3. **Close Context**: Always close context in standalone applications
4. **Profile-Specific Beans**: Use `@Profile` for environment-specific configuration
5. **Lazy Initialization**: Use `@Lazy` for beans that are rarely used

### Example: Complete Application Context Usage

```java
@Configuration
@ComponentScan("com.example")
@PropertySource("classpath:application.properties")
@EnableTransactionManagement
public class AppConfig {
    
    @Bean
    public DataSource dataSource(Environment env) {
        DriverManagerDataSource ds = new DriverManagerDataSource();
        ds.setUrl(env.getProperty("db.url"));
        ds.setUsername(env.getProperty("db.username"));
        ds.setPassword(env.getProperty("db.password"));
        return ds;
    }
}

public class Main {
    public static void main(String[] args) {
        ConfigurableApplicationContext context = 
            new AnnotationConfigApplicationContext(AppConfig.class);
        
        try {
            UserService service = context.getBean(UserService.class);
            service.createUser(new User("John"));
        } finally {
            context.close(); // Important: release resources
        }
    }
}
```

---

## Summary

Spring Core Concepts provide the foundation for building enterprise Java applications. Understanding IoC, DI, and the Application Context is crucial for mastering Spring Framework. Spring Boot builds on these concepts to provide a streamlined development experience with sensible defaults and auto-configuration.

**Key Takeaways:**
- Spring is lightweight, modular, and non-invasive
- IoC and DI promote loose coupling and testability
- ApplicationContext is the central container managing beans
- Spring Boot simplifies Spring configuration dramatically
- Declarative programming reduces boilerplate code

