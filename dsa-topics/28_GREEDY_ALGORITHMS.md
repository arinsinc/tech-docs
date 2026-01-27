# Greedy Approach & Patterns

## 📋 Overview

**Greedy Algorithms** make locally optimal choices at each step, hoping to find a global optimum. Unlike dynamic programming which considers all possibilities, greedy algorithms make irrevocable decisions based on current information. While not always correct, when applicable, greedy solutions are often elegant and efficient.

---

## 🎯 Core Concepts

### What is a Greedy Algorithm?

A greedy algorithm:
- Makes the **best local choice** at each step
- **Never reconsiders** previous decisions
- Hopes local optimums lead to global optimum
- **Simple and intuitive** when it works
- **Fast execution** - usually O(n) or O(n log n)

**Key Question:** Does making the locally optimal choice lead to a globally optimal solution?

**Visual Analogy:**
```
Problem: Climb to highest point

Dynamic Programming approach:
    ╱╲    ╱╲
   ╱  ╲  ╱  ╲
  ╱    ╲╱    ╲
Try all paths, backtrack, compare

Greedy approach:
    ╱╲
   ╱  ╲
  ╱ Always go up
 
At each step, take steepest upward path
(May miss global maximum if path goes down first!)
```

---

## 🎯 When Greedy Works

### Greedy Choice Property

**Definition:** A globally optimal solution can be arrived at by making locally optimal choices.

**Example - Coin Change (standard denominations):**
```
Coins: [25¢, 10¢, 5¢, 1¢]
Amount: 67¢

Greedy: Always take largest coin possible
Step 1: 67 - 25 = 42 (use quarter)
Step 2: 42 - 25 = 17 (use quarter)
Step 3: 17 - 10 =  7 (use dime)
Step 4:  7 -  5 =  2 (use nickel)
Step 5:  2 -  1 =  1 (use penny)
Step 6:  1 -  1 =  0 (use penny)

Result: 2 quarters + 1 dime + 1 nickel + 2 pennies = 6 coins ✓
This IS optimal for standard US coins!
```

**Counter-Example (greedy fails):**
```
Coins: [25¢, 10¢, 1¢]
Amount: 30¢

Greedy approach:
Step 1: 30 - 25 = 5 (use quarter)
Step 2:  5 -  1 = 4 (use penny)
Step 3:  4 -  1 = 3 (use penny)
Step 4:  3 -  1 = 2 (use penny)
Step 5:  2 -  1 = 1 (use penny)
Step 6:  1 -  1 = 0 (use penny)
Result: 1 quarter + 5 pennies = 6 coins ✗

Optimal solution:
3 dimes = 3 coins ✓

Greedy FAILS here!
```

### Optimal Substructure

**Definition:** Optimal solution contains optimal solutions to subproblems.

**Visual Example:**
```
Problem: Path A → B → C

Optimal path A → C must contain optimal path A → B
(or optimal path B → C)

  A ─────────→ B ─────────→ C
  └──── optimal ────┘
         └──── optimal ────┘
  └────────── optimal ──────────┘
```

---

## 📚 Classic Greedy Problems

### 1. Activity Selection

**Problem:** Given activities with start and end times, select maximum non-overlapping activities.

