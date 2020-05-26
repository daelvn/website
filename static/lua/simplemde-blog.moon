js       = require "js"
new      = js.new
window   = js.global
document = window.document
_        = window.ljs window.document

simplemde = {}
for lang in *({"en", "es"})
  simplemde[lang] = window["simplemde_#{lang}"]

-- get file contents
thisURL       = new window.URL, document.location
components    = [c for c in thisURL.pathname\gmatch "[^/]+"]
uid           = components[4]
components[1] = "blog"
components[2] = "raw"
components[3] = "lang"
components[4] = uid
content       = {}
for lang in *({"en", "es"})
  components[3] = lang
  content[lang] = window\httpGet (new window.URL, (table.concat components, "/"), document.location.origin).href

-- add to markdown editors
for lang, obj in pairs simplemde
  obj\value content[lang]