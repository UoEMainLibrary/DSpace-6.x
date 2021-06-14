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
import org.dspace.content.MetadataField;
import org.dspace.content.MetadataSchema;
import org.dspace.content.factory.ContentServiceFactory;
import org.dspace.content.service.MetadataFieldService;
import org.xml.sax.SAXException;

import java.sql.SQLException;

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
	private static final Message T_main_message = message("xmlui.administrative.refreport.mainmessage");
	private static final Message T_field_label = message("xmlui.administrative.refreport.field");
	private static final Message T_field_help = message("xmlui.administrative.refreport.fieldhelp");
	private static final Message T_author_label = message("xmlui.administrative.refreport.author");
	private static final Message T_author_help = message("xmlui.administrative.refreport.authorhelp");
	private static final Message T_startdate_label = message("xmlui.administrative.refreport.startdate");
	private static final Message T_stopdate_label = message("xmlui.administrative.refreport.stopdate");
	private static final Message T_startdate_help = message("xmlui.administrative.refreport.startdatehelp");
	private static final Message T_stopdate_help = message("xmlui.administrative.refreport.stopdatehelp");
	private static final Message T_find = message("xmlui.administrative.refreport.find");
	private static final Message T_exportexcel_label = message("xmlui.administrative.refreport.exportexcel");
	private static final Message T_exportexcel_help = message("xmlui.administrative.refreport.exportexcelhelp");

	protected MetadataFieldService metadataFieldService = ContentServiceFactory.getInstance().getMetadataFieldService();

	public void addPageMeta(PageMeta pageMeta) throws WingException
	{
		pageMeta.addTrailLink(contextPath + "/", T_dspace_home);
		pageMeta.addTrail().addContent(T_item_trail);
		pageMeta.addMetadata("title").addContent(T_title);

		pageMeta.addMetadata("javascript", "static").addContent("static/js/refreports.js");
	}

	
	public void addBody(Body body) throws SAXException, WingException, SQLException {

		// DIVISION: find-item

		Division findItem = body.addInteractiveDivision("find-refitem",
				contextPath + "/admin/refreport", Division.METHOD_GET,"primary administrative item");
		findItem.setHead(T_head1);
		findItem.addPara(T_main_message);
		
		List form = findItem.addList("find-refitem-form", List.TYPE_FORM);

		Select addName = form.addItem().addSelect("field");
		addName.setLabel(T_field_label);
		addName.addOption("0", "");
		addName.setHelp(T_field_help);

		java.util.List<MetadataField> fields = metadataFieldService.findAll(context);

		for (MetadataField field : fields)
		{
			int fieldID = field.getID();
			MetadataSchema schema = field.getMetadataSchema();
			String name = schema.getName() + "." + field.getElement();
			if (field.getQualifier() != null)
			{
				name += "." + field.getQualifier();
			}

			addName.addOption(fieldID, name);
		}

		Text author = form.addItem().addText("author");
		Text startDate = form.addItem().addText("startDate");
		Text stopDate = form.addItem().addText("stopDate");
		CheckBox exportExcel = form.addItem().addCheckBox("exportExcel");
		exportExcel.addOption("false");
		author.setAutofocus("autofocus");
		author.setLabel(T_author_label);
		author.setHelp(T_author_help);
		startDate.setLabel(T_startdate_label);
		startDate.setHelp(T_startdate_help);
		stopDate.setLabel(T_stopdate_label);
		stopDate.setHelp(T_stopdate_help);
		exportExcel.setLabel(T_exportexcel_label);
		exportExcel.setHelp(T_exportexcel_help);

		form.addItem().addButton("submit_find").setValue(T_find);
		
		findItem.addHidden("administrative-continue").setValue(knot.getId());
	}
}
