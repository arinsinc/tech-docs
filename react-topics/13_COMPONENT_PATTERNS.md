# Component Patterns

Advanced React component patterns for building flexible, reusable, and maintainable components.

## Table of Contents
- [Higher-Order Components (HOCs)](#higher-order-components-hocs)
- [Render Props](#render-props)
- [Compound Components](#compound-components)
- [Container/Presentational Pattern](#containerpresentational-pattern)
- [Provider Pattern](#provider-pattern)
- [Controlled vs Uncontrolled](#controlled-vs-uncontrolled)
- [Props Getters](#props-getters)
- [State Reducer Pattern](#state-reducer-pattern)

---

## Higher-Order Components (HOCs)

A Higher-Order Component is a function that takes a component and returns a new enhanced component.

### Basic HOC Pattern

```javascript
function withLoading(Component) {
  return function WithLoadingComponent({ isLoading, ...props }) {
    if (isLoading) {
      return <div>Loading...</div>;
    }
    return <Component {...props} />;
  };
}

// Usage
function UserList({ users }) {
  return (
    <ul>
      {users.map(user => (
        <li key={user.id}>{user.name}</li>
      ))}
    </ul>
  );
}

const UserListWithLoading = withLoading(UserList);

function App() {
  const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(true);
  
  return <UserListWithLoading isLoading={loading} users={users} />;
}
```

### Authentication HOC

```javascript
function withAuth(Component) {
  return function AuthenticatedComponent(props) {
    const { user, loading } = useAuth();
    
    if (loading) {
      return <div>Authenticating...</div>;
    }
    
    if (!user) {
      return <Navigate to="/login" />;
    }
    
    return <Component {...props} user={user} />;
  };
}

// Usage
function Dashboard({ user }) {
  return <div>Welcome, {user.name}!</div>;
}

const ProtectedDashboard = withAuth(Dashboard);
```

### Multiple HOC Composition

```javascript
function withLogger(Component) {
  return function LoggedComponent(props) {
    useEffect(() => {
      console.log('Component mounted:', Component.name);
      return () => console.log('Component unmounted:', Component.name);
    }, []);
    
    return <Component {...props} />;
  };
}

function withErrorBoundary(Component) {
  return class extends React.Component {
    state = { hasError: false };
    
    static getDerivedStateFromError(error) {
      return { hasError: true };
    }
    
    componentDidCatch(error, errorInfo) {
      console.error('Error:', error, errorInfo);
    }
    
    render() {
      if (this.state.hasError) {
        return <div>Something went wrong</div>;
      }
      return <Component {...this.props} />;
    }
  };
}

// Compose multiple HOCs
const EnhancedComponent = withLogger(withErrorBoundary(withAuth(Dashboard)));

// Or use a compose function
function compose(...fns) {
  return (x) => fns.reduceRight((acc, fn) => fn(acc), x);
}

const enhance = compose(withLogger, withErrorBoundary, withAuth);
const EnhancedDashboard = enhance(Dashboard);
```

### HOC Best Practices

```javascript
// ✅ Pass unrelated props through
function withSubscription(Component) {
  return function WrappedComponent({ forwardedRef, ...props }) {
    const data = useSubscription();
    return <Component ref={forwardedRef} data={data} {...props} />;
  };
}

// ✅ Use displayName for debugging
withSubscription.displayName = `withSubscription(${Component.displayName || Component.name})`;

// ✅ Don't mutate the original component
// ❌ Bad
function withSomething(Component) {
  Component.prototype.componentDidUpdate = function() { /* ... */ };
  return Component;
}

// ✅ Good
function withSomething(Component) {
  return class extends Component {
    componentDidUpdate() { /* ... */ }
  };
}
```

---

## Render Props

A component with a render prop takes a function that returns a React element and calls it instead of implementing its own render logic.

### Basic Render Props

```javascript
function Mouse({ render }) {
  const [position, setPosition] = useState({ x: 0, y: 0 });
  
  useEffect(() => {
    const handleMouseMove = (event) => {
      setPosition({ x: event.clientX, y: event.clientY });
    };
    
    window.addEventListener('mousemove', handleMouseMove);
    return () => window.removeEventListener('mousemove', handleMouseMove);
  }, []);
  
  return render(position);
}

// Usage
function App() {
  return (
    <Mouse
      render={({ x, y }) => (
        <h1>Mouse position: {x}, {y}</h1>
      )}
    />
  );
}
```

### Children as Function

```javascript
function DataFetcher({ url, children }) {
  const [data, setData] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  
  useEffect(() => {
    fetch(url)
      .then(res => res.json())
      .then(data => {
        setData(data);
        setLoading(false);
      })
      .catch(err => {
        setError(err);
        setLoading(false);
      });
  }, [url]);
  
  return children({ data, loading, error });
}

// Usage
function UserProfile({ userId }) {
  return (
    <DataFetcher url={`/api/users/${userId}`}>
      {({ data, loading, error }) => {
        if (loading) return <div>Loading...</div>;
        if (error) return <div>Error: {error.message}</div>;
        return <div>User: {data.name}</div>;
      }}
    </DataFetcher>
  );
}
```

### Toggle Component with Render Props

```javascript
function Toggle({ children }) {
  const [on, setOn] = useState(false);
  
  const toggle = () => setOn(!on);
  
  return children({
    on,
    toggle,
    setOn
  });
}

// Usage
function App() {
  return (
    <Toggle>
      {({ on, toggle }) => (
        <div>
          <button onClick={toggle}>
            {on ? 'ON' : 'OFF'}
          </button>
          {on && <div>Content is visible!</div>}
        </div>
      )}
    </Toggle>
  );
}
```

---

## Compound Components

Compound components work together to form a complete UI, sharing implicit state without drilling props.

### Basic Compound Component

```javascript
// Context for sharing state
const TabsContext = React.createContext();

function Tabs({ children, defaultValue }) {
  const [activeTab, setActiveTab] = useState(defaultValue);
  
  return (
    <TabsContext.Provider value={{ activeTab, setActiveTab }}>
      <div className="tabs">{children}</div>
    </TabsContext.Provider>
  );
}

function TabList({ children }) {
  return <div className="tab-list">{children}</div>;
}

function Tab({ value, children }) {
  const { activeTab, setActiveTab } = useContext(TabsContext);
  const isActive = activeTab === value;
  
  return (
    <button
      className={`tab ${isActive ? 'active' : ''}`}
      onClick={() => setActiveTab(value)}
    >
      {children}
    </button>
  );
}

function TabPanels({ children }) {
  return <div className="tab-panels">{children}</div>;
}

function TabPanel({ value, children }) {
  const { activeTab } = useContext(TabsContext);
  
  if (activeTab !== value) return null;
  
  return <div className="tab-panel">{children}</div>;
}

// Compose compound components
Tabs.List = TabList;
Tabs.Tab = Tab;
Tabs.Panels = TabPanels;
Tabs.Panel = TabPanel;

// Usage
function App() {
  return (
    <Tabs defaultValue="profile">
      <Tabs.List>
        <Tabs.Tab value="profile">Profile</Tabs.Tab>
        <Tabs.Tab value="settings">Settings</Tabs.Tab>
        <Tabs.Tab value="notifications">Notifications</Tabs.Tab>
      </Tabs.List>
      
      <Tabs.Panels>
        <Tabs.Panel value="profile">
          <h2>Profile Content</h2>
        </Tabs.Panel>
        <Tabs.Panel value="settings">
          <h2>Settings Content</h2>
        </Tabs.Panel>
        <Tabs.Panel value="notifications">
          <h2>Notifications Content</h2>
        </Tabs.Panel>
      </Tabs.Panels>
    </Tabs>
  );
}
```

### Accordion Compound Component

```javascript
const AccordionContext = React.createContext();

function Accordion({ children, allowMultiple = false }) {
  const [openItems, setOpenItems] = useState([]);
  
  const toggleItem = (value) => {
    if (allowMultiple) {
      setOpenItems(prev =>
        prev.includes(value)
          ? prev.filter(item => item !== value)
          : [...prev, value]
      );
    } else {
      setOpenItems(prev =>
        prev.includes(value) ? [] : [value]
      );
    }
  };
  
  return (
    <AccordionContext.Provider value={{ openItems, toggleItem }}>
      <div className="accordion">{children}</div>
    </AccordionContext.Provider>
  );
}

function AccordionItem({ value, children }) {
  return <div className="accordion-item">{children}</div>;
}

function AccordionTrigger({ value, children }) {
  const { openItems, toggleItem } = useContext(AccordionContext);
  const isOpen = openItems.includes(value);
  
  return (
    <button
      className="accordion-trigger"
      onClick={() => toggleItem(value)}
    >
      {children}
      <span>{isOpen ? '−' : '+'}</span>
    </button>
  );
}

function AccordionContent({ value, children }) {
  const { openItems } = useContext(AccordionContext);
  const isOpen = openItems.includes(value);
  
  if (!isOpen) return null;
  
  return <div className="accordion-content">{children}</div>;
}

Accordion.Item = AccordionItem;
Accordion.Trigger = AccordionTrigger;
Accordion.Content = AccordionContent;

// Usage
function FAQ() {
  return (
    <Accordion allowMultiple>
      <Accordion.Item value="item-1">
        <Accordion.Trigger value="item-1">
          What is React?
        </Accordion.Trigger>
        <Accordion.Content value="item-1">
          React is a JavaScript library for building user interfaces.
        </Accordion.Content>
      </Accordion.Item>
      
      <Accordion.Item value="item-2">
        <Accordion.Trigger value="item-2">
          What are hooks?
        </Accordion.Trigger>
        <Accordion.Content value="item-2">
          Hooks are functions that let you use state and other React features.
        </Accordion.Content>
      </Accordion.Item>
    </Accordion>
  );
}
```

---

## Container/Presentational Pattern

Separate logic (container) from UI (presentational).

### Presentational Component

```javascript
// Pure UI component
function UserListView({ users, loading, error, onUserClick }) {
  if (loading) return <div>Loading users...</div>;
  if (error) return <div>Error: {error}</div>;
  
  return (
    <ul className="user-list">
      {users.map(user => (
        <li key={user.id} onClick={() => onUserClick(user)}>
          <img src={user.avatar} alt={user.name} />
          <div>
            <h3>{user.name}</h3>
            <p>{user.email}</p>
          </div>
        </li>
      ))}
    </ul>
  );
}
```

### Container Component

```javascript
// Logic component
function UserListContainer() {
  const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const navigate = useNavigate();
  
  useEffect(() => {
    fetchUsers()
      .then(data => {
        setUsers(data);
        setLoading(false);
      })
      .catch(err => {
        setError(err.message);
        setLoading(false);
      });
  }, []);
  
  const handleUserClick = (user) => {
    navigate(`/users/${user.id}`);
  };
  
  return (
    <UserListView
      users={users}
      loading={loading}
      error={error}
      onUserClick={handleUserClick}
    />
  );
}
```

### With Custom Hook (Modern Approach)

```javascript
// Extract logic into custom hook
function useUsers() {
  const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  
  useEffect(() => {
    fetchUsers()
      .then(data => {
        setUsers(data);
        setLoading(false);
      })
      .catch(err => {
        setError(err.message);
        setLoading(false);
      });
  }, []);
  
  return { users, loading, error };
}

// Component focuses on UI
function UserList() {
  const { users, loading, error } = useUsers();
  const navigate = useNavigate();
  
  if (loading) return <div>Loading...</div>;
  if (error) return <div>Error: {error}</div>;
  
  return (
    <ul>
      {users.map(user => (
        <li key={user.id} onClick={() => navigate(`/users/${user.id}`)}>
          {user.name}
        </li>
      ))}
    </ul>
  );
}
```

---

## Provider Pattern

Use Context API to provide values to deeply nested components.

### Theme Provider

```javascript
const ThemeContext = React.createContext();

function ThemeProvider({ children }) {
  const [theme, setTheme] = useState('light');
  
  const toggleTheme = () => {
    setTheme(prev => prev === 'light' ? 'dark' : 'light');
  };
  
  const value = {
    theme,
    toggleTheme,
    colors: theme === 'light' 
      ? { bg: '#fff', text: '#000' }
      : { bg: '#000', text: '#fff' }
  };
  
  return (
    <ThemeContext.Provider value={value}>
      {children}
    </ThemeContext.Provider>
  );
}

function useTheme() {
  const context = useContext(ThemeContext);
  if (!context) {
    throw new Error('useTheme must be used within ThemeProvider');
  }
  return context;
}

// Usage
function App() {
  return (
    <ThemeProvider>
      <Header />
      <Main />
      <Footer />
    </ThemeProvider>
  );
}

function Header() {
  const { theme, toggleTheme, colors } = useTheme();
  
  return (
    <header style={{ background: colors.bg, color: colors.text }}>
      <h1>My App</h1>
      <button onClick={toggleTheme}>
        Switch to {theme === 'light' ? 'dark' : 'light'} mode
      </button>
    </header>
  );
}
```

---

## Controlled vs Uncontrolled

### Controlled Components

```javascript
// React controls the value
function ControlledInput() {
  const [value, setValue] = useState('');
  
  return (
    <input
      value={value}
      onChange={(e) => setValue(e.target.value)}
    />
  );
}
```

### Uncontrolled Components

```javascript
// DOM controls the value
function UncontrolledInput() {
  const inputRef = useRef();
  
  const handleSubmit = () => {
    console.log(inputRef.current.value);
  };
  
  return (
    <>
      <input ref={inputRef} defaultValue="Initial" />
      <button onClick={handleSubmit}>Submit</button>
    </>
  );
}
```

### Flexible Component (Both Modes)

```javascript
function FlexibleInput({ value: controlledValue, onChange, defaultValue }) {
  const [internalValue, setInternalValue] = useState(defaultValue || '');
  
  const isControlled = controlledValue !== undefined;
  const value = isControlled ? controlledValue : internalValue;
  
  const handleChange = (e) => {
    if (!isControlled) {
      setInternalValue(e.target.value);
    }
    onChange?.(e);
  };
  
  return <input value={value} onChange={handleChange} />;
}

// Controlled mode
<FlexibleInput value={value} onChange={setValue} />

// Uncontrolled mode
<FlexibleInput defaultValue="Hello" />
```

---

## Props Getters

Provide props bundles for common use cases.

```javascript
function useToggle(initialValue = false) {
  const [on, setOn] = useState(initialValue);
  
  const toggle = () => setOn(prev => !prev);
  
  const getTogglerProps = ({ onClick, ...props } = {}) => ({
    'aria-pressed': on,
    onClick: (...args) => {
      onClick?.(...args);
      toggle();
    },
    ...props
  });
  
  const getContentProps = ({ ...props } = {}) => ({
    'aria-hidden': !on,
    style: { display: on ? 'block' : 'none' },
    ...props
  });
  
  return {
    on,
    toggle,
    getTogglerProps,
    getContentProps
  };
}

// Usage
function Dropdown() {
  const { on, getTogglerProps, getContentProps } = useToggle();
  
  return (
    <div>
      <button {...getTogglerProps()}>
        {on ? 'Hide' : 'Show'} Menu
      </button>
      <ul {...getContentProps()}>
        <li>Item 1</li>
        <li>Item 2</li>
        <li>Item 3</li>
      </ul>
    </div>
  );
}
```

---

## State Reducer Pattern

Allow users to control how state updates happen.

```javascript
function useCounter(initialCount = 0, reducer) {
  const defaultReducer = (state, action) => {
    switch (action.type) {
      case 'increment':
        return { count: state.count + 1 };
      case 'decrement':
        return { count: state.count - 1 };
      default:
        return state;
    }
  };
  
  const [state, dispatch] = useReducer(
    reducer || defaultReducer,
    { count: initialCount }
  );
  
  const increment = () => dispatch({ type: 'increment' });
  const decrement = () => dispatch({ type: 'decrement' });
  
  return { count: state.count, increment, decrement, dispatch };
}

// Usage with custom reducer
function App() {
  const customReducer = (state, action) => {
    switch (action.type) {
      case 'increment':
        // Custom logic: max limit
        return { count: Math.min(state.count + 1, 10) };
      case 'decrement':
        // Custom logic: min limit
        return { count: Math.max(state.count - 1, 0) };
      default:
        return state;
    }
  };
  
  const { count, increment, decrement } = useCounter(0, customReducer);
  
  return (
    <div>
      <p>Count: {count} (limited 0-10)</p>
      <button onClick={increment}>+</button>
      <button onClick={decrement}>-</button>
    </div>
  );
}
```

---

## Key Takeaways

1. **HOCs**: Enhance components with additional functionality
2. **Render Props**: Share code between components using functions
3. **Compound Components**: Build flexible, composable UIs
4. **Container/Presentational**: Separate logic from UI
5. **Provider Pattern**: Share global state without prop drilling
6. **Props Getters**: Bundle related props for common use cases
7. **State Reducer**: Give users control over state updates

## Next Steps

- Explore [Performance Optimization](14_PERFORMANCE.md)
- Learn about [Error Boundaries](15_ERROR_BOUNDARIES.md)
- Study [React Router](16_REACT_ROUTER.md)
