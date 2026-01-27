# Singly & Doubly Linked Lists

## 📋 Overview

A **Linked List** is a linear data structure where elements (nodes) are not stored in contiguous memory locations. Instead, each element contains a reference (link) to the next element in the sequence. Unlike arrays, linked lists allow efficient insertion and deletion at any position without shifting elements.

---

## 🎯 What is a Linked List?

### Structure

A linked list consists of **nodes** connected by **pointers/references**. Each node contains:
1. **Data**: The value stored in the node
2. **Pointer(s)**: Reference to the next (and possibly previous) node

**Visual Representation:**
```
Array (contiguous memory):
┌───┬───┬───┬───┬───┐
│ 5 │ 3 │ 8 │ 1 │ 9 │
└───┴───┴───┴───┴───┘
  0   1   2   3   4  ← indices

Linked List (scattered memory):
Head
 ↓
┌───┬───┐    ┌───┬───┐    ┌───┬───┐    ┌───┬───┐
│ 5 │ ●─┼───→│ 3 │ ●─┼───→│ 8 │ ●─┼───→│ 1 │ ✗ │
└───┴───┘    └───┴───┘    └───┴───┘    └───┴───┘
 Data Next    Data Next    Data Next    Data Next(null)
```

### Key Characteristics

**Advantages over Arrays:**
- ✅ Dynamic size (no fixed capacity)
- ✅ Efficient insertion/deletion at beginning
- ✅ No memory waste from unused capacity
- ✅ Easy to reorganize

**Disadvantages:**
- ❌ No random access (must traverse from head)
- ❌ Extra memory for storing pointers
- ❌ Not cache-friendly (nodes scattered in memory)
- ❌ Reverse traversal difficult (in singly linked lists)

---

## 🔗 Singly Linked List

### Structure

Each node has:
- **Data**: The stored value
- **Next**: Pointer to the next node

**Visual Example:**
```
NULL ← indicates end of list

Head
 ↓
┌──────┬──────┐     ┌──────┬──────┐     ┌──────┬──────┐
│  10  │  ●───┼────→│  20  │  ●───┼────→│  30  │ NULL │
└──────┴──────┘     └──────┴──────┘     └──────┴──────┘
 Node 1              Node 2              Node 3

Each node knows about the next node only
```

---

### Basic Operations

#### 1. Insertion at Beginning

**Process:**
```
Initial List:
Head → [20] → [30] → NULL

Insert 10 at beginning:

Step 1: Create new node
        ┌──────┬──────┐
        │  10  │  ?   │
        └──────┴──────┘

Step 2: Point new node to current head
        ┌──────┬──────┐
        │  10  │  ●───┼────→ [20] → [30] → NULL
        └──────┴──────┘

Step 3: Update head to new node
Head ──→ [10] → [20] → [30] → NULL

Time: O(1) - constant time!
```

---

#### 2. Insertion at End

**Process:**
```
Initial List:
Head → [10] → [20] → NULL

Insert 30 at end:

Step 1: Traverse to last node
Head → [10] → [20] → NULL
                ↑
              Last node

Step 2: Create new node and link
Head → [10] → [20] → [30] → NULL
                      ↑
                   New node

Time: O(n) - must traverse entire list
```

---

#### 3. Insertion at Position

**Process:**
```
Initial List:
Head → [10] → [30] → NULL

Insert 20 at position 1 (between 10 and 30):

Step 1: Traverse to position 0 (one before insertion)
Head → [10] → [30] → NULL
        ↑
   Stop here (position 0)

Step 2: Create new node
        ┌──────┬──────┐
        │  20  │  ?   │
        └──────┴──────┘

Step 3: Link new node
Head → [10] ┐
            ↓
         [20] → [30] → NULL

Final:
Head → [10] → [20] → [30] → NULL

Time: O(n) - traverse to position
```

---

#### 4. Deletion at Beginning

**Process:**
```
Initial List:
Head → [10] → [20] → [30] → NULL

Delete first node:

Step 1: Store reference to node to delete
Delete → [10] → [20] → [30] → NULL
  ↑       
Head ─────┘

Step 2: Move head to next node
         ┌───→ [20] → [30] → NULL
         │      ↑
Head ────┘    New head

Step 3: Old node [10] is now unreachable (garbage collected)

Time: O(1) - constant time!
```

---

#### 5. Deletion at End

**Process:**
```
Initial List:
Head → [10] → [20] → [30] → NULL

Delete last node:

Step 1: Traverse to second-to-last node
Head → [10] → [20] → [30] → NULL
               ↑
        Stop here (one before last)

Step 2: Set its next to NULL
Head → [10] → [20] → NULL

Step 3: Node [30] is now unreachable

Time: O(n) - must traverse to end
```

