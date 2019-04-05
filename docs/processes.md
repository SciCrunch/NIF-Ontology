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

# DO NOT PUSH ONTOLOGY FILES TO MASTER
The `uri.neuinfo.org` resolver points to the `master` branch on GitHub
(see [the resolver config](https://github.com/tgbugs/pyontutils/blob/088b2f8f28be5e55278e3cde1e0e8a4f3ccfc94f/resolver/nif-ont-resolver.conf#L20-L24)).

Therefore, please do not push to the master branch.

If you are making changes to the ontology that are more than cosmetic
please push to the `staging` branch. That way merging from staging to
master can be accompanied by a SciGraph build and pushed out to services
so that everything can stay 'mostly' in sync.

Please submit a pull request (even if it is from another branch
in the SciCrunch org repo) so that we can run all the requisite
checks to make sure that the ontology is consistent.

# Please do push documentation to master
[catalog-v001.xml.example](./../ttl/catalog-v001.xml.example) should also always be updated on master

# Processes

## Development

### Prior to commit
```bash
ttlfmt $(git status -s | grep ttl | grep M | cut -d' ' -f3)
# OR if you are working on files that need to be normalized
qnamefix $(git status -s | grep ttl | grep M | cut -d' ' -f3)
```

### Adding a new remote import
All remote imports should be imported into NIFSTD via a bridge file.
This file will hold any local additions that we want to make.
1. Create a new bridge file by copying an existing bridge file and modifying
   as needed to import the remote file from its canonical iri, and to import
   `filename-dead.ttl`.
2. Add an entry in [catalog-extras](./../catalog-extras) for the new import.
3. Create `ttl/generated/filename-dead.ttl` by running `necromancy http://myurl.org/filename.owl`.
4. Whenever there is a new release repeat step 3.

### Load remote imports from local copies
Sometimes we don't want to have to retrieve remote copies of files every time
we start protege, or we need to run tests for patches that are applied to remote
imports when loading the ontology into SciGraph.
```bash
cd ttl/
cat <(head -n -1 catalog-v001.xml) ../catalog-extras <(tail -n 1 catalog-v001.xml) > catalog-new
mv catalog-new catalog-v001.xml
```
Local copies can be obtained using the following.
```bash
cd ttl
curl --header 'Accept-Encoding: gzip' --compressed --location --create-dirs \
$(cat ../catalog-extras | cut -d'=' -f4 | cut -d'"' -f2 | sed 's/^/-o /') \
--remote-name-all $(cat ../catalog-extras | cut -d'=' -f3 | cut -d'"' -f2)
```

### Running the reasoner
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

### Changing an ontology file
1. Edit your file and save.
2. If using protege `git diff` to make sure that any new triples
   have landed in the correct file.
3. Execute prior to commit processes.

### Adding a new ontology file
```bash
touch filename.ttl
add filename.ttl
`make_catalog`  # NOTE this is broken at the moment
```
1. Add an entry in [catalog-v001.xml](./../ttl/catalog-v001.xml.example) by hand.
Note that you will need to make sure that `catalog-v001.xml` is copied from the
example order to make use of the new entry.

Before you run `make_catalog` make sure that the import chain is local (unpatched)
otherwise it will take an extremely long time to fetch files.

### Integrating a new set of terms
If there is an existing ttl file that has been formatted with ttlfmt as described above then
create a new branch, add the file, and submit a pull request for review.

If there is a chance that this file may need to be regenerated from an external source
please add the external source and the generation code via the process described in
[pyontutils/development/README.md](https://github.com/tgbugs/pyontutils/blob/master/development/README.md).
This does not need to be done if ttl file will become the source of truth once integrated into NIFSTD.

Any set of terms that requires more than direct transformation to ttl should also follow the process described in
[pyontutils/development/README.md](https://github.com/tgbugs/pyontutils/blob/master/development/README.md).

### Check for incorrect or unimported predicates
1. Remove `/tmp/ttlcmp.patch` if it exists
2. `ttlcmp.sh`  (lives in `pyontutils/pyontutils`)
3. Review `/tmp/ttlcmp.patch` for annotation and object properties.

## External source synchronization
Full documentation of defaults and command line arguments can be found by running
`--help` for any of the commands listed in this section.

All of these will soon be set up to run on cron jobs and automatically
submit pull requests to the NIF-Ontology repository.

All of these scripts expect pyontutils and the NIF-Ontology repos to be
in the same directory `${HOME}/git/pyontutils` `${HOME}/git/NIF-Ontology`.
I am in the process of making this configurable (for some scripts is already is).

The following sections require you to have already run `pipenv install --skip-lock`
and `pipenv shell`.  For `registry-sync` you may want to run `pipenv install --skip-lock --dev`
in which case see the
[development installation notes](https://github.com/tgbugs/pyontutils/blob/master/README.md#development-installation)
for potential pitfalls.

Start with
``` bash
cd ~/git/pyontutils &&  # adjust accordingly
pipenv shell
```

### SciCrunch Registry
```
BRANCH="registry-$(date +%s)"
registry-sync &&
cd ${PATH_TO_ONTOLOGY} &&
git pull &&  # alternately git clone and set pushurl -> script-user or something
git checkout -B ${BRANCH} &&
git push --set-upstream origin ${BRANCH} &&
echo success
# TODO auto github api pull
```

### parcellation
TODO

### slimgen
TODO


## Release processes
The exact details of the release process are still being worked out so this section
may be out of date. Check the underlying documentation and the python scripts/commits
for the latest information.

### Run sanity checks on staging
Besides the checks listed as part of the development process we need to integrate
automated tests, probably using [ROBOT](https://github.com/ontodev/robot). See also
https://github.com/SciCrunch/NIF-Ontology/issues/60.

### versionInfo
Only bump the versionInfo string on nif.ttl for major releases (e.g. one
where nif.ttl is pushed to bioportal). Our versionIRI implementation on
top of the unix epoch provides the logical end of granular versioning so
we will use that for all practical versioning needs. It seems unlikely
that we will bump to a 4.0 release any time in the near future so simply
increase the count on the version by one for each release.

### versionIRI
Run `ontutils version-iri ttl/nif.ttl` from the root of the ontology git
directory. Then run `ontutils iri-commit NIF-Ontology -l ${git-base}` and
copy and paste the git commit command and execute it. This can now be run
on any branch and will resolve correctly when merged to master.

TODO: Should we add a process for adding a versionIRI to individual files 
whenever there is a substantial non-cosmetic change? It is already possible
to use the epoch based versionIRIs to refer to files even if we do not include
the versionIRI in the file explicitly.

### Merge to master
If the changes are minor don't bother with a pull request, run
`git checkout master && git merge staging` and then push.
If there are more major changes, such as changes to modelling of a domain
or deprecation of ontology files, submit a pull request, even if you are the
only person who will participate in it. This can provide a nice summary for
someone who needs to review the history of changes but shouldn't have to dig
through the full commit log.

### Build graph for SciGraph release
To load the graph run the following from either `pyontutils/nifstd/scigraph` or `sparc-curation/resources/scigraph`
``` bash
ontload graph NIF-Ontology NIF -z /tmp/test1 -l /tmp/test1 -b dev -p -t ./graphload.yaml
```
If you need something more the build process for the graph is quite customizable.
Run `ontload scigraph --help` if you need additional guidance.

### Build and deploy services config
This only needs to be done if the services config has changed.  

To create services.yaml run the following from the folder of this readme.
``` bash
scigraph-deploy config --local --services-config ./services.yaml --services-user ec2-user --zip-location ./ localhost scigraph.scicrunch.io
```

### Deploy to SciGraph
See the [RPM Builds](https://github.com/tgbugs/pyontutils/blob/master/nifstd/scigraph/README.md#rpm-builds) secion of the
[the pyontutils scigraph readme](https://github.com/tgbugs/pyontutils/blob/master/nifstd/scigraph/README.md) for the rest
of the instructions for deployment.

### Restart dependent services
1. Restart the `ontree` process on aux-resolver. This is needed to flush the cache of the import chain.

## Resolver
Information about the implementation of `ontology.neuinfo.org` is mostly covered in
the [resolver readme](https://github.com/tgubgs/pyontutils/blob/master/nifstd/resolver/README.md).
See [pyontutils/nifstd/resolver/aux-resolver.conf](https://github.com/tgbugs/pyontutils/blob/9c5f64afe62cf22f5e972868225835c1e65e07b8/resolver/aux-resolver.conf#L92-L94)
and [pyontutils/nifstd/resolver/nif-ont-resolver.conf](https://github.com/tgbugs/pyontutils/blob/ef18da508ebfd95aff8b1ca01f6117c95326f036/resolver/nif-ont-resolver.conf#L36-L44).

## Building documentation
### Setup
See [pyontutils/README.md#requirements](https://github.com/tgbugs/pyontutils/blob/master/README.md#requirements)
for details on `pandoc` and `orgstrap`. For the best results use `>=app-text/emacs-26.1` and `>=app-text/pandoc-2.2.3.2`.
For centos 7 (i.e. the current aux-resolver sever) this means
1. download, extract, build, and install [emacs](https://ftp.gnu.org/gnu/emacs/emacs-26.1.tar.xz)
2. download, extract, and install the [latest](https://github.com/jgm/pandoc/releases/latest) version
of [pandoc](https://github.com/jgm/pandoc/releases/download/2.2.3.2/pandoc-2.2.3.2-linux.tar.gz).
3. `git clone https://github.com/tgbugs/orgstrap.git` and run `orgstrap/orgstrap`

### Build
On aux-resolver `SCICRUNCH_API_KEY=$(cat api-key) pyontutils/pyontutils/docs.py`

### Check links
Use a crawler to check for broken links. For example using
[pylinkvalidator.py](https://github.com/bartdag/pylinkvalidator) one can run the following.
``` sh
pylinkvalidate.py \
--progress \
--depth 1 \
--workers 4 \
--parser=lxml \
--types=a \
--accepted-hosts=github.com \
http://ontology.neuinfo.org/docs/
```


### Deploy
On aux-resolver `cp -a pyontutils/pyontutils/doc_build/docs /var/www/ontology-docs`

## External records
### Registries
There are a couple of places where there are external records of the
ontology that a maintainer or curator needs to keep up to date.
1. https://scicrunch.org/resolver/SCR_005414 (NIF Ontology)
2. https://scicrunch.org/resolver/SCR_005402 (NeuroLex)
3. https://scicrunch.org/resolver/SCR_016178 (InterLex)
4. https://bioportal.bioontology.org/ontologies/NIFSTD
5. https://bioportal.bioontology.org/ontologies/NIFSUBCELL
6. https://fairsharing.org/bsg-s002584 (NeuroLex)
7. https://fairsharing.org/bsg-s002628 (NIF Ontology)
8. https://fairsharing.org/bsg-s002835 (subcellular)

### About pages
Pages that need to be kept up to date / sourced from material here.
1. https://neuinfo.org/about/components
2. https://neuinfo.org/about/nifvocabularies

### Related search pages
1. http://interlex.org
2. https://scicrunch.org/browse/terminology
