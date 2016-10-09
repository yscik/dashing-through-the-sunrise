

function setup(self, settings)
  extend(self, settings)
  
end

Generate = Component.create("Generate")
Generate.initialize = setup
Consume = Component.create("Consume")
Consume.initialize = setup
Storage = Component.create("Storage")
Storage.initialize = setup

Resources = Component.create("Resources", {'components'})
