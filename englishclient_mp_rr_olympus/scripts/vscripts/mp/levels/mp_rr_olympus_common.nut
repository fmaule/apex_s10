global function Olympus_MapInit_Common


const float RIFT_INNER_RADIUS = 850.0
const float RIFT_OUTER_RADIUS = 1200.0
const float RIFT_REDUCE_SPEED_INNER = 250.0
const float RIFT_REDUCE_SPEED_OUTER = 500.0
const float RIFT_PULL_SPEED = 1500.0
const float RIFT_SWIRL_ACCEL = 1200.0
const float RIFT_TRIGGER_BOX_SIZE = 350.0

const asset OLYMPUS_VICTORY_EFFECT = $"P_env_oly_victory"

struct
{
	table< entity, int > riftHandles
} file

void function Olympus_MapInit_Common()
{
	printf( "%s()", FUNC_NAME() )

	ShPrecacheSkydiveLauncherAssets()

	SetVictorySequencePlatformModel( $"mdl/levels_terrain/mp_rr_olympus/floating_victory_platform_01.rmdl", < 0, 0, -10 >, < 0, 0, 0 > )

	#if CLIENT
		SetVictorySequenceLocation(<15002.5635, 16763.1055, 2355.54785>, <0, 15.1553955, 0> )
		SetVictorySequenceEffectPackage( <15002.5635, 16763.1055, 2355.54785>, <0, 105.155, 0>, OLYMPUS_VICTORY_EFFECT )
		Freefall_SetPlaneHeight( 12500 )
		Freefall_SetDisplaySeaHeightForLevel( -11500 )
	#endif

	#if SERVER
		                       

		                                                                
		 
			                                            
		 
	#endif

	#if SERVER && DEV
		                                              
	#endif

	#if CLIENT
		SetMinimapBackgroundTileImage( $"overviews/mp_rr_olympus_bg" )
	#endif
}

#if SERVER && DEV
                               
 
	                 
		                   
	      

	                                 

 
#endif


#if SERVER

                                     
 
	                                                              
	 
		                                                                                                    
		                                                  
			      

		                
	   
 

                        

                                     
 
	                                           
		      

	                                                        
	                                    
	                                    
	                                                                                                                                              
	                                                    
	                                                    
	                                      
	                                          

	                        

	                                          
	                                                        

	                
 

                                                                    
 
	                                

	                                                               

	                                                                                               
		                                                                                                                                                                                      

	                           
		                        
 

                                                                    
 
	                                

	                           
		                               
 

                                                
 
	                                                                                               
	                        
	                                 
 

                                                       
 
	                                                    
	                                                               
	                                                                             
 
#endif