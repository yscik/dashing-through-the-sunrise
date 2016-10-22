MovementSystem = class("MovementSystem", System)

local dimensions = {"x", "y", "r"}

function MovementSystem:update(dt)
    
    for k, entity in pairs(self.targets) do
        local pos, v = entity:get("Position"), entity:get("Velocity")
        for k, dim in ipairs(dimensions) do
          pos.at[dim] = pos.at[dim] + v[dim] * dt
        end

    end
    
end

function MovementSystem:requires()
    return {"Velocity", "Position"}
end
