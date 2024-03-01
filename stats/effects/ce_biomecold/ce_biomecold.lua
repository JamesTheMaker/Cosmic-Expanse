function init()
    local bounds = mcontroller.boundBox()
    animator.setParticleEmitterOffsetRegion("snow", bounds)
    animator.setParticleEmitterActive("snow", true)

    script.setUpdateDelta(2)

    self.tickRate = config.getParameter("tickRate")
    self.tickDamage = config.getParameter("tickDamage")

    self.resistPerc = config.getParameter("resistPerc")
  
    self.tickTimer = self.tickRate
    
    world.sendEntityMessage(entity.id(), "queueRadioMessage", "biomecold", 5.0)
end

function update(dt)
    self.tickTimer = math.max(0, self.tickTimer - dt)
  
    if self.tickTimer == 0 and status.stat("iceResistance") < self.resistPerc then
      -- animator.burstParticleEmitter("flames")
      self.tickTimer = self.tickRate
      status.applySelfDamageRequest({
          damageType = "IgnoresDef",
          damage = self.tickDamage,
          damageSourceKind = "ice",
          sourceEntityId = entity.id()
        })
    end
end

function uninit() end