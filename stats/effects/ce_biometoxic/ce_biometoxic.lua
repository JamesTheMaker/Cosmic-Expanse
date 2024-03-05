function init()
    local bounds = mcontroller.boundBox()
    animator.setParticleEmitterOffsetRegion("toxic", bounds)
    animator.setParticleEmitterActive("toxic", true)

    script.setUpdateDelta(2)

    self.tickRate = config.getParameter("tickRate")
    self.tickDamage = config.getParameter("tickDamage")
    
    self.resistStat = config.getParameter("resistStat")
    self.resistPerc = config.getParameter("resistPerc")
  
    self.tickTimer = self.tickRate
    
    if status.stat("poisonResistance") < self.resistPerc then
        world.sendEntityMessage(entity.id(), "queueRadioMessage", "biomeradiation", 5.0)
    end
end

function update(dt)
    self.tickTimer = math.max(0, self.tickTimer - dt)
  
    if self.tickTimer == 0 and status.stat("poisonResistance") < self.resistPerc then
        -- animator.burstParticleEmitter("flames")
        self.tickTimer = self.tickRate
        status.applySelfDamageRequest({
            damageType = "IgnoresDef",
            damage = self.tickDamage,
            damageSourceKind = "poison",
            sourceEntityId = entity.id()
        })
    end
end

function uninit() end