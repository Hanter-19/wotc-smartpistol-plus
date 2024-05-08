[h1]SmartPistol Plus[/h1]
A collection of QoL tweaks and new inter-mod behavior for [url=https://steamcommunity.com/sharedfiles/filedetails/?id=2018729237]Alterd-Rushnano's excellent SmartPistol mod[/url]

[h1]Features[/h1]
[list]
	[*] Tweaks
		[list]
			[*] TODO: Figure out why the CV tier is firing 4 shots instead of the advertised 3
			[*] TODO: (not sure how) Some way of visualizing the remaining ammo in tactical UI when the smartpistol is not the primary weapon
			[*] TODO: (not sure how) Add flyover text when reload succeeds or fails
		[/list]
	[*] Localization
		[list]
			[*] Fix the missing localization error in all smartpistol items: it was missing localization for an innate ability that grants +100 aim to and enables critical hits on reaction shots. I have localized it as "Guided Reactive Fire".
			[*] TODO: Tidy up the original mod's English localization
			[*] TODO: (not sure if possible; current attempt not working) Add localization for the target's Hacking Defense in aim breakdown in Tactical HUD
		[/list]
	[*] [url=https://steamcommunity.com/sharedfiles/filedetails/?id=2133399183]True Primary Secondaries[/url]
		Can be equipped in primary weapon slot using True Primary Secondaries (class restrictions still apply)
	[*] [url=https://steamcommunity.com/workshop/filedetails/?id=1280477867]RPGO[/url]
		All non-hero soldiers (UniversalSoldier class) can equip the Smartpistol in both the primary and secondary weapon slots.
		TODO: RPGO item icon Texture UILibrary_RPGO.loadout_icon_smartpistol
	[*] [url=https://steamcommunity.com/sharedfiles/filedetails/?id=2567230730]Covert Infiltration[/url]
		The smartpistol does not grant any infiltration bonus on its own (configurable). Instead, it grants scaling infiltration bonuses according to their hack skill (configurable)
		TODO: Custom icon for the CI Smart Infiltration ability?
	[*] [url=https://steamcommunity.com/sharedfiles/filedetails/?id=1705464884]Dedicated Pistol Slot[/url]
		RPGO soldiers and the original classes who can use smartpistols in the original smartpistol mod can equip them in the Dedicated Pistol Slot.
		Note that LWotC has its own impelementation of the dedicated pistol slot, and I've not configured it for that. Instead I've configured it for the [url=https://steamcommunity.com/sharedfiles/filedetails/?id=3234301247]backported classes[/url].
	[*] TODO: Unique attachments for the smartpistol (smartpistol will not be able to use vanilla attachments)
		TODO: Attachment projects for proving ground and alternatively the [url=https://steamcommunity.com/sharedfiles/filedetails/?id=2810861938]Combined Workshop and Laboratory[/url]
	[*] TODO: Tesla Loot Mod integration?
	[*]	NOT HANDLED BY THIS MOD - Missing smartpistol textures
		At least in non-LWotC modlists, you might need [url=https://steamcommunity.com/sharedfiles/filedetails/?id=1750855914]TLP Plasma Weapons With Visual Attachments REDUX[/url]. Appears to be an unintentional/accidental dependency by Alterd-Rushnano.		
[/list]

[h1]Credits and Appreciation[/h1]
[list]
	[*] Zelfana, LordAbizi and h4ilst0rm for helping me figure out how to build the mod against CI and providing many pointers on how to avoid pitfalls in XCOM code https://discord.com/channels/437999291928412171/646925416384299009/1237457996313792553
	[*] Mitzruti for giving pointers on how to get the hack stats https://discord.com/channels/165245941664710656/402042994255069184/1237481939598966885
	[*] Zelfana and SwfDelicious for helping me figure out a workaround to add CI structs to one of its configs without making CI a hard requirement https://discord.com/channels/165245941664710656/1120847951514849412/1237841684457459802
	[*] Stukov for providing perspectives on balance, and whose configs helped me figure out how to add support for True Primary Secondaries