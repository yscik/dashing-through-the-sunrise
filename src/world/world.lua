
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

  local body = entity:get('Body')
  if body then body.body:destroy() end

  systems.engine:removeEntity(entity)
  self.entities[entity.id] = nil

end

function World:tick()
  _.invoke(self.entities, 'tick')
end

function World:update(dt)
  _.invoke(self.entities, 'update', dt)
end

function World:get(entity)

end