# Array Methods

## Table of Contents
1. [Introduction](#introduction)
2. [Adding and Removing Elements](#adding-and-removing-elements)
3. [Transforming Arrays](#transforming-arrays)
4. [Searching and Finding](#searching-and-finding)
5. [Testing Arrays](#testing-arrays)
6. [Sorting and Reversing](#sorting-and-reversing)
7. [Iteration Methods](#iteration-methods)
8. [Combining Arrays](#combining-arrays)
9. [Advanced Methods](#advanced-methods)
10. [Method Chaining](#method-chaining)
11. [Performance Considerations](#performance-considerations)

## Introduction

JavaScript arrays come with a rich set of built-in methods that make working with collections of data easier and more expressive. These methods can be categorized based on their purpose: mutation, transformation, searching, and more.

### Mutating vs Non-Mutating Methods

```javascript
// Mutating methods (modify the original array)
const arr1 = [1, 2, 3];
arr1.push(4); // arr1 is now [1, 2, 3, 4]

// Non-mutating methods (return a new array)
const arr2 = [1, 2, 3];
const arr3 = arr2.concat(4); // arr2 is still [1, 2, 3], arr3 is [1, 2, 3, 4]
```

## Adding and Removing Elements

### push() - Add to End (Mutating)

```javascript
const fruits = ['apple', 'banana'];
const newLength = fruits.push('orange', 'mango');

console.log(fruits);     // ['apple', 'banana', 'orange', 'mango']
console.log(newLength);  // 4
```

### pop() - Remove from End (Mutating)

```javascript
const fruits = ['apple', 'banana', 'orange'];
const removed = fruits.pop();

console.log(removed);  // 'orange'
console.log(fruits);   // ['apple', 'banana']
```

### unshift() - Add to Beginning (Mutating)

```javascript
const fruits = ['banana', 'orange'];
const newLength = fruits.unshift('apple', 'mango');

console.log(fruits);     // ['apple', 'mango', 'banana', 'orange']
console.log(newLength);  // 4
```

### shift() - Remove from Beginning (Mutating)

```javascript
const fruits = ['apple', 'banana', 'orange'];
const removed = fruits.shift();

console.log(removed);  // 'apple'
console.log(fruits);   // ['banana', 'orange']
```

### splice() - Add/Remove at Any Position (Mutating)

```javascript
const fruits = ['apple', 'banana', 'orange', 'mango'];

// Remove elements
const removed = fruits.splice(1, 2); // Start at index 1, remove 2 items
console.log(removed);  // ['banana', 'orange']
console.log(fruits);   // ['apple', 'mango']

// Add elements
fruits.splice(1, 0, 'kiwi', 'grape'); // Start at index 1, remove 0, add items
console.log(fruits);   // ['apple', 'kiwi', 'grape', 'mango']

// Replace elements
fruits.splice(1, 2, 'pear'); // Start at index 1, remove 2, add 1
console.log(fruits);   // ['apple', 'pear', 'mango']
```

## Transforming Arrays

### map() - Transform Each Element

```javascript
const numbers = [1, 2, 3, 4, 5];

// Square each number
const squared = numbers.map(num => num ** 2);
console.log(squared);  // [1, 4, 9, 16, 25]

// With index
const withIndex = numbers.map((num, index) => `${index}: ${num}`);
console.log(withIndex);  // ['0: 1', '1: 2', '2: 3', '3: 4', '4: 5']

// Transform objects
const users = [
    { firstName: 'John', lastName: 'Doe' },
    { firstName: 'Jane', lastName: 'Smith' }
];

const fullNames = users.map(user => `${user.firstName} ${user.lastName}`);
console.log(fullNames);  // ['John Doe', 'Jane Smith']
```

### filter() - Select Elements Based on Condition

```javascript
const numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

// Get even numbers
const evens = numbers.filter(num => num % 2 === 0);
console.log(evens);  // [2, 4, 6, 8, 10]

// Filter objects
const users = [
    { name: 'Alice', age: 25, active: true },
    { name: 'Bob', age: 30, active: false },
    { name: 'Charlie', age: 35, active: true }
];

const activeUsers = users.filter(user => user.active);
const adults = users.filter(user => user.age >= 30);

console.log(activeUsers);  // Alice and Charlie
console.log(adults);       // Bob and Charlie
```

### reduce() - Reduce to Single Value

```javascript
const numbers = [1, 2, 3, 4, 5];

// Sum
const sum = numbers.reduce((acc, num) => acc + num, 0);
console.log(sum);  // 15

// Product
const product = numbers.reduce((acc, num) => acc * num, 1);
console.log(product);  // 120

// Max value
const max = numbers.reduce((acc, num) => Math.max(acc, num));
console.log(max);  // 5

// Group by property
const people = [
    { name: 'Alice', department: 'IT' },
    { name: 'Bob', department: 'HR' },
    { name: 'Charlie', department: 'IT' },
    { name: 'David', department: 'Finance' }
];

const byDepartment = people.reduce((acc, person) => {
    const dept = person.department;
    if (!acc[dept]) acc[dept] = [];
    acc[dept].push(person);
    return acc;
}, {});

console.log(byDepartment);
// {
//   IT: [{ name: 'Alice', ... }, { name: 'Charlie', ... }],
//   HR: [{ name: 'Bob', ... }],
//   Finance: [{ name: 'David', ... }]
// }

// Count occurrences
const fruits = ['apple', 'banana', 'apple', 'orange', 'banana', 'apple'];
const count = fruits.reduce((acc, fruit) => {
    acc[fruit] = (acc[fruit] || 0) + 1;
    return acc;
}, {});

console.log(count);  // { apple: 3, banana: 2, orange: 1 }
```

### reduceRight() - Reduce from Right to Left

```javascript
const numbers = [1, 2, 3, 4, 5];

const result = numbers.reduceRight((acc, num) => acc - num);
console.log(result);  // -5 (5 - 4 - 3 - 2 - 1 = -5)

// Useful for right-associative operations
const operations = ['(', '1', '+', '2', ')', '*', '3'];
const expression = operations.reduceRight((acc, op) => op + acc, '');
console.log(expression);  // "3*)2+1("
```

### flat() - Flatten Nested Arrays

```javascript
// Flatten one level
const arr1 = [1, 2, [3, 4]];
console.log(arr1.flat());  // [1, 2, 3, 4]

// Flatten multiple levels
const arr2 = [1, 2, [3, 4, [5, 6]]];
console.log(arr2.flat());    // [1, 2, 3, 4, [5, 6]] (default depth: 1)
console.log(arr2.flat(2));   // [1, 2, 3, 4, 5, 6]
console.log(arr2.flat(Infinity));  // Flatten all levels

// Remove empty slots
const arr3 = [1, 2, , 4, 5];
console.log(arr3.flat());  // [1, 2, 4, 5]
```

### flatMap() - Map and Flatten

```javascript
const sentences = ['Hello world', 'How are you'];

// Using map + flat
const words1 = sentences.map(s => s.split(' ')).flat();
console.log(words1);  // ['Hello', 'world', 'How', 'are', 'you']

// Using flatMap (more efficient)
const words2 = sentences.flatMap(s => s.split(' '));
console.log(words2);  // ['Hello', 'world', 'How', 'are', 'you']

// Practical example: Get all tags from multiple posts
const posts = [
    { title: 'Post 1', tags: ['javascript', 'web'] },
    { title: 'Post 2', tags: ['python', 'data'] },
    { title: 'Post 3', tags: ['javascript', 'react'] }
];

const allTags = posts.flatMap(post => post.tags);
console.log(allTags);  // ['javascript', 'web', 'python', 'data', 'javascript', 'react']
```

## Searching and Finding

### indexOf() - Find Index of Element

```javascript
const fruits = ['apple', 'banana', 'orange', 'banana'];

console.log(fruits.indexOf('banana'));      // 1 (first occurrence)
console.log(fruits.indexOf('grape'));       // -1 (not found)
console.log(fruits.indexOf('banana', 2));   // 3 (search from index 2)
```

### lastIndexOf() - Find Last Index

```javascript
const fruits = ['apple', 'banana', 'orange', 'banana'];

console.log(fruits.lastIndexOf('banana'));  // 3 (last occurrence)
```

### includes() - Check if Element Exists

```javascript
const fruits = ['apple', 'banana', 'orange'];

console.log(fruits.includes('banana'));     // true
console.log(fruits.includes('grape'));      // false
console.log(fruits.includes('apple', 1));   // false (search from index 1)
```

### find() - Find First Matching Element

```javascript
const numbers = [1, 2, 3, 4, 5];

const firstEven = numbers.find(num => num % 2 === 0);
console.log(firstEven);  // 2

// Find object
const users = [
    { id: 1, name: 'Alice' },
    { id: 2, name: 'Bob' },
    { id: 3, name: 'Charlie' }
];

const user = users.find(u => u.id === 2);
console.log(user);  // { id: 2, name: 'Bob' }

// Returns undefined if not found
const notFound = users.find(u => u.id === 99);
console.log(notFound);  // undefined
```

### findIndex() - Find Index of First Match

```javascript
const numbers = [1, 2, 3, 4, 5];

const index = numbers.findIndex(num => num > 3);
console.log(index);  // 3 (index of 4)

// Returns -1 if not found
const notFound = numbers.findIndex(num => num > 10);
console.log(notFound);  // -1
```

### findLast() and findLastIndex() (ES2023)

```javascript
const numbers = [1, 2, 3, 4, 5, 6];

// Find last even number
const lastEven = numbers.findLast(num => num % 2 === 0);
console.log(lastEven);  // 6

// Find index of last even number
const lastEvenIndex = numbers.findLastIndex(num => num % 2 === 0);
console.log(lastEvenIndex);  // 5
```

## Testing Arrays

### some() - Test if Any Element Matches

```javascript
const numbers = [1, 2, 3, 4, 5];

const hasEven = numbers.some(num => num % 2 === 0);
console.log(hasEven);  // true

const hasNegative = numbers.some(num => num < 0);
console.log(hasNegative);  // false

// Check if any user is admin
const users = [
    { name: 'Alice', role: 'user' },
    { name: 'Bob', role: 'admin' },
    { name: 'Charlie', role: 'user' }
];

const hasAdmin = users.some(user => user.role === 'admin');
console.log(hasAdmin);  // true
```

### every() - Test if All Elements Match

```javascript
const numbers = [2, 4, 6, 8];

const allEven = numbers.every(num => num % 2 === 0);
console.log(allEven);  // true

const allPositive = numbers.every(num => num > 0);
console.log(allPositive);  // true

const allGreaterThan5 = numbers.every(num => num > 5);
console.log(allGreaterThan5);  // false

// Validate form data
const formData = [
    { field: 'username', value: 'john' },
    { field: 'email', value: 'john@example.com' },
    { field: 'password', value: 'secret123' }
];

const allFieldsFilled = formData.every(field => field.value.length > 0);
console.log(allFieldsFilled);  // true
```

## Sorting and Reversing

### sort() - Sort Array (Mutating)

```javascript
// Default sort (alphabetical)
const fruits = ['banana', 'apple', 'orange', 'mango'];
fruits.sort();
console.log(fruits);  // ['apple', 'banana', 'mango', 'orange']

// Number sort (requires compare function)
const numbers = [10, 5, 40, 25, 1000, 1];

// ❌ Wrong way (treats as strings)
numbers.sort();
console.log(numbers);  // [1, 10, 1000, 25, 40, 5]

// ✅ Correct way
numbers.sort((a, b) => a - b);  // Ascending
console.log(numbers);  // [1, 5, 10, 25, 40, 1000]

numbers.sort((a, b) => b - a);  // Descending
console.log(numbers);  // [1000, 40, 25, 10, 5, 1]

// Sort objects
const users = [
    { name: 'Charlie', age: 35 },
    { name: 'Alice', age: 25 },
    { name: 'Bob', age: 30 }
];

// Sort by age
users.sort((a, b) => a.age - b.age);
console.log(users);  // Alice (25), Bob (30), Charlie (35)

// Sort by name
users.sort((a, b) => a.name.localeCompare(b.name));
console.log(users);  // Alice, Bob, Charlie
```

### reverse() - Reverse Array (Mutating)

```javascript
const numbers = [1, 2, 3, 4, 5];
numbers.reverse();
console.log(numbers);  // [5, 4, 3, 2, 1]

// Non-mutating reverse
const original = [1, 2, 3, 4, 5];
const reversed = [...original].reverse();
console.log(original);  // [1, 2, 3, 4, 5]
console.log(reversed);  // [5, 4, 3, 2, 1]
```

### toSorted() and toReversed() (ES2023) - Non-Mutating

```javascript
const numbers = [3, 1, 4, 1, 5, 9, 2, 6];

// toSorted() - returns new sorted array
const sorted = numbers.toSorted((a, b) => a - b);
console.log(numbers);  // [3, 1, 4, 1, 5, 9, 2, 6] (unchanged)
console.log(sorted);   // [1, 1, 2, 3, 4, 5, 6, 9]

// toReversed() - returns new reversed array
const reversed = numbers.toReversed();
console.log(numbers);   // [3, 1, 4, 1, 5, 9, 2, 6] (unchanged)
console.log(reversed);  // [6, 2, 9, 5, 1, 4, 1, 3]
```

## Iteration Methods

### forEach() - Execute Function for Each Element

```javascript
const fruits = ['apple', 'banana', 'orange'];

fruits.forEach((fruit, index) => {
    console.log(`${index + 1}. ${fruit}`);
});
// 1. apple
// 2. banana
// 3. orange

// Note: forEach doesn't return a value and cannot be broken
const numbers = [1, 2, 3, 4, 5];
numbers.forEach(num => {
    if (num === 3) return; // Only skips current iteration
    console.log(num);
});
// 1, 2, 4, 5
```

### entries() - Get [index, value] Iterator

```javascript
const fruits = ['apple', 'banana', 'orange'];

for (const [index, fruit] of fruits.entries()) {
    console.log(`${index}: ${fruit}`);
}
// 0: apple
// 1: banana
// 2: orange

// Convert to array
const entries = Array.from(fruits.entries());
console.log(entries);  // [[0, 'apple'], [1, 'banana'], [2, 'orange']]
```

### keys() - Get Index Iterator

```javascript
const fruits = ['apple', 'banana', 'orange'];

for (const index of fruits.keys()) {
    console.log(index);
}
// 0, 1, 2

const keys = [...fruits.keys()];
console.log(keys);  // [0, 1, 2]
```

### values() - Get Value Iterator

```javascript
const fruits = ['apple', 'banana', 'orange'];

for (const fruit of fruits.values()) {
    console.log(fruit);
}
// apple, banana, orange

// Note: same as iterating the array directly
for (const fruit of fruits) {
    console.log(fruit);
}
```

## Combining Arrays

### concat() - Merge Arrays

```javascript
const arr1 = [1, 2, 3];
const arr2 = [4, 5, 6];
const arr3 = [7, 8, 9];

const merged = arr1.concat(arr2, arr3);
console.log(merged);  // [1, 2, 3, 4, 5, 6, 7, 8, 9]

// Using spread operator (modern approach)
const merged2 = [...arr1, ...arr2, ...arr3];
console.log(merged2);  // [1, 2, 3, 4, 5, 6, 7, 8, 9]
```

### join() - Convert to String

```javascript
const fruits = ['apple', 'banana', 'orange'];

console.log(fruits.join());        // 'apple,banana,orange' (default separator)
console.log(fruits.join(', '));    // 'apple, banana, orange'
console.log(fruits.join(' - '));   // 'apple - banana - orange'
console.log(fruits.join(''));      // 'applebananaorange'

// Create sentence
const words = ['Hello', 'world', 'from', 'JavaScript'];
console.log(words.join(' '));  // 'Hello world from JavaScript'
```

### slice() - Extract Portion of Array

```javascript
const fruits = ['apple', 'banana', 'orange', 'mango', 'grape'];

console.log(fruits.slice(1, 3));   // ['banana', 'orange'] (from index 1 to 3)
console.log(fruits.slice(2));      // ['orange', 'mango', 'grape'] (from index 2 to end)
console.log(fruits.slice(-2));     // ['mango', 'grape'] (last 2 items)
console.log(fruits.slice());       // Copy entire array

// Original array unchanged
console.log(fruits);  // ['apple', 'banana', 'orange', 'mango', 'grape']
```

## Advanced Methods

### fill() - Fill with Static Value (Mutating)

```javascript
const arr1 = [1, 2, 3, 4, 5];
arr1.fill(0);
console.log(arr1);  // [0, 0, 0, 0, 0]

// Fill portion of array
const arr2 = [1, 2, 3, 4, 5];
arr2.fill(0, 2, 4);  // Fill from index 2 to 4
console.log(arr2);  // [1, 2, 0, 0, 5]

// Create array with default values
const zeros = new Array(5).fill(0);
console.log(zeros);  // [0, 0, 0, 0, 0]
```

### copyWithin() - Copy Part of Array (Mutating)

```javascript
const arr = [1, 2, 3, 4, 5];

// Copy from index 0 to index 3
arr.copyWithin(3, 0);
console.log(arr);  // [1, 2, 3, 1, 2]

// Copy from index 1 to 3, paste at index 0
const arr2 = [1, 2, 3, 4, 5];
arr2.copyWithin(0, 1, 3);
console.log(arr2);  // [2, 3, 3, 4, 5]
```

### at() - Get Element at Index (Supports Negative)

```javascript
const fruits = ['apple', 'banana', 'orange'];

console.log(fruits.at(0));   // 'apple'
console.log(fruits.at(-1));  // 'orange' (last item)
console.log(fruits.at(-2));  // 'banana' (second to last)

// Compare with bracket notation
console.log(fruits[fruits.length - 1]);  // 'orange' (old way)
console.log(fruits.at(-1));              // 'orange' (new way)
```

### with() (ES2023) - Replace Element Non-Mutating

```javascript
const fruits = ['apple', 'banana', 'orange'];

const newFruits = fruits.with(1, 'mango');
console.log(fruits);     // ['apple', 'banana', 'orange'] (unchanged)
console.log(newFruits);  // ['apple', 'mango', 'orange']

// Works with negative indices
const updated = fruits.with(-1, 'grape');
console.log(updated);  // ['apple', 'banana', 'grape']
```

### Array.from() - Create Array from Iterable

```javascript
// From string
const str = 'hello';
const chars = Array.from(str);
console.log(chars);  // ['h', 'e', 'l', 'l', 'o']

// From Set
const set = new Set([1, 2, 3, 3, 4]);
const arr = Array.from(set);
console.log(arr);  // [1, 2, 3, 4]

// With mapping function
const numbers = Array.from({ length: 5 }, (_, i) => i + 1);
console.log(numbers);  // [1, 2, 3, 4, 5]

// Create range
const range = Array.from({ length: 10 }, (_, i) => i * 2);
console.log(range);  // [0, 2, 4, 6, 8, 10, 12, 14, 16, 18]
```

### Array.of() - Create Array from Arguments

```javascript
// Compare with Array constructor
console.log(new Array(3));      // [empty × 3]
console.log(Array.of(3));       // [3]

console.log(new Array(1, 2, 3));   // [1, 2, 3]
console.log(Array.of(1, 2, 3));    // [1, 2, 3]
```

## Method Chaining

```javascript
const users = [
    { name: 'Alice', age: 25, active: true, score: 85 },
    { name: 'Bob', age: 30, active: false, score: 92 },
    { name: 'Charlie', age: 35, active: true, score: 78 },
    { name: 'David', age: 28, active: true, score: 95 },
    { name: 'Eve', age: 32, active: false, score: 88 }
];

// Complex transformation with chaining
const result = users
    .filter(user => user.active)                    // Get active users
    .filter(user => user.score >= 80)               // With score >= 80
    .map(user => ({                                 // Transform to new format
        name: user.name.toUpperCase(),
        score: user.score
    }))
    .sort((a, b) => b.score - a.score)              // Sort by score descending
    .map(user => `${user.name}: ${user.score}`)     // Format as strings
    .join(', ');                                    // Join into sentence

console.log(result);  // "DAVID: 95, ALICE: 85"

// Calculate statistics
const stats = users
    .filter(user => user.active)
    .map(user => user.score)
    .reduce((acc, score) => ({
        total: acc.total + score,
        count: acc.count + 1,
        min: Math.min(acc.min, score),
        max: Math.max(acc.max, score)
    }), { total: 0, count: 0, min: Infinity, max: -Infinity });

stats.average = stats.total / stats.count;
console.log(stats);
// { total: 258, count: 3, min: 78, max: 95, average: 86 }
```

## Performance Considerations

### 1. Choose the Right Method

```javascript
// ❌ Inefficient: Using filter + map when you can use reduce
const sum = numbers.filter(n => n > 0).map(n => n * 2).reduce((a, b) => a + b, 0);

// ✅ More efficient: Single pass with reduce
const sum = numbers.reduce((acc, n) => n > 0 ? acc + n * 2 : acc, 0);
```

### 2. Avoid Unnecessary Iterations

```javascript
// ❌ Multiple passes
const result = arr
    .map(transform1)
    .map(transform2)
    .map(transform3);

// ✅ Single pass
const result = arr.map(item => transform3(transform2(transform1(item))));
```

### 3. Use Early Termination

```javascript
// ✅ Use find() instead of filter()[0]
const user = users.find(u => u.id === targetId);  // Stops at first match

// ❌ Less efficient
const user = users.filter(u => u.id === targetId)[0];  // Checks all elements
```

### 4. Use some() or every() for Boolean Checks

```javascript
// ✅ Use some() - stops at first truthy value
const hasAdmin = users.some(u => u.role === 'admin');

// ❌ Less efficient
const hasAdmin = users.filter(u => u.role === 'admin').length > 0;
```

### 5. Consider Set for Lookups

```javascript
const numbers = [1, 2, 3, 4, 5, /* ... thousands more */];

// ❌ O(n) lookup with includes()
if (numbers.includes(target)) { }

// ✅ O(1) lookup with Set
const numberSet = new Set(numbers);
if (numberSet.has(target)) { }
```

## Summary

JavaScript array methods provide powerful ways to manipulate data:

**Mutating Methods**: `push`, `pop`, `shift`, `unshift`, `splice`, `sort`, `reverse`, `fill`, `copyWithin`

**Non-Mutating Methods**: `map`, `filter`, `reduce`, `concat`, `slice`, `flat`, `flatMap`

**Search Methods**: `indexOf`, `lastIndexOf`, `includes`, `find`, `findIndex`

**Test Methods**: `some`, `every`

**Modern Methods** (ES2023): `toSorted`, `toReversed`, `with`, `findLast`, `findLastIndex`

Key principles:
- Use method chaining for complex transformations
- Choose the right method for the job
- Consider performance implications
- Prefer immutable operations when possible

---

**Next Topic**: [Destructuring and Spread](20_DESTRUCTURING_SPREAD.md)
