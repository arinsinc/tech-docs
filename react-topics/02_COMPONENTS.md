# Components

## Component Types

### Functional Components (Modern Approach)

Functional components are the modern way to write React components. They use hooks for state and side effects.

```jsx
function Welcome({ name }) {
  return <h1>Hello, {name}!</h1>;
}

// Arrow function syntax
const Welcome = ({ name }) => {
  return <h1>Hello, {name}!</h1>;
};

// Implicit return for simple components
const Welcome = ({ name }) => <h1>Hello, {name}!</h1>;
```

### Class Components (Legacy)

Class components are the older way of writing React components. Still supported but not recommended for new code.

```jsx
import React, { Component } from 'react';

class Welcome extends Component {
  render() {
    return <h1>Hello, {this.props.name}!</h1>;
  }
}
```

## Component Composition

### Basic Composition

```jsx
function Header() {
  return (
    <header>
      <h1>My Website</h1>
      <nav>Navigation</nav>
    </header>
  );
}

function MainContent() {
  return (
    <main>
      <h2>Main Content</h2>
      <p>Welcome to my website!</p>
    </main>
  );
}

function Footer() {
  return (
    <footer>
      <p>&copy; 2024 My Website</p>
    </footer>
  );
}

function App() {
  return (
    <div>
      <Header />
      <MainContent />
      <Footer />
    </div>
  );
}
```

### Nested Components

```jsx
function Avatar({ src, alt }) {
  return <img src={src} alt={alt} className="avatar" />;
}

function UserInfo({ user }) {
  return (
    <div className="user-info">
      <Avatar src={user.avatarUrl} alt={user.name} />
      <div>
        <h3>{user.name}</h3>
        <p>{user.email}</p>
      </div>
    </div>
  );
}

function UserCard({ user }) {
  return (
    <div className="user-card">
      <UserInfo user={user} />
      <p>{user.bio}</p>
    </div>
  );
}
```

## Props in Detail

### Props are Read-Only

```jsx
// ❌ Never modify props
function Button(props) {
  props.text = "Modified"; // ERROR: Props are immutable
  return <button>{props.text}</button>;
}

// ✅ Props should only be read
function Button({ text }) {
  return <button>{text}</button>;
}
```

### Passing Multiple Props

```jsx
// Individual props
<UserCard 
  name="John" 
  email="john@example.com" 
  age={30} 
  isActive={true}
/>

// Spread operator
const user = {
  name: "John",
  email: "john@example.com",
  age: 30,
  isActive: true
};

<UserCard {...user} />
```

### PropTypes (Type Checking)

```jsx
import PropTypes from 'prop-types';

function UserCard({ name, age, email, isActive }) {
  return (
    <div>
      <h2>{name}</h2>
      <p>Age: {age}</p>
      <p>Email: {email}</p>
      <p>Status: {isActive ? "Active" : "Inactive"}</p>
    </div>
  );
}

UserCard.propTypes = {
  name: PropTypes.string.isRequired,
  age: PropTypes.number.isRequired,
  email: PropTypes.string,
  isActive: PropTypes.bool
};

UserCard.defaultProps = {
  isActive: false
};
```

## Children Prop

### Basic Children

```jsx
function Container({ children }) {
  return (
    <div className="container">
      {children}
    </div>
  );
}

// Usage
<Container>
  <h1>Title</h1>
  <p>Content</p>
</Container>
```

### Multiple Children

```jsx
function Layout({ header, sidebar, content, footer }) {
  return (
    <div className="layout">
      <header>{header}</header>
      <div className="main">
        <aside>{sidebar}</aside>
        <main>{content}</main>
      </div>
      <footer>{footer}</footer>
    </div>
  );
}

// Usage
<Layout
  header={<Header />}
  sidebar={<Sidebar />}
  content={<MainContent />}
  footer={<Footer />}
/>
```

### Children Manipulation

```jsx
import React from 'react';

function List({ children }) {
  return (
    <ul>
      {React.Children.map(children, (child, index) => (
        <li key={index}>{child}</li>
      ))}
    </ul>
  );
}

// Usage
<List>
  <span>Item 1</span>
  <span>Item 2</span>
  <span>Item 3</span>
</List>
```

## Component Patterns

### Container/Presentational Pattern

