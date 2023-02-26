# Core Model / Components

# RegisteredClient

A `RegisteredClient` is a representation of a client that is registered with the authorization server. A client must be registered with the authorization server before it can initiate an authorization grant flow, such as authorization_code or client_credentials.

`RegisteredClient` 是向授权服务器注册的客户端的表示形式。客户端必须先在授权服务器上注册，然后才能启动授权授予流，如`authorization_code`或`client_credentials`。

During client registration, the client is assigned a unique client identifier, (optionally) a client secret (depending on client type), and metadata associated with its unique client identifier.

在客户注册过程中，客户被分配一个独特的客户标识符，（可选）一个客户秘密（取决于客户类型），以及与其独特客户标识符相关的元数据。

 The client’s metadata can range from human-facing display strings (such as client name) to items specific to a protocol flow (such as the list of valid redirect URIs).

客户端元数据的范围可以从面向人的显示字符串（例如客户端名称）到特定于协议流的项目（例如有效重定向 URI 列表）。

The primary purpose of a client is to request access to protected resources. The client first requests an access token by authenticating with the authorization server and presenting the authorization grant. The authorization server authenticates the client and authorization grant, and, if they are valid, issues an access token. The client can now request the protected resource from the resource server by presenting the access token.

客户端的主要目的是请求访问受保护的资源。客户端首先通过与授权服务器进行身份验证并提供授权许可来请求访问令牌。授权服务器对客户端和授权授予进行身份验证，如果它们有效，则颁发访问令牌。客户端现在可以通过提供访问令牌从资源服务器请求受保护的资源。

The following example shows how to configure a `RegisteredClient` that is allowed to perform the `authorization_code grant` flow to request an access token:

以下示例显示了如何配置一个 RegisteredClient 允许执行 authentication_code 授权流程以请求访问令牌：

```java
RegisteredClient registeredClient = RegisteredClient.withId(UUID.randomUUID().toString())
	.clientId("client-a")
	.clientSecret("{noop}secret")   // 1
	.clientAuthenticationMethod(ClientAuthenticationMethod.CLIENT_SECRET_BASIC)
	.authorizationGrantType(AuthorizationGrantType.AUTHORIZATION_CODE)
	.redirectUri("http://127.0.0.1:8080/authorized")
	.scope("scope-a")
	.clientSettings(ClientSettings.builder().requireAuthorizationConsent(true).build())
	.build();
```

1 {noop} 表示 Spring Security 的 NoOpPasswordEncoder 的 PasswordEncoder id。

The corresponding configuration in Spring Security’s OAuth2 Client support is:

```yaml
spring:
  security:
    oauth2:
      client:
        registration:
          client-a:
            provider: spring
            client-id: client-a
            client-secret: secret
            authorization-grant-type: authorization_code
            redirect-uri: "http://127.0.0.1:8080/authorized"
            scope: scope-a
        provider:
          spring:
            issuer-uri: http://localhost:9000
```

A `RegisteredClient` has metadata (attributes) associated with its unique Client Identifier and is defined as follows:

```java
public class RegisteredClient implements Serializable {
	private String id;  (1)
	private String clientId;    (2)
	private Instant clientIdIssuedAt;   (3)
	private String clientSecret;    (4)
	private Instant clientSecretExpiresAt;  (5)
	private String clientName;  (6)
	private Set<ClientAuthenticationMethod> clientAuthenticationMethods;    (7)
	private Set<AuthorizationGrantType> authorizationGrantTypes;    (8)
	private Set<String> redirectUris;   (9)
	private Set<String> scopes; (10)
	private ClientSettings clientSettings;  (11)
	private TokenSettings tokenSettings;    (12)

	...

}
```

