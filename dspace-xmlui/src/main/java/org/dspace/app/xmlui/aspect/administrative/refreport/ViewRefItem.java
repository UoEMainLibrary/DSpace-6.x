/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.app.xmlui.aspect.administrative.refreport;

import java.io.FileWriter;
import java.io.BufferedWriter;
import java.io.IOException;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;

import org.apache.log4j.Logger;
import org.dspace.app.xmlui.cocoon.AbstractDSpaceTransformer;
import org.dspace.app.xmlui.wing.Message;
import org.dspace.app.xmlui.wing.WingException;
import org.dspace.app.xmlui.wing.element.*;
import org.dspace.authorize.AuthorizeException;
import org.dspace.content.Item;
import org.dspace.content.factory.ContentServiceFactory;
import org.dspace.content.service.ItemService;
import org.dspace.content.MetadataValue;
import org.dspace.core.ConfigurationManager;

/**
 * Display a subset of items that can be filtered by author and a date window.
 * If a check-box is checked a CSV file will be written to webapps/refreports
 * NOTE: that directory must be created before Tomcat is deployed or it will fail because
 * server.xml in tomcat/conf maps to that
 * For the purposes of REF auditing for QMU.
 * August-September 2019
 * Based off the Items functionality under Content administration
 * 
 * @author Hrafn Malmquist
 */

public class ViewRefItem extends AbstractDSpaceTransformer {

	/** Language strings */
	private static final Message T_dspace_home = message("xmlui.general.dspace_home");

	private static final Message T_refreport_trail = message("xmlui.administrative.refreport.trail");

	private static final Message T_refreport_head = message("xmlui.administrative.refreport.head2");

	private static final Message T_title = message("xmlui.administrative.refreport.title");

	private static final Message T_trail = message("xmlui.administrative.refreport.view_trail");

    protected ItemService itemService = ContentServiceFactory.getInstance().getItemService();
    private java.io.File outputPath = new java.io.File(ConfigurationManager.getProperty("dspace.dir") + "/webapps/refreports");

	private static Logger log = Logger.getLogger(ViewRefItem.class);

	/**
	 * Explode an array list of Metadatavalues into a String separated by commas
 	 * @param mdvs array of Metadatavalues
	 * @return String
	 */
	private String getMetadata(java.util.List<MetadataValue> mdvs)	{
		StringBuilder mdvalue = new StringBuilder();

		for(MetadataValue mdv: mdvs)	{
			mdvalue.append(mdv.getValue()).append(", ");
		}

		return mdvalue.substring(0, Math.max(0, mdvalue.length()-2));
	}

	/**
	 * Convert a String to a date.
	 *
	 * If string only consists of year or year-month then
	 * the first of the month is appended.
	 * @param dateTxt  String is expected to be yyyy, yyyy-mm, yyyy-mm-dd
	 * @return Date
	 */

	private Date getDate(String dateTxt)	{
		Date date = null;

		if(dateTxt.length() == 4)
			dateTxt += "-01-01";
		else if(dateTxt.length() == 7)
			dateTxt += "-01";

		try {
			date = new SimpleDateFormat("yyyy-MM-dd").parse(dateTxt);

		}
		catch (Exception exc)	{
			log.error("Couldn't convert to date.\n" + exc.toString());
		}

		return date;

	}

	/**
	 * String to escape quote for CSV export
	 * Ported from
	 * https://stackoverflow.com/questions/6377454/escaping-tricky-string-to-csv-format
	 * @param str unquoted string
	 * @return quoted string
	 */

    private static String StringToCSVCell(String str)
    {
        boolean mustQuote = (str.contains(",") || str.contains("\"") || str.contains("\r") || str.contains("\n"));
        if (mustQuote)
        {
            StringBuilder sb = new StringBuilder();
            sb.append("\"");
            for (char nextChar : str.toCharArray())	{
                sb.append(nextChar);
                if (nextChar == '"')
                    sb.append("\"");
            }
            sb.append("\"");
            return sb.toString();
        }

        return str;
    }

	/**
	 * Iterate through and array of items and write their metadata to a CSV file.
	 * @param fileName name of CSV file to be written
	 * @param content array list of items to be written
	 * @throws IOException standard for write
	 */

