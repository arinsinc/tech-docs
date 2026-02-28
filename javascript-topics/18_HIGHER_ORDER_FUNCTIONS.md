# Higher-Order Functions

## Table of Contents
1. [Introduction](#introduction)
2. [What are Higher-Order Functions?](#what-are-higher-order-functions)
3. [Functions as Arguments](#functions-as-arguments)
4. [Functions as Return Values](#functions-as-return-values)
5. [Common Higher-Order Functions](#common-higher-order-functions)
6. [Creating Your Own Higher-Order Functions](#creating-your-own-higher-order-functions)
7. [Real-World Examples](#real-world-examples)
8. [Best Practices](#best-practices)

## Introduction

Higher-order functions are a fundamental concept in JavaScript that enable powerful functional programming patterns. They treat functions as first-class citizens, allowing them to be passed as arguments and returned from other functions.

## What are Higher-Order Functions?

A higher-order function is a function that:
- **Takes one or more functions as arguments**, OR
- **Returns a function as its result**

### Why Higher-Order Functions?

```javascript
// ❌ Without higher-order functions (repetitive code)
const numbers = [1, 2, 3, 4, 5];

const doubled = [];
for (let i = 0; i < numbers.length; i++) {
    doubled.push(numbers[i] * 2);
}

const tripled = [];
for (let i = 0; i < numbers.length; i++) {
    tripled.push(numbers[i] * 3);
}

// ✅ With higher-order functions (DRY - Don't Repeat Yourself)
const numbers = [1, 2, 3, 4, 5];
const doubled = numbers.map(num => num * 2);
const tripled = numbers.map(num => num * 3);
```

## Functions as Arguments

### Basic Example

```javascript
// Higher-order function that takes a function as an argument
function repeat(times, action) {
    for (let i = 0; i < times; i++) {
        action(i);
    }
}

// Using the higher-order function
repeat(3, (index) => {
    console.log(`Iteration ${index}`);
});
// Output:
// Iteration 0
// Iteration 1
// Iteration 2
```

### Callback Functions

```javascript
// Array processing with callbacks
function processArray(arr, callback) {
    const result = [];
    for (let item of arr) {
        result.push(callback(item));
    }
    return result;
}

const numbers = [1, 2, 3, 4, 5];

// Square each number
const squared = processArray(numbers, num => num * num);
console.log(squared); // [1, 4, 9, 16, 25]

// Convert to strings
const strings = processArray(numbers, num => `Number: ${num}`);
console.log(strings); // ['Number: 1', 'Number: 2', ...]
```

### Custom Filter Function

```javascript
function customFilter(arr, predicate) {
    const result = [];
    for (let item of arr) {
        if (predicate(item)) {
            result.push(item);
        }
    }
    return result;
}

const numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

// Get even numbers
const evens = customFilter(numbers, num => num % 2 === 0);
console.log(evens); // [2, 4, 6, 8, 10]

// Get numbers greater than 5
const greaterThanFive = customFilter(numbers, num => num > 5);
console.log(greaterThanFive); // [6, 7, 8, 9, 10]
```

## Functions as Return Values

### Function Factory

```javascript
// Returns a function that multiplies by a specific number
function createMultiplier(multiplier) {
    return function(number) {
        return number * multiplier;
    };
}

const double = createMultiplier(2);
const triple = createMultiplier(3);

console.log(double(5));  // 10
console.log(triple(5));  // 15
```

### Greeting Generator

```javascript
function createGreeter(greeting) {
    return function(name) {
        return `${greeting}, ${name}!`;
    };
}

const sayHello = createGreeter('Hello');
const sayHi = createGreeter('Hi');
const sayGoodMorning = createGreeter('Good morning');

console.log(sayHello('Alice'));        // "Hello, Alice!"
console.log(sayHi('Bob'));             // "Hi, Bob!"
console.log(sayGoodMorning('Charlie')); // "Good morning, Charlie!"
```

### Closure with Counter

```javascript
function createCounter(initialValue = 0) {
    let count = initialValue;
    
    return {
        increment: () => ++count,
        decrement: () => --count,
        getValue: () => count,
        reset: () => count = initialValue
    };
}

const counter = createCounter(10);
console.log(counter.increment()); // 11
console.log(counter.increment()); // 12
console.log(counter.decrement()); // 11
console.log(counter.getValue());  // 11
counter.reset();
console.log(counter.getValue());  // 10
```

## Common Higher-Order Functions

### Array.prototype.map()

```javascript
const numbers = [1, 2, 3, 4, 5];

// Transform each element
const squared = numbers.map(num => num ** 2);
console.log(squared); // [1, 4, 9, 16, 25]

// Working with objects
const users = [
    { name: 'Alice', age: 25 },
    { name: 'Bob', age: 30 },
    { name: 'Charlie', age: 35 }
];

const names = users.map(user => user.name);
console.log(names); // ['Alice', 'Bob', 'Charlie']
```

### Array.prototype.filter()

```javascript
const numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

// Get even numbers
const evens = numbers.filter(num => num % 2 === 0);
console.log(evens); // [2, 4, 6, 8, 10]

// Filter objects
const users = [
    { name: 'Alice', age: 25, active: true },
    { name: 'Bob', age: 30, active: false },
    { name: 'Charlie', age: 35, active: true }
];

const activeUsers = users.filter(user => user.active);
console.log(activeUsers);
// [{ name: 'Alice', age: 25, active: true }, 
//  { name: 'Charlie', age: 35, active: true }]
```

### Array.prototype.reduce()

```javascript
const numbers = [1, 2, 3, 4, 5];

// Sum all numbers
const sum = numbers.reduce((acc, num) => acc + num, 0);
console.log(sum); // 15

// Find maximum
const max = numbers.reduce((acc, num) => Math.max(acc, num));
console.log(max); // 5

// Group objects
const users = [
    { name: 'Alice', department: 'IT' },
    { name: 'Bob', department: 'HR' },
    { name: 'Charlie', department: 'IT' }
];

const byDepartment = users.reduce((acc, user) => {
    const dept = user.department;
    if (!acc[dept]) acc[dept] = [];
    acc[dept].push(user);
    return acc;
}, {});

console.log(byDepartment);
// {
//   IT: [{ name: 'Alice', department: 'IT' }, { name: 'Charlie', department: 'IT' }],
//   HR: [{ name: 'Bob', department: 'HR' }]
// }
```

### Array.prototype.forEach()

```javascript
const fruits = ['apple', 'banana', 'orange'];

// Print each fruit with index
fruits.forEach((fruit, index) => {
    console.log(`${index + 1}. ${fruit}`);
});
// 1. apple
// 2. banana
// 3. orange
```

### Array.prototype.find() and Array.prototype.findIndex()

```javascript
const users = [
    { id: 1, name: 'Alice', age: 25 },
    { id: 2, name: 'Bob', age: 30 },
    { id: 3, name: 'Charlie', age: 35 }
];

// Find first user older than 28
const user = users.find(user => user.age > 28);
console.log(user); // { id: 2, name: 'Bob', age: 30 }

// Find index
const index = users.findIndex(user => user.name === 'Charlie');
console.log(index); // 2
```

### Array.prototype.some() and Array.prototype.every()

```javascript
const numbers = [1, 2, 3, 4, 5];

// Check if some numbers are even
const hasEven = numbers.some(num => num % 2 === 0);
console.log(hasEven); // true

// Check if all numbers are positive
const allPositive = numbers.every(num => num > 0);
console.log(allPositive); // true

// Check if all numbers are even
const allEven = numbers.every(num => num % 2 === 0);
console.log(allEven); // false
```

## Creating Your Own Higher-Order Functions

### Compose Function

```javascript
// Compose functions from right to left
function compose(...functions) {
    return function(value) {
        return functions.reduceRight((acc, fn) => fn(acc), value);
    };
}

const addOne = x => x + 1;
const double = x => x * 2;
const square = x => x * x;

const composedFunction = compose(square, double, addOne);
console.log(composedFunction(3)); // ((3 + 1) * 2)^2 = 64
```

### Pipe Function

```javascript
// Pipe functions from left to right
function pipe(...functions) {
    return function(value) {
        return functions.reduce((acc, fn) => fn(acc), value);
    };
}

const addOne = x => x + 1;
const double = x => x * 2;
const square = x => x * x;

const pipedFunction = pipe(addOne, double, square);
console.log(pipedFunction(3)); // ((3 + 1) * 2)^2 = 64
```

### Memoization

```javascript
function memoize(fn) {
    const cache = new Map();
    
    return function(...args) {
        const key = JSON.stringify(args);
        
        if (cache.has(key)) {
            console.log('Returning cached result');
            return cache.get(key);
        }
        
        console.log('Computing result');
        const result = fn.apply(this, args);
        cache.set(key, result);
        return result;
    };
}

// Expensive function
function fibonacci(n) {
    if (n <= 1) return n;
    return fibonacci(n - 1) + fibonacci(n - 2);
}

const memoizedFib = memoize(fibonacci);
console.log(memoizedFib(40)); // Computing result: 102334155
console.log(memoizedFib(40)); // Returning cached result: 102334155
```

### Debounce

```javascript
function debounce(fn, delay) {
    let timeoutId;
    
    return function(...args) {
        clearTimeout(timeoutId);
        timeoutId = setTimeout(() => {
            fn.apply(this, args);
        }, delay);
    };
}

// Example usage: Search as user types
const search = (query) => {
    console.log(`Searching for: ${query}`);
};

const debouncedSearch = debounce(search, 500);

// Only the last call will execute after 500ms
debouncedSearch('J');
debouncedSearch('Ja');
debouncedSearch('Jav');
debouncedSearch('Java');
debouncedSearch('JavaS');
debouncedSearch('JavaScript'); // This will execute
```

### Throttle

```javascript
function throttle(fn, limit) {
    let inThrottle;
    
    return function(...args) {
        if (!inThrottle) {
            fn.apply(this, args);
            inThrottle = true;
            setTimeout(() => inThrottle = false, limit);
        }
    };
}

// Example: Scroll event handler
const handleScroll = () => {
    console.log('Scroll event handled at:', new Date().toLocaleTimeString());
};

const throttledScroll = throttle(handleScroll, 1000);

// Will only execute once per second, no matter how many times it's called
```

## Real-World Examples

### Form Validation

```javascript
function createValidator(rules) {
    return function(formData) {
        const errors = {};
        
        for (const [field, validators] of Object.entries(rules)) {
            for (const validator of validators) {
                const error = validator(formData[field]);
                if (error) {
                    if (!errors[field]) errors[field] = [];
                    errors[field].push(error);
                }
            }
        }
        
        return {
            isValid: Object.keys(errors).length === 0,
            errors
        };
    };
}

// Validator functions
const required = (value) => !value ? 'This field is required' : null;
const minLength = (min) => (value) => 
    value.length < min ? `Minimum length is ${min}` : null;
const isEmail = (value) => 
    !/\S+@\S+\.\S+/.test(value) ? 'Invalid email format' : null;

// Create validator
const validateUser = createValidator({
    username: [required, minLength(3)],
    email: [required, isEmail],
    password: [required, minLength(8)]
});

// Use validator
const result = validateUser({
    username: 'ab',
    email: 'invalid-email',
    password: '123'
});

console.log(result);
// {
//   isValid: false,
//   errors: {
//     username: ['Minimum length is 3'],
//     email: ['Invalid email format'],
//     password: ['Minimum length is 8']
//   }
// }
```

### API Request with Retry

```javascript
function withRetry(fn, maxRetries = 3, delay = 1000) {
    return async function(...args) {
        for (let attempt = 1; attempt <= maxRetries; attempt++) {
            try {
                return await fn.apply(this, args);
            } catch (error) {
                if (attempt === maxRetries) {
                    throw new Error(`Failed after ${maxRetries} attempts: ${error.message}`);
                }
                console.log(`Attempt ${attempt} failed. Retrying in ${delay}ms...`);
                await new Promise(resolve => setTimeout(resolve, delay));
            }
        }
    };
}

// Usage
async function fetchUserData(userId) {
    const response = await fetch(`/api/users/${userId}`);
    if (!response.ok) throw new Error('Failed to fetch');
    return response.json();
}

const fetchWithRetry = withRetry(fetchUserData, 3, 2000);
```

### Event Bus

```javascript
function createEventBus() {
    const listeners = new Map();
    
    return {
        on: function(event, callback) {
            if (!listeners.has(event)) {
                listeners.set(event, []);
            }
            listeners.get(event).push(callback);
        },
        
        off: function(event, callback) {
            if (!listeners.has(event)) return;
            const callbacks = listeners.get(event);
            const index = callbacks.indexOf(callback);
            if (index > -1) {
                callbacks.splice(index, 1);
            }
        },
        
        emit: function(event, data) {
            if (!listeners.has(event)) return;
            listeners.get(event).forEach(callback => callback(data));
        }
    };
}

// Usage
const eventBus = createEventBus();

const handler = (data) => console.log('User logged in:', data);
eventBus.on('user:login', handler);

eventBus.emit('user:login', { username: 'Alice', timestamp: Date.now() });
```

### Chaining Operations

```javascript
function createChainableArray(arr) {
    const operations = [];
    
    const chain = {
        map: function(fn) {
            operations.push({ type: 'map', fn });
            return chain;
        },
        filter: function(fn) {
            operations.push({ type: 'filter', fn });
            return chain;
        },
        reduce: function(fn, initial) {
            operations.push({ type: 'reduce', fn, initial });
            return chain;
        },
        execute: function() {
            let result = arr;
            for (const op of operations) {
                switch (op.type) {
                    case 'map':
                        result = result.map(op.fn);
                        break;
                    case 'filter':
                        result = result.filter(op.fn);
                        break;
                    case 'reduce':
                        result = result.reduce(op.fn, op.initial);
                        break;
                }
            }
            return result;
        }
    };
    
    return chain;
}

// Usage
const result = createChainableArray([1, 2, 3, 4, 5, 6])
    .filter(num => num % 2 === 0)
    .map(num => num * 2)
    .reduce((sum, num) => sum + num, 0)
    .execute();

console.log(result); // 24 (2*2 + 4*2 + 6*2 = 4 + 8 + 12 = 24)
```

## Best Practices

### 1. Keep Functions Pure

```javascript
// ❌ Impure function (modifies external state)
let total = 0;
function addToTotal(value) {
    total += value;
    return total;
}

// ✅ Pure function (no side effects)
function add(a, b) {
    return a + b;
}
```

### 2. Use Descriptive Names

```javascript
// ❌ Unclear
const fn = arr => arr.filter(x => x > 5);

// ✅ Clear
const filterNumbersGreaterThanFive = arr => arr.filter(num => num > 5);
```

### 3. Avoid Nested Callbacks (Callback Hell)

```javascript
// ❌ Callback hell
getData(function(a) {
    getMoreData(a, function(b) {
        getMoreData(b, function(c) {
            console.log(c);
        });
    });
});

// ✅ Use Promises or async/await
async function fetchAllData() {
    const a = await getData();
    const b = await getMoreData(a);
    const c = await getMoreData(b);
    console.log(c);
}
```

### 4. Leverage Built-in Higher-Order Functions

```javascript
// ❌ Manual loop
const doubled = [];
for (let i = 0; i < numbers.length; i++) {
    doubled.push(numbers[i] * 2);
}

// ✅ Use map
const doubled = numbers.map(num => num * 2);
```

### 5. Combine Higher-Order Functions

```javascript
const users = [
    { name: 'Alice', age: 25, active: true },
    { name: 'Bob', age: 30, active: false },
    { name: 'Charlie', age: 35, active: true },
    { name: 'David', age: 28, active: true }
];

// Get names of active users over 26
const activeUserNames = users
    .filter(user => user.active)
    .filter(user => user.age > 26)
    .map(user => user.name);

console.log(activeUserNames); // ['Charlie', 'David']
```

## Summary

Higher-order functions are powerful tools that:
- Enable code reusability and composition
- Make code more declarative and readable
- Support functional programming patterns
- Reduce boilerplate code

Key takeaways:
- Functions can be passed as arguments to other functions
- Functions can return other functions
- Built-in array methods (map, filter, reduce) are higher-order functions
- Higher-order functions enable powerful patterns like memoization, debouncing, and function composition

---

**Next Topic**: [Array Methods](19_ARRAY_METHODS.md)
