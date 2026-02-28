# Conditional Rendering in React

## Table of Contents
- [Introduction](#introduction)
- [If-Else Statements](#if-else-statements)
- [Ternary Operators](#ternary-operators)
- [Logical AND Operator](#logical-and-operator)
- [Logical OR Operator](#logical-or-operator)
- [Switch Statements](#switch-statements)
- [Immediately Invoked Function Expressions](#immediately-invoked-function-expressions)
- [Conditional Rendering with Variables](#conditional-rendering-with-variables)
- [Multiple Conditions](#multiple-conditions)
- [Rendering Nothing](#rendering-nothing)
- [Best Practices](#best-practices)
- [Common Patterns](#common-patterns)

## Introduction

Conditional rendering in React allows you to render different UI elements or components based on certain conditions. React uses JavaScript's conditional operators to create dynamic and interactive user interfaces.

### Why Conditional Rendering?
- Show/hide elements based on state
- Display different content for different user roles
- Handle loading and error states
- Create responsive and adaptive UIs

## If-Else Statements

### Basic If-Else Outside JSX

```jsx
function Greeting({ isLoggedIn }) {
  if (isLoggedIn) {
    return <h1>Welcome back!</h1>;
  } else {
    return <h1>Please sign in.</h1>;
  }
}
```

### Multiple Returns

```jsx
function UserStatus({ user }) {
  if (!user) {
    return <div>Loading...</div>;
  }

  if (user.error) {
    return <div>Error: {user.error}</div>;
  }

  if (!user.verified) {
    return <div>Please verify your email</div>;
  }

  return <div>Welcome, {user.name}!</div>;
}
```

### If-Else with Complex Logic

```jsx
function Dashboard({ user }) {
  let content;

  if (user.role === 'admin') {
    content = <AdminPanel />;
  } else if (user.role === 'moderator') {
    content = <ModeratorPanel />;
  } else {
    content = <UserPanel />;
  }

  return (
    <div className="dashboard">
      <Header user={user} />
      {content}
      <Footer />
    </div>
  );
}
```

## Ternary Operators

### Basic Ternary

```jsx
function LoginButton({ isLoggedIn }) {
  return (
    <button>
      {isLoggedIn ? 'Logout' : 'Login'}
    </button>
  );
}
```

### Ternary with Components

```jsx
function UserGreeting({ isLoggedIn, username }) {
  return (
    <div>
      {isLoggedIn ? (
        <h1>Welcome back, {username}!</h1>
      ) : (
        <h1>Please sign in</h1>
      )}
    </div>
  );
}
```

### Nested Ternary (Use Sparingly)

```jsx
function StatusMessage({ status }) {
  return (
    <div>
      {status === 'loading' ? (
        <Spinner />
      ) : status === 'error' ? (
        <ErrorMessage />
      ) : status === 'success' ? (
        <SuccessMessage />
      ) : (
        <IdleMessage />
      )}
    </div>
  );
}
```

### Ternary in Attributes

```jsx
function Button({ isPrimary, isDisabled }) {
  return (
    <button
      className={isPrimary ? 'btn-primary' : 'btn-secondary'}
      disabled={isDisabled ? true : false}
      style={{ opacity: isDisabled ? 0.5 : 1 }}
    >
      Click me
    </button>
  );
}
```

## Logical AND Operator

### Short-Circuit Evaluation

```jsx
function Notification({ message }) {
  return (
    <div>
      {message && <div className="alert">{message}</div>}
    </div>
  );
}
```

### Multiple Conditions with AND

```jsx
function AdminPanel({ user, hasPermission }) {
  return (
    <div>
      {user && hasPermission && (
        <div className="admin-panel">
          <h2>Admin Controls</h2>
          <button>Delete User</button>
          <button>Edit Settings</button>
        </div>
      )}
    </div>
  );
}
```

### Common Use Cases

```jsx
function UserProfile({ user }) {
  return (
    <div>
      <h1>{user.name}</h1>
      {user.email && <p>Email: {user.email}</p>}
      {user.phone && <p>Phone: {user.phone}</p>}
      {user.isPremium && <span className="badge">Premium</span>}
      {user.posts.length > 0 && (
        <div>
          <h3>Recent Posts</h3>
          <PostList posts={user.posts} />
        </div>
      )}
    </div>
  );
}
```

### Gotcha: Falsy Values

```jsx
function ItemCount({ count }) {
  // ❌ Problem: renders "0" when count is 0
  return <div>{count && <span>{count} items</span>}</div>;

  // ✅ Solution: explicit comparison
  return <div>{count > 0 && <span>{count} items</span>}</div>;

  // ✅ Alternative: use ternary
  return <div>{count ? <span>{count} items</span> : null}</div>;
}
```

## Logical OR Operator

### Default Values

```jsx
function UserName({ user }) {
  return <h1>{user.name || 'Guest'}</h1>;
}
```

### Fallback Content

```jsx
function Avatar({ src, alt }) {
  return (
    <div>
      {src ? (
        <img src={src} alt={alt} />
      ) : (
        <div className="avatar-placeholder">
          {alt || 'User'}
        </div>
      )}
    </div>
  );
}
```

### Nullish Coalescing

```jsx
function DisplayValue({ value }) {
  // ✅ Uses nullish coalescing - only falls back for null/undefined
  return <div>{value ?? 'No value'}</div>;

  // vs

  // ❌ Uses OR - falls back for any falsy value (0, '', false, etc.)
  return <div>{value || 'No value'}</div>;
}

// Examples:
// value = 0: nullish shows "0", OR shows "No value"
// value = '': nullish shows "", OR shows "No value"
// value = null: both show "No value"
```

## Switch Statements

### Component Switch

```jsx
function PageContent({ page }) {
  switch (page) {
    case 'home':
      return <HomePage />;
    case 'about':
      return <AboutPage />;
    case 'contact':
      return <ContactPage />;
    case 'profile':
      return <ProfilePage />;
    default:
      return <NotFoundPage />;
  }
}
```

### Switch with JSX

```jsx
function StatusIndicator({ status }) {
  const getStatusContent = () => {
    switch (status) {
      case 'pending':
        return { icon: '⏳', color: 'orange', text: 'Pending' };
      case 'approved':
        return { icon: '✅', color: 'green', text: 'Approved' };
      case 'rejected':
        return { icon: '❌', color: 'red', text: 'Rejected' };
      default:
        return { icon: '❓', color: 'gray', text: 'Unknown' };
    }
  };

  const { icon, color, text } = getStatusContent();

  return (
    <div style={{ color }}>
      <span>{icon}</span>
      <span>{text}</span>
    </div>
  );
}
```

## Immediately Invoked Function Expressions

### IIFE for Complex Logic

```jsx
function ComplexConditional({ user, data, isLoading }) {
  return (
    <div>
      {(() => {
        if (isLoading) {
          return <Spinner />;
        }

        if (!user) {
          return <LoginPrompt />;
        }

        if (!data) {
          return <NoDataMessage />;
        }

        if (user.role === 'admin') {
          return <AdminView data={data} />;
        }

        return <UserView data={data} />;
      })()}
    </div>
  );
}
```

### IIFE with Side Effects

```jsx
function DataDisplay({ data }) {
  return (
    <div>
      {(() => {
        console.log('Rendering data:', data);
        
        if (!data) return <p>No data</p>;
        if (data.length === 0) return <p>Empty list</p>;
        
        return <ul>{data.map(item => <li key={item.id}>{item.name}</li>)}</ul>;
      })()}
    </div>
  );
}
```

## Conditional Rendering with Variables

### Element Variables

```jsx
function LoginControl({ isLoggedIn }) {
  let button;
  
  if (isLoggedIn) {
    button = <LogoutButton />;
  } else {
    button = <LoginButton />;
  }

  return (
    <div>
      <Greeting isLoggedIn={isLoggedIn} />
      {button}
    </div>
  );
}
```

### Multiple Element Variables

```jsx
function Dashboard({ user, notifications, messages }) {
  let notificationBadge = null;
  let messageBadge = null;

  if (notifications > 0) {
    notificationBadge = <span className="badge">{notifications}</span>;
  }

  if (messages > 0) {
    messageBadge = <span className="badge">{messages}</span>;
  }

  return (
    <nav>
      <div>
        Notifications {notificationBadge}
      </div>
      <div>
        Messages {messageBadge}
      </div>
    </nav>
  );
}
```

## Multiple Conditions

### Combining Conditions

```jsx
function AccessControl({ user, hasPermission, isVerified }) {
  const canAccess = user && hasPermission && isVerified;

  return (
    <div>
      {canAccess ? (
        <SecureContent />
      ) : (
        <AccessDenied reason={!user ? 'Not logged in' : !isVerified ? 'Not verified' : 'No permission'} />
      )}
    </div>
  );
}
```

### Complex Conditions with Helper Functions

```jsx
function PostActions({ post, user }) {
  const canEdit = user && (user.id === post.authorId || user.role === 'admin');
  const canDelete = user && user.role === 'admin';
  const canPublish = user && post.status === 'draft' && user.id === post.authorId;

  return (
    <div className="post-actions">
      {canEdit && <button>Edit</button>}
      {canDelete && <button>Delete</button>}
      {canPublish && <button>Publish</button>}
    </div>
  );
}
```

### Object Mapping for Conditions

```jsx
function NotificationIcon({ type }) {
  const icons = {
    success: '✅',
    error: '❌',
    warning: '⚠️',
    info: 'ℹ️'
  };

  const colors = {
    success: 'green',
    error: 'red',
    warning: 'orange',
    info: 'blue'
  };

  return (
    <span style={{ color: colors[type] }}>
      {icons[type] || '📌'}
    </span>
  );
}
```

## Rendering Nothing

### Return Null

```jsx
function Warning({ show, message }) {
  if (!show) {
    return null;
  }

  return <div className="warning">{message}</div>;
}
```

### Conditional with Null

```jsx
function Sidebar({ isOpen, content }) {
  return (
    <div>
      {isOpen ? (
        <aside>{content}</aside>
      ) : null}
    </div>
  );
}
```

### Short-Circuit to Null

```jsx
function Badge({ count }) {
  return (
    <div>
      {count > 0 && <span className="badge">{count}</span>}
      {/* When count <= 0, React renders nothing */}
    </div>
  );
}
```

## Best Practices

### 1. Keep Conditions Simple

```jsx
// ✅ Good - Simple and readable
function UserStatus({ isActive }) {
  return (
    <div>
      {isActive ? <ActiveBadge /> : <InactiveBadge />}
    </div>
  );
}

// ❌ Avoid - Too complex
function UserStatus({ user }) {
  return (
    <div>
      {user && user.status && user.status.active && user.status.verified && !user.status.suspended ? (
        <ActiveBadge />
      ) : (
        <InactiveBadge />
      )}
    </div>
  );
}

// ✅ Better - Extract logic
function UserStatus({ user }) {
  const isFullyActive = user?.status?.active && 
                        user?.status?.verified && 
                        !user?.status?.suspended;

  return (
    <div>
      {isFullyActive ? <ActiveBadge /> : <InactiveBadge />}
    </div>
  );
}
```

### 2. Use Early Returns

```jsx
// ✅ Good - Early returns for edge cases
function UserProfile({ user }) {
  if (!user) return <div>Loading...</div>;
  if (user.error) return <ErrorMessage error={user.error} />;
  if (!user.isActive) return <InactiveAccount />;

  return (
    <div>
      <h1>{user.name}</h1>
      <p>{user.bio}</p>
    </div>
  );
}
```

### 3. Avoid Deep Nesting

```jsx
// ❌ Avoid - Deeply nested ternaries
function Status({ status }) {
  return (
    <div>
      {status === 'loading' ? (
        <Spinner />
      ) : status === 'error' ? (
        <Error />
      ) : status === 'empty' ? (
        <Empty />
      ) : (
        <Content />
      )}
    </div>
  );
}

// ✅ Better - Use mapping or switch
function Status({ status }) {
  const components = {
    loading: <Spinner />,
    error: <Error />,
    empty: <Empty />,
    success: <Content />
  };

  return <div>{components[status] || <Content />}</div>;
}
```

### 4. Use Descriptive Variable Names

```jsx
// ✅ Good - Clear variable names
function ProductCard({ product, user }) {
  const isOwner = user?.id === product.ownerId;
  const isAdmin = user?.role === 'admin';
  const canEdit = isOwner || isAdmin;
  const hasDiscount = product.discount > 0;

  return (
    <div>
      <h3>{product.name}</h3>
      {hasDiscount && <DiscountBadge amount={product.discount} />}
      {canEdit && <EditButton />}
    </div>
  );
}
```

### 5. Watch for Falsy Values

```jsx
// ❌ Problem - Shows "0" instead of hiding
function ItemCount({ count }) {
  return <div>{count && <span>{count} items</span>}</div>;
}

// ✅ Solution - Explicit comparison
function ItemCount({ count }) {
  return <div>{count > 0 && <span>{count} items</span>}</div>;
}

// ✅ Alternative - Boolean conversion
function ItemCount({ count }) {
  return <div>{Boolean(count) && <span>{count} items</span>}</div>;
}
```

## Common Patterns

### Loading State Pattern

```jsx
function DataComponent() {
  const [data, setData] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    fetchData()
      .then(setData)
      .catch(setError)
      .finally(() => setLoading(false));
  }, []);

  if (loading) return <LoadingSpinner />;
  if (error) return <ErrorMessage error={error} />;
  if (!data) return <NoData />;

  return <DisplayData data={data} />;
}
```

### Authentication Pattern

```jsx
function ProtectedRoute({ user, children }) {
  if (!user) {
    return <Navigate to="/login" />;
  }

  if (!user.isVerified) {
    return <VerificationRequired />;
  }

  if (!user.hasAccess) {
    return <AccessDenied />;
  }

  return children;
}
```

### Feature Flag Pattern

```jsx
function Feature({ featureFlags, flagName, children, fallback = null }) {
  const isEnabled = featureFlags[flagName];

  return isEnabled ? children : fallback;
}

// Usage
function App({ featureFlags }) {
  return (
    <div>
      <Feature featureFlags={featureFlags} flagName="newUI">
        <NewUIComponent />
      </Feature>
      
      <Feature 
        featureFlags={featureFlags} 
        flagName="betaFeature"
        fallback={<ComingSoon />}
      >
        <BetaFeature />
      </Feature>
    </div>
  );
}
```

### Empty State Pattern

```jsx
function ItemList({ items, loading }) {
  if (loading) {
    return <LoadingState />;
  }

  if (!items || items.length === 0) {
    return (
      <EmptyState
        title="No items found"
        description="Get started by creating your first item"
        action={<CreateButton />}
      />
    );
  }

  return (
    <ul>
      {items.map(item => (
        <ItemCard key={item.id} item={item} />
      ))}
    </ul>
  );
}
```

### Permission-Based Rendering

```jsx
function PermissionGate({ userPermissions, requiredPermission, children, fallback = null }) {
  const hasPermission = userPermissions.includes(requiredPermission);

  return hasPermission ? children : fallback;
}

// Usage
function AdminPanel({ userPermissions }) {
  return (
    <div>
      <PermissionGate 
        userPermissions={userPermissions} 
        requiredPermission="admin"
        fallback={<AccessDenied />}
      >
        <AdminControls />
      </PermissionGate>

      <PermissionGate 
        userPermissions={userPermissions} 
        requiredPermission="edit"
      >
        <EditButton />
      </PermissionGate>
    </div>
  );
}
```

### Responsive Rendering Pattern

```jsx
function ResponsiveLayout() {
  const [isMobile, setIsMobile] = useState(window.innerWidth < 768);

  useEffect(() => {
    const handleResize = () => {
      setIsMobile(window.innerWidth < 768);
    };

    window.addEventListener('resize', handleResize);
    return () => window.removeEventListener('resize', handleResize);
  }, []);

  return (
    <div>
      {isMobile ? (
        <MobileNavigation />
      ) : (
        <DesktopNavigation />
      )}
    </div>
  );
}
```

## Summary

Conditional rendering is a fundamental concept in React that allows you to:

- Show/hide UI elements dynamically
- Handle different states (loading, error, success)
- Create adaptive user interfaces
- Control access and permissions
- Provide fallback content

**Key Takeaways:**
- Use ternary operators for simple conditions
- Use logical AND (&&) for showing/hiding elements
- Use early returns for cleaner code
- Extract complex conditions into variables
- Watch out for falsy values (0, '', false)
- Keep conditions simple and readable
- Use appropriate patterns for common scenarios

Choose the right technique based on your specific use case and prioritize code readability and maintainability.

---

**Related Topics:**
- [Components](02_COMPONENTS.md)
- [State Management](03_STATE_MANAGEMENT.md)
- [Event Handling](05_EVENT_HANDLING.md)
- [Lists and Keys](07_LISTS_KEYS.md)
