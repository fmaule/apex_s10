#if SERVER
                                       
#endif


#if CLIENT
global function ClOlympusStoryEvents_Init
#endif

              
global function S10E05_GetPhase


#if CLIENT
global function ServerCallback_S10E05_UpdateLaptopScreen
global function ServerCallback_S10E05_UpdateMapTableState
#if DEV
global function S10E05_UpdateLaptopTopPos
global function S10E05_UpdateHoloMapTopPos
#endif
#endif

const string S10E05_AMBIENT_TRIGGER_EXT = "amb_diag_escape_pod_ext"
const string S10E05_AMBIENT_TRIGGER_INT = "amb_diag_escape_pod_int"
const string S10E05_MAPTABLE_TARGET_INFO = "s10e05_maptable_node"
const string S10E05_MAPTABLE_SCRIPT_NAME = "s10e05_maptable"
const string S10E05_LAPTOP_INTERACT_TARGET_INFO = "s10e05_laptop_interact_node"
const string S10E05_LAPTOP_SCREEN_TARGET_INFO = "s10e05_laptopscreen_node"                
const asset S10E05_INTERACT_PROP_MDL = $"mdl/props/global_access_panel_button/global_access_panel_button_console.rmdl"

const string S10E05_CC_RIGHT_SCREEN_TARGET_INFO = "s10e05_cc_right_node"
const string S10E05_CC_CENTER_SCREEN_TARGET_INFO = "s10e05_cc_center_node"
const string S10E05_CC_LEFT_SCREEN_TARGET_INFO ="s10e05_cc_left_node"

const string S10E05_CC_RIGHT_SCREEN_SCRIPT_NAME = "s10e05_cc_right"
const string S10E05_CC_LEFT_SCREEN_SCRIPT_NAME = "s10e05_cc_left"
const string S10E05_CC_CENTER_SCREEN_SCRIPT_NAME = "s10e05_cc_center"

const string S10E05_LAPTOP_INTERACT_SCRIPT_NAME = "s10e05_laptop_interact"
const float S10E05_LAPTOP_INTERACT_COOLDOWN = 0.5
const float S10E05_LAPTOP_INTERACT_IDLE_TIMEOUT = 60

const asset S10E05_CC_ON_SCREEN_MDL = $"mdl/eden/beacon_small_screen_01_on_tropics.rmdl"

const asset S10E05_HOLOMAP_BASE_FX = $"P_oly_ship_holo_base_ts"
const vector S10E05_HOLOMAP_BASE_FX_ORIGIN = < 26598.9, 11607.8, -3392.3 >
const vector S10E05_HOLOMAP_BASE_FX_ANGLES = < 0, 149.5438, 0 >

const asset S10E05_HOLOMAP_IDLE_FX = $"P_oly_ship_holo_ts_1"
const asset S10E05_HOLOMAP_CONTACTING_FX = $"P_oly_ship_holo_ts_2"
const asset S10E05_HOLOMAP_FOUND_FX = $"P_oly_ship_holo_ts_3"
const vector S10E05_HOLOMAP_FX_ORIGIN = < 26597.8, 11606.6, -3341.89 >
const vector S10E05_HOLOMAP_FX_ANGLES = < -50.5159, 21.1985, -1.5668 >

const string S10E05_REWARD_TRIGGER_SCRIPT_NAME = "s10e05_reward_trigger"

const int S10E05_DIALOGUE_FLAGS =
		eDialogueFlags.BLOCK_LOWER_PRIORITY_QUEUE_ITEMS |
		eDialogueFlags.MUTE_PLAYER_PING_DIALOGUE_FOR_DURATION |
		eDialogueFlags.MUTE_PLAYER_PING_CHIMES_FOR_DURATION |
		eDialogueFlags.BLOCK_ANNOUNCER

global enum eS10E05Phase
{
	DISABLED,
	PHASE_1,
	PHASE_2,
	PHASE_3,
	PHASE_4
}

struct ManifestDataStruct
{
	string name = ""
	string title = ""
	string status = ""
	int type = 0
}
      

struct
{
              
	#if SERVER
		                       
		                     
		                      
		                         
		                
		                    

		                                             
	#endif

	#if CLIENT
		var laptopTopo
		var holoMapTopo
		var holoMapRui
		var laptopRui
	#endif

	int laptopIndex = -1
	int mapTableState = 0
	array < ManifestDataStruct > manifestDataArray
      
} file


                                                                                                                                    
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    
  
                               
                            
                            
                            
                            
                            
                            
  
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    


