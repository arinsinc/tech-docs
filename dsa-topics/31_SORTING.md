# Sorting Algorithms

## 📋 Overview

**Sorting** is the process of arranging elements in a specific order (ascending or descending). Sorting is one of the most fundamental operations in computer science and forms the basis for many efficient algorithms. Understanding different sorting approaches, their trade-offs, and when to use each is essential for technical interviews.

**Difficulty Level**: 🟡 Intermediate

---

## 🎯 Why Sorting Matters

### Real-World Applications

1. **Search Optimization**: Binary search requires sorted data
2. **Data Organization**: File systems, databases, contact lists
3. **Finding Duplicates**: Adjacent duplicates in sorted arrays
4. **Merge Operations**: Combining sorted datasets
5. **Statistical Analysis**: Finding median, percentiles, outliers
6. **Rendering**: Z-ordering in graphics, priority-based rendering

---

## 🔄 Sorting Categories

### By Comparison Type

**Comparison-Based Sorting**
- Compare elements using `<`, `>`, `==` operators
- Lower bound: O(n log n) for worst case
- Examples: Merge Sort, Quick Sort, Heap Sort

**Non-Comparison Sorting**
- Use properties of data (digits, range)
- Can achieve O(n) time complexity
- Examples: Counting Sort, Radix Sort, Bucket Sort

### By Memory Usage

**In-Place Sorting**
- Uses O(1) extra space (excluding input)
- Modifies input array directly
- Examples: Bubble Sort, Selection Sort, Insertion Sort, Quick Sort

**Out-of-Place Sorting**
- Requires additional memory proportional to input
- Creates auxiliary arrays
- Examples: Merge Sort, Counting Sort

### By Stability

**Stable Sorting**
- Maintains relative order of equal elements
- Important for multi-key sorting
- Examples: Merge Sort, Insertion Sort, Bubble Sort

**Unstable Sorting**
- May change relative order of equal elements
- Examples: Quick Sort, Heap Sort, Selection Sort

---

## 🔵 Bubble Sort

### Concept

Repeatedly compare adjacent elements and swap if they're in wrong order. Like bubbles rising to the surface, larger elements "bubble up" to the end.

### Visual Process

```
Initial: [5, 2, 8, 1, 9]

Pass 1: Compare adjacent pairs, swap if needed
[5, 2, 8, 1, 9]
 ↓  ↓  swap
[2, 5, 8, 1, 9]
    ↓  ↓  no swap
[2, 5, 8, 1, 9]
       ↓  ↓  swap
[2, 5, 1, 8, 9]
          ↓  ↓  no swap
[2, 5, 1, 8, 9] ← 9 in final position

Pass 2: Repeat (ignore last element)
[2, 5, 1, 8, 9]
 ↓  ↓  no swap
[2, 5, 1, 8, 9]
    ↓  ↓  swap
[2, 1, 5, 8, 9]
       ↓  ↓  no swap
[2, 1, 5, 8, 9] ← 8 in final position

Pass 3:
[2, 1, 5, 8, 9]
 ↓  ↓  swap
[1, 2, 5, 8, 9] ← 5 in final position

Pass 4:
[1, 2, 5, 8, 9] ← Already sorted!

Final: [1, 2, 5, 8, 9]
```

### Characteristics

- **Time Complexity**: O(n²) average and worst, O(n) best (already sorted)
- **Space Complexity**: O(1)
- **Stability**: Stable
- **In-Place**: Yes
- **Use Case**: Educational purposes, nearly sorted small arrays

---

## 🟢 Selection Sort

### Concept

Find the minimum element in unsorted portion and swap it with the first unsorted element. Builds sorted array one element at a time.

### Visual Process

