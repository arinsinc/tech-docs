# Queue Operations & Variants

## 📋 Overview

A **Queue** is a linear data structure that follows the **FIFO (First In, First Out)** principle. Think of it like a line at a ticket counter - the first person to arrive is the first to be served. Elements are added at one end (rear/back) and removed from the other end (front).

---

## 🎯 Core Concepts

### What is a Queue?

A queue is a collection where:
- Elements are added at the **rear/back** (enqueue)
- Elements are removed from the **front** (dequeue)
- **FIFO order**: First element added is the first to be removed
- Both ends are accessible, but for different operations

**Visual Representation:**
```
Queue structure:

Front                                          Rear
  ↓                                             ↓
┌────┬────┬────┬────┬────┐
│ 1  │ 3  │ 7  │ 5  │ 9  │
└────┴────┴────┴────┴────┘
  ↑                       ↑
Remove                 Add here
from here             (Enqueue)
(Dequeue)

First person in line → First person served
```

**Real-World Analogy:**
```
Ticket Counter Queue:

People waiting:
Alice → Bob → Carol → David
  ↑                      ↑
First                  Last
(served first)      (served last)

New person Eve joins:
Alice → Bob → Carol → David → Eve

Alice gets served (leaves):
Bob → Carol → David → Eve
 ↑
Now first
```

---

## 🔧 Core Operations

### 1. Enqueue (Insert at Rear)

Add an element to the back of the queue.

**Visual Process:**
```
Initial Queue:
Front                    Rear
  ↓                       ↓
┌────┬────┬────┐
│ 1  │ 3  │ 5  │
└────┴────┴────┘

Enqueue(7):
Front                         Rear
  ↓                            ↓
┌────┬────┬────┬────┐
│ 1  │ 3  │ 5  │ 7  │
└────┴────┴────┴────┘

Time Complexity: O(1) - constant time
```

---

### 2. Dequeue (Remove from Front)

Remove and return the element at the front.

**Visual Process:**
```
Initial Queue:
Front                         Rear
  ↓                            ↓
┌────┬────┬────┬────┐
│ 1  │ 3  │ 5  │ 7  │
└────┴────┴────┴────┘

Dequeue() → returns 1:
     Front              Rear
       ↓                 ↓
     ┌────┬────┬────┐
     │ 3  │ 5  │ 7  │
     └────┴────┴────┘

Time Complexity: O(1) - constant time
```

---

### 3. Peek / Front

View the front element without removing it.

**Visual Process:**
```
Queue:
Front                    Rear
  ↓                       ↓
┌────┬────┬────┬────┐
│ 3  │ 5  │ 7  │ 9  │
└────┴────┴────┴────┘

Peek() → returns 3 (doesn't remove)

Queue unchanged
Time Complexity: O(1) - constant time
```

---

### 4. IsEmpty

Check if queue has no elements.

**Visual Process:**
```
Non-Empty Queue:        Empty Queue:
Front         Rear      Front/Rear
  ↓            ↓            ↓
┌────┬────┐              ┌──┐
│ 3  │ 5  │              │  │
└────┴────┘              └──┘

IsEmpty() → false       IsEmpty() → true
```

---

### 5. Size

Return the number of elements in the queue.

**Visual Process:**
```
Queue:
Front                         Rear
  ↓                            ↓
┌────┬────┬────┬────┬────┐
│ 1  │ 3  │ 5  │ 7  │ 9  │
└────┴────┴────┴────┴────┘
  1    2    3    4    5

Size() → 5
```

---

## 🏗️ Implementation Approaches

### 1. Array-Based Queue (Simple)

```
Fixed-size array with front and rear pointers:

Initial (empty):
Front/Rear = -1
┌───┬───┬───┬───┬───┐
│   │   │   │   │   │
└───┴───┴───┴───┴───┘
  0   1   2   3   4

After Enqueue(1,3,5):
Front=0, Rear=2
┌───┬───┬───┬───┬───┐
│ 1 │ 3 │ 5 │   │   │
└───┴───┴───┴───┴───┘
  ↑       ↑
Front   Rear

Problem: Wasted space after dequeues
After Dequeue() twice:
Front=2, Rear=2
┌───┬───┬───┬───┬───┐
│ X │ X │ 5 │   │   │
└───┴───┴───┴───┴───┘
          ↑
      Front/Rear
      
Space at front is wasted!
```

---

### 2. Circular Queue (Array-Based)

**Solves the wasted space problem:**

