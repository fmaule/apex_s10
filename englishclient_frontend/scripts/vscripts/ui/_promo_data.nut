global function InitPromoData
global function UpdatePromoData
global function IsPromoDataProtocolValid
global function GetPromoDataVersion
global function GetPromoDataLayout
global function GetPromoImage

global function GetPromoRpakName
global function GetMiniPromoRpakName
global function OpenPromoLink

global function UICodeCallback_MainMenuPromosUpdated

#if DEV
global function DEV_PrintPromoData
global function DEV_PrintUMPromoData
#endif       

                                                                              
                                                            
const int PROMO_PROTOCOL = 2

struct
{
	MainMenuPromos&      promoData
	table<string, asset> imageMap
} file

string function GetPromoRpakName()
{
	return file.promoData.promoRpak
}

string function GetMiniPromoRpakName()
{
	return file.promoData.miniPromoRpak
}

void function InitPromoData()
{
	RequestMainMenuPromos()                                                                                   

	var dataTable = GetDataTable( $"datatable/promo_images.rpak" )
	for ( int i = 0; i < GetDataTableRowCount( dataTable ); i++ )
	{
		string name = GetDataTableString( dataTable, i, GetDataTableColumnByName( dataTable, "name" ) ).tolower()
		asset image = GetDataTableAsset( dataTable, i, GetDataTableColumnByName( dataTable, "image" ) )
		if ( name != "" )
			file.imageMap[name] <- image
	}
}


void function UpdatePromoData()
{
	#if DEV
		if ( GetConVarBool( "mainMenuPromos_scriptUpdateDisabled" ) )
			return
	#endif       
	file.promoData = GetMainMenuPromos()
	PromoDialog_InitPages()
}


void function UICodeCallback_MainMenuPromosUpdated()
{
	printt( "UICodeCallback_MainMenuPromosUpdated" )

	UpdatePromoData()
}


bool function IsPromoDataProtocolValid()
{
	return file.promoData.prot == PROMO_PROTOCOL
}


int function GetPromoDataVersion()
{
	return file.promoData.version
}


string function GetPromoDataLayout()
{
	return file.promoData.layout
}


asset function GetPromoImage( string identifier )
{
	identifier = identifier.tolower()

	asset image
	if ( identifier in file.imageMap )
		image = file.imageMap[identifier]
	else
		image = $"rui/promo/apex_title_blue"

	return image
}

void function OpenPromoLink( string linkType, string link )
{
	                                                                      
	if ( linkType == "battlepass" )
	{
		EmitUISound( "UI_Menu_Accept" )
		JumpToSeasonTab( "PassPanel" )
	}
	else if ( linkType == "storecharacter" )
	{
		EmitUISound( "UI_Menu_Accept" )
		if ( IsValidItemFlavorHumanReadableRef( link ) )
		{
			ItemFlavor character = GetItemFlavorByHumanReadableRef( link )
			if ( GRX_IsItemOwnedByPlayer( character ) )
				JumpToStoreLegendsTab()
			else
				JumpToStoreCharacter( character )
		}
		else
		{
			JumpToStoreLegendsTab()
		}
	}
	else if ( linkType == "storeskin" )
	{
		EmitUISound( "UI_Menu_Accept" )
		if ( IsValidItemFlavorHumanReadableRef( link ) )
		{
			ItemFlavor skin = GetItemFlavorByHumanReadableRef( link )
			if ( GRX_IsItemOwnedByPlayer( skin ) )
				JumpToStoreTab()
			else
				JumpToStoreSkin( skin )
		}
		else
		{
			JumpToStoreTab()
		}
	}
	else if ( linkType == "themedstoreskin" )
	{
		EmitUISound( "UI_Menu_Accept" )
		ItemFlavor ornull activeThemedShopEvent = GetActiveThemedShopEvent( GetUnixTimestamp() )
		if ( activeThemedShopEvent != null )
			JumpToSeasonTab( "ThemedShopPanel" )
		else
			JumpToStoreTab()
	}
	else if ( linkType == "collectionevent" )
	{
		EmitUISound( "UI_Menu_Accept" )
		ItemFlavor ornull activeCollectionEvent = GetActiveCollectionEvent( GetUnixTimestamp() )
		if ( activeCollectionEvent != null )
			JumpToSeasonTab( "CollectionEventPanel" )
		else
			JumpToStoreTab()
	}
	else if ( linkType == "url" )
	{
		EmitUISound( "UI_Menu_Accept" )
		LaunchExternalWebBrowser( link, WEBBROWSER_FLAG_NONE )
	}
	else if ( linkType == "product" )
	{
		EmitUISound( "UI_Menu_Accept" )
		if ( link != "" )
			ViewEntitlementInStoreOverlay( link )
		else
			JumpToStoreEditions()
	}
	else if ( linkType == "storeoffer" )
	{
		EmitUISound( "UI_Menu_Accept" )
		JumpToStoreOffer( link )
	}
	else if ( linkType == "whatsnew" )
	{
		EmitUISound( "UI_Menu_Accept" )
		JumpToSeasonTab( "WhatsNewPanel" )
	}
}

#if DEV
void function DEV_PrintPromoData()
{
	printt( "protocol:      ", file.promoData.prot )
	printt( "version:       ", file.promoData.version )
	printt( "promoRpak:     ", file.promoData.promoRpak )
	printt( "miniPromoRpak: ", file.promoData.miniPromoRpak )
	printt( "layout:        ", file.promoData.layout )
}


void function DEV_PrintUMPromoData()
{
	UMData um = EADP_UM_GetPromoData()
	printt( "triggerId:", um.triggerId )
	printt( "triggerName:", um.triggerName )
	foreach( int i, UMAction action in um.actions )
	{
		printt( i, "action name:", action.name )
		printt( i, "action trackingId:", action.trackingId )
		foreach( int j, UMItem item in action.items )
		{
			printt( j, "item type:", item.type, "- name:", item.name )
			printt( j, "item value:", item.value )
			foreach( int k, UMAttribute attr in item.attributes )
			{
				printt( k, "attr key:", attr.key )
				printt( k, "attr value:", attr.value )
			}
		}
	}
}
#endif       