# Functions

## What is a Function?

A function is a reusable block of code designed to perform a particular task. Functions are first-class citizens in JavaScript, meaning they can be assigned to variables, passed as arguments, and returned from other functions.

## Function Declaration

```javascript
// Basic function declaration
function greet(name) {
    return `Hello, ${name}!`;
}

// Calling the function
let message = greet("John");  // "Hello, John!"

// Function with multiple parameters
function add(a, b) {
    return a + b;
}

// Function without return (returns undefined)
function sayHello() {
    console.log("Hello!");
}  // Returns undefined
```

### Function Hoisting

Function declarations are hoisted to the top of their scope.

```javascript
// This works because of hoisting
console.log(greet("John"));  // "Hello, John!"

function greet(name) {
    return `Hello, ${name}!`;
}
```

## Function Expression

```javascript
// Function expression
const greet = function(name) {
    return `Hello, ${name}!`;
};

// Anonymous function
const sayHello = function() {
    console.log("Hello!");
};

// Named function expression (useful for recursion and debugging)
const factorial = function fact(n) {
    if (n <= 1) return 1;
    return n * fact(n - 1);
};
```

### No Hoisting

Function expressions are NOT hoisted.

```javascript
// This will throw an error
console.log(greet("John"));  // ReferenceError

const greet = function(name) {
    return `Hello, ${name}!`;
};
```

## Arrow Functions (ES6)

More concise syntax for function expressions.

```javascript
// Basic arrow function
const greet = (name) => {
    return `Hello, ${name}!`;
};

// Implicit return (single expression)
const greet = (name) => `Hello, ${name}!`;

// Single parameter (parentheses optional)
const square = x => x * x;

// No parameters
const sayHello = () => console.log("Hello!");

// Multiple parameters
const add = (a, b) => a + b;

// Returning object literal (wrap in parentheses)
const createUser = (name, age) => ({ name, age });

// Multi-line arrow function
const complexFunction = (a, b) => {
    const sum = a + b;
    const product = a * b;
    return { sum, product };
};
```

### Arrow Functions vs Regular Functions

```javascript
// 1. No 'this' binding (lexical this)
function RegularFunction() {
    this.value = 1;
    setTimeout(function() {
        this.value++;  // 'this' refers to global object
        console.log(this.value);
    }, 1000);
}

function ArrowFunction() {
    this.value = 1;
    setTimeout(() => {
        this.value++;  // 'this' refers to ArrowFunction
        console.log(this.value);
    }, 1000);
}

// 2. No arguments object
function regular() {
    console.log(arguments);  // Available
}

const arrow = () => {
    console.log(arguments);  // ReferenceError
};

// 3. Cannot be used as constructor
const Regular = function() {};
new Regular();  // OK

const Arrow = () => {};
new Arrow();  // TypeError
```

## Function Parameters

### Default Parameters (ES6)

```javascript
// Old way
function greet(name) {
    name = name || "Guest";
    return `Hello, ${name}!`;
}

// ES6 way
function greet(name = "Guest") {
    return `Hello, ${name}!`;
}

// Default parameters can use previous parameters
function createUser(name, age = 18, role = `${name}_user`) {
    return { name, age, role };
}

// Can use expressions
function calculate(a, b = a * 2) {
    return a + b;
}
```

### Rest Parameters (ES6)

Collect remaining arguments into an array.

```javascript
function sum(...numbers) {
    return numbers.reduce((total, num) => total + num, 0);
}

sum(1, 2, 3);        // 6
sum(1, 2, 3, 4, 5);  // 15

// Rest parameter must be last
function process(first, second, ...rest) {
    console.log(first);   // First argument
    console.log(second);  // Second argument
    console.log(rest);    // Array of remaining arguments
}

// Combine with destructuring
function createUser(name, ...details) {
    return { name, details };
}
```

### Arguments Object (Old Way)

```javascript
function oldWay() {
    console.log(arguments);  // Array-like object
    
    // Convert to real array
    const args = Array.from(arguments);
    // or
    const args2 = [...arguments];
}

// Note: Not available in arrow functions
```

