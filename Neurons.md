We are creating a new neuron ontology. This ontology is built on the idea that neuron types are fundamentally bags of phenotypes.

# WARNING
At the moment if you see an ILX: identifier in one of the ontology files that is involved in modelling neurons it is temporary and should not be used.

# Phenotypes
In our model phenotypes are the outputs of some measurement or set of measurements and computations/classifications. Ideally the process for documenting exactly how each phenotype was measured would be included as well, but that is currently outside the scope of this project. The current major categories of phenotypes (with example identifiers are):
  * species [NCBITaxon:10116]
  * developmental stage [EFO:0001272]
  * brain region [UBERON:0000955]
  * morphology [ilx:]
  * electrophysiology [ilx:]
  * expression [NCBIGene:, PR:000004967; CHEBI:18243]
  * projection pattern [ilx:]
  * cell type specific connectivity [ilx:]
  * circuit role [ilx:]

# Phenotype Predicates
The core of our neuron ontology is based around a set of phenotype predicates that define relationships between phenotypes an neurons. Some examples of these predicates (relationships) are `has morphological phenotype`, `has electrophysiological phenotype`, and `has expression phenotype`. In the first two cases these predicates correspond directly to phenotype classes that are in NIF-Neuron-Phenotype because there are not other ontologies that have provided a consistent delineation for many of these types. In the case of expression phenotypes there are a number of different sources of identifiers which all imply that slightly different measurements have been made. For example a CHEBI identifier would suggest that a stain against a particular small molecule might have been used, whereas the use of a NCBIGene identifier would imply that RNAseq had been used to detect the expression of a gene transcript. While these combinations can be used to provide some implicit information about the original type of measurement, all predicate-phenotype pairs are really proxies for the experimental protocol that was used and how the resulting measurement maps onto the categorical names provided. In the future we will provide a way to link these phenotype assertions to more detailed information about the exact experimental protocol used.

# Bagging
All neurons are modelled using `owl:equivalentClass` and `owl:disjointWith` statements on `owl:Restriction`s. We have also developed a [python library](https://github.com/tgbugs/pyontutils/neurons.py) to regularize the bagging process.

# Species specific identifiers
One of the advantages of using a phenotype based approach is that when there are species specific genes or proteins it is possible to be completely explicit about the exact gene or gene product that was measure/detected. When we then construct a high level neuron such as a PV+ neuron, we can then leverage species general identifiers to make it explicit that we are making assertions about phenotypes that are evolutionarily conserved.

# Notes:

1. Mappings between hbp-cell and the new interlex identifiers.

2. Python code that generates the new neuron ttl files

https://github.com/tgbugs/pyontutils/blob/master/neurons.py

https://github.com/tgbugs/pyontutils/blob/master/nif_neuron.py

https://github.com/tgbugs/pyontutils/blob/master/resources/26451489%20table%201.csv

https://www.ncbi.nlm.nih.gov/pubmed/26451489