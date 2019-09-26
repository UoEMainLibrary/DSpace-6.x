<!--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

-->

<!--
    Rendering specific to the navigation (options)

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
	xmlns="http://www.w3.org/1999/xhtml"
	exclude-result-prefixes="i18n dri mets xlink xsl dim xhtml mods dc">

    <xsl:output indent="yes"/>

    <!-- Variables to be used to supress Sidebar facets based on dri:trail or URI values -->
    <xsl:variable name="trail-string" select="/dri:document/dri:meta/dri:pageMeta/dri:trail[last()]" />
    <xsl:variable name="request-uri" select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='request'][@qualifier='URI']" />
    <xsl:variable name="uri-string" select="concat($trail-string, '/', $request-uri)" />
    <!-- String values for individual pages where sidebar facets are to be supressed -->
    <xsl:variable name="trail-string-1">xmlui.ArtifactBrowser.ItemViewer.trail</xsl:variable>
    <xsl:variable name="trail-string-2">xmlui.EPerson.PasswordLogin.trail</xsl:variable>
    <xsl:variable name="trail-string-3">xmlui.EPerson.trail_new_registration</xsl:variable>
    <xsl:variable name="trail-string-4">xmlui.ArtifactBrowser.CommunityBrowser.trail</xsl:variable>
    <xsl:variable name="trail-string-5">xmlui.ArtifactBrowser.ConfigurableBrowse.trail.item.dateissued</xsl:variable>
    <xsl:variable name="trail-string-6">xmlui.ArtifactBrowser.ConfigurableBrowse.trail.item.title</xsl:variable>
    <xsl:variable name="trail-string-7">xmlui.ArtifactBrowser.ConfigurableBrowse.trail.metadata.author</xsl:variable>
    <xsl:variable name="trail-string-8">xmlui.ArtifactBrowser.ConfigurableBrowse.trail.metadata.subject</xsl:variable>
    <xsl:variable name="trail-string-9">xmlui.Discovery.RecentSubmissions.RecentSubmissionTransformer.trail</xsl:variable>
    <xsl:variable name="trail-string-10">xmlui.Submission.general.submission.trail</xsl:variable>
    <xsl:variable name="trail-string-11">xmlui.Submission.Submissions.trail</xsl:variable>
    <xsl:variable name="trail-string-12">xmlui.EPerson.EditProfile.trail_update</xsl:variable>
    <xsl:variable name="uri-string-1">dspace_home/handle</xsl:variable>
    <xsl:variable name="uri-string-2">dspace_home/xmlui</xsl:variable>
    <xsl:variable name="uri-string-3">dspace_home/identifier-not-found</xsl:variable>
    <xsl:variable name="uri-string-4">search-filter</xsl:variable>

    <!--
        The template to handle dri:options. Since it contains only dri:list tags (which carry the actual
        information), the only things than need to be done is creating the ds-options div and applying
        the templates inside it.

        In fact, the only bit of real work this template does is add the search box, which has to be
        handled specially in that it is not actually included in the options div, and is instead built
        from metadata available under pageMeta.
    -->
    <!-- TODO: figure out why i18n tags break the go button -->
    <xsl:template match="dri:options">
        <div id="ds-options" class="word-break hidden-print">
            <xsl:if test="not(contains(/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='request'][@qualifier='URI'], 'discover'))">
                <div id="ds-search-option" class="ds-option-set">
                <!-- Variables for testing url via tail and url -->
                <!-- <p><xsl:value-of select="$request-uri" /></p> -->
                <!-- <p><xsl:value-of select="$uri-string" /></p> -->
                <!-- <p><xsl:value-of select="$trail-string" /></p> -->
                    <!-- The form, complete with a text box and a button, all built from attributes referenced
                 from under pageMeta. -->
                    <form id="ds-search-form" class="" method="post">
                        <xsl:attribute name="action">
                            <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath']"/>
                            <xsl:value-of
                                    select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='search'][@qualifier='simpleURL']"/>
                        </xsl:attribute>
                        <fieldset>
                            <div class="input-group" is="era-search-form">
                                <input class="ds-text-field form-control" type="text" placeholder="xmlui.general.search"
                                       i18n:attr="placeholder">
                                    <xsl:attribute name="name">
                                        <xsl:value-of
                                                select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='search'][@qualifier='queryField']"/>
                                    </xsl:attribute>
                                </input>
                                <span class="input-group-btn">
                                    <button class="ds-button-field btn btn-primary" id="era-search" title="xmlui.general.go" i18n:attr="title">
                                        <span class="glyphicon glyphicon-search" aria-hidden="true"/>
                                        <xsl:attribute name="onclick">
                                                    <xsl:text>
                                                        var radio = document.getElementById(&quot;ds-search-form-scope-container&quot;);
                                                        if (radio != undefined &amp;&amp; radio.checked)
                                                        {
                                                        var form = document.getElementById(&quot;ds-search-form&quot;);
                                                        form.action=
                                                    </xsl:text>
                                            <xsl:text>&quot;</xsl:text>
                                            <xsl:value-of
                                                    select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath']"/>
                                            <xsl:text>/handle/&quot; + radio.value + &quot;</xsl:text>
                                            <xsl:value-of
                                                    select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='search'][@qualifier='simpleURL']"/>
                                            <xsl:text>&quot; ; </xsl:text>
                                                    <xsl:text>
                                                        }
                                                    </xsl:text>
                                        </xsl:attribute>
                                    </button>
                                </span>
                            </div>

                            <xsl:if test="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='focus'][@qualifier='container']">
                                <div class="radio">
                                    <label>
                                        <input id="ds-search-form-scope-all" type="radio" name="scope" value=""
                                               checked="checked"/>
                                        <i18n:text>xmlui.dri2xhtml.structural.search</i18n:text>
                                    </label>
                                </div>
                                <div class="radio">
                                    <label>
                                        <input id="ds-search-form-scope-container" type="radio" name="scope">
                                            <xsl:attribute name="value">
                                                <xsl:value-of
                                                        select="substring-after(/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='focus'][@qualifier='container'],':')"/>
                                            </xsl:attribute>
                                        </input>
                                        <xsl:choose>
                                            <xsl:when
                                                    test="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='focus'][@qualifier='containerType']/text() = 'type:community'">
                                                <i18n:text>xmlui.dri2xhtml.structural.search-in-community</i18n:text>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <i18n:text>xmlui.dri2xhtml.structural.search-in-collection</i18n:text>
                                            </xsl:otherwise>

                                        </xsl:choose>
                                    </label>
                                </div>
                            </xsl:if>
                        </fieldset>
                    </form>
                </div>
            </xsl:if>
            <xsl:apply-templates/>
            <!-- DS-984 Add RSS Links to Options Box -->
            <!--<xsl:if test="count(/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='feed']) != 0">
                <div>
                    <h2 class="ds-option-set-head h6">
                        <i18n:text>xmlui.feed.header</i18n:text>
                    </h2>
                    <div id="ds-feed-option" class="ds-option-set list-group">
                        <xsl:call-template name="addRSSLinks"/>
                    </div>
                </div>

            </xsl:if>-->
        </div>
    </xsl:template>

    <!-- Add each RSS feed from meta to a list -->
    <xsl:template name="addRSSLinks">
        <xsl:for-each select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='feed']">
            <a class="list-group-item" id="rss-item">
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

    <xsl:template match="dri:options//dri:list">
        <xsl:apply-templates select="dri:head"/>
        <xsl:apply-templates select="dri:item"/>
        <xsl:apply-templates select="dri:list"/>
    </xsl:template>

    <!-- Template employs conditional using trail strings to determine current page
    The position value determines after which point the facets should be supressed -->
    <xsl:template match="dri:options/dri:list" priority="3">
        <xsl:choose>
            <xsl:when test="not($trail-string = $trail-string-1) and not($trail-string = $trail-string-2) and not($trail-string = $trail-string-3) 
                            and not($trail-string = $trail-string-4) and not($trail-string = $trail-string-5) and not($trail-string = $trail-string-6) 
                            and not($trail-string = $trail-string-7) and not($trail-string = $trail-string-8) and not($trail-string = $trail-string-9) 
                            and not($trail-string = $trail-string-10) and not($trail-string = $trail-string-11) and not($trail-string = $trail-string-12)
                            and not(contains($uri-string, $uri-string-1)) and not(contains($uri-string, $uri-string-2)) and not(contains($uri-string, $uri-string-3)) 
                            and not(contains($uri-string, $uri-string-4))">
                <div>
                    <xsl:call-template name="standardAttributes">
                        <xsl:with-param name="class">list-group</xsl:with-param>
                    </xsl:call-template>
                    <xsl:apply-templates select="dri:item"/>
                    <xsl:apply-templates select="dri:list"/>
                </div>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <!-- Suppress sidebar facets based on position in hierarchy -->
                    <xsl:when test="position() >= 3">
                    </xsl:when>
                    <xsl:otherwise>
                        <div>
                            <xsl:call-template name="standardAttributes">
                                <xsl:with-param name="class">list-group</xsl:with-param>
                            </xsl:call-template>
                            <xsl:apply-templates select="dri:item"/>
                            <xsl:apply-templates select="dri:list"/>
                        </div>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Template uses conditionals to check current page and supress facets accordingly -->
    <xsl:template match="dri:options//dri:item">
        <xsl:choose>
            <xsl:when test="not($trail-string = $trail-string-1) and not($trail-string = $trail-string-2) and not($trail-string = $trail-string-3) 
                            and not($trail-string = $trail-string-4) and not($trail-string = $trail-string-5) and not($trail-string = $trail-string-6) 
                            and not($trail-string = $trail-string-7) and not($trail-string = $trail-string-8) and not($trail-string = $trail-string-9) 
                            and not($trail-string = $trail-string-10) and not($trail-string = $trail-string-11) and not($trail-string = $trail-string-12)
                            and not(contains($uri-string, $uri-string-1)) and not(contains($uri-string, $uri-string-2)) and not(contains($uri-string, $uri-string-3)) 
                            and not(contains($uri-string, $uri-string-4))">
                <div class="sidebar-dropdown">
                    <xsl:call-template name="standardAttributes">
                        <xsl:with-param name="class">list-group-item ds-option</xsl:with-param>
                    </xsl:call-template>
                    <xsl:apply-templates />
                </div>
            </xsl:when>
            <xsl:otherwise>
                <!-- Suppress sidebar facets based on group -->
                <xsl:if test="not(../@n = 'author') and not(../@n = 'subject') and not(../@n = 'dateIssued')">
                    <div class="sidebar-dropdown">
                        <xsl:call-template name="standardAttributes">
                            <xsl:with-param name="class">list-group-item ds-option</xsl:with-param>
                        </xsl:call-template>
                        <xsl:apply-templates />
                    </div>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Template uses conditionals to check current page and supress facets accordingly -->
    <xsl:template match="dri:options//dri:item[dri:xref]">
        <xsl:choose>
            <xsl:when test="not($trail-string = $trail-string-1) and not($trail-string = $trail-string-2) and not($trail-string = $trail-string-3) 
                            and not($trail-string = $trail-string-4) and not($trail-string = $trail-string-5) and not($trail-string = $trail-string-6) 
                            and not($trail-string = $trail-string-7) and not($trail-string = $trail-string-8) and not($trail-string = $trail-string-9) 
                            and not($trail-string = $trail-string-10) and not($trail-string = $trail-string-11) and not($trail-string = $trail-string-12)
                            and not(contains($uri-string, $uri-string-1)) and not(contains($uri-string, $uri-string-2)) and not(contains($uri-string, $uri-string-3)) 
                            and not(contains($uri-string, $uri-string-4))">
                <a href="{dri:xref/@target}">
                    <xsl:call-template name="standardAttributes">
                        <xsl:with-param name="class">list-group-item ds-option</xsl:with-param>
                    </xsl:call-template>
                    <xsl:choose>
                        <xsl:when test="dri:xref/node()">
                            <xsl:apply-templates select="dri:xref/node()"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="dri:xref"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <!-- Suppress sidebar facets based on group -->
                <xsl:if test="not(../@n = 'author') and not(../@n = 'subject') and not(../@n = 'dateIssued')">
                    <a href="{dri:xref/@target}">
                        <xsl:call-template name="standardAttributes">
                            <xsl:with-param name="class">list-group-item ds-option</xsl:with-param>
                        </xsl:call-template>
                        <xsl:choose>
                            <xsl:when test="dri:xref/node()">
                                <xsl:apply-templates select="dri:xref/node()"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="dri:xref"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </a>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Template uses conditionals to check current page and supress facets accordingly -->
    <xsl:template match="dri:options/dri:list/dri:head" priority="3">
        <xsl:choose>
            <xsl:when test="not($trail-string = $trail-string-1) and not($trail-string = $trail-string-2) and not($trail-string = $trail-string-3) 
                            and not($trail-string = $trail-string-4) and not($trail-string = $trail-string-5) and not($trail-string = $trail-string-6) 
                            and not($trail-string = $trail-string-7) and not($trail-string = $trail-string-8) and not($trail-string = $trail-string-9) 
                            and not($trail-string = $trail-string-10) and not($trail-string = $trail-string-11) and not($trail-string = $trail-string-12)
                            and not(contains($uri-string, $uri-string-1)) and not(contains($uri-string, $uri-string-2)) and not(contains($uri-string, $uri-string-3)) 
                            and not(contains($uri-string, $uri-string-4))">
                <xsl:call-template name="renderHead">
                    <xsl:with-param name="class">ds-option-set-head</xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <!-- Suppress sidebar facets based on group -->
                <xsl:if test="not(../@n = 'author') and not(../@n = 'subject') and not(../@n = 'dateIssued')">
                    <xsl:call-template name="renderHead">
                        <xsl:with-param name="class">ds-option-set-head</xsl:with-param>
                    </xsl:call-template>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Template uses conditionals to check current page and supress facets accordingly -->
    <xsl:template match="dri:options/dri:list//dri:list/dri:head" priority="3">
        <xsl:choose>
            <xsl:when test="not($trail-string = $trail-string-1) and not($trail-string = $trail-string-2) and not($trail-string = $trail-string-3) 
                            and not($trail-string = $trail-string-4) and not($trail-string = $trail-string-5) and not($trail-string = $trail-string-6) 
                            and not($trail-string = $trail-string-7) and not($trail-string = $trail-string-8) and not($trail-string = $trail-string-9) 
                            and not($trail-string = $trail-string-10) and not($trail-string = $trail-string-11) and not($trail-string = $trail-string-12)
                            and not(contains($uri-string, $uri-string-1)) and not(contains($uri-string, $uri-string-2)) and not(contains($uri-string, $uri-string-3)) 
                            and not(contains($uri-string, $uri-string-4))">
                <a class="list-group-item active">
                    <span>
                        <xsl:call-template name="standardAttributes">
                            <xsl:with-param name="class">
                                <xsl:value-of select="@rend"/>
                                <xsl:text> list-group-item-heading</xsl:text>
                            </xsl:with-param>
                        </xsl:call-template>
                        <xsl:apply-templates/>
                    </span>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <!-- Suppress sidebar facets based on group -->
                <xsl:if test="not(../@n = 'author') and not(../@n = 'subject') and not(../@n = 'dateIssued')">
                    <a class="list-group-item active">
                        <span>
                            <xsl:call-template name="standardAttributes">
                                <xsl:with-param name="class">
                                    <xsl:value-of select="@rend"/>
                                    <xsl:text> list-group-item-heading</xsl:text>
                                </xsl:with-param>
                            </xsl:call-template>
                            <xsl:apply-templates/>
                        </span>
                    </a>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--<xsl:template match="dri:list[count(child::*)=0]"/>-->

</xsl:stylesheet>
