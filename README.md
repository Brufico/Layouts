---
title: Experiments with document layout and features
author: Bruno Fischer Colonimos
date: 15/07/2017
---

# as of now : 16/07/2017

## file versions

* A2_testcross3_Latex.Rmd ==> A2_testcross3B.Rmd ==> A2_testcross3C.Rmd

crossrefs fonctions réécrites, mais cul-de-sac pour HTML. :
- par rapport à la situation d'Andy Lyons, on ne peut plus localiser les créations de
graphes en recherchant la fonction de captionning, même plus dans les options de chunks.
==> beaucoup plus dur.

une idée serait de générer un pdf, et de parser
a) la table des matières
b) la liste des figures
c) la liste des tableaux

Trop de travail.

Décision: revenir sur de simples liens dans tous les cas en HTML, dans les versions futures.

OU BIEN: générer au fil de l'eau une table des figures (et une table des tableaux) et la (les) sauvegarder en fin de document. A la prochaine compilation, vérifier la présence du ficher et , s'il existe, en tirer les paramètre de référence (n0 de figure + etiquette correspondante.) Pas mal.


tests HTML dans knithtml_minimal.Rmd
prochaine version du fichier principal: B0_testcross.Rmd





# as of now : 15/07/2017

## important files:

* A2_Exp_figures_crossrefs 10.Rmd : contains
    * definitions for figure sizes
    * some functions for accessing context: chunk names, options, & captioning / control of flotation
* A2_testcross3_Latex.Rmd : contains
    * many exeriments for cross-referencing things in LaTex (from Markdown)
* A2_HTML_Crossrefs_Lyons.Rmd : contains
    * The code of Andy Lyons for cross-referencing figures in HTML more or less heavily modified.
* A2_HTML_Crossrefs_Thell.Rmd : contains
    * The code of Bo Thell for cross-referencing "things" in HTML more or less heavily modified.
* latex_temp2.latex = modified latex template
