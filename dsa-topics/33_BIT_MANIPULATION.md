# Bit Manipulation

## 📋 Overview

**Bit Manipulation** involves directly operating on binary representations of numbers using bitwise operators. It's one of the most efficient techniques in programming, often providing O(1) solutions to problems that might otherwise require more complex approaches. Understanding bits is crucial for low-level optimization, systems programming, and many interview problems.

**Difficulty Level**: 🟡 Intermediate to 🔴 Advanced

---

## 🎯 Why Bit Manipulation?

### Advantages

1. **Speed**: Bitwise operations are extremely fast (hardware-level)
2. **Space**: Can store multiple boolean flags in a single integer
3. **Elegance**: Complex operations can be expressed concisely
4. **Practical**: Used in networking, graphics, cryptography, compression

### Real-World Applications

- **Graphics**: Color manipulation (RGB), alpha channels
- **Networking**: IP addresses, subnet masks, packet headers
- **Permissions**: File permissions (rwx), access control
- **Compression**: Data encoding, Huffman coding
- **Cryptography**: XOR encryption, hash functions
- **Game Development**: State flags, collision detection

---

## 🔢 Binary Number System

### Understanding Binary

```
Decimal to Binary:
13₁₀ = 1101₂

Position:  3  2  1  0
Bit:       1  1  0  1
Value:     8  4  0  1  = 8+4+1 = 13

Each position represents: 2^position
```

### Positive and Negative Numbers

```
8-bit representation:

Positive: 13
Binary: 0000 1101

Negative: -13 (Two's Complement)
Step 1: Binary of 13:    0000 1101
Step 2: Invert bits:     1111 0010
Step 3: Add 1:           1111 0011

Result: -13 = 1111 0011

Why Two's Complement?
13 + (-13) = 0000 1101 + 1111 0011 = 0000 0000 (overflow ignored)
Perfect for hardware addition!
```

---

## ⚡ Bitwise Operators

### 1. AND (&)

**Operation**: Both bits must be 1

```
5 & 3

  0101  (5)
& 0011  (3)
------
  0001  (1)

Truth Table:
0 & 0 = 0
0 & 1 = 0
1 & 0 = 0
1 & 1 = 1
```

**Use Cases**:
- Check if bit is set
- Clear specific bits
- Extract specific bits

### 2. OR (|)

**Operation**: At least one bit must be 1

```
5 | 3

  0101  (5)
| 0011  (3)
------
  0111  (7)

Truth Table:
0 | 0 = 0
0 | 1 = 1
1 | 0 = 1
1 | 1 = 1
```

**Use Cases**:
- Set specific bits
- Combine flags
- Merge values

### 3. XOR (^)

**Operation**: Bits must be different

```
5 ^ 3

  0101  (5)
^ 0011  (3)
------
  0110  (6)

Truth Table:
0 ^ 0 = 0
0 ^ 1 = 1
1 ^ 0 = 1
1 ^ 1 = 0
```

**Special Properties**:
- `a ^ a = 0` (cancel out)
- `a ^ 0 = a` (identity)
- `a ^ b ^ a = b` (commutative cancellation)

**Use Cases**:
- Find single number (others appear twice)
- Swap without temp variable
- Toggle bits

### 4. NOT (~)

**Operation**: Flip all bits

```
~5

  0000 0101  (5)
~ 
  1111 1010  (-6 in two's complement)

For 8-bit: ~5 = 250
For signed: ~5 = -6
```

**Use Cases**:
- Invert all bits
- Create bit masks

### 5. Left Shift (<<)

**Operation**: Shift bits left, fill with zeros

```
5 << 2

  0000 0101  (5)
<<2
  0001 0100  (20)

Effect: Multiply by 2^n
5 << 2 = 5 × 2² = 5 × 4 = 20
```

**Visual**:
```
Original: 0 0 0 0 0 1 0 1
          ← ← shift left by 2
Result:   0 0 0 1 0 1 0 0
             ↑ ↑ (zeros filled)
```

**Use Cases**:
- Fast multiplication by powers of 2
- Set bits at specific positions
- Create bit masks

### 6. Right Shift (>>)

**Operation**: Shift bits right, fill with sign bit (arithmetic) or zero (logical)

```
20 >> 2

  0001 0100  (20)
>>2
  0000 0101  (5)

Effect: Divide by 2^n (integer division)
20 >> 2 = 20 ÷ 2² = 20 ÷ 4 = 5
```

