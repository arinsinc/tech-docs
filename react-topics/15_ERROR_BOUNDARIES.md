# Error Boundaries

Error boundaries are React components that catch JavaScript errors in their child component tree, log errors, and display a fallback UI.

## Table of Contents
- [Introduction to Error Boundaries](#introduction-to-error-boundaries)
- [Creating Error Boundaries](#creating-error-boundaries)
- [Error Boundary Patterns](#error-boundary-patterns)
- [Best Practices](#best-practices)
- [Limitations](#limitations)
- [Error Handling in React 18+](#error-handling-in-react-18)

---

## Introduction to Error Boundaries

Error boundaries catch errors during:
- Rendering
- Lifecycle methods
- Constructors of child components

They **do NOT** catch errors in:
- Event handlers
- Asynchronous code (setTimeout, promises)
- Server-side rendering
- Errors thrown in the error boundary itself

### Why Error Boundaries?

```javascript
// Without error boundary - entire app crashes
function App() {
  return (
    <div>
      <Header />
      <BuggyComponent /> {/* Error here crashes everything */}
      <Footer />
    </div>
  );
}

// With error boundary - isolated error handling
function App() {
  return (
    <div>
      <Header />
      <ErrorBoundary fallback={<div>Something went wrong</div>}>
        <BuggyComponent /> {/* Error here is contained */}
      </ErrorBoundary>
      <Footer />
    </div>
  );
}
```

---

## Creating Error Boundaries

### Basic Error Boundary (Class Component)

Error boundaries must be class components (as of React 18).

```javascript
class ErrorBoundary extends React.Component {
  constructor(props) {
    super(props);
    this.state = { hasError: false };
  }
  
  static getDerivedStateFromError(error) {
    // Update state so next render shows fallback UI
    return { hasError: true };
  }
  
  componentDidCatch(error, errorInfo) {
    // Log error to error reporting service
    console.error('Error caught:', error, errorInfo);
  }
  
  render() {
    if (this.state.hasError) {
      return <h1>Something went wrong.</h1>;
    }
    
    return this.props.children;
  }
}

// Usage
function App() {
  return (
    <ErrorBoundary>
      <MyComponent />
    </ErrorBoundary>
  );
}
```

### Enhanced Error Boundary with Details

```javascript
class ErrorBoundary extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      hasError: false,
      error: null,
      errorInfo: null
    };
  }
  
  static getDerivedStateFromError(error) {
    return { hasError: true };
  }
  
  componentDidCatch(error, errorInfo) {
    this.setState({
      error,
      errorInfo
    });
    
    // Log to error reporting service
    logErrorToService(error, errorInfo);
  }
  
  render() {
    if (this.state.hasError) {
      return (
        <div style={{ padding: '20px' }}>
          <h1>Oops! Something went wrong</h1>
          <details style={{ whiteSpace: 'pre-wrap' }}>
            <summary>Error Details</summary>
            {this.state.error && this.state.error.toString()}
            <br />
            {this.state.errorInfo && this.state.errorInfo.componentStack}
          </details>
        </div>
      );
    }
    
    return this.props.children;
  }
}
```

### Error Boundary with Reset

```javascript
class ErrorBoundary extends React.Component {
  constructor(props) {
    super(props);
    this.state = { hasError: false, error: null };
  }
  
  static getDerivedStateFromError(error) {
    return { hasError: true, error };
  }
  
  componentDidCatch(error, errorInfo) {
    console.error('Error:', error, errorInfo);
  }
  
  resetError = () => {
    this.setState({ hasError: false, error: null });
  };
  
  render() {
    if (this.state.hasError) {
      return (
        <div className="error-container">
          <h1>Something went wrong</h1>
          <p>{this.state.error?.message}</p>
          <button onClick={this.resetError}>Try Again</button>
        </div>
      );
    }
    
    return this.props.children;
  }
}
```

### Custom Fallback Component

```javascript
class ErrorBoundary extends React.Component {
  constructor(props) {
    super(props);
    this.state = { hasError: false, error: null };
  }
  
  static getDerivedStateFromError(error) {
    return { hasError: true, error };
  }
  
  componentDidCatch(error, errorInfo) {
    this.props.onError?.(error, errorInfo);
  }
  
  render() {
    if (this.state.hasError) {
      // Use custom fallback if provided
      if (this.props.fallback) {
        return this.props.fallback;
      }
      
      // Or use render prop
      if (this.props.FallbackComponent) {
        return (
          <this.props.FallbackComponent
            error={this.state.error}
            resetError={() => this.setState({ hasError: false })}
          />
        );
      }
      
      return <h1>Error occurred</h1>;
    }
    
    return this.props.children;
  }
}

// Usage with custom fallback
<ErrorBoundary fallback={<div>Custom Error Message</div>}>
  <MyComponent />
</ErrorBoundary>

// Usage with fallback component
<ErrorBoundary FallbackComponent={ErrorFallback}>
  <MyComponent />
</ErrorBoundary>

function ErrorFallback({ error, resetError }) {
  return (
    <div role="alert">
      <h2>Error</h2>
      <pre>{error.message}</pre>
      <button onClick={resetError}>Try again</button>
    </div>
  );
}
```

---

## Error Boundary Patterns

### Granular Error Boundaries

Place error boundaries strategically to isolate failures.

```javascript
function App() {
  return (
    <div>
      <ErrorBoundary fallback={<HeaderFallback />}>
        <Header />
      </ErrorBoundary>
      
      <ErrorBoundary fallback={<SidebarFallback />}>
        <Sidebar />
      </ErrorBoundary>
      
      <ErrorBoundary fallback={<MainContentFallback />}>
        <MainContent />
      </ErrorBoundary>
      
      <ErrorBoundary fallback={<FooterFallback />}>
        <Footer />
      </ErrorBoundary>
    </div>
  );
}
```

### Route-Level Error Boundaries

```javascript
function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<Home />} />
        <Route
          path="/dashboard"
          element={
            <ErrorBoundary fallback={<DashboardError />}>
              <Dashboard />
            </ErrorBoundary>
          }
        />
        <Route
          path="/profile"
          element={
            <ErrorBoundary fallback={<ProfileError />}>
              <Profile />
            </ErrorBoundary>
          }
        />
      </Routes>
    </BrowserRouter>
  );
}
```

### Error Boundary with Retry Logic

```javascript
class RetryErrorBoundary extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      hasError: false,
      error: null,
      retryCount: 0
    };
  }
  
  static getDerivedStateFromError(error) {
    return { hasError: true, error };
  }
  
  componentDidCatch(error, errorInfo) {
    console.error('Error:', error, errorInfo);
  }
  
  handleRetry = () => {
    this.setState(prevState => ({
      hasError: false,
      error: null,
      retryCount: prevState.retryCount + 1
    }));
  };
  
  render() {
    const { hasError, error, retryCount } = this.state;
    const { maxRetries = 3 } = this.props;
    
    if (hasError) {
      if (retryCount >= maxRetries) {
        return (
          <div>
            <h1>Maximum retry attempts reached</h1>
            <p>Please refresh the page or contact support</p>
          </div>
        );
      }
      
      return (
        <div>
          <h1>Error occurred</h1>
          <p>{error?.message}</p>
          <button onClick={this.handleRetry}>
            Retry ({retryCount + 1}/{maxRetries})
          </button>
        </div>
      );
    }
    
    return this.props.children;
  }
}
```

### Error Boundary with Logging Service

```javascript
class LoggingErrorBoundary extends React.Component {
  constructor(props) {
    super(props);
    this.state = { hasError: false };
  }
  
  static getDerivedStateFromError(error) {
    return { hasError: true };
  }
  
  componentDidCatch(error, errorInfo) {
    // Log to service like Sentry, LogRocket, etc.
    const errorReport = {
      error: error.toString(),
      errorInfo: errorInfo.componentStack,
      timestamp: new Date().toISOString(),
      url: window.location.href,
      userAgent: navigator.userAgent
    };
    
    // Send to logging service
    fetch('/api/log-error', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(errorReport)
    });
    
    // Or use Sentry
    // Sentry.captureException(error, { contexts: { react: errorInfo } });
  }
  
  render() {
    if (this.state.hasError) {
      return this.props.fallback || <h1>Something went wrong</h1>;
    }
    
    return this.props.children;
  }
}
```

---

## Best Practices

### 1. Handle Errors in Event Handlers Separately

```javascript
function MyComponent() {
  const [error, setError] = useState(null);
  
  const handleClick = async () => {
    try {
      await riskyOperation();
    } catch (error) {
      setError(error);
      // Or show toast notification
      toast.error(error.message);
    }
  };
  
  if (error) {
    return <div>Error: {error.message}</div>;
  }
  
  return <button onClick={handleClick}>Click me</button>;
}
```

### 2. Handle Async Errors

```javascript
function DataComponent() {
  const [error, setError] = useState(null);
  
  useEffect(() => {
    fetchData()
      .then(data => setData(data))
      .catch(error => setError(error));
  }, []);
  
  if (error) {
    return <div>Error loading data: {error.message}</div>;
  }
  
  return <div>{/* render data */}</div>;
}
```

### 3. Provide Meaningful Error Messages

```javascript
class ErrorBoundary extends React.Component {
  // ... error boundary setup
  
  render() {
    if (this.state.hasError) {
      const errorType = this.state.error?.name;
      
      if (errorType === 'NetworkError') {
        return (
          <div>
            <h1>Connection Problem</h1>
            <p>Please check your internet connection and try again.</p>
          </div>
        );
      }
      
      if (errorType === 'AuthenticationError') {
        return (
          <div>
            <h1>Authentication Required</h1>
            <p>Please log in to continue.</p>
          </div>
        );
      }
      
      return (
        <div>
          <h1>Something went wrong</h1>
          <p>We're working to fix the issue.</p>
        </div>
      );
    }
    
    return this.props.children;
  }
}
```

### 4. Development vs Production

```javascript
class ErrorBoundary extends React.Component {
  // ... error boundary setup
  
  render() {
    if (this.state.hasError) {
      if (process.env.NODE_ENV === 'development') {
        // Show detailed error in development
        return (
          <div>
            <h1>Development Error</h1>
            <pre>{this.state.error?.stack}</pre>
            <pre>{this.state.errorInfo?.componentStack}</pre>
          </div>
        );
      }
      
      // Show user-friendly message in production
      return (
        <div>
          <h1>Something went wrong</h1>
          <p>Please try refreshing the page.</p>
          <button onClick={() => window.location.reload()}>
            Refresh
          </button>
        </div>
      );
    }
    
    return this.props.children;
  }
}
```

### 5. Reset on Route Change

```javascript
import { useLocation } from 'react-router-dom';

class ErrorBoundary extends React.Component {
  constructor(props) {
    super(props);
    this.state = { hasError: false };
  }
  
  static getDerivedStateFromError(error) {
    return { hasError: true };
  }
  
  componentDidUpdate(prevProps) {
    // Reset error boundary when route changes
    if (this.props.location !== prevProps.location) {
      this.setState({ hasError: false });
    }
  }
  
  render() {
    if (this.state.hasError) {
      return <h1>Error occurred</h1>;
    }
    return this.props.children;
  }
}

// Wrapper to inject location
function ErrorBoundaryWithRouter(props) {
  const location = useLocation();
  return <ErrorBoundary location={location} {...props} />;
}
```

---

## Limitations

### What Error Boundaries DON'T Catch

```javascript
function ProblematicComponent() {
  // ❌ Error boundaries don't catch this
  const handleClick = () => {
    throw new Error('Event handler error');
  };
  
  // ❌ Error boundaries don't catch this
  useEffect(() => {
    setTimeout(() => {
      throw new Error('Async error');
    }, 1000);
  }, []);
  
  // ❌ Error boundaries don't catch this
  useEffect(() => {
    fetch('/api/data')
      .then(res => res.json())
      .catch(error => {
        // Must handle this manually
        console.error(error);
      });
  }, []);
  
  return <button onClick={handleClick}>Click</button>;
}

// ✅ Handle event handler errors manually
function SafeComponent() {
  const [error, setError] = useState(null);
  
  const handleClick = () => {
    try {
      riskyOperation();
    } catch (error) {
      setError(error.message);
    }
  };
  
  if (error) return <div>Error: {error}</div>;
  
  return <button onClick={handleClick}>Click</button>;
}
```

---

## Error Handling in React 18+

### Using react-error-boundary Library

```javascript
import { ErrorBoundary } from 'react-error-boundary';

function ErrorFallback({ error, resetErrorBoundary }) {
  return (
    <div role="alert">
      <h2>Something went wrong:</h2>
      <pre style={{ color: 'red' }}>{error.message}</pre>
      <button onClick={resetErrorBoundary}>Try again</button>
    </div>
  );
}

function App() {
  return (
    <ErrorBoundary
      FallbackComponent={ErrorFallback}
      onReset={() => {
        // Reset app state
      }}
      onError={(error, errorInfo) => {
        // Log error
        console.log('Error:', error, errorInfo);
      }}
    >
      <MyApp />
    </ErrorBoundary>
  );
}
```

### With Reset Keys

```javascript
function App() {
  const [userId, setUserId] = useState(null);
  
  return (
    <ErrorBoundary
      FallbackComponent={ErrorFallback}
      resetKeys={[userId]} // Reset when userId changes
    >
      <UserProfile userId={userId} />
    </ErrorBoundary>
  );
}
```

### Combining with Suspense

```javascript
function App() {
  return (
    <ErrorBoundary fallback={<ErrorFallback />}>
      <Suspense fallback={<Loading />}>
        <LazyComponent />
      </Suspense>
    </ErrorBoundary>
  );
}
```

---

## Complete Example

```javascript
class AppErrorBoundary extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      hasError: false,
      error: null,
      errorInfo: null,
      errorCount: 0
    };
  }
  
  static getDerivedStateFromError(error) {
    return { hasError: true };
  }
  
  componentDidCatch(error, errorInfo) {
    this.setState(prevState => ({
      error,
      errorInfo,
      errorCount: prevState.errorCount + 1
    }));
    
    // Log to monitoring service
    if (window.Sentry) {
      window.Sentry.captureException(error, {
        contexts: { react: errorInfo }
      });
    }
  }
  
  handleReset = () => {
    this.setState({
      hasError: false,
      error: null,
      errorInfo: null
    });
  };
  
  render() {
    if (this.state.hasError) {
      const isDevelopment = process.env.NODE_ENV === 'development';
      
      return (
        <div className="error-container">
          <div className="error-content">
            <h1>😔 Oops! Something went wrong</h1>
            
            {isDevelopment && (
              <details>
                <summary>Error Details (Development Only)</summary>
                <pre>{this.state.error?.toString()}</pre>
                <pre>{this.state.errorInfo?.componentStack}</pre>
              </details>
            )}
            
            <div className="error-actions">
              <button onClick={this.handleReset}>
                Try Again
              </button>
              <button onClick={() => window.location.reload()}>
                Reload Page
              </button>
              {this.state.errorCount > 2 && (
                <button onClick={() => window.location.href = '/'}>
                  Go Home
                </button>
              )}
            </div>
          </div>
        </div>
      );
    }
    
    return this.props.children;
  }
}

// Usage
function App() {
  return (
    <AppErrorBoundary>
      <Router>
        <Routes>
          <Route path="/" element={<Home />} />
          <Route path="/about" element={<About />} />
        </Routes>
      </Router>
    </AppErrorBoundary>
  );
}
```

---

## Key Takeaways

1. **Error boundaries catch rendering errors** - Not event handlers or async code
2. **Use multiple boundaries** - Isolate failures to specific parts of the UI
3. **Provide fallback UI** - Show meaningful error messages to users
4. **Log errors** - Send to monitoring services for debugging
5. **Handle other errors manually** - Use try/catch for events and async code
6. **Development vs Production** - Show detailed errors in dev, friendly messages in prod

## Next Steps

- Learn about [React Router](16_REACT_ROUTER.md)
- Explore [Performance Optimization](14_PERFORMANCE.md)
- Study [Testing](18_TESTING.md) strategies
