surface.CreateFont("vanillaHeaderFont", {
	font="Mailart Rubberstamp",
	size=ScreenScale(20)
})

surface.CreateFont("vanillaTextFont1", {
	font="Mailart Rubberstamp",
	size=ScreenScale(10)
})

surface.CreateFont("vanillaTextFont2", {
	font="Mailart Rubberstamp",
	size=ScreenScale(12)
})


include("cl_headers.lua")
include("cl_characterview.lua")

local vignette = Material("helix/gui/vignette.png")
local paper = Material("vgui/paper-01.png")
local grunge = Material("vgui/grunge.png")
local grunge2 = Material("vgui/grunge2.png")
local grunge3 = Material("vgui/grunge3.png")
local steel = Material("vgui/steele.png")
local blackpaper = Material("vgui/black-paper.png")

local PLUGIN = PLUGIN

DEFINE_BASECLASS("EditablePanel")
PANEL = {}
--[[ External Variables
local PLUGIN = {}
PLUGIN.tabs = {"Config","Settings","Scoreboard","You"}
-- end]]

AccessorFunc(PANEL, "primaryColor","PrimaryColor", FORCE_COLOR)
AccessorFunc(PANEL, "secondaryColor","SecondaryColor", FORCE_COLOR)
AccessorFunc(PANEL, "tertiaryColor","TertiaryColor", FORCE_COLOR)
AccessorFunc(PANEL, "backgroundColor","BackgroundColor", FORCE_COLOR)

function PANEL:Init()
	--self:SetPrimaryColor(Color(75,75,75))
	self:SetPrimaryColor(Color(75,75,75))
	self:SetSecondaryColor(Color(35,35,35))
	self:SetTertiaryColor(Color(128,84,18))

	--self:SetSize(ScrW()*.9, ScrH()*.9)
	self:SetSize(ScreenScale(560), ScreenScale(320))
	self:Center()
	print("Screenscale  at 1920/1080 is "..ScreenScale(20))

	self.tabs = {}
	
	for i=1, #PLUGIN.tabs, 1 do
		self.tabs[i] = {["name"]=PLUGIN.tabs[i]}
	end
	
	self.activeTab = 4

	self.anchorMode = true
	self.noAnchor = CurTime() + 0.4
	self.bClosing = false
	self.menu = self:BuildMenu()
	self.header = self:BuildHeader()
	self.body = self:BuildBody()
	self.background = vgui.Create("EditablePanel")
	self.background:SetZPos(-999)
	self.background:Dock(FILL)
	self.background.Paint = function(s,w,h)
		derma.SkinFunc("PaintMenu",s,w,h)
	end

	self:MakePopup()
end

function PANEL:OnKeyCodePressed(key)
	self.noAnchor = CurTime() + 0.5

	if key == KEY_TAB then
		self:Remove()
	end
end

function PANEL:PerformLayout()
	surface.CreateFont("vanillaHeaderFont", {
		font="Mailart Rubberstamp",
		size=ScreenScale(20)
	})
	--test
	surface.CreateFont("vanillaTextFont1", {
		font="Mailart Rubberstamp",
		size=ScreenScale(10)
	})

	surface.CreateFont("vanillaTextFont2", {
		font="Mailart Rubberstamp",
		size=ScreenScale(12)
	})
end

function PANEL:Think()
	local bTabDown = input.IsKeyDown(KEY_TAB)
	
	if (bTabDown and (self.noAnchor or CurTime() + 0.4) < CurTime() and self.anchorMode) then
		self.anchorMode = false
		surface.PlaySound("buttons/lightswitch2.wav")
	end

	if ((!self.anchorMode and !bTabDown) or gui.IsGameUIVisible()) then
		self:Remove()
	end
end

function PANEL:AddContentPanel(tab, panel)
	self.tabs[tab] = panel
end

local function doVertices(radius, centerX, centerY, startAngle, endAngle)
			local circleVertices = {}

			if startAngle < endAngle then
				for i = startAngle, endAngle, 6 do
					local tbL = #circleVertices
					local angle = math.rad(i)
					local x = centerX + math.cos(angle) * radius
					local y = centerY + math.sin(angle) * radius

					circleVertices[tbL + 1] = {x = x, y = y}
				end

			else

				for i = startAngle, 360, 0.5 do
					local tbL = #circleVertices
					local angle = math.rad(i)
					local x = centerX + math.cos(angle) * radius
					local y = centerY + math.sin(angle) * radius

					circleVertices[tbL + 1] = {x = x, y = y}

				end

				for i = 1, endAngle, 0.5 do
					local tbL = #circleVertices
					local angle = math.rad(i)
					local x = centerX + math.cos(angle) * radius
					local y = centerY + math.sin(angle) * radius

					circleVertices[tbL + 1] = {x = x, y = y}

				end

			end

			return circleVertices
	end

