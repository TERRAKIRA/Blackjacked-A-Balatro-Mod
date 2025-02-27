--- STEAMODDED HEADER
--- MOD_NAME: Blackjacked
--- MOD_ID: Blackjacked
--- MOD_AUTHOR: [terrakira]
--- MOD_DESCRIPTION: Blackjack themed jokers and abilities.
--- PREFIX: blckjkd
----------------------------------------------
------------MOD CODE -------------------------

SMODS.Atlas {
	-- Key for code to find it with
	key = "Jokers",
	-- The name of the file, for the code to pull the atlas from
	path = "Jokers.png",
	-- Width of each sprite in 1x size
	px = 71,
	-- Height of each sprite in 1x size
	py = 95
}

SMODS.Joker{
    key = 'black_joker', --joker key
    loc_txt = { -- local text
        name = 'Black Joker',
        text = {
            'This Joker gains {C:blue}+21{} Chips',
            'if the sum of all ranks held',
            'in hand are {C:attention}21{} or under',
            '{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips)',
        },
    },
    config = { extra = { chips = 0, chip_gain = 21 }},
    atlas = 'Jokers', --atlas' key
    rarity = 3, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 8, --cost
    unlocked = true, --whether it is unlocked or not: if true,
    discovered = true, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = { x = 0, y = 0 }, --position in atlas, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.chip_gain }}
    end,
    
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                chip_mod = card.ability.extra.chips,
                message = localize { type = 'variable', key = 'a_chips', vars = { card.ability.extra.chips }}
            }
        end

        if context.before and not context.blueprint then
			local ID_totals, temp_ID = 0, 0
            for i = 1, #G.hand.cards do
                if G.hand.cards[i].ability.effect ~= 'Stone Card' then 
                    temp_ID = G.hand.cards[i]:get_id()
                    if temp_ID <= 10 and temp_ID >= 2 then
                        ID_totals = ID_totals + temp_ID
					elseif temp_ID == 11 then
						if next(SMODS.find_card('j_blckjkd_blackknight')) or next(SMODS.find_card('j_blckjkd_redknight')) then
							ID_totals = ID_totals + 21
						else
							ID_totals = ID_totals + 10
						end
                    elseif temp_ID == 14 then
                        ID_totals = ID_totals + 1
                    end
                end
            end
			
			if ID_totals <= 21 and ID_totals ~= 0 and context.before then
                card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_gain
                return {
                    message = 'Upgraded!',
                    colour = G.C.CHIPS,
                    card = card,
                    ID_totals = 0
                }
            else
                return {ID_totals = 0}
            end
        end
    end
}

SMODS.Joker{
    key = '9plus10', --joker key
    loc_txt = { -- local text
        name = '9+10',
        text = {
            'Gains {X:mult,C:white}X0.5{} Mult per hand played if',
            ' the sum of all ranks played (scored and unscored)',
            'are {C:attention}EXACTLY{} 21. Mult is {C:red}reset{}',
            'if ranks are {C:attention}over{} 21',
            '{C:inactive}(Currently: {}{X:mult,C:white}X#1#{}{C:inactive}){}',
        },
    },
    config = { extra = { xmult = 1, scale = 0.5 }},
    atlas = 'Jokers', --atlas' key
    rarity = 3, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 8, --cost
    unlocked = true, --whether it is unlocked or not: if true,
    discovered = true, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = { x = 1, y = 0 }, --position in atlas, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult, card.ability.extra.scale }}
    end,
    
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult,
                ---message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.xmult }}
            }
        end

        if context.before and not context.blueprint then
			local ID_totals, temp_ID, num_aces = 0, 0, 0
            for i = 1, #G.play.cards do
                if G.play.cards[i].ability.effect ~= 'Stone Card' then 
                    temp_ID = G.play.cards[i]:get_id()
                    if temp_ID <= 10 and temp_ID >= 2 then
                        ID_totals = ID_totals + temp_ID
					elseif temp_ID == 11 then
						if (G.play.cards[i]:is_suit('Clubs') or G.play.cards[i]:is_suit('Spades') ) and next(SMODS.find_card('j_blckjkd_blackknight')) then
							ID_totals = ID_totals + 21
						elseif (G.play.cards[i]:is_suit('Hearts') or G.play.cards[i]:is_suit('Diamonds')) and next(SMODS.find_card('j_blckjkd_redknight')) then
							ID_totals = ID_totals + 21
						else
							ID_totals = ID_totals + 10
						end
					elseif temp_ID >11 and temp_ID < 14 then
						ID_totals = ID_totals + 10
                    elseif temp_ID == 14 then
						num_aces = num_aces + 1
                    end
                end
            end
			
			if ID_totals == 10 and num_aces == 1 then
				ID_totals = ID_totals + 11
			elseif ID_totals == 10 and num_aces > 1 then
				ID_totals = ID_totals + num_aces
			elseif ID_totals < 10 and num_aces == 1 then
				ID_totals = ID_totals + 11
			elseif ID_totals < 10 and num_aces > 1 then
				if (21 - ID_totals) >= 12 then
					ID_totals = ID_totals + 11 + (num_aces-1)
				else
					ID_totals = ID_totals + num_aces
				end
			elseif ID_totals > 10 and num_aces > 1 then
				ID_totals = ID_totals + num_aces
			elseif ID_totals > 10 and num_aces == 1 then
				ID_totals = ID_totals + 1
			end	
				
			if ID_totals == 21 then
                card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.scale
                return {
                    message = 'Blackjack!',
                    colour = G.C.MULT,
                    card = card,
                    ID_totals = 0
                }
			elseif ID_totals > 21 then
				--[[G.E_MANAGER:add_event(Event({
					func = function()
					card:start_dissolve({G.C.ORANGE})
					return true 
					end 
				})) ]]--
				card.ability.extra.xmult = 1
				return
				{
                    message = 'Reset!',
                    colour = G.C.MULT,
                    card = card,
                    ID_totals = 0
                }
			else
                return {ID_totals = 0}
			end
        end
    end
}

