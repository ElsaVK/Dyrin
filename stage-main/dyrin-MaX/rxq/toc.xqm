(: For conditions of distribution and use, see the accompanying legal.txt file. :)

module namespace max.toc = 'pddn/max/toc';
import module namespace max.cons = 'pddn/max/cons' at 'cons.xqm';
import module namespace max.config = 'pddn/max/config' at 'config.xqm';
import module namespace max.util = 'pddn/max/util' at 'util.xqm';
import module namespace max.i18n = 'pddn/max/i18n' at 'i18n.xqm';

(:get project table of contents:)
declare function max.toc:getProjectTOC($project){

    let $tocFile := max.util:getResourceFilePath($project, "editions/"||$project ||'/'||$max.cons:TOC_QUERY_FILEPATH)
    let $xml :=
        if(file:exists($tocFile))
        then
            xquery:eval(xs:anyURI($tocFile),map
            {
            'project':$project,
            'baseURI': max.config:getBaseURI(),
            'dbPath':max.config:getProjectDBPath($project),
            'locale': max.i18n:getLang($project)
            })
        else
            max.util:list-db-resources($project)

    let $tocXSL := max.util:getProjectTOCXSL($project)

    return xslt:transform(
            $xml,
            $tocXSL,
            map {
            'project' : $project,
            'locale': max.i18n:getLang($project)
            })/*[1]
};

(:
  Returns document's table of content
:)

declare function max.toc:getDocumentTOC($project, $doc){

   let $tocQuery := max.util:getDocumentTOCXQueryFile($project)
   let $xml := xquery:eval(xs:anyURI($tocQuery),map
                  { 'project':$project,
                    'baseURI': max.config:getBaseURI(),
                    'dbPath':max.config:getProjectDBPath($project),
                    'doc': $doc,
                    'locale': max.i18n:getLang($project)
                  })

   let $tocXSL := max.util:getProjectDocumentTOCXSL($project)
   return
       if(file:exists($tocXSL))
       then
        xslt:transform($xml,
           $tocXSL,
           map{
           "baseuri":max.config:getBaseURI(),
           "project": $project,
           'locale': max.i18n:getLang($project),
           "docTitle": max.util:getDocTitle(max.config:getProjectDBPath($project),$doc, max.config:getXMLFormat($project))
           })/*[1]
       else $xml
}; 


