local assets =
{
	Asset( "ANIM", "anim/ling.zip" ),
	Asset( "ANIM", "anim/ghost_ling_build.zip" ),
}

local skins =
{
	normal_skin = "ling",
	ghost_skin = "ghost_ling_build",
}

return CreatePrefabSkin("ling_none",
{
	base_prefab = "ling",
	type = "base",
	assets = assets,
	skins = skins, 
	skin_tags = {"LING", "CHARACTER", "BASE"},
	build_name_override = "ling",
	rarity = "Character",
}) 