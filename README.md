# Awkward

**Awkward** is a (trivial) lua plugin for Neovim that allows your to write
`AWK` expressions to perform calculations on data inside a vim buffer. The
`AWK` expression, when evaluated, is concealed and the result is displayed with
Virtual Text.

For example, given a buffer:
```
| Mock | Data |
| ---- | ---- |
| 10   | 2    |
| 12   | 4    |
| 14   | 6    |
| 16   | 8    |

-- Sum: first column
awk '{ a += $2 } END { print a }'

-- Sum: second column
awk '{ b += $4 } END { print b }'
```

Running `:Awkward<cr>` will result in
```lua
...

-- Sum: first column
→ 52

-- Sum: second column
→ 20
```

The `AWK` expression is only `Conceal`ed (not replaced) so when you hover your
cursor over the result, you can continue to edit the `AWK` expression.

Lua-style comments (`--`) are available to use to document the result of your
`AWK` expressions.

### Keybindings
Awkward comes with no keybindings. Map `:Awkward<cr>` to whatever you want.

### Highlights
* `AwkwardComment` (defaults to `Comment`) are the Lua-style `--` comments
* `AwkwardExpression` (defaults to `Text`) are the `awk '{ ... }'` expressions
* `AwkwardResults` (defaults to `Text`) are evaluated results

### Setup
In `init.lua`
```lua
require('awkward').setup{}
```

To evaluate the buffer, use `:Awkward<cr>`.
