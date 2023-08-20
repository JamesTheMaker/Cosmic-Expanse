local pInit = init
function init()
  if pInit then
    pInit()
  end
  
	message.setHandler("ceByosUpdate", ceByosUpdate)
end

function ceByosUpdate()
  if player.worldId() ~= player.ownShipWorldId() then
    return
  end

  sb.logInfo("Message recieved")

  local applyShipUpgrades = {  }

  applyShipUpgrades.maxFuel = (world.getProperty("cebyos.maxFuel") or 0) + 500
  applyShipUpgrades.crewSize = (world.getProperty("cebyos.crewSize") or 0)
  applyShipUpgrades.shipSpeed = (world.getProperty("cebyos.shipSpeed") or 0) + 15
  applyShipUpgrades.capabilities = { "teleport" }

  sb.logInfo("Stats calculated")
  
  if world.getProperty("cebyos.capabilities.planetTravel") then
    table.insert(applyShipUpgrades, "planetTravel")
  end
  if world.getProperty("cebyos.capabilities.systemTravel") then
    table.insert(applyShipUpgrades, "systemTravel")
  end

  player.upgradeShip(applyShipUpgrades)
  sb.logInfo("Ship upgraded")
end
