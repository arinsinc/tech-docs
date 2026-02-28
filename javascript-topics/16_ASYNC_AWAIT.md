# Async/Await

## What is Async/Await?

**Async/Await** is a modern syntax for handling asynchronous operations in JavaScript. It's built on top of Promises and makes asynchronous code look and behave more like synchronous code.

- `async` declares a function as asynchronous
- `await` pauses execution until a Promise resolves
- Makes code more readable and easier to reason about

### Basic Syntax

```javascript
// Async function
async function fetchData() {
    const response = await fetch('https://api.example.com/data');
    const data = await response.json();
    return data;
}

// Async arrow function
const fetchData = async () => {
    const response = await fetch('https://api.example.com/data');
    const data = await response.json();
    return data;
};
```

## The `async` Keyword

Functions declared with `async` always return a Promise.

```javascript
// Regular function
function regularFunction() {
    return "Hello";
}

console.log(regularFunction());  // "Hello"

// Async function always returns a Promise
async function asyncFunction() {
    return "Hello";
}

console.log(asyncFunction());  // Promise { "Hello" }

asyncFunction().then(result => {
    console.log(result);  // "Hello"
});
```

### Async Function Return Values

```javascript
// Returning a value
async function getValue() {
    return 42;
}

getValue().then(value => console.log(value));  // 42

// Returning a Promise
async function getPromise() {
    return Promise.resolve(100);
}

getPromise().then(value => console.log(value));  // 100

// Throwing an error
async function throwError() {
    throw new Error("Something went wrong!");
}

throwError().catch(err => console.error(err.message));  // "Something went wrong!"
```

## The `await` Keyword

`await` can only be used inside `async` functions and pauses execution until a Promise settles.

```javascript
async function example() {
    // Pause and wait for Promise to resolve
    const result = await Promise.resolve("Done!");
    console.log(result);  // "Done!"
}

example();

// ❌ Cannot use await outside async function
// const result = await Promise.resolve("Done!");  // SyntaxError
```

### Await with Different Promise States

```javascript
async function demonstrateAwait() {
    // Await resolved Promise
    const success = await Promise.resolve("Success!");
    console.log(success);  // "Success!"
    
    try {
        // Await rejected Promise
        const failure = await Promise.reject("Failed!");
        console.log(failure);  // This won't execute
    } catch (error) {
        console.error(error);  // "Failed!"
    }
    
    // Await delayed Promise
    const delayed = await new Promise(resolve => {
        setTimeout(() => resolve("After 2 seconds"), 2000);
    });
    console.log(delayed);  // "After 2 seconds" (after 2 second delay)
}

demonstrateAwait();
```

## Converting Promises to Async/Await

### Before: Promise Chains

```javascript
// Using Promises
function fetchUserData(userId) {
    return fetch(`https://api.example.com/users/${userId}`)
        .then(response => response.json())
        .then(user => {
            return fetch(`https://api.example.com/posts?userId=${user.id}`);
        })
        .then(response => response.json())
        .then(posts => {
            console.log(posts);
            return posts;
        })
        .catch(error => {
            console.error("Error:", error);
            throw error;
        });
}
```

### After: Async/Await

```javascript
// Using async/await (much cleaner!)
async function fetchUserData(userId) {
    try {
        const userResponse = await fetch(`https://api.example.com/users/${userId}`);
        const user = await userResponse.json();
        
        const postsResponse = await fetch(`https://api.example.com/posts?userId=${user.id}`);
        const posts = await postsResponse.json();
        
        console.log(posts);
        return posts;
    } catch (error) {
        console.error("Error:", error);
        throw error;
    }
}
```

## Error Handling

### Try-Catch Blocks

```javascript
async function fetchData() {
    try {
        const response = await fetch('https://api.example.com/data');
        
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        
        const data = await response.json();
        return data;
    } catch (error) {
        console.error("Failed to fetch data:", error.message);
        throw error;  // Re-throw or handle as needed
    }
}

// Usage
fetchData()
    .then(data => console.log(data))
    .catch(err => console.error("Caught:", err));
