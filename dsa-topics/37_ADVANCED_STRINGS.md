# Advanced String Algorithms

## 📋 Overview

**Advanced String Algorithms** go beyond basic string manipulation to solve complex pattern matching, searching, and transformation problems efficiently. These algorithms are fundamental in text editors, search engines, bioinformatics, data compression, and many other applications. Understanding these techniques is crucial for senior-level technical interviews.

**Difficulty Level**: 🔴 Advanced

---

## 🎯 Why Advanced String Algorithms?

### Real-World Applications

1. **Search Engines**: Fast pattern matching in massive text
2. **Plagiarism Detection**: Finding similar text patterns
3. **DNA Sequencing**: Genome matching and analysis
4. **Text Editors**: Find and replace, auto-completion
5. **Data Compression**: Identifying repeated patterns
6. **Spell Checkers**: Edit distance calculations
7. **Network Security**: Intrusion detection, pattern matching

---

## 🔍 Pattern Matching Algorithms

### Naive Pattern Matching

**Concept**: Check every position in text for pattern.

```
Text:    "ABABCABCAB"
Pattern: "ABCAB"

Check position 0:
ABABCABCAB
ABCAB
✗ Mismatch at position 2

Check position 1:
ABABCABCAB
 ABCAB
✗ Mismatch at position 0

Check position 2:
ABABCABCAB
  ABCAB
✗ Mismatch at position 1

Check position 3:
ABABCABCAB
   ABCAB
✗ Mismatch at position 0

Check position 4:
ABABCABCAB
    ABCAB
✗ Mismatch at position 0

Check position 5:
ABABCABCAB
     ABCAB
✓ Match found at position 5!

Time: O(m × n) where m = text length, n = pattern length
```

---

## 🎨 KMP Algorithm (Knuth-Morris-Pratt)

### Core Concept

**Key Insight**: Use information from previous comparisons to avoid redundant checks.

**Main Idea**: When mismatch occurs, don't restart from beginning. Jump to a position based on pattern's structure.

### LPS Array (Longest Proper Prefix which is also Suffix)

```
Pattern: "ABABCAB"

LPS array construction:

Position: 0 1 2 3 4 5 6
Pattern:  A B A B C A B
LPS:      0 0 1 2 0 1 2

Meaning:
- LPS[0] = 0 (no proper prefix)
- LPS[1] = 0 (no match)
- LPS[2] = 1 (A matches)
- LPS[3] = 2 (AB matches)
- LPS[4] = 0 (ABC has no prefix = suffix)
- LPS[5] = 1 (ABABCA → A matches)
- LPS[6] = 2 (ABABCAB → AB matches)

Visual for "ABABCAB":
A B A B C A B
↑ ↑ → match (LPS[2] = 1)

A B A B C A B
↑ ↑ ↑ ↑ → match (LPS[3] = 2)

A B A B C A B
        ↑ ↑ → match (LPS[5] = 1)

A B A B C A B
        ↑ ↑ ↑ ↑ → match (LPS[6] = 2)
```

### Pattern Matching with KMP

```
Text:    "ABABCABABCAB"
Pattern: "ABABCAB"
LPS:     [0,0,1,2,0,1,2]

Matching process:

Position 0:
ABABCABABCAB
ABABCAB
Match: A B A B C
i=0-4, j=0-4 ✓

Position 5:
ABABCABABCAB
ABABCAB
     ↑ ↑
Mismatch at j=5 (C vs A)
Use LPS: j = LPS[4] = 0
Don't move i backward!

Continue from:
ABABCABABCAB
     ABABCAB
Match found at position 5!

Key: When mismatch at j, jump to LPS[j-1]
Avoid rechecking matched prefix
```

**Time Complexity**: O(m + n)
- Build LPS: O(n)
- Search: O(m)

---

## 🔄 Rabin-Karp Algorithm

### Core Concept

**Rolling Hash**: Use hash values to quickly compare pattern with text substrings.

**Key Idea**: 
1. Compute hash of pattern
2. Compute hash of text substrings using rolling hash
3. If hashes match, verify actual characters

### Rolling Hash Mechanism

