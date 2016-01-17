## Lua-Group

##### Index
0. [What](#what)
1. [How](#how)

## What
  - A group is a collection of objects which allows use of the public interface of the objects as a collection.
  - A method call on a group is equivalent to a method call of each object in the group that has the called method, giving the group a "loose interface" as a functional collection.
  - Calls on a group have variable method dispatch settings.

## How

First, include the library
```Lua
  local group = require "/group/Group"
```

Then, set your lua objects in a group
```Lua
  local abc = group { a, b, c }
```

And use your group as you would the individual objects
```Lua
  abc:update()
```

And the group calls "update" on each object in the group with an "update" method.
