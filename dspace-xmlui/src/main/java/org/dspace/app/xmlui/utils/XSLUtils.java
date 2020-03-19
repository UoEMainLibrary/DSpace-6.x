/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.app.xmlui.utils;

import org.dspace.authorize.AuthorizeException;
import org.dspace.content.Bitstream;
import org.dspace.content.Bundle;
import org.dspace.content.DSpaceObject;
import org.dspace.content.Item;
import org.dspace.content.factory.ContentServiceFactory;
import org.dspace.content.service.ItemService;
import org.dspace.core.Context;
import org.dspace.handle.factory.HandleServiceFactory;
import org.dspace.handle.service.HandleService;

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

}
