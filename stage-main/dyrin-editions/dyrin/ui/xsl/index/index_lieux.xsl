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

  <xsl:template match="*:index[@type='lieux']">
    <div class="index">
      <h1>
        <xsl:value-of select="max:i18n($project,'menu.index_lieux',$locale)"/>
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
                      <xsl:variable name="identifiant">
                        <xsl:value-of select="substring-after(substring-before(./*:iden, '.xml'),'/lieux/')"/>
                      </xsl:variable>
                      <a class="lieu">
                        <xsl:attribute name="id">
                          <xsl:value-of select="substring-before(substring-after(./*:iden, 'pddn_l.'), '.xml')"/>
                        </xsl:attribute>
                        <xsl:attribute name="onclick">
                					<xsl:text>MAX.plugins['thesauri'].showInWindow('lieux','</xsl:text>
                								<xsl:value-of select="$identifiant"/> <!-- renvoie l'dientifiant de la fiche thesauris -->
                					<xsl:text>')</xsl:text>
                				</xsl:attribute>
                        <xsl:value-of select="*:value"/>
                      </a>
                      <xsl:text>&#160;:&#160;</xsl:text>
                      <xsl:for-each-group select="current-group()" group-by="@id"> <!-- groupement par fiche: Narval etc... -->
                          <xsl:sort select="@id" order="ascending"/>
                        <a class="fiche">
                          <xsl:attribute name="href">
                            <xsl:value-of select="concat(replace(./*:baseuri[1], 'xml', 'html'), '#', substring-after($identifiant, '.'))"/>
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

</xsl:stylesheet>
