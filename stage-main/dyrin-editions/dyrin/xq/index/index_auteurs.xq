declare variable $dbPath external;
declare variable $project external;
declare variable $baseURI external;

<index type="personnes">{
	for $entry in collection($dbPath)//*:body//*:author[not(@role='artiste')]//*:persName
		let $titre := $entry/ancestor::*:TEI//*:titleStmt/*:title
		let $thesau := $entry/parent::*:name/@ref
    let $cId := $entry/ancestor::*:c[@id][1]/@id
    let $key := data($entry)
		let $persName := data($entry)
		let $surname := $entry/*:surname
		let $forename := $entry/*:forename
			let $plop :=
			if ($surname|$forename!='')
			then concat($surname, ' ', $forename)
        else $persName
  	let $anchor := $entry/ancestor::*:TEI/descendant::*:title[1]/text()
		let $entryURI := substring-after(base-uri($entry), $dbPath)
		let $initiale := translate(upper-case(substring($plop,1,1)), 'ŒÉÍÄÎÞʿ', 'OEIAITA')
    let $result :=
			<marker anchor="{$anchor}" id="{$titre}">
					<entry>{$titre}</entry>
					<iden>{data($thesau)}</iden>
					<value>{$plop}</value>
					<forename>{$forename}</forename>
					<surname>{$surname}</surname>
				<baseuri>{$baseURI || $project || '/doc' || $entryURI}</baseuri>
				<initiale>{$initiale}</initiale>
			</marker>
	return $result
}</index>
