function Settings(body)
	local container = vgui.Create("Panel")
	container:Dock(FILL)
	container:DockMargin(30,20,30,20)

	--container:SetSize(body:GetWide(), body:GetTall())
	--container:SetPos(0,0)

	--container:SetTitle(L("settings"))

	local panel = container:Add("ixSettings")
	panel:SetSearchEnabled(true)

	for category, options in SortedPairs(ix.option.GetAllByCategories(true)) do
		category = L(category)
		panel:AddCategory(category)

		-- sort options by language phrase rather than the key
		table.sort(options, function(a, b)
			return L(a.phrase) < L(b.phrase)
		end)

		for _, data in pairs(options) do
			local key = data.key
			local row = panel:AddRow(data.type, category)
			local value = ix.util.SanitizeType(data.type, ix.option.Get(key))

			row:SetText(L(data.phrase))
			row:Populate(key, data)

			-- type-specific properties
			if (data.type == ix.type.number) then
				row:SetMin(data.min or 0)
				row:SetMax(data.max or 10)
				row:SetDecimals(data.decimals or 0)
			end

			row:SetValue(value, true)
			row:SetShowReset(value != data.default, key, data.default)
			row.OnValueChanged = function()
				local newValue = row:GetValue()

				row:SetShowReset(newValue != data.default, key, data.default)
				ix.option.Set(key, newValue)
			end

			row.OnResetClicked = function()
				row:SetShowReset(false)
				row:SetValue(data.default, true)

				ix.option.Set(key, data.default)
			end

			row:GetLabel():SetHelixTooltip(function(tooltip)
				local title = tooltip:AddRow("name")
				title:SetImportant()
				title:SetText(key)
				title:SizeToContents()
				title:SetMaxWidth(math.max(title:GetMaxWidth(), ScrW() * 0.5))

				local description = tooltip:AddRow("description")
				description:SetText(L(data.description))
				description:SizeToContents()
			end)
		end
	end

	panel:SizeToContents()
	container.panel = panel

	return container
end
