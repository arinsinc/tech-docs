# Spring MVC (Model-View-Controller)

## Table of Contents
- [What is Spring MVC?](#what-is-spring-mvc)
- [Spring MVC Request Flow](#spring-mvc-request-flow)
- [Controllers](#controllers)
- [Request Mapping](#request-mapping)
- [Request Parameters](#request-parameters)
- [Model and View](#model-and-view)
- [Interceptors vs Filters](#interceptors-vs-filters)
- [Exception Handling](#exception-handling)

---

## What is Spring MVC?

**Spring MVC** is a web framework built on the Servlet API for building web applications. It follows the Model-View-Controller design pattern.

### MVC Pattern

```
┌──────────────────────────────────────────────┐
│                   Browser                     │
└──────────────┬───────────────────────────────┘
               │ HTTP Request
               ↓
┌──────────────────────────────────────────────┐
│              CONTROLLER                       │
│  - Receives request                          │
│  - Processes input                           │
│  - Calls business logic                      │
└──────────────┬───────────────────────────────┘
               │
               ↓
┌──────────────────────────────────────────────┐
│               MODEL                          │
│  - Business logic                            │
│  - Data processing                           │
│  - Database interaction                      │
└──────────────┬───────────────────────────────┘
               │
               ↓
┌──────────────────────────────────────────────┐
│                VIEW                          │
│  - Renders data                              │
│  - Presents to user                          │
│  - HTML/JSON/XML                             │
└──────────────┬───────────────────────────────┘
               │ HTTP Response
               ↓
          Browser
```

### Key Components

1. **DispatcherServlet**: Front controller
2. **HandlerMapping**: Maps requests to controllers
3. **Controller**: Handles requests
4. **ModelAndView**: Contains model data and view name
5. **ViewResolver**: Resolves view names to actual views
6. **View**: Renders the response

---

## Spring MVC Request Flow

### Detailed Flow Diagram

```
1. Client Request
   ↓
2. DispatcherServlet (Front Controller)
   ↓
3. HandlerMapping (Find controller)
   ↓
4. HandlerAdapter (Execute controller)
   ↓
5. Controller (Process request)
   ↓
6. Service Layer (Business logic)
   ↓
7. Repository Layer (Database)
   ↓
8. Controller returns ModelAndView
   ↓
9. ViewResolver (Find view)
   ↓
10. View (Render response)
    ↓
11. Response to Client
```

### Step-by-Step Example

```java
// 1. Client makes request: GET /users/123

// 2. DispatcherServlet receives request
public class DispatcherServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) {
        // 3. HandlerMapping finds the right controller
        HandlerExecutionChain chain = handlerMapping.getHandler(request);
        
        // 4. HandlerAdapter executes the controller method
        ModelAndView mv = handlerAdapter.handle(request, response, chain.getHandler());
        
        // 9. ViewResolver resolves the view name
        View view = viewResolver.resolveViewName(mv.getViewName());
        
        // 10. View renders the response
        view.render(mv.getModel(), request, response);
    }
}

// 5. Controller processes the request
@Controller
public class UserController {
    @GetMapping("/users/{id}")
    public String getUser(@PathVariable Long id, Model model) {
        // 6. Call service layer
        User user = userService.findById(id);
        
        // 8. Add data to model and return view name
        model.addAttribute("user", user);
        return "user-details"; // View name
    }
}

// 6-7. Service and Repository
@Service
public class UserService {
    @Autowired
    private UserRepository userRepository;
    
    public User findById(Long id) {
        return userRepository.findById(id).orElseThrow();
    }
}

// 10. View (user-details.html) renders the response
// <!DOCTYPE html>
// <html>
// <body>
//     <h1>User: ${user.name}</h1>
// </body>
// </html>
```

### Configuration

**Java Configuration:**
```java
@Configuration
@EnableWebMvc
@ComponentScan(basePackages = "com.example")
public class WebConfig implements WebMvcConfigurer {
    
    @Bean
    public ViewResolver viewResolver() {
        InternalResourceViewResolver resolver = new InternalResourceViewResolver();
        resolver.setPrefix("/WEB-INF/views/");
        resolver.setSuffix(".jsp");
        return resolver;
    }
    
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/static/**")
                .addResourceLocations("/static/");
    }
    
    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(new LoggingInterceptor());
    }
}
```

**Spring Boot Auto-Configuration:**
```java
@SpringBootApplication
public class Application {
    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }
}
// That's it! Spring Boot auto-configures everything
```

---

## Controllers

### @Controller

For traditional web applications returning views.

```java
@Controller
@RequestMapping("/users")
public class UserController {
    
    @Autowired
    private UserService userService;
    
    // Returns view name
    @GetMapping("/{id}")
    public String getUser(@PathVariable Long id, Model model) {
        User user = userService.findById(id);
        model.addAttribute("user", user);
        return "user-details"; // Resolves to view
    }
    
    // Returns ModelAndView
    @GetMapping("/list")
    public ModelAndView listUsers() {
        List<User> users = userService.findAll();
        ModelAndView mav = new ModelAndView("user-list");
        mav.addObject("users", users);
        return mav;
    }
    
    // Handle form submission
    @PostMapping("/create")
    public String createUser(@ModelAttribute User user, RedirectAttributes redirectAttributes) {
        User savedUser = userService.save(user);
        redirectAttributes.addFlashAttribute("message", "User created successfully");
        return "redirect:/users/" + savedUser.getId();
    }
}
```

### @RestController

For RESTful APIs returning data (JSON/XML).

```java
@RestController
@RequestMapping("/api/users")
public class UserRestController {
    
    @Autowired
    private UserService userService;
    
    // Returns User object (automatically converted to JSON)
    @GetMapping("/{id}")
    public User getUser(@PathVariable Long id) {
        return userService.findById(id);
    }
    
    // Returns ResponseEntity with status and headers
    @PostMapping
    public ResponseEntity<User> createUser(@RequestBody User user) {
        User savedUser = userService.save(user);
        return ResponseEntity
                .status(HttpStatus.CREATED)
                .header("Location", "/api/users/" + savedUser.getId())
                .body(savedUser);
    }
    
    // Returns list
    @GetMapping
    public List<User> getAllUsers() {
        return userService.findAll();
    }
    
    // Returns custom response
    @GetMapping("/search")
    public ResponseEntity<ApiResponse<List<User>>> searchUsers(@RequestParam String keyword) {
        List<User> users = userService.search(keyword);
        ApiResponse<List<User>> response = new ApiResponse<>(
            "success",
            users,
            "Found " + users.size() + " users"
        );
        return ResponseEntity.ok(response);
    }
}
```

**@RestController = @Controller + @ResponseBody**

```java
// These are equivalent:

// Option 1: @RestController
@RestController
public class UserController {
    @GetMapping("/users/{id}")
    public User getUser(@PathVariable Long id) {
        return userService.findById(id);
    }
}

// Option 2: @Controller + @ResponseBody on each method
@Controller
public class UserController {
    @GetMapping("/users/{id}")
    @ResponseBody
    public User getUser(@PathVariable Long id) {
        return userService.findById(id);
    }
}
```

### ResponseEntity

Full control over HTTP response.

```java
@RestController
@RequestMapping("/api/products")
public class ProductController {
    
    // Success response
    @GetMapping("/{id}")
    public ResponseEntity<Product> getProduct(@PathVariable Long id) {
        return productService.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }
    
    // Created response with location header
    @PostMapping
    public ResponseEntity<Product> createProduct(@RequestBody Product product) {
        Product saved = productService.save(product);
        URI location = URI.create("/api/products/" + saved.getId());
        return ResponseEntity.created(location).body(saved);
    }
    
    // No content response
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteProduct(@PathVariable Long id) {
        productService.deleteById(id);
        return ResponseEntity.noContent().build();
    }
    
    // Custom headers
    @GetMapping("/{id}/download")
    public ResponseEntity<byte[]> downloadProduct(@PathVariable Long id) {
        byte[] data = productService.getProductData(id);
        
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_PDF);
        headers.setContentDispositionFormData("attachment", "product.pdf");
        
        return ResponseEntity.ok()
                .headers(headers)
                .body(data);
    }
    
    // Conditional response
    @GetMapping("/{id}/check")
    public ResponseEntity<String> checkProduct(@PathVariable Long id) {
        boolean exists = productService.exists(id);
        
        if (exists) {
            return ResponseEntity.ok("Product exists");
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body("Product not found");
        }
    }
}
```

---

## Request Mapping

### @RequestMapping

Generic mapping annotation.

```java
@Controller
@RequestMapping("/products")
public class ProductController {
    
    // GET /products
    @RequestMapping(method = RequestMethod.GET)
    public String list() {
        return "product-list";
    }
    
    // POST /products
    @RequestMapping(method = RequestMethod.POST)
    public String create(@ModelAttribute Product product) {
        productService.save(product);
        return "redirect:/products";
    }
    
    // Multiple methods
    @RequestMapping(value = "/search", method = {RequestMethod.GET, RequestMethod.POST})
    public String search() {
        return "search-results";
    }
    
    // Multiple paths
    @RequestMapping(value = {"/", "/home", "/index"})
    public String home() {
        return "home";
    }
    
    // With params
    @RequestMapping(value = "/filter", params = "type=premium")
    public String filterPremium() {
        return "premium-products";
    }
    
    // With headers
    @RequestMapping(value = "/api", headers = "X-API-Version=1")
    public String apiV1() {
        return "api-v1";
    }
    
    // With consumes (Content-Type)
    @RequestMapping(
        value = "/upload",
        method = RequestMethod.POST,
        consumes = MediaType.MULTIPART_FORM_DATA_VALUE
    )
    public String upload(@RequestParam("file") MultipartFile file) {
        return "upload-success";
    }
    
    // With produces (Accept header)
    @RequestMapping(
        value = "/data",
        method = RequestMethod.GET,
        produces = MediaType.APPLICATION_JSON_VALUE
    )
    @ResponseBody
    public List<Product> getData() {
        return productService.findAll();
    }
}
```

### Specialized Annotations

```java
@RestController
@RequestMapping("/api/users")
public class UserController {
    
    // GET - Retrieve
    @GetMapping("/{id}")
    public User getUser(@PathVariable Long id) {
        return userService.findById(id);
    }
    
    @GetMapping
    public List<User> getAllUsers() {
        return userService.findAll();
    }
    
    // POST - Create
    @PostMapping
    public ResponseEntity<User> createUser(@RequestBody User user) {
        User saved = userService.save(user);
        return ResponseEntity.status(HttpStatus.CREATED).body(saved);
    }
    
    // PUT - Update (full)
    @PutMapping("/{id}")
    public User updateUser(@PathVariable Long id, @RequestBody User user) {
        user.setId(id);
        return userService.update(user);
    }
    
    // PATCH - Update (partial)
    @PatchMapping("/{id}")
    public User partialUpdate(@PathVariable Long id, @RequestBody Map<String, Object> updates) {
        return userService.partialUpdate(id, updates);
    }
    
    // DELETE - Remove
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteUser(@PathVariable Long id) {
        userService.deleteById(id);
        return ResponseEntity.noContent().build();
    }
}
```

### Path Patterns

```java
@RestController
public class PatternController {
    
    // Exact match
    @GetMapping("/users/profile")
    public String exactMatch() { }
    
    // Path variable
    @GetMapping("/users/{id}")
    public User pathVariable(@PathVariable Long id) { }
    
    // Multiple path variables
    @GetMapping("/users/{userId}/orders/{orderId}")
    public Order multipleVariables(
        @PathVariable Long userId,
        @PathVariable Long orderId
    ) { }
    
    // Path variable with regex
    @GetMapping("/users/{id:[0-9]+}")
    public User numericId(@PathVariable Long id) { }
    
    @GetMapping("/files/{filename:.+}")
    public File fileWithExtension(@PathVariable String filename) { }
    
    // Wildcard - single level
    @GetMapping("/resources/*/info")
    public String singleLevelWildcard() { }
    
    // Wildcard - multiple levels
    @GetMapping("/files/**")
    public String multipleLevelWildcard() { }
    
    // Ant-style patterns
    @GetMapping("/images/*.jpg")
    public String jpgFiles() { }
    
    // Optional path variable (Spring 5.3+)
    @GetMapping({"/users", "/users/{id}"})
    public String optionalId(@PathVariable(required = false) Long id) { }
}
```

---

## Request Parameters

### @PathVariable

Extract values from URI path.

```java
@RestController
@RequestMapping("/api")
public class PathController {
    
    // Simple path variable
    @GetMapping("/users/{id}")
    public User getUser(@PathVariable Long id) {
        return userService.findById(id);
    }
    
    // Multiple path variables
    @GetMapping("/users/{userId}/posts/{postId}")
    public Post getUserPost(
        @PathVariable Long userId,
        @PathVariable Long postId
    ) {
        return postService.findByUserAndId(userId, postId);
    }
    
    // Custom variable name
    @GetMapping("/articles/{article-id}")
    public Article getArticle(@PathVariable("article-id") Long articleId) {
        return articleService.findById(articleId);
    }
    
    // Optional path variable
    @GetMapping({"/products", "/products/{category}"})
    public List<Product> getProducts(
        @PathVariable(required = false) String category
    ) {
        return category != null 
            ? productService.findByCategory(category)
            : productService.findAll();
    }
    
    // Map all path variables
    @GetMapping("/data/{var1}/{var2}")
    public String getAllVars(@PathVariable Map<String, String> pathVars) {
        return "var1=" + pathVars.get("var1") + ", var2=" + pathVars.get("var2");
    }
}
```

### @RequestParam

Extract query parameters.

```java
@RestController
@RequestMapping("/api/search")
public class SearchController {
    
    // Simple parameter: /search?keyword=java
    @GetMapping
    public List<Product> search(@RequestParam String keyword) {
        return productService.search(keyword);
    }
    
    // Optional parameter with default
    @GetMapping("/products")
    public List<Product> getProducts(
        @RequestParam(required = false, defaultValue = "0") int page,
        @RequestParam(required = false, defaultValue = "10") int size
    ) {
        return productService.findAll(page, size);
    }
    
    // Custom parameter name
    @GetMapping("/filter")
    public List<Product> filter(
        @RequestParam("min-price") BigDecimal minPrice,
        @RequestParam("max-price") BigDecimal maxPrice
    ) {
        return productService.findByPriceRange(minPrice, maxPrice);
    }
    
    // Multiple values: /search?tags=java&tags=spring&tags=boot
    @GetMapping("/tags")
    public List<Product> searchByTags(@RequestParam List<String> tags) {
        return productService.findByTags(tags);
    }
    
    // Map all parameters
    @GetMapping("/advanced")
    public List<Product> advancedSearch(@RequestParam Map<String, String> params) {
        return productService.advancedSearch(params);
    }
    
    // MultiValueMap for duplicate keys
    @GetMapping("/multi")
    public String multiSearch(@RequestParam MultiValueMap<String, String> params) {
        List<String> categories = params.get("category");
        return "Categories: " + categories;
    }
}
```

### @RequestBody

Bind HTTP request body to object.

```java
@RestController
@RequestMapping("/api/users")
public class UserController {
    
    // JSON request body
    @PostMapping
    public ResponseEntity<User> createUser(@RequestBody User user) {
        User saved = userService.save(user);
        return ResponseEntity.status(HttpStatus.CREATED).body(saved);
    }
    
    // With validation
    @PostMapping("/validated")
    public ResponseEntity<User> createValidatedUser(@Valid @RequestBody User user) {
        User saved = userService.save(user);
        return ResponseEntity.status(HttpStatus.CREATED).body(saved);
    }
    
    // DTO pattern
    @PostMapping("/register")
    public ResponseEntity<User> register(@RequestBody UserRegistrationDto dto) {
        User user = userService.register(dto);
        return ResponseEntity.status(HttpStatus.CREATED).body(user);
    }
    
    // Batch operation
    @PostMapping("/batch")
    public ResponseEntity<List<User>> createUsers(@RequestBody List<User> users) {
        List<User> saved = userService.saveAll(users);
        return ResponseEntity.status(HttpStatus.CREATED).body(saved);
    }
    
    // Generic map
    @PatchMapping("/{id}")
    public User partialUpdate(
        @PathVariable Long id,
        @RequestBody Map<String, Object> updates
    ) {
        return userService.partialUpdate(id, updates);
    }
}

// Request example:
// POST /api/users
// Content-Type: application/json
// {
//   "name": "John Doe",
//   "email": "john@example.com",
//   "age": 30
// }
```

### @RequestHeader

Access HTTP headers.

```java
@RestController
public class HeaderController {
    
    // Simple header
    @GetMapping("/api/data")
    public String getData(@RequestHeader("Authorization") String token) {
        return "Token: " + token;
    }
    
    // Optional header with default
    @GetMapping("/api/info")
    public String getInfo(
        @RequestHeader(value = "User-Agent", defaultValue = "unknown") String userAgent
    ) {
        return "User-Agent: " + userAgent;
    }
    
    // Multiple headers
    @GetMapping("/api/check")
    public String checkHeaders(
        @RequestHeader("X-API-Key") String apiKey,
        @RequestHeader("X-Request-ID") String requestId
    ) {
        return "API Key: " + apiKey + ", Request ID: " + requestId;
    }
    
    // All headers as map
    @GetMapping("/api/headers")
    public Map<String, String> getAllHeaders(@RequestHeader Map<String, String> headers) {
        return headers;
    }
    
    // HttpHeaders object
    @GetMapping("/api/headers-obj")
    public String getHeadersObj(@RequestHeader HttpHeaders headers) {
        return "Content-Type: " + headers.getContentType();
    }
}
```

### @CookieValue

Access cookies.

```java
@RestController
public class CookieController {
    
    @GetMapping("/welcome")
    public String welcome(@CookieValue("session-id") String sessionId) {
        return "Session ID: " + sessionId;
    }
    
    @GetMapping("/user-pref")
    public String getUserPreference(
        @CookieValue(value = "theme", defaultValue = "light") String theme
    ) {
        return "Theme: " + theme;
    }
}
```

### @ModelAttribute

Bind form data or query parameters to object.

```java
@Controller
@RequestMapping("/users")
public class UserFormController {
    
    // Form submission
    @PostMapping("/create")
    public String createUser(@ModelAttribute User user, RedirectAttributes redirectAttributes) {
        userService.save(user);
        redirectAttributes.addFlashAttribute("message", "User created");
        return "redirect:/users/list";
    }
    
    // With validation
    @PostMapping("/register")
    public String register(
        @Valid @ModelAttribute("registrationForm") UserRegistrationForm form,
        BindingResult result,
        Model model
    ) {
        if (result.hasErrors()) {
            return "registration-form";
        }
        userService.register(form);
        return "redirect:/login";
    }
    
    // Query parameters to object
    @GetMapping("/search")
    public String search(@ModelAttribute SearchCriteria criteria, Model model) {
        List<User> users = userService.search(criteria);
        model.addAttribute("users", users);
        return "search-results";
    }
    
    // Global model attribute (available to all methods)
    @ModelAttribute("countries")
    public List<String> populateCountries() {
        return Arrays.asList("USA", "UK", "Canada", "Australia");
    }
}

// HTML Form:
// <form action="/users/create" method="post">
//     <input type="text" name="name" />
//     <input type="email" name="email" />
//     <input type="number" name="age" />
//     <button type="submit">Create</button>
// </form>
```

### @RequestPart

For multipart requests.

```java
@RestController
@RequestMapping("/api/files")
public class FileUploadController {
    
    @PostMapping("/upload")
    public ResponseEntity<String> uploadFile(
        @RequestPart("file") MultipartFile file,
        @RequestPart("metadata") FileMetadata metadata
    ) {
        String fileId = fileService.save(file, metadata);
        return ResponseEntity.ok("File uploaded: " + fileId);
    }
    
    @PostMapping("/upload-multiple")
    public ResponseEntity<List<String>> uploadMultiple(
        @RequestPart("files") List<MultipartFile> files,
        @RequestPart("description") String description
    ) {
        List<String> fileIds = fileService.saveAll(files, description);
        return ResponseEntity.ok(fileIds);
    }
}
```

---

## Model and View

### Model

```java
@Controller
public class ProductController {
    
    // Using Model interface
    @GetMapping("/products/{id}")
    public String getProduct(@PathVariable Long id, Model model) {
        Product product = productService.findById(id);
        model.addAttribute("product", product);
        model.addAttribute("categories", categoryService.findAll());
        return "product-details";
    }
    
    // Using ModelMap
    @GetMapping("/products/list")
    public String listProducts(ModelMap model) {
        model.addAttribute("products", productService.findAll());
        model.addAttribute("totalCount", productService.count());
        return "product-list";
    }
    
    // Using Map
    @GetMapping("/products/search")
    public String searchProducts(@RequestParam String keyword, Map<String, Object> model) {
        model.put("results", productService.search(keyword));
        model.put("keyword", keyword);
        return "search-results";
    }
    
    // Return model directly
    @GetMapping("/products/featured")
    public String featuredProducts(Model model) {
        List<Product> featured = productService.findFeatured();
        model.addAttribute("featuredProducts", featured);
        
        // Attribute name inferred from type
        model.addAttribute(new Category("Electronics"));
        // Available as "category" in view
        
        return "featured";
    }
}
```

### ModelAndView

```java
@Controller
public class OrderController {
    
    // Basic ModelAndView
    @GetMapping("/orders/{id}")
    public ModelAndView getOrder(@PathVariable Long id) {
        Order order = orderService.findById(id);
        
        ModelAndView mav = new ModelAndView("order-details");
        mav.addObject("order", order);
        mav.addObject("items", order.getItems());
        return mav;
    }
    
    // With status
    @GetMapping("/orders/{id}/invoice")
    public ModelAndView getInvoice(@PathVariable Long id, HttpServletResponse response) {
        Order order = orderService.findById(id);
        
        if (order == null) {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            return new ModelAndView("error/404");
        }
        
        ModelAndView mav = new ModelAndView("invoice");
        mav.addObject("order", order);
        return mav;
    }
    
    // Redirect
    @PostMapping("/orders")
    public ModelAndView createOrder(@ModelAttribute Order order) {
        Order saved = orderService.save(order);
        return new ModelAndView("redirect:/orders/" + saved.getId());
    }
    
    // Forward
    @GetMapping("/orders/latest")
    public ModelAndView getLatest() {
        Order latest = orderService.findLatest();
        return new ModelAndView("forward:/orders/" + latest.getId());
    }
}
```

### RedirectAttributes

```java
@Controller
public class UserController {
    
    @PostMapping("/users")
    public String createUser(@ModelAttribute User user, RedirectAttributes redirectAttributes) {
        try {
            User saved = userService.save(user);
            
            // Flash attribute (temporary, survives redirect)
            redirectAttributes.addFlashAttribute("message", "User created successfully");
            redirectAttributes.addFlashAttribute("messageType", "success");
            
            // URL parameter (visible in URL)
            redirectAttributes.addAttribute("id", saved.getId());
            
            return "redirect:/users/{id}";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/users/new";
        }
    }
    
    @GetMapping("/users/{id}")
    public String getUser(@PathVariable Long id, Model model) {
        // Flash attributes automatically added to model
        // "message" and "messageType" available here
        
        User user = userService.findById(id);
        model.addAttribute("user", user);
        return "user-details";
    }
}
```

### View Resolution

```java
@Configuration
public class WebConfig implements WebMvcConfigurer {
    
    // JSP View Resolver
    @Bean
    public ViewResolver jspViewResolver() {
        InternalResourceViewResolver resolver = new InternalResourceViewResolver();
        resolver.setPrefix("/WEB-INF/views/");
        resolver.setSuffix(".jsp");
        resolver.setViewNames("jsp/*");
        resolver.setOrder(1);
        return resolver;
    }
    
    // Thymeleaf View Resolver
    @Bean
    public ViewResolver thymeleafViewResolver() {
        ThymeleafViewResolver resolver = new ThymeleafViewResolver();
        resolver.setTemplateEngine(templateEngine());
        resolver.setViewNames(new String[] {"thymeleaf/*"});
        resolver.setOrder(2);
        return resolver;
    }
    
    // Content Negotiation View Resolver
    @Bean
    public ViewResolver contentNegotiatingViewResolver() {
        ContentNegotiatingViewResolver resolver = new ContentNegotiatingViewResolver();
        resolver.setViewResolvers(Arrays.asList(
            jspViewResolver(),
            thymeleafViewResolver()
        ));
        resolver.setDefaultViews(Arrays.asList(
            new MappingJackson2JsonView()
        ));
        return resolver;
    }
}
```

---

## Interceptors vs Filters

### Comparison Table

| Feature | Filter | Interceptor |
|---------|--------|-------------|
| **Part of** | Servlet API | Spring MVC |
| **Scope** | All requests | Spring MVC requests only |
| **Execution** | Before/After servlet | Before/After controller |
| **Access** | Request/Response | Handler, Model, Exception |
| **Configuration** | web.xml or @WebFilter | WebMvcConfigurer |
| **Order** | @Order or web.xml | Explicit order |
| **Spring Beans** | ❌ Not by default | ✅ Full access |

### Filter Example

```java
@Component
@Order(1)
public class LoggingFilter implements Filter {
    
    private static final Logger logger = LoggerFactory.getLogger(LoggingFilter.class);
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        
        // Before processing
        logger.info("Filter: {} {}", httpRequest.getMethod(), httpRequest.getRequestURI());
        long start = System.currentTimeMillis();
        
        try {
            // Continue chain
            chain.doFilter(request, response);
        } finally {
            // After processing
            long duration = System.currentTimeMillis() - start;
            logger.info("Filter: Completed in {}ms", duration);
        }
    }
}

// Or register explicitly
@Configuration
public class FilterConfig {
    @Bean
    public FilterRegistrationBean<LoggingFilter> loggingFilter() {
        FilterRegistrationBean<LoggingFilter> registrationBean = new FilterRegistrationBean<>();
        registrationBean.setFilter(new LoggingFilter());
        registrationBean.addUrlPatterns("/api/*");
        registrationBean.setOrder(1);
        return registrationBean;
    }
}
```

### Interceptor Example

```java
@Component
public class AuthenticationInterceptor implements HandlerInterceptor {
    
    @Autowired
    private AuthenticationService authService;
    
    // Before controller execution
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
            throws Exception {
        
        String token = request.getHeader("Authorization");
        
        if (token == null || !authService.validateToken(token)) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("Unauthorized");
            return false; // Stop execution
        }
        
        // Store user in request
        User user = authService.getUserFromToken(token);
        request.setAttribute("currentUser", user);
        
        return true; // Continue execution
    }
    
    // After controller execution, before view rendering
    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response,
                          Object handler, ModelAndView modelAndView) throws Exception {
        
        if (modelAndView != null) {
            // Add common data to all views
            modelAndView.addObject("timestamp", System.currentTimeMillis());
            
            User user = (User) request.getAttribute("currentUser");
            modelAndView.addObject("currentUser", user);
        }
    }
    
    // After view rendering (cleanup)
    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response,
                               Object handler, Exception ex) throws Exception {
        
        // Cleanup resources
        // Log completion
        if (ex != null) {
            logger.error("Request failed: ", ex);
        }
    }
}

// Register interceptor
@Configuration
public class WebConfig implements WebMvcConfigurer {
    
    @Autowired
    private AuthenticationInterceptor authenticationInterceptor;
    
    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(authenticationInterceptor)
                .addPathPatterns("/api/**")
                .excludePathPatterns("/api/public/**", "/api/auth/login");
        
        registry.addInterceptor(new LoggingInterceptor())
                .addPathPatterns("/**")
                .order(1);
    }
}
```

### Multiple Interceptors

```java
@Configuration
public class WebConfig implements WebMvcConfigurer {
    
    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        // Order matters!
        
        // 1. Logging (first)
        registry.addInterceptor(new LoggingInterceptor())
                .addPathPatterns("/**")
                .order(1);
        
        // 2. Authentication
        registry.addInterceptor(new AuthenticationInterceptor())
                .addPathPatterns("/api/**")
                .excludePathPatterns("/api/public/**")
                .order(2);
        
        // 3. Authorization
        registry.addInterceptor(new AuthorizationInterceptor())
                .addPathPatterns("/api/**")
                .order(3);
        
        // 4. Performance monitoring (last)
        registry.addInterceptor(new PerformanceInterceptor())
                .addPathPatterns("/**")
                .order(4);
    }
}

// Execution order:
// Request → LoggingInterceptor.preHandle()
//        → AuthenticationInterceptor.preHandle()
//        → AuthorizationInterceptor.preHandle()
//        → PerformanceInterceptor.preHandle()
//        → Controller
//        → PerformanceInterceptor.postHandle()
//        → AuthorizationInterceptor.postHandle()
//        → AuthenticationInterceptor.postHandle()
//        → LoggingInterceptor.postHandle()
//        → View Rendering
//        → LoggingInterceptor.afterCompletion()
//        → AuthenticationInterceptor.afterCompletion()
//        → AuthorizationInterceptor.afterCompletion()
//        → PerformanceInterceptor.afterCompletion()
// Response
```

---

## Exception Handling

### @ExceptionHandler (Controller Level)

```java
@RestController
@RequestMapping("/api/users")
public class UserController {
    
    @GetMapping("/{id}")
    public User getUser(@PathVariable Long id) {
        return userService.findById(id)
                .orElseThrow(() -> new UserNotFoundException("User not found: " + id));
    }
    
    // Handle specific exception in this controller
    @ExceptionHandler(UserNotFoundException.class)
    public ResponseEntity<ErrorResponse> handleUserNotFound(UserNotFoundException ex) {
        ErrorResponse error = new ErrorResponse(
            HttpStatus.NOT_FOUND.value(),
            ex.getMessage(),
            System.currentTimeMillis()
        );
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(error);
    }
    
    @ExceptionHandler(IllegalArgumentException.class)
    public ResponseEntity<ErrorResponse> handleBadRequest(IllegalArgumentException ex) {
        ErrorResponse error = new ErrorResponse(
            HttpStatus.BAD_REQUEST.value(),
            ex.getMessage(),
            System.currentTimeMillis()
        );
        return ResponseEntity.badRequest().body(error);
    }
}
```

### @ControllerAdvice (Global)

```java
@RestControllerAdvice
public class GlobalExceptionHandler {
    
    private static final Logger logger = LoggerFactory.getLogger(GlobalExceptionHandler.class);
    
    // Specific exception
    @ExceptionHandler(UserNotFoundException.class)
    @ResponseStatus(HttpStatus.NOT_FOUND)
    public ErrorResponse handleUserNotFound(UserNotFoundException ex, WebRequest request) {
        logger.error("User not found: {}", ex.getMessage());
        return ErrorResponse.builder()
                .timestamp(LocalDateTime.now())
                .status(HttpStatus.NOT_FOUND.value())
                .error("Not Found")
                .message(ex.getMessage())
                .path(((ServletWebRequest) request).getRequest().getRequestURI())
                .build();
    }
    
    // Multiple exceptions
    @ExceptionHandler({
        DataAccessException.class,
        SQLException.class
    })
    @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
    public ErrorResponse handleDatabaseException(Exception ex) {
        logger.error("Database error", ex);
        return ErrorResponse.builder()
                .timestamp(LocalDateTime.now())
                .status(HttpStatus.INTERNAL_SERVER_ERROR.value())
                .error("Internal Server Error")
                .message("Database operation failed")
                .build();
    }
    
    // Validation errors
    @ExceptionHandler(MethodArgumentNotValidException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public ValidationErrorResponse handleValidationErrors(MethodArgumentNotValidException ex) {
        Map<String, String> errors = new HashMap<>();
        ex.getBindingResult().getFieldErrors().forEach(error -> 
            errors.put(error.getField(), error.getDefaultMessage())
        );
        
        return ValidationErrorResponse.builder()
                .timestamp(LocalDateTime.now())
                .status(HttpStatus.BAD_REQUEST.value())
                .message("Validation failed")
                .errors(errors)
                .build();
    }
    
    // Generic exception (catch-all)
    @ExceptionHandler(Exception.class)
    @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
    public ErrorResponse handleGenericException(Exception ex, WebRequest request) {
        logger.error("Unexpected error", ex);
        return ErrorResponse.builder()
                .timestamp(LocalDateTime.now())
                .status(HttpStatus.INTERNAL_SERVER_ERROR.value())
                .error("Internal Server Error")
                .message("An unexpected error occurred")
                .path(((ServletWebRequest) request).getRequest().getRequestURI())
                .build();
    }
    
    // With ResponseEntity for more control
    @ExceptionHandler(AccessDeniedException.class)
    public ResponseEntity<ErrorResponse> handleAccessDenied(AccessDeniedException ex) {
        ErrorResponse error = ErrorResponse.builder()
                .timestamp(LocalDateTime.now())
                .status(HttpStatus.FORBIDDEN.value())
                .error("Forbidden")
                .message("Access denied")
                .build();
        
        HttpHeaders headers = new HttpHeaders();
        headers.add("X-Error-Reason", "Insufficient permissions");
        
        return ResponseEntity.status(HttpStatus.FORBIDDEN)
                .headers(headers)
                .body(error);
    }
}

// Error response DTOs
@Data
@Builder
public class ErrorResponse {
    private LocalDateTime timestamp;
    private int status;
    private String error;
    private String message;
    private String path;
}

@Data
@Builder
public class ValidationErrorResponse {
    private LocalDateTime timestamp;
    private int status;
    private String message;
    private Map<String, String> errors;
}
```

### @ResponseStatus

```java
// Custom exception with status
@ResponseStatus(HttpStatus.NOT_FOUND)
public class ResourceNotFoundException extends RuntimeException {
    public ResourceNotFoundException(String message) {
        super(message);
    }
}

@ResponseStatus(HttpStatus.CONFLICT)
public class DuplicateResourceException extends RuntimeException {
    public DuplicateResourceException(String message) {
        super(message);
    }
}

// Usage
@RestController
public class ProductController {
    
    @GetMapping("/products/{id}")
    public Product getProduct(@PathVariable Long id) {
        return productRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Product not found"));
        // Automatically returns 404
    }
    
    @PostMapping("/products")
    public Product createProduct(@RequestBody Product product) {
        if (productRepository.existsByCode(product.getCode())) {
            throw new DuplicateResourceException("Product code already exists");
            // Automatically returns 409
        }
        return productRepository.save(product);
    }
}
```

### ResponseEntityExceptionHandler

```java
@RestControllerAdvice
public class CustomExceptionHandler extends ResponseEntityExceptionHandler {
    
    // Override Spring's default handlers
    
    @Override
    protected ResponseEntity<Object> handleMethodArgumentNotValid(
            MethodArgumentNotValidException ex,
            HttpHeaders headers,
            HttpStatusCode status,
            WebRequest request) {
        
        Map<String, String> errors = new HashMap<>();
        ex.getBindingResult().getFieldErrors().forEach(error ->
            errors.put(error.getField(), error.getDefaultMessage())
        );
        
        ErrorResponse errorResponse = ErrorResponse.builder()
                .timestamp(LocalDateTime.now())
                .status(status.value())
                .message("Validation failed")
                .errors(errors)
                .build();
        
        return new ResponseEntity<>(errorResponse, headers, status);
    }
    
    @Override
    protected ResponseEntity<Object> handleHttpMessageNotReadable(
            HttpMessageNotReadableException ex,
            HttpHeaders headers,
            HttpStatusCode status,
            WebRequest request) {
        
        ErrorResponse errorResponse = ErrorResponse.builder()
                .timestamp(LocalDateTime.now())
                .status(status.value())
                .message("Malformed JSON request")
                .build();
        
        return new ResponseEntity<>(errorResponse, headers, status);
    }
}
```

---

## Summary

**Key Takeaways:**

1. **Spring MVC** follows Model-View-Controller pattern
2. **DispatcherServlet** is the front controller
3. **@Controller** for views, **@RestController** for APIs
4. **@PathVariable** for URI paths, **@RequestParam** for query parameters
5. **Interceptors** have access to Spring context, **Filters** don't
6. **@ControllerAdvice** provides global exception handling
7. **Model** carries data to views
8. **ResponseEntity** gives full control over HTTP response

**Best Practices:**
- ✅ Use @RestController for REST APIs
- ✅ Use constructor injection in controllers
- ✅ Keep controllers thin (delegate to service layer)
- ✅ Use DTOs for API requests/responses
- ✅ Implement global exception handling
- ✅ Use interceptors for cross-cutting concerns
- ✅ Return proper HTTP status codes
- ✅ Validate input with @Valid

