# Intro
NIFSTD development uses this repo, git (GitHub), pyontutils (Python3.6), Protege, ELK, FACT++, and InterLex.

NIFSTD development also uses SciGraph (Java8), and OWLAPI (see pyontutils for more information).

## git
If you have not used git before please follow [this guide](https://help.github.com/articles/set-up-git/).
**We do not accept pull requests with commits that do not have an email address.** Please be sure to
[set your commit email](https://help.github.com/articles/setting-your-commit-email-address-in-git/).
**NOTE:** If you have not participated in open source development before I often
recommend creating a new email specifically for all development related activities.
If you have never used git before check out the
[git bootcamp guides](https://help.github.com/categories/bootcamp/)
and if you have never used GitHub before check out the
[GitHub guides](https://guides.github.com/).

## repo
If you do not have push rights to
[SciCrunch/NIF-Ontology](https://github.com/SciCrunch/NIF-Ontology),
[fork](https://github.com/SciCrunch/NIF-Ontology#fork-destination-box)
the repo so that you can push somewhere that can submit
[pull requests](https://github.com/SciCrunch/NIF-Ontology/pull/new/master).
```bash
cd ~/git/
git clone https://github.com/${github_username}/NIF-Ontology.git
# OR if you have push rights to the SciCrunch org repo
git clone https://github.com/SciCrunch/NIF-Ontology.git
```
My default development setup assumes that all git repos live in `~/git/`, so if your setup
is different you should adjust accordingly. Note that many of the scripts in pyontutils
avoid this issue by using `/tmp/` as the default location for local git repos and the
`--git-local` option can be used to adjust accordingly. However, not all scripts have been
updated with these assumptions, so if you encounter a `FileNotFoundError` that is likely the
cause.

## pyontutils
Install [pyontutils](https://github.com/tgbugs/pyontutils) by following the installation instructions
[here](https://github.com/tgbugs/pyontutils/blob/master/README.md#installation).

## Protege
Download and install the latest version of Protege [here](http://protege.stanford.edu/products.php#desktop-protege).

**NIFSTD is a very large ontology which requires more memory than the Protege defaults.**

Modify how your OS's equivalent of `run.sh` launches java to `jre/bin/java -Xmx8G -Xms500M \`
(or similar).

## Reasoners (ELK, FACT++)
You can obtain copies of ELK and FACT++ but launching protege and in the
menu bar File -> Check for plugins and select ELK and FACT++. **NOTE:**
that sometimes the plugin repos don't resolve, if that happens try again.
Otherwise you can get the reasoner plugins and put them in `Protege-*/plugins/`.
### ELK
Get the latest version of `elk-distribution-*-protege-plugin.zip` from https://github.com/liveontologies/elk-reasoner/releases.
Or get the latest version of https://mvnrepository.com/artifact/org.semanticweb.elk/elk-owlapi.
### FACT++
Get the latest version of `uk.ac.manchester.cs.owl.factplusplus-*.jar` from https://bitbucket.org/dtsarkov/factplusplus/downloads/.

## InterLex
[InterLex](https://interlex.org/) provides all new identifiers for NIFSTD.
You will need a [SciCrunch account](https://scicrunch.org/register) in order to
access the InterLex web api and to use InterLex to create new terms.
**NOTE:** At the moment only curators can add terms so let us know if you need access.
