Data Structure Notes

1. Primitive Data Types - int, float , char ,etc.,
2. User Defined Data Types - struct in C/C++, classes in JAVA

1. Linear Data Structure -  Linked Lists, Stacks and Queues.
2. Non- Linear Data Structure - Trees , Graphs

Abstract Data Type(ADT) includes 
1. Declaration of Data
2. Declaration of Operations
Commonly used ADTs include: Linked Lists, Stacks, Queues, Priority Queues, Binary Trees, Dictionaries, Disjoint Sets (Union and Find), Hash Tables, Graphs, and many others.

### Algorithm

- A step by step unambiguous instructions to solve a given problem.

Two Criteria to check Algorithm
1. Correctness
2. Efficiency


### 1. Linked List

   Logic - Header Package

   ADT - insert , delete

   Array takes memory allocation with fixed index, adding to 0 index cost more expensive for swapping

   Advantages
   - They can expand constant time without extending new array to old array like Array

   Disadvantages 
   - Access time to data O(n) vs (Array is random index - O(1))
   - Hard to manipulate  - when last one holding null value is deleted, list is transvered to find last one

   Singly vs Double Linked List vs Circular Linked List
   

### 2. Stack ( Last in First Out)

   ADT - Main Stack Operations 		  -> Push() , POP()
         Auxiliary Stack Operations -> Top(),Size(),IsEmptyStack(),IsFullStack()

   ### Direct Application
   - Page visited history in Web browser
   - Undo Sequence in text editor
   - Matching Tags in Html and XML

### 3. Queue ( First In First Out)

   Logic - Front Rear

   ADT -  Main Queue Operations      -> EnQueue() , DeQueue()
          Auxiliary Queue Operations -> Front(), QueueSize(), isEmptyQueue()

   ### Direct Application
   - Operation system schedule jobs
   - Like Ticket Counter
   - Multiprogramming
   - Asynchronous data transfer
   - Waiting times for customer at call center
   - Determining numbers of cashier at supermarket

### 4. Tree

   A tree structure is a way of representing the hierarchical nature of a structure in a graphical form.

   Parent -> Child , same parent means siblings, node without children is leaf node.

   1. Left Skew Tree (Nodes down only left)
   2. SKew Tree (Nodes down both left and right)
   3. Right Skew Tree (Nodes down only right)

   ### Binary Tree
   A tree is called binary tree if each node has zero child, one child or two children. Empty tree is also a valid binary tree. 

  1. Strict Binary Tree
      - Each Node has zero or two chidren
     
  2. Fully Binary Tree
      - Each Node has two chidren and all leaf nodes are same level
     
  3. Complete Binary Tree
     - if all leaf nodes are at height h or h – 1
    
  Basic Operations
• Inserting an element into a tree
• Deleting an element from a tree
• Searching for an element
• Traversing the tree
  
  Auxiliary Operations
• Finding the size of the tree
• Finding the height of the tree
• Finding the level which has maximum sum
• Finding the least common ancestor (LCA) for a given pair of nodes, and many more.

  ### Direct Applications
  - Expression trees -  in compilers
  - Huffan coding trees - in data compression algorithms
  - Priority Queue (PQ) - supports search and deletion of minimum (or maximum)
on a collection of items in logarithmic time (in worst case).

  ### Tranversal 
  ( L - left, R - right, D - visiting and denoting current node)
• Preorder (DLR) Traversal
• Inorder (LDR) Traversal
• Postorder (LRD) Traversal

* Level Order Traversal: This method is inspired from Breadth First Traversal (BFS of Graph algorithms).

  ### Expression Tree
  A tree representing an expression is called an expression tree.
  In expression trees, leaf nodes are operands and non-leaf nodes are operators.
  That means, an expression tree is a binary tree where internal nodes are operators and leaves are operands.

  ### Binary Search Tree
  - L is less than D, R is greater than D
  - Performing inorder traversal produces a sorted list.

 ### 5. Priority Queue and Heaps

   ### Priority Queue - assending
   ADT - Insert() , DeleteMin(), DeleteMax(), GetMinimum(), GetMaximum()

   ### Direct Applications
   - Job scheduling, which is prioritized instead of serving in first come first serve.
   - Data compression: Huffman Coding algorithm
   - Shortest path algorithms: Dijkstra’s algorithm
   - Minimum spanning tree algorithms: Prim’s algorithm
   - Event-driven simulation: customers in a line

  ### Heap 
  - Binary Tree with Heap property - a node be >= or (<=) than values of its children
  - Less than equal    => Min Heap
  - Greater than equal => Max Heap


