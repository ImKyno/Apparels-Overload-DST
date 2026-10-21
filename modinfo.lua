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

󰀏 Featuring the Retailored! Update:
New clothing, headwear and many more changes! 

The Mod has been completely rewritten from scratch to improve performance and compatibility with future updates and other Mods.

It also includes changes to some Vanilla items as well!

󰀏 Client-side Configuration is available through:
Main Menu - Mods - Server Mods - Apparels Overload

󰀌 Mod Version: 2.9-B
󰀧 Update: Retailored!
]],
        pt  =
[[
󰀖 Atravesse o Constante com estilo usando novas roupas, chapéus e acessórios. Desperte suas habilidades de moda!

󰀏 Apresentando a Atualização Repaginada!:
Novas roupas, chapéus e muitas mudanças!

O Mod foi completamente reescrito do zero para melhorar performance e compatibilidade com atualizações futuras e outros Mods.

Também inclui mudanças para alguns itens do Vanilla!

󰀏 Configurações Cliente estão disponívels em:
Menu Principal - Mods - Mods de Servidor - Amontoado de Roupas

󰀌 Mod Version: 2.9-B
󰀧 Update: Repaginada!
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

        TWEAK_ANTLIONHAT =
        {
            NAME =
            {
                "Turf-Raiser Helm - Tweaks",
                pt  = "Chapéu Revolvedor de Solo - Mudanças",
            },

            HOVER =
            {
                "Should the Turf-Raiser Helm have new features?\nVisit the Mod's Wiki for more information.",
                pt  = "Permitir que o Chapéu Revolvedor de Solo tenha novos recursos?\nVisite a Wiki do Mod para mais informações.",
            },

            HOVER_OPTIONS =
            {
                DISABLED =
                {
                    "Default Turf-Raiser Helm.",
                    pt  = "Chapéu Revolvedor de Solo Padrão",
                },

                ENABLED =
                {
                    "Turf-Raiser Helm will have some new features.",
                    pt  = "O Chapéu Revolvedor de Solo terá novos recursos.",
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
                    pt  = "O Chapéu de Apicultor e a Cora da Abelha Rainha terão novos recursos.",
                },
            },
        },

        TWEAK_CATCOONHAT =
        {
            NAME =
            {
                "Cat Cap - Tweaks",
                pt  = "Chapéu de Gato - Mudanças",
            },

            HOVER =
            {
                "Should the Cat Cap have new features?\nVisit the Mod's Wiki for more information.",
                pt  = "Permitir que o Chapéu de Gato tenha novos recursos?\nVisite a Wiki do Mod para mais informações.",
            },

            HOVER_OPTIONS =
            {
                DISABLED =
                {
                    "Default Cat Cap.",
                    pt  = "Chapéu de Gato Padrão",
                },

                ENABLED =
                {
                    "Cat Cap will have some new features.",
                    pt  = "O Chapéu de Gato terá novos recursos.",
                },
            },
        },

        TWEAK_COOKIECUTTERHAT =
        {
            NAME =
            {
                "Cookie Cutter Cap - Tweaks",
                pt  = "Chapéu de Cupim - Mudanças",
            },

            HOVER =
            {
                "Should the Cookie Cutter Cap have new features?\nVisit the Mod's Wiki for more information.",
                pt  = "Permitir que o Chapéu de Cupim tenha novos recursos?\nVisite a Wiki do Mod para mais informações.",
            },

            HOVER_OPTIONS =
            {
                DISABLED =
                {
                    "Default Cookie Cutter Cap.",
                    pt  = "Chapéu de Cupim Padrão",
                },

                ENABLED =
                {
                    "Cookie Cutter Cap will have some new features.",
                    pt  = "O Chapéu de Cupim terá novos recursos.",
                },
            },
        },

        TWEAK_EARMUFFSHAT =
        {
            NAME =
            {
                "Rabbit Earmuffs - Tweaks",
                pt  = "P. de Orelha de Coelho - Mudanças",
            },

            HOVER =
            {
                "Should the Rabbit Earmuffs have new features?\nVisit the Mod's Wiki for more information.",
                pt  = "Permitir que o P. de Orelhas de Coelho tenha novos recursos?\nVisite a Wiki do Mod para mais informações.",
            },

            HOVER_OPTIONS =
            {
                DISABLED =
                {
                    "Default Rabbit Earmuffs.",
                    pt  = "Protetor de Orelhas de Coelho Padrão",
                },

                ENABLED =
                {
                    "Rabbit Earmuffs will have some new features.",
                    pt  = "O Protetor de Orelhas de Coelho terá novos recursos.",
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

        TWEAK_MUSHROOMHAT =
        {
            NAME =
            {
                "Mushroom Funcaps - Tweaks",
                pt  = "Chapéus de Cogumelos - Mudanças",
            },

            HOVER =
            {
                "Should the Mushroom Funcaps have new features?\nVisit the Mod's Wiki for more information.",
                pt  = "Permitir que os Chapéus de Cogumelos tenha novos recursos?\nVisite a Wiki do Mod para mais informações.",
            },

            HOVER_OPTIONS =
            {
                DISABLED =
                {
                    "Default Mushroom Funcaps.",
                    pt  = "Chapéus de Cogumelos Padrões",
                },

                ENABLED =
                {
                    "Mushroom Funcaps will have some new features.",
                    pt  = "Os Chapéus de Cogumelos terão novos recursos.",
                },
            },
        },

        TWEAK_RAINHAT =
        {
            NAME =
            {
                "Rain Hat - Tweaks",
                pt  = "Chapéu de Chuva - Mudanças",
            },

            HOVER =
            {
                "Should the Rain Hat have new features?\nVisit the Mod's Wiki for more information.",
                pt  = "Permitir que o Chapéu de Chuva tenha novos recursos?\nVisite a Wiki do Mod para mais informações.",
            },

            HOVER_OPTIONS =
            {
                DISABLED =
                {
                    "Default Rain Hat.",
                    pt  = "Chapéu de Chuva Padrão",
                },

                ENABLED =
                {
                    "Rain Hat will have some new features.",
                    pt  = "O Chapéu de Chuva terá novos recursos.",
                },
            },
        },

        TWEAK_SLURTLEHAT =
        {
            NAME =
            {
                "Shelmet - Tweaks",
                pt  = "Carapacete - Mudanças",
            },

            HOVER =
            {
                "Should the Shelmet have new features?\nVisit the Mod's Wiki for more information.",
                pt  = "Permitir que o Carapacete tenha novos recursos?\nVisite a Wiki do Mod para mais informações.",
            },

            HOVER_OPTIONS =
            {
                DISABLED =
                {
                    "Default Shelmet.",
                    pt  = "Carapacete Padrão",
                },

                ENABLED =
                {
                    "Shelmet will have some new features.",
                    pt  = "O Carapacete terá novos recursos.",
                },
            },
        },

        TWEAK_SPIDERHAT =
        {
            NAME =
            {
                "Spiderhat - Tweaks",
                pt  = "Chapéu de Aranha - Mudanças",
            },

            HOVER =
            {
                "Should the Spiderhat have new features?\nVisit the Mod's Wiki for more information.",
                pt  = "Permitir que o Chapéu de Aranha tenha novos recursos?\nVisite a Wiki do Mod para mais informações.",
            },

            HOVER_OPTIONS =
            {
                DISABLED =
                {
                    "Default Spiderhat.",
                    pt  = "Chapéu de Aranha Padrão",
                },

                ENABLED =
                {
                    "Spiderhat will have some new features.",
                    pt  = "O Chapéu de Aranha terá novos recursos.",
                },
            },
        },

        TWEAK_WINTERHAT =
        {
            NAME =
            {
                "Winter Hat - Tweaks",
                pt  = "Chapéu de Inverno - Mudanças",
            },

            HOVER =
            {
                "Should the Winter Hat have new features?\nVisit the Mod's Wiki for more information.",
                pt  = "Permitir que o Chapéu de Inverno tenha novos recursos?\nVisite a Wiki do Mod para mais informações.",
            },

            HOVER_OPTIONS =
            {
                DISABLED =
                {
                    "Default Winter Hat.",
                    pt  = "Chapéu de Inverno Padrão",
                },

                ENABLED =
                {
                    "Winter Hat will have some new features.",
                    pt  = "O Chapéu de Inverno terá novos recursos.",
                },
            },
        },

        -- CLOTHING
        TWEAK_ARMORSLURPER =
        {
            NAME =
            {
                "Belt of Hunger - Tweaks",
                pt  = "Cinto da Fome - Mudanças",
            },

            HOVER =
            {
                "Should the Belt of Hunger have new features?\nVisit the Mod's Wiki for more information.",
                pt  = "Permitir que o Cinto da Fome tenha novos recursos?\nVisite a Wiki do Mod para mais informações.",
            },

            HOVER_OPTIONS =
            {
                DISABLED =
                {
                    "Default Belt of Hunger.",
                    pt  = "Cinto da Fome Padrão.",
                },

                ENABLED =
                {
                    "Belt of Hunger will have some new features.",
                    pt  = "O Cinto da Fome terá recursos novos.",
                },
            },
        },

        TWEAK_ARMORSNURTLE =
        {
            NAME =
            {
                "Snurtle Shell Armor - Tweaks",
                pt  = "Concha de Tartareca - Mudanças",
            },

            HOVER =
            {
                "Should the Snurtle Shell Armor have new features?\nVisit the Mod's Wiki for more information.",
                pt  = "Permitir que a Concha de Tartareca tenha novos recursos?\nVisite a Wiki do Mod para mais informações.",
            },

            HOVER_OPTIONS =
            {
                DISABLED =
                {
                    "Default Snurtle Shell Armor.",
                    pt  = "Concha de Tartareca Padrão",
                },

                ENABLED =
                {
                    "Snurtle Shell Armor will have some new features.",
                    pt  = "A Concha de Tartareca terá novos recursos.",
                },
            },
        },

        TWEAK_BEARGERVEST =
        {
            NAME =
            {
                "Hibearnation Vest - Tweaks",
                pt  = "Veste de Hibernação - Mudanças",
            },

            HOVER =
            {
                "Should the Hibearnation Vest have new features?\nVisit the Mod's Wiki for more information.",
                pt  = "Permitir que a Veste de Hibernação tenha novos recursos?\nVisite a Wiki do Mod para mais informações.",
            },

            HOVER_OPTIONS =
            {
                DISABLED =
                {
                    "Default Hibearnation Vest.",
                    pt  = "Veste de Hibernação Padrão",
                },

                ENABLED =
                {
                    "Hibearnation Vest will have some new features.",
                    pt  = "A Veste de Hibernação terá novos recursos.",
                },
            },
        },

        TWEAK_HAWAIIANSHIRT =
        {
            NAME =
            {
                "Floral Shirt - Tweaks",
                pt  = "Camiseta Floral - Mudanças",
            },

            HOVER =
            {
                "Should the Floral Shirt have new features?\nVisit the Mod's Wiki for more information.",
                pt  = "Permitir que a Camiseta Floral tenha novos recursos?\nVisite a Wiki do Mod para mais informações.",
            },

            HOVER_OPTIONS =
            {
                DISABLED =
                {
                    "Default Floral Shirt.",
                    pt  = "Camiseta Floral Padrão",
                },

                ENABLED =
                {
                    "Floral Shirt will have some new features.",
                    pt  = "A Camiseta Floral terá novos recursos.",
                },
            },
        },

        TWEAK_REFLECTIVEVEST =
        {
            NAME =
            {
                "Summer Frest - Tweaks",
                pt  = "Freste de Verão - Mudanças",
            },

            HOVER =
            {
                "Should the Summer Frest have new features?\nVisit the Mod's Wiki for more information.",
                pt  = "Permitir que o Freste de Verão tenha novos recursos?\nVisite a Wiki do Mod para mais informações.",
            },

            HOVER_OPTIONS =
            {
                DISABLED =
                {
                    "Default Summer Frest.",
                    pt  = "Freste de Verão Padrão",
                },

                ENABLED =
                {
                    "Summer Frest will have some new features.",
                    pt  = "O Freste de Verão terá novos recursos.",
                },
            },
        },

        TWEAK_SWEATERVEST =
        {
            NAME =
            {
                "Dapper Vest - Tweaks",
                pt  = "Veste Elegante - Mudanças",
            },

            HOVER =
            {
                "Should the Dapper Vest have new features?\nVisit the Mod's Wiki for more information.",
                pt  = "Permitir que a Veste Elegante tenha novos recursos?\nVisite a Wiki do Mod para mais informações.",
            },

            HOVER_OPTIONS =
            {
                DISABLED =
                {
                    "Default Dapper Vest.",
                    pt  = "Veste Elegante Padrão",
                },

                ENABLED =
                {
                    "Dapper Vest will have some new features.",
                    pt  = "A Veste Elegante terá novos recursos.",
                },
            },
        },

        TWEAK_TRUNKVEST_S =
        {
            NAME =
            {
                "Breezy Vest - Tweaks",
                pt  = "Veste Arejada - Mudanças",
            },

            HOVER =
            {
                "Should the Breezy Vest have new features?\nVisit the Mod's Wiki for more information.",
                pt  = "Permitir que a Veste Arejada tenha novos recursos?\nVisite a Wiki do Mod para mais informações.",
            },

            HOVER_OPTIONS =
            {
                DISABLED =
                {
                    "Default Breezy Vest.",
                    pt  = "Veste Arejada Padrão",
                },

                ENABLED =
                {
                    "Breezy Vest will have some new features.",
                    pt  = "A Veste Arejada terá novos recursos.",
                },
            },
        },

        TWEAK_TRUNKVEST_W =
        {
            NAME =
            {
                "Puffy Vest - Tweaks",
                pt  = "Veste Arejada - Mudanças",
            },

            HOVER =
            {
                "Should the Puffy Vest have new features?\nVisit the Mod's Wiki for more information.",
                pt  = "Permitir que a Veste Inchada tenha novos recursos?\nVisite a Wiki do Mod para mais informações.",
            },

            HOVER_OPTIONS =
            {
                DISABLED =
                {
                    "Default Puffy Vest.",
                    pt  = "Veste Inchada Padrão",
                },

                ENABLED =
                {
                    "Puffy Vest will have some new features.",
                    pt  = "A Veste Inchada terá novos recursos.",
                },
            },
        },

        -- SET BONUS
        TWEAK_ARMORMARBLE =
        {
            NAME =
            {
                "Marble - Set Bonus",
                pt  = "Mármore - Bônus de Conjunto",
            },

            HOVER =
            {
                "Should the Marble Helmet/Suit have a Set Bonus?\nVisit the Mod's Wiki for more information.",
                pt  = "Permitir que a Armadura/Capacete de Mármore tenha um Bônus de Conjunto?\nVisite a Wiki do Mod para mais informações.",
            },

            HOVER_OPTIONS =
            {
                DISABLED =
                {
                    "Default Marble Helmet/Suit.",
                    pt  = "Armadura/Capacete de Mármore Padrão.",
                },

                ENABLED =
                {
                    "Marble Helmet/Suit will have a Set Bonus.",
                    pt  = "A Armadura/Capacete de Mármore terá um Bônus de Conjunto.",
                },
            },
        },

        TWEAK_ARMORRUINS =
        {
            NAME =
            {
                "Thulecite - Set Bonus",
                pt  = "Thulecita - Bônus de Conjunto",
            },

            HOVER =
            {
                "Should the Thulecite Crown/Suit have a Set Bonus?\nVisit the Mod's Wiki for more information.",
                pt  = "Permitir que a Coroa/Armadura de Thulecita tenha um Bônus de Conjunto?\nVisite a Wiki do Mod para mais informações.",
            },

            HOVER_OPTIONS =
            {
                DISABLED =
                {
                    "Default Thulecite Crown/Suit.",
                    pt  = "Coroa/Armadura de Thulecita Padrão.",
                },

                ENABLED =
                {
                    "Thulecite Crown/Suit will have a Set Bonus.",
                    pt  = "A Coroa/Armadura de Thulecita terá um Bônus de Conjunto.",
                },
            },
        },

        -- MISC
        TWEAK_FOLLOWER =
        {
            NAME =
            {
                "Creatures - Wear Out",
                pt  = "Creatures - Desgaste",
            },

            HOVER =
            {
                "Should Clothing and Headwear wear out on Creatures?",
                pt  = "Permitir que Roupas e Chapéus desgastem se estiverem em Criaturas?",
            },

            HOVER_OPTIONS = -- THIS OPTION IS BACKWARDS !!!
            {
                DISABLED =
                {
                    "Clothing and Headwear will not wear out on Creatures.",
                    pt  = "Roupas e Chapéus não irão desgastar se estiverem em Criaturas.",
                },

                ENABLED =
                {
                    "Default Creatures behaviour.",
                    pt  = "Comportamento padrão de Criaturas.",
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

    -- HEADWEAR
    local TWEAK_ANTLIONHAT_LABEL        = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_ANTLIONHAT.NAME)
    local TWEAK_ANTLIONHAT_HOVER        = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_ANTLIONHAT.HOVER)
    local TWEAK_ANTLIONHAT_OPTIONS      =
    {
        {
            description                 = ChooseTranslationTable(STRINGS.SETTINGS.DISABLED),
            hover                       = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_ANTLIONHAT.HOVER_OPTIONS.DISABLED),
            data                        = false
        },
        {
            description                 = ChooseTranslationTable(STRINGS.SETTINGS.ENABLED),
            hover                       = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_ANTLIONHAT.HOVER_OPTIONS.ENABLED),
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

    local TWEAK_CATCOONHAT_LABEL        = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_CATCOONHAT.NAME)
    local TWEAK_CATCOONHAT_HOVER        = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_CATCOONHAT.HOVER)
    local TWEAK_CATCOONHAT_OPTIONS      =
    {
        {
            description                 = ChooseTranslationTable(STRINGS.SETTINGS.DISABLED),
            hover                       = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_CATCOONHAT.HOVER_OPTIONS.DISABLED),
            data                        = false
        },
        {
            description                 = ChooseTranslationTable(STRINGS.SETTINGS.ENABLED),
            hover                       = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_CATCOONHAT.HOVER_OPTIONS.ENABLED),
            data                        = true
        }
    }

    local TWEAK_COOKIECUTTERHAT_LABEL   = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_COOKIECUTTERHAT.NAME)
    local TWEAK_COOKIECUTTERHAT_HOVER   = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_COOKIECUTTERHAT.HOVER)
    local TWEAK_COOKIECUTTERHAT_OPTIONS =
    {
        {
            description                 = ChooseTranslationTable(STRINGS.SETTINGS.DISABLED),
            hover                       = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_COOKIECUTTERHAT.HOVER_OPTIONS.DISABLED),
            data                        = false
        },
        {
            description                 = ChooseTranslationTable(STRINGS.SETTINGS.ENABLED),
            hover                       = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_COOKIECUTTERHAT.HOVER_OPTIONS.ENABLED),
            data                        = true
        }
    }

    local TWEAK_EARMUFFSHAT_LABEL       = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_EARMUFFSHAT.NAME)
    local TWEAK_EARMUFFSHAT_HOVER       = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_EARMUFFSHAT.HOVER)
    local TWEAK_EARMUFFSHAT_OPTIONS     =
    {
        {
            description                 = ChooseTranslationTable(STRINGS.SETTINGS.DISABLED),
            hover                       = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_EARMUFFSHAT.HOVER_OPTIONS.DISABLED),
            data                        = false
        },
        {
            description                 = ChooseTranslationTable(STRINGS.SETTINGS.ENABLED),
            hover                       = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_EARMUFFSHAT.HOVER_OPTIONS.ENABLED),
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

    local TWEAK_MUSHROOMHAT_LABEL       = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_MUSHROOMHAT.NAME)
    local TWEAK_MUSHROOMHAT_HOVER       = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_MUSHROOMHAT.HOVER)
    local TWEAK_MUSHROOMHAT_OPTIONS     =
    {
        {
            description                 = ChooseTranslationTable(STRINGS.SETTINGS.DISABLED),
            hover                       = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_MUSHROOMHAT.HOVER_OPTIONS.DISABLED),
            data                        = false
        },
        {
            description                 = ChooseTranslationTable(STRINGS.SETTINGS.ENABLED),
            hover                       = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_MUSHROOMHAT.HOVER_OPTIONS.ENABLED),
            data                        = true
        }
    }

    local TWEAK_RAINHAT_LABEL         = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_RAINHAT.NAME)
    local TWEAK_RAINHAT_HOVER         = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_RAINHAT.HOVER)
    local TWEAK_RAINHAT_OPTIONS       =
    {
        {
            description                 = ChooseTranslationTable(STRINGS.SETTINGS.DISABLED),
            hover                       = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_RAINHAT.HOVER_OPTIONS.DISABLED),
            data                        = false
        },
        {
            description                 = ChooseTranslationTable(STRINGS.SETTINGS.ENABLED),
            hover                       = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_RAINHAT.HOVER_OPTIONS.ENABLED),
            data                        = true
        }
    }

    local TWEAK_SLURTLEHAT_LABEL         = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_SLURTLEHAT.NAME)
    local TWEAK_SLURTLEHAT_HOVER         = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_SLURTLEHAT.HOVER)
    local TWEAK_SLURTLEHAT_OPTIONS       =
    {
        {
            description                 = ChooseTranslationTable(STRINGS.SETTINGS.DISABLED),
            hover                       = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_SLURTLEHAT.HOVER_OPTIONS.DISABLED),
            data                        = false
        },
        {
            description                 = ChooseTranslationTable(STRINGS.SETTINGS.ENABLED),
            hover                       = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_SLURTLEHAT.HOVER_OPTIONS.ENABLED),
            data                        = true
        }
    }

    local TWEAK_SPIDERHAT_LABEL         = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_SPIDERHAT.NAME)
    local TWEAK_SPIDERHAT_HOVER         = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_SPIDERHAT.HOVER)
    local TWEAK_SPIDERHAT_OPTIONS       =
    {
        {
            description                 = ChooseTranslationTable(STRINGS.SETTINGS.DISABLED),
            hover                       = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_SPIDERHAT.HOVER_OPTIONS.DISABLED),
            data                        = false
        },
        {
            description                 = ChooseTranslationTable(STRINGS.SETTINGS.ENABLED),
            hover                       = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_SPIDERHAT.HOVER_OPTIONS.ENABLED),
            data                        = true
        }
    }

    local TWEAK_WINTERHAT_LABEL         = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_WINTERHAT.NAME)
    local TWEAK_WINTERHAT_HOVER         = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_WINTERHAT.HOVER)
    local TWEAK_WINTERHAT_OPTIONS       =
    {
        {
            description                 = ChooseTranslationTable(STRINGS.SETTINGS.DISABLED),
            hover                       = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_WINTERHAT.HOVER_OPTIONS.DISABLED),
            data                        = false
        },
        {
            description                 = ChooseTranslationTable(STRINGS.SETTINGS.ENABLED),
            hover                       = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_WINTERHAT.HOVER_OPTIONS.ENABLED),
            data                        = true
        }
    }

    -- CLOTHING
    local TWEAK_ARMORSLURPER_LABEL      = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_ARMORSLURPER.NAME)
    local TWEAK_ARMORSLURPER_HOVER      = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_ARMORSLURPER.HOVER)
    local TWEAK_ARMORSLURPER_OPTIONS    =
    {
        {
            description                 = ChooseTranslationTable(STRINGS.SETTINGS.DISABLED),
            hover                       = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_ARMORSLURPER.HOVER_OPTIONS.DISABLED),
            data                        = false
        },
        {
            description                 = ChooseTranslationTable(STRINGS.SETTINGS.ENABLED),
            hover                       = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_ARMORSLURPER.HOVER_OPTIONS.ENABLED),
            data                        = true
        }
    }

    local TWEAK_ARMORSNURTLE_LABEL      = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_ARMORSNURTLE.NAME)
    local TWEAK_ARMORSNURTLE_HOVER      = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_ARMORSNURTLE.HOVER)
    local TWEAK_ARMORSNURTLE_OPTIONS    =
    {
        {
            description                 = ChooseTranslationTable(STRINGS.SETTINGS.DISABLED),
            hover                       = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_ARMORSNURTLE.HOVER_OPTIONS.DISABLED),
            data                        = false
        },
        {
            description                 = ChooseTranslationTable(STRINGS.SETTINGS.ENABLED),
            hover                       = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_ARMORSNURTLE.HOVER_OPTIONS.ENABLED),
            data                        = true
        }
    }

    local TWEAK_BEARGERVEST_LABEL       = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_BEARGERVEST.NAME)
    local TWEAK_BEARGERVEST_HOVER       = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_BEARGERVEST.HOVER)
    local TWEAK_BEARGERVEST_OPTIONS     =
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

    local TWEAK_HAWAIIANSHIRT_LABEL     = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_HAWAIIANSHIRT.NAME)
    local TWEAK_HAWAIIANSHIRT_HOVER     = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_HAWAIIANSHIRT.HOVER)
    local TWEAK_HAWAIIANSHIRT_OPTIONS   =
    {
        {
            description                 = ChooseTranslationTable(STRINGS.SETTINGS.DISABLED),
            hover                       = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_HAWAIIANSHIRT.HOVER_OPTIONS.DISABLED),
            data                        = false
        },
        {
            description                 = ChooseTranslationTable(STRINGS.SETTINGS.ENABLED),
            hover                       = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_HAWAIIANSHIRT.HOVER_OPTIONS.ENABLED),
            data                        = true
        }
    }

    local TWEAK_REFLECTIVEVEST_LABEL    = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_REFLECTIVEVEST.NAME)
    local TWEAK_REFLECTIVEVEST_HOVER    = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_REFLECTIVEVEST.HOVER)
    local TWEAK_REFLECTIVEVEST_OPTIONS  =
    {
        {
            description                 = ChooseTranslationTable(STRINGS.SETTINGS.DISABLED),
            hover                       = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_REFLECTIVEVEST.HOVER_OPTIONS.DISABLED),
            data                        = false
        },
        {
            description                 = ChooseTranslationTable(STRINGS.SETTINGS.ENABLED),
            hover                       = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_REFLECTIVEVEST.HOVER_OPTIONS.ENABLED),
            data                        = true
        }
    }

    local TWEAK_SWEATERVEST_LABEL       = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_SWEATERVEST.NAME)
    local TWEAK_SWEATERVEST_HOVER       = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_SWEATERVEST.HOVER)
    local TWEAK_SWEATERVEST_OPTIONS     =
    {
        {
            description                 = ChooseTranslationTable(STRINGS.SETTINGS.DISABLED),
            hover                       = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_SWEATERVEST.HOVER_OPTIONS.DISABLED),
            data                        = false
        },
        {
            description                 = ChooseTranslationTable(STRINGS.SETTINGS.ENABLED),
            hover                       = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_SWEATERVEST.HOVER_OPTIONS.ENABLED),
            data                        = true
        }
    }

    local TWEAK_TRUNKVEST_S_LABEL       = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_TRUNKVEST_S.NAME)
    local TWEAK_TRUNKVEST_S_HOVER       = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_TRUNKVEST_S.HOVER)
    local TWEAK_TRUNKVEST_S_OPTIONS     =
    {
        {
            description                 = ChooseTranslationTable(STRINGS.SETTINGS.DISABLED),
            hover                       = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_TRUNKVEST_S.HOVER_OPTIONS.DISABLED),
            data                        = false
        },
        {
            description                 = ChooseTranslationTable(STRINGS.SETTINGS.ENABLED),
            hover                       = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_TRUNKVEST_S.HOVER_OPTIONS.ENABLED),
            data                        = true
        }
    }

    local TWEAK_TRUNKVEST_W_LABEL       = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_TRUNKVEST_W.NAME)
    local TWEAK_TRUNKVEST_W_HOVER       = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_TRUNKVEST_W.HOVER)
    local TWEAK_TRUNKVEST_W_OPTIONS     =
    {
        {
            description                 = ChooseTranslationTable(STRINGS.SETTINGS.DISABLED),
            hover                       = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_TRUNKVEST_W.HOVER_OPTIONS.DISABLED),
            data                        = false
        },
        {
            description                 = ChooseTranslationTable(STRINGS.SETTINGS.ENABLED),
            hover                       = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_TRUNKVEST_W.HOVER_OPTIONS.ENABLED),
            data                        = true
        }
    }

    -- SET BONUS
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

    local TWEAK_ARMORRUINS_LABEL        = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_ARMORRUINS.NAME)
    local TWEAK_ARMORRUINS_HOVER        = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_ARMORRUINS.HOVER)
    local TWEAK_ARMORRUINS_OPTIONS      =
    {
        {
            description                 = ChooseTranslationTable(STRINGS.SETTINGS.DISABLED),
            hover                       = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_ARMORRUINS.HOVER_OPTIONS.DISABLED),
            data                        = false
        },
        {
            description                 = ChooseTranslationTable(STRINGS.SETTINGS.ENABLED),
            hover                       = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_ARMORRUINS.HOVER_OPTIONS.ENABLED),
            data                        = true
        }
    }

    -- MISC
    -- THESE OPTION ARE BACKWARDS !!!
    local TWEAK_FOLLOWER_LABEL         = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_FOLLOWER.NAME)
    local TWEAK_FOLLOWER_HOVER         = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_FOLLOWER.HOVER)
    local TWEAK_FOLLOWER_OPTIONS       =
    {
        {
            description                 = ChooseTranslationTable(STRINGS.SETTINGS.DISABLED),
            hover                       = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_FOLLOWER.HOVER_OPTIONS.DISABLED),
            data                        = false
        },
        {
            description                 = ChooseTranslationTable(STRINGS.SETTINGS.ENABLED),
            hover                       = ChooseTranslationTable(STRINGS.SETTINGS.TWEAK_FOLLOWER.HOVER_OPTIONS.ENABLED),
            data                        = true
        }
    }

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
            name                        = "TWEAK_CATCOONHAT",
            label                       = TWEAK_CATCOONHAT_LABEL,
            hover                       = TWEAK_CATCOONHAT_HOVER,
            options                     = TWEAK_CATCOONHAT_OPTIONS,
            default                     = true
        },
        {
            name                        = "TWEAK_COOKIECUTTERHAT",
            label                       = TWEAK_COOKIECUTTERHAT_LABEL,
            hover                       = TWEAK_COOKIECUTTERHAT_HOVER,
            options                     = TWEAK_COOKIECUTTERHAT_OPTIONS,
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
            name                        = "TWEAK_MUSHROOMHAT",
            label                       = TWEAK_MUSHROOMHAT_LABEL,
            hover                       = TWEAK_MUSHROOMHAT_HOVER,
            options                     = TWEAK_MUSHROOMHAT_OPTIONS,
            default                     = true
        },
        {
            name                        = "TWEAK_EARMUFFSHAT",
            label                       = TWEAK_EARMUFFSHAT_LABEL,
            hover                       = TWEAK_EARMUFFSHAT_HOVER,
            options                     = TWEAK_EARMUFFSHAT_OPTIONS,
            default                     = true
        },
        {
            name                        = "TWEAK_RAINHAT",
            label                       = TWEAK_RAINHAT_LABEL,
            hover                       = TWEAK_RAINHAT_HOVER,
            options                     = TWEAK_RAINHAT_OPTIONS,
            default                     = true
        },
        {
            name                        = "TWEAK_SLURTLEHAT",
            label                       = TWEAK_SLURTLEHAT_LABEL,
            hover                       = TWEAK_SLURTLEHAT_HOVER,
            options                     = TWEAK_SLURTLEHAT_OPTIONS,
            default                     = true
        },
        {
            name                        = "TWEAK_SPIDERHAT",
            label                       = TWEAK_SPIDERHAT_LABEL,
            hover                       = TWEAK_SPIDERHAT_HOVER,
            options                     = TWEAK_SPIDERHAT_OPTIONS,
            default                     = true
        },
        {
            name                        = "TWEAK_ANTLIONHAT",
            label                       = TWEAK_ANTLIONHAT_LABEL,
            hover                       = TWEAK_ANTLIONHAT_HOVER,
            options                     = TWEAK_ANTLIONHAT_OPTIONS,
            default                     = true
        },
        {
            name                        = "TWEAK_WINTERHAT",
            label                       = TWEAK_WINTERHAT_LABEL,
            hover                       = TWEAK_WINTERHAT_HOVER,
            options                     = TWEAK_WINTERHAT_OPTIONS,
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
            name                        = "TWEAK_ARMORSLURPER",
            label                       = TWEAK_ARMORSLURPER_LABEL,
            hover                       = TWEAK_ARMORSLURPER_HOVER,
            options                     = TWEAK_ARMORSLURPER_OPTIONS,
            default                     = true
        },
        {
            name                        = "TWEAK_TRUNKVEST_S",
            label                       = TWEAK_TRUNKVEST_S_LABEL,
            hover                       = TWEAK_TRUNKVEST_S_HOVER,
            options                     = TWEAK_TRUNKVEST_S_OPTIONS,
            default                     = true
        },
        {
            name                        = "TWEAK_SWEATERVEST",
            label                       = TWEAK_SWEATERVEST_LABEL,
            hover                       = TWEAK_SWEATERVEST_HOVER,
            options                     = TWEAK_SWEATERVEST_OPTIONS,
            default                     = true
        },
        {
            name                        = "TWEAK_HAWAIIANSHIRT",
            label                       = TWEAK_HAWAIIANSHIRT_LABEL,
            hover                       = TWEAK_HAWAIIANSHIRT_HOVER,
            options                     = TWEAK_HAWAIIANSHIRT_OPTIONS,
            default                     = true
        },
        {
            name                        = "TWEAK_BEARGERVEST",
            label                       = TWEAK_BEARGERVEST_LABEL,
            hover                       = TWEAK_BEARGERVEST_HOVER,
            options                     = TWEAK_BEARGERVEST_OPTIONS,
            default                     = true
        },
        {
            name                        = "TWEAK_TRUNKVEST_W",
            label                       = TWEAK_TRUNKVEST_W_LABEL,
            hover                       = TWEAK_TRUNKVEST_W_HOVER,
            options                     = TWEAK_TRUNKVEST_W_OPTIONS,
            default                     = true
        },
        {
            name                        = "TWEAK_ARMORSNURTLE",
            label                       = TWEAK_ARMORSNURTLE_LABEL,
            hover                       = TWEAK_ARMORSNURTLE_HOVER,
            options                     = TWEAK_ARMORSNURTLE_OPTIONS,
            default                     = true
        },
        {
            name                        = "TWEAK_REFLECTIVEVEST",
            label                       = TWEAK_REFLECTIVEVEST_LABEL,
            hover                       = TWEAK_REFLECTIVEVEST_HOVER,
            options                     = TWEAK_REFLECTIVEVEST_OPTIONS,
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
            name                        = "TWEAK_ARMORMARBLE",
            label                       = TWEAK_ARMORMARBLE_LABEL,
            hover                       = TWEAK_ARMORMARBLE_HOVER,
            options                     = TWEAK_ARMORMARBLE_OPTIONS,
            default                     = true
        },
        {
            name                        = "TWEAK_ARMORRUINS",
            label                       = TWEAK_ARMORRUINS_LABEL,
            hover                       = TWEAK_ARMORRUINS_HOVER,
            options                     = TWEAK_ARMORRUINS_OPTIONS,
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
            name                        = "TWEAK_FOLLOWER",
            label                       = TWEAK_FOLLOWER_LABEL,
            hover                       = TWEAK_FOLLOWER_HOVER,
            options                     = TWEAK_FOLLOWER_OPTIONS,
            default                     = true
        },
        {
            name                        = "TWEAK_MANNEQUIN",
            label                       = TWEAK_MANNEQUIN_LABEL,
            hover                       = TWEAK_MANNEQUIN_HOVER,
            options                     = TWEAK_MANNEQUIN_OPTIONS,
            default                     = true
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