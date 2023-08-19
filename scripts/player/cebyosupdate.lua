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

  local defaultUpgrades = {}
  defaultUpgrades.stats = {}
  defaultUpgrades.capabilities = {}

  local shipUpgrades = world.getProperty("cebyos") or defaultUpgrades
  local applyShipUpgrades = {  }

  applyShipUpgrades.maxFuel = shipUpgrades.stats.maxFuel or 0
  applyShipUpgrades.crewSize = shipUpgrades.stats.crewSize or 0
  applyShipUpgrades.shipSpeed = shipUpgrades.stats.shipSpeed or 0
  applyShipUpgrades.capabilities = { "teleport" }
  
  for capability, enabled in pairs(shipUpgrades.capabilities) do
    if enabled then
     table.insert(applyShipUpgrades.capabilities, capability)
    end
  end

  player.upgradeShip(applyShipUpgrades)
end
