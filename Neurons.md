We are creating a new neuron ontology. This ontology is built on the idea that neuron types are fundamentally bags of phenotypes.
# Phenotypes
In our model phenotypes are the outputs of some measurement or set of measurements and computations/classifications. Ideally the process for documenting exactly how each phenotype was measured would be included as well, but that is currently outside the scope of this project. The current major categories of phenotypes (with example identifiers are):
  * species [NCBITaxon:10116]
  * developmental stage [EFO:0001272]
  * brain region [UBERON:0000955]
  * morphology [ilx:]
  * electrophysiology [ilx:]
  * expression [NCBIGene:, PR:000004967]
  * projection pattern [ilx:]
  * cell type specific connectivity [ilx:]
  * circuit role [ilx:]

# Phenotype Predicates
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