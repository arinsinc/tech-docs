# Graph Traversals (BFS & DFS)

## 📋 Overview

**Graph traversal** is the process of visiting all vertices in a graph systematically. The two fundamental traversal methods are **Breadth-First Search (BFS)** and **Depth-First Search (DFS)**. These form the foundation for solving numerous graph problems including pathfinding, connectivity, cycle detection, and topological sorting.

**Difficulty Level**: 🟡 Intermediate

---

## 🌊 Breadth-First Search (BFS)

### Core Concept

**BFS** explores the graph level by level, visiting all neighbors before moving to the next level. It uses a **queue** data structure.

**Key Characteristics**:
- Visit neighbors before going deeper
- Uses queue (FIFO)
- Finds shortest path in unweighted graphs
- Level-order traversal

---

### Visual Example

```
Graph:
        0
       /|\
      1 2 3
     /|   |
    4 5   6

BFS Starting from 0:

Level 0: [0]
Level 1: [1, 2, 3]
Level 2: [4, 5, 6]

Traversal Order: 0 → 1 → 2 → 3 → 4 → 5 → 6
```

---

### Step-by-Step Process

```
Initial state:
Queue: [0]
Visited: {0}

Step 1: Process 0
Remove 0 from queue
Add neighbors: 1, 2, 3
Queue: [1, 2, 3]
Visited: {0, 1, 2, 3}
Output: 0

Step 2: Process 1
Remove 1 from queue
Add unvisited neighbors: 4, 5
Queue: [2, 3, 4, 5]
Visited: {0, 1, 2, 3, 4, 5}
Output: 0, 1

Step 3: Process 2
Remove 2 from queue
No unvisited neighbors
Queue: [3, 4, 5]
Output: 0, 1, 2

Step 4: Process 3
Remove 3 from queue
Add unvisited neighbor: 6
Queue: [4, 5, 6]
Visited: {0, 1, 2, 3, 4, 5, 6}
Output: 0, 1, 2, 3

Step 5-7: Process 4, 5, 6
All have no unvisited neighbors
Output: 0, 1, 2, 3, 4, 5, 6
```

---

### BFS with Distance Tracking

**Example**: Find distance from source to all vertices

```
Graph:
    0 --- 1 --- 2
    |           |
    3 --- 4 --- 5

BFS from 0 with distances:

Initial:
Queue: [(0, 0)]  // (vertex, distance)
Distance: {0: 0}

Step 1: Process (0, 0)
Neighbors: 1, 3
Queue: [(1,1), (3,1)]
Distance: {0:0, 1:1, 3:1}

Step 2: Process (1, 1)
Neighbors: 0(visited), 2
Queue: [(3,1), (2,2)]
Distance: {0:0, 1:1, 3:1, 2:2}

Step 3: Process (3, 1)
Neighbors: 0(visited), 4
Queue: [(2,2), (4,2)]
Distance: {0:0, 1:1, 3:1, 2:2, 4:2}

Step 4: Process (2, 2)
Neighbors: 1(visited), 5
Queue: [(4,2), (5,3)]
Distance: {0:0, 1:1, 3:1, 2:2, 4:2, 5:3}

Step 5-6: Process (4,2), (5,3)
Final distances from 0:
0→0: 0
0→1: 1
0→2: 2
0→3: 1
0→4: 2
0→5: 3
```

---

### BFS on Disconnected Graph

```
Graph with 2 components:
    0 --- 1     4 --- 5
    |           |
    2 --- 3     6

BFS from all unvisited nodes:

Component 1 (start from 0):
BFS: 0 → 1 → 2 → 3

Component 2 (start from 4):
BFS: 4 → 5 → 6

Complete traversal: [0,1,2,3,4,5,6]
Number of components: 2
```

---

### Shortest Path with BFS

**Example**: Find shortest path from A to E

