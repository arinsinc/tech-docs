# Heap Data Structure

## 📋 Overview

A **heap** is a specialized tree-based data structure that satisfies the **heap property**. Heaps are complete binary trees used primarily for implementing priority queues and for efficient sorting (heap sort). They provide O(log n) insertion and O(1) access to the maximum (max heap) or minimum (min heap) element.

**Difficulty Level**: 🟡 Intermediate

---

## 🎯 Core Concepts

### Heap Property

**Max Heap**: Parent node ≥ all children nodes
**Min Heap**: Parent node ≤ all children nodes

**Visual Comparison**:

```
Max Heap:                Min Heap:
      100                     1
     /   \                  /   \
    19    36               2     3
   / \    / \             / \   / \
  17  3  25  1           17 19 36 7
  /                      /
 2                      100

Root = Maximum (100)    Root = Minimum (1)
```

### Complete Binary Tree

**Concept**: All levels are completely filled except possibly the last level, which is filled from left to right.

```
Valid Complete Binary Tree:
       1
      / \
     2   3
    / \  /
   4  5 6

✓ All levels filled left to right
```

```
Invalid (Not Complete):
       1
      / \
     2   3
    /     \
   4       5

❌ Last level not filled left to right
```

---

## 🏗️ Heap Implementation

### Array Representation

**Concept**: Store heap as array using level-order traversal.

**Visual Example**:

```
Heap Tree:
       1
      / \
     3   5
    / \ /
   7  9 8

Array: [1, 3, 5, 7, 9, 8]
Index:  0  1  2  3  4  5
```

### Index Relationships

For node at index `i`:
- **Parent**: `(i - 1) / 2`
- **Left Child**: `2 * i + 1`
- **Right Child**: `2 * i + 2`

**Visual Mapping**:

```
Array: [10, 15, 20, 25, 30, 40, 50]
Index:  0   1   2   3   4   5   6

Tree:
        10 (i=0)
       /  \
    15(1) 20(2)
    / \   / \
  25(3)30(4)40(5)50(6)

For i=1 (value 15):
- Parent: (1-1)/2 = 0 → 10
- Left: 2*1+1 = 3 → 25
- Right: 2*1+2 = 4 → 30

For i=2 (value 20):
- Parent: (2-1)/2 = 0 → 10
- Left: 2*2+1 = 5 → 40
- Right: 2*2+2 = 6 → 50
```

---

## 🔄 Heap Operations

### 1. Insert (Heapify Up / Bubble Up)

**Concept**: Add element at end, then move up to restore heap property.

**Example**: Insert 2 into min heap

```
Step 1: Add at end
       1
      / \
     3   5
    / \ / \
   7  9 8  2  ← new element

Array: [1, 3, 5, 7, 9, 8, 2]
Index:  0  1  2  3  4  5  6

Step 2: Compare with parent (5)
2 < 5, swap!

       1
      / \
     3   2
    / \ / \
   7  9 8  5

Array: [1, 3, 2, 7, 9, 8, 5]

Step 3: Compare with parent (1)
2 > 1, stop!

Final heap: [1, 3, 2, 7, 9, 8, 5]
```

**Detailed Process**:

```
Insert 2:
Index 6: value = 2
Parent index = (6-1)/2 = 2, value = 5
2 < 5, swap

Index 2: value = 2
Parent index = (2-1)/2 = 0, value = 1
2 > 1, done!
```

**Time Complexity**: O(log n) - height of tree

---

### 2. Extract Min/Max (Heapify Down / Bubble Down)

**Concept**: Remove root, replace with last element, then move down to restore heap property.

**Example**: Extract min from min heap

```
Step 1: Original heap
       1
      / \
     3   5
    / \ /
   7  9 8

Array: [1, 3, 5, 7, 9, 8]

Step 2: Remove root, replace with last
       8
      / \
     3   5
    / \
   7  9

Array: [8, 3, 5, 7, 9]

Step 3: Heapify down from root
Compare 8 with children (3, 5)
Smallest = 3, swap with 8

       3
      / \
     8   5
    / \
   7  9

Array: [3, 8, 5, 7, 9]

Step 4: Continue heapify down
Compare 8 with children (7, 9)
Smallest = 7, swap with 8

       3
      / \
     7   5
    / \
   8  9

Array: [3, 7, 5, 8, 9]

Done! Heap property restored
```

**Detailed Process**:

```
After moving last to root:
Index 0: value = 8
Left child: 2*0+1 = 1, value = 3
Right child: 2*0+2 = 2, value = 5
Smallest child = 3, swap

Index 1: value = 8
Left child: 2*1+1 = 3, value = 7
Right child: 2*1+2 = 4, value = 9
Smallest child = 7, swap

Index 3: value = 8
No children, done!
```

