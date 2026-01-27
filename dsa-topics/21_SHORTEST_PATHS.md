# Shortest Path Algorithms

## 📋 Overview

**Shortest path algorithms** find the minimum-cost path between vertices in a weighted graph. These are fundamental algorithms in computer science with applications in routing, navigation, network optimization, and more. Different algorithms are optimal for different graph types and constraints.

**Difficulty Level**: 🔴 Advanced

---

## 🎯 Problem Categories

### Types of Shortest Path Problems

```
1. Single-Source Shortest Path (SSSP)
   From one vertex to all others
   Examples: Dijkstra, Bellman-Ford

2. Single-Pair Shortest Path
   From source to specific target
   Can use SSSP algorithms

3. All-Pairs Shortest Path (APSP)
   Between every pair of vertices
   Examples: Floyd-Warshall, Johnson's

4. Single-Destination Shortest Path
   All vertices to one destination
   Reverse edges, use SSSP
```

---

## 🚀 Dijkstra's Algorithm

### Core Concept

**Dijkstra's** finds shortest paths from a source to all vertices in graphs with **non-negative** edge weights. Uses greedy approach with priority queue.

**Key Idea**: Always process the closest unvisited vertex.

---

### Visual Example

```
Graph:
        2       3
    A ----→ B ----→ C
    |       |       ↑
    1       4       |
    |       |       2
    ↓       ↓       |
    D ----→ E ------┘
        5

Find shortest paths from A
```

**Step-by-Step Execution**:

```
Initial State:
Distance: {A: 0, B: ∞, C: ∞, D: ∞, E: ∞}
Priority Queue: [(0, A)]
Visited: {}

Step 1: Process A (distance 0)
Update neighbors:
  B: 0 + 2 = 2
  D: 0 + 1 = 1
Distance: {A:0, B:2, D:1, C:∞, E:∞}
PQ: [(1,D), (2,B)]
Visited: {A}

        [0]
    A ----→ B
    |       
  [1]       
    |       
    ↓       
    D       

Step 2: Process D (distance 1)
Update neighbors:
  E: 1 + 5 = 6
Distance: {A:0, B:2, D:1, E:6, C:∞}
PQ: [(2,B), (6,E)]
Visited: {A, D}

Step 3: Process B (distance 2)
Update neighbors:
  C: 2 + 3 = 5
  E: 2 + 4 = 6 (not better than 6)
Distance: {A:0, B:2, D:1, E:6, C:5}
PQ: [(5,C), (6,E)]
Visited: {A, B, D}

Step 4: Process C (distance 5)
Update neighbors:
  (no outgoing edges)
Distance: {A:0, B:2, D:1, E:6, C:5}
PQ: [(6,E)]
Visited: {A, B, C, D}

Step 5: Process E (distance 6)
Update neighbors:
  C: 6 + 2 = 8 (worse than 5)
Final Distance: {A:0, B:2, D:1, E:6, C:5}
Visited: {A, B, C, D, E}
```

**Final Shortest Paths**:

```
A → A: 0
A → B: 2 (path: A → B)
A → C: 5 (path: A → B → C)
A → D: 1 (path: A → D)
A → E: 6 (path: A → D → E)
```

---

### Path Reconstruction

```
Track parent pointers:

During algorithm:
When updating distance[v] via u:
  distance[v] = distance[u] + weight(u,v)
  parent[v] = u

After algorithm:
Reconstruct path from A to C:
C → parent[C] = B
B → parent[B] = A
A → parent[A] = null

Path: A → B → C
```

---

### Why Greedy Works

```
Key Property: Non-negative weights

When we process vertex u with distance d:
- d is the shortest distance to u
- Any path through unprocessed vertices would be longer
  (because weights are non-negative)

Example:
    A --1-- B --(-5)-- C
    |                   ↑
    10                  |
    └-------------------┘

With negative weight:
Path A→B→C: 1 + (-5) = -4
Path A→C: 10

Greedy would choose B first (distance 1)
But better path exists through C!
❌ Dijkstra fails with negative weights
```

---

### Complexity

