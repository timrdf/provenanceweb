#!/bin/bash
#
#3> <> a conversion:ConversionTrigger; # Could also be conversion:Idempotent;
#3>    foaf:name    "convert.sh";
#3>    rdfs:seeAlso <https://github.com/timrdf/csv2rdf4lod-automation/wiki/Triggers#wiki-3-computation-triggers>;
#3> .
#

saxon.sh ../../src/svn2prov.xsl xml ttl -w -od manual -v `cr-sdv.sh --attribute-value` -in source/prizms.xml 
