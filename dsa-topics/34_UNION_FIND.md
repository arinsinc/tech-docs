# Union-Find (Disjoint Set Union)

## 📋 Overview

**Union-Find** (also called Disjoint Set Union or DSU) is a data structure that efficiently tracks elements partitioned into disjoint (non-overlapping) sets. It provides near-constant time operations to merge sets and determine if elements belong to the same set. This structure is fundamental for solving connectivity problems in graphs and networks.

**Difficulty Level**: 🔴 Advanced

---

## 🎯 Core Concept

### The Problem

Imagine you have a collection of objects, and you need to:
1. **Union**: Combine two groups into one
2. **Find**: Determine which group an object belongs to
3. **Check connectivity**: Are two objects in the same group?

### Real-World Analogy

**Social Networks**: Groups of friends
- Initially, each person is their own group
- When two people become friends, merge their groups
- Check if two people are connected (friends or friends-of-friends)

```
Initial: {Alice} {Bob} {Carol} {David} {Eve}

Alice befriends Bob:
{Alice, Bob} {Carol} {David} {Eve}

Carol befriends David:
{Alice, Bob} {Carol, David} {Eve}

Bob befriends Carol:
{Alice, Bob, Carol, David} {Eve}

All connected except Eve!
```

---

## 🏗️ Basic Structure

### Representation

Each element points to a parent. The root of the tree represents the set.

```
Initial state (each element is its own set):
0  1  2  3  4
↑  ↑  ↑  ↑  ↑
(each points to itself)

After Union(0, 1):
   0
  ↙
 1  2  3  4
    ↑  ↑  ↑

After Union(2, 3):
   0     2
  ↙     ↙
 1     3  4
          ↑

After Union(0, 2):
      0
    ↙  ↘
   1    2
       ↙
      3    4
           ↑

Elements 0, 1, 2, 3 are now in same set
Element 4 is in different set
```

### Parent Array Representation

```
Index:  0  1  2  3  4
Parent: 0  0  0  2  4

Element 0: parent is 0 (root)
Element 1: parent is 0 → root is 0
Element 2: parent is 0 → root is 0
Element 3: parent is 2 → parent of 2 is 0 → root is 0
Element 4: parent is 4 (root)

Two disjoint sets: {0,1,2,3} and {4}
```

---

## 🔍 Basic Operations

### 1. Find (Find Root)

**Concept**: Follow parent pointers until reaching root.

```
Find root of element 3:

Parent array: [0, 0, 0, 2, 4]

Step 1: parent[3] = 2
        ↓
Step 2: parent[2] = 0
        ↓
Step 3: parent[0] = 0 (root!)

Root of 3 is 0
```

**Visual Tree**:
```
      0 ← root
    ↙  ↘
   1    2
       ↙
      3

Finding 3:
3 → 2 → 0 (found root)
```

### 2. Union (Merge Sets)

**Concept**: Make root of one set point to root of other set.

```
Union(1, 4):

Before:
Parent: [0, 0, 0, 2, 4]

      0         4
    ↙  ↘       ↑
   1    2
       ↙
      3

Step 1: Find root of 1 → 0
Step 2: Find root of 4 → 4
Step 3: Make root of one point to other
        parent[4] = 0

After:
Parent: [0, 0, 0, 2, 0]

        0
    ↙  ↙  ↘
   1   4   2
          ↙
         3

All elements now in same set!
```

### 3. Connected (Same Set Check)

**Concept**: Two elements are connected if they have same root.

```
Are 1 and 3 connected?

Parent: [0, 0, 0, 2, 0]

Find(1): 1 → 0 (root)
Find(3): 3 → 2 → 0 (root)

Both have root 0 → YES, connected!

Are 1 and 5 connected? (if 5 exists)
Find(1) = 0
Find(5) = 5 (different root)
→ NO, not connected
```

---

## ⚡ Optimization: Path Compression

### Problem with Naive Approach

```
Worst case: Chain of length n

0 → 1 → 2 → 3 → 4 → 5

Finding 5 requires 5 hops!
Every Find operation could be O(n)
```

### Solution: Path Compression

**Concept**: During Find, make every node point directly to root.

```
Before Path Compression:
      0
      ↓
      1
      ↓
      2
      ↓
      3
      ↓
      4

Find(4) with path compression:

Step 1: Find root (0)
Step 2: While going back, update all parents to point to root

After Path Compression:
        0
    ↙ ↙ ↙ ↘
   1  2  3  4

All nodes now point directly to root!
Next Find(4) is O(1)
```

**Detailed Process**:
```
Find(4) with path compression:

Initial path: 4 → 3 → 2 → 1 → 0

Recursion:
parent[4] = Find(3)
  parent[3] = Find(2)
    parent[2] = Find(1)
      parent[1] = Find(0)
        return 0 (root)
      parent[1] = 0
      return 0
    parent[2] = 0
    return 0
  parent[3] = 0
  return 0
parent[4] = 0
return 0

All compressed to point to 0!
```

