local extend = require('src/utils/extend')

local function setup(self, settings)
  extend(self, settings)
  
end

function DataComponent(name)
  local comp = Component.create(name)
  comp.initialize = setup
  return comp
end