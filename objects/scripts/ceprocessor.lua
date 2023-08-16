require "/scripts/cepower.lua"

local pInit = init
function init()
  pInit()

  self.powerConsumption = config.getParameter("powerConsumption") or 0
  self.delayMax = config.getParameter("delay") or 0
  self.recipeList = config.getParameter("recipeList")
  self.recipes = root.assetJson("/recipes/" .. self.recipeList .. ".config")
end

function update(dt)
  if world.containerItemAt(entity.id(), 0) == nil then return end
  self.delay = (self.delay or 0) + dt
  if self.delay < self.delayMax then return end
  self.delay = 0

  for r, recipe in pairs(self.recipes) do
    if world.containerItemAt(entity.id(), 0).name == recipe[1] and canAddItems(recipe[2]) and cepower.consumePower(self.powerConsumption) then
      addItems(recipe[2])
      world.containerConsumeAt(entity.id(), 0, 1)
      return
    end
  end
end

function canAddItems(items)
  for i, item in pairs(items) do
    if not canAddItem(item[2]) then return false end
  end

  return true
end

function canAddItem(i)
  for x = 1, world.containerSize(entity.id()) - 1, 1 do
    local slotItem = world.containerItemAt(entity.id(), x)

    if not slotItem or slotItem.name == i then
      return true
    end
  end
  
  return false
end

function addItems(items)
  for i, item in pairs(items) do
    if math.random() <= item[1] then
      addItem(item[2])
    end
  end
end

function addItem(i)
  for x = 1, world.containerSize(entity.id()) - 1, 1 do
    local slotItem = world.containerItemAt(entity.id(), x)

    if not slotItem or slotItem.name == i then
      world.containerPutItemsAt(entity.id(), i, x)
      return
    end
  end
end
