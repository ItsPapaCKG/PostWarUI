include("cl_characterview.lua")
include("cl_bars.lua")

function You(body)
	local MOTD = ix.data.Get("ServerMOTD",false,true,false,true)
	MOTD = util.JSONToTable(MOTD)

	local name = LocalPlayer():GetCharacter():GetName()
	local tokens = "Tokens: "..LocalPlayer():GetCharacter():GetMoney()
	local cid = "CID: "..LocalPlayer():GetCharacter():GetData("cid")
	local description = LocalPlayer():GetCharacter():GetDescription()
	local servername = MOTD.servername or ""
	local serverip = MOTD.serverip or ""
	local messageotd = MOTD.motd or ""
	local serverrumor = MOTD.rumor or ""
	local Timestamp = os.time()
	local TimeString = os.date( "%H:%M:%S - %d/%m/%Y" , Timestamp )
	local health = LocalPlayer():GetCharacter():GetData("health") or 0
	local stamina = LocalPlayer():GetCharacter():GetData("stamina") or 0
	local hunger = --[[LocalPlayer():GetHunger() or]] 0
	local thirst = --[[LocalPlayer():GetThirst() or]] 0

	local vignette = Material("helix/gui/vignette.png")
	local paper = Material("vgui/paper-01.png")
	local blackpaper = Material("vgui/black-paper.png")
	local grunge = Material("vgui/grunge.png")
	local grunge2 = Material("vgui/grunge2.png")

	local function inventoryLoad(container, bodyparent)

		local panel = container:Add("ixInventory")
		surface.SetFont("vanillaTextFont1")
		local _, th = surface.GetTextSize("Inventory")

		panel:SetIconSize(ScreenScale(18))
		panel:SetDraggable(false)
		panel:SetSizable(false)
		panel:SetTitle(nil)
		panel:CenterHorizontal()
		panel.bNoBackgroundBlur = true
		panel.childPanels = {}

		local canvas = container:Add("DTileLayout")
		local canvasLayout = canvas.PerformLayout
		canvas.PerformLayout = nil -- we'll layout after we add the panels instead of each time one is added
		canvas:SetBorder(0)
		canvas:SetSpaceX(2)
		canvas:SetSpaceY(2)
		canvas:Dock(BOTTOM)
		canvas:SetTall(container:GetTall() / 3 - 10 - ScreenScale(18))
		canvas:SetWide(500)
		canvas:SetBaseSize(ScreenScale(18) + 5)
	
		local inventory = LocalPlayer():GetCharacter():GetInventory()

		if (inventory) then
			panel:SetInventory(inventory)
		end

		panel:SetPos(container:GetWide()/2 - (panel:GetWide()/2),th+20)


		ix.gui.inv1 = panel
		
		ix.gui.menuInventoryContainer = canvas

		if (ix.option.Get("openBags", true)) then
			for _, v in pairs(inventory:GetItems()) do
				if (!v.isBag) then
					continue
				end

				v.functions.View.OnClick(v)
			end
		end

		DEFINE_BASECLASS("DTileLayout")

		canvas.LayoutTiles = function(self)
			local StartLine = 1
			local LastX = 1
			local tilesize = self:GetBaseSize()
			local MaxWidth = math.floor( ( self:GetWide() - self:GetBorder() * 2 + self:GetSpaceX() ) / ( tilesize + self:GetSpaceX() ) )

			self:ClearTiles()

			for k, v in ipairs( self:GetChildren() ) do

				if ( !v:IsVisible() ) then continue end

				local w = math.ceil( v:GetWide() / ( tilesize + self:GetSpaceX() ) )
				local h = math.ceil( v:GetTall() / ( tilesize + self:GetSpaceY() ) )

				if ( v.OwnLine ) then
					w = MaxWidth
				end

				local x, y = self:FindFreeTile( 1, StartLine, w, h )

				v:SetPos( self:GetBorder() + ( x - 1 ) * ( tilesize + self:GetSpaceX() ), self:GetBorder() + ( y - 1 ) * ( tilesize + self:GetSpaceY() ) )

				self:ConsumeTiles( x, y, w, h )

				if ( v.OwnLine ) then
					StartLine = y + 1
				end

				LastX = x

			end
		end
		canvas.PerformLayout = canvasLayout
		canvas:Layout()
		return canvas
	end

	local content = vgui.Create("EditablePanel", body)

	content.test = "\nTest Successful - cl_you.lua loaded.\n"

	content:SetPos(0,0)
	content:SetSize(body:GetWide(),body:GetTall())
	content.Paint = function(s,w,h)
		if (IsValid(ix.gui.inv1) and ix.gui.inv1.childPanels) then
			for i = 1, #ix.gui.inv1.childPanels do
				local panel = ix.gui.inv1.childPanels[i]

				if (IsValid(panel)) then
					panel:PaintManual()
				end
			end
		end
	end

	content.bodysection = {}

	for i=1,3,1 do
		content.bodysection[i] = content:Add("EditablePanel")
		local wide = (3/10)*content:GetWide()
		local pos = 0

		if i == 3 then
			pos = (7/10)*content:GetWide()
		end

		if i == 2 then
			pos = (3/10)*content:GetWide()
			wide = (4/10)*content:GetWide()
		end

		content.bodysection[i]:SetSize(wide,content:GetTall())
		content.bodysection[i]:SetPos(pos,0)
		content.bodysection[i].Paint = function(s,w,h)
			--draw.RoundedBox(0,0,0,w,h,Color(55*i,0,0))
		end
		content.bodysection[i]:SetZPos(0)
	end

	local function rightPane()
		local parent = content.bodysection[3]
		parent:DockMargin(5,5,5,5)
		parent:DockPadding(5,5,5,5)
		local top = vgui.Create("Panel", parent)
		top:Dock(TOP)
		top:SetTall(parent:GetTall()/2)

		local bars = vgui.Create("vnBars",top)
		bars:Dock(LEFT)
		bars:SetWide(200)
		bars:DockMargin(5,0,5,0)

		bars:SetHealth(health)
		bars:SetStamina(stamina)
		bars:SetHunger(hunger)
		bars:SetThirst(thirst)

		content.bars = bars

		local modelviewpanel = vgui.Create("Panel",top)
		modelviewpanel:Dock(FILL)
		modelviewpanel:DockMargin(0,0,5,0)
		--modelviewpanel:SetSize(300,412) -- TODO make this proportional to the bodysection

		--modelviewpanel:SetPos(content.bodysection[3]:GetWide() - modelviewpanel:GetWide() - 5,5)
		modelviewpanel.Paint = function(s,w,h)
			local mat = grunge
			draw.RoundedBox(8,0,0,w,h,Color(30,30,30))
			surface.SetMaterial(mat)
			surface.SetDrawColor(35,35,35)
			surface.DrawTexturedRect(0,0,1920,1080)
			surface.SetDrawColor(0,0,0)
			surface.DrawOutlinedRect(0,0,w,h,2)
		end

		content.modelviewpanel = modelviewpanel
		--[[local pmodel = content.modelviewpanel:Add("vnCharacterView")
		pmodel:Dock(FILL)]]
		local avatar = vgui.Create("DImage",modelviewpanel)
		avatar:SetImage("vgui/avatar.png")
		local avatall = parent:GetTall()/2 - 20
		local secwidth = (7/10)*content.bodysection[3]:GetWide() - 200
		local margin = (secwidth - (avatall/2))/2
		avatar:SetTall(avatall)
		avatar:SetWide(avatall/2)
		--avatar:Dock(FILL)
		avatar:SetPos((avatall/10),0)
		avatar:DockMargin(0,0,0,0)
		avatar:SetTall(avatall)
		avatar:SetWide(avatall/2)
		--avatar:CenterHorizontal()

		local bottom = vgui.Create("EditablePanel", parent)
		bottom:Dock(BOTTOM)
		bottom:SetTall((parent:GetTall()*.5) - 10)
		bottom:DockMargin(5,5,5,5)
		
		local rowh = bottom:GetTall()*.1 - 1
		local firstrow = bottom:Add("EditablePanel")
		firstrow:Dock(TOP)
		firstrow.Paint = function(s,w,h)
			draw.RoundedBox(0,0,0,w,h,Color(40,40,40))
			surface.SetDrawColor(0,0,0)
			surface.DrawOutlinedRect(0,0,w,h,2)
		end

		local displayname = firstrow:Add("DLabel")
		displayname:Dock(FILL)
		displayname:SetContentAlignment(5)
		displayname:DockMargin(5,5,0,0)
		displayname:SetFont("vanillaTextFont1")
		displayname:SetText(name)
		displayname:SizeToContents()
		local _, th = surface.GetTextSize(name)
		firstrow:SetTall(th+10)
		displayname:SetAutoStretchVertical(true)
		
		local secondrow = vgui.Create("Panel",bottom)
		secondrow:Dock(TOP)
		secondrow:SetTall(th+10)
		secondrow.Paint = function(s,w,h)
			draw.RoundedBox(0,0,0,w,h,Color(40,40,40))
			surface.SetDrawColor(0,0,0)
			surface.DrawOutlinedRect(0,0,w,h,2)
		end
		local displaycid = vgui.Create("DLabel",secondrow)
		displaycid:Dock(LEFT)
		displaycid:DockMargin(10,5,0,5)
		displaycid:SetAutoStretchVertical(true)
		displaycid:SetFont("vanillaTextFont1")
		displaycid:SetText(cid)
		displaycid:SizeToContents()
		local displaytokens = vgui.Create("DLabel", secondrow)
		displaytokens:Dock(RIGHT)
		displaytokens:DockMargin(0,5,10,5)
		displaytokens:SetAutoStretchVertical(true)
		displaytokens:SizeToContents()
		displaytokens:SetFont("vanillaTextFont1")
		displaytokens:SetText(tokens)
		displaytokens:SizeToContents()
		local notes = vgui.Create("ixTextEntry", bottom)
		notes:Dock(FILL)
		notes:SetFont("vanillaTextFont1")
		
		notes:SetMultiline(true)
		notes:SetEditable(true)
		notes:SetDisabled(false)
		local bottombar = vgui.Create("Panel",bottom)
		bottombar:Dock(BOTTOM)
		bottombar.Paint = function(s,w,h)
			draw.RoundedBox(0,0,0,w,h,Color(40,40,40))
			surface.SetDrawColor(0,0,0)
			surface.DrawOutlinedRect(0,0,w,h,2)
		end
	end

	local function centerPane()
		surface.SetFont("vanillaTextFont1")
		local _, fontH = surface.GetTextSize("Inventory")
	
		local center = content.bodysection[2]
		content.bodysection[2]:DockPadding(5,5,5,5)

		local top = vgui.Create("EditablePanel",center)
		top:Dock(TOP)
		top:SetTall(center:GetTall() / 2 - fontH - 10)

		local switchcharacter = top:Add("DButton")
		switchcharacter:Dock(TOP)
		switchcharacter:DockMargin(10,5,10,5)
		switchcharacter:SetTall(fontH+5)
		switchcharacter:SetFont("vanillaTextFont1")
		switchcharacter:SetText("Switch Character")
		switchcharacter.DoClick = function()
			content:GetParent():GetParent():Remove()
			ix.gui.characterMenu = vgui.Create("ixCharMenu")
		end

		local logoholder = top:Add("EditablePanel")
		logoholder:Dock(TOP)
		logoholder:SetTall((top:GetTall() * 2) / 3)

		local logo = vgui.Create("DImage", logoholder)
		logo:SetImage("vgui/logo_white-01.png")
		logo:SetImageColor(Color(255,255,255))
		logo:SetSize(ScreenScale(220),ScreenScale(220))
		local x = ( content.bodysection[2]:GetWide() / 2 ) - ( logo:GetWide()/2 )

		logo:SetPos(x,(-ScreenScale(220) / 5) - 50)

		local bottom = vgui.Create("Panel", center)
		local _, fontH = surface.GetTextSize("Inventory")
		bottom:Dock(FILL)
		bottom:SetWide(center:GetWide() - 20)
		bottom:DockMargin(10,10,10,10)
		bottom:DockPadding(5,fontH+5,5,5)
		bottom.PaintOver = function(s,w,h)
			surface.SetDrawColor(0,0,0)
			draw.NoTexture()
			surface.SetFont("vanillaTextFont1")
			surface.SetTextColor(255,255,255)
			local tw, th = surface.GetTextSize("Inventory")
			surface.DrawOutlinedRect(0,0,w,h,2)
			surface.DrawRect(0,0,w,th + 10)
			surface.SetTextPos((w/2) - (tw / 2), 5)
			surface.DrawText("Inventory")
		end
		
		local invPanel = inventoryLoad(bottom, center)
		content.invcanvas = invPanel
		--invPanel:SetPos((center:GetWide() / 2) - (invPanel:GetWide() / 2), center:GetTall() - 10 - invPanel:GetTall()*1.5 )
	end

	local function leftPane()
		local motd = vgui.Create("Panel",content.bodysection[1])
		content.bodysection[1]:DockPadding(10,10,10,10)
		motd:SetTall(200)
		motd:Dock(TOP)

		content.motd = motd
		content.motd.Paint = function(s,w,h)
			--draw.RoundedBox(0,0,0,w,h,Color(25,25,25))
			local mat = grunge

			draw.NoTexture()
			surface.SetDrawColor(30,30,30)
			surface.DrawTexturedRect(0,0,w,h)
			surface.SetMaterial(mat)
			surface.SetDrawColor(35,35,35)
			surface.DrawTexturedRect(0,0,1920,1080)
			surface.SetDrawColor(0,0,0)
			surface.DrawOutlinedRect(0,0,w,h,2)
		end

		content.motd:DockPadding(10,10,10,10)

		local serverinfo = content.motd:Add("DLabel")
		serverinfo:Dock(TOP)
		serverinfo:SetFont("vanillaTextFont1")
		serverinfo:SetText(servername.."  -  "..serverip)
		serverinfo:DockMargin(0,10,0,0)
		serverinfo:SetAutoStretchVertical(true)

		local timeinfo = content.motd:Add("DLabel")
		timeinfo:Dock(TOP)
		timeinfo:SetFont("vanillaTextFont1")
		timeinfo:SetText(TimeString)
		timeinfo:DockMargin(0,5,0,0)
		timeinfo:SetAutoStretchVertical(true)
		timeinfo.Think = function(s)
			local Timestamp = os.time()
			local TimeString = os.date( "%H:%M:%S - %d/%m/%Y" , Timestamp )
			s:SetText(TimeString)
		end
		timeinfo:SizeToContents()

		local mess = content.motd:Add("DLabel")
		mess:Dock(FILL)
		mess:SetFont("vanillaTextFont1")
		mess:SetText(messageotd)
		mess:SetAutoStretchVertical(true)

		local desc = vgui.Create("Panel",content.bodysection[1])
		desc:SetTall(322)
		desc:Dock(TOP)
		desc:DockMargin(0,5,0,0)
		desc:DockPadding(10,10,10,10)
		desc.Paint = function(s,w,h)
			draw.RoundedBox(0,0,0,w,h,Color(45,45,45))
			surface.SetDrawColor(0,0,0)
			surface.DrawOutlinedRect(0,0,w,h,2)
		end

		content.desc = desc

		--[[
		local chardesc = content.desc:Add("DLabel")
		chardesc:Dock(TOP)
		chardesc:DockMargin(0,5,0,0)
		chardesc:SetFont("vanillaTextFont1")
		chardesc:SetText(description)
		chardesc:SetAutoStretchVertical(true)
		]]
		local rumor = vgui.Create("Panel",content.bodysection[1])
		rumor:SetTall(322)
		rumor:Dock(FILL)
		rumor:DockMargin(0,5,0,0)
		rumor.Paint = function(s,w,h)
			draw.RoundedBox(0,0,0,w,h,Color(50,50,50))
			surface.SetDrawColor(0,0,0)
			surface.DrawOutlinedRect(0,0,w,h,2)
		end

		surface.SetFont("vanillaTextFont1")
		local _, th = surface.GetTextSize("Test")
		rumor:DockPadding(5,5+th,5,5)
		desc:DockPadding(5,5,5,5)

		local lastend = 1
		for i=1, #description,1 do
			local foundend = false
			if i%45 ~= 0 then
				if i ~= #description then
					continue
				else
					foundend = true
				end
			end

			local line = string.sub(description, lastend, i)

			if description[i] == " " then
				foundend = true
			end

			local startcounter = i
			while foundend == false do
				if description[startcounter] == " " then
					line = string.sub(description, lastend, startcounter)
					lastend = startcounter + 1
					foundend = true
					break
				end
				startcounter = startcounter - 1
			end

			if line[1] == " " then
				line = string.sub(line,2,#line)
			end

			local desctext = desc:Add("DLabel")
			desctext:Dock(TOP)
			desctext:SetFont("vanillaTextFont1")
			desctext:SetText(line)
			desctext:DockMargin(0,0,0,5)
			desctext:SetAutoStretchVertical(true)
			lastline = i

			if i == #description then
				break
			end
		end

		local lastend = 1
		for i=1, #serverrumor,1 do
			local foundend = false
			if i%45 ~= 0 then
				if i ~= #serverrumor then
					continue
				else
					foundend = true
				end
			end

			local line = string.sub(description, lastend, i)

			if description[i] == " " then
				foundend = true
			end

			local startcounter = i
			while foundend == false do
				if serverrumor[startcounter] == " " then
					line = string.sub(serverrumor, lastend, startcounter)
					lastend = startcounter + 1
					foundend = true
					break
				end
				startcounter = startcounter - 1
			end

			if line[1] == " " then
				line = string.sub(line,2,#line)
			end

			local rumortext = rumor:Add("DLabel")
			rumortext:Dock(TOP)
			rumortext:SetFont("vanillaTextFont1")
			rumortext:SetText(line)
			rumortext:DockMargin(0,0,0,5)
			rumortext:SetAutoStretchVertical(true)
			lastline = i

			if i == #serverrumor then
				break
			end
		end

		content.rumorpanel = rumor
	end

	leftPane()
	centerPane()
	rightPane()

	local divider1 = vgui.Create("Panel",content)
	divider1:SetSize(ScreenScale(2.5),content:GetTall())
	divider1:SetPos(content.bodysection[1]:GetWide() - (divider1:GetWide()/2),0)
	divider1.Paint = function(s,w,h)
		draw.RoundedBox(0,0,0,w,h,Color(0,0,0))
	end

	local divider2 = vgui.Create("Panel",content)
	divider2:SetSize(ScreenScale(2.5),content:GetTall())
	divider2:SetPos(content.bodysection[1]:GetWide() + content.bodysection[2]:GetWide() - (divider2:GetWide()/2),0)
	divider2.Paint = function(s,w,h)
		draw.RoundedBox(0,0,0,w,h,Color(0,0,0))
	end

	surface.SetFont("vanillaTextFont1")
	local _, th = surface.GetTextSize("I heard..")
	local rumorheaderpanel = content.bodysection[1]:Add("Panel")
	rumorheaderpanel:SetPos(6, 538)
	rumorheaderpanel:SetSize(ScreenScale(64),th+10)
	rumorheaderpanel.Paint = function(s,w,h)
		draw.RoundedBox(0,0,0,w,h,Color(40,40,40))
		surface.SetDrawColor(0,0,0)
		surface.DrawOutlinedRect(0,0,w,h,2)
	end

	surface.SetFont("vanillaTextFont1")
	local _, th = surface.GetTextSize("I heard..")
	local rumorheader = rumorheaderpanel:Add("DLabel")
	rumorheader:Dock(FILL)
	rumorheader:SetContentAlignment(5)
	rumorheader:DockMargin(5,5,5,5)
	rumorheader:SetAutoStretchVertical(true)
	rumorheader:SetText("I heard..")
	rumorheader:SetFont("vanillaTextFont1")
	--rumorheader:SetSize(ScreenScale(64), 30)

	return content
end
