#if SERVER || CLIENT
global function ShFiringRangeStoryEvents_Init
#endif

              
#if SERVER
       
                                             
                                     
                                       
                                         
                                           
                                  
                                       
                                      
      
                                                    
                                                               
#endif

#if CLIENT
#if DEV
global function DEV_TeleportToAether_CL
global function DEV_StopAetherEffects_CL
global function DEV_TitleScreenRui
#endif

global function S10E04_IsPlayerInFinale
global function ServerCallback_S10E04_TitleScreen
global function ServerCallback_S10E04_AetherResponsePrompt
global function ServerCallback_S10E04_AetherRemoveClientEffects
global function ServerCallback_S10E04_MarkPlayerInFinale
#endif


const asset S10E04_SHIP_PANEL_MDL = $"mdl/props/global_access_panel_button/global_access_panel_button_console_w_stand.rmdl"
const string S10E04_SHIP_PANEL_SCRIPTNAME = "arenas_tease_dropship_button"
const string S10E04_SHIP_BUTTON_SOUND_EVENT = "ArenaTease_DropshipButton_Activate"
const string S10E04_SHIP_BUTTON_DENY_SOUND_EVENT = "Olympus_Horizon_Screen_Deny"
const vector S10E04_SHIP_ORIGIN = < 33530, -4975, -28647>
const vector S10E04_SHIP_ANGLES = <0, -90, 0>
const float S10E04_SHIP_PICK_UP_RADIUS = 256
const float S10E04_SHIP_TIME_TO_ARRIVE = 6
const float S10E04_SHIP_TIME_TO_DEPART = 30
const string S10E04_SHIP_ATTACHMENT_PT =  "ATTACH_PLAYER_3"
const float S10E04_SHIP_Z_OFFSET = 128


const asset S10E04_PROWLER_MDL = $"mdl/creatures/prowler/prowler_apex.rmdl"
const vector S10E04_PROWLER_ORIGIN = <-21739.58, 6152.38, -22398.7>
const vector S10E04_PROWLER_ANGLES = <0, -170.0, 0>              
const string S10E04_PROWLER_IDLE_ANIM = "prowler_s10e04_01"
const string S10E04_PROWLER_END_ANIM = "prowler_s10e04_02"
const string S10E04_PROWLER_INTERACT_ANIM = "ptpov_s10e04_01"
const string S10E04_PROWLER_SCRIPTNAME = "S10E04_Prowler"

const asset S10E04_BLINK_FX = $"P_BH_aether_blink_FP"
const asset S10E04_AETHER_BH_EYES_FX = $"P_BH_aether_eyes"

const asset S10E04_AETHER_FOG_FX = $"P_aether_fog_screen"
const asset S10E04_AETHER_BH_MDL = $"mdl/Humans/class/medium/pilot_medium_bloodhound.rmdl"
const int S10E04_SKIN_ID = 22
const asset S10E04_AETHER_BH_ANIM_SEQ = $"animseq/humans/class/medium/pilot_medium_bloodhound/bloodhound_s10e04_float_01"
const asset AETHER_BLOODHOUND_DEATH_FX = $"P_BH_aether_death"

const string S10E04_RAVEN_TRIGGER_SCRIPTNAME_TEMPLATE = "s10e04_trigger_raven%d"
const string S10E04_RAVEN_SCRIPTNAME_TEMPLATE = "s10e04_cave_raven_%d"
const int S10E04_RAVEN_COUNT = 9

const asset S10E04_RAVEN_MDL = $"mdl/creatures/bird/bird.rmdl"

struct S10E04EntityData
{
	vector origin
	vector angles
	string scriptName
}
      

struct RealmStoryData
{
               
	entity dropShipPanel
	entity dropShip
	bool dropShipArrived
	bool dropShipPlayerBoarded
	bool playerLanded

	entity prowler
	entity aetherProwler

	array< entity > aetherBloodhounds
	table < entity, entity > aetherBloodhoundEyeFx

	array < entity > ravens
       
}

struct
{
               
	#if SERVER
		                          
		                          
		                       
		                     
		                        
		                        

		                                         
		                                                
	#endif

	#if CLIENT
		int colorCorrection = -1
		int cockpitFxHandle = -1
		bool inFinale = false
	#endif         
       

