# Binary Search & Variants

## 📋 Overview

**Binary Search** is one of the most fundamental and efficient search algorithms that works on sorted data. It repeatedly divides the search space in half, achieving logarithmic time complexity. Mastering binary search and its variants is essential for technical interviews, as it appears in numerous problem variations.

**Difficulty Level**: 🟡 Intermediate

---

## 🎯 Core Concept

### The Big Idea

Instead of checking every element linearly, binary search eliminates half of the remaining elements with each comparison.

**Analogy**: Like finding a word in a dictionary - you open to the middle, determine if the word is before or after, and repeat with the relevant half.

### Why It's Powerful

- **Speed**: O(log n) instead of O(n)
- **Predictability**: Consistent performance
- **Versatility**: Many problems can be converted to binary search

---

## 🔍 Basic Binary Search

### Concept

Search for a target value in a sorted array by repeatedly dividing the search interval in half.

### Visual Process

```
Array: [1, 3, 5, 7, 9, 11, 13, 15, 17, 19]
Target: 11

Step 1: Check middle
[1, 3, 5, 7, 9, 11, 13, 15, 17, 19]
 0  1  2  3  4   5   6   7   8   9  (indices)
 L              M                  R

Middle = (0 + 9) / 2 = 4
arr[4] = 9
9 < 11, search right half

Step 2: Search [11, 13, 15, 17, 19]
[1, 3, 5, 7, 9, 11, 13, 15, 17, 19]
                L   M           R
                5   7           9

Middle = (5 + 9) / 2 = 7
arr[7] = 15
15 > 11, search left half

Step 3: Search [11, 13]
[1, 3, 5, 7, 9, 11, 13, 15, 17, 19]
                L,M  R
                5    6

Middle = (5 + 6) / 2 = 5
arr[5] = 11
11 == 11, FOUND at index 5!
```

### Search Space Reduction

```
Initial: 10 elements
After comparison 1: 5 elements (50% eliminated)
After comparison 2: 2 elements (75% eliminated)
After comparison 3: 1 element (FOUND)

Total comparisons: 3 = log₂(10)
```

---

## 🎨 Binary Search Variations

### 1. Find First Occurrence

**Problem**: Find the first (leftmost) occurrence of target in array with duplicates.

```
Array: [1, 2, 2, 2, 3, 4, 5]
Target: 2

Standard binary search might return any 2
First occurrence should return index 1

Step 1: Find a 2
[1, 2, 2, 2, 3, 4, 5]
 L        M        R
         
arr[3] = 2, FOUND

Step 2: Continue searching left to find first
[1, 2, 2, 2, 3, 4, 5]
 L     M  R
 
arr[1] = 2, FOUND
Update result, continue left

Step 3: Continue
[1, 2, 2, 2, 3, 4, 5]
 L,M R

arr[0] = 1 ≠ 2
Left exhausted

First occurrence: index 1
```

### 2. Find Last Occurrence

**Problem**: Find the last (rightmost) occurrence of target.

```
Array: [1, 2, 2, 2, 3, 4, 5]
Target: 2

Step 1: Find a 2
[1, 2, 2, 2, 3, 4, 5]
 L        M        R
         
arr[3] = 2, FOUND

Step 2: Continue searching right to find last
[1, 2, 2, 2, 3, 4, 5]
          L  M     R
 
arr[5] = 4 > 2
Search left

Step 3: Narrow down
[1, 2, 2, 2, 3, 4, 5]
          L,M R
 
arr[3] = 2, update result

Last occurrence: index 3
```

### 3. Find Insert Position

**Problem**: Find position where target should be inserted to maintain sorted order.

```
Array: [1, 3, 5, 7, 9]
Target: 6

Step 1: Standard binary search
[1, 3, 5, 7, 9]
 L     M     R

arr[2] = 5 < 6, search right

Step 2: 
[1, 3, 5, 7, 9]
          L,M R

arr[3] = 7 > 6, search left

Step 3: Left > Right, stop
L = 3, this is insert position

Result: Insert at index 3
[1, 3, 5, 6, 7, 9]
          ↑
       index 3
```

### 4. Find Floor and Ceiling

**Floor**: Largest element ≤ target
**Ceiling**: Smallest element ≥ target

