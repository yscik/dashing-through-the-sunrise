ResourceSystem = class("ResourceSystem", System)

ResourceSystem.process = {}

function ResourceSystem:update(dt)
    
    for k, entity in pairs(self.targets) do
        local resources = entity:get("Resources").components
        local resourceMap = _.groupBy(resources, function(k, res) return res.class.name end)
      for r, resource in pairs(resources) do
        self.process[resource.class.name](resource, resourceMap)
        end
    end
    
end

function ResourceSystem.process.Consume(consume, resourceMap)
    if consume.active then
      local source = find_resource_source(resourceMap, consume.type)
      if not source or source.content <= 0 then
        consume.blocked = true
      else
        source.content = source.content - consume.rate
      end
    end
end

function ResourceSystem.process.Storage(storage, resourceMap)
    
end

function ResourceSystem.process.Generate(storage, resourceMap)
   
end

function find_resource_source(map, type)
  return map.Storage and _.findWhere(map.Storage, {type = type})

end
  
  

function ResourceSystem:requires()
    return {"Resources"}
end
