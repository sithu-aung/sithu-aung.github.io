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

### 3.1 Shell Sort

- **Description**: An optimization of insertion sort that allows the exchange of items that are far apart.
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
