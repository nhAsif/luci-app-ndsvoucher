local fs = require "nixio.fs"
local sys = require "luci.sys"
local util = require "luci.util"

m = Map("ndsvoucher", translate("NDS Voucher System"), translate("Manage vouchers for NoDogSplash captive portal"))

-- Voucher list section
s = m:section(TypedSection, "voucher", translate("Vouchers"))
s.template = "cbi/tblsection"
s.anonymous = true
s.addremove = true

-- Name
name = s:option(Value, "name", translate("Name"))
name.datatype = "string"

-- Code
code = s:option(Value, "code", translate("Code"))
code.datatype = "string"
code.rmempty = false

-- Duration
duration = s:option(Value, "duration", translate("Duration (minutes)"))
duration.datatype = "uinteger"
duration.rmempty = false

-- Reusable
reusable = s:option(Flag, "reusable", translate("Reusable"))
reusable.rmempty = false

-- Add new voucher section
s2 = m:section(NamedSection, "new_voucher", "new_voucher", translate("Add New Voucher"))

-- Name
new_name = s2:option(Value, "name", translate("Name"))
new_name.datatype = "string"

-- Code
new_code = s2:option(Value, "code", translate("Code (leave blank for auto-generated)"))
new_code.datatype = "string"

-- Duration
new_duration = s2:option(Value, "duration", translate("Duration (minutes)"))
new_duration.datatype = "uinteger"
new_duration.rmempty = false
new_duration.default = "60"

-- Reusable
new_reusable = s2:option(Flag, "reusable", translate("Reusable"))
new_reusable.rmempty = false

return m