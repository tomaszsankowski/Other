<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="xml" />
    

<xsl:template match="/">
	<xsl:element name="engines">
		<xsl:apply-templates select="//samochod"/>
	</xsl:element>
</xsl:template>

<xsl:template match="samochod">
    <xsl:element name="engine">
        <xsl:element name="example">
            <xsl:value-of select="nazwa"/>
        </xsl:element>
        <xsl:element name="characterictic">
            <xsl:apply-templates select="parametry/silnik"/>
        </xsl:element>
	</xsl:element>
</xsl:template>

<xsl:template match="parametry/silnik">
    <xsl:element name="type">
        <xsl:attribute name="{pojemnosc/@paliwo}">
            <xsl:value-of select="pojemnosc" />
        </xsl:attribute>    
        <xsl:value-of select="typ" />
    </xsl:element>
    <xsl:element name="{naped}">
        <xsl:attribute name="to100">
            <xsl:value-of select="../predkosc/dosetki" />
        </xsl:attribute>
        <xsl:attribute name="Vmax">
            <xsl:value-of select="../predkosc/predkoscmax" />
        </xsl:attribute>   
        <xsl:value-of select="@skrzynia" />
    </xsl:element>
</xsl:template>
    
</xsl:stylesheet>

