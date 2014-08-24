<!-- Timothy Lebo -->
<xsl:transform version="2.0" 
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   exclude-result-prefixes="">
<xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>

<!-- http://stackoverflow.com/questions/1384802/java-how-to-indent-xml-generated-by-transformer -->

<xsl:template match="/">
   <xsl:apply-templates select="//div[@id='mime-types-list']/table/tbody/tr"/>
</xsl:template>

<xsl:template match="tr">
                                        <th nowrap="nowrap" style="width:250px;">Name</th>
                                        <th nowrap="nowrap">MIME Type / Internet Media Type</th>
                                        <th nowrap="nowrap">File Extension</th>
                                        <th nowrap="nowrap">More Details</th>

   <xsl:variable name="name"      select="td[1]"/>
   <xsl:variable name="mimetype"  select="td[2]"/>
   <xsl:variable name="extension" select="td[3]"/>
   <xsl:variable name="details"   select="td[4]"/>
   <xsl:value-of select="concat($DQ,string-join((
                                                    $name,$mimetype,$extension,$details
                                                   ),
                                                   concat($DQ,',',$DQ)),$DQ,$NL)"/>
</xsl:template>

<!--xsl:template match="text()">
   <xsl:value-of select="normalize-space(.)"/>
</xsl:template-->

<xsl:variable name="NL" select="'&#xa;'"/>
<xsl:variable name="DQ" select="'&#x22;'"/>

</xsl:transform>
