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

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    -- TODO : litlle ball Model
	self:SetModel( "" )
    self:SetColor(Color(255, 255, 255, 0))
    self:SetRenderMode(RENDERMODE_TRANSCOLOR)
    self:SetNoDraw(true)
	self:RebuildPhysics()
	self:Ignite(999)
end

-- Intialise the physic of the entity
function ENT:RebuildPhysics( )
	self:PhysicsInit( SOLID_VPHYSICS ) 
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid( SOLID_VPHYSICS ) 
	self:SetUseType(SIMPLE_USE)
	self:PhysWake()
end

-- Use specially for the physics sounds
function ENT:PhysicsCollide( data, physobj )
    local EntHit = data.HitEntity
	if (EntHit:IsPlayer()) then
		EntHit:EmitSound("ambient/fire/ignite.wav", 75, 100, 1, CHAN_AUTO)
		EntHit:ignite(1)
    end
	self:Remove()
end