---

#### 6. Search

**Process:**
```
List: Head → [10] → [20] → [30] → [40] → NULL

Search for value 30:

Step 1: Start at head
        ↓
Head → [10] → [20] → [30] → [40] → NULL
        ✗ (10 ≠ 30, continue)

Step 2: Move to next
               ↓
Head → [10] → [20] → [30] → [40] → NULL
               ✗ (20 ≠ 30, continue)

Step 3: Move to next
                      ↓
Head → [10] → [20] → [30] → [40] → NULL
                      ✓ (30 == 30, found!)

Time: O(n) - worst case traverse entire list
```

---

## ↔️ Doubly Linked List

### Structure

Each node has:
- **Data**: The stored value
- **Next**: Pointer to the next node
- **Prev**: Pointer to the previous node

**Visual Example:**
```
Head                                                  Tail
 ↓                                                     ↓
┌─────┬─────┬─────┐   ┌─────┬─────┬─────┐   ┌─────┬─────┬─────┐
│NULL │ 10  │  ●──┼──→│  ●  │ 20  │  ●──┼──→│  ●  │ 30  │NULL │
└─────┴─────┴─────┘   └──┼──┴─────┴─────┘   └──┼──┴─────┴─────┘
                          │                       │
                          └───────────────────────┘
Prev   Data   Next     Backwards pointers for traversal

Can traverse in BOTH directions
```

### Advantages over Singly Linked List

✅ **Bidirectional traversal** - can move forward and backward
✅ **Easier deletion** - don't need to find previous node
✅ **Better for certain operations** - reverse iteration, delete from tail

**Disadvantages:**
❌ **More memory** - extra pointer per node
❌ **More complex** - must maintain two sets of pointers

---

### Basic Operations

#### 1. Insertion at Beginning

**Process:**
```
Initial List:
NULL ←─ [20] ←→ [30] ─→ NULL
Head ─→

Insert 10 at beginning:

Step 1: Create new node
    ┌─────┬─────┬─────┐
    │NULL │ 10  │  ?  │
    └─────┴─────┴─────┘

Step 2: Link new node to current head
    ┌─────┬─────┬─────┐
    │NULL │ 10  │  ●──┼───→ [20] ←→ [30] ─→ NULL
    └─────┴─────┴─────┘

Step 3: Update current head's prev to new node
         ┌──────────────┐
         ↓              │
    [10] ──→ [20] ←→ [30] ─→ NULL
    
Step 4: Update head pointer
Head → [10] ←→ [20] ←→ [30] → NULL

Time: O(1) - constant time!
```

---

#### 2. Insertion at End

**Process:**
```
Initial List with Tail pointer:
Head → [10] ←→ [20] ← Tail

Insert 30 at end:

Step 1: Create new node and link
Head → [10] ←→ [20] ←→ [30] ← Tail
                 ↑      ↑
                 └──────┘
            Link both directions

Step 2: Update tail pointer
Head → [10] ←→ [20] ←→ [30] ← Tail

Time: O(1) with tail pointer, O(n) without
```

---

#### 3. Deletion at Position

**Process:**
```
Initial List:
NULL ← [10] ←→ [20] ←→ [30] → NULL
        ↑
      Delete this node

Step 1: Identify node to delete
NULL ← [10] ←→ [20] ←→ [30] → NULL
        ↑
      Delete

Step 2: Update previous node's next
NULL ← [10] ───────→ [30] → NULL
       (skip over 20)

Step 3: Update next node's prev
NULL ← [10] ←─────── [30] → NULL

Final:
NULL ← [10] ←→ [30] → NULL

Time: O(1) if node is given, O(n) to find node
```

---

## 📊 Comparison: Singly vs Doubly Linked List

```
┌─────────────────────┬──────────────┬──────────────┐
│     Operation       │   Singly     │   Doubly     │
├─────────────────────┼──────────────┼──────────────┤
│ Insert at Head      │    O(1)      │    O(1)      │
│ Insert at Tail      │    O(n)      │  O(1)*       │
│ Delete at Head      │    O(1)      │    O(1)      │
│ Delete at Tail      │    O(n)      │  O(1)*       │
│ Search              │    O(n)      │    O(n)      │
│ Reverse Traversal   │    O(n)      │    O(n)      │
│ Memory per Node     │   Lower      │   Higher     │
│ Delete Given Node   │    O(n)      │    O(1)      │
└─────────────────────┴──────────────┴──────────────┘

* With tail pointer maintained
```