1. `id`: The ID that uniquely identifies the `RegisteredClient`.
2. `clientId`: The client identifier.
3. `clientIdIssuedAt`: The time at which the client identifier was issued.
4. `clientSecret`: The client’s secret. The value should be encoded using Spring Security’s PasswordEncoder.
5. `clientSecretExpiresAt`: The time at which the client secret expires.
6. `clientName`: A descriptive name used for the client. The name may be used in certain scenarios, such as when displaying the client name in the consent page.
7. `clientAuthenticationMethods`: The authentication method(s) that the client may use. The supported values are `client_secret_basic`, `client_secret_post`, `private_key_jwt`, `client_secret_jwt`, and `none` (public clients).
8. `authorizationGrantTypes`: The authorization grant type(s) that the client can use. The supported values are `authorization_code`, `client_credentials`, and `refresh_token`.
9. `redirectUris`: The registered redirect URI(s) that the client may use in redirect-based flows – for example, `authorization_code` grant.
10. `scopes`: The scope(s) that the client is allowed to request.
11. `clientSettings`: The custom settings for the client – for example, require PKCE, require authorization consent, and others.
12. `tokenSettings`: The custom settings for the OAuth2 tokens issued to the client – for example, access/refresh token time-to-live, reuse refresh tokens, and others.

## RegisteredClientRepository


The `RegisteredClientRepository` is the central component where new clients can be registered and existing clients can be queried. 

`RegisteredClientRepository` 是可以注册新客户端和查询现有客户端的中心组件。

It is used by other components when following a specific protocol flow, such as client authentication, authorization grant processing, token introspection, dynamic client registration, and others.

在遵循特定的协议流程时，它被其他组件使用，如客户端认证、授权授予处理、令牌反省、动态客户端注册等。

The provided implementations of `RegisteredClientRepository` are `InMemoryRegisteredClientRepository` and `JdbcRegisteredClientRepository`. 

`RegisteredClientRepository` 提供的实现是 `InMemoryRegisteredClientRepository` 和 `JdbcRegisteredClientRepository`。 

The `InMemoryRegisteredClientRepository` implementation stores `RegisteredClient` instances in-memory and is recommended ONLY to be used during development and testing.

`InMemoryRegisteredClientRepository` 实现将 `RegisteredClient` 实例存储在内存中， 建议仅在开发和测试期间使用。 

`JdbcRegisteredClientRepository` is a JDBC implementation that persists `RegisteredClient` instances by using JdbcOperations.

`JdbcRegisteredClientRepository` 是一个 JDBC 实现，它使用 `JdbcOperations` 持久化 `RegisteredClient` 实例。

> Note
> RegisteredClientRepository 是一个必需的组件。

The following example shows how to register a `RegisteredClientRepository` `@Bean`:

以下示例显示了如何注册 `RegisteredClientRepository` `@Bean`：

```java
@Bean
public RegisteredClientRepository registeredClientRepository() {
	List<RegisteredClient> registrations = ...
	return new InMemoryRegisteredClientRepository(registrations);
}
```

Alternatively, you can configure the `RegisteredClientRepository` through the `OAuth2AuthorizationServerConfigurer`:

或者，您可以通过 OAuth2AuthorizationServerConfigurer 配置 RegisteredClientRepository：

```java
@Bean
public SecurityFilterChain authorizationServerSecurityFilterChain(HttpSecurity http) throws Exception {
	OAuth2AuthorizationServerConfigurer<HttpSecurity> authorizationServerConfigurer =
		new OAuth2AuthorizationServerConfigurer<>();
	http.apply(authorizationServerConfigurer);

	authorizationServerConfigurer
		.registeredClientRepository(registeredClientRepository);

	...

	return http.build();
}
```

> OAuth2AuthorizationServerConfigurer在同时应用多个配置选项时非常有用。

# OAuth2Authorization

An `OAuth2Authorization` is a representation of an OAuth2 authorization, which holds state related to the authorization granted to a client, by the resource owner or itself in the case of the `client_credentials` authorization grant type.

OAuth2Authorization是一个OAuth2授权的表示，它持有与授予客户的授权有关的状态，由资源所有者授予，或者在client_credentials授权类型的情况下由其本身授予。

> Tips
> Spring Security 的 OAuth2 Client 支持中对应的授权模型是 OAuth2AuthorizedClient。
>

After the successful completion of an authorization grant flow, an `OAuth2Authorization` is created and associates an `OAuth2AccessToken`, an (optional) `OAuth2RefreshToken`, and additional state specific to the executed authorization grant type.

成功完成授权授权流程后，将创建 `OAuth2Authorization` 并将 `OAuth2AccessToken`、（可选）`OAuth2RefreshToken` 和特定于已执行授权授权类型的附加状态相关联。

