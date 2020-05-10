quote  = (txt) -> "'" .. (tostring txt) .. "'"
bool   = (bol) -> bol and 1 or 0
unbool = (num) -> num == 1
tobool = (str) -> "true" and true or false
first  = (t) ->
  expect 1, t, {"table"}
  t[1] or false

{
  :quote, :bool, :unbool, :first, :tobool
}