**Visual**:
```
Original: 0 0 0 1 0 1 0 0
          → → shift right by 2
Result:   0 0 0 0 0 1 0 1
          ↑ ↑ (zeros filled)
```

**Arithmetic vs Logical**:
```
Negative number: -8 = 1111 1000

Arithmetic >> (preserves sign):
-8 >> 1 = 1111 1100 = -4

Logical >> (fills with 0):
-8 >>> 1 = 0111 1100 = 124
```

---

## 🎨 Common Bit Manipulation Techniques

### 1. Check if Bit is Set

```
Check if i-th bit is set in number n

Number: 13 = 1101
Check 2nd bit (from right, 0-indexed)

  1101  (13)
& 0100  (1 << 2 = 4)
------
  0100  (non-zero, bit is SET)

Formula: (n & (1 << i)) != 0

Example positions:
1101
↑↑↑↑
3210 (bit positions)
```

### 2. Set a Bit

```
Set i-th bit in number n

Number: 9 = 1001
Set 1st bit

  1001  (9)
| 0010  (1 << 1 = 2)
------
  1011  (11)

Formula: n | (1 << i)

Visual:
Before: 1 0 0 1
After:  1 0 1 1
           ↑ (set to 1)
```

### 3. Clear a Bit

```
Clear i-th bit in number n

Number: 11 = 1011
Clear 1st bit

  1011  (11)
& 1101  (~(1 << 1))
------
  1001  (9)

Formula: n & ~(1 << i)

Visual:
Before: 1 0 1 1
After:  1 0 0 1
           ↑ (cleared to 0)
```

### 4. Toggle a Bit

```
Toggle i-th bit in number n

Number: 9 = 1001
Toggle 1st bit

  1001  (9)
^ 0010  (1 << 1)
------
  1011  (11)

Formula: n ^ (1 << i)

Toggle again:
  1011  (11)
^ 0010  (1 << 1)
------
  1001  (9) - back to original!
```

### 5. Remove Rightmost Set Bit

```
Remove rightmost 1-bit

Number: 12 = 1100

  1100  (12)
& 1011  (11 = 12-1)
------
  1000  (8)

Formula: n & (n - 1)

Why it works:
n     = 1100
n-1   = 1011 (rightmost 1 becomes 0, all bits after become 1)
n&(n-1) clears the rightmost 1
```

### 6. Isolate Rightmost Set Bit

```
Get only the rightmost 1-bit

Number: 12 = 1100

  1100   (12)
& 0100   (-12 in two's complement)
------
  0100   (4)

Formula: n & (-n)

Visual:
n:    1 1 0 0
-n:   0 1 0 0
AND:  0 1 0 0
      ↑ (isolated)
```

### 7. Check if Power of 2

```
Number is power of 2 if only one bit is set

8 = 1000 ✓ (power of 2)
7 = 0111 ✗ (not power of 2)

Method: n & (n-1) == 0

8:    1000
8-1:  0111
AND:  0000 ✓

7:    0111
7-1:  0110
AND:  0110 ✗ (not zero)

Also handle: n > 0 (exclude 0)
```

---

## 🎯 Classic Bit Manipulation Problems

### 1. Count Set Bits (Population Count)

```
Count number of 1s in binary representation

Number: 13 = 1101
Count: 3 (three 1s)

Method 1: Check each bit
1101 & 0001 = 1 → count++
1101 & 0010 = 0
1101 & 0100 = 1 → count++
1101 & 1000 = 1 → count++
Result: 3

Method 2: Remove rightmost 1
1101 & 1100 = 1100 → count++
1100 & 1011 = 1000 → count++
1000 & 0111 = 0000 → count++
Result: 3 (counted each removal)
```

### 2. Single Number (Find Unique)

```
Array where every element appears twice except one
Find the unique element

Array: [4, 1, 2, 1, 2]

XOR all elements:
4 ^ 1 ^ 2 ^ 1 ^ 2

Properties of XOR:
- a ^ a = 0
- a ^ 0 = a
- Commutative: a ^ b = b ^ a

Rearrange:
= 4 ^ (1 ^ 1) ^ (2 ^ 2)
= 4 ^ 0 ^ 0
= 4

Visual:
  0100  (4)
^ 0001  (1)
-------
  0101

^ 0010  (2)
-------
  0111

^ 0001  (1) - cancels previous 1
-------
  0110

^ 0010  (2) - cancels previous 2
-------
  0100  (4) - only 4 remains!
```

