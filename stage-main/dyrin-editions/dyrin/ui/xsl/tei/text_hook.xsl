<?xml version="1.0" encoding="UTF-8"?>
<!--
 For conditions of distribution and use, see the accompanying legal.txt file.
-->
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                exclude-result-prefixes="tei xsl">

    <!-- <xsl:import href="document_title.xsl"/> -->

    <xsl:output method="xml" encoding="utf-8"/>

    <xsl:param name="baseuri"/>
    <xsl:param name="project"/>
    <xsl:param name="route"/>
    <xsl:param name="id"/>


    <!-- <xsl:template match="node() | @*">
        <xsl:copy>
          <xsl:apply-templates select="@*|node()" />
        </xsl:copy>
    </xsl:template> -->

    <!-- gestion de la racine -->
    <xsl:template match="/">
<div class="contenu">
    <h1 class="titre_fiche">
      <!-- <xsl:value-of select=".//tei:titleStmt/tei:title"/> -->
      <xsl:apply-templates select=".//tei:titleStmt/tei:title"/>
    </h1>
    <!-- <xsl:apply-templates select=".//tei:titleStmt//tei:title"/> -->
    <xsl:apply-templates select=".//tei:body"/>
    <xsl:apply-templates select=".//tei:teiHeader"/>
</div>
  </xsl:template>

  <!-- on cache certaines parties de l'arbre que l'on ne souhaite pas montrer -->
  <xsl:template match="tei:profileDesc//tei:abstract|tei:langUsage"/> <!-- la langue de l'arbre xml -->
  <xsl:template match="//tei:div[@type='images']/tei:head"/> <!-- le titre Image de la partie iconographie -->
  <xsl:template match="tei:div[@type='presentation']/tei:head"/>   <!-- on retire le titre 'Presentation' -->

            <xsl:template match="tei:text" name="text">
              <div class="blop">
                <xsl:apply-templates/>
              </div>
            </xsl:template>

            <xsl:template match="tei:body" name="body">
              <div class="body">
                <xsl:apply-templates/>
              </div>
            </xsl:template>


    <xsl:template match="tei:teiHeader" name="metadata">
    <div class="metadata">
      <!-- <span class="hide">
        <xsl:value-of select=".//tei:author[1]"/>
      </span> -->
    <xsl:apply-templates/>
  </div>
    </xsl:template>

    <xsl:template match="tei:teiHeader//tei:name">
      <span class="auteur_fiche">
        <xsl:apply-templates/>
      </span>
    </xsl:template>

    <xsl:template match="tei:titleStmt">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="tei:fileDesc">
      <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="tei:publicationStmt">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="tei:publisher">
      <span class="editeur">
      <xsl:apply-templates/>
    </span>
    <xsl:if test="following-sibling::tei:date">
      <xsl:text>, </xsl:text>
    </xsl:if>
    </xsl:template>

    <!-- gestion des title -->
    <xsl:template match="tei:title">
      <xsl:choose>
        <xsl:when test="ancestor::tei:listBibl">
      <span>
        <xsl:attribute name="class">
          <xsl:value-of select="concat('titre_', ancestor::tei:listBibl/@type)"/>
        </xsl:attribute>
        <xsl:apply-templates/>
        <span>
          <xsl:text> (</xsl:text>
          <xsl:apply-templates select="ancestor::tei:listBibl/@subtype" mode="titre"/>
        <abbr>
          <xsl:attribute name="title">
            <xsl:apply-templates select="@xml:lang" mode="langues"/>
          </xsl:attribute>
          <xsl:value-of select="@xml:lang"/>
        </abbr>
        <xsl:text>), </xsl:text>
      </span>
      </span>
    </xsl:when>
    <xsl:when test="ancestor::tei:figure">
      <span>
        <xsl:attribute name="class">
          <xsl:value-of select="@type"/>
        </xsl:attribute>
        <xsl:value-of select="."/>
      </span>
    </xsl:when>
    <xsl:when test="parent::tei:titleStmt">
      <xsl:apply-templates/>
    </xsl:when>
    <xsl:otherwise>
    <xsl:apply-templates/>
    </xsl:otherwise>
  </xsl:choose>
    </xsl:template>

      <!-- gestion des langues -->
        <xsl:template match="@xml:lang" mode="langues">
            <xsl:choose>
              <xsl:when test=".='fre'">
                <xsl:text>français</xsl:text>
              </xsl:when>
              <xsl:when test=".='fro'">
                <xsl:text>ancien français</xsl:text>
              </xsl:when>
              <xsl:when test=".='ita'">
                <xsl:text>italien</xsl:text>
              </xsl:when>
              <xsl:when test=".='eng'">
                <xsl:text>anglais</xsl:text>
              </xsl:when>
              <xsl:when test=".='swe'">
                <xsl:text>suédois</xsl:text>
              </xsl:when>
              <xsl:when test=".='nor'">
                <xsl:text>norvégien</xsl:text>
              </xsl:when>
              <xsl:when test=".='dan'">
                <xsl:text>danois</xsl:text>
              </xsl:when>
              <xsl:when test=".='ice'">
                <xsl:text>islandais</xsl:text>
              </xsl:when>
              <xsl:when test=".='ger'">
                <xsl:text>allemand</xsl:text>
              </xsl:when>
              <xsl:when test=".='lat'">
                <xsl:text>latin</xsl:text>
              </xsl:when>
              <xsl:when test=".='fin'">
                <xsl:text>finnois</xsl:text>
              </xsl:when>
              <xsl:when test=".='non'">
                <xsl:text>vieux norrois</xsl:text>
              </xsl:when>
              <xsl:when test=".='lit'">
                <xsl:text>lituanien</xsl:text>
              </xsl:when>
              <xsl:when test=".='ara'">
                <xsl:text>arabe</xsl:text>
              </xsl:when>
              <xsl:when test=".='dut'">
                <xsl:text>néérlandais</xsl:text>
              </xsl:when>
              <xsl:when test=".='tur'">
                <xsl:text>turque</xsl:text>
              </xsl:when>
              <xsl:when test=".='rus'">
                <xsl:text>russe</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="tei:form/@xml:lang"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:template>


          <!-- GESTION DES DIV SECTIONS 1,2 et 3 -->

          <!-- div @subtype='section1' -->
    <xsl:template match="tei:div[@subtype='section1']">
      <div class="section1">
      <xsl:apply-templates/>
    </div>
    </xsl:template>

      <!-- div @subtype='section2'-->
    <xsl:template match="tei:div[@subtype='section2']">
      <xsl:choose>
        <xsl:when test="@type='zoonymes'"> <!-- affichage des langues pour les zoonymes -->
          <xsl:apply-templates select="tei:head"/>
          <xsl:for-each-group select="tei:entry" group-by="@type">
            <p>
              <xsl:text>Formes </xsl:text><xsl:value-of select="concat(current-grouping-key(), 's')"/>
            <ul>
            <xsl:for-each select="current-group()">
                <li><xsl:value-of select="lower-case(tei:form)"/> (<xsl:apply-templates select="tei:form/@xml:lang" mode="langues"/>)</li>
              </xsl:for-each>
            </ul>
            </p>
          </xsl:for-each-group>
        </xsl:when>
      <xsl:when test="not(@type='zoonymes')"> <!-- affichage des langues HORS zoonymes -->
      <div>
        <xsl:attribute name="class"><xsl:value-of select="concat(@subtype, ' ', @type)"/></xsl:attribute>
        <xsl:apply-templates/>
      </div>
    </xsl:when>
    </xsl:choose>
