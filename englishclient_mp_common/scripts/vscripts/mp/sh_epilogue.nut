global function ShEpilogue_Init
global function ShEpilogue_RegisterNetworking

global function SetSetupNetwork_Epilogue
global function SetSetup_Epilogue
global function SetProcess_Epilogue
global function EpilogueThink

#if SERVER
                                 
#endif


                                               

                                          

          
                                   
                                     
      

          
                                                      
                                                   
      

      







struct
{
	void functionref()	SetupNetwork_Epilogue
	void functionref()	Setup_Epilogue
	void functionref()	Process_EpilogueThink
} file


void function ShEpilogue_Init()
{
	AddCallback_GameStateEnter( eGameState.Epilogue, Callback_EpilogueEnter )

	if ( file.Setup_Epilogue != null )
		file.Setup_Epilogue()
}


void function ShEpilogue_RegisterNetworking()
{
	if ( file.SetupNetwork_Epilogue != null )
		file.SetupNetwork_Epilogue()
}









void function SetSetupNetwork_Epilogue( void functionref() func )
{
	file.SetupNetwork_Epilogue = func
}


void function SetSetup_Epilogue( void functionref() func )
{
	file.Setup_Epilogue = func
}


void function SetProcess_Epilogue( void functionref() func )
{
	file.Process_EpilogueThink = func
}


void function Callback_EpilogueEnter()
{
	thread EpilogueThink()
}


void function EpilogueThink()
{
	Assert( IsNewThread(), "Must be threaded off" )
	printf( "Epilogue: Starting Epilogue Think" )

	if ( file.Process_EpilogueThink != null )
		waitthread file.Process_EpilogueThink()

	printf( "Epilogue: Completed Epilogue Think, transitioning to Resolution" )

	#if SERVER
	                                     
	#endif
}







#if SERVER
                                 
 
	                                         
 
#endif












                                               

                                                                                    
                                                                                    
                                                                                    

      
 
                  
                           
                        
                          


                   
                 

              



                                          
 
                                                                                                   
                                                                                                 
 


          
                                   
 
                                                                                       
                                                      
 


                                     
 
                                                

                                   
                                             
  
                           
           

                                                                                          
  

           

 


                                           
 
                                   

                                             
  
                           
           

                                                                                             
  
 


                                                                                      
 
                         
                               
 
      




          
                                                                       
 
                                                                   

                                                                                                                                          
                                                                                                                                                       
                                                                        
                                                                         
                                            
                                                                                                      
                                                                               
                            
                                                            
 

                                                                    
 
                                                                   

                                                                                                                                                    
                                                                                           
                                                                        
                                                                
                                            
                                                                                                      
                                                                               
                                                             
                                                              
                             
                                                            
 
      

      