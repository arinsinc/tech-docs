# String Processing & Pattern Matching

## 📋 Overview

Strings are sequences of characters and one of the most common data types in programming interviews. String manipulation, searching, and pattern matching are essential skills for solving real-world problems.

---

## 🎯 Core Concepts

### 1. **String Basics**

#### Immutability
- In many languages (Java, Python, JavaScript), strings are immutable
- Modifications create new strings, leading to O(n) operations
- Use StringBuilder/StringBuffer for multiple modifications

#### Character Operations
- ASCII values: 'a' = 97, 'A' = 65, '0' = 48
- Lowercase to uppercase: char - 32
- Uppercase to lowercase: char + 32
- Character to digit: char - '0'

---

## 🔧 Common String Techniques

### 1. **Two Pointer Approach**

**Use Case**: Palindrome checking, reversing, comparing

**Example: Valid Palindrome**
- Given: "A man, a plan, a canal: Panama"
- Approach:
  - Use two pointers from start and end
  - Skip non-alphanumeric characters
  - Compare characters (case-insensitive)
  - Move pointers inward until they meet

**Time**: O(n) | **Space**: O(1)

### 2. **Sliding Window**

**Use Case**: Substring problems, anagrams

**Example: Longest Substring Without Repeating Characters**
- Given: "abcabcbb"
- Output: 3 ("abc")
- Approach:
  - Use a window with start and end pointers
  - Expand window by moving end pointer
  - Contract when duplicates found using hash set
  - Track maximum length seen

**Time**: O(n) | **Space**: O(min(m,n)) where m = charset size

### 3. **Hash Map for Character Frequency**

**Use Case**: Anagrams, character counting

**Example: Valid Anagram**
- Given: s = "anagram", t = "nagaram"
- Output: true
- Approach:
  - Count character frequencies in both strings using hash map
  - Compare frequency maps for equality
  - Alternative: Sort both strings and compare

**Time**: O(n) | **Space**: O(1) - limited charset

---

## 🎨 Pattern Matching Algorithms

### 1. **Naive Pattern Matching**

**Example**:
- Text:    "ABABCABAB"
- Pattern: "ABAB"
- Process:
  - Position 0: ABAB matches ✓
  - Position 5: ABAB matches ✓
- Check every position in text, compare character by character

**Time**: O(n×m) where n = text length, m = pattern length

### 2. **KMP Algorithm (Knuth-Morris-Pratt)**

**Key Concept**: Precompute failure function to avoid redundant comparisons

**Example**:
- Pattern: "ABABC"
- LPS Array: [0, 0, 1, 2, 0]
- LPS[i] = Longest proper prefix which is also suffix

**Steps**:
1. Build LPS (Longest Prefix Suffix) array for the pattern
2. Use LPS to skip characters intelligently during matching
3. When mismatch occurs, use LPS to determine next comparison position
4. Never go backwards in the text

**Time**: O(n + m) | **Space**: O(m)

### 3. **Rabin-Karp Algorithm**

**Key Concept**: Use rolling hash for efficient substring comparison

**Example**: Find "ABC" in "XYZABC"
- Calculate hash value: Hash("ABC") = 65×256² + 66×256 + 67
- Rolling hash updates in O(1) time by removing old char and adding new char
- Compare hash values first, then verify character by character if match
- Use modulo to prevent integer overflow

**Time**: O(n + m) average, O(n×m) worst case | **Space**: O(1)

### 4. **Boyer-Moore Algorithm**

**Key Concept**: Match pattern from right to left, skip intelligently

**Best for**: Long patterns and large alphabets

**Time**: O(n/m) best case, O(n×m) worst case

---

## 💡 Common String Problems

### 1. **Longest Palindromic Substring**

**Problem**: Find the longest palindrome in a string

**Approach 1: Expand Around Center**
```
For each character (and pair):
- Treat as center of potential palindrome
- Expand outwards while characters match
- Track longest palindrome found
```

**Time**: O(n²) | **Space**: O(1)

**Approach 2: Dynamic Programming**
```
dp[i][j] = true if s[i...j] is palindrome

Base cases:
- Single character: dp[i][i] = true
- Two characters: dp[i][i+1] = (s[i] == s[i+1])

Recurrence:
dp[i][j] = (s[i] == s[j]) && dp[i+1][j-1]
```

**Time**: O(n²) | **Space**: O(n²)

### 2. **Longest Common Substring**

**Problem**: Find longest common substring between two strings

```
Example:
s1 = "ABABC"
s2 = "BABCA"
LCS = "BABC" (length 4)

DP Table:
    B  A  B  C  A
A   0  1  0  0  1
B   1  0  2  0  0
A   0  2  0  0  1
B   1  0  3  0  0
C   0  0  0  4  0
```

**Time**: O(m×n) | **Space**: O(m×n)

### 3. **String Compression**

**Problem**: Compress string using character counts

```
Input: "aabcccccaaa"
Output: "a2b1c5a3"

If compressed is not shorter, return original
```

