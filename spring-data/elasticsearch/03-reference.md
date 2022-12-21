# 5. Elasticsearch Clients

## 5.1. Imperative Rest Client

## 5.2. Reactive Rest Client

## 5.3. High Level REST Client (deprecated)

## 5.4. Reactive Client (deprecated)

## 5.5. Client Configuration

### 5.5.1. Client configuration callbacks

### 5.5.2. Elasticsearch 7 compatibility headers

## 5.6. Client Logging

# 6. Elasticsearch Object Mapping

## 6.1. Meta Model Object Mapping

### 6.1.1. Mapping Annotation Overview

### 6.1.2. Mapping Rules

### 6.1.3. Custom Conversions

# 7. Elasticsearch Operations

## 7.1. Usage examples
## 7.2. Reactive Elasticsearch Operations
### 7.2.1. Reactive Elasticsearch Operations
## 7.3. Search Result Types
## 7.4. Queries
### 7.4.1. CriteriaQuery
### 7.4.2. StringQuery
### 7.4.3. NativeQuery

# 8. Elasticsearch Repositories
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



