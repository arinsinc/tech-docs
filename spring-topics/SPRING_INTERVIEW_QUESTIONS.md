# Spring Framework & Spring Boot Interview Questions

## Table of Contents
1. [Spring Core Concepts](#spring-core-concepts)
2. [Dependency Injection & IoC](#dependency-injection--ioc)
3. [Spring Bean Lifecycle](#spring-bean-lifecycle)
4. [Spring AOP](#spring-aop)
5. [Spring MVC](#spring-mvc)
6. [Spring Boot Basics](#spring-boot-basics)
7. [Spring Boot Configuration](#spring-boot-configuration)
8. [Spring Data JPA](#spring-data-jpa)
9. [Spring Security](#spring-security)
10. [Spring REST APIs](#spring-rest-apis)
11. [Spring Transactions](#spring-transactions)
12. [Spring Testing](#spring-testing)
13. [Microservices with Spring](#microservices-with-spring)
14. [Spring Cloud](#spring-cloud)
15. [Performance & Optimization](#performance--optimization)
16. [Advanced Topics](#advanced-topics)

---

## Spring Core Concepts

### Basic Questions

1. **What is the Spring Framework?**
   - Explain the core features and benefits
   - Why was Spring created?
   - What problems does it solve?

2. **What are the main modules of Spring Framework?**
   - Spring Core
   - Spring AOP
   - Spring MVC
   - Spring Data
   - Spring Security
   - Spring Boot

3. **What is the difference between Spring and Spring Boot?**
   - Configuration differences
   - Auto-configuration
   - Embedded servers
   - Starter dependencies

4. **What are the advantages of using Spring Framework?**
   - Lightweight and loosely coupled
   - Declarative programming
   - POJO-based development
   - Easy testability

5. **What is a Spring Application Context?**
   - Definition and purpose
   - Types of ApplicationContext
   - BeanFactory vs ApplicationContext

---

## Dependency Injection & IoC

### Core DI Questions

6. **What is Dependency Injection (DI)?**
   - Definition and purpose
   - Benefits of DI
   - Types of dependency injection

7. **What is Inversion of Control (IoC)?**
   - Explain the concept
   - How Spring implements IoC
   - IoC Container

8. **What are the different types of Dependency Injection in Spring?**
   - Constructor Injection
   - Setter Injection
   - Field Injection
   - Pros and cons of each

9. **Which type of dependency injection is recommended and why?**
   - Constructor injection advantages
   - Immutability
   - Testability

10. **What is the @Autowired annotation?**
    - How it works
    - Where it can be used
    - Required vs optional autowiring

11. **What is the difference between @Autowired and @Inject?**
    - JSR-330 vs Spring
    - When to use which

12. **What is @Qualifier annotation?**
    - Purpose and usage
    - Resolving ambiguous dependencies
    - Example scenarios

13. **What is @Primary annotation?**
    - Default bean selection
    - Difference from @Qualifier

14. **How do you handle circular dependencies in Spring?**
    - What causes circular dependencies
    - Solutions (setter injection, @Lazy)
    - Best practices to avoid

---

## Spring Bean Lifecycle

### Bean Management Questions

15. **What is a Spring Bean?**
    - Definition
    - How beans are managed
    - Bean scope

16. **What are the different scopes of Spring Beans?**
    - Singleton
    - Prototype
    - Request
    - Session
    - Application
    - WebSocket

17. **What is the default scope of a Spring Bean?**
    - Singleton scope
    - When is it created?

18. **Explain the Spring Bean lifecycle.**
    - Instantiation
    - Populate properties
    - BeanNameAware, BeanFactoryAware
    - Pre-initialization (BeanPostProcessor)
    - InitializingBean and init-method
    - Post-initialization
    - Bean ready to use
    - Destruction callbacks

19. **What are the different ways to configure Spring Beans?**
    - XML configuration
    - Java-based configuration (@Configuration)
    - Annotation-based configuration
    - Component scanning

20. **What is @Component annotation?**
    - Purpose and usage
    - Stereotype annotations
    - Component scanning

21. **What is the difference between @Component, @Service, @Repository, and @Controller?**
    - Semantic meaning
    - Special features of each
    - When to use which

22. **What is @Bean annotation?**
    - Method-level bean definition
    - Difference from @Component
    - Bean name customization

23. **What is @Configuration annotation?**
    - Java-based configuration
    - @Bean methods within @Configuration
    - CGLIB proxying

24. **How do you create a bean conditionally in Spring?**
    - @Conditional annotation
    - @ConditionalOnProperty
    - @ConditionalOnClass
    - @Profile

25. **What is @PostConstruct and @PreDestroy?**
    - Lifecycle callbacks
    - JSR-250 annotations
    - Use cases

---

## Spring AOP

### Aspect-Oriented Programming Questions

26. **What is AOP (Aspect-Oriented Programming)?**
    - Cross-cutting concerns
    - Benefits of AOP
    - How Spring implements AOP

27. **What are the key AOP concepts?**
    - Aspect
    - Join Point
    - Advice
    - Pointcut
    - Target Object
    - Proxy
    - Weaving

28. **What are the different types of Advice in Spring AOP?**
    - Before advice
    - After returning advice
    - After throwing advice
    - After (finally) advice
    - Around advice

29. **What is the difference between @Before and @Around advice?**
    - Execution control
    - ProceedingJoinPoint
    - Use cases

30. **What is a Pointcut expression?**
    - Syntax and patterns
    - execution()
    - within()
    - @annotation()

31. **What is the difference between Spring AOP and AspectJ?**
    - Compile-time vs runtime weaving
    - Proxy-based vs bytecode manipulation
    - Feature comparison

32. **What are JDK Dynamic Proxy and CGLIB Proxy?**
    - Interface-based proxying
    - Class-based proxying
    - When Spring uses which

33. **What are common use cases for AOP?**
    - Logging
    - Transaction management
    - Security
    - Caching
    - Error handling

---

## Spring MVC

### Web Framework Questions

34. **What is Spring MVC?**
    - Model-View-Controller pattern
    - DispatcherServlet
    - Front Controller pattern

35. **Explain the Spring MVC request flow.**
    - Client request → DispatcherServlet
    - HandlerMapping
    - Controller
    - ViewResolver
    - View rendering
    - Response to client

36. **What is DispatcherServlet?**
    - Front controller
    - Configuration
    - Initialization

37. **What is @Controller annotation?**
    - MVC controller
    - Request handling
    - Difference from @RestController

38. **What is @RestController?**
    - @Controller + @ResponseBody
    - RESTful web services
    - JSON/XML responses

39. **What is @RequestMapping?**
    - URL mapping
    - HTTP method mapping
    - Path variables and request parameters

40. **What are the variants of @RequestMapping?**
    - @GetMapping
    - @PostMapping
    - @PutMapping
    - @DeleteMapping
    - @PatchMapping

41. **What is @PathVariable?**
    - URI template patterns
    - Extracting values from URL
    - Required vs optional

42. **What is @RequestParam?**
    - Query parameters
    - Form data
    - Default values
    - Required vs optional

43. **What is @RequestBody?**
    - HTTP request body to Java object
    - Content negotiation
    - HttpMessageConverter

44. **What is @ResponseBody?**
    - Java object to HTTP response body
    - Automatic serialization
    - Content negotiation

45. **What is the difference between @RequestParam and @PathVariable?**
    - Query parameters vs path parameters
    - Use cases
    - Syntax differences

46. **What is ModelAndView?**
    - Model data + view name
    - Returning from controller methods
    - Adding attributes

47. **What are ViewResolvers in Spring MVC?**
    - InternalResourceViewResolver
    - Thymeleaf ViewResolver
    - Content negotiation

48. **What is @ModelAttribute?**
    - Binding request data to model objects
    - Form backing objects
    - Method-level vs parameter-level

49. **What are Interceptors in Spring MVC?**
    - HandlerInterceptor interface
    - preHandle, postHandle, afterCompletion
    - Use cases (logging, authentication)

50. **What is the difference between Filters and Interceptors?**
    - Servlet API vs Spring MVC
    - Execution order
    - Access to Spring beans

---

## Spring Boot Basics

### Fundamental Spring Boot Questions

51. **What is Spring Boot?**
    - Opinionated framework
    - Convention over configuration
    - Rapid application development

52. **What are the main features of Spring Boot?**
    - Auto-configuration
    - Starter dependencies
    - Embedded servers
    - Actuator
    - DevTools
    - CLI

53. **What is Spring Boot Auto-configuration?**
    - @EnableAutoConfiguration
    - Conditional configuration
    - How it works under the hood
    - Customizing auto-configuration

54. **What are Spring Boot Starters?**
    - Dependency descriptors
    - Common starters (web, data-jpa, security)
    - Creating custom starters

55. **What is the @SpringBootApplication annotation?**
    - Meta-annotation combining:
      - @Configuration
      - @EnableAutoConfiguration
      - @ComponentScan
    - Main class entry point

56. **How does Spring Boot application start?**
    - SpringApplication.run()
    - ApplicationContext creation
    - Auto-configuration
    - Component scanning
    - Bean initialization

57. **What are embedded servers in Spring Boot?**
    - Tomcat (default)
    - Jetty
    - Undertow
    - Configuration and customization

58. **How do you change the default embedded server in Spring Boot?**
    - Excluding Tomcat dependency
    - Adding alternative server dependency
    - Configuration properties

59. **What is Spring Boot DevTools?**
    - Automatic restart
    - LiveReload
    - Property defaults
    - Remote debugging

60. **What is the difference between @Component and @Bean?**
    - Class-level vs method-level
    - Component scanning vs explicit declaration
    - Use cases for each

---

## Spring Boot Configuration

### Configuration Management Questions

61. **What is application.properties file?**
    - Configuration externalization
    - Property injection
    - Profile-specific properties

62. **What is the difference between application.properties and application.yml?**
    - Format differences
    - Hierarchical structure
    - Readability

63. **What is @Value annotation?**
    - Injecting property values
    - SpEL expressions
    - Default values

64. **What is @ConfigurationProperties?**
    - Type-safe configuration
    - Binding external properties to POJOs
    - Validation support
    - Advantages over @Value

65. **How do you use Spring Profiles?**
    - @Profile annotation
    - application-{profile}.properties
    - Activating profiles
    - Multiple active profiles

66. **What are the different ways to activate Spring Profiles?**
    - spring.profiles.active property
    - Command-line argument
    - Environment variable
    - Programmatically

67. **What is property precedence in Spring Boot?**
    - Order of property sources
    - Command-line args > Environment variables > application.properties
    - Profile-specific properties

68. **What is @PropertySource annotation?**
    - Loading external property files
    - Multiple property sources
    - Encoding

69. **How do you externalize configuration in Spring Boot?**
    - application.properties
    - Environment variables
    - Command-line arguments
    - Config server (Spring Cloud Config)

70. **What is Spring Boot Actuator?**
    - Production-ready features
    - Health checks
    - Metrics
    - Endpoints

---

## Spring Data JPA

### Database and JPA Questions

71. **What is Spring Data JPA?**
    - Repository abstraction
    - Reducing boilerplate code
    - CRUD operations
    - Query methods

72. **What is JpaRepository?**
    - Repository interface hierarchy
    - Built-in CRUD methods
    - Extending with custom methods

73. **What is the difference between JpaRepository, CrudRepository, and PagingAndSortingRepository?**
    - Feature comparison
    - Method availability
    - Use cases

74. **What are derived query methods in Spring Data JPA?**
    - Method naming conventions
    - findBy, readBy, queryBy, countBy, deleteBy
    - Property expressions
    - Operators (And, Or, Between, LessThan, etc.)

75. **What is @Query annotation?**
    - Custom JPQL queries
    - Native SQL queries
    - Named parameters vs positional parameters
    - @Modifying for updates/deletes

76. **What is the difference between JPQL and native SQL queries?**
    - Entity-based vs table-based
    - Database independence
    - When to use which

77. **What is @Entity annotation?**
    - JPA entity mapping
    - Table mapping
    - Entity lifecycle

78. **What are the key JPA annotations?**
    - @Id, @GeneratedValue
    - @Column, @Table
    - @OneToMany, @ManyToOne, @ManyToMany, @OneToOne
    - @JoinColumn, @JoinTable
    - @Transient

79. **What are entity relationships in JPA?**
    - One-to-One
    - One-to-Many / Many-to-One
    - Many-to-Many
    - Bidirectional vs unidirectional

80. **What is lazy loading vs eager loading?**
    - FetchType.LAZY vs FetchType.EAGER
    - Performance implications
    - N+1 query problem
    - Best practices

81. **What is the N+1 query problem?**
    - How it occurs
    - Performance impact
    - Solutions (JOIN FETCH, Entity Graphs, Batch Size)

82. **What are entity lifecycle states in JPA?**
    - Transient
    - Managed (Persistent)
    - Detached
    - Removed

83. **What is the difference between save() and saveAndFlush()?**
    - Persistence context
    - Database synchronization
    - Use cases

84. **What is @Transactional annotation?**
    - Transaction management
    - Propagation levels
    - Isolation levels
    - Rollback rules

85. **What is Spring Data JPA pagination?**
    - Pageable interface
    - Page<T> result
    - Sorting
    - PageRequest

---

## Spring Security

### Security Framework Questions

86. **What is Spring Security?**
    - Authentication and authorization framework
    - Security filters
    - Protection against common attacks

87. **What is the difference between authentication and authorization?**
    - Authentication: verifying identity (who you are)
    - Authorization: verifying permissions (what you can do)

88. **How does Spring Security work internally?**
    - Filter chain
    - SecurityContext
    - Authentication Manager
    - User Details Service

89. **What is SecurityFilterChain?**
    - Chain of security filters
    - Filter ordering
    - Custom filters

90. **What is UserDetailsService?**
    - Loading user-specific data
    - Custom implementation
    - loadUserByUsername()

91. **What are different authentication methods in Spring Security?**
    - Form-based login
    - HTTP Basic
    - JWT tokens
    - OAuth2
    - LDAP

92. **What is @PreAuthorize and @PostAuthorize?**
    - Method-level security
    - SpEL expressions
    - hasRole(), hasAuthority()
    - Difference between the two

93. **What is @Secured annotation?**
    - Method security
    - Role-based access control
    - Difference from @PreAuthorize

94. **What is CORS and how do you configure it in Spring?**
    - Cross-Origin Resource Sharing
    - @CrossOrigin annotation
    - Global CORS configuration
    - Security implications

95. **What is CSRF protection?**
    - Cross-Site Request Forgery
    - CSRF tokens
    - When to disable
    - REST API considerations

96. **How do you implement JWT authentication in Spring Boot?**
    - Token generation
    - Token validation
    - Filter implementation
    - Stateless authentication

97. **What is OAuth2?**
    - Authorization framework
    - Grant types
    - Spring Security OAuth2
    - Resource server vs authorization server

98. **What is BCryptPasswordEncoder?**
    - Password hashing
    - Salt generation
    - Security best practices

99. **How do you secure REST APIs in Spring Boot?**
    - JWT tokens
    - API keys
    - OAuth2
    - Rate limiting

100. **What is SecurityContext and SecurityContextHolder?**
     - Thread-local storage for authentication
     - Accessing current user
     - Custom authentication

---

## Spring REST APIs

### RESTful Web Services Questions

101. **What is REST?**
     - Representational State Transfer
     - Architectural style
     - Stateless communication
     - Resource-based

102. **What are RESTful web services?**
     - HTTP methods (GET, POST, PUT, DELETE, PATCH)
     - Resource URIs
     - Stateless
     - JSON/XML representations

103. **What are the key principles of REST?**
     - Client-Server architecture
     - Stateless
     - Cacheable
     - Uniform interface
     - Layered system
     - Code on demand (optional)

104. **What is the difference between PUT and PATCH?**
     - PUT: complete replacement
     - PATCH: partial update
     - Idempotency

105. **What are HTTP status codes used in REST APIs?**
     - 2xx: Success (200 OK, 201 Created, 204 No Content)
     - 3xx: Redirection
     - 4xx: Client errors (400 Bad Request, 401 Unauthorized, 404 Not Found)
     - 5xx: Server errors (500 Internal Server Error)

106. **How do you handle exceptions in Spring REST APIs?**
     - @ExceptionHandler
     - @ControllerAdvice
     - ResponseEntityExceptionHandler
     - Custom error responses

107. **What is @ControllerAdvice?**
     - Global exception handling
     - Model attributes
     - Data binding
     - Response body advice

108. **What is ResponseEntity?**
     - HTTP response with status, headers, and body
     - Flexible response construction
     - Builder pattern

109. **How do you implement versioning in REST APIs?**
     - URI versioning (/v1/users)
     - Request parameter versioning
     - Header versioning
     - Media type versioning

110. **What is content negotiation?**
     - Producing different representations
     - Accept header
     - @RequestMapping(produces)
     - JSON vs XML

111. **How do you document REST APIs in Spring Boot?**
     - Swagger/OpenAPI
     - SpringDoc
     - @ApiOperation, @ApiModel annotations
     - API documentation endpoints

112. **What is HATEOAS?**
     - Hypermedia as the Engine of Application State
     - Self-descriptive APIs
     - Links in responses
     - Spring HATEOAS

113. **What is RestTemplate?**
     - Synchronous HTTP client
     - REST API consumption
     - Methods: getForObject, postForEntity, exchange, etc.
     - Deprecated in favor of WebClient

114. **What is WebClient?**
     - Reactive, non-blocking HTTP client
     - Part of Spring WebFlux
     - Fluent API
     - Async and reactive support

115. **What is the difference between RestTemplate and WebClient?**
     - Synchronous vs asynchronous
     - Blocking vs non-blocking
     - Performance characteristics
     - Modern alternatives

---

## Spring Transactions

### Transaction Management Questions

116. **What is a transaction?**
     - ACID properties (Atomicity, Consistency, Isolation, Durability)
     - Unit of work
     - All-or-nothing execution

117. **How does Spring manage transactions?**
     - Declarative transaction management
     - Programmatic transaction management
     - Transaction proxies
     - PlatformTransactionManager

118. **What is @Transactional annotation?**
     - Declarative transaction management
     - Method or class level
     - Transaction boundaries
     - Configuration options

119. **What are transaction propagation levels?**
     - REQUIRED (default)
     - REQUIRES_NEW
     - NESTED
     - MANDATORY
     - SUPPORTS
     - NOT_SUPPORTED
     - NEVER

120. **What are transaction isolation levels?**
     - READ_UNCOMMITTED
     - READ_COMMITTED (default)
     - REPEATABLE_READ
     - SERIALIZABLE
     - Concurrency issues (dirty reads, phantom reads, non-repeatable reads)

121. **What is the difference between REQUIRED and REQUIRES_NEW?**
     - Joining existing transaction vs creating new
     - Independent rollback
     - Use cases

122. **When does @Transactional not work?**
     - Self-invocation (calling transactional method from same class)
     - Private methods
     - Not a Spring bean
     - Solutions (proxy mode, AspectJ weaving)

123. **What is transaction rollback?**
     - Default: runtime exceptions
     - Checked exceptions: no rollback by default
     - rollbackFor and noRollbackFor attributes
     - Custom rollback rules

124. **What is read-only transaction?**
     - readOnly = true
     - Performance optimization
     - Hint to database
     - Use cases

125. **What is programmatic transaction management?**
     - TransactionTemplate
     - PlatformTransactionManager
     - Fine-grained control
     - When to use

---

## Spring Testing

### Testing Framework Questions

126. **What is the importance of testing in Spring applications?**
     - Quality assurance
     - Regression prevention
     - Documentation
     - Design feedback

127. **What testing annotations does Spring provide?**
     - @SpringBootTest
     - @WebMvcTest
     - @DataJpaTest
     - @MockBean
     - @SpyBean

128. **What is @SpringBootTest?**
     - Integration testing
     - Full application context
     - Configuration options
     - WebEnvironment modes

129. **What is @WebMvcTest?**
     - Testing MVC controllers
     - Auto-configured MockMvc
     - Limited context loading
     - Mock service layer

130. **What is @DataJpaTest?**
     - Testing JPA repositories
     - In-memory database
     - Transaction rollback
     - TestEntityManager

131. **What is MockMvc?**
     - Testing MVC controllers without HTTP server
     - Request builders
     - Result matchers
     - Assertions

132. **What is the difference between @Mock and @MockBean?**
     - Mockito vs Spring
     - @Mock: plain Mockito mock
     - @MockBean: adds mock to Spring context
     - Use cases

133. **How do you test REST APIs in Spring Boot?**
     - MockMvc
     - TestRestTemplate
     - WebTestClient (reactive)
     - Integration tests

134. **What is @TestConfiguration?**
     - Test-specific configuration
     - Override beans
     - Additional test beans

135. **What is @DirtiesContext?**
     - Reloading application context
     - Cleaning up state
     - Performance implications
     - When to use sparingly

136. **How do you test transactional methods?**
     - @Transactional in tests
     - Automatic rollback
     - Verifying database state

137. **What is the difference between unit testing and integration testing?**
     - Scope and dependencies
     - Speed and feedback
     - Test pyramid
     - When to use each

138. **How do you mock external services in tests?**
     - @MockBean
     - WireMock
     - MockServer
     - Test containers

---

## Microservices with Spring

### Microservices Architecture Questions

139. **What are microservices?**
     - Architectural style
     - Independent deployable services
     - Business capability focus
     - Benefits and challenges

140. **What are the advantages of microservices?**
     - Scalability
     - Technology diversity
     - Independent deployment
     - Fault isolation
     - Team autonomy

141. **What are the challenges of microservices?**
     - Distributed system complexity
     - Data consistency
     - Network latency
     - Deployment complexity
     - Monitoring and debugging

142. **How do microservices communicate?**
     - Synchronous: REST, gRPC
     - Asynchronous: Message queues, Event streams
     - Service mesh

143. **What is service discovery?**
     - Dynamic service location
     - Client-side vs server-side discovery
     - Eureka, Consul
     - Load balancing

144. **What is API Gateway?**
     - Single entry point
     - Routing
     - Authentication/Authorization
     - Rate limiting
     - Spring Cloud Gateway

145. **What is circuit breaker pattern?**
     - Fault tolerance
     - Preventing cascade failures
     - States: Closed, Open, Half-Open
     - Resilience4j, Hystrix

146. **What is the difference between monolithic and microservices architecture?**
     - Structure and organization
     - Deployment
     - Scalability
     - Development and maintenance
     - When to use each

147. **What is the Saga pattern?**
     - Distributed transactions
     - Choreography vs Orchestration
     - Compensating transactions
     - Eventual consistency

148. **How do you handle data consistency in microservices?**
     - Database per service
     - Eventual consistency
     - Event sourcing
     - CQRS

149. **What is the strangler pattern?**
     - Gradual migration
     - Monolith to microservices
     - Risk mitigation

150. **What is the bulkhead pattern?**
     - Resource isolation
     - Preventing resource exhaustion
     - Thread pools
     - Resilience4j

---

## Spring Cloud

### Cloud-Native Application Questions

151. **What is Spring Cloud?**
     - Distributed system patterns
     - Cloud-native application development
     - Integration with various cloud platforms
     - Common patterns implementation

152. **What is Spring Cloud Config?**
     - Centralized configuration management
     - Config server and client
     - Git-based configuration
     - Environment-specific properties
     - Refresh without restart

153. **What is Eureka?**
     - Service registry
     - Service discovery
     - Eureka server and client
     - Heartbeat mechanism
     - Load balancing

154. **What is Spring Cloud Gateway?**
     - API Gateway implementation
     - Routing
     - Filters (Pre, Post, Global)
     - Predicates
     - Rate limiting and circuit breaker integration

155. **What is Zuul?**
     - API Gateway (older approach)
     - Routing and filtering
     - Difference from Spring Cloud Gateway
     - Migration considerations

156. **What is Ribbon?**
     - Client-side load balancing
     - Load balancing algorithms
     - Integration with Eureka
     - Superseded by Spring Cloud LoadBalancer

157. **What is Feign?**
     - Declarative REST client
     - Interface-based
     - Integration with Eureka and Ribbon
     - Error handling

158. **What is Hystrix?**
     - Circuit breaker implementation
     - Fallback methods
     - Dashboard
     - Maintenance mode (use Resilience4j instead)

159. **What is Resilience4j?**
     - Fault tolerance library
     - Circuit breaker
     - Rate limiter
     - Retry
     - Bulkhead
     - Time limiter

160. **What is Spring Cloud Sleuth?**
     - Distributed tracing
     - Trace and span IDs
     - Log correlation
     - Integration with Zipkin

161. **What is Zipkin?**
     - Distributed tracing system
     - Visualizing traces
     - Performance monitoring
     - Troubleshooting latency issues

162. **What is Spring Cloud Stream?**
     - Event-driven microservices
     - Message broker abstraction
     - Binders (Kafka, RabbitMQ)
     - Producers and consumers

163. **What is Spring Cloud Bus?**
     - Broadcasting state changes
     - Configuration refresh
     - Message broker based
     - Use cases

164. **How do you implement distributed tracing?**
     - Spring Cloud Sleuth + Zipkin
     - OpenTelemetry
     - Correlation IDs
     - Log aggregation

165. **What is the difference between Eureka and Consul?**
     - Service discovery
     - Health checking
     - Key-value store
     - Use cases

---

## Performance & Optimization

### Performance Tuning Questions

166. **How do you optimize Spring Boot application startup time?**
     - Lazy initialization
     - Exclude unnecessary auto-configurations
     - Component index
     - AOT compilation
     - Spring Native (GraalVM)

167. **What is Spring Boot Lazy Initialization?**
     - Beans created on first use
     - spring.main.lazy-initialization=true
     - Faster startup
     - Trade-offs

168. **How do you implement caching in Spring Boot?**
     - @EnableCaching
     - @Cacheable, @CachePut, @CacheEvict
     - Cache providers (Caffeine, Redis, Ehcache)
     - Cache configuration

169. **What is @Cacheable annotation?**
     - Method result caching
     - Cache key generation
     - Conditional caching
     - TTL configuration

170. **What are the different cache providers in Spring?**
     - ConcurrentMapCache (default)
     - Caffeine
     - Redis
     - Ehcache
     - Hazelcast

171. **How do you monitor Spring Boot applications?**
     - Spring Boot Actuator
     - Micrometer
     - Prometheus + Grafana
     - APM tools (New Relic, Dynatrace)
     - Custom metrics

172. **What is connection pooling?**
     - Database connection management
     - HikariCP (default in Spring Boot)
     - Configuration parameters
     - Performance benefits

173. **How do you tune database queries for performance?**
     - Indexing
     - Query optimization
     - Lazy vs eager loading
     - Pagination
     - Caching
     - Connection pooling

174. **What is the N+1 query problem and how do you solve it?**
     - Problem description
     - JOIN FETCH
     - @EntityGraph
     - Batch fetching
     - DTO projections

175. **How do you handle large file uploads/downloads?**
     - Streaming
     - MultipartFile
     - Chunked transfer
     - Async processing
     - Cloud storage integration

176. **What is reactive programming in Spring?**
     - Spring WebFlux
     - Non-blocking I/O
     - Reactive streams
     - Mono and Flux
     - Backpressure

177. **When should you use Spring WebFlux vs Spring MVC?**
     - Use cases for each
     - Performance characteristics
     - Programming model
     - Learning curve

178. **How do you implement rate limiting?**
     - Bucket4j
     - Redis rate limiting
     - API Gateway rate limiting
     - Custom filters

179. **What are thread pools in Spring?**
     - @Async
     - TaskExecutor
     - Configuration
     - Best practices

180. **How do you profile a Spring Boot application?**
     - JProfiler, YourKit
     - Java Flight Recorder
     - Actuator endpoints
     - Heap dumps
     - Thread dumps

---

## Advanced Topics

### Expert-Level Questions

181. **What is Spring WebFlux?**
     - Reactive web framework
     - Non-blocking architecture
     - Annotation-based vs functional endpoints
     - Netty server

182. **What is the difference between Mono and Flux?**
     - Mono: 0 or 1 element
     - Flux: 0 to N elements
     - Reactive streams
     - Operators

183. **What is Spring Batch?**
     - Batch processing framework
     - Job, Step, ItemReader, ItemProcessor, ItemWriter
     - Chunk-based processing
     - Job scheduling

184. **What is Spring Integration?**
     - Enterprise Integration Patterns
     - Message-driven architecture
     - Channels, adapters, transformers
     - Integration with external systems

185. **What is Spring State Machine?**
     - State machine implementation
     - State transitions
     - Guards and actions
     - Use cases

186. **What is Spring HATEOAS?**
     - Hypermedia-driven APIs
     - Links in responses
     - Resource representation
     - Self-descriptive APIs

187. **What is GraphQL and how do you integrate it with Spring Boot?**
     - Query language
     - Spring for GraphQL
     - Schema definition
     - Resolvers

188. **What is gRPC and how do you use it with Spring Boot?**
     - RPC framework
     - Protocol buffers
     - gRPC Spring Boot starter
     - Performance benefits

189. **What is Spring Native?**
     - GraalVM native images
     - AOT compilation
     - Faster startup
     - Lower memory footprint
     - Limitations

190. **What is Spring Modulith?**
     - Modular monolith
     - Module boundaries
     - Event publication
     - Documentation

191. **How do you implement multi-tenancy in Spring Boot?**
     - Separate database
     - Shared database, separate schema
     - Shared database, shared schema
     - Hibernate MultiTenancyStrategy
     - Tenant resolution

192. **What is event-driven architecture in Spring?**
     - ApplicationEvent
     - @EventListener
     - @TransactionalEventListener
     - Async event processing
     - Message brokers (Kafka, RabbitMQ)

193. **How do you implement audit logging in Spring Boot?**
     - Spring Data JPA auditing
     - @CreatedDate, @LastModifiedDate
     - @CreatedBy, @LastModifiedBy
     - AuditorAware
     - Custom audit trails

194. **What is Spring Cloud Function?**
     - Function as a Service (FaaS)
     - Serverless applications
     - Platform agnostic
     - AWS Lambda, Azure Functions

195. **How do you implement websockets in Spring Boot?**
     - @EnableWebSocket
     - WebSocketHandler
     - STOMP protocol
     - SockJS fallback
     - Message brokers

196. **What is Kotlin support in Spring?**
     - Null safety
     - Coroutines
     - Extension functions
     - Spring DSL

197. **How do you implement API rate limiting?**
     - Bucket4j
     - Redis-based rate limiting
     - Spring Cloud Gateway filters
     - Custom filters

198. **What is the difference between synchronous and asynchronous communication?**
     - Blocking vs non-blocking
     - Use cases
     - REST vs messaging
     - Performance implications

199. **How do you implement idempotency in REST APIs?**
     - Idempotent operations
     - Idempotency keys
     - Database constraints
     - Distributed locks

200. **What are the best practices for Spring Boot application development?**
     - Use constructor injection
     - Keep controllers thin
     - Use DTOs for API layer
     - Externalize configuration
     - Implement proper exception handling
     - Write tests
     - Use actuator for monitoring
     - Follow REST conventions
     - Use appropriate HTTP status codes
     - Document APIs
     - Secure endpoints
     - Use connection pooling
     - Implement caching strategically
     - Handle transactions properly
     - Profile and optimize

---

## Additional Topics to Explore

### Scenario-Based Questions

201. **How would you design a highly available Spring Boot application?**
202. **How do you handle distributed transactions across microservices?**
203. **What strategies would you use for zero-downtime deployment?**
204. **How do you implement blue-green deployment for Spring Boot applications?**
205. **How would you migrate a monolithic application to microservices?**
206. **How do you handle versioning in microservices?**
207. **What is your approach to logging in a microservices architecture?**
208. **How do you implement correlation IDs across microservices?**
209. **How would you handle a memory leak in a Spring Boot application?**
210. **How do you implement feature flags in Spring Boot?**

### Design Pattern Questions

211. **What design patterns are used in Spring Framework?**
     - Factory pattern
     - Singleton pattern
     - Proxy pattern
     - Template method pattern
     - Front controller pattern
     - Dependency injection pattern

212. **How does Spring implement the Singleton pattern?**
213. **What is the Template Method pattern in Spring?**
214. **How does Spring use the Proxy pattern?**

### Database-Related Questions

215. **How do you implement database migration in Spring Boot?**
     - Flyway
     - Liquibase
     - Configuration
     - Best practices

216. **What is the difference between Flyway and Liquibase?**
217. **How do you handle database versioning?**
218. **How do you implement soft deletes in Spring Data JPA?**
219. **What is optimistic locking vs pessimistic locking?**
220. **How do you implement full-text search in Spring Boot?**

### Messaging and Events

221. **How do you integrate Apache Kafka with Spring Boot?**
222. **What is Spring Kafka?**
223. **How do you integrate RabbitMQ with Spring Boot?**
224. **What is Spring AMQP?**
225. **How do you implement event sourcing?**
226. **What is CQRS pattern?**

### Container and Deployment

227. **How do you containerize a Spring Boot application with Docker?**
228. **What are the best practices for Docker images of Spring Boot apps?**
229. **How do you deploy Spring Boot applications to Kubernetes?**
230. **What is Spring Cloud Kubernetes?**
231. **How do you implement health checks for Kubernetes?**
232. **What are readiness and liveness probes?**

---

## Study Tips

1. **Understand Core Concepts First**: Focus on IoC, DI, and bean lifecycle before moving to advanced topics.

2. **Practice Hands-On**: Build small projects implementing each concept.

3. **Read Official Documentation**: Spring docs are comprehensive and well-written.

4. **Understand the "Why"**: Don't just memorize answers; understand why certain approaches are recommended.

5. **Follow Best Practices**: Learn industry-standard patterns and practices.

6. **Stay Updated**: Spring evolves rapidly; keep up with the latest versions and features.

7. **Work on Real Projects**: Practical experience is invaluable.

8. **Contribute to Open Source**: Learn from real-world Spring applications.

9. **Join Community**: Participate in Spring forums, Stack Overflow, and Reddit discussions.

10. **Review Regularly**: Revisit concepts periodically to reinforce learning.

---

## Useful Resources

- **Official Spring Documentation**: https://spring.io/projects
- **Spring Boot Reference Guide**: https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/
- **Spring Framework Documentation**: https://docs.spring.io/spring-framework/docs/current/reference/html/
- **Baeldung**: https://www.baeldung.com/
- **Spring Blog**: https://spring.io/blog
- **Spring Academy**: https://spring.academy/
- **GitHub Spring Projects**: https://github.com/spring-projects

---

## Interview Preparation Checklist

- [ ] Understand Spring Core (IoC, DI, Bean Lifecycle)
- [ ] Master Spring Boot fundamentals and auto-configuration
- [ ] Practice Spring MVC and REST API development
- [ ] Learn Spring Data JPA thoroughly
- [ ] Understand Spring Security basics
- [ ] Study Spring AOP concepts
- [ ] Learn transaction management
- [ ] Understand testing in Spring
- [ ] Study microservices patterns
- [ ] Learn Spring Cloud basics
- [ ] Practice performance optimization
- [ ] Build at least 2-3 complete projects
- [ ] Prepare for scenario-based questions
- [ ] Review design patterns used in Spring
- [ ] Stay updated with latest Spring features

---

## Conclusion

This documentation covers a comprehensive range of Spring Framework and Spring Boot interview questions. The topics progress from fundamental concepts to advanced architectural patterns. Regular practice, hands-on coding, and understanding the underlying principles will help you excel in technical interviews.

Remember: **Understanding > Memorization**. Focus on understanding concepts deeply rather than memorizing answers. Be ready to explain your thought process and discuss trade-offs in your solutions.

Good luck with your interviews! 🚀

---

*Last Updated: January 26, 2026*
