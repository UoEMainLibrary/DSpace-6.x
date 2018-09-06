package org.dspace.app.QMUfixes;

import org.dspace.content.DCDate;
import org.dspace.content.Item;
import org.dspace.content.MetadataValue;
import org.dspace.content.factory.ContentServiceFactory;
import org.dspace.content.service.ItemService;
import org.dspace.content.service.MetadataValueService;
import org.dspace.core.Context;
import org.dspace.handle.factory.HandleServiceFactory;
import org.dspace.handle.service.HandleService;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;

public class FixQMUAuthorOrder {
    private ItemService itemService;
    private MetadataValueService metadataValueService;
    private HandleService handleService;
    private int itemCount = 0;


    private FixQMUAuthorOrder() {
        itemService = ContentServiceFactory.getInstance().getItemService();
        metadataValueService = ContentServiceFactory.getInstance().getMetadataValueService();
        handleService = HandleServiceFactory.getInstance().getHandleService();


    }


    public static void main(String[] argv) throws Exception {
        FixQMUAuthorOrder fixqmuuri = new FixQMUAuthorOrder();
        Context c = new Context();

        // We are superuser!
        c.turnOffAuthorisationSystem();

        fixqmuuri.doStuff(c);

        c.complete();
    }

    private void doStuff(Context c) throws Exception {
        Iterator<Item> itemIterator = itemService.findAll(c);
        while (itemIterator.hasNext()) {
            getMetadata(c, itemIterator.next());
        }

        System.out.println("Number of items changed " + itemCount);
    }

    private void getMetadata(Context c, Item item) throws Exception {
        String title = itemService.getMetadata(item, "dc", "title", Item.ANY, Item.ANY).get(0).getValue();
        String dateAccessioned = itemService.getMetadata(item, "dc", "date", "accessioned", Item.ANY).get(0).getValue();

        List<MetadataValue> citations = itemService.getMetadata(item, "dc", "identifier", "citation", Item.ANY);


        List<MetadataValue> authors = itemService.getMetadata(item, "dc", "contributor", "author", Item.ANY);


        if (!citations.isEmpty()) {
            String citation = itemService.getMetadata(item, "dc", "identifier", "citation", Item.ANY).get(0).getValue();


            // Only 'fix' items that have multiple authors and were imported from eprints
            if ((authors.size() > 1) && (dateAccessioned.compareTo("2018-08-03T00:00:00Z") < 0)) {
            //if ((authors.size() > 1) && (!authors.get(0).getValue().substring(0, 2).equals(citation.substring(0, 2)))) {

                itemCount++;

                System.out.println("");
                System.out.println(title);
                System.out.println("");

                String[] authorsCopy = new String[authors.size()];

                // Before
                for (int i = 0; i < authors.size(); i++) {
                    System.out.println(authors.get(i).getPlace() + " " + authors.get(i).getValue());

                    // Save the original authors names
                    authorsCopy[i] = authors.get(i).getValue();
                }

                // Move the first author to be the last and shuffle the rest forward
                for (int i = 0; i < authors.size(); i++) {
                    MetadataValue author = authors.get(i);

                    if (i < (authors.size() - 1)) {
                        // Shuffle one forward
                        author.setValue(authorsCopy[i + 1]);
                    } else {
                        // Its the last one so set it to the first value
                        author.setValue(authorsCopy[0]);
                    }

                    //System.out.println(author.toString());
                    metadataValueService.update(c, author, true);
                    c.uncacheEntity(author);
                }

                // After
                for (int i = 0; i < authors.size(); i++) {
                    System.out.println(authors.get(i).getPlace() + " " + authors.get(i).getValue());
                }
            }

        }
    }


}
