<!--
#3> <> a prov:Entity, doap:Project;
#3>    dcterms:title "provx2o.xsl";
#3>    prov:specializationOf  <https://github.com/timrdf/provenanceweb/blob/master/src/provx2o.xsl>;
#3>    prov:hasProvenance     <https://raw.github.com/timrdf/provenanceweb/master/src/provx2o.xsl.prov.ttl>;
#3>    doap:developer         <http://tw.rpi.edu/instances/TimLebo>;
#3>    prov:wasAttributedTo   <http://tw.rpi.edu/instances/TimLebo>;
#3>    dcterms:isReferencedBy <http://www.w3.org/TR/prov-implementations/>,
#3>                           <https://www.w3.org/2002/09/wbs/46974/prov-vocabulary-survey/results>;
#3>    foaf:homepage          <https://github.com/timrdf/provenanceweb/wiki/provx2o>;
#3>    rdfs:seeAlso <http://www.w3.org/TR/prov-xml/>,
#3>                 <http://www.w3.org/TR/grddl-primer/>,
#3>                 <http://www.w3.org/TR/prov-o/>,
#3>                 <https://github.com/timrdf/csv2rdf4lod-automation/wiki/tic-turtle-in-comments>;
#3>    dcterms:description """
#3>       This XSL transform can be used to generate a PROV-O representation of a PROV-XML representation.
#3>       The following attributes may be included in any PROV-XML document to signal that this transform is available.""";
#3>
#3>    rdfs:comment """Please note that this transform is incomplete. 
#3>                    If you need it to do more, please feel free to fork it or add a GitHub issue.""";
#3>    doap:bug-database <https://github.com/timrdf/provenanceweb/issues>;
#3> .

   <prov:document
       xmlns:grddl="http://www.w3.org/2003/g/data-view#"
       grddl:transformation="https://raw.github.com/timrdf/provenanceweb/master/src/provx2o.xsl"

-->

<xsl:transform version="2.0" 
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
               xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
               xmlns:prov="http://www.w3.org/ns/prov#"
               xmlns:o="https://github.com/timrdf/provenanceweb/wiki/provx2o#"
               exclude-result-prefixes="">
<xsl:output method="text"/>

<!-- If 'base_uri' is specified, instance URIs will be absolute to it (i.e., set a @base in the output RDF). 
        'base_uri' will also be used to identify the instances.
     If 'base_uri' is not specified, instance URIs will remain relative. 
         The input file URL will be used to identify the instances. -->
<xsl:param name="base_uri"/>

<!-- If 'base_identifier' is provided, it will be used as hash salt for the identify of instances.
     e.g., provide a md5 of the file or the file modification date if those aspects effect 
           the identity of the instances in the input file. -->
<xsl:param name="base_identifier"/>
<xsl:variable name="identity_base" select="if ($base_uri) then $base_uri else document-uri(.)"/> <!-- TODO: base_identifier -->

<!-- The namespace to create types. -->
<xsl:param name="vocab_uri"/>

<xsl:template match="/">

   <xsl:message select="concat('   identity_base: ',$identity_base,$NL)"/>

   <!-- Prefixes -->
   <xsl:value-of select="concat('@prefix rdfs: ',o:ref('http://www.w3.org/2000/01/rdf-schema#'),' .',$NL,
                                '@prefix prov: ',o:ref('http://www.w3.org/ns/prov#'),' .',$NL,
                                '@prefix my:   ',o:ref(if ($vocab_uri) then $vocab_uri else concat($base_uri,'vocab#')),' .',$NL
                                )"/>

   <xsl:if test="$base_uri">
      <xsl:value-of select="concat('@base      &lt;',$base_uri,'&gt; .',$NL)"/>
   </xsl:if>

   <!-- Elements are enumerated for self-documentation purposes. -->
   <xsl:variable name="prov" 
                 select="prov:document/
                          (prov:actedOnBehalfOf   |
                           prov:activity          |
                           prov:agent             |
                           prov:alternateOf       |
                           prov:bundle            |
                           prov:entity            |
                           prov:hadMember         |
                           prov:specializationOf  |
                           prov:used              |
                           prov:wasAssociatedWith |
                           prov:wasAttributedTo   |
                           prov:wasDerivedFrom    |
                           prov:wasEndedBy        |
                           prov:wasGeneratedBy    |
                           prov:wasInfluencedBy   |
                           prov:wasInformedBy     |
                           prov:wasInvalidatedBy  |
                           prov:wasStartedBy)"/>

   <xsl:for-each select="$prov">
      <xsl:value-of select="$NL"/>
      <xsl:apply-templates select="." mode="o:unqualified-form"/>
   </xsl:for-each>
</xsl:template>


