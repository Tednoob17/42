# EPIAG Research Dossier

Ce dossier relie les modules au corpus de recherche 2024-2026. Il sert de
carte de sources, pas de recueil d'exploits : chaque note doit pouvoir être
transformée en exercice défensif, en question d'audit ou en critère de
triage.

## Méthode

Pour chaque source :

1. identifier l'affirmation principale ;
2. séparer la root cause du chemin d'exploitation ;
3. repérer ce que le correctif suppose ;
4. chercher le chemin voisin qui ne reçoit pas la même supposition ;
5. transformer le tout en exercice reproductible et sans cible réelle.

## Sources principales

| Source | Date | Apport | Modules |
|---|---|---|---|
| Project Zero, *How to fix a bug in a fix* | 2026-10-06 | Anatomie du patch d'urgence, patch gap opérationnel | A-EPI-001, A-EPI-005 |
| Project Zero, *Windows Exploitation Techniques: Dangling COM Object Registrations* | 2026-09-21 | Correctif incomplet, COM orphelin, frontière SYSTEM | A-EPI-004 |
| Project Zero, *Testing race conditions with memory access tracing and stack-based delay injection* | 2026-09-08 | Confirmation de races, tests de régression, ordonnancement contrôlé | A-EPI-003, M-EPI-004 |
| OtterSec, *OtterRoot: Netfilter universal root 1-day* | 2024-11-25 | Patch gap noyau, double-free pipapo, root cause multi-commit | A-EPI-002, A-EPI-001 |
| OtterSec, *Patch gap to mobile renderer RCE* | 2026-04-01 | Dépendance V8 ancienne, patch gap mobile, UXSS | A-EPI-005, A-EPI-001 |
| Calif, *Dark Elevator: Windows Install Service LPE* | 2026-07-22 | Bug purement logique, carte de plugins inscriptible, COM plantable | A-EPI-004 |
| Synacktiv, *The Gift That Keeps on Giving* | 2026-05 | Réflexions d'authentification et limites des mitigations | A-EPI-004 |
| Node.js, security releases 2025 | 2025-01 / 2025-07 | `path.normalize`, lecteurs, périphériques, UNC | A-EPI-006 |
| Apache MINA, avis CVE-2024-52046 / CVE-2026-41409 / CVE-2026-42778 | 2024-2026 | Désérialisation, allowlist, branches 2.0/2.1/2.2 | A-EPI-006 |
| FreeBSD, CVE-2026-42511 et CVE-2026-4747 | 2026 | Portée cross-kernel, mappings `cross-kernel/` | A-EPI-006 |

## Project Zero : emergency patching

Source : <https://projectzero.google/2026/10/emergency-patching.html>

Natalie Silvanovich décrit les étapes minimales d'un correctif :

- triage ;
- développement du patch ;
- tests ;
- revue par des partenaires ;
- livraison ;
- activation, parfois avec redémarrage.

Le point utile pour EPIAG est que ces étapes sont un pipeline, pas un
événement. Un patch peut être écrit mais non livré ; livré mais non activé ;
ou activé seulement sur une partie du parc. Le patch gap n'est donc pas
seulement « commit amont vers stable », c'est aussi « correctif disponible
vers correctif réellement appliqué ».

Mécanismes d'urgence cités :

- **feature flags** : désactiver une fonctionnalité sans livrer de nouveau
  code ;
- **dual stack** : embarquer deux versions d'une bibliothèque et basculer
  par configuration ;
- **filtering** : bloquer les entrées qui atteignent la vulnérabilité ;
- **canaux de mise à jour alternatifs** : réduire le délai de livraison.

Ils réduisent l'exposition, mais ils ne prouvent pas que la root cause est
fermée. Un module doit donc distinguer :

- correction complète ;
- correction partielle ;
- atténuation d'urgence ;
- simple réduction de surface.

## Project Zero : dangling COM object registration

Sources :

- <https://projectzero.google/2026/09/windows-dangling-com.html>
- <https://blog.calif.io/p/dark-elevator-windows-install-service>

Le cas est une chaîne en deux temps.

### CVE-2026-50343, « Dark Elevator »

Deux défauts logiques :

1. `InstallService`, service SYSTEM, lit `StaticPluginMap`, une clé de
   registre que tout utilisateur normal peut modifier.
2. Une classe COM fournie par Windows, CrossDevice
   `{E9F83CF2-E0C0-4CA7-AF01-E90C70BEF496}`, pointe vers une DLL située sous
   `%PROGRAMDATA%\CrossDevice\CrossDevice.Streaming.Source.dll`. Le dossier
   est inscriptible par un utilisateur normal et la DLL peut ne pas exister.

