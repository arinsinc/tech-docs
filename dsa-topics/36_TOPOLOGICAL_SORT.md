# Topological Sorting

## 📋 Overview

**Topological Sorting** is the linear ordering of vertices in a Directed Acyclic Graph (DAG) such that for every directed edge (u → v), vertex u comes before v in the ordering. This concept is fundamental for scheduling tasks, resolving dependencies, and many real-world ordering problems.

**Difficulty Level**: 🟡 Intermediate to 🔴 Advanced

---

## 🎯 Core Concept

### The Big Idea

**Analogy**: Course prerequisites
- Take Math 101 before Math 201
- Take Programming 101 before Algorithms
- Order courses so all prerequisites are satisfied

**Formal Definition**: A topological order is a linear sequence of vertices where:
- For every edge u → v, u appears before v
- Only exists for Directed Acyclic Graphs (DAGs)
- Not unique - multiple valid orderings may exist

---

## 📚 Understanding DAGs

### Directed Acyclic Graph

```
Valid DAG:
    A → B → D
    ↓       ↑
    C  ───→

Properties:
✓ Directed edges (arrows)
✓ No cycles (can't return to starting point)
✓ Topological sort exists

Possible topological orders:
1. A, C, B, D
2. A, B, C, D
3. A, B, D, C (invalid - C must come before D)

All valid: A before B, A before C, B before D, C before D
```

### Not a DAG (Has Cycle)

```
Graph with cycle:
    A → B → C
    ↑       ↓
    ← ← ← ← D

✗ Contains cycle: A → B → C → D → A
✗ No topological sort possible
✗ Cannot order tasks if there are circular dependencies
```

---

## 🔄 Algorithm 1: Kahn's Algorithm (BFS-based)

### Concept

Use **in-degree** (number of incoming edges) to process vertices:
1. Start with vertices having in-degree 0 (no dependencies)
2. Remove vertex and reduce in-degree of neighbors
3. Repeat until all vertices processed

### Visual Walkthrough

```
Graph:
    A → B → D
    ↓       ↑
    C  ───→

Step 0: Calculate in-degrees
A: in-degree = 0 (no incoming edges)
B: in-degree = 1 (from A)
C: in-degree = 1 (from A)
D: in-degree = 2 (from B and C)

Queue: []
Result: []

Step 1: Add vertices with in-degree 0
Queue: [A]
Result: []

Step 2: Process A
Remove A from queue
Add A to result
Reduce in-degree of B (1→0) and C (1→0)

Queue: []
Result: [A]
In-degrees: B=0, C=0, D=2

Step 3: Add vertices with in-degree 0
Queue: [B, C]
Result: [A]

Step 4: Process B
Remove B from queue
Add B to result
Reduce in-degree of D (2→1)

Queue: [C]
Result: [A, B]
In-degrees: C=0, D=1

Step 5: Process C
Remove C from queue
Add C to result
Reduce in-degree of D (1→0)

Queue: []
Result: [A, B, C]
In-degrees: D=0

Step 6: Add D to queue
Queue: [D]
Result: [A, B, C]

Step 7: Process D
Remove D from queue
Add D to result

Queue: []
Result: [A, B, C, D]

Topological Order: A → B → C → D ✓
```

### Cycle Detection

```
Graph with cycle:
    A → B
    ↑   ↓
    ←── C

In-degrees: A=1, B=1, C=1
Queue: [] (no vertex with in-degree 0!)

No vertices can be processed
Result length < number of vertices
→ Cycle detected!
```

---

## 🌲 Algorithm 2: DFS-based Approach

### Concept

Use **post-order DFS** traversal:
1. Perform DFS from each unvisited vertex
2. Mark vertices as visiting/visited
3. Add to result after exploring all descendants
4. Reverse the result for topological order

### Visual Walkthrough

```
Graph:
    A → B → D
    ↓       ↑
    C  ───→

DFS from A:

Visit A (mark as visiting)
  ↓
  Explore neighbors: [B, C]
  
  Visit B (mark as visiting)
    ↓
    Explore neighbors: [D]
    
    Visit D (mark as visiting)
      ↓
      No unvisited neighbors
      Mark D as visited
      Add D to stack
    ← Back to B
    
    Mark B as visited
    Add B to stack
  ← Back to A
  
  Visit C (mark as visiting)
    ↓
    Explore neighbors: [D]
    D already visited, skip
    Mark C as visited
    Add C to stack
  ← Back to A
  
  Mark A as visited
  Add A to stack

Stack (order of completion): [D, B, C, A]
Reverse for topological order: [A, C, B, D] ✓

Visual of call stack:
A enters
├─ B enters
│  └─ D enters → exits → adds to result
│  B exits → adds to result
└─ C enters → exits → adds to result
A exits → adds to result
```