```jsx
// Presentational Component (UI only)
function UserListView({ users, onUserClick }) {
  return (
    <ul>
      {users.map(user => (
        <li key={user.id} onClick={() => onUserClick(user)}>
          {user.name}
        </li>
      ))}
    </ul>
  );
}

// Container Component (Logic)
function UserListContainer() {
  const [users, setUsers] = useState([]);
  
  useEffect(() => {
    fetchUsers().then(setUsers);
  }, []);
  
  const handleUserClick = (user) => {
    console.log('Clicked:', user);
  };
  
  return <UserListView users={users} onUserClick={handleUserClick} />;
}
```

### Composition vs Inheritance

React recommends composition over inheritance.

```jsx
// ✅ Good: Using composition
function Dialog({ title, children }) {
  return (
    <div className="dialog">
      <h2>{title}</h2>
      <div className="dialog-content">
        {children}
      </div>
    </div>
  );
}

function WelcomeDialog() {
  return (
    <Dialog title="Welcome">
      <p>Thank you for visiting!</p>
    </Dialog>
  );
}

// ✅ Good: Specialized components
function ConfirmDialog({ title, message, onConfirm, onCancel }) {
  return (
    <Dialog title={title}>
      <p>{message}</p>
      <button onClick={onConfirm}>Confirm</button>
      <button onClick={onCancel}>Cancel</button>
    </Dialog>
  );
}
```

## Component Organization

### File Structure

```
src/
  components/
    Button/
      Button.jsx
      Button.module.css
      Button.test.jsx
      index.js
    UserCard/
      UserCard.jsx
      UserCard.module.css
      index.js
  pages/
    Home.jsx
    Profile.jsx
  App.jsx
```

### Exporting Components

```jsx
// Button.jsx
export function Button({ children, onClick }) {
  return <button onClick={onClick}>{children}</button>;
}

// index.js
export { Button } from './Button';

// Usage in other files
import { Button } from './components/Button';
```

### Named vs Default Exports

```jsx
// Named export
export function Button() { }
export function Icon() { }

// Import named exports
import { Button, Icon } from './components';

// Default export
export default function Button() { }

// Import default export
import Button from './components/Button';
```

## Styling Components

### Inline Styles

```jsx
function StyledButton() {
  const buttonStyle = {
    backgroundColor: 'blue',
    color: 'white',
    padding: '10px 20px',
    border: 'none',
    borderRadius: '5px'
  };
  
  return <button style={buttonStyle}>Click me</button>;
}
```

### CSS Modules

```jsx
// Button.module.css
.button {
  background-color: blue;
  color: white;
  padding: 10px 20px;
}

// Button.jsx
import styles from './Button.module.css';

function Button() {
  return <button className={styles.button}>Click me</button>;
}
```

### Conditional Classes

```jsx
function Button({ primary, disabled }) {
  const className = `
    button
    ${primary ? 'button-primary' : 'button-secondary'}
    ${disabled ? 'button-disabled' : ''}
  `.trim();
  
  return <button className={className}>Click me</button>;
}

// Using classnames library
import classNames from 'classnames';

function Button({ primary, disabled }) {
  return (
    <button className={classNames('button', {
      'button-primary': primary,
      'button-secondary': !primary,
      'button-disabled': disabled
    })}>
      Click me
    </button>
  );
}
```

## Best Practices

1. **Single Responsibility**: Each component should do one thing well
2. **Reusability**: Design components to be reusable
3. **Prop Drilling**: Avoid passing props through many levels (use Context instead)
4. **Naming**: Use descriptive, PascalCase names for components
5. **File Organization**: One component per file (for main components)
6. **Composition**: Prefer composition over complex conditional rendering

## Common Pitfalls

```jsx
// ❌ Don't define components inside components
function Parent() {
  function Child() { // Bad: Recreated on every render
    return <div>Child</div>;
  }
  return <Child />;
}

// ✅ Define components at the top level
function Child() {
  return <div>Child</div>;
}

function Parent() {
  return <Child />;
}

// ❌ Don't mutate props
function Component({ user }) {
  user.name = "Changed"; // Bad: Mutating props
  return <div>{user.name}</div>;
}

// ✅ Create new objects/arrays
function Component({ user }) {
  const updatedUser = { ...user, name: "Changed" };
  return <div>{updatedUser.name}</div>;
}
```

## Summary

- Functional components are the modern standard
- Components enable reusable, maintainable code
- Props flow data from parent to child
- Composition is preferred over inheritance
- Keep components focused and simple

## Next Steps

Continue to [State Management](03_STATE_MANAGEMENT.md) to learn about managing component state.
