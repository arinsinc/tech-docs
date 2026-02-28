# Effects and Lifecycle

## useEffect Hook

The `useEffect` hook lets you perform side effects in functional components. Side effects include data fetching, subscriptions, timers, and manually changing the DOM.

### Basic Syntax

```jsx
import { useEffect } from 'react';

useEffect(() => {
  // Effect code runs after render
  
  return () => {
    // Cleanup code (optional)
  };
}, [/* dependencies */]);
```

### Running Effects

```jsx
function Component() {
  // Runs after every render
  useEffect(() => {
    console.log('Rendered!');
  });
  
  // Runs only once (on mount)
  useEffect(() => {
    console.log('Component mounted!');
  }, []);
  
  // Runs when dependencies change
  useEffect(() => {
    console.log('Count or name changed!');
  }, [count, name]);
}
```

## Common Use Cases

### Data Fetching

```jsx
function UserProfile({ userId }) {
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  
  useEffect(() => {
    setLoading(true);
    
    fetch(`/api/users/${userId}`)
      .then(response => response.json())
      .then(data => {
        setUser(data);
        setLoading(false);
      })
      .catch(err => {
        setError(err.message);
        setLoading(false);
      });
  }, [userId]); // Re-fetch when userId changes
  
  if (loading) return <div>Loading...</div>;
  if (error) return <div>Error: {error}</div>;
  if (!user) return <div>No user found</div>;
  
  return <div>{user.name}</div>;
}
```

### Async/Await Pattern

```jsx
function UserProfile({ userId }) {
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);
  
  useEffect(() => {
    // Can't make useEffect callback async directly
    // Use an inner async function instead
    
    const fetchUser = async () => {
      setLoading(true);
      try {
        const response = await fetch(`/api/users/${userId}`);
        const data = await response.json();
        setUser(data);
      } catch (error) {
        console.error('Failed to fetch:', error);
      } finally {
        setLoading(false);
      }
    };
    
    fetchUser();
  }, [userId]);
  
  return loading ? <div>Loading...</div> : <div>{user?.name}</div>;
}
```

### Subscriptions and Event Listeners

```jsx
function WindowSize() {
  const [size, setSize] = useState({
    width: window.innerWidth,
    height: window.innerHeight
  });
  
  useEffect(() => {
    const handleResize = () => {
      setSize({
        width: window.innerWidth,
        height: window.innerHeight
      });
    };
    
    // Subscribe
    window.addEventListener('resize', handleResize);
    
    // Cleanup: Unsubscribe
    return () => {
      window.removeEventListener('resize', handleResize);
    };
  }, []); // Empty deps = runs once
  
  return <div>{size.width} x {size.height}</div>;
}
```

### Timers

```jsx
function Timer() {
  const [seconds, setSeconds] = useState(0);
  
  useEffect(() => {
    const interval = setInterval(() => {
      setSeconds(prev => prev + 1);
    }, 1000);
    
    // Cleanup: Clear interval
    return () => clearInterval(interval);
  }, []);
  
  return <div>Seconds: {seconds}</div>;
}
```

### Document Title

```jsx
function PageTitle({ title }) {
  useEffect(() => {
    document.title = title;
    
    // Optional: Reset title on unmount
    return () => {
      document.title = 'Default Title';
    };
  }, [title]);
  
  return <h1>{title}</h1>;
}
```

## Cleanup Functions

Cleanup functions prevent memory leaks and unwanted behavior.

```jsx
function ChatRoom({ roomId }) {
  useEffect(() => {
    // Setup
    const connection = createConnection(roomId);
    connection.connect();
    
    // Cleanup runs:
    // 1. Before re-running effect (when deps change)
    // 2. When component unmounts
    return () => {
      connection.disconnect();
    };
  }, [roomId]);
  
  return <div>Room: {roomId}</div>;
}
```

### When Cleanup Runs

