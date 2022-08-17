declare variable $dbPath external;
declare variable $project external;
declare variable $baseURI external;

<index type="themes">
	{for $idx in collection($dbPath)//*:index[@indexName='themes']/*:term[@ref]
  let $titre := $idx/ancestor::*:TEI//*:titleStmt/*:title
	let $ref := string($idx/@ref)
  let $nom := node-name($idx)
	let $baseuridb := substring-after(base-uri($idx), $dbPath)
	let $initiale := translate(upper-case(substring($idx,1,1)), 'ŒÉÍÄÎ', 'OEIAI')
  let $result :=
			<marker id="{$titre}">
				<entry>{$titre}</entry>
				<value>{data($idx)}</value>
				<iden>{$ref}</iden>
				<baseuri>{$baseURI || $project || '/doc'|| $baseuridb}</baseuri>
				<initiale>{$initiale}</initiale>
			</marker>
		return $result
	}
</index>
