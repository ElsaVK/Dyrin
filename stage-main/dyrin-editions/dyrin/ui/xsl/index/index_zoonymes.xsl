<xsl:stylesheet version="2.0"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:xinclude="http://www.w3.org/2001/XInclude"
  xmlns:xhtml="http://www.w3.org/TR/xhtml/strict"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:ead="urn:isbn:1-931666-22-9"
  xmlns:hfp="http://www.w3.org/2001/XMLSchema-hasFacetAndProperty"
  xmlns:max="https://max.unicaen.fr"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="max ead tei xsl xsi xs xlink xinclude xhtml tei hfp">
  <xsl:import href="../../../../../ui/xsl/core/i18n.xsl"/>
  <xsl:output method="xhtml" encoding="utf-8" indent="no"/>

  <xsl:preserve-space elements="*"/>

  <xsl:param name="project"/>
  <xsl:param name="locale"/>
  <xsl:param name="key"/>

  <!-- <xsl:template match="*:initiale" mode="initiale">
    <xsl:choose>
  <xsl:when test="contains(., 'é')">
    <xsl:sort select="replace(./*:initiale, 'é', 'e')"/>
  </xsl:when>
  <xsl:when test="contains(./*:value,'ä')">
    <xsl:sort select="replace(./*:initiale, 'ä', 'a')"/>
  </xsl:when>
  <xsl:otherwise/>
</xsl:choose>
  </xsl:template> -->


  <xsl:template match="*:index[@type='zoonymes']">
    <div class="index">
      <h1>
        <xsl:value-of select="max:i18n($project,'menu.index_zoonymes',$locale)"/>
      </h1>
            <xsl:for-each-group select="./descendant::*:marker" group-by="./*:initiale"> <!-- trie sur les initiales -->
              <xsl:sort select="./*:initiale" order="ascending"/>
              <fieldset id="{@role}{./*:initiale}">
                <legend class="collapsible">
                  <xsl:value-of select="./*:initiale"/>
                </legend>
                <div class="developper">
                  <xsl:for-each-group select="current-group()" group-by="./*:value">
                    <xsl:sort select="./*:value" order="ascending"/>
                    <!-- <xsl:sort select="translate(./*:value,'Ä', 'A')" order="ascending"/> -->
                    <p class="entries">
                      <span class="zoonyme">
                        <xsl:value-of select="lower-case(*:value)"/>
                      </span>
                      <xsl:text>&#160;:&#160;</xsl:text>
                      <xsl:for-each-group select="current-group()" group-by="@id">
                        <xsl:sort select="@id" order="ascending"/>
                        <a class="fiche">
                          <xsl:attribute name="href">
                            <xsl:value-of select="replace(./*:baseuri[1], 'xml', 'html')"/>
                          </xsl:attribute>
                          <!--<xsl:value-of select="./*:entry"/>-->
                           <xsl:value-of select="./@id"/>
                        </a>
                        <xsl:if test="not(position()=last())">
                          <xsl:text>&#160;; </xsl:text>
                        </xsl:if>
                      </xsl:for-each-group>
                    </p>
                  </xsl:for-each-group>
                </div>
              </fieldset>
            </xsl:for-each-group>
    </div>
  </xsl:template>

</xsl:stylesheet>
