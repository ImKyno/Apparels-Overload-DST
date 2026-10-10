local function ChooseTranslationTable(tbl)
    return tbl[locale] or tbl[1]
end

local STRINGS =
{
    NAME =
    {
        "Apparels Overload",
        pt  = "Amontoado de Roupas",
    },

    DESCRIPTION =
    {
[[
󰀖 Travel The Constant with style using brand new clothing and headwear accessories. Unleash your inner stylish skills!

󰀌 Mod Version: 2.9-B
󰀧 Update: Rebranded!
]],
        pt  =
[[
󰀖 Atravesse o Constante com estilo usando novas roupas, chapéus e acessórios. Desperte suas habilidades de moda!

󰀌 Mod Version: 2.9-B
󰀧 Update: Repaginado!
]],
    },

    SETTINGS =
    {
        DISABLED =
        {
            "Disabled",
            pt  = "Desativado",
        },

        ENABLED =
        {
            "Enabled",
            pt  = "Ativado",
        },

        GENERAL =
        {
            NAME =
            {
                "General Options",
                pt  = "Opções Gerais",
            },

            HOVER =
            {
                "General Options for the entire Mod.",
                pt  = "Opções Gerais para o Mod inteiro.",
            },
        },

        LANGUAGE =
        {
            NAME =
            {
                "Language",
                pt  = "Idioma",
            },

            HOVER =
            {
                "Choose the language for the mod.\nYou can submit your translation in our Discord.",
                pt  = "Escolha o idioma do Mod.\nVocê pode enviar sua tradução em nosso Discord.",
            },

            HOVER_OPTIONS =
            {
                en  = "English",
                pt  = "Português",

                DESCRIPTION =
                {
                    en  = "Default Localization",
                    pt  = "Autor: Eventide",
                },
            },
        },

        SCRAPBOOK =
        {
            NAME =
            {
                "Mod Scrapbook",
                pt  = "Scrapbook do Mod",
            },

            HOVER =
            {
                "Should the Mod's contents be added to the Scrapbook?",
                pt  = "Permitir que os conteúdos do Mod sejam adicionados ao Scrapbook?",
            },

            HOVER_OPTIONS =
            {
                DISABLED =
                {
                    "Default Scrapbook.",
                    pt  = "Scrapbook Padrão.",
                },

                ENABLED =
                {
                    "Mod's contents will be added to the Scrapbook.",
                    pt  = "Os conteúdos do Mod serão adicionados ao Scrapbook.",
                },
            },
        },

        VANILLA =
        {
            NAME =
            {
                "Vanilla Options",
                pt  = "Opções do Vanilla",
            },

            HOVER =
            {
                "Options for the Vanilla Content.",
                pt  = "Opções para o Conteúdo do Vanilla.",
            },
        },
    },
}

name                         = ChooseTranslationTable(STRINGS.NAME)
version                      = "2.9-B"

description                  = ChooseTranslationTable(STRINGS.DESCRIPTION)

author                       = "Kyno 󰀃"
api_version                  = 10
priority                     = -50 -- Above 0 = Override other mods. | Below 0 = Overriden by other mods.

dst_compatible               = true
all_clients_require_mod      = true
client_only_mod              = false

server_filter_tags           = { "Apparels Overload", "APO", "Clothing", "Hats", "Entertainment", "Kyno" }

icon                         = "ModiconAPO.tex"
icon_atlas                   = "ModiconAPO.xml"

-- What the fuck ipairs is not available in here (?)
local function AddConfigurationOptions(target, options)
    local i = 1
    local count = #target

    while options[i] ~= nil do
        count = count + 1
        target[count] = options[i]
        i = i + 1
    end
end

local function GetNoneOptions()
    return
    {
        {
            description = "",
            data        = false,
        }
    }
end

local function GetYesNoOptions()
    return
    {
        {
            description = ChooseTranslationTable(STRINGS.SETTINGS.DISABLED),
            data        = false,
        },
        {
            description = ChooseTranslationTable(STRINGS.SETTINGS.ENABLED),
            data        = true,
        },
    }
end

local function GetGeneralOptions()
    local NONE_OPTIONS          = GetNoneOptions()

    local GENERAL_LABEL         = ChooseTranslationTable(STRINGS.SETTINGS.GENERAL.NAME)
    local GENERAL_HOVER         = ChooseTranslationTable(STRINGS.SETTINGS.GENERAL.HOVER)

    local MOD_SCRAPBOOK_LABEL   = ChooseTranslationTable(STRINGS.SETTINGS.SCRAPBOOK.NAME)
    local MOD_SCRAPBOOK_HOVER   = ChooseTranslationTable(STRINGS.SETTINGS.SCRAPBOOK.HOVER)

    local MOD_SCRAPBOOK_OPTIONS =
    {
        {
            description         = ChooseTranslationTable(STRINGS.SETTINGS.DISABLED),
            hover               = ChooseTranslationTable(STRINGS.SETTINGS.SCRAPBOOK.HOVER_OPTIONS.DISABLED),
            data                = false
        },
        {
            description         = ChooseTranslationTable(STRINGS.SETTINGS.ENABLED),
            hover               = ChooseTranslationTable(STRINGS.SETTINGS.SCRAPBOOK.HOVER_OPTIONS.ENABLED),
            data                = true
        }
    }

    return
    {
        {
            name                = "GENERAL",
            label               = GENERAL_LABEL,
            hover               = GENERAL_HOVER,
            options             = NONE_OPTIONS,
            default             = false
        },
        {
            name                = "MOD_SCRAPBOOK",
            label               = MOD_SCRAPBOOK_LABEL,
            hover               = MOD_SCRAPBOOK_HOVER,
            options             = MOD_SCRAPBOOK_OPTIONS,
            default             = true
        },
    }
end

local function GetVanillaOptions()
    local NONE_OPTIONS          = GetNoneOptions()

    local VANILLA_LABEL         = ChooseTranslationTable(STRINGS.SETTINGS.VANILLA.NAME)
    local VANILLA_HOVER         = ChooseTranslationTable(STRINGS.SETTINGS.VANILLA.HOVER)

    return
    {
        {
            name                = "VANILLA",
            label               = VANILLA_LABEL,
            hover               = VANILLA_HOVER,
            options             = NONE_OPTIONS,
            default             = false
        },
    }
end

configuration_options = {}

AddConfigurationOptions(configuration_options, GetGeneralOptions())
AddConfigurationOptions(configuration_options, GetVanillaOptions())