# JavaScript Design Patterns

Design patterns are reusable solutions to commonly occurring problems in software design. They represent best practices and provide a template for how to solve problems in various situations.

## Table of Contents
1. [Creational Patterns](#creational-patterns)
2. [Structural Patterns](#structural-patterns)
3. [Behavioral Patterns](#behavioral-patterns)

---

## Creational Patterns

### 1. Singleton Pattern

Ensures a class has only one instance and provides a global point of access to it.

```javascript
// Using class
class Singleton {
  constructor() {
    if (Singleton.instance) {
      return Singleton.instance;
    }
    
    this.timestamp = Date.now();
    Singleton.instance = this;
  }
  
  getInstance() {
    return this;
  }
}

// Usage
const instance1 = new Singleton();
const instance2 = new Singleton();
console.log(instance1 === instance2); // true

// Using closure
const DatabaseConnection = (function() {
  let instance;
  
  function createInstance() {
    return {
      connect: () => console.log('Connected to database'),
      query: (sql) => console.log(`Executing: ${sql}`)
    };
  }
  
  return {
    getInstance: function() {
      if (!instance) {
        instance = createInstance();
      }
      return instance;
    }
  };
})();

const db1 = DatabaseConnection.getInstance();
const db2 = DatabaseConnection.getInstance();
console.log(db1 === db2); // true
```

### 2. Factory Pattern

Creates objects without specifying the exact class of object that will be created.

```javascript
// Simple Factory
class Car {
  constructor(options) {
    this.doors = options.doors || 4;
    this.state = options.state || 'new';
    this.color = options.color || 'white';
  }
}

class Truck {
  constructor(options) {
    this.wheelSize = options.wheelSize || 'large';
    this.state = options.state || 'new';
    this.color = options.color || 'blue';
  }
}

class VehicleFactory {
  createVehicle(type, options) {
    switch(type) {
      case 'car':
        return new Car(options);
      case 'truck':
        return new Truck(options);
      default:
        throw new Error('Unknown vehicle type');
    }
  }
}

// Usage
const factory = new VehicleFactory();
const car = factory.createVehicle('car', { doors: 2, color: 'red' });
const truck = factory.createVehicle('truck', { wheelSize: 'extra-large' });

// Abstract Factory Pattern
class Button {
  render() {}
}

class WindowsButton extends Button {
  render() {
    return '<button class="windows-btn">Windows Button</button>';
  }
}

class MacButton extends Button {
  render() {
    return '<button class="mac-btn">Mac Button</button>';
  }
}

class GUIFactory {
  createButton() {}
}

class WindowsFactory extends GUIFactory {
  createButton() {
    return new WindowsButton();
  }
}

class MacFactory extends GUIFactory {
  createButton() {
    return new MacButton();
  }
}

// Usage
const getFactory = (os) => {
  switch(os) {
    case 'windows': return new WindowsFactory();
    case 'mac': return new MacFactory();
    default: throw new Error('Unknown OS');
  }
};

const factory = getFactory('mac');
const button = factory.createButton();
console.log(button.render());
```

### 3. Constructor Pattern

Uses constructor functions to create specific types of objects.

```javascript
// ES5 Constructor
function Person(name, age, job) {
  this.name = name;
  this.age = age;
  this.job = job;
  
  this.sayName = function() {
    console.log(this.name);
  };
}

// Better approach with prototype
function PersonOptimized(name, age, job) {
  this.name = name;
  this.age = age;
  this.job = job;
}

PersonOptimized.prototype.sayName = function() {
  console.log(this.name);
};

// ES6 Class (syntactic sugar)
class PersonES6 {
  constructor(name, age, job) {
    this.name = name;
    this.age = age;
    this.job = job;
  }
  
  sayName() {
    console.log(this.name);
  }
}

// Usage
const person = new PersonES6('John', 30, 'Developer');
person.sayName(); // "John"
```

### 4. Module Pattern

Encapsulates private and public members.

```javascript
// Classic Module Pattern
const ShoppingCart = (function() {
  // Private variables and functions
  let items = [];
  
  function calculateTotal() {
    return items.reduce((sum, item) => sum + item.price, 0);
  }
  
  // Public API
  return {
    addItem: function(item) {
      items.push(item);
      console.log(`${item.name} added to cart`);
    },
    
    removeItem: function(itemName) {
      items = items.filter(item => item.name !== itemName);
      console.log(`${itemName} removed from cart`);
    },
    
    getTotal: function() {
      return calculateTotal();
    },
    
    getItems: function() {
      return [...items]; // Return copy to prevent mutation
    }
  };
})();

// Usage
ShoppingCart.addItem({ name: 'Laptop', price: 1000 });
ShoppingCart.addItem({ name: 'Mouse', price: 50 });
console.log(ShoppingCart.getTotal()); // 1050

// ES6 Module Pattern
// cart.js
let items = [];

function calculateTotal() {
  return items.reduce((sum, item) => sum + item.price, 0);
}

export function addItem(item) {
  items.push(item);
}

export function getTotal() {
  return calculateTotal();
}

export function getItems() {
  return [...items];
}
```

### 5. Prototype Pattern

Creates objects based on a template of an existing object through cloning.

```javascript
// Basic Prototype Pattern
const carPrototype = {
  init: function(model, year) {
    this.model = model;
    this.year = year;
  },
  
  getInfo: function() {
    return `${this.year} ${this.model}`;
  }
};

// Create new objects
const car1 = Object.create(carPrototype);
car1.init('Tesla Model 3', 2024);

const car2 = Object.create(carPrototype);
car2.init('Toyota Camry', 2023);

console.log(car1.getInfo()); // "2024 Tesla Model 3"
console.log(car2.getInfo()); // "2023 Toyota Camry"

// With Constructor
function Vehicle(name) {
  this.name = name;
}

Vehicle.prototype.drive = function() {
  return `${this.name} is driving`;
};

Vehicle.prototype.stop = function() {
  return `${this.name} has stopped`;
};

const vehicle = new Vehicle('Car');
console.log(vehicle.drive()); // "Car is driving"
```

---

## Structural Patterns

### 1. Decorator Pattern

Adds new functionality to existing objects dynamically.

```javascript
// Simple Decorator
class Coffee {
  cost() {
    return 5;
  }
  
  description() {
    return 'Coffee';
  }
}

class MilkDecorator {
  constructor(coffee) {
    this.coffee = coffee;
  }
  
  cost() {
    return this.coffee.cost() + 2;
  }
  
  description() {
    return this.coffee.description() + ', Milk';
  }
}

class SugarDecorator {
  constructor(coffee) {
    this.coffee = coffee;
  }
  
  cost() {
    return this.coffee.cost() + 1;
  }
  
  description() {
    return this.coffee.description() + ', Sugar';
  }
}

// Usage
let myCoffee = new Coffee();
console.log(myCoffee.description(), myCoffee.cost()); // "Coffee" 5

myCoffee = new MilkDecorator(myCoffee);
console.log(myCoffee.description(), myCoffee.cost()); // "Coffee, Milk" 7

myCoffee = new SugarDecorator(myCoffee);
console.log(myCoffee.description(), myCoffee.cost()); // "Coffee, Milk, Sugar" 8

// Function Decorator
function readonly(target, key, descriptor) {
  descriptor.writable = false;
  return descriptor;
}

class User {
  constructor(name) {
    this.name = name;
  }
  
  @readonly
  getName() {
    return this.name;
  }
}
```

### 2. Facade Pattern

Provides a simplified interface to a complex subsystem.

```javascript
// Complex subsystems
class CPU {
  freeze() { console.log('CPU: Freezing...'); }
  jump(position) { console.log(`CPU: Jumping to ${position}`); }
  execute() { console.log('CPU: Executing...'); }
}

class Memory {
  load(position, data) {
    console.log(`Memory: Loading ${data} at ${position}`);
  }
}

class HardDrive {
  read(sector, size) {
    console.log(`HardDrive: Reading ${size} bytes from sector ${sector}`);
    return 'boot data';
  }
}

// Facade
class ComputerFacade {
  constructor() {
    this.cpu = new CPU();
    this.memory = new Memory();
    this.hardDrive = new HardDrive();
  }
  
  start() {
    console.log('Starting computer...');
    this.cpu.freeze();
    const bootData = this.hardDrive.read(0, 1024);
    this.memory.load(0, bootData);
    this.cpu.jump(0);
    this.cpu.execute();
    console.log('Computer started!');
  }
}

// Usage - Simple interface
const computer = new ComputerFacade();
computer.start();

// Real-world example: API Facade
class APIFacade {
  constructor() {
    this.cache = new Map();
  }
  
  async getData(url) {
    // Check cache
    if (this.cache.has(url)) {
      console.log('Returning cached data');
      return this.cache.get(url);
    }
    
    // Fetch data
    try {
      const response = await fetch(url);
      const data = await response.json();
      
      // Cache the result
      this.cache.set(url, data);
      
      return data;
    } catch (error) {
      console.error('Error fetching data:', error);
      throw error;
    }
  }
}
```

### 3. Proxy Pattern

Provides a surrogate or placeholder for another object to control access to it.

```javascript
// Virtual Proxy - Lazy loading
class ExpensiveObject {
  constructor() {
    console.log('ExpensiveObject created');
    this.data = this.loadData();
  }
  
  loadData() {
    // Simulate expensive operation
    return 'Expensive data';
  }
  
  process() {
    return this.data;
  }
}

class ProxyObject {
  constructor() {
    this.expensiveObject = null;
  }
  
  process() {
    if (!this.expensiveObject) {
      this.expensiveObject = new ExpensiveObject();
    }
    return this.expensiveObject.process();
  }
}

// Usage
const proxy = new ProxyObject();
console.log('Proxy created, but expensive object not yet');
console.log(proxy.process()); // Creates expensive object now

// ES6 Proxy
const target = {
  message1: 'hello',
  message2: 'world'
};

const handler = {
  get: function(target, prop) {
    console.log(`Getting ${prop}`);
    return prop in target ? target[prop] : 'Property not found';
  },
  
  set: function(target, prop, value) {
    console.log(`Setting ${prop} to ${value}`);
    target[prop] = value;
    return true;
  }
};

const proxyObj = new Proxy(target, handler);
console.log(proxyObj.message1); // "Getting message1" then "hello"
proxyObj.message3 = 'test'; // "Setting message3 to test"

// Validation Proxy
function createValidator(target) {
  return new Proxy(target, {
    set(obj, prop, value) {
      if (prop === 'age') {
        if (!Number.isInteger(value)) {
          throw new TypeError('Age must be an integer');
        }
        if (value < 0 || value > 150) {
          throw new RangeError('Age must be between 0 and 150');
        }
      }
      obj[prop] = value;
      return true;
    }
  });
}

const person = createValidator({});
person.age = 30; // OK
// person.age = -1; // Throws RangeError
// person.age = 'thirty'; // Throws TypeError
```

### 4. Adapter Pattern

Allows incompatible interfaces to work together.

```javascript
// Old interface
class OldCalculator {
  constructor() {
    this.operations = function(term1, term2, operation) {
      switch (operation) {
        case 'add':
          return term1 + term2;
        case 'sub':
          return term1 - term2;
        default:
          return NaN;
      }
    };
  }
}

// New interface
class NewCalculator {
  constructor() {
    this.add = function(term1, term2) {
      return term1 + term2;
    };
    this.sub = function(term1, term2) {
      return term1 - term2;
    };
  }
}

// Adapter
class CalculatorAdapter {
  constructor() {
    const newCalc = new NewCalculator();
    
    this.operations = function(term1, term2, operation) {
      switch (operation) {
        case 'add':
          return newCalc.add(term1, term2);
        case 'sub':
          return newCalc.sub(term1, term2);
        default:
          return NaN;
      }
    };
  }
}

// Usage
const adaptedCalc = new CalculatorAdapter();
console.log(adaptedCalc.operations(10, 5, 'add')); // 15

// Real-world example: API Adapter
class ThirdPartyAPI {
  fetchUserData(userId) {
    return {
      id: userId,
      full_name: 'John Doe',
      email_address: 'john@example.com'
    };
  }
}

class UserAPIAdapter {
  constructor() {
    this.api = new ThirdPartyAPI();
  }
  
  getUser(userId) {
    const data = this.api.fetchUserData(userId);
    
    // Adapt to our interface
    return {
      id: data.id,
      name: data.full_name,
      email: data.email_address
    };
  }
}

const userAPI = new UserAPIAdapter();
console.log(userAPI.getUser(1));
```

---

## Behavioral Patterns

### 1. Observer Pattern

Defines a one-to-many dependency between objects so that when one object changes state, all its dependents are notified.

```javascript
// Subject
class Subject {
  constructor() {
    this.observers = [];
  }
  
  subscribe(observer) {
    this.observers.push(observer);
  }
  
  unsubscribe(observer) {
    this.observers = this.observers.filter(obs => obs !== observer);
  }
  
  notify(data) {
    this.observers.forEach(observer => observer.update(data));
  }
}

// Observer
class Observer {
  constructor(name) {
    this.name = name;
  }
  
  update(data) {
    console.log(`${this.name} received:`, data);
  }
}

// Usage
const subject = new Subject();

const observer1 = new Observer('Observer 1');
const observer2 = new Observer('Observer 2');

subject.subscribe(observer1);
subject.subscribe(observer2);

subject.notify('Hello observers!');
// Observer 1 received: Hello observers!
// Observer 2 received: Hello observers!

subject.unsubscribe(observer1);
subject.notify('Observer 1 unsubscribed');
// Observer 2 received: Observer 1 unsubscribed

// Real-world example: Event Emitter
class EventEmitter {
  constructor() {
    this.events = {};
  }
  
  on(event, listener) {
    if (!this.events[event]) {
      this.events[event] = [];
    }
    this.events[event].push(listener);
  }
  
  emit(event, data) {
    if (this.events[event]) {
      this.events[event].forEach(listener => listener(data));
    }
  }
  
  off(event, listenerToRemove) {
    if (this.events[event]) {
      this.events[event] = this.events[event].filter(
        listener => listener !== listenerToRemove
      );
    }
  }
}

const emitter = new EventEmitter();

const listener1 = (data) => console.log('Listener 1:', data);
const listener2 = (data) => console.log('Listener 2:', data);

emitter.on('userLogin', listener1);
emitter.on('userLogin', listener2);

emitter.emit('userLogin', { user: 'John' });
```

### 2. Strategy Pattern

Defines a family of algorithms, encapsulates each one, and makes them interchangeable.

```javascript
// Strategies
class CreditCardStrategy {
  pay(amount) {
    console.log(`Paid $${amount} using Credit Card`);
  }
}

class PayPalStrategy {
  pay(amount) {
    console.log(`Paid $${amount} using PayPal`);
  }
}

class CryptoStrategy {
  pay(amount) {
    console.log(`Paid $${amount} using Cryptocurrency`);
  }
}

// Context
class PaymentContext {
  constructor(strategy) {
    this.strategy = strategy;
  }
  
  setStrategy(strategy) {
    this.strategy = strategy;
  }
  
  executePayment(amount) {
    this.strategy.pay(amount);
  }
}

// Usage
const payment = new PaymentContext(new CreditCardStrategy());
payment.executePayment(100); // Paid $100 using Credit Card

payment.setStrategy(new PayPalStrategy());
payment.executePayment(200); // Paid $200 using PayPal

// Functional approach
const strategies = {
  creditCard: (amount) => console.log(`Paid $${amount} using Credit Card`),
  paypal: (amount) => console.log(`Paid $${amount} using PayPal`),
  crypto: (amount) => console.log(`Paid $${amount} using Cryptocurrency`)
};

function processPayment(amount, strategy) {
  strategies[strategy](amount);
}

processPayment(100, 'creditCard');
processPayment(200, 'paypal');

// Real-world example: Validation strategies
const validators = {
  email: (value) => /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value),
  phone: (value) => /^\d{10}$/.test(value),
  password: (value) => value.length >= 8
};

function validate(value, type) {
  return validators[type](value);
}

console.log(validate('test@example.com', 'email')); // true
console.log(validate('12345', 'password')); // false
```

### 3. Command Pattern

Encapsulates a request as an object, allowing you to parameterize clients with different requests.

```javascript
// Receiver
class TextEditor {
  constructor() {
    this.text = '';
  }
  
  write(text) {
    this.text += text;
  }
  
  delete(length) {
    this.text = this.text.slice(0, -length);
  }
  
  getText() {
    return this.text;
  }
}

// Command interface
class Command {
  execute() {}
  undo() {}
}

// Concrete commands
class WriteCommand extends Command {
  constructor(editor, text) {
    super();
    this.editor = editor;
    this.text = text;
  }
  
  execute() {
    this.editor.write(this.text);
  }
  
  undo() {
    this.editor.delete(this.text.length);
  }
}

class DeleteCommand extends Command {
  constructor(editor, length) {
    super();
    this.editor = editor;
    this.length = length;
    this.deletedText = '';
  }
  
  execute() {
    this.deletedText = this.editor.getText().slice(-this.length);
    this.editor.delete(this.length);
  }
  
  undo() {
    this.editor.write(this.deletedText);
  }
}

// Invoker
class CommandHistory {
  constructor() {
    this.history = [];
  }
  
  execute(command) {
    command.execute();
    this.history.push(command);
  }
  
  undo() {
    const command = this.history.pop();
    if (command) {
      command.undo();
    }
  }
}

// Usage
const editor = new TextEditor();
const history = new CommandHistory();

history.execute(new WriteCommand(editor, 'Hello '));
history.execute(new WriteCommand(editor, 'World!'));
console.log(editor.getText()); // "Hello World!"

history.undo();
console.log(editor.getText()); // "Hello "

history.execute(new WriteCommand(editor, 'JavaScript!'));
console.log(editor.getText()); // "Hello JavaScript!"
```

### 4. Chain of Responsibility Pattern

Passes requests along a chain of handlers where each handler decides either to process the request or pass it to the next handler.

```javascript
// Abstract Handler
class Handler {
  constructor() {
    this.nextHandler = null;
  }
  
  setNext(handler) {
    this.nextHandler = handler;
    return handler;
  }
  
  handle(request) {
    if (this.nextHandler) {
      return this.nextHandler.handle(request);
    }
    return null;
  }
}

// Concrete Handlers
class AuthenticationHandler extends Handler {
  handle(request) {
    if (!request.authenticated) {
      console.log('Authentication failed');
      return false;
    }
    console.log('Authentication passed');
    return super.handle(request);
  }
}

class AuthorizationHandler extends Handler {
  handle(request) {
    if (request.role !== 'admin') {
      console.log('Authorization failed');
      return false;
    }
    console.log('Authorization passed');
    return super.handle(request);
  }
}

class ValidationHandler extends Handler {
  handle(request) {
    if (!request.data) {
      console.log('Validation failed');
      return false;
    }
    console.log('Validation passed');
    return super.handle(request);
  }
}

// Usage
const auth = new AuthenticationHandler();
const authz = new AuthorizationHandler();
const validation = new ValidationHandler();

auth.setNext(authz).setNext(validation);

const request1 = {
  authenticated: true,
  role: 'admin',
  data: { name: 'John' }
};

auth.handle(request1);
// Authentication passed
// Authorization passed
// Validation passed

const request2 = {
  authenticated: true,
  role: 'user',
  data: { name: 'Jane' }
};

auth.handle(request2);
// Authentication passed
// Authorization failed

// Middleware pattern (similar to Express.js)
class Middleware {
  constructor() {
    this.middlewares = [];
  }
  
  use(fn) {
    this.middlewares.push(fn);
    return this;
  }
  
  execute(context) {
    let index = 0;
    
    const next = () => {
      if (index < this.middlewares.length) {
        const middleware = this.middlewares[index++];
        middleware(context, next);
      }
    };
    
    next();
  }
}

const app = new Middleware();

app.use((ctx, next) => {
  console.log('Middleware 1');
  next();
});

app.use((ctx, next) => {
  console.log('Middleware 2');
  next();
});

app.use((ctx, next) => {
  console.log('Middleware 3');
});

app.execute({});
// Middleware 1
// Middleware 2
// Middleware 3
```

---

## Best Practices

### 1. Choosing the Right Pattern

- **Singleton**: Database connections, configuration managers
- **Factory**: Object creation with complex initialization
- **Observer**: Event handling, publish-subscribe systems
- **Strategy**: Interchangeable algorithms
- **Decorator**: Adding functionality dynamically
- **Facade**: Simplifying complex APIs

### 2. Common Mistakes

```javascript
// ❌ Overusing patterns
class SimpleCalculator {
  // Don't create a factory for simple objects
  add(a, b) { return a + b; }
}

// ✅ Keep it simple when appropriate
const add = (a, b) => a + b;

// ❌ Forcing patterns where they don't fit
// Don't make everything a singleton

// ✅ Use patterns to solve specific problems
```

### 3. Pattern Combinations

```javascript
// Combining Observer + Strategy + Command
class Application {
  constructor() {
    this.eventBus = new EventEmitter(); // Observer
    this.commandHistory = new CommandHistory(); // Command
    this.strategies = {}; // Strategy
  }
  
  registerStrategy(name, strategy) {
    this.strategies[name] = strategy;
  }
  
  executeCommand(command) {
    this.commandHistory.execute(command);
    this.eventBus.emit('commandExecuted', command);
  }
}
```

---

## Summary

Design patterns are essential tools for writing maintainable, scalable code. Key takeaways:

1. **Patterns are guidelines**, not rules - use them when appropriate
2. **Understand the problem** before applying a pattern
3. **Keep it simple** - don't over-engineer solutions
4. **Learn from experience** - patterns become clearer with practice

## Next Steps

- [Functional Programming](25_FUNCTIONAL_PROGRAMMING.md)
- [ES6+ Features](23_ES6_FEATURES.md)
- Practice implementing patterns in real projects