function PANEL:BuildHeader()

	local header = vgui.Create("Panel",self)
	header:SetSize(self:GetWide(), self:GetTall()*.1)
	header:SetPos(0,0)
	header:SetZPos(0)

	local tabwide = header:GetWide()/#self.tabs
	local overlap = 40

	for i=1,#self.tabs,1 do
		self.tabs[i]["panel"] = vgui.Create("vnHeader", header)
		self.tabs[i]["panel"]:SetPos( ((i-1) * tabwide), 0)
		self.tabs[i]["panel"]:SetSize( tabwide + overlap , header:GetTall() )
		self.tabs[i]["panel"]:SetHeaderText(self.tabs[i].name)
		self.tabs[i].content = function()
			local label = vgui.Create("DLabel")
			label:SetText("Default Content :(")
			label:SetWide(100)

			return label
		end
		self.tabs[i]["panel"].index = i
		self.tabs[i]["panel"].defaultZ = header:GetZPos() + i
		self.tabs[i]["panel"]:SetZPos(header:GetZPos() + (i))

		self.tabs[i]["panel"].activeTab = false
		if self.activeTab == i then
			self.tabs[i]["panel"].activeTab = true
		end

		--include("derma/Vanilla Testing/cl_"..self.tabs[i].name..".lua")

		local filepath = "gamemodes/ixhl2rp/plugins/papackgderma/derma/cl_"..self.tabs[i].name..".lua"

		if file.Exists(filepath, "GAME") then
			--include("gamemodes/helix/plugins/papackgderma/derma/cl_"..self.tabs[i].name..".lua")
			self.tabs[i].content = function(parent)
				return _G[self.tabs[i].name](parent)
			end
		end

	end
	return header
end

function PANEL:BuildBody()
	local body = vgui.Create("EditablePanel", self)
	body:SetPos(5,(self.menu:GetTall()*.1) + 5)
	body:SetSize(self.menu:GetWide()-10, self.menu:GetTall()*.9 - 10)
	body.Paint = function(s,w,h)
		--draw.RoundedBox(0,0,0,w,h,Color(255,255,255))
		--[[]]
	end

	--[[local label = vgui.Create("DLabel", body)
	label:SetText("Testing!")
	label:SetTextColor(Color(0,100,100))
	label:SetPos(100,100)]]

	for i=1, #self.tabs, 1 do
		if i == self.activeTab then
			
			if self.tabs[i].content then
				body.content = body:Add(self.tabs[i].content(body))
				body.content:SetSize(body:GetWide(),body:GetTall())
				if body.content.invCavas != nil then
					body.content.invCavas:Layout()
				end
				--body.content:MakePopup()
				--body.content:PerformLayout()

			end
		end
	end

	return body
end

function PANEL:BuildMenu()
	local menu = vgui.Create("EditablePanel", self)
	menu:SetSize(ScreenScale(560), ScreenScale(320))
	menu:Center()
	menu.Paint = function(s,w,h)
		draw.RoundedBox(0,0,h*.1,w,h,self.primaryColor)
		surface.SetMaterial(grunge)
		--surface.SetDrawColor(self.primaryColor.r,self.primaryColor.g,self.primaryColor.b)
		surface.DrawTexturedRect(0,h*.05,w,h)
		surface.SetDrawColor(0,0,0)
		surface.DrawOutlinedRect(0,h*.1,w,h*.9,2)
	end
	return menu
end

function PANEL:BodyLayout()
end

--[[function PANEL:PerformLayout()
	if IsValid(self.menu) then
		self.menu:Center()
	end
	--self:PopulateTabs()
end]]

function PANEL:SwitchToTab(tabIndex)

	if self.tabs[tabIndex].panel.activeTab then
		return
	end

	self.activeTab = tabIndex

	if IsValid(self.body) then
		self.body:Remove()
	end

	self.tabs[tabIndex].panel.activeTab = true
	self.tabs[tabIndex].panel:SetZPos(self.tabs[tabIndex].panel.defaultZ + 1)


	for i=1, #self.tabs, 1 do
		if i ~= tabIndex then
			self.tabs[i].panel.activeTab = false
			self.tabs[i].panel:SetZPos(self.defaultZ)
		end
	end

	self.body = self:BuildBody()
	print("ActiveTab: "..self.activeTab)
end

function PANEL:Remove()
	self.bClosing = true
	self.background:Remove()
	BaseClass.Remove(self)
end

vgui.Register("ixCMenu",PANEL,"EditablePanel")
