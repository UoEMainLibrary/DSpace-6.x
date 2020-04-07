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
                xmlns:util="org.dspace.app.xmlui.utils.XSLUtils"
                exclude-result-prefixes="i18n dri mets xlink xsl dim xhtml mods dc">

    <xsl:output indent="yes"/>

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

            <!-- CONDITION REMOVED TO DISPLAY NAVIGATION ON ALL PAGES -->
            <!--<xsl:if test="not(contains(/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='request'][@qualifier='URI'], 'discover'))">-->
            <div id="ds-search-option" class="ds-option-set">

                <!-- SEARCH BAR, COLLECTION, & DSPACE CHECKBOXES REVOVED -->
                <!--<form id="ds-search-form" class="" method="post">
                    <xsl:attribute name="action">
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath']"/>
                        <xsl:value-of
                                select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='search'][@qualifier='simpleURL']"/>
                    </xsl:attribute>
                    <fieldset>
                        <div class="input-group">
                            <input class="ds-text-field form-control" type="text" placeholder="xmlui.general.search"
                                   i18n:attr="placeholder">
                                <xsl:attribute name="name">
                                    <xsl:value-of
                                            select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='search'][@qualifier='queryField']"/>
                                </xsl:attribute>
                            </input>
                            <span class="input-group-btn">
                                <button class="ds-button-field btn btn-primary" title="xmlui.general.go" i18n:attr="title">
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
                        </div>-->

                <!--<xsl:if test="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='focus'][@qualifier='container']">
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
        </form>-->

            </div>
            <!--</xsl:if>-->
            <!--<xsl:apply-templates select="dri:list[@n='browse']"/>-->
            <xsl:apply-templates select="dri:list[@n='author']"/>
            <xsl:apply-templates select="dri:list[@n='subject']"/>
            <xsl:apply-templates select="dri:list[@n='context']"/>
            <xsl:apply-templates select="dri:list[@n='account']"/>
            <xsl:apply-templates select="dri:list[@n='administrative']"/>
            <xsl:apply-templates select="dri:list[@n='statistics']"/>
            <xsl:apply-templates select="dri:list[@n='discovery']"/>
            <!--<xsl:apply-templates/>-->

            <!-- RSS FEED REVOVED -->
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

    <!-- RSS FEED REVOVED -->
    <!-- Add each RSS feed from meta to a list -->
    <!--<xsl:template name="addRSSLinks">
        <xsl:for-each select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='feed']">
            <a class="list-group-item">
                <xsl:attribute name="href">
                    <xsl:value-of select="."/>
                </xsl:attribute>

                <img src="{concat($context-path, '/static/icons/feed.png')}" class="btn-xs" alt="xmlui.mirage2.navigation.rss.feed" i18n:attr="alt"/>

                <xsl:choose>
                    <xsl:when test="contains(., 'rss_1.0')">
                        <xsl:text>RSS 1.0</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains(., 'rss_2.0')">
                        <xsl:text>RSS 2.0</xsl:text>
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
    </xsl:template>-->

    <xsl:template match="dri:options//dri:list">
        <xsl:apply-templates select="dri:head"/>
        <xsl:apply-templates select="dri:item"/>
        <xsl:apply-templates select="dri:list"/>
    </xsl:template>

    <!-- URL variables to be used in template conditionals -->
    <!--> Supress 'Subject' in navigation bar if $doc-url equal to $doc-root (i.e. only display 'Subject' on collection pages) -->
    <xsl:variable name="doc-root" select="translate(/dri:document/dri:meta/dri:pageMeta/dri:trail[@target][last()]/@target, '/', '')" />
    <xsl:variable name="doc-url" select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='request'][@qualifier='URI']" />
    <xsl:variable name="full-url" select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='request']" />
    <xsl:variable name="return-url" select="$document//dri:meta/dri:pageMeta/dri:trail[@target][last()]/@target" />
    <xsl:variable name="auth" select="/dri:document/dri:meta/dri:userMeta/@authenticated" />
    <xsl:variable name="auth-group" select="/dri:document/dri:meta/dri:userMeta/dri:metadata[@element='identifier'][@qualifier='group']" />

    <!-- ALL SIDEBAR NAVIGATION ELEMENTS CHECKED TO SEE IF THEY RELATE TO SCHOOLS AND SERVED ACCORDINGLY (I.E. ONLY DISPLAY SCHOOLS) -->
    <!-- 'SUBJECT' NAVIGATION ELEMENTS SUPRESSED ON HOME PAGE -->
    <xsl:template match="dri:options/dri:list" priority="3">
        <xsl:choose>
            <xsl:when test="$auth = 'yes' and $auth-group = 'Administrator'">
                <xsl:choose>
                    <xsl:when test="$doc-url = $doc-root">
                        <xsl:if test="not(../@n = 'subject') and not(../@n = 'browse') and not(../@n = 'datetemporal') and not(../@n = 'titlefacet')">
                            <div id="list-group-div">
                                <xsl:call-template name="standardAttributes">
                                    <xsl:with-param name="class">list-group</xsl:with-param>
                                </xsl:call-template>
                                <xsl:apply-templates select="dri:item"/>
                                <xsl:apply-templates select="dri:list"/>
                            </div>
                        </xsl:if>
                    </xsl:when>
                    <xsl:when test="not(contains($full-url, 'subject'))">
                        <xsl:if test="not(../@n = 'browse') and not(../@n = 'datetemporal') and not(../@n = 'titlefacet')">
                            <div id="list-group-div">
                                <xsl:call-template name="standardAttributes">
                                    <xsl:with-param name="class">list-group</xsl:with-param>
                                </xsl:call-template>
                                <xsl:apply-templates/>
                            </div>
                        </xsl:if>
                    </xsl:when>
                    <xsl:when test="contains($full-url, 'profile')">
                        <xsl:if test="not(../@n = 'browse') and not(../@n = 'datetemporal') and not(../@n = 'titlefacet')">
                            <div id="list-group-div">
                                <xsl:call-template name="standardAttributes">
                                    <xsl:with-param name="class">list-group</xsl:with-param>
                                </xsl:call-template>
                                <xsl:apply-templates/>
                            </div>
                        </xsl:if>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:if test="not(../@n = 'browse') and not(../@n = 'global') and not(../@n = 'browse')">
                            <div id="list-group-div">
                                <xsl:call-template name="standardAttributes">
                                    <xsl:with-param name="class">list-group</xsl:with-param>
                                </xsl:call-template>
                                <xsl:apply-templates select="dri:item"/>
                                <xsl:apply-templates select="dri:list"/>
                            </div>
                        </xsl:if>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="$doc-url = $doc-root">
                        <xsl:if test="not(../@n = 'account') and not(../@n = 'subject') and not(../@n = 'browse') and not(../@n = 'datetemporal') and not(../@n = 'titlefacet')">
                            <div id="list-group-div">
                                <xsl:call-template name="standardAttributes">
                                    <xsl:with-param name="class">list-group</xsl:with-param>
                                </xsl:call-template>
                                <xsl:apply-templates select="dri:item"/>
                                <xsl:apply-templates select="dri:list"/>
                            </div>
                        </xsl:if>
                    </xsl:when>
                    <xsl:when test="not(contains($full-url, 'subject'))">
                        <xsl:if test="not(../@n = 'browse') and not(../@n = 'account') and not(../@n = 'datetemporal') and not(../@n = 'titlefacet')">
                            <div id="list-group-div">
                                <xsl:call-template name="standardAttributes">
                                    <xsl:with-param name="class">list-group</xsl:with-param>
                                </xsl:call-template>
                                <xsl:apply-templates/>
                            </div>
                        </xsl:if>
                    </xsl:when>
                    <xsl:when test="contains($full-url, 'profile')">
                        <xsl:if test="not(../@n = 'browse') and not(../@n = 'datetemporal') and not(../@n = 'titlefacet')">
                            <div id="list-group-div">
                                <xsl:call-template name="standardAttributes">
                                    <xsl:with-param name="class">list-group</xsl:with-param>
                                </xsl:call-template>
                                <xsl:apply-templates/>
                            </div>
                        </xsl:if>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:if test="not(../@n = 'browse') and not(../@n = 'account') and not(../@n = 'global') and not(../@n = 'browse')">
                            <div id="list-group-div">
                                <xsl:call-template name="standardAttributes">
                                    <xsl:with-param name="class">list-group</xsl:with-param>
                                </xsl:call-template>
                                <xsl:apply-templates select="dri:item"/>
                                <xsl:apply-templates select="dri:list"/>
                            </div>
                        </xsl:if>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template match="dri:options//dri:item">
        <xsl:choose>
            <xsl:when test="$auth = 'yes' and $auth-group = 'Administrator'">
                <xsl:choose>

                    <!-- Only show author on home page -->

                    <xsl:when test="$doc-url = $doc-root">
                        <xsl:if test="not(../@n = 'account') and not(../@n = 'subject') and not(../@n = 'browse') and not(../@n = 'datetemporal') and not(../@n = 'titlefacet')">
                            <div id="list-group-opt-div">

                                <a id="facet-back-link" href="/dri:document/dri:meta/dri:pageMeta/dri:trail[@target][last()]/@target" alt="View papers with this category link" title="Click to filter papers by this subject">
                                    <xsl:call-template name="standardAttributes">
                                        <xsl:with-param name="class">list-group-item ds-option</xsl:with-param>
                                    </xsl:call-template>
                                    <xsl:apply-templates/>
                                </a>
                                <xsl:comment>Stuff</xsl:comment>
                            </div>
                        </xsl:if>
                    </xsl:when>

                    <!-- Show subject links -->

                    <xsl:when test="not(contains($full-url, 'subject'))">
                        <xsl:if test="not(../@n = 'browse') and not(../@n = 'account') and not(../@n = 'datetemporal') and not(../@n = 'titlefacet')">
                            <div id="list-group-opt-div">
                                <xsl:call-template name="standardAttributes">
                                    <xsl:with-param name="class">list-group-item ds-option</xsl:with-param>
                                </xsl:call-template>
                                <xsl:apply-templates/>
                                <a>
                                    <xsl:attribute name="href">
                                        <xsl:text>discover</xsl:text>
                                    </xsl:attribute>
                                    <xsl:attribute name="class">
                                        <xsl:text>facet_button</xsl:text>
                                    </xsl:attribute>
                                    <xsl:text>X</xsl:text>
                                </a>
                            </div>
                        </xsl:if>
                    </xsl:when>

                    <!-- Show year and title filters -->

                    <xsl:otherwise>
                        <xsl:if test="not(../@n = 'browse') and not(../@n = 'account') and not(../@n = 'global')">
                            <div id="list-group-opt-div">
                                <xsl:call-template name="standardAttributes">
                                    <xsl:with-param name="class">list-group-item ds-option</xsl:with-param>
                                </xsl:call-template>
                                <xsl:apply-templates/>
                                <a>
                                    <xsl:attribute name="href">
                                        <xsl:choose>
                                            <!--   If a filter has been selected and we're about to print out the author/school axing the school always returns to spot 1. -->
                                            <xsl:when test="../@n = 'author'">
                                                <xsl:text>discover</xsl:text>
                                            </xsl:when>
                                            <xsl:when test="../@n = 'subject'">
                                                <!-- We only want to keep the school if axing the course -->
                                                <xsl:value-of select="util:removeFilter($full-url, 'author')"/>
                                            </xsl:when>
                                            <xsl:when test="../@n = 'datetemporal'">
                                                <xsl:value-of select="util:removeFilter($full-url, 'author, subject, titlefacet')"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="util:removeFilter($full-url, 'author, subject, datetemporal')"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:attribute>
                                    <xsl:attribute name="class">
                                        <xsl:text>facet_button</xsl:text>
                                    </xsl:attribute>
                                    <xsl:text>X</xsl:text>
                                </a>
                            </div>
                        </xsl:if>
                    </xsl:otherwise>

                </xsl:choose>

            </xsl:when>

            <!-- All other conditions -->

            <xsl:otherwise>

                <xsl:choose>

                    <!-- Only show author on home page -->

                    <xsl:when test="$doc-url = $doc-root">
                        <xsl:if test="not(../@n = 'account') and not(../@n = 'subject') and not(../@n = 'browse') and not(../@n = 'datetemporal') and not(../@n = 'titlefacet')">
                            <div id="list-group-opt-div">

                                <a id="facet-back-link" href="/dri:document/dri:meta/dri:pageMeta/dri:trail[@target][last()]/@target" alt="View papers with this category link" title="Click to filter papers by this subject">
                                    <xsl:call-template name="standardAttributes">
                                        <xsl:with-param name="class">list-group-item ds-option</xsl:with-param>
                                    </xsl:call-template>
                                    <xsl:apply-templates/>
                                </a>
                                <xsl:comment>Stuff</xsl:comment>
                            </div>
                        </xsl:if>
                    </xsl:when>

                    <!-- Show subject links -->

                    <xsl:when test="not(contains($full-url, 'subject'))">
                        <xsl:if test="not(../@n = 'browse') and not(../@n = 'account') and not(../@n = 'datetemporal') and not(../@n = 'titlefacet')">
                            <div id="list-group-opt-div">
                                <xsl:call-template name="standardAttributes">
                                    <xsl:with-param name="class">list-group-item ds-option</xsl:with-param>
                                </xsl:call-template>
                                <xsl:apply-templates/>
                                <a>
                                    <xsl:attribute name="href">
                                        <xsl:text>discover</xsl:text>
                                    </xsl:attribute>
                                    <xsl:attribute name="class">
                                        <xsl:text>facet_button</xsl:text>
                                    </xsl:attribute>
                                    <xsl:text>X</xsl:text>
                                </a>
                            </div>
                        </xsl:if>
                    </xsl:when>

                    <!-- Show year and title filters -->

                    <xsl:otherwise>
                        <xsl:if test="not(../@n = 'browse') and not(../@n = 'account') and not(../@n = 'global') and not(../@n = 'browse')">
                            <div id="list-group-opt-div">
                                <xsl:call-template name="standardAttributes">
                                    <xsl:with-param name="class">list-group-item ds-option</xsl:with-param>
                                </xsl:call-template>
                                <xsl:apply-templates/>
                                <a>
                                    <xsl:attribute name="href">
                                        <xsl:choose>
                                            <!--   If a filter has been selected and we're about to print out the author/school axing the school always returns to spot 1. -->
                                            <xsl:when test="../@n = 'author'">
                                                <xsl:text>discover</xsl:text>
                                            </xsl:when>
                                            <xsl:when test="../@n = 'subject'">
                                                <!-- We only want to keep the school if axing the course -->
                                                <xsl:value-of select="util:removeFilter($full-url, 'author')"/>
                                            </xsl:when>
                                            <xsl:when test="../@n = 'datetemporal'">
                                                <xsl:value-of select="util:removeFilter($full-url, 'author, subject, titlefacet')"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="util:removeFilter($full-url, 'author, subject, datetemporal')"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:attribute>
                                    <xsl:attribute name="class">
                                        <xsl:text>facet_button</xsl:text>
                                    </xsl:attribute>
                                    <xsl:text>X</xsl:text>
                                </a>
                            </div>
                        </xsl:if>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="dri:options//dri:item[dri:xref]">
        <xsl:choose>
            <xsl:when test="$auth = 'yes' and $auth-group = 'Administrator'">
                <xsl:choose>
                    <xsl:when test="$doc-url = $doc-root">
                        <xsl:if test="not(../@n = 'subject') and not(../@n = 'browse') and not(../@n = 'datetemporal') and not(../@n = 'titlefacet')">
                            <!-- Conditional to determine title value for accessibility -->
                            <xsl:choose>
                                <xsl:when test="../@n = 'author'">
                                    <a href="{dri:xref/@target}" alt="View papers with this category link" title="Click to view all papers from this school">
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
                                <xsl:when test="../@n = 'subject'">
                                    <a href="{dri:xref/@target}" alt="View papers with this category link" title="Click to filter papers by this subject">
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
                                <xsl:when test="../@n = 'datetemporal'">
                                    <a href="{dri:xref/@target}" alt="View papers with this category link" title="Click to filter papers by this accademic year">
                                        <xsl:call-template name="standardAttributes">
                                            <xsl:with-param name="class">list-group-item ds-option</xsl:with-param>
                                        </xsl:call-template>
                                        <xsl:choose>
                                            <xsl:when test="dri:xref/node()">
                                                <xsl:apply-templates select="dri:xref/node()"/>gm
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="dri:xref"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </a>
                                </xsl:when>
                                <xsl:when test="../@n = 'titlefacet'">
                                    <a href="{dri:xref/@target}" alt="View papers with this category link" title="Click to filter papers by this course title">
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
                                    <xsl:choose>
                                        <xsl:when test="contains(@target, 'logout') or contains(@target, 'profile')">
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <a href="{dri:xref/@target}" alt="View papers with this category link" title="Click to view this administrutive page">
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
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:otherwise>
                            </xsl:choose>
                            <!-- End of conditional -->
                        </xsl:if>
                    </xsl:when>
                    <xsl:when test="not(contains($full-url, 'subject'))">
                        <xsl:if test="not(../@n = 'browse') and not(../@n = 'datetemporal') and not(../@n = 'titlefacet')">
                            <xsl:choose>
                                <xsl:when test="../@n = 'subject'">
                                    <a href="{dri:xref/@target}" alt="View papers with this category link" title="Click to filter papers by this subject">
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
                                <xsl:when test="../@n = 'datetemporal'">
                                    <a href="{dri:xref/@target}" alt="View papers with this category link" title="Click to filter papers by this accademic year">
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
                                <xsl:when test="../@n = 'titlefacet'">
                                    <a href="{dri:xref/@target}" alt="View papers with this category link" title="Click to filter papers by this course title">
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
                                    <a href="{dri:xref/@target}" alt="View papers with this category link" title="Click to view this administrutive page">
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
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:if>
                    </xsl:when>
                    <xsl:when test="contains($full-url, 'profile')">
                        <xsl:if test="not(../@n = 'browse') and not(../@n = 'datetemporal') and not(../@n = 'titlefacet')">
                            <xsl:choose>
                                <xsl:when test="../@n = 'subject'">
                                    <a href="{dri:xref/@target}" alt="View papers with this category link" title="Click to filter papers by this subject">
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
                                <xsl:when test="../@n = 'datetemporal'">
                                    <a href="{dri:xref/@target}" alt="View papers with this category link" title="Click to filter papers by this accademic year">
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
                                <xsl:when test="../@n = 'titlefacet'">
                                    <a href="{dri:xref/@target}" alt="View papers with this category link" title="Click to filter papers by this course title">
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
                                    <a href="{dri:xref/@target}" alt="View papers with this category link" title="Click to view this administrutive page">
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
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:if>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:if test="not(../@n = 'browse') and not(../@n = 'global') and not(../@n = 'browse')">
                            <xsl:choose>
                                <xsl:when test="../@n = 'subject'">
                                    <a href="{dri:xref/@target}" alt="View papers with this category link" title="Click to filter papers by this subject">
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
                                <xsl:when test="../@n = 'datetemporal'">
                                    <a href="{dri:xref/@target}" alt="View papers with this category link" title="Click to filter papers by this accademic year">
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
                                <xsl:when test="../@n = 'titlefacet'">
                                    <a href="{dri:xref/@target}" alt="View papers with this category link" title="Click to filter papers by this course title">
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
                                    <xsl:choose>
                                        <xsl:when test="contains(@target, 'logout') or contains(@target, 'profile')">
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <a href="{dri:xref/@target}" alt="View papers with this category link" title="Click to view this administrutive page">
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
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:if>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="$doc-url = $doc-root">
                        <xsl:if test="not(../@n = 'account') and not(../@n = 'subject') and not(../@n = 'browse') and not(../@n = 'datetemporal') and not(../@n = 'titlefacet')">
                            <!-- Conditional to determine title value for accessibility -->
                            <xsl:choose>
                                <xsl:when test="../@n = 'author'">
                                    <a href="{dri:xref/@target}" alt="View papers with this category link" title="Click to view all papers from this school">
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
                                <xsl:when test="../@n = 'subject'">
                                    <a href="{dri:xref/@target}" alt="View papers with this category link" title="Click to filter papers by this subject">
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
                                <xsl:when test="../@n = 'datetemporal'">
                                    <a href="{dri:xref/@target}" alt="View papers with this category link" title="Click to filter papers by this accademic year">
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
                                <xsl:when test="../@n = 'titlefacet'">
                                    <a href="{dri:xref/@target}" alt="View papers with this category link" title="Click to filter papers by this course title">
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
                                    <a href="{dri:xref/@target}" alt="View papers with this category link" title="Click to view this administrutive page">
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
                                </xsl:otherwise>
                            </xsl:choose>
                            <!-- End of conditional -->
                        </xsl:if>
                    </xsl:when>
                    <xsl:when test="not(contains($full-url, 'subject'))">
                        <xsl:if test="not(../@n = 'browse') and not(../@n = 'account') and not(../@n = 'datetemporal') and not(../@n = 'titlefacet')">
                            <xsl:choose>
                                <xsl:when test="../@n = 'subject'">
                                    <a href="{dri:xref/@target}" alt="View papers with this category link" title="Click to filter papers by this subject">
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
                                <xsl:when test="../@n = 'datetemporal'">
                                    <a href="{dri:xref/@target}" alt="View papers with this category link" title="Click to filter papers by this accademic year">
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
                                <xsl:when test="../@n = 'titlefacet'">
                                    <a href="{dri:xref/@target}" alt="View papers with this category link" title="Click to filter papers by this course title">
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
                                    <a href="{dri:xref/@target}" alt="View papers with this category link" title="Click to view this administrutive page">
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
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:if>
                    </xsl:when>
                    <xsl:when test="contains($full-url, 'profile')">
                        <xsl:if test="not(../@n = 'browse') and not(../@n = 'datetemporal') and not(../@n = 'titlefacet')">
                            <xsl:choose>
                                <xsl:when test="../@n = 'subject'">
                                    <a href="{dri:xref/@target}" alt="View papers with this category link" title="Click to filter papers by this subject">
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
                                <xsl:when test="../@n = 'datetemporal'">
                                    <a href="{dri:xref/@target}" alt="View papers with this category link" title="Click to filter papers by this accademic year">
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
                                <xsl:when test="../@n = 'titlefacet'">
                                    <a href="{dri:xref/@target}" alt="View papers with this category link" title="Click to filter papers by this course title">
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
                                    <a href="{dri:xref/@target}" alt="View papers with this category link" title="Click to view this administrutive page">
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
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:if>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:if test="not(../@n = 'browse') and not(../@n = 'account') and not(../@n = 'global') and not(../@n = 'browse')">
                            <xsl:choose>
                                <xsl:when test="../@n = 'subject'">
                                    <a href="{dri:xref/@target}" alt="View papers with this category link" title="Click to filter papers by this subject">
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
                                <xsl:when test="../@n = 'datetemporal'">
                                    <a href="{dri:xref/@target}" alt="View papers with this category link" title="Click to filter papers by this accademic year">
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
                                <xsl:when test="../@n = 'titlefacet'">
                                    <a href="{dri:xref/@target}" alt="View papers with this category link" title="Click to filter papers by this course title">
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
                                    <a href="{dri:xref/@target}" alt="View papers with this category link" title="Click to view this administrutive page">
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
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:if>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="dri:options/dri:list/dri:head" priority="3">
        <xsl:choose>
            <xsl:when test="$auth = 'yes' and $auth-group = 'Administrator'">
                <xsl:choose>
                    <xsl:when test="$doc-url = $doc-root">
                        <xsl:if test="not(../@n = 'subject') and not(../@n = 'browse') and not(../@n = 'datetemporal') and not(../@n = 'titlefacet')">
                            <xsl:call-template name="renderHead">
                                <xsl:with-param name="class">ds-option-set-head</xsl:with-param>
                            </xsl:call-template>
                        </xsl:if>
                    </xsl:when>
                    <xsl:when test="not(contains($full-url, 'subject'))">
                        <xsl:if test="not(../@n = 'browse') and not(../@n = 'datetemporal') and not(../@n = 'titlefacet')">
                            <xsl:call-template name="renderHead">
                                <xsl:with-param name="class">ds-option-set-head</xsl:with-param>
                            </xsl:call-template>
                        </xsl:if>
                    </xsl:when>
                    <xsl:when test="contains($full-url, 'profile')">
                        <xsl:if test="not(../@n = 'browse') and not(../@n = 'datetemporal') and not(../@n = 'titlefacet')">
                            <xsl:call-template name="renderHead">
                                <xsl:with-param name="class">ds-option-set-head</xsl:with-param>
                            </xsl:call-template>
                        </xsl:if>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:if test="not(../@n = 'browse') and not(../@n = 'global') and not(../@n = 'browse')">
                            <xsl:call-template name="renderHead">
                                <xsl:with-param name="class">ds-option-set-head</xsl:with-param>
                            </xsl:call-template>
                        </xsl:if>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="$doc-url = $doc-root">
                        <xsl:if test="not(../@n = 'account') and not(../@n = 'subject') and not(../@n = 'browse') and not(../@n = 'datetemporal') and not(../@n = 'titlefacet')">
                            <xsl:call-template name="renderHead">
                                <xsl:with-param name="class">ds-option-set-head</xsl:with-param>
                            </xsl:call-template>
                        </xsl:if>
                    </xsl:when>
                    <xsl:when test="not(contains($full-url, 'subject'))">
                        <xsl:if test="not(../@n = 'browse') and not(../@n = 'account') and not(../@n = 'datetemporal') and not(../@n = 'titlefacet')">
                            <xsl:call-template name="renderHead">
                                <xsl:with-param name="class">ds-option-set-head</xsl:with-param>
                            </xsl:call-template>
                        </xsl:if>
                    </xsl:when>
                    <xsl:when test="contains($full-url, 'profile')">
                        <xsl:if test="not(../@n = 'browse') and not(../@n = 'datetemporal') and not(../@n = 'titlefacet')">
                            <xsl:call-template name="renderHead">
                                <xsl:with-param name="class">ds-option-set-head</xsl:with-param>
                            </xsl:call-template>
                        </xsl:if>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:if test="not(../@n = 'browse') and not(../@n = 'account') and not(../@n = 'global') and not(../@n = 'browse')">
                            <xsl:call-template name="renderHead">
                                <xsl:with-param name="class">ds-option-set-head</xsl:with-param>
                            </xsl:call-template>
                        </xsl:if>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="dri:options/dri:list//dri:list/dri:head" priority="3">
        <xsl:choose>
            <xsl:when test="$auth = 'yes' and $auth-group = 'Administrator'">
                <xsl:choose>
                    <xsl:when test="$doc-url = $doc-root">
                        <xsl:if test="not(../@n = 'subject') and not(../@n = 'browse') and not(../@n = 'datetemporal') and not(../@n = 'titlefacet')">
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
                    </xsl:when>
                    <xsl:when test="not(contains($full-url, 'subject'))">
                        <xsl:if test="not(../@n = 'browse') and not(../@n = 'datetemporal') and not(../@n = 'titlefacet')">
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
                    </xsl:when>
                    <xsl:when test="contains($full-url, 'profile')">
                        <xsl:if test="not(../@n = 'browse') and not(../@n = 'datetemporal') and not(../@n = 'titlefacet')">
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
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:if test="not(../@n = 'browse') and not(../@n = 'global') and not(../@n = 'browse')">
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
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="$doc-url = $doc-root">
                        <xsl:if test="not(../@n = 'account') and not(../@n = 'subject') and not(../@n = 'browse') and not(../@n = 'datetemporal') and not(../@n = 'titlefacet')">
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
                    </xsl:when>
                    <xsl:when test="not(contains($full-url, 'subject'))">
                        <xsl:if test="not(../@n = 'browse') and not(../@n = 'account') and not(../@n = 'datetemporal') and not(../@n = 'titlefacet')">
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
                    </xsl:when>
                    <xsl:when test="contains($full-url, 'profile')">
                        <xsl:if test="not(../@n = 'browse') and not(../@n = 'datetemporal') and not(../@n = 'titlefacet')">
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
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:if test="not(../@n = 'browse') and not(../@n = 'account') and not(../@n = 'global') and not(../@n = 'browse')">
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
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--<xsl:template match="dri:list[count(child::*)=0]"/>-->

</xsl:stylesheet>