Le service charge donc une DLL contrôlée dans son propre processus SYSTEM.
Le bug est purement logique : pas de corruption mémoire, pas d'admin, pas
d'UAC, pas de redémarrage. Calif indique un test sur Windows 11 build
`10.0.26200.8457` et une correction le 2026-07-14.

### CVE-2026-66804, correctif incomplet

Project Zero montre que le correctif de `InstallService` ne supprime pas le
problème de fond : l'enregistrement COM CrossDevice reste orphelin et pointe
toujours vers un chemin inscriptible. Le correctif ferme le chemin
`InstallService`, pas la classe COM dangereuse.

La leçon EPIAG est directe :

- le premier correctif encode l'hypothèse « le problème est la carte de
  plugins » ;
- l'hypothèse manquante est « l'enregistrement COM lui-même est une
  frontière de confiance » ;
- un autre chemin privilégié peut encore charger la classe.

Le suivi Project Zero utilise un second mécanisme, le marshaling COM, pour
montrer que la classe reste atteignable. Le module doit expliquer la classe
de bug sans fournir de chaîne d'exploitation.

## Project Zero : race testing

Source : <https://projectzero.google/2026/09/maccconc-race-condition.html>

Jann Horn décrit MAccConc, un outil pour explorer les entrelacements de
threads dans le noyau Linux.

Idées pédagogiques :

- une course n'est pas prouvée par un `sleep()` ajouté au hasard ;
- il faut identifier des **communication points** : accès mémoire qui se
  chevauchent, avec au moins une écriture ;
- ASAN en mode outline fournit un hook par accès mémoire ;
- KCOV transporte les traces vers l'utilisateur ;
- les traces sont identifiées par des **count-augmented stack traces**, plus
  stables que les adresses de données ;
- l'injection de délai `DI_STACK_WAKE_PRE`, `DI_STACK_WAIT`,
  `DI_STACK_WAKE_POST` force un ordre A-happens-before-B ;
- l'outil automatique teste les entrelacements A-B-A ;
- l'approche historique de Jann Horn reste le `mdelay()` conditionnel par
  nom de thread, utile pour confirmer une course mais coûteux en essais.

Limites à enseigner :

- MAccConc n'est pas encore entièrement upstream ;
- il faut LLVM 23.1.0 et un noyau patché ;
- ASAN ne couvre pas tous les accès à la pile ni aux globales ;
- le travail de fond (RCU, callbacks) n'est pas toujours couvert par KCOV ;
- un test de course réussi n'est pas un exploit : c'est une preuve
  d'ordonnancement.

## OtterSec : OtterRoot et CVE-2024-26809

Source : <https://osec.io/blog/netfilter-universal-root-1-day/>

Le cas est un double-free dans `nft_set_pipapo.c`.

### Root cause

- `nft_pipapo_destroy()` peut appeler `nft_set_pipapo_match_destroy()` deux
  fois : une fois sur `priv->match`, une fois sur `priv->clone`.
- Le clone contient une vue des éléments déjà commités et des éléments non
  commités.
- `priv->dirty` devient vrai quand un élément est inséré dans le set.
- `priv->dirty` est normalement remis à faux par `nft_pipapo_commit()`.
- Si le set est marqué `set->dead`, le chemin de commit saute l'appel à
  `->commit()`.
- `priv->dirty` reste donc vrai et la destruction libère deux fois les
  éléments déjà commités.

### Archéologie

- Le correctif est `b0e256f3dd2ba6532f37c5c22e07cb07a36031ee`.
- Le code fautif vient de `9827a0e6e23bf43003cd3d5b7fb11baf59a35e1e`.
- Le drapeau `set->dead`, qui rend le chemin atteignable, vient de
  `5f68718b34a531a556f2f50300ead2862278da26`, plus d'un an après.
- Le bug n'est donc pas « un correctif copié » : c'est une interaction
  entre une hypothèse de nettoyage et un nouveau chemin de commit.

### Patch gap

Chronologie donnée par OtterSec :

- 21 mars : patch public ;
- 23 mars : repérage du correctif ;
- 24 mars : exploit KernelCTF ;
- 26 mars : exploit universel ;
- 23 mai : arrivée du patch sur Ubuntu et Debian.

Le cas mesure un patch gap d'environ deux mois. Il montre aussi que le
correctif amont n'est pas le début de la protection : la distribution et le
parc utilisateur comptent.

