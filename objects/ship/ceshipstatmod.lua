local pInit = init
function init()
  pInit()
  if world.type() ~= "unknown" then
	  return
  end

  if not storage.applied then
  	if config.getParameter("shipUpgrades.capabilities") then
  	  for _, capability in pairs(config.getParameter("shipUpgrades.capabilities")) do
  	  	if world.getProperty("cebyos.capabilities." .. capability) == true then
  	  	  object.smash(false)
  	  	  return
  	  	end
  	  end
    end

    apply()
  	storage.applied = true
  end
end

function die()
  if storage.applied then
  	unapply()
  	storage.applied = false
  end
end

function apply()
  for stat, value in pairs(config.getParameter("shipUpgrades.stats")) do
  	local pValue = world.getProperty("cebyos." .. stat) or 0
  	world.setProperty("cebyos." .. stat, pValue + value)
  end

  for _, capability in pairs(config.getParameter("shipUpgrades.capabilities")) do
  	world.setProperty("cebyos.capabilities." .. capability, true)
  end
end

function unapply()
  for stat, value in pairs(config.getParameter("shipUpgrades.stats")) do
  	local pValue = world.getProperty("cebyos." .. stat) or 0
  	world.setProperty("cebyos." .. stat, pValue - value)
  end

  for _, capability in pairs(config.getParameter("shipUpgrades.capabilities")) do
  	world.setProperty("cebyos.capabilities." .. capability, false)
  end
end

function update()
  if world.type() ~= "unknown" then return end -- Check if spaceship or not

  for _, player in pairs(world.players()) do
    world.sendEntityMessage(player, "ceByosUpdate")
  end
end