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


AddCSLuaFile()
AddCSLuaFile( "cl_init.lua" )

SWEP.Slot = 1
SWEP.SlotPos = 1

SWEP.Spawnable = true

SWEP.Category = "SCP"
SWEP.ViewModel = Model( "models/weapons/scp_032fr/v_scp_032fr.mdl" )
SWEP.WorldModel = SCP_032_FR_CONFIG.ModelSCP032FR

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
SWEP.ReloadCooldown = 4
SWEP.CurrentPrimaryCooldown = CurTime()
SWEP.CurrentReloadCooldown = CurTime()

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
	self:SetPlaybackRate( GetConVarNumber( "sv_defaultdeployspeed" ) )
end

function SWEP:Equip()
	self:SetAmmoType()
end

function SWEP:Deploy()
	self:ActionAnim(ACT_VM_DRAW)
	return true
end

function SWEP:PrimaryAttack()
	if CLIENT then return end
	local CurrentTime = CurTime()
	if (self.CurrentPrimaryCooldown < CurrentTime) then
		local ply = self:GetOwner()
		if (ply.SCP032FR_AmmoLeft <= 0) then 
			ply:EmitSound(SCP_032_FR_CONFIG.Sounds.EmptyAmmo, 75, math.random( 100, 110 ) )
			self:ActionAnim(ACT_VM_PRIMARYATTACK_EMPTY)
		else
			ply.SCP032FR_AmmoLeft = math.Clamp(ply.SCP032FR_AmmoLeft - 1, 0, ply.SCP032FR_AmmoLeft)
			self:ActionAnim(ACT_VM_PRIMARYATTACK)
			scp_032_fr.Shoot(ply.SCP032FR_AmmoType, self)
			self.CurrentPrimaryCooldown = CurrentTime + self.PrimaryCooldown
		end
	end
end

function SWEP:SecondaryAttack()
	if CLIENT then return end
end

function SWEP:Reload()
	if CLIENT then return end
	local CurrentTime = CurTime()
	if (self.CurrentReloadCooldown < CurrentTime) then
		self:ActionAnim(ACT_VM_RELOAD)
		self.CurrentReloadCooldown = CurrentTime + self.ReloadCooldown
	end
end

function SWEP:SetAmmoType()
    local ply = self:GetOwner()
    if (not IsValid(ply.SCP032FR_AmmoType)) then
        scp_032_fr.InitAmmoType(ply, self)
    end
end

function SWEP:ActionAnim(animToPlay)
	self:SendWeaponAnim(animToPlay)
	self:NextIdle()
end

function SWEP:NextIdle()
	local VMAnim = self:GetOwner():GetViewModel()
	local NexIdle = math.Round(VMAnim:SequenceDuration() / VMAnim:GetPlaybackRate(), 2) - 0.1
	timer.Simple(NexIdle, function()
		if not self:IsValid() then return end
		self:SendWeaponAnim(ACT_VM_IDLE)
	end)
end