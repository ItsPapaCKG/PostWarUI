local health = 90
local stamina = 65
local hunger = 20
local thirst = 32

local grunge = Material("vgui/grunge.png")

PANEL = {}

AccessorFunc(PANEL,"bw", "BarWidth", FORCE_NUMBER)
AccessorFunc(PANEL,"bh", "BarHeight", FORCE_NUMBER)
AccessorFunc(PANEL,"by", "BarYStart", FORCE_NUMBER)
AccessorFunc(PANEL,"health", "Health", FORCE_NUMBER)
AccessorFunc(PANEL,"stamina", "Stamina", FORCE_NUMBER)
AccessorFunc(PANEL,"hunger", "Hunger", FORCE_NUMBER)
AccessorFunc(PANEL,"thirst", "Thirst", FORCE_NUMBER)
AccessorFunc(PANEL,"wid", "PanelWidth", FORCE_NUMBER)
AccessorFunc(PANEL,"hei", "PanelHeight", FORCE_NUMBER)
AccessorFunc(PANEL,"bw", "BarWidth", FORCE_NUMBER)
AccessorFunc(PANEL,"bh", "BarHeight", FORCE_NUMBER)
AccessorFunc(PANEL,"by", "BarY", FORCE_NUMBER)


function PANEL:Init()
	self:SetSize(200,400)
	self:Center()

	self:SetPanelWidth(self:GetWide())
	self:SetPanelHeight(self:GetTall())
	self:SetBarWidth(self:GetWide()*0.075)
	self:SetBarHeight(self:GetTall()*0.825)
	self:SetBarY(self:GetTall()*0.05)

	self:SetHealth(100)
	self:SetStamina(100)
	self:SetHunger(90)
	self:SetThirst(95)
	--[[
	self.health = 97
	self.stamina = 65
	self.hunger = 20
	self.thirst = 32
	]]

	self.Paint = function(s,w,h)
		local mat = grunge
		draw.NoTexture()
		surface.SetDrawColor(30,30,30)
		surface.DrawTexturedRect(0,0,w,h)
			surface.SetMaterial(mat)
			surface.DrawTexturedRect(0,0,1920,1080)
			surface.SetDrawColor(0,0,0)
			surface.DrawOutlinedRect(0,0,w,h,2)
	end

	local wid, hei, bw, bh, by = self.wid, self.hei, self.bw, self.bh, self.by
	local health, stamina, hunger, thirst = self.health, self.stamina, self.hunger, self.thirst
	local barsFrame = self

	self.healthbar = vgui.Create("Panel", barsFrame)
	self.healthbar:SetSize(self.bw,self.bh)
	self.healthbar:SetPos((self.wid/8)-(self.bw/2),self.by)
	self.healthbar.Paint = function(s,w,h)
		draw.RoundedBox(0,0,0,w,h,Color(255,150,150,85))
		draw.RoundedBox(0,0,h*(1-(self:GetHealth()/100)),w,h*(self:GetHealth()/100)+1,Color(150,0,0))
	end

	self.healthicon = vgui.Create("DImage", barsFrame)
	self.healthicon:SetSize(32.05,30)
	self.healthicon:SetPos((self.wid/8)-(self.healthicon:GetWide()/2), self.by + self.bh + 5)
	self.healthicon:SetImage("vgui/redcross.png")

	self.staminabar = vgui.Create("Panel", barsFrame)
	self.staminabar:SetSize(self.bw,self.bh)
	self.staminabar:SetPos((3*(self.wid/8))-(self.bw/2),self.by)
	self.staminabar.Paint = function(s,w,h)
		draw.RoundedBox(0,0,0,w,h,Color(150,150,0,85))
		draw.RoundedBox(0,0,h*(1-(self:GetStamina()/100)),w,h,Color(150,150,0))
	end

	self.staminaicon = vgui.Create("DImage", barsFrame)
	self.staminaicon:SetSize(32.05,30)
	self.staminaicon:SetPos((self.wid/8)*3-(self.staminaicon:GetWide()/2), self.by + self.bh + 5)
	self.staminaicon:SetImage("vgui/bolt.png")

	self.hungerbar = vgui.Create("Panel", barsFrame)
	self.hungerbar:SetSize(self.bw,self.bh)
	self.hungerbar:SetPos((5*(self.wid/8))-(self.bw/2),self.by)
	self.hungerbar.Paint = function(s,w,h)
		draw.RoundedBox(0,0,0,w,h,Color(126,80,40,85))
		draw.RoundedBox(0,0,h*(1-(self:GetHunger()/100)),w,h,Color(126,80,40))
	end

	self.hungericon = vgui.Create("DImage", barsFrame)
	self.hungericon:SetSize(32.05,30)
	self.hungericon:SetPos((self.wid/8)*5-(self.hungericon:GetWide()/2), self.by + self.bh + 5)
	self.hungericon:SetImage("vgui/meat.png")

	self.thirstbar = vgui.Create("Panel", barsFrame)
	self.thirstbar:SetSize(self.bw,self.bh)
	self.thirstbar:SetPos((7*(self.wid/8))-(self.bw/2),self.by)
	self.thirstbar.Paint = function(s,w,h)
		draw.RoundedBox(0,0,0,w,h,Color(0,90,206,85))
		draw.RoundedBox(0,0,h*(1-(self:GetThirst()/100)),w,h,Color(0,90,206))
	end

	self.thirsticon = vgui.Create("DImage", barsFrame)
	self.thirsticon:SetSize(32.05,30)
	self.thirsticon:SetPos((self.wid/8)*7-(self.thirsticon:GetWide()/2), self.by + self.bh + 5)
	self.thirsticon:SetImage("vgui/droplet.png")