- **Time**: O((V + E) log V) with binary heap priority queue
- **Time**: O(V²) with array (dense graphs)
- **Time**: O(V + E) with Fibonacci heap (theoretical)
- **Space**: O(V) for distances, priority queue, visited set

```
Example:
V = 1000 vertices
E = 5000 edges

With binary heap:
O((1000 + 5000) × log 1000) ≈ 60,000 operations
```

---

## ⚡ Bellman-Ford Algorithm

### Core Concept

**Bellman-Ford** finds shortest paths from source to all vertices, works with **negative weights**, and **detects negative cycles**.

**Key Idea**: Relax all edges V-1 times.

---

### Visual Example

```
Graph with negative weight:
        2
    A ----→ B
    |       ↓
    4      -3
    ↓       ↓
    C ←---- D
        1

Find shortest paths from A
```

**Relaxation Process**:

```
Initial:
Distance: {A: 0, B: ∞, C: ∞, D: ∞}

Iteration 1: Relax all edges
Edge A→B: dist[B] = min(∞, 0+2) = 2
Edge A→C: dist[C] = min(∞, 0+4) = 4
Edge B→D: dist[D] = min(∞, 2-3) = -1
Edge D→C: dist[C] = min(4, -1+1) = 0

After iteration 1:
Distance: {A:0, B:2, C:0, D:-1}

Iteration 2: Relax all edges
Edge A→B: dist[B] = min(2, 0+2) = 2 (no change)
Edge A→C: dist[C] = min(0, 0+4) = 0 (no change)
Edge B→D: dist[D] = min(-1, 2-3) = -1 (no change)
Edge D→C: dist[C] = min(0, -1+1) = 0 (no change)

After iteration 2:
Distance: {A:0, B:2, C:0, D:-1}

Iteration 3: (No changes)
Distance: {A:0, B:2, C:0, D:-1}

Final shortest distances:
A→A: 0
A→B: 2 (path: A → B)
A→C: 0 (path: A → B → D → C)
A→D: -1 (path: A → B → D)
```

---

### Negative Cycle Detection

```
Graph with negative cycle:
    A --1-- B
    |       |
    2      -5
    |       |
    C --1-- D

Cycle: A → B → D → C → A
Weight: 1 + (-5) + 1 + 2 = -1 < 0

After V-1 iterations:
Distance: {A:0, B:1, C:2, D:-4}

V-th iteration:
Edge B→D: dist[D] = min(-4, 1-5) = -6 (changed!)
Distance changed → negative cycle detected!

Why negative cycles are problematic:
Can keep going around cycle to reduce distance infinitely
Shortest path undefined
```

---

### Why V-1 Iterations?

```
Maximum shortest path length = V-1 edges

Example: Linear graph
A → B → C → D → E (4 edges, 5 vertices)

Iteration 1: A→B shortest distance found
Iteration 2: A→B→C shortest distance found
Iteration 3: A→B→C→D shortest distance found
Iteration 4: A→B→C→D→E shortest distance found

After V-1 iterations, all shortest paths found
(if no negative cycles)
```

---

### Complexity

- **Time**: O(V × E) - V-1 iterations, each processes all E edges
- **Space**: O(V) for distances array

```
Example:
V = 100 vertices
E = 500 edges

Time: 100 × 500 = 50,000 operations
Much slower than Dijkstra!
```

---

## 🌐 Floyd-Warshall Algorithm

### Core Concept

**Floyd-Warshall** finds shortest paths between **all pairs** of vertices. Works with negative weights. Uses dynamic programming.

**Key Idea**: Consider paths through intermediate vertices k.

---

### Visual Example

```
Graph:
      3
  A ----→ B
  |       |
  2       1
  ↓       ↓
  C ----→ D
      4

Initial distance matrix (direct edges):
     A  B  C  D
A [  0  3  2  ∞ ]
B [  ∞  0  ∞  1 ]
C [  ∞  ∞  0  4 ]
D [  ∞  ∞  ∞  0 ]
```

**Dynamic Programming Process**:

