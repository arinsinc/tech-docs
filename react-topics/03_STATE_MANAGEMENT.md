# State Management

## What is State?

State is data that changes over time in a component. When state changes, React re-renders the component.

## useState Hook

The `useState` hook allows functional components to have state.

### Basic Usage

```jsx
import { useState } from 'react';

function Counter() {
  // [currentValue, setterFunction] = useState(initialValue)
  const [count, setCount] = useState(0);
  
  return (
    <div>
      <p>Count: {count}</p>
      <button onClick={() => setCount(count + 1)}>
        Increment
      </button>
    </div>
  );
}
```

### Multiple State Variables

```jsx
function UserForm() {
  const [name, setName] = useState('');
  const [email, setEmail] = useState('');
  const [age, setAge] = useState(0);
  
  return (
    <form>
      <input 
        value={name} 
        onChange={(e) => setName(e.target.value)}
        placeholder="Name"
      />
      <input 
        value={email} 
        onChange={(e) => setEmail(e.target.value)}
        placeholder="Email"
      />
      <input 
        value={age} 
        onChange={(e) => setAge(Number(e.target.value))}
        type="number"
        placeholder="Age"
      />
    </form>
  );
}
```

### Object State

```jsx
function UserProfile() {
  const [user, setUser] = useState({
    name: '',
    email: '',
    age: 0
  });
  
  // Update individual fields
  const updateName = (name) => {
    setUser({ ...user, name });
  };
  
  // Or use a more generic handler
  const handleChange = (field, value) => {
    setUser(prevUser => ({
      ...prevUser,
      [field]: value
    }));
  };
  
  return (
    <form>
      <input 
        value={user.name} 
        onChange={(e) => handleChange('name', e.target.value)}
      />
      <input 
        value={user.email} 
        onChange={(e) => handleChange('email', e.target.value)}
      />
    </form>
  );
}
```

### Array State

```jsx
function TodoList() {
  const [todos, setTodos] = useState([]);
  const [input, setInput] = useState('');
  
  // Add item
  const addTodo = () => {
    setTodos([...todos, { id: Date.now(), text: input, completed: false }]);
    setInput('');
  };
  
  // Remove item
  const removeTodo = (id) => {
    setTodos(todos.filter(todo => todo.id !== id));
  };
  
  // Update item
  const toggleTodo = (id) => {
    setTodos(todos.map(todo =>
      todo.id === id ? { ...todo, completed: !todo.completed } : todo
    ));
  };
  
  return (
    <div>
      <input 
        value={input}
        onChange={(e) => setInput(e.target.value)}
      />
      <button onClick={addTodo}>Add</button>
      
      <ul>
        {todos.map(todo => (
          <li key={todo.id}>
            <input 
              type="checkbox"
              checked={todo.completed}
              onChange={() => toggleTodo(todo.id)}
            />
            <span style={{ 
              textDecoration: todo.completed ? 'line-through' : 'none' 
            }}>
              {todo.text}
            </span>
            <button onClick={() => removeTodo(todo.id)}>Delete</button>
          </li>
        ))}
      </ul>
    </div>
  );
}
```

## State Updates

### Functional Updates

Use functional updates when new state depends on previous state.

```jsx
function Counter() {
  const [count, setCount] = useState(0);
  
  // ❌ May not work correctly with multiple updates
  const increment = () => {
    setCount(count + 1);
    setCount(count + 1); // Still uses old count!
  };
  
  // ✅ Correct: Use functional update
  const increment = () => {
    setCount(prevCount => prevCount + 1);
    setCount(prevCount => prevCount + 1); // Works correctly!
  };
  
  return (
    <div>
      <p>Count: {count}</p>
      <button onClick={increment}>+2</button>
    </div>
  );
}
```

### Batching Updates

React batches multiple state updates for performance.

```jsx
function MultiUpdate() {
  const [count, setCount] = useState(0);
  const [flag, setFlag] = useState(false);
  
  const handleClick = () => {
    // These updates are batched together
    setCount(count + 1);
    setFlag(!flag);
    // Only one re-render occurs
  };
  
  return <button onClick={handleClick}>Update</button>;
}
```

### Asynchronous Nature

State updates are asynchronous.

```jsx
function Counter() {
  const [count, setCount] = useState(0);
  
  const handleClick = () => {
    setCount(count + 1);
    console.log(count); // Still shows old value!
    
    // ✅ Use useEffect to see updated value
  };
  
  return <button onClick={handleClick}>Increment</button>;
}
```

## Lifting State Up

When multiple components need to share state, lift it to their common parent.

```jsx
// ❌ Bad: Duplicated state
function ComponentA() {
  const [value, setValue] = useState('');
  return <input value={value} onChange={(e) => setValue(e.target.value)} />;
}

function ComponentB() {
  const [value, setValue] = useState(''); // Duplicate!
  return <input value={value} onChange={(e) => setValue(e.target.value)} />;
}

// ✅ Good: Shared state in parent
function Parent() {
  const [value, setValue] = useState('');
  
  return (
    <div>
      <ComponentA value={value} onChange={setValue} />
      <ComponentB value={value} onChange={setValue} />
    </div>
  );
}

function ComponentA({ value, onChange }) {
  return <input value={value} onChange={(e) => onChange(e.target.value)} />;
}

function ComponentB({ value, onChange }) {
  return <input value={value} onChange={(e) => onChange(e.target.value)} />;
}
```

