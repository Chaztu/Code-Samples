/* 
 * A program that converts an adjacency matrix to an adjacency list
 */

import java.io.*;

public class matrix2list{
    
    public static void main(String[] args) throws IOException{
        
        // Init
        BufferedReader br = new BufferedReader(new FileReader("matrix.txt"));        
        BufferedWriter bw = new BufferedWriter(new FileWriter("list.txt"));
        String str;
        String[] line;
        
        // Split each line in matrix.txt with comma as delimiter        
        while((str = br.readLine()) != null){
            line = str.split(",");
            str = "";
            
            // If '1' found, store index
            for(int i = 0; i < line.length; i++){
                if(line[i].charAt(0) == '1')
                    str += i + ",";
            }
            
            // Remove closing comma
            if (str.charAt(str.length() - 1) == ',')
                str = str.substring(0, str.length() - 1);
            
            // Write to file
            bw.write(str);
            bw.newLine();
        }
        // Close readers and writers
        bw.close();
        br.close();
    }
}