```
Array: [1, 3, 5, 7, 9, 11]
Target: 6

Floor of 6:
Elements ≤ 6: [1, 3, 5]
Largest: 5 (at index 2)

Ceiling of 6:
Elements ≥ 6: [7, 9, 11]
Smallest: 7 (at index 3)

Visual:
[1, 3, 5, 6, 7, 9, 11]
       ↑  |  ↑
     floor | ceiling
        (target position)
```

---

## 🔄 Search in Modified Arrays

### 1. Search in Rotated Sorted Array

**Problem**: Array was sorted, then rotated at some pivot.

```
Original: [1, 2, 3, 4, 5, 6, 7]
Rotated:  [4, 5, 6, 7, 1, 2, 3]
          (rotated at index 4)

Target: 2

Key Insight: One half is always sorted

Step 1: Check middle
[4, 5, 6, 7, 1, 2, 3]
 L        M        R
 
arr[3] = 7
Target = 2

Left half [4,5,6,7] is sorted (4 < 7)
Is target in left sorted half? 4 ≤ 2 ≤ 7? NO
Search right half

Step 2: Search [1, 2, 3]
[4, 5, 6, 7, 1, 2, 3]
             L  M  R
 
arr[5] = 2
2 == 2, FOUND at index 5!
```

**Visual Representation**:
```
        7
       /
      6
     /
    5
   /
  4
   \
    1
     \
      2
       \
        3

Rotation creates two sorted subarrays
```

### 2. Find Minimum in Rotated Array

```
Array: [4, 5, 6, 7, 1, 2, 3]

The minimum is where rotation happened

Step 1: Check middle
[4, 5, 6, 7, 1, 2, 3]
 L        M        R

arr[3] = 7
arr[6] = 3

7 > 3, minimum is in right half
(if middle > right, minimum is on right)

Step 2: Search right
[4, 5, 6, 7, 1, 2, 3]
             L  M  R

arr[5] = 2
arr[6] = 3

2 < 3, minimum is in left half

Step 3: Narrow down
[4, 5, 6, 7, 1, 2, 3]
             L,M R

arr[4] = 1
arr[5] = 2

Minimum: 1 at index 4
```

### 3. Find Peak Element

**Peak**: Element greater than its neighbors

```
Array: [1, 3, 8, 12, 4, 2]

Peaks: 12 (arr[3])

Step 1: Check middle
[1, 3, 8, 12, 4, 2]
 L        M      R

arr[2] = 8
arr[3] = 12

8 < 12, ascending slope
Peak must be on right
(move toward increasing direction)

Step 2: Search right
[1, 3, 8, 12, 4, 2]
          L   M  R

arr[3] = 12
arr[4] = 4

12 > 4, descending slope
Peak is at index 3

Found: 12 at index 3
```

**Visual**:
```
        12 ← Peak
       /  \
      8    4
     /      \
    3        2
   /
  1

Binary search follows the slope upward
```

---

## 🎯 Binary Search on Answer Space

### Concept

Sometimes the answer itself can be binary searched, not just array indices. Define a search space of possible answers and find the optimal one.

### 1. Square Root (Integer)

**Problem**: Find √n (integer part)

```
Find √10

Search space: [0, 10]

Step 1: Check middle
[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
 L              M               R

mid = 5
5² = 25 > 10
Search left

Step 2: Search [0, 4]
[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
 L        M  R

mid = 2
2² = 4 < 10
Update answer = 2
Search right

Step 3: Search [3, 4]
[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
          L  M  R

mid = 3
3² = 9 < 10
Update answer = 3
Search right

Step 4: Search [4, 4]
[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
             L,M,R

mid = 4
4² = 16 > 10
Search left (exhausted)

Answer: 3 (since 3² = 9 ≤ 10 < 16 = 4²)
```

### 2. Capacity to Ship Packages

**Problem**: Ship packages in D days. Find minimum ship capacity.

