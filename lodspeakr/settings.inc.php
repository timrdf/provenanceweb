<?php

$conf['endpoint']['local'] = 'http://aquarius.tw.rpi.edu/projects/provenanceweb/sparql';
$conf['home'] = '/var/www/lodspeakr/';
$conf['basedir'] = 'http://aquarius.tw.rpi.edu/projects/provenanceweb/';
$conf['debug'] = false;
$conf['root'] = 'home.html';

$lodspk['sitetitle'] = 'provenanceweb';

/*ATTENTION: By default this application is available to
 * be exported and copied (its configuration)
 * by others. If you do not want that, 
 * turn the next option as false
 */ 
$conf['export'] = true;
#If you want to add/overrid a namespace, add it here
$conf['ns']['local']   = 'http://provenanceweb.org/';
$conf['ns']['base']   = 'http://aquarius.tw.rpi.edu/projects/provenanceweb/';

$conf['mirror_external_uris'] = $conf['ns']['local'];
?>
