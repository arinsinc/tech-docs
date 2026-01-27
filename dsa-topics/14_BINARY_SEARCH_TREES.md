# Binary Search Trees (BST)

## 📋 Overview

A **Binary Search Tree (BST)** is a specialized binary tree data structure where each node follows a specific ordering property: all values in the left subtree are smaller than the node's value, and all values in the right subtree are greater than the node's value. This property makes BSTs extremely efficient for search, insertion, and deletion operations.

**Difficulty Level**: 🟡 Intermediate

---

## 🎯 Key Concepts

### BST Property (Invariant)

For every node in a BST:
- **Left subtree**: Contains only nodes with values **less than** the node's value
- **Right subtree**: Contains only nodes with values **greater than** the node's value
- Both left and right subtrees must also be binary search trees

### Visual Representation

```
Valid BST:
        50
       /  \
      30   70
     / \   / \
    20 40 60 80

At node 50: Left (30) < 50 < Right (70)
At node 30: Left (20) < 30 < Right (40)
At node 70: Left (60) < 70 < Right (80)
```

```
Invalid BST:
        50
       /  \
      30   70
     / \   / \
    20 65 60 80

❌ Node 65 is in left subtree of 50 but 65 > 50
```

---

## 🔍 Core Operations

### 1. Search Operation

**Concept**: Finding a value in a BST is like playing a guessing game where you get hints after each guess.

**Process**:
1. Start at the root
2. Compare target with current node
3. If equal → Found!
4. If target is smaller → Go left
5. If target is larger → Go right
6. Repeat until found or reach null

**Visual Example**: Searching for 40

```
Step 1: Start at root (50)
        [50] ← current
       /  \
      30   70
     / \   / \
    20 40 60 80
    
    40 < 50, go left

Step 2: Move to 30
        50
       /  \
     [30]  70
     / \   / \
    20 40 60 80
    
    40 > 30, go right

Step 3: Move to 40
        50
       /  \
      30   70
     / \   / \
    20[40]60 80
    
    Found! 40 == 40
```

**Time Complexity**:
- Best/Average: O(log n) - balanced tree
- Worst: O(n) - skewed tree (like a linked list)

---

### 2. Insertion Operation

**Concept**: New values are always inserted as leaf nodes while maintaining BST property.

**Process**:
1. Start at root
2. Compare value with current node
3. Navigate left (if smaller) or right (if larger)
4. When you reach null, insert new node there

**Visual Example**: Inserting 45

```
Initial Tree:
        50
       /  \
      30   70
     / \   / \
    20 40 60 80

Step 1: Compare with 50
45 < 50, go left

Step 2: Compare with 30
        50
       /  \
    →[30]  70
     / \   / \
    20 40 60 80
    
45 > 30, go right

Step 3: Compare with 40
        50
       /  \
      30   70
     / \   / \
    20[40]60 80
    
45 > 40, go right (null found)

Step 4: Insert 45
        50
       /  \
      30   70
     / \   / \
    20 40 60 80
        \
        45 ← new node
```

---

### 3. Deletion Operation

**Concept**: Deletion is the most complex BST operation with three cases.

#### Case 1: Node is a Leaf (No Children)

Simply remove the node.

```
Delete 20:

Before:              After:
        50                  50
       /  \                /  \
      30   70             30   70
     / \   / \             \   / \
   [20]40 60 80            40 60 80
```

#### Case 2: Node Has One Child

Replace node with its child.

```
Delete 30 (has only right child):

Before:              After:
        50                  50
       /  \                /  \
     [30]  70              40  70
       \   / \                / \
       40 60 80              60 80
```

#### Case 3: Node Has Two Children

**Process**:
1. Find the **inorder successor** (smallest node in right subtree)
2. Replace node's value with successor's value
3. Delete the successor

```
Delete 50 (has two children):

Step 1: Find inorder successor
        [50]
       /  \
      30   70
     / \   / \
    20 40[60]80 ← successor (smallest in right subtree)

Step 2: Replace 50 with 60
        [60]
       /  \
      30   70
     / \   / \
    20 40[60]80

Step 3: Delete original 60
        60
       /  \
      30   70
     / \    \
    20 40   80
```

