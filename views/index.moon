import Widget from require "lapis.html"
import config from require "util.config"
sections = config.dxvn.sections

class Index extends Widget
  content: =>
    script -> raw "toast('#{@toast}');" if @toast
    h1 @iiin "index"
    blockquote -> p @iiin "intro"
    h2 @iiin "links"
    for section in *sections
      sct = if section == "roleplay" then "rp" else section
      h3 -> a href: "/#{sct}", @iiin "sen_#{section}"
      blockquote -> p @iiin "sed_#{section}"