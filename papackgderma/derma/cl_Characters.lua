function Characters(container)
		local canvas = container:Add("DTileLayout")
		local canvasLayout = canvas.PerformLayout
		canvas.PerformLayout = nil -- we'll layout after we add the panels instead of each time one is added
		canvas:SetBorder(0)
		canvas:SetSpaceX(2)
		canvas:SetSpaceY(2)
		canvas:Dock(FILL)
		canvas:SetTall(container:GetTall() / 2 - 10 + ScreenScale(12))

		ix.gui.menuInventoryContainer = canvas

		local panel = canvas:Add("ixInventory")
		panel:SetPos(0, 0)
		panel:SetDraggable(false)
		panel:SetSizable(false)
		panel:SetTitle(nil)
		panel.bNoBackgroundBlur = true
		panel.childPanels = {}

		local inventory = LocalPlayer():GetCharacter():GetInventory()

		if (inventory) then
			panel:SetInventory(inventory)
		end

		ix.gui.inv1 = panel
		local frame = vgui.Create("DFrame")
		frame:SetSize(500,500)
		frame:SetPos(500,500)
		frame:MakePopup()

		ix.gui.menuInventoryContainer = frame

		if (ix.option.Get("openBags", true)) then
			for _, v in pairs(inventory:GetItems()) do
				if (!v.isBag) then
					continue
				end

				v.functions.View.OnClick(v)
			end
		end

		canvas.PerformLayout = canvasLayout
		canvas:Layout()
		return canvas
end