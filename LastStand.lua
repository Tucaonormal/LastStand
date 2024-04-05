--- STEAMODDED HEADER
--- MOD_NAME: Last Stand Challenge
--- MOD_ID: LastStand
--- MOD_AUTHOR: [Tucaonormal]
--- MOD_DESCRIPTION: A mod that adds a Challenge Deck to the game Balatro. The name of this Challenge is a tribute to one of the most popular and comprehensively researched Mini-games in the acclaimed classic video game Plants vs. Zombies, and so are its peculiar rules which banned almost all ways of earning money and all ways for obtaining free stuffs.

----------------------------------------------
------------MOD CODE -------------------------

function SMODS.INIT.LastStand()
	G.localization.misc.challenge_names["c_laststand"] = "Last Stand"

	local c = {
		name = "Last Stand",
		id = "c_laststand",
		rules = {
			modifiers = {
				{ id = "dollars", value = 250 },
			},
			custom = {
				{id = 'no_reward'},
                {id = 'no_extra_hand_money'},
                {id = 'no_interest'},
                {id = 'last_stand_rule1'},
                {id = 'last_stand_rule2'},
			}
		},
		consumeables = {
		},
		vouchers = {
		},
		deck = {
			type = "Challenge Deck",
		},
        restrictions = {
            banned_cards = {
                {id = 'v_seed_money'},
                {id = 'v_money_tree'},
                {id = 'j_to_the_moon'},
                {id = 'j_rocket'},
                {id = 'j_golden'},
                {id = 'j_satellite'},
                {id = 'j_delayed_grat'},
                {id = 'j_business'},
                {id = 'j_faceless'},
                {id = 'j_todo_list'},
                {id = 'j_ticket'},
                {id = 'j_matador'},
                {id = 'j_cloud_9'},
                {id = 'j_reserved_parking'},
                {id = 'j_mail'},
                {id = 'j_rough_gem'},
                {id = 'j_chaos'},
                {id = 'j_astronomer'},
                {id = 'c_hermit'},
                {id = 'c_temperance'},
                {id = 'c_talisman'},
            },
            banned_tags = {
                {id = 'tag_standard'},
                {id = 'tag_charm'},
                {id = 'tag_meteor'},
                {id = 'tag_buffoon'},
                {id = 'tag_handy'},
                {id = 'tag_garbage'},
                {id = 'tag_coupon'},
                {id = 'tag_d_six'},
                {id = 'tag_skip'},
                {id = 'tag_investment'},
                {id = 'tag_economy'},
                {id = 'tag_ethereal'},
            },
            banned_other = {
            },
        },
	}
	G.CHALLENGES[#G.CHALLENGES + 1] = c
    -- Localization
    G.localization.misc.challenge_names.c_laststand = "Last Stand"
    G.localization.misc.v_text.ch_c_last_stand_rule1 = {
        "After defeating each {C:attention}Boss Blind{}, earn {C:money}$10{}"
    }
    G.localization.misc.v_text.ch_c_last_stand_rule2 = {
        "Cannot earn money through any other means (including selling cards)"
    }
    -- Update localization
    init_localization()

    local ease_dollars_0 = ease_dollars
    function ease_dollars(mod, instant)
        local function _mod(mod)
            local dollar_UI = G.HUD:get_UIE_by_ID('dollar_text_UI')
            mod = mod or 0
            local text = '+'..localize('$')
            local col = G.C.MONEY
            if mod > 0 and G.GAME.challenge == "c_laststand" then
                mod = 0
            end
            if mod < 0 then
                text = '-'..localize('$')
                col = G.C.RED              
            else
              inc_career_stat('c_dollars_earned', mod)
            end
            if mod == 0 then
                return
            end
            G.GAME.dollars = G.GAME.dollars + mod
            check_and_set_high_score('most_money', G.GAME.dollars)
            check_for_unlock({type = 'money'})
            dollar_UI.config.object:update()
            G.HUD:recalculate()
            attention_text({
              text = text..tostring(math.abs(mod)),
              scale = 0.8, 
              hold = 0.7,
              cover = dollar_UI.parent,
              cover_colour = col,
              align = 'cm',
              })
            play_sound('coin1')
        end
        if instant then
            _mod(mod)
        else
            G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            func = function()
                _mod(mod)
                return true
            end
            }))
        end
    end

    local Back_trigger_effect_ref = Back.trigger_effect
	function Back.trigger_effect(self, args)
        local nu_chip, nu_mult = Back_trigger_effect_ref(self, args)
		if G.GAME.challenge == "c_laststand" then
            if args.context == 'eval' and G.GAME.last_blind and G.GAME.last_blind.boss then
                ease_dollars_0(10)
            end
            return Back_trigger_effect_ref(self, args)
		end
        return nu_chip, nu_mult
	end
end

----------------------------------------------
------------MOD CODE END----------------------