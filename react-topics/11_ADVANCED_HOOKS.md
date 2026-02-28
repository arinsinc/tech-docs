# Advanced Hooks

Advanced React hooks for complex state management, performance optimization, and precise DOM timing control.

## Table of Contents
- [useReducer](#usereducer)
- [useCallback](#usecallback)
- [useMemo](#usememo)
- [useLayoutEffect](#uselayouteffect)
- [Comparison and Best Practices](#comparison-and-best-practices)

---

## useReducer

`useReducer` is an alternative to `useState` for managing complex state logic, especially when state updates depend on previous state or involve multiple sub-values.

### Basic Syntax

```javascript
const [state, dispatch] = useReducer(reducer, initialState);
```

### Simple Counter Example

```javascript
import { useReducer } from 'react';

function counterReducer(state, action) {
  switch (action.type) {
    case 'increment':
      return { count: state.count + 1 };
    case 'decrement':
      return { count: state.count - 1 };
    case 'reset':
      return { count: 0 };
    default:
      throw new Error(`Unknown action: ${action.type}`);
  }
}

function Counter() {
  const [state, dispatch] = useReducer(counterReducer, { count: 0 });

  return (
    <div>
      <p>Count: {state.count}</p>
      <button onClick={() => dispatch({ type: 'increment' })}>+</button>
      <button onClick={() => dispatch({ type: 'decrement' })}>-</button>
      <button onClick={() => dispatch({ type: 'reset' })}>Reset</button>
    </div>
  );
}
```

### Complex Form Management

```javascript
const initialState = {
  username: '',
  email: '',
  password: '',
  errors: {},
  isSubmitting: false
};

function formReducer(state, action) {
  switch (action.type) {
    case 'SET_FIELD':
      return {
        ...state,
        [action.field]: action.value,
        errors: { ...state.errors, [action.field]: null }
      };
    case 'SET_ERRORS':
      return { ...state, errors: action.errors, isSubmitting: false };
    case 'SUBMIT_START':
      return { ...state, isSubmitting: true };
    case 'SUBMIT_SUCCESS':
      return { ...initialState };
    default:
      return state;
  }
}

function RegistrationForm() {
  const [state, dispatch] = useReducer(formReducer, initialState);

  const handleChange = (e) => {
    dispatch({
      type: 'SET_FIELD',
      field: e.target.name,
      value: e.target.value
    });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    dispatch({ type: 'SUBMIT_START' });

    try {
      await registerUser(state);
      dispatch({ type: 'SUBMIT_SUCCESS' });
    } catch (error) {
      dispatch({ type: 'SET_ERRORS', errors: error.errors });
    }
  };

  return (
    <form onSubmit={handleSubmit}>
      <input
        name="username"
        value={state.username}
        onChange={handleChange}
        placeholder="Username"
      />
      {state.errors.username && <span>{state.errors.username}</span>}
      
      <input
        name="email"
        type="email"
        value={state.email}
        onChange={handleChange}
        placeholder="Email"
      />
      {state.errors.email && <span>{state.errors.email}</span>}
      
      <button type="submit" disabled={state.isSubmitting}>
        {state.isSubmitting ? 'Submitting...' : 'Register'}
      </button>
    </form>
  );
}
```

### With Lazy Initialization

```javascript
function init(initialCount) {
  return { count: initialCount };
}

function Counter({ initialCount }) {
  const [state, dispatch] = useReducer(counterReducer, initialCount, init);
  
  return <div>Count: {state.count}</div>;
}
```

---

## useCallback

`useCallback` memoizes callback functions to prevent unnecessary re-renders of child components.

### Basic Syntax

```javascript
const memoizedCallback = useCallback(() => {
  doSomething(a, b);
}, [a, b]);
```

### Without useCallback (Problem)

```javascript
function ParentComponent() {
  const [count, setCount] = useState(0);
  const [text, setText] = useState('');

  // This function is recreated on every render
  const handleClick = () => {
    console.log('Clicked!');
  };

  return (
    <div>
      <input value={text} onChange={(e) => setText(e.target.value)} />
      <p>Count: {count}</p>
      <button onClick={() => setCount(count + 1)}>Increment</button>
      
      {/* ChildComponent re-renders even when only text changes */}
      <ChildComponent onClick={handleClick} />
    </div>
  );
}

const ChildComponent = React.memo(({ onClick }) => {
  console.log('ChildComponent rendered');
  return <button onClick={onClick}>Child Button</button>;
});
```

### With useCallback (Solution)

```javascript
function ParentComponent() {
  const [count, setCount] = useState(0);
  const [text, setText] = useState('');

  // Function is memoized and only recreated when count changes
  const handleClick = useCallback(() => {
    console.log('Clicked with count:', count);
  }, [count]);

  return (
    <div>
      <input value={text} onChange={(e) => setText(e.target.value)} />
      <p>Count: {count}</p>
      <button onClick={() => setCount(count + 1)}>Increment</button>
      
      {/* ChildComponent only re-renders when handleClick changes */}
      <ChildComponent onClick={handleClick} />
    </div>
  );
}
```

### Practical Example: Search with Debounce

```javascript
function SearchComponent() {
  const [query, setQuery] = useState('');
  const [results, setResults] = useState([]);

  const fetchResults = useCallback(async (searchQuery) => {
    if (!searchQuery) {
      setResults([]);
      return;
    }

    const data = await api.search(searchQuery);
    setResults(data);
  }, []);

  const debouncedFetch = useCallback(
    debounce((q) => fetchResults(q), 500),
    [fetchResults]
  );

  const handleChange = (e) => {
    const value = e.target.value;
    setQuery(value);
    debouncedFetch(value);
  };

  return (
    <div>
      <input value={query} onChange={handleChange} />
      <ul>
        {results.map(result => (
          <li key={result.id}>{result.title}</li>
        ))}
      </ul>
    </div>
  );
}
```

---

## useMemo

`useMemo` memoizes expensive computations to avoid recalculating on every render.

### Basic Syntax

```javascript
const memoizedValue = useMemo(() => computeExpensiveValue(a, b), [a, b]);
```

### Expensive Calculation Example

```javascript
function ProductList({ products, filter }) {
  const [sortOrder, setSortOrder] = useState('asc');

  // Without useMemo, this runs on every render
  const filteredAndSortedProducts = useMemo(() => {
    console.log('Computing filtered products...');
    
    let filtered = products.filter(p => 
      p.name.toLowerCase().includes(filter.toLowerCase())
    );
    
    return filtered.sort((a, b) => {
      if (sortOrder === 'asc') {
        return a.price - b.price;
      }
      return b.price - a.price;
    });
  }, [products, filter, sortOrder]);

  return (
    <div>
      <button onClick={() => setSortOrder(sortOrder === 'asc' ? 'desc' : 'asc')}>
        Toggle Sort
      </button>
      <ul>
        {filteredAndSortedProducts.map(product => (
          <li key={product.id}>
            {product.name} - ${product.price}
          </li>
        ))}
      </ul>
    </div>
  );
}
```

### Referential Equality

```javascript
function UserProfile({ userId }) {
  const [userData, setUserData] = useState(null);

  // This object would be recreated on every render without useMemo
  const userConfig = useMemo(() => ({
    id: userId,
    settings: {
      theme: 'dark',
      notifications: true
    }
  }), [userId]);

  useEffect(() => {
    // This effect only runs when userConfig actually changes
    fetchUserData(userConfig).then(setUserData);
  }, [userConfig]);

  return <div>{userData?.name}</div>;
}
```

### Complex Derivation

```javascript
function DataVisualization({ data }) {
  const statistics = useMemo(() => {
    const sum = data.reduce((acc, val) => acc + val, 0);
    const mean = sum / data.length;
    const sorted = [...data].sort((a, b) => a - b);
    const median = sorted[Math.floor(sorted.length / 2)];
    const variance = data.reduce((acc, val) => 
      acc + Math.pow(val - mean, 2), 0) / data.length;
    const stdDev = Math.sqrt(variance);

    return { sum, mean, median, variance, stdDev };
  }, [data]);

  return (
    <div>
      <p>Mean: {statistics.mean.toFixed(2)}</p>
      <p>Median: {statistics.median.toFixed(2)}</p>
      <p>Std Dev: {statistics.stdDev.toFixed(2)}</p>
    </div>
  );
}
```

---

## useLayoutEffect

`useLayoutEffect` runs synchronously after DOM mutations but before the browser paints. Use it when you need to measure or mutate the DOM before the user sees it.

### Basic Syntax

```javascript
useLayoutEffect(() => {
  // Runs synchronously after DOM updates
  return () => {
    // Cleanup
  };
}, [dependencies]);
```

### Difference from useEffect

```javascript
// useEffect: Runs AFTER paint (asynchronous)
// User might see a flash of unstyled content

// useLayoutEffect: Runs BEFORE paint (synchronous)
// User sees final state immediately
```

### Measuring DOM Elements

```javascript
function TooltipButton() {
  const [tooltipHeight, setTooltipHeight] = useState(0);
  const [showTooltip, setShowTooltip] = useState(false);
  const tooltipRef = useRef(null);

  useLayoutEffect(() => {
    if (showTooltip && tooltipRef.current) {
      const height = tooltipRef.current.getBoundingClientRect().height;
      setTooltipHeight(height);
    }
  }, [showTooltip]);

  return (
    <div>
      <button onClick={() => setShowTooltip(!showTooltip)}>
        Show Tooltip
      </button>
      {showTooltip && (
        <div
          ref={tooltipRef}
          style={{
            position: 'absolute',
            top: `-${tooltipHeight + 10}px`
          }}
        >
          Tooltip content
        </div>
      )}
    </div>
  );
}
```

### Scroll Position Restoration

```javascript
function ChatMessages({ messages }) {
  const messagesEndRef = useRef(null);
  const [shouldScrollToBottom, setShouldScrollToBottom] = useState(true);

  useLayoutEffect(() => {
    if (shouldScrollToBottom && messagesEndRef.current) {
      messagesEndRef.current.scrollIntoView({ behavior: 'smooth' });
    }
  }, [messages, shouldScrollToBottom]);

  return (
    <div>
      {messages.map(msg => (
        <div key={msg.id}>{msg.text}</div>
      ))}
      <div ref={messagesEndRef} />
    </div>
  );
}
```

### DOM Mutation Before Paint

```javascript
function AnimatedBox() {
  const boxRef = useRef(null);

  useLayoutEffect(() => {
    // This runs before paint, preventing flicker
    if (boxRef.current) {
      const box = boxRef.current;
      const randomColor = `#${Math.floor(Math.random()*16777215).toString(16)}`;
      box.style.backgroundColor = randomColor;
    }
  });

  return <div ref={boxRef} style={{ width: 100, height: 100 }} />;
}
```

---

## Comparison and Best Practices

### When to Use Each Hook

| Hook | Use Case | Performance Impact |
|------|----------|-------------------|
| `useReducer` | Complex state logic, multiple sub-values | None |
| `useCallback` | Preventing child re-renders, stable refs | Minimal overhead |
| `useMemo` | Expensive computations, referential equality | Minimal overhead |
| `useLayoutEffect` | DOM measurements, preventing flicker | Blocks painting |

### useReducer vs useState

**Use `useState` when:**
```javascript
// Simple, independent state
const [count, setCount] = useState(0);
const [name, setName] = useState('');
```

**Use `useReducer` when:**
```javascript
// Complex state with related fields
const [state, dispatch] = useReducer(reducer, {
  user: null,
  isLoading: false,
  error: null,
  posts: []
});

// State transitions depend on previous state
dispatch({ type: 'FETCH_SUCCESS', payload: data });
```

### useCallback vs useMemo

```javascript
// useCallback: Memoizes the function itself
const handleClick = useCallback(() => {
  doSomething();
}, []);

// useMemo: Memoizes the return value
const value = useMemo(() => {
  return computeExpensiveValue();
}, []);

// They're related:
const callback = useCallback(fn, deps);
// is equivalent to:
const callback = useMemo(() => fn, deps);
```

### useEffect vs useLayoutEffect

```javascript
// useEffect: Default choice (99% of cases)
useEffect(() => {
  // Fetch data, subscribe to events, update state
}, []);

// useLayoutEffect: Only when you need synchronous DOM access
useLayoutEffect(() => {
  // Measure DOM, prevent visual flicker
  const height = ref.current.offsetHeight;
}, []);
```

### Performance Best Practices

```javascript
// ❌ Don't: Overuse memoization
const trivialValue = useMemo(() => a + b, [a, b]); // Overkill

// ✅ Do: Use when computation is expensive
const expensiveValue = useMemo(() => {
  return heavyCalculation(data);
}, [data]);

// ❌ Don't: Wrap every function
const handleClick = useCallback(() => console.log('hi'), []);

// ✅ Do: Use when passing to memoized children
const MemoizedChild = React.memo(Child);
const handleClick = useCallback(() => doSomething(), []);
<MemoizedChild onClick={handleClick} />

// ❌ Don't: Premature optimization
// ✅ Do: Profile first, optimize second
```

### Common Patterns

#### Combining Multiple Hooks

```javascript
function DataTable({ data, filters }) {
  // Complex filtering logic
  const [state, dispatch] = useReducer(tableReducer, initialState);
  
  // Memoized filtered data
  const filteredData = useMemo(() => {
    return data.filter(item => matchesFilters(item, filters));
  }, [data, filters]);
  
  // Memoized callback for row clicks
  const handleRowClick = useCallback((rowId) => {
    dispatch({ type: 'SELECT_ROW', payload: rowId });
  }, []);
  
  // Layout effect for scroll restoration
  useLayoutEffect(() => {
    if (state.scrollPosition) {
      window.scrollTo(0, state.scrollPosition);
    }
  }, [state.scrollPosition]);
  
  return (
    <table>
      {filteredData.map(row => (
        <tr key={row.id} onClick={() => handleRowClick(row.id)}>
          <td>{row.name}</td>
        </tr>
      ))}
    </table>
  );
}
```

---

## Key Takeaways

1. **useReducer**: Better than useState for complex state logic
2. **useCallback**: Prevents function recreation, optimizes child components
3. **useMemo**: Prevents expensive recalculations
4. **useLayoutEffect**: For synchronous DOM operations before paint

Remember: **Don't optimize prematurely!** Start with simple hooks and add optimization only when you have performance issues.

## Next Steps

- Learn about [Custom Hooks](12_CUSTOM_HOOKS.md)
- Explore [Component Patterns](13_COMPONENT_PATTERNS.md)
- Master [Performance Optimization](14_PERFORMANCE.md)
