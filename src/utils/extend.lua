local extend = function(target, source)
  for k, value in pairs(source) do
    target[k] = value
  end
end

return extend