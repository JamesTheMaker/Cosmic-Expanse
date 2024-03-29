function init()
  local bounds = mcontroller.boundBox()
  animator.setParticleEmitterBurstCount("flames", 6)
  animator.setParticleEmitterOffsetRegion("flames", {bounds[1], bounds[2] - 0.25, bounds[3], bounds[2] + 0.25})
  animator.setParticleEmitterOffsetRegion("drips", bounds)
  animator.setParticleEmitterActive("drips", true)
  
  script.setUpdateDelta(2)

  self.tickRate = config.getParameter("tickRate")
  self.tickDamage = config.getParameter("tickDamage")

  self.resistPerc = config.getParameter("resistPerc")

  self.tickTimer = self.tickRate
  
  if status.stat("fireResistance") < self.resistPerc then
    world.sendEntityMessage(entity.id(), "queueRadioMessage", "biomeheat", 5.0)
  end
end

function update(dt)
  self.tickTimer = math.max(0, self.tickTimer - dt)

  if self.tickTimer == 0 and status.stat("fireResistance") < self.resistPerc then
    animator.burstParticleEmitter("flames")
    self.tickTimer = self.tickRate
    status.applySelfDamageRequest({
      damageType = "IgnoresDef",
      damage = self.tickDamage,
      damageSourceKind = "fire",
      sourceEntityId = entity.id()
    })
  end
end

function uninit() end
