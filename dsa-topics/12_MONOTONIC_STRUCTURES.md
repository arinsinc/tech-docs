# Monotonic Stack & Queue

## 📋 Overview

**Monotonic structures** are specialized variants of stacks and queues that maintain elements in a specific order (either strictly increasing or strictly decreasing). These powerful data structures are essential for solving optimization problems involving ranges, windows, and "next greater/smaller" patterns efficiently.

---

## 🎯 Core Concepts

### What is a Monotonic Structure?

A monotonic stack or queue maintains a **monotonic property**:
- **Monotonic Increasing**: Each element is greater than or equal to the previous
- **Monotonic Decreasing**: Each element is less than or equal to the previous

**Key Characteristic:** When adding a new element, remove all elements that violate the monotonic property.

---

## 📚 Monotonic Stack

### Monotonic Increasing Stack

Elements increase from bottom to top.

**Visual Example:**
```
Building Monotonic Increasing Stack from: [3, 1, 4, 2, 5]

Step 1: Push 3
    ┌───┐
    │ 3 │
    └───┘

Step 2: Push 1
    1 < 3 → Violates increasing order
    Pop 3, then push 1
    ┌───┐
    │ 1 │
    └───┘

Step 3: Push 4
    4 > 1 → Maintains order
    ┌───┐
    │ 4 │
    ├───┤
    │ 1 │
    └───┘

Step 4: Push 2
    2 < 4 → Violates order
    Pop 4, then push 2
    ┌───┐
    │ 2 │
    ├───┤
    │ 1 │
    └───┘

Step 5: Push 5
    5 > 2 → Maintains order
    ┌───┐
    │ 5 │
    ├───┤
    │ 2 │
    ├───┤
    │ 1 │
    └───┘

Final: [1, 2, 5] (increasing from bottom to top)
```

---

### Monotonic Decreasing Stack

Elements decrease from bottom to top.

**Visual Example:**
```
Building Monotonic Decreasing Stack from: [3, 1, 4, 2, 5]

Step 1: Push 3
    ┌───┐
    │ 3 │
    └───┘

Step 2: Push 1
    1 < 3 → Maintains decreasing order
    ┌───┐
    │ 1 │
    ├───┤
    │ 3 │
    └───┘

Step 3: Push 4
    4 > 1 → Violates decreasing order
    Pop 1, check 3: 4 > 3, pop 3
    Then push 4
    ┌───┐
    │ 4 │
    └───┘

Step 4: Push 2
    2 < 4 → Maintains decreasing order
    ┌───┐
    │ 2 │
    ├───┤
    │ 4 │
    └───┘

Step 5: Push 5
    5 > 2 → Violates order
    Pop 2, check 4: 5 > 4, pop 4
    Then push 5
    ┌───┐
    │ 5 │
    └───┘

Final: [5] (only largest remains)
```

---

## 🔍 Classic Problems with Monotonic Stack

### 1. Next Greater Element

**Problem:** For each element, find the next greater element to its right.

**Array:** [4, 5, 2, 10, 8]

**Solution using Monotonic Decreasing Stack:**

```
Process array from right to left:

Index 4: element = 8
Stack: []
Next greater: None (-1)
Push 8
Stack: [8]
    ┌───┐
    │ 8 │
    └───┘

Index 3: element = 10
Stack: [8]
10 > 8 → Pop 8 (smaller)
Stack: []
Next greater: None (-1)
Push 10
Stack: [10]
    ┌────┐
    │ 10 │
    └────┘

Index 2: element = 2
Stack: [10]
2 < 10 → Keep 10
Next greater: 10 ✓
Push 2
Stack: [10, 2]
    ┌───┐
    │ 2 │
    ├───┤
    │10 │
    └───┘

Index 1: element = 5
Stack: [10, 2]
5 > 2 → Pop 2
5 < 10 → Keep 10
Next greater: 10 ✓
Push 5
Stack: [10, 5]
    ┌───┐
    │ 5 │
    ├───┤
    │10 │
    └───┘

Index 0: element = 4
Stack: [10, 5]
4 < 5 → Keep 5
Next greater: 5 ✓
Push 4
Stack: [10, 5, 4]
    ┌───┐
    │ 4 │
    ├───┤
    │ 5 │
    ├───┤
    │10 │
    └───┘

Result: [5, 10, 10, -1, -1]

Visual:
Array:  4   5   2  10   8
         ↓   ↓   ↓   ↓   ↓
Next:   5  10  10  -1  -1
```

