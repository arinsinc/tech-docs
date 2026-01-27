# Backtracking Fundamentals

## 📋 Overview

**Backtracking** is an algorithmic technique for solving problems recursively by trying to build a solution incrementally, one piece at a time, and removing ("backtracking") solutions that fail to satisfy constraints at any point. It's a systematic way to explore all possible solutions by trying different paths and abandoning them when they lead nowhere.

---

## 🎯 Core Concepts

### What is Backtracking?

Backtracking is:
- **Exhaustive search** with pruning
- **Recursive** exploration of solution space
- **Try, check, and undo** approach
- **Depth-first** traversal of decision tree
- Smart **brute force** - eliminates impossible paths early

**Visual Analogy - Maze Navigation:**
```
Finding path through maze:

Start → ╔═══╗ → ╔═══╗ → ╔═══╗
        ║ ? ║   ║ ? ║   ║ ? ║
        ╚═══╝   ╚═══╝   ╚═══╝

Try path 1:
Start → Right → Right → WALL ✗
            ↓
        Backtrack!

Try path 2:
Start → Right → Down → Down → Exit ✓

This is backtracking:
- Try a direction
- Hit dead end → go back (backtrack)
- Try different direction
- Repeat until solution found
```

### Key Characteristics

**Template Structure:**
```
1. Choose: Make a choice
2. Explore: Recursively explore with that choice
3. Unchoose: Undo the choice (backtrack)
4. Repeat for all choices
```

**Visual Decision Tree:**
```
                    Root (initial state)
                   /    |    \
              Choice1 Choice2 Choice3
              /  |  \   /  \   /  \
            ...  ... ... ... ... ...

Backtracking explores this tree:
- Goes deep (DFS)
- Backtracks when invalid
- Prunes branches early
```

---

## 🎨 Visual Understanding

### Backtracking Process

```
State Space Tree:

                        []
                    /   |   \
                [1]    [2]   [3]
               / \     / \    / \
            [1,2][1,3][2,1]...  ...

Backtracking traversal:
1. Start at root
2. Pick a child (make choice)
3. Explore recursively
4. If dead end, return (backtrack)
5. Try next child
6. Repeat

Visual with marks:
✓ = explored
✗ = pruned (invalid)
? = not yet explored

                     [] ✓
                /    |    \
           [1] ✓   [2]✓  [3]?
          /  \      / \
      [1,2]✓[1,3]✗[2,1]✓
```

### Three-Step Pattern

```
Step 1: CHOOSE
┌──────────────┐
│ Add element  │
│ Mark as used │
│ Update state │
└──────────────┘
       ↓
Step 2: EXPLORE
┌──────────────┐
│   Recurse    │
│  to next     │
│    level     │
└──────────────┘
       ↓
Step 3: UNCHOOSE
┌──────────────┐
│Remove element│
│Unmark as used│
│ Restore state│
└──────────────┘
```

---

## 📚 Classic Backtracking Problems

### 1. N-Queens Problem

**Problem:** Place N queens on N×N chessboard so no two attack each other.

**Visual Example - 4 Queens:**
```
Goal: Place 4 queens on 4×4 board

Queens attack:
- Same row
- Same column  
- Same diagonal

Attempt 1:
┌───┬───┬───┬───┐
│ Q │   │   │   │ Row 0
├───┼───┼───┼───┤
│   │   │   │ Q │ Row 1
├───┼───┼───┼───┤
│ Q │   │   │   │ Row 2 ✗ Same column as row 0!
├───┼───┼───┼───┤
│   │   │   │   │
└───┴───┴───┴───┘
BACKTRACK!

Attempt 2:
┌───┬───┬───┬───┐
│ Q │   │   │   │ Row 0, Col 0
├───┼───┼───┼───┤
│   │   │ Q │   │ Row 1, Col 2 ✓
├───┼───┼───┼───┤
│   │   │   │ Q │ Row 2, Col 3 ✗ Diagonal conflict!
└───┴───┴───┴───┘
BACKTRACK!

Solution:
┌───┬───┬───┬───┐
│   │ Q │   │   │ Row 0, Col 1
├───┼───┼───┼───┤
│   │   │   │ Q │ Row 1, Col 3
├───┼───┼───┼───┤
│ Q │   │   │   │ Row 2, Col 0
├───┼───┼───┼───┤
│   │   │ Q │   │ Row 3, Col 2
└───┴───┴───┴───┘
SUCCESS! ✓

Decision tree:
                   Empty Board
                 /    |    |    \
            Q@(0,0) Q@(0,1) Q@(0,2) Q@(0,3)
            /  |  \
        Q@(1,0)✗ Q@(1,1)✗ Q@(1,2)✓
                        /  |  \
                   Q@(2,0)✗ Q@(2,1)✗ Q@(2,3)✗
                   
✗ = Invalid placement (attack detected)
✓ = Valid, continue exploring
```

