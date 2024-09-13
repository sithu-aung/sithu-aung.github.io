# Best Practices

# SOLID Principles

  - Introduced by Robert Martin ( Uncle Bob in 2000 )

 ### Single Responsibility

  - “There should never be more than one reason for a class to change”. Each class should have only one central responsibility.

  - Class ( including method in a class ) should only do one thing.

    Example :  Instead of throwing everything inside an Employee class,
     Separate the responsibilities into EmployeeTimeLog, EmployeeTimeOff, EmployeeSalary, EmployeeDetails, etc.

### Open/Closed  

   - “Software entities…” should be open for extension, but closed for modification.
   - a Module should be Open for extension, but Closed for modification'
   - Extend Module with new features not by changing its source code, but by adding new code instead

     Example :  class Pay , Instead of add different payment options
     Create a PayableInterface - that implement each payment option
     And a new class for a new payment

### Liskov Substitution

  -  Function that uses pointers, reference of base classs, must be able to use object of derived classes without knowing it.
  -  Barbara Liskov - late 80s
  -  Should be able to substitute a parent class with any of its child classes, without breaking the system.
  -  Implementations of the same interface should never give a different result.

     Example : Database methods now return objects instead of arrays. that breaks Liskov Substituion

     Mindful Programming - always keep in mind what the system expects when you're implementing its functionality.


### Interface Segregation 

   - Clients should not be forced to depend upon interfaces that they do not use.
   - Never force the client to depend on methods it doesn't use

     Example : Split the Employee class into smaller classes with specific interfaces.

### Dependency Inversion

   - Depend upon abstractions, [not] concretions.
   - High Level Modules should not depend on low-level Modules - both should depend on Abstractions

     Example : Like a socket in a house , plug in all devices and no need to care how electricity is provided.

     Solved by using Dependency Injection - no need to depend on concrete classes.

# Useful Coding Laws
### DRY ( Don't Repeat Yourself )
### use enum for fixed sets of Constants
### Avoid not complete abbreviations ( cal() -> calculate() )
### Use Key Widgets for Efficient Updates
### Avoid Nested Try Blocks
