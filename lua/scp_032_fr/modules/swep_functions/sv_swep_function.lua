-- SCP-032-FR, A representation of a paranormal object on a fictional series on the game Garry's Mod.
-- Copyright (C) 2024  MrMarrant aka BIBI.

-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.

-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.

-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <https://www.gnu.org/licenses/>.

SCP_032_FR_CONFIG.ActionAmmo = {
    ["V"] = function (gun) scp_032_fr.V(gun) end,
    ["XVII"] = function (gun) scp_032_fr.XVII(gun) end,
    ['LXII'] = function (gun) scp_032_fr.LXII(gun) end,
    ["nulla"] = function (gun) scp_032_fr.nulla(gun) end,
    ["MMII"] = function (gun) scp_032_fr.MMII(gun) end,
    ["XC"] = function (gun) scp_032_fr.XC(gun) end,
    ["MMMM"] = function (gun) scp_032_fr.MMMM(gun) end,
    ["X"] = function (gun) scp_032_fr.X(gun) end,
    ["XXII"] = function (gun) scp_032_fr.XXII(gun) end,
    ["XXIII"] = function (gun) scp_032_fr.XXIII(gun) end,
    ["CCCXII"] = function (gun) scp_032_fr.CCCXII(gun) end,
    ["DCLXVI"] = function (gun) scp_032_fr.DCLXVI(gun) end,
    ["III"] = function (gun) scp_032_fr.III(gun) end,
}

-- Cheat command
hook.Add("PlayerSay", "PlayerSay.CheatCommandSCP032FR", function(ply, text)
    local command = string.Explode(" ", text)
    if command[1] == "!setammo" then
        PrintTable(SCP_032_FR_CONFIG.KeyAmmoType)
        local ammoType = tonumber(command[2])
        local gun = ply:GetActiveWeapon()
        scp_032_fr.SetAmmoType(ply, gun, ammoType)
    end
end)

--[[
* Set the ammo type for the player
* @param ply : Player
* @param gun : Entity
* @param ammoPicked : int
--]]
function scp_032_fr.SetAmmoType(ply, gun, ammoPicked)
    if (not ammoPicked) then return end

    -- Get actual gun
    local gun = ply:GetActiveWeapon()
    local AmmoSelected = SCP_032_FR_CONFIG.KeyAmmoType[ ammoPicked ]
    local AmmoLeft = SCP_032_FR_CONFIG.AmmoType[AmmoSelected].TotalAmmo

    ply.SCP032FR_AmmoType = AmmoSelected
    ply.SCP032FR_AmmoLeft = AmmoLeft

    gun.PrimaryCooldown = SCP_032_FR_CONFIG.AmmoType[AmmoSelected].CDShoot

    net.Start(SCP_032_FR_CONFIG.SendDataAmmo)
        net.WriteString(AmmoSelected)
    net.Send(ply)

end