	table< int,  RealmStoryData > realmStoryDataByRealmTable
} file


                                                                                                                                    
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    
  
                               
                            
                            
                            
                            
                            
                            
  
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    
                                                                                                                                    


#if SERVER || CLIENT
void function ShFiringRangeStoryEvents_Init()
{
	if ( GetMapName() != "mp_rr_canyonlands_staging" )                                                  
		return

	if ( !IsFiringRangeGameMode() )
		return

	AddCallback_EntitiesDidLoad( EntitiesDidLoad )

               
	#if SERVER
		                                                  
		                                 
		                                    
		                                        
		                               
		                                       
	#endif

	#if CLIENT
		AddCreateCallback( "prop_dynamic", S10E04_PropDynamicCreated )
		file.colorCorrection = ColorCorrection_Register( "materials/correction/aether_world.raw_hdr" )
		PrecacheParticleSystem( S10E04_BLINK_FX )
	#endif
       
}
#endif

#if SERVER || CLIENT
void function EntitiesDidLoad()
{
               
		S10E04_Init()
       
}
#endif                    

              
void function S10E04_Init()
{
	#if SERVER
		                                                        
		                                                  

		                                                 
		                                                                               
		                                                          
		                                                          
		                             

		                                              
		 
			                                                                      
			                                                  

			                                                                                     
			                                                  
		 


		                                                                    
		                                                                     
		                                                                     
		                                                                     
		                                                                     

		                                                                                      
		                               
		 
			                                                     
			                                                     
		 
		  

		               
		                                                             
		                                             
		 
			                             
			                                                          

			                                           
			                                      
			                                            
			                                                
			                                    
			                                                                                                    
		 

		                                                                                       
		                                     
		 
			                                       
			                                                                  
		 

		                           
		                                           

		                                                                       
		                                                     
	#endif

	#if CLIENT
		RegisterSignal("S10E04_StopColorCorrection")
	#endif
}

#if SERVER
                                                                             
 
	                                                                       
	                                  
	 
		                                     
		                                                             
		                                                             
		                                            
		                                                         
		                             
	 
 

                                                                  
 
	                                                            
	                       
	 
		                          
		                                       
		                                       
		                                 
		                                       
		                  
	 
 

                                                           
 
	                                                                      
	                                   
	 
		                                     
		                                                              
	 
 
#endif

#if SERVER || CLIENT
bool function S10E04_IsChallengeReady( entity player )
{
	#if DEV
		int fakeStage = GetCurrentPlaylistVarInt( "s10e04_fakechallengestage", -1 )
		if ( fakeStage == 3 )
			return true
	#endif

	if ( IsValid ( player ) )
	{
		ItemFlavor challengeFlav = GetItemFlavorByHumanReadableRef( "challenge_s10e04_group4challenge0" )
		if ( DoesPlayerHaveChallenge ( player, challengeFlav ) )
		{
			return true
		}
	}

	return false
}
#endif

#if SERVER
                                                             
 
	                                                                                                                                                     
	                                                           
	                              
	                                   
	                                     

	                           
	                                                 

	                         
	                                                                                                            
	                                                      

	                                                                              
	                                                                                 

	                                                                      
 

                                                       
 
	                                                                                                                                      
	                                                  
	                        
	                             
	                               

	                                           
	                   
	                                                                                                                                    
	                           
	                                      
	                                                
	                                                                                             
	                                                                     

	                                              
	                                                    
	                                                    

	                                                                    
	                                                          
 

                                                             
 
	                                                                                                                                                                    
	                        
	                             
	                                        
	                               

	                                              
	                                                    
	                                                    

	                                                                    
	                                                                
 

                                                                 
 
	                                                       
	 
		                                                                                                                                                                               
		                                                                          
		                                          
		                                 
		                                        
		                                                                                     
		                                                                                                                                                                                                      
		                                                                                    

		                                                                   
		 
			                                                                
		 
		    
		 
			                                                                                                                                                                        
			                                            
			                                                                                                                                
		 
		                                    
	 
 

                                                      
 
	                                                
	 
		                                                                                                                                                  
		                                                        
		                  
		                      
		                                                  
		                             
		                                                               
	 
 
#endif

