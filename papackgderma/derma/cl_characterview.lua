print("\n\nCHARACTERVIEW LOADED\n\n")

PANEL = {}

function PANEL:Init()
	self:SetCamPos(Vector(70,0,50))
	self:SetModel(LocalPlayer():GetModel())

	self:SetLookAt(Vector(0,0,40))
	self:SetFOV(39)
	--25 originally
	--self:SetSize(200,200)

	--self:GetEntity():SetSequence("idle")
	self:SetAnimated(true)
end

function PANEL:Think()
	if self:IsHovered() then
		self:SetCursor("none")
	end
end

function PANEL:LayoutEntity(ent)
	--ent:FrameAdvance()
end

--[[
function PANEL:LayoutEntity(ent)
	return
end]]

vgui.Register("vnCharacterView", PANEL, "ixModelPanel")