<!-- -->
<xsl:template match="prov:actedOnBehalfOf" mode="o:unqualified-form">
   <rdfs:seeAlso resource="http://www.w3.org/TR/prov-xml/#term-Delegation"/>

   <xsl:variable name="qualified" select="prov:activity | prov:label | prov:type"/>
   <xsl:variable name="docid">
      <xsl:number count="/prov:document/prov:actedOnBehalfOf"/>
   </xsl:variable> <!-- TODO: some @id may collide with xsl:number -->
   <xsl:variable name="qualRef" select="o:ref(concat('delegation/',if (@prov:id) then @prov:id else $docid))"/> 

   <!-- Unqualified form -->
   <xsl:value-of select="concat(
                   o:ref(prov:delegate/@prov:ref),                                  $NL,
                   '   a prov:Agent;',                                              $NL,
                   '   prov:actedOnBehalfOf ',o:ref(prov:responsible/@prov:ref),';',$NL,
      o:pif(concat('   prov:qualifiedDelegation ',$qualRef,';',$NL), $qualified),
                   '.',                                                             $NL,

                   o:ref(prov:responsible/@prov:ref),                               $NL,
                   '   a prov:Agent;',                                              $NL,
                   '.',$NL)"/>
   <!-- Qualified form -->
   <xsl:apply-templates select=".[$qualified]" mode="o:qualified-form">
      <xsl:with-param name="qualRef" select="$qualRef"/>
   </xsl:apply-templates>
</xsl:template>

<xsl:template match="prov:actedOnBehalfOf" mode="o:qualified-form">
   <xsl:param name="qualRef"/>
   <rdfs:seeAlso resource="http://www.w3.org/TR/prov-xml/#term-Delegation"/>
   <xsl:value-of select="concat(
      $qualRef,                                                              $NL,
      '   a prov:Delegation;',                                               $NL,
      '   prov:agent ',o:ref(prov:responsible/@prov:ref),';',                $NL,
      for $activity in prov:activity 
         return concat('   prov:hadActivity ',o:ref($activity/@prov:ref),';',$NL),
      for $label in prov:label 
         return concat('   rdfs:label ',$DQ,$label,$DQ,';',                  $NL),
      for $type in prov:type 
         return concat('   a my:',$type,';',                                 $NL),
      '.',                                                                   $NL,
      for $activity in prov:activity 
         return concat(o:ref($activity/@prov:ref),' a prov:Activity .',      $NL)
   )"/>
</xsl:template>


<!-- -->
<xsl:template match="prov:activity" mode="o:unqualified-form">
   <rdfs:seeAlso resource="http://www.w3.org/TR/prov-xml/#term-Activity"/>

   <xsl:variable name="docid">
      <xsl:number count="/prov:document/prov:activity"/>
   </xsl:variable> <!-- TODO: some @id may collide with xsl:number -->
   <xsl:variable name="ref" select="o:ref(concat('activity/',if (@prov:id) then @prov:id else $docid))"/> 

   <xsl:value-of select="concat(
                   $ref,                                                                $NL,
                   '   a prov:Activity;',                                               $NL,
      o:pif(concat('   prov:startedAtTime ',$DQ,prov:startTime[1],$DQ,'^^xsd:dateTime;',$NL), prov:startTime),
      o:pif(concat('   prov:endedAtTime   ',$DQ,prov:endTime[1],$DQ,'^^xsd:dateTime;',  $NL), prov:endTime),
      for $location in prov:location 
         return concat('   prov:atLocation ',o:ref($location/@prov:ref),';',            $NL),
      for $label in prov:label 
         return concat('   rdfs:label ',$DQ,$label,$DQ,';',                             $NL),
      for $type in prov:type 
         return concat('   a my:',$type,';',                                            $NL),
                   '.',$NL)"/>
</xsl:template>

<!-- -->
<xsl:template match="prov:agent" mode="o:unqualified-form">
   <rdfs:seeAlso resource="http://www.w3.org/TR/prov-xml/#term-Agent"/>

   <xsl:variable name="docid">
      <xsl:number count="/prov:document/prov:agent"/>
   </xsl:variable> <!-- TODO: some @id may collide with xsl:number -->
   <xsl:variable name="ref" select="o:ref(concat('agent/',if (@prov:id) then @prov:id else $docid))"/> 

   <xsl:value-of select="concat(
                   $ref,                                                                $NL,
                   '   a prov:Agent;',                                                  $NL,
      for $location in prov:location 
         return concat('   prov:atLocation ',o:ref($location/@prov:ref),';',            $NL),
      for $label in prov:label 
         return concat('   rdfs:label ',$DQ,$label,$DQ,';',                             $NL),
      for $type in prov:type 
         return concat('   a my:',$type,';',                                            $NL),
                   '.',$NL)"/>
   <!-- TODO: custom attributes -->
</xsl:template>


<!-- -->
<xsl:template match="prov:alternateOf" mode="o:unqualified-form">
   <rdfs:seeAlso resource="http://www.w3.org/TR/prov-xml/#term-Alternate"/>

   <xsl:value-of select="concat(
      o:ref(prov:alternate1/@prov:ref),                           $NL,
      '   a prov:Entity;',                                        $NL,
      '   prov:alternateOf ',o:ref(prov:alternate2/@prov:ref),';',$NL,
      '.',                                                        $NL,$NL,
      o:ref(prov:alternate2/@prov:ref),' a prov:Entity .',        $NL)"/>
