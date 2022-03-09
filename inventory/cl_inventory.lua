local inventory = {}
inventory["fl_nichirin"] = 5
inventory["l_nichirin"] = 2
inventory["d_nichirin"] = 91
inventory["r_nichirin"] = 162

local invOpen = false

local w = 280
local h = 500

local invPanel = vgui.Create("DFrame")
invPanel:SetSize(w+100,h)
invPanel:SetPos(ScrW()-100,ScrH()/2-(h/2))
invPanel:SetTitle("")
invPanel:SetDraggable(false)
invPanel:ShowCloseButton(false)
invPanel.Paint = function()
	return
end

local invBtn = vgui.Create("DImageButton",invPanel)
invBtn:SetSize(100,100)
invBtn:SetPos(0,h/2)
invBtn:SetImage("backpack_icon.png")
function invBtn:DoClick()
	openInv()
end
function invBtn:Paint(width,height)
	draw.RoundedBox(8,0,0,width,height,Color(50,50,50,100))
end

function inventoryTable()
	return inventory
end

function inventorySave(inv)
	inventory = inv
end

function inventoryHasItem(classname, amount)
	if not amount then amount = 1 end
	local i = inventoryTable()
	if i then
		if i[classname] then
			if i[classname] >= amount then
				return true
			else
				return false
			end
		else
			return false
		end
	else
		return false
	end
end

local SKINS = {}
SKINS.COLORS = {
	lightgrey = Color(131,131,131,180),
	grey = Color(100,100,100,180),
	darkwhite = Color(240,240,240,180),
	white = Color(255,255,255,180),
	black = Color(41,41,41,180)
}

function SKINS:DrawFrame(w,h)
	topHeight = 24
	local rounded = 4
	draw.RoundedBoxEx(rounded,0,0,w,topHeight,SKINS.COLORS.grey,true,true,false,false)
	draw.RoundedBoxEx(rounded,0,topHeight,w,h-topHeight,SKINS.COLORS.grey,false,false,true,true)
	draw.RoundedBoxEx(rounded,2,topHeight,w-4,h-topHeight-2,SKINS.COLORS.black,false,false,true,true)
end

local function inventoryItemButton(classname, name ,amount, desc, model, parent, dist, buttons)
	if not dist then dist = 128 end
	local p = vgui.Create("DPanel",parent)
	p:SetPos(4,4)
	p:SetSize(85,85)
	p:SetBackgroundColor(Color(255,255,255,180))
	p.Paint = function()
		draw.RoundedBox(8,0,0,p:GetWide(),p:GetTall(),Color(255,255,255,180))
	end

	local mp = vgui.Create("DModelPanel",p)
	mp:SetSize(p:GetWide(),p:GetTall())
	mp:SetPos(0,0)
	mp:SetModel(model)
	mp:SetAnimSpeed(0.15)
	mp:SetAnimated(true)
	mp:SetAmbientLight(Color(50,50,50))
	mp:SetDirectionalLight(BOX_TOP,Color(255,255,255))
	mp:SetCamPos(Vector(dist,dist,dist))
	mp:SetLookAt(Vector(0,0,0))
	mp:SetFOV(20)
	function mp:LayoutEntity(ent)
		self:RunAnimation()
		ent:SetSkin(getItem(classname).skin or 0)
		ent:SetAngles(Angle(0,0,0))
	end

	local b = vgui.Create("DButton",p)
	b:SetPos(0,0)
	b:SetSize(85,85)
	b:SetText("")
	b:SetToolTip(name..":\n\n"..desc)
	b.DoClick = function()
			local opt = DermaMenu()
			for k,v in pairs(buttons) do
				opt:AddOption(k,v)
			end
			opt:Open()
		end
	b.DoRightClick = function()
			--pass
		end
	function b:Paint()
		return true
	end

	if amount then
		local l = vgui.Create("DLabel",p)
		l:SetPos(6,4)
		l:SetFont("default")
		l:SetTextColor(Color(100,100,100,255))
		l:SetText(amount)
		l:SizeToContents()
	end

	return p
end

local f = vgui.Create("DFrame",invPanel)
f:SetParent(invPanel)
f:SetPos(ScrW()-w,ScrH()/2-(h/2))
f:SetSize(w,h)
f:SetTitle("Инвентарь")
f:SetDraggable(false)
f:ShowCloseButton(false)
f:MakePopup()
f.Paint = function()
	f:SetPos(invPanel:GetX()+100,invPanel:GetY())
	SKINS:DrawFrame(f:GetWide(),f:GetTall())
end

local ps = vgui.Create("DPropertySheet",f)
ps:SetPos(0,20)
ps:SetSize(w,h-20)
ps.Paint = function()
	return
end
local padding = 5

local function ItemUpdate()
	local inv = inventoryTable()
	local items = vgui.Create("DPanelList",ps)
	items:SetPos(padding,padding)
	items:SetSize(w,h-20)
	items:SetPadding(padding)
	items:SetSpacing(padding)
	items:EnableHorizontal(true)
	function items:Paint()
		return
	end
	print(table.Count(items:GetItems()))
	for k,v in pairs(inv) do
		local i = getItem(k)
		if i and v > 0 then
			local buttons = {}
			buttons["Use"] = (function()
				i.use(LocalPlayer())
				SVUseItem(k)
				inv[k] = inv[k] - 1
				inventorySave(inv)
				items:Remove()
				ItemUpdate()
			end)
			buttons["Drop"] = (function()
				SVDropItem(k)
				inv[k] = inv[k] - 1
				inventorySave(inv)
				items:Remove()
				ItemUpdate()
			end)
			local b = inventoryItemButton(k,i.name.."("..v..")",v,i.desc,i.model,items,i.buttonDist,buttons)
			items:AddItem(b)
		end
	end
end

ItemUpdate()

local invMenu = nil

f:SetVisible(false)

function openInv()
	if invOpen then
		invPanel:MoveTo(ScrW()-100,ScrH()/2-(h/2),1,0,1,function()
			invOpen=false
		end)
		f:SetVisible(false)
	else
		f:SetVisible(true)
		invPanel:MoveTo(ScrW()-100-w,(ScrH()/2)-(h/2),1,0,1,function()
			invOpen = true
		end)
	end
end

concommand.Add("inventory",openInv)