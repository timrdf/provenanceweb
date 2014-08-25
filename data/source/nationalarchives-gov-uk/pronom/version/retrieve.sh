#!/bin/bash
#
# See:
# https://github.com/timrdf/csv2rdf4lod-automation/wiki/Automated-creation-of-a-new-Versioned-Dataset
#

see="https://github.com/timrdf/csv2rdf4lod-automation/wiki/CSV2RDF4LOD-not-set"
CSV2RDF4LOD_HOME=${CSV2RDF4LOD_HOME:?"not set; source csv2rdf4lod/source-me.sh or see $see"}

# cr:data-root cr:source cr:directory-of-datasets cr:dataset cr:directory-of-versions cr:conversion-cockpit
ACCEPTABLE_PWDs="cr:directory-of-versions"
if [ `${CSV2RDF4LOD_HOME}/bin/util/is-pwd-a.sh $ACCEPTABLE_PWDs` != "yes" ]; then
   ${CSV2RDF4LOD_HOME}/bin/util/pwd-not-a.sh $ACCEPTABLE_PWDs
   exit 1
fi

TEMP="_"`basename $0``date +%s`_$$.tmp

if [[ "$1" == "--help" ]]; then
   echo "usage: `basename $0` version-identifier"
   echo "   version-identifier: conversion:version_identifier for the VersionedDataset to create (use cr:auto for default)"
   exit 1
fi


#-#-#-#-#-#-#-#-#
version="${1-"cr:auto"}"
version_reason=""
if [[ "$version" == "cr:auto" ]]; then

   # Set up shop if it's not done already.
   if [ ! -e ../../pronom-droid-signatures/version/latest/automatic/droid-signature-files.csv ]; then
      if [ ! -e ../../pronom-droid-signatures/version ]; then
         mkdir -p ../../pronom-droid-signatures/version
      fi
      pushd ../../pronom-droid-signatures &> /dev/null
         url='http://www.nationalarchives.gov.uk/aboutapps/pronom/droid-signature-files.htm'
         echo "INFO retrieving signature file listing from $url"
         cr-dcat-retrieval-url.sh $url
         cr-retrieve.sh -w &> /dev/null
         pushd version &> /dev/null
            if [ -e latest ]; then
               rm latest
            fi
            latest=`cr-list-versions.sh | tail -1`
            echo "INFO latest version of `cr-dataset-id.sh`: $latest from `cr-pwd.sh`"
            pushd $latest &> /dev/null
               if [ ! -e automatic/ ]; then
                  mkdir automatic
               fi
               pushd source &> /dev/null
                  tidy.sh droid-signature-files.htm 2>&1> /dev/null
               popd &> /dev/null
               saxon.sh ../../src/html2csv.xsl a a source/droid-signature-files.htm.tidy > automatic/droid-signature-files.csv
            popd &> /dev/null
            ln -s $latest latest
         popd &> /dev/null
      popd &> /dev/null
   fi

   url=`grep DROID_SignatureFile ../../pronom-droid-signatures/version/latest/automatic/droid-signature-files.csv | tail -1`
   version=`echo $url | sed 's/^.*DROID_SignatureFile_//;s/.xml//'` 
   version_reason="(Latest version listed in pronom-droid-signatures)"
fi

url='http://www.nationalarchives.gov.uk/documents/DROID_SignatureFile_V77.xml'
sig_file=`basename $url`
version=`echo $url | sed 's/^.*DROID_SignatureFile_//;s/.xml//'` 
version_reason="(Latest version listed in pronom-droid-signatures)"

