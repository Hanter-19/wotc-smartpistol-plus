//----------------------------------------------------------------------------------------------------------------------------------
//  AUTHOR:		Hanter
//  PURPOSE:	For any data structures this mod creates
//----------------------------------------------------------------------------------------------------------------------------------
class SmartPistolPlus_DataStructures extends Object;

// Used to dynamically create hack skill tiers to correspond with Covert Infiltration modifiers (infiltration and risk reduction)
struct HackToInfiltrationModifier
{
	var name	DataName;
	var int		MinHack;
	var int		MaxHack;
	var int		InfilHoursAdded;
	var float	RiskReductionPercent;

	structdefaultproperties
	{
		MinHack = -9999;
		MaxHack = 9999;
		InfilHoursAdded = 0;
		RiskReductionPercent = 0;
	}
};