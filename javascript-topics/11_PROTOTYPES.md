# Prototypes and Inheritance

## What is a Prototype?

In JavaScript, every object has an internal link to another object called its **prototype**. This prototype object has its own prototype, forming a **prototype chain** that ends with `null`.

Prototypes enable inheritance in JavaScript, allowing objects to share properties and methods.

### Key Concepts

```javascript
// Every function has a prototype property
function Person(name) {
    this.name = name;
}

console.log(Person.prototype);  // Person { constructor: Person }

// Every object has an internal [[Prototype]] link
const person = new Person("John");
console.log(Object.getPrototypeOf(person) === Person.prototype);  // true
```

## The Prototype Chain

When you access a property on an object, JavaScript looks for it in this order:

1. **Own properties** of the object
2. **Prototype** of the object
3. **Prototype's prototype** (and so on)
4. Until it reaches `null`

```javascript
function Animal(name) {
    this.name = name;
}

Animal.prototype.speak = function() {
    return `${this.name} makes a sound`;
};

const dog = new Animal("Buddy");

// Property lookup chain
console.log(dog.name);           // "Buddy" - found on object
console.log(dog.speak());        // "Buddy makes a sound" - found on prototype
console.log(dog.toString());     // "[object Object]" - found on Object.prototype
console.log(dog.nonExistent);    // undefined - not found anywhere
```

## Constructor Functions and Prototypes

### Basic Constructor Pattern

```javascript
function Person(name, age) {
    // Instance properties
    this.name = name;
    this.age = age;
}

// Shared methods on prototype
Person.prototype.greet = function() {
    return `Hello, my name is ${this.name}`;
};

Person.prototype.getAge = function() {
    return this.age;
};

// Creating instances
const john = new Person("John", 30);
const jane = new Person("Jane", 25);

console.log(john.greet());       // "Hello, my name is John"
console.log(jane.greet());       // "Hello, my name is Jane"

// Both instances share the same prototype method
console.log(john.greet === jane.greet);  // true
```

### Why Use Prototypes?

```javascript
// ❌ BAD: Methods in constructor (memory inefficient)
function PersonBad(name) {
    this.name = name;
    this.greet = function() {
        return `Hello, ${this.name}`;
    };
}

// Each instance gets its own copy of the method
const p1 = new PersonBad("John");
const p2 = new PersonBad("Jane");
console.log(p1.greet === p2.greet);  // false - different functions!

// ✅ GOOD: Methods on prototype (memory efficient)
function PersonGood(name) {
    this.name = name;
}

PersonGood.prototype.greet = function() {
    return `Hello, ${this.name}`;
};

// All instances share the same method
const p3 = new PersonGood("John");
const p4 = new PersonGood("Jane");
console.log(p3.greet === p4.greet);  // true - same function!
```

## Prototype Inheritance

### Classical Inheritance Pattern

```javascript
// Parent constructor
function Animal(name) {
    this.name = name;
}

Animal.prototype.eat = function() {
    return `${this.name} is eating`;
};

Animal.prototype.sleep = function() {
    return `${this.name} is sleeping`;
};

// Child constructor
function Dog(name, breed) {
    // Call parent constructor
    Animal.call(this, name);
    this.breed = breed;
}

// Set up inheritance
Dog.prototype = Object.create(Animal.prototype);
Dog.prototype.constructor = Dog;

// Add child-specific methods
Dog.prototype.bark = function() {
    return `${this.name} says Woof!`;
};

// Override parent method
Dog.prototype.eat = function() {
    return `${this.name} is eating dog food`;
};

// Usage
const buddy = new Dog("Buddy", "Golden Retriever");

console.log(buddy.name);         // "Buddy"
console.log(buddy.breed);        // "Golden Retriever"
console.log(buddy.bark());       // "Buddy says Woof!"
console.log(buddy.eat());        // "Buddy is eating dog food"
console.log(buddy.sleep());      // "Buddy is sleeping" (inherited)

// Prototype chain
console.log(buddy instanceof Dog);     // true
console.log(buddy instanceof Animal);  // true
console.log(buddy instanceof Object);  // true
```

### Multiple Levels of Inheritance

