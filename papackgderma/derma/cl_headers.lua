PANEL = {}

DEFINE_BASECLASS("DButton")

AccessorFunc(PANEL, "color", "Color", FORCE_COLOR)
AccessorFunc(PANEL, "headerText", "HeaderText")

local vignette = Material("helix/gui/vignette.png")
local paper = Material("vgui/paper-01.png")
local grunge = Material("vgui/grunge.png")
local grunge2 = Material("vgui/grunge2.png")

function PANEL:Init()
	self.activeTab = false
	self.color = Color(45,45,45)
	self.activeColor = Color(75,75,75)
	self.switchTo = false

	self:SetText("")

	self:SetHeaderText("Default")

	self:SetSize(10,10)
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

function PANEL:Paint(w,h)
	local rx = h / 3
	local x = h
	local ry = h / 3
	local y = h

	local color
	if self.activeTab then
		color = self.activeColor
	else
		color = self.color
	end


	local r = color.r
	local g = color.g
	local b = color.b
	local a = color.a

	--[[
	local circleVertices = doVertices(rx, rx, ry, 180, 270)
	local secondVertices = doVertices(rx, w - rx, ry, 270, 359)
	for i=1,#secondVertices,1 do
		circleVertices[#circleVertices + 1] = secondVertices[i]
	end

	--circleVertices[#circleVertices + 1] = {x=w,y=0}
	circleVertices[#circleVertices + 1] = {x=w,y=h}
	circleVertices[#circleVertices + 1] = {x=0,y=h}
	]]
	local mat = grunge2

	if self.circleVertices != nil then
		draw.NoTexture()
		surface.SetDrawColor(r,g,b,a)
		surface.DrawPoly(self.circleVertices)
		surface.SetFont("vanillaHeaderFont")
	end

	local textwide, texttall = surface.GetTextSize(self.headerText)

	surface.SetTextColor(255,255,255)
	surface.SetTextPos(self:GetWide()*.5 - (textwide*.5), self:GetTall()*.5 - (texttall*.5))
	surface.DrawText(self.headerText)

end

function PANEL:PerformLayout(w,h)
	local rx = h / 3
	local x = h
	local ry = h / 3
	local y = h

	local color
	if self.activeTab then
		color = self.activeColor
	else
		color = self.color
	end

	self.circleVertices = doVertices(rx, rx, ry, 180, 270)
	self.secondVertices = doVertices(rx, w - rx, ry, 270, 359)
	for i=1,#self.secondVertices,1 do
		self.circleVertices[#self.circleVertices + 1] = self.secondVertices[i]
	end

	self.circleVertices[#self.circleVertices + 1] = {x=w,y=h}
	self.circleVertices[#self.circleVertices + 1] = {x=0,y=h}

end

function PANEL:DoClick()
	self:GetParent():GetParent():SwitchToTab(self.index)
end

vgui.Register("vnHeader",PANEL,"DButton")