**Time Complexity**: O(log n)

---

### 3. Peek (Get Min/Max)

**Concept**: Return root element without removing it.

```
Min Heap:          Max Heap:
     1                 100
    / \                / \
   3   5             50  75

Peek: 1            Peek: 100

Time: O(1)
```

---

### 4. Build Heap (Heapify)

**Concept**: Convert unsorted array into heap.

**Approach**: Start from last non-leaf node, heapify down to root.

**Example**: Build min heap from [9, 5, 6, 2, 3]

```
Step 1: Place in tree
        9
       / \
      5   6
     / \
    2   3

Array: [9, 5, 6, 2, 3]

Step 2: Last non-leaf = index (5-1)/2 = 2
Start heapifying from index 1

At index 1 (value 5):
Children: 2, 3
Min = 2, swap

        9
       / \
      2   6
     / \
    5   3

Step 3: At index 0 (value 9):
Children: 2, 6
Min = 2, swap

        2
       / \
      9   6
     / \
    5   3

Step 4: Continue at index 0:
Children: 9, 6
Min = 6, swap

        2
       / \
      6   9
     / \
    5   3

Step 5: Continue at index 1:
Children: 5, 3
Min = 3, swap

        2
       / \
      3   9
     / \
    5   6

Final heap: [2, 3, 9, 5, 6]
```

**Why Start from Bottom?**
- Leaf nodes already satisfy heap property
- Process internal nodes from bottom up
- Each heapify operation assumes children are valid heaps

**Time Complexity**: O(n) - not O(n log n)!

**Proof Intuition**:
```
Level          Nodes    Max Swaps
Height h:      1        h swaps
Height h-1:    2        h-1 swaps
Height h-2:    4        h-2 swaps
...
Height 0:      2^h      0 swaps

Total: Σ(level_nodes * swaps) ≈ O(n)
```

---

## 📊 Heap Types

### 1. Min Heap vs Max Heap

```
Min Heap:              Max Heap:
     1                    100
    / \                  /   \
   2   3               90     85
  / \ / \             / \     / \
 4  5 6  7          80 70   75 60

Get minimum: O(1)    Get maximum: O(1)
Root = smallest      Root = largest
```

### 2. Max-Min Heap (Double-Ended Priority Queue)

**Concept**: Alternating levels of max and min heap.

```
        100 (max level)
       /   \
      2     5 (min level)
     / \   / \
    95 90 50 48 (max level)

Efficiently supports:
- Get max: O(1)
- Get min: O(1)
- Extract max: O(log n)
- Extract min: O(log n)
```

---

## 🎯 Common Heap Patterns

### 1. K Largest/Smallest Elements

**Concept**: Use min heap of size K for K largest elements.

**Example**: Find 3 largest in [4, 7, 1, 9, 3, 6, 8, 2]

```
Process each element:

Step 1: Add first 3 elements
Min Heap: [1, 4, 7]
        1
       / \
      4   7

Step 2: Add 9
9 > 1 (heap min), replace 1
Min Heap: [4, 7, 9]
        4
       / \
      7   9

Step 3: Add 3
3 < 4, ignore

Step 4: Add 6
6 > 4, replace 4
Min Heap: [6, 7, 9]
        6
       / \
      7   9

Step 5: Add 8
8 > 6, replace 6
Min Heap: [7, 8, 9]
        7
       / \
      8   9

Step 6: Add 2
2 < 7, ignore

Result: [7, 8, 9]
```

**Why Min Heap for K Largest?**
- Keep K largest elements
- Min heap root = smallest of K largest
- Easy to replace when finding larger element

---

### 2. Kth Largest/Smallest Element

**Concept**: Extract K times or use heap of size K.

**Example**: Find 3rd smallest in [7, 10, 4, 3, 20, 15]

**Approach 1**: Min heap, extract 3 times

```
Build min heap:
     3
    / \
   7   4
  / \ /
 10 20 15

Extract 1: get 3
Extract 2: get 4
Extract 3: get 7 ← 3rd smallest
```

**Approach 2**: Max heap of size 3

```
Keep 3 smallest in max heap:
[7, 10, 4] →     [7, 4, 3]
     10
    /  \
   7    4

Add 3: 3 < 10, replace
     7
    / \
   4   3

Final root = 7 (3rd smallest)
```

---

### 3. Merge K Sorted Arrays

**Concept**: Use min heap to track smallest element from each array.

**Example**: Merge [[1,4,7], [2,5,8], [3,6,9]]

```
Step 1: Add first element from each array
Min Heap: [(1,arr0), (2,arr1), (3,arr2)]
         (1,0)
         /   \
     (2,1)  (3,2)

Extract: 1
Result: [1]

Step 2: Add next from arr0 (4)
Min Heap: [(2,arr1), (3,arr2), (4,arr0)]
         (2,1)
         /   \
     (3,2)  (4,0)

Extract: 2
Result: [1, 2]

Continue until all arrays exhausted...
Final: [1,2,3,4,5,6,7,8,9]
```

