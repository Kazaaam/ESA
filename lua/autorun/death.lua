--------------------------------------------------------
-- Fichier DEATH, concerne tout ce qui est en rapport 
-- avec la mort du joueur.
--------------------------------------------------------

--
-- Définit le nombre maximum d'armes jetées lors de la mort du joueur.
-- Evite de générer beaucoup de lag si le joueur porte beaucoup d'armes.
--
-- Au-delà de 15 armes pouvant être jetées simultanément, le jeu commence
-- à lagger pour tous les joueurs présents sur le serveur.
--
-- Ne pas augmenter ce nombre, sauf si vous savez ce que vous faites.
--
local MAX_DROPPED_WEAPONS  = 15 

--
-- Définit en secondes combien de temps les armes jetées restent au sol
-- avant d'être supprimées.
--
local WEAPON_STAY_DURATION = 15

--
-- On met en cache tous les sons de morts.
--
local DeathSound = { 
	Sound("npc_barney.ba_pain01"),
	Sound("npc_barney.ba_pain02"),
	Sound("npc_barney.ba_pain03"),
	Sound("npc_barney.ba_pain04"),
	Sound("npc_barney.ba_pain05"),
	Sound("npc_barney.ba_pain06"),
	Sound("npc_barney.ba_pain07"),
	Sound("npc_barney.ba_pain08"),
	Sound("npc_barney.ba_pain09"),
	Sound("npc_barney.ba_pain10"),
	Sound("*vo/npc/male01/pain02.wav"),
	Sound("*vo/npc/male01/pain03.wav"),
	Sound("*vo/npc/male01/pain04.wav"),
	Sound("*vo/npc/male01/pain05.wav"),
	Sound("*vo/npc/male01/pain06.wav"),
	Sound("*vo/npc/male01/pain07.wav"),
	Sound("*vo/npc/male01/pain08.wav"),
	Sound("*vo/npc/male01/pain09.wav")
}

--
-- On exécute le script suivant lorsque le joueur meurt.
--
local function DoPlayerDeath(ply, attacker, dmg)

	--
	-- On sélectionne aléatoirement un nombre afin de jouer un 
	-- son différent à chaque mort, 18 étant le nombre maximum 
	-- de sons en cache.
	--
	rndSound = math.random(1, 18)

	--
	-- On sélectionne le son en cache et on le joue selon le 
	-- nombre aléatoire généré.
	--
	ply:EmitSound(DeathSound[rndSound])

	--
	-- On vérifie que l'arme que porte le joueur est jetable :
	-- qu'il n'a pas les mains vides, ou qu'il porte quelque
	-- chose de spécial qui ne peut pas être jeté et qui pourrait
	-- produire un bug si on tente de lui faire lâcher.
	--
	if(ply:GetActiveWeapon():IsValid()) then
	
		--
		-- On prépare la variable qui contiendra notre entité ARME.
		--
		local Weapon = ply:GetActiveWeapon()

		--
		-- Il semblerait que le modèle de toutes les armes disparaissent 
		-- si on jette l'arme weapon_fists, elle est donc exclue.
		--
		if Weapon:GetClass() == "weapon_fists" then return end

		--
		-- Dans un premier temps on jette l'arme que le joueur porte.
		--
		ply:DropWeapon(Weapon)			

		--
		-- Puis on crée un timer qui supprimera l'arme jetée que portait
		-- le joueur au moment où il est mort.
		--
		timer.Create( "del_"..Weapon:EntIndex(), WEAPON_STAY_DURATION, 1, function() 

			if Weapon:IsValid() then
				--
				-- On supprime l'entité ARME à la fin du timer.
				--
				Weapon:Remove()
			end

		end)
			
		--
		-- On peut aussi faire en sorte que toutes les autres armes du
		-- joueur soient jetées. Mais pour ça il faut parcourir tout son
		-- inventaire et sélectionner les armes une à une pour les jeter.
		--
		for key, wep in pairs(ply:GetWeapons()) do							

			--
			-- On jette également les armes non visibles à l'écran.
			--
			ply:DropWeapon(wep)

			--
			-- Sans oublier le timer qui supprimera toutes les armes au sol.
			--
			timer.Create( "del_"..wep:EntIndex(), WEAPON_STAY_DURATION, 1, function() 
				if wep:IsValid() then
					wep:Remove()
				end
			end)

			--
			-- Si on atteint le nombre maximum autorisé d'armes jetées 
			-- simultanément, on sort de la boucle.
			--
			if key == MAX_DROPPED_WEAPONS then return end
				
		end

	end	


end

--
-- On ajoute un hook "DoPlayerDeath" dans le jeu, qui exécutera
-- la fonction DoPlayerDeath ci-dessus à chaque mort d'un joueur.
--
hook.Add("DoPlayerDeath", "DoPlayerDeath", DoPlayerDeath)


--
-- Suppression du son par défaut de la mort (beep-beeeep-beee...)
--
local function PlayerDeathSound()

	--
	-- false = on garde le son | true = on supprime le son.
	--
	return true
end 

--
-- On ajoute le hook "PlayerDeathSound" qui exécutera la fonction
-- PlayerDeathSound à chaque mort du joueur.
--
hook.Add("PlayerDeathSound", "PlayerDeathSound", PlayerDeathSound)

--
-- Affichage du message de chargement dans la console.
--
print("-- ESA: death.lua loaded.")
