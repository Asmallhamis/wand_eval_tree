_TWWE_MANY_PROJECTILES = true
_TWWE_MANY_ENEMIES = true
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
