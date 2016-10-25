#!/usr/bin/env sh

CURIES=$(curl https://raw.githubusercontent.com/SciCrunch/NIF-Ontology/master/scigraph/nifstd_curie_map.yaml | sed 's/^/    /g')

echo "server:
  type: simple
  applicationContextPath: /scigraph
  adminContextPath: /admin
  connector:
    type: http
    port: 9000

logging:
  level: INFO
  
applicationContextPath: scigraph 

apiConfiguration:
  apikeyParameter: apikey
  defaultApikey: default
  authenticationCachePolicy: maximumSize=10000, expireAfterAccess=10m
  authenticationQuery: select APIKEY from USERS where APIKEY = ?
  roleQuery: select ROLES from USERS where APIKEY = ?
  permissionQuery: select PERMISSION from ROLES where ROLE = ?
  authDataSourceFactory:
    # the name of your JDBC driver
    driverClass: org.hsqldb.jdbc.JDBCDriver

    # the username
    user: SA

    # the password
    password: password

    # the JDBC URL
    url: jdbc:hsqldb:res:/users/users

    # any properties specific to your JDBC driver:
    properties:
      charSet: UTF-8

    # the maximum amount of time to wait on an empty pool before throwing an exception
    maxWaitForConnection: 1s

    # the SQL query to run when validating a connections liveness
    validationQuery: "/* MyService Health Check */ SELECT 1 FROM INFORMATION_SCHEMA.SYSTEM_USERS"

    # the minimum number of connections to keep open
    minSize: 8

    # the maximum number of connections to keep open
    maxSize: 32

    # whether or not idle connections should be validated
    checkConnectionWhileIdle: false

graphConfiguration:
  location: /var/scigraph-services/graph 
  indexedNodeProperties:
    - label
    - synonym
    - curie
    - acronym
    - abbreviation

  exactNodeProperties:
    - label
    - synonym
    - acronym
    - abbreviation

  neo4jConfig:
    dump_configuration : true
    dbms.pagecache.memory : 4g
  curies:
$CURIES

serviceMetadata:
  name: 'NIF Reconciliation Service'
  identifierSpace: "http://neuinfo.org/"
  schemaSpace: "http://neuinfo.org/"
  view: {
    url: 'http://matrix.neuinfo.org:9000/scigraph/refine/view/{{id}}'
  }
  preview: {
    url: 'http://matrix.neuinfo.org:9000/scigraph/refine/preview/{{id}}',
    width: 400,
    height: 400
  }
" > services.yaml

echo 'graphConfiguration:
    location: /var/scigraph-services/graph
    neo4jConfig:
      dump_configuration : true
      dbms.pagecache.memory : 4G
    indexedNodeProperties:
      - label
      - synonym
      - curie
      - acronym
      - abbreviation

    exactNodeProperties:
      - label
      - synonym
      - acronym
      - abbreviation

ontologies:
  - url: http://ontology.neuinfo.org/NIF/scicrunch-registry.ttl
  - url: http://ontology.neuinfo.org/NIF/ttl/nif.ttl
    reasonerConfiguration:
      factory: org.semanticweb.elk.owlapi.ElkReasonerFactory
      addDirectInferredEdges: true
      removeUnsatisfiableClasses: true


categories:
    http://purl.obolibrary.org/obo/OBI_0100026 : organism
    http://purl.obolibrary.org/obo/DOID_4 : disease
    http://purl.obolibrary.org/obo/UBERON_0001062 : anatomical entity
    http://purl.obolibrary.org/obo/CHEBI_23367 : molecular entity
    http://purl.obolibrary.org/obo/chebi.owl#CHEBI_23367 : molecular entity
    http://purl.obolibrary.org/obo/ERO_0000007 : technique
    #http://purl.obolibrary.org/obo/GO_0005623 : cell
    http://ontology.neuinfo.org/NIF/BiomaterialEntities/NIF-Cell.owl#sao1813327414 : cell
    http://purl.obolibrary.org/obo/GO_0008150 : biological process
    http://purl.obolibrary.org/obo/GO_0005575 : subcellular entity
    http://purl.obolibrary.org/obo/PATO_0000001 : quality
    http://vivoweb.org/ontology/core#GovernmentAgency : GovernmentAgency
    http://vivoweb.org/ontology/core#University : University
    http://uri.neuinfo.org/nif/nifstd/nlx_63400 : Resource
    http://uri.neuinfo.org/nif/nifstd/nlx_152328 : Resource
    http://uri.neuinfo.org/nif/nifstd/birnlex_2085 : Institution
    
mappedProperties:
  - name: label
    properties:
    - http://www.w3.org/2000/01/rdf-schema#label
  - name: synonym
    properties:
    - http://www.geneontology.org/formats/oboInOwl#hasExactSynonym
    - http://www.geneontology.org/formats/oboInOwl#hasNarrowSynonym
    - http://www.geneontology.org/formats/oboInOwl#hasBroadSynonym
    - http://www.geneontology.org/formats/oboInOwl#hasRelatedSynonym
    - http://purl.obolibrary.org/obo/go#systematic_synonym
    - http://ontology.neuinfo.org/NIF/Backend/OBO_annotation_properties.owl#synonym
  - name: acronym
    properties:
    - http://ontology.neuinfo.org/NIF/Backend/OBO_annotation_properties.owl#acronym
  - name: abbreviation
    properties:
    - http://ontology.neuinfo.org/NIF/Backend/OBO_annotation_properties.owl#abbrev
  - name: definition
    properties:
    - http://purl.obolibrary.org/obo/IAO_0000115
    - http://www.w3.org/2004/02/skos/core#definition
' > graphload.yaml
