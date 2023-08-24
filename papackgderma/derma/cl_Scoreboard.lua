local vignette = Material("helix/gui/vignette.png")
local paper = Material("vgui/paper-01.png")
local grunge = Material("vgui/grunge.png")
local grunge2 = Material("vgui/grunge2.png")
local grunge3 = Material("vgui/grunge3.png")
local steel = Material("vgui/steele.png")
local blackpaper = Material("vgui/black-paper.png")

PANEL = {}

AccessorFunc(PANEL, "charName", "CharName")
AccessorFunc(PANEL, "charDesc", "CharDesc")
AccessorFunc(PANEL, "charModel", "CharModel")

function PANEL:Init()
	-- Add Model Icon
	-- Add Playername Label
	-- Add Player Description Label
	self.section1 = self:Add("Panel")
	self.section1:Dock(LEFT)
	self.section1:SetWide(100)
	self.section1:SetTall(self:GetTall())

	self.section2 = self:Add("Panel")
	self.section2:Dock(FILL)

	self.icon = self.section1:Add("SpawnIcon")

	self.lname = self.section2:Add("DLabel")
	self.lname:SetFont("vanillaTextFont2")
	self.lname:SetText("Invalid Name")

	self.ldesc = self.section2:Add("DLabel")
	self.ldesc:SetFont("vanillaTextFont1")
	self.ldesc:SetText("Unknown")

	self.lname:Dock(TOP)
	self.ldesc:Dock(FILL)
	self.lname:SizeToContents()
	self.ldesc:SizeToContents()
	self.ldesc:SetTall(self:GetTall()*.5)

end

function PANEL:Paint(w,h)
	surface.SetMaterial(blackpaper)
	draw.NoTexture()
	surface.SetDrawColor(0,0,0)
	draw.RoundedBox(0,0,0,w,h,Color(0,0,0,50))
	--surface.DrawOutlinedRect(0,0,w,h,2)
end

function PANEL:SetCharName(name)
	self.lname:SetText(name)
end

function PANEL:SetCharDesc(desc)
	self.ldesc:SetText(desc)
end

function PANEL:SetModel(model)
	self.icon:SetModel(model)
end

function PANEL:PerformLayout()
	self.section1:SetTall(self:GetTall())
	self.icon:SetPos(( self.section1:GetWide() / 2 ) - (self.icon:GetWide() / 2),( self.section1:GetTall() / 2 ) - (self.icon:GetTall() / 2))
end

vgui.Register("vnScoreboardItem", PANEL, "Panel")

local factions = {
	{
		["faction"] = "Citizen", 
		["members"] = { 
			{["name"] = "Bob Iger", ["desc"] = "I'm kind of a big deal, yo.",["model"]="models/Humans/Group02/Female_01.mdl"} ,
			{["name"] = "Chance Balls", ["desc"] = "it's a jewish name, you wouldn't understand",["model"]="models/Humans/Group02/Female_02.mdl"} ,
			{["name"] = "My Friend Who Doesn't Really Know How to Use Computers'", ["desc"] = "control alt delete",["model"]="models/Humans/Group02/Female_03.mdl"} 
		} 
	},
	{
		["faction"] = "Metropolice",
		["members"] = { 
			{["name"] = "CP-1", ["desc"] = "Pick up that can.",["model"]="models/Police.mdl"} ,  
			{["name"] = "CP-2", ["desc"] = "Ohana my brother. *static*",["model"]="models/Police.mdl"} ,  
			{["name"] = "CP-3", ["desc"] = "My stunstick hand is itching.",["model"]="models/Police.mdl"} 
		} 
	},
	{
		["faction"] = "Vortigaunts",
		["members"] = { 
			{["name"] = "Vorty1", ["desc"] = "Aaaaggh-la musha na..",["model"]="models/vortigaunt.mdl"} ,  
			{["name"] = "Vorty2", ["desc"] = "Galunga.",["model"]="models/vortigaunt.mdl"} ,  
			{["name"] = "Vorty3", ["desc"] = "ayo bro chiLL CHILL-",["model"]="models/vortigaunt.mdl"} 
		} 
	}

}
function Scoreboard(body)


	local panel = body:Add("EditablePanel")
	panel:Dock(FILL)
	panel:DockMargin(30,20,30,20)

	local content = panel:Add("ixScoreboard")

	return panel

end