</xsl:template>

<!-- div @subtype='section3'-->
<xsl:template match="tei:div[@subtype='section3']">
  <div class="oeuvre">
    <xsl:apply-templates/>
  </div>
</xsl:template>

<!-- FIN GESTION DES DIV SECTIONS 1,2 et 3 -->

<!-- gestion des listBibl -->
<xsl:template match="tei:listBibl">
  <xsl:choose>
    <xsl:when test="@type='editions'">  <!-- EDITIONS -->
      <div>
        <xsl:attribute name="class">
          <xsl:choose>
            <xsl:when test="not(@subtype)"> <!-- création de la classe -->
              <xsl:value-of select="concat('oeuvre_', @type)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="concat('oeuvre_', @subtype)"/>
            </xsl:otherwise>
      </xsl:choose>
        </xsl:attribute>
        <h4>
            <xsl:choose>  <!-- gestion des titres des éditions -->
              <xsl:when test="not(@subtype)">
                <xsl:text>Édition</xsl:text>
              </xsl:when>
              <xsl:when test="@subtype='edition_critique'">
                <xsl:text>Édition critique</xsl:text>
              </xsl:when>
              <xsl:when test="@subtype='edition_ancienne'">
                <xsl:text>Édition ancienne</xsl:text>
              </xsl:when>
              <xsl:when test="@subtype='edition_seule'">
                <xsl:text>Édition seule</xsl:text>
              </xsl:when>
              <xsl:when test="@subtype='trad_seule'">
                <xsl:text>Traduction seule</xsl:text>
              </xsl:when>
              <xsl:when test="@subtype='edition_critique'">
                <xsl:text>Édition critique</xsl:text>
              </xsl:when>
              <xsl:when test="@subtype='edition_princeps'">
                <xsl:text>Édition princeps</xsl:text>
              </xsl:when>
              <xsl:when test="@subtype='fac-simile'">
                <xsl:text>Fac similé</xsl:text>
              </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates/>
            </xsl:otherwise>
          </xsl:choose>
            </h4>
          <ul><xsl:apply-templates/></ul> <!-- FIN EDITIONS -->
        </div>
      </xsl:when>
      <xsl:when test="@type='manuscrits'"> <!-- MANUSCRITS -->
        <div>
          <xsl:attribute name="class">
            <xsl:value-of select="concat('oeuvre_', @type)"/>
          </xsl:attribute>
            <xsl:if test="not(./tei:head)">
              <h4><xsl:value-of select="replace(@type, 'm', 'M')"/></h4>
            </xsl:if>
            <ul><xsl:apply-templates/></ul>
          </div>
        </xsl:when>                       <!-- FIN MANUSCRITS -->
    <xsl:when test="@type='ref_biblio'">   <!-- REF_BIBLIO -->
      <div>
        <xsl:attribute name="class">
          <xsl:value-of select="concat('ref_', @type)"/>
        </xsl:attribute>
          <xsl:apply-templates select="tei:head"/>
          <ul><xsl:apply-templates select="tei:bibl"/></ul>
        </div>
    </xsl:when>                           <!-- FIN REF_BIBLIO -->
    <xsl:when test="@type='etudes'">      <!-- ETUDES -->
      <div>
        <xsl:attribute name="class">
          <xsl:value-of select="concat('biblio_', @type)"/>
        </xsl:attribute>
          <xsl:apply-templates select="tei:head"/>
          <ul><xsl:apply-templates select="tei:bibl"/></ul>
        </div>
    </xsl:when>                             <!-- FIN ETUDES -->
    <xsl:when test="@type='oeuvre'">        <!-- OEUVRE -->
      <xsl:apply-templates/>
    </xsl:when>                             <!-- FIN OEUVRE -->
    <xsl:when test="@type='ref_zoologie'">  <!-- REF_ZOOLOGIE -->
      <div class="ref_zoologie">
      <xsl:apply-templates select="tei:head"/>
      <ul>
      <xsl:apply-templates select="tei:bibl"/>
    </ul>
  </div>
