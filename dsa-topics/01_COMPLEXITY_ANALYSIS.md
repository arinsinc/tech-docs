# Time & Space Complexity Analysis

## 📖 Overview

Complexity analysis is the foundation of understanding algorithm efficiency. It helps you evaluate and compare different solutions based on their resource consumption (time and memory).

---

## ⏱️ Time Complexity

### What is Time Complexity?

Time complexity measures how the runtime of an algorithm grows as the input size increases. It's expressed using **Big O notation**.

### Big O Notation Hierarchy

```
Best ←--------------------------------→ Worst

O(1) < O(log n) < O(n) < O(n log n) < O(n²) < O(n³) < O(2ⁿ) < O(n!)
```

---

## 📊 Common Time Complexities

### 1. O(1) - Constant Time

**Definition**: Execution time doesn't depend on input size.

**Visual Representation**:
```
Time
  ↑
  |     _______________
  |    |
  |    |
  |____|_______________→
       Input Size (n)
```

**Real-World Examples**:
- Accessing an array element by index: `arr[5]`
- Getting hash map value by key: `map.get("key")`
- Checking if number is even: `num % 2 == 0`
- Stack push/pop operations

**Interview Example**:
```
Question: Find the first element of an array
Array: [10, 20, 30, 40, 50]
Answer: 10

Time: O(1) - Always takes the same time regardless of array size
```

---

### 2. O(log n) - Logarithmic Time

**Definition**: Execution time grows logarithmically as input doubles.

**Visual Representation**:
```
Time
  ↑
  |         ___
  |       _/
  |     _/
  |   _/
  |__/_______________→
       Input Size (n)
```

**How it Works**:
- Each step reduces the problem size by half
- Common in divide-and-conquer algorithms

**Real-World Examples**:
- Binary search in sorted array
- Searching in balanced binary search tree
- Finding an element in a skip list

**Interview Example**:
```
Question: Find 37 in sorted array [1, 5, 12, 23, 37, 45, 67, 89, 91]

Step 1: Check middle (37) - Found! ✓
Only 1 comparison needed

If we had 1 million elements:
- O(log n) would take ~20 comparisons
- O(n) would take up to 1,000,000 comparisons
```

**Why log n?**
```
Array size: 16 elements
Step 1: 16 → 8 (divide by 2)
Step 2: 8 → 4 (divide by 2)
Step 3: 4 → 2 (divide by 2)
Step 4: 2 → 1 (divide by 2)

Total steps: 4 = log₂(16)
```

---

### 3. O(n) - Linear Time

**Definition**: Execution time grows proportionally with input size.

**Visual Representation**:
```
Time
  ↑        /
  |       /
  |      /
  |     /
  |    /
  |___/_______________→
       Input Size (n)
```

**Real-World Examples**:
- Finding maximum element in unsorted array
- Checking if array contains a value
- Summing all elements
- Linear search

**Interview Example**:
```
Question: Find the sum of all elements in [3, 7, 2, 9, 1]

Process: 3 + 7 + 2 + 9 + 1 = 22
Must visit each element once = 5 operations

For n elements → n operations = O(n)
```

---

### 4. O(n log n) - Linearithmic Time

**Definition**: Combination of linear and logarithmic growth.

**Visual Representation**:
```
Time
  ↑          /
  |         /
  |       /
  |     /
  |   /
  |__/_______________→
       Input Size (n)
```

**Real-World Examples**:
- Efficient sorting algorithms (Merge Sort, Quick Sort, Heap Sort)
- Building a balanced binary search tree from unsorted data
- Some divide-and-conquer algorithms

**Interview Example**:
```
Question: Sort array [64, 34, 25, 12, 22, 11, 90] using Merge Sort

Merge Sort Process:
1. Divide array into halves recursively: log n levels
2. Merge sorted halves: n operations per level

Total: n × log n = O(n log n)

For 8 elements: 8 × 3 = 24 operations
For 16 elements: 16 × 4 = 64 operations
```

---

### 5. O(n²) - Quadratic Time

**Definition**: Execution time grows quadratically with input size.

**Visual Representation**:
```
Time
  ↑           /|
  |          / |
  |        /   |
  |      /     |
  |    /       |
  |___/________|_→
       Input Size (n)
```

