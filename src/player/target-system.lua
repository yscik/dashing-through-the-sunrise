Target = DataComponent("Target")

TargetSystem = class("TargetSystem", System)

function TargetSystem:update(dt)    
    for k, entity in pairs(self.targets) do
      
        local target = entity:get("Target")
        if target.source.move then
            target.x, target.y = target.source.pos.x, target.source.pos.y
            target.set = true
            target.source.move = false
        end
    end
    
end

function TargetSystem:requires()
    return {"Target"}
end
