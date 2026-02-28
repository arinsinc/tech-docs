# Variables and Data Types

## Variables

Variables are containers for storing data values. JavaScript has three ways to declare variables:

### Variable Declaration Keywords

#### 1. let (ES6+)
Block-scoped, can be reassigned, cannot be re-declared in same scope.

```javascript
let age = 25;
age = 26;  // OK: Reassignment allowed

let age = 30;  // Error: Cannot re-declare

if (true) {
    let blockScoped = "only in this block";
}
console.log(blockScoped);  // Error: not defined
```

#### 2. const (ES6+)
Block-scoped, cannot be reassigned, cannot be re-declared.

```javascript
const PI = 3.14159;
PI = 3.14;  // Error: Cannot reassign

const user = { name: "John" };
user.name = "Jane";  // OK: Object properties can change
user = {};  // Error: Cannot reassign the reference

const arr = [1, 2, 3];
arr.push(4);  // OK: Array can be modified
arr = [];  // Error: Cannot reassign
```

#### 3. var (Old Style - Avoid)
Function-scoped, can be reassigned and re-declared.

```javascript
var x = 10;
var x = 20;  // OK: Re-declaration allowed

if (true) {
    var y = 30;
}
console.log(y);  // 30 (function-scoped, not block-scoped)

// Hoisting issue
console.log(z);  // undefined (not an error!)
var z = 40;
```

### Variable Naming Rules

```javascript
// Valid names
let userName;
let _private;
let $element;
let user123;
let camelCaseStyle;

// Invalid names
let 123user;     // Cannot start with number
let user-name;   // No hyphens
let let;         // Cannot use keywords
let user name;   // No spaces
```

### Naming Conventions

```javascript
// camelCase for variables and functions
let firstName = "John";
function getUserData() {}

// PascalCase for classes
class UserProfile {}

// UPPER_CASE for constants
const MAX_SIZE = 100;
const API_KEY = "abc123";

// Descriptive names
let n = "John";              // Bad
let userName = "John";       // Good

let arr = [1, 2, 3];         // Bad
let scores = [1, 2, 3];      // Good
```

## Data Types

JavaScript has 8 data types:

### 1. Primitive Types

#### Number
```javascript
let integer = 42;
let float = 3.14;
let negative = -10;
let exponential = 5e3;  // 5000
let binary = 0b1010;    // 10
let octal = 0o12;       // 10
let hex = 0xFF;         // 255

// Special numeric values
let infinity = Infinity;
let negInfinity = -Infinity;
let notANumber = NaN;

// Number operations
console.log(10 / 0);          // Infinity
console.log("text" / 2);      // NaN
console.log(typeof NaN);      // "number"

// Number methods
let num = 123.456;
num.toFixed(2);              // "123.46"
num.toPrecision(4);          // "123.5"
parseInt("123.45");          // 123
parseFloat("123.45");        // 123.45
Number.isInteger(123);       // true
Number.isNaN(NaN);           // true
```

#### BigInt (ES2020)
For integers larger than 2^53 - 1.

```javascript
let big = 1234567890123456789012345678901234567890n;
let big2 = BigInt("1234567890123456789012345678901234567890");

// Operations
let result = big + 100n;  // Must use 'n' suffix
// let invalid = big + 100;  // Error: Cannot mix BigInt and Number
```

#### String
```javascript
let single = 'Single quotes';
let double = "Double quotes";
let template = `Template literal with ${single}`;

// String length
let str = "Hello";
console.log(str.length);  // 5

// String methods
str.toUpperCase();        // "HELLO"
str.toLowerCase();        // "hello"
str.charAt(0);            // "H"
str.indexOf("l");         // 2
str.slice(1, 4);          // "ell"
str.substring(1, 4);      // "ell"
str.split("");            // ["H", "e", "l", "l", "o"]
str.includes("ll");       // true
str.startsWith("He");     // true
str.endsWith("lo");       // true
str.repeat(3);            // "HelloHelloHello"
str.trim();               // Removes whitespace

// Template literals
let name = "John";
let age = 30;
let message = `My name is ${name} and I'm ${age} years old.`;

// Multi-line strings
let multiline = `
    This is line 1
    This is line 2
    This is line 3
`;
```

#### Boolean
```javascript
let isTrue = true;
let isFalse = false;

// Boolean conversion
Boolean(1);          // true
Boolean(0);          // false
Boolean("text");     // true
Boolean("");         // false
Boolean(null);       // false
Boolean(undefined);  // false

// Falsy values (convert to false)
// false, 0, -0, 0n, "", null, undefined, NaN

// Truthy values (everything else)
// true, any non-zero number, non-empty string, objects, arrays
```

#### Undefined
```javascript
let notAssigned;
console.log(notAssigned);  // undefined

function noReturn() {}
console.log(noReturn());   // undefined

let obj = { name: "John" };
console.log(obj.age);      // undefined
```

#### Null
```javascript
let empty = null;
console.log(empty);        // null
console.log(typeof null);  // "object" (historical bug!)

// null vs undefined
let a;              // undefined (not assigned)
let b = null;       // null (intentionally empty)
```

#### Symbol (ES6)
Unique and immutable identifier.

```javascript
let sym1 = Symbol("description");
let sym2 = Symbol("description");
console.log(sym1 === sym2);  // false (always unique)

