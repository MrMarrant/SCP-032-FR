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

include('shared.lua')

SWEP.PrintName = "SCP-032-FR"
SWEP.Author = "MrMarrant"
SWEP.Purpose = "It shoot something."
SWEP.DrawCrosshair = false
SWEP.Base = "weapon_base"
SWEP.AutoSwitchTo = false


-- TODO : Afficher Le type de mun de l'arme actuelle
-- TODO : A test l'effet de wiggle
--! Actuellement ça fonctionne pas trop en l'état, à revoir ou à réfléchir à un affichage plus simple.
local shakeAmount = 2
local shakeSpeed = 50

function SWEP:DrawHUD()
    local ply = self:GetOwner()
    local xPosition = SCP_032_FR_CONFIG.ScrW * 0.372
    local yPosition = SCP_032_FR_CONFIG.ScrH * 0.55
    local isShaking = scp_032_fr.IsPlayerMoving(LocalPlayer())

    if (isShaking) then
        local shakeOffsetX = math.sin(CurTime() * shakeSpeed) * shakeAmount
        local shakeOffsetY = math.cos(CurTime() * shakeSpeed) * shakeAmount
        xPosition = xPosition + shakeOffsetX
        yPosition = yPosition + shakeOffsetY
    end

    surface.SetDrawColor( 0, 0, 0, 0)
    surface.DrawRect(0, 0, SCP_032_FR_CONFIG.ScrW, SCP_032_FR_CONFIG.ScrH)
    draw.DrawText( ply.SCP032FR_AmmoType, "SCP032FR_RomanNumeral", xPosition, yPosition, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER )
end