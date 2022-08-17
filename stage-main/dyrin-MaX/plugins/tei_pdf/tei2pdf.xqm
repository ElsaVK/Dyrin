(: For conditions of distribution and use, see the accompanying legal.txt file. :)

module namespace max.plugins.tei2pdf = 'pddn/max/plugins/tei2pdf.xqm';

import module namespace max.config = 'pddn/max/config' at '../../rxq/config.xqm';
import module namespace max.api = 'pddn/max/max_api' at '../../rxq/max_api.xqm';
import module namespace max.util = 'pddn/max/util' at '../../rxq/util.xqm';


declare
%rest:GET
%rest:produces("application/pdf")
%rest:path("/{$project}/{$routeDoc=.*\.xml}/{$id}.pdf")
function max.plugins.tei2pdf:fragmentToPDF($project, $routeDoc, $id){
    let $dbPath := max.config:getProjectDBPath($project)
    let $teiHeader := doc($dbPath || '/' || $routeDoc)//*:teiHeader
    let $content:=
        <TEI xmlns="http://www.tei-c.org/ns/1.0">
            <teiHeader>{$teiHeader}</teiHeader>
            <text>{max.api:getXMLByID($dbPath, $id)}</text>
        </TEI>
    (: return $content :)
    let $pdf := max.util:xml2pdf($content, max.util:getProjectFoXsl($project),$project,$id)
    return
        (<rest:response>
            <http:response status="200">
                <http:header name="content-type" value="application/pdf"/>
            </http:response>
        </rest:response>,
        $pdf)
};