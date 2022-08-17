import module namespace max.html = 'pddn/max/html' at '../../../rxq/html.xqm';
import module namespace max.config = 'pddn/max/config' at '../../../rxq/config.xqm';

declare variable $project external;
declare variable $requestPath external;
declare variable $content external;

<title>{max.html:cleanValue(string-join(($content//(*:h3 | *:h2 | *:h1)[1])//text(), ''))}</title>,
<meta name="author" content="PLOP"/>,

<meta property="dc:description" content="{max.config:getProjectDescription($project)}"/>,
<meta property="dc:title" content="{max.html:cleanValue(string-join(($content//(*:h3 | *:h2 | *:h1)[1])//text(), ''))}"/>,
<meta property="dc:type" content="Web page"/>,
<meta property="dc:relation" content="{$requestPath}"/>,

<meta property="og:description" content="{max.config:getProjectDescription($project)}"/>,
<meta property="og:title" content="{max.html:cleanValue(string-join(($content//(*:h3 | *:h2 | *:h1)[1])//text(), ''))}"/>,
<meta property="og:type" content="page"/>,
<meta property="og:url" content="{$requestPath}"/>
