module("luci.controller.ndsvoucher", package.seeall)

function index()
    entry({"admin", "services", "ndsvoucher"}, alias("admin", "services", "ndsvoucher", "vouchers"), _("NDS Voucher"), 30).dependent = false
    entry({"admin", "services", "ndsvoucher", "vouchers"}, template("ndsvoucher/voucher_template"), _("Vouchers"), 1)
    entry({"admin", "services", "ndsvoucher", "settings"}, cbi("ndsvoucher/settings"), _("Settings"), 2)
    
    -- Public endpoint for voucher entry
    entry({"ndsvoucher"}, alias("ndsvoucher", "index"))
    entry({"ndsvoucher", "index"}, template("ndsvoucher/public_index"))
    
    -- API endpoints
    entry({"admin", "ndsvoucher", "api", "list"}, call("api_list_vouchers")).leaf = true
    entry({"admin", "ndsvoucher", "api", "add"}, call("api_add_voucher")).leaf = true
    entry({"admin", "ndsvoucher", "api", "delete"}, call("api_delete_voucher")).leaf = true
    entry({"admin", "ndsvoucher", "api", "change_password"}, call("api_change_password")).leaf = true
    
    -- Public API endpoints
    entry({"ndsvoucher", "api", "validate"}, call("api_validate_voucher")).leaf = true
end

function api_list_vouchers()
    local sys = require "luci.sys"
    
    -- Call the shell script to list vouchers
    local vouchers_json = sys.exec("/usr/share/ndsvoucher/scripts/voucher.sh list")
    
    luci.http.prepare_content("application/json")
    luci.http.write(vouchers_json)
end

function api_add_voucher()
    local sys = require "luci.sys"
    local http = require "luci.http"
    
    -- Get POST data
    local name = http.formvalue("name") or ""
    local code = http.formvalue("code") or ""
    local duration = http.formvalue("duration") or "60"
    local reusable = http.formvalue("reusable") or "0"
    
    -- Call the shell script to add voucher
    local voucher_json = sys.exec(string.format("/usr/share/ndsvoucher/scripts/voucher.sh add '%s' '%s' '%s' '%s'", name, code, duration, reusable))
    
    luci.http.prepare_content("application/json")
    luci.http.write(voucher_json)
end

function api_delete_voucher()
    local sys = require "luci.sys"
    local http = require "luci.http"
    
    -- Get POST data
    local id = http.formvalue("id") or "0"
    
    -- Call the shell script to delete voucher
    sys.exec(string.format("/usr/share/ndsvoucher/scripts/voucher.sh delete '%s'", id))
    
    local response = {status = "success"}
    
    luci.http.prepare_content("application/json")
    luci.http.write_json(response)
end

function api_change_password()
    local sys = require "luci.sys"
    local http = require "luci.http"
    
    -- Get POST data
    local password = http.formvalue("password") or ""
    
    -- Call the shell script to change password
    sys.exec(string.format("/usr/share/ndsvoucher/scripts/voucher.sh set-password '%s'", password))
    
    local response = {status = "success"}
    
    luci.http.prepare_content("application/json")
    luci.http.write_json(response)
end

function api_validate_voucher()
    local sys = require "luci.sys"
    local http = require "luci.http"
    
    -- Get query parameters
    local voucher = http.formvalue("voucher") or ""
    local ip = http.formvalue("ip") or ""
    local mac = http.formvalue("mac") or ""
    
    -- Call the shell script to validate voucher
    local result = sys.exec(string.format("/usr/share/ndsvoucher/scripts/voucher.sh validate-client '%s' '%s' '%s'", voucher, ip, mac))
    
    -- In a real implementation, we would parse the result and return appropriate JSON
    local response = {status = "success", duration = 60}
    
    luci.http.prepare_content("application/json")
    luci.http.write_json(response)
end