### 6. Disjoint Set


### 7. Graphs

   - Objects and their relationships - eg Flights routes between cities
   - Graph is a pair (V,E) - Vertices = nodes , Edges = pair of vertices

   - မြှားပါရင် - Directed , မြှားမပါ - Undirected


### Sorting

   - Arraning elements of list in certain order (ascending or descending)

  - By number of comparison
     -  best case - O(n Log n) , worst case - n square

  - By number of swap
  - By memory usage
  - By recursion
  - By stability
  - By adaptability

  If use main memory - Internal Sort
  If use external memory - External Sort

  # Sorting Algorithms Comparison

Sorting algorithms are fundamental in computer science, and they can be categorized based on their characteristics, efficiency, and use cases. Below is a detailed overview of some common sorting algorithms, their complexities, and comparisons.

# Sorting Algorithms Comparison

Sorting algorithms are fundamental in computer science, and they can be categorized based on their characteristics, efficiency, and use cases. Below is a detailed overview of some common sorting algorithms, their complexities, and comparisons.

## 1. Bubble Sort

- **Description**: A simple comparison-based algorithm that repeatedly steps through the list, compares adjacent elements, and swaps them if they are in the wrong order.
- **How It Works**: 
  - Start at the beginning of the array.
  - Compare the first two elements. If the first is greater than the second, swap them.
  - Move to the next pair and repeat until the end of the array is reached.
  - Repeat the process for the entire array until no swaps are needed.
- **Time Complexity**: 
  - Best: O(n)
  - Average: O(n^2)
  - Worst: O(n^2)
- **Space Complexity**: O(1)
- **Stability**: Stable
- **Use Case**: Educational purposes, small datasets.
- **Advantage **: can detect whether input list is sorted or not

## 2. Selection Sort

- **Description**: Divides the input list into two parts: a sorted and an unsorted part. It repeatedly selects the smallest (or largest) element from the unsorted part and moves it to the sorted part.
- **How It Works**: 
  - Start with the first element as the minimum.
  - Compare it with the rest of the array to find the smallest element.
  - Swap the smallest found with the first element.
  - Move to the next element and repeat until the array is sorted.
- **Time Complexity**: 
  - Best: O(n^2)
  - Average: O(n^2)
  - Worst: O(n^2)
- **Space Complexity**: O(1)
- **Stability**: Unstable
- **Use Case**: Small datasets, when memory space is limited.
- **Advantage **: in-place sort(requires no additional storage space)

## 3. Insertion Sort

- **Description**: Builds a sorted array one element at a time by repeatedly taking the next element from the input and inserting it into the correct position in the sorted part.
- If every element is greater than or equal to every element to its left, the running time of insertion sort is Θ(n).
- **How It Works**: 
  - Start with the second element. Compare it to the first and insert it in the correct position.
  - Move to the next element and insert it into the sorted part by shifting larger elements to the right.
  - Repeat until the entire array is sorted.
- **Time Complexity**: 
  - Best: O(n)
  - Average: O(n^2)
  - Worst: O(n^2)
- **Space Complexity**: O(1)
- **Stability**: Stable
- **Use Case**: Small datasets, partially sorted datasets.

• Bubble sort takes n^2/2 comparisons and n^2/2 swaps in both average and worst case.

• Selection sort takes n^2/2 comparisons and n swaps
• Selection sort is best suits for elements with bigger values and small keys.

• Insertion sort takes n^2/4 comparisons and n^2/8 swaps in average case , worst case - double.
• Insertion sort is almost linear for partially sorted input.

### 3.1 Shell Sort (diminishing increment sort)

- **Description**: An optimization of insertion sort that allows the exchange of items that are far apart.
- n-gap insertion sort
- **How It Works**: 
  - Start with a gap (initially set to half the array length).
  - Compare elements that are a gap apart and swap them if they are in the wrong order.
  - Reduce the gap and repeat until the gap is 1, at which point it becomes a regular insertion sort.
- **Time Complexity**: 
  - Best: O(n log n)
  - Average: O(n^(3/2))
  - Worst: O(n^2)
- **Space Complexity**: O(1)
- **Stability**: Unstable
- **Use Case**: Medium-sized datasets, when a simple implementation is needed.
- Shell sort is efficient for medium size lists. For bigger lists, the algorithm is not the best choice. It is the fastest of all O(n2) sorting algorithms.