---

## 🎯 Optimization: Union by Rank

### Problem with Naive Union

```
Unbalanced trees can form:

Union(0,1), Union(1,2), Union(2,3), Union(3,4)

Result:
0 → 1 → 2 → 3 → 4 (chain)

Height = 4 (bad for Find operations)
```

### Solution: Union by Rank

**Concept**: Always attach smaller tree under larger tree.

**Rank**: Approximate height/depth of tree.

```
Example: Union by Rank

Initial (rank = 0 for all):
0  1  2  3
↑  ↑  ↑  ↑
rank: 0,0,0,0

Union(0,1):
Compare ranks: both 0
Attach 1 under 0
   0
  ↙
 1
rank[0] = 1 (increased)

Union(2,3):
   0     2
  ↙     ↙
 1     3
rank: 1,0,1,0

Union(0,2):
Compare ranks: both 1
Attach 2 under 0
      0
    ↙  ↘
   1    2
       ↙
      3
rank[0] = 2 (increased)

Result: Balanced tree!
```

**Key Rules**:
1. If ranks equal: attach one to other, increase rank by 1
2. If ranks differ: attach smaller rank to larger rank, no rank change

---

## 🎪 Complete Implementation Concept

### Optimized Union-Find Structure

```
Class UnionFind:
  - parent[]: array of parent pointers
  - rank[]: array of ranks (approximate heights)

Initialize:
  For each element i:
    parent[i] = i (self-parent)
    rank[i] = 0 (initially height 0)

Find(x) with path compression:
  If parent[x] == x:
    return x (found root)
  Else:
    parent[x] = Find(parent[x]) (compress path)
    return parent[x]

Union(x, y) with union by rank:
  rootX = Find(x)
  rootY = Find(y)
  
  If rootX == rootY:
    return (already in same set)
  
  If rank[rootX] < rank[rootY]:
    parent[rootX] = rootY (attach smaller to larger)
  Else if rank[rootX] > rank[rootY]:
    parent[rootY] = rootX
  Else:
    parent[rootY] = rootX
    rank[rootX]++ (both equal, increase rank)

Connected(x, y):
  return Find(x) == Find(y)
```

---

## 📊 Complexity Analysis

### Time Complexity

**Without optimizations**:
- Find: O(n) worst case (chain)
- Union: O(n) (requires Find)

**With path compression only**:
- Amortized O(log n)

**With union by rank only**:
- O(log n) per operation

**With both optimizations**:
- **O(α(n))** per operation (inverse Ackermann function)
- α(n) ≤ 4 for all practical values of n
- **Effectively constant time!**

### Space Complexity

- O(n) for parent and rank arrays

---

## 🎯 Classic Applications

### 1. Number of Connected Components

**Problem**: Count separate groups in graph.

```
Graph edges: (0,1), (1,2), (3,4)
Nodes: 0,1,2,3,4

Process:
Initial: {0} {1} {2} {3} {4} → 5 components

Union(0,1): {0,1} {2} {3} {4} → 4 components

Union(1,2): {0,1,2} {3} {4} → 3 components

Union(3,4): {0,1,2} {3,4} → 2 components

Result: 2 connected components
```

### 2. Detect Cycle in Undirected Graph

**Problem**: Does adding an edge create a cycle?

```
Edges: (0,1), (1,2), (2,0)

Process edge (0,1):
Find(0) = 0, Find(1) = 1
Different roots → no cycle yet
Union(0,1)

Process edge (1,2):
Find(1) = 0, Find(2) = 2
Different roots → no cycle yet
Union(1,2)

Process edge (2,0):
Find(2) = 0, Find(0) = 0
Same root! → CYCLE DETECTED

Visual:
0 - 1
|   |
2 - (trying to connect back to 0)
```

### 3. Accounts Merge

**Problem**: Merge accounts with common emails.

```
Accounts:
1. ["John", "john@email.com", "john@work.com"]
2. ["John", "john@email.com", "john@home.com"]
3. ["Mary", "mary@email.com"]

Common email "john@email.com" → merge accounts 1 and 2

Use Union-Find:
- Each email is a node
- Union emails within same account
- Union emails across accounts with common email

Result:
john@email.com, john@work.com, john@home.com → John
mary@email.com → Mary
```

### 4. Redundant Connection

**Problem**: Find edge that creates cycle in tree.

```
Edges: (1,2), (1,3), (2,3), (3,4)

Process:
Edge (1,2): Union(1,2) → OK
Edge (1,3): Union(1,3) → OK
Edge (2,3): Find(2)=1, Find(3)=1 → Same root!
            This edge creates cycle!

Tree before (2,3):
    1
   ↙ ↘
  2   3
      |
      4

Edge (2,3) creates:
    1
   ↙ ↘
  2 - 3 ← cycle!
      |
      4
```

