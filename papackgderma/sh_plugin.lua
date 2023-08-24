print("\n\n\nPlugin initialized!\n\n\n")

PLUGIN.name = "PapaCKG's Derma Rework"
PLUGIN.description = "Completely Rebuilds the HELIX Derma."
PLUGIN.author = "PapaCKG"
PLUGIN.tabs = {"Config","Settings","Scoreboard","You"}
PLUGIN.dfp = "helix/papackgderma/motd.txt"

do
	local COMMAND = {}
	COMMAND.arguments = ix.type.text

	function COMMAND:OnRun(client, message)
		if !client:IsAdmin() then
			return false
		end
		local table = ix.data.Get("ServerMOTD",false,true,true,true)
		table = util.JSONToTable(table)

		if !table then
			return false
		end

		table.servername = message
		local JSON = util.TableToJSON(table)
		ix.data.Set("ServerMOTD",JSON,true)
	end

	ix.command.Add("SetServerName", COMMAND)
end

do
	local COMMAND = {}
	COMMAND.arguments = ix.type.text

	function COMMAND:OnRun(client, message)
		if !client:IsAdmin() then
			return false
		end
	
		local table = ix.data.Get("ServerMOTD",false,true,true,true)
		table = util.JSONToTable(table)
		if !table then
			return false
		end

		table.serverip = message
		local JSON = util.TableToJSON(table)
		ix.data.Set("ServerMOTD",JSON,true)
	end

	ix.command.Add("SetServerIP", COMMAND)
end

do
	local COMMAND = {}
	COMMAND.arguments = ix.type.text

	function COMMAND:OnRun(client, message)
		if !client:IsAdmin() then
			return false
		end
		local table = ix.data.Get("ServerMOTD",false,true,true,true)
		table = util.JSONToTable(table)
		if !table then
			return false
		end

		table.motd = message
		local JSON = util.TableToJSON(table)
		ix.data.Set("ServerMOTD",JSON,true)
	end

	ix.command.Add("SetMOTD", COMMAND)
end

do
	local COMMAND = {}
	COMMAND.arguments = ix.type.text

	function COMMAND:OnRun(client, message)
		if !client:IsAdmin() then
			return false
		end
		local table = ix.data.Get("ServerMOTD",false,true,true,true)
		table = util.JSONToTable(table)
		if !table then
			return false
		end

		table.rumor = message
		local JSON = util.TableToJSON(table)
		ix.data.Set("ServerMOTD",JSON,true)
	end

	ix.command.Add("SetRumor", COMMAND)
end

surface.CreateFont("vanillaHeaderFont", {
	font="Mailart Rubberstamp",
	size=60
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

surface.CreateFont("vanillaTextFont3", {
	font="Mailart Rubberstamp",
	size=ScreenScale(20)
})

ix.util.Include("cl_hooks.lua")
ix.util.Include("derma/cl_main.lua")
ix.util.Include("cl_skin.lua")
