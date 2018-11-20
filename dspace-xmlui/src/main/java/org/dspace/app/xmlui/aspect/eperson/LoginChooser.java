/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.app.xmlui.aspect.eperson;

import java.io.Serializable;
import java.sql.SQLException;
import java.util.Iterator;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.cocoon.caching.CacheableProcessingComponent;
import org.apache.cocoon.environment.ObjectModelHelper;
import org.apache.cocoon.environment.Request;
import org.apache.cocoon.environment.http.HttpEnvironment;
import org.apache.excalibur.source.SourceValidity;
import org.apache.excalibur.source.impl.validity.NOPValidity;
import org.dspace.app.xmlui.cocoon.AbstractDSpaceTransformer;
import org.dspace.app.xmlui.utils.AuthenticationUtil;
import org.dspace.app.xmlui.wing.Message;
import org.dspace.app.xmlui.wing.WingException;
import org.dspace.app.xmlui.wing.element.*;
import org.dspace.authenticate.AuthenticationMethod;
import org.dspace.authenticate.factory.AuthenticateServiceFactory;
import org.dspace.authenticate.service.AuthenticationService;
import org.dspace.services.factory.DSpaceServicesFactory;
import org.xml.sax.SAXException;

/**
 * Displays a list of authentication methods. This page is displayed if more
 * than one AuthenticationMethod is defined in the dspace config file.
 * 
 * @author Jay Paz
 * 
 */