---

## 🎯 Common Linked List Problems

### 1. Reverse a Linked List

**Process Visualization:**
```
Original:
1 → 2 → 3 → 4 → NULL

Step-by-step reversal:

Initial: prev = NULL, curr = 1
         NULL  1 → 2 → 3 → 4 → NULL
         prev  curr

Step 1: Save next, reverse pointer, move forward
         NULL ← 1   2 → 3 → 4 → NULL
         prev  curr next

Step 2: Move pointers
         NULL ← 1   2 → 3 → 4 → NULL
                prev curr

Step 3: Continue...
         NULL ← 1 ← 2   3 → 4 → NULL
                    prev curr

Step 4: Continue...
         NULL ← 1 ← 2 ← 3   4 → NULL
                        prev curr

Step 5: Final step
         NULL ← 1 ← 2 ← 3 ← 4
                            prev/head

Result: 4 → 3 → 2 → 1 → NULL
```

---

### 2. Find Middle Element

**Two-Pointer Technique (Tortoise and Hare):**
```
List: 1 → 2 → 3 → 4 → 5 → NULL

Slow moves 1 step, Fast moves 2 steps:

Step 0: slow=1, fast=1
        ↓
        1 → 2 → 3 → 4 → 5 → NULL
        ↑
        ↑

Step 1: slow=2, fast=3
            ↓
        1 → 2 → 3 → 4 → 5 → NULL
                ↑
              fast

Step 2: slow=3, fast=5
                ↓
        1 → 2 → 3 → 4 → 5 → NULL
                        ↑
                      fast

Step 3: fast reaches end
        slow is at middle!
        
Middle element: 3
```

---

### 3. Detect Cycle

**Floyd's Cycle Detection (Tortoise and Hare):**
```
List with cycle:
        ┌─────────────────┐
        ↓                 │
1 → 2 → 3 → 4 → 5 → 6 ────┘

Visualization:

Step 1: slow=1, fast=2
        1 → 2 → 3 → 4 → 5 → 6 ──┐
        ↓   ↑                    │
            fast                 │
                                 └──→

Step 2: slow=2, fast=4
        1 → 2 → 3 → 4 → 5 → 6 ──┐
            ↓       ↑            │
                    fast         │
                                 └──→

Steps continue...

Eventually: slow and fast meet inside cycle
           Cycle detected! ✓

If fast reaches NULL → No cycle
```

---

### 4. Merge Two Sorted Lists

**Process:**
```
List 1: 1 → 3 → 5 → NULL
List 2: 2 → 4 → 6 → NULL

Merge process (compare and link):

Step 1: Compare 1 vs 2
        1 < 2 → take 1
        Result: 1 → ?

Step 2: Compare 3 vs 2
        2 < 3 → take 2
        Result: 1 → 2 → ?

Step 3: Compare 3 vs 4
        3 < 4 → take 3
        Result: 1 → 2 → 3 → ?

Step 4: Compare 5 vs 4
        4 < 5 → take 4
        Result: 1 → 2 → 3 → 4 → ?

Step 5: Compare 5 vs 6
        5 < 6 → take 5
        Result: 1 → 2 → 3 → 4 → 5 → ?

Step 6: Only 6 remains
        Result: 1 → 2 → 3 → 4 → 5 → 6 → NULL

Merged List: 1 → 2 → 3 → 4 → 5 → 6 → NULL
```

---

## 🌍 Real-World Applications

### 1. Browser History

```
Back/Forward navigation using doubly linked list:

Current Page
     ↓
NULL ← [Home] ←→ [Search] ←→ [Results] ←→ [Details] → NULL
                                          
Click Back:
NULL ← [Home] ←→ [Search] ←→ [Results] ←→ [Details] → NULL
                              ↑
                         Move here

Click Forward:
NULL ← [Home] ←→ [Search] ←→ [Results] ←→ [Details] → NULL
                                             ↑
                                        Move here
```

---

### 2. Music Playlist

```
Singly linked list for next song:

Now Playing
    ↓
[Song1] → [Song2] → [Song3] → [Song4] → NULL

Next button: Move to next node

Doubly linked list for prev/next:

NULL ← [Song1] ←→ [Song2] ←→ [Song3] ←→ [Song4] → NULL
                    ↑
              Now Playing
                    
Previous button: Move backwards
Next button: Move forwards
```

---

### 3. Undo/Redo Functionality