</xsl:when>                             <!-- FIN REF_ZOOLOGIE -->
  <xsl:when test="@type='ref_images'">  <!-- REF_IMAGES -->
    <div class="ref_images">
    <xsl:apply-templates select="tei:head"/>
    <ul>
    <xsl:apply-templates select="tei:bibl"/>
  </ul>
  </div>
</xsl:when>                           <!-- FIN REF_IMAGES -->
    <xsl:when test="@type='bibl_zoologie'">  <!-- BIBL_ZOOLOGIE -->
        <div>
          <xsl:attribute name="class">
            <xsl:value-of select="concat('oeuvre_', @type)"/>
          </xsl:attribute>
            <xsl:apply-templates select="tei:head"/>
            <ul><xsl:apply-templates select="tei:bibl"/></ul>
          </div>
    </xsl:when>                             <!-- FIN BIBL_ZOOLOGIE -->
    <xsl:otherwise>
      <xsl:apply-templates/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

  <!-- gestion des bibl -->
  <xsl:template match="tei:bibl">
    <xsl:choose>
      <xsl:when test="parent::tei:listBibl/@type='oeuvre'"> <!-- gestion des bibl danes les oeuvres -->
        <div class="bandeau_oeuvre">
          <xsl:apply-templates select="./tei:author"/>
          <xsl:apply-templates select="./tei:title"/>
          <xsl:apply-templates select="./tei:date"/>
          <xsl:apply-templates select="./tei:biblScope"/>
        </div>
        <div class="index">
          <xsl:apply-templates select="./tei:index"/>
        </div>
      </xsl:when>
      <xsl:when test="parent::tei:listBibl[not(@type='oeuvre')]">
        <li>
          <xsl:apply-templates/>
        </li>
      </xsl:when>
      <xsl:when test="ancestor::tei:div[@type='iconographie']">
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise/>
    </xsl:choose>
  </xsl:template>

