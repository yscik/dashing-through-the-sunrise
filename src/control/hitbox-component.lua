Hitbox = Component.create("Hitbox")
local HC = require 'lib/hc'

function Hitbox:initialize(o)
  _.extend(self, o)

  self.hc = HC.polygon(unpack(_.take(o.shape, #o.shape - 2)))
  self.center = {}
  self.center.x, self.center.y = self.hc:center()
end