## State vs Props

| State | Props |
|-------|-------|
| Managed within component | Passed from parent |
| Mutable (via setState) | Immutable |
| Can change over time | Fixed for a render |
| Private to component | Public interface |

```jsx
// Props: passed from parent
function Child({ message }) {
  return <div>{message}</div>;
}

// State: managed internally
function Parent() {
  const [message, setMessage] = useState('Hello');
  
  return (
    <div>
      <button onClick={() => setMessage('Hi!')}>
        Change Message
      </button>
      <Child message={message} />
    </div>
  );
}
```

## Derived State

Compute values from state instead of storing them.

```jsx
// ❌ Bad: Redundant state
function ShoppingCart() {
  const [items, setItems] = useState([]);
  const [total, setTotal] = useState(0); // Redundant!
  
  const addItem = (item) => {
    setItems([...items, item]);
    setTotal(total + item.price); // Can get out of sync
  };
}

// ✅ Good: Compute derived values
function ShoppingCart() {
  const [items, setItems] = useState([]);
  
  // Compute total from items
  const total = items.reduce((sum, item) => sum + item.price, 0);
  
  const addItem = (item) => {
    setItems([...items, item]);
  };
  
  return (
    <div>
      <p>Total: ${total}</p>
    </div>
  );
}
```

## Lazy Initialization

Use a function for expensive initial state computation.

```jsx
// ❌ Runs on every render
function Component() {
  const [data, setData] = useState(expensiveComputation());
  // expensiveComputation() runs every render!
}

// ✅ Runs only once
function Component() {
  const [data, setData] = useState(() => expensiveComputation());
  // Function runs only on initial render
}

// Example
function TodoApp() {
  const [todos, setTodos] = useState(() => {
    // Only runs once
    const saved = localStorage.getItem('todos');
    return saved ? JSON.parse(saved) : [];
  });
}
```

## State Management Patterns

### Toggle Pattern

```jsx
function Toggle() {
  const [isOn, setIsOn] = useState(false);
  
  const toggle = () => setIsOn(prev => !prev);
  
  return (
    <button onClick={toggle}>
      {isOn ? 'ON' : 'OFF'}
    </button>
  );
}
```

### Form State Pattern

```jsx
function Form() {
  const [formData, setFormData] = useState({
    username: '',
    email: '',
    password: ''
  });
  
  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData(prev => ({
      ...prev,
      [name]: value
    }));
  };
  
  const handleSubmit = (e) => {
    e.preventDefault();
    console.log(formData);
  };
  
  return (
    <form onSubmit={handleSubmit}>
      <input 
        name="username"
        value={formData.username}
        onChange={handleChange}
      />
      <input 
        name="email"
        value={formData.email}
        onChange={handleChange}
      />
      <input 
        name="password"
        type="password"
        value={formData.password}
        onChange={handleChange}
      />
      <button type="submit">Submit</button>
    </form>
  );
}
```

### Loading State Pattern

```jsx
function DataFetcher() {
  const [data, setData] = useState(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);
  
  const fetchData = async () => {
    setLoading(true);
    setError(null);
    
    try {
      const response = await fetch('/api/data');
      const result = await response.json();
      setData(result);
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };
  
  if (loading) return <div>Loading...</div>;
  if (error) return <div>Error: {error}</div>;
  if (!data) return <button onClick={fetchData}>Load Data</button>;
  
  return <div>{JSON.stringify(data)}</div>;
}
```

## Best Practices

1. **Minimize State**: Only store what you need
2. **Derive When Possible**: Compute values instead of storing them
3. **Use Functional Updates**: When new state depends on old state
4. **Group Related State**: Use objects for related values
5. **Lift State Up**: Share state at the lowest common ancestor
6. **Keep State Local**: Don't lift state unnecessarily high

## Common Pitfalls

```jsx
// ❌ Mutating state directly
const [user, setUser] = useState({ name: 'John' });
user.name = 'Jane'; // Bad!

// ✅ Create new object
setUser({ ...user, name: 'Jane' });

// ❌ Using state immediately after setting
const [count, setCount] = useState(0);
setCount(count + 1);
console.log(count); // Still 0!

// ✅ Use previous value in setter or useEffect
setCount(prev => {
  console.log(prev + 1); // Correct new value
  return prev + 1;
});

// ❌ Storing props in state (usually)
function Component({ initialValue }) {
  const [value, setValue] = useState(initialValue);
  // Won't update if initialValue prop changes!
}

// ✅ Use props directly or handle updates
function Component({ value, onChange }) {
  // Controlled component - use props
  return <input value={value} onChange={onChange} />;
}
```

## Summary

- `useState` manages component state
- State updates trigger re-renders
- Use functional updates for dependent state
- Lift state to share between components
- Minimize and derive state when possible
- State is asynchronous and batched

## Next Steps

Continue to [Effects and Lifecycle](04_EFFECTS_LIFECYCLE.md) to learn about side effects and component lifecycle.