</xsl:template>


<!-- -->
<xsl:template match="prov:entity" mode="o:unqualified-form">
   <rdfs:seeAlso resource="http://www.w3.org/TR/prov-xml/#term-Entity"/>

   <xsl:variable name="docid">
      <xsl:number count="/prov:document/prov:entity"/>
   </xsl:variable> <!-- TODO: some @id may collide with xsl:number -->
   <xsl:variable name="ref" select="o:ref(concat('entity/',if (@prov:id) then @prov:id else $docid))"/> 
   <!-- TODO: handle qname ids e.g. ex:e1 -->

   <xsl:value-of select="
                       $ref,                                                                $NL,
                       '  a prov:Entity;',                                                 $NL,
      for $location in prov:location 
         return concat('  prov:atLocation ',o:ref($location/@prov:ref),';',            $NL),
      for $value in prov:value 
         return concat('  prov:value ',$DQ,$value,$DQ,';',                             $NL),
      for $label in prov:label 
         return concat('  rdfs:label ',$DQ,$label/text(),$DQ,';', $NL),
      for $type in prov:type 
         return concat('  a my:',$type,';',                                            $NL),
                   '.',$NL"/>
   <!-- TODO: custom attributes, TODO: my:prov:Collection -->
</xsl:template>


<!-- -->
<xsl:template match="prov:hadMember" mode="o:unqualified-form">
   <rdfs:seeAlso resource="http://www.w3.org/TR/prov-xml/#term-Membership"/>

   <xsl:for-each select="prov:collection">
      <xsl:value-of select="o:ref(@prov:ref),$NL,'  a prov:Collection, prov:Entity;',$NL"/>
   </xsl:for-each>

   <xsl:for-each select="prov:entity">
      <xsl:variable name="entity" select="@prov:ref"/>
      <xsl:for-each select="../prov:collection">
         <xsl:value-of select="'   prov:hadMember',o:ref($entity),' .',$NL"/>
      </xsl:for-each>
   </xsl:for-each>

   <xsl:value-of select="'.',$NL"/>

   <xsl:for-each select="prov:entity">
      <xsl:value-of select="o:ref(@prov:ref),'a prov:Entity .',$NL"/>
   </xsl:for-each>
</xsl:template>

<!-- -->
<xsl:template match="prov:specializationOf" mode="o:unqualified-form">
   <rdfs:seeAlso resource="http://www.w3.org/TR/prov-xml/#term-Specialization"/>

   <xsl:value-of select="
      o:ref(concat('entity/',prov:specificEntity/@prov:ref)),                               $NL,
      '   a prov:Entity;',                                                $NL,
      '   prov:specializationOf ',o:ref(concat('entity/',prov:generalEntity/@prov:ref)),';',$NL,
      '.',                                                                $NL,$NL,
      o:ref(concat('entity/',prov:generalEntity/@prov:ref)),' a prov:Entity .',        $NL"/>
   <!-- TODO: entity URI construction -->
</xsl:template>





<!-- -->
<xsl:template match="*" mode="o:unqualified-form">
   <!-- Catch any element that we didn't know about -->
   <xsl:value-of select="concat('[] rdfs:label ',$DQ,'WARNING: did not recognize unqualified form of element ',local-name(.),$DQ,' .',$NL)"/>
</xsl:template>

<xsl:template match="*" mode="o:qualified-form">
   <!-- Catch any element that we didn't know about -->
   <xsl:value-of select="concat('[] rdfs:label ',$DQ,'WARNING: did not recognize qualified form of element ',local-name(.),$DQ,' .',$NL)"/>
</xsl:template>

<!-- Common PROV templates -->

<xsl:template match="prov:type">
    <!--prov:type xsi:type="xsd:QName">line-management</prov:type-->
</xsl:template>

<!-- Generic templates -->

<xsl:template match="@*|node()">
   <!-- Identity template -->
   <xsl:copy>
      <xsl:copy-of select="@*"/>   
      <xsl:apply-templates/>
   </xsl:copy>
</xsl:template>

<!--xsl:template match="text()">
   <xsl:value-of select="normalize-space(.)"/>
</xsl:template-->

<xsl:variable name="NL">
<xsl:text>
</xsl:text>
</xsl:variable>

<xsl:variable name="DQ">
<xsl:text>"</xsl:text>
</xsl:variable>

<xsl:variable name="lt">
<xsl:text>&lt;</xsl:text>
</xsl:variable>

<xsl:variable name="gt">
<xsl:text>&gt;</xsl:text>
</xsl:variable>

<xsl:function name="o:ref">
   <xsl:param name="ref"/>
   <xsl:value-of select="concat('&lt;',$ref,'&gt;')"/>
</xsl:function>

<xsl:function name="o:pif"> <!-- Print if true -->
   <xsl:param name="string"/>
   <xsl:param name="if"/>
   <xsl:value-of select="if ($if) then $string else ''"/>
</xsl:function>

</xsl:transform>