    private void writeFile(String fileName, java.util.List<Item> content) throws IOException {
	    String write = "\"Title\", \"Author\", \"ISSN\", \"Date issued\", \"URL\", \"Publisher\", \"Is part of\"," +
				" \"Abstract\", \"Description\", \"Description URL\", \"Date accepted\", \"Date FCD\"\n";

	    for(Item item: content)	{
			String con_author = getMetadata(itemService.getMetadata(item, "dc", "contributor","author", Item.ANY));
			String dateIssued = getMetadata(itemService.getMetadata(item, "dc", "date", "issued", Item.ANY));
			String issn = getMetadata(itemService.getMetadata(item, "dc", "identifier","issn", Item.ANY));
			String uri = getMetadata(itemService.getMetadata(item, "dc", "identifier", "uri", Item.ANY));
			String description = getMetadata(itemService.getMetadata(item, "dc", "description",null, Item.ANY));
			String mabstract = getMetadata(itemService.getMetadata(item, "dc", "description", "abstract", Item.ANY));
			String descuri = getMetadata(itemService.getMetadata(item, "dc", "description","uri", Item.ANY));
			String publisher = getMetadata(itemService.getMetadata(item, "dc", "publisher", null, Item.ANY));
			String ispartof = getMetadata(itemService.getMetadata(item, "dc", "relation","ispartof", Item.ANY));
			String title = getMetadata(itemService.getMetadata(item, "dc", "title", null, Item.ANY));
			String dateAccepted = getMetadata(itemService.getMetadata(item, "refterms", "dateAccepted",null, Item.ANY));
			String dateFCD = getMetadata(itemService.getMetadata(item, "refterms", "dateFCD", null, Item.ANY));

			write += StringToCSVCell(title) + "," + StringToCSVCell(con_author) + "," + StringToCSVCell(issn) + "," +
                    StringToCSVCell(dateIssued) + "," + StringToCSVCell(uri) + "," + StringToCSVCell(publisher) + "," +
                    StringToCSVCell(ispartof) + "," + StringToCSVCell(mabstract) + "," + StringToCSVCell(description) + "," +
                    StringToCSVCell(descuri) + "," + StringToCSVCell(dateAccepted) + "," + StringToCSVCell(dateFCD) + "\n";
		}

	    BufferedWriter writer = new BufferedWriter(new FileWriter(outputPath + "/" + fileName + ".csv"));
		writer.write(write);
		writer.flush();
		writer.close();
	}

	/**
	 * Filter items according to author, startDate and endDate if set.
	 * @param refItem item to check
	 * @param author author value, can be null
	 * @param startDate startDate value, can be null
	 * @param stopDate stopDate value
	 * @return true if item should be returned, else false
	 */

	private boolean checkItem(Item refItem, String author, Date startDate, Date stopDate)	{
		String refAuthor = getMetadata(itemService.getMetadata(refItem, "dc", "contributor","author", Item.ANY));
		Date dateAccepted = getDate(getMetadata(itemService.getMetadata(refItem, "refterms", "dateAccepted",null, Item.ANY)));

		if(author != null && !refAuthor.toLowerCase().contains(author.toLowerCase()))	{
			return false;
		}
		else if(startDate != null && dateAccepted != null && dateAccepted.before(startDate))	{
			return false;
		}
		else if(stopDate != null && dateAccepted != null && dateAccepted.after(stopDate))	{
			return false;
		}

		return true;

	}

	public void addPageMeta(PageMeta pageMeta) throws WingException {
		pageMeta.addMetadata("title").addContent(T_title);

		pageMeta.addTrailLink(contextPath + "/", T_dspace_home);
		pageMeta.addTrailLink(contextPath + "/admin/refreport", T_refreport_trail);
		pageMeta.addTrail().addContent(T_trail);

	}

