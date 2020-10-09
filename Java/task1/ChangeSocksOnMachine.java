// This is a utility class that helps in changing the number of socks kept
// on the machine. 
// Since this variable can be changed at one time by both matching machine
// and robotic arms, we need to ensure synchronization
// Thats why the function is made as a synchronized block

import java.io.*; 
import java.util.*; 

public class ChangeSocksOnMachine{
	public static synchronized void updateSocksOnMachine(int index, int changeInValue){
		sharedVariable.socksOnMachine.set(index, sharedVariable.socksOnMachine.get(index) + changeInValue );
	}
}
