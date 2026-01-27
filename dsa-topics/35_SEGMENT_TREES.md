# Segment Trees & Fenwick Trees

## 📋 Overview

**Segment Trees** and **Fenwick Trees** (Binary Indexed Trees) are advanced data structures that efficiently handle range queries and updates on arrays. While both solve similar problems, they differ in implementation complexity, space usage, and types of operations supported. These structures are essential for competitive programming and appear in advanced technical interviews.

**Difficulty Level**: 🔴 Advanced

---

## 🎯 The Problem They Solve

### Range Query Problem

**Scenario**: Given an array, answer queries efficiently:
- **Range queries**: Sum/min/max over range [L, R]
- **Point updates**: Modify single element
- **Range updates**: Modify multiple elements

### Naive Approach Limitations

```
Array: [2, 5, 1, 7, 3, 9, 4]

Query: Sum of range [1, 4]
Naive: Sum 5+1+7+3 = 16
Time: O(n)

Update: arr[2] = 6
Naive: Direct assignment
Time: O(1)

Problem: Multiple queries become expensive
100 queries × O(n) = O(100n)

Need: Fast queries AND fast updates!
```

---

## 🌳 Segment Tree

### Core Concept

**Idea**: Build a tree where:
- **Leaves**: Individual array elements
- **Internal nodes**: Aggregate information about ranges
- **Root**: Information about entire array

### Visual Structure

```
Array: [2, 5, 1, 7, 3, 9, 4, 6]

Segment Tree (Sum):
                   [0-7: 37]
                  /         \
           [0-3: 15]         [4-7: 22]
           /      \           /      \
      [0-1: 7]  [2-3: 8] [4-5: 12] [6-7: 10]
       /    \    /    \    /    \    /    \
     [2]  [5]  [1]  [7]  [3]  [9]  [4]  [6]

Each node stores:
- Range it represents: [L, R]
- Aggregate value: sum/min/max of that range
```

### Tree Array Representation

```
Array: [2, 5, 1, 7, 3, 9, 4, 6]

Tree stored in array (1-indexed):
Index:  1    2    3    4   5   6   7   8   9  10  11  12  13  14  15
Value: 37   15   22    7   8  12  10   2   5   1   7   3   9   4   6

Navigation:
- Parent of i: i/2
- Left child of i: 2*i
- Right child of i: 2*i + 1

Visual:
                 1(37)
               /      \
            2(15)      3(22)
           /    \      /    \
         4(7)  5(8)  6(12) 7(10)
        /  \   /  \   /  \  /  \
       8   9  10 11 12 13 14  15
```

---

## 🔨 Segment Tree Operations

### 1. Build Tree

**Concept**: Recursively build tree bottom-up.

```
Array: [2, 5, 1, 7]

Build process:

Step 1: Build leaves (base case)
Tree[4] = arr[0] = 2
Tree[5] = arr[1] = 5
Tree[6] = arr[2] = 1
Tree[7] = arr[3] = 7

Step 2: Build internal nodes (bottom-up)
Tree[2] = Tree[4] + Tree[5] = 2+5 = 7
Tree[3] = Tree[6] + Tree[7] = 1+7 = 8

Step 3: Build root
Tree[1] = Tree[2] + Tree[3] = 7+8 = 15

Final tree:
       15(1)
      /    \
    7(2)   8(3)
    / \    / \
   2  5   1  7
  (4)(5) (6)(7)

Time: O(n) - visit each node once
Space: O(4n) ≈ O(n) - tree has at most 4n nodes
```

### 2. Range Query

**Concept**: Recursively combine relevant nodes.

```
Query: Sum of range [1, 3] in array [2, 5, 1, 7]
       (indices 1 to 3 → elements 5, 1, 7)

Tree:
       15[0-3]
      /       \
    7[0-1]    8[2-3] ← fully inside [1,3]
    / \       / \
   2  5      1  7
  [0][1]    [2][3]
       ↑     ↑  ↑
     inside [1,3]

Recursive process:

Query([1,3], node=1, range=[0,3]):
  Query overlaps [0,3]
  Split and recurse

Query([1,3], node=2, range=[0,1]):
  Partial overlap
  Split: [0,0] and [1,1]
  
  Query([1,3], node=4, range=[0,0]):
    Outside [1,3] → return 0
  
  Query([1,3], node=5, range=[1,1]):
    Fully inside [1,3] → return 5

Query([1,3], node=3, range=[2,3]):
  Fully inside [1,3] → return 8

Result: 0 + 5 + 8 = 13 ✓ (5+1+7=13)

Time: O(log n) - traverse height of tree
```

