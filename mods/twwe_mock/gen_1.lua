dofile_once("data/scripts/gun/procedural/gun_action_utils.lua")
dofile_once("data/scripts/lib/utilities.lua")
dofile_once( "data/scripts/gun/gun_enums.lua")

local DE_ULTIMATE_MANA = 418 -- HTTP Status Code

function DEEP_END_SPELLS_add_projectile_trigger_customized( entity_filename, customized_timer_list, action_draw_count_list, can_reload_at_end )
	if reflecting then 
		Reflection_RegisterProjectile( entity_filename )
		return 
	end

	if nil == entity_filename then return end
	if nil == action_draw_count_list then action_draw_count_list = {} end
	if nil == can_reload_at_end then can_reload_at_end = true end
	if nil == customized_timer_list then
		add_projectile( entity_filename )
		return
	end

	BeginProjectile( entity_filename )

	for i=1,#customized_timer_list do
		if customized_timer_list[i] == 0 then
			BeginTriggerDeath()
		elseif customized_timer_list[i] < 0 then
			BeginTriggerHitWorld()
		elseif customized_timer_list[i] > 0 then
			BeginTriggerTimer( customized_timer_list[i] )
		end

		draw_shot( create_shot( action_draw_count_list[i] or 1 ), can_reload_at_end )

		EndTrigger()
	end

	EndProjectile() -- Honestly, I didn't know what I was doing at the time
end

function DEEP_END_SPELLS_add_projectile_trigger_heritable( heritance, entity_filename, customized_timer, action_draw_count, can_reload_at_end )
	if reflecting then 
		Reflection_RegisterProjectile( entity_filename )
		return 
	end

	if nil == entity_filename then return end
	if nil == customized_timer then customized_timer = 0 end
	if nil == action_draw_count then action_draw_count = 1 end
	if nil == can_reload_at_end then can_reload_at_end = true end

	BeginProjectile( entity_filename )

		if customized_timer == 0 then
		BeginTriggerDeath()
		elseif customized_timer < 0 then
		BeginTriggerHitWorld()
		elseif customized_timer > 0 then
		BeginTriggerTimer( customized_timer )
		end

			-- draw_shot( create_shot( action_draw_count ), can_reload_at_end )
			local shot = create_shot( action_draw_count )
			local c_old = c
			c = shot.state
			
			c.damage_melee_add = heritance.damage_melee_add
            c.damage_drill_add = heritance.damage_drill_add
            c.damage_slice_add = heritance.damage_slice_add
            c.damage_fire_add = heritance.damage_fire_add
            c.damage_ice_add = heritance.damage_ice_add
            c.damage_electricity_add = heritance.damage_electricity_add
            c.damage_curse_add = heritance.damage_curse_add
            c.damage_healing_add = heritance.damage_healing_add
            c.damage_explosion_add = heritance.damage_explosion_add
            c.damage_explosion = heritance.damage_explosion
			c.explosion_radius = heritance.explosion_radius
 			c.damage_projectile_add = heritance.damage_projectile_add
            c.damage_critical_chance = heritance.damage_critical_chance
            c.damage_null_all = heritance.damage_null_all
            c.gore_particles = heritance.gore_particles
			c.knockback_force = heritance.knockback_force
			c.trail_material = heritance.trail_material
			c.trail_material_amount = heritance.trail_material_amount
			c.extra_entities = heritance.extra_entities
			c.game_effect_entities = heritance.game_effect_entities
			c.lifetime_add = heritance.lifetime_add
			c.bounces = heritance.bounces
			c.gravity = heritance.gravity
			c.speed_multiplier = heritance.speed_multiplier
			c.spread_degrees = heritance.spread_degrees
			c.pattern_degrees = heritance.pattern_degrees
			
			shot_structure = {}
			draw_actions( shot.num_of_cards_to_draw, can_reload_at_end )
			register_action( shot.state )
			SetProjectileConfigs()

			c = c_old
			
		EndTrigger()

	EndProjectile()
end


