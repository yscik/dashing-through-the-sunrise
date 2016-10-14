
PanelCommand = DataComponent("PanelCommand")
ScanCommand = DataComponent("ScanCommand")

function PanelCommand:execute()
  local panel = ui:addPanel(self.entity:get("Position").pos, self.content)
  return panel
end