```
Graph:
    A --- B --- C
    |     |     |
    D --- E --- F

BFS with parent tracking:

Queue: [A]
Parent: {A: null}

Process A:
Queue: [B, D]
Parent: {A:null, B:A, D:A}

Process B:
Queue: [D, C, E]
Parent: {A:null, B:A, D:A, C:B, E:B}

Found E!
Reconstruct path by following parents:
E → B (parent of E)
B → A (parent of B)
A → null (reached source)

Path: A → B → E
Distance: 2
```

---

### BFS Applications

#### 1. Level Order Traversal

```
Tree:
        1
       / \
      2   3
     / \
    4   5

BFS gives levels:
Level 0: [1]
Level 1: [2, 3]
Level 2: [4, 5]
```

#### 2. Check if Graph is Bipartite

```
Bipartite: Can color vertices with 2 colors such that
           no edge connects same color

Graph:
    0 --- 1
    |     |
    3 --- 2

BFS with coloring:
Color 0: Red
Color 1, 3: Blue (neighbors of 0)
Color 2: Red (neighbor of 1, 3)

Valid bipartite! 
Red: {0, 2}
Blue: {1, 3}

Non-bipartite example:
    0 --- 1
    |   / |
    | /   |
    2 --- 3

Color 0: Red
Color 1, 2: Blue
Color 3: needs Red (neighbor of 1,2)
But 3 neighbors 0 (also Red)! ❌
Not bipartite (contains odd cycle)
```

#### 3. Snake and Ladder

```
Board: 1 to 100
Snakes and Ladders

BFS from 1:
Each state = board position
Edges = dice roll (1-6) + snakes/ladders

Find shortest path (minimum rolls) to 100

Queue: [1]
From 1, can reach: 2,3,4,5,6,7
Apply snakes/ladders transformations
Continue BFS until reaching 100
```

---

## 🌲 Depth-First Search (DFS)

### Core Concept

**DFS** explores the graph by going as deep as possible before backtracking. It uses a **stack** (implicit via recursion or explicit).

**Key Characteristics**:
- Go deep before going wide
- Uses stack (recursion or explicit)
- Natural for recursive problems
- Detects cycles, components

---

### Visual Example

```
Graph:
        0
       /|\
      1 2 3
     /|   |
    4 5   6

DFS Starting from 0:

Path:
0 → 1 → 4 (dead end, backtrack)
    1 → 5 (dead end, backtrack)
    (back to 0)
0 → 2 (dead end, backtrack)
0 → 3 → 6 (dead end, backtrack)

Traversal Order: 0 → 1 → 4 → 5 → 2 → 3 → 6
```

---

### Step-by-Step Process (Recursive)

```
DFS(0):
    Mark 0 as visited
    Output: 0
    
    For neighbor 1:
        DFS(1):
            Mark 1 as visited
            Output: 1
            
            For neighbor 4:
                DFS(4):
                    Mark 4 as visited
                    Output: 4
                    No unvisited neighbors
                    Return
            
            For neighbor 5:
                DFS(5):
                    Mark 5 as visited
                    Output: 5
                    No unvisited neighbors
                    Return
            
            Return to DFS(0)
    
    For neighbor 2:
        DFS(2):
            Mark 2 as visited
            Output: 2
            No unvisited neighbors
            Return
    
    For neighbor 3:
        DFS(3):
            Mark 3 as visited
            Output: 3
            
            For neighbor 6:
                DFS(6):
                    Mark 6 as visited
                    Output: 6
                    Return
            
            Return

Complete: 0 → 1 → 4 → 5 → 2 → 3 → 6
```

---

### DFS with Stack (Iterative)

```
Graph:
    0 --- 1
    |     |
    2 --- 3

Initial:
Stack: [0]
Visited: {}

Step 1: Pop 0
Add neighbors: 1, 2
Stack: [1, 2]
Visited: {0}
Output: 0

Step 2: Pop 2
Add neighbors: 0(visited), 3
Stack: [1, 3]
Visited: {0, 2}
Output: 0, 2

Step 3: Pop 3
Add neighbors: 2(visited), 1
Stack: [1, 1]
Visited: {0, 2, 3}
Output: 0, 2, 3

Step 4: Pop 1
Already visited? No
Mark visited
Add neighbors: 0(visited), 3(visited)
Stack: [1]
Visited: {0, 1, 2, 3}
Output: 0, 2, 3, 1

Result: 0 → 2 → 3 → 1
```