```
Circular array (capacity = 5):

Enqueue(1,3,5,7):
Front=0, Rear=3, Size=4
┌───┬───┬───┬───┬───┐
│ 1 │ 3 │ 5 │ 7 │   │
└───┴───┴───┴───┴───┘
  ↑           ↑
Front       Rear

Dequeue() twice:
Front=2, Rear=3, Size=2
┌───┬───┬───┬───┬───┐
│   │   │ 5 │ 7 │   │
└───┴───┴───┴───┴───┘
          ↑   ↑
        Front Rear

Enqueue(9,2,4):
Front=2, Rear=0, Size=5
┌───┬───┬───┬───┬───┐
│ 4 │   │ 5 │ 7 │ 9 │
└───┴───┴───┴───┴───┘
  ↑   ↑   ↑
Rear    Front
(wrapped around!)

Circular visualization:
        0
    ┌───────┐
  4 │   4   │
    ├───────┤
1   │       │ 3
    │   5   │
  2 ├───────┤ 4
    │   7   │
    ├───────┤
    │   9   │
    └───────┘
    
Rear wraps to position 0
```

**Key formulas:**
```
Enqueue: rear = (rear + 1) % capacity
Dequeue: front = (front + 1) % capacity
IsFull: (rear + 1) % capacity == front
```

---

### 3. Linked List-Based Queue

```
Dynamic size using linked list:

Front                           Rear
  ↓                              ↓
[1] → [3] → [5] → [7] → NULL

Enqueue(9): Add at rear
Front                                  Rear
  ↓                                     ↓
[1] → [3] → [5] → [7] → [9] → NULL

Dequeue(): Remove from front
      Front                            Rear
        ↓                               ↓
      [3] → [5] → [7] → [9] → NULL

Pros: No size limit, no wasted space
Cons: Extra memory for pointers
```

---

## 🔄 Queue Variants

### 1. Deque (Double-Ended Queue)

Can add/remove from **both ends**.

**Structure:**
```
Deque:
Front                              Rear
  ↓                                 ↓
┌────┬────┬────┬────┬────┐
│ 1  │ 3  │ 5  │ 7  │ 9  │
└────┴────┴────┴────┴────┘
  ↕                       ↕
Add/Remove           Add/Remove
from front           from rear

Operations:
- addFront() / removeFront()
- addRear() / removeRear()

All operations O(1)
```

**Use Cases:**
- Palindrome checking
- Sliding window problems
- Maintaining order with both-end access

---

### 2. Priority Queue

Elements have **priority**; highest priority dequeued first.

**Visualization:**
```
Regular Queue (FIFO):
Front                    Rear
  ↓                       ↓
┌────┬────┬────┬────┐
│ 5  │ 3  │ 8  │ 1  │  → Dequeue 5 (first in)
└────┴────┴────┴────┘

Priority Queue (ordered by priority):
Highest                 Lowest
Priority               Priority
  ↓                       ↓
┌────┬────┬────┬────┐
│ 8  │ 5  │ 3  │ 1  │  → Dequeue 8 (highest priority)
└────┴────┴────┴────┘

Enqueue automatically orders by priority
```

**Implementation:**
```
Using Heap (most efficient):

       9
      / \
     7   8
    / \
   3   5

Dequeue → Remove 9 (root, highest priority)
Enqueue → Add and heapify to maintain order

Time: O(log n) for enqueue/dequeue
```

---

### 3. Circular Queue

**Already covered above** - efficient use of array space by wrapping around.

---

### 4. Blocking Queue

Queue with **capacity limits** and **blocking behavior**.

**Concept:**
```
Queue capacity = 3

Current state (full):
┌────┬────┬────┐
│ 5  │ 7  │ 9  │  ← Full
└────┴────┴────┘

Thread tries to enqueue:
→ Blocks until space available

Thread dequeues:
┌────┬────┐
│ 7  │ 9  │  ← Space available
└────┴────┘

Blocked thread now proceeds

Used in: Producer-Consumer problems
```

---

## 🎯 Common Use Cases & Problems

### 1. Breadth-First Search (BFS)

**Level-by-level tree/graph traversal:**

```
Tree:
       1
      / \
     2   3
    / \   \
   4   5   6

BFS traversal using queue:

Start: Enqueue root
Queue: [1]

Step 1: Dequeue 1, enqueue children
Process: 1
Queue: [2, 3]

Step 2: Dequeue 2, enqueue children
Process: 2
Queue: [3, 4, 5]

Step 3: Dequeue 3, enqueue children
Process: 3
Queue: [4, 5, 6]

Step 4: Dequeue 4 (no children)
Process: 4
Queue: [5, 6]

Step 5: Dequeue 5 (no children)
Process: 5
Queue: [6]

Step 6: Dequeue 6 (no children)
Process: 6
Queue: []

BFS order: 1, 2, 3, 4, 5, 6 (level by level)
```

---

### 2. Task Scheduling

**Process tasks in order received:**

