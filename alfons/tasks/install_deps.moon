(deps) -> (bin="luarocks") =>
  for dep in *deps
    print "==> installing dependency: #{dep}"
    sh "#{bin} install #{dep}"