### 3. Point Update

**Concept**: Update leaf, propagate changes to root.

```
Update: Set arr[2] = 6 (was 1)
Array: [2, 5, 1, 7] → [2, 5, 6, 7]

Before:
       15
      /  \
    7     8
   / \   / \
  2  5  1  7

Update path (bottom-up):
Step 1: Update leaf
Tree[6] = 6 (was 1)

Step 2: Update parent node
Tree[3] = Tree[6] + Tree[7] = 6+7 = 13

Step 3: Update root
Tree[1] = Tree[2] + Tree[3] = 7+13 = 20

After:
       20
      /  \
    7    13
   / \   / \
  2  5  6  7

Time: O(log n) - path from leaf to root
```

### 4. Range Update (Lazy Propagation)

**Concept**: Store pending updates, apply when needed.

```
Update: Add 3 to range [1, 3]
Array: [2, 5, 1, 7] → [2, 8, 4, 10]

Instead of updating all elements:
Store lazy value at nodes covering range

Tree with lazy values:
       15 (lazy=0)
      /           \
    7(lazy=3)    8(lazy=3)
   / \           / \
  2  5          1  7

When query visits node with lazy value:
1. Apply lazy to node's value
2. Push lazy to children
3. Clear lazy at current node

Benefits:
- Update: O(log n) instead of O(n)
- Deferred execution - only update when needed
```

---

## 🎯 Segment Tree Variations

### 1. Range Minimum Query (RMQ)

```
Array: [2, 5, 1, 7, 3]

Min Segment Tree:
          1[0-4]
        /        \
     1[0-2]      3[3-4]
     /    \      /    \
   2[0-1] 1[2]  7[3]  3[4]
   /  \
  2[0] 5[1]

Query: min in range [1, 4]
Visit nodes: [1] → 5, [2] → 1, [3-4] → 3
Result: min(5, 1, 3) = 1
```

### 2. Range Maximum Query

```
Array: [2, 5, 1, 7, 3]

Max Segment Tree:
          7[0-4]
        /        \
     5[0-2]      7[3-4]
     /    \      /    \
   5[0-1] 1[2]  7[3]  3[4]
   /  \
  2[0] 5[1]

Query: max in range [0, 3]
Result: 7
```

### 3. Range GCD/LCM

```
Array: [12, 18, 24, 36]

GCD Segment Tree:
          6[0-3]
        /        \
     6[0-1]     12[2-3]
     /    \      /    \
  12[0] 18[1] 24[2] 36[3]

Query: GCD of range [1, 3]
gcd(18, 24, 36) = 6
```

---

## 📊 Fenwick Tree (Binary Indexed Tree)

### Core Concept

**Idea**: Use binary representation to efficiently store cumulative sums.

**Key Property**: Each index is responsible for a range based on its binary representation.

### Structure and Responsibility

```
Array: [3, 2, -1, 6, 5, 4, -3, 3, 7]
Index:  1  2   3  4  5  6   7  8  9

Fenwick Tree (BIT):
Index: 1  2  3  4  5  6  7   8  9
BIT:   3  5  4  10 5  9  6  20  7

Responsibility (ranges):
BIT[1] stores: arr[1]           (range 1-1)
BIT[2] stores: arr[1..2]        (range 1-2)
BIT[3] stores: arr[3]           (range 3-3)
BIT[4] stores: arr[1..4]        (range 1-4)
BIT[5] stores: arr[5]           (range 5-5)
BIT[6] stores: arr[5..6]        (range 5-6)
BIT[7] stores: arr[7]           (range 7-7)
BIT[8] stores: arr[1..8]        (range 1-8)
BIT[9] stores: arr[9]           (range 9-9)

Pattern: Index i is responsible for 2^k elements
where k = number of trailing zeros in binary(i)
```

### Binary Representation Insight

```
Index in binary:
1  = 0001 → 0 trailing zeros → 2^0 = 1 element
2  = 0010 → 1 trailing zero  → 2^1 = 2 elements
3  = 0011 → 0 trailing zeros → 2^0 = 1 element
4  = 0100 → 2 trailing zeros → 2^2 = 4 elements
8  = 1000 → 3 trailing zeros → 2^3 = 8 elements

Range size = 2^(trailing zeros)
```

