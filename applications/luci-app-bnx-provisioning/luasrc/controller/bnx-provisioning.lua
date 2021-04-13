module("luci.controller.bnx-provisioning", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/provision") then
		return
	end

	entry({"admin", "system", "provisioning"}, cbi("bnx-provisioning/bnx-provisioning"), _("Provisioning"), 40).dependent=false
end
