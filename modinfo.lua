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

        BEEHATS_CHANGES =
        {
            NAME =
            {
                "Bee-like Hats Tweaks",
                pt  = "Mudanças para os Chapéus de Abelha",
            },

            HOVER =
            {
                "Should bee hats such as the Beekeeper Hat and Bee Queen Crown have new features? Visit the Mod's Wiki for more information.",
                pt  = "Permitir que chapéus de abelhas como o Chapéu de Apicultour e Cora da Abelha Rainha ganhe novos recursos? Visite a Wiki do Mod para mais informações.",
            },

            HOVER_OPTIONS =
            {
                DISABLED =
                {
                    "Default behaviour for Bee-like Hats.",
                    pt  = "Comportamento padrão para os chapéus de abelhas.",
                },

                ENABLED =
                {
                    "Bee-like Hats will recieve new features.",
                    pt  = "Chapéus de abelhas receberão novos recursos.",
                },
            },
        },

        ARMOR_MARBLE_CHANGES =
        {
            NAME =
            {
                "Marble Suit Set Bonus",
                pt  = "Bonus da Armadura de Mármore",
            },

            HOVER =
            {
                "Should the Marble Suit have an unique Set Bonus when paired with the Marble Helmet? Visit the Mod's Wiki for more information.",
                pt  = "Permitir que a Armadura de Mármore tenha um bônus quando usada em conjuto com o Capacete de Mármore? Visite a Wiki do Mod para mais informações.",
            },

            HOVER_OPTIONS =
            {
                DISABLED =
                {
                    "Default behaviour for the Marble Suit",
                    pt  = "Comportamento padrão para a Armadura de Mármore",
                },

                ENABLED =
                {
                    "Marble Suit will recieve a Set Bonus when paired with the Marble Helmet.",
                    pt  = "A Armadura de Mármore receberá um bônus quando usada em conjunto com o Capacete de Mármore.",
                },
            },
        },
    },
}

name                    = ChooseTranslationTable(STRINGS.NAME)
version                 = "2.9-B"

description             = ChooseTranslationTable(STRINGS.DESCRIPTION)

author                  = "Kyno 󰀃"
api_version             = 10
priority                = -50 -- Above 0 = Override other mods. | Below 0 = Overriden by other mods.

dst_compatible          = true
all_clients_require_mod = true
client_only_mod         = false

server_filter_tags      = { "Apparels Overload", "APO", "Clothing", "Hats", "Entertainment", "Kyno" }

icon                    = "ModiconAPO.tex"
icon_atlas              = "ModiconAPO.xml"

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
    local NONE_OPTIONS                 = GetNoneOptions()

    local GENERAL_LABEL                = ChooseTranslationTable(STRINGS.SETTINGS.GENERAL.NAME)
    local GENERAL_HOVER                = ChooseTranslationTable(STRINGS.SETTINGS.GENERAL.HOVER)

    local MOD_SCRAPBOOK_LABEL          = ChooseTranslationTable(STRINGS.SETTINGS.SCRAPBOOK.NAME)
    local MOD_SCRAPBOOK_HOVER          = ChooseTranslationTable(STRINGS.SETTINGS.SCRAPBOOK.HOVER)

    local MOD_SCRAPBOOK_OPTIONS        =
    {
        {
            description                = ChooseTranslationTable(STRINGS.SETTINGS.DISABLED),
            hover                      = ChooseTranslationTable(STRINGS.SETTINGS.SCRAPBOOK.HOVER_OPTIONS.DISABLED),
            data                       = false
        },
        {
            description                = ChooseTranslationTable(STRINGS.SETTINGS.ENABLED),
            hover                      = ChooseTranslationTable(STRINGS.SETTINGS.SCRAPBOOK.HOVER_OPTIONS.ENABLED),
            data                       = true
        }
    }

    return
    {
        {
            name                       = "GENERAL",
            label                      = GENERAL_LABEL,
            hover                      = GENERAL_HOVER,
            options                    = NONE_OPTIONS,
            default                    = false
        },
        {
            name                       = "MOD_SCRAPBOOK",
            label                      = MOD_SCRAPBOOK_LABEL,
            hover                      = MOD_SCRAPBOOK_HOVER,
            options                    = MOD_SCRAPBOOK_OPTIONS,
            default                    = true
        },
    }
end

local function GetVanillaOptions()
    local NONE_OPTIONS                 = GetNoneOptions()

    local VANILLA_LABEL                = ChooseTranslationTable(STRINGS.SETTINGS.VANILLA.NAME)
    local VANILLA_HOVER                = ChooseTranslationTable(STRINGS.SETTINGS.VANILLA.HOVER)

    local BEEHATS_CHANGES_LABEL        = ChooseTranslationTable(STRINGS.SETTINGS.BEEHATS_CHANGES.NAME)
    local BEEHATS_CHANGES_HOVER        = ChooseTranslationTable(STRINGS.SETTINGS.BEEHATS_CHANGES.HOVER)
    local BEEHATS_CHANGES_OPTIONS      =
    {
        {
            description                = ChooseTranslationTable(STRINGS.SETTINGS.DISABLED),
            hover                      = ChooseTranslationTable(STRINGS.SETTINGS.BEEHATS_CHANGES.HOVER_OPTIONS.DISABLED),
            data                       = false
        },
        {
            description                = ChooseTranslationTable(STRINGS.SETTINGS.ENABLED),
            hover                      = ChooseTranslationTable(STRINGS.SETTINGS.BEEHATS_CHANGES.HOVER_OPTIONS.ENABLED),
            data                       = true
        }
    }

    local ARMOR_MARBLE_CHANGES_LABEL   = ChooseTranslationTable(STRINGS.SETTINGS.ARMOR_MARBLE_CHANGES.NAME)
    local ARMOR_MARBLE_CHANGES_HOVER   = ChooseTranslationTable(STRINGS.SETTINGS.ARMOR_MARBLE_CHANGES.HOVER)
    local ARMOR_MARBLE_CHANGES_OPTIONS =
    {
        {
            description                = ChooseTranslationTable(STRINGS.SETTINGS.DISABLED),
            hover                      = ChooseTranslationTable(STRINGS.SETTINGS.ARMOR_MARBLE_CHANGES.HOVER_OPTIONS.DISABLED),
            data                       = false
        },
        {
            description                = ChooseTranslationTable(STRINGS.SETTINGS.ENABLED),
            hover                      = ChooseTranslationTable(STRINGS.SETTINGS.ARMOR_MARBLE_CHANGES.HOVER_OPTIONS.ENABLED),
            data                       = true
        }
    }

    return
    {
        {
            name                = "VANILLA",
            label               = VANILLA_LABEL,
            hover               = VANILLA_HOVER,
            options             = NONE_OPTIONS,
            default             = false
        },
        {
            name                = "BEEHATS_CHANGES",
            label               = BEEHATS_CHANGES_LABEL,
            hover               = BEEHATS_CHANGES_HOVER,
            options             = BEEHATS_CHANGES_OPTIONS,
            default             = true
        },
        {
            name                = "ARMOR_MARBLE_CHANGES",
            label               = ARMOR_MARBLE_CHANGES_LABEL,
            hover               = ARMOR_MARBLE_CHANGES_HOVER,
            options             = ARMOR_MARBLE_CHANGES_OPTIONS,
            default             = true
        },
    }
end

configuration_options = {}

AddConfigurationOptions(configuration_options, GetGeneralOptions())
AddConfigurationOptions(configuration_options, GetVanillaOptions())