# Callbacks

## What is a Callback?

A **callback** is a function passed as an argument to another function, which is then invoked inside the outer function to complete an action.

Callbacks are fundamental to JavaScript's asynchronous programming model.

### Basic Concept

```javascript
// Simple callback example
function greet(name, callback) {
    console.log(`Hello, ${name}!`);
    callback();
}

function sayGoodbye() {
    console.log("Goodbye!");
}

greet("John", sayGoodbye);
// Output:
// Hello, John!
// Goodbye!
```

### Why Use Callbacks?

```javascript
// Synchronous code - executes in order
console.log("Start");
console.log("Middle");
console.log("End");

// Asynchronous code - doesn't wait
console.log("Start");
setTimeout(() => {
    console.log("Middle (after 2 seconds)");
}, 2000);
console.log("End");

// Output:
// Start
// End
// Middle (after 2 seconds)
```

## Types of Callbacks

### Synchronous Callbacks

Executed immediately within the calling function.

```javascript
// Array methods use synchronous callbacks
const numbers = [1, 2, 3, 4, 5];

// forEach callback
numbers.forEach(function(num) {
    console.log(num * 2);
});

// map callback
const doubled = numbers.map(function(num) {
    return num * 2;
});
console.log(doubled);  // [2, 4, 6, 8, 10]

// filter callback
const evens = numbers.filter(function(num) {
    return num % 2 === 0;
});
console.log(evens);  // [2, 4]

// reduce callback
const sum = numbers.reduce(function(acc, num) {
    return acc + num;
}, 0);
console.log(sum);  // 15
```

### Asynchronous Callbacks

Executed later, after an asynchronous operation completes.

```javascript
// setTimeout
setTimeout(function() {
    console.log("This runs after 1 second");
}, 1000);

// setInterval
let count = 0;
const intervalId = setInterval(function() {
    count++;
    console.log(`Count: ${count}`);
    if (count === 5) {
        clearInterval(intervalId);
    }
}, 1000);

// Event listeners
document.getElementById("myButton").addEventListener("click", function(event) {
    console.log("Button clicked!");
});

// File reading (Node.js)
const fs = require('fs');
fs.readFile('file.txt', 'utf8', function(err, data) {
    if (err) {
        console.error("Error reading file:", err);
        return;
    }
    console.log(data);
});
```

## Callback Patterns

### Error-First Callbacks (Node.js Convention)

```javascript
// Standard Node.js callback pattern
function readFileCallback(filename, callback) {
    // Simulate async file reading
    setTimeout(() => {
        const error = null;
        const data = "File contents here";
        
        // Always call callback with (error, result)
        callback(error, data);
    }, 1000);
}

// Usage
readFileCallback('data.txt', function(err, data) {
    if (err) {
        console.error("Error:", err);
        return;
    }
    console.log("Data:", data);
});
```

### Callback with Multiple Parameters

```javascript
function fetchUser(userId, onSuccess, onError) {
    // Simulate API call
    setTimeout(() => {
        const users = {
            1: { id: 1, name: "John", email: "john@example.com" },
            2: { id: 2, name: "Jane", email: "jane@example.com" }
        };
        
        const user = users[userId];
        
        if (user) {
            onSuccess(user);
        } else {
            onError(new Error("User not found"));
        }
    }, 1000);
}

// Usage
fetchUser(
    1,
    function(user) {
        console.log("Success:", user);
    },
    function(error) {
        console.error("Error:", error.message);
    }
);
```

### Callback Options Object

```javascript
function processData(data, options) {
    const {
        onStart,
        onProgress,
        onComplete,
        onError
    } = options;
    
    if (onStart) onStart();
    
    try {
        data.forEach((item, index) => {
            // Process item
            if (onProgress) {
                onProgress(index + 1, data.length);
            }
        });
        
        if (onComplete) onComplete();
    } catch (error) {
        if (onError) onError(error);
    }
}

// Usage
processData([1, 2, 3, 4, 5], {
    onStart: () => console.log("Processing started"),
    onProgress: (current, total) => {
        console.log(`Progress: ${current}/${total}`);
    },
    onComplete: () => console.log("Processing complete"),
    onError: (err) => console.error("Error:", err)
});
```

## Common Callback Use Cases

### Timer Functions

```javascript
// setTimeout - execute once after delay
const timeoutId = setTimeout(function() {
    console.log("Executed after 2 seconds");
}, 2000);

// Cancel timeout
clearTimeout(timeoutId);

// setInterval - execute repeatedly
let counter = 0;
const intervalId = setInterval(function() {
    counter++;
    console.log(`Interval ${counter}`);
    
    if (counter === 5) {
        clearInterval(intervalId);
        console.log("Interval cleared");
    }
}, 1000);

// setImmediate (Node.js) - execute on next event loop
setImmediate(function() {
    console.log("Executed immediately after I/O events");
});
```

