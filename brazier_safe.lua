-- check for MineClone2
local mcl = minetest.get_modpath("mcl_core")

if mcl then
    item1='mcl_core:torch'
    item2='mcl_core:cobble'
    item3="mcl_fire:basic_flame"
else
    item1='default:torch'
    item2='default:cobble'
    item3="fire:basic_flame"
end

--Adds Brazier node
minetest.register_node("brazier:brazier_safe", {
	description = "Safe Brazier",
	drawtype = "nodebox",
	paramtype = "light",
	tiles = {"brazier_brazier_top.png", "brazier_brazier_side.png", "brazier_brazier_side.png",  "brazier_brazier_side.png", "brazier_brazier_side.png", "brazier_brazier_side.png"},
	node_box = {
		type = "fixed",
		fixed = {
			{0.2,-0.2,0.2,-0.2,0.2,-0.2}, --nodebox1
			{-0.3,0.2,-0.3,0.3,0.3,0.3}, --nodebox2
			{-0.4,0.3,-0.4,0.4,0.4,0.4}, --nodebox3
			{-0.5,0.4,-0.5,0.5,0.5,0.5}, --nodebox4
			{-0.5,-0.5,-0.5,0.5,-0.4,0.5}, --nodebox5
			{-0.4,-0.4,-0.4,0.4,-0.3,0.4}, --nodebox6
			{-0.3,-0.3,-0.3,0.3,-0.2,0.3}, --nodebox7
		},
	},
	groups = {cracky = 3, stone = 1},
	--When punched set fire above
	on_punch = function(pos, node, puncher, pointed_thing)
		local ab_pos = { x = pos.x, y = pos.y + 1, z = pos.z}
		local n = minetest.env:get_node(ab_pos).name
		if (n == "air") then
			--Then set brazier flame
			minetest.set_node(ab_pos, {name = "brazier:brazier_safe_flame"})
			end
	end,
	--When destroyed remove brazier fire
	after_destruct = function(pos, oldnode)
		--If above node is brazier fire
		local ab_pos = { x = pos.x, y = pos.y + 1, z = pos.z}
		local n = minetest.env:get_node(ab_pos).name
		if (n == "brazier:brazier_safe_flame") then
			--Then remove brazier flame
			minetest.set_node(ab_pos, {name = "air"})
			end
	end,
})

--Register crafting recipie for brazier node
minetest.register_craft({
output = "brazier:brazier_safe",
recipe = {
{'', item1, item2},
{item2, item2, item2},
{item2, item2, item2},
}
})

--Adds fake fire node
--It's a copy of the basic fire node, but it doesn't disappear
minetest.register_node("brazier:brazier_safe_flame", {
	description = "Brazier Safe Fire",
	drawtype = "plantlike",
	tiles = {{
		name="fire_basic_flame_animated.png",
		animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=1},
	}},
	inventory_image = "fire_basic_flame.png",
	light_source = 14,
	groups = {dig_immediate=3, not_in_creative_inventory=1},
	drop = '',
	walkable = false,
	buildable_to = true,
})

--Adds ABM to make brazier fire above brazier when there is basic fire nearby
minetest.register_abm({
	nodenames = {"brazier:brazier_safe"},
	neighbors = {item3},
	interval = 1.0,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		--Check if above node is air or fire
		local ab_pos = { x = pos.x, y = pos.y + 1, z = pos.z}
		local n = minetest.env:get_node(ab_pos).name
		if (n == "air" or n == item3) then
			--Then set brazier flame
			minetest.set_node(ab_pos, {name = "brazier:brazier_safe_flame"})
			end
	end,
})