#if [ ${#version} -ne 11 -a "$1" == "cr:auto" ]; then # 11!?
#   version=`cr-make-today-version.sh 2>&1 | head -1`
#   #echo "Using today's date to name version: $version"
#   version_reason="(Today's date)"
#fi
#if [ "$1" == "cr:today" ]; then
#   version=`cr-make-today-version.sh 2>&1 | head -1`
#   #echo "Using today's date to name version: $version"
#   version_reason="(Today's date)"
#fi
if [ ${#version} -gt 0 -a `echo $version | grep ":" | wc -l | awk '{print $1}'` -gt 0 ]; then
   echo "Version identifier invalid."
   exit 1
fi
shift

echo "INFO url       : $url"
echo "INFO version   : $version $version_reason"
echo

#
# This script is invoked from a cr:directory-of-versions, 
# e.g. source/contactingthecongress/directory-for-the-112th-congress/version
#
if [ ! -d $version ]; then

   # Create the directory for the new version.
   mkdir -p $version/source

   # Go into the directory that stores the original data obtained from the source organization.
   echo INFO `cr-pwd.sh`/$version/source
   pushd $version/source &> /dev/null
      touch .__CSV2RDF4LOD_retrieval # Make a timestamp so we know what files were created during retrieval.
      # - - - - - - - - - - - - - - - - - - - - Replace below for custom retrieval  - - - \
      pcurl.sh $url                                                                     # |
      # - - - - - - - - - - - - - - - - - - - - Replace above for custom retrieval - - - -/
   popd &> /dev/null

   # Go into the conversion cockpit of the new version.
   pushd $version &> /dev/null

      mkdir -p manual automatic

      echo                                                                                                               
      base=${CSV2RDF4LOD_BASE_URI_OVERRIDE:-$CSV2RDF4LOD_BASE_URI}
      # It's rarely good to go straight XML->RDF, misses too much that csv2rdf4lod provides for free...
      echo automatic/pronom-formats.ttl
      saxon.sh ../../src/pronom-formats.xsl a a -v accept=text/turtle BASE_URI=$base -in source/$sig_file > automatic/$sig_file.ttl
      # TODO: The extension is falling on the floor ATM.
      #        <FileFormat ID="45" MIMEType="text/csv"
      #            Name="Comma Separated Values" PUID="x-fmt/18">
      #            <Extension>csv</Extension>
      #        </FileFormat>
      echo automatic/pronom-formats.csv
      saxon.sh ../../src/pronom-formats.xsl a a -v accept=text/csv                   -in source/$sig_file > automatic/$sig_file.csv


      if [[ 'process-csvs' == 'no' ]]; then
         # The CSVs have less information than the XMLs.
         echo automatic/retrieve-format-csv.sh                                                               
         cat automatic/retrieve-format-xml.sh | sed 's/xml/csv/;s/XML/CSV/' > automatic/retrieve-format-csv.sh
         source automatic/retrieve-format-csv.sh
      fi

      echo automatic/retrieve-format-xml.sh
      saxon.sh ../../src/pronom-format-ids.xsl a a source/DROID*.xml | awk -f ../../src/retrieve-xml.awk > automatic/retrieve-format-xml.sh
      source automatic/retrieve-format-xml.sh
      echo

      echo "#!/bin/bash"                                                                                          > convert-pronom.sh
      echo                                                                                                       >> convert-pronom.sh
      echo "for fmt in source/*fmt*.xml; do"                                                                     >> convert-pronom.sh
      echo "   ttl=\${fmt%.xml}.ttl"                                                                             >> convert-pronom.sh
      echo "   ttl=automatic/\${ttl#source/}"                                                                    >> convert-pronom.sh
      echo "   if [[ ! -e \"\$ttl\" || \$fmt -nt \"\$ttl\" ]]; then"                                             >> convert-pronom.sh
      echo "      echo \"\$fmt -> \$ttl\""                                                                       >> convert-pronom.sh
      echo "      saxon.sh ../../src/pronom-format.xsl a a -v BASE_URI=\$CSV2RDF4LOD_BASE_URI -in \$fmt > \$ttl" >> convert-pronom.sh
      echo "   else"                                                                                             >> convert-pronom.sh
      echo "      echo \"[INFO] \$fmt already cached at \$ttl\""                                                 >> convert-pronom.sh
      echo "   fi"                                                                                               >> convert-pronom.sh
      echo "done"                                                                                                >> convert-pronom.sh
      echo                                                                                                       >> convert-pronom.sh
      echo "aggregate-source-rdf.sh automatic/*.ttl"                                                             >> convert-pronom.sh

      chmod +x convert-pronom.sh
      ./convert-pronom.sh
   popd &> /dev/null
else
   echo "Version exists; skipping."
fi
