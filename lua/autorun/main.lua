--
-- Fichier main.lu contenant les fonctions globales à tous les
-- autres fichiers lua.
--

print([[=======================================
Running Essential Simple Addon | v0.1
=======================================]])

--
-- Fonction exécutée à la première frame juste après le
-- lancement d'une partie.
--
local function Initialize()

	--
	-- Déclaration d'une variable Tableau globale (utilisable)
	-- par n'importe quel fichier Lua.
	--
	DroppedEnt = {}

end
hook.Add("Initialize", "ESA:Initialize", Initialize)

--
-- Fonction qui va s'exécuter à chaque fois qu'un joueur
-- tente de ramasser une entité ARME.
--
local function PlayerCanPickupWeapon(ply, wep)

	--
	-- On parcourt tout le tableau des entités jetées au sol.
	--
	for key, val in pairs(DroppedEnt) do		
		
		--
		-- Si l'ID de l'entité est stocké dans le tableau des
		-- des entités jetées au sol, on empêche le joueur de
		-- la récupérer.
		--
		if key == wep:EntIndex() then 

			--
			-- On cherche la cause du drop de l'entité ARME
			--
			if val == "death" then

				--
				-- On empêche le joueur de ramasser l'arme
				--
				return false

			elseif val == "drop"  then

				--
				-- Si le joueur a ramassé l'arme qu'il a jeté, on
				-- désactive sa suppression.
				--
				timer.Destroy("del_"..wep:EntIndex())

				--
				-- Et on supprime l'ID de la liste des entités ARMES
				-- jetées.
				--
				DroppedEnt[wep:EntIndex()] = nil
			end

		end

	end

 	--
 	-- Sinon on autorise le joueur à prendre toutes les autres entités.
 	-- 
   return true
end
hook.Add("PlayerCanPickupWeapon", "ESA:PlayerCanPickupWeapon", PlayerCanPickupWeapon)


--
-- Fonction qui va vérifier à chaque suppression d'entité, si cette dernière
-- est dans la liste des entités jetées par le joueur.
--
local function EntityRemoved(ent)

	--
	-- Pour une raison qui m'échappe, parfois EntIndex retourn -1, ce qui
	-- sert à rien, donc on sort de la fonction.
	--
	if ent:EntIndex() == -1 then return end

	--
	-- On va chercher si l'entité fait partie des entités jetées par le joueur,
	-- si c'est le cas, on la supprime du tableau.
	--
	for key, val in pairs(DroppedEnt) do
		
		if ent:EntIndex() == key then
			DroppedEnt[key] = nil
		end

	end

end
hook.Add("EntityRemoved", "ESA:EntityRemoved", EntityRemoved)

--
--
--
print("<ESA> main.lua loaded")