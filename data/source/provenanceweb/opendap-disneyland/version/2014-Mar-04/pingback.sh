#!/bin/bash
#3> <> rdfs:seeAlso <https://github.com/tetherless-world/opendap/wiki/Use-case:-Disneyland#wiki-the-clients-derivation-rendering-the-lidar-as-an-image> .

# opendap.tw: cd /home/prizms/prizms/opendap/data/source/us/opendap-prov/version
pingbackURI='http://opendap.tw.rpi.edu/prov-pingback/20140304-1393948965-ab12/mykey'

prov='http://provenanceweb.org/source/provenanceweb/file/opendap-disneyland/version/2014-Mar-04/conversion/provenanceweb-opendap-disneyland-2014-Mar-04.ttl.gz'

curl --data-urlencode provenance=$prov $pingbackURI
