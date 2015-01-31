--------------------------------------------------------
-- Fichier DROP, concerne tout ce qui est en rapport 
-- avec la possibilité de jeter ses armes.
--------------------------------------------------------

--
-- Définit en secondes combien de temps les armes jetées restent au sol
-- avant d'être supprimées.
--
local WEAPON_STAY_DURATION = 60

--
-- Fonction qui permet de jeter l'arme portée actuellement
-- par le joueur.
--
local function dropWeapon(ply)

	--
	-- On prépare la variable qui contiendra notre entité ARME
	--
	local Weapon = ply:GetActiveWeapon()

	--
	-- Il semblerait que le modèle de toutes les armes disparaissent 
	-- si on jette l'arme weapon_fists, elle est donc exclue.
	--
	if Weapon:GetClass() == "weapon_fists" then return end

		--
		-- On stocke l'ID de l'entité ARME jetée.
		-- Les autres informations servent au Debug.
		DroppedEnt[Weapon:EntIndex()] = "drop"

		--
		-- Affichage des informations de Debug dans la console.
		--			
		print("<ESA> Player "..ply:Nick().." (#"..ply:EntIndex()..") dropped "..Weapon:GetClass().." (#"..Weapon:EntIndex()..") from drop cmd")		

		--
		-- On jette l'arme portée par le joueur.
		--
		ply:DropWeapon(Weapon)

		--
		-- Puis on crée un timer qui supprimera l'arme jetée que portait
		-- le joueur au moment où il est mort.
		--
		timer.Create("del_"..Weapon:EntIndex(), WEAPON_STAY_DURATION, 1, function() 

		--
		-- On vérifie que l'arme est une entité valide et qu'elle 
		-- existe avant de la supprimer.
		--
		if Weapon:IsValid() then

			--
			-- On supprime l'entité ARME à la fin du timer.
			--
			Weapon:Remove()
		end

	end)	
end

--
-- On ajoute la commande "drop" à la console.
--
concommand.Add("drop", function(ply, cmd)

	--
	-- On exécute la fonction qui va jeter l'arme lors qu'on entre
	-- la commande "drop" dans la console.
	--
	dropWeapon(ply)
end)

--
-- Ajout du hook qui exécutera le code qu'il contient lorsque
-- le joueur va envoyer un message dans le Chat.
--
hook.Add("PlayerSay", "c_DropCmd", function(ply, text, public)
	
	--
	-- On met le texte en minuscules pour éviter les problèmes de
	-- reconnaissance de caractères.
	--
	text = string.lower(text)
	
	--
	-- On vérifie si le message contient uniquement une commande et
	-- rien d'autre, sinon on ne fait rien.
	--
	if string.sub(text, 1) == ".drop" or string.sub(text, 1) == ".d" then

		--
		-- Et on exécute la fonction qui va jeter l'arme portée.
		--
		dropWeapon(ply)

		--
		-- On empêche la commande de s'afficher dans le Chat public.
		--
		return false
	end
end )

--
-- Affichage du message de chargement dans la console.
--
print("<ESA> drop.lua loaded.")
