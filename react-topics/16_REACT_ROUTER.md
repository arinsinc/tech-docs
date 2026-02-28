# React Router

React Router is the standard routing library for React applications, enabling navigation between views and URL management.

## Table of Contents
- [Setup and Installation](#setup-and-installation)
- [Basic Routing](#basic-routing)
- [Navigation](#navigation)
- [Dynamic Routes](#dynamic-routes)
- [Nested Routes](#nested-routes)
- [Protected Routes](#protected-routes)
- [Route Parameters and Query Strings](#route-parameters-and-query-strings)
- [Advanced Patterns](#advanced-patterns)

---

## Setup and Installation

### Installation

```bash
npm install react-router-dom
```

### Basic Setup (React Router v6)

```javascript
import { BrowserRouter, Routes, Route } from 'react-router-dom';

function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<Home />} />
        <Route path="/about" element={<About />} />
        <Route path="/contact" element={<Contact />} />
      </Routes>
    </BrowserRouter>
  );
}
```

### Router Types

```javascript
// Browser Router - Uses HTML5 history API
import { BrowserRouter } from 'react-router-dom';

// Hash Router - Uses URL hash (#)
import { HashRouter } from 'react-router-dom';

// Memory Router - Keeps history in memory (for testing)
import { MemoryRouter } from 'react-router-dom';
```

---

## Basic Routing

### Simple Routes

```javascript
import { BrowserRouter, Routes, Route } from 'react-router-dom';

function App() {
  return (
    <BrowserRouter>
      <nav>
        <Link to="/">Home</Link>
        <Link to="/about">About</Link>
        <Link to="/contact">Contact</Link>
      </nav>
      
      <Routes>
        <Route path="/" element={<Home />} />
        <Route path="/about" element={<About />} />
        <Route path="/contact" element={<Contact />} />
        <Route path="*" element={<NotFound />} />
      </Routes>
    </BrowserRouter>
  );
}

function Home() {
  return <h1>Home Page</h1>;
}

function About() {
  return <h1>About Page</h1>;
}

function NotFound() {
  return <h1>404 - Page Not Found</h1>;
}
```

### Index Routes

```javascript
<Routes>
  <Route path="/" element={<Layout />}>
    <Route index element={<Home />} /> {/* Shows at "/" */}
    <Route path="about" element={<About />} />
    <Route path="contact" element={<Contact />} />
  </Route>
</Routes>

function Layout() {
  return (
    <div>
      <nav>{/* navigation */}</nav>
      <Outlet /> {/* Child routes render here */}
      <footer>{/* footer */}</footer>
    </div>
  );
}
```

---

## Navigation

### Link Component

```javascript
import { Link } from 'react-router-dom';

function Navigation() {
  return (
    <nav>
      <Link to="/">Home</Link>
      <Link to="/about">About</Link>
      <Link to="/products">Products</Link>
      
      {/* With state */}
      <Link to="/profile" state={{ from: 'navigation' }}>
        Profile
      </Link>
      
      {/* Replace instead of push */}
      <Link to="/login" replace>
        Login
      </Link>
    </nav>
  );
}
```

### NavLink Component (Active Styling)

```javascript
import { NavLink } from 'react-router-dom';

function Navigation() {
  return (
    <nav>
      <NavLink
        to="/"
        className={({ isActive }) => isActive ? 'active' : ''}
      >
        Home
      </NavLink>
      
      <NavLink
        to="/about"
        style={({ isActive }) => ({
          color: isActive ? 'red' : 'black',
          fontWeight: isActive ? 'bold' : 'normal'
        })}
      >
        About
      </NavLink>
      
      {/* Custom active indicator */}
      <NavLink to="/products">
        {({ isActive }) => (
          <span>
            Products {isActive && '👈'}
          </span>
        )}
      </NavLink>
    </nav>
  );
}
```

### Programmatic Navigation

```javascript
import { useNavigate } from 'react-router-dom';

function LoginForm() {
  const navigate = useNavigate();
  
  const handleSubmit = async (e) => {
    e.preventDefault();
    await login(credentials);
    
    // Navigate to dashboard
    navigate('/dashboard');
    
    // Navigate with state
    navigate('/dashboard', { state: { from: 'login' } });
    
    // Replace current entry
    navigate('/dashboard', { replace: true });
    
    // Go back
    navigate(-1);
    
    // Go forward
    navigate(1);
  };
  
  return <form onSubmit={handleSubmit}>{/* form fields */}</form>;
}
```

### Navigate Component (Redirect)

```javascript
import { Navigate } from 'react-router-dom';

function ProtectedRoute({ children }) {
  const isAuthenticated = useAuth();
  
  if (!isAuthenticated) {
    return <Navigate to="/login" replace />;
  }
  
  return children;
}

// Usage
<Route
  path="/dashboard"
  element={
    <ProtectedRoute>
      <Dashboard />
    </ProtectedRoute>
  }
/>
```

---

## Dynamic Routes

### URL Parameters

```javascript
// Define route with parameter
<Route path="/users/:userId" element={<UserProfile />} />
<Route path="/posts/:postId/comments/:commentId" element={<Comment />} />

// Access parameters
import { useParams } from 'react-router-dom';

function UserProfile() {
  const { userId } = useParams();
  
  const [user, setUser] = useState(null);
  
  useEffect(() => {
    fetchUser(userId).then(setUser);
  }, [userId]);
  
  return (
    <div>
      <h1>User Profile</h1>
      {user && <p>{user.name}</p>}
    </div>
  );
}
```

### Optional Parameters

```javascript
// Optional segment
<Route path="/products/:category?" element={<Products />} />

function Products() {
  const { category } = useParams();
  
  return (
    <div>
      <h1>Products</h1>
      {category ? (
        <p>Showing: {category}</p>
      ) : (
        <p>Showing all products</p>
      )}
    </div>
  );
}
```

### Wildcard Routes

```javascript
// Catch-all route
<Route path="/docs/*" element={<Documentation />} />

function Documentation() {
  const location = useLocation();
  const path = location.pathname.replace('/docs/', '');
  
  return <div>Documentation: {path}</div>;
}
```

---

## Nested Routes

### Basic Nested Routes

```javascript
function App() {
  return (
    <Routes>
      <Route path="/" element={<Layout />}>
        <Route index element={<Home />} />
        <Route path="products" element={<Products />}>
          <Route index element={<ProductList />} />
          <Route path=":productId" element={<ProductDetail />} />
          <Route path="new" element={<NewProduct />} />
        </Route>
      </Route>
    </Routes>
  );
}

function Layout() {
  return (
    <div>
      <nav>{/* navigation */}</nav>
      <main>
        <Outlet /> {/* Nested routes render here */}
      </main>
    </div>
  );
}

function Products() {
  return (
    <div>
      <h1>Products</h1>
      <aside>{/* sidebar */}</aside>
      <div>
        <Outlet /> {/* ProductList, ProductDetail, or NewProduct */}
      </div>
    </div>
  );
}
```

### Context with Outlets

```javascript
import { Outlet, useOutletContext } from 'react-router-dom';

function Dashboard() {
  const [user, setUser] = useState(null);
  
  return (
    <div>
      <h1>Dashboard</h1>
      <Outlet context={{ user, setUser }} />
    </div>
  );
}

function Profile() {
  const { user } = useOutletContext();
  
  return <div>Welcome, {user.name}</div>;
}

// Routes
<Route path="/dashboard" element={<Dashboard />}>
  <Route path="profile" element={<Profile />} />
</Route>
```

---

## Protected Routes

### Authentication Guard

```javascript
function ProtectedRoute({ children }) {
  const { user, loading } = useAuth();
  const location = useLocation();
  
  if (loading) {
    return <div>Loading...</div>;
  }
  
  if (!user) {
    // Redirect to login, save intended destination
    return <Navigate to="/login" state={{ from: location }} replace />;
  }
  
  return children;
}

// Usage
<Route
  path="/dashboard"
  element={
    <ProtectedRoute>
      <Dashboard />
    </ProtectedRoute>
  }
/>
```

### Role-Based Access

```javascript
function RoleProtectedRoute({ children, allowedRoles }) {
  const { user } = useAuth();
  
  if (!user) {
    return <Navigate to="/login" replace />;
  }
  
  if (!allowedRoles.includes(user.role)) {
    return <Navigate to="/unauthorized" replace />;
  }
  
  return children;
}

// Usage
<Route
  path="/admin"
  element={
    <RoleProtectedRoute allowedRoles={['admin']}>
      <AdminPanel />
    </RoleProtectedRoute>
  }
/>
```

### Redirect After Login

```javascript
function LoginPage() {
  const navigate = useNavigate();
  const location = useLocation();
  
  const from = location.state?.from?.pathname || '/';
  
  const handleLogin = async (credentials) => {
    await login(credentials);
    navigate(from, { replace: true });
  };
  
  return <LoginForm onSubmit={handleLogin} />;
}
```

---

## Route Parameters and Query Strings

### Reading Query Parameters

```javascript
import { useSearchParams } from 'react-router-dom';

function SearchPage() {
  const [searchParams, setSearchParams] = useSearchParams();
  
  const query = searchParams.get('q');
  const page = searchParams.get('page') || 1;
  const sort = searchParams.get('sort') || 'relevance';
  
  const handleSearch = (newQuery) => {
    setSearchParams({ q: newQuery, page: 1 });
  };
  
  const handlePageChange = (newPage) => {
    setSearchParams({ q: query, page: newPage, sort });
  };
  
  return (
    <div>
      <h1>Search Results for: {query}</h1>
      <p>Page: {page}, Sort: {sort}</p>
      
      {/* Update query params */}
      <button onClick={() => handlePageChange(Number(page) + 1)}>
        Next Page
      </button>
    </div>
  );
}

// URL: /search?q=react&page=2&sort=date
```

### Programmatic Query Updates

```javascript
function FilteredProducts() {
  const [searchParams, setSearchParams] = useSearchParams();
  
  const category = searchParams.get('category');
  const minPrice = searchParams.get('minPrice');
  const maxPrice = searchParams.get('maxPrice');
  
  const updateFilter = (key, value) => {
    const newParams = new URLSearchParams(searchParams);
    
    if (value) {
      newParams.set(key, value);
    } else {
      newParams.delete(key);
    }
    
    setSearchParams(newParams);
  };
  
  return (
    <div>
      <select
        value={category || ''}
        onChange={(e) => updateFilter('category', e.target.value)}
      >
        <option value="">All Categories</option>
        <option value="electronics">Electronics</option>
        <option value="clothing">Clothing</option>
      </select>
      
      <input
        type="number"
        value={minPrice || ''}
        onChange={(e) => updateFilter('minPrice', e.target.value)}
        placeholder="Min Price"
      />
    </div>
  );
}
```

### Location State

```javascript
import { useLocation, useNavigate } from 'react-router-dom';

// Passing state
function ProductList() {
  const navigate = useNavigate();
  
  const viewProduct = (product) => {
    navigate(`/products/${product.id}`, {
      state: { from: 'product-list', product }
    });
  };
  
  return (
    <div>
      {products.map(product => (
        <button key={product.id} onClick={() => viewProduct(product)}>
          View {product.name}
        </button>
      ))}
    </div>
  );
}

// Reading state
function ProductDetail() {
  const location = useLocation();
  const { from, product } = location.state || {};
  
  return (
    <div>
      {from && <p>Came from: {from}</p>}
      {product && <p>Pre-loaded: {product.name}</p>}
    </div>
  );
}
```

---

## Advanced Patterns

### Lazy Loading Routes

```javascript
import { lazy, Suspense } from 'react';

const Dashboard = lazy(() => import('./pages/Dashboard'));
const Profile = lazy(() => import('./pages/Profile'));
const Settings = lazy(() => import('./pages/Settings'));

function App() {
  return (
    <BrowserRouter>
      <Suspense fallback={<div>Loading...</div>}>
        <Routes>
          <Route path="/" element={<Home />} />
          <Route path="/dashboard" element={<Dashboard />} />
          <Route path="/profile" element={<Profile />} />
          <Route path="/settings" element={<Settings />} />
        </Routes>
      </Suspense>
    </BrowserRouter>
  );
}
```

### Route Configuration

```javascript
const routes = [
  {
    path: '/',
    element: <Layout />,
    children: [
      { index: true, element: <Home /> },
      { path: 'about', element: <About /> },
      {
        path: 'products',
        element: <Products />,
        children: [
          { index: true, element: <ProductList /> },
          { path: ':productId', element: <ProductDetail /> }
        ]
      }
    ]
  }
];

function App() {
  return (
    <BrowserRouter>
      {useRoutes(routes)}
    </BrowserRouter>
  );
}
```

### Scroll Restoration

```javascript
import { useEffect } from 'react';
import { useLocation } from 'react-router-dom';

function ScrollToTop() {
  const { pathname } = useLocation();
  
  useEffect(() => {
    window.scrollTo(0, 0);
  }, [pathname]);
  
  return null;
}

function App() {
  return (
    <BrowserRouter>
      <ScrollToTop />
      <Routes>
        {/* routes */}
      </Routes>
    </BrowserRouter>
  );
}
```

### Route Transitions

```javascript
import { CSSTransition, TransitionGroup } from 'react-transition-group';

function AnimatedRoutes() {
  const location = useLocation();
  
  return (
    <TransitionGroup>
      <CSSTransition
        key={location.key}
        timeout={300}
        classNames="fade"
      >
        <Routes location={location}>
          <Route path="/" element={<Home />} />
          <Route path="/about" element={<About />} />
        </Routes>
      </CSSTransition>
    </TransitionGroup>
  );
}

// CSS
.fade-enter {
  opacity: 0;
}
.fade-enter-active {
  opacity: 1;
  transition: opacity 300ms;
}
.fade-exit {
  opacity: 1;
}
.fade-exit-active {
  opacity: 0;
  transition: opacity 300ms;
}
```

### Prompt Before Navigation

```javascript
function UnsavedChangesPrompt({ when, message }) {
  const blocker = useBlocker(when);
  
  useEffect(() => {
    if (blocker.state === 'blocked') {
      const proceed = window.confirm(message);
      if (proceed) {
        blocker.proceed();
      } else {
        blocker.reset();
      }
    }
  }, [blocker, message]);
  
  return null;
}

function EditForm() {
  const [hasUnsavedChanges, setHasUnsavedChanges] = useState(false);
  
  return (
    <>
      <UnsavedChangesPrompt
        when={hasUnsavedChanges}
        message="You have unsaved changes. Are you sure you want to leave?"
      />
      <form>{/* form content */}</form>
    </>
  );
}
```

---

## Complete Example

```javascript
import {
  BrowserRouter,
  Routes,
  Route,
  Link,
  NavLink,
  Navigate,
  useParams,
  useSearchParams,
  Outlet
} from 'react-router-dom';

function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<Layout />}>
          <Route index element={<Home />} />
          <Route path="about" element={<About />} />
          
          <Route path="products" element={<ProductsLayout />}>
            <Route index element={<ProductList />} />
            <Route path=":productId" element={<ProductDetail />} />
          </Route>
          
          <Route
            path="dashboard"
            element={
              <ProtectedRoute>
                <Dashboard />
              </ProtectedRoute>
            }
          />
          
          <Route path="*" element={<NotFound />} />
        </Route>
      </Routes>
    </BrowserRouter>
  );
}

function Layout() {
  return (
    <div>
      <nav>
        <NavLink to="/">Home</NavLink>
        <NavLink to="/about">About</NavLink>
        <NavLink to="/products">Products</NavLink>
        <NavLink to="/dashboard">Dashboard</NavLink>
      </nav>
      <main>
        <Outlet />
      </main>
    </div>
  );
}

function ProductList() {
  const [searchParams, setSearchParams] = useSearchParams();
  const category = searchParams.get('category');
  
  return (
    <div>
      <h1>Products {category && `in ${category}`}</h1>
      <Link to="/products/1">Product 1</Link>
      <Link to="/products/2">Product 2</Link>
    </div>
  );
}

function ProductDetail() {
  const { productId } = useParams();
  
  return <h1>Product {productId} Details</h1>;
}

function ProtectedRoute({ children }) {
  const isAuthenticated = useAuth();
  
  return isAuthenticated ? children : <Navigate to="/login" replace />;
}
```

---

## Key Takeaways

1. **BrowserRouter** wraps your entire app
2. **Routes & Route** define your app's navigation structure
3. **Link/NavLink** for declarative navigation
4. **useNavigate** for programmatic navigation
5. **useParams** to access URL parameters
6. **useSearchParams** for query strings
7. **Outlet** for nested route rendering
8. **Protect routes** with authentication guards

## Next Steps

- Learn about [State Libraries](17_STATE_LIBRARIES.md)
- Explore [Testing](18_TESTING.md) React applications
- Study [TypeScript with React](19_TYPESCRIPT_REACT.md)
