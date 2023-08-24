local SKIN = derma.GetNamedSkin("helix")
SKIN.fontCategoryBlur = "vanillaTextFont3"

function SKIN:PaintCategoryPanel(panel, text, color)
	text = text or ""
	color = color or ix.config.Get("color")

	surface.SetFont("vanillaTextFont2")

	local textHeight = select(2, surface.GetTextSize(text)) + 6
	local width, height = panel:GetSize()

	--surface.SetDrawColor(0, 0, 0, 100)
	--surface.DrawRect(0, textHeight, width, height - textHeight)

	--self:DrawImportantBackground(0, 0, width, textHeight, color)

	surface.SetTextColor(color_black)
	surface.SetTextPos(4, 4)
	surface.DrawText(text)

	surface.SetFont("vanillaTextFont3")
	surface.SetTextColor(color_white)
	surface.SetTextPos(4, 4)
	surface.DrawText(text)

	--surface.SetDrawColor(color)
	--surface.DrawOutlinedRect(0, 0, width, height)

	return 1, textHeight, 1, 1
end

function SKIN:PaintSettingsRowBackground(panel, width, height)

end

derma.RefreshSkins()