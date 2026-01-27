# Advanced Tree Concepts

## 📋 Overview

Beyond basic binary trees and BSTs, there are numerous advanced tree structures and concepts that solve specific problems efficiently. This guide covers balanced trees, specialized trees, and advanced tree operations commonly encountered in senior-level interviews.

**Difficulty Level**: 🔴 Advanced

---

## ⚖️ Self-Balancing Trees

### 1. AVL Trees

**Concept**: A self-balancing BST where the height difference between left and right subtrees (balance factor) is at most 1.

**Balance Factor** = Height(Left Subtree) - Height(Right Subtree)
- Valid values: -1, 0, +1

**Visual Example**:

```
Valid AVL Tree:
        10 (BF=0)
       /  \
      5    15 (BF=0)
   (BF=0)  / \
          12 20
        (BF=0)(BF=0)

All nodes have |BF| ≤ 1 ✓
```

```
Invalid AVL Tree:
        10 (BF=2)
       /
      5 (BF=1)
     /
    3 (BF=0)

Node 10 has BF=2 ❌
```

#### AVL Rotations

**Four Types of Rotations**:

**1. Left Rotation (LL Case)**

```
Before:              After:
    10                  20
      \                /  \
      20             10    30
        \
        30

Node 10 is right-heavy
```

**2. Right Rotation (RR Case)**

```
Before:              After:
      30                20
     /                 /  \
    20               10    30
   /
  10

Node 30 is left-heavy
```

**3. Left-Right Rotation (LR Case)**

```
Before:              Step 1 (Left):    Step 2 (Right):
    30                  30                  20
   /                   /                   /  \
  10                  20                 10    30
    \                /
    20             10

First rotate left at 10, then rotate right at 30
```

**4. Right-Left Rotation (RL Case)**

```
Before:              Step 1 (Right):   Step 2 (Left):
    10                  10                  20
      \                   \                /  \
      30                  20              10   30
     /                      \
    20                      30

First rotate right at 30, then rotate left at 10
```

**Rotation Example**:

```
Insert sequence: 10, 20, 30

Step 1: Insert 10
   10 (BF=0)

Step 2: Insert 20
   10 (BF=-1)
     \
     20 (BF=0)

Step 3: Insert 30
   10 (BF=-2) ❌ Violation!
     \
     20 (BF=-1)
       \
       30 (BF=0)

Apply Left Rotation at 10:
     20 (BF=0)
    /  \
   10   30
 (BF=0)(BF=0)

✓ Balanced!
```

**Performance**:
- All operations: O(log n) guaranteed
- Self-balancing overhead on insertion/deletion

---

### 2. Red-Black Trees

**Concept**: Self-balancing BST with color properties ensuring approximate balance.

**Properties**:
1. Every node is either red or black
2. Root is always black
3. All leaves (NULL) are black
4. Red nodes have black children (no two consecutive red nodes)
5. All paths from root to leaves have same number of black nodes

**Visual Example**:

```
Valid Red-Black Tree:
        10(B)
       /    \
    5(R)    15(B)
    /  \    /  \
  3(B) 7(B)12(R)20(R)

✓ Root is black
✓ No consecutive red nodes
✓ All paths have 2 black nodes
```

**Comparison: AVL vs Red-Black**

```
AVL Tree:
- Stricter balancing (BF ≤ 1)
- Faster lookups
- More rotations on insert/delete
- Best for: read-heavy workloads

Red-Black Tree:
- Relaxed balancing
- Faster insertions/deletions
- Fewer rotations
- Best for: write-heavy workloads

Height Comparison (n nodes):
AVL:       ≤ 1.44 log(n)
Red-Black: ≤ 2.00 log(n)
```

---

## 🌲 Specialized Tree Structures

### 1. Trie (Prefix Tree)

**Concept**: Tree structure for storing strings, where each path represents a word.

**Visual Example**:

```
Words: ["cat", "car", "cart", "dog"]

        (root)
       /      \
      c        d
      |        |
      a        o
     / \       |
    t   r      g
        |    (end)
        t
      (end)

Paths:
c→a→t = "cat"
c→a→r = "car"
c→a→r→t = "cart"
d→o→g = "dog"
```

**Detailed Structure**:

