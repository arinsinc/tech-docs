# GraphQL Tutorial

## Table of Contents
1. [Introduction to GraphQL](#introduction-to-graphql)
2. [GraphQL vs REST](#graphql-vs-rest)
3. [Core Concepts](#core-concepts)
4. [Schema Definition Language (SDL)](#schema-definition-language-sdl)
5. [Queries](#queries)
6. [Mutations](#mutations)
7. [Subscriptions](#subscriptions)
8. [Resolvers](#resolvers)
9. [GraphQL Server Setup](#graphql-server-setup)
10. [GraphQL Client](#graphql-client)
11. [Advanced Topics](#advanced-topics)
12. [Best Practices](#best-practices)
13. [Common Patterns](#common-patterns)

---

## Introduction to GraphQL

### What is GraphQL?

GraphQL is a **query language for APIs** and a **runtime for executing those queries** with your existing data. It was developed by Facebook in 2012 and open-sourced in 2015.

**Key Features:**
- Query exactly what you need (no over-fetching or under-fetching)
- Get multiple resources in a single request
- Strongly typed schema
- Self-documenting API
- Real-time data with subscriptions
- Evolve API without versioning

### Why GraphQL?

**Problems with REST:**
- Over-fetching: Getting more data than needed
- Under-fetching: Need multiple requests to get all required data
- API versioning complexity
- Lack of flexibility for diverse clients (web, mobile, IoT)

**GraphQL Solutions:**
- Clients request only the fields they need
- Related data can be fetched in a single query
- Strong type system prevents errors
- Introspection enables powerful tooling

---

## GraphQL vs REST

| Feature | REST | GraphQL |
|---------|------|---------|
| **Data Fetching** | Multiple endpoints | Single endpoint |
| **Over-fetching** | Common | Eliminated |
| **Under-fetching** | Requires multiple requests | Single request |
| **Versioning** | Multiple versions (v1, v2) | No versioning needed |
| **Documentation** | Separate (Swagger, etc.) | Self-documenting |
| **Learning Curve** | Lower | Slightly higher |
| **Caching** | HTTP caching works well | More complex |
| **File Upload** | Straightforward | Requires multipart spec |

**Example Comparison:**

**REST:**
```bash
# Get user
GET /users/123

# Get user's posts
GET /users/123/posts

# Get post comments
GET /posts/456/comments
```

**GraphQL:**
```graphql
# Single query for all data
query {
  user(id: "123") {
    name
    email
    posts {
      title
      comments {
        text
        author
      }
    }
  }
}
```

---

## Core Concepts

### 1. Schema

The schema defines the structure of your API - what data can be queried and how.

```graphql
type User {
  id: ID!
  name: String!
  email: String!
  age: Int
  posts: [Post!]!
}

type Post {
  id: ID!
  title: String!
  content: String!
  author: User!
  comments: [Comment!]!
  createdAt: String!
}

type Comment {
  id: ID!
  text: String!
  author: User!
  post: Post!
}
```

### 2. Types

**Scalar Types:**
- `Int`: 32-bit integer
- `Float`: Double-precision floating-point
- `String`: UTF-8 character sequence
- `Boolean`: true or false
- `ID`: Unique identifier (serialized as String)

**Object Types:**
```graphql
type Book {
  id: ID!
  title: String!
  author: Author!
}
```

**Enum Types:**
```graphql
enum Role {
  ADMIN
  USER
  GUEST
}
```

**Interface Types:**
```graphql
interface Node {
  id: ID!
}

type User implements Node {
  id: ID!
  name: String!
}
```

**Union Types:**
```graphql
union SearchResult = User | Post | Comment

type Query {
  search(term: String!): [SearchResult!]!
}
```

### 3. Type Modifiers

- `String`: Nullable string
- `String!`: Non-nullable string (required)
- `[String]`: Nullable list of nullable strings
- `[String!]`: Nullable list of non-nullable strings
- `[String!]!`: Non-nullable list of non-nullable strings

---

## Schema Definition Language (SDL)

### Root Types

Every GraphQL schema has three special root types:

```graphql
type Query {
  # Read operations
  user(id: ID!): User
  users: [User!]!
  post(id: ID!): Post
}

type Mutation {
  # Write operations
  createUser(name: String!, email: String!): User!
  updateUser(id: ID!, name: String, email: String): User!
  deleteUser(id: ID!): Boolean!
}

type Subscription {
  # Real-time updates
  userCreated: User!
  postUpdated(id: ID!): Post!
}
```

### Input Types

For complex arguments in mutations:

```graphql
input CreateUserInput {
  name: String!
  email: String!
  age: Int
  role: Role = USER
}

type Mutation {
  createUser(input: CreateUserInput!): User!
}
```

### Directives

Built-in directives:

```graphql
type User {
  id: ID!
  name: String!
  email: String! @deprecated(reason: "Use emailAddress instead")
  emailAddress: String!
  password: String! @skip(if: true)
}
```

**Common Directives:**
- `@deprecated`: Mark fields as deprecated
- `@skip(if: Boolean)`: Skip field if condition is true
- `@include(if: Boolean)`: Include field if condition is true

---

## Queries

### Basic Query

```graphql
query {
  user(id: "123") {
    name
    email
  }
}
```

**Response:**
```json
{
  "data": {
    "user": {
      "name": "John Doe",
      "email": "john@example.com"
    }
  }
}
```

### Named Query

```graphql
query GetUser {
  user(id: "123") {
    name
    email
  }
}
```

### Query with Variables

```graphql
query GetUser($userId: ID!) {
  user(id: $userId) {
    name
    email
    posts {
      title
    }
  }
}
```

**Variables:**
```json
{
  "userId": "123"
}
```

### Nested Queries

```graphql
query {
  user(id: "123") {
    name
    posts {
      title
      comments {
        text
        author {
          name
        }
      }
    }
  }
}
```

### Aliases

Query the same field with different arguments:

```graphql
query {
  user1: user(id: "123") {
    name
  }
  user2: user(id: "456") {
    name
  }
}
```

**Response:**
```json
{
  "data": {
    "user1": { "name": "John" },
    "user2": { "name": "Jane" }
  }
}
```

### Fragments

Reusable units of fields:

```graphql
fragment UserFields on User {
  id
  name
  email
}

query {
  user1: user(id: "123") {
    ...UserFields
  }
  user2: user(id: "456") {
    ...UserFields
  }
}
```

### Inline Fragments

For union or interface types:

```graphql
query {
  search(term: "john") {
    ... on User {
      name
      email
    }
    ... on Post {
      title
      content
    }
  }
}
```

---

## Mutations

### Basic Mutation

```graphql
mutation {
  createUser(name: "John Doe", email: "john@example.com") {
    id
    name
    email
  }
}
```

### Mutation with Variables

```graphql
mutation CreateUser($input: CreateUserInput!) {
  createUser(input: $input) {
    id
    name
    email
  }
}
```

**Variables:**
```json
{
  "input": {
    "name": "John Doe",
    "email": "john@example.com",
    "age": 30
  }
}
```

### Multiple Mutations

```graphql
mutation {
  createUser(input: { name: "John", email: "john@example.com" }) {
    id
  }
  createPost(input: { title: "My Post", authorId: "123" }) {
    id
  }
}
```

**Note:** Mutations are executed sequentially (queries are parallel).

### Update Mutation

```graphql
mutation UpdateUser($id: ID!, $input: UpdateUserInput!) {
  updateUser(id: $id, input: $input) {
    id
    name
    email
    updatedAt
  }
}
```

### Delete Mutation

```graphql
mutation DeleteUser($id: ID!) {
  deleteUser(id: $id) {
    success
    message
  }
}
```

---

## Subscriptions

Subscriptions enable real-time updates via WebSocket connections.

### Schema Definition

```graphql
type Subscription {
  messageAdded(chatId: ID!): Message!
  userStatusChanged(userId: ID!): UserStatus!
  postUpdated: Post!
}

type Message {
  id: ID!
  text: String!
  author: User!
  createdAt: String!
}
```

### Client Subscription

```graphql
subscription OnMessageAdded($chatId: ID!) {
  messageAdded(chatId: $chatId) {
    id
    text
    author {
      name
    }
    createdAt
  }
}
```

### Use Cases
- Live chat applications
- Real-time notifications
- Live dashboards
- Collaborative editing
- Stock price updates

---

## Resolvers

Resolvers are functions that handle fetching data for each field in your schema.

### Basic Resolver Structure

```javascript
const resolvers = {
  Query: {
    // Resolver for Query.user field
    user: (parent, args, context, info) => {
      return getUserById(args.id);
    },
    users: () => {
      return getAllUsers();
    }
  },
  
  Mutation: {
    createUser: (parent, args, context, info) => {
      return createNewUser(args.input);
    }
  },
  
  // Field resolvers for User type
  User: {
    posts: (parent, args, context, info) => {
      return getPostsByUserId(parent.id);
    }
  }
};
```

### Resolver Arguments

1. **parent** (or `root`): The result from the parent resolver
2. **args**: The arguments provided to the field
3. **context**: Shared across all resolvers (auth, database, etc.)
4. **info**: Information about the execution state

### Example Resolvers

```javascript
const resolvers = {
  Query: {
    user: async (_, { id }, { dataSources }) => {
      return await dataSources.userAPI.getUserById(id);
    },
    
    users: async (_, __, { dataSources }) => {
      return await dataSources.userAPI.getAllUsers();
    }
  },
  
  Mutation: {
    createUser: async (_, { input }, { dataSources, user }) => {
      // Check authentication
      if (!user) throw new Error('Not authenticated');
      
      return await dataSources.userAPI.createUser(input);
    },
    
    updateUser: async (_, { id, input }, { dataSources, user }) => {
      // Check authorization
      if (user.id !== id && user.role !== 'ADMIN') {
        throw new Error('Not authorized');
      }
      
      return await dataSources.userAPI.updateUser(id, input);
    }
  },
  
  User: {
    posts: async (parent, _, { dataSources }) => {
      return await dataSources.postAPI.getPostsByUserId(parent.id);
    },
    
    fullName: (parent) => {
      return `${parent.firstName} ${parent.lastName}`;
    }
  },
  
  Subscription: {
    messageAdded: {
      subscribe: (_, { chatId }, { pubsub }) => {
        return pubsub.asyncIterator(`MESSAGE_ADDED_${chatId}`);
      }
    }
  }
};
```

---

## GraphQL Server Setup

### Using Apollo Server (Node.js)

**Installation:**
```bash
npm install @apollo/server graphql
```

**Basic Server:**

```javascript
const { ApolloServer } = require('@apollo/server');
const { startStandaloneServer } = require('@apollo/server/standalone');

// Type definitions
const typeDefs = `
  type User {
    id: ID!
    name: String!
    email: String!
  }

  type Query {
    users: [User!]!
    user(id: ID!): User
  }

  type Mutation {
    createUser(name: String!, email: String!): User!
  }
`;

// Sample data
let users = [
  { id: '1', name: 'John Doe', email: 'john@example.com' },
  { id: '2', name: 'Jane Smith', email: 'jane@example.com' }
];

// Resolvers
const resolvers = {
  Query: {
    users: () => users,
    user: (_, { id }) => users.find(user => user.id === id)
  },
  
  Mutation: {
    createUser: (_, { name, email }) => {
      const newUser = {
        id: String(users.length + 1),
        name,
        email
      };
      users.push(newUser);
      return newUser;
    }
  }
};

// Create server
const server = new ApolloServer({
  typeDefs,
  resolvers
});

// Start server
startStandaloneServer(server, {
  listen: { port: 4000 }
}).then(({ url }) => {
  console.log(`🚀 Server ready at ${url}`);
});
```

### With Express Integration

```javascript
const express = require('express');
const { ApolloServer } = require('@apollo/server');
const { expressMiddleware } = require('@apollo/server/express4');
const cors = require('cors');
const bodyParser = require('body-parser');

const app = express();

const server = new ApolloServer({
  typeDefs,
  resolvers
});

await server.start();

app.use(
  '/graphql',
  cors(),
  bodyParser.json(),
  expressMiddleware(server, {
    context: async ({ req }) => ({
      user: await authenticateUser(req.headers.authorization),
      dataSources: {
        userAPI: new UserAPI(),
        postAPI: new PostAPI()
      }
    })
  })
);

app.listen(4000, () => {
  console.log('Server running on http://localhost:4000/graphql');
});
```

### Using GraphQL Yoga

```javascript
const { createServer } = require('@graphql-yoga/node');

const server = createServer({
  schema: {
    typeDefs,
    resolvers
  },
  context: ({ request }) => ({
    user: authenticateUser(request.headers.get('authorization'))
  })
});

server.start();
```

---

## GraphQL Client

### Using Apollo Client (React)

**Installation:**
```bash
npm install @apollo/client graphql
```

**Setup:**

```javascript
import { ApolloClient, InMemoryCache, ApolloProvider } from '@apollo/client';

const client = new ApolloClient({
  uri: 'http://localhost:4000/graphql',
  cache: new InMemoryCache()
});

function App() {
  return (
    <ApolloProvider client={client}>
      <YourApp />
    </ApolloProvider>
  );
}
```

**Query Example:**

```javascript
import { useQuery, gql } from '@apollo/client';

const GET_USERS = gql`
  query GetUsers {
    users {
      id
      name
      email
    }
  }
`;

function UserList() {
  const { loading, error, data } = useQuery(GET_USERS);

  if (loading) return <p>Loading...</p>;
  if (error) return <p>Error: {error.message}</p>;

  return (
    <ul>
      {data.users.map(user => (
        <li key={user.id}>{user.name}</li>
      ))}
    </ul>
  );
}
```

**Mutation Example:**

```javascript
import { useMutation, gql } from '@apollo/client';

const CREATE_USER = gql`
  mutation CreateUser($name: String!, $email: String!) {
    createUser(name: $name, email: $email) {
      id
      name
      email
    }
  }
`;

function CreateUserForm() {
  const [createUser, { data, loading, error }] = useMutation(CREATE_USER, {
    refetchQueries: [{ query: GET_USERS }]
  });

  const handleSubmit = (e) => {
    e.preventDefault();
    createUser({
      variables: {
        name: e.target.name.value,
        email: e.target.email.value
      }
    });
  };

  return (
    <form onSubmit={handleSubmit}>
      <input name="name" placeholder="Name" />
      <input name="email" placeholder="Email" />
      <button type="submit" disabled={loading}>
        Create User
      </button>
      {error && <p>Error: {error.message}</p>}
    </form>
  );
}
```

### Using fetch API

```javascript
async function fetchGraphQL(query, variables = {}) {
  const response = await fetch('http://localhost:4000/graphql', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${token}`
    },
    body: JSON.stringify({
      query,
      variables
    })
  });

  return await response.json();
}

// Usage
const query = `
  query GetUser($id: ID!) {
    user(id: $id) {
      name
      email
    }
  }
`;

const result = await fetchGraphQL(query, { id: '123' });
console.log(result.data.user);
```

---

## Advanced Topics

### 1. DataLoader (N+1 Problem Solution)

The N+1 problem occurs when you fetch a list and then fetch related data for each item.

```javascript
const DataLoader = require('dataloader');

// Create a DataLoader
const userLoader = new DataLoader(async (userIds) => {
  const users = await db.users.findMany({
    where: { id: { in: userIds } }
  });
  
  // Return users in the same order as userIds
  return userIds.map(id => users.find(user => user.id === id));
});

// Use in resolver
const resolvers = {
  Post: {
    author: (post, _, { loaders }) => {
      return loaders.userLoader.load(post.authorId);
    }
  }
};
```

### 2. Pagination

**Offset-based:**
```graphql
type Query {
  users(offset: Int, limit: Int): [User!]!
}

query {
  users(offset: 10, limit: 5) {
    id
    name
  }
}
```

**Cursor-based (Relay-style):**
```graphql
type PageInfo {
  hasNextPage: Boolean!
  hasPreviousPage: Boolean!
  startCursor: String
  endCursor: String
}

type UserEdge {
  node: User!
  cursor: String!
}

type UserConnection {
  edges: [UserEdge!]!
  pageInfo: PageInfo!
  totalCount: Int!
}

type Query {
  users(first: Int, after: String, last: Int, before: String): UserConnection!
}
```

### 3. Error Handling

```javascript
const { GraphQLError } = require('graphql');

const resolvers = {
  Query: {
    user: async (_, { id }, { dataSources }) => {
      const user = await dataSources.userAPI.getUserById(id);
      
      if (!user) {
        throw new GraphQLError('User not found', {
          extensions: {
            code: 'USER_NOT_FOUND',
            http: { status: 404 }
          }
        });
      }
      
      return user;
    }
  }
};
```

### 4. Authentication & Authorization

```javascript
// Context with authentication
const server = new ApolloServer({
  typeDefs,
  resolvers,
  context: async ({ req }) => {
    const token = req.headers.authorization || '';
    const user = await getUserFromToken(token);
    return { user };
  }
});

// Resolver with authorization
const resolvers = {
  Mutation: {
    deletePost: (_, { id }, { user }) => {
      if (!user) {
        throw new GraphQLError('Not authenticated', {
          extensions: { code: 'UNAUTHENTICATED' }
        });
      }
      
      const post = getPostById(id);
      
      if (post.authorId !== user.id && user.role !== 'ADMIN') {
        throw new GraphQLError('Not authorized', {
          extensions: { code: 'FORBIDDEN' }
        });
      }
      
      return deletePost(id);
    }
  }
};
```

### 5. Custom Scalars

```javascript
const { GraphQLScalarType, Kind } = require('graphql');

const dateScalar = new GraphQLScalarType({
  name: 'Date',
  description: 'Date custom scalar type',
  
  serialize(value) {
    return value.toISOString(); // Send to client
  },
  
  parseValue(value) {
    return new Date(value); // From client variable
  },
  
  parseLiteral(ast) {
    if (ast.kind === Kind.STRING) {
      return new Date(ast.value); // From client query
    }
    return null;
  }
});

const resolvers = {
  Date: dateScalar,
  Query: {
    // ... other resolvers
  }
};
```

### 6. File Upload

```graphql
scalar Upload

type Mutation {
  uploadFile(file: Upload!): File!
}

type File {
  filename: String!
  mimetype: String!
  encoding: String!
  url: String!
}
```

```javascript
const resolvers = {
  Mutation: {
    uploadFile: async (_, { file }) => {
      const { createReadStream, filename, mimetype, encoding } = await file;
      
      const stream = createReadStream();
      const url = await saveFile(stream, filename);
      
      return { filename, mimetype, encoding, url };
    }
  }
};
```

---

## Best Practices

### 1. Schema Design

**✅ DO:**
- Use clear, descriptive names
- Make fields non-nullable when appropriate
- Use input types for complex arguments
- Design schema from client perspective

**❌ DON'T:**
- Create too many nullable fields
- Use generic names like `data` or `result`
- Expose internal database structure directly

### 2. Query Design

**✅ DO:**
```graphql
# Use specific queries
query GetUserProfile($userId: ID!) {
  user(id: $userId) {
    id
    name
    email
    profileImage
  }
}
```

**❌ DON'T:**
```graphql
# Avoid over-fetching
query {
  user(id: "123") {
    id
    name
    email
    posts {
      id
      title
      content
      comments {
        # Too much nesting
        text
        author {
          posts {
            # Circular reference issue
          }
        }
      }
    }
  }
}
```

### 3. Performance Optimization

- **Use DataLoader** to batch and cache requests
- **Implement pagination** for lists
- **Add query depth limiting** to prevent abuse
- **Use field-level caching** when appropriate
- **Monitor query complexity**

### 4. Security

- **Validate input** in resolvers
- **Implement rate limiting**
- **Use query depth and complexity limits**
- **Sanitize error messages** (don't expose internal details)
- **Implement proper authentication and authorization**

### 5. Error Handling

```javascript
// Return user-friendly errors
const resolvers = {
  Mutation: {
    createUser: async (_, { input }) => {
      try {
        return await createUser(input);
      } catch (error) {
        if (error.code === 'DUPLICATE_EMAIL') {
          throw new GraphQLError('Email already exists', {
            extensions: { code: 'BAD_USER_INPUT' }
          });
        }
        throw error;
      }
    }
  }
};
```

---

## Common Patterns

### 1. Connection Pattern (Relay)

```graphql
type UserConnection {
  edges: [UserEdge!]!
  pageInfo: PageInfo!
  totalCount: Int!
}

type UserEdge {
  node: User!
  cursor: String!
}

type PageInfo {
  hasNextPage: Boolean!
  hasPreviousPage: Boolean!
  startCursor: String
  endCursor: String
}
```

### 2. Node Pattern

```graphql
interface Node {
  id: ID!
}

type User implements Node {
  id: ID!
  name: String!
}

type Query {
  node(id: ID!): Node
}
```

### 3. Mutation Response Pattern

```graphql
type CreateUserPayload {
  user: User
  errors: [Error!]
  success: Boolean!
}

type Error {
  field: String!
  message: String!
}

type Mutation {
  createUser(input: CreateUserInput!): CreateUserPayload!
}
```

### 4. Filtering and Sorting

```graphql
enum SortOrder {
  ASC
  DESC
}

input UserFilter {
  name: String
  email: String
  ageMin: Int
  ageMax: Int
}

input UserSort {
  field: String!
  order: SortOrder!
}

type Query {
  users(
    filter: UserFilter
    sort: UserSort
    limit: Int
    offset: Int
  ): [User!]!
}
```

---

## Practice Examples

### Example 1: Blog API

```graphql
type User {
  id: ID!
  username: String!
  email: String!
  posts: [Post!]!
  createdAt: String!
}

type Post {
  id: ID!
  title: String!
  content: String!
  author: User!
  comments: [Comment!]!
  tags: [String!]!
  published: Boolean!
  createdAt: String!
  updatedAt: String!
}

type Comment {
  id: ID!
  text: String!
  author: User!
  post: Post!
  createdAt: String!
}

type Query {
  users: [User!]!
  user(id: ID!): User
  posts(published: Boolean): [Post!]!
  post(id: ID!): Post
}

type Mutation {
  createUser(username: String!, email: String!): User!
  createPost(title: String!, content: String!, authorId: ID!): Post!
  publishPost(id: ID!): Post!
  addComment(postId: ID!, text: String!): Comment!
}

type Subscription {
  postPublished: Post!
  commentAdded(postId: ID!): Comment!
}
```

### Example 2: E-commerce API

```graphql
type Product {
  id: ID!
  name: String!
  description: String!
  price: Float!
  category: Category!
  inStock: Boolean!
  images: [String!]!
}

type Category {
  id: ID!
  name: String!
  products: [Product!]!
}

type Order {
  id: ID!
  user: User!
  items: [OrderItem!]!
  total: Float!
  status: OrderStatus!
  createdAt: String!
}

type OrderItem {
  product: Product!
  quantity: Int!
  price: Float!
}

enum OrderStatus {
  PENDING
  PROCESSING
  SHIPPED
  DELIVERED
  CANCELLED
}

type Query {
  products(categoryId: ID, inStock: Boolean): [Product!]!
  product(id: ID!): Product
  orders(userId: ID!): [Order!]!
  order(id: ID!): Order
}

type Mutation {
  createOrder(items: [OrderItemInput!]!): Order!
  updateOrderStatus(id: ID!, status: OrderStatus!): Order!
}

input OrderItemInput {
  productId: ID!
  quantity: Int!
}
```

---

## Tools and Resources

### Development Tools
- **GraphiQL**: In-browser GraphQL IDE
- **Apollo Studio**: Cloud-based GraphQL platform
- **GraphQL Playground**: Feature-rich GraphQL IDE
- **Postman**: API testing with GraphQL support
- **Insomnia**: REST and GraphQL client

### Learning Resources
- [Official GraphQL Documentation](https://graphql.org/)
- [Apollo Documentation](https://www.apollographql.com/docs/)
- [How to GraphQL](https://www.howtographql.com/)
- [GraphQL Code Generator](https://www.graphql-code-generator.com/)

### Libraries
- **Server:** Apollo Server, GraphQL Yoga, Mercurius, Express-GraphQL
- **Client:** Apollo Client, urql, Relay
- **Tools:** GraphQL Code Generator, GraphQL Inspector, GraphQL ESLint

---

## Conclusion

GraphQL provides a powerful, flexible way to build APIs that gives clients precise control over the data they receive. While it has a learning curve, the benefits of reduced over-fetching, strong typing, and excellent tooling make it an excellent choice for modern applications.

**Next Steps:**
1. Build a simple GraphQL server
2. Create a client application
3. Implement authentication
4. Add real-time subscriptions
5. Optimize with DataLoader
6. Deploy to production

Happy coding! 🚀
