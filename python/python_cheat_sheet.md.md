# Python Cheat Sheet
## Program Structure

```python
def main():  
    print('Hello World!')  
  
if __name__ == '__main__':  
    main()
```
## Arithmetic Operators
| Operator | Name of Operation | Example  | Description                       |
| -------- | ----------------- | -------- | --------------------------------- |
| `+`      | Addition          | `x + y`  | x plus y                          |
| `-`      | Subtraction       | `x - y`  | x minus y                         |
| `*`      | Multiplication    | `x * y`  | x multiplied by y                 |
| `**`     | Exponentiation    | `x ** y` | x raised to the power of y        |
| `/`      | Division          | `x / y`  | x divided by y                    |
| `//`     | Floor Division    | `x // y` | x divided by y, returning integer |
| `%`      | Modulo            | `x % y`  | The remainder of x divided by y   |
## `for` loops with `range()`

```python
for i in range(3):  
    print(i)
```

## Error Handling

```python
nums = ['x', 'y', 'z']  
  
try:  
   print(sum(nums))  
  
except:  
   print('Cannot print the sum! Your variables are not numbers.')  
  
finally:  
   print('Hope you got the result you want!')
```

## Lambda Functions

Syntax of a lambda function:

```python
lambda [arguments]: [expression]
```

```python
# Regular function  
def square(x):  
    return x ** 2  
  
# Lambda function  
square_lambda = lambda x: x ** 2
```

### Lambda with `map()`
The `map()` function applies the given lambda function to each item in a list:

```python
numbers = [1, 2, 3, 4, 5] squared = list(map(lambda x: x ** 2, numbers)) print(squared)  # Output: [1, 4, 9, 16, 25] 
```
### Lambda with `filter()`
The `filter()` function creates a new list of elements for which the given lambda function returns True:

```python
numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10] even_numbers = list(filter(lambda x: x % 2 == 0, numbers)) print(even_numbers)  # Output: [2, 4, 6, 8, 10] 
```
### Lambda with `sorted()`
The `sorted()` function can use a lambda function as a key for custom sorting:

```python
students = [('Alice', 'A', 15), ('Bob', 'B', 12), ('Charlie', 'A', 20)] sorted_students = sorted(students, key=lambda x: x[2]) print(sorted_students) # Output: [('Bob', 'B', 12), ('Alice', 'A', 15), ('Charlie', 'A', 20)] 
```

## Classes

```python
class ClassSchedule:  
   def __init__(self, course):  
       self.course = course  
    
   def __del__(self):  
       print('You successfully deleted your schedule')

sched = ClassSchedule('Chemistry')  
del sched
```

### Public, Protected and Private Modifiers

By default, all members are public. Members with a single `_` prefix are protected and a double `__` are private.

```python
class ClassSchedule:  
   def __init__(self, course, instructor):  
       self._course = course # protected  
       self.__instructor = instructor # private
    
   def display_course(self):  
       print(f'Course: {self._course}, Instructor: {self._instructor}')
```

### Inheritance

```python
class Person:  
   def __init__(self, name, age):  
       self.name = name  
       self.age = age  
    
   def print_info(self):  
       print(f'{self.name} is {self.age} years old')

class Teacher(Person):  
  def __init__(self, name, age, subject):  
      self.subject = subject  
  
      Person.__init__(self, name, age)
```

## Strings
### Formatted String Literals

```python
print(f'Very nice to meet you, {name.upper()}!')
```
### String Functions

```python
intro = "My name is Jeff!"  
print(len(intro))    # 16
print(intro.lower()) # 'my name is jeff!'  
print(intro.upper()) # 'MY NAME IS JEFF!'  
print(intro.title()) # 'My Name Is Jeff!'  

print(intro.split()) # prints ['My', 'name', 'is', 'Jeff!']  
print(intro.split('name')) # prints ['My ', ' is Jeff!']  
print(intro.split('!')) # prints ['My name is Jeff', '']
```
## Lists

Lists are ordered collections that can contain different data types. They are created with `[]` and can be sliced like strings.

```python
lst = ['abc', 123, 'def', 10.5, 62, ['g', 'h', 'i']]

print(lst[0]) # prints abc
print(lst[4:6]) # prints [62, ['g', 'h', 'i']]
```

### List Functions