```

### Multiple Error Types

```javascript
async function complexOperation() {
    try {
        const data = await riskyOperation();
        return data;
    } catch (error) {
        if (error.name === 'NetworkError') {
            console.error("Network problem:", error.message);
            return null;
        } else if (error.name === 'ValidationError') {
            console.error("Invalid data:", error.message);
            throw error;  // Re-throw validation errors
        } else {
            console.error("Unknown error:", error);
            throw error;
        }
    }
}
```

### Finally Block

```javascript
async function fetchWithCleanup() {
    let connection = null;
    
    try {
        connection = await openConnection();
        const data = await fetchData(connection);
        return data;
    } catch (error) {
        console.error("Error:", error);
        throw error;
    } finally {
        // Always executes, even if error thrown
        if (connection) {
            await closeConnection(connection);
            console.log("Connection closed");
        }
    }
}
```

## Sequential vs Parallel Execution

### Sequential Execution (One After Another)

```javascript
async function sequential() {
    console.time('sequential');
    
    // These run one after another
    const result1 = await operation1();  // Wait for 1 second
    const result2 = await operation2();  // Wait for 1 second
    const result3 = await operation3();  // Wait for 1 second
    
    console.timeEnd('sequential');  // ~3 seconds
    return [result1, result2, result3];
}
```

### Parallel Execution (All at Once)

```javascript
async function parallel() {
    console.time('parallel');
    
    // Start all operations at once
    const promise1 = operation1();
    const promise2 = operation2();
    const promise3 = operation3();
    
    // Wait for all to complete
    const result1 = await promise1;
    const result2 = await promise2;
    const result3 = await promise3;
    
    console.timeEnd('parallel');  // ~1 second
    return [result1, result2, result3];
}

// Or use Promise.all
async function parallelWithPromiseAll() {
    console.time('parallel-all');
    
    const results = await Promise.all([
        operation1(),
        operation2(),
        operation3()
    ]);
    
    console.timeEnd('parallel-all');  // ~1 second
    return results;
}
```

### When to Use Each

```javascript
// ✅ Sequential: When operations depend on each other
async function sequentialNeeded() {
    const user = await fetchUser(userId);
    const profile = await fetchProfile(user.profileId);  // Needs user data
    const settings = await fetchSettings(profile.settingsId);  // Needs profile data
    return settings;
}

// ✅ Parallel: When operations are independent
async function parallelNeeded() {
    const [users, products, categories] = await Promise.all([
        fetchUsers(),      // Independent
        fetchProducts(),   // Independent
        fetchCategories()  // Independent
    ]);
    return { users, products, categories };
}
```

## Promise Combinators with Async/Await

### Promise.all() - Wait for All

```javascript
async function fetchAllData() {
    try {
        const [users, posts, comments] = await Promise.all([
            fetch('/api/users').then(r => r.json()),
            fetch('/api/posts').then(r => r.json()),
            fetch('/api/comments').then(r => r.json())
        ]);
        
        return { users, posts, comments };
    } catch (error) {
        // If ANY promise rejects, catch block executes
        console.error("One or more requests failed:", error);
        throw error;
    }
}
```

### Promise.allSettled() - Wait for All (No Fail)

```javascript
async function fetchAllDataSafe() {
    const results = await Promise.allSettled([
        fetch('/api/users').then(r => r.json()),
        fetch('/api/posts').then(r => r.json()),
        fetch('/api/comments').then(r => r.json())
    ]);
    
    // Check each result
    results.forEach((result, index) => {
        if (result.status === 'fulfilled') {
            console.log(`Request ${index} succeeded:`, result.value);
        } else {
            console.error(`Request ${index} failed:`, result.reason);
        }
    });
    
    return results;
}
```

### Promise.race() - First to Finish

```javascript
async function fetchWithTimeout(url, timeout = 5000) {
    try {
        const result = await Promise.race([
            fetch(url).then(r => r.json()),
            new Promise((_, reject) => 
                setTimeout(() => reject(new Error('Timeout')), timeout)
            )
        ]);
        return result;
    } catch (error) {
        console.error("Request failed or timed out:", error);
        throw error;
    }
}