--[[
* Init the ammo type for the player
* @param ply : Player
* @param gun : Entity
--]]
function scp_032_fr.InitAmmoType(ply, gun)
    local ammoPicked = math.random( #SCP_032_FR_CONFIG.KeyAmmoType )
    scp_032_fr.SetAmmoType(ply, gun, ammoPicked)
end

--[[
* Create an entity and set params.
* @param ply : Player
* @param distance : int
* @param model : string
* @param obj : Entity?
--]]
function scp_032_fr.CreateEnt(ply, distance, model, obj)
	local ent = obj or ents.Create("prop_physics")
    if not IsValid(obj) then ent:SetModel( model ) end
	ent:SetPos( ply:GetShootPos() + ply:GetAimVector() * distance )
	ent:SetAngles( ply:EyeAngles() )
    ent:Spawn()
	ent:Activate()

    return ent
end

--[[
* Get the position in front of the player
* @param ply : Player
* @param DistanceToPos : int
--]]
function scp_032_fr.GetPosForward(ply, DistanceToPos)
    local LookForward = ply:EyeAngles():Forward()
	local LookUp = ply:EyeAngles():Up()
    local PosObject = (ply:IsPlayer() and ply:GetShootPos() or ply:GetPos()) + LookForward * DistanceToPos + LookUp
    PosObject.z = ply:GetPos().z
    
    return PosObject
end

--[[
* Shoot an entity.
* @param ply : Player
* @param ent : Entity
* @param speed : int
--]]
function scp_032_fr.ShootAnEnt(ply, ent, speed)
    ent:GetPhysicsObject():SetVelocity( ply:EyeAngles():Forward() * speed )
end

--[[
* Shoot with the gun depend on the ammo type
* @param AmmoType : string
* @param gun : Entity
--]]
function scp_032_fr.Shoot(AmmoType, gun)
    SCP_032_FR_CONFIG.ActionAmmo[AmmoType](gun)
end

--[[
* Make a Earth Quake physic effect on a entity
* @param ent : Entity
--]]
function scp_032_fr.QuakeEffect(ent)
    if not IsValid(ent) or not ent:GetPhysicsObject():IsValid() then return end

    local phys = ent:GetPhysicsObject()
    local quakeStrength = 50

    local forceEQ = Vector(
        math.random(-quakeStrength, quakeStrength),
        math.random(-quakeStrength, quakeStrength),
        math.random(-quakeStrength, quakeStrength) / 2
    )

    phys:ApplyForceCenter(forceEQ)
end

--[[
* Make a tinnitus effect on a player.
* @param ply : Player
* @param duration : int
--]]
function scp_032_fr.ApplyTinnitusEffect(ply, duration)
    if not IsValid(ply) or not ply:IsPlayer() then return end
    if ply.SCP023_AffectTinnitus then return end

    ply:SetDSP(35, false) -- Disable Sounds
    -- TODO : SFX tinnitus
    ply:StartLoopingSound("")
    ply.SCP023_AffectTinnitus = true

    timer.Simple(duration, function()
        if not IsValid(ply) then return end
        if ply.SCP023_AffectTinnitus then
            ply:SetDSP(1, false)
            -- TODO : SFX tinnitus
            ply:StopSound("")
            ply.SCP023_AffectTinnitus = nil
        end
    end)
end

--[[
* Remove an ent by a timer.
* @param ent : Entity
--]]
function scp_032_fr.RemoveByTimer(ent)
    timer.Simple(SCP_032_FR_CONFIG.DurationProps:GetInt(), function()
        if (not IsValid(ent)) then return end
        ent:Remove()
    end)
end

--? [[ *  Gun Type Functions  *]]

--[[
* Shoot an electrib orb that flash nearby player & 
* burn those who are too close
--]]
-- TODO : A test
function scp_032_fr.III(gun)
    local ply = gun:GetOwner()
    local pos = scp_032_fr.GetPosForward(ply, 50)

    local ent = scp_032_fr.CreateEnt(ply, 50, "", ents.Create( "electricorb_scp032fr" ))

    -- Création de l'entité de particules pour l'effet
    local effectData = EffectData()
    effectData:SetOrigin(pos)
    effectData:SetScale(1)
    effectData:SetMagnitude(2)
    
    util.Effect("TeslaZap", effectData)

    net.Start(SCP_032_FR_CONFIG.ElectricOrb)
        net.WriteVector(pos)
    net.Broadcast(ply)
end

--[[
* Shoot an earthquake from the player pos
* @param gun : Entity
--]]
-- TODO : A test
function scp_032_fr.V(gun)
    local posEQ = gun:GetOwner():GetPos()
    local duration = math.random(20, 30)
    local radius = 9999
    local quakeFrequency = 0.1

    util.ScreenShake( posEQ, 5, 20, duration, radius )
    timer.Create("SCP032FR_EarthquakeTimer", quakeFrequency, 0, function()
        for _, ent in pairs(ents.GetAll()) do
            if ent:GetClass() == "prop_physics" and posEQ:Distance(ent:GetPos()) <= radius then
                scp_032_fr.QuakeEffect(ent)
            end
        end
    end)

    timer.Simple(duration, function()
        timer.Remove("SCP032FR_EarthquakeTimer")
    end)
    -- TODO : SFX
    gun:GetOwner():EmitSound("", 75, math.random(90, 110))
end

--[[
* Shoot 9mm pistol
* @param gun : Entity
--]]
function scp_032_fr.XVII(gun)
    gun:ShootBullet( 20, 1, 0.01 )
    gun:GetOwner():ViewPunch( Angle( -1, 0, 0 ) )
    gun:GetOwner():EmitSound("weapons/pistol/pistol_fire".. math.random(2,3) ..".wav", 75, math.random(90, 110))
end

--[[
* Set the player in the sky
* @param gun : Entity
--]]
function scp_032_fr.LXII(gun)
    local ply = gun:GetOwner()
    local CurrentPos = ply:GetPos()
    CurrentPos.z = 9999 -- TODO : Vérifier ça
    ply:SetPos(CurrentPos)
end

--[[
* Nothing bhahahahaha
* @param gun : Entity
--]]
function scp_032_fr.nulla(gun)
end

--[[
* Shoot this gun
* @param gun : Entity
--]]
function scp_032_fr.MMII(gun)
    -- TODO : Spawn the model gun (not fast, it just have to travel 2-3m)
    local ply = gun:GetOwner()
	local ent = scp_032_fr.CreateEnt(ply, 50, SCP_032_FR_CONFIG.ModelSCP032FR)
    scp_032_fr.ShootAnEnt(ply, ent, 300)
    -- TODO : SFX
    gun:GetOwner():EmitSound("", 75, math.random(90, 110))
    scp_032_fr.RemoveByTimer(ent)
end

--[[
* Shoot ball of bowling
* Nice Strike
* @param gun : Entity
--]]
function scp_032_fr.X(gun)
    local ply = gun:GetOwner()
	local ent = scp_032_fr.CreateEnt(ply, 50, "", ents.Create( "bowling_scp032fr" ))
	scp_032_fr.ShootAnEnt(ply, ent, 1000)
    -- TODO : SFX
    ply:EmitSound("", 75, math.random(90, 110))
    scp_032_fr.RemoveByTimer(ent)
end

--[[
* Shoot a train
* @param gun : Entity
--]]
function scp_032_fr.XXIII(gun)
    local ply = gun:GetOwner()
	local ent = scp_032_fr.CreateEnt(ply, 50, SCP_032_FR_CONFIG.ModelTrain)
	scp_032_fr.ShootAnEnt(ply, ent, 1000)
    scp_032_fr.RemoveByTimer(ent)
    -- TODO : SFX
    gun:GetOwner():EmitSound("", 75, math.random(90, 110))
end

--[[
* Shoot a blue whale
* @param gun : Entity
--]]
function scp_032_fr.XXII(gun)
    local ply = gun:GetOwner()
	local ent = scp_032_fr.CreateEnt(ply, 100, "", ents.Create( "bluewhale_scp032fr" ))
	scp_032_fr.ShootAnEnt(ply, ent, 1000)
end

--[[
* Shoot a cup of plastic
* @param gun : Entity
--]]
function scp_032_fr.CCCXII(gun)
    local ply = gun:GetOwner()
	local ent = scp_032_fr.CreateEnt(ply, 50, SCP_032_FR_CONFIG.ModelPlasticCup)
	scp_032_fr.ShootAnEnt(ply, ent, 500)
    scp_032_fr.RemoveByTimer(ent)
    -- TODO : SFX
    gun:GetOwner():EmitSound("", 75, math.random(90, 110))
end

--[[
* Set a enourmous sound & accouphene
* @param gun : Entity
--]]
--TODO : A test
function scp_032_fr.XC(gun)
    local ply = gun:GetOwner()
    local radiusEffect = 3000
    -- TODO : SFX
    ply:EmitSound("", 75, math.random(90, 110))
    for _, ent in pairs(player.GetAll()) do
        if ent:GetPos():Distance(ply:GetPos()) <= radiusEffect then
            scp_032_fr.ApplyTinnitusEffect(ent, 10)
        end
    end
end

--[[
* Shoot hair
* @param gun : Entity
--]]
function scp_032_fr.MMMM(gun)
    gun:ShootBullet( 1, 1, 0.01 )
    gun:GetOwner():ViewPunch( Angle( -1, 0, 0 ) )
    -- TODO : SFX
    gun:GetOwner():EmitSound("", 75, math.random(90, 110))
end

--[[
* Shoot fire
* @param gun : Entity
--]]
function scp_032_fr.DCLXVI(gun)
    local ply = gun:GetOwner()
	local ent = scp_032_fr.CreateEnt(ply, 50, "", ents.Create( "fire_scp032fr" ))
	scp_032_fr.ShootAnEnt(ply, ent, 1500)
    -- TODO : SFX
    gun:GetOwner():EmitSound("", 75, math.random(90, 110))
end