```python
lst = ['abc', 123, 'def', 10.5, 62, ['g', 'h', 'i']]  

print(len(lst)) # 6

lst.append(99) # appends 99 at the end of the list
lst.remove(62) # removes 62 from the list
lst.pop() # removes ['g', 'h', 'i']  
lst.pop(0) # removes 'abc'
```
## Tuples

Tuples are an immutable data structure defined with `()`. They are more memory efficient and faster than lists. They can be indexed and sliced like lists and strings.

```python
my_tuple = ('abc', 123, 'def', 456)
```

Tuples can hold one item, but it must be followed by a comma,

```python
my_tuple = ('abc',)
```

### Tuple Functions
#### len()

```python
my_tuple = ('abc', 123, 'def', 456, 789, 'ghi')  
print(len(my_tuple)) # prints 6
```
#### max() and min()

```python
my_tuple = (65, 2, 88, 101, 25)  
max(my_tuple) # returns 101    
min(my_tuple) # returns 2
  
my_tuple = ('orange', 'blue', 'red', 'green')  
max(my_tuple) # returns "red"    
min(my_tuple) # returns "blue"
  
my_tuple = ('abc', 234, 567, 'def')  
max(my_tuple) # throws an error!  
min(my_tuple) # returns "blue"
```
#### index()

```python
my_tuple = ('abc', 234, 567, 'def')  
my_tuple.index('abc') # returns 0  
my_tuple.index(567) # returns 2
```

#### count()

```python
my_tuple = ('abc', 'abc', 2, 3, 4)  
my_tuple.count('abc') # returns 2  
my_tuple.count(3) # returns 1
```
## Dictionaries
Dictionaries contain key-value pairs which are separated by a `:`. They are defined with `{}`. The values can be a mix of different data types but the keys must be immutable data types like strings, numbers or tuples.

```python
groceries = {'fruits': ['mangoes', 'bananas', 'kiwis'],  
             'protein': ['beef', 'pork', 'salmon'],  
             'carbs': ['rice', 'pasta', 'bread'],  
             'veggies': ['lettuce', 'cabbage', 'onions']}

groceries['carbs']  # ['rice', 'pasta', 'bread']
```

### Dictionary Functions

```python
party_planning = {'Yes': 10,  
                  'No': 15,  
                  'Maybe': 30,  
                  'Location': 'Our Backyard',  
                  'Date': '2022/05/01'}  
  
len(party_planning) # returns 5
```
#### update()

Takes a dictionary which is used to update an existing dictionary.

```python
shopping_list1 = {'jewelry': 'earrings', 'clothes': 'jeans', 'budget': 200}  
shopping_list2 = {'shoes': 'sandals', 'budget': 350}  
  
shopping_list1.update(shopping_list2)  
  
print(shopping_list1) # prints {'jewelry': 'earrings', 'clothes': 'jeans', 'budget': 350, 'shoes': 'sandals'}
```
#### keys() and values()

```python
shopping_list = {'jewelry': 'earrings', 'clothes': 'jeans', 'budget': 200}  
  
shopping_list.keys() # returns dict_keys(['jewelry', 'clothes', 'budget'])  
shopping_list.values() # returns dict_values(['earrings', 'jeans', 200])
```
## Sets

A set is an immutable, unordered collection of **unique** elements that can consist of integers, floats, strings and tuples. A set is created with `{}` with items separated with commas. The function `set()` to convert a list into a set. Duplicates items are not included in a set.

Sets do not have indexes or keys. You can use `in` to check if an element exists in the set.

```python
students = {'Jane', 'Carlos', 'Amy', 'Bridgette', 'Chau', 'Dmitry'}  
  
print('Chau' in students) # returns True
```

### Set Functions
#### add()

Items in a set are immutable, but you can add additional items with `add()`.

```python
students = {'Jane', 'Carlos', 'Amy', 'Bridgette', 'Chau', 'Dmitry'}  
  
students.add('George')  
print('George' in students) # returns True
```
#### update() and union()

`update()` adds the given items to the set whereas `union()` returns a new set which is the union of the two sets.

```python
set1 = { 1, 3, 5 }
set2 = { 2, 4, 6 }

set3 = set1.union(set2) # { 1, 2, 3, 4, 5, 6 }
set1.update(set2)       # { 1, 2, 3, 4, 5, 6 }
```
#### remove()  

```python
students = {'Jane', 'Carlos', 'Amy', 'Bridgette', 'Chau', 'Dmitry'}  
students.remove('Bridgette')
```



