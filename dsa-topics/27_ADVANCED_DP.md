# Advanced DP Patterns

## 📋 Overview

**Advanced Dynamic Programming** encompasses sophisticated techniques beyond basic 1D and 2D patterns. These include state compression, bitmask DP, digit DP, interval DP, tree DP, and DP with data structures. These patterns solve complex optimization problems that require creative state representation and efficient computation.

---

## 🎯 Core Concepts

### What Makes DP "Advanced"?

Advanced DP problems involve:
- **Complex state representation** (bitmasks, intervals, trees)
- **Multiple dimensions** or **compressed states**
- **Optimization tricks** (monotonic queue, convex hull)
- **Combination with other algorithms** (graphs, trees, segment trees)
- **Creative transitions** not obvious from problem statement

**Characteristics:**
- 🎯 Non-obvious state definitions
- 💡 Requires insight and creativity
- ⚡ Often needs optimization for feasibility
- 🔄 Combines multiple algorithmic concepts

---

## 📚 Advanced DP Patterns

### 1. Bitmask DP

**Concept:** Use integers as bitmasks to represent subsets, enabling compact state representation.

**When to Use:**
- Small set of elements (typically ≤ 20)
- Need to track which elements are used/visited
- Subset-based problems

**Visual Example - Traveling Salesman Problem (TSP):**
```
Cities: 0, 1, 2, 3 (4 cities)

Bitmask representation:
0000 = {} (no cities visited)
0001 = {0} (only city 0)
0011 = {0, 1} (cities 0 and 1)
1111 = {0, 1, 2, 3} (all cities)

DP State: dp[mask][i]
= minimum cost to visit cities in mask, ending at city i

Example:
dp[0011][1] = min cost to visit {0,1}, currently at city 1
dp[1111][3] = min cost to visit all cities, ending at city 3

Transition:
To compute dp[mask | (1<<j)][j]:
  Try all cities i in mask:
    dp[newMask][j] = min(dp[newMask][j], 
                         dp[mask][i] + dist[i][j])

Visual state space (4 cities):
Level 0: {} - start
         ↓
Level 1: {0}, {1}, {2}, {3} - visit 1 city
         ↓
Level 2: {0,1}, {0,2}, {0,3}, {1,2}, ... - visit 2 cities
         ↓
Level 3: {0,1,2}, {0,1,3}, ... - visit 3 cities
         ↓
Level 4: {0,1,2,3} - visit all cities (goal)

Total states: 2^n × n
```

**Example - Assignment Problem:**
```
Assign n tasks to n people, each person one task.

Bitmask = which tasks assigned
dp[mask] = min cost to assign tasks in mask

Tasks: T0, T1, T2
People: P0, P1, P2

State progression:
mask=000 (no tasks assigned)
  ↓
mask=001 (T0 assigned to P0)
mask=010 (T1 assigned to P0)
mask=100 (T2 assigned to P0)
  ↓
mask=011 (T0→P0, T1→P1)
mask=101 (T0→P0, T2→P1)
...
  ↓
mask=111 (all tasks assigned)

Transition:
For person i (process people in order):
  For each unassigned task j:
    dp[mask | (1<<j)] = min(dp[mask | (1<<j)],
                             dp[mask] + cost[i][j])
```

---

### 2. Digit DP

**Concept:** Count numbers with certain properties up to a given limit, processing digit by digit.

**When to Use:**
- Counting numbers in range with constraints
- Digit-based properties
- Very large ranges

**Visual Example - Count numbers ≤ 2345 with no consecutive 1s:**
```
Number: 2 3 4 5
        ↑ ↑ ↑ ↑
      pos:0 1 2 3

State: dp[pos][tight][prev]
- pos: current digit position
- tight: whether we're still bounded by limit
- prev: previous digit (to check consecutive)

Building number digit by digit:

Position 0 (thousands):
  tight=1: can choose 0,1,2 (limited by 2)
  tight=0: can choose any 0-9

Position 1 (hundreds):
  If prev was 2, tight=1: can choose 0-3
  If prev was <2, tight=0: can choose any

Visual state tree:
                Start
                  |
         ┌────────┼────────┐
         0        1        2 (tight)
         |        |        |
    [0-9,loose][0-9,loose][0-3,tight]
         |        |        |
        ...      ...      ...

Pruning:
If prev=1 and current=1: skip (consecutive 1s)

Example trace:
Number: 2345
- pos=0: choose 2 (tight=1)
- pos=1: choose 3 (tight=1, prev=2)
- pos=2: choose 4 (tight=1, prev=3)
- pos=3: choose 5 (tight=1, prev=4)
Valid if no consecutive 1s ✓
```

