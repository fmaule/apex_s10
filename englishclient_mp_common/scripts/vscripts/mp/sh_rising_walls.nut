#if SERVER
                                

       
                                   
      

#endif


#if CLIENT
global function ClRisingWalls_Init
global function ServerToClient_SetRisingWallAmbientGenericState
#endif


#if SERVER || CLIENT
global const string RISABLE_WALL_BRUSH_SCRIPTNAME = "risable_wall_brush"

const string RISABLE_WALL_HELPER_SCRIPTNAME = "rising_wall_helper"
const string RISABLE_WALL_PANEL_SCRIPTNAME = "risable_wall_top_panel"
const string RISABLE_WALL_MOVER_TOP_SCRIPTNAME = "risable_wall_top_mover"
const string RISABLE_WALL_MOVER_BASE_SCRIPTNAME = "risable_wall_base_mover"
const string RISABLE_WALL_MOVER_FLAP_SCRIPTNAME = "risable_wall_flap_mover"
const string RISABLE_WALL_FLOOR_MODEL_SCRIPTNAME = "rising_wall_floor_model"
const string RISABLE_WALL_FX_TRANSITION = "FX_wall_transition"
const string RISABLE_WALL_FX_COMPLETE = "FX_wall_complete"

const float WALL_RAISE_SEQ_DURATION = 20.0
const float DISPERSE_STICKY_LOOT_DURATION = 14.0
#endif                   


#if SERVER
                                                                                                  
                                                          
                                                    

                                        
 
	             
	             
	             
	             
 

                                                 
                                            
                                                     

                                                    
                                                     
                                                    

                                                                          
#endif         


#if CLIENT
const string AMBIENT_GENERIC_SCRIPTNAME = "rising_wall_ambient_generic"
#endif


struct RisableWallData
{
	array<entity> panels
	entity        moverTop
	entity        moverFlap
	entity        moverBase
	entity        baseWallBrush
	entity        topWallBrush
	entity        flapWallBrush

	bool hasStartedRising = false

	#if SERVER
		                          
		                        
		                    
		                     
		                               
		                              
		                              
	#else
		array<entity> ambientGenerics
	#endif
}


struct
{
	table<EHI, RisableWallData> risableWallEHandleDataGroups

	#if SERVER
		                         
	#endif
} file


#if SERVER
                                
 
	                                        
	                                    
	                                  

	                                              
 
#endif


#if CLIENT
void function ClRisingWalls_Init()
{
	AddCallback_EntitiesDidLoad( EntitiesDidLoad )

	RegisterMinimapPackage( "prop_script", eMinimapObject_prop_script.RISING_WALL_DOWN, MINIMAP_OBJECT_RUI, MinimapPackage_RisingWall_Down, FULLMAP_OBJECT_RUI, MinimapPackage_RisingWall_Down )
	RegisterMinimapPackage( "prop_script", eMinimapObject_prop_script.RISING_WALL_MOVING, MINIMAP_OBJECT_RUI, MinimapPackage_RisingWall_Moving, FULLMAP_OBJECT_RUI, MinimapPackage_RisingWall_Moving )
	RegisterMinimapPackage( "prop_script", eMinimapObject_prop_script.RISING_WALL_UP, MINIMAP_OBJECT_RUI, MinimapPackage_RisingWall_Up, FULLMAP_OBJECT_RUI, MinimapPackage_RisingWall_Up )
}
#endif


