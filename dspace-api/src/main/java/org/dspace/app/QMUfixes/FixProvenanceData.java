package org.dspace.app.QMUfixes;

import org.dspace.content.*;
import org.dspace.content.factory.ContentServiceFactory;
import org.dspace.content.service.*;
import org.dspace.core.Context;
import org.dspace.util.UUIDUtils;

import java.util.Iterator;
import java.util.List;
import java.util.UUID;

/**
 * Created by rtaylor3 on 15/08/2018.
 *
 *
 */
public class FixProvenanceData {
    private CommunityService communityService;
    private CollectionService collectionService;
    private ItemService itemService;
    private MetadataFieldService metadataFieldService;
    private MetadataValueService metadataValueService;
    private int itemCount;


    private FixProvenanceData() {
        communityService = ContentServiceFactory.getInstance().getCommunityService();
        collectionService = ContentServiceFactory.getInstance().getCollectionService();
        itemService = ContentServiceFactory.getInstance().getItemService();
        metadataFieldService = ContentServiceFactory.getInstance().getMetadataFieldService();
        metadataValueService = ContentServiceFactory.getInstance().getMetadataValueService();

    }

    public static void main(String[] argv) throws Exception
    {
        FixProvenanceData fixProvenanceData = new FixProvenanceData();
        Context c = new Context();

        // We are superuser!
        c.turnOffAuthorisationSystem();

        fixProvenanceData.doStuff(c);

        c.complete();
    }

    private void doStuff(Context c) throws Exception {

        itemCount=0;

        getItems(c);

        System.out.println("Item count is " + itemCount);
    }

    private void getItems(Context c) throws Exception {
        Iterator<Item> itemIterator = itemService.findAll(c);

        while (itemIterator.hasNext())
        {
            fixMetadata(c, itemIterator.next());
        }
    }

    private void fixMetadata(Context c, Item item) throws Exception {
        List<MetadataValue> mvs = itemService.getMetadata(item, "dc", "provenance", null, Item.ANY);

        for (MetadataValue mv : mvs) {
            if (mv.getValue().equals("Imported from Eprints to DSpace on 31/07/2018")) {

                itemCount++;
                System.out.println("Item is " + item.getHandle());

                // First, readd the provenance data but in the right field.
                MetadataField metadataField1 = metadataFieldService.findByElement(c,"dc", "description", "provenance");
                MetadataValue metadataValue1 = metadataValueService.create(c,item, metadataField1);
                metadataValue1.setValue("Imported from Eprints to DSpace on 31/07/2018");
                metadataValueService.update(c, metadataValue1);

                // Don't know what this does, but the code was copied from UpdateHandlePrefix so I'll leave it in
                c.uncacheEntity(metadataValue1);

            }
        }
    }
}
