# Context API in React

## Table of Contents
- [Introduction](#introduction)
- [When to Use Context](#when-to-use-context)
- [Creating Context](#creating-context)
- [useContext Hook](#usecontext-hook)
- [Provider Pattern](#provider-pattern)
- [Multiple Contexts](#multiple-contexts)
- [Context with useReducer](#context-with-usereducer)
- [Performance Optimization](#performance-optimization)
- [Best Practices](#best-practices)
- [Common Patterns](#common-patterns)

## Introduction

The Context API provides a way to pass data through the component tree without having to pass props down manually at every level. It's designed to share data that can be considered "global" for a tree of React components.

### What is Context?

Context provides a way to share values between components without explicitly passing props through every level of the tree. This solves the "prop drilling" problem.

```jsx
// Without Context - Prop Drilling
function App() {
  const user = { name: 'Alice', role: 'admin' };
  return <Parent user={user} />;
}

function Parent({ user }) {
  return <Child user={user} />;
}

function Child({ user }) {
  return <GrandChild user={user} />;
}

function GrandChild({ user }) {
  return <div>{user.name}</div>;
}

// With Context - Direct Access
const UserContext = createContext();

function App() {
  const user = { name: 'Alice', role: 'admin' };
  return (
    <UserContext.Provider value={user}>
      <Parent />
    </UserContext.Provider>
  );
}

function GrandChild() {
  const user = useContext(UserContext);
  return <div>{user.name}</div>;
}
```

## When to Use Context

### Good Use Cases

✅ **Theme Settings**
```jsx
const ThemeContext = createContext();

function App() {
  const [theme, setTheme] = useState('light');
  
  return (
    <ThemeContext.Provider value={{ theme, setTheme }}>
      <Header />
      <Content />
      <Footer />
    </ThemeContext.Provider>
  );
}
```

✅ **Authentication State**
```jsx
const AuthContext = createContext();

function App() {
  const [user, setUser] = useState(null);
  
  return (
    <AuthContext.Provider value={{ user, setUser }}>
      <Navigation />
      <MainContent />
    </AuthContext.Provider>
  );
}
```

✅ **Localization/Internationalization**
```jsx
const LanguageContext = createContext();

function App() {
  const [language, setLanguage] = useState('en');
  
  return (
    <LanguageContext.Provider value={{ language, setLanguage }}>
      <AppContent />
    </LanguageContext.Provider>
  );
}
```

### When NOT to Use Context

❌ **Frequent Updates** - Context causes all consumers to re-render

❌ **Local Component State** - Use regular state for component-specific data

❌ **Complex State Logic** - Consider state management libraries like Redux

## Creating Context

### Basic Context Creation

```jsx
import { createContext } from 'react';

// Create context with default value
const ThemeContext = createContext('light');

function App() {
  return (
    <ThemeContext.Provider value="dark">
      <Toolbar />
    </ThemeContext.Provider>
  );
}

function Toolbar() {
  return <ThemedButton />;
}

function ThemedButton() {
  const theme = useContext(ThemeContext);
  return <button className={theme}>Themed Button</button>;
}
```

### Context with Object Values

```jsx
const UserContext = createContext();

function App() {
  const [user, setUser] = useState({
    name: 'John Doe',
    email: 'john@example.com',
    isLoggedIn: false
  });

  return (
    <UserContext.Provider value={{ user, setUser }}>
      <Dashboard />
    </UserContext.Provider>
  );
}
```

### Context with Default Values

```jsx
// Default value is used when no Provider is found
const ThemeContext = createContext({
  theme: 'light',
  toggleTheme: () => {}
});

// Component can use context even without Provider
function ThemedComponent() {
  const { theme } = useContext(ThemeContext);
  return <div>Theme: {theme}</div>;
}
```

## useContext Hook

### Basic Usage

```jsx
const ThemeContext = createContext();

function ThemedButton() {
  const theme = useContext(ThemeContext);
  
  return (
    <button style={{ background: theme === 'dark' ? '#333' : '#fff' }}>
      Click me
    </button>
  );
}

function App() {
  const [theme, setTheme] = useState('light');
  
  return (
    <ThemeContext.Provider value={theme}>
      <ThemedButton />
    </ThemeContext.Provider>
  );
}
```

### Consuming Multiple Values

```jsx
const UserContext = createContext();

function UserProfile() {
  const { user, updateUser, logout } = useContext(UserContext);
  
  return (
    <div>
      <h1>{user.name}</h1>
      <p>{user.email}</p>
      <button onClick={logout}>Logout</button>
    </div>
  );
}
```

### Conditional Context Usage

```jsx
const UserContext = createContext();

function UserGreeting() {
  const user = useContext(UserContext);
  
  if (!user) {
    return <div>Please log in</div>;
  }
  
  return <div>Welcome, {user.name}!</div>;
}
```

## Provider Pattern

### Basic Provider

```jsx
const ThemeContext = createContext();

function ThemeProvider({ children }) {
  const [theme, setTheme] = useState('light');
  
  const toggleTheme = () => {
    setTheme(prev => prev === 'light' ? 'dark' : 'light');
  };
  
  return (
    <ThemeContext.Provider value={{ theme, toggleTheme }}>
      {children}
    </ThemeContext.Provider>
  );
}

// Usage
function App() {
  return (
    <ThemeProvider>
      <Header />
      <Content />
    </ThemeProvider>
  );
}
```

### Provider with Custom Hook

```jsx
const ThemeContext = createContext();

// Custom hook for easier usage
function useTheme() {
  const context = useContext(ThemeContext);
  if (!context) {
    throw new Error('useTheme must be used within ThemeProvider');
  }
  return context;
}

function ThemeProvider({ children }) {
  const [theme, setTheme] = useState('light');
  
  const value = {
    theme,
    toggleTheme: () => setTheme(prev => prev === 'light' ? 'dark' : 'light')
  };
  
  return (
    <ThemeContext.Provider value={value}>
      {children}
    </ThemeContext.Provider>
  );
}

// Usage in components
function ThemedButton() {
  const { theme, toggleTheme } = useTheme();
  
  return (
    <button onClick={toggleTheme}>
      Current theme: {theme}
    </button>
  );
}
```

### Provider with Complex State

```jsx
const AuthContext = createContext();

function useAuth() {
  const context = useContext(AuthContext);
  if (!context) {
    throw new Error('useAuth must be used within AuthProvider');
  }
  return context;
}

function AuthProvider({ children }) {
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    // Check if user is logged in
    const checkAuth = async () => {
      try {
        const response = await fetch('/api/auth/me');
        const data = await response.json();
        setUser(data);
      } catch (error) {
        setUser(null);
      } finally {
        setLoading(false);
      }
    };
    
    checkAuth();
  }, []);

  const login = async (credentials) => {
    const response = await fetch('/api/auth/login', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(credentials)
    });
    const data = await response.json();
    setUser(data.user);
  };

  const logout = async () => {
    await fetch('/api/auth/logout', { method: 'POST' });
    setUser(null);
  };

  const value = {
    user,
    loading,
    login,
    logout,
    isAuthenticated: !!user
  };

  return (
    <AuthContext.Provider value={value}>
      {children}
    </AuthContext.Provider>
  );
}

// Usage
function ProtectedRoute({ children }) {
  const { user, loading } = useAuth();
  
  if (loading) return <div>Loading...</div>;
  if (!user) return <Navigate to="/login" />;
  
  return children;
}
```

## Multiple Contexts

### Nested Providers

```jsx
const ThemeContext = createContext();
const UserContext = createContext();
const LanguageContext = createContext();

function App() {
  return (
    <ThemeProvider>
      <UserProvider>
        <LanguageProvider>
          <MainApp />
        </LanguageProvider>
      </UserProvider>
    </ThemeProvider>
  );
}

// Component using multiple contexts
function Header() {
  const { theme } = useTheme();
  const { user } = useUser();
  const { language } = useLanguage();
  
  return (
    <header className={theme}>
      <span>{language === 'en' ? 'Welcome' : 'Bienvenue'}, {user.name}</span>
    </header>
  );
}
```

### Combining Providers

```jsx
function AppProviders({ children }) {
  return (
    <ThemeProvider>
      <AuthProvider>
        <LanguageProvider>
          {children}
        </LanguageProvider>
      </AuthProvider>
    </ThemeProvider>
  );
}

// Usage
function App() {
  return (
    <AppProviders>
      <Router>
        <Routes />
      </Router>
    </AppProviders>
  );
}
```

### Context Composition

```jsx
function ComponentUsingMultipleContexts() {
  const theme = useContext(ThemeContext);
  const user = useContext(UserContext);
  const language = useContext(LanguageContext);
  
  return (
    <div className={theme}>
      <p>{language === 'en' ? 'Hello' : 'Bonjour'}, {user.name}</p>
    </div>
  );
}
```

## Context with useReducer

### Basic Reducer with Context

```jsx
const TodoContext = createContext();

const todoReducer = (state, action) => {
  switch (action.type) {
    case 'ADD_TODO':
      return [...state, { id: Date.now(), text: action.payload, completed: false }];
    case 'TOGGLE_TODO':
      return state.map(todo =>
        todo.id === action.payload ? { ...todo, completed: !todo.completed } : todo
      );
    case 'DELETE_TODO':
      return state.filter(todo => todo.id !== action.payload);
    default:
      return state;
  }
};

function TodoProvider({ children }) {
  const [todos, dispatch] = useReducer(todoReducer, []);
  
  return (
    <TodoContext.Provider value={{ todos, dispatch }}>
      {children}
    </TodoContext.Provider>
  );
}

// Usage
function TodoList() {
  const { todos, dispatch } = useContext(TodoContext);
  
  return (
    <ul>
      {todos.map(todo => (
        <li key={todo.id}>
          <input
            type="checkbox"
            checked={todo.completed}
            onChange={() => dispatch({ type: 'TOGGLE_TODO', payload: todo.id })}
          />
          {todo.text}
          <button onClick={() => dispatch({ type: 'DELETE_TODO', payload: todo.id })}>
            Delete
          </button>
        </li>
      ))}
    </ul>
  );
}
```

### Complex State Management

```jsx
const CartContext = createContext();

const cartReducer = (state, action) => {
  switch (action.type) {
    case 'ADD_ITEM':
      const existing = state.items.find(item => item.id === action.payload.id);
      if (existing) {
        return {
          ...state,
          items: state.items.map(item =>
            item.id === action.payload.id
              ? { ...item, quantity: item.quantity + 1 }
              : item
          )
        };
      }
      return {
        ...state,
        items: [...state.items, { ...action.payload, quantity: 1 }]
      };
    
    case 'REMOVE_ITEM':
      return {
        ...state,
        items: state.items.filter(item => item.id !== action.payload)
      };
    
    case 'UPDATE_QUANTITY':
      return {
        ...state,
        items: state.items.map(item =>
          item.id === action.payload.id
            ? { ...item, quantity: action.payload.quantity }
            : item
        )
      };
    
    case 'CLEAR_CART':
      return { ...state, items: [] };
    
    default:
      return state;
  }
};

function CartProvider({ children }) {
  const [state, dispatch] = useReducer(cartReducer, { items: [] });
  
  const addItem = (item) => dispatch({ type: 'ADD_ITEM', payload: item });
  const removeItem = (id) => dispatch({ type: 'REMOVE_ITEM', payload: id });
  const updateQuantity = (id, quantity) => 
    dispatch({ type: 'UPDATE_QUANTITY', payload: { id, quantity } });
  const clearCart = () => dispatch({ type: 'CLEAR_CART' });
  
  const totalItems = state.items.reduce((sum, item) => sum + item.quantity, 0);
  const totalPrice = state.items.reduce((sum, item) => sum + item.price * item.quantity, 0);
  
  const value = {
    items: state.items,
    addItem,
    removeItem,
    updateQuantity,
    clearCart,
    totalItems,
    totalPrice
  };
  
  return (
    <CartContext.Provider value={value}>
      {children}
    </CartContext.Provider>
  );
}

// Custom hook
function useCart() {
  const context = useContext(CartContext);
  if (!context) {
    throw new Error('useCart must be used within CartProvider');
  }
  return context;
}
```

## Performance Optimization

### Splitting Contexts

```jsx
// ❌ Bad - Single context with all state causes unnecessary re-renders
const AppContext = createContext();

function AppProvider({ children }) {
  const [user, setUser] = useState(null);
  const [theme, setTheme] = useState('light');
  const [language, setLanguage] = useState('en');
  
  // Any state change re-renders all consumers
  const value = { user, setUser, theme, setTheme, language, setLanguage };
  
  return <AppContext.Provider value={value}>{children}</AppContext.Provider>;
}

// ✅ Good - Split into separate contexts
const UserContext = createContext();
const ThemeContext = createContext();
const LanguageContext = createContext();

function AppProvider({ children }) {
  return (
    <UserProvider>
      <ThemeProvider>
        <LanguageProvider>
          {children}
        </LanguageProvider>
      </ThemeProvider>
    </UserProvider>
  );
}
```

### Memoizing Context Value

```jsx
// ❌ Bad - Value object recreated on every render
function ThemeProvider({ children }) {
  const [theme, setTheme] = useState('light');
  
  return (
    <ThemeContext.Provider value={{ theme, setTheme }}>
      {children}
    </ThemeContext.Provider>
  );
}

// ✅ Good - Memoized value
function ThemeProvider({ children }) {
  const [theme, setTheme] = useState('light');
  
  const value = useMemo(() => ({ theme, setTheme }), [theme]);
  
  return (
    <ThemeContext.Provider value={value}>
      {children}
    </ThemeContext.Provider>
  );
}
```

### Optimizing with useCallback

```jsx
function TodoProvider({ children }) {
  const [todos, setTodos] = useState([]);
  
  const addTodo = useCallback((text) => {
    setTodos(prev => [...prev, { id: Date.now(), text, completed: false }]);
  }, []);
  
  const toggleTodo = useCallback((id) => {
    setTodos(prev => prev.map(todo =>
      todo.id === id ? { ...todo, completed: !todo.completed } : todo
    ));
  }, []);
  
  const deleteTodo = useCallback((id) => {
    setTodos(prev => prev.filter(todo => todo.id !== id));
  }, []);
  
  const value = useMemo(() => ({
    todos,
    addTodo,
    toggleTodo,
    deleteTodo
  }), [todos, addTodo, toggleTodo, deleteTodo]);
  
  return (
    <TodoContext.Provider value={value}>
      {children}
    </TodoContext.Provider>
  );
}
```

### Selective Re-rendering

```jsx
// Split read and write contexts
const StateContext = createContext();
const DispatchContext = createContext();

function Provider({ children }) {
  const [state, dispatch] = useReducer(reducer, initialState);
  
  return (
    <StateContext.Provider value={state}>
      <DispatchContext.Provider value={dispatch}>
        {children}
      </DispatchContext.Provider>
    </StateContext.Provider>
  );
}

// Components only re-render when their specific context changes
function DisplayComponent() {
  const state = useContext(StateContext); // Re-renders on state change
  return <div>{state.value}</div>;
}

function ActionComponent() {
  const dispatch = useContext(DispatchContext); // Never re-renders
  return <button onClick={() => dispatch({ type: 'INCREMENT' })}>+</button>;
}
```

## Best Practices

### 1. Create Custom Hooks

```jsx
// ✅ Good - Encapsulate context logic
const ThemeContext = createContext();

function useTheme() {
  const context = useContext(ThemeContext);
  if (!context) {
    throw new Error('useTheme must be used within ThemeProvider');
  }
  return context;
}

// Usage is cleaner
function Component() {
  const { theme, toggleTheme } = useTheme();
  return <button onClick={toggleTheme}>{theme}</button>;
}
```

### 2. Provide Default Values

```jsx
// ✅ Good - Meaningful default values
const UserContext = createContext({
  user: null,
  login: () => {},
  logout: () => {},
  isAuthenticated: false
});
```

### 3. Keep Context Values Stable

```jsx
// ✅ Good - Memoize to prevent unnecessary re-renders
function DataProvider({ children }) {
  const [data, setData] = useState([]);
  
  const value = useMemo(() => ({
    data,
    setData
  }), [data]);
  
  return <DataContext.Provider value={value}>{children}</DataContext.Provider>;
}
```

### 4. Split Large Contexts

```jsx
// ✅ Good - Separate concerns
function App() {
  return (
    <AuthProvider>
      <ThemeProvider>
        <NotificationProvider>
          <AppContent />
        </NotificationProvider>
      </ThemeProvider>
    </AuthProvider>
  );
}
```

### 5. Don't Overuse Context

```jsx
// ❌ Bad - Using context for local state
function Parent() {
  return (
    <CountProvider>
      <Child />
    </CountProvider>
  );
}

// ✅ Good - Use props for local state
function Parent() {
  const [count, setCount] = useState(0);
  return <Child count={count} setCount={setCount} />;
}
```

## Common Patterns

### Auth Context Pattern

```jsx
const AuthContext = createContext();

export function useAuth() {
  return useContext(AuthContext);
}

export function AuthProvider({ children }) {
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    // Check authentication status
    const unsubscribe = onAuthStateChange((user) => {
      setUser(user);
      setLoading(false);
    });
    
    return unsubscribe;
  }, []);

  const login = async (email, password) => {
    const user = await signIn(email, password);
    setUser(user);
  };

  const logout = async () => {
    await signOut();
    setUser(null);
  };

  const value = {
    user,
    loading,
    login,
    logout,
    isAuthenticated: !!user
  };

  return (
    <AuthContext.Provider value={value}>
      {!loading && children}
    </AuthContext.Provider>
  );
}
```

### Theme Context Pattern

```jsx
const ThemeContext = createContext();

export function useTheme() {
  return useContext(ThemeContext);
}

export function ThemeProvider({ children }) {
  const [theme, setTheme] = useState(() => {
    return localStorage.getItem('theme') || 'light';
  });

  useEffect(() => {
    localStorage.setItem('theme', theme);
    document.documentElement.setAttribute('data-theme', theme);
  }, [theme]);

  const toggleTheme = () => {
    setTheme(prev => prev === 'light' ? 'dark' : 'light');
  };

  const value = { theme, toggleTheme };

  return (
    <ThemeContext.Provider value={value}>
      {children}
    </ThemeContext.Provider>
  );
}
```

### Notification Context Pattern

```jsx
const NotificationContext = createContext();

export function useNotification() {
  return useContext(NotificationContext);
}

export function NotificationProvider({ children }) {
  const [notifications, setNotifications] = useState([]);

  const addNotification = useCallback((message, type = 'info') => {
    const id = Date.now();
    setNotifications(prev => [...prev, { id, message, type }]);
    
    setTimeout(() => {
      setNotifications(prev => prev.filter(n => n.id !== id));
    }, 3000);
  }, []);

  const removeNotification = useCallback((id) => {
    setNotifications(prev => prev.filter(n => n.id !== id));
  }, []);

  const value = {
    notifications,
    addNotification,
    removeNotification,
    success: (msg) => addNotification(msg, 'success'),
    error: (msg) => addNotification(msg, 'error'),
    info: (msg) => addNotification(msg, 'info')
  };

  return (
    <NotificationContext.Provider value={value}>
      {children}
      <NotificationList notifications={notifications} onClose={removeNotification} />
    </NotificationContext.Provider>
  );
}
```

## Summary

The Context API is a powerful tool for managing global state in React:

**Key Concepts:**
- Context provides a way to share data across component tree
- Use `createContext()` to create a context
- Use `useContext()` hook to consume context values
- Provider pattern wraps context logic in reusable components
- Combine Context with useReducer for complex state

**Best Practices:**
- Create custom hooks for cleaner consumption
- Memoize context values to prevent unnecessary re-renders
- Split large contexts into smaller ones
- Don't overuse context - use props for local state
- Provide meaningful default values
- Add error handling for missing providers

**Common Use Cases:**
- Authentication state
- Theme/styling preferences
- Localization/language settings
- User preferences
- Notification systems
- Global application settings

Context is ideal for truly global data but consider state management libraries like Redux or Zustand for complex applications with frequent state updates.

---

**Related Topics:**
- [State Management](03_STATE_MANAGEMENT.md)
- [Advanced Hooks](11_ADVANCED_HOOKS.md)
- [Custom Hooks](12_CUSTOM_HOOKS.md)
- [State Libraries](17_STATE_LIBRARIES.md)
