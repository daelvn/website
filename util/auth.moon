-- Authentication utils
-- By daelvn
import hash_encoded, verify from  require "argon2"
import bytes                from  require "openssl.rand"
config                         = (require "lapis.config").get!

hashPassword   = (password)       -> (hash_encoded password, bytes 16)\sub 1, -2
verifyPassword = (password, hash) -> verify hash.."\0", password

{
  :hashPassword, :verifyPassword
}