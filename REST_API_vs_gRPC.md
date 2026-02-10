# REST API vs gRPC

## Table of Contents
- [Overview](#overview)
- [REST API](#rest-api)
- [gRPC](#grpc)
- [Key Differences](#key-differences)
- [Performance Comparison](#performance-comparison)
- [Use Cases](#use-cases)
- [Pros and Cons](#pros-and-cons)
- [Code Examples](#code-examples)
- [When to Choose What](#when-to-choose-what)

---

## Overview

REST (Representational State Transfer) and gRPC (gRPC Remote Procedure Call) are two popular approaches for building APIs and enabling communication between services.

### Quick Comparison

| Aspect | REST API | gRPC |
|--------|----------|------|
| **Protocol** | HTTP/1.1 (typically) | HTTP/2 |
| **Data Format** | JSON, XML (flexible) | Protocol Buffers (binary) |
| **Communication** | Request-Response | Request-Response, Streaming |
| **Performance** | Slower (text-based) | Faster (binary) |
| **Browser Support** | Native | Limited (needs proxy) |
| **Human Readable** | Yes | No (binary format) |
| **Code Generation** | Optional | Built-in |
| **Streaming** | Limited (SSE, WebSockets) | Native support |

---

## REST API

### What is REST?

REST is an architectural style that uses HTTP methods to perform CRUD operations on resources identified by URLs.

### Key Characteristics

1. **Stateless**: Each request contains all necessary information
2. **Resource-Based**: Everything is a resource (nouns, not verbs)
3. **HTTP Methods**: GET, POST, PUT, DELETE, PATCH
4. **Status Codes**: Standard HTTP status codes (200, 404, 500, etc.)
5. **Flexible Format**: Typically JSON, but supports XML, HTML, etc.

### REST Principles

- **Client-Server Architecture**: Separation of concerns
- **Statelessness**: No client context stored on server
- **Cacheability**: Responses can be cached
- **Layered System**: Client doesn't know if connected to end server
- **Uniform Interface**: Standardized way to interact with resources
- **Code on Demand** (optional): Server can send executable code

### Example REST Endpoints

```
GET    /api/users           # Get all users
GET    /api/users/123       # Get user by ID
POST   /api/users           # Create new user
PUT    /api/users/123       # Update user (full)
PATCH  /api/users/123       # Update user (partial)
DELETE /api/users/123       # Delete user
```

---

## gRPC

### What is gRPC?

gRPC is a high-performance, open-source RPC (Remote Procedure Call) framework developed by Google. It uses Protocol Buffers as its interface definition language.

### Key Characteristics

1. **Protocol Buffers**: Binary serialization format
2. **HTTP/2**: Multiplexing, header compression, bidirectional streaming
3. **Strongly Typed**: Strict schema definition
4. **Code Generation**: Automatic client/server code generation
5. **Multiple Languages**: Support for 10+ programming languages

### Communication Patterns

1. **Unary RPC**: Single request, single response (like REST)
2. **Server Streaming**: Single request, stream of responses
3. **Client Streaming**: Stream of requests, single response
4. **Bidirectional Streaming**: Both client and server send streams

### Protocol Buffer Definition Example

```protobuf
syntax = "proto3";

service UserService {
  rpc GetUser (GetUserRequest) returns (User);
  rpc ListUsers (ListUsersRequest) returns (stream User);
  rpc CreateUser (CreateUserRequest) returns (User);
  rpc UpdateUser (UpdateUserRequest) returns (User);
  rpc DeleteUser (DeleteUserRequest) returns (DeleteUserResponse);
}

message User {
  int32 id = 1;
  string name = 2;
  string email = 3;
  string role = 4;
}

message GetUserRequest {
  int32 id = 1;
}

message CreateUserRequest {
  string name = 1;
  string email = 2;
  string role = 3;
}
```

---

## Key Differences

### 1. Data Format

**REST**
- Text-based (JSON, XML)
- Human-readable
- Larger payload size
- Slower serialization/deserialization

**gRPC**
- Binary (Protocol Buffers)
- Not human-readable
- Smaller payload size (30-50% reduction)
- Faster serialization/deserialization (5-10x faster)

### 2. Performance

**REST**
- HTTP/1.1 (new connection per request)
- Text parsing overhead
- Larger payloads
- Good for simple CRUD operations

**gRPC**
- HTTP/2 (connection multiplexing)
- Binary format
- Smaller payloads
- Excellent for high-frequency, low-latency scenarios

### 3. Streaming

**REST**
- Limited streaming support
- Server-Sent Events (SSE) for server → client
- WebSockets (not truly REST)
- Complex implementation

**gRPC**
- Native streaming support
- Server streaming
- Client streaming
- Bidirectional streaming
- Built into the protocol

### 4. Browser Support

**REST**
- Native browser support
- Works with `fetch()` and `XMLHttpRequest`
- No additional tooling required

**gRPC**
- No direct browser support
- Requires gRPC-Web proxy
- Limited streaming in browsers
- Additional complexity

### 5. API Contract

**REST**
- Loose contract (OpenAPI/Swagger optional)
- Flexible and forgiving
- Documentation can drift from implementation
- Runtime errors more common

**gRPC**
- Strict contract (`.proto` files required)
- Strongly typed
- Contract enforced at compile time
- Auto-generated documentation

### 6. Error Handling

**REST**
- HTTP status codes (200, 404, 500, etc.)
- Custom error messages in response body
- Well-understood by developers
- Standard across web

**gRPC**
- gRPC status codes (OK, CANCELLED, INVALID_ARGUMENT, etc.)
- Rich error model with details
- Less familiar to developers
- More granular error handling

---

## Performance Comparison

### Payload Size

```
Example: User object with 10 fields

JSON (REST):     ~250 bytes
Protocol Buffer: ~80 bytes
Reduction:       ~68%
```

### Latency

```
Average Response Time (1000 requests):

REST API:        ~50ms
gRPC:            ~20ms
Improvement:     ~60% faster
```

### Throughput

```
Requests per second (on same hardware):

REST API:        ~5,000 req/s
gRPC:            ~15,000 req/s
Improvement:     3x higher throughput
```

---

## Use Cases

### REST is Better For:

1. **Public APIs**
   - Easy to consume without special tooling
   - Browser-friendly
   - Wide adoption

2. **Simple CRUD Operations**
   - Straightforward resource manipulation
   - Standard HTTP methods map well

3. **Web Applications**
   - Native browser support
   - Easy debugging with browser dev tools

4. **Third-Party Integrations**
   - Most services expose REST APIs
   - Easier for external developers

5. **Human-Readable APIs**
   - JSON is easy to read and debug
   - Good for development and testing

### gRPC is Better For:

1. **Microservices Communication**
   - High performance
   - Efficient resource usage
   - Built-in service discovery

2. **Real-Time Applications**
   - Low latency
   - Bidirectional streaming
   - Gaming, chat, live updates

3. **Mobile Applications**
   - Smaller payloads save bandwidth
   - Battery-efficient
   - Better performance on slow networks

4. **Polyglot Environments**
   - Code generation for multiple languages
   - Consistent API across languages

5. **High-Frequency Trading**
   - Microsecond latency matters
   - Binary protocol is faster

6. **IoT Devices**
   - Limited bandwidth
   - Low power consumption
   - Efficient binary format

---

## Pros and Cons

### REST API

#### Pros ✅
- Simple and easy to understand
- Great tooling and ecosystem
- Human-readable (JSON)
- Native browser support
- Extensive documentation and tutorials
- Flexible and loosely coupled
- Cacheable by default
- Standard HTTP methods
- Language-agnostic
- Easy debugging

#### Cons ❌
- Larger payload size
- Slower performance
- Limited streaming capabilities
- No built-in code generation
- API contract not enforced
- HTTP/1.1 limitations
- Over-fetching/under-fetching data
- Multiple round trips for related data

### gRPC

#### Pros ✅
- High performance (binary format)
- Smaller payload size
- Native streaming support
- Strongly typed contracts
- Auto-generated code
- HTTP/2 benefits
- Built-in authentication
- Multiple language support
- Better for microservices
- Efficient for real-time apps

#### Cons ❌
- Steeper learning curve
- Limited browser support
- Not human-readable
- Requires Protocol Buffers knowledge
- Harder to debug
- Less tooling than REST
- Requires proxy for web clients
- Breaking changes impact clients
- Overkill for simple APIs

---

## Code Examples

### REST API Example (Node.js/Express)

```javascript
// Server
const express = require('express');
const app = express();
app.use(express.json());

// In-memory store
const users = new Map();

// GET all users
app.get('/api/users', (req, res) => {
  res.json(Array.from(users.values()));
});

// GET user by ID
app.get('/api/users/:id', (req, res) => {
  const user = users.get(req.params.id);
  if (!user) {
    return res.status(404).json({ error: 'User not found' });
  }
  res.json(user);
});

// POST create user
app.post('/api/users', (req, res) => {
  const { name, email, role } = req.body;
  const id = Date.now().toString();
  const user = { id, name, email, role };
  users.set(id, user);
  res.status(201).json(user);
});

// PUT update user
app.put('/api/users/:id', (req, res) => {
  if (!users.has(req.params.id)) {
    return res.status(404).json({ error: 'User not found' });
  }
  const user = { id: req.params.id, ...req.body };
  users.set(req.params.id, user);
  res.json(user);
});

// DELETE user
app.delete('/api/users/:id', (req, res) => {
  if (!users.delete(req.params.id)) {
    return res.status(404).json({ error: 'User not found' });
  }
  res.status(204).send();
});

app.listen(3000, () => console.log('REST API on port 3000'));
```

```javascript
// Client
const fetch = require('node-fetch');

// Get user
async function getUser(id) {
  const response = await fetch(`http://localhost:3000/api/users/${id}`);
  if (!response.ok) {
    throw new Error(`HTTP error! status: ${response.status}`);
  }
  return await response.json();
}

// Create user
async function createUser(userData) {
  const response = await fetch('http://localhost:3000/api/users', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(userData)
  });
  return await response.json();
}

// Usage
(async () => {
  const newUser = await createUser({
    name: 'John Doe',
    email: 'john@example.com',
    role: 'admin'
  });
  console.log('Created:', newUser);
  
  const user = await getUser(newUser.id);
  console.log('Fetched:', user);
})();
```

### gRPC Example (Node.js)

```protobuf
// user.proto
syntax = "proto3";

package user;

service UserService {
  rpc GetUser (GetUserRequest) returns (User);
  rpc CreateUser (CreateUserRequest) returns (User);
  rpc ListUsers (ListUsersRequest) returns (stream User);
  rpc UpdateUser (UpdateUserRequest) returns (User);
  rpc DeleteUser (DeleteUserRequest) returns (DeleteUserResponse);
}

message User {
  string id = 1;
  string name = 2;
  string email = 3;
  string role = 4;
}

message GetUserRequest {
  string id = 1;
}

message CreateUserRequest {
  string name = 1;
  string email = 2;
  string role = 3;
}

message UpdateUserRequest {
  string id = 1;
  string name = 2;
  string email = 3;
  string role = 4;
}

message DeleteUserRequest {
  string id = 1;
}

message DeleteUserResponse {
  bool success = 1;
}

message ListUsersRequest {
  int32 page_size = 1;
  string page_token = 2;
}
```

```javascript
// Server
const grpc = require('@grpc/grpc-js');
const protoLoader = require('@grpc/proto-loader');

const PROTO_PATH = './user.proto';
const packageDefinition = protoLoader.loadSync(PROTO_PATH);
const userProto = grpc.loadPackageDefinition(packageDefinition).user;

// In-memory store
const users = new Map();

// Service implementation
const userService = {
  GetUser: (call, callback) => {
    const user = users.get(call.request.id);
    if (!user) {
      return callback({
        code: grpc.status.NOT_FOUND,
        message: 'User not found'
      });
    }
    callback(null, user);
  },
  
  CreateUser: (call, callback) => {
    const id = Date.now().toString();
    const user = {
      id,
      name: call.request.name,
      email: call.request.email,
      role: call.request.role
    };
    users.set(id, user);
    callback(null, user);
  },
  
  ListUsers: (call) => {
    users.forEach(user => {
      call.write(user);
    });
    call.end();
  },
  
  UpdateUser: (call, callback) => {
    if (!users.has(call.request.id)) {
      return callback({
        code: grpc.status.NOT_FOUND,
        message: 'User not found'
      });
    }
    const user = {
      id: call.request.id,
      name: call.request.name,
      email: call.request.email,
      role: call.request.role
    };
    users.set(call.request.id, user);
    callback(null, user);
  },
  
  DeleteUser: (call, callback) => {
    const success = users.delete(call.request.id);
    callback(null, { success });
  }
};

// Start server
const server = new grpc.Server();
server.addService(userProto.UserService.service, userService);
server.bindAsync(
  '0.0.0.0:50051',
  grpc.ServerCredentials.createInsecure(),
  () => {
    console.log('gRPC server running on port 50051');
    server.start();
  }
);
```

```javascript
// Client
const grpc = require('@grpc/grpc-js');
const protoLoader = require('@grpc/proto-loader');

const PROTO_PATH = './user.proto';
const packageDefinition = protoLoader.loadSync(PROTO_PATH);
const userProto = grpc.loadPackageDefinition(packageDefinition).user;

const client = new userProto.UserService(
  'localhost:50051',
  grpc.credentials.createInsecure()
);

// Create user
client.CreateUser(
  { name: 'John Doe', email: 'john@example.com', role: 'admin' },
  (error, user) => {
    if (error) {
      console.error(error);
      return;
    }
    console.log('Created user:', user);
    
    // Get user
    client.GetUser({ id: user.id }, (error, fetchedUser) => {
      if (error) {
        console.error(error);
        return;
      }
      console.log('Fetched user:', fetchedUser);
    });
  }
);

// List users (streaming)
const call = client.ListUsers({});
call.on('data', (user) => {
  console.log('User:', user);
});
call.on('end', () => {
  console.log('Streaming finished');
});
```

---

## When to Choose What

### Choose REST When:

```
✅ Building public APIs
✅ Simple CRUD applications
✅ Browser-based clients (web apps)
✅ Team is familiar with REST
✅ Need human-readable format
✅ Third-party integrations
✅ Caching is important
✅ Simple request-response pattern
✅ Documentation over performance
```

### Choose gRPC When:

```
✅ Microservices architecture
✅ Performance is critical
✅ Real-time streaming needed
✅ Mobile applications
✅ Polyglot environment
✅ Internal APIs (not public)
✅ IoT or resource-constrained devices
✅ High-frequency, low-latency needs
✅ Strong typing is important
```

### Hybrid Approach

Many organizations use **both**:
- **gRPC** for internal microservice communication
- **REST** for public-facing APIs
- **API Gateway** to translate between REST and gRPC

```
Client (REST) → API Gateway → gRPC Services
                    ↓
                REST Services
```

---

## Migration Considerations

### REST to gRPC

1. **Define Proto Files**: Convert REST models to Protocol Buffers
2. **Generate Code**: Use protoc compiler
3. **Implement Services**: Port REST handlers to gRPC methods
4. **Update Clients**: Replace HTTP calls with gRPC stubs
5. **Testing**: Ensure feature parity
6. **Gradual Rollout**: Use feature flags

### Maintaining Both

```javascript
// Express REST wrapper for gRPC service
app.get('/api/users/:id', async (req, res) => {
  try {
    const user = await grpcClient.GetUser({ id: req.params.id });
    res.json(user);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});
```

---

## Best Practices

### REST Best Practices

1. Use proper HTTP methods (GET, POST, PUT, DELETE)
2. Use meaningful resource names (nouns, not verbs)
3. Version your API (/api/v1/users)
4. Use HTTP status codes correctly
5. Implement pagination for lists
6. Support filtering and sorting
7. Use HATEOAS for discoverability
8. Implement proper error handling
9. Document with OpenAPI/Swagger
10. Use ETags for caching

### gRPC Best Practices

1. Design clear service boundaries
2. Use semantic versioning for proto files
3. Define deadline/timeout policies
4. Implement proper error handling
5. Use interceptors for cross-cutting concerns
6. Monitor with distributed tracing
7. Implement health checks
8. Use compression for large payloads
9. Handle backward compatibility
10. Document your proto files

---

## Conclusion

Both REST and gRPC have their place in modern architecture:

- **REST** excels in simplicity, browser support, and public APIs
- **gRPC** excels in performance, streaming, and microservices

The choice depends on your specific requirements:
- Performance needs
- Client types (browser, mobile, server)
- Team expertise
- Use case (public API vs internal services)

Many successful systems use **both**, leveraging the strengths of each where appropriate.

---

## References

- [REST API Design Best Practices](https://restfulapi.net/)
- [gRPC Official Documentation](https://grpc.io/docs/)
- [Protocol Buffers Guide](https://developers.google.com/protocol-buffers)
- [HTTP/2 vs HTTP/1.1](https://www.cloudflare.com/learning/performance/http2-vs-http1.1/)
- [Martin Fowler - Richardson Maturity Model](https://martinfowler.com/articles/richardsonMaturityModel.html)

---

*Last Updated: February 2026*
