# Events in JavaScript

Events are actions or occurrences that happen in the browser that can be detected and responded to. Understanding events is crucial for creating interactive web applications.

## Table of Contents
1. [Event Basics](#event-basics)
2. [Event Listeners](#event-listeners)
3. [Event Object](#event-object)
4. [Event Types](#event-types)
5. [Event Propagation](#event-propagation)
6. [Event Delegation](#event-delegation)
7. [Custom Events](#custom-events)

---

## Event Basics

### What Are Events?

Events are signals that something has happened in the browser. They can be:
- User actions (clicks, key presses, mouse movements)
- Browser actions (page load, resize, scroll)
- Programmatic triggers (custom events)

```javascript
// Basic event handler
const button = document.querySelector('button');

button.onclick = function() {
  console.log('Button clicked!');
};

// Or using arrow function
button.onclick = () => {
  console.log('Button clicked!');
};
```

### Event Handler Properties

```javascript
const element = document.querySelector('#myElement');

// Only one handler per property
element.onclick = function() {
  console.log('First handler');
};

element.onclick = function() {
  console.log('Second handler'); // Overwrites first
};

// This will only log "Second handler"
```

---

## Event Listeners

### addEventListener()

More flexible than event handler properties. Allows multiple handlers for the same event.

```javascript
const button = document.querySelector('button');

// Basic syntax
button.addEventListener('click', function() {
  console.log('Button clicked!');
});

// With arrow function
button.addEventListener('click', () => {
  console.log('Button clicked!');
});

// With named function (better for removal)
function handleClick() {
  console.log('Button clicked!');
}

button.addEventListener('click', handleClick);

// Multiple handlers
button.addEventListener('click', () => {
  console.log('Handler 1');
});

button.addEventListener('click', () => {
  console.log('Handler 2');
});

// Both handlers will execute
```

### removeEventListener()

```javascript
// Remove event listener
function handleClick() {
  console.log('Clicked!');
}

button.addEventListener('click', handleClick);

// Later, remove it
button.removeEventListener('click', handleClick);

// ❌ This won't work (anonymous functions can't be removed)
button.addEventListener('click', () => console.log('Clicked'));
button.removeEventListener('click', () => console.log('Clicked'));

// ✅ Use named functions for removable listeners
const handler = () => console.log('Clicked');
button.addEventListener('click', handler);
button.removeEventListener('click', handler);
```

### Event Listener Options

```javascript
const element = document.querySelector('#myElement');

// Options object
element.addEventListener('click', handleClick, {
  capture: false,  // Use capturing phase
  once: true,      // Remove after first execution
  passive: true    // Never calls preventDefault()
});

// Once option - auto-removes after first call
button.addEventListener('click', () => {
  console.log('This will only run once');
}, { once: true });

// Passive option - improves scroll performance
window.addEventListener('scroll', handleScroll, { passive: true });

// Capture option
parent.addEventListener('click', () => {
  console.log('Parent capturing');
}, { capture: true });
```

---

## Event Object

The event object contains information about the event.

### Common Properties

```javascript
element.addEventListener('click', function(event) {
  // Event type
  console.log(event.type); // "click"
  
  // Target element (where event originated)
  console.log(event.target);
  
  // Current element (where handler is attached)
  console.log(event.currentTarget); // Same as 'this'
  
  // Timestamp
  console.log(event.timeStamp);
  
  // Mouse position
  console.log(event.clientX, event.clientY);
  console.log(event.pageX, event.pageY);
  console.log(event.screenX, event.screenY);
  
  // Modifier keys
  console.log(event.ctrlKey);  // Ctrl key pressed?
  console.log(event.shiftKey); // Shift key pressed?
  console.log(event.altKey);   // Alt key pressed?
  console.log(event.metaKey);  // Meta/Cmd key pressed?
});
```

### Event Methods

```javascript
element.addEventListener('click', function(event) {
  // Prevent default browser behavior
  event.preventDefault();
  
  // Stop event propagation
  event.stopPropagation();
  
  // Stop propagation and prevent other handlers
  event.stopImmediatePropagation();
});

// Example: Prevent form submission
const form = document.querySelector('form');

form.addEventListener('submit', (e) => {
  e.preventDefault();
  console.log('Form submitted, but default prevented');
  
  // Handle form data
  const formData = new FormData(e.target);
  console.log(Object.fromEntries(formData));
});

// Example: Prevent link navigation
const link = document.querySelector('a');

link.addEventListener('click', (e) => {
  e.preventDefault();
  console.log('Link clicked, but navigation prevented');
});
```

---

## Event Types

### Mouse Events

```javascript
const element = document.querySelector('#myElement');

// Click events
element.addEventListener('click', (e) => {
  console.log('Clicked');
});

element.addEventListener('dblclick', (e) => {
  console.log('Double clicked');
});

element.addEventListener('contextmenu', (e) => {
  e.preventDefault(); // Prevent right-click menu
  console.log('Right clicked');
});

// Mouse movement
element.addEventListener('mouseenter', (e) => {
  console.log('Mouse entered');
});

element.addEventListener('mouseleave', (e) => {
  console.log('Mouse left');
});

element.addEventListener('mouseover', (e) => {
  console.log('Mouse over');
});

element.addEventListener('mouseout', (e) => {
  console.log('Mouse out');
});

element.addEventListener('mousemove', (e) => {
  console.log(`Mouse at: ${e.clientX}, ${e.clientY}`);
});

// Mouse buttons
element.addEventListener('mousedown', (e) => {
  console.log('Mouse button pressed');
});

element.addEventListener('mouseup', (e) => {
  console.log('Mouse button released');
});

// Detect which button
element.addEventListener('mousedown', (e) => {
  switch(e.button) {
    case 0: console.log('Left button'); break;
    case 1: console.log('Middle button'); break;
    case 2: console.log('Right button'); break;
  }
});
```

### Keyboard Events

```javascript
// Keyboard events
document.addEventListener('keydown', (e) => {
  console.log(`Key pressed: ${e.key}`);
  console.log(`Key code: ${e.code}`);
  console.log(`Char code: ${e.keyCode}`); // Deprecated
});

document.addEventListener('keyup', (e) => {
  console.log(`Key released: ${e.key}`);
});

document.addEventListener('keypress', (e) => {
  console.log('Key pressed (deprecated)');
});

// Practical examples
const input = document.querySelector('input');

// Detect Enter key
input.addEventListener('keydown', (e) => {
  if (e.key === 'Enter') {
    console.log('Enter pressed');
  }
});

// Detect Escape key
document.addEventListener('keydown', (e) => {
  if (e.key === 'Escape') {
    console.log('Escape pressed');
  }
});

// Keyboard shortcuts
document.addEventListener('keydown', (e) => {
  // Ctrl+S or Cmd+S
  if ((e.ctrlKey || e.metaKey) && e.key === 's') {
    e.preventDefault();
    console.log('Save triggered');
  }
  
  // Ctrl+C or Cmd+C
  if ((e.ctrlKey || e.metaKey) && e.key === 'c') {
    console.log('Copy triggered');
  }
});

// Filter input
input.addEventListener('keydown', (e) => {
  // Only allow numbers
  if (!/[0-9]/.test(e.key) && e.key !== 'Backspace') {
    e.preventDefault();
  }
});
```

### Form Events

```javascript
const form = document.querySelector('form');
const input = document.querySelector('input');
const select = document.querySelector('select');

// Form submission
form.addEventListener('submit', (e) => {
  e.preventDefault();
  console.log('Form submitted');
});

// Input events
input.addEventListener('input', (e) => {
  console.log('Input value:', e.target.value);
});

input.addEventListener('change', (e) => {
  console.log('Input changed:', e.target.value);
});

input.addEventListener('focus', (e) => {
  console.log('Input focused');
});

input.addEventListener('blur', (e) => {
  console.log('Input blurred');
});

// Select events
select.addEventListener('change', (e) => {
  console.log('Selected:', e.target.value);
});

// Real-time validation
const emailInput = document.querySelector('#email');

emailInput.addEventListener('input', (e) => {
  const email = e.target.value;
  const isValid = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
  
  if (isValid) {
    emailInput.classList.remove('invalid');
    emailInput.classList.add('valid');
  } else {
    emailInput.classList.remove('valid');
    emailInput.classList.add('invalid');
  }
});
```

### Window Events

```javascript
// Page load
window.addEventListener('load', () => {
  console.log('Page fully loaded');
});

// DOM ready
document.addEventListener('DOMContentLoaded', () => {
  console.log('DOM ready');
});

// Before unload
window.addEventListener('beforeunload', (e) => {
  e.preventDefault();
  e.returnValue = '';
  return 'Are you sure you want to leave?';
});

// Resize
window.addEventListener('resize', () => {
  console.log(`Window size: ${window.innerWidth}x${window.innerHeight}`);
});

// Debounced resize
function debounce(fn, delay) {
  let timeoutId;
  return function(...args) {
    clearTimeout(timeoutId);
    timeoutId = setTimeout(() => fn(...args), delay);
  };
}

const handleResize = debounce(() => {
  console.log('Resized!');
}, 250);

window.addEventListener('resize', handleResize);

// Scroll
window.addEventListener('scroll', () => {
  console.log('Scroll position:', window.scrollY);
});

// Throttled scroll
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

const handleScroll = throttle(() => {
  console.log('Scrolled!');
}, 100);

window.addEventListener('scroll', handleScroll);
```

### Other Common Events

```javascript
// Focus events
document.addEventListener('focusin', (e) => {
  console.log('Element focused:', e.target);
});

document.addEventListener('focusout', (e) => {
  console.log('Element blurred:', e.target);
});

// Drag and drop
const draggable = document.querySelector('.draggable');
const dropzone = document.querySelector('.dropzone');

draggable.addEventListener('dragstart', (e) => {
  e.dataTransfer.setData('text/plain', e.target.id);
});

dropzone.addEventListener('dragover', (e) => {
  e.preventDefault(); // Allow drop
});

dropzone.addEventListener('drop', (e) => {
  e.preventDefault();
  const id = e.dataTransfer.getData('text/plain');
  const element = document.getElementById(id);
  dropzone.appendChild(element);
});

// Clipboard events
document.addEventListener('copy', (e) => {
  e.preventDefault();
  e.clipboardData.setData('text/plain', 'Custom copy text');
});

document.addEventListener('paste', (e) => {
  e.preventDefault();
  const text = e.clipboardData.getData('text/plain');
  console.log('Pasted:', text);
});

// Media events
const video = document.querySelector('video');

video.addEventListener('play', () => console.log('Playing'));
video.addEventListener('pause', () => console.log('Paused'));
video.addEventListener('ended', () => console.log('Ended'));
video.addEventListener('timeupdate', () => {
  console.log('Current time:', video.currentTime);
});
```

---

## Event Propagation

Events propagate through the DOM in three phases: capturing, target, and bubbling.

### Bubbling

Events bubble up from the target element to the root.

```javascript
<div id="outer">
  <div id="middle">
    <div id="inner">
      Click me
    </div>
  </div>
</div>

const outer = document.querySelector('#outer');
const middle = document.querySelector('#middle');
const inner = document.querySelector('#inner');

outer.addEventListener('click', () => {
  console.log('Outer clicked');
});

middle.addEventListener('click', () => {
  console.log('Middle clicked');
});

inner.addEventListener('click', () => {
  console.log('Inner clicked');
});

// Clicking inner logs:
// "Inner clicked"
// "Middle clicked"
// "Outer clicked"
```

### Capturing

Events can be captured during the downward phase.

```javascript
outer.addEventListener('click', () => {
  console.log('Outer capturing');
}, { capture: true });

middle.addEventListener('click', () => {
  console.log('Middle capturing');
}, { capture: true });

inner.addEventListener('click', () => {
  console.log('Inner clicked');
});

// Clicking inner logs:
// "Outer capturing"
// "Middle capturing"
// "Inner clicked"
```

### Stopping Propagation

```javascript
inner.addEventListener('click', (e) => {
  e.stopPropagation();
  console.log('Inner clicked');
});

middle.addEventListener('click', () => {
  console.log('Middle clicked'); // Won't execute
});

// stopImmediatePropagation - also stops other handlers on same element
inner.addEventListener('click', (e) => {
  e.stopImmediatePropagation();
  console.log('First handler');
});

inner.addEventListener('click', () => {
  console.log('Second handler'); // Won't execute
});
```

### Event Target vs Current Target

```javascript
const outer = document.querySelector('#outer');
const inner = document.querySelector('#inner');

outer.addEventListener('click', (e) => {
  console.log('Target:', e.target.id);           // inner (where click occurred)
  console.log('Current target:', e.currentTarget.id); // outer (where handler attached)
});

// Clicking inner logs:
// "Target: inner"
// "Current target: outer"
```

---

## Event Delegation

Attach a single event listener to a parent element instead of multiple listeners to child elements.

### Basic Delegation

```javascript
// ❌ Inefficient - many listeners
document.querySelectorAll('.item').forEach(item => {
  item.addEventListener('click', () => {
    console.log('Item clicked');
  });
});

// ✅ Efficient - one listener
document.querySelector('#list').addEventListener('click', (e) => {
  if (e.target.classList.contains('item')) {
    console.log('Item clicked');
  }
});
```

### Practical Examples

```javascript
// Dynamic list
const list = document.querySelector('#list');

list.addEventListener('click', (e) => {
  if (e.target.matches('.delete-btn')) {
    e.target.closest('.item').remove();
  }
  
  if (e.target.matches('.edit-btn')) {
    const item = e.target.closest('.item');
    // Edit logic
  }
});

// Add new items (listeners still work)
const newItem = document.createElement('div');
newItem.className = 'item';
newItem.innerHTML = `
  <span>New item</span>
  <button class="delete-btn">Delete</button>
`;
list.appendChild(newItem);

// Table row clicks
const table = document.querySelector('table');

table.addEventListener('click', (e) => {
  const row = e.target.closest('tr');
  if (row && table.contains(row)) {
    console.log('Row clicked:', row.dataset.id);
  }
});

// Multiple event types
document.querySelector('#container').addEventListener('click', (e) => {
  const target = e.target;
  
  if (target.matches('.button')) {
    handleButtonClick(target);
  } else if (target.matches('.link')) {
    handleLinkClick(target);
  } else if (target.matches('.checkbox')) {
    handleCheckboxChange(target);
  }
});
```

### Delegation Helper

```javascript
function delegate(parent, selector, event, handler) {
  parent.addEventListener(event, (e) => {
    if (e.target.matches(selector)) {
      handler.call(e.target, e);
    }
  });
}

// Usage
delegate(document, '.button', 'click', function(e) {
  console.log('Button clicked:', this.textContent);
});

delegate(document, '.item', 'mouseover', function(e) {
  this.classList.add('hover');
});

delegate(document, '.item', 'mouseout', function(e) {
  this.classList.remove('hover');
});
```

---

## Custom Events

Create and dispatch custom events for application-specific communication.

### Creating Custom Events

```javascript
// Simple custom event
const event = new Event('myEvent');

element.addEventListener('myEvent', () => {
  console.log('Custom event triggered');
});

element.dispatchEvent(event);

// Custom event with data
const customEvent = new CustomEvent('userLoggedIn', {
  detail: {
    username: 'john',
    timestamp: Date.now()
  }
});

document.addEventListener('userLoggedIn', (e) => {
  console.log('User:', e.detail.username);
  console.log('Time:', new Date(e.detail.timestamp));
});

document.dispatchEvent(customEvent);
```

### Custom Event Options

```javascript
const event = new CustomEvent('myEvent', {
  detail: { message: 'Hello' },
  bubbles: true,      // Event bubbles up
  cancelable: true,   // Can be canceled
  composed: false     // Crosses shadow DOM boundary
});

element.dispatchEvent(event);

// Check if event was canceled
const event = new CustomEvent('save', {
  cancelable: true,
  detail: { data: 'some data' }
});

const wasCanceled = !element.dispatchEvent(event);

if (wasCanceled) {
  console.log('Save was prevented');
}
```

### Practical Examples

```javascript
// Publish-Subscribe pattern
class EventBus {
  constructor() {
    this.events = {};
  }
  
  on(event, callback) {
    if (!this.events[event]) {
      this.events[event] = [];
    }
    this.events[event].push(callback);
  }
  
  off(event, callback) {
    if (this.events[event]) {
      this.events[event] = this.events[event].filter(cb => cb !== callback);
    }
  }
  
  emit(event, data) {
    if (this.events[event]) {
      this.events[event].forEach(callback => callback(data));
    }
  }
}

// Usage
const bus = new EventBus();

bus.on('userLoggedIn', (user) => {
  console.log('Welcome:', user.name);
});

bus.on('userLoggedIn', (user) => {
  console.log('Updating UI for:', user.name);
});

bus.emit('userLoggedIn', { name: 'John', id: 1 });

// Component communication
class Component {
  constructor(element) {
    this.element = element;
  }
  
  emit(eventName, data) {
    const event = new CustomEvent(eventName, {
      detail: data,
      bubbles: true
    });
    this.element.dispatchEvent(event);
  }
  
  on(eventName, handler) {
    this.element.addEventListener(eventName, handler);
  }
}

// Usage
const button = new Component(document.querySelector('button'));

button.on('clicked', (e) => {
  console.log('Button clicked with data:', e.detail);
});

button.element.addEventListener('click', () => {
  button.emit('clicked', { timestamp: Date.now() });
});

// State change notifications
class Store {
  constructor(initialState) {
    this.state = initialState;
    this.listeners = [];
  }
  
  getState() {
    return this.state;
  }
  
  setState(newState) {
    const oldState = this.state;
    this.state = { ...this.state, ...newState };
    
    const event = new CustomEvent('stateChange', {
      detail: {
        oldState,
        newState: this.state
      }
    });
    
    document.dispatchEvent(event);
  }
}

const store = new Store({ count: 0 });

document.addEventListener('stateChange', (e) => {
  console.log('State changed:', e.detail);
});

store.setState({ count: 1 });
```

---

## Best Practices

### Memory Management

```javascript
// ✅ Remove event listeners when done
const button = document.querySelector('button');
const handler = () => console.log('Clicked');

button.addEventListener('click', handler);

// Later, when component is destroyed
button.removeEventListener('click', handler);

// ✅ Use once option for one-time events
button.addEventListener('click', handler, { once: true });

// ✅ AbortController for multiple listeners
const controller = new AbortController();
const signal = controller.signal;

element.addEventListener('click', handler1, { signal });
element.addEventListener('mouseover', handler2, { signal });

// Remove all at once
controller.abort();
```

### Performance

```javascript
// ✅ Use event delegation
document.querySelector('#list').addEventListener('click', (e) => {
  if (e.target.matches('.item')) {
    // Handle click
  }
});

// ✅ Debounce expensive handlers
const handleInput = debounce((e) => {
  // Expensive operation
}, 300);

input.addEventListener('input', handleInput);

// ✅ Throttle high-frequency events
const handleScroll = throttle(() => {
  // Scroll handler
}, 100);

window.addEventListener('scroll', handleScroll);

// ✅ Use passive listeners for scroll/touch
window.addEventListener('scroll', handler, { passive: true });
```

### Common Pitfalls

```javascript
// ❌ Anonymous functions can't be removed
element.addEventListener('click', () => console.log('Click'));
element.removeEventListener('click', () => console.log('Click')); // Won't work

// ✅ Use named functions
const handler = () => console.log('Click');
element.addEventListener('click', handler);
element.removeEventListener('click', handler);

// ❌ This binding issues
class Component {
  constructor() {
    this.count = 0;
    element.addEventListener('click', this.handleClick);
  }
  
  handleClick() {
    this.count++; // 'this' is undefined!
  }
}

// ✅ Bind this or use arrow function
class Component {
  constructor() {
    this.count = 0;
    element.addEventListener('click', this.handleClick.bind(this));
    // or
    element.addEventListener('click', () => this.handleClick());
  }
  
  handleClick() {
    this.count++;
  }
}
```

---

## Summary

Events are fundamental to interactive web applications:

1. **Use addEventListener()** for flexibility
2. **Leverage event delegation** for dynamic content
3. **Understand event propagation** (bubbling and capturing)
4. **Create custom events** for application communication
5. **Manage memory** by removing unused listeners
6. **Optimize performance** with debouncing and throttling

## Next Steps

- [DOM Manipulation](26_DOM_MANIPULATION.md)
- [Fetch API](29_FETCH_API.md)
- [Browser Storage](28_BROWSER_STORAGE.md)
- Practice building interactive applications
