import Widget from require "lapis.html"
inspect          = require "inspect"

-- removes html suffix
basename = (f) -> f\match "(.+)%.html"

-- renders a number as two digits
twodigit = (n) -> return string.format "%02d", tonumber n

-- npairs
-- ipairs, but does not stop if nil is found
npairs = (t) ->
  keys = [k for k, v in pairs t when "number" == type k]
  table.sort keys
  i    = 0
  n    = #keys
  ->
    i += 1
    return keys[i], t[keys[i]] if i <= n

-- form list outside widget
-- add entries
local sorted
do
  files  = fs.list1 "page/blog/en/"
  byDate = {}
  for file in *files
    continue if     file == "raw"
    continue unless file\match "html$"
    continue if     file\match "EXCL"
    dd, mm, yyyy, name = (basename file)\match "(%d%d)%.(%d%d)%.(%d%d%d%d)%-([a-z-]+)"
    dd                   = tonumber dd
    mm                   = tonumber mm
    yyyy                 = tonumber yyyy
    byDate[yyyy]       or= {}
    byDate[yyyy][mm]   or= {}
    byDate[yyyy][mm][dd] = {:dd, :mm, :yyyy, :name}
  --ngx.log ngx.NOTICE, inspect byDate
  sorted = {}
  for yyyy, yt in npairs byDate
    for mm, mt in npairs yt
      for dd, dt in npairs mt
        table.insert sorted, dt

class Blog extends Widget
  content: =>
    -- title
    h1 @iiin "b_index"
    -- description
    blockquote -> p -> raw @iiin "b_description"
    -- create table
    element "table", ->
      thead ->
        tr ->
          th class: "table-col1", @iiin "b_date"
          th class: "table-col2", @iiin "b_entry"
      tbody ->
        -- render
        for i=#sorted,1,-1
          entry = sorted[i]
          tr ->
            td class: "table-col1", -> span "#{twodigit entry.dd}/#{twodigit entry.mm}/#{entry.yyyy}"
            td class: "table-col2", -> a href: "/blog/#{entry.yyyy}/#{twodigit entry.mm}/#{entry.name}", @iiin "be_#{twodigit entry.mm}_#{entry.name}"