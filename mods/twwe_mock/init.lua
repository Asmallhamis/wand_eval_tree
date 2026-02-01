-- 覆盖环境检测函数以支持 IF_HP, IF_ENEMY, IF_PROJECTILE
local _old_EntityGetWithTag = EntityGetWithTag
function EntityGetWithTag(tag)
    if tag == 'player_unit' and _TWWE_LOW_HP then return { 12345 } end
    return _old_EntityGetWithTag(tag)
end
local _old_GetUpdatedEntityID = GetUpdatedEntityID
function GetUpdatedEntityID()
    if _TWWE_LOW_HP or _TWWE_MANY_ENEMIES or _TWWE_MANY_PROJECTILES then return 12345 end
    return _old_GetUpdatedEntityID()
end
function EntityGetFirstComponent(ent, type, tag)
    if ent == 12345 and type == 'DamageModelComponent' and _TWWE_LOW_HP then return 67890 end
    return nil
end
function ComponentGetValue2(comp, field)
    if comp == 67890 then
        if field == 'hp' then return 0.1 end
        if field == 'max_hp' then return 1.0 end
    end
    return 0
end
