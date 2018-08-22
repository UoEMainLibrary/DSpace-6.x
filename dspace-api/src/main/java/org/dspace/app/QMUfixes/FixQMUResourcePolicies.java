package org.dspace.app.QMUfixes;

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

import java.sql.SQLException;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;

/**
 * Created by rtaylor3 on 15/08/2018.
 *
 * As a very quick and nasty hack to stop general access to theses in the postgrad and undergrad communities, all policies relating
 * to bitstreams in those communities were deleted. This prog will look for collections that need to be restricted to group LDAP_GROUP,
 * delete any existing policies for bundles and bitstreams in that group, then add new ones that are restricted to LDAP_GROUP.
 *
 */
public class FixQMUResourcePolicies {

    private CollectionService collectionService;
    private ItemService itemService;
    private ResourcePolicyService resourcePolicyService;
    private AuthorizeService authorizeService;
    private GroupService groupService;
    private String LDAP_GROUP = "READ_LDAP";

    private FixQMUResourcePolicies() {
        collectionService = ContentServiceFactory.getInstance().getCollectionService();
        itemService = ContentServiceFactory.getInstance().getItemService();
        resourcePolicyService = AuthorizeServiceFactory.getInstance().getResourcePolicyService();
        authorizeService = AuthorizeServiceFactory.getInstance().getAuthorizeService();
        groupService = EPersonServiceFactory.getInstance().getGroupService();

    }

    public static void main(String[] argv) throws Exception
    {
        FixQMUResourcePolicies fixqmurps = new FixQMUResourcePolicies();
        Context c = new Context();

        // We are superuser!
        c.turnOffAuthorisationSystem();

        fixqmurps.doStuff(c);

        c.complete();
    }

    private void doStuff(Context c) throws Exception {
        List<Collection> allCollections = collectionService.findAll(c);

        for (Collection collection : allCollections) {
            System.out.println("Collection is " + collection.getName());
            List <ResourcePolicy> resourcePolicies = collection.getResourcePolicies();

            for (ResourcePolicy resourcePolicy : resourcePolicies) {
                if(resourcePolicy.getAction() == Constants.getActionID("DEFAULT_BITSTREAM_READ")) {
                    System.out.println(resourcePolicy.getAction() + " , " + resourcePolicy.getGroup().getName());

                    if (resourcePolicy.getGroup().getName().equals(LDAP_GROUP)) {
                        getItems(c, collection);
                    }
                }
            }
        }
    }

    private void getItems(Context c, Collection collection) throws Exception {
        Iterator<Item> itemIterator = itemService.findAllByCollection(c, collection);
        while (itemIterator.hasNext())
        {
            getBundles(c, itemIterator.next());
        }
    }

    private void getBundles(Context c, Item item) throws SQLException, AuthorizeException {
        System.out.println("Updating item " + item.getHandle() + " " + item.getName());

        List<Bundle> bundles = item.getBundles();

        for (Bundle bundle : bundles) {
            System.out.println("Bundle is " + bundle.getName());
            getBitstreams(c, bundle);
        }
    }

    private void getBitstreams(Context c, Bundle bundle) throws SQLException, AuthorizeException {
        List<Bitstream> bitstreams = bundle.getBitstreams();
        if (CollectionUtils.isNotEmpty(bitstreams))
        {
            for (Bitstream bs : bitstreams)
            {
                // change bitstream policies
                authorizeService.removeAllPolicies(c, bs);
                authorizeService.addPolicy(c, bs, Constants.getActionID("READ"), groupService.findByName(c, LDAP_GROUP), ResourcePolicy.TYPE_INHERITED);
            }
        }

        // change bundle policies
        authorizeService.removeAllPolicies(c, bundle);
        authorizeService.addPolicy(c, bundle, Constants.getActionID("READ"), groupService.findByName(c, LDAP_GROUP), ResourcePolicy.TYPE_INHERITED);
    }


}
