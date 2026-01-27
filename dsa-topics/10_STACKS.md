# Stack Operations & Applications

## 📋 Overview

A **Stack** is a linear data structure that follows the **LIFO (Last In, First Out)** principle. Think of it like a stack of plates - you can only add or remove plates from the top. The last plate you place on the stack is the first one you'll remove.

---

## 🎯 Core Concepts

### What is a Stack?

A stack is a collection where:
- Elements are added and removed from the **same end** (called the "top")
- **LIFO order**: Last element added is the first to be removed
- Only the **top element** is accessible

**Visual Representation:**
```
Stack operations visualization:

        ┌─────┐
        │  5  │ ← Top (most recent)
        ├─────┤
        │  3  │
        ├─────┤
        │  7  │
        ├─────┤
        │  1  │ ← Bottom (oldest)
        └─────┘

Push (add to top):        Pop (remove from top):
        ┌─────┐                   ┌─────┐
        │  9  │ ← New                    │ (5 removed)
        ├─────┤                   ├─────┤
        │  5  │                   │  3  │ ← New top
        ├─────┤                   ├─────┤
        │  3  │                   │  7  │
        ├─────┤                   ├─────┤
        │  7  │                   │  1  │
        ├─────┤                   └─────┘
        │  1  │
        └─────┘
```

---

## 🔧 Core Operations

### 1. Push (Insert)

Add an element to the top of the stack.

**Visual Process:**
```
Initial Stack:         After Push(8):
    ┌─────┐               ┌─────┐
    │  5  │ ← Top         │  8  │ ← New Top
    ├─────┤               ├─────┤
    │  3  │               │  5  │
    ├─────┤               ├─────┤
    │  1  │               │  3  │
    └─────┘               ├─────┤
                          │  1  │
                          └─────┘

Time Complexity: O(1) - constant time
```

---

### 2. Pop (Remove)

Remove and return the top element.

**Visual Process:**
```
Initial Stack:         After Pop():
    ┌─────┐               
    │  8  │ ← Top (removed, returns 8)
    ├─────┤               ┌─────┐
    │  5  │               │  5  │ ← New Top
    ├─────┤               ├─────┤
    │  3  │               │  3  │
    ├─────┤               ├─────┤
    │  1  │               │  1  │
    └─────┘               └─────┘

Time Complexity: O(1) - constant time
```

---

### 3. Peek / Top

View the top element without removing it.

**Visual Process:**
```
Stack:
    ┌─────┐
    │  8  │ ← Peek returns 8 (doesn't remove)
    ├─────┤
    │  5  │
    ├─────┤
    │  3  │
    └─────┘

Stack unchanged after Peek
Time Complexity: O(1) - constant time
```

---

### 4. IsEmpty

Check if stack has no elements.

**Visual Process:**
```
Non-Empty Stack:        Empty Stack:
    ┌─────┐                ┌─────┐
    │  5  │                │     │
    ├─────┤                └─────┘
    │  3  │                
    └─────┘                IsEmpty() → true
    
IsEmpty() → false
```

---

### 5. Size

Return the number of elements in the stack.

**Visual Process:**
```
Stack:
    ┌─────┐
    │  8  │ ← Position 3
    ├─────┤
    │  5  │ ← Position 2
    ├─────┤
    │  3  │ ← Position 1
    ├─────┤
    │  1  │ ← Position 0
    └─────┘
    
Size() → 4
```

---

## 🏗️ Implementation Approaches

### Using Array

```
Array-based Stack:
┌───┬───┬───┬───┬───┬───┬───┬───┐
│ 5 │ 3 │ 8 │ 1 │   │   │   │   │
└───┴───┴───┴───┴───┴───┴───┴───┘
  0   1   2   3   4   5   6   7
              ↑
            Top index = 3

Push: arr[++top] = element
Pop: return arr[top--]
Peek: return arr[top]

Pros: Simple, cache-friendly
Cons: Fixed size (unless dynamic array)
```

---

### Using Linked List

```
Linked List-based Stack:

Top → [1] → [8] → [3] → [5] → NULL
      ↑
    Most recent

Push: Create node, link to current top, update top
Pop: Save top.data, move top to top.next, return data
Peek: return top.data

Pros: Dynamic size, no capacity limit
Cons: Extra memory for pointers
```

---

## 🎯 Common Use Cases & Problems

