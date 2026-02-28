# Event Handling in React

## Table of Contents
- [Introduction](#introduction)
- [Basic Event Handling](#basic-event-handling)
- [Synthetic Events](#synthetic-events)
- [Event Binding](#event-binding)
- [Passing Arguments to Event Handlers](#passing-arguments-to-event-handlers)
- [Event Delegation](#event-delegation)
- [Common Event Types](#common-event-types)
- [Preventing Default Behavior](#preventing-default-behavior)
- [Event Bubbling and Capturing](#event-bubbling-and-capturing)
- [Best Practices](#best-practices)
- [Common Patterns](#common-patterns)

## Introduction

Event handling in React is similar to handling events on DOM elements, but with some syntactic differences. React events are named using camelCase, and you pass a function as the event handler rather than a string.

### Key Differences from HTML
- React uses camelCase naming (onClick vs onclick)
- Pass functions as handlers, not strings
- Cannot return false to prevent default behavior
- Uses synthetic events for cross-browser compatibility

## Basic Event Handling

### Click Events

```jsx
function Button() {
  const handleClick = () => {
    console.log('Button clicked!');
  };

  return <button onClick={handleClick}>Click Me</button>;
}
```

### Inline Event Handlers

```jsx
function Button() {
  return (
    <button onClick={() => console.log('Clicked!')}>
      Click Me
    </button>
  );
}
```

### Multiple Events

```jsx
function InteractiveDiv() {
  return (
    <div
      onClick={() => console.log('Clicked')}
      onMouseEnter={() => console.log('Mouse entered')}
      onMouseLeave={() => console.log('Mouse left')}
    >
      Hover or click me
    </div>
  );
}
```

## Synthetic Events

React wraps the browser's native event in a `SyntheticEvent` object for cross-browser compatibility.

### SyntheticEvent Properties

```jsx
function EventLogger() {
  const handleClick = (event) => {
    console.log('Event type:', event.type);
    console.log('Target:', event.target);
    console.log('Current target:', event.currentTarget);
    console.log('Client X:', event.clientX);
    console.log('Client Y:', event.clientY);
  };

  return <button onClick={handleClick}>Click to Log Event</button>;
}
```

### Accessing Native Event

```jsx
function NativeEventAccess() {
  const handleClick = (event) => {
    // Access the native event
    const nativeEvent = event.nativeEvent;
    console.log('Native event:', nativeEvent);
  };

  return <button onClick={handleClick}>Click Me</button>;
}
```

### Event Persistence

```jsx
function EventPersistence() {
  const handleClick = (event) => {
    // Event is automatically persisted in modern React
    setTimeout(() => {
      console.log(event.type); // Works fine
    }, 1000);
  };

  return <button onClick={handleClick}>Click Me</button>;
}
```

## Event Binding

### Using Arrow Functions (Recommended)

```jsx
function Counter() {
  const [count, setCount] = useState(0);

  const handleIncrement = () => {
    setCount(count + 1);
  };

  return (
    <div>
      <p>Count: {count}</p>
      <button onClick={handleIncrement}>Increment</button>
    </div>
  );
}
```

### Binding in Constructor (Class Components)

```jsx
class Counter extends React.Component {
  constructor(props) {
    super(props);
    this.state = { count: 0 };
    // Bind in constructor
    this.handleIncrement = this.handleIncrement.bind(this);
  }

  handleIncrement() {
    this.setState({ count: this.state.count + 1 });
  }

  render() {
    return (
      <button onClick={this.handleIncrement}>
        Count: {this.state.count}
      </button>
    );
  }
}
```

### Class Property Arrow Function

```jsx
class Counter extends React.Component {
  state = { count: 0 };

  // Arrow function automatically binds this
  handleIncrement = () => {
    this.setState({ count: this.state.count + 1 });
  };

  render() {
    return (
      <button onClick={this.handleIncrement}>
        Count: {this.state.count}
      </button>
    );
  }
}
```

## Passing Arguments to Event Handlers

### Using Arrow Functions

```jsx
function TodoList() {
  const [todos, setTodos] = useState(['Task 1', 'Task 2', 'Task 3']);

  const handleDelete = (index) => {
    setTodos(todos.filter((_, i) => i !== index));
  };

  return (
    <ul>
      {todos.map((todo, index) => (
        <li key={index}>
          {todo}
          <button onClick={() => handleDelete(index)}>Delete</button>
        </li>
      ))}
    </ul>
  );
}
```

### Using Data Attributes

```jsx
function ItemList() {
  const handleClick = (event) => {
    const itemId = event.currentTarget.dataset.id;
    console.log('Clicked item:', itemId);
  };

  return (
    <div>
      <button data-id="1" onClick={handleClick}>Item 1</button>
      <button data-id="2" onClick={handleClick}>Item 2</button>
      <button data-id="3" onClick={handleClick}>Item 3</button>
    </div>
  );
}
```

### Using bind()

```jsx
function ItemList() {
  const handleClick = (id, event) => {
    console.log('Clicked item:', id);
  };

  return (
    <div>
      <button onClick={handleClick.bind(null, 1)}>Item 1</button>
      <button onClick={handleClick.bind(null, 2)}>Item 2</button>
      <button onClick={handleClick.bind(null, 3)}>Item 3</button>
    </div>
  );
}
```

## Event Delegation

React uses event delegation at the root level for performance optimization.

### Parent-Child Event Handling

```jsx
function ParentChild() {
  const handleParentClick = () => {
    console.log('Parent clicked');
  };

  const handleChildClick = (e) => {
    e.stopPropagation(); // Prevent parent handler from firing
    console.log('Child clicked');
  };

  return (
    <div onClick={handleParentClick} style={{ padding: '20px', background: 'lightblue' }}>
      Parent
      <button onClick={handleChildClick}>Child Button</button>
    </div>
  );
}
```

### Event Target vs Current Target

```jsx
function EventTargetDemo() {
  const handleClick = (e) => {
    console.log('Target (element that triggered):', e.target);
    console.log('CurrentTarget (element with handler):', e.currentTarget);
  };

  return (
    <div onClick={handleClick} style={{ padding: '20px', background: 'lightgray' }}>
      <button>Click me</button>
      <span>Or click me</span>
    </div>
  );
}
```

## Common Event Types

### Mouse Events

```jsx
function MouseEvents() {
  const [position, setPosition] = useState({ x: 0, y: 0 });

  return (
    <div
      onClick={(e) => console.log('Click')}
      onDoubleClick={(e) => console.log('Double click')}
      onMouseDown={(e) => console.log('Mouse down')}
      onMouseUp={(e) => console.log('Mouse up')}
      onMouseEnter={(e) => console.log('Mouse enter')}
      onMouseLeave={(e) => console.log('Mouse leave')}
      onMouseMove={(e) => setPosition({ x: e.clientX, y: e.clientY })}
      style={{ height: '200px', border: '1px solid black' }}
    >
      Move mouse here. Position: {position.x}, {position.y}
    </div>
  );
}
```

### Keyboard Events

```jsx
function KeyboardEvents() {
  const [key, setKey] = useState('');

  const handleKeyPress = (e) => {
    setKey(e.key);
    console.log('Key:', e.key);
    console.log('Code:', e.code);
    console.log('Ctrl:', e.ctrlKey);
    console.log('Shift:', e.shiftKey);
    console.log('Alt:', e.altKey);
  };

  return (
    <div>
      <input
        type="text"
        onKeyDown={handleKeyPress}
        onKeyUp={(e) => console.log('Key up:', e.key)}
        placeholder="Type something"
      />
      <p>Last key pressed: {key}</p>
    </div>
  );
}
```

### Form Events

```jsx
function FormEvents() {
  const [value, setValue] = useState('');

  return (
    <form
      onSubmit={(e) => {
        e.preventDefault();
        console.log('Form submitted');
      }}
    >
      <input
        type="text"
        value={value}
        onChange={(e) => setValue(e.target.value)}
        onFocus={() => console.log('Input focused')}
        onBlur={() => console.log('Input blurred')}
      />
      <button type="submit">Submit</button>
    </form>
  );
}
```

### Focus Events

```jsx
function FocusEvents() {
  const [isFocused, setIsFocused] = useState(false);

  return (
    <input
      type="text"
      onFocus={() => setIsFocused(true)}
      onBlur={() => setIsFocused(false)}
      style={{ border: isFocused ? '2px solid blue' : '1px solid gray' }}
      placeholder="Click to focus"
    />
  );
}
```

### Touch Events (Mobile)

```jsx
function TouchEvents() {
  const [touchInfo, setTouchInfo] = useState('');

  return (
    <div
      onTouchStart={(e) => setTouchInfo('Touch started')}
      onTouchMove={(e) => setTouchInfo(`Touch moving: ${e.touches.length} touches`)}
      onTouchEnd={(e) => setTouchInfo('Touch ended')}
      style={{ height: '200px', background: 'lightgreen', padding: '20px' }}
    >
      {touchInfo || 'Touch this area (mobile only)'}
    </div>
  );
}
```

## Preventing Default Behavior

### Preventing Form Submission

```jsx
function LoginForm() {
  const handleSubmit = (e) => {
    e.preventDefault();
    console.log('Form submission prevented');
    // Handle form data here
  };

  return (
    <form onSubmit={handleSubmit}>
      <input type="email" />
      <button type="submit">Submit</button>
    </form>
  );
}
```

### Preventing Link Navigation

```jsx
function CustomLink() {
  const handleClick = (e) => {
    e.preventDefault();
    console.log('Navigation prevented');
    // Custom navigation logic
  };

  return (
    <a href="https://example.com" onClick={handleClick}>
      Click me (won't navigate)
    </a>
  );
}
```

## Event Bubbling and Capturing

### Stopping Propagation

```jsx
function BubblingExample() {
  const handleOuterClick = () => {
    console.log('Outer clicked');
  };

  const handleInnerClick = (e) => {
    e.stopPropagation(); // Stop bubbling to outer div
    console.log('Inner clicked');
  };

  return (
    <div onClick={handleOuterClick} style={{ padding: '20px', background: 'lightblue' }}>
      Outer
      <div onClick={handleInnerClick} style={{ padding: '20px', background: 'lightcoral' }}>
        Inner (click won't bubble)
      </div>
    </div>
  );
}
```

### Capture Phase

```jsx
function CapturePhase() {
  return (
    <div
      onClickCapture={() => console.log('Outer capture')}
      onClick={() => console.log('Outer bubble')}
      style={{ padding: '20px', background: 'lightblue' }}
    >
      Outer
      <button onClick={() => console.log('Button bubble')}>
        Click me
      </button>
    </div>
  );
}
```

## Best Practices

### 1. Use Arrow Functions for Event Handlers

```jsx
// ✅ Good - Arrow function in component
function Counter() {
  const [count, setCount] = useState(0);
  
  const increment = () => setCount(count + 1);
  
  return <button onClick={increment}>Count: {count}</button>;
}

// ❌ Avoid - Inline arrow functions that recreate on every render
function Counter() {
  const [count, setCount] = useState(0);
  
  return (
    <button onClick={() => setCount(count + 1)}>
      Count: {count}
    </button>
  );
}
```

### 2. Avoid Inline Functions in Lists

```jsx
// ✅ Good - Memoized handler
function TodoList({ todos, onDelete }) {
  const handleDelete = useCallback((id) => {
    onDelete(id);
  }, [onDelete]);

  return (
    <ul>
      {todos.map(todo => (
        <TodoItem
          key={todo.id}
          todo={todo}
          onDelete={() => handleDelete(todo.id)}
        />
      ))}
    </ul>
  );
}

// ❌ Avoid - Creates new function for each item on every render
function TodoList({ todos, onDelete }) {
  return (
    <ul>
      {todos.map(todo => (
        <li key={todo.id}>
          {todo.text}
          <button onClick={() => onDelete(todo.id)}>Delete</button>
        </li>
      ))}
    </ul>
  );
}
```

### 3. Name Event Handlers Clearly

```jsx
// ✅ Good - Clear naming convention
function Form() {
  const handleSubmit = (e) => { /* ... */ };
  const handleInputChange = (e) => { /* ... */ };
  const handleCancelClick = () => { /* ... */ };
  
  return (
    <form onSubmit={handleSubmit}>
      <input onChange={handleInputChange} />
      <button onClick={handleCancelClick}>Cancel</button>
    </form>
  );
}
```

### 4. Extract Complex Logic

```jsx
// ✅ Good - Logic extracted to separate function
function ComplexForm() {
  const validateAndSubmit = (data) => {
    // Complex validation logic
    if (!data.email) return;
    // Submit logic
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    const formData = new FormData(e.target);
    validateAndSubmit(Object.fromEntries(formData));
  };

  return <form onSubmit={handleSubmit}>{/* ... */}</form>;
}
```

## Common Patterns

### Debounced Event Handler

```jsx
function SearchInput() {
  const [query, setQuery] = useState('');

  const debouncedSearch = useMemo(
    () => debounce((value) => {
      console.log('Searching for:', value);
      // API call here
    }, 300),
    []
  );

  const handleChange = (e) => {
    const value = e.target.value;
    setQuery(value);
    debouncedSearch(value);
  };

  return <input value={query} onChange={handleChange} placeholder="Search..." />;
}

// Debounce utility
function debounce(func, wait) {
  let timeout;
  return function executedFunction(...args) {
    const later = () => {
      clearTimeout(timeout);
      func(...args);
    };
    clearTimeout(timeout);
    timeout = setTimeout(later, wait);
  };
}
```

### Throttled Event Handler

```jsx
function ScrollTracker() {
  const [scrollPos, setScrollPos] = useState(0);

  useEffect(() => {
    const throttledScroll = throttle(() => {
      setScrollPos(window.scrollY);
    }, 100);

    window.addEventListener('scroll', throttledScroll);
    return () => window.removeEventListener('scroll', throttledScroll);
  }, []);

  return <div>Scroll position: {scrollPos}</div>;
}

// Throttle utility
function throttle(func, limit) {
  let inThrottle;
  return function(...args) {
    if (!inThrottle) {
      func.apply(this, args);
      inThrottle = true;
      setTimeout(() => inThrottle = false, limit);
    }
  };
}
```

### Event Handler with Loading State

```jsx
function AsyncButton() {
  const [loading, setLoading] = useState(false);

  const handleClick = async () => {
    setLoading(true);
    try {
      await fetch('/api/data');
      console.log('Success');
    } catch (error) {
      console.error('Error:', error);
    } finally {
      setLoading(false);
    }
  };

  return (
    <button onClick={handleClick} disabled={loading}>
      {loading ? 'Loading...' : 'Click Me'}
    </button>
  );
}
```

### Conditional Event Handlers

```jsx
function ConditionalButton() {
  const [enabled, setEnabled] = useState(false);

  const handleClick = () => {
    if (!enabled) return;
    console.log('Button action executed');
  };

  return (
    <div>
      <label>
        <input
          type="checkbox"
          checked={enabled}
          onChange={(e) => setEnabled(e.target.checked)}
        />
        Enable button
      </label>
      <button onClick={handleClick} disabled={!enabled}>
        Click Me
      </button>
    </div>
  );
}
```

## Summary

Event handling in React is straightforward but has important differences from vanilla JavaScript:

- Use camelCase naming for events
- Pass function references, not strings
- Leverage synthetic events for cross-browser compatibility
- Use arrow functions to avoid binding issues
- Prevent default behavior with `e.preventDefault()`
- Control event propagation with `e.stopPropagation()`
- Follow best practices to avoid performance issues

Understanding event handling is crucial for creating interactive React applications. Practice with different event types and patterns to become proficient.

---

**Related Topics:**
- [Components](02_COMPONENTS.md)
- [State Management](03_STATE_MANAGEMENT.md)
- [Forms and Inputs](08_FORMS_INPUTS.md)
- [Performance Optimization](14_PERFORMANCE.md)