// Usage
const data = await fetchWithTimeout('https://api.example.com/data', 3000);
```

### Promise.any() - First Successful

```javascript
async function fetchFromMirrors() {
    try {
        // Try multiple servers, return first success
        const data = await Promise.any([
            fetch('https://mirror1.example.com/data'),
            fetch('https://mirror2.example.com/data'),
            fetch('https://mirror3.example.com/data')
        ]);
        
        return await data.json();
    } catch (error) {
        // All requests failed
        console.error("All mirrors failed:", error);
        throw error;
    }
}
```

## Async/Await Patterns

### Retry Pattern

```javascript
async function retry(fn, maxAttempts = 3, delay = 1000) {
    for (let attempt = 1; attempt <= maxAttempts; attempt++) {
        try {
            return await fn();
        } catch (error) {
            if (attempt === maxAttempts) {
                throw error;
            }
            console.log(`Attempt ${attempt} failed, retrying...`);
            await new Promise(resolve => setTimeout(resolve, delay));
        }
    }
}

// Usage
const data = await retry(
    () => fetch('https://api.example.com/data').then(r => r.json()),
    3,
    2000
);
```

### Timeout Pattern

```javascript
function timeout(promise, ms) {
    return Promise.race([
        promise,
        new Promise((_, reject) =>
            setTimeout(() => reject(new Error('Operation timed out')), ms)
        )
    ]);
}

// Usage
async function fetchWithTimeout() {
    try {
        const data = await timeout(
            fetch('https://api.example.com/data').then(r => r.json()),
            5000
        );
        return data;
    } catch (error) {
        console.error("Fetch failed or timed out:", error);
        throw error;
    }
}
```

### Rate Limiting Pattern

```javascript
async function sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
}

async function processWithRateLimit(items, limit, delayMs) {
    const results = [];
    
    for (let i = 0; i < items.length; i += limit) {
        const batch = items.slice(i, i + limit);
        const batchResults = await Promise.all(
            batch.map(item => processItem(item))
        );
        results.push(...batchResults);
        
        // Wait before next batch
        if (i + limit < items.length) {
            await sleep(delayMs);
        }
    }
    
    return results;
}

// Process 5 items at a time with 1 second delay between batches
const results = await processWithRateLimit(items, 5, 1000);
```

### Caching Pattern

```javascript
const cache = new Map();

async function fetchWithCache(url) {
    // Check cache first
    if (cache.has(url)) {
        console.log('Cache hit');
        return cache.get(url);
    }
    
    // Fetch if not cached
    console.log('Cache miss, fetching...');
    const response = await fetch(url);
    const data = await response.json();
    
    // Store in cache
    cache.set(url, data);
    
    return data;
}

// Usage
const data1 = await fetchWithCache('https://api.example.com/users');  // Fetches
const data2 = await fetchWithCache('https://api.example.com/users');  // From cache
```

## Async Iteration

### For-Await-Of Loop

```javascript
// Async generator
async function* generateNumbers() {
    for (let i = 1; i <= 5; i++) {
        await new Promise(resolve => setTimeout(resolve, 1000));
        yield i;
    }
}

// Iterate over async iterable
async function consumeNumbers() {
    for await (const num of generateNumbers()) {
        console.log(num);  // Logs 1, 2, 3, 4, 5 (one per second)
    }
}

consumeNumbers();
```

### Processing Array Items Asynchronously

```javascript
const urls = [
    'https://api.example.com/user/1',
    'https://api.example.com/user/2',
    'https://api.example.com/user/3'
];

// Sequential processing
async function processSequentially() {
    const results = [];
    
    for (const url of urls) {
        const response = await fetch(url);
        const data = await response.json();
        results.push(data);
    }
    
    return results;
}

// Parallel processing
async function processInParallel() {
    const promises = urls.map(async (url) => {
        const response = await fetch(url);
        return await response.json();
    });
    
    return await Promise.all(promises);
}