SMODS.Joker {
	key = 'blackknight',
	loc_txt = {
		name = 'Black Knight',
		text = {
			"{C:attention}Jacks{} of {C:blue}Clubs{} or {C:spades}Spades{}",
			"are considered a {C:Spades}Blackjack{} hand, and ",
			"give +{C:chips}21{} total Chips when scored"
		}
	},
	config = { extra = { chips = 11} },
	rarity = 2,
	atlas = 'Jokers',
	pos = { x = 2, y = 0 },
	cost = 5,
	discovered = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chips } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			-- :get_id tests for the rank of the card. Other than 2-10, Jack is 11, Queen is 12, King is 13, and Ace is 14.
			if context.other_card.base.value == 'Jack' and ( context.other_card:is_suit('Spades') or context.other_card:is_suit('Clubs') ) then
				-- Specifically returning to context.other_card is fine with multiple values in a single return value, chips/mult are different from chip_mod and mult_mod, and automatically come with a message which plays in order of return.
				return {
					chips = card.ability.extra.chips,
					card = context.other_card
				}
			end
		end
	end
}

SMODS.Joker{
    key = 'red_joker', --joker key
    loc_txt = { -- local text
        name = 'Red Joker',
        text = {
            'This Joker gains {C:mult}+2.1{} Mult',
            'if the sum of all ranks {C:attention}scored{}',
            'are {C:attention}21{} or under',
            '{C:inactive}(Currently{} {C:mult}+#1#{} {C:inactive}){}',
        },
    },
    config = { extra = { mult = 0, mult_gain = 2.1 }},
    atlas = 'Jokers', --atlas' key
    rarity = 2, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 6, --cost
    unlocked = true, --whether it is unlocked or not: if true,
    discovered = true, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = true, --can it be eternal
    perishable_compat = true, --can it be perishable
    pos = { x = 3, y = 0 }, --position in atlas, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.mult_gain }}
    end,
    
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                mult_mod = card.ability.extra.mult,
                message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult }}
            }
        end

        if context.before and not context.blueprint then
			local ID_totals, temp_ID = 0, 0
            for i = 1, #G.play.cards do
                if G.play.cards[i].ability.effect ~= 'Stone Card' then 
                    temp_ID = G.play.cards[i]:get_id()
                    if temp_ID <= 10 and temp_ID >= 2 then
                        ID_totals = ID_totals + temp_ID
					elseif temp_ID == 11 then
						if ( G.play.cards[i]:is_suit('Clubs') or G.play.cards[i]:is_suit('Spades') ) and next(SMODS.find_card('j_blckjkd_blackknight')) then
							ID_totals = ID_totals + 21
						elseif ( G.play.cards[i]:is_suit('Hearts') or G.play.cards[i]:is_suit('Diamonds') ) and next(SMODS.find_card('j_blckjkd_redknight')) then
							ID_totals = ID_totals + 21
						else
							ID_totals = ID_totals + 10
						end
                    elseif temp_ID == 14 then
                        ID_totals = ID_totals + 1
                    end
                end
            end
			
			if ID_totals <= 21 and ID_totals ~= 0 and context.before then
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
                return {
                    message = 'Upgraded!',
                    colour = G.C.MULT,
                    card = card,
                    ID_totals = 0
                }
            else
                return {ID_totals = 0}
            end
        end
    end
}

SMODS.Joker {
	key = 'redknight',
	loc_txt = {
		name = 'Red Knight',
		text = {
			"{C:attention}Jacks{} of {C:hearts}Hearts{} or {C:diamonds}Diamonds{}",
			"are considered a {C:Spades}Blackjack{} hand, and ",
			"give +{C:mult}21{} Mult when scored"
		}
	},
	config = { extra = { mult = 21} },
	rarity = 2,
	atlas = 'Jokers',
	pos = { x = 4, y = 0 },
	cost = 6,
	discovered = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			-- :get_id tests for the rank of the card. Other than 2-10, Jack is 11, Queen is 12, King is 13, and Ace is 14.
			if context.other_card.base.value == 'Jack' and (context.other_card:is_suit('Hearts') or context.other_card:is_suit('Diamonds') ) then
				-- Specifically returning to context.other_card is fine with multiple values in a single return value, chips/mult are different from chip_mod and mult_mod, and automatically come with a message which plays in order of return.
				return {
					mult = card.ability.extra.mult,
					card = context.other_card
				}
			end
		end
	end
}