### 1. Balanced Parentheses

**Problem:** Check if brackets are properly matched.

**Visual Solution:**
```
Input: "{[()]}"

Process:
Step 1: See '{'       Stack: ['{']
Step 2: See '['       Stack: ['{', '[']
Step 3: See '('       Stack: ['{', '[', '(']
Step 4: See ')'       Match with '(' → Pop
                      Stack: ['{', '[']
Step 5: See ']'       Match with '[' → Pop
                      Stack: ['{']
Step 6: See '}'       Match with '{' → Pop
                      Stack: []

Empty stack → Balanced ✓

Invalid Example: "([)]"
Step 1: '('          Stack: ['(']
Step 2: '['          Stack: ['(', '[']
Step 3: ')'          Top is '[', not '(' → Mismatch ✗
```

**Matching Rules:**
```
Opening brackets push to stack:
'(' '[' '{'

Closing brackets must match top:
')' matches '('
']' matches '['
'}' matches '{'

Visual:
    ┌─────┐
    │  (  │ ← Must match with )
    ├─────┤
    │  [  │ ← Must match with ]
    ├─────┤
    │  {  │ ← Must match with }
    └─────┘
```

---

### 2. Function Call Stack

**How programs execute functions:**

```
Function calls:
main() calls foo(5)
foo(5) calls bar(3)
bar(3) calls baz(1)

Call Stack visualization:

Step 1: main() starts
    ┌────────┐
    │ main() │
    └────────┘

Step 2: main() calls foo(5)
    ┌─────────┐
    │ foo(5)  │ ← Currently executing
    ├─────────┤
    │ main()  │ ← Waiting
    └─────────┘

Step 3: foo(5) calls bar(3)
    ┌─────────┐
    │ bar(3)  │ ← Currently executing
    ├─────────┤
    │ foo(5)  │ ← Waiting
    ├─────────┤
    │ main()  │ ← Waiting
    └─────────┘

Step 4: bar(3) calls baz(1)
    ┌─────────┐
    │ baz(1)  │ ← Currently executing
    ├─────────┤
    │ bar(3)  │ ← Waiting
    ├─────────┤
    │ foo(5)  │ ← Waiting
    ├─────────┤
    │ main()  │ ← Waiting
    └─────────┘

Step 5: baz(1) returns
    ┌─────────┐
    │ bar(3)  │ ← Resume
    ├─────────┤
    │ foo(5)  │
    ├─────────┤
    │ main()  │
    └─────────┘

Continue until all return...
```

---

### 3. Undo/Redo Mechanism

**Track operations for undo:**

```
Actions Stack:

Initial state: Document is empty
    ┌──────────────┐
    │              │
    └──────────────┘

Action: Type "Hello"
    ┌──────────────┐
    │ Type "Hello" │
    └──────────────┘

Action: Bold text
    ┌──────────────┐
    │ Bold         │
    ├──────────────┤
    │ Type "Hello" │
    └──────────────┘

Action: Type " World"
    ┌──────────────┐
    │ Type " World"│
    ├──────────────┤
    │ Bold         │
    ├──────────────┤
    │ Type "Hello" │
    └──────────────┘

Undo: Pop top action (Type " World")
    ┌──────────────┐
    │ Bold         │
    ├──────────────┤
    │ Type "Hello" │
    └──────────────┘

Undo: Pop top action (Bold)
    ┌──────────────┐
    │ Type "Hello" │
    └──────────────┘
```

---

### 4. Expression Evaluation

#### Infix to Postfix Conversion

**Infix:** A + B * C
**Postfix:** A B C * +

**Conversion Process:**
```
Infix: A + B * C

Operator precedence: * > +

Process each token:

Token: A (operand)
Output: A
Stack: []

Token: + (operator)
Output: A
Stack: [+]

Token: B (operand)
Output: A B
Stack: [+]

Token: * (operator, higher precedence than +)
Output: A B
Stack: [+, *]

Token: C (operand)
Output: A B C
Stack: [+, *]

End: Pop all operators
Output: A B C * +
Stack: []

Postfix: A B C * +
```

**Visual Stack Changes:**
```
Step-by-step operator stack:

[]  →  [+]  →  [+]  →  [+ *]  →  [+ *]  →  [+]  →  []
                         ↑         ↑
                      Push *    Pop * to output
```

