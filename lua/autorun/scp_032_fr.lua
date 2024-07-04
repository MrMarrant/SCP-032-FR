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


-- Functions
scp_032_fr = {}
-- Global Variable
SCP_032_FR_CONFIG = {}
-- Lang
SCP_032_FR_LANG = {}

-- Root path
SCP_032_FR_CONFIG.RootFolder = "scp_032_fr/"
-- Actual lang server
SCP_032_FR_CONFIG.LangServer = GetConVar("gmod_language"):GetString()

--[[
* Load the file set in the parameters.
* @string File The name of the file to load.
* @string directory The path of the directory to load.
--]]
local function AddFile( File, directory )
	local prefix = string.lower( string.Left( File, 3 ) )

	if SERVER and prefix == "sv_" then
		include( directory .. File )
	elseif prefix == "sh_" then
		if SERVER then
			AddCSLuaFile( directory .. File )
		end
		include( directory .. File )
	elseif prefix == "cl_" then
		if SERVER then
			AddCSLuaFile( directory .. File )
		elseif CLIENT then
			include( directory .. File )
		end
	end
end

--[[
* Allows you to load all the files in a folder.
* @string directory The path of the directory to load.
--]]
local function LoadDirectory( directory )
	directory = directory .. "/"

	local files, directories = file.Find( directory .. "*", "LUA" )

	for _, v in ipairs( files ) do
		if string.EndsWith( v, ".lua" ) then
			AddFile( v, directory )
		end
	end

	for _, v in ipairs( directories ) do
		LoadDirectory( directory .. v )
	end
end

print("SCP-032-FR Loading . . .")
    LoadDirectory(SCP_032_FR_CONFIG.RootFolder .. "config")
	LoadDirectory(SCP_032_FR_CONFIG.RootFolder .. "language")
    LoadDirectory(SCP_032_FR_CONFIG.RootFolder .. "modules")
print("SCP-032-FR Loaded!")