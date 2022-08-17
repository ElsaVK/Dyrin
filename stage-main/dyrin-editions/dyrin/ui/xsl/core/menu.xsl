<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:param name="baseURI"/>
    <xsl:param name="selectedTarget"/>
    <xsl:param name="projectId"/>

    <xsl:template match="/">
      <xsl:variable name="topEntry" select="/menu//entry[target/text()=$selectedTarget]/ancestor-or-self::entry[@type='main']"/>
        <div>
            <!-- top menu -->
            <ul class="navbar-nav nav-fill flex-row mr-auto">
                <xsl:for-each select="/menu/entry[@type='main']">
                    <xsl:choose>
                        <xsl:when test="count(./entry) > 0">
                        <li class="no-list-style">
                                <xsl:if test="./id/text()=$topEntry/id/text()">
                                    <xsl:attribute name="class">nav-item</xsl:attribute>
                                </xsl:if>
                                <summary class='nav-item'>
                                    <a href="{$baseURI}{$projectId}/{./target/text()}"><xsl:value-of select="./label/text()"/></a>
                                </summary>

                                    <ul>
                                        <xsl:for-each select="./entry">
                                            <li class='nav-item'>
                                                <xsl:if test="./target/text()=$selectedTarget">
                                                    <xsl:attribute name="class">active</xsl:attribute>
                                                </xsl:if>
                                                <a href="{$baseURI}{$projectId}/{./target/text()}">
                                                    <xsl:value-of select="./label/text()"/>
                                                </a>
                                            </li>
                                        </xsl:for-each>
                                    </ul>
                        </li>
                        </xsl:when>
                        <xsl:otherwise>
                            <li class='nav-item'>
                                <xsl:if test="./id/text()=$topEntry/id/text()">
                                    <xsl:attribute name="class">nav-item active</xsl:attribute>
                                </xsl:if>
                                <a href="{$baseURI}{$projectId}/{./target/text()}">
                                    <xsl:value-of select="./label/text()"/>
                                </a>

                                <ul>
                                    <xsl:for-each select="./entry">
                                        <li class='nav-item'>
                                            <xsl:if test="./target/text()=$selectedTarget">
                                                <xsl:attribute name="class">active</xsl:attribute>
                                            </xsl:if>
                                            <a href="{$baseURI}{$projectId}/{./target/text()}">
                                                <xsl:value-of select="./label/text()"/>
                                            </a>
                                        </li>
                                    </xsl:for-each>
                                </ul>

                            </li>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </ul>
            <!-- sub menu -->
<!--            <xsl:if test="count($topEntry/entry) > 0">-->
<!--                <div id="sub-navbar">-->
<!--                    <ul class="nav navbar-nav flex-row mr-auto">-->
<!--                        <xsl:for-each select="$topEntry/entry">-->
<!--                            <li class='nav-item'>-->
<!--                                <xsl:if test="./target/text()=$selectedTarget">-->
<!--                                    <xsl:attribute name="class">active</xsl:attribute>-->
<!--                                </xsl:if>-->
<!--                                <a href="{$baseURI}{$projectId}/{./target/text()}">-->
<!--                                    <xsl:value-of select="./label/text()"/>-->
<!--                                </a>-->
<!--                            </li>-->
<!--                        </xsl:for-each>-->
<!--                    </ul>-->
<!--                </div>-->
<!--            </xsl:if>-->
        </div>

    </xsl:template>


</xsl:stylesheet>