**Note**: Order may differ from recursive DFS due to stack/recursion handling

---

### DFS Applications

#### 1. Detect Cycle in Directed Graph

```
Graph:
    0 → 1 → 2
    ↑       ↓
    └───────┘

DFS with recursion stack tracking:

Start DFS(0):
RecStack: {0}
Visit 1:
    RecStack: {0, 1}
    Visit 2:
        RecStack: {0, 1, 2}
        Visit 0: Already in RecStack!
        Cycle detected: 0 → 1 → 2 → 0
```

#### 2. Detect Cycle in Undirected Graph

```
Graph:
    0 --- 1
    |     |
    2 --- 3

DFS(0, parent=null):
    Visit 1 (parent=0):
        Visit 3 (parent=1):
            Visit 2 (parent=3):
                Visit 0: Already visited!
                Is 0 the parent? No (parent is 3)
                Cycle detected!
```

#### 3. Topological Sort (DAG)

```
DAG:
    A → B → D
    ↓   ↓
    C → E

DFS with finish time tracking:

DFS from all unvisited:
    DFS(A):
        DFS(B):
            DFS(D): finish D
            DFS(E): finish E
        finish B
        DFS(C):
            (E already finished)
        finish C
    finish A

Topological order (reverse finish time):
A → C → B → E → D
or
A → B → C → E → D
(multiple valid orderings possible)
```

#### 4. Connected Components

```
Graph:
    0 --- 1     4 --- 5
    |           |
    2 --- 3     6 --- 7

DFS from each unvisited:

Component 1:
DFS(0): visits 0,1,2,3
Count: 1

Component 2:
DFS(4): visits 4,5,6,7
Count: 2

Total components: 2
```

#### 5. Strongly Connected Components (SCC)

```
Directed graph:
    0 → 1 → 2
    ↑       ↓
    └───────┘
    ↓
    3 → 4

Kosaraju's Algorithm:
1. DFS on original graph (track finish times)
2. Reverse all edges
3. DFS on reversed graph in decreasing finish time

SCCs:
- {0, 1, 2}
- {3}
- {4}
```

#### 6. Path Finding

```
Find path from A to D:

Graph:
    A --- B
    |     |
    C --- D

DFS(A, target=D, path=[]):
    path = [A]
    Visit B:
        path = [A, B]
        Visit D:
            path = [A, B, D]
            Found target!
            Return [A, B, D]

Alternative path: [A, C, D]
DFS finds one valid path
```

---

## 🎯 BFS vs DFS Comparison

### Visual Exploration Pattern

```
Graph:
        1
      / | \
     2  3  4
    /|  |  |\
   5 6  7  8 9

BFS Order:
1 → 2 → 3 → 4 → 5 → 6 → 7 → 8 → 9
(Level by level)

DFS Order (possible):
1 → 2 → 5 → 6 → 3 → 7 → 4 → 8 → 9
(Deep before wide)
```

---

### Characteristics Comparison

| Feature | BFS | DFS |
|---------|-----|-----|
| Data Structure | Queue | Stack/Recursion |
| Memory | O(width) | O(height) |
| Shortest Path | Yes (unweighted) | No |
| All paths | No | Yes (with backtracking) |
| Cycle Detection | Yes | Yes (easier) |
| Space | More for wide graphs | More for deep graphs |
| Use Case | Level-order, shortest path | Topological sort, cycles |

---

### Time & Space Complexity

**Both BFS and DFS**:
- **Time**: O(V + E) - visit each vertex and edge once
- **Space**: 
  - BFS: O(V) - queue can hold all vertices at a level
  - DFS: O(V) - recursion stack depth = height of graph

```
Example:
V = 100 vertices
E = 500 edges

Time: O(100 + 500) = O(600)
Space: O(100)
```

---

### When to Use Which?