The `OAuth2Token` instances associated with an `OAuth2Authorization` vary, depending on the authorization grant type.

与 OAuth2Authorization 关联的 OAuth2Token 实例会有所不同，具体取决于授权授予类型。

For the OAuth2 `authorization_code grant`, an `OAuth2AuthorizationCode`, an `OAuth2AccessToken`, and an (optional) `OAuth2RefreshToken` are associated.

对于 OAuth2 授权码授权，一个 OAuth2AuthorizationCode、一个 OAuth2AccessToken 和一个（可选的）OAuth2RefreshToken 是相关联的。

For the OpenID Connect 1.0 `authorization_code` grant, an `OAuth2AuthorizationCode`, an `OidcIdToken`, an `OAuth2AccessToken`, and an (optional) `OAuth2RefreshToken` are associated.

对于 OpenID Connect 1.0 授权码授权，OAuth2AuthorizationCode、OidcIdToken、OAuth2AccessToken 和（可选）OAuth2RefreshToken 相关联。

For the OAuth2 `client_credentials` grant, only an `OAuth2AccessToken` is associated.

对于 OAuth2 client_credentials 授权，仅关联一个 OAuth2AccessToken。

`OAuth2Authorization` and its attributes are defined as follows:

`OAuth2Authorization` 及其属性定义如下：

```java
public class OAuth2Authorization implements Serializable {
	private String id; // 1 
	private String registeredClientId; // 2  
	private String principalName;   // 3
	private AuthorizationGrantType authorizationGrantType; // 4
	private Map<Class<? extends OAuth2Token>, Token<?>> tokens; // 5 
	private Map<String, Object> attributes;  // 6

	...

}
```


1. `id`: The ID that uniquely identifies the OAuth2Authorization.
2. `registeredClientId`: The ID that uniquely identifies the RegisteredClient.
3. `principalName`: The principal name of the resource owner (or client).
4. `authorizationGrantType`: The AuthorizationGrantType used.
5. `authorizedScopes`: The Set of scope(s) authorized for the client.
6. `tokens`: The OAuth2Token instances (and associated metadata) specific to the executed authorization grant type.
7. `attributes`: The additional attributes specific to the executed authorization grant type – for example, the authenticated Principal, OAuth2AuthorizationRequest, and others.


1. id：唯一标识 OAuth2Authorization 的 ID。

2. registeredClientId：唯一标识RegisteredClient的ID。

3. principalName：资源所有者（或客户端）的主体名称。

4. authorizationGrantType：使用的 AuthorizationGrantType。

5. tokens：特定于执行的授权授予类型的 OAuth2Token 实例（和关联的元数据）。

6. attributes：特定于已执行授权授予类型的附加属性——例如，已验证的 Principal、OAuth2AuthorizationRequest、授权范围等。

`OAuth2Authorization` and its associated `OAuth2Token` instances have a set lifespan. 

OAuth2Authorization 及其关联的 OAuth2Token 实例具有固定的生命周期。

A newly issued `OAuth2Token` is active and becomes inactive when it either expires or is invalidated (revoked). 

新发布的 OAuth2Token 处于活动状态，并在过期或失效（撤销）时变为非活动状态。

The `OAuth2Authorization` is (implicitly) inactive when all associated `OAuth2Token` instances are inactive. 

当所有关联的 OAuth2Token 实例都处于非活动状态时，OAuth2Authorization （隐式）处于非活动状态。

Each `OAuth2Token` is held in an `OAuth2Authorization.Token`, which provides accessors for `isExpired()`, `isInvalidated()`, and `isActive().`

每个 `OAuth2Token` 都保存在一个 `OAuth2Authorization.Token` 中，它为 **isExpired()**、**isInvalidated()** 和 **isActive()** 提供访问器。

`OAuth2Authorization.Token` also provides `getClaims()`, which returns the claims (if any) associated with the `OAuth2Token`.

`OAuth2Authorization.Token` 还提供 `getClaims()`，它返回与 `OAuth2Token` 关联的声明（如果有）。

# OAuth2AuthorizationService

