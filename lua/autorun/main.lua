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
	EntOwners = {}

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
	for key, val in pairs(EntOwners) do		
		
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
				EntOwners[wep:EntIndex()] = nil
			end

		end

	end

 	--
 	-- Sinon on autorise le joueur à prendre toutes les autres entités.
 	-- 
   return true
end
hook.Add("PlayerCanPickupWeapon", "ESA:PlayerCanPickupWeapon", PlayerCanPickupWeapon)