**State Transitions:**
```
dp[pos][tight][prev] = 
  sum over all valid digits d:
    dp[pos+1][newTight][d]

where:
  newTight = tight AND (d == limit[pos])
  valid = !(prev==1 AND d==1)
```

---

### 3. Interval DP (Range DP)

**Concept:** Solve problems on intervals/ranges, building from smaller to larger intervals.

**When to Use:**
- Optimal way to break/merge intervals
- Parenthesization problems
- Palindrome problems on ranges

**Visual Example - Matrix Chain Multiplication:**
```
Matrices: A₁(10×20), A₂(20×30), A₃(30×40), A₄(40×30)

DP State: dp[i][j] = min operations to multiply matrices i to j

Build from small intervals to large:

Length 1: Single matrices (base case)
dp[1][1] = 0, dp[2][2] = 0, dp[3][3] = 0, dp[4][4] = 0

Length 2: Two consecutive matrices
dp[1][2] = A₁ × A₂ = 10×20×30 = 6000
dp[2][3] = A₂ × A₃ = 20×30×40 = 24000
dp[3][4] = A₃ × A₄ = 30×40×30 = 36000

Length 3: Three consecutive matrices
dp[1][3]: Try splits at k=1,2
  k=1: (A₁) × (A₂×A₃)
       = dp[1][1] + dp[2][3] + 10×20×40
       = 0 + 24000 + 8000 = 32000
  k=2: (A₁×A₂) × (A₃)
       = dp[1][2] + dp[3][3] + 10×30×40
       = 6000 + 0 + 12000 = 18000 ✓ min

Length 4: All matrices
dp[1][4]: Try splits at k=1,2,3
  k=1: (A₁) × (A₂×A₃×A₄)
  k=2: (A₁×A₂) × (A₃×A₄)
  k=3: (A₁×A₂×A₃) × (A₄)
  ... compute each and take minimum

Visual interval building:
[i...i]         [i+1...i+1]       [i+2...i+2]
   ↓                 ↓                 ↓
[i...i+1]         [i+1...i+2]
      ↓                 ↓
      [i...i+2]
            ↓
         [i...i+3]
```

**Palindrome Partitioning:**
```
String: "aab"

dp[i][j] = min cuts to make substring [i,j] all palindromes

         a  a  b
      ┌──┬──┬──┐
    a │ 0│ 0│ 1│
      ├──┼──┼──┤
    a │  │ 0│ 1│
      ├──┼──┼──┤
    b │  │  │ 0│
      └──┴──┴──┘

Build diagonally:
Length 1: All are palindromes, 0 cuts
Length 2: "aa" is palindrome, 0 cuts
          "ab" is not, 1 cut
Length 3: "aab" - try all splits
```

---

### 4. Tree DP

**Concept:** Dynamic programming on tree structures, typically using DFS with memoization.

**When to Use:**
- Optimization problems on trees
- Subtree-based decisions
- Parent-child relationships