```
Use BFS when:
✓ Finding shortest path (unweighted)
✓ Level-order traversal needed
✓ Finding all nodes within k distance
✓ Testing bipartiteness
✓ Social network (degrees of separation)

Use DFS when:
✓ Detecting cycles
✓ Topological sorting
✓ Finding strongly connected components
✓ Solving mazes/puzzles
✓ Generating all possible paths
✓ Tree/graph traversal problems
```

---

## 🎨 Advanced Traversal Patterns

### 1. Bidirectional BFS

**Concept**: BFS from both source and target simultaneously

```
Find path from A to F:

Regular BFS:
Level 0: A
Level 1: B, C
Level 2: D, E
Level 3: F

Bidirectional BFS:
Forward: A → B, C
Backward: F → E
Meet in middle: C connects to E

Faster for large graphs!
```

### 2. Multi-Source BFS

**Concept**: Start BFS from multiple sources simultaneously

```
Problem: Shortest distance to nearest hospital

Hospitals at: H1, H2, H3
Start BFS from all hospitals:

Queue: [H1, H2, H3]

Each cell gets distance to nearest hospital
Naturally finds closest one
```

### 3. 0-1 BFS

**Concept**: BFS for weighted graphs with weights 0 and 1

```
Graph with 0 and 1 weights:
    A --0-- B --1-- C
    |               |
    1               0
    |               |
    D --0-- E --1-- F

Use deque:
- Weight 0: add to front
- Weight 1: add to back

Finds shortest path in O(E)
Faster than Dijkstra for 0-1 weights!
```

### 4. Iterative Deepening DFS

**Concept**: Combine DFS space efficiency with BFS completeness

```
Depth limit increases:
Depth 0: 1
Depth 1: 1, 2, 3, 4
Depth 2: 1, 2, 5, 6, 3, 7, 4, 8, 9

Memory: O(depth)
Complete like BFS
```

---

## 🌍 Real-World Applications

### 1. Social Networks

```
BFS: Find friends within 3 degrees
     Friend of friend of friend

DFS: Find if path exists between users
     Explore friend groups deeply
```

### 2. Web Crawler

```
BFS: Level-by-level crawling
     All pages at depth d before d+1

DFS: Follow links deeply
     Explore one path completely
```

### 3. GPS Navigation

```
BFS: Find shortest route (number of roads)
     Unweighted graph

DFS: Explore all possible routes
     Find alternative paths
```

### 4. Dependency Resolution

```
DFS: Build order (topological sort)
     Detect circular dependencies
     
Package manager, build systems
```

### 5. Game AI

```
DFS: Explore game tree
     Minimax algorithm
     Chess, checkers

BFS: Find shortest solution
     Puzzle games
```

---

## 🎓 Key Takeaways

1. **BFS**: Level-order, shortest path, queue-based
2. **DFS**: Go deep, cycle detection, stack/recursion-based
3. **Both**: O(V+E) time complexity
4. **Choice**: Depends on problem (shortest path vs cycle detection)
5. **Applications**: Vast range from networking to AI
6. **Variants**: 0-1 BFS, bidirectional, multi-source
7. **Understanding**: Master both for graph problems

---

## 💡 Interview Tips

1. **Clarify graph type**: Directed? Weighted? Connected?
2. **Choose appropriate traversal**: BFS for shortest path, DFS for cycles
3. **Handle disconnected graphs**: Loop through all vertices
4. **Visited tracking**: Essential to avoid infinite loops
5. **Path reconstruction**: Use parent pointers with BFS
6. **Recursion limit**: Be aware for very deep DFS
7. **Practice both**: Recursive and iterative implementations

---

## 🔗 Related Topics

- [Graph Representations](./19_GRAPH_BASICS.md)
- [Shortest Path Algorithms](./21_SHORTEST_PATHS.md)
- [Advanced Graph Algorithms](./22_ADVANCED_GRAPHS.md)
- [Tree Traversals](./15_TREE_TRAVERSALS.md)

---

**Next**: [Shortest Path Algorithms](./21_SHORTEST_PATHS.md)
