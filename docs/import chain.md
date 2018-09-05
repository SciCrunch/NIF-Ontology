# Logic of the import chain
The basic principle that guides the structure of the import chain is that
ALL references to owl:Classes, owl:ObjectProperties, etc. should not require
a local redefinition of that class. Said another way, all local additions to
externally defined classes should appear in the Annotations section of the
serialization, not in the Classes section. It is not always possible (nor
sensible) to follow this principle, but most of the time it is.

If there is an external class that we want to reference it should either be
imported directly or it should live in a slim that is imported as a proxy
for the external ontology and copies exactly the contents of that ontology.
Any local modifications should NOT be made to that slim itself but should be
made in the bridge file that imports it (in accordance with the basic principle).

In the case where we want to make bridging axioms between multiple external
ontologies, those axioms should live in another bridge file that imports
the other bridge files. This practice increases the depth of the import chain
but ultimately simplifies the development workflow by providing explicit
locations where bridging axioms should live that can be easily checked by
seeing whether the basic principle holds.

Import of `ttl/generated/*-dead.ttl` files should occur at the first point in
the import chain that we have control over. See for example [doid-bridge.ttl](./../ttl/bridge/doid-bridge.ttl)
which imports both `symp-dead.ttl` and `trans-dead.ttl`. The original ontologies
are imported by `doid.owl` so we import them in `doid-bridge.ttl`.