**Constraint Checking:**
```
For queen at (row, col):

Column conflict:
  Any queen in same column

Row conflict:
  Any queen in same row (we place one per row)

Diagonal conflict:
  Main diagonal: row - col is constant
  Anti-diagonal: row + col is constant

Example:
Board:
  0 1 2 3
0 . Q . .  (0,1): row-col=-1, row+col=1
1 . . . Q  (1,3): row-col=-2, row+col=4
2 Q . . .  (2,0): row-col=2, row+col=2
3 . . Q .  (3,2): row-col=1, row+col=5

No duplicates in:
- Columns: {1,3,0,2} ✓
- row-col: {-1,-2,2,1} ✓
- row+col: {1,4,2,5} ✓
Valid solution!
```

---

### 2. Sudoku Solver

**Problem:** Fill 9×9 grid so each row, column, and 3×3 box contains digits 1-9.

**Visual Example:**
```
Input (. = empty):
┌─────┬─────┬─────┐
│5 3 .│. 7 .│. . .│
│6 . .│1 9 5│. . .│
│. 9 8│. . .│. 6 .│
├─────┼─────┼─────┤
│8 . .│. 6 .│. . 3│
│4 . .│8 . 3│. . 1│
│7 . .│. 2 .│. . 6│
├─────┼─────┼─────┤
│. 6 .│. . .│2 8 .│
│. . .│4 1 9│. . 5│
│. . .│. 8 .│. 7 9│
└─────┴─────┴─────┘

Backtracking process:
1. Find empty cell (0,2)
2. Try digit 1: Check row/col/box ✗ (used)
3. Try digit 2: Check constraints ✗
4. Try digit 4: Check constraints ✓
5. Place 4, move to next empty
6. Continue...
7. If stuck, backtrack and try different digit

Decision at cell (0,2):
      (0,2)=?
    / | ... \
  1✗ 2✗ ... 4✓
             |
          Next cell
             |
            ...

Constraint checking for (0,2)=4:
Row 0: {5,3,_,_,7,_,_,_,_} - 4 not in row ✓
Col 2: {_,_,8,_,_,_,_,_,_} - 4 not in col ✓
Box (0,0): {5,3,_,6,_,_,_,9,8} - 4 not in box ✓
Valid! Continue.
```

---

### 3. Generate Parentheses

**Problem:** Generate all valid combinations of n pairs of parentheses.

**Visual Example - n=3:**
```
Need 3 open '(' and 3 close ')' parentheses

Decision tree:
                    ""
                    |
                   "("
                  /   \
               "(("    "()"
              /   \      |
           "((("  "(())"()()"
            |       |      |
          "((()))" ...    ...

Rules (pruning):
1. Can add '(' if count < n
2. Can add ')' if count < open count
3. Valid when open=n and close=n

Step-by-step for "((()))":
Step 1: "" → "(" (open=1, close=0) ✓
Step 2: "(" → "((" (open=2, close=0) ✓
Step 3: "((" → "(((" (open=3, close=0) ✓
Step 4: "(((" → "((()" (open=3, close=1) ✓
Step 5: "((()" → "((())" (open=3, close=2) ✓
Step 6: "((())" → "((()))" (open=3, close=3) ✓ VALID!

All valid combinations for n=3:
1. ((()))
2. (()())
3. (())()
4. ()(())
5. ()()()

Invalid paths (pruned):
")(" ✗ (can't start with ')')
"(((" → "))))" ✗ (close > open)
"((((" ✗ (open > n)
```

---

### 4. Permutations

**Problem:** Generate all permutations of array elements.

**Visual Example - [1,2,3]:**
```
Decision tree:

                    []
          /         |         \
        [1]        [2]        [3]
       /   \      /   \      /   \
    [1,2] [1,3] [2,1] [2,3] [3,1] [3,2]
      |     |     |     |     |     |
   [1,2,3][1,3,2][2,1,3][2,3,1][3,1,2][3,2,1]

All 6 permutations found!

Process for [1,2,3]:

Level 0: Choose from {1,2,3}
  Choose 1 → [1], remaining {2,3}
    Level 1: Choose from {2,3}
      Choose 2 → [1,2], remaining {3}
        Level 2: Choose from {3}
          Choose 3 → [1,2,3] ✓ COMPLETE
        Backtrack → [1,2]
      Backtrack → [1]
      Choose 3 → [1,3], remaining {2}
        Level 2: Choose from {2}
          Choose 2 → [1,3,2] ✓ COMPLETE
  Backtrack → []
  Choose 2 → [2], remaining {1,3}
    ... continue

Visual with used array:
Start: perm=[], used=[F,F,F]
  Add 1: perm=[1], used=[T,F,F]
    Add 2: perm=[1,2], used=[T,T,F]
      Add 3: perm=[1,2,3], used=[T,T,T] ✓
      Remove 3: perm=[1,2], used=[T,T,F]
    Remove 2: perm=[1], used=[T,F,F]
    Add 3: perm=[1,3], used=[T,F,T]
      Add 2: perm=[1,3,2], used=[T,T,T] ✓
```

