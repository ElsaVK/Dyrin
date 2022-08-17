(: For conditions of distribution and use, see the accompanying legal.txt file. :)

module namespace max.file = 'pddn/max/file';
import module namespace max.util = 'pddn/max/util' at 'util.xqm';
import module namespace max.cons = 'pddn/max/cons' at 'cons.xqm';


(:
Project's UI file: css, js, image ...
:)
declare
  %rest:path("/{$project}/ui/{$filePath=.*}")
function max.file:projectUIFile(
  $project as xs:string,
  $filePath as xs:string){

    let $path := file:parent(file:parent(static-base-uri())) || "/editions/" || $project || "/ui/"  || $filePath
    return if (file:exists($path))
    then
         max.util:rawFile($path)
    else max.util:error404()
};

(:
 Global ui css,images,f font, js ... file
:)
declare
  %rest:path("/core/ui/{$filePath=.*}")
function max.file:UIFile(
  $filePath as xs:string){
    let $path := file:parent(file:parent(static-base-uri())) || "/ui/"  || $filePath
    return if (file:exists($path))
    then
         max.util:rawFile($path)
    else max.util:error404()
};

(:
 Plugin ui css,images,f font, js ... file
:)
declare
%rest:path("/plugins/{$filePath=.*}")
function max.file:pluginUIFile($filePath as xs:string){
    let $path := file:parent(file:parent(static-base-uri())) || "/"||$max.cons:PLUGIN_FOLDER_NAME||"/" || $filePath
    let $mediaType := web:content-type($path)
    return
        (<rest:response>
            <http:response status="200">
                <http:header name="content-type" value="{$mediaType}"/>
                <http:header name="expires" value="Tue, 22 Oct 2222 22:22:22 GMT"/>
            </http:response>
        </rest:response>,
        file:read-binary($path))
};

(:
 uiAddon css or js file
:)
declare
  %rest:path("/ui/uiAddons/{$uiAddonName}/{$file}")
function max.file:UIAddonFile(
  $uiAddonName as xs:string,
  $file as xs:string){
    let $path := file:parent(file:parent(static-base-uri())) || "/ui/uiAddons/" || $uiAddonName || "/" || $file
    return max.util:rawFile($path)

};