**Real-World Examples**:
- Bubble Sort, Selection Sort, Insertion Sort
- Checking all pairs in an array
- Nested loops iterating over the same array

**Interview Example**:
```
Question: Find all pairs in array [1, 2, 3, 4]

Pairs found:
(1,2), (1,3), (1,4)
(2,3), (2,4)
(3,4)

Process:
Outer loop: 4 iterations (n)
Inner loop: 3+2+1 iterations = 6 total ≈ n²/2

Time complexity: O(n²)

For n=10: ~100 operations
For n=100: ~10,000 operations
For n=1000: ~1,000,000 operations
```

---

### 6. O(2ⁿ) - Exponential Time

**Definition**: Execution time doubles with each additional input element.

**Visual Representation**:
```
Time
  ↑                |
  |                |
  |              | |
  |           |  | |
  |        |  |  | |
  |__|__|__|__|__|_|→
       Input Size (n)
```

**Real-World Examples**:
- Recursive Fibonacci without memoization
- Generating all subsets of a set
- Solving Towers of Hanoi
- Brute force solution to traveling salesman problem

**Interview Example**:
```
Question: Calculate Fibonacci(5) recursively

Recursive Tree:
                    fib(5)
                   /      \
              fib(4)      fib(3)
             /     \      /     \
        fib(3)   fib(2) fib(2) fib(1)
       /    \    /   \   /   \
   fib(2) fib(1) f(1) f(0) f(1) f(0)
   /   \
fib(1) fib(0)

Number of calls: 15 = 2⁵ - 1

For n=5: 15 calls
For n=10: 1,023 calls
For n=20: 1,048,575 calls ❌ VERY SLOW!
```

---

### 7. O(n!) - Factorial Time

**Definition**: Execution time grows factorially with input size.

**Visual Representation**:
```
Time
  ↑                   |
  |                   |
  |                   |
  |                   |
  |              |    |
  |        |     |    |
  |__|__|__|_____|____|→
       Input Size (n)
```

**Real-World Examples**:
- Generating all permutations of a set
- Brute force traveling salesman problem
- Solving some constraint satisfaction problems

**Interview Example**:
```
Question: Generate all permutations of [A, B, C]

Permutations:
ABC, ACB, BAC, BCA, CAB, CBA

Total: 3! = 6 permutations

For n=3: 6 permutations
For n=5: 120 permutations
For n=10: 3,628,800 permutations ❌ EXTREMELY SLOW!
```

---

## 💾 Space Complexity

### What is Space Complexity?

Space complexity measures how much additional memory an algorithm uses relative to input size.

### Types of Space:

1. **Input Space**: Memory for input data (usually excluded from analysis)
2. **Auxiliary Space**: Extra memory used by algorithm (what we measure)

---

## 📊 Common Space Complexities

### O(1) - Constant Space

**Description**: Uses fixed amount of memory regardless of input size.

**Examples**:
```
Scenario: Swap two variables
Variables needed: temp (1 variable)
Space: O(1)

Scenario: Find max in array
Variables needed: max (1 variable)
Space: O(1)
```

---

### O(n) - Linear Space

**Description**: Memory usage grows proportionally with input size.

**Examples**:
```
Scenario: Copy an array
Original: [1, 2, 3, 4, 5]
Copy: [1, 2, 3, 4, 5]
Space: O(n) - duplicating n elements

Scenario: Hash map to track frequencies
Input: [1, 2, 2, 3, 3, 3]
Map: {1:1, 2:2, 3:3}
Space: O(n) - worst case stores n unique elements
```

---

### O(log n) - Logarithmic Space

**Description**: Memory usage grows logarithmically with input size.

**Examples**:
```
Scenario: Recursive binary search
Call stack depth: log n
Space: O(log n) for recursion stack

Example with n=16:
Maximum recursive calls: 4 = log₂(16)
```

---

### O(n²) - Quadratic Space

**Description**: Memory usage grows quadratically with input size.

**Examples**:
```
Scenario: 2D matrix representation of graph
Graph with n vertices
Adjacency matrix: n × n
Space: O(n²)

For 10 vertices: 100 cells
For 100 vertices: 10,000 cells
```

---