```
Text: "ABCDE"
Pattern: "BCD" (length 3)

Hash function: h(s) = (s[0] × d² + s[1] × d + s[2]) mod q
where d = number of characters, q = large prime

Step 1: Hash pattern
h("BCD") = (B × 10² + C × 10 + D) mod 13
         = (2 × 100 + 3 × 10 + 4) mod 13
         = 234 mod 13 = 0

Step 2: Hash first window "ABC"
h("ABC") = (1 × 100 + 2 × 10 + 3) mod 13
         = 123 mod 13 = 6
6 ≠ 0, no match

Step 3: Roll to "BCD"
Remove 'A', add 'D':
h("BCD") = ((123 - 1 × 100) × 10 + 4) mod 13
         = (23 × 10 + 4) mod 13
         = 234 mod 13 = 0
0 = 0, match! Verify characters: "BCD" = "BCD" ✓

Visual:
Text:  A B C D E
      [A B C]     hash = 6
        [B C D]   hash = 0 → match!
```

**Rolling hash formula**:
```
Remove leading character: hash = (hash - text[i] × h) × d
Add trailing character: hash = hash + text[i + m]

Where h = d^(m-1) mod q
```

**Time Complexity**: O(m + n) average, O(mn) worst (hash collisions)

---

## 🎯 Z-Algorithm

### Core Concept

**Z-array**: For each position i, Z[i] is the length of the longest substring starting from i that matches a prefix of the string.

```
String: "AABXAAY"

Z-array calculation:

Position: 0 1 2 3 4 5 6
String:   A A B X A A Y
Z-array:  - 1 0 0 2 1 0

Meaning:
Z[0] = undefined (whole string)
Z[1] = 1 (A matches first character)
Z[2] = 0 (B doesn't match A)
Z[3] = 0 (X doesn't match A)
Z[4] = 2 (AA matches AA)
Z[5] = 1 (A matches A)
Z[6] = 0 (Y doesn't match A)

Visual:
A A B X A A Y
↑ ↑ → Z[1] = 1

A A B X A A Y
↑ ↑ → Z[2] = 0 (B ≠ A)

A A B X A A Y
↑     ↑ ↑ → Z[4] = 2 (AA matches)
```

### Pattern Matching with Z-Algorithm

```
Pattern: "ABC"
Text: "XABCYABC"

Concatenate: "ABC$XABCYABC"
             ($ is separator)

Compute Z-array:
Position: 0 1 2 3 4 5 6 7 8 9 10 11
String:   A B C $ X A B C Y A B  C
Z-array:  - 0 0 0 0 3 0 0 0 3 0  0

Z[i] = 3 (pattern length) indicates match!
Matches at positions: 5, 9 (in concatenated string)
Original positions: 1, 5 (in text)

Text positions:
XABCYABC
 ↑   ↑
 1   5 (matches found)
```

**Time Complexity**: O(m + n)

---

## 📏 Edit Distance (Levenshtein Distance)

### Core Concept

**Minimum operations** to transform one string to another.

**Operations allowed**:
1. Insert a character
2. Delete a character
3. Replace a character

### Visual Process

```
Transform "HORSE" to "ROS"

        ""  R  O  S
    ""  0   1  2  3
    H   1   1  2  3
    O   2   2  1  2
    R   3   2  2  2
    S   4   3  3  2
    E   5   4  4  3

Bottom-right cell: 3 (minimum operations)

Operations:
1. Replace H with R: "RORSE"
2. Delete R: "ROSE"
3. Delete E: "ROS"

Or:
1. Delete H: "ORSE"
2. Delete E: "ORS"
3. Replace R with R: "ORS" (or delete O, add R at start)

Recurrence:
if s1[i] == s2[j]:
    dp[i][j] = dp[i-1][j-1]
else:
    dp[i][j] = 1 + min(
        dp[i-1][j],    // delete from s1
        dp[i][j-1],    // insert into s1
        dp[i-1][j-1]   // replace
    )
```

**Time Complexity**: O(m × n)
**Space Complexity**: O(m × n), can be optimized to O(min(m,n))

---

## 🧬 Longest Common Substring

### Core Concept

**Find longest substring** common to two strings.

```
String 1: "ABCDGH"
String 2: "ACDGHR"

DP Table:
        ""  A  C  D  G  H  R
    ""  0   0  0  0  0  0  0
    A   0   1  0  0  0  0  0
    B   0   0  0  0  0  0  0
    C   0   0  1  0  0  0  0
    D   0   0  0  2  0  0  0
    G   0   0  0  0  3  0  0
    H   0   0  0  0  0  4  0

Maximum value: 4 at position (5, 5)

Recurrence:
if s1[i] == s2[j]:
    dp[i][j] = dp[i-1][j-1] + 1
else:
    dp[i][j] = 0

Longest common substring: "CDGH" (length 4)

Visual:
ABCDGH
  ||||
  CDGHR
```

