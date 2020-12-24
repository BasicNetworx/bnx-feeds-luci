local uci = require "uci"

mp = Map("bnx-vpn", translate("VPN Client"))
mp.description = translate("VPN connectivity using the native built-in VPN Client on BNX device")

s = mp:section(NamedSection, "vpn", "vpn")
s.anonymouse = true

mode = s:option(ListValue, "mode", translate("Mode"))
mode.datatype = "string"
mode.description = translate("VPN client mode - Off : VPN is disable , Manual : Add config manually, Auto : Get config automatically")
mode:value("off", "Off")
mode:value("manual", "Manual")
mode:value("auto", "Auto")
mode.default = "off"
mode.rmempty = false

endpoint = s:option(Value, "endpoint", translate("Endpoint"))
endpoint:depends("mode","manual")
endpoint.datatype = "string"
endpoint.description = translate("VPN endpoint for vpn client connection")

psk = s:option(Value, "psk", translate("Secret Pre-Shared Key"))
psk:depends("mode","manual")
psk.password = true

auto = s:option(DummyValue, "auto_on", " ")
auto:depends("mode","auto")
function auto.cfgvalue(...)
	local v = Value.cfgvalue(...)
	if v == "1" then
		x = uci.cursor()
		local name = x:get("bnx-vpn","vpn","auto_name")
		local val = "This device belongs to the " .. name .. " VPN" 
		return translate(val)
	else
		local val = "This device does not belong to a VPN."
		return translate(val)
	end
	return translate(" ")
end

return mp

