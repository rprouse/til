# Working with Files in Python

```python
# Echo the contents of a text file
f = open('foo.txt', 'rt', encoding='utf-8')
for line in f:   ## iterates over the lines of the file
    print(line, end='')    ## end='' so print does not add an end-of-line char
                           ## since 'line' already includes the end-of-line.
f.close()
```

To read and write unicode encoded files use a `'t'` mode and explicitly specify an encoding:

```python
with open('foo.txt', 'rt', encoding='utf-8') as f:
  for line in f:
    # here line is a *unicode* string

with open('write_test', encoding='utf-8', mode='wt') as f:
    f.write('\u20ACunicode\u20AC\n') #  €unicode€
    # AKA print('\u20ACunicode\u20AC', file=f)  ## which auto-adds end='\n'
```