void function EntitiesDidLoad()
{
	if ( !DoRisableWallEntsExist() )
		return

	#if CLIENT
		array<entity> allAmbientGenerics = GetEntArrayByScriptName( AMBIENT_GENERIC_SCRIPTNAME )
		foreach ( entity ambientGeneric in allAmbientGenerics )
			ambientGeneric.SetEnabled( false )
	#endif

	foreach ( entity helper in GetEntArrayByScriptName( RISABLE_WALL_HELPER_SCRIPTNAME ) )
	{
		RisableWallData data
		EHI helperEHI = ToEHI( helper )

		#if SERVER
			                 
		#endif

		foreach ( entity linkEnt in helper.GetLinkEntArray() )
		{
			string scriptName = linkEnt.GetScriptName()

			if ( scriptName == RISABLE_WALL_PANEL_SCRIPTNAME )
			{
				data.panels.append( linkEnt )
			}
			else if ( scriptName == RISABLE_WALL_MOVER_BASE_SCRIPTNAME )
			{
				data.moverBase = linkEnt
				#if SERVER
					                                      
				#endif

				foreach ( entity childEnt in linkEnt.GetChildren() )
				{
					string className

					#if SERVER
						                                   
					#else
						className = expect string( childEnt.GetNetworkedClassName() )
					#endif

					if ( className == "func_brush" )
					{
						data.baseWallBrush = childEnt
						data.baseWallBrush.SetScriptName( RISABLE_WALL_BRUSH_SCRIPTNAME )
					}
				}
			}
			else if ( scriptName == RISABLE_WALL_MOVER_TOP_SCRIPTNAME )
			{
				data.moverTop = linkEnt
				#if SERVER
					                                     
				#endif

				foreach ( entity childEnt in linkEnt.GetChildren() )
				{
					string className

					#if SERVER
						                                   
					#else
						className = expect string( childEnt.GetNetworkedClassName() )
					#endif

					if ( className == "func_brush" )
					{
						data.topWallBrush = childEnt
						data.topWallBrush.SetScriptName( RISABLE_WALL_BRUSH_SCRIPTNAME )
					}
				}
			}
			else if ( scriptName == RISABLE_WALL_MOVER_FLAP_SCRIPTNAME )
			{
				data.moverFlap = linkEnt
				#if SERVER
					                                      
				#endif

				foreach ( entity childEnt in linkEnt.GetChildren() )
				{
					string className

					#if SERVER
						                                   
					#else
						className = expect string( childEnt.GetNetworkedClassName() )
					#endif

					if ( className == "func_brush" )
					{
						data.flapWallBrush = childEnt
						data.flapWallBrush.SetScriptName( RISABLE_WALL_BRUSH_SCRIPTNAME )
					}
				}
			}
#if SERVER
			                                                             
			 
				                    
			 
			                                                    
			 
				                  
				                                         
				                                         
				                                        
				                 
			 
			                                                  
			 
				                     
				                                            
				                                            
				                                         
				                 
			 
#endif
		}

		#if CLIENT
			foreach ( entity ambientGeneric in allAmbientGenerics )
			{
				entity parentEnt = ambientGeneric.GetParent()
				if ( IsValid( parentEnt ) && IsValid( data.baseWallBrush ) && data.baseWallBrush == parentEnt )
					data.ambientGenerics.append( ambientGeneric )
			}
		#endif

		#if SERVER
			                                     
			                                         
			                                         
			                                         
			                                                   

			                
			                                                   
			 
				                                                              
				                                                                     
				                                                                     

				                                                                                            
				                                                 
				                             
			 

			                                                                                                                        
			                    
		#endif

		string instanceName = data.panels[0].GetInstanceName()

		if ( instanceName == "" )
		{
			Warning( "Risable wall instance at pos: " + data.panels[0].GetOrigin() + " needs an instance name." )
		}
		else
		{
			data.panels.extend( GetEntArrayByScriptName( format( "%s_extra_panel", instanceName ) ) )
		}

		foreach ( entity wallPanel in data.panels )
		{
			#if SERVER
				                       
				                                             
				                     
				                                                                                                        
				                                                  
				                      
				                                                                                     
			#endif
			                                                                        

			AddCallback_OnUseEntity_ClientServer( wallPanel, CreateRisableWallPanelFunc( data, helper ) )
		}

		#if SERVER
			                                                                                    
		#endif

		file.risableWallEHandleDataGroups[helperEHI] <- data
	}
}


#if SERVER
                                                                                      
 
	                 

	                                                                 
	 
		                                                                                                                                              
		                                   
		                                                 
	 
	                                                                        
	 
		                                                                                                                                             
		                                  
		                                                   
	 
	                                                                    
	 
		                                                                                                                                             
		                                  
		                                               
	 

	                                                
	                                      
	 
		                                          
	 
 
#endif


#if SERVER
                                                  
 
	                                  

	                       
	 
		                     
		                   
	 
 
#endif


#if SERVER || CLIENT
bool function DoRisableWallEntsExist()
{
	array<string> entNamesToCheck

	#if SERVER
		                                                        
		                                                       
		                                                           
		                                                            
		                                                            
		                                                             
		                                                    
		                                                  
	#endif

	foreach ( string scriptName in entNamesToCheck )
	{
		array<entity> ents = GetEntArrayByScriptName( scriptName )
		if ( ents.len() < 1 )
			return false
	}

	return true
}
#endif                   


#if SERVER || CLIENT
void functionref( entity panel, entity player, int useInputFlags ) function CreateRisableWallPanelFunc( RisableWallData data, entity helper )
{
	return void function( entity panel, entity player, int useInputFlags ) : ( data, helper )
	{
		thread OnRisableWallPanelActivate( data, helper, panel, player )
	}
}
#endif                   


