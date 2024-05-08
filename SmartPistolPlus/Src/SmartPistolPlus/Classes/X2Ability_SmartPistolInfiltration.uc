//----------------------------------------------------------------------------------------------------------------------------------
//  AUTHOR:		Hanter
//  PURPOSE:	Create dummy Ability Templates and Infiltration Templates for Covert Infiltration
//				These will be used to enable Infiltration/Deterrence stats based on a unit's hack skill when wielding a smartpistol
//----------------------------------------------------------------------------------------------------------------------------------
class X2Ability_SmartPistolInfiltration extends X2Ability config(Infiltration);

var config array<HackToInfiltrationModifier>	HackSkillTiers;
var config string								SMARTPISTOL_INFIL_ICON;

var const name									SMARTPISTOL_INFILTRATION_ABILITY_NAME;

var localized string strTemplateLocFriendlyName;
var localized string strTemplateLocLongDescription;
var localized string strTemplateInfiltrationHours;
var localized string strTemplateRiskReduction;
var localized string strTemplateJoinInfiltrationHours;
var localized string strTemplateJoinRiskReduction;

// Dynamically create dummy abilities that will interact with CI mechanics to grant configurable infiltration bonuses based on the smartpistol wielder's hack skill
static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate>			Templates;
	
	// Only if Covert Infiltration mod is loaded
	if (class'SmartPistolPlus_Helper'.static.IsDLCLoaded('CovertInfiltration'))
	{
		Templates = CreateAbilityTemplates();
	}

	return Templates;
}

static function array<X2DataTemplate> CreateAbilityTemplates()
{
	local array<X2DataTemplate>			Templates;
	local HackToInfiltrationModifier	Modifier;
	local name							TierName;
	local int							Index;
	local int							LastIndex;

	local X2AbilityTemplate				AbilityTemplate;

	local string						AbilityLongDescription;

	foreach default.HackSkillTiers(Modifier, Index)
	{
		TierName = name(default.SMARTPISTOL_INFILTRATION_ABILITY_NAME $ Index);

		default.HackSkillTiers[Index].DataName = TierName; // set the name of the HackToInfiltrationModifier so we can use it later to match it with the X2InfiltrationModTemplate

		`LOG(GetFuncName() @ "Creating X2AbilityTemplate" @ TierName,class'X2DownloadableContentInfo_SmartPistolPlus'.default.bLOG, 'SmartPistolPlus');

		`CREATE_X2ABILITY_TEMPLATE(AbilityTemplate, TierName);
		AbilityTemplate.IconImage = default.SMARTPISTOL_INFIL_ICON;
		AbilityTemplate.bDisplayInUITooltip = false;
		AbilityTemplate.bDisplayInUITacticalText = false;

		AbilityTemplate.AbilitySourceName = 'eAbilitySource_Item';
		AbilityTemplate.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
		AbilityTemplate.Hostility = eHostility_Neutral;
		AbilityTemplate.bDisplayInUITacticalText = false;
	
		AbilityTemplate.AbilityToHitCalc = default.DeadEye;
		AbilityTemplate.AbilityTargetStyle = default.SelfTarget;
		AbilityTemplate.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

		AbilityTemplate.BuildNewGameStateFn = TypicalAbility_BuildGameState;

		AbilityLongDescription = default.strTemplateLocLongDescription;
		AbilityLongDescription $= default.strTemplateJoinInfiltrationHours @ class'SmartPistolPlus_Helper'.static.GetSignage(Modifier.InfilHoursAdded) $ Modifier.InfilHoursAdded @ default.strTemplateInfiltrationHours;
		AbilityLongDescription $= default.strTemplateJoinRiskReduction @ class'SmartPistolPlus_Helper'.static.GetSignage(Modifier.RiskReductionPercent) $ Modifier.RiskReductionPercent @ default.strTemplateRiskReduction;

		AbilityTemplate.LocFriendlyName = default.strTemplateLocFriendlyName;
		AbilityTemplate.LocLongDescription = AbilityLongDescription;

		Templates.AddItem(AbilityTemplate);

		// Now add it to InfiltrationModifiers
		// Note that for this to work, this class has to run before X2InfiltrationMod.uc (from CI)
		// because we are modifying an array in the config XComInfiltration.ini
		// I'm not entirely sure what governs the order, but doing this here seems to work based on my local testing
		// 
		// According to the Wiki: https://www.reddit.com/r/xcom2mods/wiki/wotc_modding/config_files/#wiki_how_to_override_other_mod.27s_config
		// Using OnPreCreateTemplates seems to be the most reliable way of doing this (requires Highlander)
				
		// Since declaring any local instances of the InfilModifier struct will make CI a hard requirement,
		// we use the following workaroudn where we add a default item to the array and then modify the added item to our needs
		class'X2InfiltrationMod'.default.InfilModifiers.Add(1);
		
		LastIndex = class'X2InfiltrationMod'.default.InfilModifiers.Length - 1;
		
		class'X2InfiltrationMod'.default.InfilModifiers[LastIndex].DataName = TierName;
		class'X2InfiltrationMod'.default.InfilModifiers[LastIndex].InfilHoursAdded = Modifier.InfilHoursAdded;
		class'X2InfiltrationMod'.default.InfilModifiers[LastIndex].RiskReductionPercent = Modifier.RiskReductionPercent;
		class'X2InfiltrationMod'.default.InfilModifiers[LastIndex].ModifyType = eIMT_Ability;

	}

	return Templates;
}

