global function DesertlandsStoryEvents_Init

#if SERVER
                            	                            
                                                                 
                                                               
#endif

              
#if DEV
#if SERVER
                                             
                                           
                                     
                                         
                                     
                                           
                                        
                                         
#endif

#if CLIENT
global function DEV_S10E04_WPFocusThinkThread
#endif
#endif

#if CLIENT
global function ServerCallback_S10E04_ChallengeMessage
global function ServerCallback_S10E04_UpdatePlayerChallengeState
global function S10E04_CreateSonarPulse
global function S10E04_WaypointPOIVisibilityChanged_Internal
global function ServerCallback_S10E04_UnHidePrints
#endif


const asset S10E04_FIREPIT = $"mdl/desertlands/desertlands_storyevent_firepit_01.rmdl"
const asset S10E04_CROW_MDL = $"mdl/creatures/bird/bird.rmdl"
const string S10E04_CROW_SCRIPTNAME = "s10e04_raven"
const string S10E04_CROW_IDLE_ANIM = "Bird_casual_idle_s10e04"
const string S10E04_CROW_LEAVE_ANIM =  "Bird_react_fly_small_s10e04"
const asset S10E04_CROW_DISSOLVE = $"P_aether_raven_death"
const vector S10E04_WAYPOINT_OFFSET = < 0, 0, 54.0 >
const int S10E04_RAVEN_AIRDROP_INVALID_RADIUS = 50

const int S10E04_CHALLENGE_ID_MAX = 2
const int S10E04_VARIANCE_MAX = 4
const string S10E04_PRINTS_SCRIPTNAME_TEMPLATE = "s10e04_challengemark_%d_%d"

const string S10E04_SEGMENTCOMPLETED_SIGNAL = "s10e04_segmentcompleted"

const string S10E04_PIN_TEMPLATE = "s10e04_chal%d_var%d_seg%d"

const int S10E04_DIALOGUE_FLAGS =
		eDialogueFlags.BLOCK_LOWER_PRIORITY_QUEUE_ITEMS |
		eDialogueFlags.MUTE_PLAYER_PING_DIALOGUE_FOR_DURATION |
		eDialogueFlags.MUTE_PLAYER_PING_CHIMES_FOR_DURATION |
		eDialogueFlags.BLOCK_ANNOUNCER

global enum eS10E04ChallengeDataType
{
	PROWLER_PRINT = 0
	RAVEN_START = 1,
	RAVEN_END = 2,
	INIT_PROWLER_PRINTS = 3,
	CHECKPOINT_TRIGGER = 4,
	FIREPIT = 5
}

struct S10E04_ChallengeData
{
	array < array < vector > > wayPoints
	int challengeId
	table< int, vector > ravenOriginBySegments
	table< int, vector > ravenAnglesBySegements
	vector firepitOrigin
	vector firepitAngles
}

global enum eS10E04ChallengeState
{
	UNAVAILABLE = 0,
	INACTIVE = 1
	INACTIVE_RESUME = 2,
	INPROGRESS = 3,
	COMPLETED = 4,
}

struct S10E04_PlayerChallengeData
{
	int segment = -1
	int state = eS10E04ChallengeState.UNAVAILABLE
	int variance = -1
	int challengeId = -1
}

#if CLIENT
struct POISonarPulseData
{
	vector origin
	float radius
	vector dir
	float fov
}
#endif

      

struct
{
	entity beamFX
               
	#if CLIENT
		                            
		int nextId = 0
		table < int, var > trackedPOIRui
		array< POISonarPulseData > activeSonarPulseAreas

		                          
		int state = eS10E04ChallengeState.UNAVAILABLE
		int variance = -1
		int challengeId = -1
		int segment = -1

		string printsScriptName = ""
	#endif

	#if SERVER
	                                                             
	                                                                                         
	                                             
	#endif

	                                                 
	table < int, table < int, S10E04_ChallengeData > > challengeDataTable
	float challengeTime

	#if DEV
	#if SERVER
		                       
	#endif
	#endif
       
} file


                                                                                                                                    
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    
  
                               
                            
                            
                            
                            
                            
                            
  
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    


void function DesertlandsStoryEvents_Init()
{
	AddCallback_EntitiesDidLoad( EntitiesDidLoad )

	#if SERVER
		                                         
		                                             
	#endif

               
	if ( GetMapName() == "mp_rr_desertlands_mu3" )
	{
		S10E04_Init()
	}
       
}