**Visual Example:**
```
Activities:
A1: [1, 4)   ████
A2: [3, 5)     ██
A3: [0, 6)   ██████
A4: [5, 7)       ██
A5: [3, 9)     ██████
A6: [5, 9)       ████
A7: [6, 10)       ███
A8: [8, 11)         ███
A9: [8, 12)         ████
A10:[2, 14)   ████████████
A11:[12,16)             ████

Timeline:
0  1  2  3  4  5  6  7  8  9  10 11 12 13 14 15 16
|──|──|──|──|──|──|──|──|──|──|──|──|──|──|──|──|
   A1───
      A3──────────
      A2──
            A4──
      A5──────────
            A6────
               A7───
                  A8───
                  A9────
   A10────────────────────
                     A11────

Greedy strategy: Always pick activity that finishes earliest
(leaves most room for future activities)

Step 1: Sort by end time
A1[1,4], A2[3,5], A3[0,6], A4[5,7], A5[3,9], A6[5,9], 
A7[6,10], A8[8,11], A9[8,12], A10[2,14], A11[12,16]

Step 2: Select greedily
Select A1 [1,4] ✓ (first to end)
Skip A2 [3,5] (overlaps with A1)
Skip A3 [0,6] (overlaps with A1)
Select A4 [5,7] ✓ (ends earliest after A1)
Skip A5, A6, A7 (overlap with A4)
Select A8 [8,11] ✓ (ends earliest after A4)
Skip A9, A10 (overlap with A8)
Select A11 [12,16] ✓ (no overlap)

Selected activities: A1, A4, A8, A11 (4 activities)

Visual solution:
0  1  2  3  4  5  6  7  8  9  10 11 12 13 14 15 16
|──|──|──|──|──|──|──|──|──|──|──|──|──|──|──|──|
   ████      ██         ███            ████
   A1        A4         A8             A11
```

**Why greedy works:** Finishing earliest leaves maximum time for remaining activities.

---

### 2. Fractional Knapsack

**Problem:** Items with weights and values, can take fractions. Maximize value with weight capacity.

**Visual Example:**
```
Capacity: 50 kg
Items:
  Item A: 10 kg, $60  (value/weight = $6/kg)
  Item B: 20 kg, $100 (value/weight = $5/kg)
  Item C: 30 kg, $120 (value/weight = $4/kg)

Greedy strategy: Take highest value per kg first

Step 1: Sort by value per kg
  A: $6/kg
  B: $5/kg
  C: $4/kg

Step 2: Take items greedily
  Take all of A: 10 kg, $60
  Remaining capacity: 40 kg
  
  Take all of B: 20 kg, $100
  Remaining capacity: 20 kg
  
  Take part of C: 20 kg (of 30 kg), $80
  Remaining capacity: 0 kg

Visual packing:
Knapsack (50 kg capacity):
┌────────────────────────────────────────────────┐
│ A (10kg)│ B (20kg)      │ C (20kg)        │    │
│  $60    │  $100         │  $80            │    │
└────────────────────────────────────────────────┘

Total value: $60 + $100 + $80 = $240
Total weight: 50 kg (full capacity used)
```

**Why greedy works:** Taking best value/weight ratio always optimal when fractions allowed.

---

### 3. Huffman Coding

**Problem:** Create optimal prefix-free binary encoding based on character frequencies.

**Visual Example:**
```
Characters and frequencies:
A: 5, B: 9, C: 12, D: 13, E: 16, F: 45

Greedy strategy: Always merge two smallest frequency nodes

Step 1: Create node for each character
[A:5] [B:9] [C:12] [D:13] [E:16] [F:45]

Step 2: Merge A and B (smallest two)
[AB:14] [C:12] [D:13] [E:16] [F:45]
     AB(14)
     /    \
   A(5)  B(9)

Step 3: Merge C and D
[AB:14] [CD:25] [E:16] [F:45]
     AB(14)    CD(25)
     /    \    /    \
   A(5)  B(9) C(12) D(13)

Step 4: Merge AB and E
[ABE:30] [CD:25] [F:45]
        ABE(30)
        /     \
     AB(14)  E(16)
     /    \
   A(5)  B(9)

Step 5: Merge CD and ABE
[ABCDE:55] [F:45]
          ABCDE(55)
          /       \
      ABE(30)    CD(25)
      /     \    /    \
   AB(14)  E(16) C(12) D(13)
   /    \
 A(5)  B(9)

Step 6: Merge all
            ROOT(100)
            /        \
        F(45)      ABCDE(55)
                   /       \
               ABE(30)    CD(25)
               /     \    /    \
            AB(14)  E(16) C(12) D(13)
            /    \
          A(5)  B(9)

Final encoding (0=left, 1=right):
F: 0           (1 bit)
C: 110         (3 bits)
D: 111         (3 bits)
E: 101         (3 bits)
A: 1000        (4 bits)
B: 1001        (4 bits)

Most frequent (F) gets shortest code!
Total bits: 45×1 + 12×3 + 13×3 + 16×3 + 5×4 + 9×4 = 224 bits

Fixed-length encoding would use: 100 × 3 = 300 bits
Savings: 25%!
```

