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

function scp_032_fr.SetConvarInt(name, value, ply)
    if (ply:IsSuperAdmin() or game.SinglePlayer()) then --? Just for avoid to spam net message, we check server side to.
        net.Start(SCP_032_FR_CONFIG.SetConvarInt)
            net.WriteString(name)
            net.WriteUInt(value, 14)
        net.SendToServer()
    end
end

hook.Add("PopulateToolMenu", "PopulateToolMenu.SCP032FR_MenuConfig", function()
    spawnmenu.AddToolMenuOption("Utilities", "SCP-032FR", "SCP032FR_MenuConfig", "Settings", "", "", function(panel)
        local ply = LocalPlayer()

        local SCP032FR_DurationProps = vgui.Create("DNumSlider")
        SCP032FR_DurationProps:SetPos( 5, 5 )
        SCP032FR_DurationProps:SetSize( 100, 20 )
        SCP032FR_DurationProps:SetMinMax( 5, 9999 )
        SCP032FR_DurationProps:SetDecimals( 0 )
        SCP032FR_DurationProps:SetValue( SCP_032_FR_CONFIG.ClientDurationProps )
        SCP032FR_DurationProps.OnValueChanged = function(NumSlider, val)
            scp_032_fr.SetConvarInt("DurationProps", val, ply)
        end

        panel:Clear()
        panel:ControlHelp(scp_032_fr.GetTranslation("warningsettings"))
        panel:Help( scp_032_fr.GetTranslation("durationprops_description") )
        panel:AddItem(SCP032FR_DurationProps)
    end)
end)

net.Receive(SCP_032_FR_CONFIG.SetConvarClientSide, function ()
    local name = net.ReadString()
    local value = net.ReadUInt(14)
    SCP_032_FR_CONFIG[name] = value
end)
