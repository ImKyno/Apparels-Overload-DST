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

        CLIENT =
        {
            NAME =
            {
                "Client-side Options",
                pt  = "Opções do Cliente",
            },

            HOVER =
            {
                "Options that only affects you in the server.",
                pt  = "Opções que afetam somente a você no servidor.",
            },
        },

        -- Server Options.
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

        TWEAK_ARMORMARBLE =
        {
            NAME =
            {
                "Marble Suit - Tweaks",
                pt  = "Armadura de Mármore - Mudanças",
            },

            HOVER =
            {
                "Should the Marble Suit have new features?\nVisit the Mod's Wiki for more information.",
                pt  = "Permitir que a Armadura de Mármore tenha novos recursos?\nVisite a Wiki do Mod para mais informações.",
            },

            HOVER_OPTIONS =
            {
                DISABLED =
                {
                    "Default Marble Suit.",
                    pt  = "Armadura de Mármore Padrão.",
                },

                ENABLED =
                {
                    "Marble Suit will have some new features.",
                    pt  = "A Armadura de Mármore terá recursos novos.",
                },
            },
        },

        TWEAK_BEEHAT =
        {
            NAME =
            {
                "Bee Hats - Tweaks",
                pt  = "Chapéus de Abelha - Mudanças",
            },

            HOVER =
            {
                "Should the Beekeeper Hat and Bee Queen Crown have new features?\nVisit the Mod's Wiki for more information.",
                pt  = "Permitir que o Chapéu de Apicultor e Coroa da Abelha Rainha tenham novos recursos?\nVisite a Wiki do Mod para mais informações.",
            },

            HOVER_OPTIONS =
            {
                DISABLED =
                {
                    "Default Beekeeper Hat and Bee Queen Crown.",
                    pt  = "Chapéu de Apicultor e Coroa da Abelha Rainha Padrões.",
                },

                ENABLED =
                {
                    "Beekeeper Hat and Bee Queen Crown will have some new features.",
                    pt  = "O Chapéu de Apicultor e a Cora da Abelha Rainha teram novos recursos.",
                },
            },
        },

        TWEAK_INSPECTACLESHAT =
        {
            NAME =
            {
                "Inspectacles - Tweaks",
                pt  = "Inspectares - Mudanças",
            },

            HOVER =
            {
                "Should the Inspectacles have new features?\nVisit the Mod's Wiki for more information.",
                pt  = "Permitir que o Inspectares tenha novos recursos?\nVisite a Wiki do Mod para mais informações.",
            },

            HOVER_OPTIONS =
            {
                DISABLED =
                {
                    "Default Inspectacles.",
                    pt  = "Inspectares Padrão.",
                },

                ENABLED =
                {
                    "Inspectacles will have some new features.",
                    pt  = "O Inspectares terá novos recursos.",
                },
            },
        },

        TWEAK_MANNEQUIN =
        {
            NAME =
            {
                "Mannequin - Wear Out",
                pt  = "Manequim - Desgaste",
            },

            HOVER =
            {
                "Should Clothing and Headwear wear out on the Sewing Mannequin?",
                pt  = "Permitir que Roupas e Chapéus desgastem se estiverem no Manequim?",
            },

            HOVER_OPTIONS = -- THIS OPTION IS BACKWARDS !!!
            {
                DISABLED =
                {
                    "Clothing and Headwear will not wear out on the Sewing Mannequin.",
                    pt  = "Roupas e Chapéus não irão desgastar se estiverem no Manequim.",
                },

                ENABLED =
                {
                    "Default Sewing Mannequin behaviour.",
                    pt  = "Comportamento padrão do Manequim.",
                },
            },
        },

        -- Client Options.
        BATVISION_CC =
        {
            NAME =
            {
                "Cowl - Nightvision Filter",
                pt  = "Capuz de Morcego - Filtro de Visão Noturna",
            },

            HOVER =
            {
                "Should the Cowl have an unique Nightvision Filter when worn?",
                pt  = "Permitir que o Capuz de Morcego tenha um filtro único de Visão Noturna quando equipado?",
            },

            HOVER_OPTIONS =
            {
                DISABLED =
                {
                    "Cowl will not have any Nightvision Filter.",
                    pt  = "O Capuz de Morcego não terá nenhum filtro de Visão Noturna.",
                },

                ENABLED =
                {
                    "Cowl will have an unique Nightvision Filter.",
                    pt  = "O Capuz de Morcego terá um filtro único de Visão Noturna.",
                },
            },
        },

        HEATVISION_CC =
        {
            NAME =
            {
                "Infroggles - Nightvision Filter",
                pt  = "Infróculos - Filtro de Visão Noturna",
            },

            HOVER =
            {
                "Should the Infroggles have an unique Nightvision Filter when worn?",
                pt  = "Permitir que o Infróculos tenha um filtro único de Visão Noturna quando equipado?",
            },

            HOVER_OPTIONS =
            {
                DISABLED =
                {
                    "Infroggles will not have any Nightvision Filter.",
                    pt  = "O Infróculos não terá nenhum filtro de Visão Noturna.",
                },

                ENABLED =
                {
                    "Infroggles will have an unique Nightvision Filter.",
                    pt  = "O Infróculos terá um filtro único de Visão Noturna.",
                },
            },
        },

        SHOOTVISION_CC =
        {
            NAME =
            {
                "Fryfocals - Nightvision Filter",
                pt  = "Fritóculos - Filtro de Visão Noturna",
            },

            HOVER =
            {
                "Should the Fryfocals have an unique Nightvision Filter when worn?",
                pt  = "Permitir que o Fritóculos tenha um filtro único de Visão Noturna quando equipado?",
            },

            HOVER_OPTIONS =
            {
                DISABLED =
                {
                    "Fryfocals will not have any Nightvision Filter.",
                    pt  = "O Fritóculos não terá nenhum filtro de Visão Noturna.",
                },

                ENABLED =
                {
                    "Fryfocals will have an unique Nightvision Filter.",
                    pt  = "O Fritóculos terá um filtro único de Visão Noturna.",
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

local SEPARATOR_LABEL   = "- - - - - - - - - - - - - -"
local SEPARATOR_HOVER   = "- - - - - - - - - - - - - -"

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
    local NONE_OPTIONS                  = GetNoneOptions()

    local GENERAL_LABEL                 = ChooseTranslationTable(STRINGS.SETTINGS.GENERAL.NAME)
    local GENERAL_HOVER                 = ChooseTranslationTable(STRINGS.SETTINGS.GENERAL.HOVER)

    local MOD_SCRAPBOOK_LABEL           = ChooseTranslationTable(STRINGS.SETTINGS.SCRAPBOOK.NAME)
    local MOD_SCRAPBOOK_HOVER           = ChooseTranslationTable(STRINGS.SETTINGS.SCRAPBOOK.HOVER)

    local MOD_SCRAPBOOK_OPTIONS         =
    {
        {
            description                 = ChooseTranslationTable(STRINGS.SETTINGS.DISABLED),
            hover                       = ChooseTranslationTable(STRINGS.SETTINGS.SCRAPBOOK.HOVER_OPTIONS.DISABLED),
            data                        = false
        },
        {
            description                 = ChooseTranslationTable(STRINGS.SETTINGS.ENABLED),
            hover                       = ChooseTranslationTable(STRINGS.SETTINGS.SCRAPBOOK.HOVER_OPTIONS.ENABLED),
            data                        = true
        }
    }

    return
    {
        {
            name                        = "GENERAL",
            label                       = GENERAL_LABEL,
            hover                       = GENERAL_HOVER,
            options                     = NONE_OPTIONS,
            default                     = false
        },
        {
            name                        = "MOD_SCRAPBOOK",
            label                       = MOD_SCRAPBOOK_LABEL,
            hover                       = MOD_SCRAPBOOK_HOVER,
            options                     = MOD_SCRAPBOOK_OPTIONS,
            default                     = true
        },
    }
end

local function GetVanillaOptions()
    local NONE_OPTIONS                  = GetNoneOptions()

    local VANILLA_LABEL                 = ChooseTranslationTable(STRINGS.SETTINGS.VANILLA.NAME)
    local VANILLA_HOVER                 = ChooseTranslationTable(STRINGS.SETTINGS.VANILLA.HOVER)

    local TWEAK_ARMORMARBLE_LABEL       = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_ARMORMARBLE.NAME)
    local TWEAK_ARMORMARBLE_HOVER       = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_ARMORMARBLE.HOVER)
    local TWEAK_ARMORMARBLE_OPTIONS     =
    {
        {
            description                 = ChooseTranslationTable(STRINGS.SETTINGS.DISABLED),
            hover                       = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_ARMORMARBLE.HOVER_OPTIONS.DISABLED),
            data                        = false
        },
        {
            description                 = ChooseTranslationTable(STRINGS.SETTINGS.ENABLED),
            hover                       = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_ARMORMARBLE.HOVER_OPTIONS.ENABLED),
            data                        = true
        }
    }

    local TWEAK_BEEHAT_LABEL            = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_BEEHAT.NAME)
    local TWEAK_BEEHAT_HOVER            = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_BEEHAT.HOVER)
    local TWEAK_BEEHAT_OPTIONS          =
    {
        {
            description                 = ChooseTranslationTable(STRINGS.SETTINGS.DISABLED),
            hover                       = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_BEEHAT.HOVER_OPTIONS.DISABLED),
            data                        = false
        },
        {
            description                 = ChooseTranslationTable(STRINGS.SETTINGS.ENABLED),
            hover                       = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_BEEHAT.HOVER_OPTIONS.ENABLED),
            data                        = true
        }
    }

    local TWEAK_INSPECTACLESHAT_LABEL   = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_INSPECTACLESHAT.NAME)
    local TWEAK_INSPECTACLESHAT_HOVER   = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_INSPECTACLESHAT.HOVER)
    local TWEAK_INSPECTACLESHAT_OPTIONS =
    {
        {
            description                 = ChooseTranslationTable(STRINGS.SETTINGS.DISABLED),
            hover                       = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_INSPECTACLESHAT.HOVER_OPTIONS.DISABLED),
            data                        = false
        },
        {
            description                 = ChooseTranslationTable(STRINGS.SETTINGS.ENABLED),
            hover                       = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_INSPECTACLESHAT.HOVER_OPTIONS.ENABLED),
            data                        = true
        }
    }

    -- THIS OPTION IS BACKWARDS !!!
    local TWEAK_MANNEQUIN_LABEL         = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_MANNEQUIN.NAME)
    local TWEAK_MANNEQUIN_HOVER         = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_MANNEQUIN.HOVER)
    local TWEAK_MANNEQUIN_OPTIONS       =
    {
        {
            description                 = ChooseTranslationTable(STRINGS.SETTINGS.DISABLED),
            hover                       = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_MANNEQUIN.HOVER_OPTIONS.DISABLED),
            data                        = false
        },
        {
            description                 = ChooseTranslationTable(STRINGS.SETTINGS.ENABLED),
            hover                       = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_MANNEQUIN.HOVER_OPTIONS.ENABLED),
            data                        = true
        }
    }

    return
    {
        {
            name                        = "VANILLA",
            label                       = VANILLA_LABEL,
            hover                       = VANILLA_HOVER,
            options                     = NONE_OPTIONS,
            default                     = false
        },
        {
            name                        = "TWEAK_BEEHAT",
            label                       = TWEAK_BEEHAT_LABEL,
            hover                       = TWEAK_BEEHAT_HOVER,
            options                     = TWEAK_BEEHAT_OPTIONS,
            default                     = true
        },
        {
            name                        = "TWEAK_INSPECTACLESHAT",
            label                       = TWEAK_INSPECTACLESHAT_LABEL,
            hover                       = TWEAK_INSPECTACLESHAT_HOVER,
            options                     = TWEAK_INSPECTACLESHAT_OPTIONS,
            default                     = true
        },
        {
            name                        = "TWEAK_ARMORMARBLE",
            label                       = TWEAK_ARMORMARBLE_LABEL,
            hover                       = TWEAK_ARMORMARBLE_HOVER,
            options                     = TWEAK_ARMORMARBLE_OPTIONS,
            default                     = true
        },
        {
            name                        = "SEPARATOR",
            label                       = SEPARATOR_LABEL,
            hover                       = SEPARATOR_HOVER,
            options                     = NONE_OPTIONS,
            default                     = false
        },
        {
            name                        = "TWEAK_MANNEQUIN",
            label                       = TWEAK_MANNEQUIN_LABEL,
            hover                       = TWEAK_MANNEQUIN_HOVER,
            options                     = TWEAK_MANNEQUIN_OPTIONS,
            default                     = false
        },
    }