## Return Statement

```javascript
// Basic return
function add(a, b) {
    return a + b;
}

// Multiple return paths
function max(a, b) {
    if (a > b) return a;
    return b;
}

// Early return pattern
function validateUser(user) {
    if (!user) return false;
    if (!user.name) return false;
    if (!user.email) return false;
    return true;
}

// Return object
function createUser(name, age) {
    return {
        name: name,
        age: age
    };
}

// Return function (closure)
function multiplier(factor) {
    return function(number) {
        return number * factor;
    };
}

const double = multiplier(2);
console.log(double(5));  // 10
```

## Immediately Invoked Function Expression (IIFE)

```javascript
// Basic IIFE
(function() {
    console.log("I run immediately!");
})();

// IIFE with parameters
(function(name) {
    console.log(`Hello, ${name}!`);
})("John");

// Arrow IIFE
(() => {
    console.log("Arrow IIFE!");
})();

// Use case: Private scope
const counter = (function() {
    let count = 0;
    return {
        increment: () => ++count,
        decrement: () => --count,
        getCount: () => count
    };
})();

counter.increment();  // 1
counter.increment();  // 2
console.log(counter.getCount());  // 2
```

## Higher-Order Functions

Functions that take functions as arguments or return functions.

```javascript
// Function that takes a function
function repeat(n, action) {
    for (let i = 0; i < n; i++) {
        action(i);
    }
}

repeat(3, console.log);  // Logs 0, 1, 2

// Function that returns a function
function greeterFactory(greeting) {
    return function(name) {
        return `${greeting}, ${name}!`;
    };
}

const sayHello = greeterFactory("Hello");
const sayHi = greeterFactory("Hi");
console.log(sayHello("John"));  // "Hello, John!"
console.log(sayHi("Jane"));     // "Hi, Jane!"

// Built-in higher-order functions
const numbers = [1, 2, 3, 4, 5];
numbers.map(x => x * 2);           // [2, 4, 6, 8, 10]
numbers.filter(x => x > 2);        // [3, 4, 5]
numbers.reduce((sum, x) => sum + x, 0);  // 15
```

## Callback Functions

Functions passed as arguments to be called later.

```javascript
// Simple callback
function fetchData(callback) {
    setTimeout(() => {
        const data = { name: "John", age: 30 };
        callback(data);
    }, 1000);
}

fetchData((data) => {
    console.log(data);
});

// Error-first callbacks (Node.js convention)
function readFile(filename, callback) {
    // Simulated file reading
    setTimeout(() => {
        if (!filename) {
            callback(new Error("Filename is required"), null);
        } else {
            callback(null, "File contents");
        }
    }, 1000);
}

readFile("data.txt", (error, data) => {
    if (error) {
        console.error(error);
    } else {
        console.log(data);
    }
});
```

## Recursive Functions

Functions that call themselves.

```javascript
// Factorial
function factorial(n) {
    if (n <= 1) return 1;
    return n * factorial(n - 1);
}

// Fibonacci
function fibonacci(n) {
    if (n <= 1) return n;
    return fibonacci(n - 1) + fibonacci(n - 2);
}

// Countdown
function countdown(n) {
    if (n < 0) return;
    console.log(n);
    countdown(n - 1);
}

// Array sum (recursive)
function sumArray(arr) {
    if (arr.length === 0) return 0;
    return arr[0] + sumArray(arr.slice(1));
}

// Flatten nested array
function flatten(arr) {
    let result = [];
    for (let item of arr) {
        if (Array.isArray(item)) {
            result = result.concat(flatten(item));
        } else {
            result.push(item);
        }
    }
    return result;
}

flatten([1, [2, [3, [4]], 5]]);  // [1, 2, 3, 4, 5]
```

## Function Scope and Closures

