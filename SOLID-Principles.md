# SOLID Principles

  - Introduced by Robert Martin ( Uncle Bob in 2000 )

 ### Single Responsibility

  - Class ( including method in a class ) should only do one thing.

    Example :  Instead of throwing everything inside an Employee class,
     Separate the responsibilities into EmployeeTimeLog, EmployeeTimeOff, EmployeeSalary, EmployeeDetails, etc.

### Open/Closed  

   - a Module should be Open for extension, but Closed for modification'
   - Extend Module with new features not by changing its source code, but by adding new code instead

     Example :  class Pay , Instead of add different payment options
     Create a PayableInterface - that implement each payment option
     And a new class for a new payment

### Liskov Substitution

  -  Barbara Liskov - late 80s
  -  Should be able to substitute a parent class with any of its child classes, without breaking the system.
  -  Implementations of the same interface should never give a different result.

     Example : Database methods now return objects instead of arrays. that breaks Liskov Substituion

     Mindful Programming - always keep in mind what the system expects when you're implementing its functionality.


### Interface Segregation 

   - Never force the client to depend on methods it doesn't use

     Example : Split the Employee class into smaller classes with specific interfaces.

### Dependency Inversion

   - High Level Modules should not depend on low-level Modules - both should depend on Abstractions

     Example : Like a socket in a house , plug in all devices and no need to care how electricity is provided.

     Solved by using Dependency Injection - no need to depend on concrete classes.
