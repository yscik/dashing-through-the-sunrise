
Generate = DataComponent("Generate")
Consume = DataComponent("Consume")
Storage = DataComponent("Storage")

Resources = Component.create("Resources")

function Resources:initialize(components)
  self.components = components
  self.map = _.groupBy(components, function(k, res) return res.class.name end)
end

function Consume:use(amount)
  if self.multiple then
    if _.all(self.sources, function(k, source) return source.storage:has(amount * source.rate)  end) then
      for k, source in pairs(self.sources) do
        source.storage:use(amount * source.rate)
      end
      return true
    else return false
    end
  else
    return _.any(self.sources, function(source)
      return source:use(amount) end)
  end
end

function Storage:has(amount)
  return self.content >= amount
end

function Storage:add(amount)
  self.content = self.content + amount
end

function Storage:use(amount)
  if self:has(amount) then
    self.content = self.content - amount
    return true
  else return false
  end
  
end
