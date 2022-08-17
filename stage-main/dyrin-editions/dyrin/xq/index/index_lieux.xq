declare variable $dbPath external;
declare variable $project external;
declare variable $baseURI external;

<index type="lieux">
	{for $idx in collection($dbPath)//*:index[@indexName='lieux']//*:term[@type='lieu']
	let $thesau := string($idx/*:name/@ref)
  let $titre := $idx/ancestor::*:TEI//*:titleStmt/*:title
  let $nom := node-name($idx)
	let $baseuridb := substring-after(base-uri($idx), $dbPath)
	let $initiale := translate(upper-case(substring($idx,1,1)), 'ŒÉÍÄ', 'OEIA')
  let $result :=
			<marker id="{$titre}">
				<entry>{$titre}</entry>
				<iden>{$thesau}</iden>
				<value>{data($idx)}</value>
				<baseuri>{$baseURI || $project || '/doc'|| $baseuridb}</baseuri>
				<initiale>{$initiale}</initiale>
			</marker>
		return $result
	}
</index>
