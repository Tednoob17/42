# EPIAG Pool

Piscine et modules hors-piscine construits autour de
`every-patch-is-a-guess-full.txt` : lire un correctif comme une hypothèse,
trouver les chemins qui n'ont pas reçu la même vérification, puis trier les
candidats sans transformer l'analyse en exploitation.

## Principes

- Un correctif encode une hypothèse sur le passé : « le bug était ici, sur
  ce chemin, sous cette condition ».
- La question centrale est toujours : **quel invariant le patch ajoute-t-il,
  et où le même invariant manque-t-il ?**
- Aucun module ne demande d'exploit weaponisé. Les labs sont locaux, isolés
  et autorisés.
- Chaque rendu doit contenir les commandes permettant de refaire l'analyse.
- Un faux positif bien argumenté vaut mieux qu'un twin inventé.

## Structure

```text
epiag-pool/
|-- 01-piscine/        # 7 jours, progression guidée
|-- 02-hors-pool/      # modules avancés, 2 à 3 jours chacun
|-- RESEARCH.md        # sources 2024-2026 et matrice d'intégration
+-- resources/latex/   # classes, macros, assets, Makefile LaTeX
```

## Piscine

| Module | Titre | Format | Points |
|---|---|---|---|
| `M-EPI-000-patch-anatomy` | Anatomie d'un patch | 4 exercices | 16 |
| `M-EPI-001-mutation-model` | Le modèle de mutation | 4 exercices | 16 |
| `M-EPI-002-differential-audit-loop` | La boucle d'audit différentiel | 4 exercices | 16 |
| `M-EPI-003-nf-tables` | nf_tables : dispersion architecturale | 5 exercices | 20 |
| `M-EPI-004-ebpf-io-uring` | eBPF et io_uring : oracle et proxy | 5 exercices | 20 |
| `M-EPI-005-rush-variant-hunt` | Rush — Variant Hunt | 1 jour | 20 |
| `M-EPI-006-exam-unseen-patch` | Exam — Unseen Patch | 3 h | 20 |

## Hors-piscine

| Module | Titre | Format | Points |
|---|---|---|---|
| `A-EPI-001-patch-diffing` | Patch Diffing et archéologie | 5 exercices | 22 |
| `A-EPI-002-nftables-variant-hunting` | nf_tables : chasse aux variantes | 5 exercices | 22 |
| `A-EPI-003-ebpf-io-uring-audit` | eBPF et io_uring : audit avancé | 5 exercices | 23 |
| `A-EPI-004-windows-auth-chain` | Windows : réflexion et frontières | 5 exercices | 22 |
| `A-EPI-005-conference-reproduction` | Reproduire et présenter le papier | 5 exercices | 22 |
| `A-EPI-006-warmups-cross-domain` | Node.js, MINA, FreeBSD : warm-ups croisés | 5 exercices | 20 |

## Compiler

Chaque module contient un `subject/Makefile` autonome :

```sh
make -C 01-piscine/M-EPI-000-patch-anatomy/subject
make -C 02-hors-pool/A-EPI-001-patch-diffing/subject
```

Le Makefile produit un PDF nommé `<MODULE>_fr.pdf`. Il faut
`pdflatex` et `-shell-escape` (déjà configuré). Les sources LaTeX sont en
français ; les identifiants de modules, de fichiers et de fonctions restent
en anglais.

Compiler toute la piscine et le hors-pool :

```sh
make
```

Nettoyer les artefacts :

```sh
make clean
```

## Prérequis

- Shell Linux, `git`, `grep`, `ctags`.
- Bases de C et, pour les modules avancés, lecture de code noyau.
- Pour `A-EPI-004` : un laboratoire Active Directory simulé et isolé.
- Pour `A-EPI-005` : Python 3 et le dépôt compagnon du papier.
- Pour `A-EPI-006` : Node.js, sources Java/Apache MINA et avis FreeBSD.

## Sources

- `every-patch-is-a-guess-full.txt`, Phrack Vol. 0x10, Issue 0x49,
  Phile 0x01.
- Dépôt compagnon : `rules/`, `validation/`, `classifier/`.
- Project Zero : emergency patching, dangling COM registrations, race
  testing avec MAccConc.
- OtterSec : OtterRoot (`CVE-2024-26809`) et patch gap mobile V8.
- Calif : Dark Elevator (`CVE-2026-50343`).
- Synacktiv : réflexions d'authentification, eBPF et io_uring.
- Node.js : `path.normalize`, lecteurs, périphériques et UNC.
- Apache MINA : désérialisation, allowlist et branches 2.0/2.1/2.2.
- FreeBSD/XNU : mappings cross-kernel de la section 18.11.
- NVD, Microsoft, Semperis et documentation noyau pour les CVE citées.

La cartographie complète des sources et des exercices se trouve dans
`RESEARCH.md`.

## État

Les 13 modules sont rédigés, enrichis par les sources 2024-2026 de
`RESEARCH.md`, couvrent tous les exemples du papier et compilent. Les 52
configurations `pendragon` des exercices sont générées ; le rush et l'examen
n'en ont pas, car ce sont des formats de soutenance et non des exercices à
rendu fichier.
