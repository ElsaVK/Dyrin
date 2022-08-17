declare variable $baseURI external;
declare variable $dbPath external;
declare variable $project external;
declare variable $doc external;

	<div id="toc">
	<ul>
	{
		for $doc in collection($dbPath)/*:TEI
		let $titre := $doc/*:teiHeader/*:fileDesc/*:titleStmt/*:title
		let $initiale := translate($titre, 'É', 'E')
			order by $initiale
		let $desc := $doc//*:body//*:div[@type='resume_zoologie']/*:p/text()

(:		collation "?lang=fr":)
let $result :=
		<marker id="{$titre}">
		<li data-href="{concat('doc/',tokenize(base-uri($titre),'/')[last()])}">{$titre}</li>
		<desc>{$desc}</desc>
		</marker>
	return $result

	}
	</ul>
	</div>
