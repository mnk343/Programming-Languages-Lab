// This is the class that represents a single robotic arm.
// A robotic arm picks up a sock from the main belt, and passes it on to the
// match making machine
import java.io.*; 
import java.util.*; 

public class RoboticArm extends Thread{

	public void run(){
		while(true){
			String sock = sharedVariable.pickupSharedItem();
			// If sock returned was empty, this means no more socks remain 
			// and the thread can now exit
			if(sock.equals("Empty") ){
				System.out.println(this.getName() + " rest since no socks left on the belt. ");
				return;
			}

			// Otherwise, we notify the user about the sock we picked up
			System.out.println(this.getName() + " picked up " + sharedVariable.colourTable.get(sock) + " and sent to Matching Machine" );
			int sockIndex = Integer.parseInt(sock);
			sockIndex -= 1;
			// We make the necessary uodates to the Number of socks on the machine
			ChangeSocksOnMachine.updateSocksOnMachine(sockIndex , 1);

			// We sleep after 500 ms
			// This has been written to make approprite analogies to the practical case
			// Practically, identifying the coulour of sock then moving it forward to the required one takes some time.
			try{
           		sleep(500);         
           	}
           	catch (Exception e) {
   				System.out.println("thrown to main" + e);
			}
		}
	}
}