## 4. Merge Sort

- **Description**: A divide-and-conquer algorithm that divides the array into halves, sorts them, and then merges the sorted halves.
- **How It Works**: 
  - Divide the array into two halves.
  - Recursively sort each half.
  - Merge the two sorted halves into a single sorted array.
- **Time Complexity**: 
  - Best: O(n log n)
  - Average: O(n log n)
  - Worst: O(n log n)
- **Space Complexity**: O(n)
- **Stability**: Stable
- **Use Case**: Large datasets, linked lists.

## 5. Quick Sort

- **Description**: A divide-and-conquer algorithm that selects a 'pivot' element and partitions the array into elements less than and greater than the pivot, then recursively sorts the partitions.
- 
- **How It Works**: 
  - Choose a pivot element from the array.
  - Partition the array into two sub-arrays: elements less than the pivot and elements greater than the pivot.
  - Recursively apply the same process to the sub-arrays.
- **Time Complexity**: 
  - Best: O(n log n)
  - Average: O(n log n)
  - Worst: O(n^2) (rare, occurs with poor pivot choices)
- **Space Complexity**: O(log n) (due to recursion stack)
- **Stability**: Unstable
- **Use Case**: Large datasets, when average performance is critical.

### 5.1 Randomized Quick Sort

- **Description**: A variant of quick sort that selects a pivot randomly, which helps to avoid the worst-case scenario of O(n^2) time complexity.
- **How It Works**: 
  - Randomly select a pivot element from the array.
  - Partition the array into two sub-arrays based on the pivot.
  - Recursively apply the same process to the sub-arrays.
- **Time Complexity**: 
  - Best: O(n log n)
  - Average: O(n log n)
  - Worst: O(n^2) (rare, but less likely than standard quick sort)
- **Space Complexity**: O(log n)
- **Stability**: Unstable
- **Use Case**: Large datasets, when average performance is critical and worst-case scenarios need to be minimized.

## 6. Heap Sort

- **Description**: Converts the array into a heap structure, then repeatedly extracts the maximum element from the heap and rebuilds the heap.
- **How It Works**: 
  - Build a max heap from the array.
  - Swap the root of the heap (maximum element) with the last element of the array.
  - Reduce the size of the heap and heapify the root.
  - Repeat until the heap is empty.
- **Time Complexity**: 
  - Best: O(n log n)
  - Average: O(n log n)
  - Worst: O(n log n)
- **Space Complexity**: O(1)
- **Stability**: Unstable
- **Use Case**: Large datasets, when memory usage is a concern.

## 7. Counting Sort

- **Description**: A non-comparison-based sorting algorithm that counts the occurrences of each unique element and calculates the position of each element in the sorted array.
- **How It Works**: 
  - Count the occurrences of each unique element.
  - Calculate the cumulative count to determine the position of each element in the sorted array.
  - Place each element in its correct position in the output array.
- **Time Complexity**: 
  - Best: O(n + k)
  - Average: O(n + k)
  - Worst: O(n + k) (where k is the range of the input)
- **Space Complexity**: O(k)
- **Stability**: Stable
- **Use Case**: When the range of input values (k) is not significantly larger than the number of elements (n).

## 8. Radix Sort

- **Description**: A non-comparison-based sorting algorithm that sorts numbers by processing individual digits. It uses counting sort as a subroutine.
- **How It Works**: 
  - Sort the input numbers by each digit, starting from the least significant digit to the most significant digit.
  - Use counting sort to sort the numbers based on the current digit.
  - Repeat for all digits.
- **Time Complexity**: 
  - Best: O(nk)
  - Average: O(nk)
  - Worst: O(nk) (where k is the number of digits in the largest number)
- **Space Complexity**: O(n + k)
- **Stability**: Stable
- **Use Case**: Sorting integers or strings, especially when the range of digits is limited.

## 9. Bucket Sort

- **Description**: Distributes elements into a number of buckets, sorts each bucket individually (often using another sorting algorithm), and then concatenates the results.
- **How It Works**: 
  - Create a number of empty buckets.
  - Distribute the elements into the buckets based on a specific range.
  - Sort each bucket individually (using another sorting algorithm).
  - Concatenate the sorted buckets to get the final sorted array.
- **Time Complexity**: 
  - Best: O(n + k)
  - Average: O(n + k)
  - Worst: O(n^2) (if all elements fall into one bucket)
