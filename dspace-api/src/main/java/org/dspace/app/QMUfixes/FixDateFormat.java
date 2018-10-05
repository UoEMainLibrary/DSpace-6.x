package org.dspace.app.QMUfixes;

import org.dspace.content.Item;
import org.dspace.content.MetadataValue;
import org.dspace.content.factory.ContentServiceFactory;
import org.dspace.content.service.ItemService;
import org.dspace.content.service.MetadataValueService;
import org.dspace.core.Context;
import org.dspace.handle.factory.HandleServiceFactory;
import org.dspace.handle.service.HandleService;

import java.sql.SQLException;
import java.util.Iterator;
import java.util.List;

public class FixDateFormat {
    private ItemService itemService;
    private MetadataValueService metadataValueService;
    private HandleService handleService;
    private int itemCount;


    private FixDateFormat() {
        itemService = ContentServiceFactory.getInstance().getItemService();
        metadataValueService = ContentServiceFactory.getInstance().getMetadataValueService();
        handleService = HandleServiceFactory.getInstance().getHandleService();


    }


    public static void main(String[] argv) throws Exception
    {
        FixDateFormat fixDateFormat = new FixDateFormat();
        Context c = new Context();

        // We are superuser!
        c.turnOffAuthorisationSystem();

        fixDateFormat.doStuff(c);

        c.complete();
    }

    private void doStuff(Context c) throws Exception {

        itemCount=0;

        Iterator<Item> itemIterator = itemService.findAll(c);
        while (itemIterator.hasNext())
        {
            getMetadata(c, itemIterator.next());
        }

        System.out.println("Item count is " + itemCount);
    }

    private void getMetadata(Context c, Item item) throws SQLException {
        // Get the handle for the item
        String handle = handleService.findHandle(c, item);

        // Now get the dc.identifier.uri values for the item
        List<MetadataValue> metadataValues = itemService.getMetadata(item, "dc", "date", "issued", Item.ANY);

        for (MetadataValue metadataValue : metadataValues) {

            if (metadataValue.getValue().contains("/")) {

                itemCount++;

                System.out.println("Item is " + handle);
                System.out.println("Old date is " + metadataValue.getValue());

                String oldDate = metadataValue.getValue();
                String dd = oldDate.substring(0,2);
                String mm = oldDate.substring(3,5);
                String yyyy = oldDate.substring(6);

                if (yyyy.length() == 2) {
                    System.out.println("No Century !!!!!!!!! " + metadataValue.getValue());

                    if (Integer.valueOf(yyyy) > 50) {
                        yyyy = "19" + yyyy;
                    } else {
                        yyyy = "20" + yyyy;
                    }
                }

                String newDate = String.format("%s-%s-%s", yyyy, mm, dd);

                System.out.println("New date is " + newDate);
                System.out.println();

                metadataValue.setValue(newDate);
                metadataValueService.update(c, metadataValue);

                // Don't know what this does, but the code was copied from UpdateHandlePrefix so I'll leave it in
                c.uncacheEntity(metadataValue);

            }

        }


    }

}
