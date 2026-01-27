# Combinatorial Problems

## 📋 Overview

**Combinatorial problems** involve counting, generating, or optimizing arrangements of objects. These problems explore permutations, combinations, partitions, and arrangements where the number of possibilities grows exponentially. Backtracking is the primary technique for solving these problems, often with clever pruning to manage the exponential search space.

---

## 🎯 Core Concepts

### What are Combinatorial Problems?

Combinatorial problems deal with:
- **Counting** arrangements or configurations
- **Generating** all possible solutions
- **Optimizing** selections or orderings
- **Satisfying** complex constraints

**Types:**
- 🎲 Permutations (order matters)
- 🎯 Combinations (order doesn't matter)
- 🔢 Partitions (grouping elements)
- 🎨 Arrangements with constraints

---

## 📚 Fundamental Concepts

### Permutations vs Combinations

**Visual Comparison:**
```
Set: {A, B, C}

PERMUTATIONS (order matters):
ABC, ACB, BAC, BCA, CAB, CBA
Total: 3! = 6

Selection matters:
"AB" ≠ "BA" (different order)

COMBINATIONS (order doesn't matter):
{A,B}, {A,C}, {B,C}
Total: C(3,2) = 3

Selection same:
{A,B} = {B,A} (same set)

Visual:
Permutations:      Combinations:
A-B-C              {A,B,C}
A-C-B               /  |  \
B-A-C            {A,B}{A,C}{B,C}
B-C-A
C-A-B
C-B-A
```

### Counting Formulas

```
Permutations of n items:
P(n) = n!

Example: 4 books on shelf
P(4) = 4! = 24 ways

Permutations of r from n:
P(n,r) = n!/(n-r)!

Example: Choose 2 from 4 books for display
P(4,2) = 4!/2! = 12 ways

Combinations of r from n:
C(n,r) = n!/(r!(n-r)!)

Example: Choose 2 from 4 books (order doesn't matter)
C(4,2) = 4!/(2!×2!) = 6 ways

With repetition:
Permutations: n^r
Combinations: C(n+r-1, r)
```

---

## 📚 Classic Combinatorial Problems

### 1. Combinations

**Problem:** Generate all k-sized combinations from n elements.

**Visual Example - C(4,2) from [1,2,3,4]:**
```
All pairs:
{1,2}, {1,3}, {1,4}, {2,3}, {2,4}, {3,4}

Decision tree:
                    []
           /      |      |      \
         [1]    [2]    [3]    [4]
        / | \    / \     |
    [1,2][1,3][1,4][2,3][2,4][3,4]

Process:
Start with 1:
  Combine with 2: {1,2} ✓
  Combine with 3: {1,3} ✓
  Combine with 4: {1,4} ✓

Start with 2 (skip 1, already covered):
  Combine with 3: {2,3} ✓
  Combine with 4: {2,4} ✓

Start with 3 (skip 1,2):
  Combine with 4: {3,4} ✓

Start with 4: No elements left

Visual indices pattern:
[1,2,3,4]
 i j       → {1,2}
 i   j     → {1,3}
 i     j   → {1,4}
   i j     → {2,3}
   i   j   → {2,4}
     i j   → {3,4}

Rule: j > i (avoid duplicates, preserve order)
```

**Larger Example - C(5,3):**
```
Choose 3 from [1,2,3,4,5]:

         start=1, need 2 more
        /      |      \
     [1,2]   [1,3]   [1,4]   [1,5]
      / \      / \     / \     |
  [1,2,3].. [1,3,4][1,4,5][1,5,?]

Combinations:
{1,2,3}, {1,2,4}, {1,2,5}
{1,3,4}, {1,3,5}
{1,4,5}
{2,3,4}, {2,3,5}
{2,4,5}
{3,4,5}

Total: C(5,3) = 10 combinations
```

---

### 2. Combination Sum

**Problem:** Find all unique combinations that sum to target (elements can be reused).

**Visual Example - candidates=[2,3,6,7], target=7:**
```
Decision tree:
                      target=7
            /      |        |       \
         use 2   use 3    use 6    use 7
         t=5     t=4      t=1      t=0 ✓
        / | \    / \       |
      2 3 6 7  3 6 7      6,7
      
Path 1: [7] → sum=7 ✓

Path 2: [2,2,3]
  Start: target=7
  Use 2: target=5, path=[2]
  Use 2: target=3, path=[2,2]
  Use 3: target=0, path=[2,2,3] ✓

Path 3: [3,3] → sum=6 ✗ (can't reach exactly 7)

Path 4: [2,3,2] (same as [2,2,3])
  Avoid duplicates by not going backwards

Visual paths:
         7
    /    |    |    \
   2     3    6    7✓
  / \    |    
 2   3   3
 |   |   |
 3✓  2✓  
 
Solutions:
[7]
[2,2,3]

Pruning:
- If current sum > target: stop
- If current sum = target: add solution
- Only try candidates ≥ last used (avoid duplicates)
```

---

### 3. Letter Combinations of Phone Number

**Problem:** Given digit string, return all possible letter combinations.

**Visual Example - digits="23":**
```
Phone keypad:
2: abc
3: def
4: ghi
5: jkl
6: mno
7: pqrs
8: tuv
9: wxyz

Input: "23"
Digit 2: {a,b,c}
Digit 3: {d,e,f}

Decision tree:
                ""
          /     |     \
         a      b      c
       / | \  / | \  / | \
      ad ae af bd be bf cd ce cf

All combinations:
ad, ae, af, bd, be, bf, cd, ce, cf

Visual grid:
      d    e    f
   ┌────┬────┬────┐
 a │ ad │ ae │ af │
   ├────┼────┼────┤
 b │ bd │ be │ bf │
   ├────┼────┼────┤
 c │ cd │ ce │ cf │
   └────┴────┴────┘

Total: 3 × 3 = 9 combinations

Longer example - "234":
Level 1: {a,b,c}        → 3 choices
Level 2: {d,e,f}        → 3 choices each
Level 3: {g,h,i}        → 3 choices each
Total: 3 × 3 × 3 = 27 combinations

Example paths:
a → d → g = "adg"
a → d → h = "adh"
b → e → h = "beh"
...
```

---

### 4. Palindrome Partitioning

**Problem:** Partition string into substrings where each is a palindrome.

**Visual Example - "aab":**
```
String: "aab"

Decision tree (where to cut):
                "aab"
           /     |      \
         "|aab" "a|ab"  "aa|b"
          ✗      /  \     ✓
              "a|a|b""a|ab"
                ✓      ✗

Partition "a|ab":
  "a" is palindrome ✓
  "ab" is not palindrome ✗

Partition "aa|b":
  "aa" is palindrome ✓
  "b" is palindrome ✓
  Solution: ["aa","b"] ✓

Partition "a|a|b":
  "a" is palindrome ✓
  "a" is palindrome ✓
  "b" is palindrome ✓
  Solution: ["a","a","b"] ✓

Visual cuts:
"aab"
 ↓ ↓↓  (all possible cut positions)

Cut after 'a': ["a", "ab"]
  "a" ✓, "ab" ✗

Cut after 'aa': ["aa", "b"]
  "aa" ✓, "b" ✓ → Valid! ✓

Cut after 'a' and 'a': ["a", "a", "b"]
  All palindromes ✓ → Valid! ✓

Final solutions:
1. ["aa", "b"]
2. ["a", "a", "b"]
```

---

### 5. Subsets with Duplicates

**Problem:** Generate all subsets when array contains duplicates.

**Visual Example - [1,2,2]:**
```
Without handling duplicates:
                []
         /      |      \
       [1]     [2]     [2]  ← duplicate branches!
      / | \   / | \   / | \
    ...  ... ...  ... ...  ...

Result: duplicates like [1,2] appearing multiple times

With handling duplicates:
Sort first: [1,2,2]

                []
         /      |      \
       [1]     [2]     skip(2)
      / | \   / | \   
   [1,2][1,2²] [2,2²] skip

Rules:
1. Sort array first
2. Skip duplicates at same decision level
3. Only skip if not taking previous duplicate

Decision at each level:
Level 0: Consider 1
  Include: [1]
  Exclude: []

Level 1: Consider first 2
  Include: [1,2] or [2]
  Exclude: [1] or []

Level 2: Consider second 2
  Only if included first 2!
  Include: [1,2,2] or [2,2]

Valid subsets:
[], [1], [2], [1,2], [2,2], [1,2,2]

Visual with skip logic:
        []
       / \
     [1]  []    (include/exclude 1)
     /|\  /|\
   ...skip...   (skip duplicate 2 if didn't take first 2)
```

---

### 6. Partition Equal Subset Sum

**Problem:** Can we partition array into two subsets with equal sum?

**Visual Example - [1,5,11,5]:**
```
Total sum: 22
Target: 11 (half of total)

Question: Can we find subset summing to 11?

Decision tree:
                sum=0, remaining=[1,5,11,5]
              /                              \
       Include 1                         Exclude 1
       sum=1                             sum=0
      /        \                        /         \
  Include 5  Exclude 5            Include 5    Exclude 5
  sum=6      sum=1                sum=5        sum=0
    / \        / \                  / \          / \
  ...  ...   ...  ...             ...  ...     ...  ...

Path finding sum=11:
Start: sum=0
  Include 1: sum=1
    Include 5: sum=6
      Include 5: sum=11 ✓ FOUND!

Subset 1: {1, 5, 5} = 11
Subset 2: {11} = 11
Equal partitions exist! ✓

Visual partition:
Array: [1, 5, 11, 5]
        ↓  ↓      ↓
Group 1: 1 +5  + 5 = 11
Group 2:    11     = 11
         ✓ Equal!

Example that fails - [1,2,5]:
Total: 8
Target: 4
Can we make 4?
  {1,2} = 3 ✗
  {1,5} = 6 ✗
  {2,5} = 7 ✗
  {1} = 1 ✗
  {2} = 2 ✗
  {5} = 5 ✗
No subset sums to 4!
```

---

### 7. Generate Abbreviations

**Problem:** Generate all abbreviations of a word.

**Visual Example - "word":**
```
Word: "word" (length 4)

At each position: keep letter or abbreviate

Decision tree:
                  "word"
           /                \
        w (keep)          1 (abbreviate)
       /        \        /         \
     wo         w1      1o         2
    /  \       /  \    /  \       /  \
  wor  wo1   w1r w2  1or  1o1   2r  3
  / \   / \   |   |   |    |    |   |
word wo1d w1rd w2d 1ord 1o1d  2rd  3d
 ✓    ✓    ✓   ✓   ✓    ✓    ✓   ✓

And many more...

Examples of abbreviations:
- "word" (no abbreviation)
- "wor1" (abbreviate 'd')
- "wo2" (abbreviate "rd")
- "w3" (abbreviate "ord")
- "2rd" (abbreviate "wo")
- "4" (abbreviate entire word)

Count: 2^n = 2^4 = 16 abbreviations

Visual representation:
Position: 0 1 2 3
Letter:   w o r d

Choices at each position:
w: keep 'w' or count as 1
o: keep 'o' or count as 1
r: keep 'r' or count as 1
d: keep 'd' or count as 1

Sequential digits merge:
"w" + "1" + "1" + "1" = "w3" (not "w111")
```

---

### 8. Beautiful Arrangements

**Problem:** Count permutations where arr[i] is divisible by i or i is divisible by arr[i].

**Visual Example - N=3:**
```
Need permutation of [1,2,3] where:
Position 1: num % 1 == 0 or 1 % num == 0
Position 2: num % 2 == 0 or 2 % num == 0
Position 3: num % 3 == 0 or 3 % num == 0

Testing permutations:

[1,2,3]:
  pos 1: 1 % 1 = 0 ✓
  pos 2: 2 % 2 = 0 ✓
  pos 3: 3 % 3 = 0 ✓
  Valid! ✓

[1,3,2]:
  pos 1: 1 % 1 = 0 ✓
  pos 2: 3 % 2 = 1 ✗, 2 % 3 = 2 ✗
  Invalid! ✗

[2,1,3]:
  pos 1: 2 % 1 = 0 ✓
  pos 2: 1 % 2 = 1 ✗, but 2 % 1 = 0 ✓
  pos 3: 3 % 3 = 0 ✓
  Valid! ✓

[2,3,1]:
  pos 1: 2 % 1 = 0 ✓
  pos 2: 3 % 2 = 1 ✗, 2 % 3 = 2 ✗
  Invalid! ✗

[3,1,2]:
  pos 1: 3 % 1 = 0 ✓
  pos 2: 1 % 2 = 1 ✗, but 2 % 1 = 0 ✓
  pos 3: 2 % 3 = 2 ✗, but 3 % 2 = 1 ✗
  Invalid! ✗

[3,2,1]:
  pos 1: 3 % 1 = 0 ✓
  pos 2: 2 % 2 = 0 ✓
  pos 3: 1 % 3 = 1 ✗, but 3 % 1 = 0 ✓
  Valid! ✓

Beautiful arrangements: [1,2,3], [2,1,3], [3,2,1]
Count: 3

Decision tree with pruning:
        []
    /   |   \
  [1]  [2]  [3]
  / \   |\   |\
[1,2][1,3][2,1][2,3]✗...
  |    |    |
[1,2,3][1,3,2]✗[2,1,3]
  ✓           ✓

Prune invalid branches early!
```

---

## 🎯 Optimization Techniques

### 1. Early Pruning

```
Check constraints BEFORE recursing:

❌ Bad:
  Add number
  Recurse
  Check if valid (too late!)

✓ Good:
  For each number:
    If valid at this position:
      Add number
      Recurse
```

### 2. Avoiding Duplicates

```
For arrays with duplicates:

1. Sort first
2. Skip duplicate at same level:

for i in range(start, n):
  if i > start and arr[i] == arr[i-1]:
    continue  # skip duplicate
  # process arr[i]

Visual:
[1,2,2,3]
   ↑ ↑
  Skip second 2 at same decision level
```

### 3. Memoization

```
Cache results for repeated states:

State: (remaining_elements, current_sum)
If seen before: return cached result

Example - Subset sum:
State (index=3, sum=10) computed once
Reuse result if encountered again
```

---

## 🎯 Problem-Solving Strategies

### Strategy 1: Choose-Explore-Unchoose

```
Template:
1. Choose element
2. Recursively explore
3. Unchoose (backtrack)

for element in choices:
  choose(element)
  explore(remaining)
  unchoose(element)
```

### Strategy 2: Include-Exclude

```
For each element:
  Branch 1: Include it
  Branch 2: Exclude it

Generates all subsets/combinations
```

### Strategy 3: Try All Positions

```
For permutations:
  For each position:
    Try each unused element
    Recurse with that element fixed
    Unmark element
```

---

## 🎯 Complexity Analysis

### Time Complexity

```
Permutations: O(n! × n)
  - n! permutations
  - n to build each

Combinations: O(C(n,k) × k)
  - C(n,k) combinations
  - k to build each

Subsets: O(2^n × n)
  - 2^n subsets
  - n to build each

General: O(b^d × s)
  - b = branching factor
  - d = depth
  - s = solution size
```

### Space Complexity

```
Recursion stack: O(depth)
Current state: O(solution size)
Results storage: O(total solutions × solution size)

Example - Subsets of n elements:
  Stack: O(n)
  Current subset: O(n)
  All subsets: O(2^n × n)
```

---

## 🎯 Common Patterns Recognition

### Permutations
**Signals:**
- "All arrangements"
- "Order matters"
- "Each element used once"

### Combinations
**Signals:**
- "Select k items"
- "Order doesn't matter"
- "Choose subset"

### Partitioning
**Signals:**
- "Split into groups"
- "Divide into subsets"
- "Equal sum partitions"

### Constraint Satisfaction
**Signals:**
- "Place n items"
- "Satisfy rules"
- "Valid configuration"

---

## 🎯 Summary

**Combinatorial problems explore exponential solution spaces:**

**Key Problem Types:**
1. **Permutations** - All orderings (n!)
2. **Combinations** - Subsets of size k (C(n,k))
3. **Subsets** - All possible subsets (2^n)
4. **Partitions** - Ways to divide elements
5. **Arrangements** - Configurations satisfying constraints

**Core Techniques:**
- 🎯 Backtracking with pruning
- 🔄 Include/exclude decisions
- 📊 Try all positions/choices
- ✂️ Early constraint checking

**Optimization Strategies:**
- ✅ Sort to handle duplicates
- ✅ Prune invalid branches early
- ✅ Cache repeated states
- ✅ Use bit manipulation for subsets

**Complexity:**
- ⏱️ Typically exponential: O(2^n) or O(n!)
- 💾 Space for recursion and results
- 🎯 Focus on pruning to make tractable

**Recognition:**
- "Generate all..."
- "Count ways to..."
- "Find all combinations/permutations..."
- Constraints on arrangements

**Remember:** Combinatorial problems explore exponentially large spaces. The key is intelligent pruning and efficient generation to make them tractable!

---

## 📚 Related Topics

- [Backtracking Fundamentals](./29_BACKTRACKING.md) - Core technique
- [Dynamic Programming](./24_DYNAMIC_PROGRAMMING_BASICS.md) - For counting optimizations
- [Bit Manipulation](./33_BIT_MANIPULATION.md) - For subset generation
- [Recursion](./02_PROBLEM_SOLVING_PATTERNS.md) - Foundation
- [Graph Traversals](./20_GRAPH_TRAVERSALS.md) - Similar exploration