## 🎯 How to Calculate Time Complexity

### Rule 1: Drop Constants

```
3n + 5 → O(n)
n/2 → O(n)
100 → O(1)
```

### Rule 2: Drop Non-Dominant Terms

```
n² + n → O(n²)
n³ + n² + n → O(n³)
n log n + n → O(n log n)
```

### Rule 3: Different Inputs Use Different Variables

```
Two arrays of different sizes: O(n + m)
Nested loops on different inputs: O(n × m)
```

### Rule 4: Sequential Statements Add

```
Operation 1: O(n)
Operation 2: O(m)
Total: O(n + m)
```

### Rule 5: Nested Statements Multiply

```
Outer loop: O(n)
Inner loop: O(m)
Total: O(n × m)
```

---

## 📝 Analysis Examples

### Example 1: Single Loop

```
Question: What's the time complexity?

Process:
- Visit each element once: n iterations
- Each iteration does O(1) work

Time Complexity: O(n)
Space Complexity: O(1)
```

### Example 2: Nested Loops (Same Input)

```
Question: Find all pairs

Process:
- Outer loop: n iterations
- Inner loop: n iterations for each outer
- Total: n × n = n²

Time Complexity: O(n²)
Space Complexity: O(1)
```

### Example 3: Nested Loops (Different Inputs)

```
Question: Compare two arrays

Process:
- First array: n elements
- Second array: m elements
- Nested loops: n × m

Time Complexity: O(n × m)
Space Complexity: O(1)
```

### Example 4: Divide and Conquer

```
Question: Binary search

Process:
- Each step eliminates half
- Continues until 1 element
- Steps: log n

Time Complexity: O(log n)
Space Complexity: O(1) iterative, O(log n) recursive
```

### Example 5: Multiple Loops (Sequential)

```
Question: Process then search

Process:
- First loop: O(n)
- Second loop: O(n)
- Total: O(n) + O(n) = O(2n) → O(n)

Time Complexity: O(n)
Space Complexity: O(1)
```

---

## 📈 Best, Average, and Worst Case

### Understanding Different Cases

**Best Case**: Minimum time/space needed (optimistic scenario)
**Average Case**: Expected time/space for typical input
**Worst Case**: Maximum time/space needed (pessimistic scenario)

### Example: Quick Sort

```
Array: [5, 2, 8, 1, 9]

Best Case: O(n log n)
- Pivot always divides array evenly
- Example: Pivot is median each time

Average Case: O(n log n)
- Pivot gives reasonable divisions
- Most common in practice

Worst Case: O(n²)
- Pivot is always smallest/largest
- Example: Already sorted array with first element as pivot
```

### Visual Comparison:

```
Best Case:     Average Case:    Worst Case:
    [5]            [5]              [5]
   /   \          /   \            /
 [2,1] [8,9]   [2,1] [8,9]      [2]
                                /
                              [1]
Balanced         Mostly         Unbalanced
                balanced
```

---

## 💡 Interview Tips

### 1. Always Discuss Complexity

When solving a problem, always mention:
- Time complexity of your solution
- Space complexity of your solution
- Can it be optimized?

### 2. Start with Brute Force

- First, provide a working solution
- Then, discuss its complexity
- Finally, optimize if possible

### 3. Consider Trade-offs

Sometimes you can trade space for time:
- Use hash map to reduce O(n²) to O(n)
- Use memoization to optimize recursion
- Pre-processing for faster queries

### 4. Watch for Hidden Complexities

Some operations aren't O(1):
- String concatenation in loops
- Array/list insertions in middle
- Sorting within your algorithm

---

## 🎓 Key Takeaways

1. **Big O describes growth rate**, not exact runtime
2. **Drop constants and non-dominant terms** for Big O
3. **Logarithmic time is very efficient** (O(log n))
4. **Avoid exponential and factorial** time when possible (O(2ⁿ), O(n!))
5. **Space-time trade-offs** are common in optimization
6. **Always analyze both** time and space complexity
7. **Worst case is typically** what we discuss in interviews

---

## 📚 Next Topic

Continue to [Problem-Solving Patterns](./02_PROBLEM_SOLVING_PATTERNS.md) to learn common approaches for tackling interview questions.
