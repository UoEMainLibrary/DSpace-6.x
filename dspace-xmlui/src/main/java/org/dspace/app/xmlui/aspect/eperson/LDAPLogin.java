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

import javax.servlet.http.HttpSession;

import org.apache.cocoon.caching.CacheableProcessingComponent;
import org.apache.cocoon.environment.ObjectModelHelper;
import org.apache.cocoon.environment.Request;
import org.apache.commons.lang3.StringUtils;
import org.apache.excalibur.source.SourceValidity;
import org.apache.excalibur.source.impl.validity.NOPValidity;
import org.dspace.app.xmlui.cocoon.AbstractDSpaceTransformer;
import org.dspace.app.xmlui.utils.AuthenticationUtil;
import org.dspace.app.xmlui.wing.Message;
import org.dspace.app.xmlui.wing.WingException;
import org.dspace.app.xmlui.wing.element.Body;
import org.dspace.app.xmlui.wing.element.Division;
import org.dspace.app.xmlui.wing.element.Item;
import org.dspace.app.xmlui.wing.element.List;
import org.dspace.app.xmlui.wing.element.PageMeta;
import org.dspace.app.xmlui.wing.element.Password;
import org.dspace.app.xmlui.wing.element.Text;
import org.xml.sax.SAXException;

/**
 * Query the user for their authentication credentials.
 * 
 * The parameter "return-url" may be passed to give a location where to redirect
 * the user to after successfully authenticating.
 * 
 * @author Jay Paz
 */
public class LDAPLogin extends AbstractDSpaceTransformer implements
		CacheableProcessingComponent {
	/** language strings */
	public static final Message T_title = message("xmlui.EPerson.LDAPLogin.title");

	public static final Message T_dspace_home = message("xmlui.general.dspace_home");

	public static final Message T_trail = message("xmlui.EPerson.LDAPLogin.trail");

	public static final Message T_head1 = message("xmlui.EPerson.LDAPLogin.head1");

	public static final Message T_head2 = message("xmlui.EPerson.LDAPLogin.head2");

	public static final Message T_para1 = message("xmlui.EPerson.LDAPLogin.para1");

	public static final Message T_userName = message("xmlui.EPerson.LDAPLogin.username");

	public static final Message T_error_bad_login = message("xmlui.EPerson.LDAPLogin.error_bad_login");

	public static final Message T_password = message("xmlui.EPerson.LDAPLogin.password");

	public static final Message T_submit = message("xmlui.EPerson.LDAPLogin.submit");

	public static final Message T_head3 = message("xmlui.EPerson.LDAPLogin.head3");

	public static final Message T_para2 = message("xmlui.EPerson.LDAPLogin.para2");

	public static final Message T_para3 = message("xmlui.EPerson.LDAPLogin.para3");

	public static final Message T_para4 = message("xmlui.EPerson.LDAPLogin.para4");

	public static final Message T_para5 = message("xmlui.EPerson.LDAPLogin.para5");

	public static final Message T_email = message("xmlui.EPerson.LDAPLogin.email");

	public static final Message T_school = message("xmlui.EPerson.LDAPLogin.school");

	public static final Message T_error_no_school = message("xmlui.EPerson.LDAPLogin.error_no_school");

	public static final Message T_register = message("xmlui.EPerson.LDAPLogin.register");

	public static final Message T_para6 = message("xmlui.EPerson.LDAPLogin.para6");


	/**
	 * Generate the unique caching key. This key must be unique inside the space
	 * of this component.
	 */
	public Serializable getKey() {
		Request request = ObjectModelHelper.getRequest(objectModel);
		String previous_username = request.getParameter("username");

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
				&& previous_username == null)
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
		String previous_username = request.getParameter("username");

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
				&& previous_username == null)
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
	 * Display the login form.
	 */
	public void addBody(Body body) throws SQLException, SAXException,
			WingException {
		// Check if the user has previously attempted to login or register.
		Request request = ObjectModelHelper.getRequest(objectModel);
		HttpSession session = request.getSession();
		String previousUserName = request.getParameter("username");
        String previousSubmit = request.getParameter("submit_save");
        String previousRegister = request.getParameter("submit_register");
        String previousSchool = request.getParameter("school");
        String previousCustomEmail = request.getParameter("customemail");


        // Get any message parameters
		String header = (String) session
				.getAttribute(AuthenticationUtil.REQUEST_INTERRUPTED_HEADER);
		String message = (String) session
				.getAttribute(AuthenticationUtil.REQUEST_INTERRUPTED_MESSAGE);
		String characters = (String) session
				.getAttribute(AuthenticationUtil.REQUEST_INTERRUPTED_CHARACTERS);

		if (header != null || message != null || characters != null) {
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

			if(previousSubmit != null) {
                // if it was the Log In button then show the error
                if (previousSubmit != null) {
                    email.addError(T_error_bad_login);
                }
                // else if it was the Register button then only show the error
                // if the school has been input
                else if (previousRegister != null && previousSchool != null) {
                    email.addError(T_error_bad_login);
                }
            }
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
        customemail.setAutofocus("autofocus");
        customemail.setLabel(T_email);
        if(previousCustomEmail != null){
            customemail.setValue(previousCustomEmail);
        }
        Item item2 = list2.addItem();
        Text school = item2.addText("school");
        school.setLabel(T_school);
        // only give an error about the school missing if the register
        // button was clicked
        if (previousRegister != null && StringUtils.isEmpty(previousSchool)) {
            school.addError(T_error_no_school);
        }
        else if(StringUtils.isNotEmpty(previousSchool)) {
            school.setValue(previousSchool);
        }
        list2.addLabel();
        Item register = list2.addItem("register", null);
        register.addButton("submit_register").setValue(T_register);
        login.addPara().addContent(T_para6);

	}
}
