# JavaScript Tutorial - Index

A comprehensive guide to JavaScript programming, from fundamentals to advanced concepts.

## Table of Contents

### Fundamentals
1. [JavaScript Basics](01_JAVASCRIPT_BASICS.md)
2. [Variables and Data Types](02_VARIABLES_DATA_TYPES.md)
3. [Operators and Expressions](03_OPERATORS.md)
4. [Control Flow](04_CONTROL_FLOW.md)
5. [Functions](05_FUNCTIONS.md)

### Core Concepts
6. [Arrays](06_ARRAYS.md)
7. [Objects](07_OBJECTS.md)
8. [Strings and Template Literals](08_STRINGS.md)
9. [Error Handling](09_ERROR_HANDLING.md)
10. [Scope and Closures](10_SCOPE_CLOSURES.md)

### Object-Oriented JavaScript
11. [Prototypes and Inheritance](11_PROTOTYPES.md)
12. [Classes](12_CLASSES.md)
13. [This Keyword](13_THIS_KEYWORD.md)

### Asynchronous JavaScript
14. [Callbacks](14_CALLBACKS.md)
15. [Promises](15_PROMISES.md)
16. [Async/Await](16_ASYNC_AWAIT.md)
17. [Event Loop](17_EVENT_LOOP.md)

### Advanced Topics
18. [Higher-Order Functions](18_HIGHER_ORDER_FUNCTIONS.md)
19. [Array Methods](19_ARRAY_METHODS.md)
20. [Destructuring and Spread](20_DESTRUCTURING_SPREAD.md)
21. [Modules (ES6)](21_MODULES.md)
22. [Iterators and Generators](22_ITERATORS_GENERATORS.md)

### Modern JavaScript
23. [ES6+ Features](23_ES6_FEATURES.md)
24. [JavaScript Design Patterns](24_DESIGN_PATTERNS.md)
25. [Functional Programming](25_FUNCTIONAL_PROGRAMMING.md)

### DOM and Browser APIs
26. [DOM Manipulation](26_DOM_MANIPULATION.md)
27. [Events](27_EVENTS.md)
28. [Browser Storage](28_BROWSER_STORAGE.md)
29. [Fetch API](29_FETCH_API.md)

### Best Practices
30. [Debugging and Testing](30_DEBUGGING_TESTING.md)
31. [Performance Optimization](31_PERFORMANCE.md)
32. [Security Best Practices](32_SECURITY.md)

## Learning Path

### Beginner (Start Here)
- JavaScript Basics
- Variables and Data Types
- Control Flow
- Functions
- Arrays
- Objects

### Intermediate
- Error Handling
- Scope and Closures
- Promises
- Async/Await
- Array Methods
- DOM Manipulation

### Advanced
- Prototypes and Inheritance
- Design Patterns
- Functional Programming
- Performance Optimization
- Event Loop

## Quick Reference

### Variable Declaration
```javascript
let mutableVar = "can change";
const immutableVar = "cannot change";
var oldStyle = "function-scoped";
```

### Function Types
```javascript
// Function declaration
function greet(name) { return `Hello, ${name}`; }

// Arrow function
const greet = (name) => `Hello, ${name}`;

// Function expression
const greet = function(name) { return `Hello, ${name}`; };
```

### Common Patterns
```javascript
// Destructuring
const { name, age } = person;
const [first, second] = array;

// Spread operator
const newArray = [...oldArray, newItem];
const newObject = { ...oldObject, newProp: value };

// Template literals
const message = `Hello, ${name}!`;
```

## Additional Resources
- [MDN Web Docs](https://developer.mozilla.org/en-US/docs/Web/JavaScript)
- [JavaScript.info](https://javascript.info/)
- [ECMAScript Specification](https://tc39.es/ecma262/)
