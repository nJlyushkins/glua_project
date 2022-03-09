function GM:ShowHelp(ply)
	ply:ConCommand("inventory")
end

util.AddNetworkString("inv_use")
util.AddNetworkString("inv_drop")

net.Receive("inv_use",function(len,ply)
	local classname = net.ReadString()
	local itemData = getItem(classname)
	if itemData then
		print(getType()[itemData.ent](itemData,ply))
	end
end)

net.Receive("inv_drop",function(len,ply)
	local classname = net.ReadString()
	local itemData = getItem(classname)
	if itemData then
		local tr = util.TraceLine({
			start = ply:EyePos(),
			endpos = ply:EyePos() + ply:EyeAngles():Forward() * 50,
			filter = ply
		})
		local itemEnt = ents.Create("prop_physics")
		itemEnt:SetPos(tr.HitPos)
		itemEnt:SetAngles(Angle(0,0,0))
		itemEnt:SetModel(itemData.model)
		itemEnt:Spawn()
		itemEnt:PhysicsInit(SOLID_VPHYSICS)
		itemEnt:SetMoveType(MOVETYPE_VPHYSICS)
		itemEnt:SetSolid(SOLID_VPHYSICS)
		itemEnt:SetUseType(SIMPLE_USE)
		itemEnt:DropToFloor()
	end
end)