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

SCP_032_FR_CONFIG.ActionAmmo = {
    ["XVII"] = function (x) scp_032_fr.XVII() end,
    ['LXII'] = function (x) scp_032_fr.LXII() end,
    ["nulla"] = function (x) scp_032_fr.nulla() end,
    ["MMII"] = function (x) scp_032_fr.MMII() end,
  }

--[[
* Shoot with the gun depend on the ammo type
--]]
function scp_032_fr.Shoot(AmmoType)
    SCP_032_FR_CONFIG.ActionAmmo[AmmoType]
end

--[[
* Shoot 9mm pistol
--]]
function scp_032_fr.XVII()
    -- TODO : make like the regular pistol (sound & shoot feeling)
end

--[[
* Set the player in the sky
--]]
function scp_032_fr.LXII()
    -- TODO : Tp the player very high
end

--[[
* Nothing bhahahahaha
--]]
function scp_032_fr.nulla()
end

--[[
* Shoot this gun
--]]
function scp_032_fr.MMII()
    -- TODO : Spawn the model gun (not fast, it just have to travel 2-3m)
end
