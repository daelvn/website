->
  inspect = require "inspect"
  html    = require "htmlparser"
  displayed = false
  for file in wildcard "poetryrx/**.html"
    -- read DOM
    local root
    with fs.safeOpen file, "r"
      if .error
        print "could not read file #{file}"
        continue
      content = \read "*a"
      root    = html.parse content
      \close!
    -- get contents of div#write
    continue unless root.nodes[1]
    continue if     root.nodes[1].name != "html"
    --     root.html    .body    .div#write
    print file
    body = root.nodes[1].nodes[2].nodes[1]\getcontent!
    -- write back into file
    with fs.safeOpen file, "w"
      if .error
        print "could not write file #{file}"
        continue
      \write body
      \close!