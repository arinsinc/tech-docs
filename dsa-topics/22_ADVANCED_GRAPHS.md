# Advanced Graph Algorithms

## 📋 Overview

Beyond basic traversals and shortest paths, advanced graph algorithms solve complex problems in network flow, spanning trees, connectivity, matching, and more. These algorithms are essential for optimization problems, network design, and complex system analysis.

**Difficulty Level**: 🔴 Advanced

---

## 🌳 Minimum Spanning Tree (MST)

### Core Concept

A **Minimum Spanning Tree** connects all vertices with minimum total edge weight, using exactly V-1 edges with no cycles.

**Visual Example**:

```
Original Graph:
        4       5
    A -------- B
    |  \       |
    |   \      |
    2    \ 7   | 3
    |     \    |
    |      \   |
    C ------- D
        6

Possible Spanning Trees:
MST (total: 9):         Not MST (total: 14):
    A ---- B                A ---- B
    |      |                |  \   |
    2      3                2   7  3
    |      |                |    \ |
    C      D                C ---- D
```

---

## 🎯 Kruskal's Algorithm

### Core Concept

**Kruskal's** builds MST by adding edges in increasing weight order, skipping edges that create cycles.

**Key Components**:
- Sort all edges by weight
- Use Union-Find to detect cycles
- Add edge if it connects different components

---

### Visual Example

```
Graph:
        4       5
    A -------- B
    |  \       |
    2    \ 7   | 3
    |     \    |
    C ------- D
        6

Sorted edges:
1. A-C: 2
2. B-D: 3
3. A-B: 4
4. B-C: 5
5. C-D: 6
6. A-D: 7
```

**Step-by-Step**:

```
Initial:
Components: {A}, {B}, {C}, {D}
MST edges: []
Total weight: 0

Step 1: Edge A-C (weight 2)
A and C in different components? Yes
Add edge A-C
Components: {A,C}, {B}, {D}
MST edges: [A-C]
Total: 2

        A
        |
        2
        |
        C

Step 2: Edge B-D (weight 3)
B and D in different components? Yes
Add edge B-D
Components: {A,C}, {B,D}
MST edges: [A-C, B-D]
Total: 5

        A           B
        |           |
        2           3
        |           |
        C           D

Step 3: Edge A-B (weight 4)
A and B in different components? Yes
Add edge A-B
Components: {A,B,C,D}
MST edges: [A-C, B-D, A-B]
Total: 9

        A ---- B
        |      |
        2      3
        |      |
        C      D

Step 4: Edge B-C (weight 5)
B and C in same component? Yes
Skip (would create cycle)

Step 5: Edge C-D (weight 6)
C and D in same component? Yes
Skip (would create cycle)

Step 6: Edge A-D (weight 7)
A and D in same component? Yes
Skip

Final MST:
Edges: [A-C, B-D, A-B]
Total weight: 9
```

---

### Union-Find Data Structure

```
Key operations:
- Find(x): Which set does x belong to?
- Union(x, y): Merge sets containing x and y

Example during Kruskal's:

Initial:
Parent: {A:A, B:B, C:C, D:D}

After A-C:
Parent: {A:A, B:B, C:A, D:D}
(C points to A)

After B-D:
Parent: {A:A, B:B, C:A, D:B}

Check edge B-C:
Find(B) = B
Find(C) = A
Different roots → can add edge
```

---

### Complexity

- **Time**: O(E log E) for sorting edges + O(E α(V)) for Union-Find
  - Overall: O(E log E)
- **Space**: O(V) for Union-Find

```
α(V) = inverse Ackermann function
Nearly constant for all practical values
```

---

## 🌲 Prim's Algorithm

### Core Concept

**Prim's** builds MST by growing tree from starting vertex, always adding minimum-weight edge that connects to tree.

**Key Components**:
- Start from any vertex
- Maintain priority queue of edges
- Add minimum edge connecting to tree

---

### Visual Example

