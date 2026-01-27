# Hash Tables & Hash Maps

## 📋 Overview

Hash tables (also called hash maps) are one of the most important data structures in computer science. They provide extremely fast data access by using a hash function to map keys to array positions, enabling average O(1) time complexity for insertion, deletion, and lookup operations.

---

## 🎯 Core Concepts

### What is a Hash Table?

A hash table is a data structure that implements an associative array - a structure that can map keys to values. It uses a **hash function** to compute an index into an array of buckets or slots, from which the desired value can be found.

**Key Components:**
1. **Keys**: Unique identifiers used to store and retrieve values
2. **Values**: The data associated with each key
3. **Hash Function**: Converts keys into array indices
4. **Buckets/Slots**: Array positions where key-value pairs are stored

---

## 🔑 Hash Function

### Purpose
A hash function takes an input (key) and returns a fixed-size integer (hash code) that serves as an index in the underlying array.

### Good Hash Function Properties

**1. Deterministic**
- Same input always produces the same output
- `hash("apple")` always returns the same value

**2. Uniform Distribution**
- Spreads keys evenly across available slots
- Minimizes clustering of values

**3. Fast Computation**
- Should be quick to calculate
- Typically O(1) operation

**4. Minimize Collisions**
- Different keys should rarely produce the same hash

### Visual Example: Simple Hash Function

```
Hash Function: hash(key) = sum of ASCII values % table_size

Key: "cat"
ASCII values: c=99, a=97, t=116
Sum: 99 + 97 + 116 = 312
Table size: 10
Hash: 312 % 10 = 2

The key "cat" goes to index 2
```

**Visual Representation:**
```
Index:  0    1    2    3    4    5    6    7    8    9
       [ ]  [ ] ["cat"] [ ]  [ ]  [ ]  [ ]  [ ]  [ ]  [ ]
                  ↑
              Hash = 2
```

---

## 💥 Collision Handling

### What is a Collision?

A collision occurs when two different keys hash to the same index. This is inevitable due to the **Pigeonhole Principle** - if you have more keys than slots, at least one slot must contain multiple keys.

**Example:**
```
hash("cat") = 2
hash("dog") = 2  ← Collision!
```

### Collision Resolution Strategies

#### 1. Chaining (Separate Chaining)

Each array slot contains a linked list (or another data structure) of all key-value pairs that hash to that index.

**Visual Example:**
```
Index:     0         1         2              3         4
         [ ] →    [ ] →   [Head] →         [ ] →    [ ] →
                           ↓
                      ["cat", 🐱]
                           ↓
                      ["dog", 🐶]
                           ↓
                      ["bat", 🦇]
                           ↓
                         null

All three keys hashed to index 2, forming a chain
```

**Characteristics:**
- **Simple to implement**
- **Never fills up** - can always add more items
- **Performance degrades** if many collisions occur
- **Extra memory** for linked list pointers

**Time Complexity:**
- Average: O(1) for insert, delete, search
- Worst case: O(n) if all keys hash to same index

---

#### 2. Open Addressing

All elements are stored directly in the hash table array. When a collision occurs, we probe for the next available slot.

**Types of Probing:**

**A. Linear Probing**

If slot is occupied, try the next slot sequentially.

**Formula:** `index = (hash + i) % table_size` where i = 0, 1, 2, 3...

**Visual Example:**
```
Inserting "cat" → hash = 2
Inserting "dog" → hash = 2 (collision!)
                → try 3 (available) ✓

Index:  0    1    2      3      4    5    6    7
       [ ]  [ ] ["cat"] ["dog"] [ ]  [ ]  [ ]  [ ]
                  ↑       ↑
              original  probed
               hash=2   to 3
```

**Clustering Problem:**
```
Primary clustering - consecutive occupied slots form clusters

Index:  0    1    2    3    4    5    6    7
       [ ]  [ ]  [X]  [X]  [X]  [X]  [ ]  [ ]
                  └─── Cluster ───┘

New insertions keep extending the cluster
```

---

**B. Quadratic Probing**

Use quadratic function to find next slot: `index = (hash + i²) % table_size`

**Visual Example:**
```
Inserting "cat" → hash = 2
Inserting "dog" → hash = 2 (collision!)
                → try (2 + 1²) % 10 = 3 (occupied)
                → try (2 + 2²) % 10 = 6 (available) ✓

Index:  0    1    2      3      4    5    6      7    8    9
       [ ]  [ ] ["cat"] [X]    [ ]  [ ] ["dog"] [ ]  [ ]  [ ]
                  ↑                        ↑
              hash=2                   probed to 6
```

**Reduces primary clustering** but can create secondary clustering

---

**C. Double Hashing**

Use a second hash function to determine probe sequence.

**Formula:** `index = (hash1(key) + i * hash2(key)) % table_size`

**Visual Example:**
```
hash1("dog") = 2
hash2("dog") = 3 (second hash function)

Probe sequence: 2, 5, 8, 1, 4, 7, 0, 3, 6, 9
               (2+0*3), (2+1*3), (2+2*3), ...
```