public class LoginChooser extends AbstractDSpaceTransformer implements
		CacheableProcessingComponent {

	public static final Message T_dspace_home = message("xmlui.general.dspace_home");

	public static final Message T_title = message("xmlui.EPerson.LoginChooser.title");

	public static final Message T_trail = message("xmlui.EPerson.LoginChooser.trail");

	public static final Message T_head1 = message("xmlui.EPerson.LoginChooser.head1");

	public static final Message T_head2 = message("xmlui.EPerson.LoginChooser.head2");

	public static final Message T_para1 = message("xmlui.EPerson.LoginChooser.para1");

	public static final Message T_userName = message("xmlui.EPerson.LoginChooser.username");

	public static final Message T_error_bad_login = message("xmlui.EPerson.LoginChooser.error_bad_login");

	public static final Message T_password = message("xmlui.EPerson.LoginChooser.password");

	public static final Message T_submit = message("xmlui.EPerson.LoginChooser.submit");

	public static final Message T_head3 = message("xmlui.EPerson.LoginChooser.head3");

	public static final Message T_para2 = message("xmlui.EPerson.LoginChooser.para2");

	public static final Message T_para3 = message("xmlui.EPerson.LoginChooser.para3");

	public static final Message T_para4 = message("xmlui.EPerson.LoginChooser.para4");

	public static final Message T_para5 = message("xmlui.EPerson.LoginChooser.para5");

	public static final Message T_email = message("xmlui.EPerson.LoginChooser.email");

	public static final Message T_school = message("xmlui.EPerson.LoginChooser.school");

	public static final Message T_register = message("xmlui.EPerson.LoginChooser.register");

	public static final Message T_para6 = message("xmlui.EPerson.LoginChooser.para6");

	protected AuthenticationService authenticationService = AuthenticateServiceFactory.getInstance().getAuthenticationService();
	/**
	 * Generate the unique caching key. This key must be unique inside the space
	 * of this component.
	 */
	public Serializable getKey() {
		Request request = ObjectModelHelper.getRequest(objectModel);
		String previous_email = request.getParameter("login_email");

		// Get any message parameters
		HttpSession session = request.getSession();
		String header = (String) session
				.getAttribute(AuthenticationUtil.REQUEST_INTERRUPTED_HEADER);
		String message = (String) session
				.getAttribute(AuthenticationUtil.REQUEST_INTERRUPTED_MESSAGE);
		String characters = (String) session
				.getAttribute(AuthenticationUtil.REQUEST_INTERRUPTED_CHARACTERS);

		// If there is a message or previous email attempt then the page is not
		// cachable
		if (header == null && message == null && characters == null
				&& previous_email == null)
        {
            // cacheable
            return "1";
        }
		else
        {
            // Uncachable
            return "0";
        }
	}

	/**
	 * Generate the cache validity object.
	 */
	public SourceValidity getValidity() {
		Request request = ObjectModelHelper.getRequest(objectModel);
		String previous_email = request.getParameter("login_email");

		// Get any message parameters
		HttpSession session = request.getSession();
		String header = (String) session
				.getAttribute(AuthenticationUtil.REQUEST_INTERRUPTED_HEADER);
		String message = (String) session
				.getAttribute(AuthenticationUtil.REQUEST_INTERRUPTED_MESSAGE);
		String characters = (String) session
				.getAttribute(AuthenticationUtil.REQUEST_INTERRUPTED_CHARACTERS);

		// If there is a message or previous email attempt then the page is not
		// cachable
		if (header == null && message == null && characters == null
				&& previous_email == null)
        {
            // Always valid
            return NOPValidity.SHARED_INSTANCE;
        }
		else
        {
            // invalid
            return null;
        }
	}

	/**
	 * Set the page title and trail.
	 */
	public void addPageMeta(PageMeta pageMeta) throws WingException {
		pageMeta.addMetadata("title").addContent(T_title);

		pageMeta.addTrailLink(contextPath + "/", T_dspace_home);
		pageMeta.addTrail().addContent(T_trail);
	}

	/**
	 * Display the login choices.
	 */
	public void addBody(Body body) throws SQLException, SAXException,
			WingException {
		Iterator authMethods = authenticationService
				.authenticationMethodIterator();
		Request request = ObjectModelHelper.getRequest(objectModel);
		HttpSession session = request.getSession();
		String previousUserName = request.getParameter("username");

		// Get any message parameters
		String header = (String) session
				.getAttribute(AuthenticationUtil.REQUEST_INTERRUPTED_HEADER);
		String message = (String) session
				.getAttribute(AuthenticationUtil.REQUEST_INTERRUPTED_MESSAGE);
		String characters = (String) session
				.getAttribute(AuthenticationUtil.REQUEST_INTERRUPTED_CHARACTERS);

		if ( (header != null && header.trim().length() > 0) || 
			 (message != null && message.trim().length() > 0) ||
			 (characters != null && characters.trim().length() > 0)) {
			Division reason = body.addDivision("login-reason");

			if (header != null)
			{
				reason.setHead(message(header));
			}
			else
			{
				// Always have a head.
				reason.setHead("Authentication Required");
			}
			
			if (message != null)
			{
				reason.addPara(message(message));
			}
			
			if (characters != null)
			{
				reason.addPara(characters);
			}
		}

		Division login = body.addInteractiveDivision("login", contextPath
				+ "/ldap-login", Division.METHOD_POST, "primary");
		login.setHead(T_head1);

		Division loginHeader = login.addDivision("login_header");
		loginHeader.setHead(T_head2);
		loginHeader.addPara().addContent(T_para1);

		List list = login.addList("ldap-login", List.TYPE_FORM);

		Text email = list.addItem().addText("username");
		email.setRequired();
		email.setAutofocus("autofocus");
		email.setLabel(T_userName);
		if (previousUserName != null) {
			email.setValue(previousUserName);
			email.addError(T_error_bad_login);
		}

		Item item = list.addItem();
		Password password = item.addPassword("ldap_password");
		password.setRequired();
		password.setLabel(T_password);

		list.addLabel();
		Item submit = list.addItem("login-in", null);
		submit.addButton("submit_save").setValue(T_submit);

		Division registerHeader = login.addDivision("register_header");
		registerHeader.setHead(T_head3);
		registerHeader.addPara().addContent(T_para2);
		registerHeader.addPara().addContent(T_para3);
		registerHeader.addPara().addContent(T_para4);
		registerHeader.addPara().addContent(T_para5);

		List list2 = login.addList("registration", List.TYPE_FORM);

		Text customemail = list2.addItem().addText("customemail");
		//customemail.setRequired();
		customemail.setAutofocus("autofocus");
		customemail.setLabel(T_email);

		Item item2 = list2.addItem();
		Text school = item2.addText("school");
		//school.setRequired();
		school.setLabel(T_school);

		list2.addLabel();
		Item register = list2.addItem("register", null);
		register.addButton("submit_register").setValue(T_register);

		login.addPara().addContent(T_para6);
	}

}
