(: For conditions of distribution and use, see the accompanying legal.txt file. :)

module namespace max.plugin.mirador = 'pddn/max/plugin/mirador';
import module namespace max.config = 'pddn/max/config' at '../../rxq/config.xqm';

declare variable $max.plugin.mirador:PLUGIN_ID := "mirador_viewer";

(:
returns html page with mirador loaded
:)

declare
%rest:GET
%output:method("html")
%rest:query-param("link", "{$link}")
%rest:query-param("canvasId", "{$canvasId}")
%rest:query-param("canvasIndex", "{$canvasIndex}")
%rest:path("/{$project}/mirador")
function max.plugin.mirador:loadViewer($project,$link,$canvasId,$canvasIndex){
let $libJs := max.config:getBaseURI() || 'plugins/mirador_viewer/max-mirador/MaxMirador.js'

let $htmlPage := <html>
  <head>
    <script type='text/javascript' src='{$libJs}'></script>
  </head>
  <body onload='MaxMirador.open("{$link}","{$canvasId}","{$canvasIndex}")'>
    <div id='mirador-viewer'/>
  </body>
</html>
return $htmlPage
  };