#if SERVER
                                       
 
	                                              
               
		                                        
		                                          
		                                        
		                                        
		                                              
		                                         

		                                         
       
 
#endif


#if CLIENT
void function ClOlympusStoryEvents_Init()
{
	AddCallback_EntitiesDidLoad( EntitiesDidLoad )
               
	AddCreateCallback( "prop_script", S10E05_OnCCPropCreated )
       
}
#endif


#if SERVER || CLIENT
void function EntitiesDidLoad()
{
               
	if ( GetMapName() == "mp_rr_olympus_mu1" )
			S10E05_Init()
       
}
#endif                    



              
void function S10E05_Init()
{
	if ( IsPrivateMatch() || IsArenaMode() )
		return

	S10E05_ManifestDataInit()

	#if SERVER
		                             
		                                                                                                      
		                                           
		 
			                                                                                                                                                                          

			                                     
			 
				                                                                                                             
				                                   
				                                                                        
			 
			    
			 
				                                  
			 

			                                          
			                                                                          
			                                      
		 

		                                                                                                    
		                                          
		 
			                                                                                                                                                                       
			                                     
			 
				                                                                                                             
				                                  
				                                                                       
			 
			    
			 
				                                 
			 

			                                         
			                                                                        
			                                     
		 

		                                                                                                  
		                                         
		 
			                                                                                                                                                                    
			                                     
			 
				                                                                                                             
				                                 
				                                                                      
			 
			    
			 
				                                                           
			 

			                                        
			                                                                      
			                                    
		 

		                                    
		 
			                                                                                                   
		 

		                                    
		 
			                                                                                                   
		 

		                                    
		 
			                                                                                            
			                                       
			 
				                                                                                                                                                                                        
				                                                                  
				                                      
				                                 
				                                                                                                                    
				                                                              
				                            
				                                                                                   
			 

			                                                                                                                                                         
			                                                                                                                                                                
		 

		               
		                                                         
		                                                                  

		                                      
	#endif

	#if CLIENT
		S10E05_CreateLaptopRui()
	#endif

}

bool function S10E05_MapTableCanUse( entity player, entity ent, int useFlags )
{
	if ( file.mapTableState == 0 )
		return true

	return false
}

#if SERVER
                                             
 
	                                               
	 
		                                                                                                             
		                                            
	 

	                                                                                                         
	                                             
	 
		                                                                                                                                                                                  
		                                                                       
		                               
		                                                                                                                  
		                                                            
		                                                                                                       
		                          
		                                                                             
	 
 
#endif

void function S10E05_ManifestDataInit()
{
	var dataTable = GetDataTable( $"datatable/s10e05_manifest_data.rpak" )
	int numRows   = GetDataTableRowCount( dataTable )

	int titleColumn              = GetDataTableColumnByName( dataTable, "title" )
	int nameColumn               = GetDataTableColumnByName( dataTable, "name" )
	int statusColumn           		 = GetDataTableColumnByName( dataTable, "status" )
	int typeColumn                 = GetDataTableColumnByName( dataTable, "type" )

	for ( int i = 0; i < numRows; i++ )
	{
		ManifestDataStruct manifestData
		manifestData.title = GetDataTableString( dataTable, i, titleColumn )
		manifestData.name = GetDataTableString( dataTable, i, nameColumn )
		manifestData.status = GetDataTableString( dataTable, i, statusColumn )
		manifestData.type = GetDataTableInt( dataTable, i, typeColumn )
		file.manifestDataArray.append( manifestData )
	}
}

#if SERVER || CLIENT
bool function IsPlayerBangalore( entity player )
{
	ItemFlavor character = LoadoutSlot_GetItemFlavor( ToEHI( player ), Loadout_Character() )
	string characterRef  = ItemFlavor_GetHumanReadableRef( character ).tolower()

	if ( characterRef != "character_bangalore" )
		return false

	return true
}
#endif

#if SERVER
                                                       
 
	                                               
		      

	                                                                                                            

	                                                
		                                                                                                        

 
#endif

