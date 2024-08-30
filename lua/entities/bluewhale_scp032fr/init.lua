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

AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    -- TODO : Blue Whale Model
	self:SetModel( SCP_032_FR_CONFIG.ModelBlueWhale )
	self:RebuildPhysics()
	self:InitVar()
	self:SetMaxHealth( 500 )
	self:StartLoopingSound( "" ) -- TODO : Son de balène loop
end

-- Intialise the physic of the entity
function ENT:RebuildPhysics( )
	self:PhysicsInit( SOLID_VPHYSICS ) 
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid( SOLID_VPHYSICS ) 
	self:SetUseType(SIMPLE_USE)
	self:PhysWake()
end

-- Intialise every var related to the entity
function ENT:InitVar( )
	self:SetRadiusOrb( 1500 )
	self:SetIsDead( false )
end

function ENT:OnTakeDamage( damage )
	if (damage >= self:Health()) then
		self:EmitSound( "" ) -- TODO : Son de râle d'agonie
		self:SetIsDead( true )
		self:StopSound( "" ) -- TODO : Arrêt du son de balène loop
		-- TODO : Animation de mort
	else
		self:EmitSound( "" ) -- TODO : Son de balène qui se fait taper
	end
end

function ENT:Think()
	if (self:GetIsDead()) then return end

	local entsFound = ents.FindInSphere( self:GetPos(), self:GetRadiusOrb() )
	for key, value in ipairs(entsFound) do
        if (value:IsPlayer() and value:Alive()) then
			value:TakeDamage( 0.5, self, self )
			scp_032_fr.ApplyTinnitusEffect(value, 20)
        end
    end
end