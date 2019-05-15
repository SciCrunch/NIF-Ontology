# NIF-Ontology
This is the main repository for the NIF Standard ontology (NIFSTD).  
NIFSTD is a neuroscience ontology that maintains an extensive set of  
terms and concepts important for the domains of neuroscience and biology.

# The ontology won't load!
If you are having trouble loading [ttl/nif.ttl](./ttl/nif.ttl) in protege
please see [docs/development-setup.md#protege](./docs/development-setup.md#protege).

# Using NIFSTD
The easiest way to use the NIF Ontology is through our SciGraph [REST API](https://scicrunch.org/browse/api-docs/index.html?url=https://scicrunch.org/swagger-docs/swagger.json).  
You will need a SciCunch API key.  
You can get one by [registering for a SciCrunch account](https://scicrunch.org/register)
and then [creating an api key](https://scicrunch.org/account/developer).

# Contributing
## Ontology files
Please [fork](https://github.com/SciCrunch/NIF-Ontology#fork-destination-box) and submit
[pull requests](https://github.com/SciCrunch/NIF-Ontology/pull/new/master) on GitHub.  
**Please read [the docs for development processes](./docs/processes.md) in order to get started.**  
In short, load [ttl/nif.ttl](./ttl/nif.ttl) in your favourite ontology editor,
and before commit run [ttlfmt](https://github.com/tgbugs/pyontutils/blob/master/ttlser/ttlser/ttlfmt.py)
on any files that you have modified.

## Non-ontology files
This repository only holds ontology files (usually .ttl) that are directly part of NIFSTD
and its documentation. Workflows for ingesting external content into the ontology are managed
in the [pyontutils repository](https://github.com/tgbugs/pyontutils). If you have additional
non-ontology files please contribute them to the appropriate folder in
[pyontutils/nifstd/development](https://github.com/tgbugs/pyontutils/tree/master/nifstd/development).

## New terms
There are two ways to submit new terms.
1. Via the [issue tracker](https://github.com/SciCrunch/NIF-Ontology/issues) with the `new term` tag.  
2. Via [InterLex](http://interlex.org). InterLex is still in beta so you will need to
[contact us](mailto:info@scicrunch.org) in order to get edit access. There will be some delay between
the creation of a term in InterLex and its inclusion here in the ontology.

# Documentation
Please see the [documentation](http://ontology.neuinfo.org/docs) for information about how to use and develop NIFSTD.

# License
<a rel="license" href="http://creativecommons.org/licenses/by/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by/4.0/80x15.png" /></a><br />The contents of this repository are licensed under a <a rel="license" href="http://creativecommons.org/licenses/by/4.0/">Creative Commons Attribution 4.0 International License</a>.
The text of the license can also be found in the [LICENSE](./LICENSE) file.