```jsx
function Example() {
  useEffect(() => {
    console.log('Effect ran');
    
    return () => {
      console.log('Cleanup ran');
    };
  }, [dependency]);
  
  // Sequence:
  // 1. Component mounts → "Effect ran"
  // 2. dependency changes → "Cleanup ran" → "Effect ran"
  // 3. Component unmounts → "Cleanup ran"
}
```

## Dependency Array

### Empty Dependencies

```jsx
// Runs once on mount
useEffect(() => {
  console.log('Mounted!');
}, []);
```

### No Dependencies

```jsx
// Runs after every render
useEffect(() => {
  console.log('Rendered!');
});
```

### Specific Dependencies

```jsx
// Runs when count or name changes
useEffect(() => {
  console.log('Count or name changed!');
}, [count, name]);
```

### Dependencies Best Practices

```jsx
function SearchResults({ query }) {
  const [results, setResults] = useState([]);
  
  useEffect(() => {
    // ✅ Include all used values from component scope
    searchAPI(query).then(setResults);
  }, [query]); // query is from props
  
  return <div>{results.length} results</div>;
}

// ❌ Wrong: Missing dependencies
function Example() {
  const [count, setCount] = useState(0);
  
  useEffect(() => {
    const id = setInterval(() => {
      setCount(count + 1); // Uses count but not in deps!
    }, 1000);
    return () => clearInterval(id);
  }, []); // Missing count dependency
  
  // ✅ Correct: Use functional update
  useEffect(() => {
    const id = setInterval(() => {
      setCount(c => c + 1); // Doesn't depend on count
    }, 1000);
    return () => clearInterval(id);
  }, []); // Now correct
}
```

## Multiple Effects

Separate concerns into multiple effects.

```jsx
function UserDashboard({ userId }) {
  const [user, setUser] = useState(null);
  const [posts, setPosts] = useState([]);
  
  // Effect 1: Fetch user
  useEffect(() => {
    fetch(`/api/users/${userId}`)
      .then(res => res.json())
      .then(setUser);
  }, [userId]);
  
  // Effect 2: Fetch posts
  useEffect(() => {
    fetch(`/api/users/${userId}/posts`)
      .then(res => res.json())
      .then(setPosts);
  }, [userId]);
  
  // Effect 3: Update document title
  useEffect(() => {
    if (user) {
      document.title = `${user.name}'s Dashboard`;
    }
  }, [user]);
  
  return <div>{/* Render UI */}</div>;
}
```

## Avoiding Infinite Loops

```jsx
// ❌ Infinite loop: Effect updates state, triggering re-render
function BadExample() {
  const [count, setCount] = useState(0);
  
  useEffect(() => {
    setCount(count + 1); // Re-render → Effect runs → Re-render → ...
  }); // No dependency array!
}

// ✅ Fixed: Add dependency array
function GoodExample() {
  const [count, setCount] = useState(0);
  
  useEffect(() => {
    // Only runs once on mount
    setCount(1);
  }, []);
}

// ❌ Infinite loop: Object/array dependency changes every render
function BadExample() {
  const [data, setData] = useState([]);
  
  useEffect(() => {
    const options = { filter: 'active' }; // New object every render!
    fetchData(options).then(setData);
  }, [options]); // options is always different!
}

// ✅ Fixed: Move object outside or use useMemo
function GoodExample() {
  const [data, setData] = useState([]);
  const options = useMemo(() => ({ filter: 'active' }), []);
  
  useEffect(() => {
    fetchData(options).then(setData);
  }, [options]);
}
```

## Component Lifecycle

### Functional Component Lifecycle

```jsx
function Component() {
  // 1. Initial render (mounting)
  useEffect(() => {
    console.log('Component mounted');
    
    // 3. Unmounting
    return () => {
      console.log('Component unmounted');
    };
  }, []);
  
  // 2. Updates (when state/props change)
  useEffect(() => {
    console.log('Component updated');
  });
  
  return <div>Component</div>;
}
```

### Class Component Lifecycle (Legacy)

```jsx
class Component extends React.Component {
  componentDidMount() {
    // After first render
    console.log('Mounted');
  }
  