```
Packages: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
Days: 5

Search space: [max(packages), sum(packages)]
            = [10, 55]

Need capacity such that all packages fit in 5 days

Step 1: Try capacity = 32
Day 1: 1+2+3+4+5+6+7+4 = 32 ✓
Day 2: 5+6+7+8+6 = 32 ✓
...
Can fit in 3 days → capacity too large

Step 2: Try capacity = 20
Day 1: 1+2+3+4+5+5 = 20 ✓
Day 2: 6+7+7 = 20 ✓
Day 3: 8+8 = 16 ✓
Day 4: 9+9 = 18 ✓
Day 5: 10 ✓
Can fit in 5 days → possible, try smaller

Step 3: Try capacity = 15
Day 1: 1+2+3+4+5 = 15 ✓
Day 2: 6+7 = 13 ✓
Day 3: 8 ✓
Day 4: 9 ✓
Day 5: 10 ✓
Day 6: needed! → capacity too small

Answer: 15 (minimum capacity that works)
```

### 3. Koko Eating Bananas

**Problem**: Koko must eat all banana piles in H hours. Find minimum eating speed.

```
Piles: [3, 6, 7, 11]
Hours: 8

Search space: [1, max(piles)] = [1, 11]

Speed = 4:
Pile 1: 3 bananas → ceil(3/4) = 1 hour
Pile 2: 6 bananas → ceil(6/4) = 2 hours
Pile 3: 7 bananas → ceil(7/4) = 2 hours
Pile 4: 11 bananas → ceil(11/4) = 3 hours
Total: 1+2+2+3 = 8 hours ✓

Speed = 3:
Pile 1: ceil(3/3) = 1 hour
Pile 2: ceil(6/3) = 2 hours
Pile 3: ceil(7/3) = 3 hours
Pile 4: ceil(11/3) = 4 hours
Total: 1+2+3+4 = 10 hours > 8 ✗

Answer: 4 (minimum speed to finish in 8 hours)
```

---

## 🌐 Binary Search in 2D

### Search in Row and Column Sorted Matrix

```
Matrix:
[1,  4,  7,  11, 15]
[2,  5,  8,  12, 19]
[3,  6,  9,  16, 22]
[10, 13, 14, 17, 24]
[18, 21, 23, 26, 30]

Target: 14

Strategy: Start from top-right or bottom-left corner

Starting from top-right (15):
[1,  4,  7,  11, 15] ← start here
[2,  5,  8,  12, 19]
[3,  6,  9,  16, 22]
[10, 13, 14, 17, 24]
[18, 21, 23, 26, 30]

15 > 14, move left

[1,  4,  7,  11, 15]
[2,  5,  8,  12, 19]
[3,  6,  9,  16, 22]
[10, 13, 14, 17, 24] ← at 11
[18, 21, 23, 26, 30]

11 < 14, move down

[1,  4,  7,  11, 15]
[2,  5,  8,  12, 19] ← at 12
[3,  6,  9,  16, 22]
[10, 13, 14, 17, 24]
[18, 21, 23, 26, 30]

12 < 14, move down

[1,  4,  7,  11, 15]
[2,  5,  8,  12, 19]
[3,  6,  9,  16, 22] ← at 16
[10, 13, 14, 17, 24]
[18, 21, 23, 26, 30]

16 > 14, move left

[1,  4,  7,  11, 15]
[2,  5,  8,  12, 19]
[3,  6,  9,  16, 22] ← at 9
[10, 13, 14, 17, 24]
[18, 21, 23, 26, 30]

9 < 14, move down

[1,  4,  7,  11, 15]
[2,  5,  8,  12, 19]
[3,  6,  9,  16, 22]
[10, 13, 14, 17, 24] ← at 14, FOUND!
[18, 21, 23, 26, 30]
```

---

## 🎪 Advanced Patterns

### 1. Median of Two Sorted Arrays

```
Array 1: [1, 3, 8, 9, 15]
Array 2: [7, 11, 18, 19, 21, 25]

Combined (conceptually): [1, 3, 7, 8, 9, 11, 15, 18, 19, 21, 25]
Median: 11 (middle element)

Approach: Binary search on smaller array for partition point

Partition Array 1: [1, 3, 8 | 9, 15]
Partition Array 2: [7, 11 | 18, 19, 21, 25]

Left half: [1, 3, 7, 8, 11]
Right half: [9, 15, 18, 19, 21, 25]

Condition: max(left) ≤ min(right)
max(1,3,7,8,11) = 11
min(9,15,18,19,21,25) = 9
11 > 9 ✗

Try different partition...

Partition Array 1: [1, 3 | 8, 9, 15]
Partition Array 2: [7, 11, 18 | 19, 21, 25]

Left half: [1, 3, 7, 11, 18]
Right half: [8, 9, 15, 19, 21, 25]

max(left) = 18
min(right) = 8
18 > 8 ✗

Continue binary search until valid partition found...
```

