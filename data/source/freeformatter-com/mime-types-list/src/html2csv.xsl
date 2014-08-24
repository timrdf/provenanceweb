<!-- Timothy Lebo -->
<xsl:transform version="2.0" 
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   xmlns:html="http://www.w3.org/1999/xhtml"
   exclude-result-prefixes="">
<xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>

<!-- http://stackoverflow.com/questions/1384802/java-how-to-indent-xml-generated-by-transformer -->

<xsl:template match="/">
   <xsl:apply-templates select="//div[@id='mime-types-list']/table/tbody/tr"/>
</xsl:template>

<xsl:template match="tr">
                                       <!--  <th nowrap="nowrap" style="width:250px;">Name</th>
                                        <th nowrap="nowrap">MIME Type / Internet Media Type</th>
                                        <th nowrap="nowrap">File Extension</th>
                                        <th nowrap="nowrap">More Details</th> -->

   <xsl:variable name="name"          select="td[1]"/>
   <xsl:variable name="mimetype"      select="td[2]"/>
   <xsl:variable name="extension"     select="td[3]"/>
   <xsl:variable name="details-link"  select="html:anchor-hrefs(td[4]/a,'')"/>
   <xsl:variable name="details-title" select="html:anchor-labels(td[4]/a)"/>
   <xsl:value-of select="concat($DQ,string-join((
                                                    $mimetype,$name,$extension,$details-link,$details-title
                                                   ),
                                                   concat($DQ,',',$DQ)),$DQ,$NL)"/>
</xsl:template>

<xsl:function name="html:anchor-hrefs">
   <xsl:param name="anchors"/>
   <xsl:param name="base"/>

   <xsl:variable name="together">
      <xsl:for-each select="$anchors">
         <xsl:if test="position() gt 1">
            <xsl:value-of select="'||'"/>
         </xsl:if>
         <xsl:value-of select="concat($base,normalize-space(@href))"/>
      </xsl:for-each>
   </xsl:variable>

   <xsl:value-of select="normalize-space($together)"/>
</xsl:function>

<xsl:function name="html:anchor-labels">
   <xsl:param name="anchors"/>

   <xsl:variable name="together">
      <xsl:for-each select="$anchors">
         <xsl:if test="position() gt 1">
            <xsl:value-of select="'||'"/>
         </xsl:if>
         <xsl:value-of select="normalize-space(.)"/>
      </xsl:for-each>
   </xsl:variable>

   <xsl:value-of select="normalize-space($together)"/>
</xsl:function>

<xsl:variable name="NL" select="'&#xa;'"/>
<xsl:variable name="DQ" select="'&#x22;'"/>

</xsl:transform>
