-- lastpage functionality
-- By daelvn
js       = require "js"
new      = js.new
window   = js.global
document = window.document
_        = window.ljs window.document

-- quick create icon
Icon = (ind) ->
  icon = document\createElement "i"
  icon.classList\add "fas"
  icon.classList\add tostring ind
  return icon

-- get button container
container = _"#lastpage-container"
return if container == js.null

-- get pathname
thisURL    = new window.URL, document.location
components = [c for c in thisURL.pathname\gmatch "[^/]+"]

-- if there are no components, there is nowhere to go back to
if #components > 0
  components[#components] = nil
  -- reassemble URL
  prevURL = new window.URL, (table.concat components, "/"), document.location.origin
  -- create back button
  --button id: "lastpage", title: "Go back", -> i class: "fas fa-arrow-left"
  btn       = document\createElement "button"
  btn.id    = "lastpage"
  btn.title = "Go back"
  btn\appendChild Icon "fa-arrow-left"
  btn.onclick = ->
    window.location = prevURL
  -- add to container
  container\appendChild btn
  