package org.dspace.storage.bitstore;
import org.apache.commons.cli.*;
import org.apache.log4j.Logger;
import org.dspace.content.Bitstream;
import org.dspace.content.factory.ContentServiceFactory;
import org.dspace.content.service.BitstreamService;
import org.dspace.content.Bundle;
import org.dspace.content.DSpaceObject;
import org.dspace.content.Item;
import org.dspace.core.Constants;
import org.dspace.core.Context;
import org.dspace.eperson.EPerson;
import org.dspace.eperson.service.EPersonService;
import org.dspace.eperson.factory.EPersonServiceFactory;
import java.io.BufferedReader;
import java.io.IOException;
import java.nio.charset.Charset;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.SQLException;
import java.util.List;

/**
 * User: Robin Taylor
 * Date: 31/03/2016
 * Time: 10:48
 */
public class DeleteUnwantedBitstreams {
    private static Logger log = Logger.getLogger(DeleteUnwantedBitstreams.class);

    private static String eperson;
    private static String filename;
    private static EPersonService ePersonService = EPersonServiceFactory.getInstance().getEPersonService();
    private static BitstreamService bitstreamService = ContentServiceFactory.getInstance().getBitstreamService();

    /**
     * Given a list of unwanted bitstream ids, this class will cause them to be marked as deleted. This is the normal
     * practice for 'deleting' bitstreams.
     *
     * Background - St Andrews added lots of placeholder files back in the day when DSpace insisted you upload a file.
     *
     */
    public static void main(String[] argv)
    {
        try
        {
            log.info("Deleting unwanted bitstreams");
            // set up command line parser
            CommandLineParser parser = new PosixParser();
            CommandLine line = null;
            // create an options object and populate it
            Options options = new Options();
            options.addOption("e", "eperson", true, "A valid DSpace eperson");
            options.addOption("f", "filename", true, "The file containing a list of bitstream ids to be deleted");

            options.addOption("d", "dummy", false, "A dummy run that doesn't actually commit the changes");
            options.addOption("v", "verbose", false, "Provide verbose output");
            options.addOption("h", "help", false, "Help");
            try
            {
                line = parser.parse(options, argv);
            }
            catch (ParseException e)
            {
                log.fatal(e);
                System.exit(1);
            }

            if (line.hasOption('e'))
            {
                eperson = line.getOptionValue('e');
            } else {
                System.out.println("You need to specify a valid eperson");
                System.exit(1);
            }
            if (line.hasOption('f'))
            {
                filename = line.getOptionValue('f');
            } else {
                System.out.println("You need to specify a filename");
                System.exit(1);
            }


            // user asks for help
            if (line.hasOption('h'))
            {
                printHelp(options);
                System.exit(0);
            }
            boolean dummyRun = false;
            // Prune stage
            if (line.hasOption('d'))
            {
                log.info("option d used so its a dummy run");
                dummyRun = true;
            }
            doStuff(dummyRun);
            System.exit(0);
        }
        catch (Exception e)
        {
            log.fatal("Caught exception:", e);
            System.exit(1);
        }
    }
    private static void printHelp(Options options)
    {
        HelpFormatter myhelp = new HelpFormatter();
        myhelp.printHelp("DeleteUnwantedBitstreams\n", options);
    }
    private static void doStuff(boolean dummyRun) throws Exception {
        Context context = new Context();

        EPerson myEPerson = null;
        if (eperson.indexOf('@') != -1)
        {
            // @ sign, must be an email
            myEPerson = ePersonService.findByEmail(context, eperson);
        }
        else // This was a search of int, so id?
        {
            myEPerson = ePersonService.findByNetid(context, eperson);
        }
        if (myEPerson == null)
        {
            System.out.println("Error, eperson cannot be found: " + eperson);
            System.exit(1);
        }
        context.setCurrentUser(myEPerson);
        Path file = Paths.get(filename);
        Charset charset = Charset.forName("US-ASCII");
        BufferedReader reader = Files.newBufferedReader(file, charset);
        String line = null;
        while ((line = reader.readLine()) != null) {
            log.info("Delete bitstream id " + line);
            deleteBitstream(context, Integer.parseInt(line));
        }
        if (!dummyRun) {
            context.complete();
        }
    }
    private static void deleteBitstream(Context context, int bitstreamID) throws Exception {
        Bitstream bitstream;
        try
        {
            //bitstream = Bitstream.find(context, bitstreamID);
            bitstream = bitstreamService.findByLegacyId(context, bitstreamID);
        }
        catch (NumberFormatException nfe)
        {
            throw new Exception("NumberFormatException retrieving bitstream");
        }
        if (bitstream == null)
        {
            throw new Exception("Bitstream is null");
        }
        Item item;

        if (bitstreamService.getParentObject(context, bitstream).getType() == Constants.ITEM) {
            item = (Item) bitstreamService.getParentObject(context, bitstream);
        } else {
            throw new Exception("Parent object of bitstream is not an item");
        }
        // Remove bitstream from bundle

        List<Bundle> bundles = bitstream.getBundles();
        bundles.get(0).removeBitstream(bitstream);
        // Remove bundle if it's now empty
        List<Bitstream> bitstreams = bundles.get(0).getBitstreams();
        if (bitstreams.size() < 1)
        {
            item.getItemService().removeBundle(context, item, bundles.get(0));
            //item.removeBundle(bundles[0]);
            item.getItemService().update(context, item);
            //item.update();
        }
    }
}