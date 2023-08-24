local PANEL = {}

function PANEL:Paint(width, height)
	derma.SkinFunc("PaintCategoryPanel", self, self.text, self.color)

end

--vgui.Register("ixCategoryPanel", PANEL, "ixCategoryPanel")