The `OAuth2AuthorizationService` is the central component where new authorizations are stored and existing authorizations are queried. 

`OAuth2AuthorizationService` 是存储新授权和查询现有授权的中心组件。

It is used by other components when following a specific protocol flow – for example, client authentication, authorization grant processing, token introspection, token revocation, dynamic client registration, and others.

在遵循特定的协议流程时，它被其他组件使用--例如，客户端认证、授权授予处理、令牌反省、令牌撤销、动态客户端注册等。

The provided implementations of `OAuth2AuthorizationService` are `InMemoryOAuth2AuthorizationService` and `JdbcOAuth2AuthorizationService`. 

`OAuth2AuthorizationService` 提供的实现是 `InMemoryOAuth2AuthorizationService` 和 `JdbcOAuth2AuthorizationService`。

 The `InMemoryOAuth2AuthorizationService` implementation stores `OAuth2Authorization` instances in-memory and is recommended ONLY to be used during development and testing.

`InMemoryOAuth2AuthorizationService` 实现将 `OAuth2Authorization` 实例存储在内存中，建议仅在开发和测试期间使用。

`JdbcOAuth2AuthorizationService` is a JDBC implementation that persists `OAuth2Authorization` instances by using `JdbcOperations`.

`JdbcOAuth2AuthorizationService` 是一个 JDBC 实现，它使用 `JdbcOperations` 持久化 `OAuth2Authorization` 实例。

> Note
> OAuth2AuthorizationService 是一个可选组件，默认为 InMemoryOAuth2AuthorizationService。

The following example shows how to register an `OAuth2AuthorizationService` `@Bean`:

以下示例显示如何注册 OAuth2AuthorizationService @Bean：

```java
@Bean
public OAuth2AuthorizationService authorizationService() {
	return new InMemoryOAuth2AuthorizationService();
}
```

Alternatively, you can configure the `OAuth2AuthorizationService` through the `OAuth2AuthorizationServerConfigurer`:

或者，您可以通过 `OAuth2AuthorizationServerConfigurer` 配置 `OAuth2AuthorizationService`：

```java
@Bean
public SecurityFilterChain authorizationServerSecurityFilterChain(HttpSecurity http) throws Exception {
	OAuth2AuthorizationServerConfigurer<HttpSecurity> authorizationServerConfigurer =
		new OAuth2AuthorizationServerConfigurer<>();
	http.apply(authorizationServerConfigurer);

	authorizationServerConfigurer
		.authorizationService(authorizationService);

	...

	return http.build();
}
```

# OAuth2AuthorizationConsent

An `OAuth2AuthorizationConsent` is a representation of an authorization "consent" (decision) from an OAuth2 authorization request flow – for example, the `authorization_code` grant, which holds the authorities granted to a client by the resource owner.

`OAuth2AuthorizationConsent` 是来自 `OAuth2` 授权请求流的授权“同意”（决定）的表示 - 例如，`authorization_code` 授权，它持有资源所有者授予客户端的权限。

When authorizing access to a client, the resource owner may grant only a subset of the authorities requested by the client. The typical use case is the authorization_code grant flow, in which the client requests scope(s) and the resource owner grants (or denies) access to the requested scope(s).

当授权对客户端的访问时，资源所有者可以仅授予客户端请求的权限的子集。典型的用例是授权代码授权流程，其中客户端请求范围，资源所有者授予（或拒绝）对所请求范围的访问权限。

After the completion of an OAuth2 authorization request flow, an `OAuth2AuthorizationConsent` is created (or updated) and associates the granted authorities with the client and resource owner.

在完成 `OAuth2` 授权请求流程后，将创建（或更新）`OAuth2AuthorizationConsent` 并将授予的权限与客户端和资源所有者相关联。

`OAuth2AuthorizationConsent` and its attributes are defined as follows:

OAuth2AuthorizationConsent 及其属性定义如下：

```java
public final class OAuth2AuthorizationConsent implements Serializable {
	private final String registeredClientId;    //(1)
	private final String principalName; //(2)
	private final Set<GrantedAuthority> authorities;    //(3)

	...

}
```

1. registeredClientId：唯一标识RegisteredClient的ID。
2. principalName：资源所有者的主体名称。
3. 权限：资源所有者授予客户端的权限。权限可以表示范围、声明、权限、角色等。

