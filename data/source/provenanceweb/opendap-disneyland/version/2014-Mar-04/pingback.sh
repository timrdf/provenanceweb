#!/bin/bash
#3> <> rdfs:seeAlso <https://github.com/tetherless-world/opendap/wiki/Use-case:-Disneyland#wiki-the-clients-derivation-rendering-the-lidar-as-an-image> .

# /home/prizms/prizms/opendap/data/source/us/opendap-prov/version
pingbackURI='http://opendap.tw.rpi.edu/prov-pingback/20140304-1393961676-ab12/mykey'

prov='http://provenanceweb.org/source/provenanceweb/file/opendap-disneyland/version/2014-Mar-04/conversion/provenanceweb-opendap-disneyland-2014-Mar-04.ttl.gz'

curl --data-urlencode provenance=$prov $pingbackURI
# /home/prizms/prizms/opendap/data/source/provenanceweb-org/prov-pingback/version
# --> 20140304-1393948965-ab12-d99a2dbf06b7d1e7cf6faf7e9720fd10
#     --> cr-retrieve.sh -w --skip-if-exists

# /home/prizms/prizms/opendap/data/source/us/pr-aggregate-pingbacks/version
# ./retrieve.sh