---

### 4. Interval Scheduling Maximization

**Problem:** Schedule maximum number of tasks with deadlines.

**Visual Example:**
```
Tasks with deadlines and profits:
T1: deadline=2, profit=$100
T2: deadline=1, profit=$19
T3: deadline=2, profit=$27
T4: deadline=1, profit=$25
T5: deadline=3, profit=$15

Greedy: Sort by profit (descending), schedule earliest

Sorted: T1($100), T3($27), T4($25), T2($19), T5($15)

Time slots:
Slot 1: |___|
Slot 2: |___|
Slot 3: |___|

Schedule:
T1 (deadline=2): Place in slot 2 ✓
Slots: [___][T1][___]

T3 (deadline=2): Slot 2 full, try slot 1 ✓
Slots: [T3][T1][___]

T4 (deadline=1): Slot 1 full, can't schedule ✗

T2 (deadline=1): Slot 1 full, can't schedule ✗

T5 (deadline=3): Place in slot 3 ✓
Slots: [T3][T1][T5]

Final schedule:
Time:   1    2    3
Task:  T3   T1   T5
Profit: $27 $100 $15
Total: $142

Visual timeline:
0────1────2────3────4
     T3   T1   T5
```

---

### 5. Minimum Platforms

**Problem:** Find minimum platforms needed for train station.

**Visual Example:**
```
Trains:
T1: arrive=9:00, depart=9:10
T2: arrive=9:40, depart=12:00
T3: arrive=9:50, depart=11:20
T4: arrive=11:00, depart=11:30
T5: arrive=15:00, depart=19:00
T6: arrive=18:00, depart=20:00

Greedy: Process all events (arrivals and departures) in order

Events timeline:
9:00  9:10  9:40  9:50  11:00  11:20  11:30  12:00  15:00  18:00  19:00  20:00
 A1    D1    A2    A3     A4     D3     D4     D2     A5     A6     D5     D6

A = Arrival (need platform)
D = Departure (free platform)

Process events:
9:00: A1 → platforms=1 (need 1)
9:10: D1 → platforms=0
9:40: A2 → platforms=1
9:50: A3 → platforms=2 (need 2)
11:00: A4 → platforms=3 (need 3) ← Maximum!
11:20: D3 → platforms=2
11:30: D4 → platforms=1
12:00: D2 → platforms=0
15:00: A5 → platforms=1
18:00: A6 → platforms=2
19:00: D5 → platforms=1
20:00: D6 → platforms=0

Visual occupancy:
Platform 1: |T1|──|T2──────────────────|──|T5────────|
Platform 2:        |T3──────────|
Platform 3:              |T4──|
                               ↑
                          Peak: 3 platforms needed

Minimum platforms required: 3
```

---

### 6. Merge Intervals

**Problem:** Merge overlapping intervals.

**Visual Example:**
```
Intervals: [1,3], [2,6], [8,10], [15,18]

Timeline:
0  1  2  3  4  5  6  7  8  9  10 11 12 13 14 15 16 17 18
|──|──|──|──|──|──|──|──|──|──|──|──|──|──|──|──|──|──|
   ████        [1,3]
      ████████  [2,6]
                     ████      [8,10]
                                       ███████     [15,18]

Greedy: Sort by start, merge if overlapping

Sorted: [1,3], [2,6], [8,10], [15,18]

Step 1: Start with [1,3]
Current: [1,3]

Step 2: [2,6] overlaps with [1,3] (2 ≤ 3)
Merge: [1, max(3,6)] = [1,6]
Current: [1,6]

Step 3: [8,10] doesn't overlap with [1,6] (8 > 6)
Add [1,6] to result, start new interval
Current: [8,10]

Step 4: [15,18] doesn't overlap with [8,10] (15 > 10)
Add [8,10] to result, start new interval
Current: [15,18]

Final: Add [15,18] to result

Result: [1,6], [8,10], [15,18]

Visual merged:
0  1  2  3  4  5  6  7  8  9  10 11 12 13 14 15 16 17 18
|──|──|──|──|──|──|──|──|──|──|──|──|──|──|──|──|──|──|
   ██████████████        [1,6]
                     ████      [8,10]
                                       ███████     [15,18]
```

