# Arrays

## 📖 Overview

Arrays are the most fundamental data structure, storing elements in contiguous memory locations. Mastering array manipulation is essential for interview success.

---

## 🔍 Array Basics

### What is an Array?

An array is a collection of elements stored at contiguous memory locations, accessed using an index.

```
Visual Representation:
Index:   0    1    2    3    4
       ┌────┬────┬────┬────┬────┐
Array: │ 10 │ 20 │ 30 │ 40 │ 50 │
       └────┴────┴────┴────┴────┘
Memory: ↑ Each element at sequential address
```

### Properties

- **Fixed Size**: Size determined at creation (in most languages)
- **Random Access**: O(1) access time using index
- **Contiguous Memory**: Elements stored sequentially
- **Same Data Type**: All elements of same type

### Time Complexities

| Operation | Time Complexity |
|-----------|----------------|
| Access by index | O(1) |
| Search (unsorted) | O(n) |
| Search (sorted) | O(log n) with binary search |
| Insert at end | O(1) amortized |
| Insert at beginning | O(n) |
| Insert in middle | O(n) |
| Delete from end | O(1) |
| Delete from beginning | O(n) |
| Delete from middle | O(n) |

---

## 🎯 Common Array Patterns

### 1. Prefix Sum

**Concept**: Pre-compute cumulative sums for efficient range queries.

**Visual Example**:
```
Original Array: [2, 4, 6, 8, 10]

Prefix Sum Array:
Index:  0   1   2   3    4
       ┌───┬───┬───┬────┬────┐
       │ 2 │ 6 │12 │ 20 │ 30 │
       └───┴───┴───┴────┴────┘
        ↑   ↑   ↑    ↑     ↑
        2  2+4 6+6  12+8  20+10

Query: Sum of elements from index 1 to 3
Direct calculation: 4 + 6 + 8 = 18
Using prefix sum: prefix[3] - prefix[0] = 20 - 2 = 18

Visual:
[2, 4, 6, 8, 10]
    └──┬──┘
    range sum

Without prefix: O(n) per query
With prefix: O(1) per query (after O(n) preprocessing)
```

**Use Cases**:
- Range sum queries
- Finding subarray with given sum
- Equilibrium index problems

---

### 2. Kadane's Algorithm (Maximum Subarray Sum)

**Concept**: Find contiguous subarray with maximum sum.

**Visual Example**:
```
Array: [-2, 1, -3, 4, -1, 2, 1, -5, 4]

Track two values at each position:
- current_sum: max sum ending at current position
- max_sum: overall maximum

Step-by-step:
Index:  -2   1   -3   4   -1   2   1   -5   4
       ┌───┬───┬────┬───┬────┬───┬───┬────┬───┐
curr:  │-2 │ 1 │ -2 │ 4 │  3 │ 5 │ 6 │  1 │ 5 │
max:   │-2 │ 1 │  1 │ 4 │  4 │ 5 │ 6 │  6 │ 6 │
       └───┴───┴────┴───┴────┴───┴───┴────┴───┘

At each step:
current_sum = max(element, current_sum + element)
max_sum = max(max_sum, current_sum)

Visual of maximum subarray:
[-2, 1, -3, 4, -1, 2, 1, -5, 4]
            └────┬────┘
         sum = 6 (maximum)

Key Insight: If current_sum becomes negative, 
reset to 0 (start fresh from next element)
```

**Time Complexity**: O(n)  
**Space Complexity**: O(1)

---

### 3. Dutch National Flag (3-Way Partitioning)

**Concept**: Sort array with three distinct values.

**Visual Example**:
```
Problem: Sort [2, 0, 2, 1, 1, 0] where values are 0, 1, 2

Three pointers:
- low: boundary for 0s
- mid: current element
- high: boundary for 2s

Initial:
[2, 0, 2, 1, 1, 0]
 ↑              ↑
low,mid        high

Step 1: mid=2, swap with high
[0, 0, 2, 1, 1, 2]
 ↑           ↑  ↑
low,mid    high

Step 2: mid=0, swap with low
[0, 0, 2, 1, 1, 2]
    ↑        ↑  ↑
   low,mid  high

Step 3: mid=2, swap with high
[0, 0, 1, 1, 2, 2]
    ↑     ↑  ↑
   low   mid high

Step 4: mid=1, just move mid
[0, 0, 1, 1, 2, 2]
    ↑        ↑
   low    mid,high

Final sorted: [0, 0, 1, 1, 2, 2]

Visual regions:
[0s | 1s | unsorted | 2s]
 ↑    ↑      ↑        ↑
low  mid   current  high
```

**Time Complexity**: O(n)  
**Space Complexity**: O(1)

---

### 4. Moore's Voting Algorithm (Majority Element)

**Concept**: Find element appearing more than n/2 times.

