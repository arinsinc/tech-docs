# Trie Data Structure

## 📋 Overview

A **Trie** (pronounced "try"), also called a **prefix tree** or **digital tree**, is a tree-like data structure used to store and retrieve strings efficiently. Each node represents a single character, and paths from root to nodes form words or prefixes. Tries excel at prefix-based operations like autocomplete, spell checking, and dictionary lookups.

---

## 🎯 Core Concepts

### What is a Trie?

A trie is a tree where:
- **Root node** represents an empty string
- Each **edge** represents a character
- Each **path** from root to a node represents a prefix
- **Leaf nodes** or **marked nodes** indicate complete words

**Visual Representation:**
```
Example: Store words ["cat", "car", "card", "care", "dog", "dodge"]

                    ROOT
                   /    \
                  c      d
                  |      |
                  a      o
                 / \     |
                t   r    g
               *   /|\   *
                  d e *
                  | |
                  * *

* = End of word marker

Paths:
ROOT → c → a → t        = "cat" ✓
ROOT → c → a → r        = "car" ✓
ROOT → c → a → r → d    = "card" ✓
ROOT → c → a → r → e    = "care" ✓
ROOT → d → o → g        = "dog" ✓
ROOT → d → o → d → g → e = "dodge" ✓
```

**Key Characteristics:**
- 🌳 Tree structure with character edges
- 🎯 Fast prefix-based operations
- 💾 Shares common prefixes (space efficient for related words)
- ⚡ O(L) operations where L = word length

---

## 🏗️ Trie Structure

### Node Structure

Each trie node contains:
1. **Children**: Links to child nodes (one per possible character)
2. **End marker**: Boolean indicating if this node completes a word
3. **Optional data**: Additional information (frequency, word, etc.)

**Visual Node Structure:**
```
Trie Node:
┌─────────────────────────────────┐
│  Character: 'a'                 │
│  Is End of Word: false          │
│  Children (26 letters):         │
│    'a' → null                   │
│    'b' → [Node]                 │
│    'c' → null                   │
│    ...                          │
│    'z' → [Node]                 │
│  Optional: frequency, metadata  │
└─────────────────────────────────┘
```

### Alphabet Size

Common implementations:
- **Lowercase letters**: 26 children per node (a-z)
- **All letters**: 52 children (A-Z, a-z)
- **Alphanumeric**: 62 children (A-Z, a-z, 0-9)
- **ASCII**: 128 or 256 children
- **HashMap**: Dynamic children (memory efficient)

---

## 🔧 Core Operations

### 1. Insertion

**Process:**
1. Start at root
2. For each character in word:
   - If child exists, move to it
   - If not, create new node
3. Mark last node as end of word

**Visual Example - Insert "cart":**
```
Initial trie has: "cat", "car"

         ROOT
          |
          c
          |
          a
         / \
        t   r
       *    *

Step 1: Start at ROOT
Step 2: Move to 'c' (exists)
Step 3: Move to 'a' (exists)
Step 4: Move to 'r' (exists)
Step 5: Create 't' node under 'r'
Step 6: Mark 't' as word end

Result:
         ROOT
          |
          c
          |
          a
         / \
        t   r
       *   / \
          t   *
          *   (new)
```

**Time Complexity:** O(L) where L = word length  
**Space Complexity:** O(L) in worst case (all new nodes)

---

### 2. Search

**Process:**
1. Start at root
2. For each character:
   - If child exists, move to it
   - If not, word doesn't exist
3. Check if final node is marked as end

**Visual Example - Search "car":**
```
Trie contains: "cat", "car", "card"

         ROOT
          |
          c
          |
          a
         / \
        t   r
       *   /|\
          d e *
          | |
          * *

Step 1: ROOT → c ✓
Step 2: c → a ✓
Step 3: a → r ✓
Step 4: r has end marker ✓

Result: "car" EXISTS
```

