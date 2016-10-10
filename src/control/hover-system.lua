HoverSystem = class("HoverSystem", System)
local HC = require 'lib/hc'

function HoverSystem:initialize()
  System.initialize(self)
  self.cursor = Cursor
  
end

function HoverSystem:update(dt)
  
  for k, entity in pairs(self.targets) do
    local clickable, pos = entity:get("Clickable"), entity:get("Position").pos
      clickable.hc:moveTo(pos.x, pos.y)
      clickable.hover = clickable.hc:contains(self.cursor.x, self.cursor.y)
  end
  
end

function HoverSystem:requires()
    return {"Clickable", "Position"}
end

function HoverSystem:onAddEntity(entity)
    local comp = entity:get("Clickable")
    
    comp.hc = HC.polygon(unpack(comp.shape))
    comp.hc.parent = comp
end