#!/bin/bash
#
#3> <> a conversion:ConversionTrigger; # Could also be conversion:Idempotent;
#3>    foaf:name    "convert.sh";
#3>    rdfs:seeAlso <https://github.com/timrdf/csv2rdf4lod-automation/wiki/Triggers#wiki-3-computation-triggers>;
#3> .
#

for repo in `cat automatic/repos.csv`; do
        hash=`md5.sh -qs $repos`
        echo "<$hash> a doap:GitRepository;"           >> automatic/repos.csv.ttl
        echo "        doap:location <$repo>;"          >> automatic/repos.csv.ttl
        echo "."                                       >> automatic/repos.csv.ttl
        echo "<$hash> dcterms:isReferencedBy <$repo>." >> automatic/repos.csv.ttl
done
justify.sh automatic/repos.csv automatic/repos.csv.ttl TODO
