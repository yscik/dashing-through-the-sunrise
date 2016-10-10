
Generate = DataComponent("Generate")
Consume = DataComponent("Consume")
Storage = DataComponent("Storage")

Resources = Component.create("Resources", {'components'})


function Consume:use(amount)
  return _.any(self.sources, function(source) return source:use(amount) end)
end

function Storage:use(amount)
  if self.content >= amount then 
    self.content = self.content - amount
    return true
  else return false
  end
  
end