int function S10E05_GetPhase()
{
	if ( IsPrivateMatch() || IsArenaMode() )
		return eS10E05Phase.DISABLED

	int unixTimeNow = GetUnixTimestamp()
	if ( unixTimeNow >=  expect int( GetCurrentPlaylistVarTimestamp( "s10e05_phase4", UNIX_TIME_FALLBACK_2038 ) ) )
	{
		return eS10E05Phase.PHASE_4
	}
	else if ( unixTimeNow >=  expect int( GetCurrentPlaylistVarTimestamp( "s10e05_phase3", UNIX_TIME_FALLBACK_2038 ) ) )
	{
		return eS10E05Phase.PHASE_3
	}
	else if ( unixTimeNow >=  expect int( GetCurrentPlaylistVarTimestamp( "s10e05_phase2", UNIX_TIME_FALLBACK_2038 ) ) )
	{
		return eS10E05Phase.PHASE_2
	}
	else if ( unixTimeNow >=  expect int( GetCurrentPlaylistVarTimestamp( "s10e05_phase1", UNIX_TIME_FALLBACK_2038 ) ) )
	{
		return eS10E05Phase.PHASE_1
	}

	return eS10E05Phase.DISABLED
}

void function S10E05_OnMapTableUse( entity holoMap, entity playerUser, int useInputFlags )
{
	if ( !(useInputFlags & USE_INPUT_LONG) )
		return

	if ( file.mapTableState != 0 )
		return

	ExtendedUseSettings settings

	settings.duration = 3.0
	settings.useInputFlag = IN_USE_LONG
	settings.successSound = "S10E05_Holo_Access"
	settings.successFunc = S10E05_MapTableUseSuccess

	#if CLIENT
		settings.loopSound = "S10E05_Holo_StatusBar"
		settings.displayRuiFunc = DefaultExtendedUseRui
		settings.displayRui = $"ui/extended_use_hint.rpak"
		settings.icon = $"rui/hud/gametype_icons/survival/data_knife"
		settings.hint = "#S10E05_MAP_INTERACT_HOLD"
	#endif         

	#if SERVER
		                            
		                               
		                             
	#endif         

	thread ExtendedUse( holoMap, playerUser, settings )
}

void function S10E05_MapTableUseSuccess( entity holoMap, entity player, ExtendedUseSettings settings )
{
	#if SERVER
		                     
	#endif

	thread function() : ( holoMap, player )
	{
		OnThreadEnd(
			function() : ( holoMap )
			{

				file.mapTableState = 0

				#if SERVER
				                               
					                            

				                                                                                                                                                                
				                   

				                               
				                                
				#endif
			}
		)
		#if SERVER
			                           

			                               
				                            

			                                                                                                                                                                      
			                      
			                                                
			        

			                                                                                       
			                  

			                                                    

			                               
				                            

			                      
			                                                                                                                                                                 
			                                         

			      

			                                                     
			 
				                                                                  
			 

			                               
			                                

			       
		#endif

		#if CLIENT
			file.mapTableState = 1
			wait ( GetSoundDuration( "diag_mp_bangalore_bc_trtrec_01_3p_3p" ) + 4.0 )
			file.mapTableState = 2
			wait 30.0
		#endif
	}()
}

#if SERVER
                                                                        
 
	            
		                    
		 
			                    
			 
				                              
				 
					                                       
						                                         
						     
					                                         
						                
						     
					                                        
						                
						     
					        
						     
				 
			 

		 
	 

	                                            
 

                                                           
 
	                       
		      

	                             

	                                     
	                                    
	                 
	              
	 
		                      
		 
			              
			                              
			 
				                                   
			 
			    
			 
				                                    
			 
			                        
		 

		           
		                     
			             

		        
	 
 
#endif

#if SERVER
                                                    
 
	                                                                                           
	                               
	 
		                                                          
		                                   
		 
			                                                                                                       
			 
				                              
				                                                                                                                         
				                                                                                                                   
				                                                                                                                  

				                      
				                                                                 
				 
					                                                   
					                            
					                       
					                                            
					                                            
				 

				                                                                 
				 
					                                                     
					                            
					                       
					                                            
					                                            
				 

				                                                                 
				 
					                                                     
					                            
					                       
					                                            
					                                            
				 

				                                                      
			 
		 
	 
 
#endif


void function S10E05_OnLaptopUse( entity panel, entity playerUser, int useInputFlags )
{
	#if SERVER
		                   
		                                       
		                                                       
		 
			                                        
				                     
			    
				                    
		 

		                                      
		                                                    
		 
			                                                                                                           
		 

		                                                
		                                                                                                                                           
		 
			                                                        
			                
			 
				                                                                      
				              
			 
			                     
			 
				                                                                      
				              
			 
		 

		                                                        
	#endif
}


