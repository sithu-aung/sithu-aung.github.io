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

    
  

