Target = Component.create("Target")

function Target:initialize(settings)
  extend(self, settings)
  
end

TargetSystem = class("TargetSystem", System)

function TargetSystem:update(dt)    
    for k, entity in pairs(self.targets) do
      
        local target = entity:get("Target")
        if target.source and target.button and target.source.button[target.button] then
            target.x, target.y = target.source.x, target.source.y
            target.set = true
        end
    end
    
end

function TargetSystem:requires()
    return {"Target"}
end
