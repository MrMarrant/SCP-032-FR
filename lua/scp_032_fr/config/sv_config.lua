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

SCP_032_FR_CONFIG.DurationProps = CreateConVar( "SCP032FR_DurationProps", 60, {FCVAR_PROTECTED, FCVAR_ARCHIVE}, "Time before a props disappears.", 5, 9999 )

hook.Add( "PlayerDeath", "PlayerDeath.SCP032FR_Died", function( victim, inflictor, attacker )
    victim.SCP032FR_AmmoType = nil
    victim.SCP032FR_AmmoLeft = nil
    victim:SetDSP(1, false)
    victim:StopSound("")
    -- TODO : Set coté client aussi 
    victim.SCP023_AffectTinnitus = nil
    if (inflictor:GetClass() == 'bowling_scp032fr') then
        -- TODO : NICE STRIKE de nintendo.
        victim:EmitSound("")
    end
end)

util.AddNetworkString(SCP_032_FR_CONFIG.SendDataAmmo)
util.AddNetworkString(SCP_032_FR_CONFIG.ElectricOrb)
util.AddNetworkString(SCP_032_FR_CONFIG.SetConvarClientSide)
util.AddNetworkString(SCP_032_FR_CONFIG.SetConvarInt)

-- Send to player the list of actual players who wear the mask client side.
hook.Add( "PlayerInitialSpawn", "PlayerInitialSpawn.SCP032FR_LoadConVar", function(ply)
    scp_032_fr.SetConvarClientSide("ClientDurationProps", SCP_032_FR_CONFIG.DurationProps:GetInt(), ply)
end)