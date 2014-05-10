--Adds Brazier node
minetest.register_node("braziers:brazier", {
	description = "Brazier",
	drawtype = "normal",
	paramtype = light,
	tiles = {"braziers_brazier.png"},
	groups = {cracky = 3, stone = 1},
	--When punched set fire above
	on_punch = function(pos, node, puncher, pointed_thing)
		local ab_pos = { x = pos.x, y = pos.y + 1, z = pos.z}
		local n = minetest.env:get_node(ab_pos).name
		if (n == "air") then
			--Then set brazier flame
			minetest.set_node(ab_pos, {name = "braziers:brazier_flame"})
			end
	end,
})

--Adds fake fire node
--It's a copy of the basic fire node, but it doesn't disappear
minetest.register_node("braziers:brazier_flame", {
	description = "Brazier Fire",
	drawtype = "plantlike",
	tiles = {{
		name="fire_basic_flame_animated.png",
		animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=1},
	}},
	inventory_image = "fire_basic_flame.png",
	light_source = 14,
	groups = {igniter=2,dig_immediate=3,hot=3,not_in_creative_inventory=1},
	drop = '',
	walkable = false,
	buildable_to = true,
	damage_per_second = 4,
})

--Adds ABM to make brazier fire above brazier when there is basic fire nearby
minetest.register_abm({
	nodenames = {"braziers:brazier"},
	neighbors = {"fire:basic_flame"},
	interval = 1.0,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		--Check if above node is air or fire
		local ab_pos = { x = pos.x, y = pos.y + 1, z = pos.z}
		local n = minetest.env:get_node(ab_pos).name
		if (n == "air" or n == "fire:basic_flame") then
			--Then set brazier flame
			minetest.set_node(ab_pos, {name = "braziers:brazier_flame"})
			end
	end,
})