### 3. Two Missing Numbers

```
Array with all numbers 1 to n, two are missing
Find the two missing numbers

Array: [1, 2, 4, 6] (missing 3 and 5)

Step 1: XOR all array elements with 1 to n
xor = 1^2^4^6 ^ 1^2^3^4^5^6
    = 3^5 (pairs cancel)
    = 0011 ^ 0101
    = 0110

Step 2: Find rightmost set bit
0110 has rightmost 1 at position 1
This bit differs between 3 and 5

Step 3: Partition by this bit
Group 1 (bit 1 is 0): 1, 4 (and missing 3)
Group 2 (bit 1 is 1): 2, 6 (and missing 5)

Step 4: XOR each group
Group 1: 1^4^1^2^3^4 = 3
Group 2: 2^6^2^5^6 = 5

Result: 3 and 5
```

### 4. Reverse Bits

```
Reverse bits of a 32-bit integer

Input:  00000010100101000001111010011100
Output: 00111001011110000010100101000000

Process bit by bit:
Result = 0
For each bit in input (right to left):
  - Shift result left
  - If current bit is 1, set rightmost bit of result
  - Move to next input bit

Visual (8-bit example):
Input:  1 0 1 1 0 0 1 0
         ← ← ← reverse
Output: 0 1 0 0 1 1 0 1
```

### 5. Hamming Distance

```
Count positions where bits differ

x = 1 (0001)
y = 4 (0100)

XOR to find differences:
  0001
^ 0100
------
  0101

Count 1s in XOR result:
0101 has two 1s

Hamming Distance = 2

Positions differ at: bit 0 and bit 2
```

### 6. Maximum XOR of Two Numbers

```
Find maximum XOR of any two numbers in array

Array: [3, 10, 5, 25, 2, 8]

Binary representations:
3:  00011
10: 01010
5:  00101
25: 11001
2:  00010
8:  01000

Maximum XOR: 25 ^ 10 = 31
  11001  (25)
^ 01010  (10)
-------
  11111  (31) - all 1s!

Strategy: Try to maximize from leftmost bit
Build result bit by bit from left
```

---

## 🎪 Advanced Techniques

### 1. Bit Masking for Subsets

```
Generate all subsets using bit masks

Set: [a, b, c]
n = 3, so 2³ = 8 subsets

Mask: 000 → {}
Mask: 001 → {c}
Mask: 010 → {b}
Mask: 011 → {b, c}
Mask: 100 → {a}
Mask: 101 → {a, c}
Mask: 110 → {a, b}
Mask: 111 → {a, b, c}

For mask i:
  For each bit j (0 to n-1):
    If bit j is set in i:
      Include element[j] in subset

Example: mask = 5 (101)
  Bit 0: 1 → include c
  Bit 1: 0 → skip b
  Bit 2: 1 → include a
  Subset: {a, c}
```

### 2. Gray Code

```
Sequence where adjacent numbers differ by 1 bit

4-bit Gray Code:
0000 (0)
0001 (1)
0011 (3)
0010 (2)
0110 (6)
0111 (7)
0101 (5)
0100 (4)
1100 (12)
1101 (13)
1111 (15)
1110 (14)
1010 (10)
1011 (11)
1001 (9)
1000 (8)

Formula: gray(n) = n ^ (n >> 1)

Example: n = 5 (0101)
5 >> 1 = 2 (0010)
5 ^ 2  = 7 (0111) - Gray code of 5
```

### 3. Swap Bits

```
Swap bits at positions i and j

Number: 28 = 11100
Swap positions 1 and 4

Step 1: Check if bits differ
bit1 = (28 >> 1) & 1 = 0
bit4 = (28 >> 4) & 1 = 1
They differ!

Step 2: Toggle both bits
mask = (1 << 1) | (1 << 4) = 00010 | 10000 = 10010
result = 28 ^ mask = 11100 ^ 10010 = 01110 = 14

Visual:
Before: 1 1 1 0 0
            ↑   ↑
After:  0 1 1 1 0
        ↑       ↑
```

### 4. Next Power of 2

```
Find next power of 2 greater than or equal to n

n = 21 = 00010101

Step 1: Decrease by 1
20 = 00010100

Step 2: Fill all bits to right of MSB
20      = 00010100
20 >> 1 = 00001010
20 | (20 >> 1) = 00011110

Continue for 2,4,8,16 shifts:
Result = 00011111 = 31

Step 3: Add 1
31 + 1 = 32 = 00100000

Next power of 2: 32
```

