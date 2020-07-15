<!--
    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at
    http://www.dspace.org/license/
-->

<!--
    Main structure of the page, determines where
    header, footer, body, navigation are structurally rendered.
    Rendering of the header, footer, trail and alerts
    Author: art.lowel at atmire.com
    Author: lieven.droogmans at atmire.com
    Author: ben at atmire.com
    Author: Alexey Maslov
-->

<xsl:stylesheet xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
                xmlns:dri="http://di.tamu.edu/DRI/1.0/"
                xmlns:mets="http://www.loc.gov/METS/"
                xmlns:xlink="http://www.w3.org/TR/xlink/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
                xmlns:dim="http://www.dspace.org/xmlns/dspace/dim"
                xmlns:xhtml="http://www.w3.org/1999/xhtml"
                xmlns:mods="http://www.loc.gov/mods/v3"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:confman="org.dspace.core.ConfigurationManager"
                exclude-result-prefixes="i18n dri mets xlink xsl dim xhtml mods dc confman">

    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

    <!--
        Requested Page URI. Some functions may alter behavior of processing depending if URI matches a pattern.
        Specifically, adding a static page will need to override the DRI, to directly add content.
    -->

    <!-- Various variables for conditionals regarding page structure, sidebar structure and RSS feed availablity -->
    <xsl:variable name="request-uri" select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='request'][@qualifier='URI']"/>
    <xsl:variable name="doc-root" select="translate(/dri:document/dri:meta/dri:pageMeta/dri:trail[@target][last()]/@target, '/', '')" />
    <xsl:variable name="trail-test" select="/dri:document/dri:meta/dri:pageMeta/dri:trail[last()]" />
    <xsl:variable name="auth" select="/dri:document/dri:meta/dri:userMeta/@authenticated" />
    <xsl:variable name="uri-string" select="concat($trail-test, '/', $request-uri)" />


    <!--
        The starting point of any XSL processing is matching the root element. In DRI the root element is document,
        which contains a version attribute and three top level elements: body, options, meta (in that order).
        This template creates the html document, giving it a head and body. A title and the CSS style reference
        are placed in the html head, while the body is further split into several divs. The top-level div
        directly under html body is called "ds-main". It is further subdivided into:
            "ds-header"  - the header div containing title, subtitle, trail and other front matter
            "ds-body"    - the div containing all the content of the page; built from the contents of dri:body
            "ds-options" - the div with all the navigation and actions; built from the contents of dri:options
            "ds-footer"  - optional footer div, containing misc information
        The order in which the top level divisions appear may have some impact on the design of CSS and the
        final appearance of the DSpace page. While the layout of the DRI schema does favor the above div
        arrangement, nothing is preventing the designer from changing them around or adding new ones by
        overriding the dri:document template.
    -->
    <xsl:template match="dri:document">

        <xsl:choose>
            <xsl:when test="not($isModal)">


            <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;
            </xsl:text>
            <xsl:text disable-output-escaping="yes">&lt;!--[if lt IE 7]&gt; &lt;html class=&quot;no-js lt-ie9 lt-ie8 lt-ie7&quot; lang=&quot;en&quot;&gt; &lt;![endif]--&gt;
            &lt;!--[if IE 7]&gt;    &lt;html class=&quot;no-js lt-ie9 lt-ie8&quot; lang=&quot;en&quot;&gt; &lt;![endif]--&gt;
            &lt;!--[if IE 8]&gt;    &lt;html class=&quot;no-js lt-ie9&quot; lang=&quot;en&quot;&gt; &lt;![endif]--&gt;
            &lt;!--[if gt IE 8]&gt;&lt;!--&gt; &lt;html class=&quot;no-js&quot; lang=&quot;en&quot;&gt; &lt;!--&lt;![endif]--&gt;
            </xsl:text>

                <!-- First of all, build the HTML head element -->

                <xsl:call-template name="buildHead"/>

                <!-- Then proceed to the body -->
                <body>
                    
                    <!-- Prompt IE 6 users to install Chrome Frame. Remove this if you support IE 6.
                   chromium.org/developers/how-tos/chrome-frame-getting-started -->
                    <!--[if lt IE 7]><p class=chromeframe>Your browser is <em>ancient!</em> <a href="http://browsehappy.com/">Upgrade to a different browser</a> or <a href="http://www.google.com/chromeframe/?redirect=true">install Google Chrome Frame</a> to experience this site.</p><![endif]-->
                    <xsl:choose>
                        <xsl:when
                                test="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='framing'][@qualifier='popup']">
                            <xsl:apply-templates select="dri:body/*"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="buildHeader"/>
                            <!-- Remove normal implementation of trail -->
                            <!--<xsl:call-template name="buildTrail"/>-->

                            <!--javascript-disabled warning, will be invisible if javascript is enabled-->
                            <div id="no-js-warning-wrapper" class="hidden">
                                <div id="no-js-warning">
                                    <div class="notice failure">
                                        <xsl:text>JavaScript is disabled for your browser. Some features of this site may not work without it.</xsl:text>
                                    </div>
                                </div>
                            </div>

                            <div id="main-container" class="container">

                                <div class="row row-offcanvas row-offcanvas-right">
                                    
                                    <div class="horizontal-slider clearfix">

                                        <!-- Top background image (globe) -->
                                        <img id="background-globe" src="{$theme-path}/images/globe-png-icon.png" />

                                        <div class="col-xs-12 col-sm-12 col-md-9 main-content" id="main-content">

                                            <!-- Commented out for now -->
                                            <!--<xsl:if test="$trail-test = xmlui.ArtifactBrowser.ItemViewer.trail">
                                                <script type="text/javascript">
                                                    <xsl:text>
                                                        $(window).on('load', function() {
                                                            document.getElementById("aspect_discovery_Navigation_list_discovery").style.display = "none";
                                                            console.log('All assets are loaded')
                                                        }); 
                                                    </xsl:text>
                                                </script>   
                                                <div id="aspect_discovery_Navigation_list_discovery" class="list-group" style="display: none;"></div>
                                            </xsl:if>-->

                                            <xsl:apply-templates select="*[not(self::dri:options)]"/>

                                            <div class="visible-xs visible-sm">
                                                <xsl:call-template name="buildFooter"/>
                                            </div>
                                        </div>
                                        <div class="col-xs-6 col-sm-3 sidebar-offcanvas" id="sidebar" role="navigation">
                                            <xsl:apply-templates select="dri:options"/>
                                        </div>

                                        <!-- Bottom background image (dandylion) -->
                                        <img id="background-dandy" src="{$theme-path}/images/dandy-png-icon.png" />

                                    </div>
                                </div>

                                <!--
                            The footer div, dropping whatever extra information is needed on the page. It will
                            most likely be something similar in structure to the currently given example. -->
                                <div class="hidden-xs hidden-sm">
                                    <xsl:call-template name="buildFooter"/>
                                </div>
                            </div>


                        </xsl:otherwise>
                    </xsl:choose>
                    <!-- Javascript at the bottom for fast page loading -->
                    <xsl:call-template name="addJavascript"/>
                </body>
                <xsl:text disable-output-escaping="yes">&lt;/html&gt;</xsl:text>

            </xsl:when>
            <xsl:otherwise>
                <!-- This is only a starting point. If you want to use this feature you need to implement
                JavaScript code and a XSLT template by yourself. Currently this is used for the DSpace Value Lookup -->
                <xsl:apply-templates select="dri:body" mode="modal"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- The HTML head element contains references to CSS as well as embedded JavaScript code. Most of this
    information is either user-provided bits of post-processing (as in the case of the JavaScript), or
    references to stylesheets pulled directly from the pageMeta element. -->
    <xsl:template name="buildHead">
        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>

            <!-- Use the .htaccess and remove these lines to avoid edge case issues.
             More info: h5bp.com/i/378 -->
            <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>

            <!-- Mobile viewport optimized: h5bp.com/viewport -->
            <meta name="viewport" content="width=device-width,initial-scale=1"/>

            <link rel="shortcut icon">
                <xsl:attribute name="href">
                    <xsl:value-of select="$theme-path"/>
                    <xsl:text>lib/images/favicon.ico</xsl:text>
                </xsl:attribute>
            </link>
            <link rel="apple-touch-icon">
                <xsl:attribute name="href">
                    <xsl:value-of select="$theme-path"/>
                    <xsl:text>lib/images/apple-touch-icon.png</xsl:text>
                </xsl:attribute>
            </link>

            <meta name="Generator">
                <xsl:attribute name="content">
                    <xsl:text>DSpace</xsl:text>
                    <xsl:if test="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='dspace'][@qualifier='version']">
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='dspace'][@qualifier='version']"/>
                    </xsl:if>
                </xsl:attribute>
            </meta>

            <!-- Add stylesheets -->

            <!--TODO figure out a way to include these in the concat & minify-->
            <xsl:for-each select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='stylesheet']">
                <link rel="stylesheet" type="text/css">
                    <xsl:attribute name="media">
                        <xsl:value-of select="@qualifier"/>
                    </xsl:attribute>
                    <xsl:attribute name="href">
                        <xsl:value-of select="$theme-path"/>
                        <xsl:value-of select="."/>
                    </xsl:attribute>
                </link>
            </xsl:for-each>

            <link rel="stylesheet" href="{concat($theme-path, 'styles/main.css')}"/>

            <!-- Add syndication feeds -->
            <xsl:for-each select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='feed']">
                <link rel="alternate" type="application">
                    <xsl:attribute name="type">
                        <xsl:text>application/</xsl:text>
                        <xsl:value-of select="@qualifier"/>
                    </xsl:attribute>
                    <xsl:attribute name="href">
                        <xsl:value-of select="."/>
                    </xsl:attribute>
                </link>
            </xsl:for-each>

            <!--  Add OpenSearch auto-discovery link -->
            <xsl:if test="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='opensearch'][@qualifier='shortName']">
                <link rel="search" type="application/opensearchdescription+xml">
                    <xsl:attribute name="href">
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='request'][@qualifier='scheme']"/>
                        <xsl:text>://</xsl:text>
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='request'][@qualifier='serverName']"/>
                        <xsl:text>:</xsl:text>
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='request'][@qualifier='serverPort']"/>
                        <xsl:value-of select="$context-path"/>
                        <xsl:text>/</xsl:text>
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='opensearch'][@qualifier='context']"/>
                        <xsl:text>description.xml</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="title" >
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='opensearch'][@qualifier='shortName']"/>
                    </xsl:attribute>
                </link>
            </xsl:if>

            <!-- The following javascript removes the default text of empty text areas when they are focused on or submitted -->
            <!-- There is also javascript to disable submitting a form when the 'enter' key is pressed. -->
            <script>
                //Clear default text of emty text areas on focus
                function tFocus(element)
                {
                if (element.value == '<i18n:text>xmlui.dri2xhtml.default.textarea.value</i18n:text>'){element.value='';}
                }
                //Clear default text of emty text areas on submit
                function tSubmit(form)
                {
                var defaultedElements = document.getElementsByTagName("textarea");
                for (var i=0; i != defaultedElements.length; i++){
                if (defaultedElements[i].value == '<i18n:text>xmlui.dri2xhtml.default.textarea.value</i18n:text>'){
                defaultedElements[i].value='';}}
                }
                //Disable pressing 'enter' key to submit a form (otherwise pressing 'enter' causes a submission to start over)
                function disableEnterKey(e)
                {
                var key;

                if(window.event)
                key = window.event.keyCode;     //Internet Explorer
                else
                key = e.which;     //Firefox and Netscape

                if(key == 13)  //if "Enter" pressed, then disable!
                return false;
                else
                return true;
                }
            </script>

            <xsl:text disable-output-escaping="yes">&lt;!--[if lt IE 9]&gt;
                &lt;script src="</xsl:text><xsl:value-of select="concat($theme-path, 'vendor/html5shiv/dist/html5shiv.js')"/><xsl:text disable-output-escaping="yes">"&gt;&#160;&lt;/script&gt;
                &lt;script src="</xsl:text><xsl:value-of select="concat($theme-path, 'vendor/respond/dest/respond.min.js')"/><xsl:text disable-output-escaping="yes">"&gt;&#160;&lt;/script&gt;
                &lt;![endif]--&gt;</xsl:text>

            <!-- Modernizr enables HTML5 elements & feature detects -->
            <script src="{concat($theme-path, 'vendor/modernizr/modernizr.js')}">&#160;</script>

            <!-- Add the title in -->
            <xsl:variable name="page_title" select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='title'][last()]" />
            <title>
                <xsl:choose>
                    <xsl:when test="starts-with($request-uri, 'page/about')">
                        <i18n:text>xmlui.mirage2.page-structure.aboutThisRepository</i18n:text>
                    </xsl:when>
                    <xsl:when test="not($page_title)">
                        <xsl:text>  </xsl:text>
                    </xsl:when>
                    <xsl:when test="starts-with($request-uri, 'accessibility')">
                        <i18n:text>Accessibility</i18n:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:copy-of select="$page_title/node()" />
                    </xsl:otherwise>
                </xsl:choose>
            </title>

            <!-- Head metadata in item pages -->
            <xsl:if test="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='xhtml_head_item']">
                <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='xhtml_head_item']"
                              disable-output-escaping="yes"/>
            </xsl:if>

            <!-- Add all Google Scholar Metadata values -->
            <xsl:for-each select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[substring(@element, 1, 9) = 'citation_']">
                <meta name="{@element}" content="{.}"></meta>
            </xsl:for-each>

        </head>
    </xsl:template>


    <!-- The header (distinct from the HTML head element) contains the title, subtitle, login box and various
        placeholders for header images -->
    <xsl:template name="buildHeader">
        <header class="era-header">

            <!-- Simple container for header logos -->
            <div class="container era-logos">
                <div class="row">
                    <div class="col-xs-3 col-sm-2">
                        <a href="{$context-path}/" title="Return to the ERA home page">
                            <img src="{$theme-path}images/era-logo.gif"  alt="Edinburgh Research Archive logo"/>
                        </a>
                    </div>
                    <div class="col-xs-6 col-sm-8 header-title">
                        <a href="{$context-path}/" id="era-title"  title="Return to the ERA home page">
                            <h1 class="hidden-xs hidden-sm">Edinburgh Research Archive</h1>
                        </a>
                    </div>
                    <div class="col-xs-3 col-sm-2">
                        <a href="https://www.ed.ac.uk/" class="pull-right"  title="External link to the University of Edinburgh's home page">
                            <img id="crest-head" src="{$theme-path}images/homecrest.png" alt="University of Edinburgh homecrest"/>
                        </a>
                    </div>
                </div>

                <div class="clearfix"></div>
            </div>

            <!-- Custom naviagtion layout -->
            <div class="navbar navbar-default navbar-static-top" role="navigation">
                <div class="container">
                    <div class="navbar-header">

                        <!-- Commented out due to ineffective display
                                Could be fixed if required -->
                        <button type="button" class="navbar-toggle" data-toggle="offcanvas">
                            <span class="sr-only">
                                <i18n:text>xmlui.mirage2.page-structure.toggleNavigation</i18n:text>
                            </span>
                            <span class="icon-bar"></span>
                            <span class="icon-bar"></span>
                            <span class="icon-bar"></span>
                        </button>

                        <!-- Custom trail implementation -->
                        <div class="pull-left">
                            <xsl:choose>
                                <xsl:when test="count(/dri:document/dri:meta/dri:pageMeta/dri:trail) > 1">
                                    <div class="breadcrumb dropdown visible-xs visible-sm">
                                        <a id="trail-dropdown-toggle" href="#" role="button" class="dropdown-toggle"
                                           data-toggle="dropdown">
                                            <xsl:variable name="last-node"
                                                          select="/dri:document/dri:meta/dri:pageMeta/dri:trail[last()]"/>
                                            <xsl:choose>
                                                <xsl:when test="$last-node/i18n:*">
                                                    <xsl:apply-templates select="$last-node/*"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:apply-templates select="$last-node/text()"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                            <xsl:text>&#160;</xsl:text>
                                            <b class="caret"/>
                                        </a>
                                        <ul class="dropdown-menu" role="menu" aria-labelledby="trail-dropdown-toggle">
                                            <xsl:apply-templates select="/dri:document/dri:meta/dri:pageMeta/dri:trail"
                                                                 mode="dropdown"/>
                                        </ul>
                                    </div>
                                    <ul class="breadcrumb hidden-xs hidden-sm">
                                        <xsl:apply-templates select="/dri:document/dri:meta/dri:pageMeta/dri:trail"/>
                                    </ul>
                                </xsl:when>
                                <xsl:when test="contains($request-uri, 'access')">
                                <ul class="breadcrumb">
                                        <xsl:apply-templates select="/dri:document/dri:meta/dri:pageMeta/dri:trail"/>
                                        <li>Accessibility</li>
                                    </ul>
                                </xsl:when>
                                <xsl:otherwise>
                                    <ul class="breadcrumb">
                                        <xsl:apply-templates select="/dri:document/dri:meta/dri:pageMeta/dri:trail"/>
                                    </ul>
                                </xsl:otherwise>
                            </xsl:choose>
                        </div>

                        <!-- Login added to navigation -->
                        <div class="navbar-header pull-right visible-xs hidden-sm hidden-md hidden-lg">
                            <ul class="nav nav-pills pull-left ">
                                <xsl:call-template name="languageSelection-xs"/>

                                <xsl:choose>
                                    <xsl:when test="/dri:document/dri:meta/dri:userMeta/@authenticated = 'yes'">
                                        <li class="dropdown">
                                            <button class="dropdown-toggle navbar-toggle navbar-link" id="user-dropdown-toggle-xs" href="#" role="button"  data-toggle="dropdown">
                                                <b class="visible-xs glyphicon glyphicon-user" aria-hidden="true"/>
                                            </button>
                                            <ul class="dropdown-menu pull-right" role="menu" aria-labelledby="user-dropdown-toggle-xs" data-no-collapse="true">
                                                <li>
                                                    <a href="{/dri:document/dri:meta/dri:userMeta/dri:metadata[@element='identifier' and @qualifier='url']}" alt="View profile" title="View profile">
                                                        <i18n:text>xmlui.EPerson.Navigation.profile</i18n:text>
                                                    </a>
                                                </li>
                                                <li>
                                                    <a href="{/dri:document/dri:meta/dri:userMeta/dri:metadata[@element='identifier' and @qualifier='logoutURL']}" alt="Logout from profile" title="Logout">
                                                        <i18n:text>xmlui.dri2xhtml.structural.logout</i18n:text>
                                                    </a>
                                                </li>
                                            </ul>
                                        </li>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <li>
                                            <form style="display: inline" action="{/dri:document/dri:meta/dri:userMeta/dri:metadata[@element='identifier' and @qualifier='loginURL']}" method="get">
                                                <button class="navbar-toggle navbar-link">
                                                    <b class="visible-xs glyphicon glyphicon-user" aria-hidden="true"/>
                                                </button>
                                            </form>
                                        </li>                                  
                                    </xsl:otherwise>
                                </xsl:choose>
                            </ul>
                        </div>
                    </div>

                    <!-- Account / Logout dropdown menu -->
                    <div class="navbar-header pull-right hidden-xs">

                        <ul class="nav navbar-nav pull-left" id="era-nav">
                            <xsl:choose>
                                <xsl:when test="/dri:document/dri:meta/dri:userMeta/@authenticated = 'yes'">
                                    <li class="dropdown">
                                        <a id="user-dropdown-toggle" href="#" role="button" class="dropdown-toggle"
                                           data-toggle="dropdown" alt="Account dropdown menu" title="Account dropdown menu">
                                            <span class="hidden-xs">
                                                <xsl:value-of select="/dri:document/dri:meta/dri:userMeta/dri:metadata[@element='identifier' and @qualifier='firstName']"/>
                                                <xsl:text> </xsl:text>
                                                <xsl:value-of select="/dri:document/dri:meta/dri:userMeta/dri:metadata[@element='identifier' and @qualifier='lastName']"/>
                                                &#160;
                                                <b class="caret"/>
                                            </span>
                                        </a>
                                        <ul class="dropdown-menu pull-right" role="menu" aria-labelledby="user-dropdown-toggle" data-no-collapse="true">
                                            <li>
                                                <a href="{/dri:document/dri:meta/dri:userMeta/dri:metadata[@element='identifier' and @qualifier='url']}" alt="View profile" title="View profile">
                                                    <i18n:text>xmlui.EPerson.Navigation.profile</i18n:text>
                                                </a>
                                            </li>
                                            <li>
                                                <a href="{/dri:document/dri:meta/dri:userMeta/dri:metadata[@element='identifier' and @qualifier='logoutURL']}" alt="Logout" title="logout">
                                                    <i18n:text>xmlui.dri2xhtml.structural.logout</i18n:text>
                                                    <i class="glyphicon glyphicon-log-out open-icon hidden" aria-hidden="true"/>
                                                </a>
                                            </li>
                                        </ul>
                                    </li>
                                </xsl:when>
                                <xsl:otherwise>
                                    <li>
                                        <a href="{/dri:document/dri:meta/dri:userMeta/dri:metadata[@element='identifier' and @qualifier='loginURL']}" alt="Login to profile" title="Login Link">
                                            <span class="hidden-xs">    
                                                <i18n:text>xmlui.dri2xhtml.structural.login</i18n:text>
                                                <i class="glyphicon glyphicon-log-in open-icon hidden" aria-hidden="true"/>
                                            </span>
                                        </a>
                                    </li>
                                </xsl:otherwise>
                            </xsl:choose>
                        </ul>

                        <button data-toggle="offcanvas" class="navbar-toggle visible-sm" type="button">
                            <span class="sr-only"><i18n:text>xmlui.mirage2.page-structure.toggleNavigation</i18n:text></span>
                            <span class="icon-bar"></span>
                            <span class="icon-bar"></span>
                            <span class="icon-bar"></span>
                        </button>

                    </div>
                </div>
            </div>

        </header>

    </xsl:template>


    <!-- The header (distinct from the HTML head element) contains the title, subtitle, login box and various
        placeholders for header images -->
    <xsl:template name="buildTrail">
        <div class="trail-wrapper">
            <div class="container">
                <div class="row">
                    <!--TODO-->
                    <div class="col-xs-12">
                        <xsl:choose>
                            <xsl:when test="count(/dri:document/dri:meta/dri:pageMeta/dri:trail) > 1">
                                <div class="breadcrumb dropdown visible-xs visible-sm">
                                    <a id="trail-dropdown-toggle" href="#" role="button" class="dropdown-toggle"
                                       data-toggle="dropdown">
                                        <xsl:variable name="last-node"
                                                      select="/dri:document/dri:meta/dri:pageMeta/dri:trail[last()]"/>
                                        <xsl:choose>
                                            <xsl:when test="$last-node/i18n:*">
                                                <xsl:apply-templates select="$last-node/*"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:apply-templates select="$last-node/text()"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                        <xsl:text>&#160;</xsl:text>
                                        <b class="caret"/>
                                    </a>
                                    <ul class="dropdown-menu" role="menu" aria-labelledby="trail-dropdown-toggle">
                                        <xsl:apply-templates select="/dri:document/dri:meta/dri:pageMeta/dri:trail"
                                                             mode="dropdown"/>
                                    </ul>
                                </div>
                                <ul class="breadcrumb hidden-xs hidden-sm">
                                    <xsl:apply-templates select="/dri:document/dri:meta/dri:pageMeta/dri:trail"/>
                                </ul>
                            </xsl:when>
                            <xsl:otherwise>
                                <ul class="breadcrumb">
                                    <xsl:apply-templates select="/dri:document/dri:meta/dri:pageMeta/dri:trail"/>
                                </ul>
                            </xsl:otherwise>
                        </xsl:choose>
                    </div>
                </div>
            </div>
        </div>
    </xsl:template>

    <!--The Trail-->
    <xsl:template match="dri:trail">
        <!--put an arrow between the parts of the trail-->
        <li>
            <xsl:if test="position()=1">
                <i class="glyphicon glyphicon-home" aria-hidden="true"/>&#160;
            </xsl:if>
            <!-- Determine whether we are dealing with a link or plain text trail link -->
            <xsl:choose>
                <xsl:when test="./@target">
                    <a alt="Breadcrumb link">
                        <xsl:attribute name="href">
                            <xsl:value-of select="./@target"/>
                        </xsl:attribute>
                        <xsl:apply-templates />
                    </a>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="class">active</xsl:attribute>
                    <xsl:apply-templates />
                </xsl:otherwise>
            </xsl:choose>
        </li>
    </xsl:template>

    <xsl:template match="dri:trail" mode="dropdown">
        <!--put an arrow between the parts of the trail-->
        <li role="presentation">
            <!-- Determine whether we are dealing with a link or plain text trail link -->
            <xsl:choose>
                <xsl:when test="./@target">
                    <a role="menuitem" alt="Breadcrumb link">
                        <xsl:attribute name="href">
                            <xsl:value-of select="./@target"/>
                        </xsl:attribute>
                        <xsl:if test="position()=1">
                            <i class="glyphicon glyphicon-home" aria-hidden="true" id="glyph-white" />&#160;
                        </xsl:if>
                        <xsl:apply-templates />
                    </a>
                </xsl:when>
                <xsl:when test="position() > 1 and position() = last()">
                    <xsl:attribute name="class">disabled</xsl:attribute>
                    <a role="menuitem" href="#" alt="Breadcrumb link">
                        <xsl:apply-templates />
                    </a>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="class">active</xsl:attribute>
                    <xsl:if test="position()=1">
                        <i class="glyphicon glyphicon-home" aria-hidden="true"/>&#160;
                    </xsl:if>
                    <xsl:apply-templates />
                </xsl:otherwise>
            </xsl:choose>
        </li>
    </xsl:template>

    <!--The License-->
    <xsl:template name="cc-license">
        <xsl:param name="metadataURL"/>
        <xsl:variable name="externalMetadataURL">
            <xsl:text>cocoon:/</xsl:text>
            <xsl:value-of select="$metadataURL"/>
            <xsl:text>?sections=dmdSec,fileSec&amp;fileGrpTypes=THUMBNAIL</xsl:text>
        </xsl:variable>

        <xsl:variable name="ccLicenseName"
                      select="document($externalMetadataURL)//dim:field[@element='rights']"
                />
        <xsl:variable name="ccLicenseUri"
                      select="document($externalMetadataURL)//dim:field[@element='rights'][@qualifier='uri']"
                />
        <xsl:variable name="handleUri">
            <xsl:for-each select="document($externalMetadataURL)//dim:field[@element='identifier' and @qualifier='uri']">
                <a>
                    <xsl:attribute name="href">
                        <xsl:copy-of select="./node()"/>
                    </xsl:attribute>
                    <xsl:copy-of select="./node()"/>
                </a>
                <xsl:if test="count(following-sibling::dim:field[@element='identifier' and @qualifier='uri']) != 0">
                    <xsl:text>, </xsl:text>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>

        <xsl:if test="$ccLicenseName and $ccLicenseUri and contains($ccLicenseUri, 'creativecommons')">
            <div about="{$handleUri}" class="row">
            <div class="col-sm-3 col-xs-12">
                <a rel="license"
                   href="{$ccLicenseUri}"
                   alt="{$ccLicenseName}"
                   title="{$ccLicenseName}"
                        >
                    <img class="img-responsive">
                        <xsl:attribute name="src">
                            <xsl:value-of select="concat($theme-path,'/images/cc-ship.gif')"/>
                        </xsl:attribute>
                        <xsl:attribute name="alt">
                            <xsl:value-of select="$ccLicenseName"/>
                        </xsl:attribute>
                    </img>
                </a>
            </div> <div class="col-sm-8">
                <span>
                    <i18n:text>xmlui.dri2xhtml.METS-1.0.cc-license-text</i18n:text>
                    <xsl:value-of select="$ccLicenseName"/>
                </span>
            </div>
            </div>
        </xsl:if>
    </xsl:template>

    <!-- Like the header, the footer contains various miscellaneous text, links, and image placeholders -->
    <xsl:template name="buildFooter">
        <footer>
            <div class="row">
                <hr/>
                <div class="col-xs-3 col-sm-2" id="footer-logo-cont">
                    <div id="footer-img-cont">
                        <a href="http://www.ed.ac.uk/schools-departments/information-services/about/organisation/library-and-collections" target="_blank" title="Library &amp; University Collections Home">
                            <img id="luc-logo" src="{$theme-path}images/CollectionsLUCLogo.png" />
                        </a>
                        <a href="http://www.is.ed.ac.uk" target="_blank" title="University of Edinburgh Information Services Home">
                            <img id="is-logo" src="{$theme-path}images/islogo.gif"/>
                        </a>
                    </div>
                </div>

                <div class="col-xs-6 col-sm-8 hidden-xs footer-links" >
                    <a href="http://www.ed.ac.uk/about/website/privacy" title="Privacy and Cookies Link" target="_blank">Privacy &amp; Cookies</a><xsl:text>  |  </xsl:text>
                    <a href="http://www.ed.ac.uk/schools-departments/information-services/services/research-support/publish-research/scholarly-communications/sct-policies/sct-policies-take-down" title="Takedown Policy Link">Takedown Policy</a><xsl:text>  |  </xsl:text>
                    <a href="{$context-path}/accessibility" title="Website Accessibility Link">Accessibility</a><xsl:text>  |  </xsl:text>
                    <a href="http://www.ed.ac.uk/schools-departments/information-services/research-support/publish-research/scholarly-communications/help" title="Contact the Edinburgh Research Archive">Contact</a>
                </div>

                <div class="col-xs-6 col-sm-8 visible-xs footer-links">
                    <div>
                        <a href="http://www.ed.ac.uk/about/website/privacy" title="Privacy and Cookies Link" target="_blank">Privacy &amp; Cookies</a>
                    </div>
                    <div>
                        <a href="http://www.ed.ac.uk/schools-departments/information-services/services/research-support/publish-research/scholarly-communications/sct-policies/sct-policies-take-down" title="Takedown Policy Link">Takedown Policy</a>
                    </div>
                    <div>
                        <a href="http://www.ed.ac.uk/about/website/accessibility" title="Website Accessibility Link" target="_blank">Accessibility</a>
                    </div>
                    <div>
                        <a href="http://www.ed.ac.uk/schools-departments/information-services/research-support/publish-research/scholarly-communications/help"  title="Contact the Edinburgh Research Archive">Contact</a>
                    </div>
                </div>

                <!-- Dynamic RSS feed pop-up menu -->
                <div class="col-xs-3 col-sm-2" id="rss-dropdown">
                    <div class="footer-links" id="footer-rss">
                        <img src="{concat($context-path, '/static/icons/feed.png')}" class="btn-xs" alt="xmlui.mirage2.navigation.rss.feed" i18n:attr="alt"/>
                        <a class="rss-dropdownbtn" alt="Link to RSS pop-up menu" title="RSS pop-up link">
                            RSS Feeds 
                        </a>
                    </div>
                    <!-- Pop-up block for RSS feed on :hover -->
                    <div class="rss-content">
                        <div class="rss-block">
                            <xsl:choose>
                                <!-- List of URL strings that do not have RSS compatability -->
                                <xsl:when test="not($request-uri = 'discover') 
                                                and not($request-uri = 'browse') 
                                                and not($request-uri = 'password-login') 
                                                and not($request-uri = 'community-list')
                                                and not($request-uri = 'recent-submissions') 
                                                and not($request-uri = 'identifier-not-found')
                                                and not(contains($request-uri, 'register')) 
                                                and not(contains($request-uri, 'handle'))
                                                and not(contains($request-uri, 'submit'))
                                                and not(contains($request-uri, 'submissions'))
                                                and not(contains($request-uri, 'continue'))
                                                and not(contains($request-uri, 'profile'))
                                                and not(contains($request-uri, 'xmlui'))">
                                        <xsl:call-template name="addRSSLinks"/>
                                </xsl:when>
                                <!-- Default display for no RSS feed -->
                                <xsl:otherwise>
                                    <p class="rss-p">RSS Feed not available for this page</p>                 
                                </xsl:otherwise>
                            </xsl:choose>
                        </div>
                    </div>
                </div>    
            </div>

            <!--Invisible link to HTML sitemap (for search engines) -->
            <a class="hidden">
                <xsl:attribute name="href">
                    <xsl:value-of
                            select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath'][not(@qualifier)]"/>
                    <xsl:text>/htmlmap</xsl:text>
                    <xsl:text>/accessibility</xsl:text>
                </xsl:attribute>
                <xsl:text>&#160;</xsl:text>
            </a>
            <p>&#160;</p>

        </footer>
    </xsl:template>

    <!-- RSS template taken from navigation.xsl to fill pop-up block -->
    <xsl:template name="addRSSLinks">
        <xsl:for-each select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='feed']">
            <a class="list-group-item" id="rss-item" alt="RSS feed link" title="RSS feed link">
                <xsl:attribute name="href">
                    <xsl:value-of select="."/>
                </xsl:attribute>
                <img src="{concat($context-path, '/static/icons/feed.png')}" class="btn-xs" alt="xmlui.mirage2.navigation.rss.feed" i18n:attr="alt"/>
                <xsl:choose>
                    <xsl:when test="contains(., 'rss_1.0')">
                        <xsl:text>1.0</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains(., 'rss_2.0')">
                        <xsl:text>2.0</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains(., 'atom_1.0')">
                        <xsl:text>Atom</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="@qualifier"/>
                    </xsl:otherwise>
                </xsl:choose>
            </a>
        </xsl:for-each>
    </xsl:template>




    <!--
            The meta, body, options elements; the three top-level elements in the schema
    -->




    <!--
        The template to handle the dri:body element. It simply creates the ds-body div and applies
        templates of the body's child elements (which consists entirely of dri:div tags).
    -->
    <xsl:template match="dri:body">
        <div>
            <xsl:if test="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='alert'][@qualifier='message']">
                <div class="alert">
                    <button type="button" class="close" data-dismiss="alert">&#215;</button>
                    <xsl:copy-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='alert'][@qualifier='message']/node()"/>
                </div>
            </xsl:if>

            <!-- Check for the custom pages -->
            <xsl:choose>
                <xsl:when test="starts-with($request-uri, 'page/about')">
                    <div class="hero-unit">
                        <h1><i18n:text>xmlui.mirage2.page-structure.heroUnit.title</i18n:text></h1>
                        <p><i18n:text>xmlui.mirage2.page-structure.heroUnit.content</i18n:text></p>
                    </div>
                </xsl:when>
                <xsl:when test="contains($request-uri, 'accessibility')">
                    <div class="hero-unit">
                        <div class="content">
                            <h2 class="ds-div-head page-header" alt="page title">Accessibility Statement for the Edinburgh Research Archive</h2>
                            <p>
                                This is the website accessibility statement in line with Public Sector Body (Websites and Mobile Applications) (No. 2) Accessibility Regulations 2018
                            </p>
                            <p>
                                The online Edinburgh Research Archive is run by the University of Edinburgh. We want as many people as possible to be able to use this website. For example, that means you should be able to:
                            </p>
                            <ul id="access-ul">
                                <li>
                                    change most of the colours, contrast levels and fonts
                                </li>
                                <li>
                                    navigate most of the website using just a keyboard
                                </li>
                                <li>
                                    navigate most of the website using speech recognition software
                                </li>
                                <li>
                                    listen to most of the website using a screen reader (including the most recent versions of JAWS, NVDA and VoiceOver)
                                </li>
                                <li>
                                    ensure no information is conveyed by colour or sound only
                                </li>
                            </ul>
                            <p>
                                We’ve also made the website text as simple as possible to understand.
                            </p>


                            <h2 class="ds-div-head page-header" >
                                Customising the website
                            </h2>
                            <p>
                                AbilityNet has advice on making your device easier to use if you have a disability.
                            </p>
                            <p>
                                <a href="https://mcmw.abilitynet.org.uk/" title="External link to AbilityNet website" id="access-link">                                   
                                    <p>AbilityNet - My computer my way</p>
                                </a>
                            </p>
                            <p>
                                With a few simple steps you can customise the appearance of our website to make it easier to read and navigate.
                            </p>
                            <p>
                                <a href="https://www.edweb.ed.ac.uk/about/website/accessibility/customising-site" title="External link to EdWeb website customising page" id="access-link">
                                    <p>Additional information on how to customise our website appearance</p>
                                </a>
                            </p>


                            <h2 class="ds-div-head page-header" >How accessible this website is</h2>
                            <p >
                                We know some parts of this website are not fully accessible:
                            </p>
                            <ul id="access-ul">
                                <li>
                                    May not be fully compatible with screen readers
                                </li>
                                <li>
                                    May not be fully compatible with other forms of assistive technology e.g. Read and Write, Zoomtext
                                </li>
                                <li>
                                    May not be able to access all content by using the keyboard alone and it is unclear where you have tabbed to
                                </li>
                                <li>
                                    Some text is lost at certain levels of magnification
                                </li>
                                <li>
                                    There is a lot of movement on the site
                                </li>
                                <li>
                                    Not all colour contrasts meet recommended WCAG 2.1 AA standards
                                </li>
                                <li>
                                    A user is not notified when a link opens a new window
                                </li>
                            </ul>
                            
                            
                            <h2 class="ds-div-head page-header" >What to do if you cannot access parts of this website</h2>
                            <p>
                                Please note that if you require any content or web related resources such as media, documents or downloads in an alternative format please contact the Information Services Helpline on <a href="tel: 0131 651 5151" title="Clink to call the Edinburgh Research Archive" id="access-link">0131 651 5151</a> or use their online contact form.
                            </p>
                            
                            
                            <h2 class="ds-div-head page-header">
                                Reporting accessibility problems with this website
                            </h2>
                            <p>
                                We’re always looking to improve the accessibility of this website. 
                                If you find any problems not listed on this page or think we’re not meeting accessibility requirements please let us know by contacting the Information Services Helpline on <a href="tel: 0131 651 5151" title="Clink to call the Edinburgh Research Archive" id="access-link">0131 651 5151</a>. 
                            </p>
                            <p>
                                We’ll consider your request and get back to you in 5 working days.
                            </p>


                            <h2 class="ds-div-head page-header">Enforcement procedure</h2>
                            <p>
                                The Equality and Human Rights Commission (EHRC) is responsible for enforcing the Public Sector Bodies (Websites and Mobile Applications) (No. 2) Accessibility Regulations 2018 (the ‘accessibility regulations’). If you’re not happy with how we respond to your complaint please contact the Equality Advisory and Support Service (EASS) directly.
                            </p>
                            <p>
                                <a href="https://www.equalityadvisoryservice.com/" title="External link to Equality Advisory and Support Service website" id="access-link">Contact details for the Equality Advisory and Support Service (EASS)</a>
                            </p>
                            <p>
                                <strong>Contacting us by phone using British Sign Language</strong>
                            </p>
                            <p>
                                British Sign Language service<br></br>
                                British Sign Language Scotland runs a service for British Sign Language users and all of Scotland’s public bodies using video relay. This enables sign language users to contact public bodies and vice versa. The service operates from 8am to 12 midnight, 7 days a week. 
                            </p>
                            <p>
                                <a href="https://contactscotland-bsl.org" title="External link to British Sign Language Scotland website" id="access-link">British Sign Language Scotland service details</a>
                            </p>
                            <p>
                                <strong>Technical information about this website’s accessibility</strong>
                            </p>
                            <p>
                                The University of Edinburgh is committed to making its website accessible, in accordance with the Public Sector Bodies (Websites and Mobile Applications) (No. 2) Accessibility Regulations 2018.
                            </p>
                            <p>
                                This website is partially compliant with the Web Content Accessibility Guidelines 2.1 AA standard, due to the non-compliances listed below.
                            </p>
                            <p>
                                The full guidelines are available at:
                            </p>
                            <p>
                                <a href="https://www.w3.org/TR/WCAG21/" title="External link to W3 Web Content Accessibility Guidelines" id="access-link">Web Content Accessibility Guidelines version 2.1</a>
                            </p>


                            <h2 class="ds-div-head page-header">Non accessible content</h2>
                            <p>
                                The content listed below is non-accessible for the following reasons.
                            </p>
                            <p>
                                Noncompliance with the accessibility regulations
                            </p>
                            <p>
                                The following items to not comply with the WCAG 2.1 AA success criteria:
                            </p>
                            <ul id="access-ul">
                                <li>
                                    It is not possible to use a keyboard to access all the content <br></br>
                                    <a href="https://www.w3.org/TR/WCAG21/#keyboard-accessible" title="External link to W3 Keyboard Accessibility Guidelines" id="access-link">2.1 - Keyboard accessible</a>
                                </li>
                                <li>
                                    Information is conveyed as an image of text rather than as text itelf so that it's not compatible with screen readers and other assistive technology <br></br>
                                    <a href="https://www.w3.org/TR/WCAG21/#images-of-text" title="External link to W3 Images of Text Guidelines" id="access-link">1.4.5 - Images of text</a>
                                </li>
                                <li>
                                    Most tooltips disappear as soon as the cursor moves. Also tooltips are not always present for all icons and images. <br></br> 

                                    <a href="https://www.w3.org/TR/WCAG21/#content-on-hover-or-focus" title="External link to W3 Content on Hover or Focus Guidelines" id="access-link">1.4.3 - Contrast (Minimum)</a>
                                </li>
                                <li>
                                    There may not be sufficient colour contrast between font and background colours especially where the text size is very small. <br></br> 

                                    <a href="https://www.w3.org/TR/2008/REC-WCAG20-20081211/#visual-audio-contrast-contrast" title="External link to W3 Visual and Audio Contrast Guidelines" id="access-link">1.4.13 - Content on Hover or Focus</a>
                                </li>
                                <li>
                                    Visual information to identify user interface components, such as keyboard focus, do not always have a sufficient contrast ratio <br></br>

                                    <a href="https://www.w3.org/TR/WCAG21/#non-text-contrast" title="External link to W3 Non-text Contrast Guidelines" id="access-link">1.4.11 - Non-text contrast</a>
                                </li>
                                <li>
                                    Some content cannot be presented without loss of information when magnified to the maximum browser level <br></br>

                                    <a href="https://www.w3.org/TR/WCAG21/#reflow" title="External link to W3 Reflow Guidelines" id="access-link">1.4.10 - Reflow</a>
                                </li>
                                <li>
                                    It might not be possible for all form fields to be programmatically determined. This means that when using auto-fill functionality for forms not all fields will identify the meaning for input data accurately <br></br>

                                    <a href="https://www.w3.org/TR/WCAG21/#identify-input-purpose" title="External link to W3 Identify Input Purpose Guidelines" id="access-link">1.3.5 - Identify Input Purpose</a>
                                </li>
                                <li>
                                    Some content cannot be presented without loss of information if the line height, paragraph spacing, letter spacing or word spacing is increased. <br></br>

                                    <a href="https://www.w3.org/TR/WCAG21/#text-spacing" title="External link to W3 ext Spacing Guidelines" id="access-link">1.4.12 - Text Spacing</a>
                                </li>
                                <li>
                                    There is content that has moving, blinking or scrolling information that (1) starts automatically, (2) lasts more than five seconds, and (3) is presented in parallel with other content, there is a mechanism for the user to pause, stop, or hide it unless the movement, blinking, or scrolling is part of an activity where it is essential. <br></br>

                                    <a href="https://www.w3.org/TR/WCAG21/#pause-stop-hide" title="External link to W3 Pause, Stop and Hide Guidelines" id="access-link">2.2.2- Pause, Stop and Hide</a>
                                </li>
                            </ul>
                            <p>
                                Unless specified otherwise a complete solution or significant improvement will be in place by September 2020. We also plan to remove the use of italics and continuous capitals wherever possible. <br></br>
                            </p>


                            <h2 class="ds-div-head page-header">How We Tested This Website</h2>
                            <p>
                                This system was last tested by the University of Edinburgh’s Web Developers in October 2019 via sampling the majority of pages across the website. 
                                We tested the system on suite of operating systems and browsers including the Internet Explorer 11 as this is the browsers most commonly used by disabled users due to its accessibility features and compatibility with assistive technology, as shown by the Government Assistive Technology Survey.
                                We are in the process of undertaking further accessibility testing with the Information Services Disability Team. This testing will include
                            </p>
                            <p>
                                We tested:
                            </p>
                            <ul id="access-ul">
                                <li>
                                    Spellcheck functionality
                                </li>
                                <li>
                                    Data validation
                                </li>
                                <li>
                                    Scaling using different resolutions
                                </li>
                                <li>
                                    Options to customise the interface (magnification, font and background colour changing etc)
                                </li>
                                <li>
                                    Keyboard navigation
                                </li>
                                <li>
                                    Warning of links opening in a new tab or window
                                </li>
                                <li>
                                    Information conveyed in colour or sound only
                                </li>
                                <li>
                                    Flashing or scrolling text
                                </li>
                                <li>
                                    Operability if Javascript is disabled
                                </li>
                                <li>
                                    Use with screenreading software (JAWS) 
                                </li>
                                <li>
                                    TextHelp Read and Write (assistive software)
                                </li>
                                <li>
                                    Zoomtext (assistive software)
                                </li>
                                <li>
                                    Time limits
                                </li>
                                <li>
                                    Access to specialist help
                                </li>
                            </ul>


                            <h2 class="ds-div-head page-header">What we’re doing to improve accessibility</h2>
                            <p>
                                Once the further accessibility testing is complete, we work with the developers to address these issues and deliver a solution or suitable workaround. 
                                We are in the process of undertaking further accessibility testing with the Information Services Disability Team
                            </p>
                            <p>
                                We will continue to monitor system accessibility and will carry out further accessibility testing as these issues are resolved. 
                                However, due to the complex nature of the information displayed it may not be possible to resolve all accessibility issues. 
                                If this is the case, we will ensure reasonable adjustments are in place to make sure no user is disadvantaged. 
                                We plan to have resolved the majority of accessibility issues by September 2020 at the latest.
                            </p>
                            

                            <h2 class="ds-div-head page-header">Information Services and accessibility</h2>
                            <p>
                                Information Services (IS) has further information on accessibility including assistive technology, creating accessible documents, and services IS provides for disabled users.
                            </p>
                            <p>
                                <a href="https://www.ed.ac.uk/information-services/help-consultancy/accessibility" id="access-link">
                                    Assistive technology, creating accessible documents, and services IS provides for disabled users
                                </a>
                            </p>

                            <h2 class="ds-div-head page-header">A-Z list of higher education terms</h2>
                            <p>
                                This glossary includes common abbreviations and acronyms used across the University of Edinburgh website.                            
                            </p>
                            <p>
                                <a href="https://www.ed.ac.uk/about/website/accessibility/list-terms" id="access-link">
                                    A-Z list of higher education terms
                                </a>
                            </p>

                            <h2 class="ds-div-head page-header">Requesting web content in alternative formats</h2>
                            <p>
                                Please note that if you require any content or web related resources such as media, documents or downloads in an alternative format please contact the Information Services Helpline on <a href="tel: 0131 651 5151" title="Clink to call the Edinburgh Research Archive">0131 651 5151</a> or use their online contact form.                            
                            </p>

                            <h2 class="ds-div-head page-header">Information Services online contact form</h2>
                            <p>
                                <a href="http://www.ishelpline.ed.ac.uk/forms/" id="access-link">
                                    Get support
                                </a>
                            </p>    

                            
                            <p>
                                <strong>This statement was prepared on October 2019. It was last updated on October 2019.</strong>
                            </p>
                        </div>
                    </div>
                </xsl:when>
                <!-- Otherwise use default handling of body -->
                <xsl:otherwise>
                    <xsl:apply-templates />
                </xsl:otherwise>
            </xsl:choose>

        </div>
    </xsl:template>


    <!-- Currently the dri:meta element is not parsed directly. Instead, parts of it are referenced from inside
        other elements (like reference). The blank template below ends the execution of the meta branch -->
    <xsl:template match="dri:meta">
    </xsl:template>

    <!-- Meta's children: userMeta, pageMeta, objectMeta and repositoryMeta may or may not have templates of
        their own. This depends on the meta template implementation, which currently does not go this deep.
    <xsl:template match="dri:userMeta" />
    <xsl:template match="dri:pageMeta" />
    <xsl:template match="dri:objectMeta" />
    <xsl:template match="dri:repositoryMeta" />
    -->

    <xsl:template name="addJavascript">

        <!--TODO concat & minify!-->

        <script>
            <xsl:text>if(!window.DSpace){window.DSpace={};}window.DSpace.context_path='</xsl:text><xsl:value-of select="$context-path"/><xsl:text>';window.DSpace.theme_path='</xsl:text><xsl:value-of select="$theme-path"/><xsl:text>';</xsl:text>
        </script>
        

        <!--inject scripts.html containing all the theme specific javascript references
        that can be minified and concatinated in to a single file or separate and untouched
        depending on whether or not the developer maven profile was active-->
        <xsl:variable name="scriptURL">
            <xsl:text>cocoon://themes/</xsl:text>
            <!--we can't use $theme-path, because that contains the context path,
            and cocoon:// urls don't need the context path-->
            <xsl:value-of select="$pagemeta/dri:metadata[@element='theme'][@qualifier='path']"/>
            <xsl:text>scripts-dist.xml</xsl:text>
        </xsl:variable>
        <xsl:for-each select="document($scriptURL)/scripts/script">
            <script src="{$theme-path}{@src}">&#160;</script>
        </xsl:for-each>

        <!-- Add javascipt specified in DRI -->
        <xsl:for-each select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='javascript'][not(@qualifier)]">
            <script>
                <xsl:attribute name="src">
                    <xsl:value-of select="$theme-path"/>
                    <xsl:value-of select="."/>
                </xsl:attribute>&#160;</script>
        </xsl:for-each>

        <!-- add "shared" javascript from static, path is relative to webapp root-->
        <xsl:for-each select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='javascript'][@qualifier='static']">
            <!--This is a dirty way of keeping the scriptaculous stuff from choice-support
            out of our theme without modifying the administrative and submission sitemaps.
            This is obviously not ideal, but adding those scripts in those sitemaps is far
            from ideal as well-->
            <xsl:choose>
                <xsl:when test="text() = 'static/js/choice-support.js'">
                    <script>
                        <xsl:attribute name="src">
                            <xsl:value-of select="$theme-path"/>
                            <xsl:text>js/choice-support.js</xsl:text>
                        </xsl:attribute>&#160;</script>
                </xsl:when>
                <xsl:when test="not(starts-with(text(), 'static/js/scriptaculous'))">
                    <script>
                        <xsl:attribute name="src">
                            <xsl:value-of
                                    select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath'][not(@qualifier)]"/>
                            <xsl:text>/</xsl:text>
                            <xsl:value-of select="."/>
                        </xsl:attribute>&#160;</script>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>

        <!-- add setup JS code if this is a choices lookup page -->
        <xsl:if test="dri:body/dri:div[@n='lookup']">
            <xsl:call-template name="choiceLookupPopUpSetup"/>
        </xsl:if>

        <!-- Add a google analytics script if the key is present -->
        <xsl:if test="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='google'][@qualifier='analytics']">
            <script><xsl:text>
                  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
                  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
                  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
                  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

                  ga('create', '</xsl:text><xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='google'][@qualifier='analytics']"/>
                  <xsl:text>', '</xsl:text><xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='request'][@qualifier='serverName']"/><xsl:text>');
                  ga('send', 'pageview');
           </xsl:text></script>
        </xsl:if>

        <!-- JAVASCRIPT CONDITIONALS -->

        <!-- Javacript conditional to render css on Firefox browsers -->
        <!-- Super hacky but does the job -->
        <script>
            <xsl:text>
                if(navigator.userAgent.toLowerCase().indexOf('firefox') > -1){
                    document.getElementById("firefox-style").style.left = "30px";
                }
            </xsl:text>
        </script>

        <!-- Authentication test to supress sidebar facets -->
        <!-- Simple auth check to trigger javascript supression of specific sidebar groups via css -->
        <xsl:if test="$auth = 'no'">
            <script>
                document.getElementById("aspect_viewArtifacts_Navigation_list_context").style.display = "none";
                document.getElementById("aspect_viewArtifacts_Navigation_list_administrative").style.display = "none";
                document.getElementById("aspect_statisticsIRUS_Navigation_list_statistics").style.display = "none";
            </script>
        </xsl:if>
        <xsl:if test="$auth = 'yes'">
            <script>
                document.getElementById("aspect_viewArtifacts_Navigation_list_context").style.display = "block";
                document.getElementById("aspect_viewArtifacts_Navigation_list_administrative").style.display = "block";
            </script>
        </xsl:if>



       <!-- <xsl:if test="contains($uri-string, 'Viewer.trail/handle')">