local de_actions_append = {
	{
		id          = "DE_THERMAL_IMPACT",
		name 		= "$THERMAL_IMPACT",
		description = "$dTHERMAL_IMPACT",
		sprite 		= "data/ui_gfx/gun_actions/thermal_impact.png",
		related_projectiles	= {"data/entities/projectiles/deck/thermal_impact.xml",5},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "2,3,4,5,6", -- SPIRAL_SHOT
		spawn_probability                 = "1,1,1,1,1", -- SPIRAL_SHOT
		price = 200,
		mana = 33,
		max_uses = 60,
		custom_xml_file = "data/entities/misc/custom_cards/thermal_impact.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/thermal_impact.xml")
			add_projectile("data/entities/projectiles/deck/thermal_impact.xml")
			add_projectile("data/entities/projectiles/deck/thermal_impact.xml")
			add_projectile("data/entities/projectiles/deck/thermal_impact.xml")
			add_projectile("data/entities/projectiles/deck/thermal_impact.xml")
			c.game_effect_entities = c.game_effect_entities .. "data/entities/misc/effect_disintegrated.xml,"
			c.speed_multiplier = math.max( c.speed_multiplier * 5.0, 0 )
			c.lifetime_add = c.lifetime_add - 96
			c.gravity = -35.0
			c.spread_degrees = 18
			c.pattern_degrees = c.pattern_degrees + 12
			c.screenshake = c.screenshake + 30
			shot_effects.recoil_knockback = 20.0
			current_reload_time = current_reload_time + 2
		end,
	},
	{
		id          = "DE_CASCADING_STORM",
		name 		= "$CASCADING_STORM",
		description = "$dCASCADING_STORM",
		sprite 		= "data/ui_gfx/gun_actions/geomagnetic_storm.png",
		related_projectiles	= {"data/entities/projectiles/deck/geomagnetic_storm_ex.xml",4},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "2,4,5,6,10", -- SPIRAL_SHOT
		spawn_probability                 = "0.6,0.8,1,0.6,0.2", -- SPIRAL_SHOT
		price = 177,
		mana = 77,
		max_uses = 77,
		custom_xml_file = "data/entities/misc/custom_cards/geomagnetic_storm_electric.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/geomagnetic_storm.xml")
			add_projectile("data/entities/projectiles/deck/geomagnetic_storm.xml")
			add_projectile("data/entities/projectiles/deck/geomagnetic_storm.xml")
			add_projectile("data/entities/projectiles/deck/geomagnetic_storm.xml")
			c.game_effect_entities = c.game_effect_entities .. "data/entities/misc/effect_disintegrated.xml,"
			c.gravity = 0.0
			c.pattern_degrees = c.pattern_degrees + 12
			c.screenshake = c.screenshake + 42
			shot_effects.recoil_knockback = 28.0
			c.fire_rate_wait = c.fire_rate_wait + 21
			current_reload_time = current_reload_time + 7
		end,
	},
	{
		id          = "DE_GHOSTY_BULLET",
		name 		= "$GHOSTY_BULLET",
		description = "$dGHOSTY_BULLET",
		sprite 		= "data/ui_gfx/gun_actions/ghosty_bullet.png",
		related_projectiles	= {"data/entities/projectiles/deck/ghosty_bullet.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "2,4,5,6,10", -- SPIRAL_SHOT
		spawn_probability                 = "1,1,1,1,0.2", -- SPIRAL_SHOT
		price = 200,
		mana = 42,
		max_uses = 18,
		custom_xml_file = "data/entities/misc/custom_cards/ghosty_bullet.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/ghosty_bullet.xml")
			c.game_effect_entities = c.game_effect_entities .. "data/entities/misc/effect_disintegrated.xml,"
			shot_effects.recoil_knockback = 0
			c.fire_rate_wait = c.fire_rate_wait + 12
			current_reload_time = current_reload_time + 4
		end,
	},
	{
		id          = "DE_SNIPER_BULLET",
		name 		= "$SNIPER_BULLET",
		description = "$dSNIPER_BULLET",
		sprite 		= "data/ui_gfx/gun_actions/sniperbullet.png",
		related_projectiles	= {"data/entities/projectiles/deck/sniperbullet.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "2,4,5,6,7,10", -- SPIRAL_SHOT
		spawn_probability                 = "0.8,0.9,1,0.8,0.6,0.5", -- SPIRAL_SHOT
		price = 200,
		mana = 27,
		max_uses = 9999,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/sniperbullet.xml")
			c.fire_rate_wait = c.fire_rate_wait + 12
			c.spread_degrees = c.spread_degrees - 180.0
			c.damage_critical_chance = c.damage_critical_chance + 7
			shot_effects.recoil_knockback = shot_effects.recoil_knockback - 7.0

			local vibra_param = c.damage_projectile_add / math.max( c.speed_multiplier, 0.01 ) * 12 - math.max( shot_effects.recoil_knockback, 0 )
			vibra_param = math.floor( math.min( vibra_param, 1600 ) )
			c.screenshake = math.min( c.screenshake + vibra_param, 3200 )
		end,
	},
	{
		id          = "DE_LASER_TURRET",
		name 		= "$LASER_TURRET",
		description = "$dLASER_TURRET",
		sprite 		= "data/ui_gfx/gun_actions/laser_turret.png",
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "1,2,4,5,6,7,10", -- SPIRAL_SHOT
		spawn_probability                 = "0.4,0.2,0.3,0.4,0.4,0.5,0.05", -- SPIRAL_SHOT
		price = 200,
		mana = 36,
		max_uses = 9999,
		custom_xml_file = "data/entities/misc/custom_cards/laser_turret.xml",
		related_projectiles	= {"data/entities/projectiles/deck/laser_turret_new.xml",2},
		action 		= function()
			add_projectile("data/entities/projectiles/deck/laser_turret_new.xml")
			add_projectile("data/entities/projectiles/laser_turret_new.xml")

			c.fire_rate_wait = c.fire_rate_wait + 7
			c.damage_critical_chance = c.damage_critical_chance + 3
			c.spread_degrees = c.spread_degrees - 36.0
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 15

			local vibra_param = c.damage_projectile_add / math.max( c.speed_multiplier, 0.01 ) * 12 - math.max( shot_effects.recoil_knockback, 0 )
			vibra_param = math.floor( math.min( vibra_param * 0.33 , 1200 ) )
			c.screenshake = math.min( c.screenshake + vibra_param, 3200 )
		end,
		--[[related_projectiles	= {"data/entities/projectiles/deck/laser_turret_c.xml",3},
		action 		= function()
			SetRandomSeed( GameGetFrameNum(), GameGetFrameNum() )
			local types = {"g","g","g","g","g","g","g","g","g","g","g","h","h","h","b","c","d","e","x","y","z"}
			local rnd = Random(1,#types)

			local laser_name = "data/entities/projectiles/deck/laser_turret_" .. tostring(types[rnd]) .. ".xml"
			add_projectile(laser_name)

			laser_name = "data/entities/projectiles/deck/laser_turret_a.xml"
			add_projectile(laser_name)

			laser_name = "data/entities/projectiles/deck/laser_turret_f.xml"
			add_projectile(laser_name)

			c.fire_rate_wait = c.fire_rate_wait + 14
			c.damage_critical_chance = c.damage_critical_chance + 3
			c.spread_degrees = c.spread_degrees - 36.0
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + Random(15,45)

			local vibra_param = c.damage_projectile_add / math.max( c.speed_multiplier, 0.01 ) * 12 - math.max( shot_effects.recoil_knockback, 0 )
			vibra_param = math.floor( math.min( vibra_param * 0.33 , 1200 ) )
			c.screenshake = math.min( c.screenshake + vibra_param, 3200 )
		end,]]--
	},
	{
		id          = "DE_SOLDIERSHIT", -- shOt
		name 		= "$SOLDIERSHIT",
		description = "$dSOLDIERSHIT",
		sprite 		= "data/ui_gfx/gun_actions/soldiershot.png",
		related_projectiles	= {"data/entities/projectiles/deck/soldiers_shot.xml",4},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "2,4,5,6,7,10", -- SPIRAL_SHOT
		spawn_probability                 = "1,1,1,1,1,0.5", -- SPIRAL_SHOT
		price = 200,
		mana = 80,
		max_uses = 9999,
		custom_xml_file = "data/entities/misc/custom_cards/soldiershot.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/soldiers_shot.xml")
			add_projectile("data/entities/projectiles/deck/soldiers_shot.xml")
			add_projectile("data/entities/projectiles/deck/soldiers_shot.xml")
			add_projectile("data/entities/projectiles/deck/soldiers_shot.xml")
			c.pattern_degrees = 30
			c.damage_critical_chance = c.damage_critical_chance + 12
			c.speed_multiplier = math.min( 1.5, c.speed_multiplier + 0.5 )
			c.fire_rate_wait = c.fire_rate_wait + 15
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 12.0
		end,
	},
	{
		id          = "DE_SNIPER_BULLET_TRIGGER",
		name 		= "$SNIPER_BULLET_TRIGGER",
		description = "$dSNIPER_BULLET_TRIGGER",
		sprite 		= "data/ui_gfx/gun_actions/sniperbullet_trigger.png",
		related_projectiles	= {"data/entities/projectiles/deck/sniperbullet.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "4,5,6,7,10", -- SPIRAL_SHOT
		spawn_probability                 = "1,1,1,1,0.5", -- SPIRAL_SHOT
		price = 300,
		mana = 36,
		max_uses = 9999,
		action 		= function()
			add_projectile_trigger_hit_world("data/entities/projectiles/deck/sniperbullet.xml",3)
			c.fire_rate_wait = c.fire_rate_wait + 12
			c.spread_degrees = c.spread_degrees - 180.0
			c.damage_critical_chance = c.damage_critical_chance + 7
			shot_effects.recoil_knockback = shot_effects.recoil_knockback - 7.0

			local vibra_param = c.damage_projectile_add / math.max( c.speed_multiplier, 0.01 ) * 12 - math.max( shot_effects.recoil_knockback, 0 )
			vibra_param = math.floor( math.min( vibra_param, 1600 ) )
			c.screenshake = math.min( c.screenshake + vibra_param, 3200 )
		end,
	},
	{
		id          = "DE_SNIPER_BULLET_TRIGGER_MULT",
		name 		= "$SNIPER_BULLET_TRIGGER_MULT",
		description = "$dSNIPER_BULLET_TRIGGER_MULT",
		sprite 		= "data/ui_gfx/gun_actions/sniperbullet_trigger_mult.png",
		related_projectiles	= {"data/entities/projectiles/deck/sniperbullet.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "4,5,6,7,10", -- SPIRAL_SHOT
		spawn_probability                 = "1,1,1,1,0.25", -- SPIRAL_SHOT
		price = 300,
		mana = 36,
		max_uses = 9999,
		action 		= function()
			DEEP_END_SPELLS_add_projectile_trigger_customized("data/entities/projectiles/deck/sniperbullet.xml",{-1,4,0},{1,1,1})
			
			c.fire_rate_wait = c.fire_rate_wait + 12
			c.spread_degrees = c.spread_degrees - 180.0
			c.damage_critical_chance = c.damage_critical_chance + 7
			shot_effects.recoil_knockback = shot_effects.recoil_knockback - 7.0

			local vibra_param = c.damage_projectile_add / math.max( c.speed_multiplier, 0.01 ) * 12 - math.max( shot_effects.recoil_knockback, 0 )
			vibra_param = math.floor( math.min( vibra_param, 1600 ) )
			c.screenshake = math.min( c.screenshake + vibra_param, 3200 )
		end,
	},
	{
		id          = "DE_SOLDIERSHIT_TRIGGER", -- shOt
		name 		= "$SOLDIERSHIT_TRIGGER",
		description = "$dSOLDIERSHIT_TRIGGER",
		sprite 		= "data/ui_gfx/gun_actions/soldiershot_trigger.png",
		related_projectiles	= {"data/entities/projectiles/deck/soldiers_shot.xml",4},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "4,5,6,7,10", -- SPIRAL_SHOT
		spawn_probability                 = "1,1,1,1,0.5", -- SPIRAL_SHOT
		price = 300,
		mana = 96,
		max_uses = 9999,
		custom_xml_file = "data/entities/misc/custom_cards/soldiershot.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/soldiers_shot.xml")
			add_projectile_trigger_hit_world("data/entities/projectiles/deck/soldiers_shot.xml",2)
			add_projectile_trigger_hit_world("data/entities/projectiles/deck/soldiers_shot.xml",2)
			add_projectile("data/entities/projectiles/deck/soldiers_shot.xml")
			c.pattern_degrees = 30
			c.damage_critical_chance = c.damage_critical_chance + 12
			c.speed_multiplier = math.min( 1.5, c.speed_multiplier + 0.5 )
			c.fire_rate_wait = c.fire_rate_wait + 15
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 2.0
		end,
	},

	{
		id          = "DE_HEAVENLY_WRATH",
		name 		= "$HEAVENLY_WRATH",
		description = "$dHEAVENLY_WRATH",
		sprite 		= "data/ui_gfx/gun_actions/heavenly_wrath.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/death_cross_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/heavenly_wrath.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "4,5,6,7,10", -- DEATH_CROSS_BIG
		spawn_probability                 = "1,1,1,1,0.1", -- DEATH_CROSS_BIG
		price = 310,
		mana = 66,
		max_uses = 5,
		-- custom_xml_file = "data/entities/misc/custom_cards/death_cross.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/heavenly_wrath.xml")
			c.damage_healing_add = c.damage_healing_add - 0.52
			c.damage_projectile_add = c.damage_projectile_add + 0.52
			c.fire_rate_wait = c.fire_rate_wait + 180
			current_reload_time = current_reload_time + 180
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 130.0
			c.screenshake = c.screenshake + 130
		end,
	},
	{
		id          = "DE_ICEY_LANCE",
		name 		= "$ICEY_LANCE",
		description = "$dICEY_LANCE",
		sprite 		= "data/ui_gfx/gun_actions/icey_lance.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/death_cross_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/deck/icey_lance.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "2,3,4,5,6,10", -- DEATH_CROSS_BIG
		spawn_probability                 = "0.5,0.6,0.7,0.6,0.5,0.05", -- DEATH_CROSS_BIG
		price = 310,
		mana = 21,
		max_uses = 48,
		-- custom_xml_file = "data/entities/misc/custom_cards/death_cross.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/icey_lance.xml")
			c.damage_ice_add = c.damage_ice_add + 0.11
			c.speed_multiplier = c.speed_multiplier * 1.5
			c.fire_rate_wait = c.fire_rate_wait + 30
			c.spread_degrees = c.spread_degrees - 30
		end,
	},
	{
		id          = "DE_ENCHANTER_FIELD",
		name 		= "$denchantment_field",
		description = "$ddenchantment_field",
		sprite 		= "data/ui_gfx/gun_actions/enchantment_field.png",
		related_projectiles	= {"data/entities/projectiles/deck/enchantment_field.xml"},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "0,1,6,7", -- SHIELD_FIELD
		spawn_probability                 = "0.3,0.4,0.5,0.05", -- SHIELD_FIELD
		price = 250,
		mana = 150,
		max_uses = 3,
		never_unlimited = true,
		custom_xml_file = "data/entities/misc/custom_cards/enchantment_field.xml",
		action 		= function()
			local fields = EntityGetWithTag( "de_enchantment_field" )

			if #fields > 0 then
				for i=1,#fields do
					EntityKill( fields[i] )
				end
			end

			add_projectile("data/entities/projectiles/deck/enchantment_field.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
		end,
	},
	{
		id          = "DE_GUIDANCE_FIELD",
		name 		= "$dguidance_field",
		description = "$ddguidance_field",
		sprite 		= "data/ui_gfx/gun_actions/guidance_field.png",
		related_projectiles	= {"data/entities/projectiles/deck/guidance_field.xml"},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "0,2,5,7", -- SHIELD_FIELD
		spawn_probability                 = "0.3,0.4,0.5,0.05", -- SHIELD_FIELD
		price = 250,
		mana = 120,
		max_uses = 3,
		never_unlimited = true,
		action 		= function()
			local fields = EntityGetWithTag( "de_guidance_field" )

			if #fields > 0 then
				for i=1,#fields do
					EntityKill( fields[i] )
				end
			end

			add_projectile("data/entities/projectiles/deck/guidance_field.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
		end,
	},
	{
		id          = "DE_STP_FIELD",
		name 		= "$dassimilation_field",
		description = "$ddassimilation_field",
		sprite 		= "data/ui_gfx/gun_actions/assimilation_field.png",
		related_projectiles	= {"data/entities/projectiles/deck/assimilation_field.xml"},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "0,3,4,7", -- SHIELD_FIELD
		spawn_probability                 = "0.3,0.4,0.5,0.05", -- SHIELD_FIELD
		price = 250,
		mana = 90,
		max_uses = 3,
		never_unlimited = true,
		action 		= function()
			local fields = EntityGetWithTag( "de_assimilation_field" )

			if #fields > 0 then
				for i=1,#fields do
					EntityKill( fields[i] )
				end
			end

			add_projectile("data/entities/projectiles/deck/assimilation_field.xml")
			c.fire_rate_wait = c.fire_rate_wait + 15
		end,
	},
	{
		id          = "DE_DARK_SWORD",
		name 		= "$DARK_SWORD",
		description = "$dDARK_SWORD",
		sprite 		= "data/ui_gfx/gun_actions/dark_sword.png",
		related_projectiles	= {"data/entities/projectiles/deck/dark_sword.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "4,5,6,7,10", -- SPIRAL_SHOT
		spawn_probability                 = "1,1,1,1,1", -- SPIRAL_SHOT
		price = 233,
		mana = 66,
		max_uses = 36,
		custom_xml_file = "data/entities/misc/custom_cards/dark_sword.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/dark_sword.xml")
			c.fire_rate_wait = c.fire_rate_wait + 22
			shot_effects.recoil_knockback = 13.0
			c.screenshake = c.screenshake + 1.3
		end,
	},
	{
		id          = "DE_ORDER",
		name 		= "$ORDER",
		description = "$dORDER",
		sprite 		= "data/ui_gfx/gun_actions/order.png",
		related_projectiles	= {"data/entities/projectiles/deck/order_projectile_ex.xml"},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "6,7,10",
		spawn_probability                 = "1,1,1",
		price = 400,
		mana = 175,
		max_uses = 15,
		custom_xml_file = "data/entities/misc/custom_cards/de_order.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/order.xml")
			c.extra_entities = c.extra_entities .. "data/entities/misc/order_trajectory.xml,"
			c.spread_degrees = 9.0
			c.fire_rate_wait = c.fire_rate_wait + 24
			c.speed_multiplier = math.max( c.speed_multiplier * 0.25, 0 )
			shot_effects.recoil_knockback = shot_effects.recoil_knockback - 15.0
			current_reload_time = current_reload_time + 27
		end,
	},
	{
		id          = "DE_UAV",
		name 		= "$UAV",
		description = "$dUAV",
		sprite 		= "data/ui_gfx/gun_actions/uav.png",
		related_projectiles	= {"data/entities/projectiles/deck/uav_projectile_ex.xml"},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "2,4,5,6,7,10", -- SPIRAL_SHOT
		spawn_probability                 = "1,1,1,1,1,1", -- SPIRAL_SHOT
		price = 400,
		mana = 110,
		max_uses = 30,
		custom_xml_file = "data/entities/misc/custom_cards/de_uav.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/uav.xml")
			c.spread_degrees = c.spread_degrees + 90.0
			c.fire_rate_wait = c.fire_rate_wait + 24
			c.speed_multiplier = math.max( c.speed_multiplier * 0.25, 0 )
			shot_effects.recoil_knockback = shot_effects.recoil_knockback - 15.0
			current_reload_time = current_reload_time + 24
		end,
	},
	{
		id          = "DE_INF_TRAIN",
		name 		= "$INF_TRAIN",
		description = "$dINF_TRAIN",
		sprite 		= "data/ui_gfx/gun_actions/inf_train.png",
		related_projectiles	= {"data/entities/projectiles/deck/inf_train_physics.xml"},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "10",
		spawn_probability                 = "0.02",
		price = 200,
		mana = 720, 
		max_uses = 4, 
		custom_xml_file = "data/entities/misc/custom_cards/inf_train.xml",
		action 		= function()
			local players = EntityGetWithTag( "player_unit" )

			if players[1] ~= nil then
				local x,y = EntityGetTransform( players[1] )
				local trians = EntityGetInRadiusWithTag( x, y, 512, "de_inf_train" )
			
				if trians[1] == nil then
					add_projectile("data/entities/projectiles/deck/inf_train_guidance.xml")
					
					c.screenshake = 256
					shot_effects.recoil_knockback = shot_effects.recoil_knockback - 15.0
				else
					local comps = EntityGetComponent( trians[1], "VariableStorageComponent" )

					if comps[3] ~= nil then
					for i,comp in ipairs( comps ) do
					if ComponentGetValue2( comp, "name" ) == "num" then
						ComponentSetValue2( comp, "value_int", clamp( ComponentGetValue2( comp, "value_int" ) + 1, 3, 13 ) )			
					end end end

					mana = mana + 640
				end
			end

			c.spread_degrees = 12.0
			c.fire_rate_wait = c.fire_rate_wait + 48
			c.speed_multiplier = clamp( c.speed_multiplier * 0.25, 0, 0.5 )
			current_reload_time = current_reload_time + 8
		end,
	},
	{
		id          = "DE_METEOR_RAIN",
		name 		= "$action_meteor_rain",
		description = "$dMETEOR_RAIN",
		sprite 		= "data/ui_gfx/gun_actions/de_meteor_rain.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/bomb_unidentified.png",
		related_projectiles	= { "data/entities/projectiles/deck/meteor_rain_newsun.xml" },
		related_extra_entities = { "data/entities/misc/de_effect_meteor_rain.xml" },
		-- spawn_requires_flag = "card_unlocked_rain",
		-- never_unlimited		= true,
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "6,7,10",
		spawn_probability                 = "1,1,1",
		price = 300,
		mana = 575, 
		max_uses = 2, 
		custom_xml_file = "data/entities/misc/custom_cards/de_meteor_rain.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/de_meteor_rain.xml")
			c.extra_entities = c.extra_entities .. "data/entities/misc/de_effect_meteor_rain.xml,"
			c.damage_fire_add = c.damage_fire_add + 0.96
			c.speed_multiplier = math.max( c.speed_multiplier * 0.25, 0 )
			c.fire_rate_wait = c.fire_rate_wait + 54
			current_reload_time = current_reload_time + 54
		end,
	},
	{
		id          = "DE_CLEAVE",
		name 		= "$CLEAVE",
		description = "$dCLEAVE",
		sprite 		= "data/ui_gfx/gun_actions/katana_arc_slash.png",
		related_projectiles	= {"data/entities/projectiles/deck/projectile_arc_slash_ex.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "3,4,5,6,7,10", -- SPIRAL_SHOT
		spawn_probability                 = "1,1,1,1,1,1", -- SPIRAL_SHOT
		price = 200,
		mana = 75,
		max_uses = 20 * 3,
		custom_xml_file = "data/entities/misc/custom_cards/de_cleave.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/projectile_circle_slash.xml")
			add_projectile("data/entities/projectiles/deck/projectile_arc_slash.xml")
			add_projectile("data/entities/projectiles/deck/projectile_circle_slash.xml")
			c.fire_rate_wait = c.fire_rate_wait + 10
		end,
	},
	{
		id          = "DE_SLASH_DOWN",
		name 		= "$SLASH_DOWN",
		description = "$dSLASH_DOWN",
		sprite 		= "data/ui_gfx/gun_actions/katana_cross_slash.png",
		related_projectiles	= {"data/entities/projectiles/deck/projectile_cross_slash_ex.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "3,4,5,6,7,10", -- SPIRAL_SHOT
		spawn_probability                 = "1,1,1,1,1,1", -- SPIRAL_SHOT
		price = 240,
		mana = 100,
		max_uses = 20 * 3,
		custom_xml_file = "data/entities/misc/custom_cards/de_slash.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/projectile_circle_slash.xml")
			add_projectile("data/entities/projectiles/deck/projectile_cross_slash.xml")
			add_projectile("data/entities/projectiles/deck/projectile_circle_slash.xml")
			c.fire_rate_wait = c.fire_rate_wait + 14
		end,
	},
	{
		id          = "DE_THRUST",
		name 		= "$THRUST",
		description = "$dTHRUST",
		sprite 		= "data/ui_gfx/gun_actions/thrust.png",
		related_projectiles	= {"data/entities/projectiles/deck/thrust.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "1,2,3,4,5,7", -- SPIRAL_SHOT
		spawn_probability                 = "1,1,1,1,1,1", -- SPIRAL_SHOT
		-- spawn_requires_flag = "card_unlocked_black_hole",
		price = 110,
		mana = 10,
		max_uses = 75,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/thrust.xml")
			c.spread_degrees = c.spread_degrees + 15
			c.fire_rate_wait = c.fire_rate_wait - 2
			current_reload_time = current_reload_time + 2
		end,
	},
	{
		id          = "DE_GFUEL",
		name 		= "$GFUEL",
		description = "$dGFUEL",
		sprite 		= "data/ui_gfx/gun_actions/g_fuel.png",
		related_projectiles	= {"data/entities/projectiles/deck/epinephrine.xml"},
		type 		= ACTION_TYPE_UTILITY,
		spawn_level       = "0,1,2,3,4,5,6", -- X_RAY
		spawn_probability = "1,1,1,1,1,1,1", -- X_RAY
		price = 170,
		mana = 0,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/epinephrine.xml")
		end,
	},
	{
		id          = "DE_CHARGE",
		name 		= "$CHARGE",
		description = "$dCHARGE",
		sprite 		= "data/ui_gfx/gun_actions/charge.png",
		related_projectiles	= {"data/entities/misc/mana_from_spell.xml"},
		type 		= ACTION_TYPE_UTILITY,
		spawn_level       = "0,1,2,3,4,5,6", -- X_RAY
		spawn_probability = "1,1,1,1,1,1,1", -- X_RAY
		price = 200,
		mana = 0,
		action 		= function()
			local entity_id, eid = GetUpdatedEntityID(), nil

			if entity_id ~= nil and entity_id ~= NULL_ENTITY then
				local px, py = EntityGetTransform( entity_id )

				if EntityHasTag( entity_id, "de_effect_charge" ) then
    				eid = EntityLoad( "data/entities/misc/mana_from_spell_init.xml", px, py )
				else
					eid = EntityLoad( "data/entities/misc/mana_from_spell.xml", px, py )

					EntityAddTag( entity_id, "de_effect_charge" )
				end

				EntityAddChild( entity_id, eid )
			end

			-- c.screenshake = c.screenshake + clamp( math.floor( mana * 0.04 - 3 ), -0.5, 16.0 )
			if GameGetFrameNum() < 60 then
				c.fire_rate_wait = c.fire_rate_wait + 20
				current_reload_time = current_reload_time + 20
			else
				c.fire_rate_wait = c.fire_rate_wait - math.min( math.floor( mana * 0.08 - 20 ), 10 )
				current_reload_time = current_reload_time - math.min( math.floor( mana * 0.08 - 20 ), 10 )
			end
			
			mana = clamp( math.ceil( mana * 0.5 ), 25, 200 )
		end,
	},
	{
		id          = "DE_CAPE_PURIFY",
		name 		= "$CAPE_PURIFY",
		description = "$dCAPE_PURIFY",
		sprite 		= "data/ui_gfx/gun_actions/cape_purification.png",
		type 		= ACTION_TYPE_UTILITY,
		related_projectiles	= {"data/entities/misc/cape_purification.xml"},
		spawn_level       = "0,1,2,3,4,5,6,10", -- X_RAY
		spawn_probability = "1,1,1,1,1,1,1,0.3", -- X_RAY
		price = 10,
		mana = 10,
		action 		= function()
			local entity_id = GetUpdatedEntityID()

			if ( entity_id ~= nil ) and ( entity_id ~= NULL_ENTITY ) then
				local px, py = EntityGetTransform( entity_id )

    			local eid = EntityLoad( "data/entities/misc/cape_purification.xml", px, py )
    			EntityAddChild( entity_id, eid )
			end

			c.fire_rate_wait = c.fire_rate_wait + 20
			current_reload_time = current_reload_time + 20
		end,
	},
	{
		id          = "DE_HAEMOSPASIA",
		name 		= "$HAEMOSPASIA",
		description = "$dHAEMOSPASIA",
		sprite 		= "data/ui_gfx/gun_actions/haemospasia.png",
		type 		= ACTION_TYPE_UTILITY,
		spawn_level       = "0,1,2,3,4,5,6,10", -- X_RAY
		spawn_probability = "1,1,1,1,1,1,1,0.3", -- X_RAY
		price = 10,
		max_uses = 8,
		mana = 0,
		action 		= function()
			local entity_id, eid = GetUpdatedEntityID(), nil

			if entity_id ~= nil and entity_id ~= NULL_ENTITY then
				local px, py = EntityGetTransform( entity_id )

				if EntityHasTag( entity_id, "de_effect_cannon" ) then
    				eid = EntityLoad( "data/entities/misc/glass_cannon_short_init.xml", px, py )
				else
					eid = EntityLoad( "data/entities/misc/effect_glass_cannon_short.xml", px, py )

					EntityAddTag( entity_id, "de_effect_cannon" )
				end

				EntityAddChild( entity_id, eid )
				EntityInflictDamage( entity_id, 0.16, "DAMAGE_HEALING", "Haemospasia", "NONE", 0, 0, entity_id )
				-- EntityAddRandomStains( entity_id, CellFactory_GetType("blood"), 600 )
				GamePlaySound( "data/audio/Desktop/animals.bank", "animals/boss_centipede/damage/projectile", px, py )
			end

			c.fire_rate_wait = c.fire_rate_wait + 12
		end,
	},
	{
		id          = "DE_DIPLOMANA",
		name 		= "$DIPLOMANA",
		description = "$dDIPLOMANA",
		sprite 		= "data/ui_gfx/gun_actions/diplomana.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "5,6,7,10", -- MANA_REDUCE
		spawn_probability                 = "0.1,0.2,0.3,0.4", -- MANA_REDUCE
		price = 1024,
		mana = 0,
		max_uses = 0,
		never_unlimited = true,
		custom_xml_file = "data/entities/misc/custom_cards/diplomana.xml",
		action 		= function()
			c.fire_rate_wait = c.fire_rate_wait + math.floor( clamp( mana, 0, 240 ) * 0.16667 ) * 6 -- close to 1 mana : 1 frame delay
			mana = mana + clamp( mana, 0, 1000 )

			draw_actions( 1, true )
		end,
	},
	{
		id          = "DE_HERITABLE_BULLET",
		name 		= "$HERITABLE_BULLET",
		description = "$dHERITABLE_BULLET",
		sprite 		= "data/ui_gfx/gun_actions/heritable_bullet.png",
		related_projectiles	= {"data/entities/projectiles/deck/heritable_bullet.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                         = "4,5,6,7,10", -- LIGHT_BULLET_TRIGGER_2
		spawn_probability                   = "0.4,0.5,0.5,0.5,0.5", -- LIGHT_BULLET_TRIGGER_2
		price = 250,
		mana = 12,
		max_uses = 9999,
		custom_xml_file = "data/entities/misc/custom_cards/heritable_bullet.xml",
		action 		= function()
			c.screenshake = 1.2
			c.fire_rate_wait = c.fire_rate_wait + 7
			current_reload_time = current_reload_time + 7
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 12.0

			local heritance = {}
			heritance.damage_melee_add = c.damage_melee_add
            heritance.damage_drill_add = c.damage_drill_add
            heritance.damage_slice_add = c.damage_slice_add
            heritance.damage_fire_add = c.damage_fire_add
            heritance.damage_ice_add = c.damage_ice_add
            heritance.damage_electricity_add = c.damage_electricity_add
            heritance.damage_curse_add = c.damage_curse_add
            heritance.damage_healing_add = c.damage_healing_add
            heritance.damage_explosion_add = c.damage_explosion_add
            heritance.damage_explosion = c.damage_explosion
			heritance.explosion_radius = c.explosion_radius
 			heritance.damage_projectile_add = c.damage_projectile_add
            heritance.damage_critical_chance = c.damage_critical_chance
            heritance.damage_null_all = c.damage_null_all
            heritance.gore_particles = c.gore_particles
			heritance.knockback_force = c.knockback_force
			heritance.trail_material = c.trail_material
			heritance.trail_material_amount = c.trail_material_amount
			heritance.extra_entities = c.extra_entities
			heritance.game_effect_entities = c.game_effect_entities
			heritance.lifetime_add = c.lifetime_add
			heritance.bounces = c.bounces
			heritance.gravity = c.gravity
			heritance.speed_multiplier = c.speed_multiplier
			heritance.spread_degrees = c.spread_degrees
			heritance.pattern_degrees = c.pattern_degrees
			-- friendly_fire

			DEEP_END_SPELLS_add_projectile_trigger_heritable(heritance,"data/entities/projectiles/deck/heritable_bullet.xml",150)
		end,
	},
	{
		id          = "DE_STICKY_BOMB",
		name 		= "$STICKY_BOMB",
		description = "$dSTICKY_BOMB",
		sprite 		= "data/ui_gfx/gun_actions/bomb_sticky.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/bomb_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/bomb_sticky_shoot.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5", -- GLITTER_BOMB
		spawn_probability                 = "0.3,0.25,0.2,0.15,0.1,0.05", -- GLITTER_BOMB
		price = 200,
		mana = 45, 
		max_uses    = 6, 
		custom_xml_file = "data/entities/misc/custom_cards/bomb_sticky.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/bomb_sticky_shoot.xml")
			c.fire_rate_wait = c.fire_rate_wait + 35
		end,
	},
	{
		id          = "DE_BOUNCY_BOMB",
		name 		= "$BOUNCY_BOMB",
		description = "$dBOUNCY_BOMB",
		sprite 		= "data/ui_gfx/gun_actions/bomb_bouncy.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/bomb_unidentified.png",
		related_projectiles	= {"data/entities/projectiles/bomb_bouncy.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5", -- GLITTER_BOMB
		spawn_probability                 = "0.3,0.25,0.2,0.15,0.1,0.05", -- GLITTER_BOMB
		price = 200,
		mana = 50, 
		max_uses    = 6, 
		custom_xml_file = "data/entities/misc/custom_cards/bomb_bouncy.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/bomb_bouncy.xml")
			c.fire_rate_wait = c.fire_rate_wait + 35
		end,
	},
	{
		id          = "DE_DAMAGE_TO_TIME",
		name 		= "$DAMAGE_TO_TIME",
		description = "$dDAMAGE_TO_TIME",
		sprite 		= "data/ui_gfx/gun_actions/damage_fallout.png",
		related_extra_entities = { "data/entities/particles/light_shot.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "4,5,6,7,10",
		spawn_probability                 = "1,1,1,1,0.5",
		price = 250,
		mana = 50,
		-- never_unlimited = true,
		action 		= function()
			local dmg_add = math.floor( c.damage_projectile_add * 25 )

			-- c.damage_projectile_add = 0
			c.gore_particles    = 0
			c.lifetime_add 		= c.lifetime_add + dmg_add
			c.extra_entities    = c.extra_entities .. "data/entities/particles/tinyspark_red.xml,"
			-- c.game_effect_entities = ""
			c.trail_material_amount = 0

			shot_effects.recoil_knockback = shot_effects.recoil_knockback - 10.0
			draw_actions( 1, true )
		end,
	},
	{
		id          = "DE_PUTREFY",
		name 		= "$PUTREFY",
		description = "$dPUTREFY",
		-- spawn_requires_flag = "card_unlocked_necromancy",
		sprite 		= "data/ui_gfx/gun_actions/putrefy.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/explosive_projectile_unidentified.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4,5,7,10", -- NECROMANCY
		spawn_probability                 = "1,1,1,1,1,0.5", -- NECROMANCY
		price = 200,
		mana = 24,
		action 		= function()
			c.game_effect_entities = c.game_effect_entities .. "data/entities/misc/effect_disintegrated.xml,data/entities/misc/effect_apply_poison.xml,"
			c.damage_curse_add = c.damage_curse_add + 0.33
			c.fire_rate_wait = c.fire_rate_wait + 13
			draw_actions( 1, true )
		end,
	},
	{
		id          = "DE_METALLIZATION",
		name 		= "$METALLIZATION",
		description = "$dMETALLIZATION",
		-- spawn_requires_flag = "card_unlocked_necromancy",
		sprite 		= "data/ui_gfx/gun_actions/metallization.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/explosive_projectile_unidentified.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4,5,10", -- NECROMANCY
		spawn_probability                 = "1,1,1,1,0.1", -- NECROMANCY
		price = 200,
		mana = 13,
		action 		= function()
			SetRandomSeed( GameGetFrameNum() + 81, GameGetFrameNum() + 13 )

			local rnd_a = Random( 7, 13 ) * 3
			local rnd_b = Random( 0, math.floor( rnd_a * 0.34 ) )
			local rnd_c = Random( 0, rnd_a - rnd_b )

			rnd_a = rnd_a - rnd_b - rnd_c + 0.2 * Random( -4, 7 )
			rnd_b = rnd_b + 0.8 * Random( -4, 7 ) * Random( 0, 13 )
			rnd_c = rnd_c + 0.2 * Random( -4, 7 )

			if GameGetFrameNum() > 60 then -- display the average damage
				c.damage_slice_add = c.damage_slice_add + 0.01 * rnd_a
				c.damage_drill_add = c.damage_drill_add + 0.01 * rnd_b
				c.damage_melee_add = c.damage_melee_add + 0.01 * rnd_c

				c.fire_rate_wait = c.fire_rate_wait + Random( 8, 18 )
			else
				c.damage_slice_add = c.damage_slice_add + 0.128
				c.damage_drill_add = c.damage_drill_add + 0.128
				c.damage_melee_add = c.damage_melee_add + 0.128

				c.fire_rate_wait = c.fire_rate_wait + 13
			end
			
			c.extra_entities = c.extra_entities .. "data/entities/misc/hitfx_metallization.xml,"
			draw_actions( 1, true )
		end,
	},
	{
		id          = "DE_HITFX_MIDAS",
		name 		= "$HITFX_MIDAS",
		description = "$dHITFX_MIDAS",
		sprite 		= "data/ui_gfx/gun_actions/petrify_midas.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/explosive_projectile_unidentified.png",
		related_extra_entities = { "data/entities/misc/hitfx_petrify_midas.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,5,6,7,10", -- PETRIFY
		spawn_probability                 = "1,1,1,1,1,0.2", -- PETRIFY
		price = 999,
		mana = 24,
		max_uses = 72,
		custom_xml_file = "data/entities/misc/custom_cards/petrify_midas.xml",
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/hitfx_petrify_midas.xml,"
			draw_actions( 1, true )
		end,
	},
	{
		id          = "DE_RAPE",
		name 		= "$RAPE",
		description = "$dRAPE",
		sprite 		= "data/ui_gfx/gun_actions/bloody_reap.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/explosive_projectile_unidentified.png",
		related_extra_entities = { "data/entities/misc/hitfx_bloody_reap.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		-- spawn_requires_flag = "card_unlocked_divide",
		spawn_level                       = "2,3,5,6,7,10", -- PETRIFY
		spawn_probability                 = "1,1,1,1,1,0.1", -- PETRIFY
		price = 999,
		mana = 32,
		max_uses = 72,
		custom_xml_file = "data/entities/misc/custom_cards/bloody_reap.xml",
		action 		= function()
			local entity_id = GetUpdatedEntityID()
			local dcomps = EntityGetComponent( entity_id, "DamageModelComponent" )
			
			if ( dcomps ~= nil ) and ( #dcomps > 0 ) then
				for a,b in ipairs( dcomps ) do
					local hp = ComponentGetValue2( b, "hp" )
					hp = math.max( hp - 0.16, 0.04 )
					ComponentSetValue2( b, "hp", hp )
				end

				c.extra_entities = c.extra_entities .. "data/entities/misc/hitfx_bloody_reap.xml,"
			else
				mana = math.max( mana + 32, 0 )
			end
	
			draw_actions( 1, true )
		end,
	},
	{
		id          = "DE_SLIVER_BULLET", -- silver bullet
		name 		= "$SLIVER_BULLET",
		description = "$dSLIVER_BULLET",
		sprite 		= "data/ui_gfx/gun_actions/sliver_bullet.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/explosive_projectile_unidentified.png",
		related_extra_entities = { "data/entities/misc/hitfx_sliver_bullet.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "7,10", -- PETRIFY
		spawn_probability                 = "1,0.1", -- PETRIFY
		price = 777,
		mana = 100,
		max_uses = 6,
		never_unlimited = true,
		custom_xml_file = "data/entities/misc/custom_cards/sliver_bullet.xml",
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/hitfx_sliver_bullet.xml,"
			c.damage_critical_chance = c.damage_critical_chance + 20
			draw_actions( 1, true )
		end,
	},
	{
		id          = "DE_CHAIN_BLAST",
		name 		= "$CHAIN_BLAST",
		description = "$dCHAIN_BLAST",
		sprite 		= "data/ui_gfx/gun_actions/blasting_chain_reaction.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/explosive_projectile_unidentified.png",
		related_extra_entities = { "data/entities/misc/blasting_chain_reaction.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,3,5,7,10", -- PETRIFY
		spawn_probability                 = "1,1,1,1,0.1", -- PETRIFY
		price = 512,
		mana = 50,
		custom_xml_file = "data/entities/misc/custom_cards/blasting_chain_reaction.xml",
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/blasting_chain_reaction.xml,"
			c.fire_rate_wait = c.fire_rate_wait + 42
			c.speed_multiplier = math.max( c.speed_multiplier * 0.6, 0 )
			c.screenshake = c.screenshake + 15
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 45.0

			draw_actions( 1, true )
		end,
	},
	{
		id          = "DE_WATER_EXPLODE",
		name 		= "$dUNSTABLE_GUNPOWDER",
		description = "$ddUNSTABLE_GUNPOWDER",
		sprite 		= "data/ui_gfx/gun_actions/de_water_fading.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/unstable_gunpowder_unidentified.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                      = "1,2,3,4", -- UNSTABLE_GUNPOWDER
		spawn_probability                = "1,0.5,0.5,0.5", -- UNSTABLE_GUNPOWDER
		price = 140,
		mana = 2, 
		action 		= function()
			c.material = "water_fading"
			c.material_amount = c.material_amount + 10
			shot_effects.recoil_knockback = math.max( shot_effects.recoil_knockback - 10, 0.0 )
			draw_actions( 1, true )
		end,
	},
	{
		id          = "DE_CEMENT_EXPLODE",
		name 		= "$dARC_GUNPOWDER",
		description = "$ddARC_GUNPOWDER",
		sprite 		= "data/ui_gfx/gun_actions/de_concrete_static.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/arc_fire_unidentified.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,2,3,4", -- ARC_GUNPOWDER
		spawn_probability                 = "1,0.5,0.5,0.5", -- ARC_GUNPOWDER
		price = 160,
		mana = 5,
		action 		= function()
			c.material = "concrete_static"
			c.material_amount = c.material_amount + 100
			shot_effects.recoil_knockback = math.max( shot_effects.recoil_knockback - 10, 0.0 )
			draw_actions( 1, true )
		end,
	},
	{
		id          = "DE_METASTABLE_ARC",
		name 		= "$METASTABLE_ARC",
		description = "$dMETASTABLE_ARC",
		sprite 		= "data/ui_gfx/gun_actions/metastable_trajectory.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/sinewave_unidentified.png",
		related_extra_entities = { "data/entities/misc/metastable_trajectory.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "0,2,4", -- CHAOTIC_ARC
		spawn_probability                 = "1,1,1", -- CHAOTIC_ARC
		price = 300,
		mana = 1,
		--max_uses = 150,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/metastable_trajectory.xml,"
			c.speed_multiplier = math.max( c.speed_multiplier * 0.15, 0 )
			c.lifetime_add = c.lifetime_add + 60
			c.gravity = 0
			
			draw_actions( 1, true )
		end,
	},
	{
		id          = "DE_ORBIT_LARPA",
		name 		= "Orbit Larpa 2.0",
		description = "Makes four copies of a projectile rotate around it (try to stack it!)",
		sprite 		= "data/ui_gfx/gun_actions/de_orbit_larpa.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/electric_charge_unidentified.png",
		related_extra_entities = { "data/entities/misc/de_orbit_larpa.xml" },
		-- spawn_requires_flag = "card_unlocked_dragon",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,4,6,10", -- GRAVITY_FIELD_ENEMY
		spawn_probability                 = "1,1,1,1", -- GRAVITY_FIELD_ENEMY
		price = 240,
		mana = 120,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/de_orbit_larpa.xml,"
			draw_actions( 1, true )
		end,
	},
	{
		id          = "DE_F_T_L",
		name 		= "$F_T_L",
		description = "$dF_T_L",
		sprite 		= "data/ui_gfx/gun_actions/f_t_l.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/explosive_projectile_unidentified.png",
		related_extra_entities = { "data/entities/misc/f_t_l.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,3,5,7", -- PETRIFY
		spawn_probability                 = "1,1,1,1", -- PETRIFY
		price = 512,
		mana = 25,
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/f_t_l.xml,"
			c.game_effect_entities = c.game_effect_entities .. "data/entities/misc/effect_disintegrated.xml,"
			
			c.speed_multiplier = c.speed_multiplier * 1024
			c.screenshake = 128
			draw_actions( 1, true )
		end,
	},
	{
		id          = "DE_HEMOKINESIS",
		name 		= "$HEMOKINESIS",
		description = "$dHEMOKINESIS",
		sprite 		= "data/ui_gfx/gun_actions/hemokinesis.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/explosive_projectile_unidentified.png",
		related_extra_entities = { "data/entities/misc/hemokinesis.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "0,1,2,3,4,10", -- PETRIFY
		spawn_probability                 = "1,1,1,1,1,0.2", -- PETRIFY
		price = 666,
		mana = 10,
		custom_xml_file = "data/entities/misc/custom_cards/hemokinesis.xml",
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/misc/hemokinesis.xml,"
			draw_actions( 1, true )
		end,
	},
	{
		id          = "DE_SCATTER_32",
		name 		= "$SCATTER_32",
		description = "$dSCATTER_32",
		sprite 		= "data/ui_gfx/gun_actions/scatter_32.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/scatter_4_unidentified.png",
		type 		= ACTION_TYPE_DRAW_MANY,
		-- spawn_requires_flag = "card_unlocked_musicbox",
		spawn_level                       = "3,4,10", -- SCATTER_4
		spawn_probability                 = "1,1,0.2", -- SCATTER_4
		price = 140,
		mana = 16,
		max_uses = 125,
		action 		= function()
			draw_actions( 32, true )
			c.spread_degrees = c.spread_degrees + 180.0
		end,
	},
	{
		id          = "DE_SINGLE_SHAPE",
		name 		= "$SINGLE_SHAPE",
		description = "$dSINGLE_SHAPE",
		sprite 		= "data/ui_gfx/gun_actions/single_shape.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/i_shape_unidentified.png",
		type 		= ACTION_TYPE_DRAW_MANY,
		-- spawn_requires_flag = "card_unlocked_musicbox",
		spawn_level                       = "0,1,2", -- I_SHAPE
		spawn_probability                 = "0.5,0.5,0.5", -- I_SHAPE
		price = 10,
		mana = 0,
		action 		= function()
			draw_actions(1, true)
			c.pattern_degrees = 0.5
			c.spread_degrees = math.min( c.spread_degrees - 2.0, 180.0 )
		end,
	},
	{
		id          = "DE_INF_SHOT",
		name 		= "$INF_SHOT",
		description = "$dINF_SHOT",
		sprite 		= "data/ui_gfx/gun_actions/inf_shot.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/i_shape_unidentified.png",
		type 		= ACTION_TYPE_UTILITY,
		spawn_level                       = "4,5,6,7,10", -- I_SHAPE
		spawn_probability                 = "1,1,1,1,0.5", -- I_SHAPE
		price = 330,
		mana = 30,
		max_uses = 4,
		action 		= function()
			local degrees, count = 180, 0
			local data, proj, proj_count, mana_need
			
			if #deck > 0 then data = deck[1] end

			-- won't check ACTION_TYPE now
			if data ~= nil and data.related_projectiles ~= nil
				and ( data.uses_remaining == nil or data.uses_remaining ~= 0 )
			then
				proj = data.related_projectiles[1]
				proj_count = data.related_projectiles[2] or 1

				proj_count = math.max( proj_count, 1 )
				mana_need = data.mana / proj_count

				mana_need = math.max( mana_need, 0.01 )
				count = math.floor( mana / mana_need )

				if count > 0 then
					proj_count = math.max( proj_count, 180 - proj_count )
					count = math.min( count, proj_count )

					mana_need = math.ceil( mana_need * count )
					mana = clamp( mana - mana_need, 0, mana )

					degrees = clamp( count * 5 - 5, 0.5, degrees )
					for i=1,count do add_projectile( proj ) end
				else
					OnNotEnoughManaForAction()
				end
			end
			
			c.pattern_degrees = degrees
			c.spread_degrees = math.min( c.spread_degrees - 10.0, 180.0 )
			c.fire_rate_wait = c.fire_rate_wait + 20
			current_reload_time = current_reload_time + 20
			
			draw_actions( 1, true )
		end,
	},
	{
		id          = "DE_MULT_TRIGGER",
		name 		= "$MULT_TRIGGER",
		description = "$dMULT_TRIGGER",
		sprite 		= "data/ui_gfx/gun_actions/mult_trigger.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/damage_unidentified.png",
		type 		= ACTION_TYPE_UTILITY,
		spawn_level                       = "5,6,7,10", -- I_SHAPE
		spawn_probability                 = "1,1,1,0.5", -- I_SHAPE
		price = 360,
		mana = 60,
		action 		= function()
			if #deck > 0 then
				local data,find
				local timer_list = {-3,-3,-3}
				local length_max = clamp( #deck, 1, 31 )

				for i=1,#deck do
					data = deck[i]
					
					if ( data == nil ) or ( i > length_max ) then
						draw_actions( 1, false )
						break
					elseif ( data.related_projectiles ~= nil ) and ( ( data.uses_remaining == nil ) or ( data.uses_remaining ~= 0 ) ) then
						find = i
						break
					elseif data.id == "DE_MULT_TRIGGER" then
						table.insert( timer_list, -3 )
						table.insert( timer_list, -3 )
					elseif data.id == "DE_MULT_DEATH" then
						table.insert( timer_list, 0 )
						table.insert( timer_list, 0 )
					elseif data.id == "DE_MULT_TIMER" then
						table.insert( timer_list, timer_list[#timer_list] + 15 )
						table.insert( timer_list, timer_list[#timer_list] + 15 )
					else
						draw_actions( 1, true )
						break
					end
				end

				if find ~= nil then
					for i=1,find do
						if #deck == 0 then break end
						
						table.insert( discarded, deck[1] )
						table.remove( deck, 1 )
					end

					DEEP_END_SPELLS_add_projectile_trigger_customized( data.related_projectiles[1], timer_list, nil, false )
				end
			end

			c.fire_rate_wait = math.min( c.fire_rate_wait + 26, 26 )
			current_reload_time = math.max( current_reload_time + 26, 26 )
		end,
	},
	{
		id          = "DE_MULT_TIMER",
		name 		= "$MULT_TIMER",
		description = "$dMULT_TIMER",
		sprite 		= "data/ui_gfx/gun_actions/mult_timer.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/damage_unidentified.png",
		type 		= ACTION_TYPE_UTILITY,
		spawn_level                       = "5,6,7,10", -- I_SHAPE
		spawn_probability                 = "1,1,1,0.5", -- I_SHAPE
		price = 360,
		mana = 55,
		action 		= function()
			if #deck > 0 then
				local data,find
				local timer_list = {15,30,45}
				local length_max = clamp( #deck, 1, 31 )

				for i=1,#deck do
					data = deck[i]
					
					if ( data == nil ) or ( i > length_max ) then
						draw_actions( 1, false )
						break
					elseif ( data.related_projectiles ~= nil ) and ( ( data.uses_remaining == nil ) or ( data.uses_remaining ~= 0 ) ) then
						find = i
						break
					elseif data.id == "DE_MULT_TRIGGER" then
						table.insert( timer_list, -3 )
						table.insert( timer_list, -3 )
					elseif data.id == "DE_MULT_DEATH" then
						table.insert( timer_list, 0 )
						table.insert( timer_list, 0 )
					elseif data.id == "DE_MULT_TIMER" then
						table.insert( timer_list, timer_list[#timer_list] + 15 )
						table.insert( timer_list, timer_list[#timer_list] + 15 )
					else
						draw_actions( 1, true )
						break
					end
				end

				if find ~= nil then
					for i=1,find do
						if #deck == 0 then break end
						
						table.insert( discarded, deck[1] )
						table.remove( deck, 1 )
					end

					DEEP_END_SPELLS_add_projectile_trigger_customized( data.related_projectiles[1], timer_list, nil, false )
				end
			end

			c.fire_rate_wait = math.min( c.fire_rate_wait + 26, 26 )
			current_reload_time = math.max( current_reload_time + 26, 26 )
		end,
	},
	{
		id          = "DE_MULT_DEATH",
		name 		= "$MULT_DEATH",
		description = "$dMULT_DEATH",
		sprite 		= "data/ui_gfx/gun_actions/mult_death.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/damage_unidentified.png",
		type 		= ACTION_TYPE_UTILITY,
		spawn_level                       = "5,6,7,10", -- I_SHAPE
		spawn_probability                 = "1,1,1,0.5", -- I_SHAPE
		price = 360,
		mana = 50,
		action 		= function()
			if #deck > 0 then
				local data,find
				local timer_list = {0,0,0}
				local length_max = clamp( #deck, 1, 31 )

				for i=1,#deck do
					data = deck[i]
					
					if ( data == nil ) or ( i > length_max ) then
						draw_actions( 1, false )
						break
					elseif ( data.related_projectiles ~= nil ) and ( ( data.uses_remaining == nil ) or ( data.uses_remaining ~= 0 ) ) then
						find = i
						break
					elseif data.id == "DE_MULT_TRIGGER" then
						table.insert( timer_list, -3 )
						table.insert( timer_list, -3 )
					elseif data.id == "DE_MULT_DEATH" then
						table.insert( timer_list, 0 )
						table.insert( timer_list, 0 )
					elseif data.id == "DE_MULT_TIMER" then
						table.insert( timer_list, timer_list[#timer_list] + 15 )
						table.insert( timer_list, timer_list[#timer_list] + 15 )
					else
						draw_actions( 1, true )
						break
					end
				end

				if find ~= nil then
					for i=1,find do
						if #deck == 0 then break end
						
						table.insert( discarded, deck[1] )
						table.remove( deck, 1 )
					end

					DEEP_END_SPELLS_add_projectile_trigger_customized( data.related_projectiles[1], timer_list, nil, false )
				end
			end

			c.fire_rate_wait = math.min( c.fire_rate_wait + 26, 26 )
			current_reload_time = math.max( current_reload_time + 26, 26 )
		end,
	},
	{
		id          = "DE_CAST_FOLD",
		name 		= "$CAST_FOLD",
		description = "$dCAST_FOLD",
		sprite 		= "data/ui_gfx/gun_actions/cast_fold.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		type 		= ACTION_TYPE_UTILITY,
		spawn_level                       = "6,7,10", -- I_SHAPE
		spawn_probability                 = "1,1,1", -- I_SHAPE
		price = 10,
		mana = 0,
		action 		= function()
			draw_actions( 0, false )
			dont_draw_actions = true
			reloading = true -- stop drawing anything until next cast
		end,
	},
	{
		id          = "DE_SAKUYA",
		name 		= "$SAKUYA",
		description = "$dSAKUYA",
		sprite 		= "data/ui_gfx/gun_actions/maid_knife.png",
		related_projectiles	= {"data/entities/projectiles/deck/summon_knife_freeze_timer.xml"},
		type 		= ACTION_TYPE_UTILITY,
		spawn_level                       = "6,7,10",
		spawn_probability                 = "1,1,1",
		price = 560,
		mana = 0,
		max_uses = 360,
		custom_xml_file = "data/entities/misc/custom_cards/maid_knife.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/knife_summon.xml")
			c.damage_projectile_add = math.min( c.damage_projectile_add - 0.16, -0.16 )
			c.damage_critical_chance = c.damage_critical_chance + 16
			c.spread_degrees = c.spread_degrees - 360.0
			c.speed_multiplier = c.speed_multiplier * 2.0
			c.fire_rate_wait = 9												-- the best shoot speed
			shot_effects.recoil_knockback = 0.0
		end,
	},
	{
		id          = "DE_I_NEED_MORE_POWER",
		name 		= "$I_NEED_MORE_POWER",
		description = "$dI_NEED_MORE_POWER",
		sprite 		= "data/ui_gfx/gun_actions/summon_sword.png",
		related_projectiles	= {"data/entities/projectiles/deck/summon_sword_shoot_powerful.xml"},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "6,7,10",
		spawn_probability                 = "1,1,1",
		price = 600,
		mana = 27,
		max_uses = 666,
		custom_xml_file = "data/entities/misc/custom_cards/summon_sword.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/sword_summon.xml")
			c.damage_projectile_add = c.damage_projectile_add + 0.52
			c.damage_critical_chance = c.damage_critical_chance + 24
			c.spread_degrees = c.spread_degrees - 30.0
			c.speed_multiplier = c.speed_multiplier * 2.0
			shot_effects.recoil_knockback = shot_effects.recoil_knockback - 2.0
			current_reload_time = current_reload_time + 6
		end,
	},
	{
		id          = "DE_MELODY",
		name 		= "$MELODY",
		description = "$dMELODY",
		sprite 		= "data/ui_gfx/gun_actions/melody.png",
		related_projectiles	= {"data/entities/projectiles/deck/melody_star.xml",2},
		type 		= ACTION_TYPE_UTILITY,
		spawn_level                       = "6,7,10",
		spawn_probability                 = "1,1,1",
		price = 400,
		mana = 12,
		max_uses    = 1437, 
		custom_xml_file = "data/entities/misc/custom_cards/de_note.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/melody.xml")
			if c.damage_critical_chance > 7 then c.damage_critical_chance = 7 end
			c.extra_entities = c.extra_entities .. "data/entities/misc/melody_trajectory.xml,"
			c.spread_degrees = -12
			c.fire_rate_wait = 6
			current_reload_time = math.floor( current_reload_time * 0.6 )
			shot_effects.recoil_knockback = -math.abs( shot_effects.recoil_knockback )
		end,
	},
	{
		id          = "DE_ULTIMATE",
		name 		= "$ULTIMATE",
		description = "$dULTIMATE",
		sprite 		= "data/ui_gfx/gun_actions/ultimate_spark.png",
		related_projectiles	= {"data/entities/projectiles/deck/ultimate_flash.xml"},
		type 		= ACTION_TYPE_UTILITY,
		spawn_level                       = "6,7,10",
		spawn_probability                 = "1,1,1",
		-- spawn_requires_flag = "card_unlocked_everything",
		price = 600,
		mana = DE_ULTIMATE_MANA,
		-- max_uses    = 12, 
		custom_xml_file = "data/entities/misc/custom_cards/ultimate_spark.xml",
		action 		= function()
			local players = EntityGetWithTag( "player_unit" )
			if ( #players > 0 ) then
				local pid = players[1]
				local x,y = EntityGetTransform( pid )
				local ultra = EntityGetInRadiusWithTag( x, y, 512, "ultra" )
			
				if ( #ultra < 1 ) then
					add_projectile("data/entities/projectiles/deck/ultimate_spark.xml")
					c.spread_degrees = -720
					shot_effects.recoil_knockback = -90
					c.fire_rate_wait = 54
					current_reload_time = current_reload_time * 0.5 + 42
				else
					c.damage_critical_chance = math.ceil( c.damage_critical_chance * 1.2 )
					mana = mana + DE_ULTIMATE_MANA -- how to use this mechanism
				end
			end
		end,
	},
	{
		id          = "DE_RAT_SUMMON",
		name 		= "$RAT_SUMMON",
		description = "$dRAT_SUMMON",
		sprite 		= "data/ui_gfx/gun_actions/rat_summon.png",
		type 		= ACTION_TYPE_PASSIVE,
		spawn_level                       = "0,1,2,3,4", -- TORCH
		spawn_probability                 = "0.5,0.5,0.5,0.5,0.5", -- TORCH
		price = 100,
		mana = 2,
		-- max_uses    = 0,
		custom_xml_file = "data/entities/misc/custom_cards/rat_summon.xml",
		action 		= function()
			draw_actions( 1, true ) -- draw_actions( 1, false ) in mod DEEP END
		end,
	},
	{
		id          = "DE_SNIPERSCOPE",
		name 		= "$SNIPERSCOPE",
		description = "$dSNIPERSCOPE",
		sprite 		= "data/ui_gfx/gun_actions/sniperscope.png",
		type 		= ACTION_TYPE_PASSIVE,
		spawn_level                       = "1,2,3,4,5,6",
		spawn_probability                 = "0.2,0.2,0.2,0.2,0.3,0.3",
		price = 300,
		mana = 25,
		-- max_uses    = 0,
		ai_never_uses = true,
		custom_xml_file = "data/entities/misc/custom_cards/sniperscope.xml",
		action 		= function()
			c.fire_rate_wait = c.fire_rate_wait + 12
			current_reload_time = current_reload_time + 12
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 12
			draw_actions( 1, true ) -- draw_actions( 1, false ) in mod DEEP END
		end,
	},
	{
		id          = "DE_FLOATING_WANNO",
		name 		= "$FLOATING_WANNO",
		description = "$dFLOATING_WANNO",
		sprite 		= "data/ui_gfx/gun_actions/plankter_wand.png",
		type 		= ACTION_TYPE_PASSIVE,
		spawn_level                       = "1,2,3,4",
		spawn_probability                 = "0.2,0.2,0.2,0.2",
		price = 240,
		mana = 15,
		-- max_uses    = 0,
		ai_never_uses = true,
		custom_xml_file = "data/entities/misc/custom_cards/plankter_wand.xml",
		action 		= function()
			draw_actions( 1, true ) -- draw_actions( 1, false ) in mod DEEP END
		end,
	},
	{
		id          = "DE_SOAHC_ARC_PASSIVE",
		name 		= "$SOAHC_ARC_PASSIVE",
		description = "?...!",
		sprite 		= "data/ui_gfx/gun_actions/sohac_arc_passive.png",
		type 		= ACTION_TYPE_PASSIVE,
		spawn_level                       = "0,1,2,3,4,5,6",
		spawn_probability                 = "0.06,0.06,0.06,0.06,0.06,0.06,0.06",
		price = 0,
		mana = -10,
		-- max_uses    = 0,
		ai_never_uses = true,
		custom_xml_file = "data/entities/misc/custom_cards/sohac_arc_passive.xml",
		action 		= function()
			draw_actions( 1, true ) -- draw_actions( 1, false ) in mod DEEP END
			c.fire_rate_wait = 0
			current_reload_time = 0
			shot_effects.recoil_knockback = 0
		end,
	},
	{
		id          = "DE_DEATH_RAY_TORCH",
		name 		= "$DEATH_RAY_TORCH",
		description = "$dDEATH_RAY_TORCH",
		sprite 		= "data/ui_gfx/gun_actions/death_ray_torch.png",
		type 		= ACTION_TYPE_PASSIVE,
		spawn_level                       = "0,1,2,3,4,5",
		spawn_probability                 = "0.5,0.5,0.5,0.5,0.5,0.5",
		price = 100,
		mana = 0,
		-- max_uses    = 0,
		custom_xml_file = "data/entities/misc/custom_cards/death_ray_torch.xml",
		action 		= function()
			c.game_effect_entities = c.game_effect_entities .. "data/entities/misc/effect_disintegrated.xml,"
			draw_actions( 1, true ) -- draw_actions( 1, false ) in mod DEEP END
		end,
	},
	{
		id          = "DE_GHOSTY_TORCH",
		name 		= "$GHOSTY_TORCH",
		description = "$dGHOSTY_TORCH",
		sprite 		= "data/ui_gfx/gun_actions/ghosty_torch.png",
		type 		= ACTION_TYPE_PASSIVE,
		spawn_level                       = "0,1,2,3,4,5",
		spawn_probability                 = "0.5,0.5,0.5,0.5,0.5,0.5",
		price = 100,
		mana = 0,
		-- max_uses    = 0,
		custom_xml_file = "data/entities/misc/custom_cards/ghosty_torch.xml",
		action 		= function()
			c.extra_entities = c.extra_entities .. "data/entities/particles/freeze_charge.xml,"
			draw_actions( 1, true ) -- draw_actions( 1, false ) in mod DEEP END
		end,
	},
	{
		id          = "DE_LASER_AIM",
		name 		= "$LASER_AIM",
		description = "$dLASER_AIM",
		sprite 		= "data/ui_gfx/gun_actions/laser_aim.png",
		type 		= ACTION_TYPE_PASSIVE,
		spawn_level                       = "0,1,2,3,4,5,6",
		spawn_probability                 = "0.5,0.5,0.5,0.5,0.5,0.5,0.5",
		price = 20,
		mana = 0,
		-- max_uses    = 0,
		custom_xml_file = "data/entities/misc/custom_cards/de_laser_aim.xml",
		action 		= function()
			-- c.spread_degrees = math.min( c.spread_degrees, 30 )
			-- shot_effects.recoil_knockback = math.min( shot_effects.recoil_knockback, 30.0 )
			draw_actions( 1, false ) -- draw_actions( 1, false ) in mod DEEP END
			if c.pattern_degrees > 0.5 then c.pattern_degrees = c.pattern_degrees + 5 end
		end,
	},
	{
		id          = "DE_ENERGY_SHIELD_SATELLITE",
		name 		= "$ENERGY_SHIELD_SATELLITE",
		description = "$dENERGY_SHIELD_SATELLITE",
		sprite 		= "data/ui_gfx/gun_actions/energy_shield_satellite.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/energy_shield_unidentified.png",
		type 		= ACTION_TYPE_PASSIVE,
		spawn_level                       = "1,2,3,4,5,6,7,10", -- ENERGY_SHIELD
		spawn_probability                 = "0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.1", -- ENERGY_SHIELD
		price = 160,
		mana = 2,
		custom_xml_file = "data/entities/misc/custom_cards/energy_shield_satellite.xml",
		action 		= function()
			-- does nothing to the projectiles
			draw_actions( 1, true ) -- draw_actions( 1, false ) in mod DEEP END
		end,
	},
	{
		id          = "DE_ENERGY_SHIELD_BACK",
		name 		= "$ENERGY_SHIELD_BACK",
		description = "$dENERGY_SHIELD_BACK",
		sprite 		= "data/ui_gfx/gun_actions/energy_shield_back.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/energy_shield_unidentified.png",
		type 		= ACTION_TYPE_PASSIVE,
		spawn_level                       = "1,2,3,4,5,6,7,10", -- ENERGY_SHIELD
		spawn_probability                 = "0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.1", -- ENERGY_SHIELD
		price = 220,
		mana = 10,
		-- max_uses    = 0,
		custom_xml_file = "data/entities/misc/custom_cards/energy_shield_back.xml",
		action 		= function()
			-- does nothing to the projectiles
			draw_actions( 1, true ) -- draw_actions( 1, false ) in mod DEEP END
		end,
	},
	{
		id          = "DE_ENERGY_SHIELD_POD",
		name 		= "$ENERGY_SHIELD_POD",
		description = "$dENERGY_SHIELD_POD",
		sprite 		= "data/ui_gfx/gun_actions/energy_shield_pod.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/energy_shield_unidentified.png",
		type 		= ACTION_TYPE_PASSIVE,
		spawn_level                       = "1,2,3,4,5,6,7,10", -- ENERGY_SHIELD
		spawn_probability                 = "0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.1", -- ENERGY_SHIELD
		price = 160,
		mana = 10,
		-- max_uses    = 0,
		custom_xml_file = "data/entities/misc/custom_cards/energy_shield_pod.xml",
		action 		= function()
			-- does nothing to the projectiles
			draw_actions( 1, true ) -- draw_actions( 1, false ) in mod DEEP END
		end,
	},
	{
		id          = "DE_TELEPORT_PROJECTILE_GRENADE",
		name 		= "$TELEPORT_PROJECTILE_GRENADE",
		description = "$dTELEPORT_PROJECTILE_GRENADE",
		sprite 		= "data/ui_gfx/gun_actions/grenade_teleport.png",
		related_projectiles	= {"data/entities/projectiles/deck/grenade_teleport.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "0,1,2,3,4,5,6,7", -- TELEPORT_PROJECTILE
		spawn_probability                 = "0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5", -- TELEPORT_PROJECTILE
		price = 130,
		mana = 40,
		max_uses = 9999,
		custom_xml_file = "data/entities/misc/custom_cards/grenade_teleport.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/grenade_teleport.xml")
			c.fire_rate_wait = c.fire_rate_wait + 3
			c.spread_degrees = math.min( 12.0, c.spread_degrees + 4.0 )
		end,
	},
	{
		id          = "DE_TELEPORT_PROJECTILE_LIGHTNING",
		name 		= "$TELEPORT_PROJECTILE_LIGHTNING",
		description = "$dTELEPORT_PROJECTILE_LIGHTNING",
		sprite 		= "data/ui_gfx/gun_actions/lightning_teleport.png",
		related_projectiles	= {"data/entities/projectiles/deck/lightning_teleport.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "6,7,10", -- TELEPORT_PROJECTILE
		spawn_probability                 = "1,1,1", -- TELEPORT_PROJECTILE
		price = 170,
		mana = 50,
		max_uses = 40,
		custom_xml_file = "data/entities/misc/custom_cards/lightning_teleport.xml",
		action 		= function()
			add_projectile("data/entities/projectiles/deck/lightning_teleport.xml")
			c.fire_rate_wait = math.min( c.fire_rate_wait - 18, 0 )
			c.spread_degrees = math.min( c.spread_degrees - 30, 0 )
		end,
	},
	{
		id          = "DE_HOOK_V2",
		name 		= "$HOOK_V2",
		description = "$dHOOK_V2",
		sprite 		= "data/ui_gfx/gun_actions/hook_v2.png",
		related_projectiles	= {"data/entities/projectiles/deck/hook_v2.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "2,3,4,5,6", -- BULLET
		spawn_probability                 = "1,1,1,1,1", -- BULLET
		price = 130,
		mana = 12,
		max_uses = 9999,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/hook_v2.xml")
			c.fire_rate_wait = c.fire_rate_wait + 36
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 16.0
		end,
	},
	{
		id          = "DE_TELEPORT_PROJECTILE_V2",
		name 		= "$TELEPORT_PROJECTILE_V2",
		description = "$dTELEPORT_PROJECTILE_V2",
		sprite 		= "data/ui_gfx/gun_actions/teleport_projectile_v2.png",
		related_projectiles	= {"data/entities/projectiles/deck/teleport_projectile_v2_no_hole.xml"},
		type 		= ACTION_TYPE_STATIC_PROJECTILE,
		spawn_level                       = "3,4,5,6,7,10", -- TELEPORT_PROJECTILE
		spawn_probability                 = "0.5,0.5,0.5,0.5,0.5,0.5", -- TELEPORT_PROJECTILE
		price = 130,
		mana = 75,
		max_uses = 10,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/teleport_projectile_v2.xml")
			c.fire_rate_wait = c.fire_rate_wait + 42
		end,
	},
	{
		id          = "DE_SHOCKWAVE",
		name 		= "$SHOCKWAVE",
		description = "$dSHOCKWAVE",
		sprite 		= "data/ui_gfx/gun_actions/shockwave.png",
		related_projectiles	= {"data/entities/projectiles/deck/shockwave.xml"},
		type 		= ACTION_TYPE_PROJECTILE,
		spawn_level                       = "1,2,3,4", -- RUBBER_BALL
		spawn_probability                 = "1,1,1,1", -- RUBBER_BALL
		price = 60,
		mana = 0,
		max_uses = 45,
		action 		= function()
			add_projectile("data/entities/projectiles/deck/shockwave.xml")
			shot_effects.recoil_knockback = shot_effects.recoil_knockback + 90.0
		end,
	},
	{
		id          = "DE_LINE_BREAKER",
		name 		= "$LINE_BREAKER",
		description = "$dLINE_BREAKER",
		sprite 		= "data/ui_gfx/gun_actions/line_breaker.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		-- spawn_requires_flag = "card_unlocked_maths",
		type 		= ACTION_TYPE_OTHER,
		recursive	= true,
		spawn_level                       = "6,7,10", -- BOMB
		spawn_probability                 = "1,1,1", -- BOMB
		price = 10,
		mana = -10,  
		action 		= function()
			current_reload_time = current_reload_time + 7

			for i,v in ipairs( deck ) do
				-- print( "removed " .. v.id .. " from deck" )
				table.insert( discarded, v )
			end
			
			deck = {}
			force_stop_draws = true
		end,
	},
	{
		id          = "DE_TR_PRISMA",
		name 		= "$TR_PRISMA",
		description = "$dTR_PRISMA",
		sprite 		= "data/ui_gfx/gun_actions/de_terraprisma.png",
		type 		= ACTION_TYPE_UTILITY,
		spawn_level                       = "1,2,3,4,5,6", -- MANA_REDUCE
		spawn_probability                 = "0.005,0.005,0.005,0.005,0.005,0.005", -- MANA_REDUCE
		price = 7,
		max_uses = 7,
		mana = 0,
		never_unlimited = true,
		ai_never_uses = true,
		custom_xml_file = "data/entities/misc/custom_cards/de_terraprisma.xml",
		action 		= function()
			local entity_id = GetUpdatedEntityID()
			local dcomp = EntityGetFirstComponent( entity_id, "DamageModelComponent" )
			local swords = EntityGetWithTag( "de_terraprisma" )
			
			-- GamePrint( tostring(#swords) .. " + 1" )
			if EntityHasTag( entity_id, "player_unit" ) and dcomp ~= nil and #swords < 7 then
				local maxhp = ComponentGetValue2( dcomp, "max_hp" )

				if maxhp < 2 then
					GamePrint( "You don't have enough MaxHp!" )
				else
					local px, py = EntityGetTransform( entity_id )
					local vcomps = EntityGetComponent( EntityLoad( "data/entities/projectiles/deck/de_terraprisma.xml", px, py ), "VariableStorageComponent" )

					for i,v in ipairs( vcomps ) do if ComponentGetValue2( v, "name" ) == "prey_info" then
						ComponentSetValue2( v, "value_string", #swords + 1 )
						break
					end end

					ComponentSetValue2( dcomp, "max_hp", maxhp - 1 )

					-- GamePlaySound( "data/audio/Desktop/event_cues.bank", "event_cues/orb/create", px, py )
					GamePlaySound( "data/audio/Desktop/event_cues.bank", "event_cues/perk/create", px, py )
				end
			end
		end,
	},
	{
		id          = "DE_SUICIDE_KING",
		name 		= "$SUICIDE_KING",
		description = "$dSUICIDE_KING",
		sprite 		= "data/ui_gfx/gun_actions/suicide_king.png",
		sprite_unidentified = "data/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		never_unlimited	= true,
		type 		= ACTION_TYPE_UTILITY,
		spawn_level                       = "6,7,10", -- MANA_REDUCE
		spawn_probability                 = "1,1,1", -- MANA_REDUCE
		price = 999,
		mana = 0,
		max_uses    = 13, 
		action 		= function()
			local entity_id = GetUpdatedEntityID()

			if ( entity_id ~= nil ) and ( entity_id ~= NULL_ENTITY ) then
				local x,y = EntityGetTransform( entity_id )
				local childs = EntityGetAllChildren( entity_id )

				if ( childs ~= nil ) then
					for i=1,#childs do
						local childcomps = EntityGetComponent( childs[i], "GameEffectComponent" )
						local effect_str = "NONE,"

						if ( childcomps ~= nil ) then
							for j=1,#childcomps do
								effect_str = effect_str .. ComponentGetValue2( childcomps[j], "effect" ) .. ","
							end
						end
						
						if ( string.find( effect_str, ",PROTECTION_ALL," ) ~= nil ) then
							EntityKill( childs[i] )
						end
					end
				end

				if EntityHasTag( entity_id, "player_unit" ) then
					EntityRemoveIngestionStatusEffect( entity_id, "PROTECTION_ALL" )
					-- EntityRemoveIngestionStatusEffect( entity_id, "DEEP_END_HARDEN_EFFECT" )

					EntityRemoveStainStatusEffect( entity_id, "PROTECTION_ALL", 15 )
					-- EntityRemoveStainStatusEffect( entity_id, "DEEP_END_HARDEN_EFFECT", 15 )
				end

				if ( x ~= nil ) and ( y ~= nil )then
					GamePlaySound( "data/audio/Desktop/event_cues.bank", "event_cues/heartbeat/create", x, y-4 )

					local killer = EntityLoad( "data/entities/misc/what_is_this/galactic_phantom.xml", x, y )
					local comp = EntityGetFirstComponent( killer, "VariableStorageComponent" )
					
					if ( comp ~= nil ) then
						ComponentSetValue2( comp, "value_int", entity_id )
					end

					local chest_rain = EntityLoad("data/entities/misc/chest_rain_rainbow.xml", x, y)
					EntityAddChild( entity_id, chest_rain )
				end

				local dcomp = EntityGetFirstComponent( entity_id, "DamageModelComponent" )
				
				if ( dcomp ~= nil ) then
					ComponentSetValue2( dcomp, "hp", 0.02 )
					EntityInflictDamage( entity_id, ComponentGetValue2( dcomp, "max_hp" ) * 100, "DAMAGE_HEALING", "Suside King", "NONE", 0, 0, entity_id )
				else
					EntityKill( entity_id )
				end
			end

			for i,v in ipairs( deck ) do
				-- print( "removed " .. v.id .. " from deck" )
				table.insert( discarded, v )
			end
			
			deck = {}
			force_stop_draws = true
		end,
	},
	{
		id          = "DE_RESET_ALL",
		name 		= "$DE_RESET_ALL",
		description = "$dDE_RESET_ALL",
		sprite 		= "data/ui_gfx/gun_actions/just_reset_all.png",
		type 		= ACTION_TYPE_OTHER,
		-- spawn_requires_flag = "card_unlocked_everything",
		spawn_level                       = "10", 
		spawn_probability                 = "0.01", 
		price = 0,
		mana = 0,
		action 		= function()
			local newgame_n = tonumber( SessionNumbersGetValue("NEW_GAME_PLUS_COUNT") )
			local entity_id = GetUpdatedEntityID()

			if EntityHasTag( entity_id, "player_unit" ) then
				local x,y = EntityGetTransform( entity_id )

				if newgame_n >= 32 then
					EntityLoad( "data/entities/misc/what_is_this/forget_everything.xml", x, y )
				else
					local res = EntityLoad( "data/entities/misc/what_is_this/just_reset_all.xml", x, y ) -- this is crazy!
					local comp = EntityGetFirstComponent( res, "VariableStorageComponent", "de_ng_pre" )
					
					if ( comp ~= nil ) then
						ComponentSetValue2( comp, "value_int", newgame_n )
					end
				end
			end

			for i,v in ipairs( deck ) do
				-- print( "removed " .. v.id .. " from deck" )
				table.insert( discarded, v )
			end
			
			deck = {}
			force_stop_draws = true

			c.friendly_fire	= false
		end,
	},
}

if not ModIsEnabled("spells_evolutions") then for i=1,#de_actions_append do
	if de_actions_append[i].max_uses == 9999 then de_actions_append[i].max_uses = nil end
end end

if not ModIsEnabled("deep_end") then for i=1,#de_actions_append do
	table.insert( actions, de_actions_append[i] )
end end



