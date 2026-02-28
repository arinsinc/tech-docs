# Promises

## What is a Promise?

A Promise is an object representing the eventual completion (or failure) of an asynchronous operation. It's a cleaner alternative to callback functions for handling asynchronous code.

### Promise States

A Promise has three possible states:

1. **Pending**: Initial state, neither fulfilled nor rejected
2. **Fulfilled**: Operation completed successfully
3. **Rejected**: Operation failed

```javascript
// Promise state transitions
Pending → Fulfilled (success)
Pending → Rejected (failure)
```

## Creating a Promise

```javascript
// Basic Promise creation
const promise = new Promise((resolve, reject) => {
    // Asynchronous operation
    const success = true;
    
    if (success) {
        resolve("Operation successful!");  // Fulfill the promise
    } else {
        reject("Operation failed!");       // Reject the promise
    }
});

// Simulated async operation
const fetchData = new Promise((resolve, reject) => {
    setTimeout(() => {
        const data = { id: 1, name: "John" };
        resolve(data);
    }, 1000);
});

// Promise that rejects
const failedOperation = new Promise((resolve, reject) => {
    setTimeout(() => {
        reject(new Error("Something went wrong!"));
    }, 1000);
});
```

## Consuming Promises

### then() Method

```javascript
// Handle success
promise.then((result) => {
    console.log(result);  // "Operation successful!"
});

// Handle both success and error
promise
    .then(
        (result) => console.log(result),    // Success handler
        (error) => console.error(error)     // Error handler
    );

// Chaining then() calls
fetchData
    .then((data) => {
        console.log("Received:", data);
        return data.id;
    })
    .then((id) => {
        console.log("ID:", id);
        return id * 2;
    })
    .then((doubledId) => {
        console.log("Doubled:", doubledId);
    });
```

### catch() Method

```javascript
// Handle errors with catch()
promise
    .then((result) => {
        console.log(result);
    })
    .catch((error) => {
        console.error("Error:", error);
    });

// catch() catches errors from anywhere in the chain
fetchData
    .then((data) => {
        throw new Error("Processing failed!");
    })
    .then((result) => {
        console.log(result);  // This won't run
    })
    .catch((error) => {
        console.error(error);  // Catches the thrown error
    });
```

### finally() Method

```javascript
// Runs regardless of success or failure
fetchData
    .then((data) => {
        console.log(data);
    })
    .catch((error) => {
        console.error(error);
    })
    .finally(() => {
        console.log("Operation completed");
        // Cleanup code, hide loading spinner, etc.
    });
```

## Promise Chaining

```javascript
// Sequential async operations
function getUserById(id) {
    return new Promise((resolve) => {
        setTimeout(() => {
            resolve({ id, name: "John Doe" });
        }, 1000);
    });
}

function getUserPosts(user) {
    return new Promise((resolve) => {
        setTimeout(() => {
            resolve([
                { id: 1, title: "Post 1", author: user.name },
                { id: 2, title: "Post 2", author: user.name }
            ]);
        }, 1000);
    });
}

function getPostComments(post) {
    return new Promise((resolve) => {
        setTimeout(() => {
            resolve([
                { id: 1, text: "Great post!", postId: post.id },
                { id: 2, text: "Thanks for sharing", postId: post.id }
            ]);
        }, 1000);
    });
}

// Chain the operations
getUserById(1)
    .then((user) => {
        console.log("User:", user);
        return getUserPosts(user);
    })
    .then((posts) => {
        console.log("Posts:", posts);
        return getPostComments(posts[0]);
    })
    .then((comments) => {
        console.log("Comments:", comments);
    })
    .catch((error) => {
        console.error("Error:", error);
    });
```

## Static Promise Methods

### Promise.resolve()

```javascript
// Create an immediately resolved promise
const resolved = Promise.resolve("Immediate success");
resolved.then(console.log);  // "Immediate success"

// Convert value to promise
const value = 42;
Promise.resolve(value)
    .then((result) => console.log(result));  // 42

// Flatten nested promises
const nestedPromise = Promise.resolve(
    Promise.resolve("Nested value")
);
nestedPromise.then(console.log);  // "Nested value"
```

### Promise.reject()

```javascript
// Create an immediately rejected promise
const rejected = Promise.reject(new Error("Immediate failure"));
rejected.catch(console.error);

// Useful for early validation
function validateAge(age) {
    if (age < 0) {
        return Promise.reject(new Error("Age cannot be negative"));
    }
    return Promise.resolve(age);
}
```