---

### 5. Subsets

**Problem:** Generate all subsets (power set) of array.

**Visual Example - [1,2,3]:**
```
Decision tree (include/exclude):

                     []
                /           \
          Include 1        Exclude 1
             [1]               []
           /     \           /     \
      Include 2 Exclude 2 ...     ...
         [1,2]    [1]
        /    \   /    \
       ...  ... ...  ...

All subsets:
[]          - include nothing
[1]         - include only 1
[2]         - include only 2
[3]         - include only 3
[1,2]       - include 1,2
[1,3]       - include 1,3
[2,3]       - include 2,3
[1,2,3]     - include all

8 subsets total (2³)

Process visualization:
Start with []
  Consider 1: Include → [1], Exclude → []
    Consider 2 (from [1]):
      Include → [1,2]
        Consider 3:
          Include → [1,2,3] ✓
          Exclude → [1,2] ✓
      Exclude → [1]
        Consider 3:
          Include → [1,3] ✓
          Exclude → [1] ✓
    Consider 2 (from []):
      Include → [2]
        Consider 3:
          Include → [2,3] ✓
          Exclude → [2] ✓
      Exclude → []
        Consider 3:
          Include → [3] ✓
          Exclude → [] ✓

Tree with all 8 leaves:
                    []
           /                  \
         [1]                   []
      /       \             /       \
   [1,2]     [1]         [2]        []
   /  \      /  \        /  \       /  \
[1,2,3][1,2][1,3][1]  [2,3][2]   [3] []
  ✓     ✓     ✓    ✓     ✓   ✓    ✓   ✓
```

---

### 6. Word Search

**Problem:** Find if word exists in 2D grid by connecting adjacent cells.

**Visual Example:**
```
Grid:           Word: "ABCCED"
A B C E
S F C S
A D E E

Search starting from 'A' at (0,0):

Step 1: A at (0,0) ✓
Path: [(0,0)]
┌─→─┬───┬───┬───┐
│ A │ B │ C │ E │
├───┼───┼───┼───┤
│ S │ F │ C │ S │
├───┼───┼───┼───┤
│ A │ D │ E │ E │
└───┴───┴───┴───┘

Step 2: B at (0,1) ✓
Path: [(0,0), (0,1)]
┌───┬─→─┬───┬───┐
│ A → B │ C │ E │
├───┼───┼───┼───┤
│ S │ F │ C │ S │
├───┼───┼───┼───┤
│ A │ D │ E │ E │
└───┴───┴───┴───┘

Step 3: C at (0,2) ✓
Path: [(0,0), (0,1), (0,2)]
┌───┬───┬─→─┬───┐
│ A → B → C │ E │
├───┼───┼───┼───┤
│ S │ F │ C │ S │
├───┼───┼───┼───┤
│ A │ D │ E │ E │
└───┴───┴───┴───┘

Step 4: C at (1,2) ✓
Path: [(0,0), (0,1), (0,2), (1,2)]
┌───┬───┬───┬───┐
│ A → B → C │ E │
├───┼───┼─↓─┼───┤
│ S │ F │ C │ S │
├───┼───┼───┼───┤
│ A │ D │ E │ E │
└───┴───┴───┴───┘

Step 5: E at (2,2) ✓
Path: [(0,0), (0,1), (0,2), (1,2), (2,2)]
┌───┬───┬───┬───┐
│ A → B → C │ E │
├───┼───┼───┼───┤
│ S │ F │ C │ S │
├───┼───┼─↓─┼───┤
│ A │ D │ E │ E │
└───┴───┴───┴───┘

Step 6: D at (2,1) ✓
Path: [(0,0), (0,1), (0,2), (1,2), (2,2), (2,1)]
FOUND: "ABCCED" ✓

Backtracking scenario:
If 'D' wasn't at (2,1):
  Backtrack from (2,2)
  Try other directions from (1,2)
  If none work, backtrack further
  Try different starting 'A'
```

---

## 🎯 Backtracking Patterns

### Pattern 1: Decision Tree Exploration

**When to Use:**
- Multiple choices at each step
- Build solution incrementally
- Need all solutions or one valid solution

**Template:**
```
Explore from current state:
  If complete: add to results
  For each choice:
    If valid:
      Make choice
      Recursively explore
      Undo choice (backtrack)
```

---

### Pattern 2: Constraint Satisfaction

**When to Use:**
- Must satisfy multiple constraints
- Each choice affects future choices
- Need to validate at each step

