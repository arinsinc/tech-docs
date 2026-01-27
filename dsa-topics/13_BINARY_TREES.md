# Binary Trees

## 📖 Overview

Binary trees are hierarchical data structures where each node has at most two children. They're fundamental to many algorithms and appear frequently in interviews.

---

## 🌳 Binary Tree Basics

### Structure

```
Visual Representation:
        10 ← Root
       /  \
      5    15 ← Internal nodes
     / \   / \
    3   7 12 20 ← Leaf nodes

Components:
- Root: Topmost node (10)
- Parent: Node with children (5, 15)
- Child: Node below parent (3, 7, 12, 20)
- Leaf: Node with no children (3, 7, 12, 20)
- Internal: Node with at least one child (5, 15)
```

### Tree Properties

```
Height: Longest path from root to leaf
        10        ← Level 0 (Height = 2)
       /  \
      5    15     ← Level 1
     / \
    3   7         ← Level 2

Height of tree: 2
Height of node 5: 1
Height of node 3: 0

Depth: Distance from root
Depth of 10: 0
Depth of 5: 1
Depth of 3: 2
```

### Types of Binary Trees

**1. Full Binary Tree**: Every node has 0 or 2 children

```
        10
       /  \
      5    15
     / \
    3   7

✓ All nodes have 0 or 2 children
✗ Node 15 has 0 children ← OK
✗ Cannot have nodes with only 1 child
```

**2. Complete Binary Tree**: All levels filled except possibly last, filled left to right

```
        10
       /  \
      5    15
     / \   /
    3   7 12

✓ All levels filled except last
✓ Last level filled from left
```

**3. Perfect Binary Tree**: All internal nodes have 2 children, all leaves at same level

```
        10
       /  \
      5    15
     / \   / \
    3   7 12 20

✓ All leaves at level 2
✓ All internal nodes have 2 children
✓ Total nodes: 2^(h+1) - 1 = 2^3 - 1 = 7
```

**4. Balanced Binary Tree**: Height difference between left and right subtrees ≤ 1

```
        10
       /  \
      5    15      ← Balanced
     / \
    3   7
Height difference: |2-1| = 1 ✓

        10
       /
      5            ← Unbalanced
     /
    3
Height difference: |2-0| = 2 ✗
```

---

## 🔄 Tree Traversals

### 1. Pre-order Traversal (Root → Left → Right)

```
Tree:
        1
       / \
      2   3
     / \
    4   5

Process:
1. Visit Root (1) ✓
2. Traverse Left:
   - Visit 2 ✓
   - Traverse Left: Visit 4 ✓
   - Traverse Right: Visit 5 ✓
3. Traverse Right:
   - Visit 3 ✓

Result: [1, 2, 4, 5, 3]

Visual Path:
    1(visit first)
   / \
  2   3(visit last)
 / \
4   5(visit middle)
```

**Use Cases**:
- Create copy of tree
- Get prefix expression
- Serialize tree

---

### 2. In-order Traversal (Left → Root → Right)

```
Tree:
        4
       / \
      2   6
     / \ / \
    1  3 5  7

Process:
1. Traverse Left subtree: [1, 2, 3]
2. Visit Root: 4
3. Traverse Right subtree: [5, 6, 7]

Result: [1, 2, 3, 4, 5, 6, 7]

Visual Path:
    4(visit fourth)
   / \
  2   6(visit sixth)
 / \ / \
1  3 5  7
↑(first) ↑(seventh)

Key Property: For BST, gives sorted order!
```

**Use Cases**:
- Get sorted elements from BST
- Validate BST
- Find kth smallest element

---

### 3. Post-order Traversal (Left → Right → Root)

```
Tree:
        1
       / \
      2   3
     / \
    4   5

Process:
1. Traverse Left:
   - Traverse Left of 2: Visit 4 ✓
   - Traverse Right of 2: Visit 5 ✓
   - Visit 2 ✓
2. Traverse Right: Visit 3 ✓
3. Visit Root: 1 ✓

Result: [4, 5, 2, 3, 1]

Visual Path:
    1(visit last)
   / \
  2   3(visit fourth)
 / \
4   5(visit second)
↑(first)
```

**Use Cases**:
- Delete tree (delete children before parent)
- Get postfix expression
- Calculate tree size

---

### 4. Level-order Traversal (BFS)