### Event Handlers

```javascript
// DOM events
const button = document.getElementById("myButton");

button.addEventListener("click", function(event) {
    console.log("Button clicked!");
    console.log("Event:", event);
});

// Multiple event listeners
button.addEventListener("mouseenter", function() {
    console.log("Mouse entered");
});

button.addEventListener("mouseleave", function() {
    console.log("Mouse left");
});

// Remove event listener
function handleClick() {
    console.log("Clicked!");
}

button.addEventListener("click", handleClick);
button.removeEventListener("click", handleClick);
```

### Array Methods

```javascript
const users = [
    { id: 1, name: "John", age: 30, active: true },
    { id: 2, name: "Jane", age: 25, active: false },
    { id: 3, name: "Bob", age: 35, active: true }
];

// map - transform each element
const names = users.map(function(user) {
    return user.name;
});
console.log(names);  // ["John", "Jane", "Bob"]

// filter - select elements
const activeUsers = users.filter(function(user) {
    return user.active;
});
console.log(activeUsers);  // [{id: 1, ...}, {id: 3, ...}]

// find - find first match
const jane = users.find(function(user) {
    return user.name === "Jane";
});
console.log(jane);  // {id: 2, name: "Jane", ...}

// some - test if any match
const hasYoungUsers = users.some(function(user) {
    return user.age < 30;
});
console.log(hasYoungUsers);  // true

// every - test if all match
const allActive = users.every(function(user) {
    return user.active;
});
console.log(allActive);  // false

// reduce - accumulate value
const totalAge = users.reduce(function(sum, user) {
    return sum + user.age;
}, 0);
console.log(totalAge);  // 90
```

### API Calls

```javascript
// XMLHttpRequest with callbacks
function makeRequest(url, callback) {
    const xhr = new XMLHttpRequest();
    
    xhr.onload = function() {
        if (xhr.status === 200) {
            callback(null, JSON.parse(xhr.responseText));
        } else {
            callback(new Error(`HTTP Error: ${xhr.status}`));
        }
    };
    
    xhr.onerror = function() {
        callback(new Error("Network error"));
    };
    
    xhr.open("GET", url);
    xhr.send();
}

// Usage
makeRequest("https://api.example.com/users", function(err, data) {
    if (err) {
        console.error("Error:", err);
        return;
    }
    console.log("Data:", data);
});
```

## Callback Hell (Pyramid of Doom)

### The Problem

```javascript
// ❌ Nested callbacks become hard to read and maintain
getUser(userId, function(err, user) {
    if (err) {
        console.error(err);
        return;
    }
    
    getOrders(user.id, function(err, orders) {
        if (err) {
            console.error(err);
            return;
        }
        
        getOrderDetails(orders[0].id, function(err, details) {
            if (err) {
                console.error(err);
                return;
            }
            
            processPayment(details, function(err, payment) {
                if (err) {
                    console.error(err);
                    return;
                }
                
                sendConfirmation(payment, function(err, result) {
                    if (err) {
                        console.error(err);
                        return;
                    }
                    
                    console.log("All done!", result);
                });
            });
        });
    });
});
```

### Solutions

#### 1. Named Functions

```javascript
// ✅ Break callbacks into named functions
function handleUser(err, user) {
    if (err) {
        console.error(err);
        return;
    }
    getOrders(user.id, handleOrders);
}

function handleOrders(err, orders) {
    if (err) {
        console.error(err);
        return;
    }
    getOrderDetails(orders[0].id, handleDetails);
}

function handleDetails(err, details) {
    if (err) {
        console.error(err);
        return;
    }
    processPayment(details, handlePayment);
}

function handlePayment(err, payment) {
    if (err) {
        console.error(err);
        return;
    }
    sendConfirmation(payment, handleConfirmation);
}

function handleConfirmation(err, result) {
    if (err) {
        console.error(err);
        return;
    }
    console.log("All done!", result);
}

getUser(userId, handleUser);
```

#### 2. Modularization

