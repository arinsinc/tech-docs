# Tree Traversals & Views

## 📋 Overview

**Tree traversal** is the process of visiting each node in a tree data structure exactly once in a specific order. Different traversal methods reveal different aspects of the tree and are used for various applications. Tree views provide different perspectives of the tree structure that can be derived through traversal techniques.

**Difficulty Level**: 🟡 Intermediate

---

## 🎯 Depth-First Traversals (DFS)

Depth-First Search explores as far as possible along each branch before backtracking.

### 1. Inorder Traversal (Left-Root-Right)

**Order**: Visit left subtree → Visit root → Visit right subtree

**Visual Example**:

```
        1
       / \
      2   3
     / \
    4   5

Traversal order:
Step 1: Go left to 2
Step 2: Go left to 4
Step 3: Visit 4 (leftmost leaf)
Step 4: Back to 2, visit 2
Step 5: Go right to 5
Step 6: Visit 5
Step 7: Back to 1, visit 1
Step 8: Go right to 3
Step 9: Visit 3

Result: [4, 2, 5, 1, 3]
```

**Animation**:
```
        1                    1                    1
       / \                  / \                  / \
      2   3                2   3                2   3
     / \        →         / \        →         / \
   [4]  5                4  [5]              ✓   ✓

     Step 1               Step 2              Step 3

        1                   [1]                  1
       / \                  / \                 / \
      ✓   3                ✓   3               ✓  [3]
     / \        →         / \        →        / \
    ✓   ✓                ✓   ✓               ✓   ✓

     Step 4               Step 5              Step 6
```

**Use Cases**:
- **Binary Search Trees**: Produces sorted order
- **Expression trees**: Converts to infix notation
- **Finding elements in sorted order**

---

### 2. Preorder Traversal (Root-Left-Right)

**Order**: Visit root → Visit left subtree → Visit right subtree

**Visual Example**:

```
        1
       / \
      2   3
     / \
    4   5

Traversal order:
Step 1: Visit 1 (root)
Step 2: Go left to 2
Step 3: Visit 2
Step 4: Go left to 4
Step 5: Visit 4
Step 6: Back to 2, go right to 5
Step 7: Visit 5
Step 8: Back to 1, go right to 3
Step 9: Visit 3

Result: [1, 2, 4, 5, 3]
```

**Animation**:
```
       [1]                   1                    1
       / \                  / \                  / \
      2   3        →      [2]   3      →        2   3
     / \                  / \                  / \
    4   5                4   5               [4]  5

    Step 1               Step 2              Step 3

        1                    1                    1
       / \                  / \                  / \
      ✓   3        →       ✓   3      →        ✓  [3]
     / \                  / \                  / \
    ✓  [5]               ✓   ✓                ✓   ✓

    Step 4               Step 5              Step 6
```

**Use Cases**:
- **Tree copying/cloning**: Create copy in same structure
- **Prefix expression**: Convert expression tree to prefix notation
- **Serialization**: Save tree structure to file/database
- **Tree reconstruction**: Combined with inorder

---

### 3. Postorder Traversal (Left-Right-Root)

**Order**: Visit left subtree → Visit right subtree → Visit root

**Visual Example**:

```
        1
       / \
      2   3
     / \
    4   5

Traversal order:
Step 1: Go left to 2
Step 2: Go left to 4
Step 3: Visit 4
Step 4: Back to 2, go right to 5
Step 5: Visit 5
Step 6: Back to 2, visit 2 (after children)
Step 7: Back to 1, go right to 3
Step 8: Visit 3
Step 9: Visit 1 (after all children)

Result: [4, 5, 2, 3, 1]
```

**Animation**:
```
        1                    1                    1
       / \                  / \                  / \
      2   3                2   3                2   3
     / \        →         / \        →         / \
   [4]  5                ✓  [5]               ✓   ✓

    Step 1               Step 2              Step 3

        1                    1                   [1]
       / \                  / \                  / \
     [2]  3      →         ✓  [3]     →         ✓   ✓
     / \                  / \                  / \
    ✓   ✓                ✓   ✓                ✓   ✓

    Step 4               Step 5              Step 6
```

