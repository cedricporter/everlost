
log = log or {}

function log.debug(...)
    print("[DEBUG] " .. string.format(...))
end


function log.info(...)
    print("[INFO] " .. string.format(...))
end


function log.error(...)
    print("[ERROR] " .. string.format(...))
end