```javascript
// ✅ Separate concerns into modules
function getUserAndOrders(userId, callback) {
    getUser(userId, function(err, user) {
        if (err) return callback(err);
        
        getOrders(user.id, function(err, orders) {
            if (err) return callback(err);
            callback(null, { user, orders });
        });
    });
}

function processOrderPayment(orderId, callback) {
    getOrderDetails(orderId, function(err, details) {
        if (err) return callback(err);
        
        processPayment(details, function(err, payment) {
            if (err) return callback(err);
            callback(null, payment);
        });
    });
}

// Usage
getUserAndOrders(userId, function(err, data) {
    if (err) return console.error(err);
    
    processOrderPayment(data.orders[0].id, function(err, payment) {
        if (err) return console.error(err);
        
        sendConfirmation(payment, function(err, result) {
            if (err) return console.error(err);
            console.log("All done!", result);
        });
    });
});
```

#### 3. Use Promises or Async/Await

```javascript
// ✅ Modern approach - use Promises
getUser(userId)
    .then(user => getOrders(user.id))
    .then(orders => getOrderDetails(orders[0].id))
    .then(details => processPayment(details))
    .then(payment => sendConfirmation(payment))
    .then(result => console.log("All done!", result))
    .catch(err => console.error(err));

// ✅ Even better - use async/await
async function processUserOrder(userId) {
    try {
        const user = await getUser(userId);
        const orders = await getOrders(user.id);
        const details = await getOrderDetails(orders[0].id);
        const payment = await processPayment(details);
        const result = await sendConfirmation(payment);
        console.log("All done!", result);
    } catch (err) {
        console.error(err);
    }
}
```

## Error Handling in Callbacks

### Pattern 1: Error-First Callbacks

```javascript
function readFile(filename, callback) {
    // Simulate async operation
    setTimeout(() => {
        if (!filename) {
            // First argument is always the error
            callback(new Error("Filename is required"), null);
            return;
        }
        
        // Success: error is null, second arg is result
        callback(null, "File contents");
    }, 1000);
}

// Usage
readFile("data.txt", function(err, data) {
    if (err) {
        console.error("Error:", err.message);
        return;
    }
    console.log("Data:", data);
});
```

### Pattern 2: Separate Success/Error Callbacks

```javascript
function fetchData(url, onSuccess, onError) {
    setTimeout(() => {
        const success = Math.random() > 0.5;
        
        if (success) {
            onSuccess({ data: "Some data" });
        } else {
            onError(new Error("Failed to fetch"));
        }
    }, 1000);
}

// Usage
fetchData(
    "https://api.example.com/data",
    function(data) {
        console.log("Success:", data);
    },
    function(error) {
        console.error("Error:", error.message);
    }
);
```

### Pattern 3: Try-Catch for Sync Errors

```javascript
function processWithCallback(data, callback) {
    try {
        // Synchronous code that might throw
        const result = JSON.parse(data);
        callback(null, result);
    } catch (error) {
        callback(error, null);
    }
}

// Usage
processWithCallback('{"name":"John"}', function(err, result) {
    if (err) {
        console.error("Parse error:", err.message);
        return;
    }
    console.log("Parsed:", result);
});
```

## Callback Best Practices

### 1. Always Handle Errors

```javascript
// ❌ BAD: No error handling
fs.readFile('file.txt', function(err, data) {
    console.log(data);  // Will crash if there's an error
});

// ✅ GOOD: Handle errors first
fs.readFile('file.txt', function(err, data) {
    if (err) {
        console.error("Error:", err);
        return;
    }
    console.log(data);
});
```

### 2. Avoid Anonymous Functions for Complex Logic

```javascript
// ❌ BAD: Hard to debug anonymous function
button.addEventListener('click', function(e) {
    // 50 lines of code...
});

// ✅ GOOD: Named function for clarity
function handleButtonClick(e) {
    // 50 lines of code...
    // Easier to debug, test, and reuse
}

button.addEventListener('click', handleButtonClick);
```

### 3. Return After Callback

```javascript
// ❌ BAD: Code continues after callback
function processUser(id, callback) {
    if (!id) {
        callback(new Error("ID required"));
        // Dangerous! Code below still executes
    }
    
    // This will still run!
    callback(null, { id: id });
}

// ✅ GOOD: Return after callback
function processUser(id, callback) {
    if (!id) {
        callback(new Error("ID required"));
        return;  // Stop execution
    }
    
    callback(null, { id: id });
}
```

### 4. Call Callback Only Once

```javascript
// ❌ BAD: Multiple callback calls
function getData(callback) {
    if (Math.random() > 0.5) {
        callback(null, "data");
    }
    callback(null, "more data");  // Called twice!
}

// ✅ GOOD: Single callback call
function getData(callback) {
    if (Math.random() > 0.5) {
        callback(null, "data");
        return;
    }
    callback(null, "more data");
}
```