### Cycle Detection with DFS

```
Graph with cycle:
    A → B
    ↑   ↓
    ←── C

DFS from A:

Visit A (mark as visiting)
  ↓
  Visit B (mark as visiting)
    ↓
    Visit C (mark as visiting)
      ↓
      Neighbor A is "visiting" (not fully visited)
      → Back edge detected!
      → Cycle found!

States:
- Unvisited: Not yet explored
- Visiting: Currently in DFS path (gray)
- Visited: Fully explored (black)

Back edge to "visiting" node = Cycle
```

---

## 🎯 Real-World Applications

### 1. Course Prerequisites

```
Courses with prerequisites:
Calc 1 → Calc 2 → Calc 3
  ↓        ↓
  ↓      Linear Algebra
  ↓      ↓
  Physics 1

Topological order (valid schedule):
1. Calc 1
2. Physics 1
3. Calc 2
4. Linear Algebra
5. Calc 3

Alternative valid order:
1. Calc 1
2. Calc 2
3. Physics 1
4. Linear Algebra
5. Calc 3
```

### 2. Task Scheduling

```
Build project tasks:
Design → Code → Test → Deploy
  ↓      ↓
  ↓    Review
  ↓      ↓
Setup Infrastructure

Topological order:
1. Design
2. Setup Infrastructure
3. Code
4. Review
5. Test
6. Deploy

Cannot start Review before Code is done!
```

### 3. Makefile Dependencies

```
Compilation dependencies:
main.o depends on: main.cpp, utils.h
utils.o depends on: utils.cpp, utils.h
program depends on: main.o, utils.o

Graph:
utils.h → main.o → program
   ↓         ↑
utils.cpp   utils.o
   ↓         ↑
main.cpp ───→

Build order:
1. utils.h
2. main.cpp, utils.cpp (parallel)
3. main.o, utils.o (parallel)
4. program
```

### 4. Package Installation

```
Package dependencies:
Package A needs: B, C
Package B needs: D
Package C needs: D, E
Package D needs: nothing
Package E needs: nothing

Graph:
    A
   ↙ ↘
  B   C
  ↓   ↙ ↘
  D   E

Install order:
1. D, E (no dependencies)
2. B, C (dependencies satisfied)
3. A (all dependencies satisfied)
```

---

## 📊 Multiple Valid Orderings

### Example Graph

```
Graph:
    A   B
    ↓   ↓
    C   D
     ↘ ↙
      E

Valid topological orders:
1. A, B, C, D, E
2. A, C, B, D, E
3. B, A, C, D, E
4. B, A, D, C, E
5. B, D, A, C, E
6. A, B, D, C, E

All valid! Constraints:
- A before C
- B before D
- C before E
- D before E

Invalid examples:
✗ C, A, B, D, E (A must come before C)
✗ A, B, E, C, D (E cannot come before C and D)
```

---

## 🎪 Advanced Variations

### 1. All Topological Sorts

**Problem**: Find all possible topological orderings.

```
Graph:
    A → B
    ↓   ↓
    C → D

All valid orders:
1. A, B, C, D
2. A, C, B, D

Process using backtracking:
At each step, choose any vertex with in-degree 0
Recursively find remaining orderings
Backtrack and try other choices
```

### 2. Lexicographically Smallest Topological Sort

**Problem**: Among all valid orders, find the smallest lexicographically.

```
Graph:
    B → D
    A → C

Using min-heap instead of queue:
Step 1: Choose A (smallest among A, B)
Step 2: Choose B (smallest among B, C)
Step 3: Choose C
Step 4: Choose D

Result: A, B, C, D (lexicographically smallest)
```

### 3. Topological Sort with Groups

**Problem**: Minimize number of "levels" or "generations".

```
Graph:
    A → C → E
    B → D → F

Level 0: A, B (no dependencies)
Level 1: C, D (depend on level 0)
Level 2: E, F (depend on level 1)

Minimum levels: 3
Can execute same level in parallel
```

---

## 🔍 Detecting and Handling Cycles

### Why Cycles Matter

