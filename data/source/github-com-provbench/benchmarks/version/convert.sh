#!/bin/bash
#
#3> <> a conversion:ConversionTrigger; # Could also be conversion:Idempotent;
#3>    foaf:name    "convert.sh";
#3>    rdfs:seeAlso <https://github.com/timrdf/csv2rdf4lod-automation/wiki/Triggers#wiki-3-computation-triggers>;
#3> .
#

plan='https://github.com/timrdf/provenanceweb/blob/master/data/source/github-com-timrdf/provenanceweb/version/git/convert.sh'

echo "@prefix doap:    <http://usefulinc.com/ns/doap#>." > automatic/repos.csv.ttl
echo "@prefix dcterms: <http://purl.org/dc/terms/>."    >> automatic/repos.csv.ttl

dataset=`cr-dataset-uri.sh --uri`
for repo in `cat automatic/repos.csv`; do
        hash=`md5.sh -qs $repos`
	echo
        echo "<$CSV2RDF4LOD_BASE_URI/id/repo/location/$hash> a doap:GitRepository;" >> automatic/repos.csv.ttl
        echo "        doap:location <$repo>;"                                       >> automatic/repos.csv.ttl
        echo "."                                                                    >> automatic/repos.csv.ttl
        echo "<$hash> dcterms:isReferencedBy <$dataset>."                           >> automatic/repos.csv.ttl
done
justify.sh automatic/repos.csv automatic/repos.csv.ttl $plan