### Promise.all()

Waits for all promises to resolve, or any to reject.

```javascript
// All promises must succeed
const promise1 = Promise.resolve(1);
const promise2 = Promise.resolve(2);
const promise3 = Promise.resolve(3);

Promise.all([promise1, promise2, promise3])
    .then((results) => {
        console.log(results);  // [1, 2, 3]
    })
    .catch((error) => {
        console.error(error);
    });

// If any promise rejects, Promise.all rejects
const failingPromise = Promise.reject("Failed!");
Promise.all([promise1, failingPromise, promise3])
    .then((results) => {
        console.log(results);  // Won't execute
    })
    .catch((error) => {
        console.error(error);  // "Failed!"
    });

// Practical example: Fetching multiple resources
Promise.all([
    fetch("/api/users"),
    fetch("/api/posts"),
    fetch("/api/comments")
])
    .then((responses) => {
        return Promise.all(responses.map(r => r.json()));
    })
    .then(([users, posts, comments]) => {
        console.log({ users, posts, comments });
    })
    .catch((error) => {
        console.error("One or more requests failed:", error);
    });
```

### Promise.allSettled()

Waits for all promises to settle (resolve or reject).

```javascript
const promises = [
    Promise.resolve(1),
    Promise.reject("Error!"),
    Promise.resolve(3)
];

Promise.allSettled(promises)
    .then((results) => {
        console.log(results);
        /*
        [
            { status: "fulfilled", value: 1 },
            { status: "rejected", reason: "Error!" },
            { status: "fulfilled", value: 3 }
        ]
        */
        
        // Process results
        results.forEach((result) => {
            if (result.status === "fulfilled") {
                console.log("Success:", result.value);
            } else {
                console.error("Failed:", result.reason);
            }
        });
    });
```

### Promise.race()

Returns the first promise that settles (resolves or rejects).

```javascript
const promise1 = new Promise((resolve) => {
    setTimeout(() => resolve("First"), 1000);
});

const promise2 = new Promise((resolve) => {
    setTimeout(() => resolve("Second"), 500);
});

Promise.race([promise1, promise2])
    .then((result) => {
        console.log(result);  // "Second" (faster)
    });

// Timeout pattern
function fetchWithTimeout(url, timeout) {
    return Promise.race([
        fetch(url),
        new Promise((_, reject) => {
            setTimeout(() => reject(new Error("Timeout")), timeout);
        })
    ]);
}

fetchWithTimeout("/api/data", 5000)
    .then((response) => response.json())
    .catch((error) => console.error(error));
```

### Promise.any()

Returns the first fulfilled promise, ignoring rejected ones.

```javascript
const promises = [
    Promise.reject("Error 1"),
    Promise.resolve("Success!"),
    Promise.reject("Error 2")
];

Promise.any(promises)
    .then((result) => {
        console.log(result);  // "Success!"
    })
    .catch((error) => {
        // Only if all promises reject
        console.error("All failed:", error);
    });

// Use case: Try multiple servers
Promise.any([
    fetch("https://server1.com/api"),
    fetch("https://server2.com/api"),
    fetch("https://server3.com/api")
])
    .then((response) => response.json())
    .then((data) => console.log(data))
    .catch(() => console.error("All servers failed"));
```

## Error Handling

```javascript
// Proper error handling
fetchData()
    .then((data) => {
        return processData(data);
    })
    .then((result) => {
        return saveResult(result);
    })
    .catch((error) => {
        // Handles errors from any step
        console.error("Error occurred:", error);
        throw error;  // Re-throw if needed
    })
    .finally(() => {
        console.log("Cleanup");
    });

// Multiple catch blocks
fetchData()
    .then((data) => {
        return riskyOperation(data);
    })
    .catch((error) => {
        // Handle specific error
        console.error("Risky operation failed:", error);
        return fallbackValue;  // Recover from error
    })
    .then((data) => {
        return anotherOperation(data);
    })
    .catch((error) => {
        // Handle errors from anotherOperation
        console.error("Another operation failed:", error);
    });
```

## Common Patterns

### Promisifying Callbacks

