// This is the main utility function that helps to do the necessary operations
// on the file. After creating the threads in the main class, each thread is 
// given a specific task to achieve

import java.io.IOException;
import java.nio.ByteBuffer;
import java.nio.channels.FileChannel;
import java.nio.channels.FileLock;
import java.nio.file.Paths;
import java.nio.file.Path;
import java.nio.file.StandardOpenOption;
import java.io.*; 
import java.util.*; 

public class CRUD_Operations_File extends Thread{
	public static int task;
	public static int evaluator_role;
	public static String roll_number;
	public static int change_in_marks;
	public static Vector<String> lines;
	public static FileChannel fileChannel;
	
	// The constructor funcions
	public CRUD_Operations_File(){
		// We initilize all the required variables
		evaluator_role = -1 ;
		task = 0;
		roll_number = "";
		change_in_marks = 0 ;
		lines = new Vector<String> ();
		try{
			Path path = Paths.get("Stud_Info.txt");
			RandomAccessFile reader = new RandomAccessFile("Stud_Info.txt", "rw");
	        fileChannel = reader.getChannel();
		}
		catch(Exception e){
			System.out.println(e);
		}
	}

	// This function is used to read the file after acquiring the lock
	// and storing all the data in the required varibles.
	public static void readFile(){
		Vector<Character> contents_of_file=new Vector<Character>();
		try{
	        // We initilize the bytebuffer from which our values will be read
			// The length of the buffer is taken to be equal to the filechannel size
	        ByteBuffer buffer = ByteBuffer.allocate((int) fileChannel.size());
	        int noOfBytesRead = fileChannel.read(buffer);
	        while (noOfBytesRead != -1) {
	            buffer.flip();

	            while (buffer.hasRemaining()) {
	            	contents_of_file.add((char)buffer.get());
	            }
	            buffer.clear();
	            noOfBytesRead = fileChannel.read(buffer);
	        }

	    }
		catch(Exception e){	
	        System.out.print(e);
	    }
	    // For each line, we write it into our data variables
	    // This will be used for processing later as we would see.
	    int counter = 0 ;
	    while( counter < contents_of_file.size()){
	    	String line = "";
	    	while( contents_of_file.get(counter) != '\n' ){
	    		line += contents_of_file.get(counter);
	    		counter++;
	    	}
	    	lines.add(line);
	    	counter++;
	    }
	}

	// This function generated two types of files depending on the input it gets.
	// So if the generatingIndex is 0, we sort by roll number or else we sort by name
	public static void generateFile(int generatingIndex){
		Map <String , String> map = new HashMap < String, String> ();
		// We break each line into tokens
		// and we parse the necessary tokens.
		for( int i  =0 ; i < lines.size(); i ++){
			String line = lines.get(i);
			String words[] = line.split(",");
			if(words.length == 5)
				map.put(words[generatingIndex],line);
		}
		// This is an inbuilt method used to sort the ArrayList based on some values
		ArrayList<String> sortedKeys = new ArrayList<String>(map.keySet()); 
        Collections.sort(sortedKeys);  
        try{
        	String name = "";
        	// We generate the file
        	if( generatingIndex == 0)
        		name = "Sorted_Roll.txt";
        	else
        		name = "Sorted_Name.txt";
        	// We also acquire the lock on this file
        	// as race conditions can occue if we dont lock the file
        	// In that case, it would be possible that two programs make an attempt parallely to
        	// write to that file and the data may get written twice 
        	// leading to synchronization problems
			RandomAccessFile reader = new RandomAccessFile(name, "rw");
	        FileChannel generateFile_channel = reader.getChannel();
			FileLock generateFile_lock = generateFile_channel.lock();
			
			generateFile_channel.position(0);
			String data = "";
			for (String x : sortedKeys) {
				data += map.get(x);
				data += "\n";
	        } 
	        // We store all the data into the byte buffer and then back to the file
			ByteBuffer generateFile_buf = ByteBuffer.allocate(10000);
			generateFile_buf.clear();
			generateFile_buf.put(data.getBytes());
			generateFile_buf.flip();
			while(generateFile_buf.hasRemaining()) {
			    generateFile_channel.write(generateFile_buf);
			}
			generateFile_channel.close();
			if(generatingIndex == 0){
				System.out.println("\n\t\t\tSorting by roll number successfull\n");
			}
			if(generatingIndex == 1){
				System.out.println("\n\t\t\tSorting by name successfull\n");
			}
		
		}
		catch(Exception e){
			System.out.println(e);
		}
        
	}

	// This method is used to update record level or file level entries in our system
	public static void updateMarks(){
		int is_update = 0;
		for (int i = 0 ; i < lines.size() ; i++){
			String line = lines.get(i);
			String words[] = line.split(",");
			// if the roll number matches
			if( words[0].equals(roll_number)){
				is_update = 1;
				// if the last update had been done by the CC and the TA is trying to change it
				// show appropriate errors.
				if( words[words.length-1].equals("CC") && evaluator_role != 3 ){
					System.out.println("\nPermission Denied. You cannot change the value of the student as the instructor has made the last change.\n");
					break;
				}
				// If we are allowed, calculate the updated marks.
				int current_marks = Integer.parseInt(words[words.length-2]);
				current_marks += change_in_marks;
				words[words.length-2] = String.valueOf(current_marks);
				// After this, write to the file our role so that it can be used in the future
				if( evaluator_role == 1)
					words[words.length-1] = "TA1";

				else if( evaluator_role == 2)
					words[words.length-1] = "TA2";

				else if( evaluator_role == 3)
					words[words.length-1] = "CC";
				if( i == lines.size()-1){
					words[words.length-1] += "\n";
				}
			}

			line = String.join(",", words);
			lines.set(i , line);
		}

		// After this, we again write all the data back to our file
		try{
			fileChannel.position(0);
			String dataToWrite = "";
			System.out.println(dataToWrite);
			for( int i = 0 ; i <lines.size() ; i ++){
				String line = lines.get(i);
				dataToWrite += line;
				if(i != lines.size()-1)
					dataToWrite += "\n";
			}
			// We write all the contents stored in the bytebuffer
			ByteBuffer buf = ByteBuffer.allocate(10000);
			buf.clear();
			buf.put(dataToWrite.getBytes());
			buf.flip();
			while(buf.hasRemaining()) {
			    fileChannel.write(buf);
			}
		}
		catch(Exception e){
			System.out.println(e);
		}
		// If we didnt found any matching entries, it probably means that the record was not found in the database
		if( is_update == 0){
			System.out.println("\nRecord not found in the database. Please enter correct value and try again. \n");
		}
		return;
	}

	// This is the method that is called first
	// In this method, irrespective of what we have to do, we acquire the lock
	// This is done so as to avoid race conditons.
	// After acquiring the lock ,we proceed to do our specific task.
	public void run(){
		try{
			FileLock lock = fileChannel.lock();
		}
		catch(Exception e){
			System.out.println(e);
		}
		// We read the file to fill in our input buffers.
		readFile();

		// depending on the value of task, we call the appropriate function.
		if(task < 2){
			generateFile(task);
		}
		else if(task == 2){
			updateMarks();
		}
		try{
	        fileChannel.close(); 
	        // Finally before exiting and closing the lock is implicitly closed and given to other blocked threads waiting for the same
		}
		catch(Exception e){
			System.out.println(e);
		}
	}
}