import {Plugin} from '../../core/ui/js/Plugin.js';

const PLUGIN_NAME='apparat';

class ApparatPlugin extends Plugin{
    constructor(name) {
        super(name);
    }

    run() {
        //si le fragment courant ne contient pas d'apparat
        if (!this.docWithApparat()) {
            document.querySelectorAll(".apparat-witnesses").forEach((e) => e.style.display = 'none');
            return;
        }
        this.showWitness("lem");
        this.witnessTooltiping();
    }

    showWitness(witnessClass) {
        document.querySelectorAll(".apparat").forEach((e) => e.style.display = 'none');
        document.querySelectorAll("." + witnessClass).forEach((e) => e.style.display = 'inline');
        this.hideLacunas(witnessClass);
    }

    witnessTooltiping() {
        document.querySelectorAll('[data-witness]').forEach((e) => {
            let wlist = e.getAttribute("data-witnesses").replace(" ", ", ");
            e.setAttribute("title", wlist);
        })
    }

    hideLacunas(witId) {

        /*masque les lacunas à partir des lacunaStarts
          - cherche la lacuneEnd correspondante
          - Si la lacunaEnd n'existe pas (elle se trouve dans un autre fragment),
           l'intégralité du texte suivant est masqué
        */
        document.querySelectorAll('.lacunaStart').forEach((lstart) => {
            if (lstart.getAttribute('data-lacuna-wit').indexOf('\#' + witId) > -1) {
                //on echappe les . et # de l'id cible de la lacunaEnd correspondante
                let searchedId = lstart.getAttribute('data-lacuna-synch');//.replace(/([#.])/g,'\\$1');
                console.log("searchedid ", searchedId);
                let endElement = document.getElementById(searchedId);
                console.log('traitement de la lacuna ' + lstart.getAttribute('id'));
                endElement = endElement.length === 0 ? document.getElementById('bas_de_page') : endElement
                let eltsBetween = this.getElementsBetweenTree(lstart, endElement);//$(self.getElementsBetweenTree(($(this))[0], endElement[0]))
                console.log("Nombre d'éléments à masquer (lacune " + lstart.getAttribute('id') + ")" + eltsBetween.length);
                eltsBetween.forEach((elt) => {
                    let span = document.createElement("span");
                    span.classList.add('generated_lacuna');
                    span.append(elt.cloneNode(true));
                    elt.replaceWith(span);
                })
            }
        })


        /*Cas où un couple lacunaStart/lacunaEnd se trouve respectivement dans
        des fragments qui précédent et suivent le fragment courant:
        nécessite une requête sur la DB pour accedéer aux autres noeuds XML*/

    }

    getElementsBetweenTree(start, end) {
        let ancestor = this.commonAncestor(start, end);

        let before = [];
        while (start.parentNode !== ancestor) {
            var el = start;
            while (el.nextSibling)
                before.push(el = el.nextSibling);
            start = start.parentNode;
        }

        var after = [];
        while (end.parentNode !== ancestor) {
            var el = end;
            while (el.previousSibling)
                after.push(el = el.previousSibling);
            end = end.parentNode;
        }
        after.reverse();

        while ((start = start.nextSibling) !== end)
            before.push(start);
        return before.concat(after);
    }


    ancestors(node) {
        let nodes = []
        for (; node; node = node.parentNode) {
            nodes.unshift(node)
        }
        return nodes
    }

    commonAncestor(node1, node2) {
        let parents1 = this.ancestors(node1)
        let parents2 = this.ancestors(node2)

        if (parents1[0] !== parents2[0]) throw "No common ancestor!"

        for (var i = 0; i < parents1.length; i++) {
            if (parents1[i] !== parents2[i]) return parents1[i - 1]
        }
    }


    docWithApparat() {
        return document.querySelectorAll("#text .apparat, #text .lacunaStart, #text .lacunaEnd").length > 0
    }

}

let apparat = new ApparatPlugin('Apparat')
window.apparat = apparat;
MAX.addPlugin(apparat);
