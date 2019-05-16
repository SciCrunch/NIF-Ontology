# Intro
This file documents
the steps needed to create
a working development environment
for NIFSTD.

NIFSTD development uses this repo, git (GitHub), pyontutils (Python3.6), Protege, ELK, FACT++, and InterLex.

NIFSTD development also uses SciGraph (Java8), and OWLAPI (see pyontutils for more information).

If you need more details than provided by this document,
[setup.org](https://github.com/SciCrunch/sparc-curation/blob/master/docs/setup.org)
provides an exhaustive guide to setting up all NIF related tools.

## git
Set up git. [This guide can be helpful.](https://help.github.com/articles/set-up-git/).

**We only accept pull requests with commits that have an email address.**  

Please be sure to
[set your commit email](https://help.github.com/articles/setting-your-commit-email-address-in-git/).  
**NOTE:** If you are new to open source development I recommend
creating a new email specifically for all development related activities.

If you have never used git before check out the
[git bootcamp guides](https://help.github.com/categories/bootcamp/)
and if you have never used GitHub before check out the
[GitHub guides](https://guides.github.com/).

## repo
If you do not have push rights to
[SciCrunch/NIF-Ontology](https://github.com/SciCrunch/NIF-Ontology), please
[fork](https://github.com/SciCrunch/NIF-Ontology/fork)
the repo so that you can push commits to a remote that can submit
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

## ttlfmt
If you are working in Protege then you will need the `ttlfmt` tool to
format the files you change to match the conventions used in the ontology.
You will need `>=python-3.5` installed on your system. In a terminal run
`pip3 install ttlser[ttlfmt]`. This will install the `ttlfmt` command and you
can format files from the ontology by running `ttlfmt my-ontology-file.ttl`.
Adjust the pip install command to match your system as needs be.

## nifstd-tools and friends
If you need the python codebase that supports the ontology please follow the instructions
Install [nifstd-tools](https://github.com/tgbugs/pyontutils/blob/master/nifstd/#development-installation) by following the installation instructions
[here](https://github.com/tgbugs/pyontutils/blob/master/README.md#installation).

## Protege
Download and install the latest version of Protege [here](http://protege.stanford.edu/products.php#desktop-protege).
You need `>=protege-5.5.0` because all pevious versions have a nasty bug
that mangles the iris in nifstd ttl files when you try to save your changes.

**NIFSTD is a very large ontology which requires more memory than the Protege defaults.**

Modify `run.sh` (or equivalent) so that it launches java with `jre/bin/java -Xmx8G -Xms500M \`
(or similar). If you do not you will see the following line in the protege logs:  
`An error occurred whilst loading the ontology at Java heap space. Cause: {}`.

Make sure that **Expand trees by default is disabled** in menu `File -> Preferences -> General`
otherwise load times can stretch on for many minutes.

## Catalog
There is an example ontology catalog [catalog-v001.xml.example](./../ttl/catalog-v001.xml.example)
that should be installed by running `cp catalog-v001.xml.example catalog-v001.xml`. The file itself
is not tracked to prevent conflicts when switching branches.

## Reasoners
You can obtain copies of ELK and FACT++ by launching protege and going to
menu bar `File -> Check for plugins` and selecting ELK and FACT++.
**NOTE:** sometimes the plugin repos don't load, if that happens try again.
Otherwise you can download the reasoner plugins and put them in `Protege-*/plugins/`.
### ELK
Get the latest version of `elk-distribution-*-protege-plugin.zip` from https://github.com/liveontologies/elk-reasoner/releases.
Or get the latest version of https://mvnrepository.com/artifact/org.semanticweb.elk/elk-owlapi.
### FACT++
Get the latest version of `uk.ac.manchester.cs.owl.factplusplus-*.jar` from https://bitbucket.org/dtsarkov/factplusplus/downloads/.

## InterLex
[InterLex](http://interlex.org/) provides all new identifiers for NIFSTD.
You will need a [SciCrunch account](https://scicrunch.org/register) in order to
access the InterLex web api and to use InterLex to create new terms.
**NOTE:** At the moment only curators can add terms so let us know if you need access.
