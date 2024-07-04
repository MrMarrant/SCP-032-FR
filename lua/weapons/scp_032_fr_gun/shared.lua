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


AddCSLuaFile()
AddCSLuaFile( "cl_init.lua" )

SWEP.Slot = 1
SWEP.SlotPos = 1

SWEP.Spawnable = true

SWEP.Category = "SCP"
SWEP.ViewModel = Model( "models/weapons/v_scp032fr/v_scp032fr.mdl" )
SWEP.WorldModel = Model( "models/weapons/w_scp032fr/w_scp032fr.mdl" )

SWEP.ViewModelFOV = 65
SWEP.HoldType = "pistol"
SWEP.UseHands = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.DrawAmmo = false
SWEP.AutoSwitch = true
SWEP.Automatic = false

-- Variables Personnal to this weapon --
-- [[ STATS WEAPON ]]
SWEP.PrimaryCooldown = 2

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
    self:SetAmmoType()
	self:SetPlaybackRate( GetConVarNumber( "sv_defaultdeployspeed" ) )
end

function SWEP:Deploy()
	local ply = self:GetOwner()

	self:SendWeaponAnim( ACT_VM_IDLE )

	if (ply:IsPlayer()) then
		local VMAnim = ply:GetViewModel()
		local NexIdle = VMAnim:SequenceDuration() / VMAnim:GetPlaybackRate() 
		self:SetNextPrimaryFire( CurTime() + NexIdle + 0.1 ) --? We add 0.1s for avoid to cancel primary animation
	end

	return true
end

function SWEP:PrimaryAttack()
	local CurrentTime = CurTime()
	self:SetNextPrimaryFire( CurrentTime + self.PrimaryCooldown )

    local ply = self:GetOwner()
    if (ply.SCP032FR_AmmoLeft <= 0) then return end

    ply.SCP032FR_AmmoLeft = ply.SCP032FR_AmmoLeft - 1
	if CLIENT then return end

	local VMAnim = ply:GetViewModel()

    VMAnim:SendViewModelMatchingSequence( VMAnim:LookupSequence( "shoot" ) )
    scp_032_fr.Shoot(ply.SCP032FR_AmmoType, self)
end

function SWEP:SecondaryAttack()
	if CLIENT then return end
end

function SWEP:Reload()
	if CLIENT then return end
end

function SWEP:SetAmmoType()
    local ply = self:GetOwner()
    -- TODO : Set le type de mun et son nombre de mun
    if (not IsValid(ply.SCP032FR_AmmoType)) then
        InitAmmoType(ply, self)
    end
end