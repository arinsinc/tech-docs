# Dynamic Programming Fundamentals & Patterns

## 📖 Overview

Dynamic Programming (DP) is an optimization technique that solves complex problems by breaking them into simpler subproblems. It's one of the most important topics for senior engineer interviews.

---

## 🎯 What is Dynamic Programming?

### Core Concepts

**Dynamic Programming** = Recursion + Memoization (or Tabulation)

### Two Key Properties

**1. Optimal Substructure**
- Solution to problem can be constructed from optimal solutions of subproblems

```
Example: Shortest path from A to C

A ──5── B ──3── C
  ╲           ╱
   ╲──10────╱

Optimal path A→C = Optimal(A→B) + Optimal(B→C)
                 = 5 + 3 = 8

Cannot use greedy: A→C (10) is not optimal
Must consider subproblems
```

**2. Overlapping Subproblems**
- Same subproblems solved multiple times

```
Example: Fibonacci(5)

                    fib(5)
                   ╱      ╲
              fib(4)      fib(3)
             ╱     ╲      ╱     ╲
        fib(3)   fib(2) fib(2) fib(1)
       ╱    ╲    ╱   ╲  ╱   ╲
   fib(2) fib(1) f(1) f(0) f(1) f(0)
   ╱   ╲
fib(1) fib(0)

Notice: fib(3) computed 2 times
        fib(2) computed 3 times
        fib(1) computed 5 times

Solution: Store results to avoid recomputation
```

---

## 🔄 Two Approaches to DP

### 1. Top-Down (Memoization)

**Concept**: Start with original problem, recursively break down, store results.

```
Fibonacci with Memoization:

Recursive tree WITH caching:
                    fib(5)
                   ╱      ╲
              fib(4)      fib(3) ← from cache!
             ╱     ╲      
        fib(3)   fib(2) ← from cache!
       ╱    ╲    
   fib(2) fib(1)
   ╱   ╲
fib(1) fib(0)

Cache after completion:
{
  0: 0,
  1: 1,
  2: 1,
  3: 2,
  4: 3,
  5: 5
}

Calls reduced from 15 to 9!
```

**Pros**:
- Intuitive (similar to recursion)
- Only computes needed subproblems
- Easy to write

**Cons**:
- Recursion overhead
- Stack space for recursion
- Slightly slower than bottom-up

---

### 2. Bottom-Up (Tabulation)

**Concept**: Start with smallest subproblems, build up to original problem.

```
Fibonacci with Tabulation:

DP Table (build from bottom):
Index: 0  1  2  3  4  5
      ┌──┬──┬──┬──┬──┬──┐
Value:│0 │1 │1 │2 │3 │5 │
      └──┴──┴──┴──┴──┴──┘

Build process:
Step 0: dp[0] = 0, dp[1] = 1 (base cases)
Step 1: dp[2] = dp[0] + dp[1] = 0 + 1 = 1
Step 2: dp[3] = dp[1] + dp[2] = 1 + 1 = 2
Step 3: dp[4] = dp[2] + dp[3] = 1 + 2 = 3
Step 4: dp[5] = dp[3] + dp[4] = 2 + 3 = 5

Result: dp[5] = 5

Visual flow:
0 + 1 = 1
    1 + 1 = 2
        1 + 2 = 3
            2 + 3 = 5 ✓
```

**Pros**:
- No recursion overhead
- Faster execution
- Better for interviews (shows understanding)

**Cons**:
- Less intuitive initially
- Computes all subproblems (even unneeded ones)
- Requires careful ordering

---

## 🎓 DP Pattern Recognition

### Pattern 1: Fibonacci-style (Linear DP)

**Signature**: Current state depends on previous 1-2 states

```
Examples:
- Climbing Stairs
- House Robber
- Decode Ways

General form:
dp[i] = function(dp[i-1], dp[i-2], ...)

Visual:
State i depends on:
        ┌──────┐
        │ i-2  │
        └───┬──┘
            │
        ┌───▼──┐
        │ i-1  │
        └───┬──┘
            │
        ┌───▼──┐
        │  i   │
        └──────┘
```