```javascript
// Level 1: Animal
function Animal(name) {
    this.name = name;
    this.alive = true;
}

Animal.prototype.breathe = function() {
    return `${this.name} is breathing`;
};

// Level 2: Mammal
function Mammal(name, hasFur) {
    Animal.call(this, name);
    this.hasFur = hasFur;
}

Mammal.prototype = Object.create(Animal.prototype);
Mammal.prototype.constructor = Mammal;

Mammal.prototype.nurse = function() {
    return `${this.name} is nursing its young`;
};

// Level 3: Dog
function Dog(name, breed) {
    Mammal.call(this, name, true);
    this.breed = breed;
}

Dog.prototype = Object.create(Mammal.prototype);
Dog.prototype.constructor = Dog;

Dog.prototype.bark = function() {
    return `${this.name} barks!`;
};

// Usage
const max = new Dog("Max", "Labrador");

console.log(max.bark());      // "Max barks!"
console.log(max.nurse());     // "Max is nursing its young"
console.log(max.breathe());   // "Max is breathing"
console.log(max.hasFur);      // true
console.log(max.alive);       // true

// Complete prototype chain
console.log(max instanceof Dog);      // true
console.log(max instanceof Mammal);   // true
console.log(max instanceof Animal);   // true
console.log(max instanceof Object);   // true
```

## Working with Prototypes

### Checking Prototypes

```javascript
function Person(name) {
    this.name = name;
}

Person.prototype.greet = function() {
    return `Hello, ${this.name}`;
};

const john = new Person("John");

// Get prototype of an object
console.log(Object.getPrototypeOf(john) === Person.prototype);  // true

// Check if object is in prototype chain
console.log(Person.prototype.isPrototypeOf(john));  // true

// Check if property is own property or inherited
console.log(john.hasOwnProperty('name'));    // true
console.log(john.hasOwnProperty('greet'));   // false

// Get all own properties
console.log(Object.keys(john));              // ["name"]
console.log(Object.getOwnPropertyNames(john)); // ["name"]
```

### Modifying Prototypes

```javascript
function Car(make, model) {
    this.make = make;
    this.model = model;
}

Car.prototype.start = function() {
    return `${this.make} ${this.model} is starting`;
};

const car1 = new Car("Toyota", "Camry");
const car2 = new Car("Honda", "Civic");

console.log(car1.start());  // "Toyota Camry is starting"

// Add new method to prototype (affects all instances)
Car.prototype.stop = function() {
    return `${this.make} ${this.model} is stopping`;
};

console.log(car1.stop());  // "Toyota Camry is stopping"
console.log(car2.stop());  // "Honda Civic is stopping"

// Modify existing method
Car.prototype.start = function() {
    return `Vroom! ${this.make} ${this.model} started`;
};

console.log(car1.start());  // "Vroom! Toyota Camry started"
console.log(car2.start());  // "Vroom! Honda Civic started"
```

### Shadowing Properties

```javascript
function Person(name) {
    this.name = name;
}

Person.prototype.country = "USA";
Person.prototype.greet = function() {
    return `Hello from ${this.country}`;
};

const john = new Person("John");
const jane = new Person("Jane");

console.log(john.country);  // "USA" (from prototype)
console.log(jane.country);  // "USA" (from prototype)

// Shadow the prototype property
john.country = "Canada";

console.log(john.country);  // "Canada" (own property)
console.log(jane.country);  // "USA" (still from prototype)

// Delete own property to reveal prototype property
delete john.country;
console.log(john.country);  // "USA" (from prototype again)
```

## Object.create()

Create objects with a specific prototype without using constructor functions.

```javascript
// Create a prototype object
const personPrototype = {
    greet() {
        return `Hello, my name is ${this.name}`;
    },
    getAge() {
        return this.age;
    }
};

// Create objects with this prototype
const john = Object.create(personPrototype);
john.name = "John";
john.age = 30;

const jane = Object.create(personPrototype);
jane.name = "Jane";
jane.age = 25;

console.log(john.greet());  // "Hello, my name is John"
console.log(jane.greet());  // "Hello, my name is Jane"

console.log(Object.getPrototypeOf(john) === personPrototype);  // true
```

### Object.create() for Inheritance

```javascript
// Parent prototype
const animal = {
    init(name) {
        this.name = name;
        return this;
    },
    eat() {
        return `${this.name} is eating`;
    }
};

// Child prototype
const dog = Object.create(animal);
dog.bark = function() {
    return `${this.name} says Woof!`;
};

// Create instance
const buddy = Object.create(dog).init("Buddy");

console.log(buddy.bark());  // "Buddy says Woof!"
console.log(buddy.eat());   // "Buddy is eating"
```

## Modern Prototype Methods

### Object.setPrototypeOf()

```javascript
const animal = {
    speak() {
        return `${this.name} makes a sound`;
    }
};

const dog = {
    name: "Buddy"
};

// Set prototype (not recommended for performance)
Object.setPrototypeOf(dog, animal);

console.log(dog.speak());  // "Buddy makes a sound"
```