**Visual Example**:
```
Array: [7, 7, 5, 7, 5, 1, 5, 7, 5, 5, 7, 7, 7]

Track: candidate and count

Process:
[7, 7, 5, 7, 5, 1, 5, 7, 5, 5, 7, 7, 7]
 ↑
candidate=7, count=1

[7, 7, 5, 7, 5, 1, 5, 7, 5, 5, 7, 7, 7]
    ↑
candidate=7, count=2

[7, 7, 5, 7, 5, 1, 5, 7, 5, 5, 7, 7, 7]
       ↑
candidate=7, count=1 (decremented, different element)

Continue process...

Visual voting:
7: ↑
7: ↑↑
5: ↑↓
7: ↑↑
5: ↑↓
1: ↓
5: ↑↓
7: ↑↑
5: ↑↓
5: ↑
7: ↑↑
7: ↑↑↑
7: ↑↑↑↑

Final candidate: 7
Count occurrences: 7 appears 7 times > 13/2 ✓

Key Insight: Majority element (>n/2) will always 
survive the cancellation process
```

**Time Complexity**: O(n)  
**Space Complexity**: O(1)

---

## 🔄 Array Rotation

### Left Rotation

**Concept**: Shift elements to the left by k positions.

**Visual Example**:
```
Array: [1, 2, 3, 4, 5, 6, 7]
Rotate left by 3

Method 1: Reversal Algorithm

Step 1: Reverse first k elements
[3, 2, 1, 4, 5, 6, 7]
 └──┬──┘
 reversed

Step 2: Reverse remaining elements
[3, 2, 1, 7, 6, 5, 4]
          └────┬────┘
          reversed

Step 3: Reverse entire array
[4, 5, 6, 7, 1, 2, 3]
└─────────┬─────────┘
    reversed

Visual transformation:
Original: [1, 2, 3, | 4, 5, 6, 7]
                ↓
Result:   [4, 5, 6, 7, | 1, 2, 3]
```

**Time Complexity**: O(n)  
**Space Complexity**: O(1)

---

## 🔀 Rearrangement Problems

### 1. Rearrange Positive and Negative Numbers

**Visual Example**:
```
Problem: Rearrange so positives and negatives alternate

Input: [1, 2, 3, -4, -1, 4]
Output: [-4, 1, -1, 2, 3, 4] or any valid alternating arrangement

Approach: Separate then merge
Step 1: Separate
Positive: [1, 2, 3, 4]
Negative: [-4, -1]

Step 2: Merge alternately
Result: [-4, 1, -1, 2, 3, 4]
         ↑   ↑   ↑  ↑  ↑  ↑
         N   P   N  P  P  P

Visual pattern:
Index: 0  1  2  3  4  5
      [N][P][N][P][P][P]
```

### 2. Move Zeros to End

**Visual Example**:
```
Input: [0, 1, 0, 3, 12]

Use two pointers:
- i: traverse array
- nonZero: position for next non-zero

Step 1:
[0, 1, 0, 3, 12]
 ↑  ↑
nZ  i
1 is non-zero, place at nonZero position

Step 2:
[1, 0, 0, 3, 12]
    ↑     ↑
   nZ     i
3 is non-zero, place at nonZero position

Step 3:
[1, 3, 0, 0, 12]
       ↑      ↑
      nZ      i
12 is non-zero, place at nonZero position

Final:
[1, 3, 12, 0, 0]
           └─┬─┘
          zeros
```

**Time Complexity**: O(n)  
**Space Complexity**: O(1)

---

## 🔍 Searching in Arrays

### 1. Binary Search Variations

**Find First Occurrence**:
```
Array: [1, 2, 2, 2, 3, 4, 5]
Find first occurrence of 2

Regular Binary Search finds any 2:
[1, 2, 2, 2, 3, 4, 5]
       ↑
    might find this

Modified Binary Search finds first 2:
[1, 2, 2, 2, 3, 4, 5]
    ↑
  finds this

Logic: When found, continue searching left half
until we can't find anymore

Visual:
Step 1: mid=3 (value=2) ✓ but continue left
Step 2: mid=1 (value=2) ✓ but continue left
Step 3: mid=0 (value=1) ✗ stop
Result: First occurrence at index 1
```

### 2. Search in Rotated Sorted Array

**Visual Example**:
```
Array: [4, 5, 6, 7, 0, 1, 2]
Find: 0

The array is sorted then rotated:
Original: [0, 1, 2, 4, 5, 6, 7]
Rotated:  [4, 5, 6, 7, 0, 1, 2]
                      ↑
                rotation point

Binary search with modification:
Step 1: mid=3 (value=7)
[4, 5, 6, 7, | 0, 1, 2]
         ↑
        mid

Left half [4,5,6,7] is sorted
Right half [0,1,2] contains rotation point
Target 0 not in sorted half → search right

Step 2: mid=5 (value=1)
[0, 1, 2]
    ↑
   mid

Step 3: Found at index 4
[4, 5, 6, 7, 0, 1, 2]
             ↑
          target
```

**Time Complexity**: O(log n)  
**Space Complexity**: O(1)