---

### 7. Jump Game

**Problem:** Can you reach the last index? Each element is maximum jump length.

**Visual Example:**
```
Array: [2, 3, 1, 1, 4]
Index:  0  1  2  3  4

Greedy: Track furthest reachable position

Start: position=0, maxReach=0

Position 0 (value=2):
  Can jump to: 1, 2
  maxReach = max(0, 0+2) = 2
  Can reach: [0,1,2]
  ████

Position 1 (value=3):
  Can jump to: 2, 3, 4
  maxReach = max(2, 1+3) = 4 ✓ (can reach end!)
  Can reach: [0,1,2,3,4]
  ██████████

Position 2 (value=1):
  maxReach = max(4, 2+1) = 4

Position 3 (value=1):
  maxReach = max(4, 3+1) = 4

Position 4: Goal reached!

Visual jumps:
[2, 3, 1, 1, 4]
 ↓  ↓──────────↓  (one possible path: 0→1→4)
 └──↓  (or: 0→2→3→4)

Result: Can reach end ✓
```

**Unreachable Example:**
```
Array: [3, 2, 1, 0, 4]
Index:  0  1  2  3  4

Position 0: maxReach = 3
Position 1: maxReach = max(3, 1+2) = 3
Position 2: maxReach = max(3, 2+1) = 3
Position 3: maxReach = max(3, 3+0) = 3

Stuck at position 3!
Can never reach position 4

Visual:
[3, 2, 1, 0, 4]
 ↓  ↓  ↓  X  ← unreachable
 █████████

Result: Cannot reach end ✗
```

---

## 🎯 Common Greedy Patterns

### Pattern 1: Sorting-Based Greedy

**Strategy:** Sort by some criteria, process in order.

**Examples:**
- Activity selection (sort by end time)
- Interval scheduling (sort by start/end)
- Fractional knapsack (sort by value/weight)

**Template:**
```
1. Sort elements by appropriate criteria
2. Iterate through sorted list
3. Make greedy choice at each step
4. Update running solution
```

---

### Pattern 2: Priority Queue Greedy

**Strategy:** Use heap to always get best element.

**Examples:**
- Huffman coding
- Merge k sorted lists
- Task scheduling with priorities

**Visual:**
```
Min Heap (always extract smallest):
        2
       / \
      5   3
     / \
    8   9

Extract min: 2
Next min: 3
...
Always optimal choice available
```

---

### Pattern 3: Two-Pointer Greedy

**Strategy:** Use two pointers to make greedy decisions.

**Examples:**
- Container with most water
- Two sum (sorted array)
- Removing stones

**Visual:**
```
Array: [1, 8, 6, 2, 5, 4, 8, 3, 7]
       ↑                          ↑
      left                      right

Move pointers greedily:
- Move pointer with smaller value
- Or move both based on greedy criterion
```

---

### Pattern 4: State-Based Greedy

**Strategy:** Track state, make choice based on current state.

**Examples:**
- Jump game (track furthest reach)
- Gas station (track fuel balance)
- Stock buy/sell

**Visual:**
```
State: currentBalance, maxReach, etc.
Each step: Update state based on greedy rule
```

---

## 💡 Proving Greedy Correctness

### Exchange Argument

**Approach:** Show that swapping greedy choice with any other doesn't improve solution.

