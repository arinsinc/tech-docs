# Graph Representations

## 📋 Overview

A **graph** is a non-linear data structure consisting of **vertices (nodes)** connected by **edges (links)**. Graphs model relationships between entities and are fundamental to solving problems in networks, social connections, routing, dependencies, and more. Understanding different graph representations is crucial for choosing the right approach for specific problems.

**Difficulty Level**: 🟡 Intermediate

---

## 🎯 Graph Fundamentals

### Basic Terminology

**Graph Components**:
- **Vertex (Node)**: A fundamental unit (entity)
- **Edge**: Connection between two vertices
- **Path**: Sequence of vertices connected by edges
- **Cycle**: Path that starts and ends at same vertex

**Visual Example**:

```
Simple Graph:
    A ------- B
    |         |
    |         |
    C ------- D

Vertices: {A, B, C, D}
Edges: {(A,B), (A,C), (B,D), (C,D)}
Paths: A→B, A→C→D, A→B→D
Cycle: A→B→D→C→A
```

---

## 📊 Types of Graphs

### 1. Directed vs Undirected

**Undirected Graph**: Edges have no direction (bidirectional)

```
    A ←→ B
    ↕     ↕
    C ←→ D

Edge (A,B) means: A→B and B→A
```

**Directed Graph (Digraph)**: Edges have direction

```
    A → B
    ↑   ↓
    C ← D

Edge A→B: Can go from A to B only
```

**Real-world Examples**:

```
Undirected:
- Facebook friends (mutual)
- Road networks (two-way streets)
- Collaboration networks

Directed:
- Twitter follows (one-way)
- Web page links
- Task dependencies
```

---

### 2. Weighted vs Unweighted

**Unweighted Graph**: All edges have equal cost/distance

```
    A --- B
    |     |
    C --- D

All edges cost = 1
```

**Weighted Graph**: Edges have associated costs/weights

```
    A --5-- B
    |       |
    2       3
    |       |
    C --4-- D

Distance A→B = 5
Distance A→C = 2
```

**Real-world Examples**:

```
Weighted:
- Road networks (distances)
- Flight routes (costs)
- Network latency
- Social influence (strength)
```

---

### 3. Cyclic vs Acyclic

**Cyclic Graph**: Contains at least one cycle

```
    A → B
    ↑   ↓
    C ← D

Cycle: A→B→D→C→A
```

**Acyclic Graph**: No cycles

```
    A → B → D
    ↓
    C

No way to return to starting vertex
```

**DAG (Directed Acyclic Graph)**: Important special case

```
        A
       ↙ ↘
      B   C
       ↘ ↙
        D

Used in:
- Task scheduling
- Build systems
- Course prerequisites
- Git commit history
```

---

### 4. Connected vs Disconnected

**Connected Graph**: Path exists between every pair of vertices

```
    A --- B
    |     |
    C --- D

Can reach any vertex from any other vertex
```

**Disconnected Graph**: Some vertices unreachable from others

```
    A --- B     E --- F
    |           |
    C           G

Two separate components
Cannot reach E from A
```

**Strongly Connected (Directed)**: Path in both directions

```
    A ⇄ B
    ⇅   ⇅
    C ⇄ D

Can reach any vertex from any other
via directed edges
```

---

### 5. Complete Graph

**Concept**: Every vertex connected to every other vertex

```
K₃ (3 vertices):        K₄ (4 vertices):
      A                     A
     /|\                  / | \
    B-+-C               B--+--D
      |                  \ | /
                           C

K₃: 3 edges            K₄: 6 edges
Kₙ: n(n-1)/2 edges (undirected)
```

---

## 🗂️ Graph Representation Methods

### 1. Adjacency Matrix

**Concept**: 2D array where matrix[i][j] = 1 if edge exists from vertex i to j

**Undirected Graph Example**:

```
Graph:
    0 --- 1
    |     |
    2 --- 3

Adjacency Matrix:
    0  1  2  3
0 [ 0  1  1  0 ]
1 [ 1  0  0  1 ]
2 [ 1  0  0  1 ]
3 [ 0  1  1  0 ]

matrix[0][1] = 1 means edge 0-1
Symmetric for undirected graphs
```

**Directed Graph Example**:

```
Graph:
    0 → 1
    ↓   ↓
    2 ← 3

Adjacency Matrix:
    0  1  2  3
0 [ 0  1  0  0 ]
1 [ 0  0  0  1 ]
2 [ 0  0  0  0 ]
3 [ 0  0  1  0 ]

matrix[0][1] = 1 means edge 0→1
Not symmetric for directed graphs
```

**Weighted Graph**:

```
Graph:
    0 --5-- 1
    |       |
    2       3
    |       |
    2 --4-- 3

Adjacency Matrix:
    0  1  2  3
0 [ 0  5  2  0 ]
1 [ 5  0  0  3 ]
2 [ 2  0  0  4 ]
3 [ 0  3  4  0 ]

matrix[i][j] = weight of edge
0 or ∞ means no edge
```