```
Circular dependency:
    A → B → C → A

Problem: Cannot determine order!
- A depends on C
- C depends on B
- B depends on A
→ Impossible to satisfy all constraints

Real example:
- Package A needs Package B
- Package B needs Package A
→ Cannot install either!
```

### Cycle Detection Methods

**Method 1: Kahn's Algorithm**
```
After processing:
if (result.length != number of vertices):
    Cycle detected
```

**Method 2: DFS**
```
Maintain state: Unvisited, Visiting, Visited
If encounter "Visiting" node during DFS:
    Back edge → Cycle detected
```

---

## 🎯 Problem Variations

### 1. Course Schedule

```
Can you finish all courses?
n = 4 courses: [0, 1, 2, 3]
Prerequisites: [1,0], [2,1], [3,2]

Graph:
0 → 1 → 2 → 3

Topological sort exists? YES
Can finish? YES

Order: 0, 1, 2, 3
```

### 2. Course Schedule II

```
Return actual order of courses
Prerequisites: [1,0], [2,0], [3,1], [3,2]

Graph:
    0
   ↙ ↘
  1   2
   ↘ ↙
    3

Topological order: [0, 1, 2, 3] or [0, 2, 1, 3]
```

### 3. Alien Dictionary

```
Words in alien dictionary (sorted):
["wrt", "wrf", "er", "ett", "rftt"]

Derive letter order:
w → e (from "wrt" before "er")
t → f (from "wrt" before "wrf")
r → t (from "er" before "ett")
e → r (from "er" before "rftt")

Graph:
w → e → r → t → f

Order: w, e, r, t, f
```

### 4. Minimum Height Trees

```
Find roots that minimize tree height
Related to topological sort from periphery

Graph:
    0 - 1 - 2 - 3 - 4

Process leaves (like Kahn's):
Remove 0 and 4 → [1 - 2 - 3]
Remove 1 and 3 → [2]

Root for minimum height: 2
```

---

## 📊 Complexity Analysis

### Time Complexity

**Kahn's Algorithm**:
- Calculate in-degrees: O(V + E)
- Process each vertex once: O(V)
- Process each edge once: O(E)
- **Total: O(V + E)**

**DFS-based**:
- Visit each vertex once: O(V)
- Explore each edge once: O(E)
- **Total: O(V + E)**

### Space Complexity

**Kahn's Algorithm**:
- In-degree array: O(V)
- Queue: O(V)
- Result array: O(V)
- **Total: O(V)**

**DFS-based**:
- Recursion stack: O(V)
- Visited states: O(V)
- Result array: O(V)
- **Total: O(V)**

---

## 💡 Interview Tips

### Problem Recognition

**Use topological sort when you see**:
- Dependencies between tasks
- Prerequisites or ordering constraints
- Course schedules
- Build systems
- Task scheduling
- Directed acyclic graphs

### Choosing Algorithm

**Use Kahn's (BFS)**:
- Easier to implement
- Natural for level-wise processing
- Better for finding minimum levels

**Use DFS**:
- More elegant recursively
- Better for cycle detection
- Less memory for sparse graphs

### Common Patterns

1. **Cycle detection**: Check if topological sort is possible
2. **Multiple orderings**: Use backtracking or count permutations
3. **Minimum levels**: BFS with level tracking
4. **Lexicographic order**: Use priority queue instead of regular queue
5. **All paths**: Backtracking with in-degree tracking

### Edge Cases

- Empty graph
- Single vertex
- Multiple components
- Cycles (no valid ordering)
- Complete graph
- Already sorted sequence

---

## 🎓 Key Takeaways

1. **Only works on DAGs** - must be acyclic
2. **Multiple valid orders** - not unique solution
3. **Two main algorithms** - BFS (Kahn's) and DFS
4. **O(V + E) time** - efficient for large graphs
5. **Cycle detection** - natural side effect
6. **Real-world applications** - scheduling, dependencies
7. **In-degree is key** - for BFS approach
8. **Post-order DFS** - for DFS approach

---

## 🔗 Related Topics

- [Graph Basics](./19_GRAPH_BASICS.md) - Graph representation
- [Graph Traversals](./20_GRAPH_TRAVERSALS.md) - BFS and DFS
- [Advanced Graphs](./22_ADVANCED_GRAPHS.md) - DAG properties
- [Dynamic Programming](./24_DYNAMIC_PROGRAMMING_BASICS.md) - DAG DP

---

**Next**: [Advanced String Algorithms](./37_ADVANCED_STRINGS.md)
