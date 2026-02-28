# JavaScript Basics

## What is JavaScript?

JavaScript is a high-level, interpreted programming language that is one of the core technologies of the World Wide Web. It enables interactive web pages and is an essential part of web applications.

### Key Characteristics
- **Interpreted**: Code is executed line by line
- **Dynamic typing**: Variable types are determined at runtime
- **First-class functions**: Functions are treated as first-class citizens
- **Prototype-based**: Object-oriented programming using prototypes
- **Multi-paradigm**: Supports procedural, OOP, and functional programming

## History

- **1995**: Created by Brendan Eich at Netscape in 10 days
- **1997**: ECMAScript standardization begins
- **2015**: ES6/ES2015 - Major update with modern features
- **Present**: Annual releases with new features

## JavaScript Environments

### 1. Browser (Client-Side)
```javascript
// Runs in web browsers
console.log("Hello from the browser!");
alert("Welcome!");
document.getElementById("myDiv").innerHTML = "Updated!";
```

### 2. Node.js (Server-Side)
```javascript
// Runs on servers
const http = require('http');
const server = http.createServer((req, res) => {
    res.end('Hello from Node.js!');
});
server.listen(3000);
```

## Your First JavaScript Program

### In HTML
```html
<!DOCTYPE html>
<html>
<head>
    <title>JavaScript Basics</title>
</head>
<body>
    <h1>Hello, JavaScript!</h1>
    
    <!-- Inline JavaScript -->
    <button onclick="alert('Button clicked!')">Click Me</button>
    
    <!-- Internal JavaScript -->
    <script>
        console.log("Hello from internal script!");
    </script>
    
    <!-- External JavaScript -->
    <script src="script.js"></script>
</body>
</html>
```

### In Node.js
```javascript
// app.js
console.log("Hello, Node.js!");
```

Run with: `node app.js`

## Comments

```javascript
// Single-line comment

/*
   Multi-line comment
   Can span multiple lines
*/

/**
 * JSDoc comment (documentation)
 * @param {string} name - The person's name
 * @returns {string} A greeting message
 */
function greet(name) {
    return `Hello, ${name}!`;
}
```

## Console Methods

```javascript
// Basic logging
console.log("Normal message");
console.info("Information");
console.warn("Warning message");
console.error("Error message");

// Advanced logging
console.table([{name: "John", age: 30}, {name: "Jane", age: 25}]);
console.group("Group");
console.log("Inside group");
console.groupEnd();

// Timing
console.time("timer");
// ... code to measure
console.timeEnd("timer");

// Assertions
console.assert(1 === 2, "This will show because assertion fails");
```

## Statements and Semicolons

```javascript
// Semicolons are optional but recommended
let x = 5;  // With semicolon
let y = 10  // Without semicolon (ASI - Automatic Semicolon Insertion)

// Multiple statements on one line need semicolons
let a = 1; let b = 2; let c = 3;

// Be careful with ASI pitfalls
return
{
    status: true  // This won't work as expected!
};

// Correct way
return {
    status: true
};
```

## Strict Mode

Strict mode makes JavaScript more secure and helps catch common coding mistakes.

```javascript
"use strict";

// This will throw an error in strict mode
x = 10;  // ReferenceError: x is not defined

// Must declare variables
let x = 10;  // This is fine

// Other strict mode restrictions:
// - No duplicate parameter names
// - No octal literals
// - Can't delete variables
// - eval doesn't create variables in outer scope
```

### Benefits of Strict Mode
1. Converts mistakes into errors
2. Prevents accidental global variables
3. Eliminates silent errors
4. Makes code more secure
5. Better performance in some cases

## JavaScript Keywords

Reserved words that have special meaning:

```javascript
// Variable declarations
let, const, var

// Control flow
if, else, switch, case, default, break, continue

// Loops
for, while, do, in, of

// Functions
function, return, yield, async, await

// Object-oriented
class, extends, super, static, new, this

// Error handling
try, catch, finally, throw

// Others
typeof, instanceof, void, delete, debugger, with
```

## Best Practices

### 1. Use Meaningful Names
```javascript
// Bad
let x = 10;
function fn() {}

// Good
let userAge = 10;
function calculateTotal() {}
```

### 2. Use const by Default
```javascript
// Prefer const for values that don't change
const API_URL = "https://api.example.com";
const MAX_RETRY = 3;

// Use let when value will change
let counter = 0;
counter++;
```

### 3. Use Strict Mode
```javascript
"use strict";
// Your code here
```

### 4. Consistent Code Style
```javascript
// Choose a style and stick to it
// camelCase for variables and functions
const userName = "John";
function getUserData() {}

// PascalCase for classes
class UserProfile {}

// UPPER_CASE for constants
const MAX_SIZE = 100;
```

### 5. Comment Your Code
```javascript
// Explain why, not what
// Bad: Increment i
i++;

// Good: Move to next item after processing current one
i++;
```

## Common Pitfalls

### 1. Type Coercion
```javascript
"5" + 5;   // "55" (string concatenation)
"5" - 5;   // 0 (numeric subtraction)
true + 1;  // 2
```

### 2. Equality Operators
```javascript
5 == "5";   // true (loose equality, type coercion)
5 === "5";  // false (strict equality, no coercion)

// Always prefer ===
```

### 3. Variable Hoisting
```javascript
console.log(x);  // undefined (not an error!)
var x = 5;

// Use let/const to avoid this
console.log(y);  // ReferenceError
let y = 5;
```

### 4. Global Variables
```javascript
// Bad: Accidental global
function bad() {
    leak = "I'm global!";  // No var/let/const
}

// Good: Properly scoped
function good() {
    let local = "I'm local!";
}
```

## Development Tools

### Browser Developer Tools
- **Console**: Test code and debug
- **Sources**: Set breakpoints and step through code
- **Network**: Monitor network requests
- **Elements**: Inspect and modify DOM

### Useful Shortcuts
- `F12` or `Cmd+Option+I` (Mac): Open DevTools
- `Cmd+K` (Mac) / `Ctrl+L` (Windows): Clear console
- `console.clear()`: Clear console programmatically

## Practice Exercises

### Exercise 1: Hello World
```javascript
// Write a program that prints your name
console.log("My name is [Your Name]");
```

### Exercise 2: Use Strict Mode
```javascript
// Enable strict mode and try to use an undeclared variable
"use strict";
// Try: x = 10;  (Should give error)
```

### Exercise 3: Comment Types
```javascript
// Add different types of comments to this code
function calculate(a, b) {
    return a + b;
}
```

## Summary

- JavaScript is an interpreted, dynamic language
- Can run in browsers and on servers (Node.js)
- Use strict mode for better error checking
- Always declare variables with let/const
- Use === for equality checks
- Comment your code meaningfully
- Use browser DevTools for debugging

## Next Steps

Continue to [Variables and Data Types](02_VARIABLES_DATA_TYPES.md) to learn about JavaScript's type system.
