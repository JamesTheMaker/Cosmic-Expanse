require "/scripts/util.lua"
cepower = {}

local pInit = init
function init()
  if pInit then
    pInit()
  end

  storage.maxPower = config.getParameter("maxPower")
  storage.power = config.getParameter("startPower") or 0

  message.setHandler("cepoweradd", cepower.handler)
end

function cepower.handler(message, localEnt, num)
  change = cepower.addPower(num)
  return change
end

function cepower.setPower(num)
  storage.power = util.clamp(num, 0, storage.maxPower)
end

function cepower.addPower(num)
  oldPower = (storage.power or 0)

  storage.power = util.clamp((storage.power or 0) + num, 0, storage.maxPower)
  return (storage.power or 0) - oldPower
end

function cepower.consumePower(num)
  if (storage.power or 0) < num then
    return false
  end

  storage.power = (storage.power or 0) - num
  return true
end

function cepower.pushPower(nodeID, num)
  outputTable = object.getOutputNodeIds(nodeID)

  if not outputTable[1] or (storage.power or 0) < num then
    return false
  end

  outputConnections = 0
  for _ in pairs(ouputTable) do
    outputConnections = outputConnections + 1
  end

  num = num / outputConnections

  for i = 0, outputConnections - 1, 1 do
    promise = world.sendEntityMessage(outputTable[i], "cepoweradd", num)

    while not promise do end
    if promise:result() and cepower.takePower(promise:result()) then

      object.setOutputNodeLevel(nodeID, true)
      return true
    else
      object.setOutputNodeLevel(nodeID, false)
      return false
    end
  end
end

function cepower.getMaxPower()
  return (storage.maxPower or 0)
end

function cepower.getPower()
  return (storage.power or 0)
end