**Use Cases**:
- **Tree deletion**: Delete children before parent
- **Postfix expression**: Convert expression tree to postfix notation
- **Computing directory sizes**: Calculate child sizes before parent
- **Dependency resolution**: Process dependencies before the node

---

### Comparison of DFS Traversals

```
        A
       / \
      B   C
     / \
    D   E

Preorder:  A B D E C  (Root first)
Inorder:   D B E A C  (Root middle)
Postorder: D E B C A  (Root last)

Memory: Each node processed exactly once
```

---

## 🌊 Breadth-First Traversal (BFS)

### Level Order Traversal

**Concept**: Visit nodes level by level, from left to right.

**Visual Example**:

```
        1
       / \
      2   3
     / \   \
    4   5   6

Level 0: [1]
Level 1: [2, 3]
Level 2: [4, 5, 6]

Result: [1, 2, 3, 4, 5, 6]
```

**Step-by-Step Process**:

```
Step 1: Start with root
Queue: [1]
Visit: 1

Step 2: Process level 1
Queue: [2, 3]
Visit: 2, 3

Step 3: Process level 2
Queue: [4, 5, 6]
Visit: 4, 5, 6

Complete traversal: [1, 2, 3, 4, 5, 6]
```

**Detailed Animation**:

```
Queue State at each step:

Initial:         After 1:        After 2:
[1]     →       [2,3]    →      [3,4,5]    →

After 3:         After 4:        After 5:
[4,5,6]  →      [5,6]    →      [6]        →

After 6:
[]

Visited: 1 → 2 → 3 → 4 → 5 → 6
```

**Use Cases**:
- **Finding shortest path** in unweighted trees
- **Level-wise processing**: Hierarchical data
- **Finding minimum depth**
- **Checking if tree is complete**

---

## 🎨 Tree Views

Tree views provide different perspectives by looking at the tree from various directions.

### 1. Left View

**Concept**: Nodes visible when viewing tree from the left side. First node at each level.

**Visual Example**:

```
        1
       / \
      2   3
     / \   \
    4   5   6
   /
  7

Looking from left side:

1  ←  Level 0
|
2  ←  Level 1
|
4  ←  Level 2
|
7  ←  Level 3

Left View: [1, 2, 4, 7]
```

**Another Example**:

```
        1
       / \
      2   3
       \
        5
         \
          6

Left View: [1, 2, 5, 6]

Explanation:
Level 0: See node 1
Level 1: See node 2 (leftmost)
Level 2: See node 5 (leftmost at this level)
Level 3: See node 6 (leftmost at this level)
```

---

### 2. Right View

**Concept**: Nodes visible when viewing tree from the right side. Last node at each level.

**Visual Example**:

```
        1
       / \
      2   3
     / \   \
    4   5   6
             \
              7

Looking from right side:

              1  ←  Level 0
              |
              3  ←  Level 1
              |
              6  ←  Level 2
              |
              7  ←  Level 3

Right View: [1, 3, 6, 7]
```

**Process**:
- Level 0: Rightmost = 1
- Level 1: Rightmost = 3
- Level 2: Rightmost = 6
- Level 3: Rightmost = 7

---

### 3. Top View

**Concept**: Nodes visible when viewing tree from above. Based on horizontal distance.

**Horizontal Distance**:
- Root has distance 0
- Left child: parent's distance - 1
- Right child: parent's distance + 1

**Visual Example**:

```
        1 (0)
       / \
   (-1)2   3(+1)
      / \   \
  (-2)4  5(0) 6(+2)

Horizontal distances shown in parentheses

Top View (looking from above):
       4   2   1   3   6
      -2  -1   0  +1  +2

Result: [4, 2, 1, 3, 6]
```

**Detailed Mapping**:

```
Horizontal Distance Map:
HD: -2 → node 4
HD: -1 → node 2
HD:  0 → node 1 (root)
HD: +1 → node 3
HD: +2 → node 6

Node 5 at HD=0 is hidden by node 1 (higher level)
```

**Complex Example**:

```
         1(0)
        / \
    (-1)2  3(+1)
       /  / \
   (-2)4 5  6(+2)
          \
           7(+1)

Top View: [4, 2, 1, 3, 6]

Note: Node 7 is at HD=+1 but hidden by node 3 (higher level)
      Node 5 is at HD=0 but hidden by node 1 (higher level)
```

---

### 4. Bottom View

**Concept**: Nodes visible when viewing tree from below. Last node at each horizontal distance.

**Visual Example**:

```
        1(0)
       / \
   (-1)2  3(+1)
      / \   \
  (-2)4  5(0) 6(+2)

Bottom View (looking from below):
       4   2   5   3   6
      -2  -1   0  +1  +2

Result: [4, 2, 5, 3, 6]
```

**Detailed Process**:

```
Horizontal Distance Map (level order):
HD: -2 → node 4 (only node)
HD: -1 → node 2 (only node)
HD:  0 → node 1, then node 5 (5 overwrites 1)
HD: +1 → node 3 (only node)
HD: +2 → node 6 (only node)

Bottom View: [4, 2, 5, 3, 6]
```

**Another Example**:

```
           20(0)
          /  \
      (-1)8   22(+1)
         / \    \
     (-2)5  3(0) 25(+2)
           / \
       (-1)10 14(+1)

Level-wise processing:
Level 0: HD 0  → 20
Level 1: HD -1 → 8,  HD +1 → 22
Level 2: HD -2 → 5,  HD 0  → 3 (replaces 20),  HD +2 → 25
Level 3: HD -1 → 10 (replaces 8),  HD +1 → 14 (replaces 22)

Bottom View: [5, 10, 3, 14, 25]
```

---

### 5. Diagonal View

**Concept**: Nodes on the same diagonal when tree is tilted 45° right.

**Understanding Diagonals**:
- Going right = same diagonal
- Going left = next diagonal (diagonal number increases)

**Visual Example**:

```
Original Tree:
        1
       / \
      2   3
     / \
    4   5

Tilted 45° Right:

Diagonal 0: 1 → 3
            |
Diagonal 1: 2 → 5
            |
Diagonal 2: 4

Diagonal View:
Diagonal 0: [1, 3]
Diagonal 1: [2, 5]
Diagonal 2: [4]

Result: [[1,3], [2,5], [4]]
```

**Process Explanation**:

```
Starting at root (diagonal 0):
1 (d=0) → right to 3 (d=0)
↓ left
2 (d=1) → right to 5 (d=1)
↓ left
4 (d=2)

Same diagonal = move right
Next diagonal = move left
```

**Complex Example**:

```
           8
         /  \
        3    10
       / \     \
      1   6    14
         / \   /
        4   7 13

Diagonals:
D0: 8 → 10 → 14
D1: 3 → 6 → 7 → 13
D2: 1 → 4

Result: [[8,10,14], [3,6,7,13], [1,4]]
```

---

## 🔄 Vertical Order Traversal

**Concept**: Group nodes by their horizontal distance from root.

**Visual Example**:

```
        1(0)
       / \
   (-1)2  3(+1)
      / \   \
  (-2)4  5(0) 6(+2)
        /
    (-1)7

Vertical lines:
HD=-2: 4
HD=-1: 2, 7
HD=0:  1, 5
HD=+1: 3
HD=+2: 6

Result: [[4], [2,7], [1,5], [3], [6]]
```

**Level-wise at same HD**:

```
When multiple nodes at same HD and level:
Order left to right

        1(0,L0)
       / \
      2   3(+1,L1)
   (-1,L1)  \
      / \   6(+2,L2)
     4   5
  (-2,L2)(0,L2)

HD=-1: [2] (L1)
HD=0:  [1] (L0), [5] (L2)
HD=+1: [3] (L1)

Ordered by level, then left-to-right
```

---

## 🌳 Boundary Traversal

**Concept**: Traverse the outer boundary of the tree.

**Three Parts**:
1. **Left Boundary** (excluding leaves)
2. **Leaf Nodes** (left to right)
3. **Right Boundary** (excluding leaves, bottom-up)

