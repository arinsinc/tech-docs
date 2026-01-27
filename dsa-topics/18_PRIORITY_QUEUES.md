# Priority Queue Applications

## 📋 Overview

A **Priority Queue** is an abstract data type where each element has a priority, and elements are served based on priority rather than insertion order. Heaps are the most common implementation, providing efficient O(log n) operations. Priority queues solve numerous real-world problems in scheduling, pathfinding, and optimization.

**Difficulty Level**: 🟡 Intermediate to 🔴 Advanced

---

## 🎯 Core Concepts

### Priority Queue Properties

**Key Characteristics**:
- Elements are ordered by priority, not insertion order
- Highest (or lowest) priority element is always at front
- Efficient insertion and removal based on priority

**Visual Comparison**:

```
Regular Queue (FIFO):
Enqueue: [5] → [5, 3] → [5, 3, 8] → [5, 3, 8, 1]
Dequeue: 5 → 3 → 8 → 1
(First In, First Out)

Priority Queue (by value):
Enqueue: [5] → [3, 5] → [3, 5, 8] → [1, 3, 5, 8]
Dequeue: 1 → 3 → 5 → 8
(Lowest priority first)
```

### Min Priority Queue vs Max Priority Queue

```
Min Priority Queue:        Max Priority Queue:
     1                          100
    / \                        /   \
   3   5                     50    75
  / \                       / \
 7   9                    20  30

Remove: 1 (smallest)       Remove: 100 (largest)
```

---

## 🔄 Common Priority Queue Operations

### 1. Task Scheduling

**Concept**: Execute tasks based on priority, not arrival time.

**Example**: Operating System CPU Scheduler

```
Tasks arrive:
Task A: Priority 3, Duration 5ms
Task B: Priority 1, Duration 3ms
Task C: Priority 2, Duration 4ms
Task D: Priority 1, Duration 2ms

Max Priority Queue (higher number = higher priority):
     3                    3                    2
    / \                  /                    / \
   1   2      →        2       →            1   1
  /                   / \                   /
 1                   1   1                 1

Execution Order:
A (p=3) → C (p=2) → B (p=1) → D (p=1)

Timeline:
0ms    5ms       9ms      12ms     14ms
|---A---|---C---|---B---|---D---|
```

**Dynamic Priority Example**:

```
Real-time system with aging:
Initial:
Task X: Priority 5, Wait time 0
Task Y: Priority 3, Wait time 10
Task Z: Priority 7, Wait time 5

After aging (priority += wait_time/10):
Task X: Priority 5 + 0 = 5
Task Y: Priority 3 + 1 = 4
Task Z: Priority 7 + 0.5 = 7.5

Queue updates dynamically!
```

---

### 2. Top K Problems

#### Top K Frequent Elements

**Problem**: Find K most frequent elements.

**Example**: Array = [1,1,1,2,2,3], K = 2

```
Step 1: Count frequencies
{1: 3, 2: 2, 3: 1}

Step 2: Use min heap of size K
Add (freq, value) pairs:

Add (3, 1):
Heap: [(3, 1)]

Add (2, 2):
Heap: [(2, 2), (3, 1)]
        2
        |
        3

Add (1, 3):
1 < 2 (heap min), ignore

Result: Elements with freq ≥ 2
Top K frequent: [1, 2]
```

**Detailed Process**:

```
Initial Heap (size K=2):
[(3,1), (2,2)]

Min heap property: smallest frequency at root

When seeing (1,3):
1 < 2 (root frequency)
→ This element is less frequent than all in heap
→ Not in top K, ignore

Final: [1, 2] with frequencies [3, 2]
```

#### Top K Largest Elements

**Example**: Find 3 largest in [4, 7, 1, 9, 3, 6, 8, 2]

```
Use min heap of size 3:

Process:
[4] → [4,7] → [4,7,1] → [4,7,9] → [7,9,8] → [7,9,8]
                 ↓         ↓         ↓
              Remove 1   Remove 4   Remove 7

Final min heap:
        7
       / \
      8   9

Top 3 largest: [7, 8, 9]
```

---

### 3. Merge K Sorted Lists/Arrays

**Problem**: Efficiently merge K sorted sequences.

**Example**: Merge 3 sorted arrays