**Visual Example - Maximum Independent Set on Tree:**
```
Tree:
        1(5)
       / \
     2(3) 3(2)
     /     \
   4(1)    5(4)

Problem: Select nodes with max sum, no two adjacent

State:
dp[node][0] = max sum in subtree, node NOT selected
dp[node][1] = max sum in subtree, node selected

Leaves (bottom-up):
Node 4: dp[4][0] = 0, dp[4][1] = 1
Node 5: dp[5][0] = 0, dp[5][1] = 4

Node 2:
  dp[2][0] = max(dp[4][0], dp[4][1]) = 1
  dp[2][1] = 3 + dp[4][0] = 3

Node 3:
  dp[3][0] = max(dp[5][0], dp[5][1]) = 4
  dp[3][1] = 2 + dp[5][0] = 2

Node 1 (root):
  dp[1][0] = max(dp[2][0], dp[2][1]) + 
             max(dp[3][0], dp[3][1])
           = 3 + 4 = 7
  dp[1][1] = 5 + dp[2][0] + dp[3][0]
           = 5 + 1 + 0 = 6

Maximum: 7 (select nodes 2, 5)

Visual selection:
        1(5)   ← not selected
       / \
     2(3) 3(2) ← selected left, not right
     /     \
   4(1)    5(4) ← not selected, selected
   
Selected: {2, 5} with sum = 7
```

**Tree Diameter:**
```
Tree:
        1
       /|\
      2 3 4
     /   |
    5    6

State:
dp[node] = max path length in subtree

For each node, consider:
1. Path through node (connecting two subtrees)
2. Path ending at node

        1
       /|\
      2 3 4
     /   |
    5    6

At node 2:
  Height to 5 = 1
  dp[2] = 1

At node 3:
  Height to 6 = 1
  dp[3] = 1

At node 1:
  Children heights: [2, 1, 0] (from 2, 3, 4)
  Diameter through 1 = 2 + 1 + 1 = 4
  (path: 5 → 2 → 1 → 3 → 6)
```

---

### 5. DP with Monotonic Queue

**Concept:** Optimize DP transitions using monotonic queue for sliding window min/max.

**When to Use:**
- Transitions involve range min/max queries
- Sliding window optimization
- Can reduce O(nk) to O(n)

**Visual Example - Jump Game VI:**
```
Array: [1, -1, -2, 4, -7, 3]
Max jump: k=2

dp[i] = max score reaching position i
dp[i] = arr[i] + max(dp[i-k] to dp[i-1])

Without optimization: O(nk)
With monotonic queue: O(n)

Monotonic decreasing queue (stores indices):

Position 0: dp[0] = 1
Queue: [0]

Position 1: dp[1] = arr[1] + dp[0] = -1 + 1 = 0
Queue: [0, 1]
(keep both since 1 >= 0? No, but might be useful)

Position 2: dp[2] = arr[2] + max(dp[0], dp[1])
          = -2 + max(1, 0) = -1
Remove indices out of range (i-k)
Queue maintenance:
  - Remove indices where dp[idx] <= dp[2] from back
  - Front has best value in window
  
Visual queue states:
i=0: [0(dp=1)]
i=1: [0(dp=1), 1(dp=0)]
i=2: [0(dp=1)]  (removed 1, added 2)
i=3: [3(dp=3)]  (4 + max window)
...

Queue stores indices in decreasing order of dp values
Front always has maximum in current window
```

---

### 6. DP with Convex Hull Trick

**Concept:** Optimize DP transitions that involve line equations using convex hull of lines.

**When to Use:**
- Transitions of form: dp[i] = min/max(dp[j] + cost(j, i))
- cost(j, i) can be expressed as linear function
- Typically O(n²) reduced to O(n log n) or O(n)

**Visual Representation:**
```
Problem: dp[i] = min over j < i: (dp[j] + b[j] * a[i])

This is finding min of lines: y = dp[j] + b[j] * x
where x = a[i]

Visual (lines in 2D plane):

        y
        ↑
        │    Line 1: y = dp[1] + b[1]*x
        │   /
        │  / Line 2: y = dp[2] + b[2]*x
        │ /  /
        │/  /
        ──────────→ x

Convex Hull Trick:
Keep only lines that form lower convex hull
Remove lines that are never optimal

Maintained hull:
     L1
       \
        L3  (L2 removed, never optimal)
          \
           L4

For query at x:
- Binary search on hull to find optimal line
- O(log n) instead of O(n)
```

---

### 7. Probability DP

**Concept:** DP where states represent probabilities or expected values.

