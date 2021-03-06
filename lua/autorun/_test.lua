--
-- Fichier réservé aux tests expérimentaux.
--

-- PrintMessage(HUD_PRINTTALK, ply:GetEyeTrace().Entity:EntIndex())

hook.Add( "PlayerSay", "c_TetstCmd", function(ply, text, public)
	
	text = string.lower(text)

	if string.sub(text, 1) == ".test" then
			
		for key, value in pairs(DroppedEnt) do 
			PrintMessage(HUD_PRINTTALK, key.." on "..value) 
		end

		return false
	end
end)

hook.Add( "PlayerSay", "c_ResetCmd", function(ply, text, public)
	
	text = string.lower(text)

	if string.sub(text, 1) == ".reset" then

		DroppedEnt = {}

		return false
	end
end)

hook.Add( "PlayerSay", "chatSounds", function(ply, text, public)
	
	local Sounds = {
		Sound("npc_barney.ba_laugh02"),  			-- haha
		Sound("*vo/npc/male01/help01.wav"),			-- help
		Sound("*vo/npc/male01/abouttime01.wav"),	-- about time too
		Sound("NPC_Stalker.Hit")					-- punch
	}

	text = string.lower(text)

	if string.sub(text, 1) == "haha" then

		for k,v in pairs(player.GetAll()) do
			v:EmitSound(Sounds[1])
		end		
	end

	if string.sub(text, 1) == "help" then

		for k,v in pairs(player.GetAll()) do
			v:EmitSound(Sounds[2])
		end		
	end

	if string.sub(text, 1) == "about time" then

		for k,v in pairs(player.GetAll()) do
			v:EmitSound(Sounds[3])
		end		
	end

	if string.sub(text, 1) == "punch" then

		for k,v in pairs(player.GetAll()) do
			v:EmitSound(Sounds[4])
		end		
	end

end)




---------------------------------------------------------------------
---------------------------------------------------------------------
--
--			ZONE DANGEREUSE !!
--
---------------------------------------------------------------------
---------------------------------------------------------------------

-- local function PlayerUse(ply, ent)
	
-- 	print("USE")
-- 	-- local AimedWeapon = ply:GetEyeTrace():GetEntity():GetClass()

-- 	return true	
-- end
-- hook.Add("PlayerUse", "PlayerUse", PlayerUse)

-- hook.Add( "Tick", "ESA:KeyDownUse", function(ply)

-- 	print(ply:Nick())

-- end)

local function KeyPress(ply, key)


	if (key == IN_USE) then

		local ent = ply:GetEyeTrace().Entity

		if ent:IsWeapon() && !ply:HasWeapon(ent:GetClass()) then
			ply:Give(ent:GetClass())
		end

	end	

		-- local ent =  ply:GetEyeTrace().Entity

		-- if ent:IsWeapon() && !ply:HasWeapon(ent:GetClass()) then
		--     ply:Give(ent:GetClass())
		-- end	



		
		-- if ent:IsWeapon() and !ply:HasWeapon(ent:GetClass()) then
		-- 	ply:Give(ent:GetClass())
		-- 	print("Tried to get : "..ent:GetClass())
		-- 	DroppedEnt[ent:EntIndex()] = nil
		-- 	ent:Remove()
		-- end

		

	
end
hook.Add("KeyPress", "KeyPress", KeyPress)

print("<ESA> _test.lua loaded.")