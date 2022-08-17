declare variable $baseURI external;
declare variable $dbPath external;
declare variable $project external;

<div id="toc">
<ul>
	<li>plop</li>
  {
		for $doc in collection($dbPath)/*:TEI
		let $titre := $doc/*:teiHeader/*:fileDesc/*:titleStmt/*:title
		return
		<li data-href="{concat('doc/',tokenize(base-uri($titre),'/')[last()])}">{$titre}</li>
	}
</ul>
</div>