**Best collision resolution** for open addressing - minimizes clustering

---

## 📊 Load Factor

### Definition

**Load Factor (α)** = Number of entries / Table size

```
Example:
- 7 key-value pairs
- Table size: 10
- Load Factor: 7/10 = 0.7 (70% full)
```

### Visual Representation

```
Load Factor: 0.3 (Low)                Load Factor: 0.8 (High)
Index:  0  1  2  3  4  5  6  7  8  9  Index:  0  1  2  3  4  5  6  7  8  9
       [X][ ][ ][X][ ][ ][ ][X][ ][ ]        [X][X][ ][X][X][X][X][ ][X][X]

Less collisions, more memory waste    More collisions, better memory use
```

### Impact on Performance

**Low Load Factor (α < 0.5)**
- ✅ Fewer collisions
- ✅ Faster operations
- ❌ Wasted memory space

**High Load Factor (α > 0.75)**
- ✅ Better memory utilization
- ❌ More collisions
- ❌ Slower operations

### Resizing (Rehashing)

When load factor exceeds threshold (typically 0.75), the table is resized:

```
Process:
1. Create new larger table (usually 2x size)
2. Rehash all existing keys into new table
3. Replace old table with new table

Before Resize (Load Factor = 0.8):        After Resize (Load Factor = 0.4):
Size: 10, Elements: 8                     Size: 20, Elements: 8

Index:  0  1  2  3  4  5  6  7  8  9     Index:  0  1  2  3  4 ... 17 18 19
       [X][X][ ][X][X][X][X][ ][X][X]            [X][ ][ ][X][ ]... [X][ ][ ]

All keys are rehashed to new positions
```

---

## 🎯 Common Use Cases

### 1. Caching / Memoization

Store expensive computation results for quick retrieval.

```
Fibonacci with memoization:

Memo Table:
┌─────┬─────┬─────┬─────┬─────┬─────┬─────┐
│ n   │  0  │  1  │  2  │  3  │  4  │  5  │
├─────┼─────┼─────┼─────┼─────┼─────┼─────┤
│fib(n)│  0  │  1  │  1  │  2  │  3  │  5  │
└─────┴─────┴─────┴─────┴─────┴─────┴─────┘

Instead of recalculating fib(3) multiple times,
look it up in O(1) time
```

---

### 2. Frequency Counting

Count occurrences of elements.

```
Array: ["apple", "banana", "apple", "cherry", "banana", "apple"]

Frequency Map:
┌──────────┬───────┐
│   Key    │ Count │
├──────────┼───────┤
│  "apple" │   3   │
│ "banana" │   2   │
│ "cherry" │   1   │
└──────────┴───────┘

Quick lookup: How many apples? → O(1) access
```

---

### 3. Finding Duplicates

Detect if an element has been seen before.

```
Array: [1, 2, 3, 4, 2, 5]

Seen Set:
Step 1: {1}
Step 2: {1, 2}
Step 3: {1, 2, 3}
Step 4: {1, 2, 3, 4}
Step 5: {1, 2, 3, 4} → 2 is already in set! Duplicate found
```

---

### 4. Two-Sum Pattern

Find pairs that sum to target.

```
Array: [2, 7, 11, 15], Target: 9

Complement Map:
Index 0: num=2, complement=7
         Map: {2: 0}
         
Index 1: num=7, complement=2
         Is 2 in map? Yes! ✓
         Return indices [0, 1]

Visual:
     2 + ? = 9        7 + ? = 9
     ? = 7            ? = 2 ← Found in map!
```

---

### 5. Grouping / Categorization

Group items by common property.

```
Words: ["eat", "tea", "tan", "ate", "nat", "bat"]
Group by: sorted characters (anagrams)

Grouped Map:
┌──────────┬────────────────────────┐
│   Key    │        Values          │
├──────────┼────────────────────────┤
│  "aet"   │  ["eat", "tea", "ate"] │
│  "ant"   │  ["tan", "nat"]        │
│  "abt"   │  ["bat"]               │
└──────────┴────────────────────────┘

All anagrams share the same sorted key
```

---

## 🔍 Hash Table vs Other Data Structures

### Comparison Table

```
┌──────────────────┬──────────┬──────────┬──────────┬──────────┐
│   Operation      │   Array  │  LinkedL │  BST     │ HashTable│
├──────────────────┼──────────┼──────────┼──────────┼──────────┤
│ Search by Key    │   O(n)   │   O(n)   │ O(log n) │  O(1)*   │
│ Insert           │   O(n)   │   O(1)   │ O(log n) │  O(1)*   │
│ Delete           │   O(n)   │   O(1)   │ O(log n) │  O(1)*   │
│ Ordered Traversal│   O(n)   │   O(n)   │   O(n)   │   O(n)   │
│ Min/Max Element  │   O(n)   │   O(n)   │  O(1)    │   O(n)   │
└──────────────────┴──────────┴──────────┴──────────┴──────────┘

* Average case; worst case is O(n)
```

### When to Use Hash Tables