**Alternative**: Use **inorder predecessor** (largest node in left subtree)

---

## 📊 BST Properties

### 1. Inorder Traversal Gives Sorted Order

**Concept**: Visiting BST nodes in left-root-right order produces sorted sequence.

```
        50
       /  \
      30   70
     / \   / \
    20 40 60 80

Inorder: 20 → 30 → 40 → 50 → 60 → 70 → 80
         (sorted ascending order)
```

### 2. Range Query Efficiency

**Concept**: Finding all values in a range [low, high] is efficient.

```
Find all values between 35 and 65:

        50
       /  \
      30   70
     / \   / \
    20 40 60 80

Process:
- At 50: 35 < 50 < 65, explore both sides
- At 30: 35 > 30, skip left, explore right
- At 40: 40 in range ✓
- At 70: 65 < 70, skip right
- At 60: 60 in range ✓

Result: [40, 50, 60]
```

---

## 🎭 BST Variations

### 1. Balanced BST

**Concept**: Height is kept at O(log n) to guarantee efficient operations.

```
Unbalanced BST:        Balanced BST:
    10                     40
      \                   /  \
      20                20    60
        \              /  \   / \
        30           10  30 50  70
          \
          40
            \
            50
              \
              60
                \
                70

Height: 7           Height: 3
Operations: O(n)    Operations: O(log n)
```

**Examples**: AVL Trees, Red-Black Trees

### 2. Duplicate Handling

**Strategy 1**: Store in left subtree
```
        50
       /  \
      30   70
     / \
    30 40 ← duplicate 30 on left
```

**Strategy 2**: Store in right subtree
```
        50
       /  \
      30   70
       \
       30 ← duplicate 30 on right
```

**Strategy 3**: Store count in node
```
Node structure:
{
  value: 30,
  count: 2, ← appears twice
  left: ...,
  right: ...
}
```

---

## 🏗️ BST Construction

### Building BST from Array

**Example**: Build BST from [50, 30, 70, 20, 40, 60, 80]

```
Step 1: Insert 50
   [50]

Step 2: Insert 30
    50
   /
 [30]

Step 3: Insert 70
    50
   /  \
  30  [70]

Step 4: Insert 20
    50
   /  \
  30   70
 /
[20]

Step 5: Insert 40
    50
   /  \
  30   70
 / \
20 [40]

Step 6: Insert 60
    50
   /  \
  30   70
 / \   /
20 40[60]

Step 7: Insert 80
    50
   /  \
  30   70
 / \   / \
20 40 60[80]
```

**Note**: Different insertion orders create different tree shapes!

```
Array: [20, 30, 40, 50, 60, 70, 80]
Creates skewed tree:

20
  \
  30
    \
    40
      \
      50
        \
        60
          \
          70
            \
            80

❌ Degenerates to linked list
```

---

## 🔄 BST to Sorted Array

**Concept**: Inorder traversal naturally produces sorted output.

```
        50
       /  \
      30   70
     / \   / \
    20 40 60 80

Process:
1. Visit left subtree: [20, 30, 40]
2. Visit root: [20, 30, 40, 50]
3. Visit right subtree: [20, 30, 40, 50, 60, 70, 80]

Result: [20, 30, 40, 50, 60, 70, 80]
```

---

## 📈 Performance Characteristics

### Time Complexity

| Operation | Average | Worst Case | Best Case |
|-----------|---------|------------|-----------|
| Search    | O(log n) | O(n)      | O(1)      |
| Insert    | O(log n) | O(n)      | O(1)      |
| Delete    | O(log n) | O(n)      | O(1)      |
| Min/Max   | O(log n) | O(n)      | O(1)      |
| Inorder   | O(n)     | O(n)      | O(n)      |

**Worst case** occurs with skewed tree (unbalanced)
**Average case** assumes reasonably balanced tree
**Best case** when target is at root

### Space Complexity

- **Storage**: O(n) - one node per element
- **Recursion depth**: O(h) where h is height
  - Balanced: O(log n)
  - Skewed: O(n)

---

## 🎯 Common Interview Patterns

### 1. Validate BST

**Concept**: Check if a binary tree satisfies BST property.