- **Space Complexity**: O(n + k)
- **Stability**: Stable
- **Use Case**: Uniformly distributed data.

## 10. Tree Sort

- **Description**: Builds a binary search tree from the elements and then performs an in-order traversal to retrieve the elements in sorted order.
- **How It Works**: 
  - Insert each element into a binary search tree.
  - Perform an in-order traversal of the tree to retrieve the elements in sorted order.
- **Time Complexity**: 
  - Best: O(n log n)
  - Average: O(n log n)
  - Worst: O(n^2) (if the tree becomes unbalanced)
- **Space Complexity**: O(n) (for the tree structure)
- **Stability**: Unstable
- **Use Case**: When data is dynamic and needs frequent insertions and deletions.

## Summary Table

| Algorithm            | Time Complexity (Best) | Time Complexity (Average) | Time Complexity (Worst) | Space Complexity | Stability | Use Case                      |
|----------------------|------------------------|---------------------------|-------------------------|------------------|-----------|-------------------------------|
| Bubble Sort          | O(n)                   | O(n^2)                    | O(n^2)                  | O(1)             | Stable    | Educational, small datasets   |
| Selection Sort       | O(n^2)                 | O(n^2)                    | O(n^2)                  | O(1)             | Unstable  | Small datasets                |
| Insertion Sort       | O(n)                   | O(n^2)                    | O(n^2)                  | O(1)             | Stable    | Small, partially sorted data   |
| Shell Sort           | O(n log n)            | O(n^(3/2))                | O(n^2)                  | O(1)             | Unstable  | Medium-sized datasets         |
| Merge Sort           | O(n log n)            | O(n log n)                | O(n log n)              | O(n)             | Stable    | Large datasets                |
| Quick Sort           | O(n log n)            | O(n log n)                | O(n^2)                  | O(log n)         | Unstable  | Large datasets                |
| Randomized Quick Sort| O(n log n)            | O(n log n)                | O(n^2)                  | O(log n)         | Unstable  | Large datasets                |
| Heap Sort            | O(n log n)            | O(n log n)                | O(n log n)              | O(1)             | Unstable  | Large datasets                |
| Counting Sort        | O(n + k)              | O(n + k)                  | O(n + k)                | O(k)             | Stable    | Limited range of integers     |
| Radix Sort           | O(nk)                 | O(nk)                     | O(nk)                   | O(n + k)         | Stable    | Sorting integers/strings      |
| Bucket Sort          | O(n + k)              | O(n + k)                  | O(n^2)                  | O(n + k)         | Stable    | Uniformly distributed data    |
| Tree Sort            | O(n log n)            | O(n log n)                | O(n^2)                  | O(n)             | Unstable  | Dynamic data with frequent ops|

## Conclusion

Choosing the right sorting algorithm depends on the specific requirements of the task, such as the size of the dataset, the nature of the data, and the importance of stability. Understanding the strengths and weaknesses of each algorithm can help in making an informed decision.

# Searching Algorithms

## Unordered Linear Search
- **Description**: This is the simplest search algorithm. It scans each element of the array sequentially until the desired element is found or the end of the array is reached. It does not require the array to be sorted.

## Sorted/Ordered Linear Search
- **Description**: Similar to unordered linear search, but it takes advantage of the sorted order. If the current element is greater than the target element, the search can be terminated early, as the target cannot be in the remaining elements.

## Binary Search
- **Description**: A highly efficient search algorithm that works on sorted arrays. It repeatedly divides the search interval in half. If the value of the search key is less than the item in the middle of the interval, the search continues in the lower half, or if greater, in the upper half. This process continues until the value is found or the interval is empty.

## Interpolation Search
- **Description**: An improved variant of binary search for uniformly distributed data. It estimates the position of the target value based on the values at the ends of the current search interval, rather than always choosing the middle. It can be faster than binary search for certain distributions of data.

## Binary Search Trees (BST)
- **Description**: A tree data structure where each node has at most two children, referred to as the left child and the right child. For each node, all elements in the left subtree are less than the node, and all elements in the right subtree are greater. This property makes searching efficient.

## Symbol Tables and Hashing
- **Description**: Symbol tables are data structures that associate keys with values. Hashing is a technique used to implement symbol tables, where a hash function is used to compute an index into an array of buckets or slots, from which the desired value can be found.

