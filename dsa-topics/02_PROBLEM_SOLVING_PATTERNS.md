# Problem-Solving Patterns

## 📖 Overview

Recognizing patterns is crucial for solving interview problems efficiently. This guide covers the most common problem-solving patterns that appear in technical interviews.

---

## 🎯 Pattern 1: Two Pointers

### When to Use
- Problems involving sorted arrays or lists
- Finding pairs or triplets
- Palindrome checking
- Removing duplicates
- Partitioning arrays

### How It Works

Two pointers move through the data structure from different positions:
- **Opposite Direction**: Start from both ends, move toward center
- **Same Direction**: Both start from beginning, move at different speeds

### Visual Example: Finding Pair Sum

```
Problem: Find two numbers that sum to target = 15

Array: [1, 3, 5, 7, 9, 11, 13]
        ↑                   ↑
      left                right

Step 1: 1 + 13 = 14 < 15 → Move left pointer right
Array: [1, 3, 5, 7, 9, 11, 13]
           ↑              ↑
         left          right

Step 2: 3 + 13 = 16 > 15 → Move right pointer left
Array: [1, 3, 5, 7, 9, 11, 13]
           ↑          ↑
         left      right

Step 3: 3 + 11 = 14 < 15 → Move left pointer right
Array: [1, 3, 5, 7, 9, 11, 13]
              ↑       ↑
            left    right

Step 4: 5 + 11 = 16 > 15 → Move right pointer left
Array: [1, 3, 5, 7, 9, 11, 13]
              ↑    ↑
            left right

Step 5: 5 + 9 = 14 < 15 → Move left pointer right
Array: [1, 3, 5, 7, 9, 11, 13]
                 ↑  ↑
               left right

Step 6: 7 + 9 = 16 > 15 → Move right pointer left
        Pointers crossed → No solution
```

**Time Complexity**: O(n)  
**Space Complexity**: O(1)

---

## 🪟 Pattern 2: Sliding Window

### When to Use
- Problems involving subarrays or substrings
- Finding maximum/minimum sum of fixed size subarray
- Longest/shortest substring with certain properties
- Problems requiring contiguous elements

### How It Works

Maintain a window of elements and slide it through the array:
- **Fixed Size Window**: Window size remains constant
- **Dynamic Size Window**: Window expands and contracts

### Visual Example: Maximum Sum Subarray

```
Problem: Find maximum sum of any subarray of size 3

Array: [2, 1, 5, 1, 3, 2]
Window Size: 3

Step 1: Window = [2, 1, 5], Sum = 8
Array: [2, 1, 5, 1, 3, 2]
        └──┬──┘
         window

Step 2: Slide right, Window = [1, 5, 1], Sum = 7
Array: [2, 1, 5, 1, 3, 2]
           └──┬──┘
            window
Remove 2, Add 1

Step 3: Slide right, Window = [5, 1, 3], Sum = 9 ✓ (Maximum)
Array: [2, 1, 5, 1, 3, 2]
              └──┬──┘
               window
Remove 1, Add 3

Step 4: Slide right, Window = [1, 3, 2], Sum = 6
Array: [2, 1, 5, 1, 3, 2]
                 └──┬──┘
                  window
Remove 5, Add 2

Result: Maximum sum = 9
```

**Time Complexity**: O(n)  
**Space Complexity**: O(1)

### Dynamic Window Example

```
Problem: Smallest subarray with sum ≥ 7

Array: [2, 1, 5, 2, 3, 2]

Step 1: Expand window until sum ≥ 7
[2, 1, 5] → Sum = 8 ≥ 7 ✓
 └──┬──┘
  window (size 3)

Step 2: Try to shrink from left
[1, 5] → Sum = 6 < 7 ✗
 └─┬─┘
 window

Step 3: Keep [2, 1, 5] and continue...
Eventually find [5, 2] → Sum = 7 ✓
                └─┬─┘
              window (size 2) - Smaller!

Result: Minimum length = 2
```

---

## 🔄 Pattern 3: Fast & Slow Pointers (Floyd's Cycle Detection)