<!-- GESTION DES IMAGES -->

<!-- gestion des figures -->
  <xsl:template match="tei:figure">
    <xsl:choose>
      <xsl:when test="parent::tei:div[@type='presentation']"> <!-- images de présentation de fiche -->
    <div class="figure_pres">
    <xsl:apply-templates/>
  </div>
</xsl:when>
<xsl:when test="parent::tei:div[@type='images']"> <!--images de la partie iconographie : arrangement particulier pour coller à la demande du chercheur -->
   <div class="image">
   <section class="pres"> <!-- première div -->
     <div>
        <xsl:apply-templates select="./tei:head"/>
        <xsl:text>, </xsl:text>
        <xsl:apply-templates select="./tei:bibl/tei:title"/>
        <xsl:text>, </xsl:text>
        <xsl:apply-templates select="./tei:bibl/tei:date"/>
      </div>
      <div>
        <xsl:apply-templates select="./tei:bibl/tei:ref"/>
        <xsl:text> : </xsl:text>
        <div>
          <xsl:choose>
            <xsl:when test=".//tei:author[@role='artiste']">
            <xsl:text>Artiste : </xsl:text>
              <xsl:apply-templates select=".//tei:author"/>
            </xsl:when>
            <xsl:when test=".//tei:author[not(@role='artiste')]">
              <xsl:text>Auteur : </xsl:text>
                <xsl:apply-templates select=".//tei:author"/>
            </xsl:when>
            <xsl:otherwise/>
          </xsl:choose>
        </div>
      </div>
    </section>
  <section class="desc"> <!-- deuxième div -->
    <xsl:apply-templates select="./tei:graphic"/>
    <div class="type">
      <xsl:choose>
        <xsl:when test="@type='decor_livre_imprime'">
          <xsl:text>Décor de livre imprimé</xsl:text>
        </xsl:when>
        <xsl:when test="@type='carte'">
          <xsl:text>Carte</xsl:text>
        </xsl:when>
        <xsl:when test="@type='decor_ms'">
          <xsl:text>Décor de manuscrit</xsl:text>
        </xsl:when>
        <xsl:when test="@type='dessin_inde'">
          <xsl:text>Dessin</xsl:text>
        </xsl:when>
        <xsl:when test="@type='gravure_inde'">
          <xsl:text>Gravure</xsl:text>
        </xsl:when>
        <xsl:when test="@type='objet'">
          <xsl:text>Objet</xsl:text>
        </xsl:when>
        <xsl:when test="@type='peinture'">
          <xsl:text>Peinture</xsl:text>
        </xsl:when>
        <xsl:when test="@type='sculpture'">
          <xsl:text>Sculpture</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text> ; </xsl:text>
      <xsl:choose>
        <xsl:when test="@subtype='gravure'">
          <xsl:text>gravure</xsl:text>
        </xsl:when>
        <xsl:when test="@subtype='dessin'">
          <xsl:text>dessin</xsl:text>
        </xsl:when>
        <xsl:when test="@subtype='lettre_ornee'">
          <xsl:text>lettre ornée</xsl:text>
        </xsl:when>
        <xsl:when test="@subtype='miniature'">
          <xsl:text>miniature</xsl:text>
        </xsl:when>
      <xsl:otherwise/>
    </xsl:choose>
  </div>
  <xsl:apply-templates select="./tei:figDesc"/>
  <xsl:for-each select="./tei:ab">    <!-- pour gérer le cas où deux légendes sont inscrites -->
      <div><xsl:value-of select="concat(upper-case(substring(./@type, 0, 2)) || substring(./@type, 2), ' : ', .)"/></div>
    </xsl:for-each>
  <xsl:apply-templates select="./tei:bibl/tei:note"/>
