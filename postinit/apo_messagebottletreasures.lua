local _G                         = GLOBAL
local require                    = _G.require
local UpvalueHacker              = require("tools/apo_upvaluehacker")
local messagebottletreasures     = require("messagebottletreasures")
local weighted_treasure_contents = UpvalueHacker.GetUpvalue(messagebottletreasures.GetPrefabs, "weighted_treasure_contents")

local APO_PRESETS =
{
    APO_PRESETS_PIRATE =
    {
        guaranteed_loot =
        {
            boatpatch           = { 3, 6 },
            messagebottle       = { 1, 3 },
            oar_monkey          = 1,
            -- piratehat        = 1,
            slurtle_shellpieces = { 2, 4 },
            stash_map           = 1,
        },

        randomly_selected_loot =
        {
            { cutless    = 0.50 },
            { piratepack = 0.20 },
        },

        preset_weight = 1,
    },
}

for k, preset in pairs(APO_PRESETS) do
    weighted_treasure_contents.sunkenchest[preset] = preset.preset_weight
end