### Visual Tree Representation

```
Fenwick tree conceptual structure:

           8
          /|\
         / | \
        /  |  \
       4   6   7
      /|   |    
     / |   |    
    2  3   5    
    |       
    1       

Node i covers range ending at i
with size = LSB(i) (Least Significant Bit)
```

---

## 🔨 Fenwick Tree Operations

### 1. Update (Add to Element)

**Concept**: Update all nodes responsible for this index.

```
Update: Add 5 to arr[3]

BIT before: [0, 3, 5, 4, 10, 5, 9, 6, 20, 7]

Index 3 in binary: 0011
Next index: 3 + LSB(3) = 3 + 1 = 4

Update path: 3 → 4 → 8
(indices that include position 3 in their range)

BIT[3] += 5  →  9
BIT[4] += 5  → 15
BIT[8] += 5  → 25

BIT after: [0, 3, 5, 9, 15, 5, 9, 6, 25, 7]

Process:
index = 3
while index <= n:
  BIT[index] += value
  index += (index & -index)  // add LSB

Time: O(log n)
```

### 2. Prefix Sum Query

**Concept**: Sum elements from 1 to i by combining responsible nodes.

```
Query: Sum from 1 to 6

BIT: [0, 3, 5, 4, 10, 5, 9, 6, 20, 7]

Index 6 in binary: 0110
Parent: 6 - LSB(6) = 6 - 2 = 4

Query path: 6 → 4 → 0
(accumulate values moving toward 0)

sum = 0
sum += BIT[6] = 9    (covers arr[5..6])
index = 4
sum += BIT[4] = 10   (covers arr[1..4])
index = 0 (stop)

Result: 9 + 10 = 19

Visual of ranges:
[1 2 3 4 | 5 6]
└─ BIT[4]┘ └BIT[6]┘

Process:
index = 6
sum = 0
while index > 0:
  sum += BIT[index]
  index -= (index & -index)  // subtract LSB

Time: O(log n)
```

### 3. Range Sum Query

**Concept**: Range sum = prefix_sum(R) - prefix_sum(L-1)

```
Query: Sum of range [3, 6]

Sum[3..6] = Sum[1..6] - Sum[1..2]

Sum[1..6]:
path: 6 → 4 → 0
sum = BIT[6] + BIT[4] = 9 + 10 = 19

Sum[1..2]:
path: 2 → 0
sum = BIT[2] = 5

Result: 19 - 5 = 14

Visual:
[1 2 | 3 4 5 6]
└──┘   └──query range──┘
remove   keep

Time: O(log n)
```

### 4. Building Fenwick Tree

**Concept**: Initialize by updating each element.

```
Array: [3, 2, -1, 6]

BIT initialization: [0, 0, 0, 0, 0]

Update index 1 with 3:
BIT: [0, 3, 3, 0, 3]

Update index 2 with 2:
BIT: [0, 3, 5, 0, 5]

Update index 3 with -1:
BIT: [0, 3, 5, -1, 4]

Update index 4 with 6:
BIT: [0, 3, 5, -1, 10]

Time: O(n log n)

Optimized O(n) build:
For each index i:
  BIT[i] = arr[i]
  parent = i + (i & -i)
  if parent <= n:
    BIT[parent] += BIT[i]
```

---

## ⚖️ Segment Tree vs Fenwick Tree

### Comparison Table

| Feature | Segment Tree | Fenwick Tree |
|---------|--------------|--------------|
| **Implementation** | Complex | Simple |
| **Space** | O(4n) | O(n) |
| **Range Query** | O(log n) | O(log n) |
| **Point Update** | O(log n) | O(log n) |
| **Range Update** | O(log n) with lazy | Not natural |
| **Types of Queries** | Any associative | Sum-like only |
| **1-indexed** | Optional | Required |
| **Code Length** | Longer | Shorter |
| **Flexibility** | Very flexible | Limited |

### When to Use Which?

**Use Segment Tree when**:
- Need range updates
- Need min/max/gcd/other operations
- Query types are complex
- Flexibility is important

**Use Fenwick Tree when**:
- Only need sum/frequency
- Space is constrained
- Implementation simplicity matters
- Point updates with range sums