### Proto vs Prototype

```javascript
function Person(name) {
    this.name = name;
}

Person.prototype.greet = function() {
    return `Hello, ${this.name}`;
};

const john = new Person("John");

// __proto__ is the actual object (non-standard but widely supported)
console.log(john.__proto__ === Person.prototype);  // true

// Object.getPrototypeOf() is the standard way
console.log(Object.getPrototypeOf(john) === Person.prototype);  // true

// prototype is only on constructor functions
console.log(Person.prototype);           // { greet: [Function], constructor: Person }
console.log(john.prototype);             // undefined (instances don't have it)
```

## Common Patterns

### Factory Pattern with Prototypes

```javascript
const vehiclePrototype = {
    start() {
        return `${this.make} ${this.model} is starting`;
    },
    stop() {
        return `${this.make} ${this.model} is stopping`;
    }
};

function createVehicle(make, model, year) {
    const vehicle = Object.create(vehiclePrototype);
    vehicle.make = make;
    vehicle.model = model;
    vehicle.year = year;
    return vehicle;
}

const car = createVehicle("Toyota", "Camry", 2020);
const truck = createVehicle("Ford", "F-150", 2021);

console.log(car.start());    // "Toyota Camry is starting"
console.log(truck.stop());   // "Ford F-150 is stopping"
```

### Mixin Pattern

```javascript
// Mixin objects
const canEat = {
    eat() {
        return `${this.name} is eating`;
    }
};

const canWalk = {
    walk() {
        return `${this.name} is walking`;
    }
};

const canSwim = {
    swim() {
        return `${this.name} is swimming`;
    }
};

// Constructor
function Person(name) {
    this.name = name;
}

// Add mixins to prototype
Object.assign(Person.prototype, canEat, canWalk);

function Duck(name) {
    this.name = name;
}

Object.assign(Duck.prototype, canEat, canWalk, canSwim);

// Usage
const john = new Person("John");
console.log(john.eat());   // "John is eating"
console.log(john.walk());  // "John is walking"

const donald = new Duck("Donald");
console.log(donald.eat());   // "Donald is eating"
console.log(donald.walk());  // "Donald is walking"
console.log(donald.swim());  // "Donald is swimming"
```

## Prototype Gotchas

### Reference Types on Prototypes

```javascript
function Person(name) {
    this.name = name;
}

// ❌ BAD: Arrays/objects on prototype are shared!
Person.prototype.hobbies = [];

const john = new Person("John");
const jane = new Person("Jane");

john.hobbies.push("reading");
jane.hobbies.push("gaming");

console.log(john.hobbies);  // ["reading", "gaming"] - Unexpected!
console.log(jane.hobbies);  // ["reading", "gaming"] - Shared reference!

// ✅ GOOD: Initialize arrays/objects in constructor
function PersonFixed(name) {
    this.name = name;
    this.hobbies = [];  // Each instance gets its own array
}

const bob = new PersonFixed("Bob");
const alice = new PersonFixed("Alice");

bob.hobbies.push("reading");
alice.hobbies.push("gaming");

console.log(bob.hobbies);    // ["reading"]
console.log(alice.hobbies);  // ["gaming"]
```

### Performance Considerations

```javascript
// ✅ Define methods once on prototype
function PersonGood(name) {
    this.name = name;
}

PersonGood.prototype.greet = function() {
    return `Hello, ${this.name}`;
};

// ❌ Don't modify prototypes in loops
for (let i = 0; i < 1000; i++) {
    // BAD: Modifying prototype repeatedly
    PersonGood.prototype[`method${i}`] = function() {
        return i;
    };
}

// ✅ Build methods object first, then assign
const methods = {};
for (let i = 0; i < 1000; i++) {
    methods[`method${i}`] = function() {
        return i;
    };
}
Object.assign(PersonGood.prototype, methods);
```

## ES6 Classes vs Prototypes

ES6 classes are syntactic sugar over prototypes:

```javascript
// ES6 Class syntax
class Animal {
    constructor(name) {
        this.name = name;
    }
    
    speak() {
        return `${this.name} makes a sound`;
    }
}

class Dog extends Animal {
    constructor(name, breed) {
        super(name);
        this.breed = breed;
    }
    
    bark() {
        return `${this.name} says Woof!`;
    }
}

// Equivalent prototype-based code
function Animal(name) {
    this.name = name;
}

Animal.prototype.speak = function() {
    return `${this.name} makes a sound`;
};

function Dog(name, breed) {
    Animal.call(this, name);
    this.breed = breed;
}

Dog.prototype = Object.create(Animal.prototype);
Dog.prototype.constructor = Dog;

Dog.prototype.bark = function() {
    return `${this.name} says Woof!`;
};

// Both work the same way!
const dog1 = new Dog("Buddy", "Lab");
console.log(dog1.speak());  // "Buddy makes a sound"
console.log(dog1.bark());   // "Buddy says Woof!"
```