```
Initial: [5, 2, 8, 1, 9]
         └─ unsorted ─┘

Step 1: Find minimum (1), swap with first
[5, 2, 8, 1, 9]
 ↓        ↑  find min = 1
[1, 2, 8, 5, 9]
 └┘ sorted

Step 2: Find minimum in [2,8,5,9], already at position
[1, 2, 8, 5, 9]
    └─ unsorted ─┘
    ↑  min = 2
[1, 2, 8, 5, 9]
 └──┘ sorted

Step 3: Find minimum (5), swap with first unsorted
[1, 2, 8, 5, 9]
       ↓  ↑  find min = 5
[1, 2, 5, 8, 9]
 └─────┘ sorted

Step 4: Find minimum (8), already at position
[1, 2, 5, 8, 9]
          ↑  min = 8
[1, 2, 5, 8, 9]
 └────────┘ sorted

Final: [1, 2, 5, 8, 9]
```

### Characteristics

- **Time Complexity**: O(n²) for all cases
- **Space Complexity**: O(1)
- **Stability**: Unstable (can be made stable with modifications)
- **In-Place**: Yes
- **Use Case**: Small arrays, when memory writes are expensive

---

## 🟡 Insertion Sort

### Concept

Build sorted array one element at a time by inserting each element into its correct position. Like sorting playing cards in your hand.

### Visual Process

```
Initial: [5, 2, 8, 1, 9]
        [5] ← sorted portion

Step 1: Insert 2 into sorted portion
[5 | 2, 8, 1, 9]
 ↑   ↑
compare 5 > 2, shift right
[_, 5, 8, 1, 9]
 ↑
insert 2
[2, 5 | 8, 1, 9]
 └──┘ sorted

Step 2: Insert 8 into sorted portion
[2, 5 | 8, 1, 9]
       ↑
compare 5 < 8, no shift needed
[2, 5, 8 | 1, 9]
 └─────┘ sorted

Step 3: Insert 1 into sorted portion
[2, 5, 8 | 1, 9]
          ↑
compare 8 > 1, shift right
[2, 5, _, 8, 9]
compare 5 > 1, shift right
[2, _, 5, 8, 9]
compare 2 > 1, shift right
[_, 2, 5, 8, 9]
insert 1
[1, 2, 5, 8 | 9]
 └─────────┘ sorted

Step 4: Insert 9 into sorted portion
[1, 2, 5, 8 | 9]
             ↑
compare 8 < 9, no shift needed
[1, 2, 5, 8, 9]
 └────────────┘ sorted

Final: [1, 2, 5, 8, 9]
```

### Characteristics

- **Time Complexity**: O(n²) average/worst, O(n) best
- **Space Complexity**: O(1)
- **Stability**: Stable
- **In-Place**: Yes
- **Use Case**: Small arrays, nearly sorted data, online sorting

---

## 🔴 Merge Sort

### Concept

Divide array into halves recursively until single elements, then merge sorted halves. Classic divide-and-conquer approach.

### Visual Process

```
Initial: [5, 2, 8, 1, 9, 3, 7]

DIVIDE PHASE:
              [5, 2, 8, 1, 9, 3, 7]
                     ↓ split
            /                    \
      [5, 2, 8, 1]            [9, 3, 7]
           ↓                       ↓
       /        \              /        \
   [5, 2]      [8, 1]      [9, 3]      [7]
     ↓           ↓           ↓           ↓
   /    \      /    \      /    \       |
  [5]  [2]   [8]  [1]   [9]  [3]      [7]

MERGE PHASE:
  [5]  [2]   [8]  [1]   [9]  [3]      [7]
    \  /       \  /       \  /         |
  [2, 5]     [1, 8]     [3, 9]       [7]
       \     /              \          /
     [1, 2, 5, 8]        [3, 7, 9]
            \               /
          [1, 2, 3, 5, 7, 8, 9]
```

### Merge Process Detail

```
Merging [2, 5] and [1, 8]:

[2, 5]   [1, 8]
 ↑        ↑
compare 2 vs 1 → take 1
Result: [1]

[2, 5]   [1, 8]
 ↑           ↑
compare 2 vs 8 → take 2
Result: [1, 2]

[2, 5]   [1, 8]
    ↑        ↑
compare 5 vs 8 → take 5
Result: [1, 2, 5]

[2, 5]   [1, 8]
    ↑        ↑
no more in left, take remaining
Result: [1, 2, 5, 8]
```

### Characteristics

