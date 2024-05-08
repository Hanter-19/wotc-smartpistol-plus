//---------------------------------------------------------------------------------------
//  FILE:   XComDownloadableContentInfo_SmartPistolPlus.uc                                    
//           
//	Use the X2DownloadableContentInfo class to specify unique mod behavior when the 
//  player creates a new campaign or loads a saved game.
//  
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2DownloadableContentInfo_SmartPistolPlus extends X2DownloadableContentInfo config(SmartPistolPlus);

var config bool bLOG;

// Highlander hook to modify the array returned by XComGameState_Unit:GetEarnedSoldierAbilities
// We will use this to add CI infiltration bonuses to units wielding a smartpistol
static function ModifyEarnedSoldierAbilities(out array<SoldierClassAbilityType> EarnedAbilities, XComGameState_Unit UnitState)
{
	local SoldierClassAbilityType	NewAbility;

	if (class'SmartPistolPlus_Helper'.static.HasSmartPistolEquipped(UnitState) && class'SmartPistolPlus_Helper'.static.IsDLCLoaded('CovertInfiltration'))
	{
		NewAbility = GetCovertInfiltrationBonusAbility(UnitState);
		EarnedAbilities.AddItem(NewAbility);
	}
}

static function SoldierClassAbilityType GetCovertInfiltrationBonusAbility(XComGameState_Unit UnitState)
{
	local name						HackSkillTierName;
	local SoldierClassAbilityType	NewAbility;

	HackSkillTierName = class'X2Ability_SmartPistolInfiltration'.static.GetHackSkillTierName(UnitState);

	NewAbility.AbilityName = HackSkillTierName;

	`LOG(GetFuncName() @ "Adding" @ HackSkillTierName @ "to" @ UnitState.GetFirstName() @ UnitState.GetNickName() @ UnitState.GetLastName(), default.bLOG, 'SmartPistolPlus');
	
	return NewAbility;
}