## String Searching Algorithms
- **Tries**: A tree-like data structure that stores a dynamic set of strings, where the keys are usually strings. It is used for efficient retrieval of a key in a dataset of strings.
- **Ternary Search Trees**: A type of trie where nodes are arranged in a manner similar to binary search trees, but with three children: low, equal, and high.
- **Suffix Trees**: A compressed trie containing all the suffixes of the given text as their keys and positions in the text as their values. It is used for fast substring searching.

# Selection Algorithms

- algorithm for finding the kth smallest/largest number in a list (also
called as kth order statistic) - finding minimum, maximum and median

# Symbol Tables

- Key - Value Mappings

Real time examples for dictionaries
- spell checker
- Data dictionary in database management applications
- Symbol tables generated by loaders, assemblers and compilers
- Routing tables in networking components (DNS lookup)

## Implementations
1. Unordered Array/LinkedList
2. Ordered [Sorted] Array/LinkedList
   • Store in sorted order by key
   • keys[i] = ith largest key
   • values[i] = value associated with ith largest key
3. Binary Search Tree
4. Balanced Binary Search Tree
5. Ternary Search
6. Hashing

# Hashing

technique used for storing and retrieving information as quickly as possible

## What is Hashing?

Hashing is a process of converting an input (or 'key') into a fixed-size string of bytes, typically for the purpose of indexing and retrieving items in a database or a data structure called a hash table. The output, known as a hash code or hash value, is generated by a hash function.

ADT 
 - CreateHashTable()
 - HashSearch()
 - HashInsert()
 - HashDelete()
 - DeleteHashTable()

## Key Concepts

1. **Hash Function**:
   - A hash function takes an input (or 'key') and returns a fixed-size string of bytes. The output is typically a 'hash code' or 'hash value'.
   - A good hash function should distribute hash codes uniformly across the hash table to minimize collisions.

2. **Hash Table**:
   - A data structure that implements an associative array, a structure that can map keys to values.
   - It uses a hash function to compute an index into an array of buckets or slots, from which the desired value can be found.

3. **Collisions**:
   - Occur when two different keys hash to the same index in a hash table.
   - Collisions are handled using techniques like chaining (where each bucket contains a list of all elements that hash to the same index) or open addressing (where a collision is resolved by probing alternative locations).

4. **Load Factor**:
   - The load factor of a hash table is the ratio of the number of elements to the number of buckets.
   - A high load factor can lead to more collisions, which can degrade performance.

## Advantages of Hashing

- **Fast Data Retrieval**: Hashing allows for constant time complexity, O(1), for search, insert, and delete operations in the average case.
- **Efficient Use of Space**: Hash tables can be more space-efficient than other data structures like arrays or linked lists, especially when the number of elements is much smaller than the range of possible keys.

## Applications of Hashing

1. **Data Storage and Retrieval**: Used in databases and caches to quickly locate a data record given its search key.
2. **Cryptography**: Hash functions are used in various cryptographic algorithms to ensure data integrity and security.
3. **Checksum and Data Integrity**: Hash functions are used to verify the integrity of data by generating a checksum.
4. **Load Balancing**: Hashing is used in distributed systems to distribute data evenly across multiple servers.

## Common Hashing Techniques

1. **Chaining**:
   - Each bucket in the hash table contains a linked list of entries that hash to the same index.
   - This method is simple and effective for handling collisions.

2. **Open Addressing**:
   - All elements are stored within the hash table itself.
   - When a collision occurs, the algorithm probes for the next available slot using methods like linear probing, quadratic probing, or double hashing.

3. **Perfect Hashing**:
   - A technique used when the set of keys is known in advance, allowing for a hash function that produces no collisions.

## Challenges in Hashing

- **Designing a Good Hash Function**: A poorly designed hash function can lead to many collisions, degrading performance.
- **Handling Collisions**: Efficiently managing collisions is crucial for maintaining the performance of a hash table.
- **Dynamic Resizing**: As the number of elements grows, the hash table may need to be resized to maintain performance, which can be costly.

Hashing is a powerful tool in computer science, providing efficient solutions for a wide range of problems. Its effectiveness depends heavily on the choice of hash function and collision resolution strategy.


# String Matching Algorithms

String matching algorithms are used to find occurrences of a pattern within a text. Here are some common algorithms:

## 1. Brute Force Method
- **Description**: The simplest string matching algorithm. It checks for the presence of a pattern by comparing it with all possible substrings of the text.
- **Time Complexity**: Worst case \(O(n \times m)\), where \(n\) is the length of the text and \(m\) is the length of the pattern.
- **Example**: 
  - Text (T): "abracadabra"
  - Pattern (P): "cad"
  - Steps:
    - Position 0: "abr" vs "cad" - No match.
    - Position 1: "bra" vs "cad" - No match.
    - Position 2: "rac" vs "cad" - No match.
    - Position 3: "aca" vs "cad" - No match.
    - Position 4: "cad" vs "cad" - Match found!

## 2. Rabin-Karp String Matching Algorithm
- **Description**: Uses hashing to find any one of a set of pattern strings in a text. It calculates a hash value for the pattern and each substring of the text of the same length, and compares these hash values.
- **Time Complexity**: Best case \(O(n + m)\), Worst case \(O(n \times m)\) due to hash collisions.
- **Example**:
  - Text (T): "abracadabra"
  - Pattern (P): "cad"
  - Steps:
    - Hash the Pattern: "cad" = 296
    - Initial Hash of Text: "abr" = 309
    - Slide Over Text:
      - Position 1: "bra" = 309 - No match.
      - Position 2: "rac" = 310 - No match.
      - Position 3: "aca" = 293 - No match.
      - Position 4: "cad" = 296 - Match found!

## 3. String Matching with Finite Automata
- **Description**: Constructs a finite automaton for the pattern and processes the text through this automaton to find matches.
- **Time Complexity**: Preprocessing in \(O(m)\), Matching in \(O(n)\).
- **Example**:
  - Text (T): "abababac"
  - Pattern (P): "ababac"
  - Steps:
    - Build a finite automaton for the pattern "ababac".
    - Process the text "abababac" through the automaton.
    - The automaton transitions through states based on input characters.
    - The pattern is found when the automaton reaches the accepting state after processing the text.

## 4. KMP Algorithm (Knuth-Morris-Pratt)
- **Description**: Avoids unnecessary comparisons by using information from previous matches. It preprocesses the pattern to create a partial match table (prefix table) to skip sections of the text.
- **Time Complexity**: \(O(n + m)\).
- **Example**:
  - Text (T): "ababcabcabababd"
  - Pattern (P): "ababd"
  - Steps:
    - Preprocess the pattern to create a prefix table: [0, 0, 1, 2, 0].
    - Use the prefix table to skip unnecessary comparisons in the text.
    - The pattern is found starting at index 10.

## 5. Boyer-Moore Algorithm
- **Description**: Efficient for large alphabets and long patterns. It preprocesses the pattern to create two tables: the bad character table and the good suffix table, which help in skipping sections of the text.
- **Time Complexity**: Often performs better than \(O(n)\) in practice.
- **Example**:
  - Text (T): "HERE IS A SIMPLE EXAMPLE"
  - Pattern (P): "EXAMPLE"
  - Steps:
    - Preprocess the pattern to create the bad character and good suffix tables.
    - Use these tables to skip sections of the text.
    - The pattern is found starting at index 17.

## 6. Suffix Trees
- **Description**: A compressed trie containing all the suffixes of the text. It allows for fast substring searches, typically in \(O(m)\) time after \(O(n)\) preprocessing.
- **Time Complexity**: Preprocessing in \(O(n)\), Searching in \(O(m)\).
- **Example**:
  - Text (T): "banana"
  - Steps:
    - Construct a suffix tree for "banana".
    - The tree contains all suffixes: "banana", "anana", "nana", "ana", "na", "a".
    - Search for the pattern "ana" in the suffix tree.
    - The pattern is found at indices 1 and 3.

These algorithms provide various approaches to efficiently find patterns within texts, each with its own strengths and use cases.

# Algorithm classification

  1. Implementation Method
  2. Design Method
  3. Other Classifications
     
### Implementation Method

  Recursion or Iteration
  Procedural or Declarative
  Serial or Parallel or Distributed
  Deterministic or Non-deterministic
  Exact or Approximate

## Design Method

  Greedy - choose local best as global optimal solution
  Divide and Conquer - divide , recurse and conquer
  Dynamic Programming - there is no dependency among the sub problems like Divide and Conquer
  Linear Programming - 
  Reduction ( Transform and conquer) - tranform difficult to known

## Other Classifications

   By Research
   By Complexity
   Randomized Algorithms
   Branch and Bound enumeration and backtracking

### Greedy Algorithms

 - easy to code , understand