---

### Pattern 2: 0/1 Knapsack

**Signature**: Include or exclude current item

```
Problem: Maximize value with weight limit

Items: [(weight, value)]
[(2, 3), (3, 4), (4, 5), (5, 6)]
Capacity: 5

DP Table:
      Weight: 0  1  2  3  4  5
Item 0 (2,3): 0  0  3  3  3  3
Item 1 (3,4): 0  0  3  4  4  7
Item 2 (4,5): 0  0  3  4  5  7
Item 3 (5,6): 0  0  3  4  5  7

At each cell: max(
  exclude item: dp[i-1][w],
  include item: dp[i-1][w-weight] + value
)

Decision tree for item (3,4) at capacity 5:
        include (3,4)?
       ╱            ╲
     YES             NO
  value=4          value=3
  weight=3         (use previous)
  remaining=2
  + best(2) = 3
  total = 7 ✓
```

---

### Pattern 3: Unbounded Knapsack

**Signature**: Items can be used multiple times

```
Problem: Coin Change
Coins: [1, 2, 5]
Amount: 11

DP Table (minimum coins needed):
Amount: 0  1  2  3  4  5  6  7  8  9  10 11
Coins:  0  1  1  2  2  1  2  2  3  3  2  3

Visual for amount 11:
Option 1: Use coin 1
  11 = 1 + 10 → 1 + dp[10] = 1 + 2 = 3
Option 2: Use coin 2
  11 = 2 + 9 → 1 + dp[9] = 1 + 3 = 4
Option 3: Use coin 5
  11 = 5 + 6 → 1 + dp[6] = 1 + 2 = 3

Minimum: 3 coins (5 + 5 + 1)

Visual combination:
11 = [5] + [5] + [1]
     ↓     ↓     ↓
    coin  coin  coin
```

---

### Pattern 4: Longest Common Subsequence (LCS)

**Signature**: Matching characters in two sequences

```
Problem: LCS of "ABCD" and "ACBD"

DP Table:
      ""  A  C  B  D
  ""   0  0  0  0  0
  A    0  1  1  1  1
  B    0  1  1  2  2
  C    0  1  2  2  2
  D    0  1  2  2  3

Build logic:
If s1[i] == s2[j]:
  dp[i][j] = dp[i-1][j-1] + 1
Else:
  dp[i][j] = max(dp[i-1][j], dp[i][j-1])

Visual matching:
A B C D
A   C   D ← matches
↓   ↓   ↓
matched positions

LCS = "ACD" (length 3)

Trace back path:
D ← matched
C ← matched
B ← not matched (came from left)
A ← matched
```

---

### Pattern 5: Palindrome Problems

**Signature**: Checking substring properties

```
Problem: Longest Palindromic Substring
String: "babad"

DP Table (is palindrome?):
      b  a  b  a  d
  b   T  F  T  F  F
  a   -  T  F  T  F
  b   -  -  T  F  F
  a   -  -  -  T  F
  d   -  -  -  -  T

Build diagonally (increasing length):

Length 1: All single chars are palindromes
b  a  b  a  d
T  T  T  T  T

Length 2: Check pairs
ba → b==a? No → F
ab → a==b? No → F
ba → b==a? No → F
ad → a==d? No → F

Length 3: Check if ends match AND middle is palindrome
bab → b==b? Yes, AND "a" is palindrome → T
aba → a==a? Yes, AND "b" is palindrome → T

Visual palindromes:
"b" ✓
"a" ✓
"b" ✓
"bab" ✓
"aba" ✓

Longest: "bab" or "aba" (length 3)
```

---

## 🎯 Classic DP Problems

### 1. Climbing Stairs