### 2. Find K Closest Elements

```
Array: [1, 2, 3, 4, 5]
Target: 3
K: 4

Find 4 elements closest to 3

Step 1: Binary search to find position near 3
Position of 3 is index 2

Step 2: Expand window around 3
[1, 2, 3, 4, 5]
    ↑  ↑  ↑  ↑
Window size = 4

Check distances:
|1-3| = 2
|2-3| = 1
|3-3| = 0
|4-3| = 1
|5-3| = 2

Step 3: Use two pointers to find best window
Window [1,2,3,4]: distances sum = 4
Window [2,3,4,5]: distances sum = 5

Result: [1, 2, 3, 4]
```

---

## 💡 Binary Search Template

### General Structure

```
Condition-based binary search:

Initialize: left, right, result
While left ≤ right:
    mid = left + (right - left) / 2
    
    If condition(mid) is true:
        Update result
        Adjust search space (left or right)
    Else:
        Adjust search space (opposite direction)

Return result
```

### Key Decisions

**1. Loop Condition**
- `left < right` vs `left <= right`
- Depends on whether you need to check when they're equal

**2. Mid Calculation**
- `(left + right) / 2` can overflow
- Better: `left + (right - left) / 2`
- Or: `(left + right) >>> 1` (unsigned right shift)

**3. Update Rules**
- `left = mid + 1` vs `left = mid`
- `right = mid - 1` vs `right = mid`
- Depends on whether mid can be answer

**4. Return Value**
- Return `left`, `right`, or stored result
- Depends on problem requirements

---

## 🎯 Problem-Solving Framework

### Step 1: Identify Binary Search

Ask yourself:
- Is data sorted or can it be sorted?
- Can I eliminate half the search space?
- Is there a monotonic property?
- Am I searching for a threshold/boundary?

### Step 2: Define Search Space

- What are the boundaries?
- What are we searching for? (index, value, answer)

### Step 3: Define Search Condition

- How do I decide left vs right?
- What's the invariant?

### Step 4: Handle Edge Cases

- Empty array
- Single element
- Target not found
- Multiple occurrences
- Duplicates

---

## 🎓 Key Takeaways

1. **Binary search requires sorted property** - implicit or explicit
2. **O(log n) is exponentially better** than O(n) for large datasets
3. **Many variations exist** - first, last, insert position, rotated array
4. **Answer space search** - powerful technique for optimization problems
5. **Careful with boundaries** - off-by-one errors are common
6. **Integer overflow** - use `left + (right - left) / 2`
7. **Monotonicity is key** - need some ordering property
8. **Think in terms of eliminating impossible regions**

---

## 💡 Interview Tips

### Common Mistakes

1. **Off-by-one errors** in loop conditions
2. **Integer overflow** in mid calculation
3. **Infinite loops** from incorrect updates
4. **Not considering edge cases** (empty, single element)
5. **Wrong return value** (left vs right vs result)

### Best Practices

1. **Draw diagrams** - visualize search space
2. **Test with small examples** - [1], [1,2], [1,2,3]
3. **Check boundaries** - what happens at edges?
4. **Verify loop invariant** - what's always true?
5. **Consider duplicates** - how does it affect your logic?

### Discussion Points

1. **Time complexity**: O(log n) search
2. **Space complexity**: O(1) iterative vs O(log n) recursive
3. **Stability**: Does it matter for this problem?
4. **Variations**: Could this be first/last occurrence?
5. **Alternative approaches**: Would other data structures work?

---

## 🔗 Related Topics

- [Sorting Algorithms](./31_SORTING.md) - Prerequisite for binary search
- [Arrays](./03_ARRAYS.md) - Primary data structure
- [Two Pointers](./05_TWO_POINTERS_SLIDING_WINDOW.md) - Similar search technique
- [Dynamic Programming](./24_DYNAMIC_PROGRAMMING_BASICS.md) - Optimization problems

---

**Next**: [Bit Manipulation](./33_BIT_MANIPULATION.md)
