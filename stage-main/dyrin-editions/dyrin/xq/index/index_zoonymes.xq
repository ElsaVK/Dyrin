declare variable $dbPath external;
declare variable $project external;
declare variable $baseURI external;

<index type="zoonymes">
	{for $idx in collection($dbPath)//*:div[@type='zoonymes']/*:entry/*:form
	let $idxsmall := lower-case($idx)
  let $titre := $idx/ancestor::*:TEI//*:titleStmt/*:title
  let $nom := node-name($idx)
	let $baseuridb := substring-after(base-uri($idx), $dbPath)
	let $initiale := translate(upper-case(substring($idx,1,1)), 'ŒÉÍÄ', 'OEIA')
  let $result :=
			<marker id="{$titre}">
				<entry>{$titre}</entry>
				<value>{data($idxsmall)}</value>
				<baseuri>{$baseURI || $project || '/doc'|| $baseuridb}</baseuri>
				<initiale>{$initiale}</initiale>
			</marker>
		return $result
	}
</index>