### When to Use
- Detecting cycles in linked lists or arrays
- Finding middle element of linked list
- Finding cycle entry point
- Problems involving circular data structures

### How It Works

Two pointers move at different speeds:
- **Slow Pointer**: Moves one step at a time
- **Fast Pointer**: Moves two steps at a time

### Visual Example: Cycle Detection

```
Linked List with Cycle:
1 → 2 → 3 → 4 → 5
        ↑       ↓
        8 ← 7 ← 6

Initial:
Slow: 1, Fast: 1

Step 1:
Slow: 2 (move 1 step)
Fast: 3 (move 2 steps)

Step 2:
Slow: 3
Fast: 5

Step 3:
Slow: 4
Fast: 7

Step 4:
Slow: 5
Fast: 4

Step 5:
Slow: 6
Fast: 6 ✓ (They meet! Cycle detected)

Visual:
       S,F
        ↓
1 → 2 → 3 → 4 → 5
        ↑       ↓
        8 ← 7 ← 6
```

**Time Complexity**: O(n)  
**Space Complexity**: O(1)

---

## 🔀 Pattern 4: Merge Intervals

### When to Use
- Overlapping intervals problems
- Scheduling conflicts
- Range merging
- Calendar/meeting room problems

### How It Works

1. Sort intervals by start time
2. Iterate and merge overlapping intervals
3. Add non-overlapping intervals to result

### Visual Example

```
Problem: Merge overlapping intervals

Input: [[1,3], [2,6], [8,10], [15,18]]

Step 1: Already sorted by start time
Intervals:
1───3
  2─────6
         8──10
                15───18

Step 2: Merge [1,3] and [2,6] (they overlap)
Result: [1,6]
1─────────6
         8──10
                15───18

Step 3: [8,10] doesn't overlap with [1,6]
Add separately
Result: [1,6], [8,10]
1─────────6
         8──10
                15───18

Step 4: [15,18] doesn't overlap
Result: [1,6], [8,10], [15,18]
1─────────6
         8──10
                15───18

Final: [[1,6], [8,10], [15,18]]
```

**Time Complexity**: O(n log n) - for sorting  
**Space Complexity**: O(n) - for output

---

## 🔝 Pattern 5: Top K Elements

### When to Use
- Finding K largest/smallest elements
- K most frequent elements
- K closest points
- Priority-based problems

### How It Works

Use a **Min Heap** (for K largest) or **Max Heap** (for K smallest):
1. Maintain heap of size K
2. For each element, compare with heap root
3. Replace if necessary

### Visual Example: K Largest Elements

```
Problem: Find 3 largest numbers in [3, 2, 1, 5, 6, 4]
K = 3

Min Heap (stores K largest elements, smallest at top):

Step 1: Add 3
Heap: [3]

Step 2: Add 2
Heap: [2, 3]
       2
        \
         3

Step 3: Add 1
Heap: [1, 2, 3]
       1
      / \
     2   3

Step 4: Add 5
Compare 5 > 1 (heap root)
Remove 1, Add 5
Heap: [2, 3, 5]
       2
      / \
     3   5

Step 5: Add 6
Compare 6 > 2 (heap root)
Remove 2, Add 6
Heap: [3, 5, 6]
       3
      / \
     5   6

Step 6: Add 4
Compare 4 > 3 (heap root)
Remove 3, Add 4
Heap: [4, 5, 6]
       4
      / \
     5   6

Result: [4, 5, 6]
```

**Time Complexity**: O(n log k)  
**Space Complexity**: O(k)

---

## 🔍 Pattern 6: Modified Binary Search

### When to Use
- Sorted or rotated sorted arrays
- Finding elements in sorted data
- Optimization problems with monotonic property
- Search space can be reduced by half

### How It Works

Adapt binary search for different scenarios:
- Search in rotated array
- Find peak element
- Search in 2D matrix
- Find first/last occurrence

### Visual Example: Rotated Sorted Array

