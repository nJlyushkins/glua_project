local items = {}

function getItem(classname)
	if items[classname] then
		return items[classname]
	end
	return false
end

function SVUseItem(classname)
	net.Start("inv_use")
	net.WriteString(classname)
	net.SendToServer()
end

function SVDropItem(classname)
	net.Start("inv_drop")
	net.WriteString(classname)
	net.SendToServer()
end

useTypes = {
	weapon = function(itemData,ply)
		ply:Give(itemData.classname)
		return true
	end,
}

function getType()
	return useTypes
end

items["fl_nichirin"] = {
	name = "Flash Nichirin",
	desc = "The legendary sword, maded by japanese blacksmith!",
	classname = "blink",
	ent = "weapon",
	prices = {
		buy = 15000,
		sell = 12500
	},
	model = "models/weapons/w_uchigatana.mdl",
	use = (function(ply,ent)
			if ply:IsValid() then
				ply:ChatPrint("FLASH NICHIRIN POWER!!!!")

				if ent then
					ent:Remove()
				end
			end
		end),
	spawn = (function(ply,ent)
			ent:SetItemName("Flash Nichirin")
		end),
	skin = 0,
	buttonDist = 100
}
items["l_nichirin"] = {
	name = "Light Nichirin",
	desc = "The legendary sword, maded by japanese blacksmith!",
	classname = "blink",
	ent = "weapon",
	prices = {
		buy = 15000,
		sell = 12500
	},
	model = "models/weapons/w_uchigatana.mdl",
	use = (function(ply,ent)
			if ply:IsValid() then
				ply:ChatPrint("LIGHT NICHIRIN POWER!!!!")
				if ent then
					ent:Remove()
				end
			end
		end),
	spawn = (function(ply,ent)
			ent:SetItemName("Flash Nichirin")
		end),
	skin = 0,
	buttonDist = 100
}
items["d_nichirin"] = {
	name = "Dark Nichirin",
	desc = "The legendary sword, maded by japanese blacksmith!",
	classname = "blink",
	ent = "weapon",
	prices = {
		buy = 15000,
		sell = 12500
	},
	model = "models/weapons/w_uchigatana.mdl",
	use = (function(ply,ent)
			if ply:IsValid() then
				ply:ChatPrint("DARK NICHIRIN POWER!!!!")
				if ent then
					ent:Remove()
				end
			end
		end),
	spawn = (function(ply,ent)
			ent:SetItemName("Flash Nichirin")
		end),
	skin = 0,
	buttonDist = 100
}
items["r_nichirin"] = {
	name = "Red Nichirin",
	desc = "The legendary sword, maded by japanese blacksmith!",
	classname = "blink",
	ent = "weapon",
	prices = {
		buy = 15000,
		sell = 12500
	},
	model = "models/weapons/w_uchigatana.mdl",
	use = (function(ply,ent)
			if ply:IsValid() then
				ply:ChatPrint("RED NICHIRIN POWER!!!!")
				if ent then
					ent:Remove()
				end
			end
		end),
	spawn = (function(ply,ent)
			ent:SetItemName("Flash Nichirin")
		end),
	skin = 0,
	buttonDist = 100
}