```
Tree:
        1
       / \
      2   3
     / \ / \
    4  5 6  7

Process by levels:
Level 0: [1]
Level 1: [2, 3]
Level 2: [4, 5, 6, 7]

Result: [1, 2, 3, 4, 5, 6, 7]

Queue simulation:
Initial: [1]
Process 1, add children: [2, 3]
Process 2, add children: [3, 4, 5]
Process 3, add children: [4, 5, 6, 7]
Process 4: [5, 6, 7]
Process 5: [6, 7]
Process 6: [7]
Process 7: []

Visual:
Level 0:    1
           ↙ ↘
Level 1:  2   3
         ↙↘  ↙↘
Level 2: 4 5 6 7
```

**Time Complexity**: O(n)  
**Space Complexity**: O(w) where w is maximum width

---

## 🎯 Common Tree Problems

### 1. Maximum Depth/Height

```
Tree:
        1
       / \
      2   3
     /
    4

Calculate height:
height(null) = 0
height(4) = 1 + max(0, 0) = 1
height(2) = 1 + max(1, 0) = 2
height(3) = 1 + max(0, 0) = 1
height(1) = 1 + max(2, 1) = 3

Visual:
        1 ← height 3
       / \
      2   3 ← height 1
     /
    4 ← height 1

Formula: height = 1 + max(left_height, right_height)
```

**Time Complexity**: O(n)

---

### 2. Diameter of Tree

```
Diameter: Longest path between any two nodes

Tree:
        1
       / \
      2   3
     / \
    4   5

Possible paths:
- 4 → 2 → 5: length 2
- 4 → 2 → 1 → 3: length 3 ✓ (maximum)
- 5 → 2 → 1 → 3: length 3 ✓

Visual of longest path:
        1
       /↗ ↘
      2   3
     ↗ ↖
    4   5

Calculation at each node:
diameter = max(
  left_height + right_height,
  left_diameter,
  right_diameter
)

At node 2:
left_height(4) = 0
right_height(5) = 0
path through 2 = 0 + 0 = 0

At node 1:
left_height(2) = 1
right_height(3) = 0
path through 1 = 1 + 1 + 0 = 2

Diameter = 2 (but if we count nodes instead of edges = 3)
```

**Time Complexity**: O(n)

---

### 3. Balanced Tree Check

```
Tree 1 (Balanced):
        10
       /  \
      5    15
     / \
    3   7

At each node, check:
|height(left) - height(right)| ≤ 1

Node 10:
- left height = 1 (from node 5)
- right height = 0 (from node 15)
- difference = |1 - 0| = 1 ✓

Node 5:
- left height = 0 (from node 3)
- right height = 0 (from node 7)
- difference = |0 - 0| = 0 ✓

Result: Balanced ✓

Tree 2 (Unbalanced):
        10
       /
      5
     /
    3

Node 10:
- left height = 2 (from node 5)
- right height = 0
- difference = |2 - 0| = 2 ✗

Result: Not Balanced ✗
```

**Time Complexity**: O(n)

---

### 4. Lowest Common Ancestor (LCA)

```
Tree:
        3
       / \
      5   1
     / \ / \
    6  2 0  8
      / \
     7   4

Find LCA of nodes 7 and 4:

Visual path:
        3
       ↙
      5 ← LCA
     ↙ ↘
    6   2
       ↙ ↘
      7   4

Both 7 and 4 are in left subtree of 3
Both are descendants of 5
5 is their lowest common ancestor

Find LCA of nodes 5 and 1:
        3 ← LCA
       ↙ ↘
      5   1

5 is in left subtree, 1 is in right subtree
3 is their LCA

Algorithm:
1. If node is null, return null
2. If node matches p or q, return node
3. Recursively search left and right
4. If both return non-null, current node is LCA
5. Otherwise, return non-null child
```

**Time Complexity**: O(n)

---

### 5. Path Sum Problems

**Path Sum I: Check if path exists with target sum**

```
Tree:              Target: 22
        5
       / \
      4   8
     /   / \
    11  13  4
   /  \      \
  7    2      1

Path: 5 → 4 → 11 → 2
Sum: 5 + 4 + 11 + 2 = 22 ✓

Visual:
        5 ← add 5, sum=5
       ↙
      4 ← add 4, sum=9
     ↙
    11 ← add 11, sum=20
     ↘
      2 ← add 2, sum=22 ✓ (target reached)
```

**Path Sum II: Find all paths with target sum**

```
Tree:              Target: 22
        5
       / \
      4   8
     /   / \
    11  13  4
   /  \    /
  7    2  5

Paths with sum=22:
1. [5, 4, 11, 2]
2. [5, 8, 4, 5]

Visual:
Path 1:         Path 2:
    5              5
   ↙              ↘
  4                8
 ↙                ↘
11                 4
 ↘                ↙
  2              5
```

**Time Complexity**: O(n)