**Visual Example - Search "care" (exists) vs "ca" (doesn't):**
```
Search "care":
ROOT → c → a → r → e
                    * (marked)
Result: EXISTS ✓

Search "ca":
ROOT → c → a
            (no marker)
Result: DOESN'T EXIST ✗
(prefix exists, but not a complete word)
```

**Time Complexity:** O(L)  
**Space Complexity:** O(1)

---

### 3. Prefix Search / StartsWith

**Process:**
1. Follow the path for each character
2. If path exists completely, prefix exists
3. No need to check end marker

**Visual Example:**
```
Trie: "cat", "car", "card", "care"

         ROOT
          |
          c
          |
          a
         / \
        t   r
       *   /|\
          d e *
          | |
          * *

Check prefix "car":
ROOT → c → a → r ✓
Path exists = prefix exists ✓

All words with prefix "car":
- car ✓
- card ✓
- care ✓
```

**Time Complexity:** O(L)  
**Space Complexity:** O(1)

---

### 4. Deletion

**Process:**
1. Search for the word
2. If found, unmark end-of-word
3. Remove nodes if they're not part of other words

**Visual Example - Delete "card":**
```
Before: "cat", "car", "card", "care"

         ROOT
          |
          c
          |
          a
         / \
        t   r
       *   /|\
          d e *
          | |
          * *

Step 1: Find "card" and unmark
Step 2: Check if 'd' node needed by other words
        - Not needed, remove it

After:
         ROOT
          |
          c
          |
          a
         / \
        t   r
       *   / \
          e   *
          |
          *

Words remaining: "cat", "car", "care" ✓
```

**Careful Deletion:**
```
Delete "car" from: "car", "card", "care"

         ROOT
          |
          c
          |
          a
          |
          r
         /|\
        d e *
        | |
        * *

Just unmark 'r', DON'T remove nodes:
(they're needed for "card" and "care")

         ROOT
          |
          c
          |
          a
          |
          r
         / \
        d   e
        |   |
        *   *

Result: "car" deleted, "card" and "care" remain ✓
```

**Time Complexity:** O(L)  
**Space Complexity:** O(1)

---

## 🎯 Common Use Cases

### 1. Autocomplete

**Concept:** Find all words starting with a given prefix.

**Visual Example:**
```
Dictionary: "apple", "app", "application", "apply", "banana"

User types: "app"

         ROOT
        /    \
       a      b
       |      |
       p      a
       |      |
       p      n
      /|\     |
     l l i    a
     | | |    |
     e * c    n
     |   |    |
     *   a    a
         |    *
         t
         |
         i
         |
         o
         |
         n
         |
         *

Find prefix "app":
ROOT → a → p → p ✓

Collect all words from this node:
- app ✓
- apple ✓
- application ✓
- apply ✓

Autocomplete suggestions: ["app", "apple", "application", "apply"]
```

**Real-World Application:**
- Search engines
- IDE code completion
- Mobile keyboard suggestions
- Command-line interfaces

---

### 2. Spell Checker

**Concept:** Check if word exists and suggest corrections.

**Visual Example:**
```
Dictionary trie contains: "cat", "car", "bat", "bar"

User types: "can" (not in dictionary)

Check variations at distance 1:
- Replace: "can" → "cat", "car" (found!)
- Insert: "can" → "cane", "cans" (check each)
- Delete: "can" → "ca", "cn", "an" (check each)

Suggestions: "cat", "car"
```

**Techniques:**
- **Exact match**: Standard trie search
- **Fuzzy match**: BFS/DFS with edit distance limit
- **Wildcard**: Allow '.' or '*' in search

---

### 3. Word Search in Grid

**Concept:** Find all dictionary words in a character grid.

**Visual Grid Example:**
```
Grid:           Trie: ["cat", "car", "bat"]
c a r
a t b
t b a

Search process:
1. Start from each cell
2. Use DFS traversal
3. Check each path in trie
4. Mark found words

Found paths:
- c → a → t = "cat" ✓ (diagonal)
- c → a → r = "car" ✓ (horizontal)
- b → a → t = "bat" ✓ (various paths)
```

---

### 4. IP Routing (Longest Prefix Matching)

**Concept:** Match IP address to longest matching route prefix.

**Visual Example:**
```
Routing table:
192.168.0.0/16   → Router A
192.168.1.0/24   → Router B
192.168.1.128/25 → Router C

Trie structure (binary, each bit):
                    ROOT
                   /
                  1 (first bit)
                 /
                9
               /
              2
             /
            .
           /
          ... (build full IP trie)

Lookup 192.168.1.200:
- Matches 192.168.0.0/16 → Router A
- Matches 192.168.1.0/24 → Router B
- Doesn't match 192.168.1.128/25

Best match (longest prefix): Router B
```

---

### 5. Contact Search

**Concept:** Search contacts by name prefix.

**Visual Example:**
```
Contacts:
- Alice Anderson
- Alice Brown
- Bob Anderson
- Bobby Brown

Trie by first name:
            ROOT
           /    \
          a      b
          |      |
          l      o
          |      |
          i      b
          |      |\
          c      * b
          |        |
          e        y
         / \       |
        a   b      *
        |   |
        *   *
    (Anderson) (Brown)

Search "ali" → Returns both Alices
Search "bob" → Returns Bob and Bobby
```

---

## 🎨 Visual Patterns

### Trie vs Hash Table

**Comparison:**
```
HASH TABLE:
┌──────────────┬──────────┐
│ Key          │ Value    │
├──────────────┼──────────┤
│ "cat"        │ data     │
│ "car"        │ data     │
│ "card"       │ data     │
└──────────────┴──────────┘

Pros: O(1) exact lookup
Cons: No prefix operations, no ordering

---

TRIE:
         ROOT
          |
          c
          |
          a
         / \
        t   r
       *   /|\
          d * (car)
          |
          * (card)

Pros: O(L) prefix ops, ordered, space-efficient prefixes
Cons: More space per node, slower exact lookup
```

### Compressed Trie (Radix Tree)

**Optimization:** Merge nodes with single child.

**Visual Example:**
```
Standard Trie:
         ROOT
          |
          r
          |
          o
          |
          m
          |
          a
          |
          n
         / \
        c   t
        |   |
        e   i
        |   |
        *   c
            |
            *

Compressed Trie (Radix Tree):
         ROOT
          |
        "roman"
         / \
      "ce" "tic"
       |    |
       *    *

Words: "romance", "romantic"
Saves space by combining sequential single-child nodes
```

---

## 🚀 Advanced Concepts

### 1. Ternary Search Tree

**Concept:** Hybrid between BST and Trie - three children per node.

**Visual Structure:**
```
Node structure:
      b
     /|\
    a b c
    
- Left child: characters < current
- Middle child: next character in word
- Right child: characters > current

Example with "cat", "car", "dog":
         c
         |
         a
        /|\
       r t
       * *
        \
         d
         |
         o
         |
         g
         *

Space efficient: Only 3 pointers per node
Time: O(L) average, O(L + log N) worst case
```

---

### 2. Suffix Trie

**Concept:** Store all suffixes of a string.

**Visual Example:**
```
String: "banana"

Suffixes:
- banana
- anana
- nana
- ana
- na
- a

Trie:
         ROOT
        / | \
       b  a  n
       |  |  |
       a  n  a
       |  |  |
       n  a  n
       |  |  |
       a  n  a
       |  |  |
       n  a  *
       |  |
       a  *
       |
       *

Use case: Pattern matching in strings
Time: O(M) to search pattern of length M
```

---

### 3. Trie with Frequency

**Concept:** Store word frequency for ranking.

**Visual Example:**
```
Words with frequencies:
- "cat" (100 occurrences)
- "car" (250 occurrences)
- "card" (50 occurrences)

Enhanced Node:
┌──────────────────┐
│ Character: 'r'   │
│ End: true        │
│ Frequency: 250   │
│ Children: [...]  │
└──────────────────┘

Use case: Autocomplete with popular suggestions first
Search "ca" → Return ["car" (250), "cat" (100), "card" (50)]
```

---

### 4. Wildcard Search

**Concept:** Support '.' (any character) or '*' (any sequence).

**Visual Example:**
```
Dictionary: "cat", "car", "bat", "bar"

         ROOT
        /    \
       c      b
       |      |
       a      a
      / \    / \
     t   r  t   r
     *   *  *   *

Search "ca.":
- Match 'c', then 'a', then ANY character
- Found: "cat", "car" ✓

Search ".at":
- Try ALL root children, then 'a', then 't'
- Found: "cat", "bat" ✓

Search "b*r":
- 'b', then ANY PATH, then 'r'
- Found: "bar" ✓
```

---

## 💡 Problem-Solving Patterns

### Pattern 1: Dictionary Search

**When to Use:**
- Multiple prefix queries
- Word validation
- Autocomplete

**Approach:**
1. Build trie from dictionary
2. Search with prefix
3. Collect all words from prefix node

---

### Pattern 2: Word Break

**When to Use:**
- Split string into dictionary words
- Check if string can be segmented

**Visual Example:**
```
String: "catsanddog"
Dictionary: ["cat", "cats", "and", "sand", "dog"]

Build trie:
         ROOT
        / | \
       c  a  s  d
       |  |  |  |
       a  n  a  o
       |  |  |  |
       t  d  n  g
      /|  *  |  *
     s *     d
     |       *
     *

Try splits:
"cat" + "sanddog" ✓
  ✓     try split "sanddog"
        "sand" + "dog" ✓
          ✓       ✓

Valid: "cat" + "sand" + "dog" ✓
```

---

### Pattern 3: Search with Editing

**When to Use:**
- Spell checker
- Fuzzy search
- Approximate matching

**Approach:**
1. Use DFS with edit distance tracking
2. Allow insert/delete/replace operations
3. Prune branches exceeding distance limit

---

### Pattern 4: Longest Word with Prefix

**When to Use:**
- Find longest word building on prefixes
- Sequential word building

**Visual Example:**
```
Words: ["w", "wo", "wor", "worl", "world"]

All must be buildable from prefixes:
         ROOT
          |
          w *
          |
          o *
          |
          r *
          |
          l *
          |
          d *

Each level marked = valid prefix chain
Longest: "world" ✓
```

---

## ⚖️ Complexity Analysis

### Space Complexity

**Worst Case:** O(ALPHABET_SIZE × N × L)
- N = number of words
- L = average word length
- ALPHABET_SIZE = size of character set

**Best Case (shared prefixes):** Much less
- "cat", "car", "card" share "ca" prefix

**Optimization:**
- Use HashMap for children (sparse)
- Compress single-child paths (radix tree)
- Store only necessary metadata

---

### Time Complexity

| Operation | Time | Notes |
|-----------|------|-------|
| Insert | O(L) | L = word length |
| Search | O(L) | L = word length |
| Delete | O(L) | Plus node cleanup |
| Prefix Search | O(L + K) | K = results found |
| Autocomplete | O(L + N) | N = words with prefix |

**Why Efficient:**
- Each operation proportional to word length only
- Independent of total number of words
- Shared prefixes reduce redundancy

---

## 🎯 When to Use Tries

### ✅ Use Trie When:

1. **Multiple prefix queries**
   - Autocomplete systems
   - Type-ahead search
   - Command completion

2. **Dictionary operations**
   - Spell checking
   - Word validation
   - Word games (Scrabble, Boggle)

3. **Prefix-based routing**
   - IP routing tables
   - URL routing
   - File system paths

4. **String pattern matching**
   - Multiple pattern search
   - Wildcard matching
   - Substring search

---

### ❌ Don't Use Trie When:

1. **Exact match only** → Use hash table
2. **Small dataset** → Simple array/hash sufficient
3. **Memory constrained** → Tries use lots of pointers
4. **Numeric keys** → Other structures better
5. **No prefix operations** → Hash table faster

---

## 🎨 Real-World Examples

### Example 1: Browser Autocomplete

```
User types: "stack"

Browser history trie:
         ROOT
          |
          s
          |
          t
          |
          a
          |
          c
          |
          k
         /|\
        o v e
        | | |
        v f x
        | | |
        e l c
        | | |
        r o h
        | | |
        f w a
        | | |
        l * n
        | | g
        o | e
        | | |
        w * *
        |
        *

Suggestions:
1. stackoverflow.com (most visited)
2. stackexchange.com
3. stackoverflow.com/questions/...
```

### Example 2: T9 Predictive Text

```
Phone keypad:
2(ABC) 3(DEF) 4(GHI) 5(JKL) 6(MNO) 7(PQRS) 8(TUV) 9(WXYZ)

User presses: 2-2-8 (228)

Trie maps digit sequences to words:
228 → "cat", "bat", "act", "cab"

         ROOT(228)
        /    |    \
       c     b     a
       |     |     |
       a     a     c
       |     |     |
       t     t     t
       *     *     *

Show: "cat" (most common), then "bat", "act"
```

### Example 3: File System

```
File paths stored in trie:
/home/user/documents/file1.txt
/home/user/documents/file2.txt
/home/user/downloads/image.jpg

Trie:
ROOT
 |
home
 |
user
 |\
 | downloads
 |    |
 |  image.jpg
 |
documents
 |\
 | file1.txt
 |
file2.txt

Quickly find:
- All files under /home/user
- All documents
- Path existence
```

---

## 🎯 Summary

**Tries are powerful for string operations:**

**Key Strengths:**
- ⚡ O(L) operations (L = word length)
- 🎯 Excellent for prefix operations
- 💾 Space-efficient for shared prefixes
- 📚 Natural for dictionary applications
- 🔍 Support complex string queries

**Best Applications:**
- Autocomplete systems
- Spell checkers
- Dictionary implementations
- IP routing tables
- T9 predictive text
- File systems

**Key Insight:** When your problem involves prefixes, multiple string queries, or dictionary operations, think **Trie**! The trade-off is space for fast prefix-based operations.

---

## 📚 Related Topics

- [String Processing & Pattern Matching](./04_STRINGS.md) - String fundamentals
- [Hash Tables & Hash Maps](./06_HASHING.md) - Alternative for exact match
- [Binary Search Trees](./14_BINARY_SEARCH_TREES.md) - Similar tree structure
- [Graph Traversals](./20_GRAPH_TRAVERSALS.md) - DFS/BFS in tries
- [Dynamic Programming](./24_DYNAMIC_PROGRAMMING_BASICS.md) - Word break problems
