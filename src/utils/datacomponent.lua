local function setup(self, settings)
  _.extend(self, settings)
end

function DataComponent(name)
  local comp = Component.create(name)
  comp.setup = setup
  comp.initialize = setup
  return comp
end