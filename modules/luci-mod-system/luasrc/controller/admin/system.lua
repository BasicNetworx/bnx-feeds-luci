-- Copyright 2008 Steven Barth <steven@midlink.org>
-- Copyright 2008-2011 Jo-Philipp Wich <jow@openwrt.org>
-- Licensed to the public under the Apache License 2.0.

module("luci.controller.admin.system", package.seeall)

function index()
	entry({"admin", "system", "system"}, view("system/system"), _("General"), 1)

	entry({"admin", "system", "admin"}, firstchild(), _("Change Password"), 2)
	entry({"admin", "system", "admin", "password"}, view("system/password"), _("Change Password"), 1)

	entry({"admin", "system", "flash"}, view("system/flash"), _("Backup / Flash Firmware"), 70)

	entry({"admin", "system", "reboot"}, view("system/reboot"), _("Reboot"), 90)
end