void function EntitiesDidLoad()
{
	#if SERVER
	                                                                                         
		                  
	#endif


               
	if ( GetMapName() == "mp_rr_desertlands_mu3" )
	{
	#if SERVER
		                             
	#endif
	#if CLIENT
		S10E04_HideTrails()
	#endif
	}
       

}

#if SERVER
                                
 
	                               
	                                                                                                                                  
	                                                                                                                                                                      
	                                 
 
#endif

#if CLIENT
void function S10E04_HideTrails()
{
	for ( int i = 0 ; i <= S10E04_CHALLENGE_ID_MAX; i++ )
	{
		for ( int j = 0; j <= S10E04_VARIANCE_MAX; j++ )
		{
			string scriptName = format( S10E04_PRINTS_SCRIPTNAME_TEMPLATE, i, j )
			if ( scriptName == file.printsScriptName )
				continue

			array< entity > printsArray = GetEntArrayByScriptName(scriptName)
			foreach ( print in printsArray )
			{
				print.Hide()
			}
		}
	}
}
#endif

              
void function S10E04_Init()
{
	#if DEV
		RegisterSignal( "DEV_CapturePrintsEnd" )
	#endif

	if ( IsPrivateMatch() || IsArenaMode() )
		return

	ItemFlavor ornull  storyEvent = GetStoryChallengeEventIfActive( GetUnixTimestamp(), "calevent_s10e04_story_challenges" )
	#if DEV
		if ( storyEvent == null && GetCurrentPlaylistVarInt( "s10e04_fakechallengestage", -1 ) == -1  )
			return
	#else
		if ( storyEvent == null )
			return
	#endif

	#if SERVER
		                                                                       
		                                                         
		                                                                  
		                                                          
		                                      
		                                                
	#endif
	#if CLIENT
		AddCreateCallback( PLAYER_WAYPOINT_CLASSNAME, S10E04_OnWaypointCreated )
		AddCreateCallback( "prop_script", S10E04_ChallengePropScriptCreated )
		RegisterSignal( "Challenge_StopWaypointsThink" )
		AddCallback_MinimapEntShouldCreateCheck_Scriptname("s10e04_raven_minimap", Minimap_DontCreateRavenHintForOthers)
		RegisterMinimapPackage( "prop_script", eMinimapObject_prop_script.S10E04_RAVEN, MINIMAP_OBJECT_RUI, S10E04_MinimapPackage_Raven, FULLMAP_OBJECT_RUI, S10E04_MinimapPackage_Raven )
	#endif

	PrecacheModel(S10E04_FIREPIT)

	file.challengeTime = GetCurrentPlaylistVarFloat("s10e04_challengeTime", 180.0)

	S10E04_SetupChallengeData()
}

void function S10E04_SetupChallengeData()
{
	var dataTable = GetDataTable( $"datatable/s10e04_challenge_data.rpak" )
	int numRows   = GetDataTableRowCount( dataTable )

	int challengeColumn              = GetDataTableColumnByName( dataTable, "challenge" )
	int varianceColumn               = GetDataTableColumnByName( dataTable, "variance" )
	int typeColumn           		 = GetDataTableColumnByName( dataTable, "type" )
	int originColumn                 = GetDataTableColumnByName( dataTable, "origin" )
	int anglesColumn                 = GetDataTableColumnByName( dataTable, "angles" )
	int segmentColumn				 = GetDataTableColumnByName ( dataTable, "segment" )

	for ( int i = 0; i < numRows; i++ )
	{

		int challengeId = GetDataTableInt( dataTable, i, challengeColumn )
		int variance = GetDataTableInt( dataTable, i, varianceColumn )

		if ( !(challengeId in file.challengeDataTable) )
		{
			S10E04_ChallengeData challengeData
			challengeData.challengeId = challengeId
			challengeData.wayPoints.resize(4)
			table < int, S10E04_ChallengeData > challengeTableByVariance
			challengeTableByVariance[variance] <- challengeData
			file.challengeDataTable[challengeId] <- challengeTableByVariance
		}
		else if ( !(variance in file.challengeDataTable[challengeId]) )
		{
			S10E04_ChallengeData challengeData
			challengeData.challengeId = challengeId
			challengeData.wayPoints.resize(4)
			file.challengeDataTable[challengeId][variance] <- challengeData
		}

		int type = GetDataTableInt( dataTable, i, typeColumn )
		vector origin = GetDataTableVector( dataTable, i, originColumn )
		vector angles = GetDataTableVector( dataTable, i, anglesColumn  )
		int segment = GetDataTableInt( dataTable, i, segmentColumn )
		switch ( type )
		{
			case eS10E04ChallengeDataType.PROWLER_PRINT:
				file.challengeDataTable[challengeId][variance].wayPoints[segment].append( origin )
				break
			case eS10E04ChallengeDataType.RAVEN_START:
			case eS10E04ChallengeDataType.RAVEN_END:
				file.challengeDataTable[challengeId][variance].ravenOriginBySegments[segment] <- origin
				file.challengeDataTable[challengeId][variance].ravenAnglesBySegements[segment] <- angles
				break
			case eS10E04ChallengeDataType.INIT_PROWLER_PRINTS:
				file.challengeDataTable[challengeId][variance].wayPoints[segment].append( origin )
				break
			case eS10E04ChallengeDataType.FIREPIT:
				file.challengeDataTable[challengeId][variance].firepitOrigin = origin
				file.challengeDataTable[challengeId][variance].firepitAngles = angles
				break
		}

	}
}