**Key Insight**: Not enough to compare node with immediate children!

```
Invalid example that passes naive check:

        10
       /  \
      5    15
          /  \
         6    20

Each node > left child and < right child ✓
But 6 < 10, violates BST property! ❌
```

**Correct approach**: Track valid range for each subtree

```
        10 (range: -∞ to +∞)
       /  \
      5    15
(range:  (range:
-∞ to 10) 10 to +∞)
```

### 2. Lowest Common Ancestor (LCA)

**Concept**: Find the lowest node that has both nodes as descendants.

```
        50
       /  \
      30   70
     / \   / \
    20 40 60 80

LCA(20, 40) = 30
LCA(20, 60) = 50
LCA(60, 80) = 70
```

**Key Insight**: First node where paths diverge.

```
Finding LCA(20, 80):

At 50: 20 < 50 and 80 > 50
       → paths diverge here
       → 50 is LCA
```

### 3. Kth Smallest Element

**Concept**: Find the kth smallest element using inorder traversal.

```
        50
       /  \
      30   70
     / \   / \
    20 40 60 80

Inorder: 20, 30, 40, 50, 60, 70, 80
         1st 2nd 3rd 4th 5th 6th 7th

3rd smallest = 40
5th smallest = 60
```

### 4. BST from Sorted Array

**Concept**: Build balanced BST by choosing middle element as root.

```
Array: [10, 20, 30, 40, 50, 60, 70]

Step 1: Middle = 40 (root)
        [40]

Step 2: Left half [10,20,30], middle = 20
        40
       /
     [20]

Step 3: Right half [50,60,70], middle = 60
        40
       /  \
      20  [60]

Continue recursively...

Final Tree:
        40
       /  \
      20   60
     / \   / \
    10 30 50 70

✓ Balanced tree with height = 3
```

---

## 🌍 Real-World Applications

### 1. Database Indexing

**Use Case**: B-Trees (variant of BST) for database indices

```
Database Index:
        [M]
       /   \
    [A-L]   [N-Z]
    /  \     /  \
  [A-F][G-L][N-T][U-Z]

Fast lookup: O(log n) disk accesses
```

### 2. File Systems

**Use Case**: Directory structures

```
        /root
       /     \
     /home   /var
     /  \     /  \
  /user1 /user2 /log /tmp
```

### 3. Expression Trees

**Use Case**: Mathematical expressions

```
Expression: (3 + 5) * (8 - 2)

        *
       / \
      +   -
     / \ / \
    3  5 8  2
```

### 4. Auto-complete Systems

**Use Case**: Maintaining sorted suggestions

```
BST of words:
        "hello"
       /      \
   "apple"   "world"
    /  \       /
  "a" "code" "zebra"

Quick prefix search and insertion
```

---

## 🎓 Key Takeaways

1. **BST Property**: Left < Root < Right for every subtree
2. **Inorder Traversal**: Produces sorted sequence
3. **Search Efficiency**: O(log n) average, but O(n) worst case if unbalanced
4. **Balance Matters**: Unbalanced trees degenerate to linked lists
5. **Deletion Complexity**: Three cases based on number of children
6. **Range Queries**: BST structure enables efficient range searches
7. **Construction Order**: Different insertion orders create different structures
8. **Successor/Predecessor**: Easy to find in BST structure

---

## 💡 Interview Tips

1. **Always validate BST property globally**, not just locally
2. **Consider edge cases**: empty tree, single node, all left/right children
3. **Think about balance**: mention balanced variants for optimal performance
4. **Use ranges** for validation problems
5. **Leverage inorder property** for sorted-related problems
6. **Discuss tradeoffs**: BST vs hash table vs balanced tree
7. **Handle duplicates**: clarify handling strategy in interviews

---

## 🔗 Related Topics

- [Binary Trees Fundamentals](./13_BINARY_TREES.md)
- [Tree Traversals & Views](./15_TREE_TRAVERSALS.md)
- [Advanced Tree Concepts](./16_ADVANCED_TREES.md)
- [Heaps](./17_HEAPS.md)

---

**Next**: [Tree Traversals & Views](./15_TREE_TRAVERSALS.md)