```
Problem: Ways to climb n stairs (1 or 2 steps at a time)
n = 5

DP Table:
Stair: 0  1  2  3  4  5
Ways:  1  1  2  3  5  8

Logic: ways[i] = ways[i-1] + ways[i-2]

Visual explanation:
To reach stair 5:
  Come from stair 4 (1 step) → ways[4] = 5
  Come from stair 3 (2 steps) → ways[3] = 3
  Total = 5 + 3 = 8

All paths to stair 5:
1+1+1+1+1
1+1+1+2
1+1+2+1
1+2+1+1
2+1+1+1
1+2+2
2+1+2
2+2+1

Total: 8 ways ✓
```

**Time**: O(n)  
**Space**: O(1) optimized (only need last 2 values)

---

### 2. House Robber

```
Problem: Max money from houses, can't rob adjacent
Houses: [2, 7, 9, 3, 1]

DP Table:
Index:  0  1  2  3  4
House:  2  7  9  3  1
Max:    2  7  11 11 12

Decision at each house:
dp[i] = max(
  rob this house: nums[i] + dp[i-2],
  skip this house: dp[i-1]
)

Visual for house 2 (value 9):
Option 1: Rob house 2
  9 + dp[0] = 9 + 2 = 11 ✓
Option 2: Don't rob house 2
  dp[1] = 7

Choose max: 11

Final path (trace back):
Houses: [2, 7, 9, 3, 1]
         ✓     ✓     ✓
Rob houses 0, 2, 4: 2 + 9 + 1 = 12
```

**Time**: O(n)  
**Space**: O(1) optimized

---

### 3. Longest Increasing Subsequence (LIS)

```
Array: [10, 9, 2, 5, 3, 7, 101, 18]

DP Table (length of LIS ending at i):
Index:  0  1  2  3  4  5  6   7
Value: 10  9  2  5  3  7 101  18
LIS:    1  1  1  2  2  3  4   4

Build process:
For each i, check all j < i:
  If arr[j] < arr[i]:
    dp[i] = max(dp[i], dp[j] + 1)

Visual for index 5 (value 7):
Previous values: [10, 9, 2, 5, 3]
Can extend from: [2, 5, 3]
Best: extend from 5 → dp[3] + 1 = 2 + 1 = 3

Actual LIS: [2, 5, 7, 101] or [2, 3, 7, 18]
                ↑  ↑  ↑   ↑
           increasing sequence

Visual subsequence:
[10, 9, 2, 5, 3, 7, 101, 18]
        ↓  ↓     ↓   ↓
        2  5     7  101 (length 4)
```

**Time**: O(n²)  
**Space**: O(n)  
**Note**: Can optimize to O(n log n) with binary search

---

### 4. Coin Change

```
Problem: Minimum coins to make amount
Coins: [1, 2, 5]
Amount: 11

DP Table:
Amount: 0  1  2  3  4  5  6  7  8  9  10  11
Coins:  0  1  1  2  2  1  2  2  3  3   2   3

Build for amount 11:
Try coin 1: 1 + dp[10] = 1 + 2 = 3
Try coin 2: 1 + dp[9] = 1 + 3 = 4
Try coin 5: 1 + dp[6] = 1 + 2 = 3

Minimum: 3 coins

Trace back solution:
Amount 11: Used coin 5 → remaining 6
Amount 6: Used coin 5 → remaining 1
Amount 1: Used coin 1 → remaining 0

Coins used: [5, 5, 1] ✓

Visual:
11 ──(use 5)──→ 6 ──(use 5)──→ 1 ──(use 1)──→ 0
                                                ✓
```

**Time**: O(amount × coins)  
**Space**: O(amount)

---

### 5. Edit Distance