#if SERVER || CLIENT
void function OnRisableWallPanelActivate( RisableWallData data, entity helper, entity activePanel, entity playerUser )
{
	if ( data.hasStartedRising )
		return

	data.hasStartedRising = true

	#if SERVER
		                                       
		 
			                  
			                   
		 

		                                                                
		                                   
			                                              

		                                
		                                 
		                                        

		                               
		                                

		                                
		                                 
		                                        

		                                      
			                                                

		                                                                                      
	#endif         

	AddEntToInvalidEntsForPlacingPermanentsOnto( data.baseWallBrush )
	AddEntToInvalidEntsForPlacingPermanentsOnto( data.flapWallBrush )
	AddRefEntAreaToInvalidOriginsForPlacingPermanentsOnto( data.moverBase, <-94, -896, -32>, <122, 890, 24> )

	#if SERVER
		                                 
	#endif

	#if SERVER && DEV
		                        
		 
			                                                    
			                                                                                

			                                            
				                                                                           
			                                          
				                                                                         

			                                                               
		 
	#endif                 

	OnThreadEnd(
		function() : ( data )
		{
			#if SERVER
				                  
			#endif         
		}
	)

	#if SERVER
		                                                    

		                                                   
		                                                                                                                                    

		                                                  
		                                                                                                

		                                                   
		                                                                                                  

		                                             
			                                                                                                        

		                       
		                                            
			                                                                                                                                         

		                                         
			                                    
	#endif          

	wait DISPERSE_STICKY_LOOT_DURATION

	#if SERVER
		                                                               
		                                                             
		                                        
		 
			                                              
			 
				                   
				                                                               
			 
		 
	#endif

	wait WALL_RAISE_SEQ_DURATION - DISPERSE_STICKY_LOOT_DURATION

	#if SERVER
		                                          
			                                                                                                    

		                              
		                             
		                              

		                                      
			                                               

		                                                                                  
	#endif         

	#if SERVER || CLIENT
		AddToAllowedAirdropDynamicEntities( data.topWallBrush )
	#endif

	#if SERVER
		                                             
			                                                                                                         
	#endif         
}
#endif                   


#if CLIENT
void function ServerToClient_SetRisingWallAmbientGenericState( entity helper, bool shouldEnable )
{
	if ( !IsValid( helper ) )
		return

	EHI helperEHI = ToEHI( helper )

	if ( !( helperEHI in file.risableWallEHandleDataGroups ) )
		return

	RisableWallData data = file.risableWallEHandleDataGroups[ helperEHI ]

	foreach ( entity ambientGeneric in data.ambientGenerics )
	{
		if ( IsValid( ambientGeneric ) )
		{
			if ( !shouldEnable )
			{
				ambientGeneric.Destroy()
			}
			else
			{
				ambientGeneric.SetEnabled( true )
			}
		}
	}
}
#endif


#if SERVER && DEV
                                   
 
	                        
 
#endif                     


#if SERVER && DEV
                                                                                       
 
	                                       
	                                        

	                      

	             
	 
		                                                        
			      

		                                                                     
		                                                                      

		           
	 
 
#endif                     


#if SERVER
                                                
 
	                             
	 
		                
	 
 
#endif         

#if SERVER
                                                                  
 
	                                    
	                                        
 
#endif         

#if CLIENT

void function MinimapPackage_RisingWall_Down( entity ent, var rui )
{
	#if MINIMAP_DEBUG
		printt( "Adding 'rui/hud/minimap/icon_map_wall_open' icon to minimap" )
	#endif
	RuiSetImage( rui, "defaultIcon", $"rui/hud/minimap/icon_map_wall_open" )
	RuiSetImage( rui, "clampedDefaultIcon", $"" )
	RuiSetBool( rui, "useTeamColor", false )
}


void function MinimapPackage_RisingWall_Moving( entity ent, var rui )
{
	#if MINIMAP_DEBUG
		printt( "Adding 'rui/hud/minimap/icon_map_wall_moving' icon to minimap" )
	#endif
	RuiSetImage( rui, "defaultIcon", $"rui/hud/minimap/icon_map_wall_moving" )
	RuiSetImage( rui, "clampedDefaultIcon", $"" )
	RuiSetBool( rui, "useTeamColor", false )
}


void function MinimapPackage_RisingWall_Up( entity ent, var rui )
{
	#if MINIMAP_DEBUG
		printt( "Adding 'rui/hud/minimap/icon_map_wall_blocking' icon to minimap" )
	#endif
	RuiSetImage( rui, "defaultIcon", $"rui/hud/minimap/icon_map_wall_blocking" )
	RuiSetImage( rui, "clampedDefaultIcon", $"" )
	RuiSetBool( rui, "useTeamColor", false )
}
#endif