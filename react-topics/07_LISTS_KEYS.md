# Lists and Keys in React

## Table of Contents
- [Introduction](#introduction)
- [Rendering Lists](#rendering-lists)
- [The Key Prop](#the-key-prop)
- [Choosing Keys](#choosing-keys)
- [Common Mistakes](#common-mistakes)
- [Dynamic Lists](#dynamic-lists)
- [Nested Lists](#nested-lists)
- [List Operations](#list-operations)
- [Performance Optimization](#performance-optimization)
- [Best Practices](#best-practices)
- [Common Patterns](#common-patterns)

## Introduction

Lists are a fundamental part of most React applications. React provides an efficient way to render multiple similar components using JavaScript's array methods, primarily `map()`.

### Why Lists Matter
- Display collections of data
- Create repeating UI patterns
- Handle dynamic content
- Enable efficient updates with proper keys

## Rendering Lists

### Basic List Rendering

```jsx
function SimpleList() {
  const items = ['Apple', 'Banana', 'Orange', 'Grape'];

  return (
    <ul>
      {items.map((item, index) => (
        <li key={index}>{item}</li>
      ))}
    </ul>
  );
}
```

### Rendering Object Arrays

```jsx
function UserList() {
  const users = [
    { id: 1, name: 'Alice', email: 'alice@example.com' },
    { id: 2, name: 'Bob', email: 'bob@example.com' },
    { id: 3, name: 'Charlie', email: 'charlie@example.com' }
  ];

  return (
    <ul>
      {users.map(user => (
        <li key={user.id}>
          <strong>{user.name}</strong>: {user.email}
        </li>
      ))}
    </ul>
  );
}
```

### Rendering Component Lists

```jsx
function UserCard({ user }) {
  return (
    <div className="user-card">
      <h3>{user.name}</h3>
      <p>{user.email}</p>
      <p>{user.role}</p>
    </div>
  );
}

function UserGrid() {
  const users = [
    { id: 1, name: 'Alice', email: 'alice@example.com', role: 'Admin' },
    { id: 2, name: 'Bob', email: 'bob@example.com', role: 'User' },
    { id: 3, name: 'Charlie', email: 'charlie@example.com', role: 'Moderator' }
  ];

  return (
    <div className="user-grid">
      {users.map(user => (
        <UserCard key={user.id} user={user} />
      ))}
    </div>
  );
}
```

### Inline Map with JSX

```jsx
function ProductList({ products }) {
  return (
    <div className="product-list">
      {products.map(product => (
        <div key={product.id} className="product-card">
          <img src={product.image} alt={product.name} />
          <h3>{product.name}</h3>
          <p className="price">${product.price}</p>
          <button>Add to Cart</button>
        </div>
      ))}
    </div>
  );
}
```

## The Key Prop

### What is a Key?

Keys help React identify which items have changed, been added, or been removed. Keys should be given to elements inside an array to give them a stable identity.

```jsx
function TodoList({ todos }) {
  return (
    <ul>
      {todos.map(todo => (
        <li key={todo.id}>
          {todo.text}
        </li>
      ))}
    </ul>
  );
}
```

### Why Keys Matter

```jsx
// Without proper keys, React may not update correctly
function BrokenList() {
  const [items, setItems] = useState(['A', 'B', 'C']);

  const addItem = () => {
    setItems(['Z', ...items]); // Add item at beginning
  };

  return (
    <div>
      <button onClick={addItem}>Add Z</button>
      <ul>
        {/* ❌ Using index as key causes issues */}
        {items.map((item, index) => (
          <li key={index}>
            {item} <input type="text" />
          </li>
        ))}
      </ul>
    </div>
  );
}

// ✅ Proper implementation with unique keys
function FixedList() {
  const [items, setItems] = useState([
    { id: '1', text: 'A' },
    { id: '2', text: 'B' },
    { id: '3', text: 'C' }
  ]);

  const addItem = () => {
    setItems([{ id: Date.now().toString(), text: 'Z' }, ...items]);
  };

  return (
    <div>
      <button onClick={addItem}>Add Z</button>
      <ul>
        {items.map(item => (
          <li key={item.id}>
            {item.text} <input type="text" />
          </li>
        ))}
      </ul>
    </div>
  );
}
```

### How React Uses Keys

React uses keys to:
1. **Identify elements**: Track which items are which
2. **Optimize rendering**: Reuse DOM elements when possible
3. **Preserve state**: Maintain component state correctly
4. **Minimize re-renders**: Only update changed elements

## Choosing Keys

### Use Unique IDs (Best Practice)

```jsx
function PostList({ posts }) {
  return (
    <div>
      {posts.map(post => (
        <article key={post.id}>
          <h2>{post.title}</h2>
          <p>{post.content}</p>
        </article>
      ))}
    </div>
  );
}
```

### Database IDs

```jsx
function CommentList({ comments }) {
  return (
    <div>
      {comments.map(comment => (
        <div key={comment.id} className="comment">
          <p>{comment.author}</p>
          <p>{comment.text}</p>
        </div>
      ))}
    </div>
  );
}
```

### Generated IDs

```jsx
import { v4 as uuidv4 } from 'uuid';

function AddItemForm() {
  const [items, setItems] = useState([]);

  const addItem = (text) => {
    const newItem = {
      id: uuidv4(), // Generate unique ID
      text: text,
      createdAt: new Date()
    };
    setItems([...items, newItem]);
  };

  return (
    <div>
      {items.map(item => (
        <div key={item.id}>{item.text}</div>
      ))}
    </div>
  );
}
```

### Composite Keys

```jsx
function Matrix({ rows, cols }) {
  return (
    <div>
      {Array.from({ length: rows }, (_, i) => (
        <div key={`row-${i}`}>
          {Array.from({ length: cols }, (_, j) => (
            <span key={`cell-${i}-${j}`}>
              [{i}, {j}]
            </span>
          ))}
        </div>
      ))}
    </div>
  );
}
```

### Content-Based Keys (Use Carefully)

```jsx
// Only use when items are truly static and won't change
function TagList({ tags }) {
  return (
    <div>
      {tags.map(tag => (
        <span key={tag} className="tag">
          {tag}
        </span>
      ))}
    </div>
  );
}
```

## Common Mistakes

### Don't Use Array Index as Key (Usually)

```jsx
// ❌ Avoid - Causes issues when list changes
function BadList({ items }) {
  return (
    <ul>
      {items.map((item, index) => (
        <li key={index}>{item}</li>
      ))}
    </ul>
  );
}

// ✅ Good - Use unique IDs
function GoodList({ items }) {
  return (
    <ul>
      {items.map(item => (
        <li key={item.id}>{item.text}</li>
      ))}
    </ul>
  );
}
```

### When Index Keys Are Acceptable

```jsx
// ✅ OK - Static list that never changes
function StaticList() {
  const months = [
    'January', 'February', 'March', 'April',
    'May', 'June', 'July', 'August',
    'September', 'October', 'November', 'December'
  ];

  return (
    <ul>
      {months.map((month, index) => (
        <li key={index}>{month}</li>
      ))}
    </ul>
  );
}
```

### Don't Generate Keys On-The-Fly

```jsx
// ❌ Avoid - Generates new key on every render
function BadKeyGeneration({ items }) {
  return (
    <ul>
      {items.map(item => (
        <li key={Math.random()}>{item.text}</li>
      ))}
    </ul>
  );
}

// ✅ Good - Stable keys
function GoodKeyGeneration({ items }) {
  return (
    <ul>
      {items.map(item => (
        <li key={item.id}>{item.text}</li>
      ))}
    </ul>
  );
}
```

### Keys Must Be Unique Among Siblings

```jsx
// ✅ Keys only need to be unique among siblings
function MultipleLists() {
  const fruits = [
    { id: 1, name: 'Apple' },
    { id: 2, name: 'Banana' }
  ];

  const vegetables = [
    { id: 1, name: 'Carrot' }, // Same ID as Apple, but in different list - OK!
    { id: 2, name: 'Broccoli' }
  ];

  return (
    <div>
      <h2>Fruits</h2>
      <ul>
        {fruits.map(item => (
          <li key={item.id}>{item.name}</li>
        ))}
      </ul>

      <h2>Vegetables</h2>
      <ul>
        {vegetables.map(item => (
          <li key={item.id}>{item.name}</li>
        ))}
      </ul>
    </div>
  );
}
```

## Dynamic Lists

### Adding Items

```jsx
function TodoApp() {
  const [todos, setTodos] = useState([]);
  const [input, setInput] = useState('');

  const addTodo = () => {
    if (input.trim()) {
      const newTodo = {
        id: Date.now(),
        text: input,
        completed: false
      };
      setTodos([...todos, newTodo]);
      setInput('');
    }
  };

  return (
    <div>
      <input
        value={input}
        onChange={(e) => setInput(e.target.value)}
        onKeyPress={(e) => e.key === 'Enter' && addTodo()}
      />
      <button onClick={addTodo}>Add</button>
      
      <ul>
        {todos.map(todo => (
          <li key={todo.id}>{todo.text}</li>
        ))}
      </ul>
    </div>
  );
}
```

### Removing Items

```jsx
function ItemList() {
  const [items, setItems] = useState([
    { id: 1, name: 'Item 1' },
    { id: 2, name: 'Item 2' },
    { id: 3, name: 'Item 3' }
  ]);

  const removeItem = (id) => {
    setItems(items.filter(item => item.id !== id));
  };

  return (
    <ul>
      {items.map(item => (
        <li key={item.id}>
          {item.name}
          <button onClick={() => removeItem(item.id)}>Remove</button>
        </li>
      ))}
    </ul>
  );
}
```

### Updating Items

```jsx
function TodoList() {
  const [todos, setTodos] = useState([
    { id: 1, text: 'Learn React', completed: false },
    { id: 2, text: 'Build a project', completed: false }
  ]);

  const toggleTodo = (id) => {
    setTodos(todos.map(todo =>
      todo.id === id ? { ...todo, completed: !todo.completed } : todo
    ));
  };

  return (
    <ul>
      {todos.map(todo => (
        <li key={todo.id}>
          <input
            type="checkbox"
            checked={todo.completed}
            onChange={() => toggleTodo(todo.id)}
          />
          <span style={{ textDecoration: todo.completed ? 'line-through' : 'none' }}>
            {todo.text}
          </span>
        </li>
      ))}
    </ul>
  );
}
```

### Sorting and Filtering

```jsx
function SortableList() {
  const [items, setItems] = useState([
    { id: 1, name: 'Banana', price: 2.99 },
    { id: 2, name: 'Apple', price: 1.99 },
    { id: 3, name: 'Cherry', price: 4.99 }
  ]);
  const [sortBy, setSortBy] = useState('name');
  const [filterText, setFilterText] = useState('');

  const sortedAndFilteredItems = items
    .filter(item => item.name.toLowerCase().includes(filterText.toLowerCase()))
    .sort((a, b) => {
      if (sortBy === 'name') return a.name.localeCompare(b.name);
      if (sortBy === 'price') return a.price - b.price;
      return 0;
    });

  return (
    <div>
      <input
        type="text"
        placeholder="Filter..."
        value={filterText}
        onChange={(e) => setFilterText(e.target.value)}
      />
      <select value={sortBy} onChange={(e) => setSortBy(e.target.value)}>
        <option value="name">Sort by Name</option>
        <option value="price">Sort by Price</option>
      </select>

      <ul>
        {sortedAndFilteredItems.map(item => (
          <li key={item.id}>
            {item.name} - ${item.price}
          </li>
        ))}
      </ul>
    </div>
  );
}
```

## Nested Lists

### Simple Nested Lists

```jsx
function NestedList() {
  const categories = [
    {
      id: 1,
      name: 'Fruits',
      items: [
        { id: 101, name: 'Apple' },
        { id: 102, name: 'Banana' }
      ]
    },
    {
      id: 2,
      name: 'Vegetables',
      items: [
        { id: 201, name: 'Carrot' },
        { id: 202, name: 'Broccoli' }
      ]
    }
  ];

  return (
    <div>
      {categories.map(category => (
        <div key={category.id}>
          <h3>{category.name}</h3>
          <ul>
            {category.items.map(item => (
              <li key={item.id}>{item.name}</li>
            ))}
          </ul>
        </div>
      ))}
    </div>
  );
}
```

### Complex Nested Structures

```jsx
function CommentThread({ comments }) {
  return (
    <div className="comments">
      {comments.map(comment => (
        <div key={comment.id} className="comment">
          <p>{comment.author}: {comment.text}</p>
          {comment.replies && comment.replies.length > 0 && (
            <div className="replies">
              <CommentThread comments={comment.replies} />
            </div>
          )}
        </div>
      ))}
    </div>
  );
}
```

### Tree Structures

```jsx
function TreeNode({ node }) {
  const [expanded, setExpanded] = useState(false);

  return (
    <div className="tree-node">
      <div onClick={() => setExpanded(!expanded)}>
        {node.children && (
          <span>{expanded ? '▼' : '►'}</span>
        )}
        {node.name}
      </div>
      {expanded && node.children && (
        <div className="children">
          {node.children.map(child => (
            <TreeNode key={child.id} node={child} />
          ))}
        </div>
      )}
    </div>
  );
}
```

## List Operations

### Pagination

```jsx
function PaginatedList({ items, itemsPerPage = 10 }) {
  const [currentPage, setCurrentPage] = useState(1);

  const totalPages = Math.ceil(items.length / itemsPerPage);
  const startIndex = (currentPage - 1) * itemsPerPage;
  const endIndex = startIndex + itemsPerPage;
  const currentItems = items.slice(startIndex, endIndex);

  return (
    <div>
      <ul>
        {currentItems.map(item => (
          <li key={item.id}>{item.name}</li>
        ))}
      </ul>

      <div className="pagination">
        <button
          onClick={() => setCurrentPage(currentPage - 1)}
          disabled={currentPage === 1}
        >
          Previous
        </button>
        <span>Page {currentPage} of {totalPages}</span>
        <button
          onClick={() => setCurrentPage(currentPage + 1)}
          disabled={currentPage === totalPages}
        >
          Next
        </button>
      </div>
    </div>
  );
}
```

### Infinite Scroll

```jsx
function InfiniteScrollList() {
  const [items, setItems] = useState([]);
  const [page, setPage] = useState(1);
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    const fetchItems = async () => {
      setLoading(true);
      const newItems = await fetch(`/api/items?page=${page}`).then(r => r.json());
      setItems([...items, ...newItems]);
      setLoading(false);
    };

    fetchItems();
  }, [page]);

  useEffect(() => {
    const handleScroll = () => {
      if (window.innerHeight + window.scrollY >= document.body.offsetHeight - 100) {
        setPage(page + 1);
      }
    };

    window.addEventListener('scroll', handleScroll);
    return () => window.removeEventListener('scroll', handleScroll);
  }, [page]);

  return (
    <div>
      {items.map(item => (
        <div key={item.id}>{item.name}</div>
      ))}
      {loading && <div>Loading...</div>}
    </div>
  );
}
```

### Drag and Drop

```jsx
function DraggableList() {
  const [items, setItems] = useState([
    { id: 1, text: 'Item 1' },
    { id: 2, text: 'Item 2' },
    { id: 3, text: 'Item 3' }
  ]);

  const handleDragStart = (e, index) => {
    e.dataTransfer.effectAllowed = 'move';
    e.dataTransfer.setData('text/html', index);
  };

  const handleDragOver = (e) => {
    e.preventDefault();
  };

  const handleDrop = (e, dropIndex) => {
    const dragIndex = parseInt(e.dataTransfer.getData('text/html'));
    const newItems = [...items];
    const draggedItem = newItems[dragIndex];
    newItems.splice(dragIndex, 1);
    newItems.splice(dropIndex, 0, draggedItem);
    setItems(newItems);
  };

  return (
    <ul>
      {items.map((item, index) => (
        <li
          key={item.id}
          draggable
          onDragStart={(e) => handleDragStart(e, index)}
          onDragOver={handleDragOver}
          onDrop={(e) => handleDrop(e, index)}
        >
          {item.text}
        </li>
      ))}
    </ul>
  );
}
```

## Performance Optimization

### Memoization with React.memo

```jsx
const ListItem = React.memo(({ item, onDelete }) => {
  console.log('Rendering:', item.name);
  return (
    <li>
      {item.name}
      <button onClick={() => onDelete(item.id)}>Delete</button>
    </li>
  );
});

function OptimizedList() {
  const [items, setItems] = useState([
    { id: 1, name: 'Item 1' },
    { id: 2, name: 'Item 2' },
    { id: 3, name: 'Item 3' }
  ]);

  const handleDelete = useCallback((id) => {
    setItems(items => items.filter(item => item.id !== id));
  }, []);

  return (
    <ul>
      {items.map(item => (
        <ListItem key={item.id} item={item} onDelete={handleDelete} />
      ))}
    </ul>
  );
}
```

### Virtualization for Large Lists

```jsx
import { FixedSizeList } from 'react-window';

function VirtualizedList({ items }) {
  const Row = ({ index, style }) => (
    <div style={style}>
      {items[index].name}
    </div>
  );

  return (
    <FixedSizeList
      height={400}
      itemCount={items.length}
      itemSize={35}
      width="100%"
    >
      {Row}
    </FixedSizeList>
  );
}
```

## Best Practices

### 1. Always Use Keys

```jsx
// ✅ Always provide keys
function GoodList({ items }) {
  return (
    <ul>
      {items.map(item => (
        <li key={item.id}>{item.text}</li>
      ))}
    </ul>
  );
}
```

### 2. Keys Should Be Stable

```jsx
// ❌ Avoid - Unstable keys
function BadList({ items }) {
  return (
    <ul>
      {items.map((item, index) => (
        <li key={`${item.text}-${index}`}>{item.text}</li>
      ))}
    </ul>
  );
}

// ✅ Good - Stable unique IDs
function GoodList({ items }) {
  return (
    <ul>
      {items.map(item => (
        <li key={item.id}>{item.text}</li>
      ))}
    </ul>
  );
}
```

### 3. Extract List Items to Components

```jsx
// ✅ Clean and reusable
function TodoItem({ todo, onToggle, onDelete }) {
  return (
    <li>
      <input
        type="checkbox"
        checked={todo.completed}
        onChange={() => onToggle(todo.id)}
      />
      <span>{todo.text}</span>
      <button onClick={() => onDelete(todo.id)}>Delete</button>
    </li>
  );
}

function TodoList({ todos, onToggle, onDelete }) {
  return (
    <ul>
      {todos.map(todo => (
        <TodoItem
          key={todo.id}
          todo={todo}
          onToggle={onToggle}
          onDelete={onDelete}
        />
      ))}
    </ul>
  );
}
```

### 4. Handle Empty States

```jsx
function List({ items }) {
  if (items.length === 0) {
    return <p>No items to display</p>;
  }

  return (
    <ul>
      {items.map(item => (
        <li key={item.id}>{item.text}</li>
      ))}
    </ul>
  );
}
```

## Common Patterns

### Grouped Lists

```jsx
function GroupedList({ items }) {
  const groupedItems = items.reduce((acc, item) => {
    const category = item.category;
    if (!acc[category]) {
      acc[category] = [];
    }
    acc[category].push(item);
    return acc;
  }, {});

  return (
    <div>
      {Object.entries(groupedItems).map(([category, items]) => (
        <div key={category}>
          <h3>{category}</h3>
          <ul>
            {items.map(item => (
              <li key={item.id}>{item.name}</li>
            ))}
          </ul>
        </div>
      ))}
    </div>
  );
}
```

### Master-Detail Pattern

```jsx
function MasterDetail({ items }) {
  const [selectedId, setSelectedId] = useState(null);
  const selectedItem = items.find(item => item.id === selectedId);

  return (
    <div className="master-detail">
      <div className="master">
        <ul>
          {items.map(item => (
            <li
              key={item.id}
              onClick={() => setSelectedId(item.id)}
              className={selectedId === item.id ? 'selected' : ''}
            >
              {item.name}
            </li>
          ))}
        </ul>
      </div>
      <div className="detail">
        {selectedItem ? (
          <div>
            <h2>{selectedItem.name}</h2>
            <p>{selectedItem.description}</p>
          </div>
        ) : (
          <p>Select an item</p>
        )}
      </div>
    </div>
  );
}
```

## Summary

Lists and keys are essential concepts in React:

**Key Points:**
- Use `map()` to render lists of elements
- Always provide unique keys for list items
- Keys help React identify which items changed
- Prefer stable, unique IDs over array indices
- Extract list items into separate components
- Handle empty states gracefully
- Optimize large lists with virtualization
- Use proper patterns for complex list operations

**Remember:**
- Keys must be unique among siblings
- Don't generate keys during render
- Index as key is only acceptable for static lists
- Keys are not passed as props to components

Mastering lists and keys enables you to build dynamic, performant React applications with complex data structures.

---

**Related Topics:**
- [Components](02_COMPONENTS.md)
- [State Management](03_STATE_MANAGEMENT.md)
- [Conditional Rendering](06_CONDITIONAL_RENDERING.md)
- [Performance Optimization](14_PERFORMANCE.md)