#if SERVER
                                           
 
	                                                                              
	 
		                                                                 
		 
			                                                                                                
			 
				                                                                
				                                                                          
				                                                                                
			 
		 
	 
 

                                     
 
	                                    
	                                        
	                             
	 
		                                                                           
		 
			                                                                           
			                                                  
			                                              
				        

			                                                                                  
			                                                                                                        
				                                       
			    
			 
				                                                                                                                                                               
			 
		 
	 

	                                            
	 
		                                              
			        

		                                                                                  
		                                                 

		                                                             

		                                                     
		                                                      
		                                                                                                                                                                                                                  
		                                                       
		                                                                   
		                       
			                                                     
		                                                                                                                                                               
	 

	                                                                          
	 
		                                                            
		                                 
			                                                                                         
	 
 

                                                       
 
	                                          
		      

	                                           
		      

	                                    
	 
		                                                        
		 
			                                                                                                                                
		 
		      
	 

	                                
	                                          
	 
		                                                                                  
		                                                                                                                                     
		 
			                      
			      
		 
		                                                                         
		 
			                                                                            
			                                                                                                                                     
			                                                                                                                                                                                                                  
		 
		    
		 
			                                                                                                      
			                                                                                                                                                                                               
			                                                                                                                                                                                                                  
			                                                                                                                                                               
			                          
		 
	 
	    
	 
		                                                 
		                                          
		 
			                                                                                  
			                                                                                                        
			 

				                                                 
				                                                             
				                                                     
				                                                      
				                                                                                                                                                                                                                  
				                                                       
				                                                                   
				                       
					                                                     

				                          
			 

			                                                                                                                                                               
		 
	 

	                                                                                   
	 
		                                                                  
		                                 
			                                                                                                                                    
	 
 

                                                       
 
	                                                                           
		      

	                                          
	 
		                                                                                  
		                                                                                                                                     
		 
			                      
			      
		 
		                                                                         
		 
			                                                                            
			                                                                                                                                     
			                                                                                                                                                                                                                  
		 
		    
		 
			                                                                                                      
			                                                                                                                                                                                               
			                                                                                                                                                                                                                  
		 
	 
 

                                                               
 
	       
		                                                                                         
		                                      
			                                
	      

	                
	                                                                       
	                                                                            
	 
		                                                                         
		 
			            
			                                                                   
		 
	 

	               
 

                                                                      
 
	                         
		      

	                                                        
	                                           
	 
		                                                                        
		                   
		 
			                                              
			                                     
			                                             
			                                 
			                                                          
			                                                        
		 
		    
		 
			                                                                                            
			                              
			 
				                                              
				                                     
				                                             
				                                                
				                                                                 
				                                                        

				                                                                                                                                                                                                                  

				                                                                            
				                                                               

				                       
					                                                              
			 
		 
	 
	    
	 
		                                              
		                                                             
		                                                        
	 
 

#endif


#if SERVER || CLIENT
bool function IsPlayerBloodhound( entity player )
{
	ItemFlavor character = LoadoutSlot_GetItemFlavor( ToEHI( player ), Loadout_Character() )
	string characterRef  = ItemFlavor_GetHumanReadableRef( character ).tolower()

	if ( characterRef != "character_bloodhound" )
		return false

	return true
}
#endif