**Time Complexity**: O(m × n)

---

## 🎨 Longest Common Subsequence (LCS)

### Core Concept

**Find longest subsequence** present in both strings (not necessarily contiguous).

```
String 1: "AGGTAB"
String 2: "GXTXAYB"

DP Table:
        ""  G  X  T  X  A  Y  B
    ""  0   0  0  0  0  0  0  0
    A   0   0  0  0  0  1  1  1
    G   0   1  1  1  1  1  1  1
    G   0   1  1  1  1  1  1  1
    T   0   1  1  2  2  2  2  2
    A   0   1  1  2  2  3  3  3
    B   0   1  1  2  2  3  3  4

Maximum value: 4

Recurrence:
if s1[i] == s2[j]:
    dp[i][j] = dp[i-1][j-1] + 1
else:
    dp[i][j] = max(dp[i-1][j], dp[i][j-1])

LCS: "GTAB" (length 4)

Visual (not contiguous):
AGGTAB
 | | |
GXTXAYB
```

**Time Complexity**: O(m × n)

---

## 🔤 Suffix Array

### Core Concept

**Sorted array of all suffixes** of a string.

```
String: "banana"

All suffixes:
0: banana
1: anana
2: nana
3: ana
4: na
5: a

Sorted suffixes:
5: a
3: ana
1: anana
0: banana
4: na
2: nana

Suffix Array: [5, 3, 1, 0, 4, 2]

Uses:
- Pattern matching in O(m log n)
- Finding repeated substrings
- Longest common substring of multiple strings
```

### Pattern Matching with Suffix Array

```
String: "banana"
Suffix Array: [5, 3, 1, 0, 4, 2]

Find pattern "ana":

Binary search in suffix array:
Suffixes starting positions:
5: a      → "ana" > "a"
3: ana    → "ana" = "ana" ✓
1: anana  → "ana" < "anana"
...

Found at positions: 1, 3

Visual:
banana
 |||
 ana (position 1)

banana
   |||
   ana (position 3)
```

**Construction Time**: O(n log² n) or O(n log n) with advanced methods
**Search Time**: O(m log n)

---

## 🎪 Manacher's Algorithm (Longest Palindromic Substring)

### Core Concept

**Find longest palindrome** in linear time using symmetry properties.

```
String: "ABACABAD"

Transform: Add separators
"#A#B#A#C#A#B#A#D#"

For each center, find palindrome radius:

Position: 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16
String:   # A # B # A # C # A #  B  #  A  #  D  #
Radius:   0 1 0 1 0 3 0 1 0 1 0  3  0  1  0  1  0

Largest radius: 3 at positions 5 and 11

Position 5: "#A#B#A#" → "ABA" (length 3)
Position 11: "#A#B#A#" → "ABA" (length 3)

Visual:
ABACABAD
 ^^^     → palindrome "ABA"

ABACABAD
     ^^^  → palindrome "ABA"

Longest palindrome: "ABA" (multiple occurrences)
```

**Key Optimization**: Use previously computed palindromes to avoid redundant checks.

**Time Complexity**: O(n)

---

## 🌳 Trie-Based Algorithms

### Aho-Corasick Algorithm

**Concept**: Multiple pattern matching using trie with failure links.

```
Patterns: ["he", "she", "his", "hers"]
Text: "ahishers"

Build trie with patterns:
       root
      /    \
    h       s
   / \       \
  e   i       h
  |   |       |
  r   s       e
  |
  s

Add failure links (fall back on mismatch)

Matching process:
Text: "ahishers"

Position 0-1: 'a' → no match, continue
Position 1-2: 'h' → start matching
Position 2-3: 'hi' → found "h", continue
Position 3-4: 'his' → found "his" ✓
Position 4-5: 'hish' → fail, use failure link
Position 4-7: 'she' → found "she" ✓
...

Patterns found: "his" at 1, "she" at 3, "he" at 4, "hers" at 4
```

**Time Complexity**: O(m + n + z) where z is number of matches

---

## 💡 String Compression

### Run-Length Encoding

```
String: "AAAABBBCCDDDD"

Compressed: "4A3B2C4D"

Process:
AAAABBBCCDDDD
↑↑↑↑ → count=4, char=A → "4A"
    ↑↑↑ → count=3, char=B → "3B"
       ↑↑ → count=2, char=C → "2C"
         ↑↑↑↑ → count=4, char=D → "4D"

Result: "4A3B2C4D" (original: 13, compressed: 8)

Note: Only effective for strings with many repeats
"ABCD" → "1A1B1C1D" (expansion!)
```

