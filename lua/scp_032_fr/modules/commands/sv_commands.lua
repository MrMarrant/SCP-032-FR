-- Cheat command
concommand.Add("scp_032fr_set_ammo", function(ply, cmd, args, argStr)
    if (ply:IsAdmin() or ply:IsSuperAdmin()) then
        local ammoType = tonumber(args[1])
        local gun = ply:GetActiveWeapon()
        print("Ammos available, select a key : ")
        PrintTable(SCP_032_FR_CONFIG.KeyAmmoType)
        if (SCP_032_FR_CONFIG.KeyAmmoType[ammoType] and IsValid(gun) and gun:GetClass() == "scp_032_fr_gun") then
            scp_032_fr.SetAmmoType(ply, gun, ammoType)
            ply:ChatPrint("Ammo type set successfully to " .. ammoType .. ".")
        else
            ply:ChatPrint("Invalid ammo type or you are not holding the SCP-032FR gun.")
        end
    else
        ply:ChatPrint("You need to be admin/superadmin for using this command.")
    end
end, nil, "Set the ammo type of the SCP-032FR you are holding. Usage : scp_032fr_set_ammo <ammoType>")