```
For k = 0 to V-1:
  For i = 0 to V-1:
    For j = 0 to V-1:
      dist[i][j] = min(dist[i][j], 
                       dist[i][k] + dist[k][j])

Meaning: Can we improve path i→j by going through k?
```

**Step-by-Step**:

```
k=0 (intermediate vertex A):
Can A help any path?

i=B, j=C: B→C vs B→A→C
  ∞ vs (∞ + 2) = no improvement
  
i=B, j=D: B→D vs B→A→D
  1 vs (∞ + ∞) = no improvement

After k=0:
     A  B  C  D
A [  0  3  2  ∞ ]
B [  ∞  0  ∞  1 ]
C [  ∞  ∞  0  4 ]
D [  ∞  ∞  ∞  0 ]

k=1 (intermediate vertex B):
Can B help any path?

i=A, j=D: A→D vs A→B→D
  ∞ vs (3 + 1) = 4 ✓ improvement!

After k=1:
     A  B  C  D
A [  0  3  2  4 ]
B [  ∞  0  ∞  1 ]
C [  ∞  ∞  0  4 ]
D [  ∞  ∞  ∞  0 ]

k=2 (intermediate vertex C):
Can C help any path?

i=A, j=D: A→D vs A→C→D
  4 vs (2 + 4) = 6 (no improvement)

After k=2:
     A  B  C  D
A [  0  3  2  4 ]
B [  ∞  0  ∞  1 ]
C [  ∞  ∞  0  4 ]
D [  ∞  ∞  ∞  0 ]

k=3 (intermediate vertex D):
No improvements possible

Final matrix:
     A  B  C  D
A [  0  3  2  4 ]
B [  ∞  0  ∞  1 ]
C [  ∞  ∞  0  4 ]
D [  ∞  ∞  ∞  0 ]
```

---

### Path Reconstruction

```
Maintain next[][] matrix:

Initially:
next[i][j] = j (direct edge)

When updating distance:
if dist[i][j] > dist[i][k] + dist[k][j]:
  dist[i][j] = dist[i][k] + dist[k][j]
  next[i][j] = next[i][k]

To get path from i to j:
path = [i]
while i != j:
  i = next[i][j]
  path.append(i)
```

---

### Negative Cycle Detection

```
After algorithm:
Check diagonal:
  if dist[i][i] < 0:
    negative cycle exists!

Example:
     A  B  C
A [  0  1  ∞ ]
B [  ∞  0  -2]
C [  1  ∞  0 ]

After Floyd-Warshall:
     A  B  C
A [  -1 0  -2]  ← dist[A][A] < 0
B [  -1 -2 -2]  ← dist[B][B] < 0
C [  0  1  -1]  ← dist[C][C] < 0

All vertices on negative cycle!
```

---

### Complexity

- **Time**: O(V³) - three nested loops
- **Space**: O(V²) for distance matrix

```
Example:
V = 100 vertices

Time: 100³ = 1,000,000 operations
Space: 100² = 10,000 entries

Good for dense graphs, small V
Not practical for large sparse graphs
```

---

## 🎯 Algorithm Comparison

### When to Use Which

```
Dijkstra:
✓ Non-negative weights
✓ Single source
✓ Fast: O((V+E) log V)
✗ Doesn't handle negative weights

Bellman-Ford:
✓ Handles negative weights
✓ Detects negative cycles
✓ Single source
✗ Slow: O(V×E)

Floyd-Warshall:
✓ All pairs shortest path
✓ Handles negative weights
✓ Simple to implement
✗ Very slow: O(V³)
✗ High memory: O(V²)
```

---

### Performance Comparison

```
Graph: V=1000, E=5000

Dijkstra (single source):
Time: (1000 + 5000) × log(1000) ≈ 60,000

Bellman-Ford (single source):
Time: 1000 × 5000 = 5,000,000

Floyd-Warshall (all pairs):
Time: 1000³ = 1,000,000,000

Dijkstra × 1000 (all pairs with non-negative):
Time: 60,000 × 1000 = 60,000,000
(Still better than Floyd-Warshall!)
```

---

