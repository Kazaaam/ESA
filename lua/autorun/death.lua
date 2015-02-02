--------------------------------------------------------
-- Fichier DEATH, concerne tout ce qui est en rapport 
-- avec la mort du joueur.
--------------------------------------------------------

--
-- Définit le nombre maximum d'armes jetées lors de la mort du joueur.
-- Evite de générer beaucoup de lag si le joueur porte beaucoup d'armes.
--
-- Au-delà de 30 armes pouvant être jetées simultanément, le jeu commence
-- à lagger pour tous les joueurs présents sur le serveur.
--
-- Ne pas augmenter ce nombre, sauf si vous savez ce que vous faites.
--
local MAX_DROPPED_WEAPONS  = 50

--
-- Définit en secondes combien de temps les armes jetées restent au sol
-- avant d'être supprimées.
--
local WEAPON_STAY_DURATION = 60

--
-- On met en cache tous les sons de morts.
--
local MaleDeathSounds = { 
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

local FemaleDeathSounds = {
	Sound("*vo/npc/female01/pain02.wav"),
	Sound("*vo/npc/female01/pain03.wav"),
	Sound("*vo/npc/female01/pain04.wav"),
	Sound("*vo/npc/female01/pain05.wav"),
	Sound("*vo/npc/female01/pain06.wav"),
	Sound("*vo/npc/female01/pain07.wav"),
	Sound("*vo/npc/female01/pain08.wav"),
	Sound("*vo/npc/female01/pain09.wav"),
	Sound("npc_alyx.hurt04"),
	Sound("npc_alyx.hurt05"),
	Sound("npc_alyx.hurt06"),
	Sound("npc_alyx.hurt08")
}

--
-- On sélectionne les noms des modèles féminins.
--
local FemaleModels = {
	"alyx",
	"chell",
	"female",
	"medic10",
	"medic11",
	"medic12",
	"medic13",
	"medic14",
	"medic15",	
	"mossman"
}

--
-- Fonction qui va jouer le son de la mort 
--
local function PlayDeathSound(ply)

	--
	-- Par défaut on détermine le modèle du joueur à MALE.
	--
	local genre = "male" -- par défaut

	--
	-- On vérifie si le modèle du joueur est féminin ou masculin.
	--
	for key, val in pairs(FemaleModels) do
		
		if string.match(ply:GetModel(), val) then
			genre = "female"
		end

	end

	--
	-- Selon le sexe du modèle du joueur, on joue le son approprié.
	--
	if genre == "female" then

		--
		-- On sélectionne un nombre aléatoire afin de jouer un son
		-- différent à chaque mort.
		--
		rndSound = math.random(1, 12)

		--
		-- Et on joue le son.
		--
		ply:EmitSound(FemaleDeathSounds[rndSound])
	else
	    rndSound = math.random(1, 18)
		ply:EmitSound(MaleDeathSounds[rndSound])
	end

end

--
-- On exécute le script suivant lorsque le joueur meurt.
--
local function DoPlayerDeath(ply, attacker, dmg)

	
	PlayDeathSound(ply)

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
		-- On stocke les ID des entités des armes jetées, pour savoir
		-- quelles entités le joueur peut ramasser ou non.
		-- Les autres informations servent simplement au Debug.
		--
		-- Sert à vérifier si une arme jetée au sol a bien été supprimée ou non.
		--
		DroppedEnt[Weapon:EntIndex()] = "death"

		--
		-- Affichage des informations de Debug dans la console.
		--
		print("<ESA> Player "..ply:Nick().." (#"..ply:EntIndex()..") dropped "..Weapon:GetClass().." (#"..Weapon:EntIndex()..") from death")	

		--
		-- Dans un premier temps on jette l'arme que le joueur porte.
		--
		ply:DropWeapon(Weapon)

		--
		-- Puis on crée un timer qui supprimera l'arme jetée que portait
		-- le joueur au moment où il est mort.
		--
		timer.Create("del_"..Weapon:EntIndex(), WEAPON_STAY_DURATION, 1, function() 

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
			-- On stocke les ID des entités des armes jetées, pour savoir
			-- quelles entités le joueur peut ramasser ou non.
			-- On stocke la cause du drop en valeur du tableau. 
			--
			DroppedEnt[wep:EntIndex()] = "death"

			--
			-- Affichage des informations de Debug dans la console.
			--			
			print("<ESA> Player "..ply:Nick().." (#"..ply:EntIndex()..") dropped "..wep:GetClass().." (#"..wep:EntIndex()..") from death")		

			--
			-- On jette également les armes non visibles à l'écran.
			--
			ply:DropWeapon(wep)

			--
			-- Désactivation des collisions sur les armes afin d'éviter le lag.
			--
			wep:SetCollisionGroup(COLLISION_GROUP_WORLD)

			--
			-- On modifie le poids des armes pour que la chute soit plus réaliste.
			--
			wep:GetPhysicsObject():SetMass(300)

			--
			-- Sans oublier le timer qui supprimera toutes les armes au sol.
			--
			timer.Create("del_"..wep:EntIndex(), WEAPON_STAY_DURATION, 1, function() 

				if wep:IsValid() then

					--
					-- On supprime l'entité ARME à la fin du timer.
					--
					wep:Remove()
				end

			end)

			--
			-- Si on atteint le nombre maximum autorisé d'armes jetées 
			-- simultanément, on sort de la boucle pour arrêter de jeter
			-- des armes.
			--
			if key == MAX_DROPPED_WEAPONS then return end
				
		end

	end	

end
hook.Add("DoPlayerDeath", "ESA:DoPlayerDeath", DoPlayerDeath)

--
-- Suppression du son par défaut de la mort (beep-beeeep-beee...)
--
local function PlayerDeathSound()

	--
	-- false = on garde le son | true = on supprime le son.
	--
	return true
end 
hook.Add("PlayerDeathSound", "ESA:PlayerDeathSound", PlayerDeathSound)

--
-- Affichage du message de chargement dans la console.
--
print("<ESA> death.lua loaded")
