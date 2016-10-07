ResourceSystem = class("ResourceSystem", System)

function ResourceSystem:update(dt)
    
    for k, entity in pairs(self.targets) do
        local consume = entity:get("Consume")
        
    end
    
end

function ResourceSystem:requires()
    return {"Consume"}
end
