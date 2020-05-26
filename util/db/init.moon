-- just a quick module that opens the database
config  = (require "lapis.config").get!
grasp   =  require "grasp"
db      =  grasp.Database config.dxvn.db.location
return {
  :db
  run: grasp.update db
}