  componentDidUpdate(prevProps, prevState) {
    // After updates
    if (prevProps.id !== this.props.id) {
      console.log('ID changed');
    }
  }
  
  componentWillUnmount() {
    // Before removal
    console.log('Unmounting');
  }
  
  render() {
    return <div>Component</div>;
  }
}
```

### Mapping Lifecycle to Hooks

```jsx
// componentDidMount
useEffect(() => {
  // Runs once on mount
}, []);

// componentDidUpdate
useEffect(() => {
  // Runs on every update
});

// componentWillUnmount
useEffect(() => {
  return () => {
    // Cleanup on unmount
  };
}, []);

// componentDidUpdate with condition
useEffect(() => {
  // Runs when userId changes
}, [userId]);
```

## Advanced Patterns

### Conditional Effects

```jsx
function Component({ shouldFetch, userId }) {
  useEffect(() => {
    if (!shouldFetch) return;
    
    fetch(`/api/users/${userId}`)
      .then(res => res.json())
      .then(data => console.log(data));
  }, [shouldFetch, userId]);
}
```

### Abort Fetch Requests

```jsx
function SearchResults({ query }) {
  const [results, setResults] = useState([]);
  
  useEffect(() => {
    const controller = new AbortController();
    
    fetch(`/api/search?q=${query}`, {
      signal: controller.signal
    })
      .then(res => res.json())
      .then(setResults)
      .catch(err => {
        if (err.name !== 'AbortError') {
          console.error('Fetch failed:', err);
        }
      });
    
    // Abort on cleanup (when query changes or unmounts)
    return () => controller.abort();
  }, [query]);
  
  return <div>{results.length} results</div>;
}
```

### Custom Effect Hooks

```jsx
function useDocumentTitle(title) {
  useEffect(() => {
    document.title = title;
  }, [title]);
}

function useLocalStorage(key, initialValue) {
  const [value, setValue] = useState(() => {
    const saved = localStorage.getItem(key);
    return saved ? JSON.parse(saved) : initialValue;
  });
  
  useEffect(() => {
    localStorage.setItem(key, JSON.stringify(value));
  }, [key, value]);
  
  return [value, setValue];
}

// Usage
function Component() {
  useDocumentTitle('My Page');
  const [name, setName] = useLocalStorage('name', '');
  
  return <input value={name} onChange={e => setName(e.target.value)} />;
}
```

## Best Practices

1. **One Effect Per Concern**: Separate unrelated logic into different effects
2. **Include All Dependencies**: List everything the effect uses
3. **Clean Up**: Always clean up subscriptions, timers, and listeners
4. **Avoid Objects in Dependencies**: They trigger unnecessary re-runs
5. **Use Functional Updates**: To avoid dependency on state
6. **Be Careful with Async**: Can't make effect callback async

## Common Pitfalls

```jsx
// ❌ Missing cleanup
useEffect(() => {
  const id = setInterval(() => {}, 1000);
  // Missing return () => clearInterval(id);
}, []);

// ❌ Async effect callback
useEffect(async () => { // Error!
  const data = await fetchData();
}, []);

// ✅ Async inside effect
useEffect(() => {
  const fetchData = async () => {
    const data = await fetch('/api/data');
  };
  fetchData();
}, []);

// ❌ Stale closure
const [count, setCount] = useState(0);
useEffect(() => {
  setInterval(() => {
    console.log(count); // Always logs initial value!
  }, 1000);
}, []); // count not in dependencies

// ✅ Use functional update or ref
useEffect(() => {
  setInterval(() => {
    setCount(c => c + 1); // Always gets latest
  }, 1000);
}, []);
```

## Summary

- `useEffect` handles side effects in functional components
- Cleanup functions prevent memory leaks
- Dependency array controls when effects run
- Separate concerns into multiple effects
- Always include all dependencies
- Clean up subscriptions and timers

## Next Steps

Continue to [Event Handling](05_EVENT_HANDLING.md) to learn about handling user interactions in React.