**Why it works:**
- Stack maintains decreasing order
- Top of stack is first element greater than current
- Elements popped will never be "next greater" for remaining elements

---

### 2. Previous Smaller Element

**Problem:** For each element, find the previous smaller element to its left.

**Array:** [4, 5, 2, 10, 8]

**Solution using Monotonic Increasing Stack:**

```
Process array from left to right:

Index 0: element = 4
Stack: []
Previous smaller: None (-1)
Push 4
Stack: [4]
    ┌───┐
    │ 4 │
    └───┘

Index 1: element = 5
Stack: [4]
4 < 5 → Keep 4 (it's smaller!)
Previous smaller: 4 ✓
Push 5
Stack: [4, 5]
    ┌───┐
    │ 5 │
    ├───┤
    │ 4 │
    └───┘

Index 2: element = 2
Stack: [4, 5]
5 > 2 → Pop 5 (not smaller)
4 > 2 → Pop 4 (not smaller)
Stack: []
Previous smaller: None (-1)
Push 2
Stack: [2]
    ┌───┐
    │ 2 │
    └───┘

Index 3: element = 10
Stack: [2]
2 < 10 → Keep 2
Previous smaller: 2 ✓
Push 10
Stack: [2, 10]
    ┌────┐
    │ 10 │
    ├────┤
    │ 2  │
    └────┘

Index 4: element = 8
Stack: [2, 10]
10 > 8 → Pop 10 (not smaller)
2 < 8 → Keep 2
Previous smaller: 2 ✓
Push 8
Stack: [2, 8]
    ┌───┐
    │ 8 │
    ├───┤
    │ 2 │
    └───┘

Result: [-1, 4, -1, 2, 2]

Visual:
Array:   4   5   2  10   8
         ↓   ↓   ↓   ↓   ↓
Prev:   -1   4  -1   2   2
```

---

### 3. Largest Rectangle in Histogram

**Problem:** Find largest rectangle area in histogram.

**Heights:** [2, 1, 5, 6, 2, 3]

**Visual Histogram:**
```
    6  ┌──┐
    5  │  │┌──┐
    4  │  ││  │
    3  │  ││  │    ┌──┐
    2 ┌──┐│  │┌──┐│  │
    1 │  ││  ││  ││  ││  │
    0 └──┴┴──┴┴──┴┴──┴┴──┘
       2  1  5  6  2  3
       0  1  2  3  4  5  (indices)

Largest rectangle: heights 5 and 6
Area = 2 × 5 = 10

Visual:
    6  ┌──┐
    5 ╔╗  ││┌──┐
    4 ║║  │││  │
    3 ║║  │││  │    ┌──┐
    2 ║╚──┐││  │┌──┐│  │
    1 ║   ││  ││  ││  ││  │
    0 ╚═══╧╧══╧╧══╧╧══╧╧══┘
       2  1  5  6  2  3
```

**Solution using Monotonic Increasing Stack:**

```
Stack stores indices of increasing heights:

Index 0: height = 2
Stack: [0]
    ┌───┐
    │ 0 │ (height 2)
    └───┘

Index 1: height = 1
1 < 2 → Pop 0
Calculate area with height 2:
  Width = 1 (from index 0 to 0)
  Area = 2 × 1 = 2
Stack: [1]
    ┌───┐
    │ 1 │ (height 1)
    └───┘

Index 2: height = 5
5 > 1 → Increasing, push
Stack: [1, 2]
    ┌───┐
    │ 2 │ (height 5)
    ├───┤
    │ 1 │ (height 1)
    └───┘

Index 3: height = 6
6 > 5 → Increasing, push
Stack: [1, 2, 3]
    ┌───┐
    │ 3 │ (height 6)
    ├───┤
    │ 2 │ (height 5)
    ├───┤
    │ 1 │ (height 1)
    └───┘

Index 4: height = 2
2 < 6 → Pop 3
Calculate: height=6, width=(4-2-1)=1, area=6
2 < 5 → Pop 2
Calculate: height=5, width=(4-1-1)=2, area=10 ✓ (max!)
2 > 1 → Stop, push
Stack: [1, 4]
    ┌───┐
    │ 4 │ (height 2)
    ├───┤
    │ 1 │ (height 1)
    └───┘

Index 5: height = 3
3 > 2 → Increasing, push
Stack: [1, 4, 5]

End of array: Pop remaining
Calculate all remaining rectangles

Maximum area: 10
```

