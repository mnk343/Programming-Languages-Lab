// This is the utility class that contains all the necessary variables 
// that are shared in the system
import java.io.*; 
import java.util.*; 

public class sharedVariable{
	// This will be called by the robotic arms to pickup items if there are any.
	// This is a synchronized block to restrict race conditons in the system
	public static synchronized String pickupSharedItem(){
		if(sharedVariable.socksOnBelt.size() == 0 ){
			return "Empty";
		}
		String sock = sharedVariable.socksOnBelt.remove();
		return sock;
	}
	// This is a dictionary that contains a mapping from an index to a colour
	// So for example 0 refers white colour
	public static Dictionary colourTable = new Hashtable(); 

	// This is a queue containing all the socks in our system
	public static Queue <String> socksOnBelt = new LinkedList<String> ();

	// This is a vector containing information the socks on machine.
	public static Vector <Integer> socksOnMachine = new Vector<Integer> (4);
}