**Visual Example**:

```
        1
       / \
      2   3
     / \   \
    4   5   6
       / \
      7   8

Left Boundary (top-down, no leaves):
1 → 2

Leaves (left to right):
4 → 7 → 8 → 6

Right Boundary (bottom-up, no leaves):
3 → 1 (already included)

Result: [1, 2, 4, 7, 8, 6, 3]
```

**Detailed Breakdown**:

```
        1  ← Root (start)
       / \
      2   3  ← Right boundary node
     / \   \
    4   5   6  ← Leaves
       / \
      7   8  ← Leaves

Step 1: Left boundary (no leaves)
[1, 2]

Step 2: Add all leaves
[1, 2, 4, 7, 8, 6]

Step 3: Right boundary (no leaves, reverse)
[1, 2, 4, 7, 8, 6, 3]
```

**Another Example**:

```
           20
         /    \
        8      22
       / \       \
      4   12     25
         /  \
        10  14

Left Boundary: [20, 8, 4]
Leaves: [4, 10, 14, 25]
Right Boundary: [25, 22, 20] → reverse → [22] (20 already added)

Result: [20, 8, 4, 10, 14, 25, 22]
                 └─ leaves ─┘
```

---

## 🎯 Zigzag (Spiral) Level Order

**Concept**: Alternate direction at each level.

**Visual Example**:

```
        1
       / \
      2   3
     / \   \
    4   5   6
   / \
  7   8

Level 0: [1]           (left to right)
Level 1: [3, 2]        (right to left)
Level 2: [4, 5, 6]     (left to right)
Level 3: [8, 7]        (right to left)

Result: [[1], [3,2], [4,5,6], [8,7]]
```

**Pattern**:

```
Level 0 (even): →  [1]
Level 1 (odd):  ← [3, 2]
Level 2 (even): →  [4, 5, 6]
Level 3 (odd):  ← [8, 7]

Even levels: left to right
Odd levels: right to left
```

---

## 📊 Traversal Comparison

### Summary Table

| Traversal | Order | Use Case | Result Type |
|-----------|-------|----------|-------------|
| Preorder | Root-L-R | Copying, Serialization | Linear |
| Inorder | L-Root-R | BST sorting | Linear |
| Postorder | L-R-Root | Deletion, Evaluation | Linear |
| Level Order | Level by level | Shortest path | Linear |
| Left View | First per level | UI display | Linear |
| Right View | Last per level | UI display | Linear |
| Top View | First per HD | UI display | Linear |
| Bottom View | Last per HD | UI display | Linear |
| Vertical | Group by HD | Columnar layout | 2D |
| Boundary | Outer edge | Drawing border | Linear |
| Zigzag | Alternate direction | Special display | 2D |

---

## 🎓 Key Takeaways

1. **DFS Traversals**: Different root positions (pre/in/post) serve different purposes
2. **BFS Traversal**: Level-wise processing, uses queue
3. **Views**: Different perspectives based on position and visibility
4. **Horizontal Distance**: Key concept for top/bottom/vertical views
5. **Level Tracking**: Essential for left/right views
6. **Boundary**: Combination of multiple traversals
7. **Direction Changes**: Zigzag alternates at each level

---

## 💡 Interview Tips

1. **Clarify requirements**: Which traversal is needed?
2. **Discuss recursion vs iteration**: Trade-offs in implementation
3. **Space complexity**: Stack for DFS, queue for BFS
4. **Edge cases**: Empty tree, single node, skewed tree
5. **Combination problems**: Many problems combine multiple traversals
6. **Visualization**: Draw the tree and trace execution
7. **Use appropriate data structures**: Stack, queue, hash map for tracking

---

## 🔗 Related Topics

- [Binary Trees Fundamentals](./13_BINARY_TREES.md)
- [Binary Search Trees](./14_BINARY_SEARCH_TREES.md)
- [Advanced Tree Concepts](./16_ADVANCED_TREES.md)
- [Graph Traversals](./20_GRAPH_TRAVERSALS.md)

---

**Next**: [Advanced Tree Concepts](./16_ADVANCED_TREES.md)