1. registeredClientId: The ID that uniquely identifies the RegisteredClient.
2. principalName: The principal name of the resource owner.
3. authorities: The authorities granted to the client by the resource owner. An authority can represent a scope, a claim, a permission, a role, and others.

# OAuth2AuthorizationConsentService(可选的)

The `OAuth2AuthorizationConsentService` is the central component where new authorization consents are stored and existing authorization consents are queried.

`OAuth2AuthorizationConsentService` 是存储新授权同意和查询现有授权同意的中心组件。

It is primarily used by components that implement an OAuth2 authorization request flow – for example, the `authorization_code` grant.

它主要由实现 OAuth2 授权请求流的组件使用——例如，authorization_code 授权。

The provided implementations of `OAuth2AuthorizationConsentService` are `InMemoryOAuth2AuthorizationConsentService` and `JdbcOAuth2AuthorizationConsentService`. 

`OAuth2AuthorizationConsentService` 提供的实现是 `InMemoryOAuth2AuthorizationConsentService` 和 `JdbcOAuth2AuthorizationConsentService`。 

`InMemoryOAuth2AuthorizationConsentService` 实现将 OAuth2AuthorizationConsent 实例存储在内存中，建议仅用于开发和测试。 

`JdbcOAuth2AuthorizationConsentService` 是一个 JDBC 实现，它使用 `JdbcOperations` 持久化 `OAuth2AuthorizationConsent` 实例。

> Note
> OAuth2AuthorizationConsentService 是一个可选组件，默认为 InMemoryOAuth2AuthorizationConsentService。


以下示例显示如何注册 `OAuth2AuthorizationConsentService` `@Bean`：

```java
@Bean
public OAuth2AuthorizationConsentService authorizationConsentService() {
	return new InMemoryOAuth2AuthorizationConsentService();
}
```

或者，您可以通过 `OAuth2AuthorizationServerConfigurer` 配置 `OAuth2AuthorizationConsentService`：

```java
@Bean
public SecurityFilterChain authorizationServerSecurityFilterChain(HttpSecurity http) throws Exception {
	OAuth2AuthorizationServerConfigurer<HttpSecurity> authorizationServerConfigurer =
		new OAuth2AuthorizationServerConfigurer<>();
	http.apply(authorizationServerConfigurer);

	authorizationServerConfigurer
		.authorizationConsentService(authorizationConsentService);

	...

	return http.build();
}
```

# OAuth2TokenContext

An `OAuth2TokenContext` is a context object that holds information associated with an `OAuth2Token` and is used by an `OAuth2TokenGenerator` and `OAuth2TokenCustomizer`.

`OAuth2TokenContext` 是一个上下文对象，它保存与 `OAuth2Token` 关联的信息，并由 `OAuth2TokenGenerator` 和 `OAuth2TokenCustomizer` 使用。

`OAuth2TokenContext` provides the following accessors:

OAuth2TokenContext 提供以下访问器：

```java
public interface OAuth2TokenContext extends Context {

	default RegisteredClient getRegisteredClient() ...  // 1

	default <T extends Authentication> T getPrincipal() ... // 2

	default ProviderContext getProviderContext() ...    // 3

	@Nullable
	default OAuth2Authorization getAuthorization() ...  // 4 

	default Set<String> getAuthorizedScopes() ...   // 5

	default OAuth2TokenType getTokenType() ...  // 6

	default AuthorizationGrantType getAuthorizationGrantType() ... // 7  

	default <T extends Authentication> T getAuthorizationGrant() ...  // 8  

	...

}
```

1. `getRegisteredClient()`：与授权授予关联的 `RegisteredClient`。

2. `getPrincipal()`：资源所有者（或客户端）的身份验证实例。

3. `getProviderContext()`： `ProviderContext` 对象，包含与提供者相关的信息。

4. `getAuthorization()`：与授权授予关联的 `OAuth2Authorization`。

5. `getAuthorizedScopes()`：为客户端授权的范围。

6. `getTokenType()`：要生成的 `OAuth2TokenType`。支持的值为 `code`、`access_token`、`refresh_token` 和 `id_token`。