#if SERVER
                                                                            
 
	                                                                           
	 
		                                                              
			        

		                                                                                  
	 
 


                                                                                      
 
	                 
	                            
		                       
 

                                             
 
	                                                     
	                                                        

	                                        

	                     
	                                                    
	 
		                                                                                                           
	 
 
#endif

#if CLIENT
void function ServerCallback_S10E05_UpdateLaptopScreen( int laptopIndex, bool refreshScreen )
{
	file.laptopIndex = laptopIndex
	if ( refreshScreen )
		S10E05_RefreshLaptopScreen()
}

void function S10E05_RefreshLaptopScreen()
{
	if ( file.laptopIndex >= file.manifestDataArray.len() )
		return

	if ( file.laptopRui == null )
		return

	if ( file.laptopIndex == -1 )
	{
		RuiSetBool( file.laptopRui, "idle", true )
		return
	}

	ManifestDataStruct data = file.manifestDataArray[file.laptopIndex]
	RuiSetString( file.laptopRui, "titleField", data.title )
	RuiSetString( file.laptopRui, "nameField", data.name )
	RuiSetString( file.laptopRui, "statusField", data.status )
	RuiSetBool( file.laptopRui, "idle", false )
	RuiSetInt ( file.laptopRui, "type", data.type )
}
#endif

#if CLIENT
void function S10E05_OnCCPropCreated( entity ent )
{
	switch ( ent.GetScriptName() )
	{
		case S10E05_CC_RIGHT_SCREEN_SCRIPT_NAME:
			if ( S10E05_GetPhase() < eS10E05Phase.PHASE_2 )
			{
				int activationTime = expect int( GetCurrentPlaylistVarTimestamp( "s10e05_phase2", UNIX_TIME_FALLBACK_2038 ) )
				S10E05_CreateRuiForScreen ( ent, activationTime )
			}
			break
		case S10E05_CC_CENTER_SCREEN_SCRIPT_NAME:
			if ( S10E05_GetPhase() < eS10E05Phase.PHASE_3 )
			{
				int activationTime = expect int( GetCurrentPlaylistVarTimestamp( "s10e05_phase3", UNIX_TIME_FALLBACK_2038 ) )
				S10E05_CreateRuiForScreen ( ent , activationTime )
			}
			break
		case S10E05_CC_LEFT_SCREEN_SCRIPT_NAME:
			if ( S10E05_GetPhase() < eS10E05Phase.PHASE_4 )
			{
				int activationTime = expect int( GetCurrentPlaylistVarTimestamp( "s10e05_phase4", UNIX_TIME_FALLBACK_2038 ) )
				S10E05_CreateRuiForScreen ( ent , activationTime )
			}
			break
		case S10E05_MAPTABLE_SCRIPT_NAME:
			AddCallback_OnUseEntity_ClientServer( ent, S10E05_OnMapTableUse )
			AddEntityCallback_GetUseEntOverrideText( ent, S10E05_MapTableTextOverride )
			S10E05_CreateRuiForMapTable ( ent )
			break
		case S10E05_LAPTOP_INTERACT_SCRIPT_NAME:
			AddCallback_OnUseEntity_ClientServer( ent, S10E05_OnLaptopUse )
		default:
			break
	}
}

string function S10E05_MapTableTextOverride( entity ent )
{
	if ( file.mapTableState != 0 )
	{
		return ""
	}

	return "#S10E05_MAP_INTERACT_PROMPT"
}


void function S10E05_CreateRuiForScreen( entity ent, int activationTime )
{
	int phase1UnlockTime = expect int( GetCurrentPlaylistVarTimestamp( "s10e05_phase1", UNIX_TIME_FALLBACK_2038 ) )
	var topo = CreateRUITopology_Worldspace( ent.GetOrigin() + <0, -0.5, 0.25> ,  ent.GetAngles() + <0, -90, 0>, 42, 20 )
	var rui = RuiCreate( $"ui/s10e05_cc_screen_idle.rpak", topo, RUI_DRAW_WORLD, 0 )


	RuiSetFloat( rui, "phase1UnlockTime", float(phase1UnlockTime) )
	RuiSetFloat( rui, "screenUnlockTime", float(activationTime) )
	RuiSetFloat( rui, "creationUnixTime", float(GetUnixTimestamp()) )

	thread function() : ( activationTime, rui )
	{
		OnThreadEnd(
			function() : ( rui )
			{
				RuiDestroyIfAlive( rui )
			}
		)

		wait ( activationTime - GetUnixTimestamp() )
	}()
}

