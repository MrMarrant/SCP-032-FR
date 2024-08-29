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

SCP_032_FR_CONFIG.AmmoType = {
    V = {
        TotalAmmo = 5,
        CDShoot = 35
    },
    XVII = {
        TotalAmmo = 17,
        CDShoot = 0.2
    },
    LXII = {
        TotalAmmo = 62,
        CDShoot = 5
    },
    nulla = {
        TotalAmmo = 0,
        CDShoot = 0
    },
    MMII = {
        TotalAmmo = 2002,
        CDShoot = 1
    },
    XC = {
        TotalAmmo = 90,
        CDShoot = 10
    },
    MMMM = {
        TotalAmmo = 4000,
        CDShoot = 0.1
    },
    X = {
        TotalAmmo = 10,
        CDShoot = 3
    },
    XXII = {
        TotalAmmo = 22,
        CDShoot = 10
    },
    XXIII = {
        TotalAmmo = 23,
        CDShoot = 10
    },
    CCCXII = {
        TotalAmmo = 312,
        CDShoot = 2
    },
    DCLXVI = {
        TotalAmmo = 666,
        CDShoot = 0.5
    },
    III = {
        TotalAmmo = 3,
        CDShoot = 30
    }
}
SCP_032_FR_CONFIG.KeyAmmoType = {}
for key, value in pairs(SCP_032_FR_CONFIG.AmmoType) do
    table.insert(SCP_032_FR_CONFIG.KeyAmmoType, key)
end

-- NET VAR
SCP_032_FR_CONFIG.SendDataAmmo = "SCP_032_FR_CONFIG.SendDataAmmo"
SCP_032_FR_CONFIG.ElectricOrb = "SCP_032_FR_CONFIG.ElectricOrb"
SCP_032_FR_CONFIG.SetConvarClientSide = "SCP_032_FR_CONFIG.SetConvarClientSide"
SCP_032_FR_CONFIG.SetConvarInt = "SCP_032_FR_CONFIG.SetConvarInt"