7. `getAuthorizationGrantType()`：与授权授予关联的 `AuthorizationGrantType`。

8. `getAuthorizationGrant()`：处理授权授予的 `AuthenticationProvider` 使用的 `Authentication` 实例。

1. `getRegisteredClient()`: The RegisteredClient associated with the authorization grant.
2. `getPrincipal()`: The Authentication instance of the resource owner (or client).
3. `getAuthorizationServerContext()`: The AuthorizationServerContext object that holds information of the Authorization Server runtime environment.
4. `getAuthorization()`: The OAuth2Authorization associated with the authorization grant.
5. `getAuthorizedScopes()`: The scope(s) authorized for the client.
6. `getTokenType()`: The OAuth2TokenType to generate. The supported values are code, access_token, refresh_token, and id_token.
7. `getAuthorizationGrantType()`: The AuthorizationGrantType associated with the authorization grant.
8. `getAuthorizationGrant()`: The Authentication instance used by the AuthenticationProvider that processes the authorization grant.

# OAuth2TokenGenerator

An `OAuth2TokenGenerator` is responsible for generating an `OAuth2Token` from the information contained in the provided `OAuth2TokenContext`.

`OAuth2TokenGenerator` 负责从提供的 `OAuth2TokenContext` 中包含的信息生成 `OAuth2Token`。

The `OAuth2Token` generated primarily depends on the type of `OAuth2TokenType` specified in the `OAuth2TokenContext`.

生成的 `OAuth2Token` 主要取决于 `OAuth2TokenContext` 中指定的 `OAuth2TokenType` 的类型。

For example, when the value for `OAuth2TokenType` is:

- `code`, then OAuth2AuthorizationCode is generated.

- `access_token`, then OAuth2AccessToken is generated.

- `refresh_token`, then OAuth2RefreshToken is generated.

- `id_token`, then OidcIdToken is generated.

例如，当 `OAuth2TokenType` 的值为：

- `code`，就会生成`OAuth2AuthorizationCode`。

- `access_token`，然后生成`OAuth2AccessToken`。

- `refresh_token`，然后生成`OAuth2RefreshToken`。

- `id_token`，然后生成`OidcIdToken`。

Furthermore, the format of the generated `OAuth2AccessToken` varies, depending on the `TokenSettings.getAccessTokenFormat()` configured for the `RegisteredClient`. 

此外，生成的`OAuth2AAccessToken`的格式是不同的，取决于为`RegisteredClient`配置的`TokenSettings.getAccessTokenFormat()`。

If the format is `OAuth2TokenFormat.SELF_CONTAINED` (the default), then a Jwt is generated. 

如果格式是`OAuth2TokenFormat.SELF_CONTAINED`（默认），那么就会生成一个`Jwt`。

If the format is `OAuth2TokenFormat.REFERENCE`, then an "opaque" token is generated.

如果格式是`OAuth2TokenFormat.REFERENCE`，那么就会生成一个 "不透明 "的令牌。

Finally, if the generated `OAuth2Token` has a set of claims and implements `ClaimAccessor`, the claims are made accessible from `OAuth2Authorization.Token.getClaims()`.

最后，如果生成的`OAuth2Token`有一组claims，并且实现了`ClaimAccessor`，那么索赔就可以从`OAuth2Authorization.Token.getClaims()`中获得。

The `OAuth2TokenGenerator` is primarily used by components that implement authorization grant processing – for example, `authorization_code`, `client_credentials`, and `refresh_token`.

`OAuth2TokenGenerator`主要由实现授权授予处理的组件使用--例如，`authorization_code`、`client_credentials`和`refresh_token`。

The provided implementations are `OAuth2AccessTokenGenerator`, `OAuth2RefreshTokenGenerator`, and `JwtGenerator`. The `OAuth2AccessTokenGenerator` generates an "opaque" (`OAuth2TokenFormat.REFERENCE`) access token, and the `JwtGenerator` generates a Jwt (`OAuth2TokenFormat.SELF_CONTAINED`).