**Key Insight:**
- Monotonic increasing stack
- When popping, the popped element defines rectangle height
- Width = current index - previous stack top - 1

---

### 4. Stock Span Problem

**Problem:** Calculate span = consecutive days stock price ≤ current price.

**Prices:** [100, 80, 60, 70, 60, 75, 85]

**Solution using Monotonic Decreasing Stack:**

```
Stack stores indices:

Day 0: price = 100
Stack: []
Span: 1 (no previous days)
Push 0
Stack: [0]
    ┌───┐
    │ 0 │ (price 100)
    └───┘

Day 1: price = 80
80 < 100 → Keep 0 in stack
Span: 1 (only current day)
Push 1
Stack: [0, 1]
    ┌───┐
    │ 1 │ (price 80)
    ├───┤
    │ 0 │ (price 100)
    └───┘

Day 2: price = 60
60 < 80 → Keep stack
Span: 1
Push 2
Stack: [0, 1, 2]
    ┌───┐
    │ 2 │ (price 60)
    ├───┤
    │ 1 │ (price 80)
    ├───┤
    │ 0 │ (price 100)
    └───┘

Day 3: price = 70
70 > 60 → Pop 2
70 < 80 → Keep 1
Span: 3 - 1 = 2 ✓ (days 2 and 3)
Push 3
Stack: [0, 1, 3]
    ┌───┐
    │ 3 │ (price 70)
    ├───┤
    │ 1 │ (price 80)
    ├───┤
    │ 0 │ (price 100)
    └───┘

Day 4: price = 60
60 < 70 → Keep stack
Span: 1
Push 4
Stack: [0, 1, 3, 4]

Day 5: price = 75
75 > 60 → Pop 4
75 > 70 → Pop 3
75 < 80 → Keep 1
Span: 5 - 1 = 4 ✓ (days 2,3,4,5)
Push 5
Stack: [0, 1, 5]
    ┌───┐
    │ 5 │ (price 75)
    ├───┤
    │ 1 │ (price 80)
    ├───┤
    │ 0 │ (price 100)
    └───┘

Day 6: price = 85
85 > 75 → Pop 5
85 > 80 → Pop 1
85 < 100 → Keep 0
Span: 6 - 0 = 6 ✓ (days 1,2,3,4,5,6)
Push 6
Stack: [0, 6]

Result: [1, 1, 1, 2, 1, 4, 6]

Visual:
Day:    0   1   2   3   4   5   6
Price: 100 80  60  70  60  75  85
Span:   1   1   1   2   1   4   6
        ↓   ↓   ↓  └─┘  ↓  └──┘ └─────┘
```

---

## 📦 Monotonic Queue

### Monotonic Decreasing Queue (Deque)

Used for **sliding window maximum** problems.

**Problem:** Find maximum in each sliding window.

**Array:** [1, 3, -1, -3, 5, 3, 6, 7], k = 3

**Solution:**

