
local utils = require(GetScriptDirectory() .. "/util")
local dt = require( GetScriptDirectory().."/decision_tree" )
--local sm = require( GetScriptDirectory().."/fsm" )
--require( GetScriptDirectory().."/locations" )
--require( GetScriptDirectory().."/ability_item_usage_viper" );

local curr_lvl = 0
local prevTime = 0

local action = utils.deepcopy(dt)
--local state = utils.deepcopy(sm)

local SKILL_Q = "viper_poison_attack";
local SKILL_W = "viper_nethertoxin";
local SKILL_E = "viper_corrosive_skin";
local SKILL_R = "viper_viper_strike"; 

-- FIXME: includes "" at talent levels for future easy adds
-- NOTE: "" will need to stay for levels where we can't level anything (e.g. 17)
local BotAbilityPriority = {
	SKILL_Q,    SKILL_W,    SKILL_W,    SKILL_E,    SKILL_W,
    SKILL_R,    SKILL_W,    SKILL_Q,    SKILL_Q,    "-1",
    SKILL_Q,    SKILL_R,    SKILL_E,    SKILL_E,    "-1",
    SKILL_E,    "-1",       SKILL_R,    "-1",       "-1",
    "-1",       "-1",       "-1",       "-1",       "-1"
};

function ThinkLvlupAbility(bot)

	local sNextAbility = BotAbilityPriority[1];
	
	if sNextAbility ~= "-1" then
		bot:Action_LevelAbility( sNextAbility );
	end
	
	table.remove( BotAbilityPriority, 1 );
end

--local prevState = "NONE";
local viperBot = nil;

function createViperBot()
	return setmetatable( {}, { __index = dt } )
end

function Think()
	if ( not viperBot ) then viperBot = createViperBot() end;
	
    local npcBot = GetBot();
	if ( not npcBot ) then return; end
	
	local checkLevel, newTime = utils.TimePassed(prevTime, 1.0);
	if checkLevel then
		local cLvl = utils.GetHeroLevel( npcBot );
		if ( cLvl > curr_lvl ) then
			ThinkLvlupAbility(npcBot);
			curr_lvl = curr_lvl + 1;
		end
		prevTime = newTime;
	end
	
	--action:Think(npcBot);
	viperBot:Think(npcBot);
	
	--[[
	if ( state[state.State] == nil ) then
		print (utils.tostring(state));
	end
	
	local newState = state[state.State](npcBot);
	if ( newState ~= nil ) then
		state.State = newState;
	else
		print( "INVALID STATE from " .. state.State );
	end

    if(prevState ~= newState) then
        print("STATE: " .. prevState .. " --> " .. newState);
        prevState = newState;
    end
	--]]
end