### Techniques d'exploitation à ne pas reproduire

OtterSec détaille UAF, KASLR via `nft_object`, contournement de section
critique RCU, `msg_msg`, `pipe_buffer` et `modprobe_path`. EPIAG doit
seulement en retenir les primitives et les questions d'audit :

- qui possède l'objet ;
- quand est-il libéré ;
- quel chemin peut encore le référencer ;
- quel drapeau change la validité d'une hypothèse de nettoyage.

## OtterSec : patch gap mobile et V8

Source : <https://osec.io/blog/patch-gap-to-mobile-renderer-rce/>

Samsung Internet sur Galaxy S25 embarquait V8 `13.6.233.10`, déjà vieux de
six mois. Les chercheurs ont choisi `CVE-2025-10891`, un bug dans
l'interpréteur Ignition.

Point technique utile :

- la table de handlers try/catch stocke l'offset du handler dans un champ de
  28 bits ;
- un offset trop grand est tronqué silencieusement ;
- le contrôle saute alors au milieu d'une instruction ;
- l'exploitation utilise le bytecode comme surface de confiance, puis
  `DeserializeWasmModule` et du « constant smuggling » ;
- le résultat est un RCE dans le renderer, puis un UXSS via
  `Builtins_ConstructFunction`.

La leçon EPIAG n'est pas la chaîne d'exploitation. C'est la question :

> Une dépendance qui n'a pas été mise à jour transforme un correctif public
> en porte d'entrée n-day. Qui vérifie la version réellement embarquée ?

## Calif : Dark Elevator

Source : <https://blog.calif.io/p/dark-elevator-windows-install-service>

Le cas complète A-EPI-004 parce qu'il ne ressemble pas aux CVE de réflexion
NTLM. La frontière n'est pas un protocole d'authentification, c'est une
frontière de chargement :

- un service SYSTEM ;
- une carte de plugins inscriptible ;
- une classe COM dont le serveur in-process est plantable ;
- un dossier `ProgramData` accessible à tous.

C'est un « Logical Engine » pur : aucune corruption mémoire, aucun timing
fragile, aucun privilège préalable. Le correctif ferme le chemin
`InstallService`, mais Project Zero montre que la classe COM reste un
problème séparé.

## Synacktiv

Sources repérées :

- <https://www.synacktiv.com/publications> ;
- <https://www.synacktiv.com/sites/default/files/2026-05/bypassing_authentication_reflections_mitigations_for_system_shells.pdf> ;
- <https://synacktiv.com/en/publications/linkpro-ebpf-rootkit-analysis> ;
- <https://synacktiv.com/en/publications/building-a-iouring-based-network-scanner-in-rust>.

Apports possibles :

- réflexions d'authentification et limites des mitigations ;
- eBPF comme outil d'observation et de dissimulation, pas seulement comme
  cible du vérificateur ;
- io_uring comme architecture de files SQ/CQ, utile pour comprendre le
  cycle de vie avant d'étudier les CVE.

L'article AD « simuler des services Active Directory légitimes » reste à
retrouver avec son slug exact avant citation.

## Node.js : path.normalize et sémantique Windows

Source : section 13.1 du papier ; avis Node.js de janvier et juillet 2025.

Le prédicat `path.normalize()` est un Predictive Oracle. Il modélise une
partie du chemin, pas toute la sémantique du système de fichiers Windows.

- `CVE-2025-23084` : les noms de lecteur (`C:`, `D:`) ne sont pas traités
  comme spéciaux. `C:..\sensitive` est relatif au répertoire courant du
  lecteur, pas au sous-arbre attendu.
- `CVE-2025-27210` : les noms de périphériques (`CON`, `PRN`, `AUX`, `NUL`,
  `COM1-9`, `LPT1-9`) ne sont pas filtrés. Le noyau les traite comme des
  fichiers de périphérique.
- UNC non assigné : après le filtrage des périphériques, les chemins
  `\\serveur\partage\..\sensitive` restent valides.

Chaque correctif ajoute une règle au modèle. Le troisième cas montre que le
modèle n'est toujours pas complet. C'est un `architectural scatter` dans une
seule fonction, structurellement proche de `CVE-2020-27194 -> CVE-2021-3490`.

## Apache MINA : désérialisation et ordre des transitions

Source : section 13.2 du papier ; avis Apache MINA.

Le désérialiseur est un Logical Engine :

```text
allocate -> initialize -> resolve -> check
```