// Using for-await-of with async map
async function processWithForAwait() {
    const results = [];
    
    for await (const result of urls.map(fetch)) {
        const data = await result.json();
        results.push(data);
    }
    
    return results;
}
```

## Real-World Examples

### API Request with Loading State

```javascript
async function loadUserData(userId) {
    const loadingElement = document.getElementById('loading');
    const contentElement = document.getElementById('content');
    const errorElement = document.getElementById('error');
    
    try {
        // Show loading
        loadingElement.style.display = 'block';
        contentElement.style.display = 'none';
        errorElement.style.display = 'none';
        
        // Fetch data
        const response = await fetch(`/api/users/${userId}`);
        
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        
        const user = await response.json();
        
        // Show content
        loadingElement.style.display = 'none';
        contentElement.style.display = 'block';
        contentElement.innerHTML = `
            <h2>${user.name}</h2>
            <p>${user.email}</p>
        `;
    } catch (error) {
        // Show error
        loadingElement.style.display = 'none';
        errorElement.style.display = 'block';
        errorElement.textContent = `Error: ${error.message}`;
    }
}
```

### Form Submission

```javascript
async function submitForm(formData) {
    const submitButton = document.getElementById('submit');
    
    try {
        // Disable button
        submitButton.disabled = true;
        submitButton.textContent = 'Submitting...';
        
        const response = await fetch('/api/submit', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(formData)
        });
        
        if (!response.ok) {
            const error = await response.json();
            throw new Error(error.message);
        }
        
        const result = await response.json();
        
        // Success
        alert('Form submitted successfully!');
        return result;
    } catch (error) {
        alert(`Error: ${error.message}`);
        throw error;
    } finally {
        // Re-enable button
        submitButton.disabled = false;
        submitButton.textContent = 'Submit';
    }
}
```

### File Upload with Progress

```javascript
async function uploadFile(file) {
    const formData = new FormData();
    formData.append('file', file);
    
    try {
        const response = await fetch('/api/upload', {
            method: 'POST',
            body: formData
        });
        
        if (!response.ok) {
            throw new Error('Upload failed');
        }
        
        const result = await response.json();
        console.log('Upload complete:', result);
        return result;
    } catch (error) {
        console.error('Upload error:', error);
        throw error;
    }
}

// Usage with file input
document.getElementById('fileInput').addEventListener('change', async (e) => {
    const file = e.target.files[0];
    if (file) {
        try {
            await uploadFile(file);
            alert('File uploaded successfully!');
        } catch (error) {
            alert('Upload failed: ' + error.message);
        }
    }
});
```

### Database Operations (Node.js)

```javascript
async function createUser(userData) {
    const connection = await pool.getConnection();
    
    try {
        // Start transaction
        await connection.beginTransaction();
        
        // Insert user
        const [userResult] = await connection.query(
            'INSERT INTO users (name, email) VALUES (?, ?)',
            [userData.name, userData.email]
        );
        
        const userId = userResult.insertId;
        
        // Insert user profile
        await connection.query(
            'INSERT INTO profiles (user_id, bio) VALUES (?, ?)',
            [userId, userData.bio]
        );
        
        // Commit transaction
        await connection.commit();
        
        return { id: userId, ...userData };
    } catch (error) {
        // Rollback on error
        await connection.rollback();
        console.error('Transaction failed:', error);
        throw error;
    } finally {
        // Release connection
        connection.release();
    }
}
```

## Common Pitfalls

### Forgetting to Use Await

```javascript
// ❌ BAD: Forgot await
async function fetchUser() {
    const user = fetch('/api/user').then(r => r.json());
    console.log(user);  // Promise { <pending> }
    return user.name;   // Error: Cannot read property 'name' of undefined
}

// ✅ GOOD: Use await
async function fetchUser() {
    const response = await fetch('/api/user');
    const user = await response.json();
    console.log(user);  // { id: 1, name: "John" }
    return user.name;   // "John"
}
```

### Using Async in forEach

```javascript
const ids = [1, 2, 3, 4, 5];

