# Intro
This file documents
the development processes
that have not (yet) been automated
and
the practices that developers should follow
when working on NIFSTD.

All of these processes expect the full NIF-Ontology development
environment to have been set up according to [development setup.md](development%20setup.md).

All relative filepaths listed in code sections start from the base
folder of this repository `../` from the location of this file.

# DO NOT PUSH TO MASTER
The `uri.neuinfo.org` resolver points to the `master` branch on GitHub
(see [the resolver config](https://github.com/tgbugs/pyontutils/blob/088b2f8f28be5e55278e3cde1e0e8a4f3ccfc94f/resolver/nif-ont-resolver.conf#L20-L24)).

Therefore, please do not push to the master branch.

Please submit a pull request (even if it is from another branch
in the SciCrunch org repo) so that we can run all the requisite
checks to make sure that the ontology is consistent.

## Prior to commit
```bash
ttlfmt $(git status -s | grep ttl | grep M | cut -d' ' -f3)
# OR if you are working on files that need to be normalized
qnamefix $(git status -s | grep ttl | grep M | cut -d' ' -f3)
```

## Adding a new external import
All external imports should be imported into NIFSTD via a bridge file.
This file will hold any local additions that we want to make.
1. Create a new bridge file by copying an existing bridge file and modifying
   as needed to import the external file from its canonical iri, and to import
   `filename-dead.ttl`.
2. Add an entry in [catalog-extras](../catalog-extras) for the new import.
3. Create `ttl/generated/filename-dead.ttl` by running `necromancy http://myurl.org/filename.owl`.
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
1. Add an entry in [catalog-v001.xml](../ttl/catalog-v001.xml) by hand.

Before you run `make_catalog` make sure that the import chain is local (unpatched)
otherwise it will take an extremely long time to fetch files.

## Load remote imports from local copies
Sometimes we don't want to have to retrieve remote copies of files every time
we start protege, or we need to run tests for patches that are applied to external
imports when loading the ontology into SciGraph.
```bash
cd ttl/
cat <(head -n -1 catalog-v001.xml) ../catalog-extras <(tail -n 1 catalog-v001.xml) > catalog-new
mv catalog-new catalog-v001.xml
```
Local copies can be obtained using the following.
```bash
cd ttl/external/
curl --header 'Accept-Encoding: gzip' --compressed --location --remote-name-all $(cat ../../catalog-extras | cut -d'=' -f3 | cut -d'"' -f2)
```

## Running the reasoner
Due to a [bug in protege](https://github.com/protegeproject/protege/issues/709) we need to patch
our import chain in order to for the reasoner to run correctly.
```bash
patch -p1 -i dev-reasoner.patch
# OR
cd ttl/
patch -p2 -i ../dev-reasoner.patch
# Then
protege  # can be launched as you see fit
```
1. In protege menu bar `File -> Open` and choose `ttl/nif.ttl`
   (after first load `File -> Open recent` is faster).
2. Make sure reasoner is set to ELK (menu bar `Reasoner -> ELK 0.4.3`)
3. Ctrl-R

Protege does not have to be run from `ttl/` in order to find `ttl/catalog-v001.xml`,
however the file opened must be in `ttl/`.

## Check for incorrect or unimported predicates
1. Remove `/tmp/ttlcmp.patch` if it exists
2. `ttlcmp.sh`  (lives in `pyontutils/pyontutils`)
3. Review `/tmp/ttlcmp.patch` for annotation and object properties.
