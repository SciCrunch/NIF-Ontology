# Intro
All of these processes expect the full NIF-Ontology development
environment to have been set up according to `development setup.md`.

# DO NOT PUSH TO MASTER
The `master` branch serves the 'live' resolvable ontology files

Please do not push to the master branch.

Please submit a pull request (even if it is from another branch
in the SciCrunch org repo) so that we can run all the requisite
checks to make sure that the ontology is consistent.

## Prior to commit
```bash
ttlfmt $(git status -s | grep ttl | grep M | cut -d' ' -f3)
qnamefix $(git status -s | grep ttl | grep M | cut -d' ' -f3)
```
## Adding a new external import
All external imports should be imported into NIFSTD via a bridge file.
This file will hold any local additions that we want to make.
1. Create a new bridge file by copying an existing bridge file and modifying
   as needed to import the external file from its canonical iri, and to import
   `filename-dead.ttl`.
2. Add an entry in `catalog-extras` for the new import.
3. Create `generated/filename-dead.ttl` by running `necromancy http://myurl.org/filename.owl`.
4. Whenever there is a new release repeat step 3.

## Changing an ontology file
1. Edit your file and save.
2. If using protege `git diff` to make sure that any new triples
   have landed in the correct file.
3. Execute prior to commit processes.

## Adding a new ontology file
```bash
touch filename.ttl
add filename.ttl
`make_catalog`  # NOTE this is broken at the moment
```
1. Add an entry in `ttl/catalog-v001.xml` by hand.

Before you run `make_catalog` make sure that the import chain is local (unpatched)
otherwise it will take an extremely long time to fetch files.

## Load remote imports local copies
Sometimes we don't want to have to retrieve remote copies of files every time
we start protege, or we need to run tests for patches that are applied to external
imports when loading the ontology into SciGraph.
```bash
cd ttl/
cat <(head -n -1 catalog-v001.xml) ../catalog-extras <(tail -n 1 catalog-v001.xml) > catalog-new
mv catalog-new catalog-v001.xml
```

## Running the reasoner
```bash
cd ttl/
patch -p2 -i ../dev-reasoner.patch
protege
```
1. Open NIF-Ontology/ttl/nif.ttl
2. Make sure reasoner is set to ELK
3. Ctrl-R

Protege does not have to be run from `ttl/` in order to find `ttl/catalog-v001.xml`,
however the file opened must be in `ttl/`.

## Check for incorrect or unimported predicates
1. Remove `/tmp/ttlcmp.patch` if it exists
2. `ttlcmp.sh`
3. Review `/tmp/ttlcmp.patch` for annotation and object properties.