---

## 🌍 Real-World Applications

### 1. Social Network Connections

```
People: A, B, C, D, E, F

Friendships:
- A and B are friends
- B and C are friends
- D and E are friends

Query: Are A and C connected?
Find(A) and Find(C) → Yes (through B)

Query: Are A and D connected?
Find(A) and Find(D) → No (different groups)

Visual:
Group 1: A - B - C
Group 2: D - E
Isolated: F
```

### 2. Network Connectivity

```
Computers in network:
Initial: 5 isolated computers

Connections:
1. Connect PC1 to PC2
2. Connect PC2 to PC3
3. Connect PC4 to PC5

Query: Can PC1 reach PC3?
Answer: Yes (via PC2)

Query: Can PC1 reach PC4?
Answer: No (different networks)

Network diagram:
Network A: PC1 - PC2 - PC3
Network B: PC4 - PC5
```

### 3. Image Processing (Connected Components)

```
Binary image (1 = foreground, 0 = background):

1 1 0 0 0
1 1 0 1 1
0 0 0 1 1
0 1 1 0 0

Find connected regions of 1s:

Region 1: (0,0), (0,1), (1,0), (1,1)
Region 2: (1,3), (1,4), (2,3), (2,4)
Region 3: (3,1), (3,2)

Use Union-Find:
- Union adjacent 1s
- Count distinct roots
Result: 3 connected regions
```

### 4. Kruskal's Minimum Spanning Tree

```
Graph edges with weights:
(A,B,1), (A,C,3), (B,C,2), (B,D,4), (C,D,5)

Sort by weight: 1,2,3,4,5

Process edges:
1. (A,B,1): Union(A,B) → Add to MST
2. (B,C,2): Union(B,C) → Add to MST
3. (A,C,3): Find(A)=Find(C) → Skip (creates cycle)
4. (B,D,4): Union(B,D) → Add to MST
5. (C,D,5): Find(C)=Find(D) → Skip (creates cycle)

MST edges: (A,B), (B,C), (B,D)
Total weight: 1+2+4 = 7

Visual:
    A
    |1
    B
   2|4
    C D
```

---

## 🎯 Advanced Variants

### 1. Union-Find with Size

**Track size of each set**:

```
size[i] = number of elements in set with root i

During Union:
rootX = Find(x)
rootY = Find(y)

If rootX != rootY:
  parent[rootY] = rootX
  size[rootX] += size[rootY]

Query largest set:
max(size[i] for all roots)
```

### 2. Union-Find with Count

**Track number of disjoint sets**:

```
count = n (initially)

During Union:
If rootX != rootY:
  parent[rootY] = rootX
  count-- (merged two sets into one)

Query number of components:
return count
```

### 3. Weighted Union-Find

**Track relative weights/distances**:

```
weight[i] = weight relative to parent

Useful for:
- Distance from root
- Relative rankings
- Bipartite graph checking

Example: Check if graph is bipartite
Store color relative to parent (0 or 1)
```

---

## 💡 Interview Tips

### When to Use Union-Find

**Key indicators**:
1. **Connectivity questions**: Are elements connected?
2. **Grouping problems**: Merge groups dynamically
3. **Cycle detection**: In undirected graphs
4. **Equivalence classes**: Transitive relationships

### Problem-Solving Pattern

1. **Identify disjoint sets**: What are the groups?
2. **Define union operation**: When to merge?
3. **Define find operation**: How to check membership?
4. **Consider optimizations**: Path compression? Union by rank?

### Common Variations

- Find with path compression
- Union by rank/size
- Count number of components
- Find largest component
- Weighted/ranked unions

### Edge Cases

- Single element
- All elements in one set
- All elements in separate sets
- Invalid indices
- Self-loops (union element with itself)

---

## 🎓 Key Takeaways

1. **Union-Find is for disjoint sets** - non-overlapping groups
2. **Two main operations**: Find (which set?) and Union (merge sets)
3. **Path compression** - makes Find nearly O(1)
4. **Union by rank** - keeps trees balanced
5. **Combined optimizations** - O(α(n)) ≈ O(1) amortized time
6. **Perfect for connectivity** - graphs, networks, equivalence
7. **Not for overlapping sets** - elements can't be in multiple sets
8. **Simple but powerful** - elegant solution to complex problems

---

## 🔗 Related Topics

- [Graph Basics](./19_GRAPH_BASICS.md) - Graph representation
- [Graph Traversals](./20_GRAPH_TRAVERSALS.md) - Alternative connectivity checks
- [Advanced Graphs](./22_ADVANCED_GRAPHS.md) - MST, cycle detection
- [Dynamic Programming](./24_DYNAMIC_PROGRAMMING_BASICS.md) - Sometimes alternative to Union-Find

---

**Next**: [Segment Trees & Fenwick Trees](./35_SEGMENT_TREES.md)