```
Graph:
        4       5
    A -------- B
    |  \       |
    2    \ 7   | 3
    |     \    |
    C ------- D
        6

Start from A
```

**Step-by-Step**:

```
Initial:
In MST: {A}
Priority Queue: [(2,A-C), (4,A-B), (7,A-D)]

Step 1: Add edge A-C (weight 2)
In MST: {A, C}
PQ: [(4,A-B), (5,B-C), (6,C-D), (7,A-D)]
MST edges: [A-C]
Total: 2

        A
        |
        2
        |
        C

Step 2: Add edge A-B (weight 4)
In MST: {A, B, C}
PQ: [(3,B-D), (5,B-C), (6,C-D), (7,A-D)]
(B-C already connected via A, but still in PQ)
MST edges: [A-C, A-B]
Total: 6

        A ---- B
        |
        2
        |
        C

Step 3: Add edge B-D (weight 3)
In MST: {A, B, C, D}
MST edges: [A-C, A-B, B-D]
Total: 9

        A ---- B
        |      |
        2      3
        |      |
        C      D

All vertices in MST, done!
```

---

### Complexity

- **Time**: O((V + E) log V) with binary heap
- **Time**: O(E + V log V) with Fibonacci heap
- **Space**: O(V) for priority queue

---

### Kruskal vs Prim

```
Kruskal's:
✓ Better for sparse graphs
✓ Simpler to understand
✓ Works with disconnected components
✗ Requires sorting all edges
✗ Needs Union-Find

Prim's:
✓ Better for dense graphs
✓ Can stop early if needed
✓ More intuitive (growing tree)
✗ Needs priority queue
✗ Must choose starting vertex

Choice:
Sparse graph (E << V²): Kruskal's
Dense graph (E ≈ V²): Prim's
```

---

## 🔄 Topological Sort

### Core Concept

**Topological Sort** orders vertices of a DAG such that for every edge u→v, u comes before v in the ordering.

**Requirements**: Must be a DAG (Directed Acyclic Graph)

---

### Visual Example

```
DAG: Course prerequisites
        CS101
        /    \
    CS201    CS202
        \    /
        CS301

Possible orderings:
1. CS101, CS201, CS202, CS301
2. CS101, CS202, CS201, CS301

Both valid!
Must take CS101 before CS201 and CS202
Must take CS201 and CS202 before CS301
```

---

### DFS-Based Approach

```
Algorithm:
1. Perform DFS
2. Add vertex to result when DFS finishes
3. Reverse the result

Example:
        A → B → D
        ↓   ↓
        C → E

DFS traversal:
Visit A:
  Visit B:
    Visit D: finish D
  Finish B
  Visit C:
    Visit E: finish E
  Finish C
Finish A

Finish order: D, B, E, C, A
Reversed: A, C, E, B, D
or: A, B, C, E, D

Both valid topological orders!
```

---

### Kahn's Algorithm (BFS-Based)

```
Algorithm:
1. Calculate in-degree of each vertex
2. Add all vertices with in-degree 0 to queue
3. Process queue: remove vertex, decrease neighbors' in-degrees
4. Repeat until queue empty

Example:
        A → B → D
        ↓   ↓
        C → E

In-degrees:
A: 0, B: 1, C: 1, D: 1, E: 2

Step 1: Queue [A] (in-degree 0)
Result: []

Step 2: Process A
Decrease in-degrees: B:0, C:0
Queue: [B, C]
Result: [A]

Step 3: Process B
Decrease in-degrees: D:0, E:1
Queue: [C, D]
Result: [A, B]

Step 4: Process C
Decrease in-degrees: E:0
Queue: [D, E]
Result: [A, B, C]

Step 5: Process D, E
Result: [A, B, C, D, E]
```

---

### Cycle Detection

```
If graph has cycle:
- Kahn's: Won't process all vertices
- DFS: Detect back edge

Example with cycle:
        A → B
        ↑   ↓
        └── C

In-degrees: A:1, B:1, C:1
No vertex with in-degree 0!
Queue stays empty
Cannot produce topological order
→ Cycle detected
```

