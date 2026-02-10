# Java Language Fundamentals

## Table of Contents
1. [Introduction to Java](#introduction-to-java)
2. [Java Syntax Basics](#java-syntax-basics)
3. [Data Types](#data-types)
4. [Variables](#variables)
5. [Operators](#operators)
6. [Control Flow Statements](#control-flow-statements)
7. [Methods](#methods)
8. [Object-Oriented Programming](#object-oriented-programming)
9. [Inheritance](#inheritance)
10. [Polymorphism](#polymorphism)
11. [Abstraction](#abstraction)
12. [Encapsulation](#encapsulation)
13. [Interfaces](#interfaces)
14. [Packages](#packages)
15. [Access Modifiers](#access-modifiers)

---

## Introduction to Java

Java is a high-level, object-oriented programming language developed by Sun Microsystems (now Oracle) in 1995. It follows the principle of "Write Once, Run Anywhere" (WORA), meaning compiled Java code can run on any platform that supports Java without recompilation.

### Key Features of Java

- **Object-Oriented**: Everything in Java is an object with data and behavior
- **Platform Independent**: Java bytecode runs on any JVM
- **Simple and Familiar**: Syntax based on C/C++ but simpler
- **Secure**: Built-in security features and no explicit pointers
- **Robust**: Strong memory management and exception handling
- **Multithreaded**: Built-in support for concurrent programming
- **High Performance**: Just-In-Time (JIT) compilation

### Java Architecture

```
Java Source Code (.java)
        ↓
Java Compiler (javac)
        ↓
Java Bytecode (.class)
        ↓
Java Virtual Machine (JVM)
        ↓
Machine Code (Platform Specific)
```

---

## Java Syntax Basics

### Your First Java Program

```java
public class HelloWorld {
    public static void main(String[] args) {
        System.out.println("Hello, World!");
    }
}
```

**Explanation:**
- `public class HelloWorld`: Defines a public class named HelloWorld
- `public static void main(String[] args)`: The entry point of any Java application
  - `public`: Accessible from anywhere
  - `static`: Can be called without creating an object
  - `void`: Returns nothing
  - `String[] args`: Command-line arguments
- `System.out.println()`: Prints output to console

### Java Naming Conventions

- **Classes**: Use PascalCase (e.g., `MyClass`, `StudentRecord`)
- **Methods**: Use camelCase (e.g., `calculateTotal()`, `getUserName()`)
- **Variables**: Use camelCase (e.g., `firstName`, `totalAmount`)
- **Constants**: Use UPPER_SNAKE_CASE (e.g., `MAX_SIZE`, `DEFAULT_VALUE`)
- **Packages**: Use lowercase (e.g., `com.example.project`)

---

## Data Types

Java has two categories of data types: **Primitive** and **Reference** types.

### Primitive Data Types

Java has 8 primitive data types:

| Type    | Size    | Default | Range                                    | Example          |
|---------|---------|---------|------------------------------------------|------------------|
| byte    | 1 byte  | 0       | -128 to 127                              | `byte b = 100;`  |
| short   | 2 bytes | 0       | -32,768 to 32,767                        | `short s = 5000;`|
| int     | 4 bytes | 0       | -2³¹ to 2³¹-1                            | `int i = 100000;`|
| long    | 8 bytes | 0L      | -2⁶³ to 2⁶³-1                            | `long l = 100000L;`|
| float   | 4 bytes | 0.0f    | ±3.4e−038 to ±3.4e+038                   | `float f = 10.5f;`|
| double  | 8 bytes | 0.0d    | ±1.7e−308 to ±1.7e+308                   | `double d = 10.5;`|
| char    | 2 bytes | '\u0000'| 0 to 65,535 (Unicode)                    | `char c = 'A';`  |
| boolean | 1 bit   | false   | true or false                            | `boolean b = true;`|

### Code Example: Primitive Types

```java
public class PrimitiveTypesExample {
    public static void main(String[] args) {
        // Integer types
        byte smallNumber = 127;
        short mediumNumber = 32000;
        int regularNumber = 2000000000;
        long bigNumber = 9223372036854775807L;
        
        // Floating-point types
        float decimalNumber = 3.14159f;
        double preciseDecimal = 3.141592653589793;
        
        // Character type
        char letter = 'A';
        char unicodeChar = '\u0041'; // Also 'A'
        
        // Boolean type
        boolean isJavaFun = true;
        
        System.out.println("Byte: " + smallNumber);
        System.out.println("Short: " + mediumNumber);
        System.out.println("Int: " + regularNumber);
        System.out.println("Long: " + bigNumber);
        System.out.println("Float: " + decimalNumber);
        System.out.println("Double: " + preciseDecimal);
        System.out.println("Char: " + letter);
        System.out.println("Boolean: " + isJavaFun);
    }
}
```

### Reference Data Types

Reference types include:
- **Classes**: `String`, `Integer`, custom classes
- **Interfaces**: `List`, `Map`, etc.
- **Arrays**: `int[]`, `String[]`, etc.
- **Enums**: Custom enumeration types

```java
public class ReferenceTypesExample {
    public static void main(String[] args) {
        // String (reference type)
        String name = "John Doe";
        
        // Array (reference type)
        int[] numbers = {1, 2, 3, 4, 5};
        
        // Custom class (reference type)
        Person person = new Person("Alice", 30);
        
        // Wrapper classes (reference types)
        Integer number = 42;
        Double decimal = 3.14;
        
        System.out.println("String: " + name);
        System.out.println("Array length: " + numbers.length);
        System.out.println("Person: " + person.getName());
    }
}

class Person {
    private String name;
    private int age;
    
    public Person(String name, int age) {
        this.name = name;
        this.age = age;
    }
    
    public String getName() {
        return name;
    }
}
```

---

## Variables

Variables are containers for storing data values. In Java, variables must be declared with a type before use.

### Variable Declaration and Initialization

```java
public class VariablesExample {
    public static void main(String[] args) {
        // Declaration
        int age;
        
        // Initialization
        age = 25;
        
        // Declaration and initialization
        String name = "John";
        
        // Multiple variables of same type
        int x = 5, y = 10, z = 15;
        
        // Final variables (constants)
        final double PI = 3.14159;
        // PI = 3.14; // Error: cannot assign a value to final variable
        
        System.out.println("Name: " + name + ", Age: " + age);
    }
}
```

### Types of Variables

#### 1. Local Variables

Declared inside methods, constructors, or blocks. They are created when the method is called and destroyed when it returns.

```java
public class LocalVariableExample {
    public void calculateSum() {
        // Local variables
        int num1 = 10;
        int num2 = 20;
        int sum = num1 + num2;
        
        System.out.println("Sum: " + sum);
    } // num1, num2, sum are destroyed here
}
```

#### 2. Instance Variables (Non-Static Fields)

Declared inside a class but outside any method. Each object has its own copy.

```java
public class Car {
    // Instance variables
    private String brand;
    private String model;
    private int year;
    
    public Car(String brand, String model, int year) {
        this.brand = brand;
        this.model = model;
        this.year = year;
    }
    
    public void displayInfo() {
        System.out.println(year + " " + brand + " " + model);
    }
}
```

#### 3. Class Variables (Static Fields)

Declared with `static` keyword. Shared among all instances of the class.

```java
public class Counter {
    // Class variable (shared by all instances)
    private static int count = 0;
    
    // Instance variable (unique to each instance)
    private int id;
    
    public Counter() {
        count++;
        this.id = count;
    }
    
    public static int getCount() {
        return count;
    }
    
    public int getId() {
        return id;
    }
    
    public static void main(String[] args) {
        Counter c1 = new Counter();
        Counter c2 = new Counter();
        Counter c3 = new Counter();
        
        System.out.println("Total counters created: " + Counter.getCount()); // 3
        System.out.println("c1 id: " + c1.getId()); // 1
        System.out.println("c2 id: " + c2.getId()); // 2
        System.out.println("c3 id: " + c3.getId()); // 3
    }
}
```

---

## Operators

Operators are special symbols that perform operations on variables and values.

### Arithmetic Operators

```java
public class ArithmeticOperators {
    public static void main(String[] args) {
        int a = 10, b = 3;
        
        System.out.println("Addition: " + (a + b));       // 13
        System.out.println("Subtraction: " + (a - b));    // 7
        System.out.println("Multiplication: " + (a * b)); // 30
        System.out.println("Division: " + (a / b));       // 3 (integer division)
        System.out.println("Modulus: " + (a % b));        // 1 (remainder)
        
        // Unary operators
        int x = 5;
        System.out.println("Original: " + x);        // 5
        System.out.println("Increment: " + (++x));   // 6 (pre-increment)
        System.out.println("Increment: " + (x++));   // 6 (post-increment)
        System.out.println("After post: " + x);      // 7
        System.out.println("Decrement: " + (--x));   // 6 (pre-decrement)
    }
}
```

### Assignment Operators

```java
public class AssignmentOperators {
    public static void main(String[] args) {
        int x = 10;
        
        x += 5;  // x = x + 5  → 15
        System.out.println("x += 5: " + x);
        
        x -= 3;  // x = x - 3  → 12
        System.out.println("x -= 3: " + x);
        
        x *= 2;  // x = x * 2  → 24
        System.out.println("x *= 2: " + x);
        
        x /= 4;  // x = x / 4  → 6
        System.out.println("x /= 4: " + x);
        
        x %= 4;  // x = x % 4  → 2
        System.out.println("x %= 4: " + x);
    }
}
```

### Comparison Operators

```java
public class ComparisonOperators {
    public static void main(String[] args) {
        int a = 10, b = 20;
        
        System.out.println("a == b: " + (a == b)); // false
        System.out.println("a != b: " + (a != b)); // true
        System.out.println("a > b: " + (a > b));   // false
        System.out.println("a < b: " + (a < b));   // true
        System.out.println("a >= b: " + (a >= b)); // false
        System.out.println("a <= b: " + (a <= b)); // true
    }
}
```

### Logical Operators

```java
public class LogicalOperators {
    public static void main(String[] args) {
        boolean x = true, y = false;
        
        System.out.println("x && y: " + (x && y)); // false (AND)
        System.out.println("x || y: " + (x || y)); // true (OR)
        System.out.println("!x: " + (!x));         // false (NOT)
        
        // Short-circuit evaluation
        int a = 10, b = 0;
        if (b != 0 && a / b > 5) { // Second condition not evaluated
            System.out.println("This won't print");
        }
    }
}
```

### Bitwise Operators

```java
public class BitwiseOperators {
    public static void main(String[] args) {
        int a = 5;  // 0101 in binary
        int b = 3;  // 0011 in binary
        
        System.out.println("a & b: " + (a & b));   // 1 (0001) - AND
        System.out.println("a | b: " + (a | b));   // 7 (0111) - OR
        System.out.println("a ^ b: " + (a ^ b));   // 6 (0110) - XOR
        System.out.println("~a: " + (~a));         // -6 (inverts bits)
        System.out.println("a << 1: " + (a << 1)); // 10 (1010) - Left shift
        System.out.println("a >> 1: " + (a >> 1)); // 2 (0010) - Right shift
    }
}
```

### Ternary Operator

```java
public class TernaryOperator {
    public static void main(String[] args) {
        int age = 18;
        String status = (age >= 18) ? "Adult" : "Minor";
        System.out.println("Status: " + status); // Adult
        
        // Nested ternary
        int score = 85;
        String grade = (score >= 90) ? "A" : 
                       (score >= 80) ? "B" : 
                       (score >= 70) ? "C" : "F";
        System.out.println("Grade: " + grade); // B
    }
}
```

---

## Control Flow Statements

Control flow statements determine the order in which code is executed.

### If-Else Statements

```java
public class IfElseExample {
    public static void main(String[] args) {
        int temperature = 25;
        
        // Simple if
        if (temperature > 30) {
            System.out.println("It's hot!");
        }
        
        // If-else
        if (temperature > 30) {
            System.out.println("It's hot!");
        } else {
            System.out.println("It's not too hot.");
        }
        
        // If-else-if ladder
        if (temperature < 0) {
            System.out.println("Freezing!");
        } else if (temperature < 15) {
            System.out.println("Cold");
        } else if (temperature < 25) {
            System.out.println("Mild");
        } else if (temperature < 35) {
            System.out.println("Warm");
        } else {
            System.out.println("Hot!");
        }
        
        // Nested if
        boolean isSunny = true;
        if (temperature > 20) {
            if (isSunny) {
                System.out.println("Great day for the beach!");
            } else {
                System.out.println("Warm but cloudy");
            }
        }
    }
}
```

### Switch Statements

```java
public class SwitchExample {
    public static void main(String[] args) {
        // Traditional switch
        int dayOfWeek = 3;
        String dayName;
        
        switch (dayOfWeek) {
            case 1:
                dayName = "Monday";
                break;
            case 2:
                dayName = "Tuesday";
                break;
            case 3:
                dayName = "Wednesday";
                break;
            case 4:
                dayName = "Thursday";
                break;
            case 5:
                dayName = "Friday";
                break;
            case 6:
                dayName = "Saturday";
                break;
            case 7:
                dayName = "Sunday";
                break;
            default:
                dayName = "Invalid day";
                break;
        }
        System.out.println("Day: " + dayName);
        
        // Switch with fall-through
        int month = 2;
        int days;
        
        switch (month) {
            case 1: case 3: case 5: case 7: case 8: case 10: case 12:
                days = 31;
                break;
            case 4: case 6: case 9: case 11:
                days = 30;
                break;
            case 2:
                days = 28; // Not considering leap year
                break;
            default:
                days = 0;
                break;
        }
        System.out.println("Days in month: " + days);
        
        // Enhanced switch (Java 14+)
        String season = switch (month) {
            case 12, 1, 2 -> "Winter";
            case 3, 4, 5 -> "Spring";
            case 6, 7, 8 -> "Summer";
            case 9, 10, 11 -> "Fall";
            default -> "Invalid month";
        };
        System.out.println("Season: " + season);
    }
}
```

### Loops

#### For Loop

```java
public class ForLoopExample {
    public static void main(String[] args) {
        // Basic for loop
        System.out.println("Counting 1 to 5:");
        for (int i = 1; i <= 5; i++) {
            System.out.print(i + " ");
        }
        System.out.println();
        
        // Multiple variables
        for (int i = 0, j = 10; i < j; i++, j--) {
            System.out.println("i: " + i + ", j: " + j);
        }
        
        // Nested for loop
        System.out.println("\nMultiplication table:");
        for (int i = 1; i <= 5; i++) {
            for (int j = 1; j <= 5; j++) {
                System.out.printf("%4d", i * j);
            }
            System.out.println();
        }
    }
}
```

#### Enhanced For Loop (For-Each)

```java
public class EnhancedForLoop {
    public static void main(String[] args) {
        // Array iteration
        String[] fruits = {"Apple", "Banana", "Orange", "Mango"};
        
        System.out.println("Fruits:");
        for (String fruit : fruits) {
            System.out.println("- " + fruit);
        }
        
        // 2D array iteration
        int[][] matrix = {
            {1, 2, 3},
            {4, 5, 6},
            {7, 8, 9}
        };
        
        System.out.println("\nMatrix:");
        for (int[] row : matrix) {
            for (int value : row) {
                System.out.print(value + " ");
            }
            System.out.println();
        }
    }
}
```

#### While Loop

```java
public class WhileLoopExample {
    public static void main(String[] args) {
        // Basic while loop
        int count = 1;
        System.out.println("Counting with while:");
        while (count <= 5) {
            System.out.print(count + " ");
            count++;
        }
        System.out.println();
        
        // Input validation example
        int attempts = 0;
        boolean success = false;
        while (attempts < 3 && !success) {
            attempts++;
            System.out.println("Attempt " + attempts);
            // Simulating some condition
            if (attempts == 2) {
                success = true;
            }
        }
    }
}
```

#### Do-While Loop

```java
public class DoWhileLoopExample {
    public static void main(String[] args) {
        // Do-while executes at least once
        int count = 1;
        System.out.println("Do-while loop:");
        do {
            System.out.print(count + " ");
            count++;
        } while (count <= 5);
        System.out.println();
        
        // Example: Menu system
        int choice = 0;
        do {
            System.out.println("\n--- Menu ---");
            System.out.println("1. Option 1");
            System.out.println("2. Option 2");
            System.out.println("3. Exit");
            
            // Simulating user choice
            choice = 3; // Would be from user input
            
        } while (choice != 3);
    }
}
```

### Break and Continue

```java
public class BreakContinueExample {
    public static void main(String[] args) {
        // Break statement
        System.out.println("Break example:");
        for (int i = 1; i <= 10; i++) {
            if (i == 6) {
                break; // Exit the loop
            }
            System.out.print(i + " ");
        }
        System.out.println();
        
        // Continue statement
        System.out.println("Continue example (skip even numbers):");
        for (int i = 1; i <= 10; i++) {
            if (i % 2 == 0) {
                continue; // Skip to next iteration
            }
            System.out.print(i + " ");
        }
        System.out.println();
        
        // Labeled break (for nested loops)
        System.out.println("Labeled break example:");
        outer:
        for (int i = 1; i <= 3; i++) {
            for (int j = 1; j <= 3; j++) {
                if (i == 2 && j == 2) {
                    break outer; // Break out of both loops
                }
                System.out.println("i=" + i + ", j=" + j);
            }
        }
    }
}
```

---

## Methods

Methods are blocks of code that perform specific tasks and can be reused throughout your program.

### Method Declaration and Calling

```java
public class MethodsBasics {
    // Method without parameters or return value
    public static void greet() {
        System.out.println("Hello, World!");
    }
    
    // Method with parameters
    public static void greetPerson(String name) {
        System.out.println("Hello, " + name + "!");
    }
    
    // Method with return value
    public static int add(int a, int b) {
        return a + b;
    }
    
    // Method with multiple parameters and return value
    public static double calculateArea(double length, double width) {
        return length * width;
    }
    
    public static void main(String[] args) {
        greet();
        greetPerson("Alice");
        
        int sum = add(5, 3);
        System.out.println("Sum: " + sum);
        
        double area = calculateArea(5.5, 3.2);
        System.out.println("Area: " + area);
    }
}
```

### Method Overloading

Method overloading allows multiple methods with the same name but different parameters.

```java
public class MethodOverloading {
    // Overloaded methods
    public static int add(int a, int b) {
        return a + b;
    }
    
    public static double add(double a, double b) {
        return a + b;
    }
    
    public static int add(int a, int b, int c) {
        return a + b + c;
    }
    
    public static String add(String a, String b) {
        return a + b;
    }
    
    public static void main(String[] args) {
        System.out.println("add(5, 3): " + add(5, 3));           // 8
        System.out.println("add(5.5, 3.2): " + add(5.5, 3.2));   // 8.7
        System.out.println("add(1, 2, 3): " + add(1, 2, 3));     // 6
        System.out.println("add(\"Hello\", \" World\"): " + add("Hello", " World"));
    }
}
```

### Variable Arguments (Varargs)

```java
public class VarargsExample {
    // Method with variable number of arguments
    public static int sum(int... numbers) {
        int total = 0;
        for (int num : numbers) {
            total += num;
        }
        return total;
    }
    
    // Varargs must be the last parameter
    public static void printInfo(String name, int... scores) {
        System.out.println("Name: " + name);
        System.out.print("Scores: ");
        for (int score : scores) {
            System.out.print(score + " ");
        }
        System.out.println();
    }
    
    public static void main(String[] args) {
        System.out.println("sum(1, 2, 3): " + sum(1, 2, 3));
        System.out.println("sum(1, 2, 3, 4, 5): " + sum(1, 2, 3, 4, 5));
        System.out.println("sum(): " + sum());
        
        printInfo("Alice", 90, 85, 88);
        printInfo("Bob", 75, 80);
    }
}
```

### Recursion

```java
public class RecursionExample {
    // Recursive method to calculate factorial
    public static long factorial(int n) {
        if (n <= 1) {
            return 1; // Base case
        }
        return n * factorial(n - 1); // Recursive case
    }
    
    // Recursive method for Fibonacci sequence
    public static int fibonacci(int n) {
        if (n <= 1) {
            return n;
        }
        return fibonacci(n - 1) + fibonacci(n - 2);
    }
    
    // Recursive method to calculate sum
    public static int sumUpTo(int n) {
        if (n == 0) {
            return 0;
        }
        return n + sumUpTo(n - 1);
    }
    
    public static void main(String[] args) {
        System.out.println("Factorial of 5: " + factorial(5));      // 120
        System.out.println("10th Fibonacci number: " + fibonacci(10)); // 55
        System.out.println("Sum up to 10: " + sumUpTo(10));         // 55
    }
}
```

---

## Object-Oriented Programming

Java is fundamentally an object-oriented programming language. OOP is based on four main principles: Encapsulation, Inheritance, Polymorphism, and Abstraction.

### Classes and Objects

A class is a blueprint for creating objects. An object is an instance of a class.

```java
// Class definition
public class Car {
    // Fields (attributes)
    private String brand;
    private String model;
    private int year;
    private double price;
    
    // Constructor
    public Car(String brand, String model, int year, double price) {
        this.brand = brand;
        this.model = model;
        this.year = year;
        this.price = price;
    }
    
    // Methods (behaviors)
    public void start() {
        System.out.println(brand + " " + model + " is starting...");
    }
    
    public void accelerate() {
        System.out.println(brand + " " + model + " is accelerating...");
    }
    
    public void displayInfo() {
        System.out.println("Brand: " + brand);
        System.out.println("Model: " + model);
        System.out.println("Year: " + year);
        System.out.println("Price: $" + price);
    }
    
    // Getters and Setters
    public String getBrand() {
        return brand;
    }
    
    public void setBrand(String brand) {
        this.brand = brand;
    }
    
    public String getModel() {
        return model;
    }
    
    public void setModel(String model) {
        this.model = model;
    }
    
    public int getYear() {
        return year;
    }
    
    public void setYear(int year) {
        this.year = year;
    }
    
    public double getPrice() {
        return price;
    }
    
    public void setPrice(double price) {
        if (price >= 0) {
            this.price = price;
        }
    }
}

// Using the Car class
class CarDemo {
    public static void main(String[] args) {
        // Creating objects
        Car car1 = new Car("Toyota", "Camry", 2023, 25000);
        Car car2 = new Car("Honda", "Civic", 2022, 22000);
        
        // Using object methods
        car1.displayInfo();
        System.out.println();
        
        car1.start();
        car1.accelerate();
        System.out.println();
        
        // Using getters and setters
        System.out.println("Car 2 brand: " + car2.getBrand());
        car2.setPrice(23000);
        car2.displayInfo();
    }
}
```

### Constructors

Constructors are special methods used to initialize objects.

```java
public class Person {
    private String name;
    private int age;
    private String email;
    
    // Default constructor
    public Person() {
        this.name = "Unknown";
        this.age = 0;
        this.email = "not@provided.com";
    }
    
    // Parameterized constructor
    public Person(String name, int age) {
        this.name = name;
        this.age = age;
        this.email = "not@provided.com";
    }
    
    // Constructor with all parameters
    public Person(String name, int age, String email) {
        this.name = name;
        this.age = age;
        this.email = email;
    }
    
    // Constructor chaining
    public Person(String name) {
        this(name, 0, "not@provided.com");
    }
    
    public void displayInfo() {
        System.out.println("Name: " + name + ", Age: " + age + ", Email: " + email);
    }
    
    public static void main(String[] args) {
        Person p1 = new Person();
        Person p2 = new Person("Alice", 25);
        Person p3 = new Person("Bob", 30, "bob@example.com");
        Person p4 = new Person("Charlie");
        
        p1.displayInfo();
        p2.displayInfo();
        p3.displayInfo();
        p4.displayInfo();
    }
}
```

### The `this` Keyword

The `this` keyword refers to the current object.

```java
public class Employee {
    private String name;
    private int id;
    private double salary;
    
    public Employee(String name, int id, double salary) {
        this.name = name;     // this.name refers to instance variable
        this.id = id;
        this.salary = salary;
    }
    
    // Method returning current object
    public Employee updateSalary(double salary) {
        this.salary = salary;
        return this; // Returns current object for method chaining
    }
    
    public Employee updateName(String name) {
        this.name = name;
        return this;
    }
    
    public void displayInfo() {
        System.out.println("Name: " + this.name + ", ID: " + this.id + 
                           ", Salary: $" + this.salary);
    }
    
    // Calling another constructor
    public Employee(String name) {
        this(name, 0, 0.0); // Calls the main constructor
    }
    
    public static void main(String[] args) {
        Employee emp = new Employee("John", 101, 50000);
        
        // Method chaining using this
        emp.updateName("John Doe")
           .updateSalary(55000)
           .displayInfo();
    }
}
```

---

## Inheritance

Inheritance allows a class to inherit properties and methods from another class.

### Basic Inheritance

```java
// Parent class (Superclass)
class Animal {
    protected String name;
    protected int age;
    
    public Animal(String name, int age) {
        this.name = name;
        this.age = age;
    }
    
    public void eat() {
        System.out.println(name + " is eating.");
    }
    
    public void sleep() {
        System.out.println(name + " is sleeping.");
    }
    
    public void makeSound() {
        System.out.println(name + " makes a sound.");
    }
}

// Child class (Subclass)
class Dog extends Animal {
    private String breed;
    
    public Dog(String name, int age, String breed) {
        super(name, age); // Call parent constructor
        this.breed = breed;
    }
    
    // Override parent method
    @Override
    public void makeSound() {
        System.out.println(name + " barks: Woof! Woof!");
    }
    
    // Dog-specific method
    public void fetch() {
        System.out.println(name + " is fetching the ball.");
    }
    
    public void displayInfo() {
        System.out.println("Name: " + name + ", Age: " + age + ", Breed: " + breed);
    }
}

class Cat extends Animal {
    private String color;
    
    public Cat(String name, int age, String color) {
        super(name, age);
        this.color = color;
    }
    
    @Override
    public void makeSound() {
        System.out.println(name + " meows: Meow! Meow!");
    }
    
    public void scratch() {
        System.out.println(name + " is scratching.");
    }
}

class InheritanceDemo {
    public static void main(String[] args) {
        Dog dog = new Dog("Buddy", 3, "Golden Retriever");
        dog.displayInfo();
        dog.eat();
        dog.makeSound();
        dog.fetch();
        System.out.println();
        
        Cat cat = new Cat("Whiskers", 2, "Orange");
        cat.eat();
        cat.makeSound();
        cat.scratch();
    }
}
```

### The `super` Keyword

```java
class Vehicle {
    protected String brand;
    protected int maxSpeed;
    
    public Vehicle(String brand, int maxSpeed) {
        this.brand = brand;
        this.maxSpeed = maxSpeed;
    }
    
    public void display() {
        System.out.println("Brand: " + brand + ", Max Speed: " + maxSpeed);
    }
}

class Motorcycle extends Vehicle {
    private boolean hasSidecar;
    
    public Motorcycle(String brand, int maxSpeed, boolean hasSidecar) {
        super(brand, maxSpeed); // Call parent constructor
        this.hasSidecar = hasSidecar;
    }
    
    @Override
    public void display() {
        super.display(); // Call parent method
        System.out.println("Has Sidecar: " + hasSidecar);
    }
}
```

### Types of Inheritance

```java
// Single Inheritance
class A {
    void methodA() {
        System.out.println("Method A");
    }
}

class B extends A {
    void methodB() {
        System.out.println("Method B");
    }
}

// Multilevel Inheritance
class GrandParent {
    void grandMethod() {
        System.out.println("GrandParent method");
    }
}

class Parent extends GrandParent {
    void parentMethod() {
        System.out.println("Parent method");
    }
}

class Child extends Parent {
    void childMethod() {
        System.out.println("Child method");
    }
}

// Hierarchical Inheritance
class Shape {
    void draw() {
        System.out.println("Drawing a shape");
    }
}

class Circle extends Shape {
    void draw() {
        System.out.println("Drawing a circle");
    }
}

class Rectangle extends Shape {
    void draw() {
        System.out.println("Drawing a rectangle");
    }
}

class Triangle extends Shape {
    void draw() {
        System.out.println("Drawing a triangle");
    }
}
```

---

## Polymorphism

Polymorphism means "many forms" - the ability of an object to take many forms. The most common use is when a parent class reference is used to refer to a child class object.

### Method Overriding (Runtime Polymorphism)

```java
class Shape {
    public double calculateArea() {
        return 0;
    }
    
    public void display() {
        System.out.println("This is a shape");
    }
}

class Circle extends Shape {
    private double radius;
    
    public Circle(double radius) {
        this.radius = radius;
    }
    
    @Override
    public double calculateArea() {
        return Math.PI * radius * radius;
    }
    
    @Override
    public void display() {
        System.out.println("This is a circle with radius: " + radius);
    }
}

class Rectangle extends Shape {
    private double length;
    private double width;
    
    public Rectangle(double length, double width) {
        this.length = length;
        this.width = width;
    }
    
    @Override
    public double calculateArea() {
        return length * width;
    }
    
    @Override
    public void display() {
        System.out.println("This is a rectangle with length: " + length + 
                           " and width: " + width);
    }
}

class PolymorphismDemo {
    public static void main(String[] args) {
        // Parent reference to child objects
        Shape shape1 = new Circle(5);
        Shape shape2 = new Rectangle(4, 6);
        
        // Dynamic method dispatch
        shape1.display();
        System.out.println("Area: " + shape1.calculateArea());
        System.out.println();
        
        shape2.display();
        System.out.println("Area: " + shape2.calculateArea());
        System.out.println();
        
        // Array of polymorphic objects
        Shape[] shapes = {
            new Circle(3),
            new Rectangle(5, 7),
            new Circle(4)
        };
        
        System.out.println("Calculating all areas:");
        for (Shape shape : shapes) {
            System.out.println("Area: " + shape.calculateArea());
        }
    }
}
```

### Method Overloading (Compile-time Polymorphism)

```java
class Calculator {
    // Same method name, different parameters
    public int add(int a, int b) {
        return a + b;
    }
    
    public double add(double a, double b) {
        return a + b;
    }
    
    public int add(int a, int b, int c) {
        return a + b + c;
    }
    
    public String add(String a, String b) {
        return a + b;
    }
    
    public static void main(String[] args) {
        Calculator calc = new Calculator();
        
        System.out.println(calc.add(5, 3));           // 8
        System.out.println(calc.add(5.5, 3.2));       // 8.7
        System.out.println(calc.add(1, 2, 3));        // 6
        System.out.println(calc.add("Hello", " World")); // Hello World
    }
}
```

---

## Abstraction

Abstraction is the process of hiding implementation details and showing only functionality to the user.

### Abstract Classes

```java
// Abstract class
abstract class Employee {
    protected String name;
    protected int id;
    protected double baseSalary;
    
    public Employee(String name, int id, double baseSalary) {
        this.name = name;
        this.id = id;
        this.baseSalary = baseSalary;
    }
    
    // Abstract method (no implementation)
    public abstract double calculateSalary();
    
    // Abstract method
    public abstract void displayRole();
    
    // Concrete method
    public void displayInfo() {
        System.out.println("Name: " + name + ", ID: " + id);
    }
}

class FullTimeEmployee extends Employee {
    private double benefits;
    
    public FullTimeEmployee(String name, int id, double baseSalary, double benefits) {
        super(name, id, baseSalary);
        this.benefits = benefits;
    }
    
    @Override
    public double calculateSalary() {
        return baseSalary + benefits;
    }
    
    @Override
    public void displayRole() {
        System.out.println("Role: Full-Time Employee");
    }
}

class ContractEmployee extends Employee {
    private int hoursWorked;
    private double hourlyRate;
    
    public ContractEmployee(String name, int id, int hoursWorked, double hourlyRate) {
        super(name, id, 0); // No base salary
        this.hoursWorked = hoursWorked;
        this.hourlyRate = hourlyRate;
    }
    
    @Override
    public double calculateSalary() {
        return hoursWorked * hourlyRate;
    }
    
    @Override
    public void displayRole() {
        System.out.println("Role: Contract Employee");
    }
}

class AbstractDemo {
    public static void main(String[] args) {
        // Cannot instantiate abstract class
        // Employee emp = new Employee("John", 1, 50000); // Error
        
        Employee emp1 = new FullTimeEmployee("Alice", 101, 50000, 5000);
        Employee emp2 = new ContractEmployee("Bob", 102, 160, 50);
        
        emp1.displayInfo();
        emp1.displayRole();
        System.out.println("Salary: $" + emp1.calculateSalary());
        System.out.println();
        
        emp2.displayInfo();
        emp2.displayRole();
        System.out.println("Salary: $" + emp2.calculateSalary());
    }
}
```

---

## Encapsulation

Encapsulation is the bundling of data and methods that operate on that data within a single unit (class), and restricting access to some components.

### Access Control

```java
public class BankAccount {
    // Private fields (encapsulated)
    private String accountNumber;
    private String accountHolder;
    private double balance;
    private String pin;
    
    public BankAccount(String accountNumber, String accountHolder, String pin) {
        this.accountNumber = accountNumber;
        this.accountHolder = accountHolder;
        this.balance = 0.0;
        this.pin = pin;
    }
    
    // Public methods to access private data
    public boolean deposit(double amount) {
        if (amount > 0) {
            balance += amount;
            System.out.println("Deposited: $" + amount);
            return true;
        }
        System.out.println("Invalid amount");
        return false;
    }
    
    public boolean withdraw(double amount, String pin) {
        if (!this.pin.equals(pin)) {
            System.out.println("Invalid PIN");
            return false;
        }
        
        if (amount > 0 && amount <= balance) {
            balance -= amount;
            System.out.println("Withdrawn: $" + amount);
            return true;
        }
        System.out.println("Insufficient funds or invalid amount");
        return false;
    }
    
    public double getBalance(String pin) {
        if (this.pin.equals(pin)) {
            return balance;
        }
        System.out.println("Invalid PIN");
        return -1;
    }
    
    public String getAccountHolder() {
        return accountHolder;
    }
    
    public String getAccountNumber() {
        // Return masked account number
        return "****" + accountNumber.substring(accountNumber.length() - 4);
    }
    
    public static void main(String[] args) {
        BankAccount account = new BankAccount("1234567890", "John Doe", "1234");
        
        // Cannot access private fields directly
        // account.balance = 1000000; // Error: balance has private access
        
        // Use public methods
        account.deposit(1000);
        System.out.println("Balance: $" + account.getBalance("1234"));
        
        account.withdraw(200, "1234");
        System.out.println("Balance: $" + account.getBalance("1234"));
        
        account.withdraw(200, "0000"); // Wrong PIN
        
        System.out.println("Account: " + account.getAccountNumber());
    }
}
```

### Getters and Setters with Validation

```java
public class Person {
    private String name;
    private int age;
    private String email;
    
    // Getter for name
    public String getName() {
        return name;
    }
    
    // Setter for name with validation
    public void setName(String name) {
        if (name != null && !name.trim().isEmpty()) {
            this.name = name;
        } else {
            throw new IllegalArgumentException("Name cannot be empty");
        }
    }
    
    // Getter for age
    public int getAge() {
        return age;
    }
    
    // Setter for age with validation
    public void setAge(int age) {
        if (age >= 0 && age <= 150) {
            this.age = age;
        } else {
            throw new IllegalArgumentException("Age must be between 0 and 150");
        }
    }
    
    // Getter for email
    public String getEmail() {
        return email;
    }
    
    // Setter for email with validation
    public void setEmail(String email) {
        if (email != null && email.contains("@")) {
            this.email = email;
        } else {
            throw new IllegalArgumentException("Invalid email format");
        }
    }
    
    public static void main(String[] args) {
        Person person = new Person();
        
        person.setName("Alice");
        person.setAge(25);
        person.setEmail("alice@example.com");
        
        System.out.println("Name: " + person.getName());
        System.out.println("Age: " + person.getAge());
        System.out.println("Email: " + person.getEmail());
        
        // Validation in action
        try {
            person.setAge(200); // Will throw exception
        } catch (IllegalArgumentException e) {
            System.out.println("Error: " + e.getMessage());
        }
    }
}
```

---

## Interfaces

An interface is a completely abstract class that contains only abstract methods. It defines a contract that implementing classes must follow.

### Basic Interface

```java
// Interface definition
interface Drawable {
    // Abstract methods (implicitly public and abstract)
    void draw();
    void resize(double factor);
}

// Implementing interface
class Circle implements Drawable {
    private double radius;
    
    public Circle(double radius) {
        this.radius = radius;
    }
    
    @Override
    public void draw() {
        System.out.println("Drawing a circle with radius: " + radius);
    }
    
    @Override
    public void resize(double factor) {
        radius *= factor;
        System.out.println("Circle resized. New radius: " + radius);
    }
}

class Rectangle implements Drawable {
    private double length;
    private double width;
    
    public Rectangle(double length, double width) {
        this.length = length;
        this.width = width;
    }
    
    @Override
    public void draw() {
        System.out.println("Drawing a rectangle: " + length + " x " + width);
    }
    
    @Override
    public void resize(double factor) {
        length *= factor;
        width *= factor;
        System.out.println("Rectangle resized. New dimensions: " + length + " x " + width);
    }
}

class InterfaceDemo {
    public static void main(String[] args) {
        Drawable circle = new Circle(5);
        Drawable rectangle = new Rectangle(4, 6);
        
        circle.draw();
        circle.resize(2);
        circle.draw();
        
        System.out.println();
        
        rectangle.draw();
        rectangle.resize(0.5);
        rectangle.draw();
    }
}
```

### Multiple Interface Implementation

```java
interface Flyable {
    void fly();
}

interface Swimmable {
    void swim();
}

interface Walkable {
    void walk();
}

// Class implementing multiple interfaces
class Duck implements Flyable, Swimmable, Walkable {
    private String name;
    
    public Duck(String name) {
        this.name = name;
    }
    
    @Override
    public void fly() {
        System.out.println(name + " is flying.");
    }
    
    @Override
    public void swim() {
        System.out.println(name + " is swimming.");
    }
    
    @Override
    public void walk() {
        System.out.println(name + " is walking.");
    }
}

class Fish implements Swimmable {
    private String name;
    
    public Fish(String name) {
        this.name = name;
    }
    
    @Override
    public void swim() {
        System.out.println(name + " is swimming.");
    }
}
```

### Default and Static Methods in Interfaces (Java 8+)

```java
interface Vehicle {
    // Abstract method
    void start();
    void stop();
    
    // Default method
    default void honk() {
        System.out.println("Beep! Beep!");
    }
    
    default void displayInfo() {
        System.out.println("This is a vehicle");
    }
    
    // Static method
    static void service() {
        System.out.println("Vehicle serviced");
    }
}

class Car implements Vehicle {
    @Override
    public void start() {
        System.out.println("Car is starting...");
    }
    
    @Override
    public void stop() {
        System.out.println("Car is stopping...");
    }
    
    // Can override default method
    @Override
    public void displayInfo() {
        System.out.println("This is a car");
    }
}

class Bike implements Vehicle {
    @Override
    public void start() {
        System.out.println("Bike is starting...");
    }
    
    @Override
    public void stop() {
        System.out.println("Bike is stopping...");
    }
    
    // Uses default honk() implementation
}
```

### Interface Inheritance

```java
interface Animal {
    void eat();
}

interface Mammal extends Animal {
    void breathe();
}

interface Carnivore extends Animal {
    void hunt();
}

class Lion implements Mammal, Carnivore {
    @Override
    public void eat() {
        System.out.println("Lion is eating meat");
    }
    
    @Override
    public void breathe() {
        System.out.println("Lion is breathing");
    }
    
    @Override
    public void hunt() {
        System.out.println("Lion is hunting");
    }
}
```

---

## Packages

Packages are used to group related classes and interfaces together. They help organize code and prevent naming conflicts.

### Creating and Using Packages

```java
// File: com/example/shapes/Circle.java
package com.example.shapes;

public class Circle {
    private double radius;
    
    public Circle(double radius) {
        this.radius = radius;
    }
    
    public double getArea() {
        return Math.PI * radius * radius;
    }
}

// File: com/example/shapes/Rectangle.java
package com.example.shapes;

public class Rectangle {
    private double length;
    private double width;
    
    public Rectangle(double length, double width) {
        this.length = length;
        this.width = width;
    }
    
    public double getArea() {
        return length * width;
    }
}

// File: com/example/main/Main.java
package com.example.main;

// Importing specific class
import com.example.shapes.Circle;
// Importing all classes from package
import com.example.shapes.*;

public class Main {
    public static void main(String[] args) {
        Circle circle = new Circle(5);
        Rectangle rectangle = new Rectangle(4, 6);
        
        System.out.println("Circle area: " + circle.getArea());
        System.out.println("Rectangle area: " + rectangle.getArea());
    }
}
```

### Built-in Packages

```java
import java.util.*;        // Collections
import java.io.*;          // Input/Output
import java.lang.*;        // Fundamental classes (imported by default)
import java.net.*;         // Networking
import java.sql.*;         // Database connectivity
import java.time.*;        // Date and time API

public class BuiltInPackagesDemo {
    public static void main(String[] args) {
        // java.util
        List<String> list = new ArrayList<>();
        Map<String, Integer> map = new HashMap<>();
        
        // java.time
        LocalDate today = LocalDate.now();
        LocalTime time = LocalTime.now();
        
        // java.lang (no import needed)
        String str = "Hello";
        int num = Integer.parseInt("123");
        
        System.out.println("Today: " + today);
        System.out.println("Time: " + time);
    }
}
```

---

## Access Modifiers

Access modifiers control the visibility of classes, methods, and fields.

### Types of Access Modifiers

| Modifier    | Class | Package | Subclass | World |
|-------------|-------|---------|----------|-------|
| public      | ✓     | ✓       | ✓        | ✓     |
| protected   | ✓     | ✓       | ✓        | ✗     |
| default     | ✓     | ✓       | ✗        | ✗     |
| private     | ✓     | ✗       | ✗        | ✗     |

### Access Modifier Examples

```java
// File: AccessModifierDemo.java
public class AccessModifierDemo {
    // Public: accessible everywhere
    public String publicField = "Public";
    
    // Protected: accessible in same package and subclasses
    protected String protectedField = "Protected";
    
    // Default: accessible only in same package
    String defaultField = "Default";
    
    // Private: accessible only within this class
    private String privateField = "Private";
    
    public void displayFields() {
        System.out.println("Public: " + publicField);
        System.out.println("Protected: " + protectedField);
        System.out.println("Default: " + defaultField);
        System.out.println("Private: " + privateField);
    }
    
    private void privateMethod() {
        System.out.println("Private method");
    }
    
    public void publicMethod() {
        System.out.println("Public method");
        privateMethod(); // Can access private method within class
    }
}

class TestAccess {
    public static void main(String[] args) {
        AccessModifierDemo obj = new AccessModifierDemo();
        
        System.out.println(obj.publicField);     // OK
        System.out.println(obj.protectedField);  // OK (same package)
        System.out.println(obj.defaultField);    // OK (same package)
        // System.out.println(obj.privateField); // Error: private access
        
        obj.publicMethod();                      // OK
        // obj.privateMethod();                  // Error: private access
    }
}

// Subclass in different package
class SubClass extends AccessModifierDemo {
    public void test() {
        System.out.println(publicField);      // OK
        System.out.println(protectedField);   // OK (subclass)
        // System.out.println(defaultField);  // Error (different package)
        // System.out.println(privateField);  // Error (private)
    }
}
```

---

## Best Practices

1. **Naming Conventions**: Follow Java naming standards consistently
2. **Encapsulation**: Always use private fields with public getters/setters
3. **Single Responsibility**: Each class should have one clear purpose
4. **DRY Principle**: Don't Repeat Yourself - avoid code duplication
5. **Comments**: Write clear comments for complex logic
6. **Exception Handling**: Handle exceptions appropriately
7. **Use StringBuilder**: For string concatenation in loops
8. **Prefer Composition over Inheritance**: When possible
9. **Program to Interfaces**: Not implementations
10. **Keep Methods Small**: Each method should do one thing well

---

## Summary

This tutorial covered the fundamental concepts of Java:

- **Basics**: Syntax, data types, variables, operators
- **Control Flow**: if-else, switch, loops
- **Methods**: Declaration, overloading, recursion
- **OOP Pillars**: Encapsulation, Inheritance, Polymorphism, Abstraction
- **Advanced Concepts**: Interfaces, packages, access modifiers

Understanding these fundamentals is crucial for becoming proficient in Java development. Practice these concepts through coding exercises to solidify your understanding.

---

**Next**: [Java Collections Framework](02_JAVA_COLLECTIONS.md)
