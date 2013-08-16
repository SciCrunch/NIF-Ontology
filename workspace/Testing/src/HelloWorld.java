import java.io.*; 
class MyFirstProgram {
  /** Print a hello message */ 
  public static void main(String[] args) { 
    BufferedReader in = 
        new BufferedReader(new InputStreamReader(System.in)); 
    String name = "Instructor"; 
    System.out.print("Give your name: "); 
    try {name = in.readLine();}
        catch(Exception e) {
           System.out.println("Caught an exception!"); 
        }
    System.out.println("Hello " + name + "!"); 
  }
}
