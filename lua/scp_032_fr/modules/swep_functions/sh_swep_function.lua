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

function scp_032_fr.InitAmmoType(ply, gun)
    local AmmoSelected = math.random( #SCP_032_FR_CONFIG.AmmoType ) -- TODO : Verifier qu'il renvoie bien l'index!
    ply.SCP032FR_AmmoType = AmmoSelected
    ply.SCP032FR_AmmoLeft = SCP_032_FR_CONFIG.AmmoType[AmmoSelected].TotalAmmo

    gun.PrimaryCooldown = SCP_032_FR_CONFIG.AmmoType[AmmoSelected].CDShoot
end