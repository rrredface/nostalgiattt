local disguisemodels = { -- Add playermodels to disguise as here.
"models/player/arctic.mdl",
"models/player/guerilla.mdl",
"models/player/leet.mdl",
"models/player/phoenix.mdl"
}

local models = {} -- for remembering players' equipped models

hook.Add("TTTToggleDisguiser", "TTTDisguiserCosmetics", function(ply, disg)
	if IsValid(ply) then
		if disg then
			table.insert(models, ply:UserID(), ply:GetModel())
			math.randomseed(os.time())
			ply:SetModel(disguisemodels[math.random(#disguisemodels)])
			for id, item in pairs(ply.PS_Items) do
				if item.Equipped then
					local ITEM = PS.Items[id]
					ITEM:OnHolster(ply, item.Modifiers)
				end
			end
		else
			local mdl = models[ply:UserID()]
			if mdl then
				ply:SetModel(mdl)
			end
			for id, item in pairs(ply.PS_Items) do
				if item.Equipped then
					local ITEM = PS.Items[id]
					ITEM:OnEquip(ply, item.Modifiers)
				end
			end
		end
	end
end)