=======
=======
        <xsl:if test="$request-uri = ''">
            <script>
                document.querySelectorAll("h2")[0].style.display = "none";
            </script>
        </xsl:if>

        <xsl:if test="contains($uri-string, 'Viewer.trail/handle') or contains($request-uri, 'communit')
<<<<<<< HEAD
<<<<<<< HEAD
                        or contains($request-uri, 'browse') or $request-uri = 'password-login'">
>>>>>>> code tidy
=======
                        or contains($request-uri, 'browse') or $request-uri = 'password-login'
                        or contains($request-uri, 'access')">
>>>>>>> Accessibility footer link fix
=======
                        or contains($request-uri, 'browse') or $request-uri = 'password-login'
                        or contains($request-uri, 'access')">
>>>>>>> Ported item-view XSL from 4 to not link restricted bitstreams
            <script>
                document.getElementById("aspect_discovery_Navigation_list_discovery").style.display = "none";
            </script>
        </xsl:if>
<<<<<<< HEAD
<<<<<<< HEAD
        <xsl:if test="contains($uri-string, '/communities')">
=======
        <xsl:if test="contains($request-uri, 'submi') or contains($request-uri, 'statistics')
                        or contains($request-uri, 'admin/') or contains($request-uri, 'irus')">
            <script>
                document.getElementById("aspect_discovery_Navigation_list_discovery").style.display = "none";
                document.getElementById("aspect_viewArtifacts_Navigation_list_context").style.display = "none";
            </script>
        </xsl:if>

