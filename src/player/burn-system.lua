Burn = Component.create("Burn")

function Burn:initialize(settings)
  extend(self, settings)
  
end


BurnSystem = class("BurnSystem", System)

function BurnSystem:update(dt)    
    for k, entity in pairs(self.targets) do
      
        local burn, pos, v = entity:get("Burn"), entity:get("Position").pos, entity:get("Velocity")
        if burn.target.set then
            local tx,ty = burn.target.x - pos.x, burn.target.y - pos.y
            local dx,dy = vector.normalize(tx,ty)
            local l = vector.len(tx,ty)
            local current_speed = vector.len(v.x, v.y)
            local max_speed = 200
            local speed = math.min(current_speed+1, l, max_speed)
            v.x, v.y = vector.mul(speed, dx,dy)
        end
    end
    
end

function BurnSystem:requires()
    return {"Burn", "Position", "Velocity"}
end