- **Time Complexity**: O(n log n) for all cases
- **Space Complexity**: O(n)
- **Stability**: Stable
- **In-Place**: No
- **Use Case**: Large datasets, linked lists, external sorting, guaranteed O(n log n)

---

## 🟠 Quick Sort

### Concept

Choose a pivot element, partition array so elements smaller than pivot are on left, larger on right. Recursively sort partitions.

### Visual Process

```
Initial: [5, 2, 8, 1, 9, 3, 7]

Step 1: Choose pivot (last element = 7)
[5, 2, 8, 1, 9, 3, 7]
                   ↑ pivot

Step 2: Partition around pivot
Elements < 7: [5, 2, 1, 3]
Pivot: 7
Elements > 7: [8, 9]

[5, 2, 1, 3, 7, 8, 9]
 └────┬────┘ ↑ └─┬─┘
   smaller   pivot larger

Step 3: Recursively sort left partition [5, 2, 1, 3]
Choose pivot = 3
[5, 2, 1, 3]
         ↑
Partition:
[2, 1, 3, 5]
 └─┬─┘ ↑  ↑
 smaller pivot larger

Step 4: Sort [2, 1] with pivot = 1
[2, 1]
    ↑
Partition:
[1, 2]
 ↑  ↑
pivot larger

Step 5: Sort right partition [8, 9]
Choose pivot = 9
[8, 9]
    ↑
Already partitioned correctly

Final: [1, 2, 3, 5, 7, 8, 9]
```

### Partition Process Detail

```
Array: [5, 2, 8, 1, 9, 3, 7]
Pivot: 7 (last element)

i = -1 (index for smaller elements)
j = 0  (scanning index)

[5, 2, 8, 1, 9, 3, 7]
 ↑                 ↑
 j              pivot
5 < 7? Yes → i++, swap
i=0, swap arr[0] with arr[0]
[5, 2, 8, 1, 9, 3, 7]

[5, 2, 8, 1, 9, 3, 7]
    ↑              ↑
    j           pivot
2 < 7? Yes → i++, swap
i=1, swap arr[1] with arr[1]
[5, 2, 8, 1, 9, 3, 7]

[5, 2, 8, 1, 9, 3, 7]
       ↑           ↑
       j        pivot
8 < 7? No → continue

[5, 2, 8, 1, 9, 3, 7]
          ↑        ↑
          j     pivot
1 < 7? Yes → i++, swap
i=2, swap arr[2] with arr[3]
[5, 2, 1, 8, 9, 3, 7]

[5, 2, 1, 8, 9, 3, 7]
             ↑     ↑
             j  pivot
9 < 7? No → continue

[5, 2, 1, 8, 9, 3, 7]
                ↑  ↑
                j pivot
3 < 7? Yes → i++, swap
i=3, swap arr[3] with arr[5]
[5, 2, 1, 3, 9, 8, 7]

Finally, place pivot: swap arr[i+1] with pivot
[5, 2, 1, 3, 7, 8, 9]
             ↑
          pivot in correct position
```

### Characteristics

- **Time Complexity**: O(n log n) average, O(n²) worst
- **Space Complexity**: O(log n) for recursion stack
- **Stability**: Unstable
- **In-Place**: Yes
- **Use Case**: General purpose, cache-friendly, average case is fast

---

## 🟣 Heap Sort

### Concept

Build a max heap from array, repeatedly extract maximum element and place it at the end. Uses heap data structure properties.

### Visual Process