#if SERVER
                                                                                   
 
	                         
		      

	                                                                                                           
		      

	                                                                            
	                                                                            

	                                                                   
	       
		                                      
	      
	                                  
	                                                        
	                                    
 
#endif

#if SERVER
                                                                                                                 
 
	                                                                                                           
		      

	                                                                                       
			                                                                                        
		      


	                                                                                             
	                                                                                              


	                                                                                  
	                                             
	                      
	                       
	                                                   
	                  
	                 
	                                                                                                    
	                                              
	                                                                                       
	                                                                                            
	 
		                   
		                
		             
		 
			             
			          
		 

		                                                                
		                                                                                       
		                                                                          
		                                           
		                                                    
		                                          
		             
			                                                                             
		    
			                                                                               
		                                          
		                      
		                                
		                                                    
		                                                 
		                              
		                             
	 

	                                                                          
	                                                                       
	                                              
	                                         
	                                              
 


                                                                  
 
	                                              
		      

	                                                               
	                            

	            
		                      
		 
			                       
				               
		 
	 

	             
 

#endif

#if CLIENT
void function S10E04_MinimapPackage_Raven( entity ent, var rui )
{
	RuiSetImage( rui, "defaultIcon", $"rui/hud/minimap/icon_minimap_white_raven" )
	RuiSetImage( rui, "clampedDefaultIcon", $"" )
	RuiSetFloat3( rui, "iconColor", SrgbToLinear( <242, 224, 0> / 255.0 ) )
	RuiSetBool( rui, "useTeamColor", false )
}

bool function Minimap_DontCreateRavenHintForOthers( entity ent )
{
	return (ent.GetOwner() == GetLocalViewPlayer())
}
#endif

bool function S10E04_ChallengeRaven_CanUse ( entity player, entity raven, int useFlags )
{
	if ( !IsValid( player ) )
		return false

	if ( Bleedout_IsBleedingOut( player ) )
		return false

	if ( !IsValid ( raven ) )
		return false

	if ( raven.GetOwner() != player )
		return false

	return true
}


void function S10E04_ChallengeRaven_OnUse( entity raven, entity player, int useFlags )
{
	#if SERVER
	                                             
		      

	                   

	                                                               
	                                                         
	                                                       

	                   
	 
		                                                                        
	 
	                        
	 
		                      
		 
			       
				                                          
				                                  
				                                                   
				     

			       
				                                          
				                                  
				                                                   
				     

			       
				                                          
				                                  
				                                                   
				     
		 
	 
	                                            
	 
		                                              
	 
	    
	 
		                                                
		                                       
	 

	#endif
}

#if SERVER
                                                                                                     
 
	                      
	 
		       
			                                                   
			     
		       
			                                                   
			     
		       
			                                              
			     
	 
 

                                                      
 
	                          
		      

	                                                              
 

                                                                        
 
	                                                
		      

	                                                                                        
	            
		                              
		 
			                                                                                                                                                    
			 
				                        
				 
					               
				 

				                                                       
					                                                                                          
			 
		 
	 


	                                                                                               
	             
	                                       
	                                                              
	        
	                                          
 

                                                      
 
	                          
		      

	                                                              
	                                                              
	                                                              
 

                                                                        
 
	                                                
		      
	
	                                                                                        

	            
		                              
		 
			                                                                                                                                                    
			 
				                        
				 
					               
				 

				                                                       
					                                                                                          
			 
		 
	 

	                                                              
	        
	                                                                                               
	             
	                                       
	                                                              
	         
	                                          
 

                                                      
 
	                          
		      

	                                                              
 

                                                                  
 
	                                                
		      

	                                                                                        
	                      

	            
		                              
		 
			                                                                                                                        
			 
				                        
				 
					               
				 

				                                                       
					                                                                                          
			 
		 
	 


	                                                              
	        
	                                                                                               
	             
	                                                 
	                                                              
	                                                              
	         
	                                   
 

                                                                  
 
	                                                
		      

	                                                                                        
	                      

	            
		                              
		 
			                                                                                                                                                    
			 
				                        
				 
					               
				 

				                                                       
					                                                                                          
			 
		 
	 

	                                       
	                                                              
	                                                              
	         
	                                   
 


                                                                            
 
	                                                                           
	 
		                                                              
			        

		                                                                                  
	 
 
#endif

