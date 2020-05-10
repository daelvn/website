-- display a toast notification
-- By daelvn
js     = require "js"
window = js.global
_      = window.ljs window.document

window.toast = (text) =>
  tt           = _"#toast"
  tt.innerHTML = text or "defaulting"
  tt.className = "show"
  window\setTimeout (-> tt.className = ""), 3000