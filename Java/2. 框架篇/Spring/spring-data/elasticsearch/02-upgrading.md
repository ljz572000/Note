# Upgrading Spring Data

Instructions for how to upgrade from earlier versions of Spring Data are provided on the project wiki. 

Follow the links in the release notes section to find the version that you want to upgrade to.

Upgrading instructions are always the first item in the release notes. 

If you are more than one release behind, please make sure that you also review the release notes of the versions that you jumped.

# 4. Working with Spring Data Repositories

The goal of the Spring Data repository abstraction is to significantly reduce the amount of boilerplate code required to implement data access layers for various persistence stores.

Spring Data存储库抽象的目标是显著减少为各种持久性存储实现数据访问层所需的样板代码的数量。

- boilerplate code 样板代码

> Spring Data repository documentation and your module
> This chapter explains the core concepts and interfaces of Spring Data repositories.
> 本章解释了Spring Data存储库的核心概念和接口。
> The information in this chapter is pulled from the Spring Data Commons module. 
> 本章中的信息来自Spring Data Commons模块。
>  It uses the configuration and code samples for the Jakarta Persistence API (JPA) module.
> 它使用Jakarta Persistence API (JPA)模块的配置和代码示例。
>  If you want to use XML configuration you should adapt the XML namespace declaration and the types to be extended to the equivalents of the particular module that you use.
> 如果希望使用XML配置，则应该调整XML名称空间声明和要扩展的类型，使之与所使用的特定模块等价。
>  “Namespace reference” covers XML configuration, which is supported across all Spring Data modules that support the repository API. 
> “命名空间引用”涵盖了XML配置，所有支持存储库API的Spring Data模块都支持XML配置。
>  “Repository query keywords” covers the query method keywords supported by the repository abstraction in general.
> “存储库查询关键字”一般包括存储库抽象所支持的查询方法关键字。
> For detailed information on the specific features of your module, see the chapter on that module of this document.
> 有关模块特定功能的详细信息，请参阅本文档中该模块的章节。
>

## 4.1. Core concepts

The central interface in the Spring Data repository abstraction is `Repository`.

It takes the domain class to manage as well as the ID type of the domain class as type arguments. 

它接受要管理的域类以及域类的ID类型作为类型参数。

This interface acts primarily as a marker interface to capture the types to work with and to help you to discover interfaces that extend this one.

该接口主要作为一个标记接口来捕获要使用的类型，并帮助您发现扩展该接口的接口。

The `CrudRepository` and `ListCrudRepository` interfaces provide sophisticated CRUD functionality for the entity class that is being managed.

*Example 1. CrudRepository Interface*

```java
public interface CrudRepository<T, ID> extends Repository<T, ID> {
    <S extends T> S save(S entity); //	Saves the given entity.
    Optional<T> findById(ID primaryKey); // Returns the entity identified by the given ID.
    Iterable<T> findAll(); // Returns all entities.
    long count();   // 	Returns the number of entities.
    void delete(T entity);  //	Deletes the given entity.
    boolean existsById(ID primaryKey); // 	Indicates whether an entity with the given ID exists.
```

`ListCrudRepository` offers equivalent methods, but they return `List` where the `CrudRepository` methods return an `Iterable`.

> We also provide persistence technology-specific abstractions, such as `JpaRepository` or `MongoRepository`. 
> 
> Those interfaces extend `CrudRepository` and expose the capabilities of the underlying persistence technology in addition to the rather generic persistence technology-agnostic interfaces such as `CrudRepository`.
>
> 这些接口扩展了“CrudRepository”，并公开了底层持久性技术的功能，除此之外，还有一些相当通用的与持久性技术无关的接口，比如“CrudRepository”。
>

Additional to the `CrudRepository`, there is a `PagingAndSortingRepository` abstraction that adds additional methods to ease paginated access to entities:

- paginate v. 为……标页数

*Example 2. PagingAndSortingRepository interface*

```java
public interface PagingAndSortingRepository<T, ID>  {

  Iterable<T> findAll(Sort sort);

  Page<T> findAll(Pageable pageable);
}
```

To access the second page of `User` by a page size of 20, you could do something like the following:

```java
PagingAndSortingRepository<User, Long> repository = // … get access to a bean
Page<User> users = repository.findAll(PageRequest.of(1, 20));
```

In addition to query methods, query derivation for both count and delete queries is available. 

除了查询方法之外，还提供了计数查询和删除查询的查询派生。

The following list shows the interface definition for a derived count query:

- derivation n. 起源，由来；派生，词源；求导，导数 adj. 导出的；衍生的，派生的

*Example 3. Derived Count Query*

```java
interface UserRepository extends CrudRepository<User, Long> {
  long countByLastname(String lastname);
}
```

The following listing shows the interface definition for a derived delete query:

*Example 4. Derived Delete Query*

```java
interface UserRepository extends CrudRepository<User, Long> {

  long deleteByLastname(String lastname);

  List<User> removeByLastname(String lastname);
}
```

## 4.2. Query Methods

Standard CRUD functionality repositories usually have queries on the underlying datastore.

标准CRUD功能存储库通常具有对底层数据存储的查询。

With Spring Data, declaring those queries becomes a four-step process:

1. Declare an interface extending Repository or one of its subinterfaces and type it to the domain class and ID type that it should handle, as shown in the following example:

```java
interface PersonRepository extends Repository<Person, Long> { … }
```

2. Declare query methods on the interface.

```java
interface PersonRepository extends Repository<Person, Long> {
  List<Person> findByLastname(String lastname);
}
```

3. Set up Spring to create proxy instances for those interfaces, either with JavaConfig or with XML configuration.

```java
import org.springframework.data.….repository.config.EnableJpaRepositories;

@EnableJpaRepositories
class Config { … }
```

