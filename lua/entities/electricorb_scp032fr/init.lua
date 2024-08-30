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
	self:SetModel( SCP_032_FR_CONFIG.ElectricOrb )
	self:RebuildPhysics()
	self:InitVar()
	self:EmitSound( "ambient/levels/labs/electric_explosion1.wav" )
	timer.Simple(10, function()
		if (not IsValid(self)) then return end
		self:Remove()
	end)
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
	self:SetMinDamage( 4 )
	self:SetMaxDamage( 8 )
end

function ENT:Think()
	local entsFound = ents.FindInSphere( self:GetPos(), self:GetRadiusOrb() )
	for key, value in ipairs(entsFound) do
        if (value:IsPlayer() and value:Alive()) then
			local distance = self:GetPos():Distance(value:GetPos())
			local pente = (self:GetMinDamage() - self:GetMaxDamage())/self:GetRadiusOrb()
			local damage = pente * distance + self:GetMaxDamage()
			value:TakeDamage( damage, self, self )
			value:Ignite( 1, 0 )
        end
    end
end