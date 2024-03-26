<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
>
    <xsl:variable name="table">
        <tr>
            <th>Nr</th>
            <th>Nazwa samochodu</th>
            <th>Prędkość maksymalna</th>
            <th>Cena</th>
        </tr>
    </xsl:variable>
    
    <xsl:variable name="autor" select="'Tomasz Sankowski'" />  
    <xsl:variable name="lowercase" select="'abcdefghijklmnopqrstuvwxyz'" />
    <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />
    
    <xsl:output method="html" indent="yes"/>

	<xsl:template match="/">
        
        <html lang="pl">
        <head>
        <title>Moje Hobby</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <link rel="stylesheet" href="style.css"/>
        </head>
        <body>
            <header>
                    <h1 class="sizer"><strong><i>CAR SPOTTING</i></strong></h1>
            </header>
            <div class="content">
                <h2 class="paragraph">Nasze ulubione znaleziska:</h2>
                <h3>Przygotowaliśmy dla Was nasze <xsl:number value="count(samochody/samochod)" format="1"/> ulubione samochody!</h3>
                
                <xsl:apply-templates select="samochody/samochod"/>
                <br/>
                <hr/>
                <xsl:call-template name="summary"/>
                <hr/>
                <br/><br/>
                <h3 class="paragraph">Najszybsze nasze samochody:</h3>
                <xsl:call-template name="fastest"/>
            </div>
            <footer>
                <h3><i>by <xsl:copy-of select="$autor" /></i></h3>
            </footer>
        </body>
        </html>

	</xsl:template>
    
    
    <xsl:template match="samochod">
        <section>
            <h4 class="paragraph"><xsl:value-of select="translate(nazwa, $lowercase, $uppercase)" /></h4>
            <xsl:apply-templates select="cena"/>
            <xsl:apply-templates select="parametry"/>
            
            <br/>
            <xsl:apply-templates select="media/zdjecie"/>
            <xsl:apply-templates select="media/strona"/>
        </section>
        
	</xsl:template>
    
    <xsl:template name="fastest">
        <table class="fastest">
        <xsl:copy-of select="$table" />
        <xsl:for-each select="samochody/samochod">
            <xsl:sort order="descending" select="parametry/predkosc/predkoscmax"/>
                <tr>
                    <td><xsl:number value="position()" format="1."/></td>
                    <td><xsl:value-of select="nazwa"/></td>
                    <td>
                        <xsl:value-of select="parametry/predkosc/predkoscmax"/>
                        <xsl:text> km/h</xsl:text>
                    </td>
                    <td>
                        <xsl:value-of select='format-number(cena, "###,###,### $")'/>
                    </td>
                </tr>
        </xsl:for-each>
        </table>
    </xsl:template>
    
    <xsl:template name="summary">
        <h3 class="paragraph">Podsumowanie</h3>
        <strong>
        Pierwsze nasze znalezisko to
        <xsl:value-of select="samochody/samochod[1]/nazwa"/>
        który warty jest aż
        <xsl:value-of select="samochody/samochod[1]/cena"/>
        $, natomiast ostatni to
        <xsl:value-of select="samochody/samochod[last()]/nazwa"/>
        .
        </strong>
        <br/>
        <br/>
        <strong>
        Więcej niż 250km/h osiągnie tylko:
        <ul>
            <xsl:apply-templates select="samochody/samochod/parametry/predkosc[predkoscmax>=250]"/> 
        </ul>
        </strong>
        
    </xsl:template>
    
    <xsl:template match="samochody/samochod/parametry/predkosc[predkoscmax>=250]">
        <li><xsl:value-of select="../../nazwa"/></li>
    </xsl:template>
    
    <xsl:template match="media/strona">
        <li><a href="{@link}"><xsl:value-of select="."/></a></li>
    </xsl:template>
    
    <xsl:template match="media/zdjecie">
        <div class="right">
        <img src="{@link}" alt="image"/>
        </div>
    </xsl:template>
    
    <xsl:template match="parametry">
        <h5>Opis:</h5>
        <p>
            <xsl:value-of select="../nazwa"/>
            <xsl:apply-templates select="silnik"/>
            <xsl:apply-templates select="predkosc/dosetki"/>
        </p>
    </xsl:template>
    
    <xsl:template match="@skrzynia">
        <xsl:choose>
            <xsl:when test=". = 'automatyczna'">
                <xsl:text>. Posiada automatyczną skrzynię biegów </xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>. Posiada manualną skrzynię biegów </xsl:text>
            </xsl:otherwise>
        </xsl:choose> 
    </xsl:template>
    
    <xsl:template match="naped">
        <xsl:choose>
            <xsl:when test=". = 'AWD'">
                <xsl:text>oraz napęd na cztery koła.</xsl:text>
            </xsl:when>
            <xsl:when test=". = 'RWD'">
                <xsl:text>oraz napęd na tylnie koła.</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>oraz napęd na przednie koła.</xsl:text>
            </xsl:otherwise>
        </xsl:choose> 
    </xsl:template>
    
    <xsl:template match="cena">
        <xsl:if test=".>1000000">
            <h5>
                <p>
                <xsl:value-of select="../nazwa"/>
                to jeden z najdroższych samochodów na świecie!
                </p>
            </h5>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="silnik">
        <xsl:text> posiada silnik </xsl:text>
        <xsl:value-of select="typ"/>
        <xsl:text> o pojemności </xsl:text>
        <xsl:value-of select='format-number(pojemnosc, "#0.0 L")'/>
        <xsl:text> który daje mu moc </xsl:text>
        <xsl:value-of select="moc"/>
        <xsl:apply-templates select="@skrzynia"/>
        <xsl:apply-templates select="naped"/>
    </xsl:template>
    
    <xsl:template match="predkosc/dosetki">
        <xsl:text> Do 100km/h rozpędza się w niecałe </xsl:text>
        <xsl:value-of select='ceiling(.)'/>
        <xsl:text>s !</xsl:text>
    </xsl:template>
    
</xsl:stylesheet>
