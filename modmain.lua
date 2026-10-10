local _G      = GLOBAL
local require = _G.require

require("apo_util")

local INIT_STRINGS =
{
    "strings",
    "strings_scrapbook",
    "strings_skins",
}

for _, v in pairs(INIT_STRINGS) do
    require("strings/apo_"..v)
end

local INIT_STRINGS_CHARACTERS =
{
    "wilson",
    "willow",
    "wolfgang",
    "wendy",
    "wx78",
    "wickerbottom",
    "woodie",
    "waxwell",
    "wathgrithr",
    "webber",
    "winona",
    "wortox",
    "wormwood",
    "warly",
    "wurt",
    "walter",
    "wanda",
}

for _, v in pairs(INIT_STRINGS_CHARACTERS) do
    require("strings/characters/apo_speech_"..v)
end

local APO_LANGUAGE = GetModConfigData("LANGUAGE")

if APO_LANGUAGE then
    -- modimport("scripts/strings/localization_"..APO_LANGUAGE.."/apo_strings_loadingtips")

    for _, v in pairs(INIT_STRINGS) do
        require("strings/localization_"..APO_LANGUAGE.."/apo_"..v)
    end

    for _, v in pairs(INIT_STRINGS_CHARACTERS) do
        require("strings/localization_"..APO_LANGUAGE.."/characters/apo_speech_"..v)
    end
end

modimport("main/init_main")
modimport("postinit/init_postinit")

-- require("apo_debugcommands")