```
Task Queue:
Front                              Rear
  ↓                                 ↓
┌─────┬─────┬─────┬─────┐
│Task1│Task2│Task3│Task4│
└─────┴─────┴─────┴─────┘

CPU processes:
1. Dequeue Task1 → Execute
2. Dequeue Task2 → Execute
3. New Task5 arrives → Enqueue
4. Dequeue Task3 → Execute
...

Fair scheduling: First come, first served
```

---

### 3. Buffer Management

**Data stream buffering:**

```
Input Stream: [A, B, C, D, E, F, ...]
              ↓
           Buffer Queue
           (capacity = 3)

Producer adds:
┌───┬───┬───┐
│ A │ B │ C │  ← Buffer full, producer waits
└───┴───┴───┘

Consumer reads: Dequeue A
┌───┬───┐
│ B │ C │      ← Space available
└───┴───┘

Producer adds: Enqueue D
┌───┬───┬───┐
│ B │ C │ D │
└───┴───┴───┘

Smooth data flow between producer and consumer
```

---

### 4. Request Handling

**Web server request queue:**

```
Incoming Requests:
Req1 → Req2 → Req3 → Req4 → Req5

Server Request Queue:
Front                    Rear
  ↓                       ↓
┌─────┬─────┬─────┬─────┐
│Req1 │Req2 │Req3 │Req4 │
└─────┴─────┴─────┴─────┘

Worker threads dequeue and process:

Thread 1: Dequeue Req1
Thread 2: Dequeue Req2
Thread 3: Dequeue Req3

New Req5 arrives: Enqueue at rear

Fair request handling (FIFO)
```

---

### 5. Printer Spooler

**Print job management:**

```
Print Jobs Queue:
Front                         Rear
  ↓                            ↓
┌──────┬──────┬──────┬──────┐
│ Job1 │ Job2 │ Job3 │ Job4 │
└──────┴──────┴──────┴──────┘

Printer processes:
1. Dequeue Job1 → Print
2. While printing, Job5 arrives → Enqueue
3. Job1 complete, Dequeue Job2 → Print
...

Jobs printed in order submitted
```

---

### 6. Cache Implementation (LRU with Queue)

**Least Recently Used Cache:**

```
Cache as Queue + HashMap:

Access pattern: A, B, C, D, A

After A:
Queue: [A]
HashMap: {A: node}

After B:
Queue: [A, B]

After C:
Queue: [A, B, C]

After D (cache full, capacity=3):
Remove LRU (A):
Queue: [B, C, D]

Access A again (cache miss):
Remove LRU (B), Add A:
Queue: [C, D, A]

Most recent at rear, LRU at front
```

---

### 7. Generate Numbers with Given Digits

**Generate numbers using only digits 1 and 2:**

```
Generate first 10 numbers using only 1 and 2:

Process:
Start: Enqueue "1", "2"
Queue: ["1", "2"]

Iteration 1: Dequeue "1"
Output: 1
Generate: "1"+"1"="11", "1"+"2"="12"
Queue: ["2", "11", "12"]

Iteration 2: Dequeue "2"
Output: 2
Generate: "2"+"1"="21", "2"+"2"="22"
Queue: ["11", "12", "21", "22"]

Iteration 3: Dequeue "11"
Output: 11
Generate: "111", "112"
Queue: ["12", "21", "22", "111", "112"]

Continue...

Output: 1, 2, 11, 12, 21, 22, 111, 112, 121, 122
```

---

### 8. Sliding Window Maximum

**Using deque to find max in each window:**

```
Array: [1, 3, -1, -3, 5, 3, 6, 7]
Window size: k = 3

Window: [1, 3, -1] → Max = 3
        ↓
Deque stores indices of potential maxes:
[1] (index of 3)

Window: [3, -1, -3] → Max = 3
Deque: [1] (3 still in window)

Window: [-1, -3, 5] → Max = 5
Deque: [4] (index of 5, removed smaller values)

Deque maintains decreasing order
Front has index of maximum in current window
```

---

## 🌍 Real-World Applications

### 1. Operating System - Process Scheduling

```
CPU Scheduler (Round Robin):

Ready Queue:
Front                         Rear
  ↓                            ↓
┌───┬───┬───┬───┐
│P1 │P2 │P3 │P4 │
└───┴───┴───┴───┘

CPU time slice = 10ms

Process P1 runs 10ms:
- If incomplete → Enqueue at rear
- If complete → Remove

Fair CPU time distribution
```

---

### 2. Network Packet Routing