```
Monotonic decreasing deque (stores indices):

Window [1, 3, -1]:
Step 1: Add 1
Deque: [0] (index of 1)
    ┌───┐
    │ 0 │
    └───┘

Step 2: Add 3
3 > 1 → Remove 0 (1 is useless now)
Deque: [1] (index of 3)
    ┌───┐
    │ 1 │
    └───┘

Step 3: Add -1
-1 < 3 → Keep both
Deque: [1, 2] (indices of 3, -1)
    ┌───┬───┐
    │ 1 │ 2 │
    └───┴───┘
Front has max: 3 ✓

Window [3, -1, -3]:
Remove index 0 from front (out of window)
Add -3: -3 < -1, keep
Deque: [1, 2, 3]
    ┌───┬───┬───┐
    │ 1 │ 2 │ 3 │
    └───┴───┴───┘
Front has max: 3 ✓

Window [-1, -3, 5]:
Remove index 1 (out of window)
Add 5: 5 > -1, 5 > -3
Remove 2, 3
Deque: [4] (index of 5)
    ┌───┐
    │ 4 │
    └───┘
Front has max: 5 ✓

Window [-3, 5, 3]:
Remove index 2 (out of window)
Add 3: 3 < 5, keep
Deque: [4, 5]
    ┌───┬───┐
    │ 4 │ 5 │
    └───┴───┘
Front has max: 5 ✓

Window [5, 3, 6]:
Remove index 3 (out of window)
Add 6: 6 > 3, 6 > 5
Remove all
Deque: [6] (index of 6)
    ┌───┐
    │ 6 │
    └───┘
Front has max: 6 ✓

Window [3, 6, 7]:
Add 7: 7 > 6
Remove 6
Deque: [7] (index of 7)
    ┌───┐
    │ 7 │
    └───┘
Front has max: 7 ✓

Result: [3, 3, 5, 5, 6, 7]

Visual:
Array:  1   3  -1  -3   5   3   6   7
        └───┬───┘
Window 1: Max = 3
            └───┬───┘
        Window 2: Max = 3
                └───┬───┘
            Window 3: Max = 5
                    └───┬───┘
                Window 4: Max = 5
                        └───┬───┘
                    Window 5: Max = 6
                            └───┬───┘
                        Window 6: Max = 7
```

**Key Properties:**
1. **Front** always has index of maximum in window
2. **Decreasing order** from front to back
3. Remove indices **outside window** from front
4. Remove **smaller elements** from back when adding new element

---

## 🎯 Problem Patterns

### Pattern 1: Next Greater/Smaller

**When to use:**
- Find next/previous greater/smaller element
- "First element to the right/left that is..."

**Stack type:**
- Next Greater → Decreasing stack (right to left)
- Next Smaller → Increasing stack (right to left)
- Previous Greater → Decreasing stack (left to right)
- Previous Smaller → Increasing stack (left to right)

---

### Pattern 2: Range Queries

**When to use:**
- Maximum/minimum in sliding window
- Subarray min/max problems

**Structure type:**
- Monotonic Deque (double-ended)
- Maintains candidates for current window

---

### Pattern 3: Area/Rectangle Problems

**When to use:**
- Histogram problems
- Trapping rain water
- Maximum rectangle in matrix

**Stack type:**
- Monotonic Increasing stack
- Track boundaries of rectangles

---

## 🌍 Real-World Applications

### 1. Stock Market Analysis

```
Daily Price Monitoring:

Prices: [100, 95, 92, 98, 105, 102]

Using Monotonic Stack:
- Track support levels (previous smaller)
- Identify resistance breakouts (next greater)
- Calculate trend duration (span)

Result: Trading signals based on price patterns
```

---

### 2. Weather Data Processing

```
Temperature Monitoring:

Temperatures: [73, 74, 75, 71, 69, 72, 76, 73]

Find: Days until warmer temperature

Using Next Greater Element:
[1, 1, 4, 2, 1, 1, 0, 0]

Day 0 (73°): Day 1 (74°) is warmer → 1 day
Day 1 (74°): Day 2 (75°) is warmer → 1 day
Day 2 (75°): Day 6 (76°) is warmer → 4 days
```

---

### 3. Building Skyline View

```
Building Heights: [3, 1, 4, 2, 5]

From position, which buildings visible?

Using Monotonic Decreasing Stack:
From left: [3, 4, 5] (increasing heights visible)
From right: [5] (tallest blocks all)

┌─────┐
│     │
│     │┌───┐
│     ││   │
┌───┐ ││   │
│   │ ││   │
│   │┌┴┐│   │
│   ││ ││   │┌───┐
└───┴┴─┴┴───┴┴───┘
  3  1  4  2  5
```

---

### 4. Traffic Flow Analysis

