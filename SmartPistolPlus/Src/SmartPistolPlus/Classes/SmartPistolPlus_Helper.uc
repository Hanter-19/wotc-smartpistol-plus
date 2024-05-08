//----------------------------------------------------------------------------------------------------------------------------------
//  AUTHOR:		Hanter
//  PURPOSE:	A couple of helper function
//----------------------------------------------------------------------------------------------------------------------------------
class SmartPistolPlus_Helper extends Object config(SmartPistolPlus);

var config bool bCILoaded;

var localized string strNegativeSign;
var localized string strPositiveSign;

static function bool IsDLCLoaded (coerce name DLCName)
{
	local XComOnlineEventMgr OnlineEventMgr;
	local int index;

	OnlineEventMgr = `ONLINEEVENTMGR;

	if (DLCName == 'CovertInfiltration' && default.bCILoaded)
	{
		`LOG(GetFuncName() @ "Detected Covert Infiltration in cache", class'X2DownloadableContentInfo_SmartPistolPlus'.default.bLOG, 'SmartPistolPlus');
		return true;
	}

	for (index = 0; index < OnlineEventMgr.GetNumDLC(); ++index)
	{
		if (DLCName == OnlineEventMgr.GetDLCNames(index))
		{
			if (DLCName == 'CovertInfiltration')
			{
				// Cache CI status
				`LOG(GetFuncName() @ "Detected Covert Infiltration for the first time", class'X2DownloadableContentInfo_SmartPistolPlus'.default.bLOG, 'SmartPistolPlus');
				default.bCILoaded = true;
			}

			return true;
		}
	}

	return false;
}

static function bool HasSmartPistolEquipped(XComGameState_Unit UnitState, optional XComGameState CheckGameState)
{
	local array<XComGameState_Item>	Items;
	local XComGameState_Item		ItemState;
	local X2WeaponTemplate			WeaponTemplate;

	Items = UnitState.GetAllInventoryItems(CheckGameState, true); // bExcludePCS = true

	foreach Items(ItemState)
	{
		WeaponTemplate = X2WeaponTemplate(ItemState.GetMyTemplate());

		if (WeaponTemplate != none && WeaponTemplate.WeaponCat == 'smartpistol')
		{
			return true;
		}
	}

	return false;
}

static function string GetSignage(int n)
{
	if (n < 0)
	{
		return default.strNegativeSign;
	}
	else
	{
		return default.strPositiveSign;
	}
}