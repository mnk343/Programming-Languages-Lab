// This is the main function from where execution will start.
// Socks will be taken as input and number of robotics arms also from the user.
// Then, threads equal to robotics arms would be created 
// A separate thread will be created for the matching machine

import java.io.*; 
import java.util.*; 

public class Main{
	public static void main(String args[]){

		// We initialize our dictionary which maps an index to its colour
		sharedVariable.colourTable.put("1" , "White");
		sharedVariable.colourTable.put("2" , "Black");
		sharedVariable.colourTable.put("3" , "Blue");
		sharedVariable.colourTable.put("4" , "Grey");

		System.out.println("Welcome to the Robotics Hands Machine.");
		
		// Initializing the input stream
		Scanner scanner= new Scanner(System.in); 
		int flag=1;
		
		// Take input from the cmd, as much as the user wishes to enter.
		while(flag == 1){
			System.out.printf("Enter colour of sock(e to exit): ");
			String str= scanner.nextLine();

			// If user presses e, we exit the loop
			if( str .equals("e")){
				flag = 0;
				continue;
			}
			sharedVariable.socksOnBelt.add(str);
		}

		// We now take in the number of robotic arms as input. 
		// For all robotic arms, we would create separate threads.
		System.out.printf("Enter the number of Robotics Arms(default is 4): ");
		String str= scanner.nextLine();
		int numberOfThreads;

		// We have taken default to be 4, so if user doesnt enter anything, we 
		// assume we have 4 robotic arms
		if( str.equals(" ")){
			numberOfThreads = 4;
		}
		else{
			numberOfThreads = Integer.parseInt(str);
		}

		// This is the initial count of socks on the matching machine, ie 0 for each colour
		sharedVariable.socksOnMachine.add(0);
		sharedVariable.socksOnMachine.add(0);
		sharedVariable.socksOnMachine.add(0);
		sharedVariable.socksOnMachine.add(0);

		// We create a vector of Threads and start each one of them concurrently
		Vector <RoboticArm> SingleRoboticArmVector = new Vector<RoboticArm>();
		for( int i = 0 ; i < numberOfThreads ; i++){
			RoboticArm newArm = new RoboticArm();
			// We assign appropriate names to the threads
			newArm.setName("Robotic Arm " + String.valueOf(i+1));
			SingleRoboticArmVector.add(newArm);
		}
		// We start all threads for the robotic arms
		for( int i = 0 ; i < numberOfThreads ; i++){
			SingleRoboticArmVector.get(i).start();
		}

		// We start another thread for the Matching Machine
		MatchingMachine matchineMachine = new MatchingMachine();
		matchineMachine.start();
	}
}

