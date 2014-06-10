#!/bin/bash
#
#3> <> a conversion:ConversionTrigger; # Could also be conversion:Idempotent;
#3>    foaf:name    "convert.sh";
#3>    rdfs:seeAlso <https://github.com/timrdf/csv2rdf4lod-automation/wiki/Triggers#wiki-3-computation-triggers>;
#3> .
#

echo "@prefix doap: <http://usefulinc.com/ns/doap#>."   > automatic/repos.csv.ttl
echo "@prefix dcterms: <http://purl.org/dc/terms/>."   >> automatic/repos.csv.ttl
echo

for repo in `cat automatic/repos.csv`; do
        hash=`md5.sh -qs $repos`
        echo "<$hash> a doap:GitRepository;"           >> automatic/repos.csv.ttl
        echo "        doap:location <$repo>;"          >> automatic/repos.csv.ttl
        echo "."                                       >> automatic/repos.csv.ttl
        echo "<$hash> dcterms:isReferencedBy <$repo>." >> automatic/repos.csv.ttl
done
justify.sh automatic/repos.csv automatic/repos.csv.ttl TODO