```javascript
// Function creates its own scope
function outer() {
    let outerVar = "I'm from outer";
    
    function inner() {
        let innerVar = "I'm from inner";
        console.log(outerVar);  // Accessible
        console.log(innerVar);  // Accessible
    }
    
    inner();
    console.log(innerVar);  // Error: not defined
}

// Closure: Inner function has access to outer function's variables
function createCounter() {
    let count = 0;
    
    return {
        increment: function() {
            return ++count;
        },
        decrement: function() {
            return --count;
        },
        getCount: function() {
            return count;
        }
    };
}

const counter = createCounter();
counter.increment();  // 1
counter.increment();  // 2
counter.getCount();   // 2
```

## Function Methods

### call()

```javascript
function greet(greeting, punctuation) {
    return `${greeting}, ${this.name}${punctuation}`;
}

const person = { name: "John" };

greet.call(person, "Hello", "!");  // "Hello, John!"
```

### apply()

```javascript
function greet(greeting, punctuation) {
    return `${greeting}, ${this.name}${punctuation}`;
}

const person = { name: "John" };

greet.apply(person, ["Hello", "!"]);  // "Hello, John!"

// Useful for Math functions
const numbers = [1, 5, 3, 9, 2];
Math.max.apply(null, numbers);  // 9
// Modern way: Math.max(...numbers)
```

### bind()

```javascript
function greet(greeting) {
    return `${greeting}, ${this.name}!`;
}

const person = { name: "John" };

const greetJohn = greet.bind(person);
greetJohn("Hello");  // "Hello, John!"

// Partial application
function multiply(a, b) {
    return a * b;
}

const double = multiply.bind(null, 2);
double(5);  // 10
```

## Best Practices

### 1. Use Arrow Functions for Short Callbacks

```javascript
// Good
numbers.map(x => x * 2);
numbers.filter(x => x > 0);

// Overkill
numbers.map(function(x) {
    return x * 2;
});
```

### 2. Keep Functions Small and Focused

```javascript
// Bad: Function does too much
function processUserData(user) {
    // validate
    // format
    // save to database
    // send email
}

// Good: Separate concerns
function validateUser(user) { }
function formatUserData(user) { }
function saveUser(user) { }
function sendWelcomeEmail(user) { }
```

### 3. Use Descriptive Names

```javascript
// Bad
function fn(x, y) { return x + y; }

// Good
function calculateTotal(price, tax) { return price + tax; }
```

### 4. Use Default Parameters

```javascript
// Old way
function greet(name) {
    name = name || "Guest";
    return `Hello, ${name}!`;
}

// Better
function greet(name = "Guest") {
    return `Hello, ${name}!`;
}
```

### 5. Prefer Pure Functions

```javascript
// Impure: Modifies external state
let total = 0;
function addToTotal(value) {
    total += value;
}

// Pure: No side effects
function add(a, b) {
    return a + b;
}
```

## Common Patterns

### Memoization

```javascript
function memoize(fn) {
    const cache = {};
    return function(...args) {
        const key = JSON.stringify(args);
        if (key in cache) {
            return cache[key];
        }
        const result = fn.apply(this, args);
        cache[key] = result;
        return result;
    };
}

const slowFibonacci = (n) => {
    if (n <= 1) return n;
    return slowFibonacci(n - 1) + slowFibonacci(n - 2);
};

const fastFibonacci = memoize(slowFibonacci);
```

### Currying

```javascript
// Non-curried
function add(a, b, c) {
    return a + b + c;
}

// Curried
function addCurried(a) {
    return function(b) {
        return function(c) {
            return a + b + c;
        };
    };
}

// Arrow function version
const addCurried = a => b => c => a + b + c;

addCurried(1)(2)(3);  // 6

// Partial application
const add5 = addCurried(5);
const add5and10 = add5(10);
add5and10(3);  // 18
```

## Summary

- Three ways to define functions: declaration, expression, arrow
- Arrow functions have lexical `this` and no `arguments` object
- Use default parameters and rest parameters for flexible functions
- Functions can return functions (closures)
- Higher-order functions take or return other functions
- Use `call`, `apply`, `bind` to control `this` context
- Keep functions small, focused, and pure when possible

## Next Steps

Continue to [Arrays](06_ARRAYS.md) to learn about JavaScript arrays in depth.