</section>
</div>
</xsl:when>
</xsl:choose>
  </xsl:template>

  <!-- gestion des graphic -->
  <xsl:template match="tei:graphic">
    <div class="graphic">
    <xsl:choose>
      <xsl:when test="ancestor::tei:div[@type='presentation']">
    <div>
      <a>
      <xsl:attribute name="href">
        <xsl:value-of select="@url"/>
      </xsl:attribute>
    <img>
        <xsl:attribute name="src">
          <xsl:value-of select="@url"/>
        </xsl:attribute>
        <xsl:attribute name="width">
          <xsl:text>300px</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="height">
          <xsl:text>auto</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="href">
          <xsl:value-of select="@url"/>
        </xsl:attribute>
    </img>
  </a>
  </div>
  </xsl:when>
  <xsl:when test="ancestor::tei:div[not(@type='presentation')]">
    <xsl:if test="@source='iiif'">
    <xsl:variable name="iiifLink">
      <xsl:value-of select="$baseuri"/>
      <xsl:value-of select="$project"/>
      <xsl:text>/mirador/?link=</xsl:text>
      <xsl:value-of select="substring-before(@url, '#')"/>
      <xsl:text>&amp;canvasId=&amp;canvasIndex=</xsl:text>
      <xsl:value-of select="substring-after(@url, '#')"/>
    </xsl:variable>
    <span onclick="window.open('{$iiifLink}','Mirador Viewer','width=800,height=600,location=no')">
      <xsl:attribute name="class">pb mirador-link</xsl:attribute>
      <xsl:text>lien IIIF</xsl:text>
    </span>
  </xsl:if>
  <xsl:if test="@url">
    <a class="source_url">
      <xsl:attribute name="href">
        <xsl:value-of select="@corresp"/>
      </xsl:attribute>
      <xsl:text>source en ligne</xsl:text>
    </a>
  </xsl:if>
  </xsl:when>
  <xsl:otherwise>
    <xsl:apply-templates/>
  </xsl:otherwise>
  </xsl:choose>
  </div>
  </xsl:template>



  <!-- gestion des figDesc -->
  <xsl:template match="tei:figDesc">
    <div class="fig_desc">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <!-- gestion des ab -->
  <xsl:template match="tei:ab">
    <!-- <div>
      <xsl:attribute name="class">
        <xsl:value-of select="@type"/>
      </xsl:attribute>
      <xsl:text>Légende: </xsl:text><xsl:apply-templates/>
    </div> -->
    <xsl:apply-templates/>
  </xsl:template>

        <!-- gestion des <head> -->
        <xsl:template match="tei:head">
        <xsl:choose>
          <xsl:when test="parent::tei:figure">
            <span class="titre_fig">
              <xsl:apply-templates/>
            </span>
          </xsl:when>
          <xsl:when test="parent::tei:div/@subtype='section1'">
            <h2><xsl:apply-templates/></h2>
          </xsl:when>
          <xsl:when test="parent::tei:div[@subtype='section2']">
            <xsl:choose>
              <xsl:when test="ancestor::tei:div[@type='sources']">
                <h3 class="collapsible"><xsl:apply-templates/></h3>
              </xsl:when>
              <xsl:otherwise>
                <h3><xsl:apply-templates/></h3>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
        <xsl:when test="parent::tei:listBibl">
          <div>
            <xsl:attribute name="class">
              <xsl:value-of select="concat('titre_', ancestor::tei:div[@subtype='section1']/@type)"/>
            </xsl:attribute>
            <h4><xsl:apply-templates/></h4>
          </div>
        </xsl:when>
        <xsl:otherwise/>
        </xsl:choose>
        </xsl:template>

        <!-- gestion des @subtype des listBibl -->
        <xsl:template match="//@subtype" mode="titre">
          <xsl:choose>
            <xsl:when test=".='histoire_nat'">
              <xsl:text>Histoire naturelle</xsl:text>
            </xsl:when>
            <xsl:when test=".='chronique'">
              <xsl:text>Chronique</xsl:text>
            </xsl:when>
            <xsl:when test=".='encyclopedie'">
              <xsl:text>Encyclopédie</xsl:text>
            </xsl:when>
            <xsl:when test=".='litterature'">
              <xsl:text>Texte littéraire</xsl:text>
            </xsl:when>
            <xsl:when test=".='medecine'">
              <xsl:text>Médecine, pharmacopée</xsl:text>
            </xsl:when>
            <xsl:when test=".='hagiographie'">
              <xsl:text>Hagiographie</xsl:text>
            </xsl:when>
            <xsl:when test=".='geographie'">
              <xsl:text>Géographie</xsl:text>
            </xsl:when>
            <xsl:when test=".='memoires'">
              <xsl:text>Mémoires, récits biographiques</xsl:text>
            </xsl:when>
            <xsl:when test=".='miroir'">
              <xsl:text>Miroir des princes</xsl:text>
            </xsl:when>
            <xsl:when test=".='saga'">
              <xsl:text>Saga</xsl:text>
            </xsl:when>
            <xsl:when test=".='voyage'">
              <xsl:text>Récits de voyage et pèlerinages</xsl:text>
            </xsl:when>
            <xsl:otherwise/>
          </xsl:choose>
          <xsl:text>, </xsl:text>
        </xsl:template>

        <!-- gestion des biblScope -->
        <xsl:template match="tei:biblScope">
          <span class="passage">
            <xsl:apply-templates/>
          </span>

        </xsl:template>

        <!-- gestion des enrichissements typographiques-->
        <xsl:template match="tei:hi" >
          <xsl:choose>
            <xsl:when test="@rend='sup'">
              <em><sup>
                <xsl:apply-templates select="concat(., ' ')"/>
              </sup></em>
            </xsl:when>
            <xsl:when test="@rend='small-caps'">
            <em>
              <smcaps>
              <xsl:apply-templates select="concat(' ',., ' ')"/>
            </smcaps>
            </em>
          </xsl:when>
          <xsl:when test="@rend='italic'">
            <em>
              <!-- <xsl:apply-templates select="concat(' ',.,' ')"/> -->
              <xsl:apply-templates/>
            </em>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates/>
          </xsl:otherwise>
        </xsl:choose>
        </xsl:template>

        <!-- gestion des dates -->
        <xsl:template match="tei:date" name="date">
          <span class="date">
          <xsl:apply-templates/>
          </span>
        </xsl:template>



