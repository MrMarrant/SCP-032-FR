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

SCP_032_FR_CONFIG.ModelBowling = "models/props_borealis/bluebarrel001.mdl"
SCP_032_FR_CONFIG.ModelTrain = "models/props_borealis/bluebarrel001.mdl"
SCP_032_FR_CONFIG.ModelQuartz = "models/props_borealis/bluebarrel001.mdl"
SCP_032_FR_CONFIG.ModelPlasticCup = "models/props_borealis/bluebarrel001.mdl"
SCP_032_FR_CONFIG.ModelBlueWhale = "models/props_borealis/bluebarrel001.mdl"
SCP_032_FR_CONFIG.ModelSCP032FR = "models/props_borealis/bluebarrel001.mdl"

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
}

function scp_032_fr.InitAmmoType(ply, gun)
    local AmmoSelected = SCP_032_FR_CONFIG.KeyAmmoType[ math.random( #SCP_032_FR_CONFIG.KeyAmmoType ) ]-- TODO : Verifier qu'il renvoie bien l'index!
    ply.SCP032FR_AmmoType = AmmoSelected

    local AmmoLeft = SCP_032_FR_CONFIG.AmmoType[AmmoSelected].TotalAmmo
    ply.SCP032FR_AmmoLeft = AmmoLeft

    gun.PrimaryCooldown = SCP_032_FR_CONFIG.AmmoType[AmmoSelected].CDShoot

    net.Start(SCP_032_FR_CONFIG.SendDataAmmo)
        net.WriteString(AmmoSelected)
    net.Send(ply)
end

function scp_032_fr.CreateEnt(name)
	local ent = ents.Create( name )
	if (not IsValid(ent)) then return false end
	ent:Spawn()
	ent:Activate()

	return ent
end


function scp_032_fr.CreateProp(ply)
    local LookForward = ply:EyeAngles():Forward()
	local LookUp = ply:EyeAngles():Up()
	local ent = scp_032_fr.CreateEnt("prop_physics")
	local DistanceToPos = 50
	local PosObject = (ply:IsPlayer() and ply:GetShootPos() or ply:GetPos()) + LookForward * DistanceToPos + LookUp
    PosObject.z = ply:GetPos().z

	ent:SetPos( PosObject )
	ent:SetAngles( ply:EyeAngles() )

    return ent
end

function scp_032_fr.SetEntParam(ent, model)
    ent:SetModel(model)
    local phys = ent:GetPhysicsObject()
	phys:EnableMotion( true )
	phys:Wake()
end


function scp_032_fr.ShootAnEnt(ply, ent, speed)
    ent:GetPhysicsObject():SetVelocity( ply:EyeAngles():Forward() * speed )
end

--[[
* Shoot with the gun depend on the ammo type
--]]
function scp_032_fr.Shoot(AmmoType, gun)
    SCP_032_FR_CONFIG.ActionAmmo[AmmoType](gun)
end

-- [[ *  Gun Type Functions  *]]

--[[
* Shoot an earthquake from the player pos
--]]
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
--]]
function scp_032_fr.XVII(gun)
    gun:ShootBullet( 20, 1, 0.01 )
    gun:GetOwner():ViewPunch( Angle( -1, 0, 0 ) )
    gun:GetOwner():EmitSound("weapons/pistol/pistol_fire".. math.random(2,3) ..".wav", 75, math.random(90, 110))
end

--[[
* Set the player in the sky
--]]
function scp_032_fr.LXII(gun)
    local ply = gun:GetOwner()
    local CurrentPos = ply:GetPos()
    CurrentPos.z = 9999 -- TODO : Vérifier ça
    ply:SetPos(CurrentPos)
end

--[[
* Nothing bhahahahaha
--]]
function scp_032_fr.nulla(gun)
end

--[[
* Shoot this gun
--]]
function scp_032_fr.MMII(gun)
    -- TODO : Spawn the model gun (not fast, it just have to travel 2-3m)
    local ply = gun:GetOwner()
	local ent = scp_032_fr.CreateProp(ply)
    scp_032_fr.SetEntParam(ent, SCP_032_FR_CONFIG.ModelSCP032FR)
	scp_032_fr.ShootAnEnt(ply, ent, 100)
end

--[[
* Shoot ball of bowling
* Nice Strike
--]]
function scp_032_fr.X(gun)
    local ply = gun:GetOwner()
	local ent = scp_032_fr.CreateProp(ply)
    scp_032_fr.SetEntParam(ent, SCP_032_FR_CONFIG.ModelBowling)
	scp_032_fr.ShootAnEnt(ply, ent, 1000)
    -- TODO : SFX
    gun:GetOwner():EmitSound("", 75, math.random(90, 110))
end

--[[
* Shoot a train
--]]
function scp_032_fr.XXIII(gun)
    local ply = gun:GetOwner()
	local ent = scp_032_fr.CreateProp(ply)
    scp_032_fr.SetEntParam(ent, SCP_032_FR_CONFIG.ModelBowling)
	scp_032_fr.ShootAnEnt(ply, ent, 1000)
    -- TODO : SFX
    gun:GetOwner():EmitSound("", 75, math.random(90, 110))
end

--[[
* Shoot a blue whale
--]]
function scp_032_fr.XXII(gun)
    local ply = gun:GetOwner()
	local ent = scp_032_fr.CreateProp(ply)
    scp_032_fr.SetEntParam(ent, SCP_032_FR_CONFIG.ModelBlueWhale)
	scp_032_fr.ShootAnEnt(ply, ent, 300)
    -- TODO : SFX
    gun:GetOwner():EmitSound("", 75, math.random(90, 110))
end

--[[
* Shoot a cup of plastic
--]]
function scp_032_fr.CCCXII(gun)
    local ply = gun:GetOwner()
	local ent = scp_032_fr.CreateProp(ply)
    scp_032_fr.SetEntParam(ent, SCP_032_FR_CONFIG.ModelPlasticCup)
	scp_032_fr.ShootAnEnt(ply, ent, 1000)
    -- TODO : SFX
    gun:GetOwner():EmitSound("", 75, math.random(90, 110))
end

--[[
* Set a enourmous sound & accouphene
--]]
function scp_032_fr.XC(gun)
    local ply = gun:GetOwner()
    -- TODO : SFX
    ply:EmitSound("", 75, math.random(90, 110))
    -- TODO : Trouve run moyen de produire l'effet accouphene 
    -- comme quand on se prend une grenade par ex.
end

--[[
* Shoot hair
--]]
function scp_032_fr.MMMM(gun)
    gun:ShootBullet( 1, 1, 0.01 )
    gun:GetOwner():ViewPunch( Angle( -1, 0, 0 ) )
    -- TODO : SFX
    gun:GetOwner():EmitSound("", 75, math.random(90, 110))
end

--[[
* Make a Earth Quake physic effect on a entity
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