int function S10E04_GetChallengeVarianceForPlayer ( entity player, int challengeId, int segment )
{
	#if DEV
		int challengeVarianceOverride = GetCurrentPlaylistVarInt( "s10e04_overrideVariance", -1 )
		if ( challengeVarianceOverride != -1 )
			return challengeVarianceOverride
	#endif

	if ( segment > 0 )
	{
		return player.GetPersistentVarAsInt( "s10StoryEvent.activeVariance" )
	}

	return -1
}

int function S10E04_GetChallengeSegmentForPlayer ( entity player, int challengeId )
{
	#if DEV
		int fakeSegment = GetCurrentPlaylistVarInt( "s10e04_fakesegment", -1 )
		if ( fakeSegment != -1 )
			return fakeSegment
	#endif

	if ( IsValid ( player ) )
	{
		string challengeName = ""
		switch ( challengeId )
		{
			case 0:
				challengeName = "challenge_s10e04_group1challenge0"
				break
			case 1:
				challengeName = "challenge_s10e04_group2challenge0"
				break
			case 2:
				challengeName = "challenge_s10e04_group3challenge0"
				break
			default:
				break
		}

		if ( challengeName == "" )
			return 0

		ItemFlavor challengeFlav = GetItemFlavorByHumanReadableRef( challengeName )
		if ( !DoesPlayerHaveChallenge ( player, challengeFlav ) )
			return 0

		int progress = Challenge_GetProgressValue( player, challengeFlav, 0 )
		return progress
	}
	return 0
}

int function S10E04_GetChallengeForPlayer( entity player )
{
	#if DEV
		int fakeStage = GetCurrentPlaylistVarInt( "s10e04_fakechallengestage", -1 )
		if ( fakeStage != -1 )
			return fakeStage
	#endif

	if ( IsValid ( player ) )
	{
		int tracksCompleted =  player.GetPersistentVarAsInt( "s10StoryEvent.tracksCompleted" )
		switch ( tracksCompleted )
		{
			case 0:
				ItemFlavor challengeFlav = GetItemFlavorByHumanReadableRef( "challenge_s10e04_group1challenge0" )
				if ( DoesPlayerHaveChallenge ( player, challengeFlav ) )
					return tracksCompleted
				break
			case 1:
				ItemFlavor challengeFlav = GetItemFlavorByHumanReadableRef( "challenge_s10e04_group2challenge0" )
				if ( DoesPlayerHaveChallenge ( player, challengeFlav ) )
					return tracksCompleted
				break
			case 2:
				ItemFlavor challengeFlav = GetItemFlavorByHumanReadableRef( "challenge_s10e04_group3challenge0" )
				if ( DoesPlayerHaveChallenge ( player, challengeFlav ) )
					return tracksCompleted
				break
			default:
				return -1
				break
		}
	}

	return -1
}

#if SERVER
                                                                               
 
	                                                                     
		      

	                                                                                                                                                                   
		                                                                          

	                                                

	                                                               
	                                                         
	                                                           
	                                 

	                      
	 
		                                                            
		                                                                         
		                                                     
		                                                                                    
		                                                                                                                                                                        
		                                                             
		      
	 

	                                                       
	                                                                                                                                                                        

	                       
		                                                                                    

	               
		                                                                                    

	                                   
	 
		                                                     
		                                                                                    
	 

	                                                                             
	                                                             
 

                                                                                                         
 
	                                                                              

	                   
	 
		                                      
			                                                           
		    
			                                                                         
	 
	    
	 
		                                                           
	 
 

                                                                                                        
 
	                                          
	 
		                                                                                                                                      
		      
	 

	                                                                                                           
		      

	                                                                                               
	                                                                                                              
	                                                                   
	                                                       
	                          
	                                                          

	                                                         
 

                                                                             
 
	                                                  
		      

	                                                                                               
	                              

	            
		                        
		 
			                          
				                 
		 
	 

	                                            
	 
		                               
			             
		    
			                       
	 
 

                                                                          
 
	                                                                  
	 
		      
	 

	                                
		      

	                                                            
		      

	                                       
	                 
 

                                                                                                               
 
	                                          
	 
		                                                                                                                                            
		      
	 

	                                                                                                           
		      

	                                                                                
		      

	                                                                                       
		                                          
 

                                                                      
 
	                         
		      

	                                                                        
	                                     
	                           
	                                                    
	                                        

	                                                                 
 

                                                                                       
 
	                                                                                               
	                         

	            
		                                   
		 
			                                                                     
			                                     

			                                               
			 
				                                                   
				            
			 
			                                                     
			 
				                                                                                                                                 
				                                          
			 
			                                                     
			 
				                                        
				            
			 
			    
			 
				                                                                                 
			 
		 
	 

	                                            
	 
		                                                                                                                                                                    
		 
			             
		 
		                                                                                       
		 
			                               
				             
			    
				                       
		 
	 
 
#endif