```
Document edit history (doubly linked list):

NULL ← [State1] ←→ [State2] ←→ [State3] ←→ [State4]
                                  ↑
                            Current state

Undo: Move backwards to State2
Redo: Move forward to State3
New edit: Add new node after current
```

---

### 4. Image Viewer

```
Image gallery navigation:

NULL ← [Img1] ←→ [Img2] ←→ [Img3] ←→ [Img4] → NULL
                   ↑
             Currently viewing

Previous/Next arrows traverse the list
```

---

### 5. Train/Subway Cars

```
Physical representation:

[Engine] ←→ [Car1] ←→ [Car2] ←→ [Car3] ←→ [Caboose]

Each car connected to prev and next
Can add/remove cars from middle of train
```

---

## ⚡ Performance Characteristics

### Time Complexity Comparison

```
┌──────────────────────┬─────────┬─────────────┐
│     Operation        │  Array  │ Linked List │
├──────────────────────┼─────────┼─────────────┤
│ Access by Index      │  O(1)   │    O(n)     │
│ Insert at Beginning  │  O(n)   │    O(1)     │
│ Insert at End        │  O(1)*  │    O(n)**   │
│ Insert at Middle     │  O(n)   │    O(n)     │
│ Delete at Beginning  │  O(n)   │    O(1)     │
│ Delete at End        │  O(1)*  │    O(n)**   │
│ Delete at Middle     │  O(n)   │    O(n)     │
│ Search               │  O(n)   │    O(n)     │
└──────────────────────┴─────────┴─────────────┘

*  With dynamic array
** O(1) with tail pointer maintained
```

### Space Complexity

```
Array:
┌───┬───┬───┬───┬───┐
│ 1 │ 2 │ 3 │ 4 │ 5 │
└───┴───┴───┴───┴───┘
Space: O(n) for data only

Singly Linked List:
[1|●]→[2|●]→[3|●]→[4|●]→[5|✗]
Space: O(n) for data + O(n) for pointers = O(2n) = O(n)

Doubly Linked List:
[✗|1|●]↔[●|2|●]↔[●|3|●]↔[●|4|●]↔[●|5|✗]
Space: O(n) for data + O(2n) for pointers = O(3n) = O(n)

All are O(n), but linked lists use more actual memory
```

---

## 💡 Interview Insights

### When to Use Linked Lists

**Use Linked Lists When:**
- ✅ Frequent insertions/deletions at beginning
- ✅ Size unknown or changes frequently
- ✅ No need for random access
- ✅ Implementing stacks, queues, graphs

**Use Arrays When:**
- ✅ Need random access by index
- ✅ Size is mostly fixed
- ✅ Cache locality important
- ✅ Memory efficiency critical

---

### Common Interview Patterns

**1. Two-Pointer Technique**
- Fast and slow pointers
- Finding middle, cycles
- Palindrome checking

**2. Reversal Operations**
- Reverse entire list
- Reverse segments
- Reverse in groups

**3. Merging and Sorting**
- Merge sorted lists
- Partition lists
- Sort linked lists

**4. Cycle Detection**
- Detect cycles
- Find cycle start
- Remove cycles

**5. Node Manipulation**
- Remove nth node
- Clone with random pointer
- Flatten multilevel lists

---

### Key Discussion Points

**1. Memory Management**
- How are nodes allocated?
- Garbage collection vs manual deletion
- Memory fragmentation issues

**2. Pointer Manipulation**
- Careful with null checks
- Update pointers in correct order
- Edge cases (empty list, single node)

**3. Trade-offs**
- Memory vs speed
- Complexity vs functionality
- Singly vs doubly linked

---

## 🎯 Summary

Linked lists are **fundamental** dynamic data structures:

**Key Strengths:**
- 💫 Dynamic size - grow/shrink as needed
- ⚡ O(1) insertion/deletion at head
- 🔧 Easy reorganization
- 💪 Foundation for complex structures

**Key Weaknesses:**
- 🐌 No random access - O(n) to reach element
- 💾 Extra memory for pointers
- 🔍 Sequential access only
- 📦 Poor cache locality

**Remember:**
- Use **Singly Linked** for simple forward traversal
- Use **Doubly Linked** when need backward traversal
- Master **two-pointer** technique for most problems
- Always consider **edge cases**: empty list, single node, cycles

---

## 📚 Related Topics

- [Advanced Linked List Patterns](./09_ADVANCED_LINKED_LISTS.md) - Complex linked list problems
- [Stack Operations & Applications](./10_STACKS.md) - Implemented using linked lists
- [Queue Operations & Variants](./11_QUEUES.md) - Implemented using linked lists

