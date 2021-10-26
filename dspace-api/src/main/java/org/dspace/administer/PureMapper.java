package org.dspace.administer;

import java.io.*;
import java.util.*;
import org.apache.commons.cli.*;
import org.apache.commons.cli.CommandLine;
import org.apache.commons.cli.PosixParser;

public class PureMapper 
{

    private static Map<String, String> colMap = new HashMap<String, String>();
    private static BufferedReader br;
    private static String instPath = "../../../../../../../pure-mapping/StAndrewsCollectionMapping.txt";

    public static void main(String[] args) throws Exception  
    {  
        CommandLineParser parser = new PosixParser();
        Options options = new Options();
        options.addOption("m", "map",   true, "map items to owning collection");
        CommandLine input = parser.parse(options, args);

        PureMapper pm = new PureMapper();

        if(input.hasOption("m"))
        {
            pm.populateCollectionMap();
        }

        // Read in institution metadata from file
        br = new BufferedReader(new FileReader(instPath));
        String line =  null;
        while((line=br.readLine())!=null)
        {
            // Split input at new line
            String instMeta[] = line.split("\\r?\\n");
            // Loop through new lines and extract institution (key) and handle (value) Strings
            for(int i=0;i<instMeta.length;i++)
            {
                String instFormat = instMeta[i].replaceAll("\"", "");
                String instMetaSplit[] = instFormat.split(";");
                // Map key:value to collection map
                colMap.put(instMetaSplit[0], instMetaSplit[1]);
            }
        }
    }

    protected PureMapper() throws Exception
    {
    }

    public void populateCollectionMap() throws Exception
    {
        br = new BufferedReader(new FileReader(instPath));
        String line =  null;
        while((line=br.readLine())!=null)
        {
            // Split input at new line
            String instMeta[] = line.split("\\r?\\n");
            // Loop through new lines and extract institution (key) and handle (value) Strings
            for(int i=0;i<instMeta.length;i++)
            {
                String instFormat = instMeta[i].replaceAll("\"", "");
                String instMetaSplit[] = instFormat.split(";");
                // Map key:value Strings to collection HashMap
                colMap.put(instMetaSplit[0], instMetaSplit[1]);
            }
        }
    }

    public static void printCollectionMap()
    {
        int count = 1;
        for (String institution : colMap.keySet()){
            String key = institution.toString();
            String value = colMap.get(institution).toString();
            System.out.println(count+": "+key+" - "+value);
            count++;
        }
    }

}
