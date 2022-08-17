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

  <xsl:template match="*:index[@type='themes']">
    <div class="index">
      <h1>
        <xsl:value-of select="max:i18n($project,'menu.index_themes',$locale)"/>
      </h1>

      <xsl:for-each-group select="./descendant::*:marker" group-by="./*:initiale">
        <xsl:sort select="./*:initiale" order="ascending"/>
        <fieldset id="{@role}{./*:initiale}">
          <legend class="collapsible">
            <xsl:value-of select="./*:initiale"/>
          </legend>
          <div class="developper">
            <xsl:for-each-group select="current-group()" group-by="./*:value"> <!-- groupement par pays: Angeleterre etc... -->
                <xsl:sort select="./*:value" order="ascending"/>
              <p class="entries">
                <a class="theme">
                  <xsl:attribute name="id">
                    <xsl:value-of select="substring-after(./*:iden, 'pcrt')"/>
                  </xsl:attribute>
                  <xsl:attribute name="onclick">
                    <xsl:text>window.open('</xsl:text>
                    <xsl:value-of select="./*:iden"/>
                    <xsl:text>')</xsl:text>
                  </xsl:attribute>
                  <xsl:value-of select="*:value"/>
                </a>
                <xsl:text>&#160;:&#160;</xsl:text>
                <xsl:for-each-group select="current-group()" group-by="@id"> <!-- groupement par fiche: Narval etc... -->
                    <xsl:sort select="@id" order="ascending"/> <!-- au cas où s'il y a un é majuscule dans la fiche -->
                  <a class="fiche">
                    <xsl:attribute name="href">
                      <xsl:value-of select="concat(replace(./*:baseuri[1], 'xml', 'html'), '#', substring-after(./*:iden, 'pcrt'))"/>
                    </xsl:attribute>
                     <xsl:value-of select="@id"/>
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

  <!-- <xsl:template match="*:index[@type='themes']">
    <div class="index">
      <h1>
        <xsl:value-of select="max:i18n($project,'menu.index_themes',$locale)"/>
      </h1>

            <xsl:for-each-group select="./descendant::*:marker" group-by="./*:initiale">
              <xsl:sort select="upper-case(./*:initiale)" order="ascending"/>
              <xsl:choose>
              <xsl:when test="./descendant::*:value = ''"/>
              <xsl:otherwise>
              <fieldset id="{@role}{./*:initiale}">
                <legend class="collapsible">
                  <xsl:value-of select="upper-case(./*:initiale)"/>
                </legend>
                <div class="developper">
                  <xsl:for-each-group select="current-group()" group-by="./*:value">
                    <xsl:sort select="." order="ascending"/>
                    <p class="entries">
                      <xsl:value-of select="upper-case(./*:initiale)"/>
                      <xsl:text>–&#160;</xsl:text>
                      <span class="placename">
                        <xsl:value-of select="*:value"/>
                      </span>
                      <xsl:text>&#160;:&#160;</xsl:text>
                      <xsl:for-each-group select="current-group()" group-by="@id">
                        <xsl:sort select="translate(@id,'É[', 'E')" order="ascending"/>
                        <a>
                          <xsl:attribute name="href">
                            <xsl:value-of select="replace(./*:baseuri[1], 'xml', 'html')"/>
                          </xsl:attribute>
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
              </xsl:otherwise>
            </xsl:choose>
            </xsl:for-each-group>
    </div>
  </xsl:template> -->

</xsl:stylesheet>
