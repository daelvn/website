-- scroll back to top functionality
-- by daelvn
js       = require "js"
window   = js.global
document = window.document
_        = window.ljs window.document

-- get button
btn = _"#scrollback"
return if btn == js.null

-- add scroll trigger
window.onscroll = ->
  if (document.body.scrollTop > 30) or (document.documentElement.scrollTop > 30)
    btn.style.display = "block"
  else
    btn.style.display = "none"

-- go to top
btn.onclick = ->
  document.body.scrollTop = 0            -- for safari
  document.documentElement.scrollTop = 0 -- for the rest