---

## 🎭 Subarray Problems

### 1. Longest Subarray with Sum K

**Visual Example**:
```
Array: [1, 2, 3, 4, 5]
K = 9

Using Sliding Window (for positive numbers only):

Window expands and contracts:

Step 1: [1, 2, 3, 4] sum=10 > 9
         └────┬────┘
          window

Step 2: [2, 3, 4] sum=9 ✓ length=3
         └──┬──┘
        window

Step 3: [3, 4] sum=7 < 9
         └─┬┘
        window

Step 4: [3, 4, 5] sum=12 > 9
         └──┬──┘
        window

Step 5: [4, 5] sum=9 ✓ length=2
         └─┬┘
        window

Visual of valid subarrays:
[1, 2, 3, 4, 5]
    └──┬──┘        length=3 (maximum)
       └─┬┘        length=2

Result: Maximum length = 3
```

### 2. Subarray with Given Sum

**Visual Example**:
```
Array: [1, 4, 20, 3, 10, 5]
Target Sum: 33

Use prefix sum + hash map:

Index:  0   1   2    3    4    5
Array: [1,  4, 20,  3,  10,  5]
Prefix:[1,  5, 25, 28,  38, 43]

Looking for sum = 33:
At index 4 (prefix=38):
  Check if (38-33=5) exists in map
  Yes! At index 1
  Subarray: indices 2 to 4

Visual:
[1, 4, 20, 3, 10, 5]
       └────┬────┘
    sum = 20+3+10 = 33 ✓

Hash map tracks:
{0: -1, 1: 0, 5: 1, 25: 2, 28: 3, 38: 4}
        ↑
    needed for sum from start
```

**Time Complexity**: O(n)  
**Space Complexity**: O(n)

---

## 🔢 Matrix (2D Array)

### Common Operations

**1. Spiral Traversal**:
```
Matrix:
1  2  3  4
5  6  7  8
9  10 11 12

Spiral order: [1,2,3,4,8,12,11,10,9,5,6,7]

Visual path:
→ → → ↓
↑ → ↓ ↓
↑ ← ← ↓

Step-by-step:
1. Right: [1, 2, 3, 4]
2. Down:  [8, 12]
3. Left:  [11, 10, 9]
4. Up:    [5]
5. Right: [6, 7]

Four boundaries:
top = 0, bottom = 2
left = 0, right = 3

Shrink boundaries after each direction
```

**2. Rotate Matrix 90° Clockwise**:
```
Original:
1  2  3
4  5  6
7  8  9

Rotated 90° clockwise:
7  4  1
8  5  2
9  6  3

Two-step approach:

Step 1: Transpose (swap across diagonal)
1  4  7
2  5  8
3  6  9

Visual:
1  2  3      1  4  7
4  5  6  →   2  5  8
7  8  9      3  6  9
   ↑ ↑
swap(i,j) with (j,i)

Step 2: Reverse each row
7  4  1
8  5  2
9  6  3

Visual:
1  4  7      7  4  1
2  5  8  →   8  5  2
3  6  9      9  6  3
← reverse →
```

**3. Set Matrix Zeros**:
```
Problem: If element is 0, set entire row and column to 0

Input:
1  1  1
1  0  1
1  1  1

Output:
1  0  1
0  0  0
1  0  1

Approach: Use first row/column as markers

Visual:
1. Mark affected rows/columns
   0  1  1
   1  0  1  ← row has 0
   1  1  1
   ↑
   col has 0

2. Use markers to set zeros
   0  0  0
   0  0  0
   0  0  1
```

**Time Complexity**: O(m × n)  
**Space Complexity**: O(1)

---

## 💡 Interview Tips

### Common Mistakes to Avoid

1. **Off-by-one errors**: Carefully handle array boundaries
2. **Modifying while iterating**: Use separate pointers or iterate backwards
3. **Not handling edge cases**: Empty array, single element, all same elements
4. **Integer overflow**: Be careful with sum calculations

### Optimization Techniques

1. **Two Pointers**: Reduce O(n²) to O(n)
2. **Hash Map**: Trade space for time
3. **Prefix Sum**: Optimize range queries
4. **In-place Operations**: Reduce space complexity

### Problem-Solving Steps

1. **Clarify constraints**: Array size, value range, duplicates allowed?
2. **Consider edge cases**: Empty, single element, all same
3. **Start with brute force**: Get a working solution first
4. **Optimize**: Use patterns to improve complexity
5. **Test with examples**: Walk through your solution

---

## 🎯 Key Takeaways

1. **Arrays provide O(1) access** but costly insertions/deletions
2. **Two pointers technique** is powerful for array problems
3. **Prefix sum** enables O(1) range queries
4. **In-place algorithms** save space but require careful implementation
5. **Matrix problems** often use boundary tracking
6. **Hash maps complement arrays** for many optimization problems

---

## 📚 Next Topic

Continue to [Strings](./04_STRINGS.md) to learn string manipulation techniques.
