#!/bin/bash
#
#3> @prefix doap:    <http://usefulinc.com/ns/doap#> .
#3> @prefix dcterms: <http://purl.org/dc/terms/> .
#3> @prefix rdfs:    <http://www.w3.org/2000/01/rdf-schema#> .
#3> 
#3> <> a conversion:RetrievalTrigger, doap:Project; # Could also be conversion:Idempotent;
#3>    dcterms:description 
#3>      "Script to retrieve and convert a new version of the dataset.";
#3>    rdfs:seeAlso 
#3>      <https://github.com/timrdf/csv2rdf4lod-automation/wiki/Automated-creation-of-a-new-Versioned-Dataset>,
#3>      <https://github.com/timrdf/csv2rdf4lod-automation/wiki/tic-turtle-in-comments>;
#3> .

if [[ "$1" == 'clean' ]]; then
   rm source/CA_OrangeCo_2011_000402.txt.cdl.nc source/cr-droid.tt
   exit
fi

mkdir -p source automatic

echo source/CA_OrangeCo_2011_000402.txt.cdl.nc
pushd source
   if [ ! -e CA_OrangeCo_2011_000402.txt.cdl.nc ]; then
      pcurl.sh 'http://opendap.tw.rpi.edu/tomcat/opendap/ipaw2014/disneyland/CA_OrangeCo_2011_000402.txt.cdl.nc'
   fi
   cr-droid.sh CA_OrangeCo_2011_000402.txt.cdl.nc > cr-droid.ttl
popd