---

#### Evaluate Postfix Expression

**Expression:** 2 3 * 4 +

**Evaluation:**
```
Stack-based evaluation:

Token: 2 (operand)
    ┌─────┐
    │  2  │
    └─────┘

Token: 3 (operand)
    ┌─────┐
    │  3  │
    ├─────┤
    │  2  │
    └─────┘

Token: * (operator)
Pop 3 and 2, compute 2*3=6, push result
    ┌─────┐
    │  6  │
    └─────┘

Token: 4 (operand)
    ┌─────┐
    │  4  │
    ├─────┤
    │  6  │
    └─────┘

Token: + (operator)
Pop 4 and 6, compute 6+4=10, push result
    ┌─────┐
    │ 10  │
    └─────┘

Result: 10
```

---

### 5. Backtracking

**Example: Maze solving**

```
Maze (S=Start, E=End, #=Wall):
┌─────────────┐
│ S   #     # │
│ # # # ### # │
│ #       #   │
│ ### ### # # │
│ #       # E │
└─────────────┘

Path stack tracks visited cells:

Start:
    ┌─────┐
    │ S   │
    └─────┘

Move right:
    ┌─────┐
    │(1,0)│
    ├─────┤
    │ S   │
    └─────┘

Dead end → backtrack (pop):
    ┌─────┐
    │ S   │
    └─────┘

Try different path:
    ┌─────┐
    │(0,1)│
    ├─────┤
    │ S   │
    └─────┘

Continue until reach E or exhaust options
```

---

### 6. Browser History

**Back/Forward navigation:**

```
Back Stack (pages visited):

Visit Page A:
    ┌────────┐
    │ Page A │
    └────────┘

Visit Page B:
    ┌────────┐
    │ Page B │ ← Current
    ├────────┤
    │ Page A │
    └────────┘

Visit Page C:
    ┌────────┐
    │ Page C │ ← Current
    ├────────┤
    │ Page B │
    ├────────┤
    │ Page A │
    └────────┘

Click Back: Pop C, current = B
    ┌────────┐
    │ Page B │ ← Current
    ├────────┤
    │ Page A │
    └────────┘
    
Forward Stack:
    ┌────────┐
    │ Page C │
    └────────┘

Click Back again: Pop B, current = A
    ┌────────┐
    │ Page A │ ← Current
    └────────┘
    
Forward Stack:
    ┌────────┐
    │ Page C │
    ├────────┤
    │ Page B │
    └────────┘
```

---

### 7. Next Greater Element

**Find next greater element for each array element:**

```
Array: [4, 5, 2, 10, 8]

Goal: For each element, find next greater element to its right

Process using stack:

Index 0: 4
Stack: [4]

Index 1: 5 > 4 (top)
Pop 4, its next greater is 5
Stack: [5]

Index 2: 2 < 5
Stack: [5, 2]

Index 3: 10 > 2 (top)
Pop 2, its next greater is 10
10 > 5 (top)
Pop 5, its next greater is 10
Stack: [10]

Index 4: 8 < 10
Stack: [10, 8]

End: Elements in stack have no next greater
10 → -1
8 → -1

Result: [5, 10, 10, -1, -1]

Visual:
    4 → 5 (5 is next greater)
    5 → 10 (10 is next greater)
    2 → 10 (10 is next greater)
    10 → -1 (none greater)
    8 → -1 (none greater)
```

---

### 8. Stock Span Problem

**Calculate span: days since last higher price:**

```
Prices: [100, 80, 60, 70, 60, 75, 85]

Day 0: 100 → Span = 1 (no previous)
Day 1: 80 < 100 → Span = 1
Day 2: 60 < 80 → Span = 1
Day 3: 70 > 60 → Span = 2 (includes day 2)
Day 4: 60 < 70 → Span = 1
Day 5: 75 > 60, 70 → Span = 3 (includes days 3,4)
Day 6: 85 > 75, 60, 70, 60 → Span = 6 (includes days 1-5)

Visual span representation:
Day:   0    1    2    3    4    5    6
Price: 100  80   60   70   60   75   85
Span:  1    1    1    2    1    3    6
       ↓    ↓    ↓   └─┘   ↓   └──┘ └─────┘

Using stack to track indices:
Stack stores indices of days with higher prices
```

---

## 🌍 Real-World Applications

