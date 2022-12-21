# 5. Elasticsearch Clients

This chapter illustrates configuration and usage of supported Elasticsearch client implementations.


Spring Data Elasticsearch operates upon an Elasticsearch client (provided by Elasticsearch client libraries) that is connected to a single Elasticsearch node or a cluster. 

Although the Elasticsearch Client can be used directly to work with the cluster, applications using Spring Data Elasticsearch normally use the higher level abstractions of Elasticsearch Operations and Elasticsearch Repositories.


## 5.1. Imperative Rest Client

To use the imperative (non-reactive) client, a configuration bean must be configured like this:

```java
 import org.springframework.data.elasticsearch.client.elc.ElasticsearchConfiguration;

@Configuration
public class MyClientConfig extends ElasticsearchConfiguration {

	@Override
	public ClientConfiguration clientConfiguration() {
		return ClientConfiguration.builder()           (1)
			.connectedTo("localhost:9200")
			.build();
	}
}
```
for a detailed description of the builder methods see [Client Configuration](https://docs.spring.io/spring-data/elasticsearch/docs/current/reference/html/#elasticsearch.clients.configuration)

The following beans can then be injected in other Spring components:

```
@Autowired
ElasticsearchOperations operations;      (1)

@Autowired
ElasticsearchClient elasticsearchClient; (2)

@Autowired
RestClient restClient;                   (3)
```

1. an implementation of `ElasticsearchOperations`
2. the `co.elastic.clients.elasticsearch.ElasticsearchClient` that is used.
3. the low level `RestClient` from the Elasticsearch libraries


Basically one should just use the `ElasticsearchOperations` to interact with the Elasticsearch cluster.

When using repositories, this instance is used under the hood as well.

在使用存储库时，这个实例也在底层使用。

## 5.2. Reactive Rest Client

When working with the reactive stack, the configuration must be derived from a different class:

```java
import org.springframework.data.elasticsearch.client.elc.ReactiveElasticsearchConfiguration;

@Configuration
public class MyClientConfig extends ReactiveElasticsearchConfiguration {

	@Override
	public ClientConfiguration clientConfiguration() {
		return ClientConfiguration.builder()           (1)
			.connectedTo("localhost:9200")
			.build();
	}
}
```

The following beans can then be injected in other Spring components:

```java
@Autowired
ReactiveElasticsearchOperations operations;      (1)

@Autowired
ReactiveElasticsearchClient elasticsearchClient; (2)

@Autowired
RestClient restClient;                           (3)

```

the following can be injected:

1. an implementation of `ReactiveElasticsearchOperations`
2. the `org.springframework.data.elasticsearch.client.elc.ReactiveElasticsearchClient` that is used. This is a reactive implementation based on the Elasticsearch client implementation.
3. the low level `RestClient` from the Elasticsearch libraries

Basically one should just use the `ReactiveElasticsearchOperations` to interact with the Elasticsearch cluster. When using repositories, this instance is used under the hood as well.

## 5.3. High Level REST Client (deprecated)

## 5.4. Reactive Client (deprecated)

## 5.5. Client Configuration

Client behaviour can be changed via the `ClientConfiguration` that allows to set options for SSL, connect and socket timeouts, headers and other parameters.

*Example 52. Client Configuration*

```java
import org.springframework.data.elasticsearch.client.ClientConfiguration;
import org.springframework.data.elasticsearch.support.HttpHeaders;

import static org.springframework.data.elasticsearch.client.elc.ElasticsearchClients.*;

HttpHeaders httpHeaders = new HttpHeaders();
httpHeaders.add("some-header", "on every request")                      (1)

ClientConfiguration clientConfiguration = ClientConfiguration.builder()
  .connectedTo("localhost:9200", "localhost:9291")                      (2)
  .usingSsl()                                                           (3)
  .withProxy("localhost:8888")                                          (4)
  .withPathPrefix("ela")                                                (5)
  .withConnectTimeout(Duration.ofSeconds(5))                            (6)
  .withSocketTimeout(Duration.ofSeconds(3))                             (7)
  .withDefaultHeaders(defaultHeaders)                                   (8)
  .withBasicAuth(username, password)                                    (9)
  .withHeaders(() -> {                                                  (10)
    HttpHeaders headers = new HttpHeaders();
    headers.add("currentTime", LocalDateTime.now().format(DateTimeFormatter.ISO_LOCAL_DATE_TIME));
    return headers;
  })
  .withClientConfigurer(                                                (11)
    ElasticsearchClientConfigurationCallback.from(clientBuilder -> {
  	  // ...
      return clientBuilder;
  	}))
  . // ... other options
  .build();


```

1. Define default headers, if they need to be customized
2. 	Use the builder to provide cluster addresses, set default `HttpHeaders` or enable SSL.
3. Optionally enable SSL.
4. Optionally set a proxy.
5. Optionally set a path prefix, mostly used when different clusters a behind some reverse proxy.
6. Set the connection timeout.
7. 	Set the socket timeout.
8. 	Optionally set headers.
9. Add basic authentication.
10. A **Supplier<HttpHeaders>** function can be specified which is called every time before a request is sent to Elasticsearch - here, as an example, the current time is written in a header.
11. 	a function to configure the created client (see Client configuration callbacks), can be added multiple times.

> Adding a Header supplier as shown in above example allows to inject headers that may change over the time, like authentication JWT tokens. If this is used in the reactive setup, the supplier function must not block!


### 5.5.1. Client configuration callbacks

The `ClientConfiguration` class offers the most common parameters to configure the client. 

In the case this is not enough, the user can add callback functions by using the `withClientConfigurer(ClientConfigurationCallback<?>)` method.

The following callbacks are provided:

#### Configuration of the low level Elasticsearch RestClient:

This callback provides a `org.elasticsearch.client.RestClientBuilder` that can be used to configure the Elasticsearch `RestClient`:

```java
ClientConfiguration.builder()
    .withClientConfigurer(ElasticsearchClients.ElasticsearchRestClientConfigurationCallback.from(restClientBuilder -> {
        // configure the Elasticsearch RestClient
        return restClientBuilder;
    }))
    .build();
```

#### Configuration of the HttpAsyncClient used by the low level Elasticsearch RestClient:

This callback provides a `org.apache.http.impl.nio.client.HttpAsyncClientBuilder` to configure the HttpCLient that is used by the `RestClient`.

```java
ClientConfiguration.builder()
    .withClientConfigurer(ElasticsearchClients.ElasticsearchHttpClientConfigurationCallback.from(httpAsyncClientBuilder -> {
        // configure the HttpAsyncClient
        return httpAsyncClientBuilder;
    }))
    .build();
```

### 5.5.2. Elasticsearch 7 compatibility headers

## 5.6. Client Logging

# 6. Elasticsearch Object Mapping

Spring Data Elasticsearch Object Mapping is the process that maps a Java object - the domain entity - into the JSON representation that is stored in Elasticsearch and back. 

The class that is internally used for this mapping is the `MappingElasticsearcvhConverter`.

## 6.1. Meta Model Object Mapping

The Metamodel based approach uses domain type information for reading/writing from/to Elasticsearch. 

This allows to register `Converter` instances for specific domain type mapping.

### 6.1.1. Mapping Annotation Overview

The `MappingElasticsearchConverter` uses metadata to drive the mapping of objects to documents. 

The metadata is taken from the entity’s properties which can be annotated.

The following annotations are available:

- `@Document`: Applied at the class level to indicate this class is a candidate for mapping to the database. The most important attributes are (check the API documentation for the complete list of attributes):
  - `indexName`: the name of the index to store this entity in. This can contain a SpEL template expression like `"log-#{T(java.time.LocalDate).now().toString()}"`
  - `createIndex`: flag whether to create an index on repository bootstrapping. Default value is true. See Automatic creation of indices with the corresponding mapping
- `@Id`: Applied at the field level to mark the field used for identity purpose.
- `@Transient`: By default all fields are mapped to the document when it is stored or retrieved, this annotation excludes the field.
- `@PersistenceConstructor`: Marks a given constructor - even a package protected one - to use when instantiating the object from the database. Constructor arguments are mapped by name to the key values in the retrieved Document.
- `@Field`: Applied at the field level and defines properties of the field, most of the attributes map to the respective Elasticsearch Mapping definitions (the following list is not complete, check the annotation Javadoc for a complete reference):
  - `name`: The name of the field as it will be represented in the Elasticsearch document, if not set, the Java field name is used.
  - `type`: The field type, can be one of *Text*, *Keyword*, *Long*, *Integer*, *Short*, *Byte*, *Double*, *Float*, *Half_Float*, *Scaled_Float*, *Date*, *Date_Nanos*, *Boolean*, *Binary*, *Integer_Range*, *Float_Range*, *Long_Range*, *Double_Range*, *Date_Range*, *Ip_Range*, *Object*, *Nested*, *Ip*, *TokenCount*, *Percolator*, *Flattened*, *Search_As_You_Type*. See [Elasticsearch Mapping Types](https://www.elastic.co/guide/en/elasticsearch/reference/current/mapping-types.html).If the field type is not specified, it defaults to `FieldType.Auto`. This means, that no mapping entry is written for the property and that Elasticsearch will add a mapping entry dynamically when the first data for this property is stored (check the Elasticsearch documentation for dynamic mapping rules).
  - `format`: One or more built-in date formats, see the next section Date format mapping.
  - `pattern`: One or more custom date formats, see the next section Date format mapping.
  - `store`: Flag whether the original field value should be store in Elasticsearch, default value is false.
  - `analyzer`, `searchAnalyzer`, `normalizer` for specifying custom analyzers and normalizer.
- `@GeoPoint`: Marks a field as *geo_point* datatype. Can be omitted if the field is an instance of the `GeoPoint` class.
- `@ValueConverter` defines a class to be used to convert the given property. In difference to a registered Spring `Converter` this only converts the annotated property and not every property of the given type.

The mapping metadata infrastructure is defined in a separate spring-data-commons project that is technology agnostic.

映射元数据基础设施定义在单独的spring-data-commons项目中，该项目与技术无关。

#### Date format mapping
#### Range types
#### Mapped field names
#### Non-field-backed properties

### 6.1.2. Mapping Rules

#### Type Hints

Mapping uses *type hints* embedded in the document sent to the server to allow generic type mapping. 

Those type hints are represented as `_class` attributes within the document and are written for each aggregate root.

- aggregate adj.总计的，合计的；（种群）聚生的

```java
public class Person {              (1)
  @Id String id;
  String firstname;
  String lastname;
}
```

```json
{
  "_class" : "com.example.Person", (1)
  "id" : "cb7bef",
  "firstname" : "Sarah",
  "lastname" : "Connor"
}

```

Type hints can be configured to hold custom information. Use the @TypeAlias annotation to do so.

*Example 54. Type Hints with Alias*

```java
@TypeAlias("human")                (1)
public class Person {

  @Id String id;
  // ...
}
```

```json
{
  "_class" : "human",              (1)
  "id" : ...
}
```

The configured alias is used when writing the entity.

#### Disabling Type Hints

#### Geospatial Types 地理空间类型

Geospatial types like `Point` & `GeoPoint` are converted into lat/lon pairs.

```java
public class Address {
  String city, street;
  Point location;
}
```

```json
{
  "city" : "Los Angeles",
  "street" : "2800 East Observatory Road",
  "location" : { "lat" : 34.118347, "lon" : -118.3026284 }
}
```

#### GeoJson Types

Spring Data Elasticsearch supports the GeoJson types by providing an interface `GeoJson` and implementations for the different geometries. 

They are mapped to Elasticsearch documents according to the GeoJson specification. 

The corresponding properties of the entity are specified in the index mappings as `geo_shape` when the index mappings is written. (check the Elasticsearch documentation as well)

*Example 56. GeoJson types*

```java
public class Address {

  String city, street;
  GeoJsonPoint location;
}
```

```json
{
  "city": "Los Angeles",
  "street": "2800 East Observatory Road",
  "location": {
    "type": "Point",
    "coordinates": [-118.3026284, 34.118347]
  }
}
```

- coordinates n. [数]坐标；相配之衣物

The following GeoJson types are implemented:

- `GeoJsonPoint`

- `GeoJsonMultiPoint`

- `GeoJsonLineString`

- `GeoJsonMultiLineString`

- `GeoJsonPolygon`

- `GeoJsonMultiPolygon`

- `GeoJsonGeometryCollection`

#### Collections

For values inside Collections apply the same mapping rules as for aggregate roots when it comes to type hints and Custom Conversions.

*Example 57. Collections*

```java
public class Person {

  // ...

  List<Person> friends;

}
```

```json
{
  // ...

  "friends" : [ { "firstname" : "Kyle", "lastname" : "Reese" } ]
}
```

#### Maps

For values inside Maps apply the same mapping rules as for aggregate roots when it comes to type hints and Custom Conversions. However the Map key needs to a String to be processed by Elasticsearch.

*Example 58. Collections*
```java
public class Person {

  // ...

  Map<String, Address> knownLocations;

}
```

```json
{
  // ...

  "knownLocations" : {
    "arrivedAt" : {
       "city" : "Los Angeles",
       "street" : "2800 East Observatory Road",
       "location" : { "lat" : 34.118347, "lon" : -118.3026284 }
     }
  }
}
```

### 6.1.3. Custom Conversions

# 7. Elasticsearch Operations

Spring Data Elasticsearch uses several interfaces to define the operations that can be called against an Elasticsearch index (for a description of the reactive interfaces see Reactive Elasticsearch Operations).

- `IndexOperations` defines actions on index level like creating or deleting an index.
- `DocumentOperations` defines actions to store, update and retrieve entities based on their id.
- `SearchOperations` define the actions to search for multiple entities using queries
- `ElasticsearchOperations` combines the `DocumentOperations` and `SearchOperations` interfaces.

These interfaces correspond to the structuring of the Elasticsearch API.

The default implementations of the interfaces offer:

- index management functionality.

- Read/Write mapping support for domain types.

- A rich query and criteria api.
  - criteria n.（评判或做决定的）标准，准则，尺度 （criterion 的复数）

- Resource management and Exception translation.

## 7.1. Usage examples

The example shows how to use an injected `ElasticsearchOperations` instance in a Spring REST controller. 

The example assumes that `Person` is a class that is annotated with `@Document`, `@Id` etc (see Mapping Annotation Overview). .ElasticsearchOperations usage

```java
@RestController
@RequestMapping("/")
public class TestController {

  private  ElasticsearchOperations elasticsearchOperations;

  public TestController(ElasticsearchOperations elasticsearchOperations) { (1)
    this.elasticsearchOperations = elasticsearchOperations;
  }

  @PostMapping("/person")
  public String save(@RequestBody Person person) {                         (2)
    Person savedEntity = elasticsearchOperations.save(person);
    return savedEntity.getId();
  }

  @GetMapping("/person/{id}")
  public Person findById(@PathVariable("id")  Long id) {                   (3)
    Person person = elasticsearchOperations.get(id.toString(), Person.class);
    return person;
  }
}
```

1. Let Spring inject the provided `ElasticsearchOperations` bean in the constructor.
2. Store some entity in the Elasticsearch cluster. The id is read from the returned entity, as it might have been null in the `person` object and been created by Elasticsearch.
3. Retrieve the entity with a get by id.

To see the full possibilities of `ElasticsearchOperations` please refer to the API documentation.

## 7.2. Reactive Elasticsearch Operations


### 7.2.1. Reactive Elasticsearch Operations


## 7.3. Search Result Types

## 7.4. Queries

Almost all of the methods defined in the `SearchOperations` and `ReactiveSearchOperations` interface take a `Query` parameter that defines the query to execute for searching. 

`Query` is an interface and Spring Data Elasticsearch provides three implementations: `CriteriaQuery`, `StringQuery` and `NativeQuery`.

### 7.4.1. CriteriaQuery

`CriteriaQuery` based queries allow the creation of queries to search for data without knowing the syntax or basics of Elasticsearch queries. 

They allow the user to build queries by simply chaining and combining Criteria objects that specifiy the criteria the searched documents must fulfill.

> when talking about AND or OR when combining criteria keep in mind, that in Elasticsearch AND are converted to a **must** condition and OR to a **should**


`Criteria` and their usage are best explained by example (let’s assume we have a `Book` entity with a price property):

*Example 61. Get books with a given price*

```java
Criteria criteria = new Criteria("price").is(42.0);
Query query = new CriteriaQuery(criteria);
```

Conditions for the same field can be chained, they will be combined with a logical AND:

*Example 62. Get books with a given price*

```java
Criteria criteria = new Criteria("price").greaterThan(42.0).lessThan(34.0L);
Query query = new CriteriaQuery(criteria);
```

When chaining Criteria, by default a AND logic is used:

*Example 63. Get all persons with first name James and last name Miller:*

```java
Criteria criteria = new Criteria("lastname").is("Miller") (1)
  .and("firstname").is("James")                           (2)
Query query = new CriteriaQuery(criteria);
```


1. the first Criteria
2. the and() creates a new Criteria and chaines it to the first one.

If you want to create nested queries, you need to use subqueries for this. 

Let’s assume we want to find all persons with a last name of Miller and a first name of either Jack or John:

*Example 64. Nested subqueries*

```java
Criteria miller = new Criteria("lastName").is("Miller")  (1)
  .subCriteria(                                          (2)
    new Criteria().or("firstName").is("John")            (3)
      .or("firstName").is("Jack")                        (4)
  );
Query query = new CriteriaQuery(criteria);
```

1. create a first **Criteria** for the last name
2. this is combined with AND to a subCriteria
3. This sub Criteria is an OR combination for the first name John
4. and the first name Jack

Please refer to the API documentation of the Criteria class for a complete overview of the different available operations.

### 7.4.2. StringQuery

This class takes an Elasticsearch query as JSON String. The following code shows a query that searches for persons having the first name "Jack":

```java

Query query = new StringQuery("{ \"match\": { \"firstname\": { \"query\": \"Jack\" } } } ");
SearchHits<Person> searchHits = operations.search(query, Person.class);

```

Using `StringQuery` may be appropriate if you already have an Elasticsearch query to use.

### 7.4.3. NativeQuery

`NativeQuery` is the class to use when you have a complex query, or a query that cannot be expressed by using the Criteria API, for example when building queries and using aggregates.

It allows to use all the different `co.elastic.clients.elasticsearch._types.query_dsl.Query` implementations from the Elasticsearch library therefore named "native".

The following code shows how to search for persons with a given firstname and for the found documents have a terms aggregation that counts the number of occurences of the lastnames for these persons:

```java
Query query = NativeQuery.builder()
	.withAggregation("lastNames", Aggregation.of(a -> a
		.terms(ta -> ta.field("last-name").size(10))))
	.withQuery(q -> q
		.match(m -> m
			.field("firstName")
			.query(firstName)
		)
	)
	.withPageable(pageable)
	.build();

SearchHits<Person> searchHits = operations.search(query, Person.class);
```

# 8. Elasticsearch Repositories

This chapter includes details of the Elasticsearch repository implementation.

*Example 65. The sample Book entity*

```java
@Document(indexName="books")
class Book {
    @Id
    private String id;

    @Field(type = FieldType.text)
    private String name;

    @Field(type = FieldType.text)
    private String summary;

    @Field(type = FieldType.Integer)
    private Integer price;

	// getter/setter ...
}


```

## 8.1. Automatic creation of indices with the corresponding mapping



## 8.2. Query methods



## 8.3. Reactive Elasticsearch Repositories



### 8.3.1. Usage



### 8.3.2. Configuration

## 8.4. Annotations for repository methods

### 8.4.1. @Highlight

### 8.4.2. @SourceFilters

## 8.5. Annotation based configuration

## 8.6. Elasticsearch Repositories using CDI

## 8.7. Spring Namespace

# 9. Auditing

## 9.1. Basics

## 9.2. Elasticsearch Auditing

### 9.2.1. Preparing entities

### 9.2.2. Activating auditing

# 10. Entity Callbacks

## 10.1. Implementing Entity Callbacks

## 10.2. Registering Entity Callbacks

## 10.3. Elasticsearch EntityCallbacks

# 11. Join-Type implementation

## 11.1. Setting up the data

## 11.2. Storing data

## 11.3. Retrieving data

# 12. Routing values

## 12.1. Routing on join-types

## 12.2. Custom routing values

# 13. Miscellaneous Elasticsearch Operation Support

- Miscellaneous adj.（人，物）混杂的，各种各样的；多方面的，多才多艺的

This chapter covers additional support for Elasticsearch operations that cannot be directly accessed via the repository interface.

It is recommended to add those operations as custom implementation as described in Custom Implementations for Spring Data Repositories.

## 13.1. Index settings

When creating Elasticsearch indices with Spring Data Elasticsearch different index settings can be defined by using the `@Setting` annotation.

- indices n.指数；目录（index的复数）

The following arguments are available:

- `useServerConfiguration` does not send any settings parameters, so the Elasticsearch server configuration determines them.
- ' useServerConfiguration '不发送任何设置参数，因此Elasticsearch服务器配置决定它们。
- `settingPath` refers to a JSON file defining the settings that must be resolvable in the classpath
- `shards` the number of shards to use, defaults to 1
- `replicas` the number of replicas, defaults to 1
- `refreshIntervall`, defaults to "1s"
- `indexStoreType`, defaults to "fs"

It is as well possible to define [index sorting](https://www.elastic.co/guide/en/elasticsearch/reference/7.11/index-modules-index-sorting.html) (check the linked Elasticsearch documentation for the possible field types and values):

```java
@Document(indexName = "entities")
@Setting(
  sortFields = { "secondField", "firstField" },                                  // 1
  sortModes = { Setting.SortMode.max, Setting.SortMode.min },                    // 2
  sortOrders = { Setting.SortOrder.desc, Setting.SortOrder.asc },
  sortMissingValues = { Setting.SortMissing._last, Setting.SortMissing._first })
class Entity {
    @Nullable
    @Id private String id;

    @Nullable
    @Field(name = "first_field", type = FieldType.Keyword)
    private String firstField;

    @Nullable @Field(name = "second_field", type = FieldType.Keyword)
    private String secondField;

    // getter and setter...
}
```

1. when defining sort fields, use the name of the Java property (firstField), not the name that might be defined for Elasticsearch (first_field).
2. **sortModes**, **sortOrders** and **sortMissingValues** are optional, but if they are set, the number of entries must match the number of **sortFields** elements.

## 13.2. Index Mapping

When Spring Data Elasticsearch creates the index mapping with the `IndexOperations.createMapping()` methods, it uses the annotations described in Mapping Annotation Overview, especially the `@Field` annotation.

当Spring Data Elasticsearch使用' IndexOperations.createMapping() '方法创建索引映射时，它会使用映射注释概述中描述的注释，特别是' @Field '注释。

This annotation has the following properties:

- `mappingPath` a classpath resource in JSON format; if this is not empty it is used as the mapping, no other mapping processing is done.

- `enabled` when set to false, this flag is written to the mapping and no further processing is done.

- `dateDetection` and `numericDetection` set the corresponding properties in the mapping when not set to DEFAULT.

- `dynamicDateFormats` when this String array is not empty, it defines the date formats used for automatic date detection.

- `runtimeFieldsPath` a classpath resource in JSON format containing the definition of runtime fields which is written to the index mappings, for example:

```json
{
  "day_of_week": {
    "type": "keyword",
    "script": {
      "source": "emit(doc['@timestamp'].value.dayOfWeekEnum.getDisplayName(TextStyle.FULL, Locale.ROOT))"
    }
  }
}
```

## 13.3. Filter Builder

Filter Builder improves query speed.

```java
private ElasticsearchOperations operations;

IndexCoordinates index = IndexCoordinates.of("sample-index");

Query query = NativeQuery.builder()
	.withQuery(q -> q
		.matchAll(ma -> ma))
	.withFilter( q -> q
		.bool(b -> b
			.must(m -> m
				.term(t -> t
					.field("id")
					.value(documentId))
			)))
	.build();

SearchHits<SampleEntity> sampleEntities = operations.search(query, SampleEntity.class, index);
```

## 13.4. Using Scroll For Big Result Set

Elasticsearch has a scroll API for getting big result set in chunks. 

Elasticsearch有一个滚动API，用于以块的形式获取大的结果集。

This is internally used by Spring Data Elasticsearch to provide the implementations of the `<T> SearchHitsIterator<T>` SearchOperations.searchForStream(Query query, Class<T> clazz, IndexCoordinates index) method.

## 13.5. Sort options

## 13.6. Runtime Fields

## 13.7. Point In Time (PIT) API

### 13.6.1. Runtime field definitions in the index mappings

### 13.6.2. Runtime fields definitions set on a Query

## 13.7. Point In Time (PIT) API