**Visual Example - Expected Steps to Reach End:**
```
Game: At position i, flip coin:
- Heads: move +1
- Tails: move +2

State: dp[i] = expected steps to reach position n from i

         0   1   2   3   4   5=goal
         ↓   ↓   ↓   ↓   ↓   ↓
        [5] [4] [3] [2] [1] [0]

Base: dp[n] = 0 (already at goal)

Recurrence:
dp[i] = 1 + 0.5 * dp[i+1] + 0.5 * dp[i+2]
        ↑   ↑              ↑
      step  prob heads     prob tails

dp[4] = 1 + 0.5*dp[5] + 0.5*dp[6]
      = 1 + 0.5*0 + 0.5*0 = 1

dp[3] = 1 + 0.5*dp[4] + 0.5*dp[5]
      = 1 + 0.5*1 + 0.5*0 = 1.5

dp[2] = 1 + 0.5*dp[3] + 0.5*dp[4]
      = 1 + 0.5*1.5 + 0.5*1 = 2.25

Visual probability tree:
        Start(0)
         /    \
       0.5    0.5
       /        \
      (1)       (2)
     / \       / \
   0.5 0.5   0.5 0.5
   /    \    /    \
  (2)  (3) (3)   (4)
  ...  ...  ...  ...
```

---

### 8. String DP with Automaton

**Concept:** Use finite automaton or similar structure with DP for pattern matching.

**Visual Example - Regular Expression Matching:**
```
Pattern: "a*b"
String: "aaab"

State: dp[i][j] = whether string[0..i] matches pattern[0..j]

         ""  a   *   b
      ┌────┬───┬───┬───┐
  ""  │ T  │ F │ T │ F │
      ├────┼───┼───┼───┤
  a   │ F  │ T │ T │ F │
      ├────┼───┼───┼───┤
  a   │ F  │ F │ T │ F │
      ├────┼───┼───┼───┤
  a   │ F  │ F │ T │ F │
      ├────┼───┼───┼───┤
  b   │ F  │ F │ F │ T │
      └────┴───┴───┴───┘

'*' means 0 or more of previous character

dp[4][3] = true (aaab matches a*b)

State transitions:
- Regular char: must match exactly
- '*': can match 0, 1, or more occurrences
```

---

### 9. DP on Subsets

**Concept:** DP where state represents a subset of elements.

**Visual Example - Subset Sum:**
```
Set: [3, 5, 7]
Target: 12

State: dp[i][sum] = can we achieve sum using first i elements?

         0   1   2   3   4   5   6   7   8   9  10  11  12
      ┌───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┬───┐
  {}  │ T │ F │ F │ F │ F │ F │ F │ F │ F │ F │ F │ F │ F │
      ├───┼───┼───┼───┼───┼───┼───┼───┼───┼───┼───┼───┼───┤
  {3} │ T │ F │ F │ T │ F │ F │ F │ F │ F │ F │ F │ F │ F │
      ├───┼───┼───┼───┼───┼───┼───┼───┼───┼───┼───┼───┼───┤
 {3,5}│ T │ F │ F │ T │ F │ T │ F │ F │ T │ F │ F │ F │ F │
      ├───┼───┼───┼───┼───┼───┼───┼───┼───┼───┼───┼───┼───┤
{3,5,7}│ T │ F │ F │ T │ F │ T │ F │ T │ T │ F │ T │ F │ T │
      └───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───┴───┘

Achievable sums with all elements:
{}, {3}, {5}, {7}, {3,5}, {3,7}, {5,7}, {3,5,7}
 0   3    5    7     8      10     12     15

Can achieve 12: Yes! (5 + 7)
```

---

### 10. DP with State Compression

**Concept:** Compress multiple dimensions or conditions into compact representation.