**Characteristics**:

```
Pros:
✓ O(1) edge lookup
✓ O(1) add/remove edge
✓ Simple to implement
✓ Good for dense graphs

Cons:
✗ O(V²) space (always)
✗ O(V) to find all neighbors
✗ Wasteful for sparse graphs

Best for:
- Dense graphs (many edges)
- Need frequent edge existence checks
- Small graphs
```

---

### 2. Adjacency List

**Concept**: Array of lists where list[i] contains all neighbors of vertex i

**Undirected Graph Example**:

```
Graph:
    0 --- 1
    |     |
    2 --- 3

Adjacency List:
0: [1, 2]
1: [0, 3]
2: [0, 3]
3: [1, 2]

Each edge appears twice
(once for each endpoint)
```

**Directed Graph Example**:

```
Graph:
    0 → 1
    ↓   ↓
    2 ← 3

Adjacency List:
0: [1, 2]
1: [3]
2: []
3: [2]

Each edge appears once
(from source to destination)
```

**Weighted Graph**:

```
Graph:
    0 --5-- 1
    |       |
    2       3
    |       |
    2 --4-- 3

Adjacency List (with weights):
0: [(1,5), (2,2)]
1: [(0,5), (3,3)]
2: [(0,2), (3,4)]
3: [(1,3), (2,4)]

Store (neighbor, weight) pairs
```

**Characteristics**:

```
Pros:
✓ O(V + E) space
✓ O(degree) to find neighbors
✓ Efficient for sparse graphs
✓ Easy to iterate neighbors

Cons:
✗ O(degree) edge lookup
✗ Slower edge existence check

Best for:
- Sparse graphs (few edges)
- Need to iterate neighbors
- Most real-world graphs
```

---

### 3. Edge List

**Concept**: List of all edges in the graph

**Example**:

```
Graph:
    0 --5-- 1
    |       |
    2       3
    |       |
    2 --4-- 3

Edge List (unweighted):
[(0,1), (0,2), (1,3), (2,3)]

Edge List (weighted):
[(0,1,5), (0,2,2), (1,3,3), (2,3,4)]
Format: (from, to, weight)
```

**Characteristics**:

```
Pros:
✓ O(E) space
✓ Simple implementation
✓ Easy to sort edges
✓ Good for edge-centric algorithms

Cons:
✗ O(E) edge lookup
✗ O(E) to find neighbors
✗ Not efficient for most operations

Best for:
- Kruskal's MST algorithm
- Union-Find operations
- Edge sorting problems
```

---

### 4. Adjacency Set

**Concept**: Like adjacency list but using hash sets for O(1) lookup

**Example**:

```
Graph:
    0 --- 1
    |     |
    2 --- 3

Adjacency Set:
0: {1, 2}
1: {0, 3}
2: {0, 3}
3: {1, 2}

Sets instead of lists
```

**Characteristics**:

```
Pros:
✓ O(1) edge lookup
✓ O(V + E) space
✓ O(1) add/remove edge
✓ Best of matrix and list

Cons:
✗ Extra overhead for sets
✗ No guaranteed order

Best for:
- Need fast edge lookup
- Sparse graphs
- Dynamic graphs (frequent add/remove)
```

---

## 📏 Space Complexity Comparison

### For V vertices and E edges:

```
Representation     | Space Complexity | Best For
-------------------|------------------|------------------
Adjacency Matrix   | O(V²)           | Dense graphs
Adjacency List     | O(V + E)        | Sparse graphs
Edge List          | O(E)            | Edge operations
Adjacency Set      | O(V + E)        | Fast edge lookup

Dense graph: E ≈ V²
Sparse graph: E << V²
```

**Visual Comparison**:

```
Sparse Graph (V=5, E=5):
Matrix: 25 cells (5×5)
List:   10 entries (5 vertices + 5 edges)
        
Dense Graph (V=5, E=10):
Matrix: 25 cells (5×5)
List:   15 entries (5 vertices + 10 edges)

For sparse graphs, list is better!
```

---

## 🎯 Choosing the Right Representation

### Decision Tree:

```
Is graph dense (E ≈ V²)?
    ├─ Yes → Adjacency Matrix
    └─ No (sparse) → Need fast edge lookup?
        ├─ Yes → Adjacency Set
        └─ No → Adjacency List

Need to process edges?
    └─ Yes → Edge List

Need to add/remove edges frequently?
    └─ Yes → Adjacency Set
```

### Use Case Examples:

**Social Network (sparse, large)**:

```
1 billion users (V)
Average 200 friends per user
E = 100 billion

Matrix: 10¹⁸ space ❌
List:   10¹¹ space ✓

Use: Adjacency List or Set
```

**Flight Routes (weighted, sparse)**:

```
10,000 airports (V)
50,000 routes (E)

Need: Fast neighbor iteration
      Weight information

Use: Adjacency List with weights
```

