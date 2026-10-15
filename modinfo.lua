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

        VANILLA_CHANGES =
        {
            NAME =
            {
                "Tweaks to Vanilla Items",
                pt  = "Mudanças para Items do Vanilla",
            },

            HOVER =
            {
                "Should some Clothing and Headwear have new features? Visit the Mod's Wiki for more information.",
                pt  = "Permitir que algumas Roupas e Chapéus tenham novos recursos? Visite a Wiki do Mod para mais informações.",
            },

            HOVER_OPTIONS =
            {
                DISABLED =
                {
                    "Default behaviour for Vanilla Clothing and Headwear.",
                    pt  = "Comportamento padrão para Roupas e Chapéus do Vanilla.",
                },

                ENABLED =
                {
                    "Some Clothing and Headwear will have new features.",
                    pt  = "Algumas Roupas e Chapéus terão novos recursos.",
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

    local VANILLA_CHANGES_LABEL        = ChooseTranslationTable(STRINGS.SETTINGS.VANILLA_CHANGES.NAME)
    local VANILLA_CHANGES_HOVER        = ChooseTranslationTable(STRINGS.SETTINGS.VANILLA_CHANGES.HOVER)
    local VANILLA_CHANGES_OPTIONS      =
    {
        {
            description                = ChooseTranslationTable(STRINGS.SETTINGS.DISABLED),
            hover                      = ChooseTranslationTable(STRINGS.SETTINGS.VANILLA_CHANGES.HOVER_OPTIONS.DISABLED),
            data                       = false
        },
        {
            description                = ChooseTranslationTable(STRINGS.SETTINGS.ENABLED),
            hover                      = ChooseTranslationTable(STRINGS.SETTINGS.VANILLA_CHANGES.HOVER_OPTIONS.ENABLED),
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
            name                = "VANILLA_CHANGES",
            label               = VANILLA_CHANGES_LABEL,
            hover               = VANILLA_CHANGES_HOVER,
            options             = VANILLA_CHANGES_OPTIONS,
            default             = true
        },
    }
end

local function GetClientOptions()
    local NONE_OPTIONS                 = GetNoneOptions()

    local CLIENT_LABEL                 = ChooseTranslationTable(STRINGS.SETTINGS.CLIENT.NAME)
    local CLIENT_HOVER                 = ChooseTranslationTable(STRINGS.SETTINGS.CLIENT.HOVER)

    local BATVISION_CC_LABEL           = ChooseTranslationTable(STRINGS.SETTINGS.BATVISION_CC.NAME)
    local BATVISION_CC_HOVER           = ChooseTranslationTable(STRINGS.SETTINGS.BATVISION_CC.HOVER)
    local BATVISION_CC_OPTIONS         =
    {
        {
            description                = ChooseTranslationTable(STRINGS.SETTINGS.DISABLED),
            hover                      = ChooseTranslationTable(STRINGS.SETTINGS.BATVISION_CC.HOVER_OPTIONS.DISABLED),
            data                       = false
        },
        {
            description                = ChooseTranslationTable(STRINGS.SETTINGS.ENABLED),
            hover                      = ChooseTranslationTable(STRINGS.SETTINGS.BATVISION_CC.HOVER_OPTIONS.ENABLED),
            data                       = true
        }
    }

    return
    {
        {
            name                = "CLIENT",
            label               = CLIENT_LABEL,
            hover               = CLIENT_HOVER,
            options             = NONE_OPTIONS,
            default             = false,
            client              = true
        },
        {
            name                = "BATVISION_CC",
            label               = BATVISION_CC_LABEL,
            hover               = BATVISION_CC_HOVER,
            options             = BATVISION_CC_OPTIONS,
            default             = true,
            client              = true
        },
    }
end

configuration_options = {}

AddConfigurationOptions(configuration_options, GetGeneralOptions())
AddConfigurationOptions(configuration_options, GetVanillaOptions())
AddConfigurationOptions(configuration_options, GetClientOptions())