**Examples:**
- N-Queens (no attacks)
- Sudoku (row/col/box unique)
- Graph coloring

**Visual:**
```
        Current State
             ↓
    Check Constraints
       /           \
    Valid        Invalid
      ↓              ↓
   Continue      Backtrack
```

---

### Pattern 3: Combination/Subset Generation

**When to Use:**
- Generate all combinations
- Include/exclude decisions
- Power set problems

**Template:**
```
For each element:
  Option 1: Include element
  Option 2: Exclude element
```

---

### Pattern 4: Permutation Generation

**When to Use:**
- Order matters
- Use each element exactly once
- Generate all arrangements

**Template:**
```
For each unused element:
  Add to current permutation
  Mark as used
  Recurse
  Unmark and remove
```

---

## 💡 Optimization Techniques

### 1. Pruning

**Concept:** Stop exploring branches that can't lead to valid solutions.

```
Without pruning:
        Root
      /  |  \
     ✗  ✓   ✗
    /|\  |\  /|\
   ✗✗✗ ✓✗ ✗✗✗
Explores all ✗ branches

With pruning:
        Root
      /  |  \
     ✗  ✓   ✗
        |\
        ✓✗
Only explores promising branches!
```

### 2. Early Termination

**Concept:** Stop when first solution found (if only one needed).

```
Finding any valid path:
    Root
   /   \
  ✓    ?
  ↓
Found! Stop here.
Don't explore right branch.
```

### 3. Constraint Checking

**Concept:** Check constraints before recursive call, not after.

```
Bad (check after):
  Make choice
  Recurse
  Check if valid ✗ (wasted recursion!)

Good (check before):
  If choice is valid:
    Make choice
    Recurse ✓
```

### 4. Memoization

**Concept:** Cache results of repeated states.

```
State: "ABC_" (positions filled)
If seen before: return cached result
If new: compute and cache

Reduces redundant computation
```

---

## 🎯 Time & Space Complexity

### Time Complexity

**Typical complexities:**
- **Permutations**: O(n! × n)
- **Subsets**: O(2ⁿ × n)
- **N-Queens**: O(n!)
- **Sudoku**: O(9^(empty cells))

**Why exponential?**
```
Decision tree branches exponentially:
Level 0: 1 node
Level 1: n nodes
Level 2: n² nodes
Level 3: n³ nodes
...
Total: Exponential in depth
```

### Space Complexity

**Components:**
1. **Recursion stack**: O(depth)
2. **State storage**: O(solution size)
3. **Visited tracking**: O(n)

**Example - Permutations:**
```
n = 5 elements
Stack depth: 5 (one per element)
Current permutation: 5 elements
Used array: 5 booleans
Space: O(n) = O(5)
```

---

## 🎯 Common Pitfalls

### 1. Forgetting to Backtrack

```
❌ Bad:
  Add element
  Recurse
  (Don't remove) ← Bug!

✓ Good:
  Add element
  Recurse
  Remove element ← Backtrack!
```

### 2. Not Pruning Invalid Paths

```
❌ Bad:
  Always recurse
  Check validity at end

✓ Good:
  If valid:
    Recurse
  Else:
    Skip (prune)
```

### 3. Mutating Shared State

```
❌ Bad:
  Global list modified in place
  Parallel branches see changes

✓ Good:
  Pass copies of state
  Or properly backtrack changes
```

---

## 🎯 Summary

**Backtracking is systematic exhaustive search:**

**Key Characteristics:**
- 🎯 Try all possibilities with pruning
- 🔄 Recursive exploration (DFS)
- ⬅️ Undo choices (backtrack)
- ⚡ Exponential time (usually)

**Three-Step Pattern:**
1. **Choose** - Make a decision
2. **Explore** - Recurse with that choice
3. **Unchoose** - Undo and try next

**Best Used For:**
- ✅ Constraint satisfaction (N-Queens, Sudoku)
- ✅ Generating combinations/permutations
- ✅ Path finding in grids
- ✅ Subset generation
- ✅ Puzzle solving

**Recognition Signals:**
- "Generate all..."
- "Find all valid..."
- "Can you place..."
- "Solve puzzle..."
- Multiple constraints

**Remember:** Backtracking explores the solution space like a maze - try a path, backtrack if it fails, try another. The key is efficient pruning to avoid exploring dead ends!

---

## 📚 Related Topics

- [Combinatorial Problems](./30_COMBINATORICS.md) - Specific applications
- [Graph Traversals (DFS)](./20_GRAPH_TRAVERSALS.md) - Similar exploration
- [Dynamic Programming](./24_DYNAMIC_PROGRAMMING_BASICS.md) - Alternative for overlapping subproblems
- [Recursion](./02_PROBLEM_SOLVING_PATTERNS.md) - Foundation
- [Depth-First Search](./20_GRAPH_TRAVERSALS.md) - Related technique