---

## 🔗 Strongly Connected Components (SCC)

### Core Concept

A **Strongly Connected Component** is a maximal set of vertices where every vertex is reachable from every other vertex in the set.

```
Example:
        1 → 2 → 3
        ↑       ↓
        └───────┘
        ↓
        4 → 5
        ↑   ↓
        └───┘

SCCs:
1. {1, 2, 3}
2. {4, 5}
```

---

### Kosaraju's Algorithm

**Steps**:
1. Perform DFS, track finish times
2. Create transpose graph (reverse all edges)
3. Perform DFS on transpose in decreasing finish time order

```
Original graph:
    0 → 1 → 2
    ↑       ↓
    └───────┘
    ↓
    3 → 4
        ↓
        5

Step 1: DFS finish times
Start from 0:
  Visit 1:
    Visit 2:
      Visit 0 (already visited)
      Finish 2
    Finish 1
  Visit 3:
    Visit 4:
      Visit 5:
        Finish 5
      Finish 4
    Finish 3
  Finish 0

Finish order: 2, 1, 5, 4, 3, 0

Step 2: Transpose graph
    0 ← 1 ← 2
    ↓       ↑
    └───────┘
    ↑
    3 ← 4
        ↑
        5

Step 3: DFS in reverse finish order
(0, 3, 4, 5, 1, 2)

From 0:
  Visit 0:
    Visit 2:
      Visit 1:
        (back to 0, already in current DFS)
      Finish 1
    Finish 2
  Finish 0
SCC: {0, 1, 2}

From 3:
  Visit 3:
  Finish 3
SCC: {3}

From 4:
  Visit 4:
    Visit 5:
    Finish 5
  Finish 4
SCC: {4, 5}

Result: 3 SCCs - {0,1,2}, {3}, {4,5}
```

---

### Tarjan's Algorithm

**Single DFS pass** to find SCCs using:
- Discovery time
- Low-link value
- Stack

```
More efficient than Kosaraju's
O(V + E) time, single pass
Common in practice
```

---

## 🌊 Network Flow

### Maximum Flow Problem

**Concept**: Find maximum amount of flow from source to sink in a network.

```
Network:
        10
    s ----→ a
    |  \    |
    5   15  |
    |    \  | 10
    ↓     ↘↓
    b ----→ t
        10

Edges labeled with capacity
```

---

### Ford-Fulkerson Method

**Concept**: Repeatedly find augmenting paths and add flow.

```
Initial flow: 0

Path 1: s → a → t
Flow: min(10, 10) = 10
Total flow: 10

Remaining capacity:
    s --0-→ a
    |  \    |
    5   15  | 0
    |    \  |
    ↓     ↘↓
    b --10→ t

Path 2: s → b → t
Flow: min(5, 10) = 5
Total flow: 15

Path 3: s → a → b → t
Blocked (a→b doesn't exist in this example)

Maximum flow: 15
```

---

### Min-Cut = Max-Flow

**Concept**: Minimum cut capacity equals maximum flow.

```
Min-cut visualization:
      Cut
       |
    s  |  a
    |  |  |
    5  |  | 10
    |  |  |
    ↓  |  ↓
    b  |  t

Cut edges: s→a (10), s→b (5)
Cut capacity: 10 + 5 = 15
= Maximum flow!
```

---

## 🎨 Graph Coloring

### Vertex Coloring

**Concept**: Assign colors to vertices such that no adjacent vertices have same color.

```
Graph:
    A --- B
    |  X  |
    C --- D

Coloring:
A: Red
B: Blue
C: Blue
D: Red

Chromatic number: 2
(minimum colors needed)
```

---

### Bipartite Check

```
Graph is bipartite ↔ Can be 2-colored ↔ No odd cycles

    0 --- 1
    |     |
    3 --- 2

BFS coloring:
0: Red
1, 3: Blue
2: Red

Successfully 2-colored → Bipartite!

Non-bipartite:
    0 --- 1
    |   / |
    | /   |
    2 --- 3

Contains triangle (odd cycle)
Cannot be 2-colored
```

