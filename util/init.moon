quote     = (txt) -> "'" .. (tostring txt) .. "'"
bool      = (bol) -> bol and 1 or 0
unbool    = (num) -> num == 1
tobool    = (str) -> "true" and true or false
writefile = (file, txt) ->
  with io.open "#{file}", "w"
    \write txt
    \close!
readfile = (file) ->
  local contents
  with io.open "#{file}", "r"
    contents = \read "*a"
    \close!
  return contents
first     = (t) ->
  expect 1, t, {"table"}
  t[1] or false
{
  :quote, :bool, :unbool, :first, :tobool, :writefile, :readfile
}