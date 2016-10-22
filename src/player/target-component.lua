Target = Component.create("Target")

function Target:initialize()
  self.pos = Position()
end

function Target:set(pos, options)
  options = options or {}
  self.callback = options.callback or nil
  self.active = true
  self.pos:set(pos)
end

function Target:reached()
  self.active = false
  if self.callback then self.callback() end
end