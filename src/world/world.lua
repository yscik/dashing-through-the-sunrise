
World = class("World", Entity)

function World:initialize(engine)
  self.entities = {}
  
end

function World:add(entity)

--  if not self.entities[entity.class.name] then self.entities[entity.class.name] = {} end
  engine:addEntity(entity)
  self.entities[entity.id] = entity

end

function World:get(entity)

end