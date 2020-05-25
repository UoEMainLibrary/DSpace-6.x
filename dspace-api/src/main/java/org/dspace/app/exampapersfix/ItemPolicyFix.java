package org.dspace.app.exampapersfix;

// DSpace imports
import org.apache.commons.collections.CollectionUtils;
import org.dspace.authorize.AuthorizeException;
import org.dspace.authorize.ResourcePolicy;
import org.dspace.authorize.factory.AuthorizeServiceFactory;
import org.dspace.authorize.service.AuthorizeService;
import org.dspace.authorize.service.ResourcePolicyService;
import org.dspace.content.*;
import org.dspace.content.factory.ContentServiceFactory;
import org.dspace.content.service.CollectionService;
import org.dspace.content.service.ItemService;
import org.dspace.core.Constants;
import org.dspace.core.Context;
import org.dspace.eperson.factory.EPersonServiceFactory;
import org.dspace.eperson.service.GroupService;
// Java imports
import java.sql.SQLException;
import java.util.Iterator;
import java.util.List;

/**
 * @author bparkes, Digital Library, University of Edinburgh, 20/05/2020
 * 
 * As a very quick and nasty hack to fix item restrictions on the Exam Papers collection "2014/2015"
 * Copied and edited from rtaylor3's QMU fix: 
 * https://github.com/UoEMainLibrary/DSpace-6.x/blob/qmu/dspace-api/src/main/java/org/dspace/app/QMUfixes/FixQMUResourcePolicies.java
 *
 */
public class ItemPolicyFix {

    private CollectionService collectionService;
    private ItemService itemService;
    private ResourcePolicyService resourcePolicyService; // Might be redundant
    private AuthorizeService authorizeService;
    private GroupService groupService;
    private String READ = "READ";
    private String AUTH_GROUP = "Anonymous";

    private ItemPolicyFix() {
        collectionService = ContentServiceFactory.getInstance().getCollectionService();
        itemService = ContentServiceFactory.getInstance().getItemService();
        resourcePolicyService = AuthorizeServiceFactory.getInstance().getResourcePolicyService();
        authorizeService = AuthorizeServiceFactory.getInstance().getAuthorizeService();
        groupService = EPersonServiceFactory.getInstance().getGroupService();

    }

    public static void main(String[] argv) throws Exception
    {
        ItemPolicyFix fixpolicies = new ItemPolicyFix();
        Context c = new Context();

        // We are superuser!
        c.turnOffAuthorisationSystem();

        fixpolicies.doStuff(c);

        c.complete();
    }

    private void doStuff(Context c) throws Exception {
        List<Collection> allCollections = collectionService.findAll(c);

        for (Collection collection : allCollections) {

            System.out.println("Collection is " + collection.getName());

            if (collection.getName().equals("2014/2015")){
                getItems(c, collection);
            }

        }
    }

    private void getItems(Context c, Collection collection) throws Exception {
        Iterator<Item> itemIterator = itemService.findAllByCollection(c, collection);
        while (itemIterator.hasNext())
        {
            Item item = itemIterator.next();
            getBundles(c, item);
            setItems(c, item);
        }
    }

    private void setItems(Context c, Item i) throws Exception {
        // change item policies
        authorizeService.removeAllPolicies(c, i);
        authorizeService.addPolicy(c, i, Constants.getActionID(READ), groupService.findByName(c, AUTH_GROUP), ResourcePolicy.TYPE_INHERITED);
    }

    private void getBundles(Context c, Item item) throws Exception {
        System.out.println("Updating item " + item.getHandle() + " " + item.getName());

        List<Bundle> bundles = item.getBundles();

        for (Bundle bundle : bundles) {
            System.out.println("Bundle is " + bundle.getName());
            getBitstreams(c, bundle);
            setBundles(c, bundle);
        }
    }

    private void setBundles(Context c, Bundle b) throws Exception {
        // change bundle policies
        authorizeService.removeAllPolicies(c, b);
        authorizeService.addPolicy(c, b, Constants.getActionID(READ), groupService.findByName(c, AUTH_GROUP), ResourcePolicy.TYPE_INHERITED);
    }

    private void getBitstreams(Context c, Bundle bundle) throws SQLException, AuthorizeException {
        List<Bitstream> bitstreams = bundle.getBitstreams();
        if (CollectionUtils.isNotEmpty(bitstreams))
        {
            for (Bitstream bs : bitstreams)
            {
                setBitstreams(c, bs);
            }
        }
    }

        
    private void setBitstreams(Context c, Bitstream bs) throws SQLException, AuthorizeException {
        // change bitstream policies
        authorizeService.removeAllPolicies(c, bs);
        authorizeService.addPolicy(c, bs, Constants.getActionID(READ), groupService.findByName(c, AUTH_GROUP), ResourcePolicy.TYPE_INHERITED);
    }


}
