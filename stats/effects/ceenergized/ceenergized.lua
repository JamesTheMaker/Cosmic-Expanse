function init()
  animator.setParticleEmitterOffsetRegion("energy", mcontroller.boundBox())
  animator.setParticleEmitterEmissionRate("energy", config.getParameter("emissionRate", 5))
  animator.setParticleEmitterActive("energy", true)

  script.setUpdateDelta(5)

  self.energyRate = config.getParameter("energyAmount", 30) / effect.duration()
end

function update(dt)
  status.modifyResource("energy", self.energyRate * dt)
end

function uninit()

end