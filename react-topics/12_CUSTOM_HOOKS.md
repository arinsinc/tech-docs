# Custom Hooks

Custom hooks allow you to extract component logic into reusable functions, promoting code reuse and separation of concerns.

## Table of Contents
- [Introduction to Custom Hooks](#introduction-to-custom-hooks)
- [Basic Custom Hooks](#basic-custom-hooks)
- [Advanced Custom Hooks](#advanced-custom-hooks)
- [Custom Hook Patterns](#custom-hook-patterns)
- [Testing Custom Hooks](#testing-custom-hooks)
- [Best Practices](#best-practices)

---

## Introduction to Custom Hooks

Custom hooks are JavaScript functions whose names start with "use" and that may call other hooks.

### Rules of Custom Hooks

1. **Name must start with "use"**: `useCustomHook`
2. **Can call other hooks**: useState, useEffect, etc.
3. **Must follow hook rules**: Only call at top level, only in React functions
4. **Each call has isolated state**: Different component instances don't share state

### Basic Structure

```javascript
function useCustomHook(initialValue) {
  // Use built-in hooks
  const [state, setState] = useState(initialValue);
  
  // Add custom logic
  const doSomething = () => {
    setState(newValue);
  };
  
  // Return values/functions
  return [state, doSomething];
}
```

---

## Basic Custom Hooks

### useToggle

Toggle between true/false states.

```javascript
function useToggle(initialValue = false) {
  const [value, setValue] = useState(initialValue);
  
  const toggle = useCallback(() => {
    setValue(v => !v);
  }, []);
  
  return [value, toggle];
}

// Usage
function Modal() {
  const [isOpen, toggleOpen] = useToggle(false);
  
  return (
    <>
      <button onClick={toggleOpen}>Open Modal</button>
      {isOpen && (
        <div className="modal">
          <p>Modal Content</p>
          <button onClick={toggleOpen}>Close</button>
        </div>
      )}
    </>
  );
}
```

### useLocalStorage

Sync state with localStorage.

```javascript
function useLocalStorage(key, initialValue) {
  // Get stored value or use initial value
  const [storedValue, setStoredValue] = useState(() => {
    try {
      const item = window.localStorage.getItem(key);
      return item ? JSON.parse(item) : initialValue;
    } catch (error) {
      console.error(error);
      return initialValue;
    }
  });
  
  // Return wrapped version of setState
  const setValue = (value) => {
    try {
      // Allow value to be a function
      const valueToStore = value instanceof Function 
        ? value(storedValue) 
        : value;
      
      setStoredValue(valueToStore);
      window.localStorage.setItem(key, JSON.stringify(valueToStore));
    } catch (error) {
      console.error(error);
    }
  };
  
  return [storedValue, setValue];
}

// Usage
function UserSettings() {
  const [theme, setTheme] = useLocalStorage('theme', 'light');
  
  return (
    <div className={`app ${theme}`}>
      <button onClick={() => setTheme(theme === 'light' ? 'dark' : 'light')}>
        Toggle Theme
      </button>
    </div>
  );
}
```

### usePrevious

Track previous value of a prop or state.

```javascript
function usePrevious(value) {
  const ref = useRef();
  
  useEffect(() => {
    ref.current = value;
  }, [value]);
  
  return ref.current;
}

// Usage
function Counter() {
  const [count, setCount] = useState(0);
  const prevCount = usePrevious(count);
  
  return (
    <div>
      <p>Current: {count}</p>
      <p>Previous: {prevCount}</p>
      <button onClick={() => setCount(count + 1)}>Increment</button>
    </div>
  );
}
```

### useDebounce

Debounce a value.

```javascript
function useDebounce(value, delay) {
  const [debouncedValue, setDebouncedValue] = useState(value);
  
  useEffect(() => {
    const handler = setTimeout(() => {
      setDebouncedValue(value);
    }, delay);
    
    return () => {
      clearTimeout(handler);
    };
  }, [value, delay]);
  
  return debouncedValue;
}

// Usage
function SearchBox() {
  const [searchTerm, setSearchTerm] = useState('');
  const debouncedSearchTerm = useDebounce(searchTerm, 500);
  
  useEffect(() => {
    if (debouncedSearchTerm) {
      // Make API call
      searchAPI(debouncedSearchTerm).then(setResults);
    }
  }, [debouncedSearchTerm]);
  
  return (
    <input
      value={searchTerm}
      onChange={(e) => setSearchTerm(e.target.value)}
      placeholder="Search..."
    />
  );
}
```

---

## Advanced Custom Hooks

### useFetch

Generic data fetching hook.

```javascript
function useFetch(url, options = {}) {
  const [data, setData] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  
  useEffect(() => {
    let isCancelled = false;
    
    const fetchData = async () => {
      setLoading(true);
      
      try {
        const response = await fetch(url, options);
        
        if (!response.ok) {
          throw new Error(`HTTP error! status: ${response.status}`);
        }
        
        const json = await response.json();
        
        if (!isCancelled) {
          setData(json);
          setError(null);
        }
      } catch (e) {
        if (!isCancelled) {
          setError(e.message);
          setData(null);
        }
      } finally {
        if (!isCancelled) {
          setLoading(false);
        }
      }
    };
    
    fetchData();
    
    return () => {
      isCancelled = true;
    };
  }, [url]);
  
  return { data, loading, error };
}

// Usage
function UserProfile({ userId }) {
  const { data: user, loading, error } = useFetch(
    `https://api.example.com/users/${userId}`
  );
  
  if (loading) return <div>Loading...</div>;
  if (error) return <div>Error: {error}</div>;
  
  return (
    <div>
      <h1>{user.name}</h1>
      <p>{user.email}</p>
    </div>
  );
}
```

### useAsync

Handle async operations with state management.

```javascript
function useAsync(asyncFunction, immediate = true) {
  const [status, setStatus] = useState('idle');
  const [value, setValue] = useState(null);
  const [error, setError] = useState(null);
  
  const execute = useCallback(async (...args) => {
    setStatus('pending');
    setValue(null);
    setError(null);
    
    try {
      const response = await asyncFunction(...args);
      setValue(response);
      setStatus('success');
      return response;
    } catch (error) {
      setError(error);
      setStatus('error');
      throw error;
    }
  }, [asyncFunction]);
  
  useEffect(() => {
    if (immediate) {
      execute();
    }
  }, [execute, immediate]);
  
  return { execute, status, value, error };
}

// Usage
function UserData() {
  const fetchUser = async () => {
    const response = await fetch('/api/user');
    return response.json();
  };
  
  const { execute, status, value, error } = useAsync(fetchUser);
  
  return (
    <div>
      {status === 'idle' && <div>Ready to fetch</div>}
      {status === 'pending' && <div>Loading...</div>}
      {status === 'success' && <div>User: {value.name}</div>}
      {status === 'error' && <div>Error: {error.message}</div>}
      <button onClick={execute}>Refetch</button>
    </div>
  );
}
```

### useIntersectionObserver

Detect when an element is visible.

```javascript
function useIntersectionObserver(
  elementRef,
  { threshold = 0, root = null, rootMargin = '0%' }
) {
  const [entry, setEntry] = useState(null);
  
  useEffect(() => {
    const element = elementRef.current;
    if (!element) return;
    
    const observer = new IntersectionObserver(
      ([entry]) => setEntry(entry),
      { threshold, root, rootMargin }
    );
    
    observer.observe(element);
    
    return () => observer.disconnect();
  }, [elementRef, threshold, root, rootMargin]);
  
  return entry;
}

// Usage
function LazyImage({ src, alt }) {
  const imageRef = useRef();
  const entry = useIntersectionObserver(imageRef, { threshold: 0.1 });
  const isVisible = entry?.isIntersecting;
  
  return (
    <div ref={imageRef}>
      {isVisible ? (
        <img src={src} alt={alt} />
      ) : (
        <div>Loading...</div>
      )}
    </div>
  );
}
```

### useWindowSize

Track window dimensions.

```javascript
function useWindowSize() {
  const [windowSize, setWindowSize] = useState({
    width: undefined,
    height: undefined,
  });
  
  useEffect(() => {
    function handleResize() {
      setWindowSize({
        width: window.innerWidth,
        height: window.innerHeight,
      });
    }
    
    window.addEventListener('resize', handleResize);
    handleResize(); // Call once to set initial size
    
    return () => window.removeEventListener('resize', handleResize);
  }, []);
  
  return windowSize;
}

// Usage
function ResponsiveComponent() {
  const { width } = useWindowSize();
  
  return (
    <div>
      {width < 768 ? (
        <MobileLayout />
      ) : (
        <DesktopLayout />
      )}
    </div>
  );
}
```

### useOnClickOutside

Detect clicks outside an element.

```javascript
function useOnClickOutside(ref, handler) {
  useEffect(() => {
    const listener = (event) => {
      if (!ref.current || ref.current.contains(event.target)) {
        return;
      }
      handler(event);
    };
    
    document.addEventListener('mousedown', listener);
    document.addEventListener('touchstart', listener);
    
    return () => {
      document.removeEventListener('mousedown', listener);
      document.removeEventListener('touchstart', listener);
    };
  }, [ref, handler]);
}

// Usage
function Dropdown() {
  const [isOpen, setIsOpen] = useState(false);
  const dropdownRef = useRef();
  
  useOnClickOutside(dropdownRef, () => setIsOpen(false));
  
  return (
    <div ref={dropdownRef}>
      <button onClick={() => setIsOpen(!isOpen)}>Toggle</button>
      {isOpen && (
        <div className="dropdown-menu">
          <p>Menu Item 1</p>
          <p>Menu Item 2</p>
        </div>
      )}
    </div>
  );
}
```

---

## Custom Hook Patterns

### Compound Hooks

Combine multiple hooks for complex logic.

```javascript
function useForm(initialValues, validate) {
  const [values, setValues] = useState(initialValues);
  const [errors, setErrors] = useState({});
  const [touched, setTouched] = useState({});
  const [isSubmitting, setIsSubmitting] = useState(false);
  
  const handleChange = (e) => {
    const { name, value } = e.target;
    setValues(prev => ({ ...prev, [name]: value }));
  };
  
  const handleBlur = (e) => {
    const { name } = e.target;
    setTouched(prev => ({ ...prev, [name]: true }));
    
    if (validate) {
      const fieldErrors = validate({ ...values, [name]: e.target.value });
      setErrors(prev => ({ ...prev, [name]: fieldErrors[name] }));
    }
  };
  
  const handleSubmit = async (onSubmit) => {
    return async (e) => {
      e.preventDefault();
      
      if (validate) {
        const validationErrors = validate(values);
        setErrors(validationErrors);
        
        if (Object.keys(validationErrors).length > 0) {
          return;
        }
      }
      
      setIsSubmitting(true);
      try {
        await onSubmit(values);
      } catch (error) {
        console.error(error);
      } finally {
        setIsSubmitting(false);
      }
    };
  };
  
  const reset = () => {
    setValues(initialValues);
    setErrors({});
    setTouched({});
    setIsSubmitting(false);
  };
  
  return {
    values,
    errors,
    touched,
    isSubmitting,
    handleChange,
    handleBlur,
    handleSubmit,
    reset,
  };
}

// Usage
function ContactForm() {
  const validate = (values) => {
    const errors = {};
    if (!values.email) errors.email = 'Required';
    if (!values.message) errors.message = 'Required';
    return errors;
  };
  
  const { values, errors, touched, handleChange, handleBlur, handleSubmit } = 
    useForm({ email: '', message: '' }, validate);
  
  const onSubmit = async (values) => {
    await api.sendMessage(values);
    alert('Message sent!');
  };
  
  return (
    <form onSubmit={handleSubmit(onSubmit)}>
      <input
        name="email"
        value={values.email}
        onChange={handleChange}
        onBlur={handleBlur}
      />
      {touched.email && errors.email && <span>{errors.email}</span>}
      
      <textarea
        name="message"
        value={values.message}
        onChange={handleChange}
        onBlur={handleBlur}
      />
      {touched.message && errors.message && <span>{errors.message}</span>}
      
      <button type="submit">Send</button>
    </form>
  );
}
```

### Hooks with Reducers

```javascript
function useUndoable(initialState) {
  const [state, setState] = useState({
    past: [],
    present: initialState,
    future: []
  });
  
  const canUndo = state.past.length > 0;
  const canRedo = state.future.length > 0;
  
  const set = (newPresent) => {
    setState(prevState => ({
      past: [...prevState.past, prevState.present],
      present: newPresent,
      future: []
    }));
  };
  
  const undo = () => {
    setState(prevState => {
      if (prevState.past.length === 0) return prevState;
      
      const previous = prevState.past[prevState.past.length - 1];
      const newPast = prevState.past.slice(0, prevState.past.length - 1);
      
      return {
        past: newPast,
        present: previous,
        future: [prevState.present, ...prevState.future]
      };
    });
  };
  
  const redo = () => {
    setState(prevState => {
      if (prevState.future.length === 0) return prevState;
      
      const next = prevState.future[0];
      const newFuture = prevState.future.slice(1);
      
      return {
        past: [...prevState.past, prevState.present],
        present: next,
        future: newFuture
      };
    });
  };
  
  const reset = (newPresent) => {
    setState({
      past: [],
      present: newPresent,
      future: []
    });
  };
  
  return [state.present, set, { undo, redo, canUndo, canRedo, reset }];
}

// Usage
function DrawingApp() {
  const [drawing, setDrawing, { undo, redo, canUndo, canRedo }] = 
    useUndoable([]);
  
  const addLine = (line) => {
    setDrawing([...drawing, line]);
  };
  
  return (
    <div>
      <button onClick={undo} disabled={!canUndo}>Undo</button>
      <button onClick={redo} disabled={!canRedo}>Redo</button>
      <Canvas lines={drawing} onAddLine={addLine} />
    </div>
  );
}
```

---

## Testing Custom Hooks

### Using @testing-library/react-hooks

```javascript
import { renderHook, act } from '@testing-library/react-hooks';
import useCounter from './useCounter';

describe('useCounter', () => {
  it('should initialize with default value', () => {
    const { result } = renderHook(() => useCounter(0));
    expect(result.current.count).toBe(0);
  });
  
  it('should increment counter', () => {
    const { result } = renderHook(() => useCounter(0));
    
    act(() => {
      result.current.increment();
    });
    
    expect(result.current.count).toBe(1);
  });
  
  it('should decrement counter', () => {
    const { result } = renderHook(() => useCounter(5));
    
    act(() => {
      result.current.decrement();
    });
    
    expect(result.current.count).toBe(4);
  });
});
```

### Testing Async Hooks

```javascript
import { renderHook, waitFor } from '@testing-library/react-hooks';
import useFetch from './useFetch';

describe('useFetch', () => {
  it('should fetch data successfully', async () => {
    const mockData = { name: 'John' };
    global.fetch = jest.fn(() =>
      Promise.resolve({
        ok: true,
        json: () => Promise.resolve(mockData),
      })
    );
    
    const { result } = renderHook(() => useFetch('/api/user'));
    
    expect(result.current.loading).toBe(true);
    
    await waitFor(() => expect(result.current.loading).toBe(false));
    
    expect(result.current.data).toEqual(mockData);
    expect(result.current.error).toBe(null);
  });
});
```

---

## Best Practices

### 1. Single Responsibility

```javascript
// ❌ Bad: Hook does too many things
function useEverything() {
  const [user, setUser] = useState(null);
  const [theme, setTheme] = useState('light');
  const [cart, setCart] = useState([]);
  // ... more unrelated state
}

// ✅ Good: Separate hooks for separate concerns
function useUser() { /* ... */ }
function useTheme() { /* ... */ }
function useCart() { /* ... */ }
```

### 2. Return Consistent API

```javascript
// ✅ Array destructuring for simple hooks
const [value, setValue] = useState(0);
const [isOpen, toggle] = useToggle(false);

// ✅ Object destructuring for complex hooks
const { data, loading, error, refetch } = useFetch(url);
```

### 3. Handle Cleanup

```javascript
function useEventListener(eventName, handler, element = window) {
  const savedHandler = useRef();
  
  useEffect(() => {
    savedHandler.current = handler;
  }, [handler]);
  
  useEffect(() => {
    const isSupported = element && element.addEventListener;
    if (!isSupported) return;
    
    const eventListener = (event) => savedHandler.current(event);
    element.addEventListener(eventName, eventListener);
    
    // Cleanup
    return () => {
      element.removeEventListener(eventName, eventListener);
    };
  }, [eventName, element]);
}
```

### 4. Provide TypeScript Types

```typescript
function useLocalStorage<T>(
  key: string,
  initialValue: T
): [T, (value: T) => void] {
  // Implementation
}
```

### 5. Document Your Hooks

```javascript
/**
 * Custom hook for debouncing a value
 * @param {any} value - The value to debounce
 * @param {number} delay - Delay in milliseconds
 * @returns {any} The debounced value
 * 
 * @example
 * const debouncedSearch = useDebounce(searchTerm, 500);
 */
function useDebounce(value, delay) {
  // Implementation
}
```

---

## Key Takeaways

1. **Reusability**: Extract common logic into custom hooks
2. **Naming**: Always prefix with "use"
3. **Composition**: Build complex hooks from simple ones
4. **Testing**: Test hooks in isolation
5. **Documentation**: Document parameters and return values

## Next Steps

- Explore [Component Patterns](13_COMPONENT_PATTERNS.md)
- Learn about [Performance Optimization](14_PERFORMANCE.md)
- Study [Error Boundaries](15_ERROR_BOUNDARIES.md)