---

## 🎯 Classic Problems

### 1. Range Sum Query Mutable

```
Array: [1, 3, 5, 7, 9, 11]

Operations:
1. sumRange(1, 3) → 3+5+7 = 15
2. update(1, 10)   → arr becomes [1,10,5,7,9,11]
3. sumRange(1, 3) → 10+5+7 = 22

Solution: Segment Tree or Fenwick Tree
Query: O(log n)
Update: O(log n)
```

### 2. Count Inversions

```
Array: [5, 2, 6, 1]

Inversions: pairs (i,j) where i<j but arr[i]>arr[j]
(5,2), (5,1), (2,1), (6,1)
Count: 4

Using Fenwick Tree:
Process elements right to left
For each element, query count of smaller elements seen so far

Visual:
Process: 1 → 6 → 2 → 5
BIT tracks frequency of each value
```

### 3. Range Minimum with Updates

```
Array: [4, 2, 3, 5, 1]

Query: min(1, 3) → min(2,3,5) = 2
Update: arr[2] = 1
Query: min(1, 3) → min(2,1,5) = 1

Solution: Segment Tree (RMQ)
Not suitable for Fenwick Tree (min is not cumulative)
```

### 4. Number of Smaller Elements After Self

```
Array: [5, 2, 6, 1]

For each element, count smaller elements to its right:
5: [2, 1] → 2
2: [1] → 1
6: [1] → 1
1: [] → 0

Result: [2, 1, 1, 0]

Using Fenwick Tree:
Process right to left
Track frequencies
Query cumulative frequency
```

---

## 💡 Advanced Techniques

### 1. 2D Segment Tree

```
Matrix:
1 2 3
4 5 6
7 8 9

Query: Sum of submatrix [(0,0) to (1,1)]
Result: 1+2+4+5 = 12

Build 2D segment tree:
Each node in row tree contains a column tree
Query: O(log² n)
Update: O(log² n)
```

### 2. Persistent Segment Tree

```
Track history of all versions

Version 1: [1, 2, 3, 4]
Update arr[2] = 5
Version 2: [1, 2, 5, 4]

Can query any version
Space: O(n + m log n) for m updates
Query old version: O(log n)
```

### 3. Merge Sort Tree

```
Each segment tree node stores sorted array of its range

Array: [5, 2, 8, 1, 7]

Node [0-4]: [1, 2, 5, 7, 8]
Node [0-2]: [2, 5, 8]
Node [3-4]: [1, 7]

Query: Count elements in range [L,R] that are < X
Use binary search in sorted arrays
```

---

## 🎓 Key Takeaways

1. **Range queries + updates** - core use case for both structures
2. **Segment tree is flexible** - supports any associative operation
3. **Fenwick tree is efficient** - simpler, less space for sum queries
4. **Both are O(log n)** - for query and update operations
5. **Lazy propagation** - essential for range updates in segment tree
6. **LSB operation** - key to Fenwick tree efficiency
7. **Not for unsorted data** - array indices must be meaningful
8. **Build complexity** - O(n) possible with optimization

---

## 💡 Interview Tips

### Problem Recognition

**Use when you see**:
- Multiple range queries
- Frequent updates between queries
- Need for range statistics (sum/min/max)
- Subarray problems with modifications

### Implementation Tips

1. **1-indexed Fenwick**: Always use 1-based indexing
2. **4n space for segment tree**: Allocate enough space
3. **LSB trick**: `x & -x` gives least significant bit
4. **Test with small examples**: Verify on [1,2,3,4]
5. **Consider preprocessing**: Sometimes offline queries work

### Common Mistakes

- Off-by-one errors in range queries
- Forgetting to propagate lazy updates
- Using 0-indexed Fenwick tree
- Not allocating enough space for segment tree
- Confusing query and update operations

---

## 🔗 Related Topics

- [Arrays](./03_ARRAYS.md) - Base data structure
- [Binary Trees](./13_BINARY_TREES.md) - Tree structure understanding
- [Dynamic Programming](./24_DYNAMIC_PROGRAMMING_BASICS.md) - Range DP problems
- [Sorting](./31_SORTING.md) - Merge sort tree, inversion counting

---

**Next**: [Topological Sorting](./36_TOPOLOGICAL_SORT.md)