## Practical Examples

### Creating a Custom Array-like Object

```javascript
function MyArray() {
    this.length = 0;
}

MyArray.prototype = Object.create(Array.prototype);
MyArray.prototype.constructor = MyArray;

MyArray.prototype.push = function(item) {
    this[this.length] = item;
    this.length++;
    return this.length;
};

MyArray.prototype.pop = function() {
    if (this.length === 0) return undefined;
    const item = this[this.length - 1];
    delete this[this.length - 1];
    this.length--;
    return item;
};

const myArr = new MyArray();
myArr.push(1);
myArr.push(2);
myArr.push(3);

console.log(myArr.length);     // 3
console.log(myArr[0]);         // 1
console.log(myArr.pop());      // 3
console.log(myArr.length);     // 2
```

### Event Emitter Pattern

```javascript
function EventEmitter() {
    this.events = {};
}

EventEmitter.prototype.on = function(eventName, callback) {
    if (!this.events[eventName]) {
        this.events[eventName] = [];
    }
    this.events[eventName].push(callback);
};

EventEmitter.prototype.emit = function(eventName, ...args) {
    if (!this.events[eventName]) return;
    
    this.events[eventName].forEach(callback => {
        callback(...args);
    });
};

EventEmitter.prototype.off = function(eventName, callback) {
    if (!this.events[eventName]) return;
    
    this.events[eventName] = this.events[eventName].filter(cb => cb !== callback);
};

// Usage
const emitter = new EventEmitter();

function onUserLogin(username) {
    console.log(`${username} logged in`);
}

emitter.on('login', onUserLogin);
emitter.on('login', (username) => {
    console.log(`Welcome, ${username}!`);
});

emitter.emit('login', 'John');
// Output:
// John logged in
// Welcome, John!
```

## Best Practices

### 1. Use Prototypes for Shared Methods

```javascript
// ✅ Methods shared via prototype
function User(name) {
    this.name = name;
}

User.prototype.greet = function() {
    return `Hello, ${this.name}`;
};
```

### 2. Initialize Instance Properties in Constructor

```javascript
// ✅ Instance-specific data in constructor
function User(name, preferences) {
    this.name = name;
    this.preferences = preferences || {};  // Each instance gets its own
}
```

### 3. Don't Modify Built-in Prototypes

```javascript
// ❌ BAD: Modifying native prototypes
Array.prototype.myMethod = function() {
    // This affects ALL arrays globally!
};

// ✅ GOOD: Extend with your own constructor
function MyArray() {
    Array.call(this);
}

MyArray.prototype = Object.create(Array.prototype);
MyArray.prototype.myMethod = function() {
    // Only affects MyArray instances
};
```

### 4. Use Object.create() for Inheritance

```javascript
// ✅ Proper prototype chain setup
function Parent() {}
function Child() {}

Child.prototype = Object.create(Parent.prototype);
Child.prototype.constructor = Child;
```

### 5. Consider ES6 Classes for Clarity

```javascript
// ✅ Modern syntax (same behavior as prototypes)
class User {
    constructor(name) {
        this.name = name;
    }
    
    greet() {
        return `Hello, ${this.name}`;
    }
}
```

## Summary

- **Prototypes** enable inheritance and method sharing in JavaScript
- **Prototype chain** is used for property lookup
- **Constructor functions** create objects with shared prototypes
- **Object.create()** creates objects with specific prototypes
- **Prototypal inheritance** allows objects to inherit from other objects
- **ES6 classes** are syntactic sugar over prototype-based inheritance
- Use prototypes for **memory-efficient** method sharing
- Initialize **instance-specific** data in constructors
- Understand the difference between `__proto__` and `prototype`

## Further Reading

- [MDN: Inheritance and the Prototype Chain](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Inheritance_and_the_prototype_chain)
- [MDN: Object.create()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/create)
- [MDN: Object.getPrototypeOf()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/getPrototypeOf)
- [You Don't Know JS: this & Object Prototypes](https://github.com/getify/You-Dont-Know-JS/blob/1st-ed/this%20%26%20object%20prototypes/README.md)