```
Initial: [5, 2, 8, 1, 9]

Step 1: Build Max Heap
Array: [5, 2, 8, 1, 9]
Tree representation:
        5
       / \
      2   8
     / \
    1   9

Heapify from last parent (index 1):
        5
       / \
      2   8
     / \
    1   9
    ↑   ↑
  9 > 2, swap

        5
       / \
      9   8
     / \
    1   2

Heapify root (index 0):
        5
       / \
      9   8
    ↑   ↑
  9 > 5, swap

        9
       / \
      5   8
     / \
    1   2

Continue heapify down:
        9
       / \
      5   8
      ↑   ↑
  5 < 8, no swap needed

Max Heap: [9, 5, 8, 1, 2]

Step 2: Extract Maximum
[9, 5, 8, 1, 2]
 ↑           ↑
swap first with last
[2, 5, 8, 1 | 9]
            └─ sorted

Heapify [2, 5, 8, 1]:
        2
       / \
      5   8
     /
    1
    
8 > 2, swap:
        8
       / \
      5   2
     /
    1

Heap: [8, 5, 2, 1 | 9]

Step 3: Extract Maximum
[8, 5, 2, 1 | 9]
 ↑        ↑
swap first with last
[1, 5, 2 | 8, 9]
         └─ sorted

Heapify [1, 5, 2]:
        1
       / \
      5   2
    
5 > 1, swap:
        5
       / \
      1   2

Heap: [5, 1, 2 | 8, 9]

Step 4: Continue until sorted
[2, 1 | 5, 8, 9]
[1 | 2, 5, 8, 9]

Final: [1, 2, 5, 8, 9]
```

### Characteristics

- **Time Complexity**: O(n log n) for all cases
- **Space Complexity**: O(1)
- **Stability**: Unstable
- **In-Place**: Yes
- **Use Case**: When O(1) space is required with O(n log n) time guarantee

---

## ⚡ Counting Sort

### Concept

Count occurrences of each distinct element, then place elements in sorted order based on counts. Works when range of elements is known and small.

### Visual Process

```
Initial: [4, 2, 2, 8, 3, 3, 1]
Range: 1 to 8

Step 1: Count occurrences
Count array (index represents value):
Index: 0  1  2  3  4  5  6  7  8
Count: 0  1  2  2  1  0  0  0  1

Step 2: Cumulative count (for positioning)
Index: 0  1  2  3  4  5  6  7  8
Count: 0  1  3  5  6  6  6  6  7

Step 3: Place elements
Input: [4, 2, 2, 8, 3, 3, 1]

Process 4:
Count[4] = 6, place at position 5 (6-1)
Output: [_, _, _, _, _, 4, _, _]
Count[4] = 5

Process 2:
Count[2] = 3, place at position 2 (3-1)
Output: [_, _, 2, _, _, 4, _, _]
Count[2] = 2

Process 2:
Count[2] = 2, place at position 1 (2-1)
Output: [_, 2, 2, _, _, 4, _, _]
Count[2] = 1

Process 8:
Count[8] = 7, place at position 6 (7-1)
Output: [_, 2, 2, _, _, 4, 8]
Count[8] = 6

Process 3:
Count[3] = 5, place at position 4 (5-1)
Output: [_, 2, 2, _, 3, 4, 8]
Count[3] = 4

Process 3:
Count[3] = 4, place at position 3 (4-1)
Output: [_, 2, 2, 3, 3, 4, 8]
Count[3] = 3

Process 1:
Count[1] = 1, place at position 0 (1-1)
Output: [1, 2, 2, 3, 3, 4, 8]

Final: [1, 2, 2, 3, 3, 4, 8]
```

### Characteristics

- **Time Complexity**: O(n + k) where k is range
- **Space Complexity**: O(k)
- **Stability**: Stable (when implemented correctly)
- **In-Place**: No
- **Use Case**: Small range of integers, counting frequencies

---

## 🎲 Radix Sort

### Concept

Sort numbers digit by digit, starting from least significant digit (LSD) or most significant digit (MSD). Uses stable counting sort as subroutine.

### Visual Process (LSD Radix Sort)

```
Initial: [170, 45, 75, 90, 802, 24, 2, 66]

Step 1: Sort by ones place (1st digit from right)
170 → 0
45  → 5
75  → 5
90  → 0
802 → 2
24  → 4
2   → 2
66  → 6

Sorted by ones: [170, 90, 802, 2, 24, 45, 75, 66]

Step 2: Sort by tens place (2nd digit from right)
170 → 7
90  → 9
802 → 0
2   → 0
24  → 2
45  → 4
75  → 7
66  → 6

Sorted by tens: [802, 2, 24, 45, 66, 170, 75, 90]

Step 3: Sort by hundreds place (3rd digit from right)
802 → 8
2   → 0
24  → 0
45  → 0
66  → 0
170 → 1
75  → 0
90  → 0

Sorted by hundreds: [2, 24, 45, 66, 75, 90, 170, 802]

Final: [2, 24, 45, 66, 75, 90, 170, 802]
```