// Use case: Object property keys
let id = Symbol("id");
let user = {
    name: "John",
    [id]: 12345
};
console.log(user[id]);  // 12345

// Well-known symbols
Symbol.iterator
Symbol.toStringTag
```

### 2. Non-Primitive (Object) Type

#### Object
```javascript
// Object literal
let person = {
    name: "John",
    age: 30,
    city: "New York",
    "full name": "John Doe"  // Property with space
};

// Accessing properties
console.log(person.name);           // Dot notation
console.log(person["age"]);         // Bracket notation
console.log(person["full name"]);   // Required for special names

// Adding/modifying properties
person.email = "john@example.com";
person.age = 31;

// Deleting properties
delete person.city;

// Checking property existence
"name" in person;                   // true
person.hasOwnProperty("name");      // true

// Object methods
Object.keys(person);                // Array of keys
Object.values(person);              // Array of values
Object.entries(person);             // Array of [key, value] pairs
```

#### Array
```javascript
let numbers = [1, 2, 3, 4, 5];
let mixed = [1, "text", true, null, {name: "John"}];

// Accessing elements
console.log(numbers[0]);     // 1 (zero-indexed)
console.log(numbers.length); // 5

// Common array methods
numbers.push(6);             // Add to end
numbers.pop();               // Remove from end
numbers.unshift(0);          // Add to beginning
numbers.shift();             // Remove from beginning
numbers.indexOf(3);          // Find index
numbers.includes(3);         // Check existence
numbers.slice(1, 3);         // Extract portion
numbers.splice(1, 2);        // Remove/replace elements
numbers.concat([6, 7]);      // Join arrays
numbers.reverse();           // Reverse array
numbers.sort();              // Sort array
```

#### Function
```javascript
// Function declaration
function greet(name) {
    return `Hello, ${name}!`;
}

// Function expression
const greet2 = function(name) {
    return `Hello, ${name}!`;
};

// Arrow function
const greet3 = (name) => `Hello, ${name}!`;

// Functions are objects
console.log(typeof greet);  // "function"
```

## Type Checking

### typeof Operator
```javascript
typeof 42;                // "number"
typeof 3.14;              // "number"
typeof NaN;               // "number"
typeof "text";            // "string"
typeof true;              // "boolean"
typeof undefined;         // "undefined"
typeof null;              // "object" (bug!)
typeof Symbol("sym");     // "symbol"
typeof 123n;              // "bigint"
typeof {};                // "object"
typeof [];                // "object"
typeof function(){};      // "function"
```

### Better Type Checking
```javascript
// Check for null
value === null;

// Check for array
Array.isArray([]);              // true
Array.isArray({});              // false

// Check for object (not null)
value !== null && typeof value === "object" && !Array.isArray(value);

// Check for NaN
Number.isNaN(NaN);              // true
Number.isNaN("text");           // false

// instanceof operator
new Date() instanceof Date;     // true
[] instanceof Array;            // true
```

## Type Conversion

### Implicit Conversion (Coercion)
```javascript
// String coercion
"5" + 5;          // "55" (number to string)
"5" + true;       // "5true"

// Number coercion
"5" - 5;          // 0
"5" * "2";        // 10
true + 1;         // 2
false + 1;        // 1

// Boolean coercion
if ("text") {}    // Truthy
if (0) {}         // Falsy
```

### Explicit Conversion
```javascript
// To String
String(123);              // "123"
(123).toString();         // "123"
123 + "";                 // "123"

// To Number
Number("123");            // 123
parseInt("123.45");       // 123
parseFloat("123.45");     // 123.45
+"123";                   // 123 (unary plus)

// To Boolean
Boolean(1);               // true
Boolean(0);               // false
!!value;                  // Double negation
```

## Best Practices

### 1. Use const by Default
```javascript
// Prefer const for values that don't change
const PI = 3.14159;
const user = { name: "John" };

// Use let only when you need to reassign
let counter = 0;
counter++;
```

### 2. Avoid var
```javascript
// Don't use var
var x = 10;

// Use let or const
let x = 10;
const y = 20;
```

### 3. Use Strict Equality
```javascript
// Avoid ==
5 == "5";   // true

// Use ===
5 === "5";  // false
```

### 4. Initialize Variables
```javascript
// Bad
let name;
console.log(name);  // undefined

// Good
let name = "Unknown";
console.log(name);
```

### 5. Use Descriptive Types
```javascript
// Be clear about what type you're using
const count = 0;              // Number
const message = "";           // String
const isActive = false;       // Boolean
const items = [];             // Array
const user = {};              // Object
const noValue = null;         // Null (intentional)
```

## Practice Exercises

### Exercise 1: Variable Declaration
```javascript
// Declare variables using let and const
// Try to reassign const and observe the error
```

### Exercise 2: Type Conversion
```javascript
// Convert "123" to number
// Convert 456 to string
// Convert 0 to boolean
```

### Exercise 3: Type Checking
```javascript
// Create variables of different types
// Use typeof to check each one
```

## Summary

- Use `let` for reassignable variables, `const` for constants
- Avoid `var` in modern JavaScript
- 8 data types: Number, BigInt, String, Boolean, Undefined, Null, Symbol, Object
- Use `typeof` for basic type checking
- Be aware of type coercion vs explicit conversion
- Always use `===` for equality checks

## Next Steps

Continue to [Operators and Expressions](03_OPERATORS.md) to learn about JavaScript operators.
