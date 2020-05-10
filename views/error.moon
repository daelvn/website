import Widget from require "lapis.html"

class Error extends Widget
  content: =>
    h1 @iiin "error_h1"
    p  @iiin @errorid