#if SERVER
                                                                                   
 
	                        
		      

	                             
	            
		                     
		 
			                      
				              
		 
	 

	                                                                                                       
	        

	                                                         
	                                                                         
	                                                        
	      
 


                                                                              
 
	                               

	                        
	                                    
	                    
	                

	                                             

	                           
	 
		                                                                                   
		                                
		           
	 
 
#endif


#if CLIENT

void function ServerCallback_S10E04_ChallengeMessage( int messageId )
{
	entity player = GetLocalClientPlayer()
	if ( !IsValid(player) )
		return

	switch ( messageId )
	{
		case 0:
			AnnouncementMessageQuick( player, Localize("#S10E04_CHALLENGE_MESSAGE01") )
			break
		case 1:
			AnnouncementMessageQuick( player, Localize("#S10E04_CHALLENGE_MESSAGE02") )
			break
		case 2:
			AnnouncementMessageQuick( player, Localize("#S10E04_CHALLENGE_MESSAGE03") )
			break
		case 3:
			AnnouncementMessageQuick( player, Localize("#S10E04_CHALLENGE_MESSAGE04") )
			break
	}
}

void function ServerCallback_S10E04_UpdatePlayerChallengeState( int challengeId, int variance, int segment, int state )
{
	int prevChallenge = file.challengeId
	int prevSegment = file.segment

	file.challengeId = challengeId
	file.variance = variance
	file.segment = segment
	file.state = state

	entity player = GetLocalClientPlayer()
	if ( IsValid(player) )
	{
		if ( prevChallenge == -1 && file.challengeId != -1 )
			thread S10E04_WaypointThinkThread( player )

		if ( state == eS10E04ChallengeState.COMPLETED )
			player.Signal( "Challenge_StopWaypointsThink" )
	}
}

void function ServerCallback_S10E04_UnHidePrints( string scriptName )
{
	if ( scriptName == "" )
		return

	file.printsScriptName = scriptName

	array< entity > printsArray = GetEntArrayByScriptName(scriptName)
	foreach ( print in printsArray )
	{
		print.Show()
	}
}

void function S10E04_ChallengePropScriptCreated( entity ent )
{
	switch ( ent.GetScriptName() )
	{
		case S10E04_CROW_SCRIPTNAME:
			SetCallback_CanUseEntityCallback( ent, S10E04_ChallengeRaven_CanUse )
			AddCallback_OnUseEntity_ClientServer( ent, S10E04_ChallengeRaven_OnUse )
			AddEntityCallback_GetUseEntOverrideText( ent, S10E04_ChallengeRaven_OverrideText )
			break
		case "s10e04_raven_minimap":
			SetMapFeatureItem( 300, "#S10E04_SEC_TITLE_LONG", "#S10E04_MAP_LEGEND_DESC", $"rui/hud/gametype_icons/survival/story_waypoint_zone" )
			break
		default:
			break
	}
}

void function S10E04_CreateSonarPulse( vector origin, float radius, vector dir, float fov )
{
	POISonarPulseData data
	data.origin = origin
	data.radius = radius
	data.dir	= dir
	data.fov	= fov
	file.activeSonarPulseAreas.append( data )
}

string function S10E04_ChallengeRaven_OverrideText ( entity raven )
{
	entity player = GetLocalViewPlayer()
	if ( !IsValid( player ) )
		return ""

	return "#S10E04_RAVEN_INTERACT_PROMPT"
}

void function S10E04_OnWaypointCreated( entity wp )
{
	if ( wp.GetWaypointType() != eWaypoint.S10E04_PROWLER_PRINT )
		return

	wp.WaypointAddFlag( WPF_VISBILITY_LOS | WPF_VISIBILITY_SONAR )
	wp.WaypointSetCheckDist ( 2048 )

	wp.WaypointSetID( file.nextId )
	file.nextId++

	wp.WaypointFocusTracking_Register()
	wp.WaypointFocusTracking_SetDisabled( false )
	wp.WaypointFocusTracking_TrackPos( wp, RUI_TRACK_ABSORIGIN_FOLLOW, 0 )
}

