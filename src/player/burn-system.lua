BurnTarget = Component.create("BurnTarget")

BurnSystem = class("BurnSystem", System)

function BurnSystem:update(dt)    
    for k, entity in pairs(self.targets) do
      
        local cursor, pos, v = Cursor, entity:get("Position"), entity:get("Velocity")
        if cursor.move then
            local dx,dy = vector.mul(12 * dt, vector.normalize(cursor.x - pos.x, cursor.y - pos.y))
            v.x, v.y = vector.add(v.x, v.y, dx,dy)
        end
    end
    
end

function BurnSystem:requires()
    return {"Velocity", "Position", "BurnTarget"}
end
