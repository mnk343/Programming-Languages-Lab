// This class is for the Matching Machine. The main purpose it serves is 
// to match pair of socks as given by the robotic arms and when there is a match
// pass on the pair to the appropriate shelf

import java.io.*; 
import java.util.*; 

public class MatchingMachine extends Thread{
	public void run(){
		// The flag variable is the condition variable, if it becomes false
		// we know that there is no other matching that can be done and we can exit safely
		int flag=1;
		while(flag == 1){
			flag=0;
			for(int i = 0 ; i < 4; i ++){
				// We loop through all the colours and see if any particular colour
				// is occuring in pairs
				if( sharedVariable.socksOnMachine.get(i) > 1){
					int numberOfSocks = sharedVariable.socksOnMachine.get(i)/2;
					// We make the necessary changes, as mentioned in the other file, this is synchronized
					// so there would be no race conditions if this thread and the robotic arm tries to update values
					ChangeSocksOnMachine.updateSocksOnMachine(i, -2* numberOfSocks );
					for ( int j = 0 ; j <numberOfSocks; j++ ){
						System.out.println("Matching Machine received: " + sharedVariable.colourTable.get(String.valueOf(i+1)) + " pair of socks, sending to the appropriate shelf");
					}
					flag=1;
				}
			}
			// if there are more socks to be processed, we keep running the match making machine till there is eventually no more socks left
			if(sharedVariable.socksOnBelt.size()>0)
				flag=1;
		}
		System.out.println("Matching Machine rests");
	}	
}

