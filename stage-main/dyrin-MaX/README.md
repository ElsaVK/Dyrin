# MaX

Le Moteur d'Affichage XML est une interface de lecture de sources XML développé par l'[Université de Caen Normandie](http://www.unicaen.fr) ([Pôle Document Numérique](http://www.unicaen.fr/recherche/mrsh/document_numerique) / [CERTIC](https://www.certic.unicaen.fr)) notamment dans le cadre de l'Equipex [Biblissima](http://www.biblissima-condorcet.fr/)

## Licence

voir [legal.txt](legal.txt)

## Participer au développement

Demander à rejoindre [MaX-Community](https://git.unicaen.fr/MaX-Community).

## Contacts

Vous pouvez nous contacter via [contact.certic@unicaen.fr](mailto:contact.certic@unicaen.fr?subject=[MaX])

---

## Prérequis

- Java 8+

- NodeJS (et npm) 10+

- BaseX 9.2+

## Installation

```bash
$ cd tools && ./max.sh -i # will init your max dev env, download and install saxon + fop jar dependencies
# change dir to your basex app folder
$ cd </path/to/basex>/webapp
# create a symlink on your MaX instance
$ sudo ln -s /path/to/max .
# run basex http
$ cd </path/to/basex>/bin
$ ./basexhttp
# then check your install at: http://localhost:8984/max.html
```

### Édition de démonstration

```bash
$ cd tools

# set the env var $BASEX_PATH only if the basexclient command is not in your PATH. Useless
# if basex was install with your system package manager
# The basex dir must contains the bin subfolder
$ export BASEX_PATH=/path/to/basex
```

```bash
$ ./max.sh --d-tei

or 

$ ./max.sh --d-ead
```

L'édition de démonstration TEI est consultable à **http://localhost:8984/max_tei_demo/accueil.html**

## Paramétrage et customisation

La documentation utilisateur est disponible [ici](https://pdn-certic.pages.unicaen.fr/max-documentation/).




![UNICAEN-PDN-CERTIC](https://www.certic.unicaen.fr/ui/images/UNICAEN_PDN_CERTIC.png)

[![IA](http://medites.fr/partenaires/investissement-avenir/@@images/d94128c2-f712-4712-9659-a86f6f8f36c5.jpeg)](http://www.agence-nationale-recherche.fr/investissements-d-avenir/)
![Biblissima](http://asynchrone.fr/sites/default/files/projet/logo/biblissima-logo.png)
