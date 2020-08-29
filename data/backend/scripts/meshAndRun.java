
import java.util.*;
import star.common.*;
import star.base.neo.*;
import star.meshing.*;


public class meshAndRun extends StarMacro {


  public String getFname(String path) {

    // Extract the filename from string pathname for either Windows or Unix paths
    // Do not edit this routine!
  
    String str = " ";
  
    // Split/parse the string into 'tokens' of data, each separated by a \ or /
    StringTokenizer T = new StringTokenizer (path,"\\") ;
      
    // allow for unix type paths  
    if ( path.substring(0,1).equals("/") ) { 
         T = new StringTokenizer (path,"/") ;
    }
    
    // get last token which is the filename
    while (T.hasMoreTokens()) { 
       str = T.nextToken() ; 
    } 
    
    return str ;
  }

// Main section:

  public void execute() {

    Simulation simulation_0 = getActiveSimulation();   

MeshPipelineController meshPipelineController_0 =
                simulation_0.get(MeshPipelineController.class);
				
meshPipelineController_0.generateVolumeMesh();
String str2 = getFname(simulation_0.getSessionPath());  // get the sim files name
String str3 = str2 + "@meshed";  

    simulation_0.saveState(str3);

    // Set how many iterations to run by (un)commenting the required line:
     simulation_0.getSimulationIterator().run(true);   // run till STOP crit. met
    //simulation_0.getSimulationIterator().step(30,true);  // step for x iters
    

    // optionally change save name for .sim to another name
    // --comment out this line to save over existing .sim file
	
    str3 = str2 + "@solved";  

    simulation_0.saveState(str3);

    
  }
}
