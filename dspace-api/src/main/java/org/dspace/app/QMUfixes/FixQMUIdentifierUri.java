package org.dspace.app.QMUfixes;

import org.dspace.content.Item;
import org.dspace.content.MetadataValue;
import org.dspace.content.service.MetadataValueService;
import org.dspace.core.Context;
import org.dspace.content.factory.ContentServiceFactory;
import org.dspace.content.service.CollectionService;
import org.dspace.content.service.ItemService;
import org.dspace.handle.factory.HandleServiceFactory;
import org.dspace.handle.service.HandleService;

import java.sql.SQLException;
import java.util.Iterator;
import java.util.List;

public class FixQMUIdentifierUri {
    private ItemService itemService;
    private MetadataValueService metadataValueService;
    private HandleService handleService;


    private FixQMUIdentifierUri() {
        itemService = ContentServiceFactory.getInstance().getItemService();
        metadataValueService = ContentServiceFactory.getInstance().getMetadataValueService();
        handleService = HandleServiceFactory.getInstance().getHandleService();


    }


    public static void main(String[] argv) throws Exception
    {
        FixQMUIdentifierUri fixqmuuri = new FixQMUIdentifierUri();
        Context c = new Context();

        // We are superuser!
        c.turnOffAuthorisationSystem();

        fixqmuuri.doStuff(c);

        c.complete();
    }

    private void doStuff(Context c) throws Exception {
        Iterator<Item> itemIterator = itemService.findAll(c);
        while (itemIterator.hasNext())
        {
            getMetadata(c, itemIterator.next());
        }
    }

    private void getMetadata(Context c, Item item) throws SQLException {
        // Get the handle for the item
        String handle = handleService.findHandle(c, item);

        // Now get the dc.identifier.uri values for the item
        List<MetadataValue> metadataValues = itemService.getMetadata(item, "dc", "identifier", "uri", Item.ANY);

        for (MetadataValue metadataValue : metadataValues) {

            if (metadataValue.getValue().contains("lac-sdlc")) {

                System.out.println("Old id is " + metadataValue.getValue());
                System.out.println("New id is " + "https://eresearch.qmu.ac.uk/handle/" + handle);
                System.out.println();

                metadataValue.setValue("https://eresearch.qmu.ac.uk/handle/" + handle);
                metadataValueService.update(c, metadataValue);

                // Don't know what this does, but the code was copied from UpdateHandlePrefix so I'll leave it in
                c.uncacheEntity(metadataValue);

            }

        }


    }

}