```
Node structure:
{
  children: [a-z],
  isEndOfWord: boolean
}

Example for "cat", "cap":

      root
       |
       c (children: {a})
       |
       a (children: {t, p})
      / \
     t   p
  (end) (end)
```

**Use Cases**:
- **Auto-complete**: Find all words with prefix
- **Spell checker**: Validate words
- **IP routing**: Longest prefix matching
- **Dictionary**: Fast word lookup

**Search Complexity**: O(m) where m = word length

---

### 2. Segment Tree

**Concept**: Tree for answering range queries and updates efficiently.

**Use Case**: Find sum/min/max in array range [L, R]

**Visual Example**: Array = [1, 3, 5, 7, 9, 11]

```
                [0-5] = 36
               /          \
          [0-2]=9         [3-5]=27
          /    \          /      \
      [0-1]=4 [2]=5  [3-4]=16  [5]=11
      /   \          /    \
   [0]=1 [1]=3   [3]=7  [4]=9

Each node stores sum of its range
```

**Range Query Example**: Sum of [1, 4]

```
Query: sum[1, 4]

Traverse tree:
1. At [0-5]: need partial range
2. At [0-2]: need [1-2], skip [0]
3. At [0-1]: need [1], skip [0]
4. At [3-5]: need [3-4], skip [5]

Combine: 3 + 5 + 7 + 9 = 24

Only visit O(log n) nodes!
```

**Update Example**: Update index 2 from 5 to 8

```
Before:              After:
    [0-5]=36            [0-5]=39
    /      \            /      \
[0-2]=9  [3-5]=27   [0-2]=12 [3-5]=27
  /  \                 /  \
[0-1]=4 [2]=5      [0-1]=4 [2]=8

Update path from root to leaf
```

**Complexity**:
- Build: O(n)
- Query: O(log n)
- Update: O(log n)

---

### 3. Fenwick Tree (Binary Indexed Tree)

**Concept**: Compact structure for prefix sums and range queries.

**Visual Representation**: Array = [3, 2, -1, 6, 5, 4, -3, 3]

```
Index (binary):    BIT stores:
0001 (1)          → A[1]
0010 (2)          → A[1..2]
0011 (3)          → A[3]
0100 (4)          → A[1..4]
0101 (5)          → A[5]
0110 (6)          → A[5..6]
0111 (7)          → A[7]
1000 (8)          → A[1..8]

Each index i is responsible for range based on LSB
```

**Range Sum Example**: Sum[1, 5]

```
Sum[1, 5] = PrefixSum[5]

PrefixSum[5]:
- BIT[5] covers [5]
- BIT[4] covers [1..4]

Sum = BIT[5] + BIT[4]
```

**Visual Tree**:

```
                    [1-8]
                   /     \
              [1-4]       [5-8]
             /    \       /    \
         [1-2]  [3-4] [5-6]  [7-8]
         /  \    /  \   /  \   /  \
       [1][2] [3][4] [5][6] [7][8]
```

**Advantage over Segment Tree**:
- Less memory (only array needed)
- Simpler implementation
- Slightly better cache performance

---

### 4. Suffix Tree

**Concept**: Tree containing all suffixes of a string.

**Example**: String = "banana"

```
Suffixes:
banana$
anana$
nana$
ana$
na$
a$
$

Suffix Tree (compressed):
           root
         /  |  \
        /   |   \
       b   a    na$
       |   |     |
    anana$ |   na$
           |
        na  $ 
        |
     na   $
     |
     $
```

**Use Cases**:
- **Pattern matching**: Find if pattern exists in O(m)
- **Longest repeated substring**: Find in O(n)
- **Longest common substring**: Between two strings
- **DNA sequence analysis**

---

## 🎯 Advanced Tree Operations

### 1. Lowest Common Ancestor (LCA)

**Concept**: Deepest node that is ancestor of both given nodes.

**Binary Tree Example**:

```
        1
       / \
      2   3
     / \
    4   5

LCA(4, 5) = 2
LCA(4, 3) = 1
LCA(2, 3) = 1
```

**Approach 1: Path Comparison**

```
Find path from root to both nodes:
Path to 4: [1, 2, 4]
Path to 5: [1, 2, 5]

Last common node = 2 (LCA)
```