// Get the appropriate infiltration ability based on the UnitState's hack stats
static function X2AbilityTemplate GetHackSkillTierAbility(XComGameState_Unit UnitState)
{
	local name						HackSkillTierName;
	local X2AbilityTemplateManager	AbMgr;
	local X2AbilityTemplate			Template;

	HackSkillTierName = GetHackSkillTierName(UnitState);

	AbMgr = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	Template = AbMgr.FindAbilityTemplate(HackSkillTierName);

	if(Template != none)
	{
		return Template;
	}
	else
	{
		`LOG(GetFuncName() @ "ERROR: Unable to find template:" @ HackSkillTierName,, 'SmartPistolPlus');
	}
}

// Get the name of the appropriate infiltration ability based on the UnitState's hack stats
static function name GetHackSkillTierName(XComGameState_Unit UnitState, optional XComGameState CheckGameState)
{
	local HackToInfiltrationModifier	Modifier;
	local int							HackScore;
	local bool							IncludeHackBonus;
	local X2GremlinTemplate				GremlinTemplate;

	local array<XComGameState_Item>	Items;
	local XComGameState_Item		ItemState;

	HackScore = UnitState.GetCurrentStat(eStat_Hacking);

	// Add Skullmining bonus if applicable
	IncludeHackBonus = `XCOMHQ.IsTechResearched('Skullmining') || class'X2TacticalGameRulesetDataStructures'.static.TacticalOnlyGameMode();
	if(UnitState.HasItemOfTemplateType('SKULLJACK') && IncludeHackBonus)
	{
		HackScore += class'X2AbilityToHitCalc_Hacking'.default.SKULLJACK_HACKING_BONUS;
	}

	// Add Gremlin bonus if applicable
	Items = UnitState.GetAllInventoryItems(CheckGameState, true); // bExcludePCS = true
	foreach Items(ItemState)
	{
		GremlinTemplate = X2GremlinTemplate(ItemState.GetMyTemplate());

		if (GremlinTemplate != none)
		{
			HackScore += GremlinTemplate.HackingAttemptBonus;
		}
	}

	foreach default.HackSkillTiers(Modifier)
	{
		`LOG(GetFuncName() @ "Checking HackScore" @ HackScore @ "against" @ Modifier.DataName @ "| MinHack:" @ Modifier.MinHack @ "| MaxHack:" @ Modifier.MaxHack @ "| InfilHoursAdded:" @ Modifier.InfilHoursAdded @ "| RiskReductionPercent:" @ Modifier.RiskReductionPercent, class'X2DownloadableContentInfo_SmartPistolPlus'.default.bLOG, 'SmartPistolPlus');
		
		if (HackScore >= Modifier.MinHack && HackScore <= Modifier.MaxHack)
		{
			return Modifier.DataName;
		}
	}

	return '';
}

defaultproperties
{
	SMARTPISTOL_INFILTRATION_ABILITY_NAME = "SmartPistolHackInfilTier"
}