void function S10E05_CreateLaptopRui()
{
	array<entity> laptopInteractInfoNodeArray = GetEntArrayByScriptName( S10E05_LAPTOP_SCREEN_TARGET_INFO )
	if ( laptopInteractInfoNodeArray.len() == 1 )
	{
		entity laptopInfoNode = laptopInteractInfoNodeArray[0]
		printt("Laptop Topo Origin: " + (laptopInfoNode.GetOrigin() + <-3.5, 0, 0> + <0, 1, -1>))
		file.laptopTopo = CreateRUITopology_Worldspace( <26521, 11402, -3395>, <30, 229.5 ,-0.75> , 25, 12.5 )
		file.laptopRui = RuiCreate( $"ui/s10e05_laptop_screen_idle.rpak", file.laptopTopo, RUI_DRAW_WORLD, 0 )

		if ( S10E05_GetPhase() < eS10E05Phase.PHASE_1 )
			thread S10E05_CreateLaptopWaitingThread()
		else
		{
			RuiSetBool( file.laptopRui, "active", true )
			S10E05_RefreshLaptopScreen()
		}
	}
}

void function S10E05_CreateLaptopWaitingThread()
{
	int activationTime = expect int( GetCurrentPlaylistVarTimestamp( "s10e05_phase1", UNIX_TIME_FALLBACK_2038 ) )
	wait ( activationTime - GetUnixTimestamp() )
	RuiSetBool( file.laptopRui, "active", true )
	S10E05_RefreshLaptopScreen()
}

#if DEV
void function S10E05_UpdateLaptopTopPos(vector org, vector ang)
{
	float width = 25
	float height = 12.5
	                                                              
	org += ( (AnglesToRight( ang )*-1) * (width*0.5) )
	org += ( AnglesToUp( ang ) * (height*0.5) )

	                                                                               
	vector right = ( AnglesToRight( ang ) * width )
	vector down = ( (AnglesToUp( ang )*-1) * height )
	RuiTopology_UpdatePos( file.laptopTopo, org, right, down  )
}
#endif

void function ServerCallback_S10E05_UpdateMapTableState( int mapTableState )
{
	file.mapTableState = mapTableState
}

void function S10E05_CreateRuiForMapTable( entity ent )
{
	file.holoMapTopo = CreateRUITopology_Worldspace( S10E05_HOLOMAP_FX_ORIGIN, <0, 0, 0> , 256, 140 )
	file.holoMapRui = RuiCreate( $"ui/s10e05_holomap.rpak", file.holoMapTopo, RUI_DRAW_WORLD, 0 )
	thread S10E05_OrientMapTableRuiThread()
}

void function S10E05_OrientMapTableRuiThread()
{
	entity player = GetLocalViewPlayer()
	if ( !IsValid ( player ) )
		return

	player.EndSignal("OnDestroy")
	while ( true )
	{
		vector forward     = player.CameraPosition() - S10E05_HOLOMAP_FX_ORIGIN
		bool playerLookingAtRUI = DotProduct( AnglesToForward( player.CameraAngles() ), forward ) < 0
		vector forwardNorm = Normalize( < forward.x, forward.y, 0 > )
		vector rightDir    = CrossProduct( forwardNorm, < 0, 0, 1 > )

		float rightOffset = 128
		float downOffset = 70


		float distToRUI = Length2D( forward )
		float minDist   = 16.0

		bool shouldSkipOrientation = ( distToRUI < 8.0 ) || ( playerLookingAtRUI && ( distToRUI < minDist ) )
		if ( !shouldSkipOrientation )
		{
			float rightWidth = 256
			vector down      = CrossProduct( forwardNorm, rightDir )
			float downHeight = 140

			RuiTopology_UpdatePos( file.holoMapTopo, S10E05_HOLOMAP_FX_ORIGIN - (rightDir * rightOffset) - (down * downOffset), rightDir * rightWidth, down * downHeight )
		}

		RuiSetInt( file.holoMapRui, "state", file.mapTableState )

		WaitFrame()
	}
}

#if DEV
void function S10E05_UpdateHoloMapTopPos(vector org, vector ang)
{
	float width = 256
	float height = 140
	                                                              
	org += ( (AnglesToRight( ang )*-1) * (width*0.5) )
	org += ( AnglesToUp( ang ) * (height*0.5) )

	                                                                               
	vector right = ( AnglesToRight( ang ) * width )
	vector down = ( (AnglesToUp( ang )*-1) * height )
	RuiTopology_UpdatePos( file.holoMapTopo, org, right, down  )
}
#endif

#endif
      