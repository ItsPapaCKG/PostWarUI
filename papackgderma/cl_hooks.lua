print("hooks loaded");
local PLUGIN = PLUGIN

--ix.util.Include("derma/cl_men.lua")

local GM = gmod.GetGamemode()

function GM:ScoreboardShow()
	if (LocalPlayer():GetCharacter()) then
		vgui.Create("ixCMenu")
	end
end
