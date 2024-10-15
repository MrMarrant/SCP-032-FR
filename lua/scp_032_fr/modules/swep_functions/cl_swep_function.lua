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

function scp_032_fr.IsPlayerMoving(ply)
    if not IsValid(ply) then return false end

    local velocity = ply:GetVelocity()
    return velocity:Length() > 5
end


net.Receive(SCP_032_FR_CONFIG.SendDataAmmo, function()
    local ply = LocalPlayer()
    local ammoType = net.ReadString()

    ply.SCP032FR_AmmoType = ammoType
    -- TODO : SFX Appel Des nombres
    ply:EmitSound("call_ammo_"..ammoType..'.mp3', 75, math.random(90, 110))
end)

net.Receive(SCP_032_FR_CONFIG.ElectricOrb, function()
    local pos = net.ReadVector()
    local gunIndex = net.ReadEntity():EntIndex()
    hook.Add( "Think", "Think.SCP032FR_ElectricOrb_" .. gunIndex, function()
        local light = DynamicLight(gunIndex)
        if ( light ) then
            light.pos = pos
            light.r = 255
            light.g = 255
            light.b = 255
            light.brightness = 100
            light.decay = 1000
            light.size = 1000
            light.dietime = CurTime() + 10
        end
    end )
    timer.Simple(10, function()
        hook.Remove( "Think", "Think.SCP032FR_ElectricOrb_" .. gunIndex )
    end)
end)