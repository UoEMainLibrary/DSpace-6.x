/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.app.xmlui.aspect.statisticsIRUS;

import java.io.IOException;
import java.sql.SQLException;

import org.apache.cocoon.environment.ObjectModelHelper;
import org.apache.cocoon.environment.Request;
import org.dspace.app.xmlui.cocoon.AbstractDSpaceTransformer;
import org.dspace.app.xmlui.utils.UIException;
import org.dspace.app.xmlui.wing.Message;
import org.dspace.app.xmlui.wing.WingException;
import org.dspace.app.xmlui.wing.element.Body;
import org.dspace.app.xmlui.wing.element.Button;
import org.dspace.app.xmlui.wing.element.CheckBox;
import org.dspace.app.xmlui.wing.element.Division;
import org.dspace.app.xmlui.wing.element.List;
import org.dspace.app.xmlui.wing.element.PageMeta;
import org.dspace.app.xmlui.wing.element.TextArea;
import org.dspace.authorize.AuthorizeException;
import org.xml.sax.SAXException;


/**
 * This is a class to test the capabilities of including HTML inside
 * a DRI document. This can be useful for resources outside of
 * developer's control such as text files on disk or user-supplied data.
 *
 * This class is not internationalized because it is never intended
 * to be used in production. It is merely a tool to aid developers of
 * aspects and themes.
 *
 * @author Scott Phillips
 */
public class StatisticsIRUS extends AbstractDSpaceTransformer
{

    private static final Message T_dspace_home = message("xmlui.general.dspace_home");

    // The default string to include in test, may be overridden by the user.
    private static final String DEFAULT_HTML_STRING = "<p>This is a test of manakin's ability to render HTML fragments.</p>\n\n<p>Only a few tags are allowed such as: <b>bold</b>, <i>italic</i>, <u>underline</u>, and <a href=\"http://di.tamu.edu/\">link</a>.</p>\n\n<h2>This is a heading</h2>\n\nInvalid tags are treated as plain text: <invalid attribute=\"a\">this is invalid</invalid>\n\nAlso line breaks may be treated as a paragraphs when that action is specified.";

    public void addPageMeta(PageMeta pageMeta) throws SAXException,
            WingException, UIException, SQLException, IOException,
            AuthorizeException
    {
        pageMeta.addMetadata("title").addContent("IRUS Statistics");

        pageMeta.addTrailLink(contextPath + "/", T_dspace_home);
        pageMeta.addTrail().addContent("IRUS Statistics");

        pageMeta.addMetadata("stylesheet", "screen", null, true).addContent("../../static/css/irus_stats.css");
        pageMeta.addMetadata("javascript", "static").addContent("static/js/irus_stats.js");

    }


    public void addBody(Body body) throws SAXException, WingException,
            UIException, SQLException, IOException, AuthorizeException
    {
        Division main = body.addDivision("main");
        main.setHead("IRUS Statistics");

    }
}
