-- SCP-032-FR, A representation of a paranormal object on a fictional series on the game Garry's Mod.
-- Copyright (C) 2023  MrMarrant aka BIBI.

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
    ["XVII"] = function (gun) scp_032_fr.XVII(gun) end,
    ['LXII'] = function (gun) scp_032_fr.LXII(gun) end,
    ["nulla"] = function (gun) scp_032_fr.nulla(gun) end,
    ["MMII"] = function (gun) scp_032_fr.MMII(gun) end,
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

--[[
* Shoot with the gun depend on the ammo type
--]]
function scp_032_fr.Shoot(AmmoType, gun)
    SCP_032_FR_CONFIG.ActionAmmo[AmmoType](gun)
end

-- [[ *  Gun Type Functions  *]]

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
    ent:SetModel("models/props_borealis/bluebarrel001.mdl")
    local phys = ent:GetPhysicsObject()
	phys:EnableMotion( true )
	phys:Wake()
	ent:GetPhysicsObject():SetVelocity( ply:EyeAngles():Forward() * 100 ) -- TODO : test ça aussi
end