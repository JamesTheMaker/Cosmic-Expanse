local pInit = init
function init()
  pInit()
  sb.logInfo("%s", player.shipUpgrades())
end

function showJumpDialog(system, target)
  local fuelAmount = world.getProperty("ship.fuel")
  if fuelAmount then
    widget.setVisible("jumpDialog", true)

    local cost = fuelCost()
    if player.isAdmin() or (fuelAmount >= cost and contains(player.shipUpgrades().capabilities, "systemTravel")) then
      widget.setText("jumpDialog.text", string.format(config.getParameter("jumpDialog.valid"), cost))
      widget.setButtonEnabled("jumpDialog.jump", true)
      widget.setData("jumpDialog.jump", {system = system, target = target})

      self.travel.confirmed = false
    elseif not contains(player.shipUpgrades().capabilities, "systemTravel") then
      widget.setText("jumpDialog.text", string.format(config.getParameter("jumpDialog.noFTL")))
      widget.setButtonEnabled("jumpDialog.jump", false)
      widget.setData("jumpDialog.jump", nil)
    else
      widget.setText("jumpDialog.text", string.format(config.getParameter("jumpDialog.invalid"), cost))
      widget.setButtonEnabled("jumpDialog.jump", false)
      widget.setData("jumpDialog.jump", nil)
    end
  end
end

function fuelCost()
  local cost = ( config.getParameter("jumpFuelCost") )

  if self.travel.system then
    self.fuelCostDestination = self.travel.system
  end

  local origin = celestial.currentSystem().location
  local destination = self.fuelCostDestination

  local distance = math.sqrt( ((origin[1] - destination[1]) ^ 2) + ((origin[2] - destination[2]) ^ 2) )

  cost = cost + (distance * 2)
  return util.round(cost - cost * (world.getProperty("ship.fuelEfficiency") or 0.0))
end