### Characteristics

- **Time Complexity**: O(d × (n + k)) where d is number of digits
- **Space Complexity**: O(n + k)
- **Stability**: Stable
- **In-Place**: No
- **Use Case**: Fixed-length integers, strings with same length

---

## 🪣 Bucket Sort

### Concept

Distribute elements into buckets based on range, sort individual buckets, then concatenate. Works well for uniformly distributed data.

### Visual Process

```
Initial: [0.78, 0.17, 0.39, 0.26, 0.72, 0.94, 0.21, 0.12, 0.23, 0.68]
Range: [0.0, 1.0), 10 buckets

Step 1: Distribute into buckets
Bucket 0 [0.0-0.1): []
Bucket 1 [0.1-0.2): [0.17, 0.12]
Bucket 2 [0.2-0.3): [0.26, 0.21, 0.23]
Bucket 3 [0.3-0.4): [0.39]
Bucket 4 [0.4-0.5): []
Bucket 5 [0.5-0.6): []
Bucket 6 [0.6-0.7): [0.68]
Bucket 7 [0.7-0.8): [0.78, 0.72]
Bucket 8 [0.8-0.9): []
Bucket 9 [0.9-1.0): [0.94]

Step 2: Sort each bucket (using insertion sort)
Bucket 1: [0.12, 0.17]
Bucket 2: [0.21, 0.23, 0.26]
Bucket 3: [0.39]
Bucket 6: [0.68]
Bucket 7: [0.72, 0.78]
Bucket 9: [0.94]

Step 3: Concatenate buckets
[0.12, 0.17] + [0.21, 0.23, 0.26] + [0.39] + [0.68] + [0.72, 0.78] + [0.94]

Final: [0.12, 0.17, 0.21, 0.23, 0.26, 0.39, 0.68, 0.72, 0.78, 0.94]
```

### Characteristics

- **Time Complexity**: O(n + k) average, O(n²) worst
- **Space Complexity**: O(n + k)
- **Stability**: Depends on sorting algorithm used for buckets
- **In-Place**: No
- **Use Case**: Uniformly distributed floating-point numbers

---

## 📊 Sorting Algorithm Comparison

### Comparison Table

| Algorithm | Time (Best) | Time (Avg) | Time (Worst) | Space | Stable | In-Place |
|-----------|-------------|------------|--------------|-------|--------|----------|
| Bubble Sort | O(n) | O(n²) | O(n²) | O(1) | ✓ | ✓ |
| Selection Sort | O(n²) | O(n²) | O(n²) | O(1) | ✗ | ✓ |
| Insertion Sort | O(n) | O(n²) | O(n²) | O(1) | ✓ | ✓ |
| Merge Sort | O(n log n) | O(n log n) | O(n log n) | O(n) | ✓ | ✗ |
| Quick Sort | O(n log n) | O(n log n) | O(n²) | O(log n) | ✗ | ✓ |
| Heap Sort | O(n log n) | O(n log n) | O(n log n) | O(1) | ✗ | ✓ |
| Counting Sort | O(n + k) | O(n + k) | O(n + k) | O(k) | ✓ | ✗ |
| Radix Sort | O(d(n + k)) | O(d(n + k)) | O(d(n + k)) | O(n + k) | ✓ | ✗ |
| Bucket Sort | O(n + k) | O(n + k) | O(n²) | O(n) | ✓* | ✗ |

*Depends on sorting algorithm used for buckets

---

## 🎯 When to Use Which Sort?

### Decision Tree

```
Is data nearly sorted?
├─ YES → Use Insertion Sort (O(n) best case)
└─ NO
   ├─ Is stability required?
   │  ├─ YES
   │  │  ├─ Space not a constraint? → Merge Sort
   │  │  └─ Need in-place? → Bubble/Insertion Sort (small n)
   │  └─ NO
   │     ├─ Need guaranteed O(n log n)? → Heap Sort
   │     └─ Average case performance? → Quick Sort
   └─ Are elements integers with small range?
      └─ YES → Counting Sort or Radix Sort
```

