local uci = require "uci"
local fs = require "nixio.fs"
local ut = require "luci.util"

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

authmode = s:option(ListValue, "authmode", translate("Authmode"))
authmode:depends("mode","manual")
authmode.datatype = "string"
authmode:value("psk", "psk")
authmode:value("pki", "pki")
authmode.default = "psk"

psk = s:option(Value, "psk", translate("Secret Pre-Shared Key"))
psk:depends("authmode","psk")
psk.password = true

ca = s:option(TextValue, "ca-cert","Endpoint cert")
ca.description = translate("VPN Client endpoint certificate (Copy paste your endpoint certificate in above text box)")
ca:depends("authmode","pki")
function ca.cfgvalue()
	x = uci.cursor()
	local fileName = x:get("bnx-vpn","vpn","endpoint_cert")
        return fs.readfile(fileName)
end
function ca.write(self, section, data)
	x = uci.cursor()
	local fileName = x:get("bnx-vpn","vpn","endpoint_cert")
        return fs.writefile(fileName, ut.trim(data:gsub("\r\n", "\n")) .. "\n")
end

devca = s:option(TextValue, "dev-cert","Device cert")
devca.description = translate("VPN Client device certificate ( Copy paste your device certificate in above text box )")
devca:depends("authmode","pki")
function devca.cfgvalue()
	x = uci.cursor()
	local fileName = x:get("bnx-vpn","vpn","device_cert")
        return fs.readfile(fileName)
end
function devca.write(self, section, data)
	x = uci.cursor()
	local fileName = x:get("bnx-vpn","vpn","device_cert")
        return fs.writefile(fileName, ut.trim(data:gsub("\r\n", "\n")) .. "\n")
end

cakey = s:option(TextValue, "ca-key","Private key")
cakey.description = translate("VPN Client device private key ( Copy paste your device private key in above text box )")
cakey:depends("authmode","pki")
function cakey.cfgvalue()
	x = uci.cursor()
	local fileName = x:get("bnx-vpn","vpn","device_privkey")
        return fs.readfile(fileName)
end
function cakey.write(self, section, data)
	x = uci.cursor()
	local fileName = x:get("bnx-vpn","vpn","device_privkey")
        return fs.writefile(fileName, ut.trim(data:gsub("\r\n", "\n")) .. "\n")
end


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

p = mp:section(NamedSection, "vpn", "vpn")
p:option(DummyValue, "status", "Status", "VPN Client status")
p.anonymouse = true

return mp

