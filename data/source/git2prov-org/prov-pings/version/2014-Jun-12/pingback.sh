#!/bin/bash

derivation='https://provenance.ecs.soton.ac.uk/picaso/uris/2655'
pingback_uri='http://git2prov.org:8902/prov-pings/pingback?target=http://opendap.tw.rpi.edu/source/us/dataset/ipaw-2014-paper-provenance/version/latest/pub'

echo $derivation > b.prov.ttl
echo "sending Content-Type: text/uri-list:"
cat b.prov.ttl

# DataFAQs uses POSTs like:
# curl -H "Content-Type: text/turtle" -d @my.ttl http://localhost:' + str(resource.dev_port) + '/' + resource.name


# PROV-AQ says that the Content-Type should be text/uri-list
echo
echo
echo curl -H "Content-Type: text/uri-list" -d @b.prov.ttl $pingback_uri
     curl -H "Content-Type: text/uri-list" -d @b.prov.ttl $pingback_uri
# ^^
# Provenance could not be added. Did you add a target AND a provenance URI?



# The following is how Prizms' prov-pingback.py accepts pingbacks.
echo
echo
echo curl --data-urlencode provenance="$derivation" $pingback_uri
     curl --data-urlencode provenance="$derivation" $pingback_uri
# ^^
# Provenance could not be added. Did you add a target AND a provenance URI?



#
# <form id="pingback" action="pingback"  method="post">
#   <input type="text" name="target" id="target" placeholder="Enter the URI of a publication"/><br />
#   <input type="text" name="uri"    id="uri"    placeholder="Enter the URI of the provenance of this publication" />
#   <input type="submit" value="Submit" />
# </form>
#
echo
echo
echo curl --data uri="$derivation" $pingback_uri
     curl --data uri="$derivation" $pingback_uri
# ^^
# Congratulations, your provenance was successfully added to the repository. 
# You can find the link you just added at <http://git2prov.org:8902/prov-pings/direct?target=http://opendap.tw.rpi.edu/source/us/dataset/ipaw-2014-paper-provenance/version/latest/pub>
#
# We suggest adding one or more of the following link headers to your publication at <http://opendap.tw.rpi.edu/source/us/dataset/ipaw-2014-paper-provenance/version/latest/pub>: 
# Link: <http://git2prov.org:8902/prov-pings/sparql>;rel="http://www.w3.org/ns/prov#has_query_service"
# Link: <http://git2prov.org:8902/prov-pings/pingback?target=http://opendap.tw.rpi.edu/source/us/dataset/ipaw-2014-paper-provenance/version/latest/pub>;rel="http://www.w3.org/ns/prov#pingback";


echo
echo
rm b.prov.ttl