### Use Case Matrix

**Small Arrays (n < 10-50)**
- Insertion Sort: Simple, efficient for small n

**General Purpose**
- Quick Sort: Fast average case, in-place
- Merge Sort: Stable, guaranteed O(n log n)

**Large Arrays with Memory Constraint**
- Heap Sort: O(1) space, O(n log n) guaranteed

**Nearly Sorted Data**
- Insertion Sort: O(n) for nearly sorted

**Integers with Known Range**
- Counting Sort: O(n) when range is small
- Radix Sort: O(d×n) for fixed-digit numbers

**Uniform Distribution**
- Bucket Sort: O(n) average case

**Linked Lists**
- Merge Sort: No random access needed

**External Sorting (data doesn't fit in memory)**
- Merge Sort: Sequential access pattern

---

## 🔍 Sorting in Different Scenarios

### Multi-Key Sorting

```
Sort students by: Grade (primary), then Name (secondary)

Input:
Alice   - B
Bob     - A
Charlie - B
David   - A

Step 1: Sort by Name (stable sort)
Alice   - B
Bob     - A
Charlie - B
David   - A

Step 2: Sort by Grade (stable sort)
Bob     - A
David   - A
Alice   - B
Charlie - B

Result: Sorted by grade, names in alphabetical order within each grade
```

### Partial Sorting

```
Find 3 smallest elements from [7, 10, 4, 3, 20, 15]

Option 1: Full sort + take first 3
[3, 4, 7, 10, 15, 20] → [3, 4, 7]
Time: O(n log n)

Option 2: Use min heap (partial heap sort)
Build heap, extract 3 times
Time: O(n + k log n) where k=3

Option 3: Use QuickSelect
Partition until 3 smallest are on left
Time: O(n) average
```

### Custom Comparators

```
Sort intervals by start time:
[(3,5), (1,4), (6,8), (2,7)]

Comparator: Compare start times
1 < 2 < 3 < 6

Result: [(1,4), (2,7), (3,5), (6,8)]

Sort intervals by end time:
Comparator: Compare end times
4 < 5 < 7 < 8

Result: [(1,4), (3,5), (2,7), (6,8)]
```

---

## 💡 Interview Tips

### Common Patterns

1. **When to sort**: If problem requires ordered data or finding duplicates
2. **Stability matters**: Multi-key sorting, maintaining original order
3. **Space constraints**: In-place vs out-of-place trade-offs
4. **Data characteristics**: Nearly sorted? Known range? Uniform distribution?
5. **Custom objects**: Define comparison logic clearly

### Problem-Solving Approach

1. **Identify if sorting helps**: Does ordering simplify the problem?
2. **Choose appropriate sort**: Based on constraints
3. **Consider alternatives**: Sometimes sorting isn't necessary
4. **Analyze complexity**: Time and space trade-offs

### Edge Cases

- Empty array
- Single element
- All elements equal
- Already sorted (ascending/descending)
- Large numbers or special values

---

## 🎓 Key Takeaways

1. **No universal best sorting algorithm** - choice depends on context
2. **O(n log n) is the lower bound** for comparison-based sorting
3. **Non-comparison sorts can achieve O(n)** with special constraints
4. **Stability is crucial** for multi-key sorting
5. **In-place sorting saves space** but may be less efficient
6. **Nearly sorted data** can be exploited for optimization
7. **Real-world systems** often use hybrid approaches (e.g., Timsort)
8. **Understanding trade-offs** is more important than memorizing implementations

---

## 🔗 Related Topics

- [Binary Search & Variants](./32_BINARY_SEARCH.md) - Requires sorted data
- [Heaps](./17_HEAPS.md) - Used in Heap Sort
- [Arrays](./03_ARRAYS.md) - Primary data structure for sorting
- [Dynamic Programming](./24_DYNAMIC_PROGRAMMING_BASICS.md) - Longest Increasing Subsequence

---

**Next**: [Binary Search & Variants](./32_BINARY_SEARCH.md)