void function S10E04_CreateWaypointRui( entity wp )
{
	entity localViewPlayer = GetLocalClientPlayer()
	var rui = CreateTransientFullscreenRui( $"ui/s10e04_tracking_vision_object_icons.rpak", RuiCalculateDistanceSortKey( localViewPlayer.EyePosition(), wp.WaypointGetPOIPosition() ) )

	RuiSetGameTime( rui, "startTime", wp.WaypointGetCreationTime()  )
	RuiSetGameTime( rui, "iconCreationTime", Time() )
	if ( file.state == eS10E04ChallengeState.INPROGRESS )
		RuiSetFloat( rui, "duration", file.challengeTime )
	else
		RuiSetFloat( rui, "duration", -1 )

	RuiTrackFloat3( rui, "pos", wp, RUI_TRACK_ABSORIGIN_FOLLOW )

	RuiKeepSortKeyUpdated( rui, true, "pos" )

	RuiSetInt( rui, "teamRelation", 0 )
	float drawDistance = 2048
	float huntStatusSeverity = StatusEffect_GetSeverity( localViewPlayer, eStatusEffect.hunt_mode )
	if ( huntStatusSeverity )
		drawDistance *= 2

	RuiSetFloat( rui, "iconDrawDist", drawDistance )

	RuiKeepSortKeyUpdated( rui, true, "pos" )

	if (( file.challengeId in file.challengeDataTable ) && (file.variance in file.challengeDataTable[file.challengeId]) )
	{
		S10E04_ChallengeData challengeData = file.challengeDataTable[file.challengeId][file.variance]
		float distanceToTarget = Distance( challengeData.ravenOriginBySegments[3], wp.GetOrigin() )
		RuiSetFloat( rui, "distanceToTarget", distanceToTarget )
	}


	if ( IsRavenWaypoint( wp.GetOrigin() ) )
	{
		RuiSetImage( rui, "iconImage", $"rui/hud/poi_icons/poi_white_raven" )
		RuiSetString( rui, "objectText", "#S10E04_RAVEN_WAYPOINT" )
	}
	else
	{
		RuiSetImage( rui, "iconImage", $"rui/hud/poi_icons/poi_prowler_tracks" )
		RuiSetString( rui, "objectText", "#S10E04_PRINT_WAYPOINT" )
	}

	RuiSetInt( rui, "drawSize", 1 )

	file.trackedPOIRui[ wp.WaypointGetID() ] <- rui
	thread S10E04_ClearRuiOnDestroy( wp, wp.WaypointGetID(), rui )
}

bool function IsRavenWaypoint( vector origin )
{
	                                              
	if ( file.state == eS10E04ChallengeState.INACTIVE || file.state == eS10E04ChallengeState.INACTIVE_RESUME )
		return true

	if ( !( file.challengeId in file.challengeDataTable ) || !(file.variance in file.challengeDataTable[file.challengeId]) )
		return false

	if ( !(file.segment in file.challengeDataTable[file.challengeId][file.variance].ravenOriginBySegments) )
		return false

	if ( file.segment == 3 || ( file.segment == 2 && file.challengeId == 2 ))
	{
		vector ravenOriginWithOffset = file.challengeDataTable[file.challengeId][file.variance].ravenOriginBySegments[file.segment] + S10E04_WAYPOINT_OFFSET
		if ( DistanceSqr( origin, ravenOriginWithOffset ) <= 0.1 )
			return true
	}

	return false
}

void function S10E04_ClearRuiOnDestroy( entity waypoint, int waypointID, var rui )
{
	waypoint.SetDoDestroyCallback( true )
	waypoint.EndSignal( "OnDestroy" )

	OnThreadEnd(
		function (  ) : ( waypoint, waypointID, rui )
		{
			RuiDestroyIfAlive( rui )
			if ( waypointID in file.trackedPOIRui )
				delete file.trackedPOIRui[ waypointID ]
		}
	)

	WaitForever()
}

void function S10E04_WaypointPOIVisibilityChanged_Internal( entity waypoint, bool isVisible )
{
	entity localViewPlayer = GetLocalViewPlayer()
	if ( !IsValid( localViewPlayer ) )
		return

	if ( !IsValid( waypoint ) )                                                                                                                            
		return

	if ( localViewPlayer != waypoint.GetOwner() )
		return

	int waypointID = waypoint.WaypointGetID()
	Assert( waypointID >= 0, "Never created a rui for waypoint" )

	if ( isVisible )
	{
		S10E04_CreateWaypointRui( waypoint )
	}
	else
	{
		if ( waypointID in file.trackedPOIRui )
		{
			RuiDestroyIfAlive( file.trackedPOIRui[ waypointID ] )
			delete file.trackedPOIRui[ waypointID ]
		}
	}
}

