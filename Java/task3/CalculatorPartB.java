// This file generates the Swing components for the part B
// ie. The user will have an option to choose the operand and the number
// simultaneously. Operand will be chosen with space key and number
// will be chosen with the enter key

import javax.script.ScriptEngineManager;
import javax.script.ScriptEngine;
import javax.script.ScriptException;
import javax.swing.Timer; 
import java.awt.event.*; 
import javax.swing.*; 
import java.awt.*; 
import java.util.*;

class CalculatorPartB extends JFrame implements ActionListener { 
    // create the main frame 
    static JFrame f; 

    // creates the textfield which will store the result 
    static JTextField l; 
    
    // creates a variable which tells which number button to highlight
    static int current_number_index = 0;

    // creates a variable which tells which operator button to highlight
    static int current_operator_index = 0;
    
    // Stores all the possible operands
    static String ops = "C+-/*=";

    // creates lists to hold all the buttons for numbers and operators
    Vector<JButton> operators = new Vector< JButton> ();
    Vector<JButton> numbers = new Vector< JButton> ();

    // when we output the result and then press a number, the output has to be cleared
    static int clear_screen = 0;

    // This method is used to evaluate the value of the string output
    // and display the output in the main box.
    // if there are any errors, show Error in the text field
    public void calculateValueOfTextField() {
        try{
            // The ScripEngineManager is used to evaluate expressions
            // upto a good degree of precision
            ScriptEngineManager manager = new ScriptEngineManager();
            ScriptEngine engine = manager.getEngineByName("js");
            Object result = engine.eval(output);
            output = String.valueOf(result);
            clear_screen = 1;
            // we store the ouput and now when user presses a number, this will be cleared
            l.setText(output);
        }
        catch(Exception e){
            // if any error occured, this means, there is some input error, like division by 0
            output = "";
            l.setText("Error in input..!!");
        }

    }

    // This will create the UI for the swing application
    public void createUserInterface(){
        // create a textfield and assign some properties
        l = new JTextField(17); 
        l.setPreferredSize(new Dimension(30, 50));
        l.addKeyListener(new CustomKeyListener(this));
        l.setFont(new Font("Arial", Font.PLAIN, 20));
        l.setEditable(false); 
        
        // Add the buttons for both numbers and operands
        for ( int i  =0 ; i < 10 ; i ++){
            numbers.add(new JButton(String.valueOf(i)));
        }   
        for (int i = 0 ; i < ops.length() ; i++){
            operators.add(new JButton("" + ops.charAt(i)));
        }

        // create a new panel 
        JPanel p = new JPanel(); 
        // add text box to panel
        p.add(l); 
        // Add a dummy label to the panel to get a margin between the upper and lower component
        JLabel emptyLabel = new JLabel(" ");
        emptyLabel.setPreferredSize(new Dimension(300, 30));
        p.add(emptyLabel);

        // Now for all the operators, we assign some default initial values
        // Also add key listeners and action listeners to the same
        for(int  i = 0 ; i < operators.size() ; i ++) {
            operators.get(current_operator_index).setBackground(Color.white);
            operators.get(current_operator_index).setForeground(Color.black);
            operators.get(i).setFont(new Font("Arial", Font.PLAIN, 20));
            operators.get(i).setFocusable(false);
            operators.get(i).setPreferredSize(new Dimension(100, 50));
            operators.get(i).addActionListener(this);
            operators.get(i).addKeyListener(new CustomKeyListener(this));
            operators.get(i).setFocusPainted(false);
        }
        operators.get(0).setPreferredSize(new Dimension(300, 50));

        // Now for all the numbers, we assign some default initial values
        // Also add key listeners and action listeners to the same
        for(int  i = 0 ; i < numbers.size() ; i ++) {
            numbers.get(current_operator_index).setBackground(Color.white);
            numbers.get(current_operator_index).setForeground(Color.black);
            numbers.get(i).setFont(new Font("Arial", Font.PLAIN, 20));
            numbers.get(i).setFocusable(false);
            numbers.get(i).setPreferredSize(new Dimension(100, 50));
            numbers.get(i).addActionListener(this);
            numbers.get(i).addKeyListener(new CustomKeyListener(this));
            numbers.get(i).setFocusPainted(false);
        }
        // Add all our content to the panel
        for(int  i = 0 ; i < numbers.size() ; i ++) {
            p.add(numbers.get(i));
        }
        
        // Add a dummy label to the panel to get a margin between the upper and lower component
        JLabel emptyLabelBreak = new JLabel(" ");
        emptyLabelBreak.setPreferredSize(new Dimension(300, 30));
        p.add(emptyLabelBreak);

        // Add the last set of buttons to the panel
        for(int  i = 0 ; i < operators.size() ; i ++) {
            p.add(operators.get(i));
        }
        p.setBackground(Color.black); 
        // Add the frame to the panel and start the application 
        // after setting some propoerties
        f.add(p); 
        f.setSize(350, 550);
        f.setDefaultCloseOperation(EXIT_ON_CLOSE); 
        f.setResizable(false);
        f.requestFocusInWindow();
        f.addKeyListener(new CustomKeyListener(this));
        f.show(); 

        // Keep a timer with a timer tick of 1 second
        // call action listeners after each second
        Timer timer = new Timer(1000,this );
        timer.start();        
        
    }
    // store the output
    String output;

