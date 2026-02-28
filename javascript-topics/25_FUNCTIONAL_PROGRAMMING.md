# Functional Programming in JavaScript

Functional programming is a programming paradigm that treats computation as the evaluation of mathematical functions and avoids changing state and mutable data.

## Table of Contents
1. [Core Concepts](#core-concepts)
2. [Pure Functions](#pure-functions)
3. [Immutability](#immutability)
4. [Function Composition](#function-composition)
5. [Currying and Partial Application](#currying-and-partial-application)
6. [Higher-Order Functions](#higher-order-functions)
7. [Functors and Monads](#functors-and-monads)

---

## Core Concepts

### Principles of Functional Programming

1. **Pure Functions**: Functions that always return the same output for the same input
2. **Immutability**: Data cannot be changed after creation
3. **First-Class Functions**: Functions are treated as values
4. **Function Composition**: Building complex functions from simpler ones
5. **Declarative Style**: Describing what to do, not how to do it

```javascript
// Imperative (non-functional)
const numbers = [1, 2, 3, 4, 5];
const doubled = [];
for (let i = 0; i < numbers.length; i++) {
  doubled.push(numbers[i] * 2);
}

// Declarative (functional)
const doubledFunctional = numbers.map(n => n * 2);

// Even better with named function
const double = n => n * 2;
const doubledClean = numbers.map(double);
```

---

## Pure Functions

Pure functions have no side effects and always return the same output for the same input.

### Characteristics

```javascript
// ✅ Pure function
function add(a, b) {
  return a + b;
}

console.log(add(2, 3)); // 5
console.log(add(2, 3)); // 5 (always the same)

// ✅ Pure function
function multiply(a, b) {
  return a * b;
}

// ❌ Impure function (side effect - modifies external state)
let total = 0;
function addToTotal(value) {
  total += value; // Modifies external variable
  return total;
}

// ❌ Impure function (non-deterministic)
function getCurrentTime() {
  return new Date().toISOString(); // Different output each call
}

// ❌ Impure function (side effect - I/O)
function logMessage(message) {
  console.log(message); // Side effect
  return message;
}
```

### Making Functions Pure

```javascript
// ❌ Impure
let discount = 0.1;
function calculatePrice(price) {
  return price - (price * discount);
}

// ✅ Pure
function calculatePricePure(price, discount) {
  return price - (price * discount);
}

// ❌ Impure (mutates array)
function addItem(array, item) {
  array.push(item);
  return array;
}

// ✅ Pure (returns new array)
function addItemPure(array, item) {
  return [...array, item];
}

// ❌ Impure (mutates object)
function updateUser(user, updates) {
  user.name = updates.name;
  user.email = updates.email;
  return user;
}

// ✅ Pure (returns new object)
function updateUserPure(user, updates) {
  return {
    ...user,
    ...updates
  };
}
```

### Benefits of Pure Functions

```javascript
// Easy to test
const sum = (a, b) => a + b;
console.log(sum(2, 3) === 5); // true

// Easy to reason about
const square = x => x * x;
console.log(square(4)); // 16, always

// Can be cached (memoization)
function memoize(fn) {
  const cache = {};
  return function(...args) {
    const key = JSON.stringify(args);
    if (cache[key]) {
      console.log('From cache');
      return cache[key];
    }
    const result = fn(...args);
    cache[key] = result;
    return result;
  };
}

const expensiveCalculation = memoize((n) => {
  console.log('Computing...');
  return n * n * n;
});

console.log(expensiveCalculation(5)); // Computing... 125
console.log(expensiveCalculation(5)); // From cache 125
```

---

## Immutability

Data cannot be changed after creation. Instead, create new copies with modifications.

### Working with Immutable Data

```javascript
// Arrays

// ❌ Mutable
const numbers = [1, 2, 3];
numbers.push(4); // Modifies original
numbers[0] = 0;  // Modifies original

// ✅ Immutable
const numbers = [1, 2, 3];
const newNumbers = [...numbers, 4];        // [1, 2, 3, 4]
const updated = [0, ...numbers.slice(1)];  // [0, 2, 3]

// Immutable array operations
const original = [1, 2, 3, 4, 5];

const added = [...original, 6];                          // Add
const removed = original.filter(n => n !== 3);           // Remove
const updated = original.map(n => n === 3 ? 30 : n);     // Update
const sliced = original.slice(1, 4);                     // Slice

// Objects

// ❌ Mutable
const user = { name: 'John', age: 30 };
user.age = 31; // Modifies original

// ✅ Immutable
const user = { name: 'John', age: 30 };
const updatedUser = { ...user, age: 31 };

// Nested objects
const state = {
  user: {
    name: 'John',
    address: {
      city: 'New York',
      country: 'USA'
    }
  }
};

// ✅ Immutable update of nested property
const newState = {
  ...state,
  user: {
    ...state.user,
    address: {
      ...state.user.address,
      city: 'Los Angeles'
    }
  }
};
```

### Immutable Data Structures

```javascript
// Helper functions for immutability
const updateObject = (obj, updates) => ({
  ...obj,
  ...updates
});

const updateNestedObject = (obj, path, value) => {
  const [first, ...rest] = path;
  
  if (rest.length === 0) {
    return { ...obj, [first]: value };
  }
  
  return {
    ...obj,
    [first]: updateNestedObject(obj[first], rest, value)
  };
};

// Usage
const user = {
  name: 'John',
  profile: {
    email: 'john@example.com',
    settings: {
      theme: 'dark'
    }
  }
};

const updated = updateNestedObject(
  user,
  ['profile', 'settings', 'theme'],
  'light'
);

// Using libraries like Immer
// import produce from 'immer';
//
// const nextState = produce(state, draft => {
//   draft.user.address.city = 'Los Angeles';
// });
```

### Benefits of Immutability

```javascript
// 1. Predictability
const numbers = [1, 2, 3];
const doubled = numbers.map(n => n * 2);
console.log(numbers);  // [1, 2, 3] - unchanged
console.log(doubled);  // [2, 4, 6]

// 2. Easy to track changes
function undo(history) {
  return history[history.length - 2];
}

const history = [
  { count: 0 },
  { count: 1 },
  { count: 2 }
];

// 3. Concurrent programming (no race conditions)
// Multiple functions can work with the same data safely

// 4. Easy testing
function addUser(users, newUser) {
  return [...users, newUser];
}

const users = [{ id: 1 }];
const result = addUser(users, { id: 2 });
console.log(users.length === 1);   // true
console.log(result.length === 2);  // true
```

---

## Function Composition

Combining simple functions to build more complex ones.

### Basic Composition

```javascript
// Simple functions
const add = x => x + 10;
const multiply = x => x * 2;
const subtract = x => x - 5;

// Manual composition
const result = subtract(multiply(add(5)));
console.log(result); // 25

// Compose function (right to left)
const compose = (...fns) => x =>
  fns.reduceRight((acc, fn) => fn(acc), x);

const calculate = compose(subtract, multiply, add);
console.log(calculate(5)); // 25

// Pipe function (left to right)
const pipe = (...fns) => x =>
  fns.reduce((acc, fn) => fn(acc), x);

const calculatePipe = pipe(add, multiply, subtract);
console.log(calculatePipe(5)); // 25

// Steps: 5 -> add(5) = 15 -> multiply(15) = 30 -> subtract(30) = 25
```

### Practical Examples

```javascript
// String manipulation
const trim = str => str.trim();
const toLowerCase = str => str.toLowerCase();
const capitalize = str => str.charAt(0).toUpperCase() + str.slice(1);

const normalizeString = pipe(
  trim,
  toLowerCase,
  capitalize
);

console.log(normalizeString('  HELLO WORLD  ')); // "Hello world"

// Data transformation
const users = [
  { name: 'John', age: 25, active: true },
  { name: 'Jane', age: 30, active: false },
  { name: 'Bob', age: 35, active: true }
];

const isActive = user => user.active;
const getAge = user => user.age;
const isAdult = age => age >= 18;

const getActiveUsers = users => users.filter(isActive);
const getAges = users => users.map(getAge);
const getAllAdults = ages => ages.filter(isAdult);

const processUsers = pipe(
  getActiveUsers,
  getAges,
  getAllAdults
);

console.log(processUsers(users)); // [25, 35]

// Point-free style (no explicit arguments)
const add5 = x => x + 5;
const double = x => x * 2;

const transform = pipe(add5, double);
console.log([1, 2, 3].map(transform)); // [12, 14, 16]
```

### Advanced Composition

```javascript
// Composing with multiple arguments
const curry = (fn) => {
  return function curried(...args) {
    if (args.length >= fn.length) {
      return fn(...args);
    }
    return (...nextArgs) => curried(...args, ...nextArgs);
  };
};

const add = curry((a, b) => a + b);
const multiply = curry((a, b) => a * b);

const addThenDouble = pipe(
  add(5),
  multiply(2)
);

console.log(addThenDouble(10)); // 30

// Composing async functions
const asyncPipe = (...fns) => input =>
  fns.reduce(
    (promise, fn) => promise.then(fn),
    Promise.resolve(input)
  );

const fetchUser = id => 
  Promise.resolve({ id, name: 'John' });

const fetchPosts = user =>
  Promise.resolve({ ...user, posts: ['Post 1', 'Post 2'] });

const formatData = data =>
  Promise.resolve({
    userName: data.name,
    postCount: data.posts.length
  });

const getUserInfo = asyncPipe(
  fetchUser,
  fetchPosts,
  formatData
);

getUserInfo(1).then(console.log);
// { userName: 'John', postCount: 2 }
```

---

## Currying and Partial Application

### Currying

Transforming a function with multiple arguments into a sequence of functions each taking a single argument.

```javascript
// Regular function
function add(a, b, c) {
  return a + b + c;
}

console.log(add(1, 2, 3)); // 6

// Curried version
function addCurried(a) {
  return function(b) {
    return function(c) {
      return a + b + c;
    };
  };
}

console.log(addCurried(1)(2)(3)); // 6

// Arrow function version
const addCurriedArrow = a => b => c => a + b + c;
console.log(addCurriedArrow(1)(2)(3)); // 6

// Generic curry function
const curry = (fn) => {
  return function curried(...args) {
    if (args.length >= fn.length) {
      return fn.apply(this, args);
    }
    return function(...nextArgs) {
      return curried.apply(this, args.concat(nextArgs));
    };
  };
};

// Usage
const sum = (a, b, c) => a + b + c;
const curriedSum = curry(sum);

console.log(curriedSum(1)(2)(3));     // 6
console.log(curriedSum(1, 2)(3));     // 6
console.log(curriedSum(1)(2, 3));     // 6
console.log(curriedSum(1, 2, 3));     // 6
```

### Practical Currying Examples

```javascript
// Reusable functions
const multiply = curry((a, b) => a * b);
const double = multiply(2);
const triple = multiply(3);

console.log(double(5));  // 10
console.log(triple(5));  // 15

// Array filtering
const filter = curry((fn, array) => array.filter(fn));
const map = curry((fn, array) => array.map(fn));

const numbers = [1, 2, 3, 4, 5, 6];

const isEven = n => n % 2 === 0;
const square = n => n * n;

const filterEven = filter(isEven);
const mapSquare = map(square);

console.log(filterEven(numbers));              // [2, 4, 6]
console.log(mapSquare(numbers));               // [1, 4, 9, 16, 25, 36]
console.log(mapSquare(filterEven(numbers)));   // [4, 16, 36]

// String operations
const replace = curry((pattern, replacement, str) =>
  str.replace(pattern, replacement)
);

const replaceSpaces = replace(/\s+/g);
const replaceWithDash = replaceSpaces('-');
const replaceWithUnderscore = replaceSpaces('_');

console.log(replaceWithDash('hello world'));        // "hello-world"
console.log(replaceWithUnderscore('hello world'));  // "hello_world"

// HTTP requests
const request = curry((method, url, data) => {
  return fetch(url, {
    method,
    body: JSON.stringify(data),
    headers: { 'Content-Type': 'application/json' }
  });
});

const get = request('GET');
const post = request('POST');

const getUser = get('/api/users');
const createUser = post('/api/users');
```

### Partial Application

Pre-filling some arguments of a function.

```javascript
// Partial application
function partial(fn, ...presetArgs) {
  return function(...laterArgs) {
    return fn(...presetArgs, ...laterArgs);
  };
}

// Usage
function greet(greeting, name) {
  return `${greeting}, ${name}!`;
}

const sayHello = partial(greet, 'Hello');
const sayHi = partial(greet, 'Hi');

console.log(sayHello('John'));  // "Hello, John!"
console.log(sayHi('Jane'));     // "Hi, Jane!"

// More examples
function multiply(a, b, c) {
  return a * b * c;
}

const multiplyBy2 = partial(multiply, 2);
const multiplyBy2And3 = partial(multiply, 2, 3);

console.log(multiplyBy2(3, 4));      // 24
console.log(multiplyBy2And3(5));     // 30

// Real-world example: Event handlers
function handleClick(action, element, event) {
  console.log(`${action} on ${element}`);
  event.preventDefault();
}

const handleSubmit = partial(handleClick, 'submit', 'form');
const handleDelete = partial(handleClick, 'delete', 'button');

// document.querySelector('form').addEventListener('click', handleSubmit);
// document.querySelector('button').addEventListener('click', handleDelete);
```

---

## Higher-Order Functions

Functions that take other functions as arguments or return functions.

### Built-in Higher-Order Functions

```javascript
// map
const numbers = [1, 2, 3, 4, 5];
const doubled = numbers.map(n => n * 2);
console.log(doubled); // [2, 4, 6, 8, 10]

// filter
const evens = numbers.filter(n => n % 2 === 0);
console.log(evens); // [2, 4]

// reduce
const sum = numbers.reduce((acc, n) => acc + n, 0);
console.log(sum); // 15

// forEach
numbers.forEach(n => console.log(n));

// some & every
const hasEven = numbers.some(n => n % 2 === 0);
const allPositive = numbers.every(n => n > 0);

// find & findIndex
const firstEven = numbers.find(n => n % 2 === 0);
const firstEvenIndex = numbers.findIndex(n => n % 2 === 0);
```

### Creating Higher-Order Functions

```javascript
// Function that returns a function
function multiplier(factor) {
  return function(number) {
    return number * factor;
  };
}

const double = multiplier(2);
const triple = multiplier(3);

console.log(double(5));  // 10
console.log(triple(5));  // 15

// Function that takes a function as argument
function repeat(n, action) {
  for (let i = 0; i < n; i++) {
    action(i);
  }
}

repeat(3, i => console.log(`Iteration ${i}`));
// Iteration 0
// Iteration 1
// Iteration 2

// Both patterns combined
function unless(test, then) {
  if (!test) then();
}

function loop(n, action) {
  for (let i = 0; i < n; i++) {
    unless(i % 2 === 0, () => action(i));
  }
}

loop(5, i => console.log(i)); // 1, 3
```

### Practical Examples

```javascript
// once - execute function only once
function once(fn) {
  let called = false;
  let result;
  
  return function(...args) {
    if (!called) {
      called = true;
      result = fn(...args);
    }
    return result;
  };
}

const initialize = once(() => {
  console.log('Initializing...');
  return 'Initialized';
});

console.log(initialize()); // "Initializing..." then "Initialized"
console.log(initialize()); // "Initialized" (doesn't log again)

// debounce - delay execution until after a pause
function debounce(fn, delay) {
  let timeoutId;
  
  return function(...args) {
    clearTimeout(timeoutId);
    timeoutId = setTimeout(() => fn(...args), delay);
  };
}

const searchAPI = debounce((query) => {
  console.log(`Searching for: ${query}`);
}, 500);

// Only the last call will execute after 500ms
searchAPI('a');
searchAPI('ab');
searchAPI('abc'); // Only this one executes

// throttle - limit execution rate
function throttle(fn, limit) {
  let inThrottle;
  
  return function(...args) {
    if (!inThrottle) {
      fn(...args);
      inThrottle = true;
      setTimeout(() => inThrottle = false, limit);
    }
  };
}

const logScroll = throttle(() => {
  console.log('Scrolled!');
}, 1000);

// window.addEventListener('scroll', logScroll);

// pipe for async functions
const asyncPipe = (...fns) => input =>
  fns.reduce((chain, fn) => chain.then(fn), Promise.resolve(input));

const fetchData = url => fetch(url).then(r => r.json());
const transformData = data => ({ ...data, transformed: true });
const saveData = data => {
  console.log('Saving:', data);
  return data;
};

const processData = asyncPipe(
  fetchData,
  transformData,
  saveData
);
```

---

## Functors and Monads

Advanced functional programming concepts for handling values in containers.

### Functors

A functor is a container that can be mapped over.

```javascript
// Array is a functor
const numbers = [1, 2, 3];
const doubled = numbers.map(x => x * 2);

// Custom functor
class Box {
  constructor(value) {
    this.value = value;
  }
  
  map(fn) {
    return new Box(fn(this.value));
  }
  
  fold(fn) {
    return fn(this.value);
  }
  
  inspect() {
    return `Box(${this.value})`;
  }
}

// Usage
const result = new Box(2)
  .map(x => x * 2)
  .map(x => x + 3)
  .fold(x => x);

console.log(result); // 7

// Practical example: Maybe functor
class Maybe {
  constructor(value) {
    this.value = value;
  }
  
  static of(value) {
    return new Maybe(value);
  }
  
  isNothing() {
    return this.value === null || this.value === undefined;
  }
  
  map(fn) {
    return this.isNothing() ? this : Maybe.of(fn(this.value));
  }
  
  fold(defaultValue, fn) {
    return this.isNothing() ? defaultValue : fn(this.value);
  }
}

// Safe property access
const getStreetName = user =>
  Maybe.of(user)
    .map(u => u.address)
    .map(a => a.street)
    .map(s => s.name)
    .fold('Unknown', name => name);

const user1 = {
  address: {
    street: {
      name: 'Main St'
    }
  }
};

const user2 = { address: null };

console.log(getStreetName(user1)); // "Main St"
console.log(getStreetName(user2)); // "Unknown"
```

### Either Functor

For handling errors functionally.

```javascript
class Either {
  constructor(value) {
    this.value = value;
  }
  
  static left(value) {
    return new Left(value);
  }
  
  static right(value) {
    return new Right(value);
  }
  
  static fromNullable(value) {
    return value !== null && value !== undefined
      ? Either.right(value)
      : Either.left(null);
  }
}

class Left extends Either {
  map(fn) {
    return this; // Ignore mapping on left (error case)
  }
  
  fold(leftFn, rightFn) {
    return leftFn(this.value);
  }
}

class Right extends Either {
  map(fn) {
    return Either.right(fn(this.value));
  }
  
  fold(leftFn, rightFn) {
    return rightFn(this.value);
  }
}

// Usage
const parseJSON = str => {
  try {
    return Either.right(JSON.parse(str));
  } catch (e) {
    return Either.left(e.message);
  }
};

const result1 = parseJSON('{"name": "John"}')
  .map(obj => obj.name)
  .map(name => name.toUpperCase())
  .fold(
    error => `Error: ${error}`,
    value => `Success: ${value}`
  );

console.log(result1); // "Success: JOHN"

const result2 = parseJSON('invalid json')
  .map(obj => obj.name)
  .fold(
    error => `Error: ${error}`,
    value => `Success: ${value}`
  );

console.log(result2); // "Error: Unexpected token i in JSON..."
```

### Task Monad

For handling asynchronous operations.

```javascript
class Task {
  constructor(fork) {
    this.fork = fork;
  }
  
  static of(value) {
    return new Task((reject, resolve) => resolve(value));
  }
  
  map(fn) {
    return new Task((reject, resolve) =>
      this.fork(reject, value => resolve(fn(value)))
    );
  }
  
  chain(fn) {
    return new Task((reject, resolve) =>
      this.fork(reject, value => fn(value).fork(reject, resolve))
    );
  }
}

// Usage
const fetchUser = id =>
  new Task((reject, resolve) => {
    setTimeout(() => {
      resolve({ id, name: 'John' });
    }, 1000);
  });

const fetchPosts = userId =>
  new Task((reject, resolve) => {
    setTimeout(() => {
      resolve([{ userId, title: 'Post 1' }]);
    }, 1000);
  });

// Compose tasks
const getUserWithPosts = id =>
  fetchUser(id)
    .chain(user =>
      fetchPosts(user.id)
        .map(posts => ({ ...user, posts }))
    );

getUserWithPosts(1).fork(
  error => console.error(error),
  result => console.log(result)
);
```

---

## Practical Functional Programming

### Real-World Examples

```javascript
// 1. Data transformation pipeline
const processUserData = pipe(
  users => users.filter(u => u.active),
  users => users.map(u => ({
    id: u.id,
    name: u.name.toUpperCase(),
    email: u.email.toLowerCase()
  })),
  users => users.sort((a, b) => a.name.localeCompare(b.name))
);

// 2. Form validation
const validators = {
  required: value => value ? Either.right(value) : Either.left('Required'),
  minLength: min => value =>
    value.length >= min
      ? Either.right(value)
      : Either.left(`Min length: ${min}`),
  email: value =>
    /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value)
      ? Either.right(value)
      : Either.left('Invalid email')
};

const validateEmail = email =>
  Either.fromNullable(email)
    .chain(validators.required)
    .chain(validators.minLength(5))
    .chain(validators.email);

// 3. API call composition
const apiCall = curry((method, url, data) =>
  Task.of(data)
    .chain(d => fetchAPI(method, url, d))
    .map(parseJSON)
    .chain(handleErrors)
);

const getUser = apiCall('GET');
const updateUser = apiCall('PUT');

// 4. State management
const createStore = (reducer, initialState) => {
  let state = initialState;
  const listeners = [];
  
  return {
    getState: () => state,
    dispatch: action => {
      state = reducer(state, action);
      listeners.forEach(listener => listener(state));
    },
    subscribe: listener => {
      listeners.push(listener);
      return () => {
        const index = listeners.indexOf(listener);
        listeners.splice(index, 1);
      };
    }
  };
};
```

---

## Best Practices

### Do's and Don'ts

```javascript
// ✅ Do: Use pure functions
const add = (a, b) => a + b;

// ❌ Don't: Mutate data
// const addToArray = (arr, item) => arr.push(item);

// ✅ Do: Return new data
const addToArray = (arr, item) => [...arr, item];

// ✅ Do: Compose small functions
const transform = pipe(trim, toLowerCase, capitalize);

// ❌ Don't: Create large monolithic functions
// const transform = str => {
//   let result = str.trim();
//   result = result.toLowerCase();
//   result = result.charAt(0).toUpperCase() + result.slice(1);
//   return result;
// };

// ✅ Do: Use declarative code
const evens = numbers.filter(n => n % 2 === 0);

// ❌ Don't: Use imperative code unnecessarily
// const evens = [];
// for (let i = 0; i < numbers.length; i++) {
//   if (numbers[i] % 2 === 0) evens.push(numbers[i]);
// }
```

---

## Summary

Functional programming in JavaScript offers:

1. **More predictable code** through pure functions
2. **Easier testing** with isolated functions
3. **Better reusability** through composition
4. **Fewer bugs** with immutability
5. **Cleaner code** with declarative style

## Next Steps

- [Higher-Order Functions](18_HIGHER_ORDER_FUNCTIONS.md)
- [Array Methods](19_ARRAY_METHODS.md)
- [ES6+ Features](23_ES6_FEATURES.md)
- Practice refactoring imperative code to functional style