---

## 🔍 Articulation Points and Bridges

### Articulation Point (Cut Vertex)

**Concept**: Vertex whose removal increases number of connected components.

```
Graph:
    A --- B --- C
          |
          D --- E

B is articulation point
Removing B disconnects {A} from {C,D,E}

    A     C
          |
          D --- E
```

---

### Bridge (Cut Edge)

**Concept**: Edge whose removal increases number of connected components.

```
Graph:
    A --- B --- C
    |     |     |
    D --- E     F

B-C is a bridge
Removing B-C disconnects {A,B,D,E} from {C,F}

    A --- B     C
    |     |     |
    D --- E     F
```

---

### Finding Articulation Points

```
DFS-based algorithm:
Track:
- Discovery time
- Lowest reachable vertex

Example:
        0
       /|\
      1 2 3
      |
      4

DFS from 0:
disc[0] = 0, low[0] = 0
disc[1] = 1, low[1] = 1
disc[4] = 2, low[4] = 2

Check if 1 is articulation point:
- 1 has child 4
- low[4] = 2 >= disc[1] = 1
- Cannot reach above 1 from subtree
- 1 is articulation point!
```

---

## 🎯 Eulerian Path and Circuit

### Concepts

**Eulerian Circuit**: Path visiting every edge exactly once, starts and ends at same vertex
**Eulerian Path**: Path visiting every edge exactly once

```
Eulerian Circuit exists ↔ All vertices have even degree

Eulerian Path exists ↔ Exactly 0 or 2 vertices have odd degree
```

---

### Example

```
Graph:
    A --- B
    |     |
    D --- C

Degrees: A:2, B:2, C:2, D:2 (all even)
Eulerian Circuit exists!

Circuit: A → B → C → D → A
```

```
Graph:
    A --- B --- C
    |           |
    D ----------┘

Degrees: A:2, B:2, C:3, D:3
Two vertices with odd degree
Eulerian Path exists (C to D or D to C)
No Eulerian Circuit
```

---

## 🎓 Key Takeaways

1. **MST**: Kruskal's (edge-based) vs Prim's (vertex-based)
2. **Topological Sort**: Only for DAGs, multiple valid orders
3. **SCC**: Strongly connected components in directed graphs
4. **Network Flow**: Max-flow min-cut theorem
5. **Coloring**: Bipartite check, chromatic number
6. **Connectivity**: Articulation points, bridges
7. **Eulerian**: Edge traversal problems

---

## 💡 Interview Tips

1. **Identify problem type**: MST, flow, connectivity?
2. **Graph properties**: Directed? Weighted? Cyclic?
3. **Choose right algorithm**: Trade-offs between approaches
4. **Edge cases**: Disconnected graphs, self-loops
5. **Complexity**: Discuss time and space requirements
6. **Applications**: Relate to real-world scenarios
7. **Variants**: Multiple ways to solve most problems

---

## 🌍 Real-World Applications

### MST
- Network design (minimize cable cost)
- Cluster analysis
- Approximation algorithms

### Topological Sort
- Build systems (Make, npm)
- Course scheduling
- Task dependencies

### Network Flow
- Traffic routing
- Image segmentation
- Bipartite matching

### SCC
- Web page ranking
- Social network analysis
- Software module dependencies

### Articulation Points
- Network reliability
- Critical infrastructure
- Vulnerability analysis

---

## 🔗 Related Topics

- [Graph Representations](./19_GRAPH_BASICS.md)
- [Graph Traversals](./20_GRAPH_TRAVERSALS.md)
- [Shortest Path Algorithms](./21_SHORTEST_PATHS.md)
- [Union-Find](./34_UNION_FIND.md)

---

**Previous**: [Shortest Path Algorithms](./21_SHORTEST_PATHS.md)