<!-- gestion des ptr -->
<xsl:template match="tei:ptr">
  <xsl:text> : </xsl:text>
  <xsl:choose>
    <xsl:when test="@source='url'">
      <a class="source_url">
        <xsl:attribute name="href">
          <xsl:value-of select="@target"/>
        </xsl:attribute>
        <xsl:text>source en ligne</xsl:text>
      </a>
    </xsl:when>
    <xsl:when test="@source='iiif'">
  <xsl:variable name="iiifLink">
    <xsl:value-of select="$baseuri"/>
    <xsl:value-of select="$project"/>
    <xsl:text>/mirador/?link=</xsl:text>
    <xsl:value-of select="@target"/>
  </xsl:variable>
  <span onclick="window.open('{$iiifLink}','Mirador Viewer','width=800,height=600,location=no')">
    <xsl:attribute name="class">pb mirador-link</xsl:attribute>
    <xsl:text>lien IIIF</xsl:text>
  </span>
</xsl:when>
<xsl:otherwise>
  <xsl:apply-templates/>
</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- gestion des licences -->
<xsl:template match="tei:availability">
  <xsl:apply-templates/>
</xsl:template>

<!-- gestion des licence -->
<xsl:template match="tei:licence">
  <span class="licence">
  <xsl:text>(</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>)</xsl:text>