**Example - Activity Selection:**
```
Claim: Choosing earliest-ending activity is optimal

Proof sketch:
- Let G be greedy solution (earliest ending first)
- Let O be any optimal solution
- If first activity in O ≠ first in G:
  - Replace O's first with G's first
  - Still valid (ends earlier, no more conflicts)
  - Still optimal
- Therefore G is optimal ✓
```

### Stay Ahead Argument

**Approach:** Show greedy solution is "ahead" at every step.

**Example - Fractional Knapsack:**
```
At each step:
- Greedy takes highest value/weight ratio
- After k items, greedy value ≥ any other k items
- Therefore final greedy value is optimal ✓
```

---

## 🎯 When Greedy Fails

### Example 1: Coin Change (arbitrary denominations)

```
Coins: [1, 3, 4]
Amount: 6

Greedy: 4 + 1 + 1 = 3 coins
Optimal: 3 + 3 = 2 coins ✓

Greedy FAILS!
Need DP instead.
```

### Example 2: 0/1 Knapsack

```
Cannot take fractions!

Items:
  A: 10 kg, $60  ($6/kg)
  B: 20 kg, $100 ($5/kg)
Capacity: 20 kg

Greedy (by value/kg): Take A ($60)
Optimal: Take B ($100) ✓

Greedy FAILS!
Need DP instead.
```

---

## 🎯 Greedy vs Other Approaches

### Greedy vs Dynamic Programming

```
GREEDY:
- Make irrevocable choice
- No looking back
- Fast: O(n) or O(n log n)
- Not always correct

Example: Fractional knapsack ✓

DP:
- Consider all options
- Optimal substructure
- Slower: O(n²), O(n³)
- Always finds optimum

Example: 0/1 knapsack ✓
```

### Greedy vs Divide & Conquer

```
GREEDY:
- One choice at each step
- Build solution incrementally
- Linear progression

Example: Activity selection

DIVIDE & CONQUER:
- Split into subproblems
- Solve independently
- Combine solutions

Example: Merge sort
```

---

## 🎯 Problem-Solving Strategy

### Step 1: Identify if Greedy Applies

**Questions:**
- Is there a clear "best" local choice?
- Does local optimum lead to global optimum?
- Can you prove correctness?

### Step 2: Define Greedy Strategy

**Common strategies:**
- Always choose smallest/largest
- Choose earliest/latest ending
- Choose best ratio/rate
- Choose to maximize/minimize some metric

### Step 3: Prove Correctness

**Methods:**
- Exchange argument
- Stay ahead argument
- Contradiction
- Induction

### Step 4: Implement Efficiently

**Optimizations:**
- Sort once upfront
- Use priority queue
- Two pointers
- Track state efficiently

---

## 🎯 Summary

**Greedy algorithms are powerful when applicable:**

**Key Characteristics:**
- 🎯 Make locally optimal choice
- ⚡ Fast execution (usually O(n log n))
- 💡 Simple and intuitive
- ⚠️ Not always correct - needs proof!

**Common Applications:**
- Activity/interval scheduling
- Huffman encoding
- Minimum spanning tree (Kruskal, Prim)
- Shortest path (Dijkstra)
- Fractional knapsack

**Recognition Signals:**
- ✅ "Maximum/minimum number of..."
- ✅ Scheduling problems
- ✅ Interval problems
- ✅ Optimization with ordering
- ✅ "Earliest", "latest", "shortest"

**When NOT to use:**
- ❌ 0/1 knapsack
- ❌ Longest common subsequence
- ❌ Arbitrary coin change
- ❌ Problems requiring backtracking

**Remember:** Greedy works when making the locally best choice leads to global optimum. Always prove correctness or verify with examples!

---

## 📚 Related Topics

- [Dynamic Programming Basics](./24_DYNAMIC_PROGRAMMING_BASICS.md) - Alternative approach
- [Sorting Algorithms](./31_SORTING.md) - Often used with greedy
- [Heaps & Priority Queues](./17_HEAPS.md) - For priority-based greedy
- [Graph Algorithms](./22_ADVANCED_GRAPHS.md) - MST, shortest path
- [Interval Problems](./03_ARRAYS.md) - Common greedy application
