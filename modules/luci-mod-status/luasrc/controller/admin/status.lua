-- Copyright 2008 Steven Barth <steven@midlink.org>
-- Copyright 2011 Jo-Philipp Wich <jow@openwrt.org>
-- Licensed to the public under the Apache License 2.0.

module("luci.controller.admin.status", package.seeall)

function index()
	local page

	entry({"admin", "status", "overview"}, template("admin_status/index"), _("Overview"), 1)

	entry({"admin", "status", "sim"}, view("status/bnx-sim"), _("Sim"), 2)

	entry({"admin", "status", "iptables"}, view("status/iptables"), _("Firewall"), 3).leaf = true

	entry({"admin", "status", "routes"}, view("status/routes"), _("Routes"), 4)
	entry({"admin", "status", "syslog"}, view("status/syslog"), _("System Log"), 5)

	entry({"admin", "status", "realtime"}, alias("admin", "status", "realtime", "load"), _("Realtime Graphs"), 7)

	entry({"admin", "status", "realtime", "load"}, view("status/load"), _("Load"), 1)
	entry({"admin", "status", "realtime", "bandwidth"}, view("status/bandwidth"), _("Traffic"), 2)
	entry({"admin", "status", "realtime", "wireless"}, view("status/wireless"), _("Wireless"), 3).uci_depends = { wireless = true }
	entry({"admin", "status", "realtime", "connections"}, view("status/connections"), _("Connections"), 4)

	entry({"admin", "status", "nameinfo"}, call("action_nameinfo")).leaf = true
end