---

## 🎮 Practical Applications

### 1. Flags and Permissions

```
File Permissions (Unix):
rwxrwxrwx = 111 111 111

Owner: rwx = 111 = 7
Group: r-x = 101 = 5
Other: r-- = 100 = 4

Permission: 754 = 0b111101100

Check read permission for group:
mask = 0b000100000 (read bit for group)
has_read = (permissions & mask) != 0
```

### 2. IP Address Manipulation

```
IP: 192.168.1.1
Binary: 11000000.10101000.00000001.00000001
32-bit: 0xC0A80101

Extract octets:
Octet 1: (ip >> 24) & 0xFF = 192
Octet 2: (ip >> 16) & 0xFF = 168
Octet 3: (ip >> 8)  & 0xFF = 1
Octet 4: ip & 0xFF         = 1

Subnet Mask: 255.255.255.0 = 0xFFFFFF00
Network: ip & mask = 192.168.1.0
```

### 3. Color Manipulation (RGB)

```
Color: 0xFF5733 (RGB)

Extract components:
R = (color >> 16) & 0xFF = 0xFF = 255
G = (color >> 8)  & 0xFF = 0x57 = 87
B = color & 0xFF         = 0x33 = 51

Modify alpha (RGBA):
alpha = 0x80 (50% transparent)
rgba = (alpha << 24) | (color & 0xFFFFFF)
     = 0x80FF5733

Darken color (divide by 2):
darkR = R >> 1 = 127
darkG = G >> 1 = 43
darkB = B >> 1 = 25
darkColor = (darkR << 16) | (darkG << 8) | darkB
```

### 4. State Management

```
Game character state (multiple flags in one int):

Flags:
IS_ALIVE     = 1 << 0  = 0001
HAS_WEAPON   = 1 << 1  = 0010
IS_INVISIBLE = 1 << 2  = 0100
IS_JUMPING   = 1 << 3  = 1000

State = 0

Set alive and has weapon:
state |= IS_ALIVE    → state = 0001
state |= HAS_WEAPON  → state = 0011

Check if has weapon:
has_weapon = (state & HAS_WEAPON) != 0 → true

Remove weapon:
state &= ~HAS_WEAPON → state = 0001

Toggle invisibility:
state ^= IS_INVISIBLE → state = 0101
```

---

## 💡 Interview Tips

### Common Patterns

1. **XOR for cancellation**: Find unique elements
2. **Bit masking**: Extract/set/clear specific bits
3. **Power of 2 checks**: `n & (n-1) == 0`
4. **Count bits**: Brian Kernighan's algorithm
5. **Two's complement**: Understanding negative numbers

### Problem-Solving Approach

1. **Convert to binary**: Visualize the problem
2. **Identify pattern**: XOR, AND, OR, shifts?
3. **Consider bit positions**: Which bits matter?
4. **Check edge cases**: 0, negative numbers, overflow
5. **Optimize**: Can bitwise operations replace arithmetic?

### Common Mistakes

1. **Sign extension**: Forgetting about signed vs unsigned
2. **Operator precedence**: `&` has lower precedence than `==`
3. **Overflow**: Left shift can cause overflow
4. **Off-by-one**: Bit positions are 0-indexed
5. **Assuming bit width**: 32-bit vs 64-bit

---

## 🎓 Key Takeaways

1. **Bitwise operations are O(1)** - extremely fast
2. **XOR has special properties** - cancellation, swap, find unique
3. **n & (n-1) removes rightmost 1** - count bits, check power of 2
4. **Bit masking is powerful** - flags, subsets, permissions
5. **Two's complement** - understanding negative numbers is crucial
6. **Shift operations** - fast multiplication/division by powers of 2
7. **Think in binary** - visualize problems in base 2
8. **Many problems have elegant bit solutions** - often simpler than alternatives

---

## 🔗 Related Topics

- [Arrays](./03_ARRAYS.md) - Bit arrays for space optimization
- [Dynamic Programming](./24_DYNAMIC_PROGRAMMING_BASICS.md) - Bitmask DP
- [Backtracking](./29_BACKTRACKING.md) - Subset generation
- [Hashing](./06_HASHING.md) - Bit manipulation in hash functions

---

**Next**: [Union-Find (Disjoint Set)](./34_UNION_FIND.md)