void function S10E04_Prowler_OnUse( entity prowler, entity player, int useFlags )
{
	#if SERVER
	                     
	#endif
	thread S10E04_Prowler_InteractThread( player, prowler )
}

void function S10E04_Prowler_InteractThread( entity player, entity prowler )
{

	if ( !IsValid ( player ) ||  !IsValid (prowler) )
		return

	EndSignal( player, "OnDestroy" )

	thread S10E04_AetherTeleport( player, prowler )

#if SERVER
	                                                
	                                              
	                                              
	                                        
	                                                             
	                               
	                                              
	                                                    
	                                                    
	                              
	                              

	                        
	                                               
	                                                        
	                                   
	                                                     
#endif

}

void function S10E04_AetherTeleport( entity player, entity prowler )
{
	if ( !IsValid ( player ) || !IsValid (prowler) )
		return

	EndSignal( player, "OnDestroy" )
	#if SERVER
		                                                
	#endif

	wait 2.2

	#if SERVER
	                                                                                                
	                   
	                                                                                          
	                     
	                                                        
	                                                                    
	        
	                               
	                                          
	                             
	                                                          
	        
	                                                                                     
	                                                          
	        
	                                              
	#endif

	#if CLIENT
		wait 9.0
		thread S10E04_UpdatePlayerScreenColorCorrection ( player )
	#endif
}

#if CLIENT
void function S10E04_UpdatePlayerScreenColorCorrection( entity player )
{
	player.EndSignal( "S10E04_StopColorCorrection" )
	player.EndSignal( "OnDeath" )
	player.EndSignal( "OnDestroy" )

	entity cockpit = player.GetCockpit()
	if ( !IsValid( cockpit ) )
		return

	file.cockpitFxHandle = StartParticleEffectOnEntity( cockpit, GetParticleSystemIndex( S10E04_AETHER_FOG_FX ), FX_PATTACH_ABSORIGIN_FOLLOW, -1 )

	OnThreadEnd(
		function() : ( player )
		{
			ColorCorrection_SetWeight( file.colorCorrection, 0.0 )
			ColorCorrection_SetExclusive( file.colorCorrection, false )

			if ( EffectDoesExist( file.cockpitFxHandle ) )
				EffectStop( file.cockpitFxHandle, false, true )
		}
	)

	ColorCorrection_SetExclusive( file.colorCorrection, true )
	const LERP_IN_TIME = 0.0125                                                                         
	float startTime = Time()

	while ( true )
	{
		float weight = GraphCapped( Time() - startTime, 0, LERP_IN_TIME, 0, 1.0 )
		ColorCorrection_SetWeight( file.colorCorrection, weight )
		WaitFrame()
	}

	ColorCorrection_SetWeight( file.colorCorrection, 1.0 )
}
#endif

#if SERVER
                                                            
 
	                                                             

	                                 

	                                        
	                                                  
	                               
	                                                                                             
	                                                                                                   
	                                                                                                   
	                              
	                              
	                        
	                                               
	                                                        
	                                      
	                                   
	                                                     

	                                                                                                
	                     

	                                                                                        
	                                            

	                                                                                                
	             

	                                                                                          
	                    

	                                                                                        
	                                            

	                                                                                                
	             

	                                                                                          
	                     

	                                                                                        
	                                            

	                                                                                                
	         

	                                                                                          
	                                                                                   

	                                                                                          
	                     

	                                                                                        
	                                            

	                                                                                                
	          

	                                                                                   
	                                                                                   

	                                                                                          
	             
	                                                                                          
	                     

	                                                                                       
	                                            

	                                              
	                                              
	                                                                                                
	                   

	                                                            
	        

	                                                                                   
	                                                                                           
	                                                                                          
	                                                                                           

	        

	                                                                                                
	                   

	                                                                                                
	                   

	                                                                                   
	                                                                                         

	        


	                                                                 
	                                          
	                                             
	                                             

	                                                        
	                                                                    
	        
	                                                                                          
	        
	                        
	                        
	        
	                                                          
	        

	                   
	                                                                   

	                                         
	                                                   
	                                
	                               
	                               
	                        
	                                                
	                                                     

	        

	                                                                                                
	                   
	                                                                                                
	                          
	                                     
	        
	                                                                               
	        
	                                                                                     
	                                                                     
	         
	                                              
	                                     
	        
	                                                  

	                            
	 
		                                  
	 
	    
	 
		                           
		                                
	 

 
#endif

