<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:fo="http://www.w3.org/1999/XSL/Format">
    <xsl:output method="html" encoding="UTF-8" indent="yes"	omit-xml-declaration="yes"/>
    <xsl:key name="pers_name" match="tei:person" use="@xml:id"/>
    <xsl:key name="name" match="tei:name" use="@xml:id"/>

	<xsl:template match="/">
		<html>
			<head>
				<title>Codifica manoscritto</title>
				<link rel="stylesheet" type="text/css" href="css/css.css" />
				<link rel="stylesheet" type="text/css" href="css/flickity.css" />
                <script src="js/jquery.js"/>
                <script src="js/flickity.js"/>
                <script src="js/js.js"/>
			</head>
			<body>
				<header>
                    <div>
                        <p>Progetto d'esame: <xsl:value-of select="tei:teiCorpus/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[@type='main']"/></p>
                        <p>I manoscritti sono stati codificati a <xsl:value-of select="tei:teiCorpus/tei:teiHeader/tei:fileDesc/tei:editionStmt/tei:edition/tei:date"/> da
                        <strong><xsl:value-of select="tei:teiCorpus/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:respStmt/tei:name[@xml:id='LG']"/></strong>
                        </p>
                    </div>
				</header>   
                <main class="container-flickity">
                    <xsl:for-each select="tei:teiCorpus/tei:TEI">
                    
                        <section class="container-manoscritto carousel-cell">
                            <!--immagine manoscritto-->
                            <div class="container-manoscritto__img">
                                <xsl:apply-templates select="tei:facsimile/tei:surfaceGrp"/>
                            </div>
                            
                            <!--testo manoscritto-->
                            <div class="container-manoscritto__testo">
                                <xsl:apply-templates select="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:bibl"/>
                                 
                                <div class="container-manoscritto__testo__fronte">
                                    <h3>Trascrizione Manoscritto</h3>
                                    <xsl:apply-templates select="tei:text/tei:body/tei:div[@type='trascrizione']"/>								
                                </div>

                                <div class="container-manoscritto__testo__retro hide">
                                    <h3>Traduzione Manoscritto</h3>
                                    <xsl:apply-templates select="tei:text/tei:body/tei:div[@type='retro']/tei:div[@type='contenuto_trascrizione']"/>
                                </div>

                                <div class="container-manoscritto__testo__dati-tecnici hide">
                                    <xsl:apply-templates select="tei:teiHeader/tei:fileDesc/tei:titleStmt"/>
                                    <xsl:apply-templates select="tei:teiHeader/tei:fileDesc/tei:publicationStmt"/>
                                    <xsl:apply-templates select="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc"/>
                                    <xsl:apply-templates select="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:physDesc"/>
                                    <xsl:apply-templates select="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:listPerson"/>
                                </div>

                            </div>

                            <div class="cruscotto">
                                <input type="button" value="Trascrizione" class="bottone-front"/>
                                <input type="button" value="Traduzione" class="bottone-back"/>
                                <input type="button" value="Dati tecnici" class="data"/>
                            </div>
                        </section>
                    </xsl:for-each>
                </main>             
            </body>
        </html>
    </xsl:template>


    <!--__________________________________
    INIZIO TEMPLATES
    ___________________________________-->

    <!-- Template TITOLI manoscritti -->
    <xsl:template match='tei:teiCorpus/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:bibl'>
        <xsl:for-each select="tei:title">
            <h1>
                <xsl:value-of select="."/>
            </h1>
        </xsl:for-each>
    </xsl:template>
	
    <!-- Template per immagini -->
    <xsl:template match='tei:teiCorpus/tei:TEI/tei:facsimile/tei:surfaceGrp'>
        <xsl:apply-templates select="tei:surface[1]"/>
        <xsl:apply-templates select="tei:surface[2]"/>
    </xsl:template>

    <!--Trascrizione corpo Manoscritto e descrizione immagini-->
    <xsl:template match="tei:teiCorpus/tei:TEI/tei:text/tei:body/tei:div[@type='trascrizione']/tei:p/tei:lb">
        	
      <div>       
          <xsl:for-each select="tei:p">
              <xsl:value-of select="."/>
          </xsl:for-each>  
      </div>  
    </xsl:template>	
    
   <!-- Template elemento DEL -->
    <xsl:template match="//tei:del">
        <strike><xsl:value-of select="."/></strike>
    </xsl:template>
	
    <!-- Traduzione corpo manoscritto -->
    <xsl:template match="tei:teiCorpus/tei:TEI/tei:text/tei:body/tei:div[@type='retro']/tei:div[@type='contenuto_trascrizione']/tei:p/tei:lb">

        <div>
            <xsl:for-each select="tei:p">
                <xsl:value-of select="."/>
            </xsl:for-each>              
        </div>     
    </xsl:template>

    <!-- Trascrizione delle informazioni di title statement di ogni manoscritto (nome dei compilatori ed ente di appartenenza) -->
    <xsl:template match="tei:teiCorpus/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt">
        <div>
            <xsl:for-each select="tei:respStmt">
                <strong><xsl:value-of select="tei:resp"/></strong>
                <xsl:for-each select="tei:name/@ref">
                    <xsl:for-each select="key('name', .)">
                        <p><xsl:value-of select="."/></p>
                    </xsl:for-each>
                </xsl:for-each>
            </xsl:for-each>
        </div>
    </xsl:template>

    <!--Trascrizione dei dati tecnici di ogni manoscritto, contenuti in publication statement -->
    <xsl:template match="tei:teiCorpus/tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt">
        <div>
            <p>
                <strong>Luogo:</strong>
                <xsl:value-of select="concat(' ', tei:publisher)"/>
                <xsl:value-of select="concat(' ', tei:pubPlace)"/> 
            </p>
            <p>
                <strong>Distributore:</strong>
                <xsl:value-of select="concat(' ', tei:distributor)"/>
                <xsl:value-of select="concat(' ', tei:address/tei:addrLine, ' ')"/> 
                <strong>Sede di:</strong> <xsl:value-of select="concat(' ', tei:address/tei:placeName)"/>
            </p>
            <p><i><xsl:value-of select="tei:availability"/></i></p>
        </div>
    </xsl:template>
    
    <!-- Identificazione di ogni manoscritto -->
    <xsl:template match="tei:teiCorpus/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc">
        <div>
            <xsl:apply-templates select="tei:msIdentifier"/>
            <xsl:apply-templates select="tei:msContents"/>
        </div>
    </xsl:template>
    
    <!-- Descrizione fisica dell'oggetto e note -->
    <xsl:template match="tei:teiCorpus/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:physDesc">
        <div>
            <xsl:apply-templates select="tei:objectDesc/tei:supportDesc"/>
            <xsl:apply-templates select="tei:handDesc"/>
           
        </div>
    </xsl:template>
   <!-- Persone -->
    <xsl:template match="tei:teiCorpus/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:listPerson">
        <div>
            <h3>Autore</h3>
            <xsl:for-each select="tei:person">
                <p><xsl:value-of select="concat(tei:persName, ' ')"/>
                <!-- Scelta in caso il sesso non sia specificato -->    
                    <xsl:choose>
                        <xsl:when test="tei:sex != ''">
                            <xsl:value-of select="concat('(',tei:sex, ')')"/>
                        </xsl:when>
                        <xsl:otherwise>
                            (?)
                        </xsl:otherwise>
                    </xsl:choose>
                </p>
            </xsl:for-each>
        </div>
    </xsl:template>


    <!-- Template secondari-->

    <!-- Template che prende l'immagine per la trascrizione dei manoscritti-->
    <xsl:template match='//tei:surface[1]'>
        <div class="trascrizione">
            <xsl:element name="img">
                <xsl:attribute name="src">
                    <xsl:value-of select="tei:graphic/@url"/>
                </xsl:attribute>
            </xsl:element>
        </div>
    </xsl:template>

    <!-- Template che prende l'immagine per la traduzione dei manoscritti-->
    <xsl:template match='//tei:surface[2]'>
        <div class="retro hide">
            <xsl:element name="img">
                <xsl:attribute name="src">
                    <xsl:value-of select="tei:graphic/@url"/>
                </xsl:attribute>
            </xsl:element>
        </div>
    </xsl:template>
    
    <!-- Persone e indirizzi -->
    <xsl:template match="//tei:address">
        <p><xsl:apply-templates select="tei:persName"/></p>
        <p><xsl:apply-templates select="tei:addrLine"/></p>
    </xsl:template>
    
    <!-- Identificazione manoscritto -->
    <xsl:template match="//tei:msIdentifier">
        <div>
            <h3>Descrizione del manoscritto</h3>
            <p><strong>Paese:</strong><xsl:value-of select="concat(' ', tei:country)"/></p>
            <p><strong>Città:</strong><xsl:value-of select="concat(' ', tei:settlement)"/></p>
            <p><strong>Conservato in:</strong><xsl:value-of select="concat(' ', tei:repository, ' ')"/><strong> Codice identificativo:</strong><xsl:value-of select="concat(' ', tei:idno)"/></p>
        </div>
    </xsl:template>
    
    <!-- Tipologia e lingua -->
    <xsl:template match="//tei:msContents">
        <div>
            <p><strong>Tipo di documento:</strong><xsl:value-of select="concat(' ', tei:summary)"/></p>
            <p><strong>Lingua/e:</strong><xsl:value-of select="concat(' ', tei:textLang)"/></p>
        </div>
    </xsl:template>
    
    <!-- Tipo di oggetto a livello fisico -->
    <xsl:template match="//tei:objectDesc/tei:supportDesc">
        <div>
            <h3>Descrizione oggetto</h3>
            <p><strong>Tipo di oggetto:</strong><xsl:value-of select="concat(' ', tei:support/tei:objectType)"/></p>
            <p><strong>Materiale:</strong><xsl:value-of select="concat(' ', tei:support/tei:material)"/></p>
            <!--<xsl:apply-templates select="tei:support/tei:dimensions" />-->
            <p><strong>Condizione:</strong><xsl:value-of select="concat(' ', tei:condition)"/></p>
        </div>
    </xsl:template>
    
    <!--<xsl:template match="//tei:support/tei:dimensions">
        <p>
            <strong>Dimensioni:</strong><xsl:value-of select="concat(' ', tei:width, @unit)"/>
            x
            <xsl:value-of select="concat(' ', tei:height, @unit)"/>
            </p>
    </xsl:template>-->

<!-- Note sui manoscritti -->
    <xsl:template match="//tei:handDesc">
        <div>
            <h3>Note riguardo i contenuti scritti</h3>
            <xsl:for-each select="tei:handNote">
                <p><xsl:value-of select="."/></p>
            </xsl:for-each>
        </div>
    </xsl:template>

</xsl:stylesheet>