# Destructuring and Spread Operator

## Table of Contents
1. [Introduction](#introduction)
2. [Array Destructuring](#array-destructuring)
3. [Object Destructuring](#object-destructuring)
4. [Spread Operator](#spread-operator)
5. [Rest Parameters](#rest-parameters)
6. [Advanced Patterns](#advanced-patterns)
7. [Real-World Examples](#real-world-examples)
8. [Best Practices](#best-practices)

## Introduction

Destructuring and the spread operator are ES6+ features that make working with arrays and objects more concise and readable. They allow you to extract values and combine data structures in elegant ways.

## Array Destructuring

### Basic Array Destructuring

```javascript
// Traditional way
const colors = ['red', 'green', 'blue'];
const first = colors[0];
const second = colors[1];

// ✅ Destructuring way
const [first, second] = colors;
console.log(first);   // 'red'
console.log(second);  // 'green'

// Get all values
const [r, g, b] = colors;
console.log(r, g, b);  // 'red' 'green' 'blue'
```

### Skipping Elements

```javascript
const numbers = [1, 2, 3, 4, 5];

// Skip elements with commas
const [first, , third] = numbers;
console.log(first, third);  // 1 3

// Get first and last
const [a, , , , e] = numbers;
console.log(a, e);  // 1 5
```

### Default Values

```javascript
const colors = ['red'];

// Without default
const [first, second] = colors;
console.log(first, second);  // 'red' undefined

// With default
const [primary, secondary = 'blue'] = colors;
console.log(primary, secondary);  // 'red' 'blue'

// Multiple defaults
const [r, g = 'green', b = 'blue'] = ['red'];
console.log(r, g, b);  // 'red' 'green' 'blue'
```

### Rest Pattern in Arrays

```javascript
const numbers = [1, 2, 3, 4, 5];

// Get first and rest
const [first, ...rest] = numbers;
console.log(first);  // 1
console.log(rest);   // [2, 3, 4, 5]

// Get first, second, and rest
const [a, b, ...others] = numbers;
console.log(a, b);      // 1 2
console.log(others);    // [3, 4, 5]

// Rest must be last
// ❌ const [...rest, last] = numbers; // SyntaxError
```

### Swapping Variables

```javascript
let a = 1;
let b = 2;

// Traditional way (needs temp variable)
let temp = a;
a = b;
b = temp;

// ✅ Destructuring way (no temp variable)
[a, b] = [b, a];
console.log(a, b);  // 2 1

// Swap multiple variables
let x = 1, y = 2, z = 3;
[x, y, z] = [z, x, y];
console.log(x, y, z);  // 3 1 2
```

### Nested Array Destructuring

```javascript
const nested = [1, [2, 3], 4];

const [a, [b, c], d] = nested;
console.log(a, b, c, d);  // 1 2 3 4

// Complex nesting
const matrix = [[1, 2], [3, 4], [5, 6]];
const [[a1, a2], [b1, b2]] = matrix;
console.log(a1, a2, b1, b2);  // 1 2 3 4
```

### Function Return Values

```javascript
function getCoordinates() {
    return [10, 20];
}

const [x, y] = getCoordinates();
console.log(x, y);  // 10 20

// Ignore values you don't need
function getUserInfo() {
    return ['John', 'Doe', 30, 'john@example.com'];
}

const [firstName, lastName, , email] = getUserInfo();
console.log(firstName, lastName, email);  // 'John' 'Doe' 'john@example.com'
```

## Object Destructuring

### Basic Object Destructuring

```javascript
const user = {
    name: 'Alice',
    age: 25,
    email: 'alice@example.com'
};

// Traditional way
const name = user.name;
const age = user.age;

// ✅ Destructuring way
const { name, age } = user;
console.log(name, age);  // 'Alice' 25

// Order doesn't matter
const { email, name: userName } = user;
console.log(email, userName);  // 'alice@example.com' 'Alice'
```

### Renaming Variables

```javascript
const user = {
    name: 'Bob',
    age: 30
};

// Rename during destructuring
const { name: userName, age: userAge } = user;
console.log(userName, userAge);  // 'Bob' 30

// Useful for avoiding name conflicts
const { name: firstName } = { name: 'Alice' };
const { name: lastName } = { name: 'Smith' };
console.log(firstName, lastName);  // 'Alice' 'Smith'
```

### Default Values

```javascript
const user = {
    name: 'Charlie'
};

// Without default
const { name, age } = user;
console.log(name, age);  // 'Charlie' undefined

// With default
const { name: n, age: a = 25 } = user;
console.log(n, a);  // 'Charlie' 25

// Default only applies if property is undefined
const settings = {
    theme: 'dark',
    notifications: undefined
};

const { theme = 'light', notifications = true } = settings;
console.log(theme, notifications);  // 'dark' true
```

### Nested Object Destructuring

```javascript
const user = {
    name: 'David',
    address: {
        street: '123 Main St',
        city: 'Boston',
        coordinates: {
            lat: 42.3601,
            lng: -71.0589
        }
    }
};

// Destructure nested properties
const {
    name,
    address: { city, coordinates: { lat, lng } }
} = user;

console.log(name, city, lat, lng);  // 'David' 'Boston' 42.3601 -71.0589

// Note: 'address' and 'coordinates' are not variables
// console.log(address); // ReferenceError

// To also get parent object
const {
    name: userName,
    address,
    address: { city: userCity }
} = user;

console.log(userName, address, userCity);
```

### Rest Pattern in Objects

```javascript
const user = {
    name: 'Eve',
    age: 28,
    email: 'eve@example.com',
    city: 'NYC',
    country: 'USA'
};

// Extract some properties, rest in another object
const { name, age, ...otherInfo } = user;
console.log(name, age);     // 'Eve' 28
console.log(otherInfo);     // { email: '...', city: 'NYC', country: 'USA' }

// Useful for removing properties
const { password, ...publicInfo } = {
    id: 1,
    name: 'Admin',
    password: 'secret123',
    email: 'admin@example.com'
};

console.log(publicInfo);  // { id: 1, name: 'Admin', email: '...' }
```

### Computed Property Names

```javascript
const key = 'name';
const { [key]: value } = { name: 'Frank' };
console.log(value);  // 'Frank'

// Dynamic property extraction
function getProperty(obj, key) {
    const { [key]: value } = obj;
    return value;
}

const user = { name: 'Grace', age: 30 };
console.log(getProperty(user, 'name'));  // 'Grace'
console.log(getProperty(user, 'age'));   // 30
```

### Function Parameters

```javascript
// Without destructuring
function displayUser(user) {
    console.log(`Name: ${user.name}, Age: ${user.age}`);
}

// ✅ With destructuring
function displayUser({ name, age }) {
    console.log(`Name: ${name}, Age: ${age}`);
}

displayUser({ name: 'Henry', age: 35 });  // Name: Henry, Age: 35

// With defaults
function createUser({ name, age = 18, role = 'user' }) {
    return { name, age, role };
}

console.log(createUser({ name: 'Ivy' }));
// { name: 'Ivy', age: 18, role: 'user' }

// With rest
function updateUser({ id, ...updates }) {
    console.log(`Updating user ${id} with:`, updates);
}

updateUser({ id: 1, name: 'Jack', email: 'jack@example.com' });
// Updating user 1 with: { name: 'Jack', email: 'jack@example.com' }
```

## Spread Operator

### Spreading Arrays

```javascript
const arr1 = [1, 2, 3];
const arr2 = [4, 5, 6];

// Combine arrays
const combined = [...arr1, ...arr2];
console.log(combined);  // [1, 2, 3, 4, 5, 6]

// Add elements
const withExtra = [0, ...arr1, 3.5, ...arr2, 7];
console.log(withExtra);  // [0, 1, 2, 3, 3.5, 4, 5, 6, 7]

// Copy array (shallow copy)
const copy = [...arr1];
console.log(copy);  // [1, 2, 3]
console.log(copy === arr1);  // false (different reference)
```

### Spreading Objects

```javascript
const user = {
    name: 'Kate',
    age: 28
};

const address = {
    city: 'NYC',
    country: 'USA'
};

// Combine objects
const userWithAddress = { ...user, ...address };
console.log(userWithAddress);
// { name: 'Kate', age: 28, city: 'NYC', country: 'USA' }

// Copy object (shallow copy)
const userCopy = { ...user };
console.log(userCopy);  // { name: 'Kate', age: 28 }
console.log(userCopy === user);  // false

// Override properties
const updatedUser = { ...user, age: 29 };
console.log(updatedUser);  // { name: 'Kate', age: 29 }

// Order matters
const obj1 = { a: 1, b: 2 };
const obj2 = { b: 3, c: 4 };

console.log({ ...obj1, ...obj2 });  // { a: 1, b: 3, c: 4 }
console.log({ ...obj2, ...obj1 });  // { a: 1, b: 2, c: 4 }
```

### Function Arguments

```javascript
// Spread array into function arguments
const numbers = [1, 2, 3, 4, 5];

console.log(Math.max(...numbers));  // 5
console.log(Math.min(...numbers));  // 1

// Traditional way
console.log(Math.max.apply(null, numbers));  // 5

// Multiple spreads
const moreNumbers = [6, 7, 8];
console.log(Math.max(...numbers, ...moreNumbers));  // 8
```

### String to Array

```javascript
const str = 'hello';

// Spread string into array
const chars = [...str];
console.log(chars);  // ['h', 'e', 'l', 'l', 'o']

// Traditional way
const chars2 = str.split('');
console.log(chars2);  // ['h', 'e', 'l', 'l', 'o']
```

### Spreading Iterables

```javascript
// Spread Set
const set = new Set([1, 2, 3, 3, 4]);
const arr = [...set];
console.log(arr);  // [1, 2, 3, 4]

// Spread Map
const map = new Map([['a', 1], ['b', 2]]);
const entries = [...map];
console.log(entries);  // [['a', 1], ['b', 2]]

// NodeList to Array (DOM)
// const divs = [...document.querySelectorAll('div')];
```

## Rest Parameters

### Function Rest Parameters

```javascript
// Collect all arguments into an array
function sum(...numbers) {
    return numbers.reduce((acc, num) => acc + num, 0);
}

console.log(sum(1, 2, 3));        // 6
console.log(sum(1, 2, 3, 4, 5));  // 15

// Mix regular and rest parameters
function greet(greeting, ...names) {
    return `${greeting}, ${names.join(' and ')}!`;
}

console.log(greet('Hello', 'Alice'));              // "Hello, Alice!"
console.log(greet('Hi', 'Bob', 'Charlie'));        // "Hi, Bob and Charlie!"
console.log(greet('Hey', 'David', 'Eve', 'Frank')); // "Hey, David and Eve and Frank!"
```

### Rest vs Arguments Object

```javascript
// ❌ Old way: arguments object (not a real array)
function oldSum() {
    return Array.from(arguments).reduce((acc, num) => acc + num, 0);
}

// ✅ Modern way: rest parameters (real array)
function modernSum(...numbers) {
    return numbers.reduce((acc, num) => acc + num, 0);
}

// Rest parameters work with arrow functions
const arrowSum = (...numbers) => numbers.reduce((acc, num) => acc + num, 0);
```

## Advanced Patterns

### Conditional Spreading

```javascript
const includeAge = true;

const user = {
    name: 'Leo',
    ...(includeAge && { age: 30 }),
    email: 'leo@example.com'
};

console.log(user);
// If includeAge is true: { name: 'Leo', age: 30, email: '...' }
// If includeAge is false: { name: 'Leo', email: '...' }

// Array example
const includeExtras = true;
const items = [1, 2, 3, ...(includeExtras ? [4, 5] : [])];
console.log(items);  // [1, 2, 3, 4, 5] or [1, 2, 3]
```

### Merging with Defaults

```javascript
const defaultSettings = {
    theme: 'light',
    notifications: true,
    language: 'en'
};

const userSettings = {
    theme: 'dark',
    language: 'es'
};

// Merge with defaults (user settings override defaults)
const settings = { ...defaultSettings, ...userSettings };
console.log(settings);
// { theme: 'dark', notifications: true, language: 'es' }
```

### Shallow vs Deep Copy

```javascript
const original = {
    name: 'Mia',
    address: {
        city: 'LA',
        zip: '90001'
    }
};

// ⚠️ Shallow copy (nested objects are still referenced)
const shallowCopy = { ...original };
shallowCopy.address.city = 'SF';

console.log(original.address.city);     // 'SF' (changed!)
console.log(shallowCopy.address.city);  // 'SF'

// ✅ Deep copy (for simple objects)
const deepCopy = JSON.parse(JSON.stringify(original));
deepCopy.address.city = 'NYC';

console.log(original.address.city);  // 'SF' (unchanged)
console.log(deepCopy.address.city);  // 'NYC'

// Note: JSON method has limitations (no functions, dates, etc.)
```

### Removing Properties

```javascript
const user = {
    id: 1,
    name: 'Nina',
    password: 'secret123',
    email: 'nina@example.com'
};

// Remove password
const { password, ...safeUser } = user;
console.log(safeUser);  // { id: 1, name: 'Nina', email: '...' }

// Remove multiple properties
const { password: pw, email: em, ...publicUser } = user;
console.log(publicUser);  // { id: 1, name: 'Nina' }
```

### Partial Updates

```javascript
function updateUser(userId, updates) {
    const existingUser = {
        id: userId,
        name: 'Oscar',
        age: 25,
        email: 'oscar@example.com'
    };
    
    return { ...existingUser, ...updates };
}

const updated = updateUser(1, { age: 26, city: 'Boston' });
console.log(updated);
// { id: 1, name: 'Oscar', age: 26, email: '...', city: 'Boston' }
```

## Real-World Examples

### API Response Transformation

```javascript
function transformUser(apiResponse) {
    const {
        id,
        first_name: firstName,
        last_name: lastName,
        email_address: email,
        profile: { avatar_url: avatar, bio } = {},
        ...metadata
    } = apiResponse;
    
    return {
        id,
        firstName,
        lastName,
        email,
        avatar,
        bio,
        metadata
    };
}

const apiUser = {
    id: 1,
    first_name: 'Paul',
    last_name: 'Smith',
    email_address: 'paul@example.com',
    profile: {
        avatar_url: 'https://...',
        bio: 'Developer'
    },
    created_at: '2024-01-01',
    updated_at: '2024-01-15'
};

console.log(transformUser(apiUser));
```

### React Component Props

```javascript
function Button({ children, onClick, variant = 'primary', ...restProps }) {
    const className = `btn btn-${variant}`;
    
    return (
        <button
            className={className}
            onClick={onClick}
            {...restProps}
        >
            {children}
        </button>
    );
}

// Usage
<Button onClick={handleClick} disabled id="submit-btn">
    Submit
</Button>
```

### Array Manipulation

```javascript
// Remove duplicates
const numbers = [1, 2, 2, 3, 4, 4, 5];
const unique = [...new Set(numbers)];
console.log(unique);  // [1, 2, 3, 4, 5]

// Merge and deduplicate multiple arrays
const arr1 = [1, 2, 3];
const arr2 = [2, 3, 4];
const arr3 = [3, 4, 5];
const merged = [...new Set([...arr1, ...arr2, ...arr3])];
console.log(merged);  // [1, 2, 3, 4, 5]

// Insert elements at specific position
const original = [1, 2, 5, 6];
const index = 2;
const toInsert = [3, 4];
const result = [...original.slice(0, index), ...toInsert, ...original.slice(index)];
console.log(result);  // [1, 2, 3, 4, 5, 6]
```

### Configuration Objects

```javascript
const defaultConfig = {
    port: 3000,
    host: 'localhost',
    ssl: false,
    timeout: 5000,
    retries: 3
};

function createServer(userConfig = {}) {
    const config = {
        ...defaultConfig,
        ...userConfig,
        // Computed properties
        url: `http${userConfig.ssl ? 's' : ''}://${userConfig.host || defaultConfig.host}:${userConfig.port || defaultConfig.port}`
    };
    
    return config;
}

const server = createServer({ port: 8080, ssl: true, host: 'api.example.com' });
console.log(server);
```

### Form Data Handling

```javascript
function submitForm(event) {
    event.preventDefault();
    
    const formData = new FormData(event.target);
    const data = {
        ...Object.fromEntries(formData),
        timestamp: Date.now()
    };
    
    // Remove empty fields
    const cleanData = Object.entries(data).reduce((acc, [key, value]) => {
        if (value !== '') {
            return { ...acc, [key]: value };
        }
        return acc;
    }, {});
    
    console.log(cleanData);
}
```

### State Management

```javascript
// Redux-style reducer
function reducer(state, action) {
    switch (action.type) {
        case 'UPDATE_USER':
            return {
                ...state,
                user: {
                    ...state.user,
                    ...action.payload
                }
            };
        
        case 'ADD_ITEM':
            return {
                ...state,
                items: [...state.items, action.payload]
            };
        
        case 'REMOVE_ITEM':
            return {
                ...state,
                items: state.items.filter(item => item.id !== action.payload)
            };
        
        default:
            return state;
    }
}
```

## Best Practices

### 1. Use Destructuring for Cleaner Code

```javascript
// ❌ Repetitive access
function displayUser(user) {
    console.log(user.name);
    console.log(user.email);
    console.log(user.age);
}

// ✅ Destructure parameters
function displayUser({ name, email, age }) {
    console.log(name);
    console.log(email);
    console.log(age);
}
```

### 2. Provide Defaults

```javascript
// ❌ Manual default checks
function createUser(name, age, role) {
    const userAge = age !== undefined ? age : 18;
    const userRole = role !== undefined ? role : 'user';
    // ...
}

// ✅ Use default values
function createUser(name, age = 18, role = 'user') {
    // ...
}
```

### 3. Be Aware of Shallow Copies

```javascript
// ⚠️ Shallow copy problem
const original = { nested: { value: 1 } };
const copy = { ...original };
copy.nested.value = 2;
console.log(original.nested.value);  // 2 (modified!)

// ✅ Use deep copy when needed
const deepCopy = JSON.parse(JSON.stringify(original));
// Or use a library like lodash's cloneDeep
```

### 4. Use Rest for Flexibility

```javascript
// ✅ Flexible function arguments
function createLogger(level, ...messages) {
    console.log(`[${level}]`, ...messages);
}

createLogger('INFO', 'User logged in');
createLogger('ERROR', 'Failed to connect', 'Retrying...');
```

### 5. Combine with Optional Chaining

```javascript
// ✅ Safe destructuring with optional chaining
const user = null;
const { name = 'Guest' } = user ?? {};
console.log(name);  // 'Guest'

// Nested destructuring
const data = { user: { profile: { name: 'Quinn' } } };
const { user: { profile: { name } = {} } = {} } = data ?? {};
console.log(name);  // 'Quinn'
```

## Summary

Destructuring and spread operators provide:
- Cleaner, more readable code
- Easy extraction of values from arrays and objects
- Convenient way to copy and merge data structures
- Flexible function parameters and return values

Key takeaways:
- Destructuring extracts values into variables
- Spread operator expands iterables
- Rest pattern collects remaining values
- Both work with arrays and objects
- Be mindful of shallow vs deep copies

---

**Next Topic**: [Modules (ES6)](21_MODULES.md)