The JPA namespace is used in this example.

If you use the repository abstraction for any other store, you need to change this to the appropriate namespace declaration of your store module. 

In other words, you should exchange `jpa` in favor of, for example, `mongodb`.

Note that the JavaConfig variant does not configure a package explicitly, because the package of the annotated class is used by default. To customize the package to scan, use one of the` basePackage…` attributes of the data-store-specific repository’s `@EnableJpaRepositories`-annotation.

4. Inject the repository instance and use it, as shown in the following example:

```java
class SomeClient {

  private final PersonRepository repository;

  SomeClient(PersonRepository repository) {
    this.repository = repository;
  }

  void doSomething() {
    List<Person> persons = repository.findByLastname("Matthews");
  }
}
```

The sections that follow explain each step in detail:

- Defining Repository Interfaces

- Defining Query Methods

- Creating Repository Instances

- Custom Implementations for Spring Data Repositories

## 4.3. Defining Repository Interfaces

To define a repository interface, you first need to define a domain class-specific repository interface.

The interface must extend `Repository` and be typed to the domain class and an ID type. 

If you want to expose CRUD methods for that domain type, you may extend `CrudRepository`, or one of its variants instead of `Repository`.

### 4.3.1. Fine-tuning Repository Definition

- Fine-tuning v.调整（fine-tune 的 ing 形式）

There are a few variants how you can get started with your repository interface.

The typical approach is to extend `CrudRepository`, which gives you methods for CRUD functionality. 

CRUD stands for Create, Read, Update, Delete. 

With version 3.0 we also introduced `ListCrudRepository` which is very similar to the `CrudRepository` but for those methods that return multiple entities it returns a `List` instead of an `Iterable` which you might find easier to use.

If you are using a reactive store you might choose `ReactiveCrudRepository`, or `RxJava3CrudRepository` depending on which reactive framework you are using.

If you are using Kotlin you might pick `CoroutineCrudRepository` which utilizes Kotlin’s coroutines.

Additional you can extend `PagingAndSortingRepository`, `ReactiveSortingRepository`, `RxJava3SortingRepository`, or `CoroutineSortingRepository` if you need methods that allow to specify a `Sort` abstraction or in the first case a `Pageable` abstraction. 

Note that the various sorting repositories no longer extended their respective CRUD repository as they did in Spring Data Versions pre 3.0. 

请注意，不同的排序存储库不再像Spring Data Versions pre 3.0中那样扩展各自的CRUD存储库。

Therefore, you need to extend both interfaces if you want functionality of both.

If you do not want to extend Spring Data interfaces, you can also annotate your repository interface with `@RepositoryDefinition`. 

Extending one of the CRUD repository interfaces exposes a complete set of methods to manipulate your entities.

If you prefer to be selective about the methods being exposed, copy the methods you want to expose from the CRUD repository into your domain repository.

When doing so, you may change the return type of methods. 

Spring Data will honor the return type if possible. 
如果可能，Spring Data将遵循返回类型。

For example, for methods returning multiple entities you may choose `Iterable<T>`, `List<T>`, `Collection<T>` or a VAVR list.


If many repositories in your application should have the same set of methods you can define your own base interface to inherit from. 

Such an interface must be annotated with `@NoRepositoryBean`. This prevents Spring Data to try to create an instance of it directly and failing because it can’t determine the entity for that repository, since it still contains a generic type variable.

The following example shows how to selectively expose CRUD methods (findById and save, in this case):

*Example 5. Selectively exposing CRUD methods*

```java
@NoRepositoryBean
interface MyBaseRepository<T, ID> extends Repository<T, ID> {

  Optional<T> findById(ID id);

  <S extends T> S save(S entity);
}

interface UserRepository extends MyBaseRepository<User, Long> {
  User findByEmailAddress(EmailAddress emailAddress);
}
```

In the prior example, you defined a common base interface for all your domain repositories and exposed `findById(…)` as well as `save(…)`.

These methods are routed into the base repository implementation of the store of your choice provided by Spring Data (for example, if you use JPA, the implementation is `SimpleJpaRepository`), because they match the method signatures in `CrudRepository`.

So the `UserRepository` can now save users, find individual users by ID, and trigger a query to find `Users` by email address.

> The intermediate repository interface is annotated with `@NoRepositoryBean`. 
> 中间存储库接口用“@NoRepositoryBean”进行了注释。
> Make sure you add that annotation to all repository interfaces for which Spring Data should not create instances at runtime.
>

### 4.3.2. Using Repositories with Multiple Spring Data Modules

## 4.4. Defining Query Methods

The repository proxy has two ways to derive a store-specific query from the method name:

- By deriving the query from the method name directly.
- By using a manually defined query.

Available options depend on the actual store. 

However, there must be a strategy that decides what actual query is created.

The next section describes the available options.

### 4.4.1. Query Lookup Strategies

### 4.4.2. Query Creation

### 4.4.3. Property Expressions

### 4.4.4. Special parameter handling

### 4.4.5. Limiting Query Results

### 4.4.6. Repository Methods Returning Collections or Iterables

### 4.4.7. Null Handling of Repository Methods

## 4.5. Creating Repository Instances

### 4.5.1. Java Configuration

### 4.5.2. XML Configuration

### 4.5.3. Using Filters

### 4.5.4. Standalone Usage

## 4.6. Custom Implementations for Spring Data Repositories

### 4.6.1. Customizing Individual Repositories

**Configuration**

### 4.6.2. Customize the Base Repository

## 4.7. Publishing Events from Aggregate Roots

## 4.8. Spring Data Extensions

### 4.8.1. Querydsl Extension

### 4.8.2. Web support

### 4.8.3. Repository Populators