	public void addBody(Body body) throws SQLException, WingException {
		// Get our parameters and state

		String author = parameters.getParameter("author", null).trim();
		String strstartDate = parameters.getParameter("startDate", null);
		Date startDate = getDate(strstartDate);
		String strstopDate = parameters.getParameter("stopDate", null);
		Date stopDate = getDate(strstopDate);
		boolean createExcel = (parameters.getParameter("exportExcel", null) != null
				&& !parameters.getParameter("exportExcel", null).equalsIgnoreCase(""));

		Division maindiv = body.addDivision("maindiv");
		maindiv.setHead(T_refreport_head);

		int rows = 0;
		java.util.List<Item> filteredItems = new ArrayList<Item>();

		try {
			Iterator<Item> items = itemService.findByMetadataField(context, "refterms", "dateAccepted", null, Item.ANY);

			while(items.hasNext())	{
				Item dspaceItem = items.next();

				if(checkItem(dspaceItem, author, startDate, stopDate))	{
					filteredItems.add(dspaceItem);
					rows += 1;

				}
			}
		}
		catch (AuthorizeException authExc) {
			log.error("Filter check on item failed because of lacking authorization.\n" + authExc.toString());
		}
		catch (IOException ioExc)	{
			log.error("Filter check on item failed because IO.\n" + ioExc.toString());
		}

		String filterPara = "Showing " + rows + " items";
		String filename = "ref_report";

		if(rows == 0)
			filterPara = "No results found for: ";

		if(startDate != null)	{
			filterPara += " from " + strstartDate;
			filename += "-" + strstartDate;
		}

		if(stopDate != null)	{
			filterPara += " to " + strstopDate;
			filename += "-" + strstopDate;
		}

		if(author != null && !author.equals(""))	{
			filterPara += " by " + author;
			filename += "-" + author;
		}

		maindiv.addPara(filterPara);

		//String[] cols = { "Title", "Author", "ISSN", "Date issued", "URL", "Publisher", "Is part of", "Abstract",
		// "Description", "Description URL", "Date accepted", "Date FCD"};

		String[] cols = { "Title", "Author", "Date issued", "Date accepted", "Date FCD"};

		if(createExcel)  {
			try {
				writeFile(filename, filteredItems);
				maindiv.addPara().addXref("/refreports/" + filename + ".csv","Download for Excel");
			}
			catch(IOException ioExc) {
				log.error("Couldn't write " + filename + ": " + ioExc.getMessage());
			}
		}

		Division backDiv =  maindiv.addInteractiveDivision("go_back", "", Division.METHOD_GET);
		backDiv.addHidden("author").setValue(parameters.getParameter("author", null));
		backDiv.addHidden("startDate").setValue(parameters.getParameter("startDate", null));
		backDiv.addHidden("stopDate").setValue(parameters.getParameter("stopDate", null));
		backDiv.addPara().addButton("submit_back").setValue("New search");


		Table t = maindiv.addTable("ref-items", (rows + 1), cols.length);
		Row headers = t.addRow("header");

		for (String header: cols) {
			headers.addCell("header").addContent(header);
		}

		for(Item item : filteredItems)	{
			String con_author = getMetadata(itemService.getMetadata(item, "dc", "contributor","author", Item.ANY));
			String dateIssued = getMetadata(itemService.getMetadata(item, "dc", "date", "issued", Item.ANY));
			/*String issn = getMetadata(itemService.getMetadata(item, "dc", "identifier","issn", Item.ANY));
			String uri = getMetadata(itemService.getMetadata(item, "dc", "identifier", "uri", Item.ANY));
			String description = getMetadata(itemService.getMetadata(item, "dc", "description",null, Item.ANY));
			String mabstract = getMetadata(itemService.getMetadata(item, "dc", "description", "absctract", Item.ANY));
			String descuri = getMetadata(itemService.getMetadata(item, "dc", "description","uri", Item.ANY));
			String publisher = getMetadata(itemService.getMetadata(item, "dc", "publisher", null, Item.ANY));
			String ispartof = getMetadata(itemService.getMetadata(item, "dc", "relation","ispartof", Item.ANY));*/
			String title = getMetadata(itemService.getMetadata(item, "dc", "title", null, Item.ANY));
			String dateAccepted = getMetadata(itemService.getMetadata(item, "refterms", "dateAccepted",null, Item.ANY));
			String dateFCD = getMetadata(itemService.getMetadata(item, "refterms", "dateFCD", null, Item.ANY));

			//log.info("Count: " + itemService.getMetadata(item, "dc", "date", "issued", Item.ANY).size());

			Row trow = t.addRow("data");
            trow.addCell("data").addXref("../handle/" + item.getHandle(), title);
			//trow.addCell("data").addContent(title);
			trow.addCell("data").addContent(con_author);
			//trow.addCell("data").addContent(issn);
			trow.addCell("data").addContent(dateIssued);
			//trow.addCell("data").addContent(uri);
			//trow.addCell("data").addContent(publisher);
			//trow.addCell("data").addContent(ispartof);
			//trow.addCell("data").addContent(mabstract);
			//trow.addCell("data").addContent(description);
			//trow.addCell("data").addContent(descuri);
			trow.addCell("data").addContent(dateAccepted);
			trow.addCell("data").addContent(dateFCD);

		}
	}
}
