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
    <xsl:variable name="request-uri" select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='request'][@qualifier='URI']"/>

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
                        <xsl:when test="starts-with($request-uri, 'page/policy')">
                            <xsl:call-template name="buildHeader"/>
                            <xsl:call-template name="buildTrail"/>
                            <!--javascript-disabled warning, will be invisible if javascript is enabled-->
                            <div id="no-js-warning-wrapper" class="hidden">
                                <div id="no-js-warning">
                                    <div class="notice failure">
                                        <xsl:text>JavaScript is disabled for your browser. Some features of this site may not work without it.</xsl:text>
                                    </div>
                                </div>
                            </div>

                            <div id="main-container" class="container">
                                <div class="policy-container">

                                <div class="row row-offcanvas row-offcanvas-right">
                                    <div class="horizontal-slider clearfix">
                                        <div class="col-xs-12 col-sm-12 col-md-9 main-content">
                                            <xsl:apply-templates select="*[not(self::dri:options)]"/>

                                            <div class="visible-xs visible-sm">
                                                <xsl:call-template name="buildFooter"/>
                                            </div>
                                        </div>
                                        <div class="col-xs-6 col-sm-3 sidebar-offcanvas" id="sidebar" role="navigation">
                                            <xsl:apply-templates select="dri:options"/>
                                        </div>

                                    </div>
                                </div>
                                </div>

                                <!--
                            The footer div, dropping whatever extra information is needed on the page. It will
                            most likely be something similar in structure to the currently given example. -->
                            <div class="hidden-xs hidden-sm">
                            <xsl:call-template name="buildFooter"/>
                             </div>
                         </div>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="buildHeader"/>
                            <xsl:call-template name="buildTrail"/>
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
                                        <div class="col-xs-12 col-sm-12 col-md-9 main-content">
                                            <xsl:apply-templates select="*[not(self::dri:options)]"/>

                                            <div class="visible-xs visible-sm">
                                                <xsl:call-template name="buildFooter"/>
                                            </div>
                                        </div>
                                        <div class="col-xs-6 col-sm-3 sidebar-offcanvas" id="sidebar" role="navigation">
                                            <xsl:apply-templates select="dri:options"/>
                                        </div>

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
                    <xsl:text>images/favicon.ico</xsl:text>
                </xsl:attribute>
            </link>
            <link rel="apple-touch-icon">
                <xsl:attribute name="href">
                    <xsl:value-of select="$theme-path"/>
                    <xsl:text>images/apple-touch-icon.png</xsl:text>
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

            <xsl:if test="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='ROBOTS'][not(@qualifier)]">
                <meta name="ROBOTS">
                    <xsl:attribute name="content">
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='ROBOTS']"/>
                    </xsl:attribute>
                </meta>
            </xsl:if>

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
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='opensearch'][@qualifier='autolink']"/>
                    </xsl:attribute>
                    <xsl:attribute name="title" >
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='opensearch'][@qualifier='shortName']"/>
                    </xsl:attribute>
                </link>
            </xsl:if>

            <!-- The following javascript removes the default text of empty text areas when they are focused on or submitted -->
            <!-- There is also javascript to disable submitting a form when the 'enter' key is pressed. -->
            <script>
                //Clear default text of empty text areas on focus
                function tFocus(element)
                {
                if (element.value == '<i18n:text>xmlui.dri2xhtml.default.textarea.value</i18n:text>'){element.value='';}
                }
                //Clear default text of empty text areas on submit
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
                    <xsl:when test="starts-with($request-uri, 'page/accessibility')">
                        Accessibility statement
                    </xsl:when>
                    <xsl:when test="starts-with($request-uri, 'page/policy')">
                            <xsl:text>Queen Margaret University Repository Policies</xsl:text>
                    </xsl:when>
                    <xsl:when test="not($page_title)">
                        <xsl:text>  </xsl:text>
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

            <!-- Add MathJAX JS library to render scientific formulas-->
            <xsl:if test="confman:getProperty('webui.browse.render-scientific-formulas') = 'true'">
                <script type="text/x-mathjax-config">
                    MathJax.Hub.Config({
                      tex2jax: {
                        ignoreClass: "detail-field-data|detailtable|exception"
                      },
                      TeX: {
                        Macros: {
                          AA: '{\\mathring A}'
                        }
                      }
                    });
                </script>
                <script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.1/MathJax.js?config=TeX-AMS-MML_HTMLorMML">&#160;</script>
            </xsl:if>

        </head>
    </xsl:template>


    <!-- The header (distinct from the HTML head element) contains the title, subtitle, login box and various
        placeholders for header images -->
    <xsl:template name="buildHeader">


        <header>
            <div class="navbar navbar-default navbar-static-top" role="navigation">
                <div class="container">
                    <div class="navbar-header">

                        <button type="button" class="navbar-toggle" data-toggle="offcanvas">
                            <span class="sr-only">
                                <i18n:text>xmlui.mirage2.page-structure.toggleNavigation</i18n:text>
                            </span>
                            <span class="icon-bar"></span>
                            <span class="icon-bar"></span>
                            <span class="icon-bar"></span>
                        </button>

                        <a href="{$context-path}/" class="navbar-brand" title="Back to homepage">
                            <img src="{$theme-path}images/eResearch-logo.svg" alt="Queen Margaret University logo" />
                        </a>


                        <div class="navbar-header pull-right visible-xs hidden-sm hidden-md hidden-lg">
                        <ul class="nav nav-pills pull-left ">

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

                            <xsl:choose>
                                <xsl:when test="/dri:document/dri:meta/dri:userMeta/@authenticated = 'yes'">
                                    <li class="dropdown">
                                        <button class="dropdown-toggle navbar-toggle navbar-link" id="user-dropdown-toggle-xs" href="#" role="button" data-toggle="dropdown" aria-label="Login" title="Login">
                                            <b class="visible-xs glyphicon glyphicon-user" aria-hidden="true"/>
                                        </button>
                                        <ul class="dropdown-menu pull-right" role="menu"
                                            aria-labelledby="user-dropdown-toggle-xs" data-no-collapse="true">
                                            <li>
                                                <a href="{/dri:document/dri:meta/dri:userMeta/
                            dri:metadata[@element='identifier' and @qualifier='url']}">
                                                    <i18n:text>xmlui.EPerson.Navigation.profile</i18n:text>
                                                </a>
                                            </li>
                                            <li>
                                                <a href="{/dri:document/dri:meta/dri:userMeta/
                            dri:metadata[@element='identifier' and @qualifier='logoutURL']}">
                                                    <i18n:text>xmlui.dri2xhtml.structural.logout</i18n:text>
                                                </a>
                                            </li>
                                        </ul>
                                    </li>
                                </xsl:when>
                                <xsl:otherwise>
                                    <li>
                                        <form style="display: inline" action="{/dri:document/dri:meta/dri:userMeta/
                            dri:metadata[@element='identifier' and @qualifier='loginURL']}" method="get">
                                            <button class="navbar-toggle navbar-link" aria-label="Navigation menu" title="Navigation menu">
                                            <b class="visible-xs glyphicon glyphicon-user" aria-hidden="true"/>
                                            </button>
                                        </form>
                                    </li>
                                </xsl:otherwise>
                            </xsl:choose>
                        </ul>
                              </div>
                    </div>

                    <div class="navbar-header pull-right hidden-xs">
                        <ul class="nav navbar-nav pull-left">
                              <xsl:call-template name="languageSelection"/>
                        </ul>
                        <ul class="nav navbar-nav pull-left">
                            <xsl:choose>
                                <xsl:when test="/dri:document/dri:meta/dri:userMeta/@authenticated = 'yes'">
                                    <li class="dropdown">
                                        <a id="user-dropdown-toggle" href="#" role="button" class="dropdown-toggle"
                                           data-toggle="dropdown">
                                            <span class="hidden-xs">
                                                <xsl:value-of select="/dri:document/dri:meta/dri:userMeta/
                            dri:metadata[@element='identifier' and @qualifier='firstName']"/>
                                                <xsl:text> </xsl:text>
                                                <xsl:value-of select="/dri:document/dri:meta/dri:userMeta/
                            dri:metadata[@element='identifier' and @qualifier='lastName']"/>
                                                &#160;
                                                <b class="caret"/>
                                            </span>
                                        </a>
                                        <ul class="dropdown-menu pull-right" role="menu"
                                            aria-labelledby="user-dropdown-toggle" data-no-collapse="true">
                                            <li>
                                                <a href="{/dri:document/dri:meta/dri:userMeta/
                            dri:metadata[@element='identifier' and @qualifier='url']}">
                                                    <i18n:text>xmlui.EPerson.Navigation.profile</i18n:text>
                                                </a>
                                            </li>
                                            <li>
                                                <a href="{/dri:document/dri:meta/dri:userMeta/
                            dri:metadata[@element='identifier' and @qualifier='logoutURL']}">
                                                    <i18n:text>xmlui.dri2xhtml.structural.logout</i18n:text>
                                                </a>
                                            </li>
                                        </ul>
                                    </li>
                                </xsl:when>
                                <xsl:otherwise>
                                    <li>
                                        <a href="{/dri:document/dri:meta/dri:userMeta/
                            dri:metadata[@element='identifier' and @qualifier='loginURL']}">
                                            <span class="hidden-xs">
                                                <i18n:text>xmlui.dri2xhtml.structural.login</i18n:text>
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
        <div class="trail-wrapper hidden-print">
            <div class="container">
                <div class="row">
                    <!--TODO-->
                    <div class="col-xs-12">
                        <xsl:choose>
                            <xsl:when test="count(/dri:document/dri:meta/dri:pageMeta/dri:trail) > 1">
                                <div class="breadcrumb dropdown visible-xs">
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
                                <ul class="breadcrumb hidden-xs">
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
                    <a>
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
                    <a role="menuitem">
                        <xsl:attribute name="href">
                            <xsl:value-of select="./@target"/>
                        </xsl:attribute>
                        <xsl:if test="position()=1">
                            <i class="glyphicon glyphicon-home" aria-hidden="true"/>&#160;
                        </xsl:if>
                        <xsl:apply-templates />
                    </a>
                </xsl:when>
                <xsl:when test="position() > 1 and position() = last()">
                    <xsl:attribute name="class">disabled</xsl:attribute>
                    <a role="menuitem" href="#">
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
                    <xsl:call-template name="cc-logo">
                        <xsl:with-param name="ccLicenseName" select="$ccLicenseName"/>
                        <xsl:with-param name="ccLicenseUri" select="$ccLicenseUri"/>
                    </xsl:call-template>
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

    <xsl:template name="cc-logo">
        <xsl:param name="ccLicenseName"/>
        <xsl:param name="ccLicenseUri"/>
        <xsl:variable name="ccLogo">
             <xsl:choose>
                  <xsl:when test="starts-with($ccLicenseUri,
                                           'http://creativecommons.org/licenses/by/')">
                       <xsl:value-of select="'cc-by.png'" />
                  </xsl:when>
                  <xsl:when test="starts-with($ccLicenseUri,
                                           'http://creativecommons.org/licenses/by-sa/')">
                       <xsl:value-of select="'cc-by-sa.png'" />
                  </xsl:when>
                  <xsl:when test="starts-with($ccLicenseUri,
                                           'http://creativecommons.org/licenses/by-nd/')">
                       <xsl:value-of select="'cc-by-nd.png'" />
                  </xsl:when>
                  <xsl:when test="starts-with($ccLicenseUri,
                                           'http://creativecommons.org/licenses/by-nc/')">
                       <xsl:value-of select="'cc-by-nc.png'" />
                  </xsl:when>
                  <xsl:when test="starts-with($ccLicenseUri,
                                           'http://creativecommons.org/licenses/by-nc-sa/')">
                       <xsl:value-of select="'cc-by-nc-sa.png'" />
                  </xsl:when>
                  <xsl:when test="starts-with($ccLicenseUri,
                                           'http://creativecommons.org/licenses/by-nc-nd/')">
                       <xsl:value-of select="'cc-by-nc-nd.png'" />
                  </xsl:when>
                  <xsl:when test="starts-with($ccLicenseUri,
                                           'http://creativecommons.org/publicdomain/zero/')">
                       <xsl:value-of select="'cc-zero.png'" />
                  </xsl:when>
                  <xsl:when test="starts-with($ccLicenseUri,
                                           'http://creativecommons.org/publicdomain/mark/')">
                       <xsl:value-of select="'cc-mark.png'" />
                  </xsl:when>
                  <xsl:otherwise>
                       <xsl:value-of select="'cc-generic.png'" />
                  </xsl:otherwise>
             </xsl:choose>
        </xsl:variable>
        <img class="img-responsive">
             <xsl:attribute name="src">
                <xsl:value-of select="concat($theme-path,'/images/creativecommons/', $ccLogo)"/>
             </xsl:attribute>
             <xsl:attribute name="alt">
                 <xsl:value-of select="$ccLicenseName"/>
             </xsl:attribute>
        </img>
    </xsl:template>

    <!-- Like the header, the footer contains various miscellaneous text, links, and image placeholders -->
    <xsl:template name="buildFooter">
        <footer>
                <div class="row">
                    <hr/>
                    <div class="col-xs-7 col-sm-8">
                        <div>
                            <a target="_blank" href="https://eresearch.qmu.ac.uk/">Queen Margaret University: Research Repositories</a>
                        </div>
                        <div class="hidden-print">
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:value-of
                                            select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath'][not(@qualifier)]"/>
                                    <xsl:text>/page/accessibility</xsl:text>
                                </xsl:attribute>
                                Accessibility Statement
                            </a>
                            <xsl:text> | </xsl:text>
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:value-of
                                            select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath'][not(@qualifier)]"/>
                                    <xsl:text>/page/policy</xsl:text>
                                </xsl:attribute>
                                <i18n:text>xmlui.mirage2.page-structure.policy</i18n:text>
                            </a>
                            <xsl:text> | </xsl:text>
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:value-of
                                            select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath'][not(@qualifier)]"/>
                                    <xsl:text>/contact</xsl:text>
                                </xsl:attribute>
                                <i18n:text>xmlui.dri2xhtml.structural.contact-link</i18n:text>
                            </a>
                            <xsl:text> | </xsl:text>
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:value-of
                                            select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath'][not(@qualifier)]"/>
                                    <xsl:text>/feedback</xsl:text>
                                </xsl:attribute>
                                <i18n:text>xmlui.dri2xhtml.structural.feedback-link</i18n:text>
                            </a>
                            <xsl:text> | </xsl:text>
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:value-of
                                            select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath'][not(@qualifier)]"/>
                                    <xsl:text>/htmlmap</xsl:text>
                                </xsl:attribute>
                                <xsl:text>HTML Sitemap</xsl:text>
                            </a>

                        </div>
                    </div>
                    <div class="col-xs-5 col-sm-4 hidden-print">
                        <div class="pull-right">
                            
                        </div>

                    </div>
                </div>

            <!--

            August 24 2020 - HM
            HTML sitemap link made visible for accessibility purpose
            -->
            <!--Invisible link to HTML sitemap (for search engines) -->
                <!--<a>
                    <xsl:attribute name="href">
                        <xsl:value-of
                                select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath'][not(@qualifier)]"/>
                        <xsl:text>/htmlmap</xsl:text>
                    </xsl:attribute>
                    <xsl:text>&#160;</xsl:text>
                </a>-->
            <p>&#160;</p>
        </footer>
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
                <div class="alert alert-warning">
                    <button type="button" class="close" data-dismiss="alert">&#215;</button>
                    <xsl:copy-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='alert'][@qualifier='message']/node()"/>
                </div>
            </xsl:if>

            <!-- Check for the custom pages -->
            <xsl:choose>
                <xsl:when test="starts-with($request-uri, 'page/accessibility')">
                    <div class="hero-unit">
                        <h1>Accessibility statement for the <a href="https://eresearch.qmu.ac.uk/">Queen Margaret University, eResearch Repository</a></h1>
                        <p><strong>Website accessibility statement in line with Public Sector Body (Websites and Mobile Applications) (No. 2) Accessibility Regulations 2018</strong></p>
                        <p>This accessibility statement applies to the <a href="https://eresearch.qmu.ac.uk/">Queen Margaret University, eResearch Repository</a> - <a href="https://eresearch.qmu.ac.u">https://eresearch.qmu.ac.uk/</a></p>
                        <p>This website is maintained by the Digital Library team, Library and University Collections, the University of Edinburgh on behalf of Queen Margaret University. We want as many people as possible to be able to use this application. For example, that means you should be able to:</p>
                        <ul>
                            <li>using your browser settings, customise the site via change colours, contrast levels and fonts;</li>
                            <li>zoom in up to 200% without the text spilling off the screen;</li>
                            <li>navigate most of the website using just a keyboard;</li>
                            <li>navigate most of the website using speech recognition software such as Dragon Naturally Speaking;</li>
                            <li>listen to most of the website using a screen reader (including the most recent versions of Job Access with Speech (JAWS);</li>
                            <li>no information will be conveyed by colour or sound;</li>
                            <li>Experience no time limits when using the site;</li>
                            <li>There is no flashing, scrolling or moving text.</li>
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
                        <ul>
                            <li>The website is not 100% compatible with speech to text assistive technologies, including Dragon NaturallySpeaking;</li>
                            <li>Not all non-text content has appropriate alternative text;</li>
                            <li>Tabbing outlines can sometimes obscure the content they are highlighting;</li>
                            <li>Data entry and validation is not fully robust;</li>
                            <li>Not all links contain correctly formatted hypertext;</li>
                            <li>Not all colour contrasts necessarily meet the recommended levels;</li>
                            <li>A 'skip to main content' option is not present throughout the website;</li>
                            <li>The website is not fully compatible with mobile accessibility functionality (Android, iOS);</li>
                            <li>Some PDF documents are not fully accessible;</li>
                            <li>Not all touch targets are a minimum of 9mm by 9mm.</li>
                        </ul>

                        <h2>Feedback and contact information</h2>
                        <p>If you need information on this website in a different format, including accessible PDF, large print, audio recording or braille please contact:</p>
                        <p>Email: <a href="mailto:EResearch@qmu.ac.uk">EResearch@qmu.ac.uk</a></p>
                        <p>Phone: +44 (0)131 474 0000</p>
                        <p>British Sign Language (BSL) users can contact us via Contact Scotland BSL, the on-line BSL interpreting service</p>
                        <p><a href="http://contactscotland-bsl.org/">Contact Scotland BSL</a></p>
                        <p>We'll consider your request and get back to you in 5 working days.</p>

                        <h2>Reporting accessibility problems with this website</h2>
                        <p>We are always looking to improve the accessibility of this website. If you find any problems not listed on this page, or think we're not meeting accessibility requirements, please contact:</p>
                        <p>Email: <a href="mailto:EResearch@qmu.ac.uk">EResearch@qmu.ac.uk</a></p>
                        <p>Phone: +44 (0)131 474 0000</p>
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
                        <ul>
                            <li>Some non-text content does not have text alternatives.</li>
                            <ul>
                                <li><u><a href="https://www.w3.org/TR/WCAG21/#non-text-content">1.1.1 - Non-text Content</a></u></li>
                            </ul>
                        </ul>
                        <ul>
                            <li>There may not be sufficient colour contrast between font and background colours, there are issues where text size is very small</li>
                            <ul>
                                <li><u><a href="https://www.w3.org/TR/WCAG21/#visual-audio-contrast-contrast">1.4.3 - Contrast (Minimum)</a></u></li>
                            </ul>
                        </ul>
                        <ul>
                            <li>Not all the content reflows when the page is magnified above 200%</li>
                            <ul>
                                <li><u><a href="https://www.w3.org/TR/WCAG21/#reflow">1.4.10 - Reflow</a></u></li>
                            </ul>
                        </ul>
                        <ul>
                            <li>Tooltips are not present for all icons and images</li>
                            <ul>
                                <li><u><a href="https://www.w3.org/TR/WCAG21/#content-on-hover-or-focus">1.4.13 - Content on Hover or Focus</a></u></li>
                            </ul>
                        </ul>
                        <ul>
                            <li>There is no 'skip to main content' option available throughout the website</li>
                            <ul>
                                <li><u><a href="https://www.w3.org/TR/WCAG21/#bypass-blocks">2.4.1 - Bypass Blocks</a></u></li>
                            </ul>
                        </ul>
                        <ul>
                            <li>There are missing heading levels</li>
                            <ul>
                                <li><u><a href="https://www.w3.org/TR/WCAG21/#headings-and-labels">2.4.6 - Headings and Labels</a></u></li>
                            </ul>
                        </ul>
                        <ul>
                            <li>It is not always clear where you have tabbed too</li>
                            <ul>
                                <li><u><a href="https://www.w3.org/TR/WCAG21/#focus-visible">2.4.7 - Focus Visible</a></u></li>
                            </ul>
                        </ul>
                        <ul>
                            <li>There is unformatted links present that don't determine the purpose of the link</li>
                            <ul>
                                <li><u><a href="https://www.w3.org/TR/WCAG21/#link-purpose-link-only">2.4.9 - Link Purpose (Link Only)</a></u></li>
                            </ul>
                        </ul>
                        <ul>
                            <li>There are missing labels present in the website so fail to describe the purpose of the input form</li>
                            <ul>
                                <li><u><a href="https://www.w3.org/TR/WCAG21/#labels-or-instructions">3.3.2 - Labels or Instruction</a></u></li>
                            </ul>
                        </ul>   
                        <ul>
                            <li>Error suggestions or corrections are not always displayed</li>
                            <ul>
                                <li><u><a href="https://www.w3.org/TR/WCAG21/#error-suggestion">3.3.3 - Error Suggestionn</a></u></li>
                            </ul>
                        </ul>
                        <ul>
                            <li>Voice recognition software was unable to identify some parts of the page</li>
                            <ul>
                                <li><u><a href="https://www.w3.org/TR/WCAG21/#parsing">4.1.1 - Parsing</a></u></li>
                                <li><u><a href="https://www.w3.org/TR/WCAG21/#name-role-value">4.1.2 - Name, Role, Value</a></u></li>
                            </ul>
                        </ul>
                        <ul>
                            <li>There are PDF's that are not currently accessible</li>
                            <ul>
                                <li><u><a href="https://www.w3.org/TR/WCAG21/#parsing">4.1.1 - Parsing</a></u></li>
                                <li><u><a href="https://www.w3.org/TR/WCAG21/#name-role-value">4.1.2 - Name, Role, Value</a></u></li>
                            </ul>
                        </ul>
                        <p>Unless specified otherwise, a complete solution, or significant improvement, will be in place by December 2023. At this time, we believe all items are within our control.</p>

                        <h2>Disproportionate burden</h2>
                        <p>At this time, we are not claiming any disproportionate burden.</p>

                        <h2>Content that is not within the Scope of the Accessibility Regulations</h2>
                        <p>At this time, we do not believe that any content is outside the scope of the accessibility regulations.</p>

                        <h2>What we're doing to improve accessibility</h2>
                        <p>We will continue to address and make adequate improvements to the accessibility issues highlighted. Unless specified otherwise, a complete solution or significant improvement will be in place by December 2023.</p>
                        <p>While we are in the process of resolving these accessibility issues we will ensure reasonable adjustments are in place to make sure no user is disadvantaged. As changes are made, we will continue to review accessibility and retest the accessibility of this website.</p>
                        <p>We are planning to upgrade the site to the most recent release of the system architecture before the end of 2023 which includes improvements to the current accessibility requirements. During this upgrade improving the other accessibility issues highlighted will be a key component of the development process.</p>

                        <h2>Preparation of this accessibility statement</h2>
                        <p>This statement was first prepared on 23rd September 2021. It was last reviewed on 18th January 2023.</p>
                        <p>This website was first tested in September 2020 and last tested on 9th August 2022. The test was carried out by The University of Edinburgh, Library and University Collections, Digital Library Development team using the automated <a href="https://wave.webaim.org/">Wave WEBAIM</a> and <a href="https://littleforest.co.uk/">Little Forest</a> testing tools.</p>
                        <p>This website was last tested by the Library and University Collections, Digital Library Development team, University of Edinburgh in August 2022 following on from previous automated testing of the system the previous year. This was primarily using the Google Chrome (100.0.4896.127), Mozilla Firefox (91.8.0esr), Internet Explorer (11.0) and Microsoft Edge (100.0.1185.39) browsers for comparative purposes.</p>
                        <p>Recent world-wide usage levels survey for different screen readers and browsers shows that Chrome, Mozilla Firefox and Microsoft Edge are increasing in popularity and Google Chrome is now the favoured browser for screen readers:</p>
                        <p><a href="https://webaim.org/projects/screenreadersurvey9/">WebAIM: Screen Reader User Survey</a></p>
                        <p>The aforementioned three browsers have been used in certain questions for reasons of breadth and variety.</p>
                        <p>We ran automated testing using <a href="https://wave.webaim.org/">Wave WEBAIM</a> and then manual testing that included:</p>
                        <ul>
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
                </xsl:when>
                <xsl:when test="starts-with($request-uri, 'page/policy')">
                        <div class="hero-unit">
                            <h1>Queen Margaret University Repository Policies</h1>

                            <h3>Contents</h3>
                            <ul class="contents-ul">
                                <li class="contents-li">Open Access Archiving Policy</li>
                                <li class="contents-li">eResearch Publications Repository: Submission Policy</li>
                                <li class="contents-li">eResearch Publications Repository: Content Policy</li>
                                <li class="contents-li">QMU Repositories: Data Policy</li>
                                <li class="contents-li">QMU Repositories: Metadata Policy</li>
                                <li class="contents-li">QMU Repositories: Preservation Policy</li>
                                <li class="contents-li">Definitions</li>
                            </ul>

                            <h2 id="section1">Open Access Archiving Policy</h2>
                            <ol>
                                <li>It is our policy to maximise the visibility, usage and impact of our research output by maximising online access to it for all would-be users and researchers worldwide.
                                    <ul class="policy-ul-one">
                                        <li>It is also our policy to minimise the effort that each of us has to expend in order to provide open online access to our research output</li>
                                        <li>With all our research output accessible online we will be able to respond to the research assessment and other administrative initiatives with minimal input and effort from individual staff.</li>
                                    </ul>
                                </li>
                                <li>We have accordingly adopted the policy that all peer-reviewed research outputs are to be archived in the institutional repository - QMU's eResearch publications repository: <a href="https://eresearch.qmu.ac.uk/"><strong>https://eresearch.qmu.ac.uk/</strong></a>
                                    <p>It is encouraged that those outputs not yet peer-reviewed, along with other unpublished work, are also archived in the repository as appropriate. The repository will clearly describe the status of all outputs. This archive forms the official record of the institution's research publications.</p>
                                </li>
                                <li>Our policy is compatible with publishers' copyright agreements as follows:
                                    <ul class="policy-ul-one">
                                        <li>The copyright for the un-refereed <strong>preprint<a href="#footnote1">[1]</a></strong> resides entirely with the author before it is submitted for peer-reviewed publication, hence it can be self-archived irrespective of the copyright policy of the journal to which it is eventually submitted</li>
                                        <li>The copyright for the peer-reviewed <strong>postprint<a href="#footnote2">[2]</a></strong> will depend on the wording of the copyright agreement which the author signs with the publisher</li>
                                        <li>Many publishers will allow the peer-reviewed postprint to be archived. The copyright transfer agreement will either specify this right explicitly or the author can inquire about it directly. If you are uncertain about the terms of your agreement, a directory of journal self-archiving policies is available on the JISC SHERPA/RoMEO website: <a href="https://www.sherpa.ac.uk/romeo">https://www.sherpa.ac.uk/romeo</a>
                                        <p>Wherever possible, you are advised to modify your copyright agreement so that it does not disallow archiving</p></li>
                                        <li>In the rare case where you have signed a very restrictive copyright transfer form in which you have agreed explicitly <strong>not</strong> 
                                            to self-archive the peer-reviewed postprint, you are encouraged to archive, alongside your already-archived preprint, a "corrigenda" file, 
                                            listing the substantive changes the user would need to make in order to turn the un-refereed preprint into the refereed postprint
                                        </li>
                                        <li>Copyright agreements may state that <strong>eprints<a href="#footnote3">[3]</a></strong> can be archived on your personal homepage. As far as publishers are concerned, 
                                            the institutional repository is a part of the institutions infrastructure for your personal homepage.
                                        </li>
                                    </ul>
                                </li>
                                <li>We do not require you to archive the full text of books or research monographs. It is sufficient to archive the items bibliographic details 
                                    along with the usual metadata.
                                </li>
                                <li>Some journals still maintain submission policies which state that a preprint will not be considered for publication if it has been previously 
                                    'publicised' by making it accessible online. Unlike copyright transfer agreements, such policies are not a matter of law. If you have concerns 
                                    about submitting an archived paper to a journal which still maintains such a restrictive submission policy, please discuss it with the 
                                    institutional repository named contact.
                                </li>
                            </ol>

                            <h2 id="section2">eResearch Publications Repository: Submission Policy</h2>
                            <p>This section relates to depositors, quality and copyright.</p>
                            <ol class="policy-ol-indent">
                                <li>Items may only be deposited by accredited members of the institution, or their delegated agents.</li>
                                <li>Eligible depositors must deposit full texts of all their publications, as per QMUs Open Access Archiving Policy (as above). 
                                    Depositors may delay making full texts publicly visible to comply with publishers' embargo periods.</li>
                                <li>The repositories administrator only vets items for the eligibility of authors/depositors, relevance to the scope of eResearch, 
                                    valid layout and format, and the exclusion of spam.
                                </li>
                                <li>The validity and authenticity of the content of submissions is the sole responsibility of the author(s)/depositor(s).</li>
                                <li>Items may be deposited at any time, but will not be made publicly visible until any publishers' or funders' embargo periods have expired.</li>
                                <li>Any copyright violations are entirely the responsibility of the author(s)/depositor(s).</li>
                                <li>If QMU receives proof of copyright violation, the relevant item(s) will be removed immediately.</li>
                            </ol>

                            <h2 id="section3">eResearch Publications Repository: Content Policy</h2>
                            <p>This section relates to the types of documents held in the eResearch publications repository</p>
                            <ol>
                                <li>Automatic inclusion
                                    <ul class="policy-ul-two">
                                        <li>Peer-reviewed journal articles</li>
                                        <li>Books and book chapters (<strong>not</strong> textbooks, technical chapters or teaching materials)</li>
                                        <li>Conference proceedings with papers</li>
                                        <li>Government reports, where open access is permissible</li>
                                        <li>Working papers, where open access is permissible</li>
                                        <li>Editorials, including guest editorials, in prestigious journals</li>
                                        <li>Practice as research<a href="#footnote4">[4]</a></li>
                                        <li>Items In Press but not items submitted for review.</li>
                                    </ul>
                                </li>
                                <li>Academic staff may self-deposit documents of the types described above and Library staff will perform final quality control checks on 
                                    records created for each item before making items visible externally. Academic staff may also send documents or article references, etc. 
                                    to the Library's eResearch Team (email: <a href="mailto:eResearch@qmu.ac.uk"><strong>eResearch@qmu.ac.uk</strong></a>) for record creation
                                    and upload to the repository. Library staff will use services such as JISC Publications Router alerts (which includes items identified 
                                    by QMU affiliation in services such as Scopus, Web of Science, etc.) to identify material published by QMU staff for inclusion in eResearch.
                                </li>
                                <li>Automatic exclusion
                                    <ul class="policy-ul-two">
                                        <li>Textbooks, technical chapters or teaching materials</li>
                                        <li>Abstracts</li>
                                        <li>Newspaper reviews</li>
                                        <li>Talks presented at other HEIs</li>
                                        <li>Other types of material not considered research outputs</li>
                                    </ul>
                                </li>
                            </ol>
                            <p>Exceptionally, if a member of academic staff believes an individual output demonstrates quality or specific merit then it should be forwarded, 
                                in the first instance, to the relevant QMU School or Research Centre Lead who will decide whether the material is suitable for inclusion in 
                                eResearch. If the Research Lead recommends that an item should be included in eResearch, they should inform the member of staff who will then 
                                either self-deposit or send the document to the Library's eResearch Team (email: <a href="mailto:eResearch@qmu.ac.uk">
                                <strong>eResearch@qmu.ac.uk</strong></a>) for deposit as described above.
                            </p>
                            <ol start="4">
                                <li>Items are individually tagged with their version type and date, and their publication status.</li>
                            </ol>

                            <h2 id="section4">QMU Repositories: Data Policy</h2>
                            <p>This policy relates to full-text and other full data items deposited in QMUs eData repository. Access to some or all full items may be controlled.</p>
                            <ol>
                                <li>Anyone may access full items free of charge.</li>
                                <li>Copies of full items can generally be:
                                    <ul>
                                        <li>reproduced, displayed or performed, and given to third parties in any format or medium for personal research or study, educational, 
                                            or not-for-profit purposes without prior permission or charge, provided:
                                            <ul class="policy-ul-two">
                                                <li>author(s), title(s) and full bibliographic details are provided</li>
                                                <li>hyperlink(s) and/or URL(s) are provided for original metadata page(s)</li>
                                                <li>content is not changed in any way.</li>
                                            </ul>
                                        </li>
                                    </ul>
                                </li>
                                <li>Full items may not be sold commercially in any format or medium without formal permission of the copyright holders.</li>
                                <li>Some full items are tagged individually with different rights, permissions and conditions to comply with restrictions or licensing conditions, 
                                    such as publisher embargoes, Creative Commons licenses, etc.
                                </li>
                            </ol>
                            <p>This repository is <strong>not </strong>the publisher; it is merely the online archive.</p>
                            <p>Acknowledgement of QMU repositories is appreciated but not mandatory.</p>

                            <h2 id="section5">QMU Repositories: Metadata Policy</h2>
                            <p>This policy relates to information describing items deposited in the repositories.</p>
                            <ol>
                                <li>Anyone may access the metadata free of charge.</li>
                                <li>The metadata may be re-used in any medium without prior permission for not-for-profit purposes, provided:
                                    <ul>
                                        <li>an identifier or a link to the original metadata record are given</li>
                                        <li>QMU Repositories are acknowledged.</li>
                                    </ul>
                                </li>
                                <li>The metadata must not be re-used in any medium for commercial purposes without formal permission from QMU.</li>
                            </ol>

                            <h2 id="section6">QMU Repositories: Preservation Policy</h2>
                            <ol class="policy-ol-final">
                                <li>Items authored while affiliated with QMU will be retained indefinitely. Items published outwith QMU may be withdrawn and deleted from the repository when the author leaves QMU.</li>
                                <li>QMU will try to ensure continued readability and accessibility of its repositories
                                    <ul>
                                        <li>items will be migrated to new file formats where necessary.</li>
                                        <li>where possible, software emulations will be provided to access un-migrated formats.</li>
                                    </ul>
                                </li>
                                <li>The repository and its files are backed up nightly by the repository hosts, University of Edinburgh.</li>
                                <li>Original bitstreams are retained for all items, in addition to any upgraded formats.</li>
                                <li>Items may not normally be removed from QMU repositories.</li>
                                <li>Acceptable reasons for withdrawal include:
                                    <ul>
                                        <li>proven copyright violation or plagiarism</li>
                                        <li>legal requirements and proven violations</li>
                                        <li>national security</li>
                                        <li>falsified research.</li>
                                    </ul>
                                </li>
                            <p>Proven falsified or fraudulent research or any publication(s)/article(s) submitted and proven to be produced as a result of any form of 
                                professional misconduct may be withdrawn from the repositories, in accordance with the <strong>QMU Code of Research Practice</strong> 
                                (see: section 15. Research Misconduct) available at: 
                                <a href="https://www.qmu.ac.uk/research-and-knowledge-exchange/strategy-and-policy/research-ethics-and-governance/">
                                https://www.qmu.ac.uk/research-and-knowledge-exchange/strategy-and-policy/research-ethics-and-governance/</a>
                            </p>
                                <li>Withdrawn items will be deleted entirely from the repository.</li>
                                <li>Withdrawn items' identifiers/URLs will not be retained.</li>
                                <li>Changes to deposited items are <strong>not permitted.</strong></li>
                                <li><em>Errata </em>and <em>corrigenda </em>lists may be included with the original record if required.</li>
                                <li>If necessary, an updated version may be deposited
                                    <ul  class="policy-ul-one">
                                        <li>the earlier version may be withdrawn from public view</li>
                                        <li>the original URL will be linked to the latest version.</li>
                                    </ul>
                                </li>
                                <li>In the event of QMU repositories being closed down, the database will be transferred to another appropriate archive.</li>
                            </ol>

                            <!-- FOOTNOTES -->
                            <div class="policy-footer">
                                <h3 id="section7">Definitions</h3>
                                <p id="footnote1" class="policy-footer-p">[1] A postprint (often known as accepted version, author accepted manuscript (AAM), author's final version, etc.) 
                                    is the version of an output that:
                                    <ul class="policy-footer-ul">
                                        <li>has been accepted for publication.</li>
                                        <li>has been peer-reviewed.</li>
                                        <li>but has generally not yet had the publisher's layout and typesetting applied.</li>
                                    </ul>
                                </p>
                                <p class="policy-footer-p">This can often be a Word version of a publication but some publishers work with templates from the submission stage, so it 
                                    is important that authors retain all versions of outputs until confirmation of acceptance has been received.
                                </p>
                                <p id="footnote2" class="policy-footer-p">[2] A preprint is the pre-refereed and unpublished version of the paper that has been submitted for publication 
                                    and has not yet been peer-reviewed and may also be known as an accepted version, author accepted manuscript (AAM) or author's 
                                    final version, etc.
                                </p>
                                <p id="footnote3" class="policy-footer-p">[3] An eprint is a digital version of a research document (usually a journal article, but could also be a thesis, 
                                    conference paper, book chapter, or a book) that is accessible online.
                                </p>
                                <p id="footnote4" class="policy-footer-p">[4] Practice as research is a research method in the arts in which the practice of an art is the research process, 
                                    and the performance, art, or other media item is the research output.
                                    (Definition from NELSON, R. 2013. Introduction: The What, Where, When and Why of ‘Practice as Research’. In: R. NELSON (ed.) 
                                    Practice as Research in the Arts. London: Palgrave Macmillan, pp. 3-22.)
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

        <script type="text/javascript"><xsl:text>
                         if(typeof window.publication === 'undefined'){
                            window.publication={};
                          };
                        window.publication.contextPath= '</xsl:text><xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath'][not(@qualifier)]"/><xsl:text>';</xsl:text>
            <xsl:text>window.publication.themePath= '</xsl:text><xsl:value-of select="$theme-path"/><xsl:text>';</xsl:text>
        </script>
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

        <!-- Add javascript specified in DRI -->
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

        <xsl:call-template name="addJavascript-google-analytics" />

        <xsl:if test="/dri:document/dri:body/dri:div[@id='aspect.eperson.StartRegistration.div.register']">
            <script src='https://www.google.com/recaptcha/api.js'>&#160;</script>
            <!--<script type="text/javascript">
                <xsl:attribute name="src">
                    <xsl:value-of select="concat($theme-path, 'js/add_user_captcha.js')"/>
                </xsl:attribute>
            </script>-->
            <script type="text/javascript">
                add_captcha();
            </script>

        </xsl:if>

    </xsl:template>

    <xsl:template name="addJavascript-google-analytics">
        <!-- Add a google analytics script if the key is present -->
        <xsl:if test="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='google'][@qualifier='analytics']">
            <script>
                <xsl:attribute name="async">true</xsl:attribute>
                <xsl:attribute name="src"><xsl:text>https://www.googletagmanager.com/gtag/js?id=</xsl:text><xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='google'][@qualifier='analytics']"/></xsl:attribute>
            </script>
            <script><xsl:text>
                window.dataLayer = window.dataLayer || [];
                function gtag(){dataLayer.push(arguments);}
                gtag('js', new Date());

                gtag('config', '</xsl:text><xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='google'][@qualifier='analytics']"/><xsl:text>');</xsl:text>
            </script>
        </xsl:if>
    </xsl:template>

    <!--The Language Selection
        Uses a page metadata curRequestURI which was introduced by in /xmlui-mirage2/src/main/webapp/themes/Mirage2/sitemap.xmap-->
    <xsl:template name="languageSelection">
        <xsl:variable name="curRequestURI">
            <xsl:value-of select="substring-after(/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='curRequestURI'],/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='request'][@qualifier='URI'])"/>
        </xsl:variable>

        <xsl:if test="count(/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='page'][@qualifier='supportedLocale']) &gt; 1">
            <li id="ds-language-selection" class="dropdown">
                <xsl:variable name="active-locale" select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='page'][@qualifier='currentLocale']"/>
                <a id="language-dropdown-toggle" href="#" role="button" class="dropdown-toggle" data-toggle="dropdown">
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
                                    <xsl:value-of select="$curRequestURI"/>
                                    <xsl:call-template name="getLanguageURL"/>
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

    <!-- Builds the Query String part of the language URL. If there already is an existing query string
like: ?filtertype=subject&filter_relational_operator=equals&filter=keyword1 it appends the locale parameter with the ampersand (&) symbol -->
    <xsl:template name="getLanguageURL">
        <xsl:variable name="queryString" select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='request'][@qualifier='queryString']"/>
        <xsl:choose>
            <!-- There allready is a query string so append it and the language argument -->
            <xsl:when test="$queryString != ''">
                <xsl:text>?</xsl:text>
                <xsl:choose>
                    <xsl:when test="contains($queryString, '&amp;locale-attribute')">
                        <xsl:value-of select="substring-before($queryString, '&amp;locale-attribute')"/>
                        <xsl:text>&amp;locale-attribute=</xsl:text>
                    </xsl:when>
                    <!-- the query string is only the locale-attribute so remove it to append the correct one -->
                    <xsl:when test="starts-with($queryString, 'locale-attribute')">
                        <xsl:text>locale-attribute=</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$queryString"/>
                        <xsl:text>&amp;locale-attribute=</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>?locale-attribute=</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
