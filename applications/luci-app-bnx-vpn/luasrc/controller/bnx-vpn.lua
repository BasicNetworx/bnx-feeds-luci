module("luci.controller.bnx-vpn", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/bnx-vpn") then
		return
	end
	
	entry({"admin", "network", "vpn"}, cbi("bnx-vpn/bnx-vpn"), _("VPN"), 80).dependent=false
end

