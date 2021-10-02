global function GondolaMover_Init
global function GondolasAreActive
global function IsPlayerInsideGondola

              
const string GONDOLA_SCRIPTNAME = "gondola_func_brush"
const string GONDOLA_INTERIOR_TRIGGER = "gondola_interior_trigger"

#if SERVER
                                                             
                                                           
                                                               
                                                               
                                                                      

        
                                                                    
                                                                                        
                                                                       
                                                                                 
                                                                                 
                                                                                  
                                                                          

                                      
                                              
                                                
                                                 
                                                     
#endif          

#if CLIENT
const float TRIGGER_TO_MODEL_RADIUS_SQR = 15000
#endif          

#if SERVER
                        
 
	                          
	             

	      
 
#endif          

struct GondolaMoverData
{
	entity model
	entity interiorTrigger

	#if SERVER
		            
		                    
		                

		                  
		                            

		                    
		                                         
		                                                                                                 
		                                                                                                    
	#endif
}


struct
{
	array< entity > initOnly_gondolas
	array< entity > initOnly_gondolaInteriorTriggers

	table< entity, GondolaMoverData > moverDatas

} file


void function GondolaMover_Init()
{
	#if SERVER
		                                                                            
	#endif          

	#if CLIENT
		AddCreateCallback( "func_brush", OnGondolaFuncBrushSpawned )
		AddCreateCallback( "trigger_multiple_clientside", Cl_OnGondolaTriggerSpawned )
	#endif          
}


void function OnGondolaFuncBrushSpawned( entity gondola )
{
	#if CLIENT
		if ( gondola.GetScriptName() != GONDOLA_SCRIPTNAME )
			return
	#endif          

	file.initOnly_gondolas.append( gondola )
	GondolaMoverData data

	data.model = gondola

	                       
	#if CLIENT
		array<entity> triggers = GetEntArrayByScriptName( GONDOLA_INTERIOR_TRIGGER )
		foreach( trigger in triggers)
		{
			if ( !IsValid( trigger.GetParent() ) && DistanceSqr( trigger.GetOrigin(), data.model.GetOrigin() ) < TRIGGER_TO_MODEL_RADIUS_SQR )
			{
				trigger.SetParent( data.model )
			}
		}
	#endif

	#if SERVER
		                                                   
		 
			                                           

			                                             
			 
				                              
				                                                                    
			 
			                                                       
			 
				                            

				              
				                                                                                                
				                                                              
			 
			                                                    
			 
				                                                
				                               
			 
		 

		                            
			      

		                          
		                                                  
		                                               
		                                                              
		                            
		                              
		                                        

		            
		                                  
		                                            

		                                     

		                                                                            
		                                  

		                                                                   
	#endif          
}

#if SERVER
                                                                 
 
	                                                  
	                       
	                                          

	            
 


                                                                           
 
	                         
	                             

	                          

	                                            
	                                                    
	 
		                                                    
		                                         

		                       
			     

		                           
		 
			                                          
			 
				                       
				             
				     
			 
		 
	 

	                
 
#endif

#if CLIENT
void function Cl_OnGondolaTriggerSpawned( entity trigger )
{
	if ( trigger.GetScriptName() != GONDOLA_INTERIOR_TRIGGER )
		return

	if ( !file.initOnly_gondolaInteriorTriggers.contains( trigger ) )
		file.initOnly_gondolaInteriorTriggers.append( trigger )

	                                                                               
	foreach( gondola in file.initOnly_gondolas )
	{
		if ( DistanceSqr( trigger.GetOrigin(), gondola.GetOrigin() ) < TRIGGER_TO_MODEL_RADIUS_SQR )
		{
			trigger.SetParent( gondola )
			break
		}
	}
}
#endif          

#if SERVER
                                                                  
 
	                            
	 
		                                            
			                                             
			     

		                               
			                                            
			     
	 
 


                                                                           
 
	                               

	                                                

	                       
	 
		                   
		                                     
		                                  
	 

	                                
	                                       
	 
		                                                

		                                              
		                                               
		                     
		                     

		                                 
		 
			                                                   
			 
				                                                              

				                                                          
			 
			                                                        
			 
				                                         
				                                                             
				                                                                                   
			 
			                                      
			 
				                                                          
				                                                               
			 
		 
		    
		 
			                                 
			  
				                                                               

				                                                           
				                                                                
			  
			     
			  
				                                                               

				                                                           
			  
		 

		                                                                    

		             

		                                
			     
	 

	                         

	                                                                      

	                                 

	                                                 
 


                                                                              
 
	                                     

	                              
	                            
	         

	                                                       
 


                                                                            
 
	                                     

	                                                                

	                              
	                           
	         

	                                                                  

	                    

	                                                                
 


                                              
 
	                                                                                           
		           

	            
 


                                                        
 
	                  
	                             
	 
		                                                                                                             
		 
			                    
			     
		 
	 

	                    
 

                                                                                                                                   
                                                                                                 
 
	                                 
		      

	                        
	                                    

	                         
	 
		                                     
		 
			                                                          

			                                       
			 
				                                                           
				 
					                                     
				 

				     
			 
		 

		           
	 
 
#endif          

bool function IsPlayerInsideGondola( entity ent )
{
	bool playerIsInGondola = false

	                                                                                                  
	foreach( trigger in file.initOnly_gondolaInteriorTriggers )
	{
		if ( trigger.GetTouchingEntities().contains( ent ) )
		{
			if ( ent.DoesShareRealms( trigger ) && ent.IsPlayer() )
			{
				playerIsInGondola = true
				break
			}
		}
	}

	return playerIsInGondola
}


bool function GondolasAreActive()
{
	if ( file.initOnly_gondolas.len() == 0 )
		return false

	return true
}