```
Vehicle speeds in sliding time window:

Speeds: [60, 65, 50, 55, 70, 68, 75]
Window: 3 readings

Find max speed in each window:

Using Monotonic Queue:
[65, 65, 70, 70, 75]

Window [60,65,50]: Max = 65 km/h
Window [65,50,55]: Max = 65 km/h
Window [50,55,70]: Max = 70 km/h
...
```

---

## ⚡ Performance Characteristics

### Time Complexity

```
┌───────────────────────┬────────────┐
│      Operation        │ Complexity │
├───────────────────────┼────────────┤
│ Build monotonic stack │   O(n)     │
│ Each element          │ O(1) avg*  │
│ Next greater (all)    │   O(n)     │
│ Sliding window max    │   O(n)     │
└───────────────────────┴────────────┘

* Amortized: Each element pushed/popped once
```

**Why O(n) for n elements?**
```
Each element:
- Pushed exactly once
- Popped at most once

Total operations: ≤ 2n
Amortized: O(1) per element
Overall: O(n)
```

### Space Complexity

```
Space = O(n) in worst case

Worst case: All elements in monotonic order
Best case: O(1) if elements not monotonic

Example:
Increasing array [1,2,3,4,5]
Monotonic increasing stack:
    ┌───┐
    │ 5 │
    ├───┤
    │ 4 │
    ├───┤
    │ 3 │
    ├───┤
    │ 2 │
    ├───┤
    │ 1 │
    └───┘
All elements stored: O(n)
```

---

## 💡 Interview Insights

### Key Recognition Patterns

**Use Monotonic Stack when you see:**
- "Next greater/smaller element"
- "Previous greater/smaller element"
- "Range where current element is min/max"
- "Largest rectangle/area"
- "Stock span"
- "Daily temperatures"

**Use Monotonic Queue when you see:**
- "Sliding window maximum/minimum"
- "Subarray min/max problems"
- "Moving window queries"

---

### Common Mistakes to Avoid

**1. Wrong Monotonic Direction**
```
Next Greater → Use DECREASING stack
Next Smaller → Use INCREASING stack

Don't confuse them!
```

**2. Forgetting to Store Indices**
```
Store indices, not values!
Indices help calculate:
- Distances
- Positions
- Window boundaries
```

**3. Not Handling Empty Stack**
```
Always check:
if stack.isEmpty():
    # No greater/smaller element
    result = -1
else:
    result = stack.top()
```

**4. Window Cleanup in Deque**
```
Remove out-of-window elements:
while (!deque.isEmpty() && 
       deque.front() < currentIndex - k + 1):
    deque.removeFront()
```

---

### Problem-Solving Framework

**Step 1: Identify Pattern**
- Next/Previous element? → Stack
- Sliding window? → Deque

**Step 2: Choose Direction**
- Increasing or decreasing?
- Left to right or right to left?

**Step 3: Decide What to Store**
- Indices (most common)
- Values (rare)
- Both (specific cases)

**Step 4: Handle Edges**
- Empty structure
- Single element
- All monotonic

---

## 🎯 Summary

Monotonic structures are **powerful optimization techniques**:

**Monotonic Stack:**
- 📊 Maintains increasing or decreasing order
- ⚡ O(n) total time for n elements
- 🎯 Perfect for next/previous element problems
- 🔍 Used in histogram, span, temperature problems

**Monotonic Queue:**
- 🪟 Optimizes sliding window queries
- ⚡ O(n) for n elements, O(1) per window
- 🎯 Finds min/max in moving windows
- 📈 Essential for range optimization

**Key Insights:**
- **Amortized O(1)**: Each element pushed/popped once
- **Order matters**: Increasing vs decreasing for different problems
- **Store indices**: Usually more useful than values
- **Pattern recognition**: "Next greater" → Think monotonic!

**Remember:** When you need to find the "next" or "previous" element with some property, or optimize sliding window queries, monotonic structures are your best friend!

---

## 📚 Related Topics

- [Stack Operations & Applications](./10_STACKS.md) - Foundation for monotonic stack
- [Queue Operations & Variants](./11_QUEUES.md) - Foundation for monotonic queue
- [Sliding Window](./05_TWO_POINTERS_SLIDING_WINDOW.md) - Combined with monotonic structures
- [Dynamic Programming](./24_DYNAMIC_PROGRAMMING_BASICS.md) - Some optimization problems

