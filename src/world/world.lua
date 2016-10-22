
World = class("World", Entity)

function World:initialize()
  self.entities = {}
  
end

function World:add(entity)

--  if not self.entities[entity.class.name] then self.entities[entity.class.name] = {} end
  systems.engine:addEntity(entity)
  self.entities[entity.id] = entity

end


function World:remove(entity)

  systems.engine:removeEntity(entity)
  self.entities[entity.id] = nil

end

function World:update(dt)
  _.invoke(self.entities, 'update', dt)
end

function World:get(entity)

end