**Use Hash Tables When:**
- ✅ Need fast lookups by key
- ✅ Inserting/deleting frequently
- ✅ Order doesn't matter
- ✅ Keys are hashable

**Avoid Hash Tables When:**
- ❌ Need sorted/ordered data
- ❌ Need range queries
- ❌ Memory is extremely limited
- ❌ Keys are not hashable

---

## 🌍 Real-World Applications

### 1. Database Indexing

```
User Database:
┌─────────┬────────────┬──────────────┐
│ User ID │    Name    │    Email     │
├─────────┼────────────┼──────────────┤
│  1001   │   Alice    │alice@xyz.com │
│  1002   │   Bob      │ bob@xyz.com  │
│  1003   │   Carol    │carol@xyz.com │
└─────────┴────────────┴──────────────┘

Hash Index on Email:
email → row location (fast lookup)
"alice@xyz.com" → row 1
```

---

### 2. Caching Web Pages

```
Browser Cache:
┌─────────────────────────┬──────────────────┬──────────────┐
│         URL             │   HTML Content   │  Timestamp   │
├─────────────────────────┼──────────────────┼──────────────┤
│ www.example.com/home    │   <html>...</html>│ 2:30 PM     │
│ www.example.com/about   │   <html>...</html>│ 2:31 PM     │
└─────────────────────────┴──────────────────┴──────────────┘

Quick access without re-downloading
```

---

### 3. Symbol Tables in Compilers

```
Variable Symbol Table:
┌───────────────┬───────┬───────────┬─────────┐
│ Variable Name │  Type │   Scope   │  Value  │
├───────────────┼───────┼───────────┼─────────┤
│    counter    │  int  │   local   │   42    │
│     name      │ string│  global   │ "Alice" │
│   isActive    │  bool │   local   │  true   │
└───────────────┴───────┴───────────┴─────────┘

Fast variable lookup during compilation
```

---

### 4. Spell Checkers

```
Dictionary Hash Set:
{
  "hello", "world", "computer", "algorithm",
  "data", "structure", ...
}

Check if "computr" exists:
→ O(1) lookup → Not found → Suggest corrections
```

---

### 5. Unique ID Generation

```
Session ID Tracker:
┌─────────────────────────┬────────────────────┐
│      Session ID         │    User Info       │
├─────────────────────────┼────────────────────┤
│ a3f5c9d1e2b4           │   User: Alice      │
│ 9e4b2c7a8f1d           │   User: Bob        │
└─────────────────────────┴────────────────────┘

Quickly validate session without database query
```

---

## ⚡ Performance Characteristics

### Time Complexity

| Operation | Average Case | Worst Case | Notes |
|-----------|-------------|------------|-------|
| Insert    | O(1)        | O(n)       | Worst case when all keys collide |
| Delete    | O(1)        | O(n)       | Same as insert |
| Search    | O(1)        | O(n)       | Same as insert |
| Space     | O(n)        | O(n)       | n = number of key-value pairs |

### Space Complexity

```
Memory Usage:
- Base array: O(n) where n = table size
- With chaining: O(n + m) where m = number of entries
- With open addressing: O(n)

Trade-off:
Larger table → Fewer collisions → More memory
Smaller table → More collisions → Less memory
```

---

## 💡 Interview Insights

### Common Patterns Using Hash Tables

**Pattern 1: Complement Search**
- Find pairs with specific relationship
- Store seen elements, check for complement

**Pattern 2: Frequency Map**
- Count occurrences
- Identify most/least frequent elements

**Pattern 3: Grouping**
- Categorize items by property
- Find anagrams, similar patterns

**Pattern 4: Visited/Seen Tracking**
- Detect duplicates
- Track explored nodes in graphs

**Pattern 5: Mapping Relationships**
- Create bijections
- Isomorphism checking

---

### Key Discussion Points

**1. Hash Function Choice**
- Why is uniformity important?
- Trade-offs between complexity and distribution

**2. Collision Resolution**
- Chaining vs Open Addressing
- When is each preferred?

**3. Load Factor Management**
- Why resize?
- Cost of rehashing

**4. Hash Table Limitations**
- Cannot maintain order
- No range queries
- Poor worst-case performance

---

## 🎯 Summary

Hash tables are **fundamental** to efficient algorithm design:

**Strengths:**
- ⚡ Near-constant time operations
- 🎯 Simple conceptual model
- 🔧 Versatile applications
- 💪 Industry standard for key-value storage

**Considerations:**
- 🎲 Depends on good hash function
- 💥 Collision handling adds complexity
- 📦 Memory overhead
- 🔄 Periodic resizing needed

**Remember:** Hash tables trade memory and complexity for speed. They're the go-to solution when you need fast lookups and order doesn't matter!

---

## 📚 Related Topics

- [Set Operations & Applications](./07_SETS.md) - Hash-based set implementations
- [Array Manipulation Techniques](./03_ARRAYS.md) - Underlying array structure
- [Time & Space Complexity Analysis](./01_COMPLEXITY_ANALYSIS.md) - Performance analysis