    // constructor used to initiliaze the values    
    CalculatorPartB() 
    { 
        output = "";
    } 
  
    // the main function 
    public static void main(String args[]) 
    { 
        // create a new frame 
        f = new JFrame("Calculator for Differently Abled"); 
  
        try { 
            // try to set look and feel, if some problem arises, show errors
            UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName()); 
        } 
        catch (Exception e) { 
            System.err.println(e.getMessage()); 
        } 
  
        // create an object of our class 
        CalculatorPartB c = new CalculatorPartB(); 
        c.createUserInterface();
    } 
    
    // after every timer tick this function is called
    public void actionPerformed(ActionEvent e) 
    { 
        // we first set the current selected to the defauls
        operators.get(current_operator_index).setBackground(Color.white);
        operators.get(current_operator_index).setForeground(Color.black);

        numbers.get(current_number_index).setBackground(Color.white);
        numbers.get(current_number_index).setForeground(Color.black);

        // Now we increase both the indices for our numbers 
        // as well as operands and take modulo to get next index 
        current_operator_index += 1 ;
        current_operator_index %= ops.length();

        current_number_index += 1 ;
        current_number_index %= 10;

        // we highlight the next selected buttons and change their
        // background and foreground
        operators.get(current_operator_index).setBackground(Color.cyan);
        operators.get(current_operator_index).setForeground(Color.orange);
        numbers.get(current_number_index).setBackground(Color.cyan);
        numbers.get(current_number_index).setForeground(Color.orange);

    } 
} 

// A custom class which contains the keylistener events for our calculator swing application
class CustomKeyListener implements KeyListener{
    CalculatorPartB obj;
    public CustomKeyListener(CalculatorPartB obj){
        // initialize this.obj to the obj passed. 
        // this binding will help us to change the values of the class object
        this.obj = obj;
    }
    public void keyTyped(KeyEvent e) {
    }

    // A function which is fired as soon as some key is pressed
    public void keyPressed(KeyEvent e) {
        // if key pressed is space, this means we have selected an operand
        if(e.getKeyCode() == KeyEvent.VK_SPACE){
            // if we had to clear the screen, do it and reset its value
            if( obj.clear_screen == 1){
                obj.clear_screen = 0;
                obj.output = "";
                obj.l.setText("");
            }
            // we calculate the value which the user has selected
            char element = obj.ops.charAt(obj.current_operator_index);
            // If element is C, we clear the complete screen
            if( element == 'C'){
                obj.output = "";
                obj.l.setText("");
            }
            // If element is =, we evaluate the expression and print the output
            else if( element == '='){
                obj.calculateValueOfTextField();
            }
            // If element is an operation, we push the element to the output
            else{
                obj.output += String.valueOf(element);
                obj.l.setText(obj.output);
            }
        }

        // if key pressed is enter, this means we have selected a number
        else if(e.getKeyCode() == KeyEvent.VK_ENTER){
            // if we had to clear the screen, do it and reset its value
            if( obj.clear_screen == 1){
                obj.output = "";
                obj.l.setText("");
                obj.clear_screen = 0;
            }
            // Since we have selected a number, we simply push this digit to 
            // the output variable
            obj.output += String.valueOf(obj.current_number_index);
            obj.l.setText(obj.output);
        }
    }
    public void keyReleased(KeyEvent e) {
    }   
}