### 1. Text Editor Operations

```
Text editing with undo/redo:
    ┌──────────────┐
    │ Delete line  │
    ├──────────────┤
    │ Insert "Hi"  │
    ├──────────────┤
    │ Format bold  │
    └──────────────┘

Each operation pushed to stack
Undo = pop and reverse operation
```

---

### 2. Syntax Checking in Compilers

```
Check code structure:
    if (condition) {
        while (x < 10) {
            print(x);
        }
    }

Stack tracks opening braces:
    ┌─────┐
    │  (  │ ← For if
    ├─────┤
    │  (  │ ← For while
    └─────┘

Each closing brace must match top
```

---

### 3. Expression Calculators

```
Scientific calculators evaluate using stacks:
Input: 2 + 3 * 4
Convert to postfix: 2 3 4 * +
Evaluate using stack: Result = 14
```

---

### 4. Memory Management

```
Stack frame for function calls:
    ┌──────────────────┐
    │ Local vars       │
    ├──────────────────┤
    │ Return address   │
    ├──────────────────┤
    │ Parameters       │
    └──────────────────┘

Each function call creates frame
Return pops frame
```

---

## ⚡ Performance Characteristics

### Time Complexity

```
┌─────────────┬──────────────┐
│  Operation  │ Complexity   │
├─────────────┼──────────────┤
│    Push     │    O(1)      │
│    Pop      │    O(1)      │
│    Peek     │    O(1)      │
│  IsEmpty    │    O(1)      │
│    Size     │    O(1)      │
└─────────────┴──────────────┘

All operations are constant time!
```

### Space Complexity

```
Space = O(n) where n = number of elements

Stack with n elements:
    ┌─────┐
    │  n  │
    ├─────┤
    │ ... │
    ├─────┤
    │  2  │
    ├─────┤
    │  1  │
    └─────┘

Additional space depends on implementation:
- Array: O(capacity)
- Linked List: O(n) for pointers
```

---

## 💡 Interview Insights

### Common Stack Patterns

**1. Matching Pattern**
- Balanced parentheses
- Valid HTML tags
- Syntax validation

**2. Monotonic Stack**
- Next greater element
- Stock span
- Histogram problems

**3. Expression Processing**
- Infix to postfix
- Expression evaluation
- Calculator implementation

**4. Backtracking**
- Path finding
- Permutations
- Subset generation

**5. State Tracking**
- Undo/redo
- Browser history
- Game state

---

### Problem-Solving Tips

**When to use Stack:**
- ✅ Need LIFO access
- ✅ Matching/pairing elements
- ✅ Tracking recent items
- ✅ Recursive to iterative conversion
- ✅ Expression evaluation

**Key Techniques:**
1. **Dummy bottom** - Add sentinel for easier comparison
2. **Index storage** - Store indices instead of values
3. **Monotonic** - Maintain increasing/decreasing order
4. **Two stacks** - Separate concerns (min stack, queue)

---

### Edge Cases to Consider

```
1. Empty stack
   ┌─────┐
   │     │
   └─────┘
   Pop/Peek → Error or handle gracefully

2. Single element
   ┌─────┐
   │  5  │
   └─────┘
   
3. Full stack (array-based)
   ┌─────┐
   │  9  │ ← Capacity reached
   ├─────┤
   │ ... │
   Push → Resize or error
```

---

## 🎯 Summary

Stacks are **fundamental** for many algorithms:

**Key Characteristics:**
- 🔝 LIFO (Last In, First Out)
- ⚡ O(1) for all basic operations
- 🎯 Simple but powerful
- 📚 Natural for recursion tracking

**Best Used For:**
- ✅ Function call management
- ✅ Expression evaluation
- ✅ Undo/redo operations
- ✅ Backtracking algorithms
- ✅ Syntax checking
- ✅ Matching problems

**Key Insight:** When you need to process things in reverse order or track nested structures, think **Stack**!

---

## 📚 Related Topics

- [Queue Operations & Variants](./11_QUEUES.md) - FIFO counterpart
- [Monotonic Stack & Queue](./12_MONOTONIC_STRUCTURES.md) - Advanced stack patterns
- [Singly & Doubly Linked Lists](./08_LINKED_LISTS.md) - Implementation base
- [Binary Trees Fundamentals](./13_BINARY_TREES.md) - Tree traversal with stack