### Longest Repeated Substring

```
String: "banana"

Find longest substring that appears at least twice:

Suffixes:
banana
anana
nana
ana
na
a

Compare consecutive suffixes:
banana vs anana: common prefix = "ana" (length 3)
anana vs nana: common prefix = "ana" (length 3)
nana vs ana: common prefix = "ana" (length 3)
ana vs na: common prefix = "a" (length 1)
na vs a: common prefix = "a" (length 1)

Longest: "ana" (length 3)

Visual:
banana
 |||
 ana (first occurrence)

banana
   |||
   ana (second occurrence)
```

---

## 🎯 Advanced Pattern Matching Problems

### 1. Wildcard Matching

```
Text: "adceb"
Pattern: "*a*b"

* matches zero or more characters

Match "adceb" with "*a*b":
* → matches "ad"
a → matches "a" (rejected, already matched)
  Try: * → matches "adc"
  a → matches "a" (rejected)
  Try: * → matches ""
  a → matches "a" at position 0
  * → matches "dc"
  b → matches "b" at position 4
✓ Pattern matches!

DP approach:
        ""  *  a  *  b
    ""  T   T  F  F  F
    a   F   T  T  T  F
    d   F   T  F  T  F
    c   F   T  F  T  F
    e   F   T  F  T  F
    b   F   T  F  T  T

Bottom-right: TRUE (match)
```

### 2. Regular Expression Matching

```
Text: "aab"
Pattern: "c*a*b"

. matches any single character
* matches zero or more of preceding element

Match process:
c* → matches "" (zero c's)
a* → matches "aa"
b → matches "b"
✓ Pattern matches!

Visual:
Pattern: c * a * b
         ↓   ↓   ↓
Text:    [aa] b
```

### 3. Shortest Palindrome

```
String: "aacecaaa"

Find shortest palindrome by adding characters to front:

Check: "aacecaaa" palindrome? No
Add 'a': "aaacecaaa" palindrome? No
Add 'aa': "aaaacecaaa" palindrome? Yes!

Result: "aaacecaaa"

Efficient approach: Use KMP/Z-algorithm to find longest palindrome prefix
```

---

## 🎓 Key Takeaways

1. **KMP avoids redundant comparisons** - uses LPS array
2. **Rabin-Karp uses rolling hash** - good for multiple patterns
3. **Z-algorithm is simple and efficient** - linear time pattern matching
4. **Edit distance is fundamental** - spell check, DNA alignment
5. **Suffix arrays are powerful** - many string problems
6. **Manacher's is elegant** - linear time palindrome finding
7. **Aho-Corasick for multiple patterns** - dictionary matching
8. **DP solves many string problems** - LCS, edit distance, wildcards

---

## 💡 Interview Tips

### Problem Recognition

**Use advanced string algorithms when**:
- Pattern matching with constraints
- Multiple pattern searching
- String transformations
- Palindrome problems
- Substring/subsequence questions
- Edit distance problems

### Choosing the Right Algorithm

**KMP**: Single pattern, need linear time
**Rabin-Karp**: Multiple patterns, simple implementation
**Z-Algorithm**: Linear time, simple to understand
**Suffix Array**: Multiple queries on same text
**Trie/Aho-Corasick**: Dictionary, multiple patterns
**DP**: Transformation, LCS, edit distance

### Common Patterns

1. **Preprocessing + Query**: Build structure once, query many times
2. **DP for transformation**: Edit distance, wildcards
3. **Hash for approximate matching**: Rabin-Karp
4. **Symmetry for palindromes**: Manacher's algorithm
5. **Prefix/Suffix properties**: KMP, Z-algorithm

---

## 🔗 Related Topics

- [Strings Basics](./04_STRINGS.md) - Foundation
- [Dynamic Programming](./24_DYNAMIC_PROGRAMMING_BASICS.md) - String DP
- [Tries](./23_TRIES.md) - Pattern matching structure
- [Hashing](./06_HASHING.md) - Rolling hash technique

---

## 🎉 Congratulations!

You've completed the DSA Interview Guide! These advanced string algorithms represent some of the most sophisticated techniques in computer science. Master them to excel in senior-level interviews and real-world applications.

**Keep practicing and good luck with your interviews!** 🚀
