package org.dspace.pure;

import java.io.*;
import java.sql.SQLException;
import java.util.*;

import com.google.common.collect.Iterators;

import org.apache.log4j.Logger;

import org.dspace.authorize.AuthorizeException;
import org.dspace.content.Collection;
import org.dspace.content.Community;
import org.dspace.content.DSpaceObject;
import org.dspace.content.Item;
import org.dspace.content.MetadataSchema;
import org.dspace.content.factory.ContentServiceFactory;
import org.dspace.content.service.CollectionService;
import org.dspace.content.service.ItemService;
import org.dspace.core.Context;
import org.dspace.handle.dao.HandleDAO;
import org.dspace.handle.factory.HandleServiceFactory;

public class Mapper 
{

    private static Map<String, String> colMap = new HashMap<String, String>();
    private static BufferedReader br;
    private static String instPath = "/home/lib/dspace/pure-mapping/AURACollectionMapping.txt";
    private static String communityID = "2164/705";
    private static DSpaceObject dso;
    private static Context context;
    private static CollectionService collectionService = ContentServiceFactory.getInstance().getCollectionService();
    protected ItemService itemService;
    static Iterator<Item> result = null;
    protected static HandleDAO handleDAO;
    private static final Logger logger = Logger.getLogger(Mapper.class);

    public static void main(String[] args) throws Exception  
    {  
        Mapper mpr = new Mapper();
        mpr.populateCollectionMap();
        mpr.setContext();
        dso = HandleServiceFactory.getInstance().getHandleService().resolveToObject(context, communityID);
        mpr.getCollectionItems((Community)dso);
        mpr.updateItemCollection();
    }

    protected Mapper() throws Exception
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

    public void setContext() throws Exception
    {
        // Create a context
        try
        {
            context = new Context();
            context.turnOffAuthorisationSystem();
        }
        catch (Exception e)
        {
            System.err.println("Unable to create a new DSpace Context: " + e.getMessage());
            System.exit(1);
            return;
        }
    }

    protected Iterator<Item> getCollectionItems(Community community) throws SQLException
    {
        // Add all the collections
        List<Collection> collections = community.getCollections();
        itemService = ContentServiceFactory.getInstance().getItemService();
        for (Collection collection : collections)
        {
            Iterator<Item> items = itemService.findByCollection(context, collection);
            result = addItemsToResult(result,items);
        }
        // Add all the sub-communities
        List<Community> communities = community.getSubcommunities();
        for (Community subCommunity : communities)
        {
            for (int i = 0; i < communities.size(); i++)
            {
                System.out.print(" ");
            }
            Iterator<Item> items = getCollectionItems(subCommunity);
            result = addItemsToResult(result,items);
        }
        return result;
    }

    private Iterator<Item> addItemsToResult(Iterator<Item> result, Iterator<Item> items) 
    {
        if(result == null)
        {
            result = items;
        }else{
            result = Iterators.concat(result, items);
        }
        return result;
    }

    public void updateItemCollection() throws SQLException, AuthorizeException
    {
        while (result.hasNext())
        {
            Item item = result.next();
            String institution = item.getItemService().getMetadataFirstValue(item, MetadataSchema.DC_SCHEMA, "contributor", "institution", Item.ANY);
            try
                {
                    String colHandle = colMap.get(institution).toString();
                    DSpaceObject dso = HandleServiceFactory.getInstance().getHandleService().resolveToObject(context, colHandle);
                    collectionService.addItem(context, (Collection)dso, item);
                    logger.info("\""+item.getName()+"\" has been mapped to: \""+dso.getName()+"\"");
                }
                catch (Exception e)
                {
                    logger.info("\""+item.getName()+"\" has no dc.contibutor.institution metadata. Item was not mapped to an owning collection");
                }
                if(result.hasNext()==false){
                    logger.info("MAPPER WHILE LOOP BREAK");
                    break;
                }
        }
        context.complete();
        logger.info("All Research items mapped to dc.contibutor.institution owning collections");
    }
}