```
Array 1: [1, 4, 7]
Array 2: [2, 5, 8]
Array 3: [3, 6, 9]

Min heap tracks smallest element from each array:

Initial state:
Heap: [(1,arr1,idx0), (2,arr2,idx0), (3,arr3,idx0)]
         (1,1,0)
         /     \
    (2,2,0)   (3,3,0)

Step 1: Extract (1,1,0)
Result: [1]
Add next from arr1: (4,1,1)
Heap: [(2,2,0), (3,3,0), (4,1,1)]

Step 2: Extract (2,2,0)
Result: [1, 2]
Add next from arr2: (5,2,1)
Heap: [(3,3,0), (4,1,1), (5,2,1)]

Step 3: Extract (3,3,0)
Result: [1, 2, 3]
Add next from arr3: (6,3,1)
Heap: [(4,1,1), (5,2,1), (6,3,1)]

Continue until all exhausted...
Final: [1, 2, 3, 4, 5, 6, 7, 8, 9]
```

**Heap State Visualization**:

```
At each step:
- Extract minimum element
- Add next element from same array
- Maintain heap size = K (number of arrays)

Time: O(N log K) where N = total elements, K = arrays
Space: O(K) for heap
```

---

### 4. K Closest Points to Origin

**Problem**: Find K points closest to (0, 0).

**Example**: Points = [(1,3), (-2,2), (5,8), (0,1)], K = 2

```
Calculate distances:
(1,3):   √(1²+3²) = √10 ≈ 3.16
(-2,2):  √(4+4) = √8 ≈ 2.83
(5,8):   √(25+64) = √89 ≈ 9.43
(0,1):   √(0+1) = 1

Use max heap of size K (track K smallest distances):

Add (√10, (1,3)):
Heap: [(3.16, (1,3))]

Add (√8, (-2,2)):
Heap: [(3.16,(1,3)), (2.83,(-2,2))]
        3.16
         |
        2.83

Add (√89, (5,8)):
9.43 > 3.16, ignore (farther than K closest)

Add (1, (0,1)):
1 < 3.16, replace
Heap: [(2.83,(-2,2)), (1,(0,1))]

Result: [(-2,2), (0,1)]
```

**Why Max Heap?**

```
Keep K smallest distances
Max heap root = largest of K smallest
Easy to check if new point is closer:
  if new_distance < root_distance:
    replace root
```

---

### 5. Meeting Rooms II

**Problem**: Minimum meeting rooms needed for overlapping meetings.

**Example**: Meetings = [[0,30], [5,10], [15,20]]

```
Events:
Start: 0, 5, 15
End:   10, 20, 30

Min heap tracks ending times of ongoing meetings:

Timeline visualization:
0        5   10   15   20        30
|--------|---|-----|-----|--------|
Meeting 1: [=============================]
Meeting 2:     [====]
Meeting 3:             [====]

At time 0:
Start meeting 1
Heap: [30]
Rooms: 1

At time 5:
Meeting 1 still ongoing (30 > 5)
Start meeting 2
Heap: [10, 30]
        10
        |
       30
Rooms: 2 (max so far)

At time 10:
Meeting 2 ends
Remove from heap
Heap: [30]
Rooms: 1

At time 15:
Meeting 1 still ongoing (30 > 15)
Start meeting 3
Heap: [20, 30]
Rooms: 2

At time 20:
Meeting 3 ends
Heap: [30]

At time 30:
Meeting 1 ends
Heap: []

Maximum rooms needed: 2
```

**Process**:

```
Sort meetings by start time
Use min heap for end times

For each meeting:
  Remove all meetings that ended before current start
  Add current meeting's end time to heap
  Track maximum heap size = max rooms needed
```

---

### 6. Find Median from Data Stream

**Concept**: Two heaps maintain running median efficiently.

**Structure**:
- **Max heap**: Stores smaller half of numbers
- **Min heap**: Stores larger half of numbers

**Example**: Stream = [5, 15, 1, 3, 8]

```
Add 5:
Max heap (smaller): [5]
Min heap (larger):  []
Median: 5

Add 15:
Max heap: [5]
Min heap: [15]
         5  |  15
Median: (5+15)/2 = 10

Add 1:
Initially: Max[5,1], Min[15]
Rebalance: Max[1], Min[5,15]
         1  |  5, 15
Median: 5 (middle element)

Add 3:
Max[3,1], Min[5,15]
         1, 3  |  5, 15
Median: (3+5)/2 = 4

Add 8:
Max[3,1], Min[5,8,15]
Rebalance: Max[3,1,5], Min[8,15]
         1, 3, 5  |  8, 15
Median: 5
```

**Detailed Heap Structures**:

```
After adding 8 and rebalancing:

Max Heap (smaller half):     Min Heap (larger half):
        5                            8
       / \                          /
      3   1                       15

Size: 3                        Size: 2

Median = max heap root = 5

Invariants:
1. |maxHeap.size - minHeap.size| ≤ 1
2. maxHeap.top() ≤ minHeap.top()
3. If odd count: median = larger heap's root
   If even count: median = (maxHeap.top + minHeap.top) / 2
```

---

### 7. Sliding Window Maximum

**Problem**: Maximum in each window of size K.

**Example**: Array = [1,3,-1,-3,5,3,6,7], K = 3

```
Windows:
[1  3  -1] -3  5  3  6  7  → max = 3
 1 [3  -1  -3] 5  3  6  7  → max = 3
 1  3 [-1  -3  5] 3  6  7  → max = 5
 1  3  -1 [-3  5  3] 6  7  → max = 5
 1  3  -1  -3 [5  3  6] 7  → max = 6
 1  3  -1  -3  5 [3  6  7] → max = 7

Result: [3, 3, 5, 5, 6, 7]
```

**Using Priority Queue**:

```
Priority Queue stores (value, index) pairs
Max heap by value

Window [1, 3, -1]:
Heap: [(3,1), (1,0), (-1,2)]
Max = 3

Slide to [3, -1, -3]:
Heap: [(3,1), (1,0), (-1,2), (-3,3)]
Remove elements outside window (index < 1)
Remove (1,0)
Max = 3

Continue...

Note: More efficient with deque (monotonic queue)
but priority queue works!
```

---

### 8. Course Schedule with Prerequisites

**Problem**: Order courses considering prerequisites and priorities.

**Example**:

```
Courses:
A: Priority 10, No prerequisites
B: Priority 8,  Requires [A]
C: Priority 9,  No prerequisites
D: Priority 7,  Requires [A, C]

Step 1: Start with courses with no prerequisites
Priority Queue: [(10,A), (9,C)]

Step 2: Take A (highest priority)
Schedule: [A]
Unlock: B
Priority Queue: [(9,C), (8,B)]

Step 3: Take C
Schedule: [A, C]
Unlock: D (A and C both complete)
Priority Queue: [(8,B), (7,D)]

Step 4: Take B
Schedule: [A, C, B]
Priority Queue: [(7,D)]

Step 5: Take D
Schedule: [A, C, B, D]

Final order: [A, C, B, D]
```

---

## 🎯 Advanced Applications

### 1. Dijkstra's Shortest Path

**Concept**: Use min priority queue to explore shortest paths first.

**Example**: Find shortest path from A

```
Graph:
   A --2-- B
   |       |
   4       1
   |       |
   C --3-- D

Priority Queue processes (distance, node):

Initial:
Queue: [(0, A)]
Distances: {A: 0, B: ∞, C: ∞, D: ∞}

Step 1: Process A (distance 0)
Update neighbors:
  B: 0 + 2 = 2
  C: 0 + 4 = 4
Queue: [(2,B), (4,C)]
Distances: {A: 0, B: 2, C: 4, D: ∞}

Step 2: Process B (distance 2)
Update neighbors:
  D: 2 + 1 = 3
Queue: [(3,D), (4,C)]
Distances: {A: 0, B: 2, C: 4, D: 3}

Step 3: Process D (distance 3)
Update neighbors:
  C: 3 + 3 = 6 (worse than 4, skip)
Queue: [(4,C)]

Step 4: Process C (distance 4)
Done!

Shortest paths from A:
A→A: 0
A→B: 2
A→C: 4
A→D: 3
```

---

### 2. Huffman Coding

**Concept**: Build optimal prefix-free code tree using priority queue.

**Example**: Characters with frequencies

```
char: a  b  c  d  e
freq: 5  9 12 13 16

Priority Queue (min heap by frequency):

Initial: [(5,a), (9,b), (12,c), (13,d), (16,e)]

Step 1: Merge two smallest (a, b)
Create internal node: (14, ab)
Queue: [(12,c), (13,d), (14,ab), (16,e)]

Step 2: Merge (c, d)
Create: (25, cd)
Queue: [(14,ab), (16,e), (25,cd)]

Step 3: Merge (ab, e)
Create: (30, abe)
Queue: [(25,cd), (30,abe)]

Step 4: Merge (cd, abe)
Create: (55, root)

Final Tree:
           (55)
          /    \
      (25)      (30)
      /  \      /   \
   (12) (13) (14)  (16)
    c    d   /  \    e
           (5) (9)
            a   b

Codes:
c: 00
d: 01
a: 100
b: 101
e: 11
```