</span>
</xsl:template>

  <!-- gestion des auteurs -->
    <xsl:template match="tei:author">
        <xsl:choose>
          <xsl:when test="ancestor::tei:teiHeader">
            <span class="meta_auteur">
              <xsl:attribute name="id">
                <xsl:value-of select="@xml:id"/>
              </xsl:attribute>
            <xsl:apply-templates/>
          </span>
          </xsl:when>
          <xsl:when test="ancestor::div[@type='iconographie']">
            <div class="auteur_icono">
              <xsl:apply-templates/>
            </div>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates/>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:choose>
          <xsl:when test="ancestor::tei:div[@type='sources']"> <!-- seulement pour les auteurs des oeuvres -->
      <xsl:text>, </xsl:text>
    </xsl:when>
    <xsl:otherwise/> <!-- les auteurs partie iconographie n'ont pas la virgule -->
  </xsl:choose>
    </xsl:template>

    <xsl:template match="tei:forename">
      <span class="forename">
        <xsl:apply-templates/>
      </span>
    </xsl:template>

    <xsl:template match="tei:surname">
      <span class="surname">
        <xsl:apply-templates/>
      </span>
    </xsl:template>

    <!-- <xsl:template match="tei:name">
      <xsl:apply-templates/>
    </xsl:template> -->

    <xsl:template match="tei:name">
      <xsl:choose>
        <xsl:when test="@type='personne'"> <!-- permet d'ajouter une ancre au plugin thesauris -->
      <a class='personne'>
        <xsl:attribute name="id">
          <xsl:value-of select="substring-before(substring-after(@ref, 'pddn_p.'), '.xml')"/>
        </xsl:attribute>
      <xsl:attribute name="onclick">
        <xsl:text>MAX.plugins['thesauri'].showInWindow('personnes','</xsl:text>
              <xsl:value-of select="substring-after(@ref, '#')"/> <!-- renvoie l'identifiant de la fiche thesauris -->
        <xsl:text>')</xsl:text>
      </xsl:attribute>
      <xsl:choose>
      <xsl:when test="./tei:persName/tei:forename">
        <xsl:value-of select="concat(./tei:persName/tei:forename, ' ', ./tei:persName/tei:surname)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="."/>
    </xsl:otherwise>
      </xsl:choose>
      </a>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates/>
    </xsl:otherwise>
  </xsl:choose>
    </xsl:template>

    <xsl:template match="tei:persName">
    <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="tei:affiliation">
      <span class="hide">
      <xsl:apply-templates/>
    </span>
    </xsl:template>

    <!-- gestion des ref et pop-up Zotero -->
      <xsl:template match="tei:ref">
        <xsl:choose>
          <xsl:when test="ancestor::tei:listBibl[@type='ref_zoologie']">
            <a>
              <xsl:if test="@target">
              <xsl:attribute name="href">
              <xsl:value-of select="@target"/>
            </xsl:attribute>
          </xsl:if>
            <xsl:apply-templates/>
          </a>
          </xsl:when>
          <xsl:when test="not(@type='bibref')">
              <a>
                <xsl:if test="@target">
              <xsl:attribute name="href">
                  <xsl:value-of select="."/>
              </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
          </a>
            </xsl:when>
          <xsl:when test="@type='bibref'">
    <xsl:variable name="attributZotero">
    <xsl:text>https://www.zotero.org/groups/</xsl:text>
    <xsl:value-of select="substring-after(@target, 'groups/')"/>
    </xsl:variable>
    <a class="bibref" href="{$attributZotero}" onclick="return(openPopup(this.href, 50, 50, 500, 500));">
      <xsl:if test="ancestor::tei:figure">
        <xsl:apply-templates select="concat(' ',.)"/>
      </xsl:if>
        <xsl:value-of select="."/>
    </a>
    <xsl:if test="not(',')">
    <xsl:text>, </xsl:text>
  </xsl:if>
        </xsl:when>
        </xsl:choose>
    </xsl:template>


    <!-- mise en forme des <note>-->
    <xsl:template match="tei:note">
      <span class="note">
        <xsl:apply-templates/>
      </span>
    </xsl:template>


    <!-- gestion des entry-->
    <xsl:template match="tei:entry">
      <div>
        <xsl:attribute name="class">
          <xsl:value-of select="@type"/>
        </xsl:attribute>
        <xsl:apply-templates/>
      </div>
    </xsl:template>

<xsl:template match='tei:form'>
  <div>
    <xsl:apply-templates/>
    <xsl:apply-templates select="tei:etym"/>
  </div>
</xsl:template>

    <!-- gestion des etym -->
<xsl:template match="tei:etym">
<b><xsl:text>etym : </xsl:text></b>
<xsl:apply-templates/>
</xsl:template>

<!-- gestion des <index> -->
  <!-- <xsl:template match="tei:index">
    <div>
      <xsl:attribute name="class">
        <xsl:value-of select="concat('index_', @indexName)"/>
      </xsl:attribute>
    <xsl:for-each-group select="." group-by=".">
      <xsl:for-each select="current-group()">
        <xsl:apply-templates/>
        </xsl:for-each>
      </xsl:for-each-group>
    </div>
</xsl:template> -->

<xsl:template match="tei:index">
    <xsl:apply-templates/>
</xsl:template>


<xsl:template match="tei:term">
  <xsl:variable name="id"> <!-- initialisation de la variable id pour permettre l'ancre avec les fiches -->
    <xsl:choose>
      <xsl:when test="./@type='theme'">
        <xsl:value-of select="substring-after(./@ref, 'pcrt')"/>
      </xsl:when>
      <xsl:when test="./@type='lieu'">
        <xsl:value-of select="substring-before(substring-after(./tei:name/@ref, 'pddn_l.'), '.xml')"/>
      </xsl:when>
      <xsl:otherwise/>
    </xsl:choose>
  </xsl:variable>  <!-- fin de l'initialisation de la variable id -->
  <span class="index_term">
    <xsl:choose>
      <xsl:when test="@type='theme'"> <!-- gestion des index de type @theme -->
        <a class='theme'>
          <xsl:attribute name="id">
            <xsl:value-of select="$id"/>
          </xsl:attribute>
          <xsl:if test="./@ref">
          <xsl:attribute name="href">
            <xsl:value-of select="concat('http://localhost:16002/dyrin/index/themes.html#', $id)"/>
          </xsl:attribute>
        </xsl:if>
          <xsl:value-of select="."/>
        </a>
      </xsl:when>
      <xsl:when test="@type='animal'"> <!-- gestion des index de type @animal -->
        <a class='animal'>
          <xsl:attribute name="href">
            <xsl:value-of select="@ref"/>
          </xsl:attribute>
          <xsl:value-of select="."/>
        </a>
      </xsl:when>
      <xsl:when test="@type='lieu'"> <!-- gestion des index de type @lieu -->
        <a class='lieu'>
          <xsl:attribute name="id">
            <xsl:value-of select="$id"/>
          </xsl:attribute>
        <xsl:attribute name="href">
          <xsl:value-of select="concat('http://localhost:16002/dyrin/index/lieux.html#', $id)"/>
        </xsl:attribute>
        <xsl:value-of select="."/>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
</span>
</xsl:template>

<!-- gestion des paragraphes -->
<xsl:template match="tei:p">
  <div class="paragraphe">
    <xsl:apply-templates/>
  </div>
</xsl:template>


</xsl:stylesheet>