```
Problem: Find target = 6 in rotated array [4, 5, 6, 7, 0, 1, 2]

Original sorted: [0, 1, 2, 4, 5, 6, 7]
Rotated at index 4: [4, 5, 6, 7, 0, 1, 2]

Step 1: Find middle
Array: [4, 5, 6, 7, 0, 1, 2]
        L     M        R
mid = 7

Step 2: Determine which half is sorted
Left half [4, 5, 6, 7] is sorted
Right half [0, 1, 2] is not sorted

Step 3: Check if target in sorted half
Target 6 is in range [4, 7] → Search left half

Step 4: Binary search in [4, 5, 6, 7]
Array: [4, 5, 6, 7]
        L  M     R
mid = 5

Step 5: 6 > 5 → Search right half
Array: [6, 7]
        L,M R
mid = 6 ✓ Found!
```

**Time Complexity**: O(log n)  
**Space Complexity**: O(1)

---

## 🌳 Pattern 7: Tree BFS (Level Order Traversal)

### When to Use
- Level-by-level tree traversal
- Finding shortest path in tree
- Level order problems
- Zigzag traversal

### How It Works

Use a **queue** to process nodes level by level:
1. Add root to queue
2. Process all nodes at current level
3. Add children to queue for next level

### Visual Example

```
Tree:
        1
       / \
      2   3
     / \   \
    4   5   6

Level Order Traversal:

Initial: Queue = [1]
Level 0: 
Process 1, Add children 2, 3
Queue = [2, 3]
Result = [1]

Level 1:
Process 2, Add children 4, 5
Queue = [3, 4, 5]
Process 3, Add child 6
Queue = [4, 5, 6]
Result = [1, 2, 3]

Level 2:
Process 4 (no children)
Queue = [5, 6]
Process 5 (no children)
Queue = [6]
Process 6 (no children)
Queue = []
Result = [1, 2, 3, 4, 5, 6]

By levels: [[1], [2, 3], [4, 5, 6]]
```

**Time Complexity**: O(n)  
**Space Complexity**: O(n)

---

## 🌳 Pattern 8: Tree DFS (Depth-First Search)

### When to Use
- Path-related problems
- Tree height/depth calculation
- Subtree problems
- Backtracking in trees

### Three Types

1. **Pre-order**: Root → Left → Right
2. **In-order**: Left → Root → Right
3. **Post-order**: Left → Right → Root

### Visual Example

```
Tree:
        1
       / \
      2   3
     / \
    4   5

Pre-order (Root → Left → Right):
Visit 1 → Go left
Visit 2 → Go left
Visit 4 → Backtrack
Go right
Visit 5 → Backtrack
Go right
Visit 3
Result: [1, 2, 4, 5, 3]

Visual Path:
1(visit) → 2(visit) → 4(visit) → back → 5(visit) → back → 3(visit)

In-order (Left → Root → Right):
Go left
Go left
Visit 4 → Backtrack
Visit 2 → Go right
Visit 5 → Backtrack
Visit 1 → Go right
Visit 3
Result: [4, 2, 5, 1, 3]

Post-order (Left → Right → Root):
Go left
Go left
Visit 4 → Backtrack
Go right
Visit 5 → Backtrack
Visit 2 → Backtrack
Go right
Visit 3 → Backtrack
Visit 1
Result: [4, 5, 2, 3, 1]
```

**Time Complexity**: O(n)  
**Space Complexity**: O(h) where h is height

---

## 🎒 Pattern 9: Dynamic Programming

### When to Use
- Optimization problems (maximize/minimize)
- Counting problems
- Problems with overlapping subproblems
- Problems with optimal substructure

### Two Approaches

1. **Top-Down (Memoization)**: Recursive with caching
2. **Bottom-Up (Tabulation)**: Iterative with table

### Visual Example: Climbing Stairs

