local cosmetics = {}

local function GetPlayerCosmetics(ply)
	local items = {}
	for id, _ in pairs(ply.PS_Items) do
 		if ply:PS_HasItemEquipped(id) then
 			table.insert(items, id)
 		end
	end
	return items
end

local function HolsterCosmetics(ply)
	local items = GetPlayerCosmetics(ply)
	if not cosmetics[ply:AccountID()] then
		table.insert(cosmetics, ply:AccountID(), items)
	end
	for _, item  in pairs(items) do
		ply:PS_HolsterItem(item)
	end
end

local function RestoreCosmetics(ply)
	local items = cosmetics[ply:AccountID()]
	if items then
		for _, item in pairs(items) do
			ply:PS_EquipItem(item)
		end
	end
	cosmetics[ply:AccountID()] = nil
end

hook.Add("TTTToggleDisguiser", "TTTDisguiserCosmetics", function(ply, disg)
	if IsValid(ply) then
		if disg then
			HolsterCosmetics(ply)
		else
 			RestoreCosmetics(ply)
		end
	end
end)

-- restore a player's cosmetics on respawn if they die while disguised
hook.Add("PlayerSpawn", "RestoreCosmeticsOnDeath", function(ply, _, _)
	RestoreCosmetics(ply)
end)

-- some cases in which people's cosmetics will have to be manually re-equipped:
-- disconnect while disguised, server restart while disguised.
-- for now i don't think it's worth worrying about.