**Heap contents**: (value, array_index, element_index)

---

### 4. Median from Data Stream

**Concept**: Use two heaps - max heap for smaller half, min heap for larger half.

**Visual Representation**:

```
Data stream: 5, 15, 1, 3

After 5:
Max Heap (left): [5]
Min Heap (right): []
Median: 5

After 15:
Max Heap: [5]
Min Heap: [15]
Median: (5+15)/2 = 10

After 1:
Max Heap: [5, 1]    →    [5]
Min Heap: [15]           [15]
Rebalance: move 5 to right
Max Heap: [1]
Min Heap: [5, 15]
Median: 5

After 3:
Max Heap: [3, 1]
Min Heap: [5, 15]
Median: (3+5)/2 = 4
```

**Invariants**:
1. Max heap size = Min heap size OR Max heap size = Min heap size + 1
2. All elements in max heap ≤ all elements in min heap

---

## 🔄 Heap Sort

**Concept**: Build max heap, repeatedly extract maximum to sort.

**Example**: Sort [4, 10, 3, 5, 1]

```
Step 1: Build max heap
        10
       /  \
      5    3
     / \
    4   1

Array: [10, 5, 3, 4, 1]

Step 2: Swap first and last, reduce heap size
        1
       / \
      5   3
     /
    4    [10] ← sorted

Heapify: [5, 4, 3, 1] | [10]

Step 3: Continue
        5
       / \
      4   3
     /
    1    [10]

Swap: [1, 4, 3] [5, 10]
Heapify: [4, 1, 3] [5, 10]

Step 4: Continue
[3, 1] [4, 5, 10]
[1] [3, 4, 5, 10]
[] [1, 3, 4, 5, 10]

Sorted: [1, 3, 4, 5, 10]
```

**Time Complexity**: O(n log n)
**Space Complexity**: O(1) - in-place sorting

---

## 📈 Performance Analysis

### Time Complexity

| Operation | Average | Worst Case |
|-----------|---------|------------|
| Insert | O(log n) | O(log n) |
| Extract Min/Max | O(log n) | O(log n) |
| Peek Min/Max | O(1) | O(1) |
| Delete | O(log n) | O(log n) |
| Build Heap | O(n) | O(n) |
| Search | O(n) | O(n) |
| Heapify | O(log n) | O(log n) |

### Space Complexity

- **Storage**: O(n)
- **Heap operations**: O(1) auxiliary space
- **Recursive heapify**: O(log n) call stack

---

## 🌍 Real-World Applications

### 1. Task Scheduling

```
Priority Queue for tasks:
Priority  Task
  10      Critical bug fix
  8       Feature development
  5       Code review
  3       Documentation

Always execute highest priority first
```

### 2. Dijkstra's Algorithm

```
Min heap for shortest path:
(distance, node)

Extract minimum distance node
Update neighbors' distances
```

### 3. Huffman Coding

```
Build tree from character frequencies:
Min heap: [(5,'a'), (9,'b'), (12,'c')]

Merge two smallest repeatedly
Efficient data compression
```

### 4. Event-Driven Simulation

```
Time-based events:
(time, event)

Process events in chronological order
Use min heap by timestamp
```

---

## 🎓 Key Takeaways

1. **Heap Property**: Parent-child relationship determines min/max heap
2. **Complete Tree**: Enables efficient array representation
3. **Array Indexing**: Simple formulas for parent/child navigation
4. **Insert**: O(log n) bubble up operation
5. **Extract**: O(log n) bubble down operation
6. **Build Heap**: O(n) surprisingly efficient
7. **Root Access**: O(1) for min/max element
8. **Not for Searching**: O(n) to find arbitrary element

---

## 💡 Interview Tips

1. **Choose right heap**: Min heap for smallest, max heap for largest
2. **Heap vs BST**: Heap for priority, BST for sorted access
3. **Build heap efficiently**: O(n) heapify, not O(n log n) repeated insert
4. **Two heap pattern**: Common for median problems
5. **K-problems**: Often use heap of size K
6. **Custom comparators**: Discuss how to handle complex objects
7. **Space optimization**: In-place heap operations when possible

---

## 🔗 Related Topics

- [Priority Queue Applications](./18_PRIORITY_QUEUES.md)
- [Binary Trees](./13_BINARY_TREES.md)
- [Sorting Algorithms](./31_SORTING.md)
- [Graph Algorithms](./21_SHORTEST_PATHS.md)

---

**Next**: [Priority Queue Applications](./18_PRIORITY_QUEUES.md)