```
Router Packet Queue:

Incoming Packets:
Front                              Rear
  ↓                                 ↓
┌────┬────┬────┬────┬────┐
│Pkt1│Pkt2│Pkt3│Pkt4│Pkt5│
└────┴────┴────┴────┴────┘

Router forwards:
1. Dequeue Pkt1 → Forward to destination
2. Dequeue Pkt2 → Forward
...

FIFO ensures fair packet delivery
```

---

### 3. Call Center - Customer Service

```
Call Queue:

Waiting Customers:
Front                         Rear
  ↓                            ↓
┌────┬────┬────┬────┐
│C1  │C2  │C3  │C4  │
└────┴────┴────┴────┘

Agent becomes available:
→ Dequeue C1 (first in line)
→ Serve customer

New customer C5 calls:
→ Enqueue at rear

Fair service order
```

---

### 4. Messaging Systems

```
Message Queue (RabbitMQ, Kafka):

Producer                Queue                   Consumer
   ↓                      ↓                        ↓
[Msg1] ──→  ┌────┬────┬────┬────┐  ──→  [Process]
[Msg2] ──→  │Msg1│Msg2│Msg3│Msg4│  ──→  [Process]
[Msg3] ──→  └────┴────┴────┴────┘  ──→  [Process]

Decouples producer and consumer
Reliable message delivery (FIFO)
```

---

## ⚡ Performance Characteristics

### Time Complexity Comparison

```
┌──────────────┬─────────┬──────────┬────────────┐
│  Operation   │  Array  │ Circular │  Linked    │
├──────────────┼─────────┼──────────┼────────────┤
│   Enqueue    │  O(1)   │   O(1)   │    O(1)    │
│   Dequeue    │  O(n)*  │   O(1)   │    O(1)    │
│    Peek      │  O(1)   │   O(1)   │    O(1)    │
│   IsEmpty    │  O(1)   │   O(1)   │    O(1)    │
│    Size      │  O(1)   │   O(1)   │    O(1)    │
└──────────────┴─────────┴──────────┴────────────┘

* O(n) if shifting elements; O(1) with proper pointers
```

### Space Complexity

```
Array-based:
- Space: O(n) where n = capacity
- May have wasted space

Linked List:
- Space: O(n) where n = number of elements
- Extra space for pointers
- No wasted space
```

---

## 💡 Interview Insights

### Queue vs Stack

```
┌──────────────────┬──────────┬──────────┐
│   Characteristic │  Stack   │  Queue   │
├──────────────────┼──────────┼──────────┤
│      Order       │   LIFO   │   FIFO   │
│  Add operation   │   Push   │ Enqueue  │
│ Remove operation │   Pop    │ Dequeue  │
│    Use cases     │Undo/Back │ BFS/Task │
│                  │tracking  │scheduling│
└──────────────────┴──────────┴──────────┘

Visual:
Stack: ↓→[Top]→↓          Queue: →[Front]...[Rear]→
       Same end                  Different ends
```

---

### When to Use Queue

**Use Queue When:**
- ✅ Need FIFO processing
- ✅ Level-order traversal
- ✅ Task scheduling
- ✅ Buffer management
- ✅ Request handling

**Common Patterns:**
1. **BFS pattern** - Level-by-level exploration
2. **Processing tasks** - Fair ordering
3. **Buffering** - Smooth data flow
4. **Generation** - Build sequences

---

### Edge Cases to Consider

```
1. Empty queue
Front/Rear = -1
Dequeue → Error handling

2. Single element
Front = Rear
Careful with pointer updates

3. Full queue (circular)
(rear + 1) % capacity == front
Handle overflow

4. Wrap-around (circular)
Rear wraps to beginning
Use modulo arithmetic
```

---

## 🎯 Summary

Queues are **essential** for fair ordering and level-wise processing:

**Key Characteristics:**
- 📥 FIFO (First In, First Out)
- ⚡ O(1) for enqueue and dequeue
- 🎯 Fair processing order
- 🔄 Multiple variants for different needs

**Best Used For:**
- ✅ BFS traversals
- ✅ Task scheduling
- ✅ Request handling
- ✅ Buffer management
- ✅ Level-order processing

**Key Variants:**
- **Deque** - Both-end access
- **Priority Queue** - Priority-based ordering
- **Circular Queue** - Efficient space usage
- **Blocking Queue** - Thread synchronization

**Remember:** When you need to process items in the order they arrive, or do level-by-level traversal, think **Queue**!

---

## 📚 Related Topics

- [Stack Operations & Applications](./10_STACKS.md) - LIFO counterpart
- [Monotonic Stack & Queue](./12_MONOTONIC_STRUCTURES.md) - Advanced patterns
- [Graph Traversals (BFS & DFS)](./20_GRAPH_TRAVERSALS.md) - BFS uses queues
- [Heap Data Structure](./17_HEAPS.md) - Priority queue implementation