```javascript
// Old callback-based function
function readFileCallback(filename, callback) {
    setTimeout(() => {
        if (!filename) {
            callback(new Error("Filename required"), null);
        } else {
            callback(null, "File contents");
        }
    }, 1000);
}

// Convert to Promise
function readFilePromise(filename) {
    return new Promise((resolve, reject) => {
        readFileCallback(filename, (error, data) => {
            if (error) {
                reject(error);
            } else {
                resolve(data);
            }
        });
    });
}

// Use it
readFilePromise("data.txt")
    .then((contents) => console.log(contents))
    .catch((error) => console.error(error));

// Generic promisify function
function promisify(fn) {
    return function(...args) {
        return new Promise((resolve, reject) => {
            fn(...args, (error, result) => {
                if (error) {
                    reject(error);
                } else {
                    resolve(result);
                }
            });
        });
    };
}

const readFilePromisified = promisify(readFileCallback);
```

### Retry Pattern

```javascript
function retry(fn, maxAttempts, delay) {
    return new Promise((resolve, reject) => {
        function attempt(attemptNumber) {
            fn()
                .then(resolve)
                .catch((error) => {
                    if (attemptNumber >= maxAttempts) {
                        reject(error);
                    } else {
                        console.log(`Attempt ${attemptNumber} failed, retrying...`);
                        setTimeout(() => {
                            attempt(attemptNumber + 1);
                        }, delay);
                    }
                });
        }
        attempt(1);
    });
}

// Usage
retry(
    () => fetch("/api/unreliable-endpoint"),
    3,
    1000
)
    .then((response) => response.json())
    .then((data) => console.log(data))
    .catch((error) => console.error("All attempts failed:", error));
```

### Parallel with Limit

```javascript
async function parallelLimit(tasks, limit) {
    const results = [];
    const executing = [];
    
    for (const [index, task] of tasks.entries()) {
        const promise = Promise.resolve().then(() => task());
        results[index] = promise;
        
        if (limit <= tasks.length) {
            const executing = promise.then(() => {
                executing.splice(executing.indexOf(executing), 1);
            });
            executing.push(executing);
            
            if (executing.length >= limit) {
                await Promise.race(executing);
            }
        }
    }
    
    return Promise.all(results);
}

// Usage: Process 10 tasks, max 3 at a time
const tasks = Array.from({ length: 10 }, (_, i) => {
    return () => new Promise(resolve => {
        setTimeout(() => {
            console.log(`Task ${i} completed`);
            resolve(i);
        }, Math.random() * 1000);
    });
});

parallelLimit(tasks, 3)
    .then(results => console.log("All tasks completed:", results));
```

## Best Practices

### 1. Always Return Promises in Chains

```javascript
// Bad: Broken chain
fetchData()
    .then((data) => {
        processData(data);  // Forgot to return!
    })
    .then((result) => {
        console.log(result);  // undefined!
    });

// Good: Proper chain
fetchData()
    .then((data) => {
        return processData(data);
    })
    .then((result) => {
        console.log(result);
    });
```

### 2. Handle Errors

```javascript
// Bad: Unhandled rejection
fetchData()
    .then((data) => console.log(data));

// Good: Error handling
fetchData()
    .then((data) => console.log(data))
    .catch((error) => console.error(error));
```

### 3. Avoid Nesting

```javascript
// Bad: Nested promises (callback hell 2.0)
fetchUser()
    .then((user) => {
        fetchPosts(user).then((posts) => {
            fetchComments(posts[0]).then((comments) => {
                console.log(comments);
            });
        });
    });

// Good: Flat chain
fetchUser()
    .then((user) => fetchPosts(user))
    .then((posts) => fetchComments(posts[0]))
    .then((comments) => console.log(comments))
    .catch((error) => console.error(error));
```

### 4. Use Promise.all() for Parallel Operations

```javascript
// Bad: Sequential (slow)
const user = await fetchUser();
const posts = await fetchPosts();
const comments = await fetchComments();

// Good: Parallel (fast)
const [user, posts, comments] = await Promise.all([
    fetchUser(),
    fetchPosts(),
    fetchComments()
]);
```

## Summary

- Promises represent eventual completion of async operations
- Three states: pending, fulfilled, rejected
- Use `.then()`, `.catch()`, `.finally()` to handle results
- `Promise.all()` for parallel operations
- `Promise.race()` for timeout patterns
- `Promise.allSettled()` when you need all results
- Always handle errors with `.catch()`
- Avoid nesting promises

## Next Steps

Continue to [Async/Await](16_ASYNC_AWAIT.md) to learn about the modern syntax for handling promises.
