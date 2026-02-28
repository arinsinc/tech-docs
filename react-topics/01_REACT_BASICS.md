# React Basics

## What is React?

React is a JavaScript library for building user interfaces, particularly single-page applications. It was developed by Facebook (now Meta) and is maintained by Meta and a community of developers.

### Key Features
- **Declarative**: Design simple views for each state in your application
- **Component-Based**: Build encapsulated components that manage their own state
- **Learn Once, Write Anywhere**: Use React on the server with Node, or in mobile apps with React Native
- **Virtual DOM**: Efficient updating and rendering of components

## JSX (JavaScript XML)

JSX is a syntax extension for JavaScript that looks similar to HTML.

```jsx
// Basic JSX
const element = <h1>Hello, React!</h1>;

// JSX with expressions
const name = "World";
const element = <h1>Hello, {name}!</h1>;

// JSX with attributes
const element = <img src="logo.png" alt="Logo" />;

// JSX with children
const element = (
  <div>
    <h1>Title</h1>
    <p>Paragraph</p>
  </div>
);
```

### JSX Rules

1. **Return a single root element**
```jsx
// ❌ Wrong
return (
  <h1>Title</h1>
  <p>Text</p>
);

// ✅ Correct - wrap in a fragment
return (
  <>
    <h1>Title</h1>
    <p>Text</p>
  </>
);
```

2. **Close all tags**
```jsx
// ❌ Wrong
<img src="image.png">

// ✅ Correct
<img src="image.png" />
```

3. **Use camelCase for attributes**
```jsx
// HTML: class, onclick
// JSX: className, onClick
<button className="btn" onClick={handleClick}>
  Click me
</button>
```

## Components

Components are the building blocks of React applications.

### Functional Components

```jsx
// Simple component
function Welcome() {
  return <h1>Hello, World!</h1>;
}

// Arrow function component
const Welcome = () => {
  return <h1>Hello, World!</h1>;
};

// Component with props
function Greeting({ name }) {
  return <h1>Hello, {name}!</h1>;
}
```

### Using Components

```jsx
function App() {
  return (
    <div>
      <Welcome />
      <Greeting name="Alice" />
      <Greeting name="Bob" />
    </div>
  );
}
```

## Props (Properties)

Props are arguments passed to components, similar to function parameters.

```jsx
// Passing props
function App() {
  return <UserCard name="John" age={30} isActive={true} />;
}

// Receiving props
function UserCard(props) {
  return (
    <div>
      <h2>{props.name}</h2>
      <p>Age: {props.age}</p>
      <p>Status: {props.isActive ? "Active" : "Inactive"}</p>
    </div>
  );
}

// Destructuring props
function UserCard({ name, age, isActive }) {
  return (
    <div>
      <h2>{name}</h2>
      <p>Age: {age}</p>
      <p>Status: {isActive ? "Active" : "Inactive"}</p>
    </div>
  );
}
```

### Default Props

```jsx
function Button({ text = "Click me", color = "blue" }) {
  return <button style={{ backgroundColor: color }}>{text}</button>;
}

// Usage
<Button /> // Uses defaults
<Button text="Submit" color="green" />
```

### Children Prop

```jsx
function Card({ children }) {
  return (
    <div className="card">
      {children}
    </div>
  );
}

// Usage
<Card>
  <h2>Title</h2>
  <p>Content goes here</p>
</Card>
```

## Creating a React App

### Using Vite (Recommended)

```bash
npm create vite@latest my-app -- --template react
cd my-app
npm install
npm run dev
```

### Using Create React App

```bash
npx create-react-app my-app
cd my-app
npm start
```

## Basic App Structure

```jsx
// src/main.jsx or src/index.js
import React from 'react';
import ReactDOM from 'react-dom/client';
import App from './App';
import './index.css';

ReactDOM.createRoot(document.getElementById('root')).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);

// src/App.jsx
function App() {
  return (
    <div className="App">
      <h1>Welcome to React</h1>
      <p>Start building your app!</p>
    </div>
  );
}

export default App;
```

## React Developer Tools

Install React Developer Tools browser extension for debugging:
- Chrome: [React Developer Tools](https://chrome.google.com/webstore/detail/react-developer-tools/)
- Firefox: [React Developer Tools](https://addons.mozilla.org/en-US/firefox/addon/react-devtools/)

## Best Practices

1. **Use meaningful component names** (PascalCase)
2. **Keep components small and focused**
3. **Use props for data flow**
4. **Keep JSX readable** (break into multiple lines if needed)
5. **Use fragments** to avoid unnecessary div wrappers
6. **Extract reusable logic** into separate components

## Common Patterns

### Conditional Rendering in JSX

```jsx
function Greeting({ isLoggedIn, username }) {
  return (
    <div>
      {isLoggedIn ? (
        <h1>Welcome back, {username}!</h1>
      ) : (
        <h1>Please sign in.</h1>
      )}
    </div>
  );
}
```

### Rendering Lists

```jsx
function TodoList({ todos }) {
  return (
    <ul>
      {todos.map((todo, index) => (
        <li key={index}>{todo}</li>
      ))}
    </ul>
  );
}
```

## Summary

- React is a component-based library for building UIs
- JSX allows you to write HTML-like syntax in JavaScript
- Components are reusable pieces of UI
- Props pass data from parent to child components
- React uses a Virtual DOM for efficient updates

## Next Steps

Continue to [Components](02_COMPONENTS.md) to learn more about component types and composition.
