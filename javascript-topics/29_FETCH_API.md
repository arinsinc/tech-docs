# Fetch API

The Fetch API provides a modern interface for making HTTP requests in JavaScript. It's promise-based and more powerful than the older XMLHttpRequest.

## Table of Contents
1. [Basics](#basics)
2. [Request Configuration](#request-configuration)
3. [Response Handling](#response-handling)
4. [HTTP Methods](#http-methods)
5. [Error Handling](#error-handling)
6. [Advanced Features](#advanced-features)
7. [Best Practices](#best-practices)

---

## Basics

### Simple GET Request

```javascript
// Basic fetch
fetch('https://api.example.com/data')
  .then(response => response.json())
  .then(data => console.log(data))
  .catch(error => console.error('Error:', error));

// With async/await
async function fetchData() {
  try {
    const response = await fetch('https://api.example.com/data');
    const data = await response.json();
    console.log(data);
  } catch (error) {
    console.error('Error:', error);
  }
}

fetchData();

// Fetch returns a Promise
const promise = fetch('https://api.example.com/data');
console.log(promise); // Promise { <pending> }
```

### Checking Response Status

```javascript
async function fetchWithCheck() {
  const response = await fetch('https://api.example.com/data');
  
  // Check if request was successful
  if (!response.ok) {
    throw new Error(`HTTP error! status: ${response.status}`);
  }
  
  const data = await response.json();
  return data;
}

// More detailed status checking
async function fetchWithDetailedCheck() {
  const response = await fetch('https://api.example.com/data');
  
  console.log('Status:', response.status);           // 200, 404, etc.
  console.log('Status text:', response.statusText);  // "OK", "Not Found"
  console.log('OK?:', response.ok);                  // true if 200-299
  
  switch (response.status) {
    case 200:
      return await response.json();
    case 404:
      throw new Error('Resource not found');
    case 500:
      throw new Error('Server error');
    default:
      throw new Error(`Unexpected status: ${response.status}`);
  }
}
```

---

## Request Configuration

### Fetch Options

```javascript
// Full configuration
fetch('https://api.example.com/data', {
  method: 'GET',              // HTTP method
  headers: {                  // Request headers
    'Content-Type': 'application/json',
    'Authorization': 'Bearer token123'
  },
  body: null,                 // Request body (not used with GET)
  mode: 'cors',               // cors, no-cors, same-origin
  credentials: 'same-origin', // include, same-origin, omit
  cache: 'default',           // default, no-cache, reload, force-cache
  redirect: 'follow',         // follow, error, manual
  referrer: 'client',         // client, no-referrer, URL
  referrerPolicy: 'no-referrer-when-downgrade',
  integrity: '',              // Subresource integrity
  keepalive: false,           // Keep connection alive
  signal: null                // AbortSignal for cancellation
});
```

### Setting Headers

```javascript
// Using object
const headers = {
  'Content-Type': 'application/json',
  'Authorization': 'Bearer token123',
  'X-Custom-Header': 'value'
};

fetch(url, { headers });

// Using Headers object
const headers = new Headers();
headers.append('Content-Type', 'application/json');
headers.append('Authorization', 'Bearer token123');

fetch(url, { headers });

// Check headers
console.log(headers.has('Content-Type'));         // true
console.log(headers.get('Content-Type'));         // "application/json"
headers.set('Content-Type', 'text/plain');        // Update
headers.delete('Authorization');                  // Remove

// Iterate headers
headers.forEach((value, key) => {
  console.log(`${key}: ${value}`);
});
```

### Common Header Patterns

```javascript
// JSON request
const jsonHeaders = {
  'Content-Type': 'application/json',
  'Accept': 'application/json'
};

// With authentication
const authHeaders = {
  'Authorization': `Bearer ${token}`,
  'Content-Type': 'application/json'
};

// Form data (browser sets Content-Type automatically)
const formHeaders = {
  'Authorization': `Bearer ${token}`
  // Don't set Content-Type for FormData
};

// Custom API key
const apiHeaders = {
  'X-API-Key': 'your-api-key',
  'Content-Type': 'application/json'
};
```

---

## Response Handling

### Response Methods

```javascript
const response = await fetch(url);

// Parse as JSON
const data = await response.json();

// Parse as text
const text = await response.text();

// Parse as Blob (for files, images)
const blob = await response.blob();

// Parse as ArrayBuffer
const buffer = await response.arrayBuffer();

// Parse as FormData
const formData = await response.formData();

// Clone response (can only read body once)
const response1 = await fetch(url);
const response2 = response1.clone();

const data1 = await response1.json();
const data2 = await response2.text();
```

### Response Properties

```javascript
const response = await fetch(url);

console.log(response.status);         // 200
console.log(response.statusText);     // "OK"
console.log(response.ok);             // true (200-299)
console.log(response.headers);        // Headers object
console.log(response.url);            // Final URL (after redirects)
console.log(response.redirected);     // Was redirected?
console.log(response.type);           // basic, cors, error, opaque
console.log(response.bodyUsed);       // Was body read?

// Get specific header
console.log(response.headers.get('Content-Type'));

// Get all headers
response.headers.forEach((value, key) => {
  console.log(`${key}: ${value}`);
});
```

### Different Response Types

```javascript
// JSON response
async function fetchJSON(url) {
  const response = await fetch(url);
  if (!response.ok) throw new Error('Network response was not ok');
  return await response.json();
}

// Text response
async function fetchText(url) {
  const response = await fetch(url);
  if (!response.ok) throw new Error('Network response was not ok');
  return await response.text();
}

// Blob response (images, files)
async function fetchImage(url) {
  const response = await fetch(url);
  if (!response.ok) throw new Error('Network response was not ok');
  const blob = await response.blob();
  return URL.createObjectURL(blob);
}

// Usage
const imageUrl = await fetchImage('https://example.com/image.jpg');
document.querySelector('img').src = imageUrl;

// Download file
async function downloadFile(url, filename) {
  const response = await fetch(url);
  const blob = await response.blob();
  const url = URL.createObjectURL(blob);
  
  const a = document.createElement('a');
  a.href = url;
  a.download = filename;
  a.click();
  
  URL.revokeObjectURL(url);
}
```

---

## HTTP Methods

### GET Request

```javascript
// Simple GET
async function getUser(id) {
  const response = await fetch(`https://api.example.com/users/${id}`);
  return await response.json();
}

// GET with query parameters
function buildURL(base, params) {
  const url = new URL(base);
  Object.keys(params).forEach(key => {
    url.searchParams.append(key, params[key]);
  });
  return url.toString();
}

const url = buildURL('https://api.example.com/users', {
  page: 1,
  limit: 10,
  sort: 'name'
});

const response = await fetch(url);

// Using URLSearchParams
const params = new URLSearchParams({
  page: 1,
  limit: 10,
  sort: 'name'
});

const response = await fetch(`https://api.example.com/users?${params}`);
```

### POST Request

```javascript
// POST with JSON
async function createUser(userData) {
  const response = await fetch('https://api.example.com/users', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify(userData)
  });
  
  if (!response.ok) {
    throw new Error(`HTTP error! status: ${response.status}`);
  }
  
  return await response.json();
}

// Usage
const newUser = await createUser({
  name: 'John Doe',
  email: 'john@example.com'
});

// POST with FormData
async function uploadFile(file) {
  const formData = new FormData();
  formData.append('file', file);
  formData.append('description', 'My file');
  
  const response = await fetch('https://api.example.com/upload', {
    method: 'POST',
    body: formData // Don't set Content-Type header
  });
  
  return await response.json();
}

// Usage with file input
const fileInput = document.querySelector('input[type="file"]');
fileInput.addEventListener('change', async (e) => {
  const file = e.target.files[0];
  const result = await uploadFile(file);
  console.log(result);
});
```

### PUT Request

```javascript
// PUT - update entire resource
async function updateUser(id, userData) {
  const response = await fetch(`https://api.example.com/users/${id}`, {
    method: 'PUT',
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify(userData)
  });
  
  return await response.json();
}

// Usage
const updated = await updateUser(1, {
  name: 'Jane Doe',
  email: 'jane@example.com',
  age: 30
});
```

### PATCH Request

```javascript
// PATCH - partial update
async function patchUser(id, updates) {
  const response = await fetch(`https://api.example.com/users/${id}`, {
    method: 'PATCH',
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify(updates)
  });
  
  return await response.json();
}

// Usage - only update email
const updated = await patchUser(1, {
  email: 'newemail@example.com'
});
```

### DELETE Request

```javascript
// DELETE
async function deleteUser(id) {
  const response = await fetch(`https://api.example.com/users/${id}`, {
    method: 'DELETE'
  });
  
  if (!response.ok) {
    throw new Error(`HTTP error! status: ${response.status}`);
  }
  
  // Some APIs return 204 No Content
  if (response.status === 204) {
    return { success: true };
  }
  
  return await response.json();
}

// Usage
await deleteUser(1);
console.log('User deleted');
```

---

## Error Handling

### Basic Error Handling

```javascript
// Fetch only rejects on network errors, not HTTP errors!
async function fetchWithErrorHandling(url) {
  try {
    const response = await fetch(url);
    
    // Check HTTP status
    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }
    
    const data = await response.json();
    return data;
  } catch (error) {
    console.error('Fetch error:', error);
    throw error;
  }
}
```

### Detailed Error Handling

```javascript
class HTTPError extends Error {
  constructor(response) {
    super(`HTTP Error ${response.status}: ${response.statusText}`);
    this.name = 'HTTPError';
    this.response = response;
  }
}

async function fetchWithDetailedErrors(url) {
  try {
    const response = await fetch(url);
    
    if (!response.ok) {
      throw new HTTPError(response);
    }
    
    return await response.json();
  } catch (error) {
    if (error instanceof HTTPError) {
      // HTTP error
      console.error('HTTP Error:', error.response.status);
      
      // Try to get error message from response
      try {
        const errorData = await error.response.json();
        console.error('Error details:', errorData);
      } catch (e) {
        // Response wasn't JSON
      }
    } else if (error instanceof TypeError) {
      // Network error
      console.error('Network error:', error.message);
    } else {
      // Other errors
      console.error('Error:', error);
    }
    
    throw error;
  }
}
```

### Retry Logic

```javascript
async function fetchWithRetry(url, options = {}, retries = 3, delay = 1000) {
  for (let i = 0; i < retries; i++) {
    try {
      const response = await fetch(url, options);
      
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      
      return await response.json();
    } catch (error) {
      if (i === retries - 1) {
        throw error;
      }
      
      console.log(`Retry ${i + 1}/${retries} after ${delay}ms`);
      await new Promise(resolve => setTimeout(resolve, delay));
      delay *= 2; // Exponential backoff
    }
  }
}

// Usage
const data = await fetchWithRetry('https://api.example.com/data', {}, 3, 1000);
```

### Timeout Implementation

```javascript
// Fetch with timeout
function fetchWithTimeout(url, options = {}, timeout = 5000) {
  return Promise.race([
    fetch(url, options),
    new Promise((_, reject) =>
      setTimeout(() => reject(new Error('Request timeout')), timeout)
    )
  ]);
}

// Usage
try {
  const response = await fetchWithTimeout('https://api.example.com/data', {}, 5000);
  const data = await response.json();
} catch (error) {
  if (error.message === 'Request timeout') {
    console.error('Request took too long');
  }
}

// Using AbortController (better approach)
async function fetchWithAbort(url, timeout = 5000) {
  const controller = new AbortController();
  const timeoutId = setTimeout(() => controller.abort(), timeout);
  
  try {
    const response = await fetch(url, {
      signal: controller.signal
    });
    clearTimeout(timeoutId);
    return await response.json();
  } catch (error) {
    if (error.name === 'AbortError') {
      throw new Error('Request timeout');
    }
    throw error;
  }
}
```

---

## Advanced Features

### Request Cancellation

```javascript
// Using AbortController
const controller = new AbortController();
const signal = controller.signal;

fetch('https://api.example.com/data', { signal })
  .then(response => response.json())
  .then(data => console.log(data))
  .catch(error => {
    if (error.name === 'AbortError') {
      console.log('Request was cancelled');
    } else {
      console.error('Error:', error);
    }
  });

// Cancel the request
controller.abort();

// Practical example: Cancel on component unmount
class DataComponent {
  constructor() {
    this.controller = null;
  }
  
  async fetchData() {
    // Cancel previous request
    if (this.controller) {
      this.controller.abort();
    }
    
    this.controller = new AbortController();
    
    try {
      const response = await fetch('https://api.example.com/data', {
        signal: this.controller.signal
      });
      const data = await response.json();
      this.render(data);
    } catch (error) {
      if (error.name !== 'AbortError') {
        console.error('Error:', error);
      }
    }
  }
  
  destroy() {
    if (this.controller) {
      this.controller.abort();
    }
  }
}

// Search with debounce and cancellation
let searchController = null;

async function search(query) {
  // Cancel previous search
  if (searchController) {
    searchController.abort();
  }
  
  searchController = new AbortController();
  
  try {
    const response = await fetch(`/api/search?q=${query}`, {
      signal: searchController.signal
    });
    const results = await response.json();
    displayResults(results);
  } catch (error) {
    if (error.name !== 'AbortError') {
      console.error('Search error:', error);
    }
  }
}

// Debounced search
const debouncedSearch = debounce(search, 300);
searchInput.addEventListener('input', (e) => {
  debouncedSearch(e.target.value);
});
```

### Streaming Responses

```javascript
// Read response as stream
async function streamResponse(url) {
  const response = await fetch(url);
  const reader = response.body.getReader();
  const decoder = new TextDecoder();
  
  while (true) {
    const { done, value } = await reader.read();
    
    if (done) break;
    
    const chunk = decoder.decode(value, { stream: true });
    console.log('Received chunk:', chunk);
  }
}

// Progress tracking for large downloads
async function downloadWithProgress(url) {
  const response = await fetch(url);
  const contentLength = response.headers.get('content-length');
  const total = parseInt(contentLength, 10);
  let loaded = 0;
  
  const reader = response.body.getReader();
  const chunks = [];
  
  while (true) {
    const { done, value } = await reader.read();
    
    if (done) break;
    
    chunks.push(value);
    loaded += value.length;
    
    const progress = (loaded / total) * 100;
    console.log(`Progress: ${progress.toFixed(2)}%`);
  }
  
  // Combine chunks
  const blob = new Blob(chunks);
  return blob;
}
```

### Parallel Requests

```javascript
// Multiple requests in parallel
async function fetchMultiple(urls) {
  const promises = urls.map(url => fetch(url).then(r => r.json()));
  return await Promise.all(promises);
}

// Usage
const [users, posts, comments] = await fetchMultiple([
  'https://api.example.com/users',
  'https://api.example.com/posts',
  'https://api.example.com/comments'
]);

// With error handling for individual requests
async function fetchMultipleWithErrors(urls) {
  const promises = urls.map(url =>
    fetch(url)
      .then(r => r.json())
      .catch(error => ({ error: error.message, url }))
  );
  
  return await Promise.all(promises);
}

// Race - use fastest response
async function fetchFastest(urls) {
  const promises = urls.map(url => fetch(url).then(r => r.json()));
  return await Promise.race(promises);
}

// Fetch with fallback URLs
async function fetchWithFallback(urls) {
  for (const url of urls) {
    try {
      const response = await fetch(url);
      if (response.ok) {
        return await response.json();
      }
    } catch (error) {
      console.log(`Failed to fetch from ${url}`);
    }
  }
  throw new Error('All requests failed');
}
```

### Request Interceptors

```javascript
// Create a custom fetch wrapper
class FetchClient {
  constructor(baseURL = '', defaultOptions = {}) {
    this.baseURL = baseURL;
    this.defaultOptions = defaultOptions;
    this.interceptors = {
      request: [],
      response: []
    };
  }
  
  addRequestInterceptor(fn) {
    this.interceptors.request.push(fn);
  }
  
  addResponseInterceptor(fn) {
    this.interceptors.response.push(fn);
  }
  
  async fetch(url, options = {}) {
    // Combine URL
    const fullURL = url.startsWith('http') ? url : this.baseURL + url;
    
    // Combine options
    let finalOptions = {
      ...this.defaultOptions,
      ...options,
      headers: {
        ...this.defaultOptions.headers,
        ...options.headers
      }
    };
    
    // Apply request interceptors
    for (const interceptor of this.interceptors.request) {
      finalOptions = await interceptor(finalOptions);
    }
    
    // Make request
    let response = await fetch(fullURL, finalOptions);
    
    // Apply response interceptors
    for (const interceptor of this.interceptors.response) {
      response = await interceptor(response);
    }
    
    return response;
  }
}

// Usage
const client = new FetchClient('https://api.example.com', {
  headers: {
    'Content-Type': 'application/json'
  }
});

// Add auth token to all requests
client.addRequestInterceptor(async (options) => {
  const token = localStorage.getItem('token');
  if (token) {
    options.headers['Authorization'] = `Bearer ${token}`;
  }
  return options;
});

// Log all responses
client.addResponseInterceptor(async (response) => {
  console.log('Response:', response.status, response.url);
  return response;
});

// Handle 401 errors globally
client.addResponseInterceptor(async (response) => {
  if (response.status === 401) {
    console.log('Unauthorized, redirecting to login');
    window.location.href = '/login';
  }
  return response;
});

// Make requests
const data = await client.fetch('/users').then(r => r.json());
```

---

## Best Practices

### API Client Pattern

```javascript
class APIClient {
  constructor(baseURL, token = null) {
    this.baseURL = baseURL;
    this.token = token;
  }
  
  setToken(token) {
    this.token = token;
  }
  
  async request(endpoint, options = {}) {
    const url = `${this.baseURL}${endpoint}`;
    
    const config = {
      ...options,
      headers: {
        'Content-Type': 'application/json',
        ...options.headers
      }
    };
    
    if (this.token) {
      config.headers['Authorization'] = `Bearer ${this.token}`;
    }
    
    if (options.body) {
      config.body = JSON.stringify(options.body);
    }
    
    const response = await fetch(url, config);
    
    if (!response.ok) {
      const error = await response.json().catch(() => ({}));
      throw new Error(error.message || `HTTP error! status: ${response.status}`);
    }
    
    return await response.json();
  }
  
  get(endpoint, options = {}) {
    return this.request(endpoint, { ...options, method: 'GET' });
  }
  
  post(endpoint, body, options = {}) {
    return this.request(endpoint, { ...options, method: 'POST', body });
  }
  
  put(endpoint, body, options = {}) {
    return this.request(endpoint, { ...options, method: 'PUT', body });
  }
  
  patch(endpoint, body, options = {}) {
    return this.request(endpoint, { ...options, method: 'PATCH', body });
  }
  
  delete(endpoint, options = {}) {
    return this.request(endpoint, { ...options, method: 'DELETE' });
  }
}

// Usage
const api = new APIClient('https://api.example.com');

// Set token after login
api.setToken('your-token-here');

// Make requests
const users = await api.get('/users');
const newUser = await api.post('/users', { name: 'John', email: 'john@example.com' });
const updated = await api.patch('/users/1', { name: 'Jane' });
await api.delete('/users/1');
```

### Caching Strategy

```javascript
class CachedAPIClient extends APIClient {
  constructor(baseURL, token = null, cacheDuration = 60000) {
    super(baseURL, token);
    this.cache = new Map();
    this.cacheDuration = cacheDuration;
  }
  
  getCacheKey(endpoint, options) {
    return `${endpoint}-${JSON.stringify(options)}`;
  }
  
  async get(endpoint, options = {}) {
    const cacheKey = this.getCacheKey(endpoint, options);
    const cached = this.cache.get(cacheKey);
    
    if (cached && Date.now() - cached.timestamp < this.cacheDuration) {
      console.log('Returning cached data');
      return cached.data;
    }
    
    const data = await super.get(endpoint, options);
    
    this.cache.set(cacheKey, {
      data,
      timestamp: Date.now()
    });
    
    return data;
  }
  
  clearCache() {
    this.cache.clear();
  }
  
  invalidateCache(endpoint) {
    for (const key of this.cache.keys()) {
      if (key.startsWith(endpoint)) {
        this.cache.delete(key);
      }
    }
  }
}
```

### Loading States

```javascript
class DataFetcher {
  constructor() {
    this.loading = false;
    this.error = null;
    this.data = null;
  }
  
  async fetch(url) {
    this.loading = true;
    this.error = null;
    
    try {
      const response = await fetch(url);
      
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      
      this.data = await response.json();
    } catch (error) {
      this.error = error.message;
    } finally {
      this.loading = false;
    }
    
    return this.data;
  }
}

// Usage in UI
const fetcher = new DataFetcher();

async function loadData() {
  await fetcher.fetch('https://api.example.com/data');
  
  if (fetcher.loading) {
    showLoading();
  } else if (fetcher.error) {
    showError(fetcher.error);
  } else {
    showData(fetcher.data);
  }
}
```

---

## Summary

The Fetch API is a powerful, modern way to make HTTP requests:

1. **Promise-based** for clean async code
2. **Flexible** request/response handling
3. **Supports** all HTTP methods
4. **Handles** various data types
5. **Enables** advanced features like streaming and cancellation

### Key Points

- Always check `response.ok` for HTTP errors
- Use `async/await` for cleaner code
- Implement proper error handling
- Consider caching for performance
- Use AbortController for cancellation
- Build reusable API clients

## Next Steps

- [Async/Await](16_ASYNC_AWAIT.md)
- [Promises](15_PROMISES.md)
- [Events](27_EVENTS.md)
- Practice building API clients and handling real-world scenarios