// ❌ BAD: forEach doesn't wait for async operations
ids.forEach(async (id) => {
    const user = await fetchUser(id);
    console.log(user);
});
console.log('Done');  // Logs before users are fetched!

// ✅ GOOD: Use for...of loop
async function processUsers() {
    for (const id of ids) {
        const user = await fetchUser(id);
        console.log(user);
    }
    console.log('Done');  // Logs after all users are fetched
}

// ✅ GOOD: Use Promise.all for parallel
async function processUsersParallel() {
    const users = await Promise.all(
        ids.map(id => fetchUser(id))
    );
    users.forEach(user => console.log(user));
    console.log('Done');
}
```

### Not Handling Errors

```javascript
// ❌ BAD: Unhandled errors
async function fetchData() {
    const response = await fetch('/api/data');
    return await response.json();  // Throws if network error
}

fetchData();  // Unhandled promise rejection!

// ✅ GOOD: Always handle errors
async function fetchData() {
    try {
        const response = await fetch('/api/data');
        return await response.json();
    } catch (error) {
        console.error('Fetch failed:', error);
        throw error;
    }
}

fetchData().catch(err => console.error('Caught:', err));
```

### Returning Without Await

```javascript
// ❌ BAD: Returns Promise instead of value
async function getUser(id) {
    return fetchUser(id);  // Returns Promise<User>
}

// ✅ GOOD: Awaits before returning
async function getUser(id) {
    return await fetchUser(id);  // Returns User
}

// Note: Both work, but second is clearer about waiting
```

## Async/Await Best Practices

### 1. Always Handle Errors

```javascript
// ✅ Use try-catch
async function safeOperation() {
    try {
        const result = await riskyOperation();
        return result;
    } catch (error) {
        console.error('Error:', error);
        // Handle or rethrow
    }
}
```

### 2. Avoid Sequential Awaits for Independent Operations

```javascript
// ❌ BAD: Unnecessary sequential execution
async function slow() {
    const a = await fetchA();  // 1 second
    const b = await fetchB();  // 1 second
    // Total: 2 seconds
}

// ✅ GOOD: Parallel execution
async function fast() {
    const [a, b] = await Promise.all([
        fetchA(),
        fetchB()
    ]);
    // Total: 1 second
}
```

### 3. Use Finally for Cleanup

```javascript
async function withCleanup() {
    let resource = null;
    try {
        resource = await acquireResource();
        return await useResource(resource);
    } catch (error) {
        console.error('Error:', error);
        throw error;
    } finally {
        if (resource) {
            await releaseResource(resource);
        }
    }
}
```

### 4. Keep Async Functions Focused

```javascript
// ✅ Small, focused functions
async function fetchUser(id) {
    const response = await fetch(`/api/users/${id}`);
    return await response.json();
}

async function fetchUserPosts(userId) {
    const response = await fetch(`/api/posts?userId=${userId}`);
    return await response.json();
}

async function getUserWithPosts(id) {
    const user = await fetchUser(id);
    const posts = await fetchUserPosts(id);
    return { user, posts };
}
```

### 5. Use Descriptive Variable Names

```javascript
// ❌ BAD: Unclear names
async function getData() {
    const r = await fetch('/api/data');
    const d = await r.json();
    return d;
}

// ✅ GOOD: Clear names
async function getUserData() {
    const response = await fetch('/api/users');
    const userData = await response.json();
    return userData;
}
```

## Summary

- **Async/await** provides cleaner syntax for Promises
- `async` functions always return Promises
- `await` pauses execution until Promise settles
- Use **try-catch** for error handling
- **Sequential** execution for dependent operations
- **Parallel** execution (Promise.all) for independent operations
- Avoid common pitfalls: forgetting await, async in forEach
- Always handle errors and clean up resources
- Modern JavaScript preferred over callback hell

## Further Reading

- [MDN: async function](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/async_function)
- [MDN: await](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/await)
- [JavaScript.info: Async/Await](https://javascript.info/async-await)
- [Promises, async/await](https://developer.mozilla.org/en-US/docs/Learn/JavaScript/Asynchronous/Promises)
