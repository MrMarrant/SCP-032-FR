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

/* 
* 
* @string name
* @number value
*/
function scp_032_fr.SetConvarClientSide(name, value, ply)
    if (type( value ) == "boolean") then value = value and 1 or 0 end
    net.Start(SCP_032_FR_CONFIG.SetConvarClientSide)
        net.WriteString(name)
        net.WriteUInt(value, 14)
    if (ply) then
        net.Send(ply)
    else
        net.Broadcast()
    end
end

-- Set Convar Int for the client side
net.Receive(SCP_032_FR_CONFIG.SetConvarInt, function ( len, ply )
    if (ply:IsSuperAdmin() or game.SinglePlayer()) then
        local name = net.ReadString()
        local value = net.ReadUInt(14)
        SCP_032_FR_CONFIG[name]:SetInt(value)

        scp_032_fr.SetConvarClientSide('Client'..name, value) --? The value clientside start with Client
    end
end)