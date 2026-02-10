# Testing in Microservices

## Table of Contents
1. [Introduction](#introduction)
2. [Testing Pyramid for Microservices](#testing-pyramid-for-microservices)
3. [Types of Testing](#types-of-testing)
4. [Unit Testing](#unit-testing)
5. [Integration Testing](#integration-testing)
6. [Contract Testing](#contract-testing)
7. [Component Testing](#component-testing)
8. [End-to-End Testing](#end-to-end-testing)
9. [Performance Testing](#performance-testing)
10. [Chaos Engineering](#chaos-engineering)
11. [Testing Tools and Frameworks](#testing-tools-and-frameworks)
12. [Best Practices](#best-practices)

---

## Introduction

Testing microservices presents unique challenges compared to monolithic applications:
- **Distributed Nature**: Services communicate over the network
- **Service Dependencies**: Multiple services working together
- **Data Consistency**: Eventual consistency across services
- **Deployment Independence**: Services can be deployed separately
- **Technology Diversity**: Different tech stacks per service

### Key Testing Goals
- Ensure individual service functionality
- Verify service interactions
- Validate system behavior under failure
- Maintain deployment confidence
- Enable continuous delivery

---

## Testing Pyramid for Microservices

```
           /\
          /  \         E2E Tests (Few)
         /____\
        /      \       Integration Tests (Some)
       /________\
      /          \     Contract Tests (More)
     /____________\
    /              \   Unit Tests (Many)
   /________________\
```

### Modified Pyramid Principles
1. **Unit Tests (70%)**: Fast, isolated, numerous
2. **Contract Tests (20%)**: Service interface validation
3. **Integration Tests (5%)**: Inter-service communication
4. **E2E Tests (5%)**: Critical user journeys only

---

## Types of Testing

### 1. **Unit Testing**
- Test individual components in isolation
- Mock external dependencies
- Fast execution, high coverage

### 2. **Integration Testing**
- Test service interactions with dependencies
- Use test doubles or actual dependencies
- Validate database operations, message queues

### 3. **Contract Testing**
- Verify service contracts between consumer and provider
- Ensure API compatibility
- Prevent breaking changes

### 4. **Component Testing**
- Test entire service in isolation
- Mock external services
- Validate service behavior end-to-end

### 5. **End-to-End Testing**
- Test complete business flows across services
- Most expensive and fragile
- Focus on critical paths only

### 6. **Performance Testing**
- Load testing, stress testing, spike testing
- Measure latency, throughput, resource usage
- Identify bottlenecks

### 7. **Chaos Testing**
- Test resilience under failure conditions
- Simulate network issues, service crashes
- Verify recovery mechanisms

---

## Unit Testing

### Characteristics
- Test single class or method
- No external dependencies
- Fast execution (<100ms per test)
- High code coverage (>80%)

### Example (Java/Spring Boot)

```java
@ExtendWith(MockitoExtension.class)
class OrderServiceTest {
    
    @Mock
    private OrderRepository orderRepository;
    
    @Mock
    private InventoryClient inventoryClient;
    
    @InjectMocks
    private OrderService orderService;
    
    @Test
    void shouldCreateOrder_WhenInventoryAvailable() {
        // Given
        OrderRequest request = new OrderRequest("PROD-123", 5);
        when(inventoryClient.checkStock("PROD-123"))
            .thenReturn(new StockResponse(true, 10));
        when(orderRepository.save(any(Order.class)))
            .thenReturn(new Order("ORD-001", "PROD-123", 5));
        
        // When
        Order order = orderService.createOrder(request);
        
        // Then
        assertNotNull(order);
        assertEquals("ORD-001", order.getId());
        verify(inventoryClient).checkStock("PROD-123");
        verify(orderRepository).save(any(Order.class));
    }
    
    @Test
    void shouldThrowException_WhenInventoryNotAvailable() {
        // Given
        OrderRequest request = new OrderRequest("PROD-123", 5);
        when(inventoryClient.checkStock("PROD-123"))
            .thenReturn(new StockResponse(false, 0));
        
        // When & Then
        assertThrows(InsufficientInventoryException.class, 
            () -> orderService.createOrder(request));
        verify(orderRepository, never()).save(any());
    }
}
```

### Best Practices
- Follow AAA pattern (Arrange, Act, Assert)
- One assertion per test
- Meaningful test names
- Use mocks for external dependencies
- Keep tests independent

---

## Integration Testing

### Characteristics
- Test service with real dependencies
- Use embedded databases, message brokers
- Slower than unit tests
- Validate actual integrations

### Example (Spring Boot with TestContainers)

```java
@SpringBootTest
@Testcontainers
class OrderIntegrationTest {
    
    @Container
    static PostgreSQLContainer<?> postgres = 
        new PostgreSQLContainer<>("postgres:15-alpine");
    
    @Container
    static KafkaContainer kafka = 
        new KafkaContainer(DockerImageName.parse("confluentinc/cp-kafka:7.4.0"));
    
    @Autowired
    private OrderService orderService;
    
    @Autowired
    private OrderRepository orderRepository;
    
    @Autowired
    private KafkaTemplate<String, OrderEvent> kafkaTemplate;
    
    @DynamicPropertySource
    static void configureProperties(DynamicPropertyRegistry registry) {
        registry.add("spring.datasource.url", postgres::getJdbcUrl);
        registry.add("spring.kafka.bootstrap-servers", kafka::getBootstrapServers);
    }
    
    @Test
    void shouldPersistOrderAndPublishEvent() {
        // Given
        OrderRequest request = new OrderRequest("PROD-123", 5);
        
        // When
        Order order = orderService.createOrder(request);
        
        // Then
        Optional<Order> savedOrder = orderRepository.findById(order.getId());
        assertTrue(savedOrder.isPresent());
        assertEquals(5, savedOrder.get().getQuantity());
        
        // Verify Kafka event (simplified)
        // In real scenario, use KafkaListener test consumer
    }
}
```

### Integration Testing Strategies

#### 1. **Database Integration**
```java
@DataJpaTest
@AutoConfigureTestDatabase(replace = Replace.NONE)
class OrderRepositoryTest {
    @Autowired
    private OrderRepository orderRepository;
    
    @Test
    void shouldFindOrdersByStatus() {
        // Test actual database queries
    }
}
```

#### 2. **Message Queue Integration**
```java
@SpringBootTest
@EmbeddedKafka
class OrderEventPublisherTest {
    @Test
    void shouldPublishOrderCreatedEvent() {
        // Test Kafka publishing
    }
}
```

#### 3. **HTTP Client Integration**
```java
@SpringBootTest(webEnvironment = WebEnvironment.RANDOM_PORT)
class OrderControllerIntegrationTest {
    @Autowired
    private TestRestTemplate restTemplate;
    
    @Test
    void shouldCreateOrderViaApi() {
        ResponseEntity<Order> response = restTemplate.postForEntity(
            "/api/orders", 
            new OrderRequest("PROD-123", 5), 
            Order.class);
        
        assertEquals(HttpStatus.CREATED, response.getStatusCode());
    }
}
```

---

## Contract Testing

### Why Contract Testing?

**Problem**: Provider changes API → Consumer breaks

**Solution**: Contract testing ensures compatibility

### Consumer-Driven Contracts (CDC)

#### Using Pact

**Consumer Side (Order Service)**
```java
@ExtendWith(PactConsumerTestExt.class)
@PactTestFor(providerName = "inventory-service")
class InventoryClientPactTest {
    
    @Pact(consumer = "order-service")
    public RequestResponsePact checkStockPact(PactDslWithProvider builder) {
        return builder
            .given("product PROD-123 exists with stock 10")
            .uponReceiving("a request to check stock")
            .path("/api/inventory/PROD-123")
            .method("GET")
            .willRespondWith()
            .status(200)
            .body(new PactDslJsonBody()
                .stringValue("productId", "PROD-123")
                .booleanValue("available", true)
                .integerType("quantity", 10))
            .toPact();
    }
    
    @Test
    @PactTestFor(pactMethod = "checkStockPact")
    void testCheckStock(MockServer mockServer) {
        InventoryClient client = new InventoryClient(mockServer.getUrl());
        StockResponse response = client.checkStock("PROD-123");
        
        assertTrue(response.isAvailable());
        assertEquals(10, response.getQuantity());
    }
}
```

**Provider Side (Inventory Service)**
```java
@Provider("inventory-service")
@PactBroker
@SpringBootTest(webEnvironment = WebEnvironment.RANDOM_PORT)
class InventoryProviderPactTest {
    
    @LocalServerPort
    private int port;
    
    @BeforeEach
    void setup(PactVerificationContext context) {
        context.setTarget(new HttpTestTarget("localhost", port));
    }
    
    @TestTemplate
    @ExtendWith(PactVerificationInvocationContextProvider.class)
    void pactVerificationTestTemplate(PactVerificationContext context) {
        context.verifyInteraction();
    }
    
    @State("product PROD-123 exists with stock 10")
    void productExists() {
        // Setup test data
        inventoryRepository.save(new Inventory("PROD-123", 10));
    }
}
```

### Contract Testing Benefits
- Early detection of breaking changes
- Documentation of service contracts
- Enables independent service deployment
- Reduces need for integration tests

---

## Component Testing

### Concept
Test entire service as a black box with mocked external dependencies.

### Example with WireMock

```java
@SpringBootTest(webEnvironment = WebEnvironment.RANDOM_PORT)
@AutoConfigureWireMock(port = 0)
class OrderServiceComponentTest {
    
    @Autowired
    private TestRestTemplate restTemplate;
    
    @Test
    void shouldCreateOrderSuccessfully() {
        // Mock external inventory service
        stubFor(get(urlEqualTo("/api/inventory/PROD-123"))
            .willReturn(aResponse()
                .withStatus(200)
                .withHeader("Content-Type", "application/json")
                .withBody("""
                    {
                        "productId": "PROD-123",
                        "available": true,
                        "quantity": 10
                    }
                    """)));
        
        // Mock payment service
        stubFor(post(urlEqualTo("/api/payments"))
            .willReturn(aResponse()
                .withStatus(200)
                .withBody("""
                    {
                        "paymentId": "PAY-001",
                        "status": "SUCCESS"
                    }
                    """)));
        
        // Test order creation flow
        OrderRequest request = new OrderRequest("PROD-123", 5, "CARD-123");
        ResponseEntity<Order> response = restTemplate.postForEntity(
            "/api/orders", request, Order.class);
        
        assertEquals(HttpStatus.CREATED, response.getStatusCode());
        assertNotNull(response.getBody().getId());
        
        // Verify external calls
        verify(getRequestedFor(urlEqualTo("/api/inventory/PROD-123")));
        verify(postRequestedFor(urlEqualTo("/api/payments")));
    }
}
```

---

## End-to-End Testing

### Characteristics
- Test complete user journeys
- All services running
- Most expensive and brittle
- Focus on critical paths only

### Example (REST Assured)

```java
@SpringBootTest
class OrderE2ETest {
    
    @Test
    void completeOrderJourney() {
        // 1. Create order
        String orderId = given()
            .contentType("application/json")
            .body("""
                {
                    "productId": "PROD-123",
                    "quantity": 2,
                    "customerId": "CUST-001"
                }
                """)
            .when()
            .post("/api/orders")
            .then()
            .statusCode(201)
            .extract()
            .path("id");
        
        // 2. Verify order status
        given()
            .when()
            .get("/api/orders/" + orderId)
            .then()
            .statusCode(200)
            .body("status", equalTo("PENDING"));
        
        // 3. Process payment
        given()
            .contentType("application/json")
            .body("""
                {
                    "orderId": "%s",
                    "amount": 100.00,
                    "cardToken": "tok_visa"
                }
                """.formatted(orderId))
            .when()
            .post("/api/payments")
            .then()
            .statusCode(200);
        
        // 4. Verify order confirmed
        await().atMost(5, SECONDS).until(() ->
            get("/api/orders/" + orderId)
                .then()
                .extract()
                .path("status")
                .equals("CONFIRMED")
        );
        
        // 5. Verify inventory reduced
        given()
            .when()
            .get("/api/inventory/PROD-123")
            .then()
            .statusCode(200)
            .body("quantity", lessThan(10));
    }
}
```

### E2E Testing Best Practices
- Run in production-like environment
- Use test data management
- Implement proper cleanup
- Run selectively (smoke tests)
- Consider synthetic monitoring

---

## Performance Testing

### Types of Performance Tests

#### 1. **Load Testing**
Test system under expected load

#### 2. **Stress Testing**
Test system beyond capacity

#### 3. **Spike Testing**
Test sudden load increases

#### 4. **Soak Testing**
Test sustained load over time

### Example (Gatling)

```scala
class OrderServiceLoadTest extends Simulation {
  
  val httpProtocol = http
    .baseUrl("http://localhost:8080")
    .acceptHeader("application/json")
  
  val scn = scenario("Create Orders")
    .exec(http("Create Order")
      .post("/api/orders")
      .body(StringBody("""
        {
          "productId": "PROD-${randomProduct}",
          "quantity": ${randomQuantity},
          "customerId": "CUST-${randomCustomer}"
        }
      """))
      .check(status.is(201))
      .check(jsonPath("$.id").saveAs("orderId"))
    )
    .pause(1)
    .exec(http("Get Order")
      .get("/api/orders/${orderId}")
      .check(status.is(200))
    )
  
  setUp(
    scn.inject(
      rampUsersPerSec(10) to 100 during (60 seconds),
      constantUsersPerSec(100) during (300 seconds)
    )
  ).protocols(httpProtocol)
   .assertions(
     global.responseTime.percentile3.lt(1000),
     global.successfulRequests.percent.gt(95)
   )
}
```

### Example (JMeter with Java API)

```java
public class OrderServicePerformanceTest {
    
    @Test
    void loadTest() throws IOException {
        StandardJMeterEngine jmeter = new StandardJMeterEngine();
        
        // Test plan
        TestPlan testPlan = new TestPlan("Order Service Load Test");
        
        // Thread group
        ThreadGroup threadGroup = new ThreadGroup();
        threadGroup.setNumThreads(100);
        threadGroup.setRampUp(60);
        threadGroup.setDuration(300);
        
        // HTTP sampler
        HTTPSamplerProxy httpSampler = new HTTPSamplerProxy();
        httpSampler.setDomain("localhost");
        httpSampler.setPort(8080);
        httpSampler.setPath("/api/orders");
        httpSampler.setMethod("POST");
        httpSampler.addNonEncodedArgument("", """
            {
                "productId": "PROD-123",
                "quantity": 2
            }
            """, "");
        
        // Add listeners
        ResultCollector resultCollector = new ResultCollector();
        
        // Build test plan hierarchy
        HashTree testPlanTree = new HashTree();
        testPlanTree.add(testPlan);
        HashTree threadGroupTree = testPlanTree.add(testPlan, threadGroup);
        threadGroupTree.add(httpSampler);
        threadGroupTree.add(resultCollector);
        
        // Run test
        jmeter.configure(testPlanTree);
        jmeter.run();
        
        // Assert results
        // Analyze resultCollector data
    }
}
```

---

## Chaos Engineering

### Principles
1. Build hypothesis around steady state
2. Vary real-world events
3. Run experiments in production
4. Automate to run continuously
5. Minimize blast radius

### Example (Chaos Monkey for Spring Boot)

```yaml
# application.yml
chaos:
  monkey:
    enabled: true
    watcher:
      controller: true
      restController: true
      service: true
      repository: true
    assaults:
      level: 5
      latencyActive: true
      latencyRangeStart: 1000
      latencyRangeEnd: 3000
      exceptionsActive: true
      killApplicationActive: false
```

### Example (Toxiproxy)

```java
@Test
void shouldHandleNetworkLatency() throws IOException {
    ToxiproxyClient toxiproxy = new ToxiproxyClient();
    Proxy proxy = toxiproxy.createProxy(
        "inventory-service", 
        "localhost:18080", 
        "localhost:8081"
    );
    
    // Add latency
    proxy.toxics()
        .latency("latency", ToxicDirection.DOWNSTREAM, 2000);
    
    // Test order service with slow inventory service
    OrderRequest request = new OrderRequest("PROD-123", 5);
    
    assertTimeout(Duration.ofSeconds(5), () -> {
        Order order = orderService.createOrder(request);
        assertNotNull(order);
    });
    
    // Remove proxy
    proxy.delete();
}
```

### Resilience Testing Scenarios
- Service unavailability
- Network latency/packet loss
- Database connection pool exhaustion
- Circuit breaker activation
- Cascading failures
- Resource exhaustion (CPU, memory)

---

## Testing Tools and Frameworks

### Unit Testing
- **JUnit 5**: Standard Java testing
- **Mockito**: Mocking framework
- **AssertJ**: Fluent assertions
- **Jest**: JavaScript testing
- **pytest**: Python testing

### Integration Testing
- **TestContainers**: Docker containers for testing
- **Embedded Databases**: H2, HSQLDB
- **WireMock**: HTTP API mocking
- **MockServer**: Advanced request/response mocking

### Contract Testing
- **Pact**: Consumer-driven contracts
- **Spring Cloud Contract**: Contract testing for Spring
- **Postman**: API contract testing

### E2E Testing
- **REST Assured**: REST API testing
- **Selenium**: Browser automation
- **Cypress**: Modern web testing
- **Playwright**: Cross-browser testing

### Performance Testing
- **Gatling**: Scala-based load testing
- **JMeter**: Apache performance testing
- **k6**: Modern load testing
- **Artillery**: Node.js load testing

### Chaos Engineering
- **Chaos Monkey**: Netflix's chaos tool
- **Toxiproxy**: Network condition simulation
- **Gremlin**: Chaos engineering platform
- **Chaos Mesh**: Kubernetes chaos testing

---

## Best Practices

### 1. **Test Pyramid Balance**
- 70% unit tests (fast, cheap, many)
- 20% contract/integration tests
- 10% E2E tests (slow, expensive, few)

### 2. **Test Isolation**
- Each test independent
- No shared state
- Clean up after tests
- Use unique test data

### 3. **Test Data Management**
```java
@BeforeEach
void setup() {
    // Clean database
    orderRepository.deleteAll();
    
    // Insert test data
    testDataBuilder.createProduct("PROD-123", 100);
    testDataBuilder.createCustomer("CUST-001");
}
```

### 4. **Environment Parity**
- Test in production-like environments
- Use containers for consistency
- Manage configuration externally
- Version test dependencies

### 5. **Continuous Testing**
```yaml
# CI/CD Pipeline
stages:
  - build
  - unit-test
  - integration-test
  - contract-test
  - deploy-staging
  - e2e-test
  - performance-test
  - deploy-production
  - smoke-test
```

### 6. **Test Observability**
- Log test execution
- Capture screenshots/videos
- Monitor test metrics
- Track flaky tests

### 7. **Service Virtualization**
- Mock expensive external services
- Use service stubs for unavailable dependencies
- Implement contract-based mocks

### 8. **Test Coverage Guidelines**
- Unit tests: >80% code coverage
- Integration tests: Critical paths
- Contract tests: All service interfaces
- E2E tests: Core user journeys only

### 9. **Failure Handling**
```java
@Test
void shouldRetryOnTransientFailure() {
    // Configure retry mechanism
    when(inventoryClient.checkStock(any()))
        .thenThrow(new ConnectException())
        .thenThrow(new ConnectException())
        .thenReturn(new StockResponse(true, 10));
    
    Order order = orderService.createOrder(request);
    
    assertNotNull(order);
    verify(inventoryClient, times(3)).checkStock(any());
}
```

### 10. **Test Documentation**
- Document test scenarios
- Maintain test data catalog
- Create runbooks for test failures
- Share testing patterns

---

## Testing Strategy Example

### Order Service Testing Strategy

#### Unit Tests (70%)
- `OrderService` business logic
- `OrderValidator` validation rules
- `OrderMapper` transformations
- `PriceCalculator` computations

#### Integration Tests (15%)
- Database operations
- Kafka event publishing
- External API clients
- Cache interactions

#### Contract Tests (10%)
- Inventory service API contract
- Payment service API contract
- Notification service message contract

#### E2E Tests (5%)
- Complete order creation flow
- Order cancellation flow
- Refund processing flow

---

## Summary

Testing microservices requires a multi-layered approach:

1. **Strong unit testing foundation** (fast feedback)
2. **Contract testing for service boundaries** (prevents breaking changes)
3. **Selective integration testing** (validates key interactions)
4. **Minimal E2E testing** (critical user journeys only)
5. **Continuous performance testing** (catch regressions early)
6. **Chaos engineering** (build resilient systems)

**Key Takeaway**: Shift testing left, automate everything, and focus on fast feedback loops while maintaining confidence in your distributed system.