#if SERVER
                                                                      
 
	       
		                                                                           
		                     
			      
	      

	                         
	 
		                                                                                                 
		                                                        
		 
			                      
			                                                       
			                                                               
		 
	 
 
#endif

#if SERVER
                                                                                                      
 
	                                                             
	                          
		      

	                                 
	                                                                                              
	                    
	                                                                                     
	                                                                                                                                                                          
	                                                                                                  
	                                                             
	                       
	        

	                                
		                          
 
#endif

#if CLIENT
void function ServerCallback_S10E04_AetherResponsePrompt( int aetherBloodhoundIndex )
{
	string hintText = "#S10E04_AETHER_RESPONSE_1"

	string hint = "%chat_wheel% " + Localize( hintText )
	AddOnscreenPromptFunction( "quickchat", S10E04_PlayerAetherResponse, 10, hint, 1 )
}

void function S10E04_PlayerAetherResponse( entity player )
{
	if ( IsValid ( player ) )
		Remote_ServerCallFunction ( "ClientCallback_S10E04_AetherResponse" )
}

void function ServerCallback_S10E04_AetherRemoveClientEffects()
{
	entity player = GetLocalClientPlayer()
	if ( !IsValid ( player ) )
		return

	Signal( player, "S10E04_StopColorCorrection" )
}