提供的实现是`OAuth2AccessTokenGenerator`、`OAuth2RefreshTokenGenerator`和`JwtGenerator`。`OAuth2AccessTokenGenerator`生成一个 "不透明的"（`OAuth2TokenFormat.REFERENCE`）访问令牌，而`JwtGenerator`生成一个`Jwt（OAuth2TokenFormat.SELF_CONTAINED）`。

> Note
> OAuth2TokenGenerator 是一个可选组件，默认为由 OAuth2AccessTokenGenerator 和 OAuth2RefreshTokenGenerator 组成的 DelegatingOAuth2TokenGenerator。


> Note
> 如果注册了 JwtEncoder @Bean 或 JWKSource<SecurityContext> @Bean，则在 DelegatingOAuth2TokenGenerator 中额外组合了一个 JwtGenerator。

The `OAuth2TokenGenerator` provides great flexibility, as it can support any custom token format for `access_token` and `refresh_token`.

`OAuth2TokenGenerator` 提供了极大的灵活性，因为它可以支持 `access_token` 和 `refresh_token` 的任何自定义令牌格式。

The following example shows how to register an `OAuth2TokenGenerator` `@Bean`:

以下示例显示如何注册 `OAuth2TokenGenerator` `@Bean`：

```java
@Bean
public OAuth2TokenGenerator<?> tokenGenerator() {
	JwtEncoder jwtEncoder = ...
	JwtGenerator jwtGenerator = new JwtGenerator(jwtEncoder);
	OAuth2AccessTokenGenerator accessTokenGenerator = new OAuth2AccessTokenGenerator();
	OAuth2RefreshTokenGenerator refreshTokenGenerator = new OAuth2RefreshTokenGenerator();
	return new DelegatingOAuth2TokenGenerator(
			jwtGenerator, accessTokenGenerator, refreshTokenGenerator);
}
```

Alternatively, you can configure the `OAuth2TokenGenerator` through the `OAuth2AuthorizationServerConfigurer`:

或者，您可以通过 `OAuth2AuthorizationServerConfigurer` 配置 `OAuth2TokenGenerator`：

```java
@Bean
public SecurityFilterChain authorizationServerSecurityFilterChain(HttpSecurity http) throws Exception {
	OAuth2AuthorizationServerConfigurer<HttpSecurity> authorizationServerConfigurer =
		new OAuth2AuthorizationServerConfigurer<>();
	http.apply(authorizationServerConfigurer);

	authorizationServerConfigurer
		.tokenGenerator(tokenGenerator);

	...

	return http.build();
}
```

>The `OAuth2AuthorizationServerConfigurer` is useful when applying multiple configuration options simultaneously.

# OAuth2TokenCustomizer

An `OAuth2TokenCustomizer` provides the ability to customize the attributes of an `OAuth2Token`, which are accessible in the provided `OAuth2TokenContext`.

`OAuth2TokenCustomizer` 提供了自定义 `OAuth2Token` 属性的能力，这些属性可在提供的 `OAuth2TokenContext` 中访问。 

It is used by an `OAuth2TokenGenerator` to let it customize the attributes of the `OAuth2Token` before it is generated.

`OAuth2TokenGenerator` 使用它来让它在生成 `OAuth2Token` 之前自定义它的属性。

An `OAuth2TokenCustomizer<OAuth2TokenClaimsContext>` declared with a generic type of `OAuth2TokenClaimsContext` (implements `OAuth2TokenContext`) provides the ability to customize the claims of an "opaque" `OAuth2AccessToken`.

使用通用类型 `OAuth2TokenClaimsContext`（实现 `OAuth2TokenContext`）声明的 `OAuth2TokenCustomizer<OAuth2TokenClaimsContext>` 提供了自定义“不透明”`OAuth2AccessToken` 声明的能力。 

`OAuth2TokenClaimsContext.getClaims()` provides access to the `OAuth2TokenClaimsSet.Builder`, allowing the ability to add, replace, and remove claims.

`OAuth2TokenClaimsContext.getClaims()` 提供对 `OAuth2TokenClaimsSet.Builder` 的访问，允许添加、替换和删除声明。

The following example shows how to implement an `OAuth2TokenCustomizer<OAuth2TokenClaimsContext>` and configure it with an `OAuth2AccessTokenGenerator`:

以下示例显示了如何实现 `OAuth2TokenCustomizer<OAuth2TokenClaimsContext>` 并使用 `OAuth2AccessTokenGenerator` 对其进行配置：

```java
@Bean
public OAuth2TokenGenerator<?> tokenGenerator() {
        JwtEncoder jwtEncoder = ...
        JwtGenerator jwtGenerator = new JwtGenerator(jwtEncoder);
        OAuth2AccessTokenGenerator accessTokenGenerator = new OAuth2AccessTokenGenerator();
        accessTokenGenerator.setAccessTokenCustomizer(accessTokenCustomizer());
        OAuth2RefreshTokenGenerator refreshTokenGenerator = new OAuth2RefreshTokenGenerator();
        return new DelegatingOAuth2TokenGenerator(
        jwtGenerator, accessTokenGenerator, refreshTokenGenerator);
        }

@Bean
public OAuth2TokenCustomizer<OAuth2TokenClaimsContext> accessTokenCustomizer() {
        return context -> {
        OAuth2TokenClaimsSet.Builder claims = context.getClaims();
        // Customize claims

        };
}
```

> Note
> 如果 OAuth2TokenGenerator 未作为 @Bean 提供或未通过 OAuth2AuthorizationServerConfigurer 配置，则 OAuth2TokenCustomizer<OAuth2TokenClaimsContext> @Bean 将自动配置 OAuth2AccessTokenGenerator。


An `OAuth2TokenCustomizer<JwtEncodingContext>` declared with a generic type of `JwtEncodingContext` (implements `OAuth2TokenContext`) provides the ability to customize the headers and claims of a `Jwt`. 

使用通用类型的 `JwtEncodingContext`（实现 `OAuth2TokenContext`）声明的 `OAuth2TokenCustomizer<JwtEncodingContext>` 提供了自定义 `Jwt` 的标头和声明的能力。 

`JwtEncodingContext.getHeaders()` provides access to the `JwsHeader.Builder`, allowing the ability to add, replace, and remove headers. 

`JwtEncodingContext.getHeaders()` 提供对 `JwsHeader.Builder` 的访问，允许添加、替换和删除标头。 

`JwtEncodingContext.getClaims()` provides access to the `JwtClaimsSet.Builder`, allowing the ability to add, replace, and remove claims.

`JwtEncodingContext.getClaims()` 提供对 `JwtClaimsSet.Builder` 的访问，允许添加、替换和删除声明。

The following example shows how to implement an `OAuth2TokenCustomizer<JwtEncodingContext>` and configure it with a `JwtGenerator`:

以下示例显示了如何实现 `OAuth2TokenCustomizer<JwtEncodingContext>` 并使用 `JwtGenerator` 对其进行配置：

```java
@Bean
public OAuth2TokenGenerator<?> tokenGenerator() {
	JwtEncoder jwtEncoder = ...
	JwtGenerator jwtGenerator = new JwtGenerator(jwtEncoder);
	jwtGenerator.setJwtCustomizer(jwtCustomizer());
	OAuth2AccessTokenGenerator accessTokenGenerator = new OAuth2AccessTokenGenerator();
	OAuth2RefreshTokenGenerator refreshTokenGenerator = new OAuth2RefreshTokenGenerator();
	return new DelegatingOAuth2TokenGenerator(
			jwtGenerator, accessTokenGenerator, refreshTokenGenerator);
}

@Bean
public OAuth2TokenCustomizer<JwtEncodingContext> jwtCustomizer() {
	return context -> {
		JwsHeader.Builder headers = context.getHeaders();
		JwtClaimsSet.Builder claims = context.getClaims();
		if (context.getTokenType().equals(OAuth2TokenType.ACCESS_TOKEN)) {
			// Customize headers/claims for access_token

		} else if (context.getTokenType().getValue().equals(OidcParameterNames.ID_TOKEN)) {
			// Customize headers/claims for id_token

		}
	};
}
```

>If the `OAuth2TokenGenerator` is not provided as a `@Bean` or is not configured through the `OAuth2AuthorizationServerConfigurer`, an `OAuth2TokenCustomizer<JwtEncodingContext>` `@Bean` will automatically be configured with a `JwtGenerator`.