- `CVE-2024-52046` : aucun filtrage de classe avant l'instanciation.
- `CVE-2026-41409` : l'allowlist est évaluée après l'exécution des
  initialiseurs statiques ; une classe autorisée peut donc exécuter du code
  avant la garde.
- `CVE-2026-42778` : le correctif est complet sur 2.0.x mais incomplet sur
  2.1.x et 2.2.x ; une seconde vague de versions est nécessaire.

La question d'audit est celle de tous les Logical Engines : la garde est-elle
appliquée à toutes les transitions équivalentes, ou seulement à celle où le
bug a été observé ?

## FreeBSD et XNU : portée cross-kernel

La section 18.11 cite `CVE-2026-42511` (`dhclient`) et `CVE-2026-4747`
(NFS) pour FreeBSD, ainsi que IOKit `IOUserClient` et Mach IPC pour XNU. Les
détails sont annoncés dans `cross-kernel/` de l'archive, pas dans le corps du
papier.

Ces cas doivent être traités comme des **mappings** :

- ne pas affirmer qu'ils sont démontrés comme nf_tables/eBPF/io_uring ;
- vérifier les avis publics avant de reprendre un mécanisme ;
- distinguer la classification probable de la preuve expérimentale.

## Matrice d'intégration

| Module | Source | Modification |
|---|---|---|
| A-EPI-001 | Project Zero emergency patching | Ajouter la distinction correction / atténuation / activation |
| A-EPI-001 | OtterRoot, V8 | Ajouter deux chronologies de patch gap |
| A-EPI-002 | OtterRoot | Ajouter CVE-2024-26809 et l'archéologie multi-commit |
| A-EPI-003 | Project Zero MAccConc | Ajouter la méthode de confirmation de course |
| A-EPI-004 | Calif + Project Zero | Ajouter Dark Elevator et CVE-2026-66804 |
| A-EPI-005 | Toutes | Ajouter patch gap, correctif incomplet et Q&A |
| M-EPI-003 | OtterRoot | Ajouter une question de comparaison pipapo |
| M-EPI-004 | Project Zero MAccConc | Ajouter la question « sleep vs ordonnancement » |
| A-EPI-006 | Node.js, MINA, FreeBSD | Couvrir les warm-ups et mappings absents des autres modules |
| Tous | Papier + sources | Ajouter une section « Ressources par exercice » avec liens et requêtes |

## Décision de structure

Décision initiale : pas de nouveau module `A-EPI-006`, car le patch gap et
les correctifs incomplets étaient déjà couverts par A-EPI-001, A-EPI-002,
A-EPI-003 et A-EPI-005.

Décision révisée : créer `A-EPI-006-warmups-cross-domain` pour couvrir les
exemples du papier qui ne sont ni du noyau Linux ni Windows :

- Node.js `CVE-2025-23084`, `CVE-2025-27210` et bypass UNC ;
- Apache MINA `CVE-2024-52046`, `CVE-2026-41409`, `CVE-2026-42778` ;
- FreeBSD `CVE-2026-42511`, `CVE-2026-4747` et mappings XNU.

Ce module n'est pas un doublon : il sert de raccord cross-domain et de
vérification exhaustive de la carte des exemples. Il porte aussi la
distinction entre ce que le papier démontre, observe, cartographie et
extrapole.

## Guide de lecture

Le PDF `00-guide/PAPER-GUIDE-paper/subject/PAPER-GUIDE-paper_fr.pdf`
contient la thèse, les trois familles, le modèle de mutation, la boucle
d'audit, les hypothèses cas par cas, les limites et une carte exhaustive des
exemples. Il sert de support de soutenance et de référence pour les modules.
Aucun support élève ne dépend d'un Markdown.

## Limites et recherches restantes

- Retrouver l'article Synacktiv sur les services AD légitimes.
- Vérifier le cas `CVE-2021-3492` (shiftfs) et son lien avec les courses.
- Parcourir l'archive Project Zero pour d'autres cas de correctifs
  incomplets.
- Vérifier les builds Windows exacts avant de citer un chiffre.
- Ne pas transformer les détails d'exploitation OtterSec ou V8 en tutoriel.

## Règles de sécurité

- Pas d'exploit weaponisé.
- Pas de cible de production.
- Pas de domaine AD réel.
- Pas de chargement eBPF sur une machine partagée.
- Les tests de course restent dans une VM ou un noyau instrumenté.
- Chaque exercice doit produire une preuve reproductible et des limites.
