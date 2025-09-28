local fs = require "nixio.fs"
local sys = require "luci.sys"
local util = require "luci.util"

m = Map("ndsvoucher", translate("NDS Voucher System"), translate("Configure the voucher system settings"))

-- General settings
s = m:section(NamedSection, "general", "general", translate("General Settings"))

-- Admin password
admin_password = s:option(Value, "admin_password", translate("Admin Password"))
admin_password.password = true
admin_password.rmempty = false

-- Server port
port = s:option(Value, "port", translate("Server Port"))
port.datatype = "port"
port.rmempty = false
port.default = "7891"

-- Data directory
data_dir = s:option(Value, "data_dir", translate("Data Directory"))
data_dir.datatype = "directory"
data_dir.rmempty = false
data_dir.default = "/data"

return m