### 4. **Group Anagrams**

**Problem**: Group strings that are anagrams

```
Input: ["eat","tea","tan","ate","nat","bat"]
Output: [["eat","tea","ate"],["tan","nat"],["bat"]]

Approach:
- Use sorted string as key: "eat" → "aet"
- Group strings with same sorted key
```

**Time**: O(n×k log k) where k = max string length

---

## 🔍 Advanced String Concepts

### 1. **Trie-Based Solutions**

**Use Case**: Prefix matching, autocomplete, word search

```
Example: Word Break Problem
Given: s = "leetcode", wordDict = ["leet", "code"]
Output: true

Use trie to efficiently check word prefixes
```

### 2. **Suffix Arrays & Trees**

**Use Case**: Pattern matching in large texts, bioinformatics

**Applications**:
- Find all occurrences of pattern
- Longest repeated substring
- Longest common substring

### 3. **String Hashing**

**Rolling Hash Formula**:
```
hash(s[0...n]) = Σ(s[i] × p^i) mod m

Where:
- p = prime number (31 for lowercase, 53 for mixed case)
- m = large prime (10^9 + 9)
```

---

## 🎯 Problem-Solving Patterns

### Pattern 1: Character Manipulation

```
Problems:
- Reverse string
- Reverse words in string
- Remove duplicates
- Caesar cipher
```

**Key Techniques**:
- Two pointers
- Character array manipulation
- ASCII value operations

### Pattern 2: Substring Search

```
Problems:
- Find all anagrams
- Minimum window substring
- Longest substring with K distinct characters
```

**Key Techniques**:
- Sliding window
- Hash map for frequency counting
- Two pointers

### Pattern 3: String Matching

```
Problems:
- Implement strStr()
- Repeated substring pattern
- Is subsequence
```

**Key Techniques**:
- KMP algorithm
- Two pointers
- Dynamic programming

### Pattern 4: Palindrome Problems

```
Problems:
- Valid palindrome
- Palindrome permutation
- Shortest palindrome
```

**Key Techniques**:
- Expand around center
- Two pointers
- Manacher's algorithm (advanced)

---

## 🚀 Interview Tips

### 1. **Clarify String Properties**
- Character set (ASCII, Unicode, lowercase only?)
- String length constraints
- Immutability considerations
- Case sensitivity

### 2. **Consider Edge Cases**
```
- Empty string: ""
- Single character: "a"
- All same characters: "aaaa"
- Special characters: "a!b@c#"
- Whitespace: "  hello  "
```

### 3. **Optimization Strategies**
- Use character arrays for frequent modifications
- Consider space-time tradeoffs
- Hash maps vs arrays for character counting (size 26 vs HashMap)
- Preprocessing for multiple queries

### 4. **Common Pitfalls**
- String concatenation in loops (use StringBuilder)
- Not handling Unicode properly
- Off-by-one errors in substring operations
- Forgetting case sensitivity

---

## 📊 Complexity Comparison

| Operation | Naive | Optimized | Algorithm |
|-----------|-------|-----------|-----------|
| Pattern Matching | O(n×m) | O(n+m) | KMP |
| Palindrome Check | O(n²) | O(n) | Expand center |
| Anagram Check | O(n log n) | O(n) | Hash map |
| Substring Search | O(n×m) | O(n) | Sliding window |
| LCS | O(2^n) | O(n²) | DP |

---

## 🔥 High-Frequency Problems

### Must Practice:
1. ✅ Valid Palindrome
2. ✅ Longest Substring Without Repeating Characters
3. ✅ Group Anagrams
4. ✅ Longest Palindromic Substring
5. ✅ Minimum Window Substring
6. ✅ Valid Anagram
7. ✅ Implement strStr() / Find Needle in Haystack
8. ✅ String to Integer (atoi)
9. ✅ Longest Common Prefix
10. ✅ Word Break

---

## 🎓 Key Takeaways

1. **Master the basics**: Understand string immutability and its implications
2. **Learn patterns**: Two pointers, sliding window, and hash maps solve 80% of problems
3. **Know algorithms**: KMP and Rabin-Karp for advanced pattern matching
4. **Practice edge cases**: Empty strings, special characters, Unicode
5. **Optimize wisely**: Consider when O(n²) is acceptable vs when O(n) is required

---

## 📚 Related Topics
- [Array Manipulation Techniques](./03_ARRAYS.md)
- [Two Pointers & Sliding Window](./05_TWO_POINTERS_SLIDING_WINDOW.md)
- [Hashing](./06_HASHING.md)
- [Dynamic Programming](./24_DYNAMIC_PROGRAMMING_BASICS.md)
- [Tries](./23_TRIES.md)

---

[← Previous: Arrays](./03_ARRAYS.md) | [Index](./00_INDEX.md) | [Next: Two Pointers & Sliding Window →](./05_TWO_POINTERS_SLIDING_WINDOW.md)