void function ServerCallback_S10E04_TitleScreen( int type )
{
	thread function() : ( type )
	{
		if ( type == 0 )
		{
			var rui = CreateFullscreenRui( $"ui/map_zone_intro_title.rpak", 0 )
			OnThreadEnd(
				function() : ( rui )
				{
					RuiDestroyIfAlive( rui )
				}
			)
			RuiSetString( rui, "titleText", "#MP_RR_DESERTLANDS_64K_X_64K")
			RuiSetBool( rui, "minimapIsDisabled", false )

			wait 10.0
		}
		else if ( type == 1 )
		{
			var backgroundRui = CreateFullscreenRui( $"ui/s10e04_logo_background.rpak", 0 )
			var titleRui = CreateFullscreenRui( $"ui/s10e04_logo_shake.rpak", 1 )
			wait 2.0
			RuiSetBool(titleRui, "startAnim", true)
		}
	}()
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

#if CLIENT
void function S10E04_PropDynamicCreated ( entity ent )
{
	switch ( ent.GetScriptName() )
	{
		case S10E04_SHIP_PANEL_SCRIPTNAME :
			SetCallback_CanUseEntityCallback( ent, S10E04_DropshipPanel_CanUse )
			AddCallback_OnUseEntity_ClientServer( ent, S10E04_DropshipPanel_OnUse )
			AddEntityCallback_GetUseEntOverrideText( ent, S10E04_DropshipPanel_OverrideText )
			break
		case S10E04_PROWLER_SCRIPTNAME:
			AddCallback_OnUseEntity_ClientServer( ent, S10E04_Prowler_OnUse )
		default:
			break
	}
}
#endif

#if CLIENT
string function S10E04_DropshipPanel_OverrideText ( entity dropShipPanel )
{
	entity player = GetLocalViewPlayer()
	if ( !IsValid( player ) )
		return ""

	if ( !S10E04_IsChallengeReady ( player ) )
		return ""

	if ( !IsPlayerBloodhound ( player ) )
		return "#S10E04_BLOODHOUND_REQ_PROMPT"

	if ( GetPlayerArrayOfTeam( player.GetTeam() ).len() > 1 )
		return "#S10E04_DROPSHIP_SOLO_PROMPT"

	return "#S10E04_DROPSHIP_PROMPT"
}
#endif

#if SERVER || CLIENT
bool function IsPlayerBloodhound( entity player )
{
	if ( !IsValid ( player ) )
		return false

	ItemFlavor character = LoadoutSlot_GetItemFlavor( ToEHI( player ), Loadout_Character() )
	string characterRef  = ItemFlavor_GetHumanReadableRef( character ).tolower()

	if ( characterRef != "character_bloodhound" )
		return false

	return true
}
#endif

bool function S10E04_DropshipPanel_CanUse ( entity player, entity dropShipPanel, int useFlags )
{
	if ( !IsValid( player ) )
		return false

	if ( Bleedout_IsBleedingOut( player ) )
		return false

	int teamIdx   = player.GetTeam()
	int teamCount = GetPlayerArrayOfTeam_Connected( teamIdx ).len()
	if ( teamCount > 1 )
		return false

	if ( !IsPlayerBloodhound ( player ) )
		return false

	if ( !S10E04_IsChallengeReady ( player ) )
		return false

	return true
}

void function S10E04_DropshipPanel_OnUse( entity dropShipPanel, entity player, int useInputFlags )
{

	if ( GetPlayerArrayOfTeam( player.GetTeam() ).len() > 1 )
	{
		#if SERVER
			                                                                      
		#endif
		return
	}

	#if SERVER
		                                                                  
		                           
		                          
		                                          
	#endif
}

                                                                                                                                    
  
                                                                           
                                                                            
                                                                            
                                                                           
                                                                     
                                                                     
                                                                     
                                                                                                                                    

#if SERVER
                                                        
 
	                        
		      

	                           
	                           
	                           
	                                                                                                                                            
	                              
	                                         

	                           
	                        
	                   
	                          
	                             
	                                   
	                           
	                                        
	                                        
	                                                   

	                           
	               
	                           
	                         
	                                                
	                          
	                                     
	                                                    
	                                    
	                         
	                                    
	                                 
	                                   
	                                       

	                     

	                                                                                                
	                        
	                                   

	                     
	                                 
	                                                            
	                                                                
	                                                                      
	                                                             

	                                                    
 

                                                                                                 
 
	                   
	                        
		      

	                             
	                               
	                                               


	                                                                                                                                        
	                                      

	                                              
	                                                      
	                                           
	                                                    

	                                             
	 
		                                 
			                         
	  

	                                                             
	                                                                  


	                    
	                                                

	                                 
	                                                                   
	                         
		      

	                                 

	                                   
	 
		                                                                
		                                                                  
		                                                                                                                                                     
		                                                                                               
		                                                                 
	  

	               
	                      
	                
	                                                             
	                                                               
	                                                               
	                                                               
	                            
	                                                                           

	                                            

	                                                             

	                                  
	                        

	                                                              

	                                                               
	                                                                                  
	        

	                          
		                  

	                                 
		                         

	                                   
	                           
	                                           
	                                            
	                                         

	                                                              
	                                                                  

	                                   
		                                          
	    
	 
		                                               
	 
 

                                                               
 
	                                                 
		      

	                                               
	                               
	                                 

	                    

	                                                                                  
	                           
	                                              
	                                                    
	                               

	                     
	                      
	                              

	        

	                                                                         
	                                                                

	                                       

	        

	                                                                 

	         

	                                                                  

	        
	                                                                               
	                                             
 

                                                                         
 
	                                        
	 
		                                               
			      

		                                               
		                               
		                                 

		                                          
		                                                                    
		                                                                       
		                                                 
		                                      
		                                  
		                                                                                    

		            
			                                  
			 
				                        
				 
					                                   
					                    
					                        
					                                
					                           
					                   
					              
					                                                    
					                                              

					                         
						                                    
				 
			 
		 

		                              
		                    
		                                                                    
	   
 

                                                                   
 
	                                                                  
	 
		      
	 

	                              
	                                                             
	 
		                                                            
		                              
	 
 

                                                                 
 
	                                                                  
	 
		      
	 

	                              
	                                                  
	                                                 
	                                                                               

	                               
	               
	                     
	                    
	                                                                                 
	 
		                                              
		 
			                     
			 
				       
					                                                                                                                           
					                          
					               
					     
				       
					                         
					               
					     
				       
					                                                                                                                           
					                         
					     
				       
					                         
					     
				       
					                                                                                                                                                                                                
					                          
					     
				       
					                         
					     
				       
					                         
					                                                                                                                           
					     
				       
					                          
					     
				       
					           
					                        
					     
			 
			                                                               
			                                                                           
			     
		 
	 
 



                                                                                                                         
 
	                          
		      

	                                               
	                               

	                                           
	 
		                                                                                 
		                                                            
		             
	 
 


                                                                                                                                         
 
	                        
		      

	                                                                      
	 
		                             
		            
			                     
			 
				                      
					              
			 
		 

		          
		                                                                                                              
		              
		                                                            
		                                                                         
		                                                              

		      

	   
 


                                                                       
 
	                               

	                        
	                                    
	                    
	                

	                                             

	                           
	 
		                                                                                   
		                                
		           
	 

	                      
 


                                                
 
	                          
		      

	                                               
	                               

	                     
	                   

	           
	                     

	                                 
	                                                                      
	                                                                                 
	 
		                                              
		 
			                                                               
			                                                           
			     
		 
	 

 

                                                                                          
 
	                                         
 

                                                                     
 
	                                  
	                                                                   
	                         
		      

	                                                                                                                              
	 
		      
	 

	                                                                                                                                                
	 
		      
	 

	                                 
		      

	                                     
 

                                                      
 
	                         
		      

	                             
	                               
	                                               

	                                 
	                                                                   

	                         
		      

	                                 

	                     
	                           
		                     

	                              
	                                                                             
	 
		                                              
	 

	                               
		                        

	                                                                     
	                                                                
		                                     

	                                                                
	                                
		                 

	                                           
		                                      

	                          
	                              
	                                   
	                                       
	                                                                     
	                               
	                                                                                   

	                                             
	                                         
	                                             
	                                     
	        
	                              
	                                                                             

	                          
	                        
	                          

	                                                                     
	                                                              
	                                                              

	                               
	                                 

	                                  
	 
		                          
		                  
		           
		           
	 

	                                  
	                                
	                                
	                                                                   
	                                  
	                                                     

	                                                                              
	                    

	                          
		                                                

	                                                          
	 
		                                     
		                                                                                
	 

	                                                     

	                                                         
	                                                      
	                               
	                                    
	                                               
	                                                   

	                                                 

	                                         

	                                           
 

                                                                                    
 
	                   
	                          
		      

	                                          
	                                 
	                                              

	                 
 

                                                                        
 
	                         
		      

	                                 

	                                       
	 
		                                         
		                      
		                     
	 

	                                                                                                                                                                                                         
	                  
 
#endif

#if CLIENT
void function ServerCallback_S10E04_MarkPlayerInFinale()
{
	file.inFinale = true
}

bool function S10E04_IsPlayerInFinale()
{
	return file.inFinale
}
#endif

#if DEV
#if CLIENT
void function DEV_TeleportToAether_CL()
{
	entity player = GetLocalClientPlayer()
	if ( !IsValid ( player ) )
		return

	thread S10E04_UpdatePlayerScreenColorCorrection ( player )
}

void function DEV_StopAetherEffects_CL()
{
	entity player = GetLocalClientPlayer()
	if ( !IsValid ( player ) )
		return

	Signal( player, "S10E04_StopColorCorrection" )
}

void function DEV_TitleScreenRui()
{
	var backgroundRui = CreateFullscreenRui( $"ui/s10e04_logo_background.rpak", 0 )
	var titleRui = CreateFullscreenRui( $"ui/s10e04_logo_shake.rpak", 1 )
}
#endif

#if SERVER
                                                      
 
	                         
	 
		                                  
		                                                         
		                                                         
		                                                          
	 
 

                                                 
 
	                         
	 
		                                  
		                                                
		                                     
		                                                 
	 
 

                                                            
 
	                         
	 
		                                  
		                                                
		                                    
		                                                 
	 
 

                                                    
 
	                         
	 
		                                  
		                                                   
		                                    
		                                                 
	 
 

                                                      
 
	                               
	                                    
	                                               
	                                                     
	                                                 
	                                                         
	                                                      
 

                                         
 
	                                                                                         
	                                      
		      

	               	                                
	                            
	                                                                                                                                      
	                                                        
	                              
	                                    
	                                 
	                                                                                                                      
 

                                           
 
	                                                                                         
	                                       
		      

	                                                  

	                                        
	 
		                                                                                                                                                                          
		        
		                          
	   
 

                                                     
 
	                                          
	                                        
	                                                                                                      
	                                                                                                                                                                                                          
 
#endif
#endif
      




