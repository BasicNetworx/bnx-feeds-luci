local uci = require "uci"
local fs = require "nixio.fs"
local ut = require "luci.util"

mp = Map("bnx-cloud-services", translate("Provisioning"))
mp.description = translate("Device provisioning using BNX Cloud")

x = uci.cursor()
local org_name = x:get("bnx-cloud-services","state","org_name")
local org_key = x:get("bnx-cloud-services","settings","org_key")

s = mp:section(NamedSection, "state", "state", "Status")
s.anonymouse = true

if org_key == "" or org_key == nil then
	auto_s = s:option(DummyValue, "")
	function auto_s.cfgvalue(...)
		local val = "Not Provisioned (Organization key not set)"
		return translate(val)
	end
elseif org_name == "" or org_name == nil then
	auto_s = s:option(DummyValue, "")
	function auto_s.cfgvalue(...)
		local val = "Provision Pending"
		return translate(val)
	end
else
	auto_s = s:option(DummyValue, "")
	function auto_s.cfgvalue(...)
		return translate("Provision Successful")
	end
	auto_s = s:option(DummyValue, "")
	function auto_s.cfgvalue(...)
		return translate("This device belongs to the '" .. org_name .. "' organization.")
	end
	auto_s = s:option(DummyValue, "")
	function auto_s.cfgvalue(...)
		return translate("For security reasons, the organization cannot be changed without resetting this device to its initial state.")
	end
end

s = mp:section(NamedSection, "settings", "settings", "Organization Key")
s.anonymouse = true

auto_s = s:option(Value, "org_key")
auto_s.placeholder = "Enter Organization Key"
if org_name == "" or org_name == nil then
	auto_s.readonly = false
else
	auto_s.readonly = true
end

return mp

