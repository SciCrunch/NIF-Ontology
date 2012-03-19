import java.io.*;
import java.util.*;
import java.util.Scanner;
import java.io.File;

/**
 * TextFileReader class
 * 
 * @author Michael Aranda
 * @param textfile to read, textfile to print output to
 * @data last modified: February 01, 2012
 */

public class labelFinder{
	
    public static void main(String[] args){
		
		try{
			BufferedReader in = new BufferedReader(new FileReader(args[0]));
			
			FileWriter outFile = new FileWriter(args[1]);
			PrintWriter out = new PrintWriter(outFile);
					
			String line;
			ArrayList encountered = new ArrayList();
      
			while((line = in.readLine()) != null){
        int indexOfColon = line.indexOf(':');
        if(indexOfColon != -1){
           String label = line.substring(0,indexOfColon);
           if(!encountered.contains(label)){
              encountered.add(label);
              out.println(label);
           }
        }
	
			}
		
			out.close();
		} catch (IOException e){
			e.printStackTrace();
		}
		
	}

}