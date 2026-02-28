# Modules (ES6)

## Table of Contents
1. [Introduction](#introduction)
2. [Module Basics](#module-basics)
3. [Export Syntax](#export-syntax)
4. [Import Syntax](#import-syntax)
5. [Default vs Named Exports](#default-vs-named-exports)
6. [Dynamic Imports](#dynamic-imports)
7. [Module Patterns](#module-patterns)
8. [Real-World Examples](#real-world-examples)
9. [Module Best Practices](#module-best-practices)
10. [CommonJS vs ES Modules](#commonjs-vs-es-modules)

## Introduction

ES6 modules provide a standardized way to organize and share code across files. They help create maintainable, reusable, and encapsulated code by breaking applications into smaller, manageable pieces.

### Why Modules?

```javascript
// ❌ Without modules (everything in global scope)
// file1.js
var user = 'Alice';
function greet() { console.log('Hello'); }

// file2.js
var user = 'Bob';  // Name collision!
function greet() { console.log('Hi'); }  // Overrides previous function

// ✅ With modules (encapsulated scope)
// file1.js
export const user = 'Alice';
export function greet() { console.log('Hello'); }

// file2.js
export const user = 'Bob';  // No collision
export function greet() { console.log('Hi'); }
```

## Module Basics

### Creating a Module

```javascript
// math.js - A simple module
export function add(a, b) {
    return a + b;
}

export function subtract(a, b) {
    return a - b;
}

const PI = 3.14159;
export { PI };
```

### Using a Module

```javascript
// main.js
import { add, subtract, PI } from './math.js';

console.log(add(5, 3));       // 8
console.log(subtract(10, 4)); // 6
console.log(PI);              // 3.14159
```

### Module Scope

```javascript
// counter.js
let count = 0;  // Private variable

export function increment() {
    return ++count;
}

export function getCount() {
    return count;
}

// main.js
import { increment, getCount } from './counter.js';

console.log(getCount());  // 0
increment();
increment();
console.log(getCount());  // 2

// console.log(count);  // ReferenceError: count is not defined
```

## Export Syntax

### Named Exports

```javascript
// users.js - Multiple named exports

// Export during declaration
export const adminRole = 'admin';
export const userRole = 'user';

export function createUser(name, email) {
    return { name, email, role: userRole };
}

export class User {
    constructor(name) {
        this.name = name;
    }
    
    greet() {
        return `Hello, ${this.name}`;
    }
}

// Or export at the end
const guestRole = 'guest';
function deleteUser(id) {
    console.log(`Deleting user ${id}`);
}

export { guestRole, deleteUser };
```

### Renaming Exports

```javascript
// utils.js
function internalValidate(data) {
    return data != null;
}

function internalTransform(data) {
    return data.toUpperCase();
}

// Rename during export
export {
    internalValidate as validate,
    internalTransform as transform
};

// main.js
import { validate, transform } from './utils.js';
console.log(validate('test'));    // true
console.log(transform('hello'));  // 'HELLO'
```

### Default Export

```javascript
// calculator.js - Single default export
export default class Calculator {
    add(a, b) {
        return a + b;
    }
    
    subtract(a, b) {
        return a - b;
    }
}

// Or
class Calculator {
    // ...
}
export default Calculator;

// Or with function
export default function calculate(operation, a, b) {
    switch (operation) {
        case '+': return a + b;
        case '-': return a - b;
        case '*': return a * b;
        case '/': return a / b;
    }
}

// Or with value
export default {
    name: 'My App',
    version: '1.0.0'
};
```

### Mixing Default and Named Exports

```javascript
// logger.js
export default class Logger {
    log(message) {
        console.log(`[LOG] ${message}`);
    }
}

export const LOG_LEVEL = {
    INFO: 'info',
    ERROR: 'error',
    WARN: 'warn'
};

export function formatMessage(level, message) {
    return `[${level.toUpperCase()}] ${message}`;
}

// main.js
import Logger, { LOG_LEVEL, formatMessage } from './logger.js';

const logger = new Logger();
logger.log(formatMessage(LOG_LEVEL.INFO, 'App started'));
```

## Import Syntax

### Basic Import

```javascript
// Import named exports
import { add, subtract } from './math.js';

// Import default export
import Calculator from './calculator.js';

// Import everything as namespace
import * as MathUtils from './math.js';
console.log(MathUtils.add(1, 2));  // 3

// Import default and named
import Logger, { LOG_LEVEL } from './logger.js';
```

### Renaming Imports

```javascript
// utils.js
export function validate(data) { /* ... */ }
export function format(data) { /* ... */ }

// main.js
import {
    validate as validateInput,
    format as formatOutput
} from './utils.js';

validateInput('test');
formatOutput({ name: 'Alice' });
```

### Import Everything

```javascript
// math.js
export const PI = 3.14159;
export function add(a, b) { return a + b; }
export function subtract(a, b) { return a - b; }

// main.js
import * as Math from './math.js';

console.log(Math.PI);          // 3.14159
console.log(Math.add(5, 3));   // 8
console.log(Math.subtract(10, 4)); // 6
```

### Side Effect Imports

```javascript
// polyfills.js
if (!Array.prototype.includes) {
    Array.prototype.includes = function(element) {
        return this.indexOf(element) !== -1;
    };
}

console.log('Polyfills loaded');

// main.js
import './polyfills.js';  // Execute the module without importing anything

// Now Array.prototype.includes is available
```

### Import Assertions (JSON Modules)

```javascript
// config.json
{
    "appName": "My App",
    "version": "1.0.0",
    "api": {
        "url": "https://api.example.com"
    }
}

// main.js
import config from './config.json' assert { type: 'json' };

console.log(config.appName);  // 'My App'
console.log(config.api.url);  // 'https://api.example.com'
```

## Default vs Named Exports

### When to Use Default Exports

```javascript
// ✅ Good use cases for default export:

// 1. Single class per file
// Button.js
export default class Button {
    render() { /* ... */ }
}

// 2. Single main function
// validator.js
export default function validate(data) {
    // validation logic
}

// 3. Configuration object
// config.js
export default {
    api: {
        url: 'https://api.example.com',
        timeout: 5000
    },
    features: {
        darkMode: true
    }
};
```

### When to Use Named Exports

```javascript
// ✅ Good use cases for named exports:

// 1. Multiple related functions
// string-utils.js
export function capitalize(str) { /* ... */ }
export function lowercase(str) { /* ... */ }
export function truncate(str, length) { /* ... */ }

// 2. Constants and enums
// constants.js
export const API_URL = 'https://api.example.com';
export const MAX_RETRIES = 3;
export const TIMEOUT = 5000;

// 3. Multiple related classes
// shapes.js
export class Circle { /* ... */ }
export class Rectangle { /* ... */ }
export class Triangle { /* ... */ }
```

### Comparison

```javascript
// Named Exports
// math.js
export function add(a, b) { return a + b; }
export function subtract(a, b) { return a - b; }

// Import with exact names
import { add, subtract } from './math.js';

// Or rename
import { add as sum } from './math.js';

// --------------------------------

// Default Export
// calculator.js
export default function calculate(op, a, b) { /* ... */ }

// Import with any name you want
import calc from './calculator.js';
import calculator from './calculator.js';
import myCalculator from './calculator.js';  // All valid
```

## Dynamic Imports

### Basic Dynamic Import

```javascript
// Regular import (loaded immediately)
import { heavyFunction } from './heavy-module.js';

// Dynamic import (loaded on demand)
button.addEventListener('click', async () => {
    const module = await import('./heavy-module.js');
    module.heavyFunction();
});
```

### Conditional Loading

```javascript
// Load different modules based on condition
async function loadTheme(theme) {
    if (theme === 'dark') {
        const darkTheme = await import('./themes/dark.js');
        darkTheme.apply();
    } else {
        const lightTheme = await import('./themes/light.js');
        lightTheme.apply();
    }
}

// User preference
const userPreference = localStorage.getItem('theme') || 'light';
loadTheme(userPreference);
```

### Code Splitting

```javascript
// Load features only when needed
class App {
    async loadAdvancedFeatures() {
        const { AdvancedEditor } = await import('./advanced-editor.js');
        this.editor = new AdvancedEditor();
    }
    
    async loadAnalytics() {
        if (process.env.ENABLE_ANALYTICS) {
            const analytics = await import('./analytics.js');
            analytics.init();
        }
    }
}
```

### Error Handling

```javascript
async function loadModule(modulePath) {
    try {
        const module = await import(modulePath);
        return module.default;
    } catch (error) {
        console.error(`Failed to load module: ${modulePath}`, error);
        return null;
    }
}

// Usage
const Calculator = await loadModule('./calculator.js');
if (Calculator) {
    const calc = new Calculator();
    calc.add(1, 2);
}
```

### Dynamic Path

```javascript
// Load module based on language
async function loadTranslations(language) {
    try {
        const translations = await import(`./i18n/${language}.js`);
        return translations.default;
    } catch (error) {
        console.warn(`Language ${language} not found, falling back to English`);
        const fallback = await import('./i18n/en.js');
        return fallback.default;
    }
}

// Usage
const userLang = navigator.language.split('-')[0]; // 'en', 'es', 'fr', etc.
const translations = await loadTranslations(userLang);
```

### Lazy Loading with React

```javascript
// React component lazy loading
import { lazy, Suspense } from 'react';

// Lazy load component
const HeavyComponent = lazy(() => import('./HeavyComponent'));

function App() {
    return (
        <Suspense fallback={<div>Loading...</div>}>
            <HeavyComponent />
        </Suspense>
    );
}
```

## Module Patterns

### Singleton Pattern

```javascript
// database.js - Single instance
class Database {
    constructor() {
        if (Database.instance) {
            return Database.instance;
        }
        
        this.connection = null;
        Database.instance = this;
    }
    
    connect() {
        if (!this.connection) {
            this.connection = 'Connected to database';
            console.log(this.connection);
        }
        return this.connection;
    }
}

export default new Database(); // Export instance, not class

// main.js
import db from './database.js';
db.connect(); // Same instance everywhere
```

### Factory Pattern

```javascript
// user-factory.js
class User {
    constructor(name, email) {
        this.name = name;
        this.email = email;
    }
}

class Admin extends User {
    constructor(name, email) {
        super(name, email);
        this.role = 'admin';
    }
}

class Guest extends User {
    constructor(name, email) {
        super(name, email);
        this.role = 'guest';
    }
}

export function createUser(type, name, email) {
    switch (type) {
        case 'admin':
            return new Admin(name, email);
        case 'guest':
            return new Guest(name, email);
        default:
            return new User(name, email);
    }
}

// main.js
import { createUser } from './user-factory.js';

const admin = createUser('admin', 'Alice', 'alice@example.com');
const guest = createUser('guest', 'Bob', 'bob@example.com');
```

### Module Aggregation

```javascript
// utils/index.js - Barrel export
export * from './string-utils.js';
export * from './number-utils.js';
export * from './date-utils.js';

// Or selective re-export
export { capitalize, truncate } from './string-utils.js';
export { formatNumber, parseNumber } from './number-utils.js';
export { formatDate } from './date-utils.js';

// main.js
// Instead of:
// import { capitalize } from './utils/string-utils.js';
// import { formatNumber } from './utils/number-utils.js';

// You can do:
import { capitalize, formatNumber } from './utils/index.js';
// Or even shorter (if index.js exists):
import { capitalize, formatNumber } from './utils';
```

### Private Implementation

```javascript
// api-client.js
const API_URL = 'https://api.example.com';
const API_KEY = 'secret-key-123';

// Private helper (not exported)
function buildHeaders() {
    return {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${API_KEY}`
    };
}

// Private helper (not exported)
async function handleResponse(response) {
    if (!response.ok) {
        throw new Error(`API error: ${response.status}`);
    }
    return response.json();
}

// Public API
export async function fetchUsers() {
    const response = await fetch(`${API_URL}/users`, {
        headers: buildHeaders()
    });
    return handleResponse(response);
}

export async function createUser(userData) {
    const response = await fetch(`${API_URL}/users`, {
        method: 'POST',
        headers: buildHeaders(),
        body: JSON.stringify(userData)
    });
    return handleResponse(response);
}

// main.js can only use fetchUsers and createUser
// buildHeaders and handleResponse are private to the module
```

## Real-World Examples

### API Module

```javascript
// api/client.js
class APIClient {
    constructor(baseURL) {
        this.baseURL = baseURL;
    }
    
    async get(endpoint) {
        const response = await fetch(`${this.baseURL}${endpoint}`);
        return response.json();
    }
    
    async post(endpoint, data) {
        const response = await fetch(`${this.baseURL}${endpoint}`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(data)
        });
        return response.json();
    }
}

export default new APIClient('https://api.example.com');

// api/users.js
import client from './client.js';

export async function getUsers() {
    return client.get('/users');
}

export async function getUser(id) {
    return client.get(`/users/${id}`);
}

export async function createUser(userData) {
    return client.post('/users', userData);
}

// api/posts.js
import client from './client.js';

export async function getPosts() {
    return client.get('/posts');
}

export async function createPost(postData) {
    return client.post('/posts', postData);
}

// api/index.js (barrel export)
export * as users from './users.js';
export * as posts from './posts.js';

// main.js
import { users, posts } from './api/index.js';

const allUsers = await users.getUsers();
const user = await users.getUser(1);
const allPosts = await posts.getPosts();
```

### State Management

```javascript
// store/state.js
let state = {
    user: null,
    theme: 'light',
    notifications: []
};

const listeners = new Set();

export function getState() {
    return { ...state }; // Return copy
}

export function setState(updates) {
    state = { ...state, ...updates };
    notifyListeners();
}

export function subscribe(listener) {
    listeners.add(listener);
    return () => listeners.delete(listener); // Unsubscribe function
}

function notifyListeners() {
    listeners.forEach(listener => listener(state));
}

// store/actions.js
import { setState, getState } from './state.js';

export function setUser(user) {
    setState({ user });
}

export function setTheme(theme) {
    setState({ theme });
    document.body.className = theme;
}

export function addNotification(notification) {
    const { notifications } = getState();
    setState({
        notifications: [...notifications, notification]
    });
}

// main.js
import { subscribe } from './store/state.js';
import { setUser, setTheme, addNotification } from './store/actions.js';

// Subscribe to changes
const unsubscribe = subscribe((state) => {
    console.log('State updated:', state);
});

// Dispatch actions
setUser({ id: 1, name: 'Alice' });
setTheme('dark');
addNotification({ message: 'Welcome!', type: 'info' });

// Later: unsubscribe when no longer needed
// unsubscribe();
```

### Router Module

```javascript
// router.js
class Router {
    constructor() {
        this.routes = new Map();
        this.currentRoute = null;
        
        window.addEventListener('popstate', () => {
            this.handleRoute(window.location.pathname);
        });
    }
    
    register(path, handler) {
        this.routes.set(path, handler);
    }
    
    navigate(path) {
        history.pushState(null, '', path);
        this.handleRoute(path);
    }
    
    handleRoute(path) {
        const handler = this.routes.get(path);
        if (handler) {
            this.currentRoute = path;
            handler();
        } else {
            this.handleNotFound();
        }
    }
    
    handleNotFound() {
        console.log('404 - Page not found');
    }
}

export default new Router();

// pages/home.js
export function render() {
    document.body.innerHTML = '<h1>Home Page</h1>';
}

// pages/about.js
export function render() {
    document.body.innerHTML = '<h1>About Page</h1>';
}

// main.js
import router from './router.js';
import * as home from './pages/home.js';
import * as about from './pages/about.js';

router.register('/', home.render);
router.register('/about', about.render);

// Handle initial route
router.handleRoute(window.location.pathname);
```

### Validation Module

```javascript
// validators/rules.js
export function required(value) {
    return value != null && value !== '' ? null : 'This field is required';
}

export function minLength(min) {
    return (value) => {
        return value.length >= min ? null : `Minimum length is ${min}`;
    };
}

export function maxLength(max) {
    return (value) => {
        return value.length <= max ? null : `Maximum length is ${max}`;
    };
}

export function email(value) {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(value) ? null : 'Invalid email format';
}

export function pattern(regex, message) {
    return (value) => {
        return regex.test(value) ? null : message;
    };
}

// validators/index.js
import * as rules from './rules.js';

export { rules };

export function validate(data, schema) {
    const errors = {};
    
    for (const [field, validators] of Object.entries(schema)) {
        for (const validator of validators) {
            const error = validator(data[field]);
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
}

// main.js
import { validate, rules } from './validators/index.js';

const schema = {
    username: [rules.required, rules.minLength(3), rules.maxLength(20)],
    email: [rules.required, rules.email],
    password: [rules.required, rules.minLength(8)]
};

const formData = {
    username: 'ab',
    email: 'invalid',
    password: '123'
};

const result = validate(formData, schema);
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

## Module Best Practices

### 1. One Concept Per Module

```javascript
// ❌ Bad: Too many unrelated things in one module
// utils.js
export function formatDate() { }
export function validateEmail() { }
export function calculateTax() { }
export class Database { }

// ✅ Good: Separate by concern
// date-utils.js
export function formatDate() { }

// validators.js
export function validateEmail() { }

// tax-calculator.js
export function calculateTax() { }

// database.js
export class Database { }
```

### 2. Clear Module Names

```javascript
// ❌ Bad: Vague names
// stuff.js, helpers.js, utils.js

// ✅ Good: Descriptive names
// string-formatter.js, email-validator.js, user-api.js
```

### 3. Avoid Circular Dependencies

```javascript
// ❌ Bad: Circular dependency
// userService.js
import { log } from './logger.js';
export function createUser() { log('User created'); }

// logger.js
import { createUser } from './userService.js'; // Circular!
export function log(msg) { console.log(msg); }

// ✅ Good: Remove circular dependency
// userService.js
import { log } from './logger.js';
export function createUser() { log('User created'); }

// logger.js
export function log(msg) { console.log(msg); }
```

### 4. Use Barrel Exports for Related Modules

```javascript
// components/
//   Button.js
//   Input.js
//   Card.js
//   index.js

// components/index.js
export { default as Button } from './Button.js';
export { default as Input } from './Input.js';
export { default as Card } from './Card.js';

// main.js
import { Button, Input, Card } from './components';
```

### 5. Keep Modules Focused and Small

```javascript
// ✅ Good: Small, focused modules
// string-utils.js (only string operations)
export function capitalize(str) { }
export function truncate(str, length) { }

// number-utils.js (only number operations)
export function formatCurrency(amount) { }
export function round(number, decimals) { }
```

### 6. Document Public APIs

```javascript
/**
 * Validates user input data
 * @param {Object} data - The data to validate
 * @param {Object} schema - Validation schema
 * @returns {Object} - { isValid: boolean, errors: Object }
 */
export function validate(data, schema) {
    // implementation
}
```

## CommonJS vs ES Modules

### CommonJS (Node.js)

```javascript
// math.js (CommonJS)
function add(a, b) {
    return a + b;
}

function subtract(a, b) {
    return a - b;
}

module.exports = { add, subtract };

// Or
exports.add = add;
exports.subtract = subtract;

// main.js
const math = require('./math');
console.log(math.add(5, 3)); // 8

// Or destructure
const { add, subtract } = require('./math');
```

### ES Modules

```javascript
// math.js (ES Modules)
export function add(a, b) {
    return a + b;
}

export function subtract(a, b) {
    return a - b;
}

// main.js
import { add, subtract } from './math.js';
console.log(add(5, 3)); // 8
```

### Key Differences

| Feature | CommonJS | ES Modules |
|---------|----------|------------|
| Syntax | `require()` / `module.exports` | `import` / `export` |
| Loading | Synchronous | Asynchronous |
| When loaded | Runtime | Parse time |
| Dynamic imports | ✅ Yes (default) | ✅ Yes (with `import()`) |
| Tree shaking | ❌ No | ✅ Yes |
| Browser support | ❌ No (needs bundler) | ✅ Yes (modern browsers) |
| File extension | `.js` | `.js` or `.mjs` |

### Using ES Modules in Node.js

```javascript
// package.json
{
    "type": "module"
}

// Or use .mjs extension
// math.mjs
export function add(a, b) {
    return a + b;
}

// main.mjs
import { add } from './math.mjs';
```

## Summary

ES6 modules provide:
- Encapsulation and organization of code
- Clear dependency management
- Better maintainability and reusability
- Support for tree shaking and code splitting
- Standardized syntax across platforms

Key concepts:
- `export` to expose functionality
- `import` to use exported functionality
- Default exports for single main exports
- Named exports for multiple exports
- Dynamic imports for lazy loading
- Module scope keeps variables private by default

---

**Previous Topic**: [Destructuring and Spread](20_DESTRUCTURING_SPREAD.md)
**Next Topic**: [Iterators and Generators](22_ITERATORS_GENERATORS.md)
