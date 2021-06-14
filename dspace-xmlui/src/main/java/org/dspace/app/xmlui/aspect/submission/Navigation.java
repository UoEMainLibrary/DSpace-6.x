/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.app.xmlui.aspect.submission;

import java.io.IOException;
import java.io.Serializable;
import java.sql.SQLException;

import org.apache.cocoon.caching.CacheableProcessingComponent;
import org.apache.excalibur.source.SourceValidity;
import org.apache.excalibur.source.impl.validity.NOPValidity;
import org.dspace.app.xmlui.cocoon.AbstractDSpaceTransformer;
import org.dspace.app.xmlui.utils.UIException;
import org.dspace.app.xmlui.wing.Message;
import org.dspace.app.xmlui.wing.WingException;
import org.dspace.app.xmlui.wing.element.List;
import org.dspace.app.xmlui.wing.element.Options;
import org.dspace.app.xmlui.wing.element.PageMeta;
import org.dspace.authorize.AuthorizeException;
import org.dspace.eperson.EPerson;
import org.dspace.eperson.Group;
import org.xml.sax.SAXException;

/**
 * Simple navigation class to add the top level link to 
 * the main submissions page.
 * 
 * @author Scott Phillips
 */
public class Navigation extends AbstractDSpaceTransformer implements CacheableProcessingComponent
{
	
    
	/** Language Strings **/
    protected static final Message T_submissions = 
        message("xmlui.Submission.Navigation.submissions");
	
	 /**
     * Generate the unique caching key.
     * This key must be unique inside the space of this component.
     */
    public Serializable getKey() {
        
        return 1;
    }

    /**
     * Generate the cache validity object.
     */
    public SourceValidity getValidity() 
    {
        return NOPValidity.SHARED_INSTANCE;
    }
	
   
    public void addOptions(Options options) throws SAXException, WingException,
            UIException, SQLException, IOException, AuthorizeException
    {
		// Basic navigation skeleton
        options.addList("browse");
        List account = options.addList("account");
        options.addList("context");
        options.addList("administrative");
    	
//      This doesn't flow very well, lets remove it and see if anyone misses it.  
//    	DSpaceObject dso = HandleUtil.obtainHandle(objectModel);	
//    	if (dso != null && dso instanceof Collection)
//    	{
//    		Collection collection = (Collection) dso;  		
//    		if (AuthorizeManager.authorizeActionBoolean(context, collection, Constants.ADD))
//    		{
//    	        String submitURL = contextPath + "/handle/" + collection.getHandle() + "/submit";
//		        account.addItemXref(submitURL,"Submit to this collection");
//    		}
//    	}
    	
    	account.addItemXref(contextPath+"/submissions",T_submissions);
    }

    public void addPageMeta(PageMeta pageMeta) throws SAXException,
            WingException, UIException, SQLException, IOException,
            AuthorizeException
    {
        /*
        This hides hard-coded input forms, defined in js file, on the submission process step if the user is
        NOT an administrator and IS a member of staff.
         */

        EPerson eperson = context.getCurrentUser();

        if (eperson != null)
        {
            boolean staff = false;
            boolean admin = false;

            for (Group g: eperson.getGroups()) {
                if(g.getName().equals("STAFF"))
                    staff = true;

                if(g.getName().equals("Administrator"))
                    admin = true;

            }

            if(staff && !admin)
                pageMeta.addMetadata("javascript","static").addContent("static/js/hide_inputs.js");

        }
    }

}
