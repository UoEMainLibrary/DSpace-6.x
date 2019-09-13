/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.app.xmlui.aspect.administrative.refreport;

import org.dspace.app.xmlui.cocoon.AbstractDSpaceTransformer;
import org.dspace.app.xmlui.wing.Message;
import org.dspace.app.xmlui.wing.WingException;
import org.dspace.app.xmlui.wing.element.*;
import org.xml.sax.SAXException;

/**
 * Find form to search items, uses jquery Datepicker.
 * NOTE: that directory must be created before Tomcat is deployed or it will fail because
 * server.xml in tomcat/conf maps to that
 * For the purposes of REF auditing for QMU.
 * August-September 2019
 * Based off the Items functionality under Content administration
 *
 * @author Hrafn Malmquist
*/

public class FindRefItemForm extends AbstractDSpaceTransformer {

	/** Language strings */
	private static final Message T_dspace_home = message("xmlui.general.dspace_home");
	private static final Message T_item_trail = message("xmlui.administrative.refreport.trail");
	
	private static final Message T_title = message("xmlui.administrative.refreport.title");
	private static final Message T_head1 = message("xmlui.administrative.refreport.head1");
	private static final Message T_author_label = message("xmlui.administrative.refreport.author");
	private static final Message T_startdate_label = message("xmlui.administrative.refreport.startdate");
	private static final Message T_stopdate_label = message("xmlui.administrative.refreport.stopdate");
	private static final Message T_label_date_help = message("xmlui.administrative.refreport.datehelp");
	private static final Message T_find = message("xmlui.administrative.refreport.find");

	public void addPageMeta(PageMeta pageMeta) throws WingException
	{
		pageMeta.addTrailLink(contextPath + "/", T_dspace_home);
		pageMeta.addTrail().addContent(T_item_trail);
		pageMeta.addMetadata("title").addContent(T_title);

		pageMeta.addMetadata("javascript", "static").addContent("static/js/refreports.js");
	}

	
	public void addBody(Body body) throws SAXException, WingException
	{

		// DIVISION: find-item
		Division findItem = body.addInteractiveDivision("find-refitem",
				contextPath + "/admin/refreport", Division.METHOD_GET,"primary administrative item");
		findItem.setHead(T_head1);
		
		List form = findItem.addList("find-refitem-form", List.TYPE_FORM);

		Text author = form.addItem().addText("author");
		Text startDate = form.addItem().addText("startDate");
		Text stopDate = form.addItem().addText("stopDate");
		CheckBox exportExcel = form.addItem().addCheckBox("exportExcel");
		exportExcel.addOption("false");
		author.setAutofocus("autofocus");
		author.setLabel(T_author_label);
		startDate.setLabel(T_startdate_label);
		startDate.setHelp(T_label_date_help);
		stopDate.setLabel(T_stopdate_label);
		stopDate.setHelp(T_label_date_help);
		exportExcel.setLabel("Export to Excel");

		form.addItem().addButton("submit_find").setValue(T_find);
		
		findItem.addHidden("administrative-continue").setValue(knot.getId());
	}
}