```
Problem: Min operations to convert "horse" to "ros"
Operations: Insert, Delete, Replace

DP Table:
      ""  r  o  s
  ""   0  1  2  3
  h    1  1  2  3
  o    2  2  1  2
  r    3  2  2  2
  s    4  3  3  2
  e    5  4  4  3

Logic at each cell:
If chars match:
  dp[i][j] = dp[i-1][j-1]
Else:
  dp[i][j] = 1 + min(
    dp[i-1][j],    // delete
    dp[i][j-1],    // insert
    dp[i-1][j-1]   // replace
  )

Visual operations:
horse → rorse (replace h→r)
rorse → rose (delete r)
rose → ros (delete e)

Total: 3 operations

Path through table:
(5,4) → (4,3) → (3,3) → (2,3)
        delete   delete   replace
```

**Time**: O(m × n)  
**Space**: O(m × n)

---

## 🔍 DP Optimization Techniques

### 1. Space Optimization

```
Before: 2D array → After: 1D array

Example: Coin Change
Instead of: dp[i][j] (amount × coins)
Use: dp[j] (amount only)

Fibonacci:
Before: dp[0..n]
After: only dp[i-1] and dp[i-2]

Visual:
Full array:  [0, 1, 1, 2, 3, 5, 8, 13]
Optimized:   prev=5, curr=8 (only last 2)
```

### 2. State Compression

```
Using bits to represent states

Example: Traveling Salesman (4 cities)
State: (current_city, visited_cities)

Visited as bitmask:
Cities: A B C D
Visited:{1,2}: 0110 = 6
Visited:{0,3}: 1001 = 9

Reduces state space significantly
```

---

## 💡 Interview Strategy

### Step 1: Identify DP Problem

**Signals**:
- "Optimal" (min/max)
- "Count ways"
- "Is it possible"
- Choices at each step
- Overlapping subproblems

### Step 2: Define State

**Questions to ask**:
- What changes between subproblems?
- What info do I need to make decision?
- What are dimensions of DP table?

### Step 3: Write Recurrence

**Format**:
```
dp[state] = optimal_choice(
  option1_result,
  option2_result,
  ...
)
```

### Step 4: Identify Base Cases

**Examples**:
- Empty string: dp[0] = 0
- First element: dp[0] = arr[0]
- No items: dp[0][j] = 0

### Step 5: Determine Iteration Order

**Rules**:
- Current state depends on previous states
- Compute dependencies first
- Usually: smaller to larger

### Step 6: Optimize Space

**After working solution**:
- Do I need full DP table?
- Can I use rolling array?
- Can I compute in-place?

---

## 🎯 Common Patterns Summary

| Pattern | State | Recurrence | Example |
|---------|-------|------------|---------|
| Linear | dp[i] | f(dp[i-1], dp[i-2]) | Fibonacci, Stairs |
| 0/1 Knapsack | dp[i][w] | max(include, exclude) | Subset Sum |
| Unbounded | dp[amount] | min over all choices | Coin Change |
| LCS | dp[i][j] | match or skip | Edit Distance |
| Interval | dp[i][j] | split interval | Matrix Chain |
| Bitmask | dp[mask] | add/remove from set | TSP |

---

## 🎓 Key Takeaways

1. **DP = Recursion + Memoization** (or Tabulation)
2. **Two properties required**: Optimal substructure + Overlapping subproblems
3. **Top-down is intuitive**, Bottom-up is faster
4. **Define state carefully** - drives entire solution
5. **Start with brute force** recursion, then optimize
6. **Practice pattern recognition** - most problems fit known patterns
7. **Draw tables** - visualize helps understand state transitions

---

## 📚 Practice Recommendation

### Beginner (Start Here)
1. Climbing Stairs
2. Min Cost Climbing Stairs
3. House Robber
4. Maximum Subarray

### Intermediate
1. Coin Change
2. Longest Increasing Subsequence
3. Unique Paths
4. Word Break

### Advanced
1. Edit Distance
2. Longest Common Subsequence
3. Maximum Product Subarray
4. Burst Balloons

---

## 📚 Next Topics

- [1D Dynamic Programming](./25_DP_1D.md) - Linear DP problems
- [2D Dynamic Programming](./26_DP_2D.md) - Matrix and grid problems
- [Advanced DP Patterns](./27_ADVANCED_DP.md) - Complex techniques
