# Java Collections Framework

## Table of Contents
1. [Introduction to Collections](#introduction-to-collections)
2. [Collection Interface Hierarchy](#collection-interface-hierarchy)
3. [List Interface](#list-interface)
4. [Set Interface](#set-interface)
5. [Queue Interface](#queue-interface)
6. [Map Interface](#map-interface)
7. [Collections Utility Class](#collections-utility-class)
8. [Comparable and Comparator](#comparable-and-comparator)
9. [Iteration Techniques](#iteration-techniques)
10. [Best Practices](#best-practices)

---

## Introduction to Collections

The Java Collections Framework is a unified architecture for representing and manipulating collections. It provides:

- **Interfaces**: Abstract data types representing collections
- **Implementations**: Concrete implementations of collection interfaces
- **Algorithms**: Methods that perform useful computations on collections

### Why Use Collections?

- **Reduced programming effort**: Ready-to-use data structures
- **Increased performance**: High-performance implementations
- **Interoperability**: Collections provide standard interfaces
- **Reduced learning curve**: Consistent API across different collections
- **Reusability**: Standard data structures and algorithms

### Collection vs Collections

- **Collection**: An interface representing a group of objects
- **Collections**: A utility class with static methods for operating on collections

---

## Collection Interface Hierarchy

```
                    Iterable
                       |
                   Collection
                       |
        _______________|_______________
       |               |               |
      List           Set            Queue
       |               |               |
   ArrayList      HashSet          PriorityQueue
   LinkedList     TreeSet          LinkedList
   Vector         LinkedHashSet    ArrayDeque
   Stack
```

```
              Map
               |
      _________|_________
     |                   |
  HashMap           TreeMap
  LinkedHashMap     Hashtable
  WeakHashMap       ConcurrentHashMap
```

---

## List Interface

A **List** is an ordered collection (sequence) that allows duplicate elements. Elements can be accessed by their position (index).

### ArrayList

ArrayList is a resizable array implementation. It's the most commonly used List implementation.

```java
import java.util.ArrayList;
import java.util.List;

public class ArrayListExample {
    public static void main(String[] args) {
        // Creating ArrayList
        List<String> fruits = new ArrayList<>();
        
        // Adding elements
        fruits.add("Apple");
        fruits.add("Banana");
        fruits.add("Orange");
        fruits.add("Banana"); // Duplicates allowed
        
        System.out.println("Fruits: " + fruits);
        
        // Adding at specific index
        fruits.add(1, "Mango");
        System.out.println("After inserting Mango: " + fruits);
        
        // Accessing elements
        String firstFruit = fruits.get(0);
        System.out.println("First fruit: " + firstFruit);
        
        // Updating elements
        fruits.set(2, "Grapes");
        System.out.println("After updating: " + fruits);
        
        // Removing elements
        fruits.remove("Banana");        // Removes first occurrence
        System.out.println("After removing Banana: " + fruits);
        
        fruits.remove(0);               // Remove by index
        System.out.println("After removing first: " + fruits);
        
        // Size and empty check
        System.out.println("Size: " + fruits.size());
        System.out.println("Is empty: " + fruits.isEmpty());
        
        // Contains check
        System.out.println("Contains Orange: " + fruits.contains("Orange"));
        
        // Index of element
        System.out.println("Index of Banana: " + fruits.indexOf("Banana"));
        
        // Clearing list
        fruits.clear();
        System.out.println("After clear: " + fruits);
    }
}
```

**Output:**
```
Fruits: [Apple, Banana, Orange, Banana]
After inserting Mango: [Apple, Mango, Banana, Orange, Banana]
First fruit: Apple
After updating: [Apple, Mango, Grapes, Orange, Banana]
After removing Banana: [Apple, Mango, Grapes, Orange]
After removing first: [Mango, Grapes, Orange]
Size: 3
Is empty: false
Contains Orange: true
Index of Banana: -1
After clear: []
```

### ArrayList with Custom Objects

```java
import java.util.ArrayList;
import java.util.List;

class Student {
    private String name;
    private int age;
    private double gpa;
    
    public Student(String name, int age, double gpa) {
        this.name = name;
        this.age = age;
        this.gpa = gpa;
    }
    
    @Override
    public String toString() {
        return "Student{name='" + name + "', age=" + age + ", gpa=" + gpa + "}";
    }
    
    // Getters
    public String getName() { return name; }
    public int getAge() { return age; }
    public double getGpa() { return gpa; }
}

public class ArrayListCustomObjects {
    public static void main(String[] args) {
        List<Student> students = new ArrayList<>();
        
        students.add(new Student("Alice", 20, 3.8));
        students.add(new Student("Bob", 22, 3.5));
        students.add(new Student("Charlie", 21, 3.9));
        
        System.out.println("All students:");
        for (Student student : students) {
            System.out.println(student);
        }
        
        // Finding specific student
        System.out.println("\nSearching for Bob:");
        for (Student student : students) {
            if (student.getName().equals("Bob")) {
                System.out.println("Found: " + student);
            }
        }
    }
}
```

### LinkedList

LinkedList is a doubly-linked list implementation. Better for frequent insertions/deletions.

```java
import java.util.LinkedList;

public class LinkedListExample {
    public static void main(String[] args) {
        LinkedList<String> cities = new LinkedList<>();
        
        // Adding elements
        cities.add("New York");
        cities.add("London");
        cities.add("Tokyo");
        
        // LinkedList specific methods
        cities.addFirst("Paris");
        cities.addLast("Sydney");
        
        System.out.println("Cities: " + cities);
        
        // Accessing elements
        System.out.println("First: " + cities.getFirst());
        System.out.println("Last: " + cities.getLast());
        
        // Removing elements
        cities.removeFirst();
        cities.removeLast();
        
        System.out.println("After removing first and last: " + cities);
        
        // Using as Stack (LIFO)
        LinkedList<Integer> stack = new LinkedList<>();
        stack.push(1);
        stack.push(2);
        stack.push(3);
        
        System.out.println("Stack: " + stack);
        System.out.println("Pop: " + stack.pop());  // Returns 3
        System.out.println("Peek: " + stack.peek()); // Returns 2
        
        // Using as Queue (FIFO)
        LinkedList<Integer> queue = new LinkedList<>();
        queue.offer(1);
        queue.offer(2);
        queue.offer(3);
        
        System.out.println("Queue: " + queue);
        System.out.println("Poll: " + queue.poll());  // Returns 1
        System.out.println("Peek: " + queue.peek());  // Returns 2
    }
}
```

### ArrayList vs LinkedList

| Feature | ArrayList | LinkedList |
|---------|-----------|------------|
| Data Structure | Dynamic array | Doubly-linked list |
| Access Time | O(1) | O(n) |
| Insertion/Deletion at beginning | O(n) | O(1) |
| Insertion/Deletion at end | O(1) | O(1) |
| Memory | Less overhead | More overhead (pointers) |
| Best Use Case | Random access | Frequent modifications |

```java
import java.util.*;

public class ListPerformanceComparison {
    public static void main(String[] args) {
        final int SIZE = 100000;
        
        // ArrayList - Good for random access
        List<Integer> arrayList = new ArrayList<>();
        long startTime = System.nanoTime();
        for (int i = 0; i < SIZE; i++) {
            arrayList.add(i);
        }
        long endTime = System.nanoTime();
        System.out.println("ArrayList add: " + (endTime - startTime) / 1000000 + " ms");
        
        // LinkedList - Good for insertions at beginning
        List<Integer> linkedList = new LinkedList<>();
        startTime = System.nanoTime();
        for (int i = 0; i < SIZE; i++) {
            linkedList.add(0, i); // Insert at beginning
        }
        endTime = System.nanoTime();
        System.out.println("LinkedList add at beginning: " + 
                           (endTime - startTime) / 1000000 + " ms");
        
        // Random access comparison
        startTime = System.nanoTime();
        for (int i = 0; i < 1000; i++) {
            arrayList.get(SIZE / 2);
        }
        endTime = System.nanoTime();
        System.out.println("ArrayList random access: " + 
                           (endTime - startTime) / 1000000 + " ms");
        
        startTime = System.nanoTime();
        for (int i = 0; i < 1000; i++) {
            linkedList.get(SIZE / 2);
        }
        endTime = System.nanoTime();
        System.out.println("LinkedList random access: " + 
                           (endTime - startTime) / 1000000 + " ms");
    }
}
```

### Vector and Stack

Vector is a legacy synchronized ArrayList. Stack extends Vector.

```java
import java.util.Stack;
import java.util.Vector;

public class VectorStackExample {
    public static void main(String[] args) {
        // Vector (synchronized, thread-safe)
        Vector<Integer> vector = new Vector<>();
        vector.add(1);
        vector.add(2);
        vector.add(3);
        System.out.println("Vector: " + vector);
        
        // Stack (LIFO - Last In First Out)
        Stack<String> stack = new Stack<>();
        
        // Push elements
        stack.push("First");
        stack.push("Second");
        stack.push("Third");
        
        System.out.println("Stack: " + stack);
        
        // Peek (view top without removing)
        System.out.println("Peek: " + stack.peek());
        
        // Pop (remove and return top)
        System.out.println("Pop: " + stack.pop());
        System.out.println("After pop: " + stack);
        
        // Search (returns position from top, 1-based)
        System.out.println("Position of 'First': " + stack.search("First"));
        
        // Check if empty
        System.out.println("Is empty: " + stack.empty());
    }
}
```

---

## Set Interface

A **Set** is a collection that contains no duplicate elements. It models the mathematical set abstraction.

### HashSet

HashSet uses a hash table for storage. It offers constant time performance for basic operations.

```java
import java.util.HashSet;
import java.util.Set;

public class HashSetExample {
    public static void main(String[] args) {
        Set<String> languages = new HashSet<>();
        
        // Adding elements
        languages.add("Java");
        languages.add("Python");
        languages.add("JavaScript");
        languages.add("Java");  // Duplicate - won't be added
        
        System.out.println("Languages: " + languages);
        System.out.println("Size: " + languages.size());
        
        // Contains check
        System.out.println("Contains Java: " + languages.contains("Java"));
        System.out.println("Contains C++: " + languages.contains("C++"));
        
        // Removing elements
        languages.remove("Python");
        System.out.println("After removing Python: " + languages);
        
        // Iteration
        System.out.println("Iterating through set:");
        for (String lang : languages) {
            System.out.println("- " + lang);
        }
        
        // Set operations
        Set<String> backendLangs = new HashSet<>();
        backendLangs.add("Java");
        backendLangs.add("Python");
        backendLangs.add("Go");
        
        Set<String> frontendLangs = new HashSet<>();
        frontendLangs.add("JavaScript");
        frontendLangs.add("TypeScript");
        
        // Union
        Set<String> allLangs = new HashSet<>(backendLangs);
        allLangs.addAll(frontendLangs);
        System.out.println("Union: " + allLangs);
        
        // Intersection
        Set<String> commonLangs = new HashSet<>(backendLangs);
        commonLangs.retainAll(frontendLangs);
        System.out.println("Intersection: " + commonLangs);
        
        // Difference
        Set<String> backendOnly = new HashSet<>(backendLangs);
        backendOnly.removeAll(frontendLangs);
        System.out.println("Backend only: " + backendOnly);
    }
}
```

### LinkedHashSet

LinkedHashSet maintains insertion order using a linked list.

```java
import java.util.LinkedHashSet;
import java.util.Set;

public class LinkedHashSetExample {
    public static void main(String[] args) {
        // LinkedHashSet maintains insertion order
        Set<Integer> numbers = new LinkedHashSet<>();
        
        numbers.add(5);
        numbers.add(2);
        numbers.add(8);
        numbers.add(1);
        numbers.add(5);  // Duplicate - won't be added
        
        System.out.println("Numbers (insertion order): " + numbers);
        // Output: [5, 2, 8, 1]
        
        // Compare with HashSet
        Set<Integer> hashSet = new HashSet<>();
        hashSet.add(5);
        hashSet.add(2);
        hashSet.add(8);
        hashSet.add(1);
        
        System.out.println("HashSet (no order guarantee): " + hashSet);
        // Output: Order not guaranteed
    }
}
```

### TreeSet

TreeSet stores elements in sorted order using a Red-Black tree.

```java
import java.util.TreeSet;
import java.util.Set;

public class TreeSetExample {
    public static void main(String[] args) {
        // TreeSet automatically sorts elements
        Set<Integer> numbers = new TreeSet<>();
        
        numbers.add(50);
        numbers.add(20);
        numbers.add(80);
        numbers.add(10);
        numbers.add(30);
        
        System.out.println("Numbers (sorted): " + numbers);
        // Output: [10, 20, 30, 50, 80]
        
        // TreeSet with Strings (alphabetical order)
        TreeSet<String> names = new TreeSet<>();
        names.add("Charlie");
        names.add("Alice");
        names.add("Bob");
        names.add("David");
        
        System.out.println("Names (alphabetical): " + names);
        
        // TreeSet specific methods
        System.out.println("First: " + names.first());
        System.out.println("Last: " + names.last());
        System.out.println("Lower than 'Charlie': " + names.lower("Charlie"));
        System.out.println("Higher than 'Bob': " + names.higher("Bob"));
        
        // Subset operations
        TreeSet<Integer> nums = new TreeSet<>();
        for (int i = 1; i <= 10; i++) {
            nums.add(i);
        }
        
        System.out.println("Full set: " + nums);
        System.out.println("Head set (<5): " + nums.headSet(5));
        System.out.println("Tail set (>=7): " + nums.tailSet(7));
        System.out.println("Sub set [3-8): " + nums.subSet(3, 8));
    }
}
```

### HashSet vs LinkedHashSet vs TreeSet

| Feature | HashSet | LinkedHashSet | TreeSet |
|---------|---------|---------------|---------|
| Order | No order | Insertion order | Sorted order |
| Null elements | One null allowed | One null allowed | No nulls (Java 7+) |
| Performance | O(1) | O(1) | O(log n) |
| Data Structure | Hash table | Hash table + Linked list | Red-Black tree |

```java
import java.util.*;

public class SetComparison {
    public static void main(String[] args) {
        List<Integer> numbers = Arrays.asList(5, 2, 8, 1, 9, 3);
        
        // HashSet - No order
        Set<Integer> hashSet = new HashSet<>(numbers);
        System.out.println("HashSet: " + hashSet);
        
        // LinkedHashSet - Insertion order
        Set<Integer> linkedHashSet = new LinkedHashSet<>(numbers);
        System.out.println("LinkedHashSet: " + linkedHashSet);
        
        // TreeSet - Sorted order
        Set<Integer> treeSet = new TreeSet<>(numbers);
        System.out.println("TreeSet: " + treeSet);
    }
}
```

**Output:**
```
HashSet: [1, 2, 3, 5, 8, 9] (order may vary)
LinkedHashSet: [5, 2, 8, 1, 9, 3]
TreeSet: [1, 2, 3, 5, 8, 9]
```

---

## Queue Interface

A **Queue** is a collection designed for holding elements prior to processing. Typically orders elements in FIFO (First-In-First-Out) manner.

### PriorityQueue

PriorityQueue orders elements based on their natural ordering or a custom Comparator.

```java
import java.util.PriorityQueue;
import java.util.Queue;
import java.util.Collections;

public class PriorityQueueExample {
    public static void main(String[] args) {
        // Min heap (default)
        Queue<Integer> minHeap = new PriorityQueue<>();
        
        minHeap.offer(5);
        minHeap.offer(2);
        minHeap.offer(8);
        minHeap.offer(1);
        minHeap.offer(9);
        
        System.out.println("Min Heap:");
        while (!minHeap.isEmpty()) {
            System.out.print(minHeap.poll() + " ");
        }
        System.out.println();
        
        // Max heap (reverse order)
        Queue<Integer> maxHeap = new PriorityQueue<>(Collections.reverseOrder());
        
        maxHeap.offer(5);
        maxHeap.offer(2);
        maxHeap.offer(8);
        maxHeap.offer(1);
        maxHeap.offer(9);
        
        System.out.println("Max Heap:");
        while (!maxHeap.isEmpty()) {
            System.out.print(maxHeap.poll() + " ");
        }
        System.out.println();
        
        // Peek (view without removing)
        Queue<Integer> queue = new PriorityQueue<>();
        queue.offer(10);
        queue.offer(5);
        queue.offer(15);
        
        System.out.println("Queue: " + queue);
        System.out.println("Peek: " + queue.peek());  // 5 (minimum)
        System.out.println("Size: " + queue.size());
    }
}
```

### PriorityQueue with Custom Objects

```java
import java.util.PriorityQueue;
import java.util.Comparator;

class Task {
    private String name;
    private int priority;
    
    public Task(String name, int priority) {
        this.name = name;
        this.priority = priority;
    }
    
    public String getName() { return name; }
    public int getPriority() { return priority; }
    
    @Override
    public String toString() {
        return name + " (priority: " + priority + ")";
    }
}

public class PriorityQueueCustomObjects {
    public static void main(String[] args) {
        // Priority queue with custom comparator
        Queue<Task> taskQueue = new PriorityQueue<>(
            Comparator.comparingInt(Task::getPriority)
        );
        
        taskQueue.offer(new Task("Write code", 2));
        taskQueue.offer(new Task("Fix critical bug", 1));
        taskQueue.offer(new Task("Update documentation", 3));
        taskQueue.offer(new Task("Review PR", 2));
        
        System.out.println("Processing tasks by priority:");
        while (!taskQueue.isEmpty()) {
            System.out.println("Processing: " + taskQueue.poll());
        }
    }
}
```

### ArrayDeque

ArrayDeque is a resizable array implementation of the Deque interface (double-ended queue).

```java
import java.util.ArrayDeque;
import java.util.Deque;

public class ArrayDequeExample {
    public static void main(String[] args) {
        Deque<String> deque = new ArrayDeque<>();
        
        // Add elements at both ends
        deque.addFirst("Front1");
        deque.addLast("Back1");
        deque.addFirst("Front2");
        deque.addLast("Back2");
        
        System.out.println("Deque: " + deque);
        // Output: [Front2, Front1, Back1, Back2]
        
        // Access elements
        System.out.println("First: " + deque.getFirst());
        System.out.println("Last: " + deque.getLast());
        
        // Remove elements
        System.out.println("Remove first: " + deque.removeFirst());
        System.out.println("Remove last: " + deque.removeLast());
        System.out.println("After removals: " + deque);
        
        // Use as Stack
        Deque<Integer> stack = new ArrayDeque<>();
        stack.push(1);
        stack.push(2);
        stack.push(3);
        System.out.println("Stack: " + stack);
        System.out.println("Pop: " + stack.pop());
        
        // Use as Queue
        Deque<Integer> queue = new ArrayDeque<>();
        queue.offer(1);
        queue.offer(2);
        queue.offer(3);
        System.out.println("Queue: " + queue);
        System.out.println("Poll: " + queue.poll());
    }
}
```

---

## Map Interface

A **Map** is an object that maps keys to values. It cannot contain duplicate keys, and each key can map to at most one value.

### HashMap

HashMap is the most commonly used Map implementation. It uses hashing for storage.

```java
import java.util.HashMap;
import java.util.Map;

public class HashMapExample {
    public static void main(String[] args) {
        // Creating HashMap
        Map<String, Integer> studentGrades = new HashMap<>();
        
        // Adding key-value pairs
        studentGrades.put("Alice", 95);
        studentGrades.put("Bob", 87);
        studentGrades.put("Charlie", 92);
        studentGrades.put("Diana", 88);
        
        System.out.println("Student grades: " + studentGrades);
        
        // Accessing values
        System.out.println("Alice's grade: " + studentGrades.get("Alice"));
        
        // Updating values
        studentGrades.put("Bob", 90);  // Updates existing key
        System.out.println("After updating Bob: " + studentGrades);
        
        // putIfAbsent - only adds if key doesn't exist
        studentGrades.putIfAbsent("Alice", 100);  // Won't update
        studentGrades.putIfAbsent("Eve", 85);     // Will add
        System.out.println("After putIfAbsent: " + studentGrades);
        
        // Checking existence
        System.out.println("Contains key 'Bob': " + studentGrades.containsKey("Bob"));
        System.out.println("Contains value 92: " + studentGrades.containsValue(92));
        
        // Removing entries
        studentGrades.remove("Diana");
        System.out.println("After removing Diana: " + studentGrades);
        
        // Size and empty check
        System.out.println("Size: " + studentGrades.size());
        System.out.println("Is empty: " + studentGrades.isEmpty());
        
        // Get or default
        int grade = studentGrades.getOrDefault("Frank", 0);
        System.out.println("Frank's grade (default): " + grade);
    }
}
```

### Iterating Through HashMap

```java
import java.util.HashMap;
import java.util.Map;

public class HashMapIteration {
    public static void main(String[] args) {
        Map<String, String> countries = new HashMap<>();
        countries.put("USA", "Washington D.C.");
        countries.put("UK", "London");
        countries.put("France", "Paris");
        countries.put("Japan", "Tokyo");
        
        // Method 1: Using entrySet()
        System.out.println("Using entrySet():");
        for (Map.Entry<String, String> entry : countries.entrySet()) {
            System.out.println(entry.getKey() + " -> " + entry.getValue());
        }
        
        // Method 2: Using keySet()
        System.out.println("\nUsing keySet():");
        for (String country : countries.keySet()) {
            System.out.println(country + " -> " + countries.get(country));
        }
        
        // Method 3: Using values()
        System.out.println("\nUsing values():");
        for (String capital : countries.values()) {
            System.out.println("Capital: " + capital);
        }
        
        // Method 4: Using forEach (Java 8+)
        System.out.println("\nUsing forEach:");
        countries.forEach((country, capital) -> 
            System.out.println(country + " -> " + capital)
        );
    }
}
```

### HashMap Advanced Operations

```java
import java.util.HashMap;
import java.util.Map;

public class HashMapAdvanced {
    public static void main(String[] args) {
        Map<String, Integer> wordCount = new HashMap<>();
        String[] words = {"apple", "banana", "apple", "cherry", "banana", "apple"};
        
        // Count word frequencies
        for (String word : words) {
            wordCount.put(word, wordCount.getOrDefault(word, 0) + 1);
        }
        System.out.println("Word count: " + wordCount);
        
        // Using compute methods
        Map<String, Integer> scores = new HashMap<>();
        scores.put("Player1", 100);
        scores.put("Player2", 150);
        
        // compute - always computes new value
        scores.compute("Player1", (key, value) -> value + 50);
        System.out.println("After compute: " + scores);
        
        // computeIfAbsent - only if key is absent
        scores.computeIfAbsent("Player3", key -> 200);
        System.out.println("After computeIfAbsent: " + scores);
        
        // computeIfPresent - only if key exists
        scores.computeIfPresent("Player2", (key, value) -> value + 25);
        System.out.println("After computeIfPresent: " + scores);
        
        // merge - combines old and new values
        scores.merge("Player1", 30, (oldVal, newVal) -> oldVal + newVal);
        System.out.println("After merge: " + scores);
        
        // replace methods
        scores.replace("Player2", 200);  // Replace if key exists
        scores.replace("Player1", 150, 180);  // Replace if old value matches
        System.out.println("After replace: " + scores);
    }
}
```

### LinkedHashMap

LinkedHashMap maintains insertion order or access order.

```java
import java.util.LinkedHashMap;
import java.util.Map;

public class LinkedHashMapExample {
    public static void main(String[] args) {
        // Maintains insertion order
        Map<String, Integer> insertionOrder = new LinkedHashMap<>();
        insertionOrder.put("Third", 3);
        insertionOrder.put("First", 1);
        insertionOrder.put("Second", 2);
        
        System.out.println("Insertion order: " + insertionOrder);
        // Output: {Third=3, First=1, Second=2}
        
        // LRU Cache using access order
        Map<String, String> lruCache = new LinkedHashMap<>(16, 0.75f, true) {
            @Override
            protected boolean removeEldestEntry(Map.Entry<String, String> eldest) {
                return size() > 3;  // Max capacity of 3
            }
        };
        
        lruCache.put("A", "Value A");
        lruCache.put("B", "Value B");
        lruCache.put("C", "Value C");
        System.out.println("Initial: " + lruCache);
        
        lruCache.get("A");  // Access A
        lruCache.put("D", "Value D");  // B will be removed (least recently used)
        System.out.println("After adding D: " + lruCache);
    }
}
```

### TreeMap

TreeMap stores entries in sorted order based on keys.

```java
import java.util.TreeMap;
import java.util.Map;

public class TreeMapExample {
    public static void main(String[] args) {
        // TreeMap - sorted by keys
        Map<Integer, String> students = new TreeMap<>();
        students.put(103, "Charlie");
        students.put(101, "Alice");
        students.put(104, "Diana");
        students.put(102, "Bob");
        
        System.out.println("Students (sorted by ID): " + students);
        // Output: {101=Alice, 102=Bob, 103=Charlie, 104=Diana}
        
        // TreeMap with String keys (alphabetical)
        TreeMap<String, Integer> scores = new TreeMap<>();
        scores.put("David", 85);
        scores.put("Alice", 92);
        scores.put("Charlie", 88);
        scores.put("Bob", 90);
        
        System.out.println("Scores (alphabetical): " + scores);
        
        // TreeMap specific methods
        System.out.println("First entry: " + scores.firstEntry());
        System.out.println("Last entry: " + scores.lastEntry());
        System.out.println("First key: " + scores.firstKey());
        System.out.println("Last key: " + scores.lastKey());
        
        // Navigation methods
        System.out.println("Lower key than 'Charlie': " + scores.lowerKey("Charlie"));
        System.out.println("Higher key than 'Bob': " + scores.higherKey("Bob"));
        
        // Submap operations
        System.out.println("Headmap (<'Charlie'): " + scores.headMap("Charlie"));
        System.out.println("Tailmap (>='Charlie'): " + scores.tailMap("Charlie"));
        System.out.println("Submap ['Bob'-'David'): " + scores.subMap("Bob", "David"));
    }
}
```

### HashMap vs LinkedHashMap vs TreeMap vs Hashtable

| Feature | HashMap | LinkedHashMap | TreeMap | Hashtable |
|---------|---------|---------------|---------|-----------|
| Order | No order | Insertion/Access order | Sorted order | No order |
| Null keys | One null key | One null key | No nulls | No nulls |
| Null values | Multiple nulls | Multiple nulls | Multiple nulls | No nulls |
| Thread-safe | No | No | No | Yes |
| Performance | O(1) | O(1) | O(log n) | O(1) |

```java
import java.util.*;

public class MapComparison {
    public static void main(String[] args) {
        // Sample data
        Map<Integer, String> map;
        
        // HashMap - No order
        map = new HashMap<>();
        map.put(3, "Three");
        map.put(1, "One");
        map.put(2, "Two");
        System.out.println("HashMap: " + map);
        
        // LinkedHashMap - Insertion order
        map = new LinkedHashMap<>();
        map.put(3, "Three");
        map.put(1, "One");
        map.put(2, "Two");
        System.out.println("LinkedHashMap: " + map);
        
        // TreeMap - Sorted order
        map = new TreeMap<>();
        map.put(3, "Three");
        map.put(1, "One");
        map.put(2, "Two");
        System.out.println("TreeMap: " + map);
        
        // Hashtable - Legacy, synchronized
        Hashtable<Integer, String> hashtable = new Hashtable<>();
        hashtable.put(3, "Three");
        hashtable.put(1, "One");
        hashtable.put(2, "Two");
        System.out.println("Hashtable: " + hashtable);
    }
}
```

---

## Collections Utility Class

The Collections class provides static methods for operating on collections.

### Sorting

```java
import java.util.*;

public class CollectionsSorting {
    public static void main(String[] args) {
        List<Integer> numbers = new ArrayList<>(Arrays.asList(5, 2, 8, 1, 9, 3));
        
        // Sort in natural order
        Collections.sort(numbers);
        System.out.println("Sorted ascending: " + numbers);
        
        // Sort in reverse order
        Collections.sort(numbers, Collections.reverseOrder());
        System.out.println("Sorted descending: " + numbers);
        
        // Sort with custom comparator
        List<String> names = new ArrayList<>(Arrays.asList("Alice", "bob", "Charlie", "david"));
        Collections.sort(names, String.CASE_INSENSITIVE_ORDER);
        System.out.println("Case-insensitive sort: " + names);
        
        // Sort custom objects
        List<Person> people = new ArrayList<>();
        people.add(new Person("Alice", 30));
        people.add(new Person("Bob", 25));
        people.add(new Person("Charlie", 35));
        
        Collections.sort(people, Comparator.comparingInt(Person::getAge));
        System.out.println("Sorted by age: " + people);
    }
}

class Person {
    private String name;
    private int age;
    
    public Person(String name, int age) {
        this.name = name;
        this.age = age;
    }
    
    public int getAge() { return age; }
    
    @Override
    public String toString() {
        return name + "(" + age + ")";
    }
}
```

### Searching

```java
import java.util.*;

public class CollectionsSearching {
    public static void main(String[] args) {
        List<Integer> numbers = Arrays.asList(1, 3, 5, 7, 9, 11, 13, 15);
        
        // Binary search (list must be sorted)
        int index = Collections.binarySearch(numbers, 7);
        System.out.println("Index of 7: " + index);  // 3
        
        index = Collections.binarySearch(numbers, 8);
        System.out.println("Index of 8 (not found): " + index);  // Negative
        
        // Min and Max
        System.out.println("Min: " + Collections.min(numbers));
        System.out.println("Max: " + Collections.max(numbers));
        
        List<String> words = Arrays.asList("apple", "zebra", "banana", "mango");
        System.out.println("Min string: " + Collections.min(words));
        System.out.println("Max string: " + Collections.max(words));
        
        // Frequency
        List<String> fruits = Arrays.asList("apple", "banana", "apple", "orange", "apple");
        System.out.println("Frequency of apple: " + Collections.frequency(fruits, "apple"));
    }
}
```

### Manipulation Operations

```java
import java.util.*;

public class CollectionsManipulation {
    public static void main(String[] args) {
        List<Integer> numbers = new ArrayList<>(Arrays.asList(1, 2, 3, 4, 5));
        
        // Reverse
        Collections.reverse(numbers);
        System.out.println("Reversed: " + numbers);
        
        // Shuffle
        Collections.shuffle(numbers);
        System.out.println("Shuffled: " + numbers);
        
        // Rotate
        numbers = new ArrayList<>(Arrays.asList(1, 2, 3, 4, 5));
        Collections.rotate(numbers, 2);
        System.out.println("Rotated by 2: " + numbers);  // [4, 5, 1, 2, 3]
        
        // Swap
        Collections.swap(numbers, 0, 4);
        System.out.println("After swap(0,4): " + numbers);
        
        // Fill
        Collections.fill(numbers, 0);
        System.out.println("Filled with 0: " + numbers);
        
        // Replace all
        List<String> words = new ArrayList<>(Arrays.asList("cat", "dog", "cat", "bird"));
        Collections.replaceAll(words, "cat", "tiger");
        System.out.println("After replace: " + words);
        
        // Copy
        List<Integer> source = Arrays.asList(1, 2, 3);
        List<Integer> dest = new ArrayList<>(Arrays.asList(0, 0, 0));
        Collections.copy(dest, source);
        System.out.println("After copy: " + dest);
    }
}
```

### Immutable Collections

```java
import java.util.*;

public class ImmutableCollections {
    public static void main(String[] args) {
        List<String> list = new ArrayList<>(Arrays.asList("A", "B", "C"));
        
        // Unmodifiable collection
        List<String> unmodifiableList = Collections.unmodifiableList(list);
        System.out.println("Unmodifiable list: " + unmodifiableList);
        
        try {
            unmodifiableList.add("D");  // Throws UnsupportedOperationException
        } catch (UnsupportedOperationException e) {
            System.out.println("Cannot modify unmodifiable list");
        }
        
        // Note: Original list can still be modified
        list.add("D");
        System.out.println("After modifying original: " + unmodifiableList);
        
        // Singleton collections
        Set<String> singletonSet = Collections.singleton("Only");
        List<String> singletonList = Collections.singletonList("Only");
        Map<String, Integer> singletonMap = Collections.singletonMap("Key", 1);
        
        System.out.println("Singleton set: " + singletonSet);
        System.out.println("Singleton list: " + singletonList);
        System.out.println("Singleton map: " + singletonMap);
        
        // Empty collections
        List<String> emptyList = Collections.emptyList();
        Set<String> emptySet = Collections.emptySet();
        Map<String, Integer> emptyMap = Collections.emptyMap();
    }
}
```

### Synchronization

```java
import java.util.*;

public class CollectionsSynchronization {
    public static void main(String[] args) {
        // Create synchronized collections
        List<String> syncList = Collections.synchronizedList(new ArrayList<>());
        Set<String> syncSet = Collections.synchronizedSet(new HashSet<>());
        Map<String, Integer> syncMap = Collections.synchronizedMap(new HashMap<>());
        
        syncList.add("Item1");
        syncList.add("Item2");
        
        // When iterating, must synchronize manually
        synchronized(syncList) {
            for (String item : syncList) {
                System.out.println(item);
            }
        }
        
        // Thread-safe operations
        syncSet.add("Element1");
        syncMap.put("Key1", 100);
        
        System.out.println("Synchronized list: " + syncList);
        System.out.println("Synchronized set: " + syncSet);
        System.out.println("Synchronized map: " + syncMap);
    }
}
```

---

## Comparable and Comparator

### Comparable Interface

Comparable is used to define natural ordering of objects.

```java
import java.util.*;

class Student implements Comparable<Student> {
    private String name;
    private int age;
    private double gpa;
    
    public Student(String name, int age, double gpa) {
        this.name = name;
        this.age = age;
        this.gpa = gpa;
    }
    
    @Override
    public int compareTo(Student other) {
        // Natural ordering by name
        return this.name.compareTo(other.name);
    }
    
    @Override
    public String toString() {
        return name + " (" + age + ", GPA: " + gpa + ")";
    }
    
    public String getName() { return name; }
    public int getAge() { return age; }
    public double getGpa() { return gpa; }
}

public class ComparableExample {
    public static void main(String[] args) {
        List<Student> students = new ArrayList<>();
        students.add(new Student("Charlie", 20, 3.5));
        students.add(new Student("Alice", 22, 3.8));
        students.add(new Student("Bob", 21, 3.6));
        
        System.out.println("Before sorting:");
        students.forEach(System.out::println);
        
        // Sort using natural ordering (compareTo)
        Collections.sort(students);
        
        System.out.println("\nAfter sorting (by name):");
        students.forEach(System.out::println);
    }
}
```

### Comparator Interface

Comparator is used to define custom ordering.

```java
import java.util.*;

class Employee {
    private String name;
    private int age;
    private double salary;
    
    public Employee(String name, int age, double salary) {
        this.name = name;
        this.age = age;
        this.salary = salary;
    }
    
    @Override
    public String toString() {
        return name + " (Age: " + age + ", Salary: $" + salary + ")";
    }
    
    public String getName() { return name; }
    public int getAge() { return age; }
    public double getSalary() { return salary; }
}

public class ComparatorExample {
    public static void main(String[] args) {
        List<Employee> employees = new ArrayList<>();
        employees.add(new Employee("Charlie", 30, 60000));
        employees.add(new Employee("Alice", 25, 70000));
        employees.add(new Employee("Bob", 28, 65000));
        
        System.out.println("Original list:");
        employees.forEach(System.out::println);
        
        // Sort by age
        Collections.sort(employees, new Comparator<Employee>() {
            @Override
            public int compare(Employee e1, Employee e2) {
                return Integer.compare(e1.getAge(), e2.getAge());
            }
        });
        
        System.out.println("\nSorted by age:");
        employees.forEach(System.out::println);
        
        // Sort by salary (lambda expression)
        Collections.sort(employees, (e1, e2) -> 
            Double.compare(e1.getSalary(), e2.getSalary())
        );
        
        System.out.println("\nSorted by salary:");
        employees.forEach(System.out::println);
        
        // Sort by name (method reference)
        Collections.sort(employees, Comparator.comparing(Employee::getName));
        
        System.out.println("\nSorted by name:");
        employees.forEach(System.out::println);
        
        // Chaining comparators
        Collections.sort(employees, 
            Comparator.comparing(Employee::getAge)
                      .thenComparing(Employee::getName)
        );
        
        System.out.println("\nSorted by age, then name:");
        employees.forEach(System.out::println);
        
        // Reverse order
        Collections.sort(employees, 
            Comparator.comparing(Employee::getSalary).reversed()
        );
        
        System.out.println("\nSorted by salary (descending):");
        employees.forEach(System.out::println);
    }
}
```

---

## Iteration Techniques

### Different Ways to Iterate

```java
import java.util.*;

public class IterationTechniques {
    public static void main(String[] args) {
        List<String> fruits = Arrays.asList("Apple", "Banana", "Orange", "Mango");
        
        // 1. For-each loop
        System.out.println("For-each loop:");
        for (String fruit : fruits) {
            System.out.println(fruit);
        }
        
        // 2. Traditional for loop
        System.out.println("\nTraditional for loop:");
        for (int i = 0; i < fruits.size(); i++) {
            System.out.println(fruits.get(i));
        }
        
        // 3. Iterator
        System.out.println("\nUsing Iterator:");
        Iterator<String> iterator = fruits.iterator();
        while (iterator.hasNext()) {
            System.out.println(iterator.next());
        }
        
        // 4. ListIterator (bidirectional)
        System.out.println("\nUsing ListIterator (backward):");
        ListIterator<String> listIterator = fruits.listIterator(fruits.size());
        while (listIterator.hasPrevious()) {
            System.out.println(listIterator.previous());
        }
        
        // 5. forEach method (Java 8+)
        System.out.println("\nUsing forEach:");
        fruits.forEach(fruit -> System.out.println(fruit));
        
        // 6. Stream API (Java 8+)
        System.out.println("\nUsing Stream:");
        fruits.stream().forEach(System.out::println);
    }
}
```

### Safe Removal During Iteration

```java
import java.util.*;

public class SafeRemoval {
    public static void main(String[] args) {
        // Wrong way - ConcurrentModificationException
        List<Integer> numbers = new ArrayList<>(Arrays.asList(1, 2, 3, 4, 5));
        
        try {
            for (Integer num : numbers) {
                if (num % 2 == 0) {
                    numbers.remove(num);  // Throws exception
                }
            }
        } catch (ConcurrentModificationException e) {
            System.out.println("ConcurrentModificationException caught!");
        }
        
        // Correct way 1: Using Iterator
        numbers = new ArrayList<>(Arrays.asList(1, 2, 3, 4, 5));
        Iterator<Integer> iterator = numbers.iterator();
        while (iterator.hasNext()) {
            Integer num = iterator.next();
            if (num % 2 == 0) {
                iterator.remove();  // Safe removal
            }
        }
        System.out.println("After Iterator removal: " + numbers);
        
        // Correct way 2: Using removeIf (Java 8+)
        numbers = new ArrayList<>(Arrays.asList(1, 2, 3, 4, 5));
        numbers.removeIf(num -> num % 2 == 0);
        System.out.println("After removeIf: " + numbers);
        
        // Correct way 3: Collect to new list
        numbers = new ArrayList<>(Arrays.asList(1, 2, 3, 4, 5));
        List<Integer> oddNumbers = new ArrayList<>();
        for (Integer num : numbers) {
            if (num % 2 != 0) {
                oddNumbers.add(num);
            }
        }
        System.out.println("Odd numbers: " + oddNumbers);
    }
}
```

---

## Best Practices

### Choosing the Right Collection

```java
/*
List:
- ArrayList: Random access, rare insertions/deletions
- LinkedList: Frequent insertions/deletions, queue operations
- Vector: Thread-safe list (consider CopyOnWriteArrayList instead)

Set:
- HashSet: Fast operations, no order needed
- LinkedHashSet: Maintain insertion order
- TreeSet: Sorted order needed

Queue:
- LinkedList: FIFO queue
- PriorityQueue: Priority-based processing
- ArrayDeque: Stack or deque operations

Map:
- HashMap: General purpose, no order
- LinkedHashMap: Maintain insertion/access order
- TreeMap: Sorted keys needed
- ConcurrentHashMap: Thread-safe map
*/
```

### Performance Considerations

```java
import java.util.*;

public class PerformanceTips {
    public static void main(String[] args) {
        // 1. Specify initial capacity if size is known
        List<Integer> list = new ArrayList<>(1000);  // Better than default
        Map<String, Integer> map = new HashMap<>(1000);
        
        // 2. Use appropriate collection
        // Bad: ArrayList for frequent insertions at beginning
        // Good: LinkedList for frequent insertions at beginning
        
        // 3. Use isEmpty() instead of size() == 0
        if (list.isEmpty()) {  // O(1)
            // Better than size() == 0
        }
        
        // 4. Avoid unnecessary boxing/unboxing
        List<Integer> numbers = new ArrayList<>();
        numbers.add(Integer.valueOf(5));  // Manual boxing
        int value = numbers.get(0).intValue();  // Manual unboxing
        
        // 5. Use enhanced for-loop or streams when index not needed
        for (Integer num : numbers) {  // Good
            System.out.println(num);
        }
        
        // 6. Use compute methods for Maps
        Map<String, Integer> counts = new HashMap<>();
        String word = "test";
        counts.merge(word, 1, Integer::sum);  // Efficient
    }
}
```

### Common Pitfalls

```java
import java.util.*;

public class CommonPitfalls {
    public static void main(String[] args) {
        // 1. Modifying collection while iterating
        List<String> list = new ArrayList<>(Arrays.asList("A", "B", "C"));
        // Use iterator.remove() or removeIf()
        
        // 2. Using == instead of equals()
        String s1 = new String("test");
        String s2 = new String("test");
        System.out.println(s1 == s2);        // false
        System.out.println(s1.equals(s2));   // true
        
        // 3. Not overriding hashCode() and equals() for custom objects
        class Person {
            String name;
            // Must override hashCode() and equals() for use in HashSet/HashMap
        }
        
        // 4. Using null in TreeSet/TreeMap (pre Java 7)
        // TreeSet<String> set = new TreeSet<>();
        // set.add(null);  // NullPointerException
        
        // 5. Assuming HashMap maintains order
        Map<Integer, String> map = new HashMap<>();
        map.put(1, "One");
        map.put(2, "Two");
        // Order not guaranteed
        
        // 6. Not making defensive copies
        List<String> original = new ArrayList<>(Arrays.asList("A", "B"));
        List<String> copy = original;  // Not a copy!
        List<String> realCopy = new ArrayList<>(original);  // Real copy
    }
}
```

---

## Summary

The Java Collections Framework provides:

- **List**: Ordered collections (ArrayList, LinkedList, Vector)
- **Set**: Unique elements (HashSet, LinkedHashSet, TreeSet)
- **Queue**: FIFO or priority-based processing (PriorityQueue, ArrayDeque)
- **Map**: Key-value pairs (HashMap, LinkedHashMap, TreeMap)

Key takeaways:
- Choose the right collection based on your use case
- Understand time complexities of operations
- Use generics for type safety
- Be aware of thread-safety requirements
- Follow best practices for performance

---

**Previous**: [Java Language Fundamentals](01_JAVA_LANGUAGE.md)  
**Next**: [Java Concurrency & Multithreading](03_JAVA_CONCURRENCY.md)