**Road Network (weighted, needs pathfinding)**:

```
Millions of intersections
Need: Shortest path queries
      Distance/time weights

Use: Adjacency List with weights
     + preprocessing for fast queries
```

**Task Dependencies (DAG)**:

```
Hundreds of tasks
Need: Topological order
      Detect cycles

Use: Adjacency List
```

---

## 🎨 Special Graph Representations

### 1. Incidence Matrix

**Concept**: Matrix of vertices × edges

```
Graph:
    A ---e1--- B
    |          |
   e2         e3
    |          |
    C ---e4--- D

Incidence Matrix:
     e1 e2 e3 e4
A [  1  1  0  0 ]
B [  1  0  1  0 ]
C [  0  1  0  1 ]
D [  0  0  1  1 ]

1 means vertex is incident to edge
```

**For Directed Graphs**:

```
Use +1 for source, -1 for destination

    A --e1→ B
    ↓e2     ↓e3
    C --e4→ D

     e1 e2 e3 e4
A [ +1 +1  0  0 ]
B [ -1  0 +1  0 ]
C [  0 -1  0 +1 ]
D [  0  0 -1 -1 ]
```

---

### 2. Compressed Sparse Row (CSR)

**Concept**: Efficient storage for sparse graphs

```
Graph:
    0 → 1 → 2
    ↓       ↓
    3       4

CSR representation:
values:  [1, 2, 3, 4]  (destination vertices)
columns: [0, 2, 3, 4]  (where each row starts)
         row 0: values[0:2] = [1, 3]
         row 1: values[2:3] = [2]
         row 2: values[3:4] = [4]

Used in high-performance computing
```

---

## 💾 Implementation Examples

### Adjacency Matrix Structure:

```
Conceptual structure:

class Graph {
    vertices: number
    matrix: number[][]
    
    constructor(V):
        vertices = V
        matrix = new Array(V × V)
        fill with 0
    
    addEdge(u, v, weight=1):
        matrix[u][v] = weight
        matrix[v][u] = weight  // for undirected
    
    hasEdge(u, v):
        return matrix[u][v] != 0
    
    getNeighbors(u):
        neighbors = []
        for v in 0 to V-1:
            if matrix[u][v] != 0:
                neighbors.add(v)
        return neighbors
}
```

### Adjacency List Structure:

```
Conceptual structure:

class Graph {
    vertices: number
    adjList: Map<number, List<Edge>>
    
    constructor(V):
        vertices = V
        adjList = new Map()
        for i in 0 to V-1:
            adjList[i] = new List()
    
    addEdge(u, v, weight=1):
        adjList[u].add((v, weight))
        adjList[v].add((u, weight))  // for undirected
    
    hasEdge(u, v):
        for (neighbor, weight) in adjList[u]:
            if neighbor == v:
                return true
        return false
    
    getNeighbors(u):
        return adjList[u]
}
```

---

## 📈 Operation Complexity Comparison

| Operation | Matrix | List | Edge List | Set |
|-----------|--------|------|-----------|-----|
| Add vertex | O(V²)* | O(1) | O(1) | O(1) |
| Add edge | O(1) | O(1) | O(1) | O(1) |
| Remove edge | O(1) | O(E) | O(E) | O(1) |
| Has edge | O(1) | O(V) | O(E) | O(1) |
| Get neighbors | O(V) | O(1) | O(E) | O(1) |
| Space | O(V²) | O(V+E) | O(E) | O(V+E) |

*Requires resizing matrix

---

## 🎓 Key Takeaways

1. **Graph Types**: Directed, weighted, cyclic determine representation choice
2. **Matrix**: Best for dense graphs, O(1) edge lookup
3. **List**: Best for sparse graphs, memory efficient
4. **Edge List**: Best for edge-centric algorithms
5. **Set**: Best balance of speed and space
6. **Tradeoffs**: Space vs query time, static vs dynamic
7. **Real-world**: Most graphs are sparse → use adjacency list
8. **Choose wisely**: Representation affects algorithm efficiency

---

## 💡 Interview Tips

1. **Ask about graph properties**: Dense or sparse? Directed? Weighted?
2. **Clarify operations**: What queries are most common?
3. **Consider constraints**: Million vertices? Billion edges?
4. **Discuss tradeoffs**: Explain why you chose a representation
5. **Dynamic vs static**: Will graph change during execution?
6. **Space limits**: Can you afford O(V²) space?
7. **Implementation details**: Hash sets vs arrays for adjacency list?

---

## 🔗 Related Topics

- [Graph Traversals](./20_GRAPH_TRAVERSALS.md)
- [Shortest Path Algorithms](./21_SHORTEST_PATHS.md)
- [Advanced Graph Algorithms](./22_ADVANCED_GRAPHS.md)
- [Trees](./13_BINARY_TREES.md)

---

**Next**: [Graph Traversals (BFS & DFS)](./20_GRAPH_TRAVERSALS.md)
