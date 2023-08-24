include("sh_plugin.lua")

local table = ix.data.Get("ServerMOTD",false,true,true,true)
table = util.JSONToTable(table)

if !table then
	table = {}
	table.servername = "PostWar HL2RP"
	table.serverip = "0.0.0.0"
	table.motd = "A good citizen is a compliant citizen."
	table.rumor = "Breen got a fatty"

	local JSON = util.TableToJSON(table)
	ix.data.Set("ServerMOTD",JSON,false,true)
end