---

### 6. Serialize and Deserialize

```
Tree:
        1
       / \
      2   3
         / \
        4   5

Serialization (Pre-order with null markers):
"1,2,null,null,3,4,null,null,5,null,null"

Visual process:
        1         → output "1"
       / \
      2   3       → output "2"
     ↙ ↘
   null null      → output "null,null"
                  → output "3"
        4   5     → output "4"
       ↙ ↘
     null null    → output "null,null"
                  → output "5"
                  → output "null,null"

Deserialization:
Read "1" → create root
Read "2" → create left child
Read "null" → left of 2 is null
Read "null" → right of 2 is null
Read "3" → create right child of root
...and so on
```

**Time Complexity**: O(n)  
**Space Complexity**: O(n)

---

## 🌲 Views of Binary Tree

### 1. Left View

```
Tree:
        1
       / \
      2   3
     / \   \
    4   5   6
         \
          7

Left View: First node at each level
[1, 2, 4, 7]

Visual:
Level 0: 1 ← visible
         |
Level 1: 2   3 ← 2 visible (first)
         |
Level 2: 4   5   6 ← 4 visible (first)
              |
Level 3:      7 ← visible
```

### 2. Right View

```
Same Tree:
Right View: Last node at each level
[1, 3, 6, 7]

Visual:
Level 0:         1 ← visible
                 |
Level 1:     2   3 ← 3 visible (last)
                 |
Level 2: 4   5   6 ← 6 visible (last)
              |
Level 3:      7 ← visible
```

### 3. Top View

```
Tree with horizontal distance:
        1 (0)
       / \
   (-1)2   3(1)
     / \   \
 (-2)4  5(0) 6(2)

Top View: First node at each horizontal distance
[-2: 4, -1: 2, 0: 1, 1: 3, 2: 6]
Result: [4, 2, 1, 3, 6]

Visual from top:
    4   2   1   3   6
        └───┴───┘
         visible
```

### 4. Bottom View

```
Same Tree:
Bottom View: Last node at each horizontal distance
[-2: 4, -1: 2, 0: 5, 1: 3, 2: 6]
Result: [4, 2, 5, 3, 6]

Visual from bottom:
    4   2   5   3   6
            ↑
        replaces 1 (deeper)
```

**Time Complexity**: O(n)  
**Space Complexity**: O(n)

---

## 🔄 Tree Construction

### From Inorder and Preorder

```
Inorder: [4, 2, 5, 1, 3]  (Left, Root, Right)
Preorder: [1, 2, 4, 5, 3] (Root, Left, Right)

Step 1: First element of preorder is root
Root = 1

Step 2: Find 1 in inorder
Inorder: [4, 2, 5 | 1 | 3]
         └──┬──┘   ↑   └┘
         left    root  right

Step 3: Recursively build left subtree
Left preorder: [2, 4, 5]
Left inorder: [4, 2, 5]
Root of left = 2

Step 4: Continue recursion
Inorder: [4 | 2 | 5]
         left root right

Final Tree:
        1
       / \
      2   3
     / \
    4   5

Visual construction:
Step 1:     1
Step 2:     1
           /
          2
Step 3:     1
           / \
          2   3
Step 4:     1
           / \
          2   3
         / \
        4   5
```

**Time Complexity**: O(n)  
**Space Complexity**: O(n)

---

## 💡 Interview Tips

### Common Patterns

1. **Recursion is Natural**: Most tree problems use recursion
2. **Base Case**: Always handle null nodes
3. **DFS vs BFS**: Choose based on problem requirements
   - DFS: Path problems, tree properties
   - BFS: Level-wise problems, shortest paths

### Problem-Solving Approach

1. **Draw the Tree**: Visualize small examples
2. **Identify Pattern**: DFS, BFS, or special technique?
3. **Write Recursion**: Define base case and recursive case
4. **Optimize**: Can you reduce space or time?

### Edge Cases to Consider

- Empty tree (null root)
- Single node tree
- Skewed tree (all left or all right)
- Complete tree
- Tree with duplicate values

---

## 🎓 Key Takeaways

1. **Tree traversals form the foundation** of tree algorithms
2. **Recursion simplifies** most tree problems
3. **Height-balanced trees** ensure O(log n) operations
4. **Level-order traversal uses queue** (BFS)
5. **In-order traversal of BST gives sorted order**
6. **Many problems combine multiple concepts** (DFS + hash map, BFS + path tracking)

---

## 📚 Next Topic

Continue to [Binary Search Trees](./14_BINARY_SEARCH_TREES.md) to learn about ordered binary trees.
