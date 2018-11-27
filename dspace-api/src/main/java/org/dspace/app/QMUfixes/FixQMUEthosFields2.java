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
public class FixQMUEthosFields2 {
    private CommunityService communityService;
    private CollectionService collectionService;
    private ItemService itemService;
    private MetadataFieldService metadataFieldService;
    private MetadataValueService metadataValueService;
    private int itemCount;


    private FixQMUEthosFields2() {
        communityService = ContentServiceFactory.getInstance().getCommunityService();
        collectionService = ContentServiceFactory.getInstance().getCollectionService();
        itemService = ContentServiceFactory.getInstance().getItemService();
        metadataFieldService = ContentServiceFactory.getInstance().getMetadataFieldService();
        metadataValueService = ContentServiceFactory.getInstance().getMetadataValueService();

    }

    public static void main(String[] argv) throws Exception
    {
        FixQMUEthosFields2 fixQMUEthosFields = new FixQMUEthosFields2();
        Context c = new Context();

        // We are superuser!
        c.turnOffAuthorisationSystem();

        fixQMUEthosFields.doStuff(c);

        c.complete();
    }

    private void doStuff(Context c) throws Exception {
        UUID uuid = UUIDUtils.fromString("792776fa-e057-425b-84da-e6cf58af8a53");
        Community community = communityService.find(c, uuid);

        if (!community.getName().equals("Professional Doctorate theses")) {
            throw new Exception("We didn't successfully find the Professional Doctorate theses Community");
        }

        itemCount=0;

        List<Collection> allCollections = communityService.getAllCollections(c, community);

        for (Collection collection : allCollections) {
            System.out.println("Collection is " + collection.getName());

            getItems(c, collection);

        }

        System.out.println("Item count is " + itemCount);
    }

    private void getItems(Context c, Collection collection) throws Exception {
        Iterator<Item> itemIterator = itemService.findAllByCollection(c, collection);
        while (itemIterator.hasNext())
        {
            fixMetadata(c, itemIterator.next());
        }
    }

    private void fixMetadata(Context c, Item item) throws Exception {
        itemCount++;

        System.out.println("Item is " + item.getHandle());

        List<MetadataValue> types = itemService.getMetadata(item, "dc", "type", null, Item.ANY);

        if (types.isEmpty()) {
            throw new Exception("Item " + item.getHandle() + " has no type");
        }

        if (types.size() > 1) {
            throw new Exception("Item " + item.getHandle() + " has more than one type");
        }

        if (!types.get(0).getValue().equals("Thesis")) {
            throw new Exception("Item " + item.getHandle() + " has type " + types.get(0).getValue());
        }

        MetadataField metadataField1 = metadataFieldService.findByElement(c,"dc", "type", "qualificationlevel");
        MetadataValue metadataValue1 = metadataValueService.create(c,item, metadataField1);
        metadataValue1.setValue("Doctoral");
        metadataValueService.update(c, metadataValue1);

        // Don't know what this does, but the code was copied from UpdateHandlePrefix so I'll leave it in
        c.uncacheEntity(metadataValue1);


        MetadataField metadataField2 = metadataFieldService.findByElement(c,"dc", "type", "qualificationname");
        MetadataValue metadataValue2 = metadataValueService.create(c,item, metadataField2);
        metadataValue2.setValue("Professional Doctorate");
        metadataValueService.update(c, metadataValue2);

        // Don't know what this does, but the code was copied from UpdateHandlePrefix so I'll leave it in
        c.uncacheEntity(metadataValue2);


    }
}
