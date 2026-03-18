-- 覆盖环境检测函数以支持 IF_HP, IF_ENEMY, IF_PROJECTILE
local _old_EntityGetWithTag = EntityGetWithTag
function EntityGetWithTag(tag)
    if tag == 'player_unit' then return { 12345 } end
    if (tag == 'homing_target' or tag == 'enemy') and _TWWE_MANY_ENEMIES then
        local res = {} for i=1,20 do res[i] = 54321 + i end return res
    end
    if tag == 'projectile' and _TWWE_MANY_PROJECTILES then
        local res = {} for i=1,30 do res[i] = 64321 + i end return res
    end
    if _old_EntityGetWithTag then return _old_EntityGetWithTag(tag) end
    return {}
end
function EntityGetTransform(ent) return 0, 0 end
function EntityHasTag(ent, tag)
    if ent == 12345 and tag == 'player_unit' then return true end
    if ent > 54321 and ent <= 54321+20 and (tag == 'enemy' or tag == 'homing_target') then return true end
    if ent > 64321 and ent <= 64321+30 and tag == 'projectile' then return true end
    return false
end
local _old_EntityGetInRadiusWithTag = EntityGetInRadiusWithTag
function EntityGetInRadiusWithTag(x, y, radius, tag)
    if (tag == 'homing_target' or tag == 'enemy') and _TWWE_MANY_ENEMIES then
        local res = {} for i=1,20 do res[i] = 54321 + i end return res
    end
    if tag == 'projectile' and _TWWE_MANY_PROJECTILES then
        local res = {} for i=1,30 do res[i] = 64321 + i end return res
    end
    if _old_EntityGetInRadiusWithTag then return _old_EntityGetInRadiusWithTag(x, y, radius, tag) end
    return {}
end
local _old_EntityGetInRadius = EntityGetInRadius
function EntityGetInRadius(x, y, radius)
    local res = {} 
    if _TWWE_MANY_ENEMIES then for i=1,20 do table.insert(res, 54321+i) end end
    if _TWWE_MANY_PROJECTILES then for i=1,30 do table.insert(res, 64321+i) end end
    if #res > 0 then return res end
    if _old_EntityGetInRadius then return _old_EntityGetInRadius(x, y, radius) end
    return {}
end
function GetUpdatedEntityID() return 12345 end
local _old_EntityGetFirstComponent = EntityGetFirstComponent
function EntityGetFirstComponent(ent, type, tag)
    if ent == 12345 and type == 'DamageModelComponent' then return 67890 end
    if _old_EntityGetFirstComponent then return _old_EntityGetFirstComponent(ent, type, tag) end
    return nil
end
local _old_EntityGetComponent = EntityGetComponent
function EntityGetComponent(ent, type, tag)
    if ent == 12345 and type == 'DamageModelComponent' then return { 67890 } end
    if _old_EntityGetComponent then return _old_EntityGetComponent(ent, type, tag) end
    return {}
end
local _old_ComponentGetValue2 = ComponentGetValue2
function ComponentGetValue2(comp, field)
    if comp == 67890 then
        if field == 'hp' then return _TWWE_LOW_HP and 0.1 or 100.0 end
        if field == 'max_hp' then return 100.0 end
    end
    if _old_ComponentGetValue2 then return _old_ComponentGetValue2(comp, field) end
    return 0
end
function EntityGetIsAlive(ent) return true end

-- TWWE VFS Initialization
local _TWWE_VFS = {}

-- TWWE Placeholder Fixer
local _TWWE_ACTIVE_MODS = {}

-- 将 VFS 数据同步到 fake_engine 的 M.vfs 中（如果存在）
local _old_MTFGC = ModTextFileGetContent
function ModTextFileGetContent(filename)
    if not filename then return nil end
    local actual_filename = filename
    
    -- 1. 修复文件名中的占位符 (支持 dofile("__MOD_ACTIONS__..."))
    if actual_filename:find("__MOD_") or actual_filename:find("___") then
        for _, mid in ipairs(_TWWE_ACTIVE_MODS) do
            if type(mid) ~= "string" then goto continue end
            local mp = "mods/" .. mid .. "/"
            local test_name = actual_filename:gsub("___", mid .. "_")
            test_name = test_name:gsub("__MOD_NAME__", mid)
            test_name = test_name:gsub("__MOD_FILES__", mp .. "files/")
            test_name = test_name:gsub("__MOD_ACTIONS__", mp .. "files/actions/")
            test_name = test_name:gsub("__MOD_LIBS__", mp .. "libs/")
            test_name = test_name:gsub("__MOD_ACTION_UTILS__", mp .. "files/action_utils/")
            
            if _TWWE_VFS[test_name] or _old_MTFGC(test_name) then
                actual_filename = test_name
                break
            end
            ::continue::
        end
    end

    local content = _TWWE_VFS[actual_filename]
    if not content then content = _old_MTFGC(actual_filename) end
    if not content or type(content) ~= "string" then return content end

    -- 2. 修复内容中的占位符
    local mod_id = nil
    if actual_filename:sub(1, 5) == "mods/" then
        local next_slash = actual_filename:find("/", 6)
        if next_slash then mod_id = actual_filename:sub(6, next_slash - 1) end
    end
    
    -- 兜底推断: 如果文件名仍含占位符或在 mod 目录下
    if not mod_id then mod_id = _TWWE_ACTIVE_MODS[1] end

    if mod_id and not actual_filename:find("twwe_mock") then
        local prefix = mod_id .. "_"
        local mp = "mods/" .. mod_id .. "/"
        content = content:gsub("___", prefix)
        content = content:gsub("__MOD_NAME__", mod_id)
        content = content:gsub("__MOD_FILES__", mp .. "files/")
        content = content:gsub("__MOD_ACTIONS__", mp .. "files/actions/")
        content = content:gsub("__MOD_LIBS__", mp .. "libs/")
        content = content:gsub("__MOD_ACTION_UTILS__", mp .. "files/action_utils/")
    end
    
    return content
end

function ModDoesFileExist(filename)
    local c = ModTextFileGetContent(filename)
    return c ~= nil and c ~= ""
end

local _TWWE_WRITTEN_FILES_OWNER = {}
local _old_MTFSC = ModTextFileSetContent
function ModTextFileSetContent(filename, content)
    if debug then
        local info = debug.getinfo(2, "S")
        if info and info.source and info.source:sub(1, 6) == "@mods/" then
            local mid = info.source:match("@mods/([^/]+)/")
            if mid then _TWWE_WRITTEN_FILES_OWNER[filename] = mid end
        end
    end
    if _old_MTFSC then return _old_MTFSC(filename, content) end
end

function ModTextFileWhoSetContent(filename)
    return _TWWE_WRITTEN_FILES_OWNER[filename] or _TWWE_ACTIVE_MODS[1] or ""
end

-- 故障诊断：当找不到法术时 dump 所有已注册 ID
local _old_error = error
function error(msg, level)
    if type(msg) == "string" and msg:find("Unknown spell") then
        print("\n[TWWE-Debug] Registered Action IDs:")
        if actions then for _, a in ipairs(actions) do print("  " .. tostring(a.id)) end end
    end
    return _old_error(msg, level)
end
