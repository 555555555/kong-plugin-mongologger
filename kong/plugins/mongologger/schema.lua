local typedefs = require "kong.db.schema.typedefs"


return {
  name = "mongologger",
  fields = {
    { protocols = typedefs.protocols },
    { config = {
        type = "record",
        fields = {
        },
    }, },
  }
}