```
Problem: How many ways to climb n=5 stairs (1 or 2 steps at a time)?

Decision Tree (without DP):
                     5
                  /    \
               4         3
             /  \      /   \
           3     2    2     1
          / \   / \  / \    |
         2  1  1  0 1  0    0
        / \
       1  0

Many repeated calculations! (e.g., ways(3) computed multiple times)

Bottom-Up DP Table:
Position:  0   1   2   3   4   5
Ways:      1   1   2   3   5   8

Logic:
ways[0] = 1 (base case: 0 steps)
ways[1] = 1 (only one way: single step)
ways[2] = ways[0] + ways[1] = 2 (two 1-steps OR one 2-step)
ways[3] = ways[1] + ways[2] = 3
ways[4] = ways[2] + ways[3] = 5
ways[5] = ways[3] + ways[4] = 8

Formula: ways[i] = ways[i-1] + ways[i-2]

Visual paths for n=3:
1. (1→1→1)
2. (1→2)
3. (2→1)
Total: 3 ways ✓
```

**Time Complexity**: O(n)  
**Space Complexity**: O(n) or O(1) with optimization

---

## 🌲 Pattern 10: Backtracking

### When to Use
- Generating combinations/permutations
- Solving constraint satisfaction problems
- Exploring all possible solutions
- Sudoku, N-Queens, etc.

### How It Works

Explore all possibilities with:
1. **Choose**: Make a choice
2. **Explore**: Recursively explore
3. **Unchoose**: Backtrack and try next choice

### Visual Example: Generate Subsets

```
Problem: Generate all subsets of [1, 2, 3]

Decision Tree:
                        []
                    /       \
              [1]              []
            /     \          /    \
        [1,2]    [1]      [2]     []
        /   \    /  \    /  \    /  \
    [1,2,3][1,2][1,3][1][2,3][2][3][]

At each element, we have 2 choices:
✓ Include it
✗ Exclude it

Step-by-step:
Start: []
├─ Include 1: [1]
│  ├─ Include 2: [1,2]
│  │  ├─ Include 3: [1,2,3] ✓
│  │  └─ Exclude 3: [1,2] ✓
│  └─ Exclude 2: [1]
│     ├─ Include 3: [1,3] ✓
│     └─ Exclude 3: [1] ✓
└─ Exclude 1: []
   ├─ Include 2: [2]
   │  ├─ Include 3: [2,3] ✓
   │  └─ Exclude 3: [2] ✓
   └─ Exclude 2: []
      ├─ Include 3: [3] ✓
      └─ Exclude 3: [] ✓

Result: [[], [1], [2], [3], [1,2], [1,3], [2,3], [1,2,3]]
```

**Time Complexity**: O(2ⁿ)  
**Space Complexity**: O(n) for recursion depth

---

## 🎯 Pattern Selection Guide

### Quick Reference Table

| Problem Type | Pattern | Key Indicator |
|--------------|---------|---------------|
| Pair with target sum | Two Pointers | Sorted array |
| Subarray sum | Sliding Window | Contiguous elements |
| Cycle in linked list | Fast & Slow Pointers | Linked list cycle |
| Overlapping ranges | Merge Intervals | Intervals/ranges |
| K largest/smallest | Top K Elements | Find top/bottom K |
| Search in sorted | Binary Search | Sorted/rotated array |
| Level-wise tree | Tree BFS | Level order |
| All paths in tree | Tree DFS | Path problems |
| Optimization problem | Dynamic Programming | Optimal substructure |
| All combinations | Backtracking | Generate all solutions |

---

## 💡 Interview Tips

### 1. Identify the Pattern Early
- Ask clarifying questions
- Look for keywords (sorted, pairs, subarray, all combinations)
- Recognize the data structure

### 2. Explain Your Pattern Choice
- "This looks like a sliding window problem because..."
- "I'll use two pointers since the array is sorted..."
- Shows deep understanding

### 3. Discuss Alternatives
- "We could use brute force O(n²), but two pointers gives us O(n)"
- Demonstrates problem-solving versatility

### 4. Draw Visual Examples
- Sketch the process on paper/whiteboard
- Walk through with small examples
- Helps interviewer follow your logic

---

## 🎓 Practice Strategy

1. **Learn one pattern at a time**
2. **Solve 10-15 problems per pattern**
3. **Mix patterns after mastering individually**
4. **Time yourself to build speed**
5. **Explain solutions aloud for communication practice**

---

## 📚 Next Topic

Continue to [Arrays](./03_ARRAYS.md) to learn array manipulation techniques in detail.