<<<<<<< HEAD
<<<<<<< HEAD
        <xsl:if test="contains($request-uri, 'communit')">
>>>>>>> code tidy
            <script>
                document.getElementById("aspect_discovery_Navigation_list_discovery").style.display = "none";
            </script>
        </xsl:if>
<<<<<<< HEAD
        <xsl:if test="contains($uri-string, '/browse')">
=======
        <xsl:if test="contains($uri-string, 'community')">
>>>>>>> Accessibility page added
=======
        
        <xsl:if test="contains($uri-string, 'browse')">
>>>>>>> code tidy
            <script>
                document.getElementById("aspect_discovery_Navigation_list_discovery").style.display = "none";
            </script>
        </xsl:if>
        <xsl:if test="$request-uri = 'password-login'">
            <script>
                document.getElementById("aspect_discovery_Navigation_list_discovery").style.display = "none";  
            </script>
        </xsl:if>

         <xsl:if test="contains($request-uri, 'statistics')">
            <script>
                document.getElementById("aspect_viewArtifacts_Navigation_list_context").style.display = "none";
                document.getElementById("aspect_discovery_Navigation_list_discovery").style.display = "none";
            </script>
        </xsl:if>
        <xsl:if test="contains($request-uri, 'admin/')">
            <script>
                document.getElementById("aspect_viewArtifacts_Navigation_list_context").style.display = "none";
                document.getElementById("aspect_discovery_Navigation_list_discovery").style.display = "none";    
            </script>