**Approach 2: Binary Search Tree**

```
BST Property:
       10
      /  \
     5    15
    / \   / \
   3   7 12  18

LCA(3, 7) = 5
Process:
- At 10: 3 < 10 and 7 < 10, go left
- At 5: 3 < 5 < 7, paths split → LCA = 5

LCA(7, 12) = 10
Process:
- At 10: 7 < 10 < 12, paths split → LCA = 10
```

---

### 2. Serialize and Deserialize Tree

**Concept**: Convert tree to string and reconstruct from string.

**Example**:

```
Original Tree:
        1
       / \
      2   3
         / \
        4   5

Serialization (preorder with nulls):
"1,2,#,#,3,4,#,#,5,#,#"

# represents null
```

**Deserialization Process**:

```
Array: [1, 2, #, #, 3, 4, #, #, 5, #, #]

Step 1: Create root (1)
   1

Step 2: Add left child (2)
   1
  /
 2

Step 3: 2's left child (#, skip)
Step 4: 2's right child (#, skip)

Step 5: Add 1's right child (3)
   1
  / \
 2   3

Step 6: Add 3's left child (4)
Step 7: Add 3's right child (5)

Final:
     1
    / \
   2   3
      / \
     4   5
```

**Alternative Formats**:

```
Level Order: "1,2,3,#,#,4,5,#,#,#,#"
JSON: {"val":1,"left":{"val":2},"right":{"val":3,"left":{"val":4},"right":{"val":5}}}
```

---

### 3. Tree Diameter

**Concept**: Longest path between any two nodes.

**Example**:

```
        1
       / \
      2   3
     / \
    4   5
       /
      6

Paths:
6 → 5 → 2 → 1 → 3: length = 4
6 → 5 → 2 → 4: length = 3
4 → 2 → 1 → 3: length = 3

Diameter = 4
```

**Understanding Diameter**:

```
For each node, diameter can be:
1. In left subtree only
2. In right subtree only
3. Passing through node (leftHeight + rightHeight)

        1 (LH=3, RH=1)
       / \
  (H=3)2  3(H=1)
      / \
     4   5
        /
       6

At node 2:
- Left height = 1
- Right height = 2
- Diameter through 2 = 1 + 2 = 3

At node 1:
- Left height = 3
- Right height = 1
- Diameter through 1 = 3 + 1 = 4 ✓
```

---

### 4. Maximum Path Sum

**Concept**: Path with maximum sum (can start and end anywhere).

**Example**:

```
       -10
       /  \
      9   20
         /  \
        15   7

Possible paths:
15 → 20 → 7: sum = 42 ✓ Maximum
9: sum = 9
15 → 20: sum = 35
20 → 7: sum = 27

Maximum Path Sum = 42
```

**Another Example**:

```
        2
       / \
     -1   3

Paths:
-1 → 2 → 3: sum = 4
-1: sum = -1
2: sum = 2
3: sum = 3
2 → 3: sum = 5 ✓ Maximum

Maximum Path Sum = 5
```

**Key Insight**: At each node, decide whether to:
1. Include only node
2. Include node + left path
3. Include node + right path
4. Include node + left + right (for diameter calculation)

---

### 5. Flatten Tree to Linked List

**Concept**: Convert binary tree to linked list using right pointers.

**Example**:

```
Original:           Flattened:
     1               1
    / \               \
   2   5               2
  / \   \               \
 3   4   6               3
                          \
                           4
                            \
                             5
                              \
                               6

Order: Preorder traversal
```

**Step-by-Step**:

```
Step 1: Original tree
     1
    / \
   2   5
  / \   \
 3   4   6

Step 2: Flatten left subtree
     1
    / \
   2   5
    \   \
     3   6
      \
       4

Step 3: Move left to right
     1
      \
       2
        \
         3
          \
           4

Step 4: Attach original right
     1
      \
       2
        \
         3
          \
           4
            \
             5
              \
               6
```

---

## 🎨 Tree Reconstruction

### From Traversals

**Inorder + Preorder**:

```
Inorder:  [4, 2, 5, 1, 6, 3, 7]
Preorder: [1, 2, 4, 5, 3, 6, 7]

Step 1: First element of preorder = root
Root = 1

Step 2: Find root in inorder
Left subtree:  [4, 2, 5]
Right subtree: [6, 3, 7]

Step 3: Recursively build subtrees
     1
    / \
   ?   ?

Preorder left:  [2, 4, 5]
Preorder right: [3, 6, 7]

Step 4: Continue recursively
Final Tree:
       1
      / \
     2   3
    / \ / \
   4  5 6  7
```

**Inorder + Postorder**:

```
Inorder:   [4, 2, 5, 1, 6, 3, 7]
Postorder: [4, 5, 2, 6, 7, 3, 1]

Step 1: Last element of postorder = root
Root = 1

Step 2: Split inorder at root
Left:  [4, 2, 5]
Right: [6, 3, 7]

Build recursively (same result as above)
```

**Why Inorder is Needed?**

```
Preorder: [1, 2, 3]
Could be:
   1           1
    \         /
     2       2
      \       \
       3       3

Without inorder, ambiguous!
```

---

## 🏗️ Tree Modifications

### 1. Mirror/Invert Tree

**Concept**: Swap left and right children at every node.

```
Original:           Mirrored:
     4                 4
    / \               / \
   2   7             7   2
  / \ / \           / \ / \
 1  3 6  9         9  6 3  1

Process:
1. Swap 2 and 7
2. Recursively mirror subtrees
```

### 2. Convert to BST

**Concept**: Convert binary tree to BST maintaining structure.

```
Original:           BST:
     10               7
    / \              / \
   2  7            2  10
  / \             / \
 8  4            4  8

Steps:
1. Collect inorder: [8, 2, 4, 10, 7]
2. Sort: [2, 4, 7, 8, 10]
3. Replace values maintaining structure
```

### 3. Sum Tree

**Concept**: Convert tree where each node = sum of its subtree.

```
Original:           Sum Tree:
     10               20
    /  \             /  \
   -2   6           4   12
  / \   / \        / \  / \
 8 -4  7  5       0  0 0  0

10 → 8 + (-4) + (-2) + 7 + 5 + 6 = 20
-2 → 8 + (-4) = 4
6 → 7 + 5 = 12
```

---

## 📊 Performance Comparisons

### Tree Structure Comparison

| Structure | Search | Insert | Delete | Use Case |
|-----------|--------|--------|--------|----------|
| BST | O(n) worst | O(n) worst | O(n) worst | Simple, no balance |
| AVL | O(log n) | O(log n) | O(log n) | Read-heavy |
| Red-Black | O(log n) | O(log n) | O(log n) | Write-heavy |
| Segment Tree | O(log n) | O(log n) | O(log n) | Range queries |
| Trie | O(m) | O(m) | O(m) | String operations |
| B-Tree | O(log n) | O(log n) | O(log n) | Databases |

(m = string length, n = number of nodes)

---

## 🎓 Key Takeaways

1. **Self-Balancing**: AVL and Red-Black trees maintain O(log n) operations
2. **Specialized Structures**: Segment trees and tries solve specific problems efficiently
3. **Tree Reconstruction**: Inorder + one other traversal uniquely defines tree
4. **LCA**: Fundamental operation with multiple approaches
5. **Path Problems**: Track paths for diameter and maximum sum
6. **Serialization**: Essential for storage and transmission
7. **Transformations**: Many problems involve tree modifications

---

## 💡 Interview Tips

1. **Choose right structure**: Match tree type to problem requirements
2. **Balance considerations**: Discuss tradeoffs of self-balancing
3. **Clarify constraints**: Is tree balanced? BST property? Binary?
4. **Multiple approaches**: Many problems have recursive and iterative solutions
5. **Edge cases**: Empty tree, single node, skewed tree
6. **Space-time tradeoffs**: Extra space for faster queries?
7. **Visualize**: Draw tree transformations step by step

---

## 🔗 Related Topics

- [Binary Trees Fundamentals](./13_BINARY_TREES.md)
- [Binary Search Trees](./14_BINARY_SEARCH_TREES.md)
- [Tree Traversals](./15_TREE_TRAVERSALS.md)
- [Heaps](./17_HEAPS.md)
- [Tries](./23_TRIES.md)

---

**Next**: [Heap Data Structure](./17_HEAPS.md)