end

local function GetClientOptions()
    local NONE_OPTIONS                  = GetNoneOptions()

    local CLIENT_LABEL                  = ChooseTranslationTable(STRINGS.SETTINGS.CLIENT.NAME)
    local CLIENT_HOVER                  = ChooseTranslationTable(STRINGS.SETTINGS.CLIENT.HOVER)

    local BATVISION_CC_LABEL            = ChooseTranslationTable(STRINGS.SETTINGS.BATVISION_CC.NAME)
    local BATVISION_CC_HOVER            = ChooseTranslationTable(STRINGS.SETTINGS.BATVISION_CC.HOVER)
    local BATVISION_CC_OPTIONS          =
    {
        {
            description                 = ChooseTranslationTable(STRINGS.SETTINGS.DISABLED),
            hover                       = ChooseTranslationTable(STRINGS.SETTINGS.BATVISION_CC.HOVER_OPTIONS.DISABLED),
            data                        = false
        },
        {
            description                 = ChooseTranslationTable(STRINGS.SETTINGS.ENABLED),
            hover                       = ChooseTranslationTable(STRINGS.SETTINGS.BATVISION_CC.HOVER_OPTIONS.ENABLED),
            data                        = true
        }
    }

    local HEATVISION_CC_LABEL           = ChooseTranslationTable(STRINGS.SETTINGS.HEATVISION_CC.NAME)
    local HEATVISION_CC_HOVER           = ChooseTranslationTable(STRINGS.SETTINGS.HEATVISION_CC.HOVER)
    local HEATVISION_CC_OPTIONS         =
    {
        {
            description                 = ChooseTranslationTable(STRINGS.SETTINGS.DISABLED),
            hover                       = ChooseTranslationTable(STRINGS.SETTINGS.HEATVISION_CC.HOVER_OPTIONS.DISABLED),
            data                        = false
        },
        {
            description                 = ChooseTranslationTable(STRINGS.SETTINGS.ENABLED),
            hover                       = ChooseTranslationTable(STRINGS.SETTINGS.HEATVISION_CC.HOVER_OPTIONS.ENABLED),
            data                        = true
        }
    }

    local SHOOTVISION_CC_LABEL          = ChooseTranslationTable(STRINGS.SETTINGS.SHOOTVISION_CC.NAME)
    local SHOOTVISION_CC_HOVER          = ChooseTranslationTable(STRINGS.SETTINGS.SHOOTVISION_CC.HOVER)
    local SHOOTVISION_CC_OPTIONS        =
    {
        {
            description                 = ChooseTranslationTable(STRINGS.SETTINGS.DISABLED),
            hover                       = ChooseTranslationTable(STRINGS.SETTINGS.SHOOTVISION_CC.HOVER_OPTIONS.DISABLED),
            data                        = false
        },
        {
            description                 = ChooseTranslationTable(STRINGS.SETTINGS.ENABLED),
            hover                       = ChooseTranslationTable(STRINGS.SETTINGS.SHOOTVISION_CC.HOVER_OPTIONS.ENABLED),
            data                        = true
        }
    }

    return
    {
        {
            name                        = "CLIENT",
            label                       = CLIENT_LABEL,
            hover                       = CLIENT_HOVER,
            options                     = NONE_OPTIONS,
            default                     = false,
            client                      = true
        },
        {
            name                        = "BATVISION_CC",
            label                       = BATVISION_CC_LABEL,
            hover                       = BATVISION_CC_HOVER,
            options                     = BATVISION_CC_OPTIONS,
            default                     = true,
            client                      = true
        },
        {
            name                        = "HEATVISION_CC",
            label                       = HEATVISION_CC_LABEL,
            hover                       = HEATVISION_CC_HOVER,
            options                     = HEATVISION_CC_OPTIONS,
            default                     = true,
            client                      = true
        },
        {
            name                        = "SHOOTVISION_CC",
            label                       = SHOOTVISION_CC_LABEL,
            hover                       = SHOOTVISION_CC_HOVER,
            options                     = SHOOTVISION_CC_OPTIONS,
            default                     = true,
            client                      = true
        },
    }
end

configuration_options = {}

AddConfigurationOptions(configuration_options, GetGeneralOptions())
AddConfigurationOptions(configuration_options, GetVanillaOptions())
AddConfigurationOptions(configuration_options, GetClientOptions())