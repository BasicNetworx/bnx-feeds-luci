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

remote_subnet = s:option(DynamicList, "remote_subnets", translate("Remote Subnet"))
remote_subnet:depends("mode","manual")
remote_subnet.datatype = "string"
remote_subnet.description = translate("VPN remote subnet")

local_subnet = s:option(Value, "local_subnet", translate("Local Subnet"))
local_subnet:depends("mode","manual")
local_subnet.datatype = "string"
local_subnet.description = translate("VPN local subnet")

auth_mode = s:option(ListValue, "auth_mode", translate("Authmode"))
auth_mode:depends("mode","manual")
auth_mode.datatype = "string"
auth_mode:value("psk", "psk")
auth_mode:value("pki", "pki")
auth_mode.default = "psk"

psk = s:option(Value, "psk", translate("Secret Pre-Shared Key"))
psk:depends("auth_mode","psk")
psk.password = true

endpoint_id = s:option(Value, "endpoint_id", translate("Endpoint ID"))
endpoint_id:depends("auth_mode","pki")
endpoint_id.datatype = "string"
endpoint_id.description = translate("VPN endpoint id")

ca = s:option(TextValue, "ca-cert","CA cert") 
ca.description = translate("VPN Client CA certificate (Copy paste your ca certificate in above text box....................)")
ca:depends("auth_mode","pki")
function ca.cfgvalue()
	x = uci.cursor()
	local fileName = x:get("bnx-vpn","vpn","ca_cert")
	return fs.readfile(fileName)
end
function ca.write(self, section, data) 
	x = uci.cursor()
	local fileName = x:get("bnx-vpn","vpn","ca_cert")
	return fs.writefile(fileName, ut.trim(data:gsub("\r\n", "\n")) .. "\n")
end

devca = s:option(TextValue, "dev-cert","Device cert")
devca.description = translate("VPN Client device certificate ( Copy paste your device certificate in above text box.......)")
devca:depends("auth_mode","pki")
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

devkey = s:option(TextValue, "ca-key","Device private key")
devkey.description = translate("VPN Client device private key ( Copy paste your device private key in above text box....)")
devkey:depends("auth_mode","pki")
function devkey.cfgvalue()
	x = uci.cursor()
	local fileName = x:get("bnx-vpn","vpn","device_privkey")
        return fs.readfile(fileName)
end
function devkey.write(self, section, data)
	x = uci.cursor()
	local fileName = x:get("bnx-vpn","vpn","device_privkey")
        return fs.writefile(fileName, ut.trim(data:gsub("\r\n", "\n")) .. "\n")
end

ikec = s:option(Value, "ike_cipher", "Phase 1 (IKE) Proposal")
ikec:depends("mode","manual")
ikec.default = "aes256-sha1"
ikec:value("aes256-sha1","aes256-sha1")
ikec:value("aes128-sha1","aes128-sha1")
ikec:value("aes128-sha256","aes128-sha256")

iked = s:option(Value, "ike_dhgroup", "Phase 1 DH Group")
iked:depends("mode","manual")
iked.default = "modp1536"
iked:value("modp1536","modp1536")
iked:value("modp1024","modp1024")

espc = s:option(Value, "esp_cipher", "Phase 2 (ESP) Proposal")
espc:depends("mode","manual")
espc.default = "aes256-sha1"
espc:value("aes256-sha1","aes256-sha1")
espc:value("aes128-sha1","aes128-sha1")
espc:value("aes128-sha256","aes128-sha256")

espd = s:option(Value, "esp_dhgroup", "Phase 2 PFS Group")
espd:depends("mode","manual")
espd.default = "modp1536"
espd:value("modp1536","modp1536")
espd:value("modp1024","modp1024")

forceencaps = s:option(Flag, "forceencaps", "Force UDP Encaptulation")
forceencaps:depends("mode","manual")
forceencaps.disabled = "no"
forceencaps.enabled = "yes"

aggressive = s:option(Flag, "aggressive", "Aggressive")
aggressive:depends("mode","manual")
aggressive.disabled = "no"
aggressive.enabled = "yes"

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