**Why Priority Queue?**
- Always merge two smallest frequency nodes
- Minimizes total encoding length
- Optimal compression

---

### 3. Network Packet Scheduling

**Real-world Example**: Router packet prioritization

```
Incoming packets:
Packet 1: Video stream, Priority 10, Size 1500 bytes
Packet 2: Email, Priority 3, Size 500 bytes
Packet 3: Voice call, Priority 15, Size 200 bytes
Packet 4: File download, Priority 5, Size 5000 bytes

Max Priority Queue:

Queue state:
        15(P3)
        /    \
    10(P1)   5(P4)
      |
    3(P2)

Transmission order:
1. P3 (Voice - highest priority, 200 bytes)
2. P1 (Video - 1500 bytes)
3. P4 (File - 5000 bytes)
4. P2 (Email - 500 bytes)

Ensures real-time traffic goes first!
```

---

### 4. Load Balancing

**Concept**: Assign tasks to server with least load.

```
Servers: S1, S2, S3
Initial load: 0, 0, 0

Min heap by current load:
[(0,S1), (0,S2), (0,S3)]

Task 1: Duration 5
Assign to S1 (minimum load)
Heap: [(0,S2), (0,S3), (5,S1)]

Task 2: Duration 3
Assign to S2
Heap: [(0,S3), (3,S2), (5,S1)]

Task 3: Duration 7
Assign to S3
Heap: [(3,S2), (5,S1), (7,S3)]

Task 4: Duration 2
Assign to S2 (load 3)
Heap: [(5,S1), (5,S2), (7,S3)]

Final loads: S1=5, S2=5, S3=7
Most balanced distribution!
```

---

## 📊 Performance Comparison

### Priority Queue Implementations

| Implementation | Insert | Extract | Peek | Search |
|----------------|--------|---------|------|--------|
| Binary Heap | O(log n) | O(log n) | O(1) | O(n) |
| Fibonacci Heap | O(1) | O(log n) | O(1) | O(n) |
| Binary Search Tree | O(log n)* | O(log n)* | O(log n)* | O(log n)* |
| Unsorted Array | O(1) | O(n) | O(n) | O(n) |
| Sorted Array | O(n) | O(1) | O(1) | O(log n) |

(*assuming balanced tree)

**Best Choice**: Binary heap for most applications

---

## 🎓 Key Takeaways

1. **Priority over Order**: Elements served by priority, not insertion sequence
2. **Heap Implementation**: Most efficient for priority queues
3. **Top K Pattern**: Use heap of size K (min heap for K largest, max heap for K smallest)
4. **Two Heap Pattern**: Solves median and percentile problems
5. **Greedy Algorithms**: Many greedy solutions use priority queues
6. **Graph Algorithms**: Essential for Dijkstra, Prim's, A*
7. **Real-time Systems**: Critical for scheduling and resource allocation

---

## 💡 Interview Tips

1. **Clarify priority definition**: Higher value = higher priority?
2. **Choose correct heap type**: Min or max based on problem
3. **Consider stability**: Multiple elements with same priority?
4. **Discuss alternatives**: When is priority queue overkill?
5. **Time-space tradeoffs**: Heap vs sorted array vs BST
6. **Custom comparators**: How to handle complex priority rules?
7. **Real-world context**: Relate to practical applications

---

## 🧩 Common Problem Patterns

### Pattern 1: Top K Elements
- Use heap of size K
- Min heap for K largest, max heap for K smallest

### Pattern 2: Merge Sorted Sequences
- Min heap tracks current element from each sequence
- Extract min, add next from same sequence

### Pattern 3: Running Statistics
- Two heap approach for median
- Heap + sorted structure for percentiles

### Pattern 4: Scheduling
- Priority queue orders tasks/events
- Remove/update based on time or completion

### Pattern 5: Optimization Problems
- Greedy selection using priority queue
- Huffman coding, MST, shortest paths

---

## 🔗 Related Topics

- [Heap Data Structure](./17_HEAPS.md)
- [Graph Algorithms](./21_SHORTEST_PATHS.md)
- [Greedy Algorithms](./28_GREEDY_ALGORITHMS.md)
- [Binary Trees](./13_BINARY_TREES.md)

---

**Next**: [Graph Representations](./19_GRAPH_BASICS.md)