<<<<<<< HEAD
        </xsl:if>
        <xsl:if test="$request-uri = 'password-login'">
            <script>
                document.getElementById("aspect_discovery_Navigation_list_discovery").style.display = "none";  
            </script>
        </xsl:if>-->

    </xsl:template>

    <!--The Language Selection-->
    <xsl:template name="languageSelection">
        <xsl:if test="count(/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='page'][@qualifier='supportedLocale']) &gt; 1">
            <li id="ds-language-selection" class="dropdown">
                <xsl:variable name="active-locale" select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='page'][@qualifier='currentLocale']"/>
                <a id="language-dropdown-toggle" href="#" role="button" class="dropdown-toggle" data-toggle="dropdown" alt="Select website language" title="Select website language">
                    <span class="hidden-xs">
                        <xsl:value-of
                                select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='supportedLocale'][@qualifier=$active-locale]"/>
                        <xsl:text>&#160;</xsl:text>
                        <b class="caret"/>
                    </span>
                </a>
                <ul class="dropdown-menu pull-right" role="menu" aria-labelledby="language-dropdown-toggle" data-no-collapse="true">
                    <xsl:for-each
                            select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='page'][@qualifier='supportedLocale']">
                        <xsl:variable name="locale" select="."/>
                        <li role="presentation">
                            <xsl:if test="$locale = $active-locale">
                                <xsl:attribute name="class">
                                    <xsl:text>disabled</xsl:text>
                                </xsl:attribute>
                            </xsl:if>
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:value-of select="$current-uri"/>
                                    <xsl:text>?locale-attribute=</xsl:text>
                                    <xsl:value-of select="$locale"/>
                                </xsl:attribute>
                                <xsl:value-of
                                        select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='supportedLocale'][@qualifier=$locale]"/>
                            </a>
                        </li>
                    </xsl:for-each>
                </ul>
            </li>
        </xsl:if>
    </xsl:template>

    <xsl:template name="languageSelection-xs">
        <xsl:if test="count(/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='page'][@qualifier='supportedLocale']) &gt; 1">
            <li id="ds-language-selection-xs" class="dropdown">
                <xsl:variable name="active-locale" select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='page'][@qualifier='currentLocale']"/>
                <button id="language-dropdown-toggle-xs" href="#" role="button" class="dropdown-toggle navbar-toggle navbar-link" data-toggle="dropdown">
                    <b class="visible-xs glyphicon glyphicon-globe" aria-hidden="true"/>
                </button>
                <ul class="dropdown-menu pull-right" role="menu" aria-labelledby="language-dropdown-toggle-xs" data-no-collapse="true">
                    <xsl:for-each
                            select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='page'][@qualifier='supportedLocale']">
                        <xsl:variable name="locale" select="."/>
                        <li role="presentation">
                            <xsl:if test="$locale = $active-locale">
                                <xsl:attribute name="class">
                                    <xsl:text>disabled</xsl:text>
                                </xsl:attribute>
                            </xsl:if>
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:value-of select="$current-uri"/>
                                    <xsl:text>?locale-attribute=</xsl:text>
                                    <xsl:value-of select="$locale"/>
                                </xsl:attribute>
                                <xsl:value-of
                                        select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='supportedLocale'][@qualifier=$locale]"/>
                            </a>
                        </li>
                    </xsl:for-each>
                </ul>
            </li>
        </xsl:if>
    </xsl:template>


</xsl:stylesheet>