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
                            <img src="{$theme-path}images/era-logo.gif" alt="Edinburgh Research Archive logo"  title="Return to the ERA home page"/>
                        </a>
                    </div>
                    <div class="col-xs-6 col-sm-8 header-title">
                        <a href="{$context-path}/" id="era-title" title="Return to the ERA home page">
                            <h1 class="hidden-xs hidden-sm">Edinburgh Research Archive</h1>
                        </a>
                    </div>
                    <div class="col-xs-3 col-sm-2">
                        <a href="https://www.ed.ac.uk/" class="pull-right" title="External link to the University of Edinburgh's home page">
                            <img id="crest-head" src="{$theme-path}images/homecrest.png" alt="University of Edinburgh homecrest" title="External link to the University of Edinburgh's home page"/>
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
                                                    <a href="{/dri:document/dri:meta/dri:userMeta/dri:metadata[@element='identifier' and @qualifier='url']}" title="View profile">
                                                        <i18n:text>xmlui.EPerson.Navigation.profile</i18n:text>
                                                    </a>
                                                </li>
                                                <li>
                                                    <a href="{/dri:document/dri:meta/dri:userMeta/dri:metadata[@element='identifier' and @qualifier='logoutURL']}" title="Logout">
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
                                           data-toggle="dropdown" title="Account dropdown menu">
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
                                                <a href="{/dri:document/dri:meta/dri:userMeta/dri:metadata[@element='identifier' and @qualifier='url']}" title="View profile">
                                                    <i18n:text>xmlui.EPerson.Navigation.profile</i18n:text>
                                                </a>
                                            </li>
                                            <li>
                                                <a href="{/dri:document/dri:meta/dri:userMeta/dri:metadata[@element='identifier' and @qualifier='logoutURL']}" title="logout">
                                                    <i18n:text>xmlui.dri2xhtml.structural.logout</i18n:text>
                                                    <i class="glyphicon glyphicon-log-out open-icon hidden" aria-hidden="true"/>
                                                </a>
                                            </li>
                                        </ul>
                                    </li>
                                </xsl:when>
                                <xsl:otherwise>
                                    <li>
                                        <a href="{/dri:document/dri:meta/dri:userMeta/dri:metadata[@element='identifier' and @qualifier='loginURL']}" title="Login Link">
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
                    <a title="Breadcrumb link">
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
                    <a role="menuitem" title="Breadcrumb link">
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
                    <a role="menuitem" href="#" title="Breadcrumb link">
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
                <div class="col-xs-3 col-sm-2">
                    <div class="footer-img-cont">
                        <a href="https://www.ed.ac.uk/schools-departments/information-services/about/organisation/library-and-collections" target="_blank" title="Library &amp; University Collections Home">
                            <img class="luc-logo" src="{$theme-path}images/CollectionsLUCLogo.png" title="Library &amp; University Collections Home" alt="Library &amp; University Collections Home"/>
                        </a>
                        <a href="https://www.is.ed.ac.uk" target="_blank" title="University of Edinburgh Information Services Home">
                            <img class="is-logo" src="{$theme-path}images/islogo.gif" title="University of Edinburgh Information Services Home" alt="University of Edinburgh Information Services Home"/>
                        </a>
                    </div>
                </div>

                <div class="col-xs-6 col-sm-8 hidden-xs footer-links" >
                    <a href="https://www.ed.ac.uk/about/website/privacy" title="Privacy and Cookies Link" target="_blank">Privacy &amp; Cookies</a><xsl:text>  |  </xsl:text>
                    <a href="https://www.ed.ac.uk/schools-departments/information-services/services/research-support/publish-research/scholarly-communications/sct-policies/sct-policies-take-down" title="Takedown Policy Link">Takedown Policy</a><xsl:text>  |  </xsl:text>
                    <a href="{$context-path}/accessibility" title="Website Accessibility Link">Accessibility</a><xsl:text>  |  </xsl:text>
                    <a href="https://www.ed.ac.uk/information-services/research-support/publish-research/scholarly-communications/open-access-help" title="Contact the Edinburgh Research Archive">Contact</a>
                </div>

                <div class="col-xs-6 col-sm-8 visible-xs footer-links">
                    <div>
                        <a href="https://www.ed.ac.uk/about/website/privacy" title="Privacy and Cookies Link" target="_blank">Privacy &amp; Cookies</a>
                    </div>
                    <div>
                        <a href="https://www.ed.ac.uk/schools-departments/information-services/services/research-support/publish-research/scholarly-communications/sct-policies/sct-policies-take-down" title="Takedown Policy Link">Takedown Policy</a>
                    </div>
                    <div>
                        <a href="https://www.ed.ac.uk/about/website/accessibility" title="Website Accessibility Link" target="_blank">Accessibility</a>
                    </div>
                    <div>
                        <a href="https://www.ed.ac.uk/information-services/research-support/publish-research/scholarly-communications/open-access-help" title="Contact the Edinburgh Research Archive">Contact</a>
                    </div>
                </div>

                <!-- Dynamic RSS feed pop-up menu -->
                <div class="col-xs-3 col-sm-2 rss-dropdown">
                    <div class="footer-links footer-rss">
                        <img src="{concat($context-path, '/static/icons/feed.png')}" class="btn-xs" alt="xmlui.mirage2.navigation.rss.feed" title="xmlui.mirage2.navigation.rss.feed" i18n:attr="alt"/>
                        <a class="rss-dropdownbtn" title="RSS pop-up link">
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
            <a class="list-group-item rss-item" title="RSS feed link">
                <xsl:attribute name="href">
                    <xsl:value-of select="."/>
                </xsl:attribute>
                <img src="{concat($context-path, '/static/icons/feed.png')}" class="btn-xs" title="xmlui.mirage2.navigation.rss.feed" alt="xmlui.mirage2.navigation.rss.feed" i18n:attr="alt"/>
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
                        
                            <h1>Accessibility statement for the <a href="https://era.ed.ac.uk/">Edinburgh Research Archive</a></h1>
                            <p><strong>Website accessibility statement in line with Public Sector Body (Websites and Mobile Applications) (No. 2) Accessibility Regulations 2018</strong></p>
                            <p>This accessibility statement applies to the “<a href="https://era.ed.ac.uk/">Edinburgh Research Archive</a>” - <a href="https://eresearch.qmu.ac.u">https://era.ed.ac.uk/</a></p>
                            <p>This website is maintained by the Digital Library team, Library and University Collections, the University of Edinburgh on behalf of Queen Margaret University. We want as many people as possible to be able to use this application. For example, that means you should be able to:</p>
                            <ul class="accessibility-list">
                                <li>Using your browser settings, change colours, contrast levels and fonts</li>
                                <li>zoom in up to 200% without the text spilling off the screen</li>
                                <li>navigate most of the website using just a keyboard</li>
                                <li>navigate most of the website using speech recognition software such as Dragon Naturally Speaking</li>
                                <li>listen to most of the website using a screen reader (including the most recent versions of Job Access with Speech (JAWS)</li>
                                <li>Experience no time limits when using the site</li>
                                <li>There is no flashing, scrolling or moving text</li>
                            </ul>
                            <p>We've also made the website text as simple as possible to understand.</p>

                            <h2>Customising the website</h2>
                            <p>AbilityNet has advice on making your device easier to use if you have a disability. This is an external site with suggestions to make your computer more accessible:</p>
                            <p><a href="https://mcmw.abilitynet.org.uk/">AbilityNet - My computer my way</a></p>
                            <p>With a few simple steps you can customise the appearance of our website using your browser settings to make it easier to read and navigate:</p>
                            <p><a href="https://www.ed.ac.uk/about/website/accessibility/customising-site">Additional information on how to customise our website appearance</a></p>
                            <p>If you are a member of University staff or a student, you can use the free SensusAccess accessible document conversion service:</p>
                            <p><a href="https://www.ed.ac.uk/student-disability-service/staff/supporting-students/accessible-technology">SenusAccess Information</a></p>

                            <h2>How accessible this website is</h2>
                            <p>We know some parts of this website are not fully accessible:</p>
                            <ul class="accessibility-list">
                                <li>Tabbing highlights sometimes obscure the content they are highlighting</li>
                                <li>It can be hard to tell where you have tabbed to using keyboard navigation</li>
                                <li>Data entry does not alert users to information entered incorrect format and error messages are in a small font with a poor colour contrast</li>
                                <li>Not all colour contrasts meet the recommended levels</li>
                                <li>Not all non-text content has appropriate alternative text</li>
                                <li>No 'skip to main content' button is present throughout the website</li>
                                <li>The website is not fully compatible with mobile accessibility functionality (Android, iOS)</li>
                                <li>Some PDF's are not fully accessible</li>
                                <li>Not all non-text items have alt text</li>
                                <li>Links are not correctly formatted hypertext links</li>
                                <li>Not all touch targets are a minimum of 9mm by 9mm </li>
                            </ul>

                            <h2>Feedback and contact information</h2>
                            <p>If you need information on this website in a different format, including accessible PDF, large print, audio recording or braille please contact:</p>
                            <p>Email: <a href="mailto:scholcomms@ed.ac.uk">scholcomms@ed.ac.uk</a></p>
                            <p>Phone: +44 (0)131 651 5226</p>
                            <p>British Sign Language (BSL) users can contact us via Contact Scotland BSL, the on-line BSL interpreting service</p>
                            <p><a href="http://contactscotland-bsl.org/">Contact Scotland BSL</a></p>
                            <p>We'll consider your request and get back to you in 5 working days.</p>

                            <h2>Reporting accessibility problems with this website</h2>
                            <p>We are always looking to improve the accessibility of this website. If you find any problems not listed on this page, or think we're not meeting accessibility requirements, please contact:</p>
                            <p>Email: <a href="mailto:scholcomms@ed.ac.uk">scholcomms@ed.ac.uk</a></p>
                            <p>Phone: +44 (0)131 651 5226</p>
                            <p>British Sign Language (BSL) users can contact us via Contact Scotland BSL, the on-line BSL interpreting service</p>
                            <p><a href="http://contactscotland-bsl.org/">Contact Scotland BSL</a></p>
                            <p>We'll consider your request and get back to you in 5 working days.</p>

                            <h2>Enforcement procedure</h2>
                            <p>The Equality and Human Rights Commission (EHRC) is responsible for enforcing the Public Sector Bodies (Websites and Mobile Applications) (No. 2) Accessibility Regulations 2018 (the 'accessibility regulations'). If you're not happy with how we respond to your complaint please contact the Equality Advisory and Support Service (EASS) directly:</p>
                            <p><a href="https://www.equalityadvisoryservice.com/">Contact details for the Equality Advisory and Support Service (EASS)</a></p>
                            <p>The government has produced information on how to report accessibility issues:</p>
                            <p><a href="https://www.gov.uk/reporting-accessibility-problem-public-sector-website">Reporting an accessibility problem on a public sector website</a></p>

                            <h2>Contacting us by phone using British Sign Language</h2>
                            <p>British Sign Language service Contact Scotland BSL runs a service for British Sign Language users and all of Scotland's public bodies using video relay. This enables sign language users to contact public bodies and vice versa. The service operates 24 hours a day, 7 days a week.</p>
                            <p><a href="https://contactscotland-bsl.org/">British Sign Language Scotland service details</a></p>

                            <h2>Technical information about this website's accessibility</h2>
                            <p>The University of Edinburgh is committed to making its websites and applications accessible, in accordance with the Public Sector Bodies (Websites and Mobile Applications) (No. 2) Accessibility Regulations 2018.</p>
                            <p>This website is partially compliant with the Web Content Accessibility Guidelines (WCAG) 2.1 AA standard, due to the non-compliances listed below.</p>
                            <p>The full guidelines are available at</p>
                            <p><a href="https://www.w3.org/TR/WCAG21/">Web Content Accessibility Guidelines (WCAG) 2.1 AA standard</a></p>

                            <h2>Non accessible content</h2>
                            <p>The content listed below is non-accessible for the following reasons.</p>
                            <p>Noncompliance with the accessibility regulations.</p>
                            <p>The following items to not comply with the WCAG 2.1 AA success criteria:</p>
                            <ul class="accessibility-list">
                                <li>Some non-text content does not have text alternatives.</li>
                                <ul>
                                    <li><u><a href="https://www.w3.org/TR/WCAG21/#non-text-content">1.1.1 - Non-text Content</a></u></li>
                                </ul>
                            </ul>
                            <ul class="accessibility-list">
                                <li>There may not be sufficient colour contrast between font and background colours, there are issues where text size is very small</li>
                                <ul>
                                    <li><u><a href="https://www.w3.org/TR/WCAG21/#visual-audio-contrast-contrast">1.4.3 - Contrast (Minimum)</a></u></li>
                                </ul>
                            </ul>
                            <ul class="accessibility-list">
                                <li>There are numerous instances of justified text</li>
                                <ul>
                                    <li><u><a href="https://www.w3.org/TR/WCAG21/#visual-presentation">1.4.8 - Visual Presentation</a></u></li>
                                </ul>
                            </ul>
                            <ul class="accessibility-list">
                                <li>Not all the content reflows when the page is magnified above 200%</li>
                                <ul>
                                    <li><u><a href="https://www.w3.org/TR/WCAG21/#reflow">1.4.10 - Reflow</a></u></li>
                                </ul>
                            </ul>
                            <ul class="accessibility-list">
                                <li>Tooltips are not present for all icons and images</li>
                                <ul>
                                    <li><u><a href="https://www.w3.org/TR/WCAG21/#content-on-hover-or-focus">1.4.13 - Content on Hover or Focus</a></u></li>
                                </ul>
                            </ul>
                            <ul class="accessibility-list">
                                <li>There is no 'skip to main content' option available throughout the website</li>
                                <ul>
                                    <li><u><a href="https://www.w3.org/TR/WCAG21/#bypass-blocks">2.4.1 - Bypass Blocks</a></u></li>
                                </ul>
                            </ul>
                            <ul class="accessibility-list">
                                <li>There are missing heading levels</li>
                                <ul>
                                    <li><u><a href="https://www.w3.org/TR/WCAG21/#headings-and-labels">2.4.6 - Headings and Labels</a></u></li>
                                </ul>
                            </ul>
                            <ul class="accessibility-list">
                                <li>It is not always clear where you have tabbed too</li>
                                <ul>
                                    <li><u><a href="https://www.w3.org/TR/WCAG21/#focus-visible">2.4.7 - Focus Visible</a></u></li>
                                </ul>
                            </ul>
                            <ul class="accessibility-list">
                                <li>There is unformatted links present that don't determine the purpose of the link</li>
                                <ul>
                                    <li><u><a href="https://www.w3.org/TR/WCAG21/#link-purpose-link-only">2.4.9 - Link Purpose (Link Only)</a></u></li>
                                </ul>
                            </ul>
                            <ul class="accessibility-list">
                                <li>There are missing labels present in the website so fail to describe the purpose of the input form</li>
                                <ul>
                                    <li><u><a href="https://www.w3.org/TR/WCAG21/#labels-or-instructions">3.3.2 - Labels or Instruction</a></u></li>
                                </ul>
                            </ul>   
                            <ul class="accessibility-list">
                                <li>Error suggestions or corrections are not always displayed</li>
                                <ul>
                                    <li><u><a href="https://www.w3.org/TR/WCAG21/#error-suggestion">3.3.3 - Error Suggestionn</a></u></li>
                                </ul>
                            </ul>
                            <ul class="accessibility-list">
                                <li>Voice recognition software was unable to identify some parts of the page</li>
                                <ul>
                                    <li><u><a href="https://www.w3.org/TR/WCAG21/#parsing">4.1.1 - Parsing</a></u></li>
                                    <li><u><a href="https://www.w3.org/TR/WCAG21/#name-role-value">4.1.2 - Name, Role, Value</a></u></li>
                                </ul>
                            </ul>
                            <ul class="accessibility-list">
                                <li>There are PDF's that are not currently accessible</li>
                                <ul>
                                    <li><u><a href="https://www.w3.org/TR/WCAG21/#parsing">4.1.1 - Parsing</a></u></li>
                                    <li><u><a href="https://www.w3.org/TR/WCAG21/#name-role-value">4.1.2 - Name, Role, Value</a></u></li>
                                </ul>
                            </ul>
                            <p>Unless specified otherwise, a complete solution, or significant improvement, will be in place by December 2023. At this time we believe all items are within our control.</p>

                            <h2>Disproportionate burden</h2>
                            <p>We are not currently claiming that any accessibility problems would be a disproportionate burden to fix.</p>

                            <h2>Content that is not within the Scope of the Accessibility Regulations</h2>
                            <p>At this time, we do not believe that any content is outside the scope of the accessibility regulations.</p>

                            <h2>What we're doing to improve accessibility</h2>
                            <p>We will continue to address and make adequate improvements to the accessibility issues highlighted. Unless specified otherwise, a complete solution or significant improvement will be in place by November 2023.</p>
                            <p>While we are in the process of resolving these accessibility issues we will ensure reasonable adjustments are in place to make sure no user is disadvantaged. As changes are made, we will continue to review accessibility and retest the accessibility of this website.</p>
                            <p>We are planning to upgrade the site to the most recent release of the system architecture before the end of 2023 which includes improvements to the current accessibility requirements. During this upgrade improving the other accessibility issues highlighted will be a key component of the development process.</p>

                            <h2>Preparation of this accessibility statement</h2>
                            <p>This statement was first prepared on 12th October 2019. It was last reviewed on 13th December 2022.</p>
                            <p>This website was first tested on 12th October 2019 and last tested on 4th July 2022. The test was carried out by The University Library and University Collections Digital Library Development team using the automated <a href="https://wave.webaim.org/">Wave WEBAIM</a> and <a href="https://littleforest.co.uk/">Little Forest</a> testing tools. The website is scheduled for manual testing by July 2023.</p>
                            <p>This website was last tested by the Library and University Collections Digital Library team, University of Edinburgh in July 2022 following on from previous automated testing of the system the previous year. This was primarily using the Google Chrome (100.0.4896.127), Mozilla Firefox (91.8.0esr), Internet Explorer (11.0) and Microsoft Edge (100.0.1185.39) browsers for comparative purposes.</p>
                            <p>Recent world-wide usage levels survey for different screen readers and browsers shows that Chrome, Mozilla Firefox and Microsoft Edge are increasing in popularity and Google Chrome is now the favoured browser for screen readers:</p>
                            <p><a href="https://webaim.org/projects/screenreadersurvey9/">WebAIM: Screen Reader User Survey</a></p>
                            <p>The aforementioned three browsers have been used in certain questions for reasons of breadth and variety.</p>
                            <p>We ran automated testing using <a href="https://wave.webaim.org/">Wave WEBAIM</a> and then manual testing that included:</p>
                            <ul class="accessibility-list">
                                <li>Spell check functionality;</li>
                                <li>Scaling using different resolutions and reflow;</li>
                                <li>Options to customise the interface (magnification, font, background colour, etc);</li>
                                <li>Keyboard navigation and keyboard traps;</li>
                                <li>Data validation;</li>
                                <li>Warning of links opening in new tab or window;</li>
                                <li>Information conveyed in the colour or sound only;</li>
                                <li>Flashing, moving or scrolling text;</li>
                                <li>Operability if JavaScript is disabled;</li>
                                <li>Use with screen reading software (for example JAWS);</li>
                                <li>Assistive software (TextHelp Read and Write, Windows Magnifier, ZoomText, Dragon Naturally Speaking, TalkBack and VoiceOver);</li>
                                <li>Tooltips and text alternatives for any non-text content;</li>
                                <li>Time limits;</li>
                                <li>Compatibility with mobile accessibility functionality (Android and iOS).</li>
                            </ul>

                            <h2>Change Log</h2>
                            <p>Since our first evaluation and statement which was based on automated testing we have been doing extensive manual testing including with a range of assistive technology to ensure we have a clear picture of the accessibility issues and how best to resolve them.</p>


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
                <a id="language-dropdown-toggle" href="#" role="button" class="dropdown-toggle" data-toggle="dropdown" title="Select website language">
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