**Visual Example - Broken Profile DP (Tiling):**
```
Tile 2×n grid with 2×1 dominoes

State: dp[col][mask]
- col: current column
- mask: which cells in current column are filled

mask representation (for 2 rows):
00 = both empty
01 = top filled, bottom empty
10 = top empty, bottom filled
11 = both filled

Grid (2×4):
┌──┬──┬──┬──┐
│  │  │  │  │  Row 0
├──┼──┼──┼──┤
│  │  │  │  │  Row 1
└──┴──┴──┴──┘

Transitions:
From col i, mask 00 (both empty):
  Place vertical: → mask 00 at col i+1
  Place 2 horizontal: → mask 11 at col i+1

From col i, mask 01 (top filled):
  Can only place horizontal in bottom
  → mask 10 at col i+1

Visual tiling:
┌──┬──┬──┬──┐
│ ═══ │ ║║ │  Horizontal + Vertical
├──┼──┼──┼──┤
│ ══ │ ║║ │  
└──┴──┴──┴──┘
```

---

## 🎯 Optimization Techniques

### Memoization vs Tabulation

**Memoization (Top-Down):**
```
- Start from goal, recurse
- Cache results as computed
- Only compute needed states
- Good for sparse state space

Example state tree:
        F(n)
       /   \
    F(n-1) F(n-2)
    /  \    /  \
  ...  ... ... ...
  
Cache prevents recomputation
```

**Tabulation (Bottom-Up):**
```
- Start from base cases
- Build up to goal
- Compute all states (potentially)
- Good for dense state space

Example table:
F(0) → F(1) → F(2) → ... → F(n)
All states filled sequentially
```

---

### Space Optimization

**Technique 1: Rolling Array**
```
From: dp[i][j] using dp[i-1][j]
To:   prev[j], curr[j]
Savings: O(n×m) → O(m)
```

**Technique 2: In-Place**
```
Update array from right to left
Prevents overwriting needed values
```

**Technique 3: State Reduction**
```
Compress multiple booleans into bitmask
Example: 10 booleans → 1 integer (10 bits)
```

---

## 🎯 Problem-Solving Strategy

### 1. Recognize Pattern

**Ask yourself:**
- Is it bitmask DP? (small set, subsets)
- Is it interval DP? (merging, breaking ranges)
- Is it tree DP? (hierarchical structure)
- Does it need optimization? (large constraints)

### 2. Define State Carefully

**State must:**
- Uniquely identify subproblem
- Be computable from smaller states
- Lead to solution

**Examples:**
- Bitmask: `dp[mask][last]`
- Interval: `dp[left][right]`
- Tree: `dp[node][selected]`

### 3. Handle Base Cases

**Common bases:**
- Empty set/interval
- Leaf nodes
- Single elements

### 4. Optimize if Needed

**When to optimize:**
- TLE with standard approach
- Large constraints (n > 10⁵)
- Tight time limits

**How:**
- Add data structure (segment tree, BIT)
- Use monotonic queue/stack
- Apply convex hull trick
- Reduce dimensions

---

## 🎯 Summary

**Advanced DP requires creativity and insight:**

**Key Patterns:**
1. **Bitmask DP** - Subset tracking (TSP, assignment)
2. **Digit DP** - Count numbers with properties
3. **Interval DP** - Range optimization (matrix chain)
4. **Tree DP** - Hierarchical problems
5. **DP + Optimization** - Monotonic queue, convex hull

**Recognition Signals:**
- ✅ Small sets (≤20) → Bitmask
- ✅ Counting numbers → Digit DP
- ✅ Range operations → Interval DP
- ✅ Tree structure → Tree DP
- ✅ Large constraints → Need optimization

**Common Optimizations:**
- 🚀 Space: Rolling array, state compression
- 🚀 Time: Monotonic structures, convex hull
- 🚀 Both: Clever state representation

**Remember:** Advanced DP is about recognizing patterns, defining creative states, and applying the right optimizations. Practice identifying these patterns in problems!

---

## 📚 Related Topics

- [DP Fundamentals & Patterns](./24_DYNAMIC_PROGRAMMING_BASICS.md) - Foundation
- [1D Dynamic Programming](./25_DP_1D.md) - Simple patterns
- [2D Dynamic Programming](./26_DP_2D.md) - Two-dimensional state
- [Binary Trees](./13_BINARY_TREES.md) - For tree DP
- [Bit Manipulation](./33_BIT_MANIPULATION.md) - For bitmask DP
- [Monotonic Structures](./12_MONOTONIC_STRUCTURES.md) - For optimization