### 5. Use Arrow Functions for Brevity

```javascript
// Traditional function
numbers.map(function(n) {
    return n * 2;
});

// ✅ Arrow function (cleaner)
numbers.map(n => n * 2);

// With multiple statements
numbers.forEach(n => {
    const doubled = n * 2;
    console.log(doubled);
});
```

## Advanced Callback Patterns

### Callback Queue

```javascript
function TaskQueue() {
    this.tasks = [];
    this.running = false;
}

TaskQueue.prototype.add = function(task) {
    this.tasks.push(task);
    if (!this.running) {
        this.run();
    }
};

TaskQueue.prototype.run = function() {
    if (this.tasks.length === 0) {
        this.running = false;
        return;
    }
    
    this.running = true;
    const task = this.tasks.shift();
    
    task(() => {
        this.run();  // Process next task
    });
};

// Usage
const queue = new TaskQueue();

queue.add(function(done) {
    console.log("Task 1");
    setTimeout(done, 1000);
});

queue.add(function(done) {
    console.log("Task 2");
    setTimeout(done, 500);
});

queue.add(function(done) {
    console.log("Task 3");
    done();
});
```

### Parallel Callbacks

```javascript
function parallel(tasks, callback) {
    let completed = 0;
    const results = [];
    
    tasks.forEach((task, index) => {
        task((err, result) => {
            if (err) {
                callback(err);
                return;
            }
            
            results[index] = result;
            completed++;
            
            if (completed === tasks.length) {
                callback(null, results);
            }
        });
    });
}

// Usage
parallel([
    cb => setTimeout(() => cb(null, "Result 1"), 1000),
    cb => setTimeout(() => cb(null, "Result 2"), 500),
    cb => setTimeout(() => cb(null, "Result 3"), 800)
], function(err, results) {
    if (err) {
        console.error(err);
        return;
    }
    console.log(results);  // ["Result 1", "Result 2", "Result 3"]
});
```

### Waterfall Pattern

```javascript
function waterfall(tasks, callback) {
    let index = 0;
    
    function next(...args) {
        if (index >= tasks.length) {
            callback(null, ...args);
            return;
        }
        
        const task = tasks[index++];
        
        task(...args, (err, ...results) => {
            if (err) {
                callback(err);
                return;
            }
            next(...results);
        });
    }
    
    next();
}

// Usage
waterfall([
    function(callback) {
        console.log("Step 1");
        callback(null, 1);
    },
    function(value, callback) {
        console.log("Step 2, got:", value);
        callback(null, value * 2);
    },
    function(value, callback) {
        console.log("Step 3, got:", value);
        callback(null, value + 10);
    }
], function(err, result) {
    if (err) {
        console.error(err);
        return;
    }
    console.log("Final result:", result);  // 12
});
```

## Converting Callbacks to Promises

```javascript
// Callback-based function
function fetchDataCallback(url, callback) {
    setTimeout(() => {
        callback(null, { data: "some data" });
    }, 1000);
}

// Convert to Promise
function fetchDataPromise(url) {
    return new Promise((resolve, reject) => {
        fetchDataCallback(url, (err, data) => {
            if (err) {
                reject(err);
            } else {
                resolve(data);
            }
        });
    });
}

// Usage
fetchDataPromise("https://api.example.com")
    .then(data => console.log(data))
    .catch(err => console.error(err));

// Or use util.promisify in Node.js
const util = require('util');
const fs = require('fs');

const readFilePromise = util.promisify(fs.readFile);

readFilePromise('file.txt', 'utf8')
    .then(data => console.log(data))
    .catch(err => console.error(err));
```

## Summary

- **Callbacks** are functions passed as arguments to be executed later
- Two types: **Synchronous** (immediate) and **Asynchronous** (delayed)
- **Error-first** callbacks are standard in Node.js
- **Callback hell** makes code hard to read and maintain
- Solutions: named functions, modularization, Promises, async/await
- Always **handle errors** in callbacks
- **Return after callbacks** to prevent further execution
- Callbacks are fundamental but **Promises** and **async/await** are preferred for modern code

## Further Reading

- [MDN: Callback Function](https://developer.mozilla.org/en-US/docs/Glossary/Callback_function)
- [MDN: Asynchronous JavaScript](https://developer.mozilla.org/en-US/docs/Learn/JavaScript/Asynchronous)
- [Node.js: Error-First Callbacks](https://nodejs.org/en/knowledge/errors/what-are-the-error-conventions/)
- [JavaScript.info: Callbacks](https://javascript.info/callbacks)