end

function PANEL:Think()
	--[[self:SetHealth(health)
	self:SetStamina(stamina)
	self:SetHunger(hunger)
	self:SetThirst(thirst)]]

	self:SetPanelWidth(self:GetWide())
	self:SetPanelHeight(self:GetTall())
	--self:SetBarWidth(self:GetWide()*0.075)
	self:SetBarWidth(self:GetWide()*0.0375)
	self:SetBarHeight(self:GetTall()*0.825)
	self:SetBarY(self:GetTall()*0.05)
end

function PANEL:PerformLayout()
	self.healthbar:SetSize(self:GetBarWidth(),self:GetBarHeight())
	self.healthbar:SetPos((self.wid/8)-(self.bw/2),self.by)
	self.healthicon:SetSize(self:GetWide()*0.16025,self:GetWide()*0.16025*0.93603)
	self.healthicon:SetPos((self.wid/8)-(self.healthicon:GetWide()/2), self.by + self.bh + 5)

	self.staminabar:SetSize(self.bw,self.bh)
	self.staminabar:SetPos((3*(self.wid/8))-(self.bw/2),self.by)
	self.staminaicon:SetSize(self:GetWide()*0.16025,self:GetWide()*0.16025*0.93603)
	self.staminaicon:SetPos(3*(self.wid/8)-(self.staminaicon:GetWide()/2), self.by + self.bh + 5)

	self.hungerbar:SetSize(self.bw,self.bh)
	self.hungerbar:SetPos((5*(self.wid/8))-(self.bw/2),self.by)
	self.hungericon:SetSize(self:GetWide()*0.16025,self:GetWide()*0.16025*0.93603)
	self.hungericon:SetPos((self.wid/8)*5-(self.hungericon:GetWide()/2), self.by + self.bh + 5)

	self.thirstbar:SetSize(self.bw,self.bh)
	self.thirstbar:SetPos((7*(self.wid/8))-(self.bw/2),self.by)
	self.thirsticon:SetSize(self:GetWide()*0.16025,self:GetWide()*0.16025*0.93603)
	self.thirsticon:SetPos((self.wid/8)*7-(self.thirsticon:GetWide()/2), self.by + self.bh + 5)
end

vgui.Register("vnBars",PANEL,"EditablePanel")

--[[
local frame = vgui.Create("DFrame")
frame:SetSize(1000,1000)
frame:Center()
frame:MakePopup()

local bars = vgui.Create("vnBars",frame)
--bars:SetSize(200,700)
bars:SetPos(50,50)
]]