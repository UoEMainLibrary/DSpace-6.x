/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.app.xmlui.utils;

import org.dspace.content.Bitstream;
import org.dspace.content.Bundle;
import org.dspace.content.Item;
import org.dspace.content.factory.ContentServiceFactory;
import org.dspace.content.service.ItemService;
import org.dspace.core.Context;
import org.dspace.handle.factory.HandleServiceFactory;
import org.dspace.handle.service.HandleService;

import java.util.*;
import java.util.regex.*;

import java.sql.SQLException;

/**
 * Utilities that are needed in XSL transformations.
 *
 * @author Art Lowel (art dot lowel at atmire dot com)
 */
public class XSLUtils {


    protected HandleService handleService = HandleServiceFactory.getInstance().getHandleService();
    protected ItemService itemService = ContentServiceFactory.getInstance().getItemService();

    /*
     * Cuts off the string at the space nearest to the targetLength if there is one within
     * maxDeviation chars from the targetLength, or at the targetLength if no such space is
     * found
     */
    public static String shortenString(String string, int targetLength, int maxDeviation) {
        targetLength = Math.abs(targetLength);
        maxDeviation = Math.abs(maxDeviation);
        if (string == null || string.length() <= targetLength + maxDeviation)
        {
            return string;
        }


        int currentDeviation = 0;
        while (currentDeviation <= maxDeviation) {
            try {
                if (string.charAt(targetLength) == ' ')
                {
                    return string.substring(0, targetLength) + " ...";
                }
                if (string.charAt(targetLength + currentDeviation) == ' ')
                {
                    return string.substring(0, targetLength + currentDeviation) + " ...";
                }
                if (string.charAt(targetLength - currentDeviation) == ' ')
                {
                    return string.substring(0, targetLength - currentDeviation) + " ...";
                }
            } catch (Exception e) {
                //just in case
            }

            currentDeviation++;
        }

        return string.substring(0, targetLength) + " ...";

    }

    /***
     * This function was lifted from
     * dspace-api/src/main/java/org/dspace/ctask/general/BitstreamsIntoMetadata.java
     *
     * It looks up an item by handle from XSL
     * @param handle
     * @return
     */

    public String getBitstreamInfo(String handle)
    {
        // The results that we'll return
        StringBuilder results = new StringBuilder();

        try {
            Item item = (Item) handleService.resolveToObject(new Context(), handle);

            for (Bundle bundle : item.getBundles()) {
                if ("ORIGINAL".equals(bundle.getName())) {
                    for (Bitstream bitstream : bundle.getBitstreams()) {
                        String bitstreamname = bitstream.getName();

                        if(bitstreamname.endsWith("pdf"))
                            return bitstreamname + "?sequence=" + bitstream.getSequenceID() + "&amp;isAllowed=y";

                    }
                }
            }
        }   catch (SQLException sqle) {

        }

        return results.toString();
    }

    private int getKeyByValue(Map<Integer, String> map, String value) {
        for (Map.Entry<Integer, String> entry : map.entrySet()) {
            if (Objects.equals(value, entry.getValue())) {
                return entry.getKey();
            }
        }
        return -1;
    }

    public String removeFilter(String url, String facets)
    {
        // The results that we'll return
        StringBuilder results = new StringBuilder();
        String[] facet_list = facets.trim().split("\\s*,\\s*");

        // Two groups to match, property and value
        Pattern p = Pattern.compile("([^|&][^=]+)=([^&]+)");
        Matcher m = p.matcher(url);

        // Data collections to store values, maps and not arrays
        // because we don't know the order in the query string
        // and we need to retain the id number with each value
        Map<Integer, String> filtertypes = new HashMap<Integer, String>();
        Map<Integer, String> relational_operators = new HashMap<Integer, String>();
        Map<Integer, String> values = new HashMap<Integer, String>();

        // Populate internal data structures
        // so we can pick the correct values to remove
        while(m.find()) {
            String prop = m.group(1);
            // minus one because query string will start with 0
            int index = -1;

            // This will fail in the first attempt and will also match the relational operator
            // keeping -1 as the value is what we want in the event
            try {
                index = Integer.parseInt(prop.substring(prop.lastIndexOf("_")+1));

            }
            catch (NumberFormatException | StringIndexOutOfBoundsException ignored)   {

            }

            // Assign value to correct data structure
            if(prop.contains("type"))
                filtertypes.put(index, m.group(2));
            else if(prop.contains("relational"))
                relational_operators.put(index, m.group(2));
            else
                values.put(index, m.group(2));

        }

        // Rejoin the data structures to form a query string and return it

        // need to first to collect ids to remove before removing to avoid a ConcurrentModificationException
        // https://www.baeldung.com/java-concurrentmodificationexception

        ArrayList<Integer> removes = new ArrayList<>();

        for (String filtertype : filtertypes.values()) {
            if (!Arrays.asList(facet_list).contains(filtertype))
                removes.add(getKeyByValue(filtertypes, filtertype));
        }

        for(int filter: removes)
            filtertypes.remove(filter);

        int index = -1;

        for (Map.Entry<Integer, String> entry : filtertypes.entrySet()) {
            if (index == -1) {
                // special case in first loop
                results.append("?filtertype=").append(entry.getValue());
                results.append("&filter_relational_operator=").append(relational_operators.get(entry.getKey()));
                results.append("&filter=").append(values.get(entry.getKey()));

            } else {
                // append the index int we are incrementing and NOT use the associated key because
                // removing one entry has (maybe) created a gap
                results.append("&filtertype_").append(index).append("=").append(filtertypes.get(entry.getKey()));
                results.append("&filter_relational_operator_").append(index).append("=").append(relational_operators.get(entry.getKey()));
                results.append("&filter_").append(index).append("=").append(values.get(entry.getKey()));
            }
            index += 1;
        }

        return "discover" + results.toString();

    }

}