## 🎨 Special Cases & Variations

### 1. A* Search

**Concept**: Dijkstra with heuristic guidance toward goal

```
Priority: g(n) + h(n)
g(n) = cost from start to n
h(n) = estimated cost from n to goal (heuristic)

Example: Map navigation
Heuristic = straight-line distance to destination

        [A]
       /   \
    5 /     \ 8
     /       \
   [B]       [C]
     \       /
    3 \     / 2
       \   /
        [Goal]

h(A) = 6, h(B) = 3, h(C) = 2

A* explores: A → B → Goal
(Ignores C due to heuristic)

Dijkstra would explore both paths
A* more efficient with good heuristic!
```

---

### 2. Bidirectional Dijkstra

**Concept**: Search from both source and target

```
Regular Dijkstra:
Source → → → → → Target
(explore entire graph)

Bidirectional:
Source → → ← ← Target
(meet in middle)

Speedup: 2× to 10× in practice
```

---

### 3. SPFA (Shortest Path Faster Algorithm)

**Concept**: Optimization of Bellman-Ford using queue

```
Only relax edges from vertices whose distance changed

Queue: [A]
Distance: {A: 0, B: ∞, C: ∞}

Process A:
  Update B, C
  Queue: [B, C]

Process B:
  Update neighbors if improved
  
Average: O(E)
Worst: O(V×E) (like Bellman-Ford)
```

---

## 🌍 Real-World Applications

### 1. GPS Navigation

```
Graph: Road network
Vertices: Intersections
Edges: Roads (weighted by distance/time)

Algorithm: Dijkstra or A*
Heuristic: Straight-line distance

Output: Turn-by-turn directions
```

### 2. Network Routing

```
Graph: Network topology
Vertices: Routers
Edges: Links (weighted by latency/bandwidth)

Algorithm: Dijkstra (OSPF protocol)

Dynamic: Recompute when network changes
```

### 3. Flight Itineraries

```
Graph: Flight network
Vertices: Airports
Edges: Flights (weighted by cost/time)

Algorithm: Dijkstra or Bellman-Ford
Constraints: Layover times, multiple criteria

Multi-criteria shortest path problem
```

### 4. Currency Arbitrage

```
Graph: Currency exchange
Vertices: Currencies
Edges: Exchange rates

Use negative log(rate):
Negative cycle = arbitrage opportunity!

Algorithm: Bellman-Ford
Detect profitable trading cycles
```

### 5. Social Networks

```
Graph: User connections
Vertices: Users
Edges: Friendships/follows

Find: Shortest path between users
"Degrees of separation"

Algorithm: BFS (unweighted) or Dijkstra
```

---

## 🎓 Key Takeaways

1. **Dijkstra**: Fast, non-negative weights, greedy approach
2. **Bellman-Ford**: Handles negatives, detects cycles, slower
3. **Floyd-Warshall**: All pairs, DP approach, O(V³)
4. **Choose wisely**: Based on graph properties and requirements
5. **Optimization**: A*, bidirectional search for specific cases
6. **Real-world**: Routing, navigation, network protocols
7. **Tradeoffs**: Time vs space vs generality

---

## 💡 Interview Tips

1. **Clarify weights**: Positive only? Negative weights? Cycles?
2. **Problem type**: Single-source or all-pairs?
3. **Graph size**: Small (Floyd-Warshall OK) or large?
4. **Discuss choices**: Why Dijkstra over Bellman-Ford?
5. **Edge cases**: Disconnected graph? Unreachable vertices?
6. **Optimization**: Can we use heuristics (A*)?
7. **Implementation**: Priority queue for Dijkstra essential

---

## 🔗 Related Topics

- [Graph Representations](./19_GRAPH_BASICS.md)
- [Graph Traversals](./20_GRAPH_TRAVERSALS.md)
- [Advanced Graph Algorithms](./22_ADVANCED_GRAPHS.md)
- [Priority Queues](./18_PRIORITY_QUEUES.md)

---

**Next**: [Advanced Graph Algorithms](./22_ADVANCED_GRAPHS.md)
