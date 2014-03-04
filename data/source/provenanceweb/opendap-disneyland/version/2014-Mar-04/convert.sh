#!/bin/bash
#
#3> <> a conversion:ConversionTrigger; # Could also be conversion:Idempotent;
#3>    foaf:name    "convert.sh";
#3>    rdfs:seeAlso <https://github.com/timrdf/csv2rdf4lod-automation/wiki/Triggers#wiki-3-computation-triggers>;
#3> .
#

mkdir -p automatic

if [ ! -e automatic/CA_OrangeCo_2011_000402.png ]; then
   # Pretend to render the LiDAR
   curl http://provenanceweb.org/CA_OrangeCo_2011_000402.png > automatic/CA_OrangeCo_2011_000402.png
   cr-droid.sh automatic/CA_OrangeCo_2011_000402.png > automatic/cr-droid.ttl
   justify.sh source/CA_OrangeCo_2011_000402.txt.cdl.nc automatic/CA_OrangeCo_2011_000402.png render

fi