Greedy Applications
• Sorting: Selection sort, Topological sort
• Priority Queues: Heap sort
• Huffman coding compression algorithm
• Prim’s and Kruskal’s algorithms
• Shortest path in Weighted Graph [Dijkstra’s]
• Coin change problem
• Fractional Knapsack problem
• Disjoint sets-UNION by size and UNION by height (or rank)
• Job scheduling algorithm
• Greedy techniques can be used as an approximation algorithm for complex problems

### Divide and Conquer Algorithms

 - recursing is Slow
   
Divide and Conquer Applications
• Binary Search
• Merge Sort and Quick Sort
• Median Finding
• Min and Max Finding
• Matrix Multiplication
• Closest Pair problem

### Dynamic Programming Algorithms

• Bottom-up dynamic programming
• Top-down dynamic programming

Dynamic Programming Applications

• Many string algorithms including longest common subsequence, longest increasing subsequence, longest common substring, edit distance.
• Algorithms on graphs can be solved efficiently: Bellman-Ford algorithm for finding the shortest distance in a graph, Floyd’s All-Pairs shortest path algorithm, etc.
• Chain matrix multiplication
• Subset Sum
• 0/1 Knapsack
• Travelling salesman problem, and many more

# Time Complexity Table

This table outlines various time complexities, their names, examples, and the general difficulty of problems associated with each complexity type.

| Time Complexity | Name            | Example Problem                          | Problem Type     |
|-----------------|-----------------|------------------------------------------|------------------|
| \(O(1)\)        | Constant        | Accessing an element in an array         | Easy-Solved      |
| \(O(\log n)\)   | Logarithmic     | Binary search in a sorted array          | Easy-Solved      |
| \(O(n)\)        | Linear          | Finding the maximum element in an array  | Easy-Solved      |
| \(O(n \log n)\) | Linearithmic    | Merge sort, Quick sort                   | Moderate-Solved  |
| \(O(n^2)\)      | Quadratic       | Bubble sort, Insertion sort              | Moderate-Solved  |
| \(O(n^3)\)      | Cubic           | Floyd-Warshall algorithm for shortest paths | Hard-Solved   |
| \(O(2^n)\)      | Exponential     | Solving the Traveling Salesman Problem (TSP) using brute force | Hard-Solved |
| \(O(n!)\)       | Factorial       | Solving the Traveling Salesman Problem (TSP) using permutations | Very Hard-Solved |

## Explanation

- **Constant Time (\(O(1)\))**: Operations that take the same amount of time regardless of the input size. These are typically very efficient and easy to solve.

- **Logarithmic Time (\(O(\log n)\))**: Operations that reduce the problem size by a constant factor at each step, such as binary search. These are efficient and generally easy to solve.

- **Linear Time (\(O(n)\))**: Operations that require processing each element of the input once, such as finding the maximum element in an array. These are straightforward and easy to solve.

- **Linearithmic Time (\(O(n \log n)\))**: Operations that involve sorting or divide-and-conquer strategies, such as merge sort. These are more complex but still manageable.

- **Quadratic Time (\(O(n^2)\))**: Operations that involve nested loops over the input, such as bubble sort. These can become inefficient for large inputs and are moderately difficult to solve.

- **Cubic Time (\(O(n^3)\))**: Operations that involve three nested loops, such as the Floyd-Warshall algorithm. These are generally hard to solve for large inputs.

- **Exponential Time (\(O(2^n)\))**: Operations that involve exploring all subsets or combinations, such as solving TSP using brute force. These are very inefficient for large inputs and are hard to solve.

- **Factorial Time (\(O(n!)\))**: Operations that involve generating all permutations, such as solving TSP using permutations. These are extremely inefficient and very hard to solve for even moderately sized inputs.

Types of Complexity Classes
- P Class - polynomial time
- NP Class - non-deterministic polynomial time
- Co-NP   - complement of NP


### Hacks on Bitwise Programming ( C, C++)

&  - Bitwise AND
1  - Bitwise OR
A  - Bitwise Exclusive OR (if both are same , result is 0)
<< - Bitwise Left Shift
>> - Bitwise Right Shift
~  - Bitwise complement

01001011
00010101
----------
00000001  - &
01011111  - 1
01011110  - A

01001011 -> Left Shift 2 -> 00101100
01001011 -> Right Shift 2 -> ??010010

01001011 -> completement -> 10110100






   

  