void function S10E04_WaypointThinkThread( entity player )
{
	player.EndSignal("Challenge_StopWaypointsThink")
	while ( true )
	{
		array< entity > waypoints = GetNearbyPlayerWaypointPOIs()
		foreach ( entity waypoint in waypoints )
			S10E04_UpdateProwlerPrintWaypointThread ( waypoint )

		file.activeSonarPulseAreas = []
		wait 0.25
	}
}

void function S10E04_UpdateProwlerPrintWaypointThread( entity waypoint )
{
	if ( !IsValid (waypoint) )
		return

	if ( waypoint.WaypointGetID() < 0 )
		return                                             

	if ( waypoint.GetWaypointType() != eWaypoint.S10E04_PROWLER_PRINT )
		return

	entity localViewPlayer = GetLocalViewPlayer()
	if ( !IsValid( localViewPlayer ) )
		return

	if ( waypoint.GetOwner() != localViewPlayer )
		return

	vector waypointPos = waypoint.GetOrigin()
	bool addWaypointFlag = false
	foreach ( POISonarPulseData sonarData in file.activeSonarPulseAreas )
	{
		float sonarDistSqr = DistanceSqr( sonarData.origin, waypointPos )
		if ( sonarDistSqr <= ( sonarData.radius * sonarData.radius ) )
		{
			                                                              
			vector posToTarget = Normalize( waypointPos - sonarData.origin )
			float dot = DotProduct( posToTarget, sonarData.dir )
			float angle = DotToAngle( dot )

			if ( angle > ( sonarData.fov / 2 ) )
				continue

			addWaypointFlag = true
			break
		}
	}

	if ( addWaypointFlag )
		waypoint.WaypointSetAlwaysVisibleEndTime( Time() + 3.0 )

	int waypointID = waypoint.WaypointGetID()
	bool isVisible = waypoint.WaypointIsVisible()
	if ( isVisible && waypointID in file.trackedPOIRui )
	{
		bool waypointInFocus = waypoint.WaypointIsInFocus()
		RuiSetBool( file.trackedPOIRui[ waypointID ], "inViewFocus", waypointInFocus )
	}
}
#endif

#if SERVER
                                                                             
 
	       
		                                                                           
		                      
			      
	      

	                        
	 
		                                                                 
	 
 
#endif

#if SERVER
                                                                                          
 
	                          
		      

	                                                           
		      

	                                                                               
	                                 
 
#endif

#if DEV
#if SERVER
                                                            
 
	                              
	 
		              
		 
			                                          
			                                         
			      
		 
	   
 

                                                          
 
	                                        
	                                                                
	         

	                                 
	 
		                                                                        
		                                          
	 
 

                                     
 
	                    
	 
		              
		 
			                                                                                     
			                                   
				                                                                                                                              

			       
		 
	   
 
#endif


#if CLIENT
void function DEV_S10E04_WPFocusThinkThread()
{
	entity player = GetLocalClientPlayer()
	thread S10E04_WaypointThinkThread( player )
}
#endif

#if SERVER
                                         
 
	              
	 
		                                                                              
		 
			                                                                 
			 
				                                                                                    
				 
					                                                                             
					 
						           
						            
						             

						                       
						 
							         
							                     
						 
						                            
						 
							           
							                    
						 
						                                                
						 
							          
							                   
						 

						             
						 
							                                                                                                                                             
						 
						    
						 
							                                                                            
						 

						                                                                                                                              
					 
				 
			 
		 

		        
	 
 
#endif

#if SERVER
                                                                     
 
	                        
	 
		                                                                 
		                       
		 
			                                                                 
			                                                                 
		 
	 
 
#endif

#if SERVER
                                                          
 
	                        
	 
		                                                                                       
	 
 
#endif

#if SERVER
                                                       
 
	                        
	 
		                                 
		 
			                                                                        
			                                                                        
			                                                     
			                                        
			                                     
			           
		 

		                                                          
	 
 
#endif

#if SERVER
                                         
 
	                                                                              
	 
		                                                                 
		 
			                                                                                                
			 
				                                                                
				                   

				                                              
				 
					             
				 

				                                                                                                                                                
				              
					                                                                
			 
		 
	 
 
#endif
#endif

      
