
PanelCommand = DataComponent("PanelCommand")
ScanCommand = DataComponent("ScanCommand")

function PanelCommand:execute()
  local panel = ui:addPanel(Panel(self.entity:get("Position").at, self.content))
  return panel
end
