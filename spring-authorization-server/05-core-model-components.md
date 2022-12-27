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
```

## RegisteredClientRepository

`RegisteredClientRepository` 是可以注册新客户端和查询现有客户端的中心组件。

在遵循特定的协议流程时，它被其他组件使用，如客户端认证、授权授予处理、令牌反省、动态客户端注册等。

`RegisteredClientRepository` 提供的实现是 `InMemoryRegisteredClientRepository` 和 `JdbcRegisteredClientRepository`。 

`InMemoryRegisteredClientRepository` 实现将 `RegisteredClient` 实例存储在内存中， 建议仅在开发和测试期间使用。 

`JdbcRegisteredClientRepository` 是一个 JDBC 实现，它使用 `JdbcOperations` 持久化 `RegisteredClient` 实例。

> Note
> RegisteredClientRepository 是一个必需的组件。

以下示例显示了如何注册 `RegisteredClientRepository` `@Bean`：

```java
@Bean
public RegisteredClientRepository registeredClientRepository() {
	List<RegisteredClient> registrations = ...
	return new InMemoryRegisteredClientRepository(registrations);
}
```

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

OAuth2Authorization是一个OAuth2授权的表示，它持有与授予客户的授权有关的状态，由资源所有者授予，或者在client_credentials授权类型的情况下由其本身授予。

> Tips
> Spring Security 的 OAuth2 Client 支持中对应的授权模型是 OAuth2AuthorizedClient。

成功完成授权授权流程后，将创建 `OAuth2Authorization` 并将 `OAuth2AccessToken`、（可选）`OAuth2RefreshToken` 和特定于已执行授权授权类型的附加状态相关联。

与 OAuth2Authorization 关联的 OAuth2Token 实例会有所不同，具体取决于授权授予类型。

对于 OAuth2 授权码授权，一个 OAuth2AuthorizationCode、一个 OAuth2AccessToken 和一个（可选的）OAuth2RefreshToken 是相关联的。

对于 OpenID Connect 1.0 授权码授权，OAuth2AuthorizationCode、OidcIdToken、OAuth2AccessToken 和（可选）OAuth2RefreshToken 相关联。

对于 OAuth2 client_credentials 授权，仅关联一个 OAuth2AccessToken。

OAuth2Authorization 及其属性定义如下：

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

- id：唯一标识 OAuth2Authorization 的 ID。

- registeredClientId：唯一标识RegisteredClient的ID。

- principalName：资源所有者（或客户端）的主体名称。

- authorizationGrantType：使用的 AuthorizationGrantType。

- tokens：特定于执行的授权授予类型的 OAuth2Token 实例（和关联的元数据）。

- attributes：特定于已执行授权授予类型的附加属性——例如，已验证的 Principal、OAuth2AuthorizationRequest、授权范围等。

OAuth2Authorization 及其关联的 OAuth2Token 实例具有固定的生命周期。

新发布的 OAuth2Token 处于活动状态，并在过期或失效（撤销）时变为非活动状态。

当所有关联的 OAuth2Token 实例都处于非活动状态时，OAuth2Authorization （隐式）处于非活动状态。

每个 OAuth2Token 都保存在一个 OAuth2Authorization.

Token 中，它为 **isExpired()**、**isInvalidated()** 和 **isActive()** 提供访问器。

OAuth2Authorization.Token 还提供 getClaims()，它返回与 OAuth2Token 关联的声明（如果有）。

# OAuth2AuthorizationService

OAuth2AuthorizationService 是存储新授权和查询现有授权的中心组件。

在遵循特定的协议流程时，它被其他组件使用--例如，客户端认证、授权授予处理、令牌反省、令牌撤销、动态客户端注册等。

`OAuth2AuthorizationService` 提供的实现是 `InMemoryOAuth2AuthorizationService` 和 `JdbcOAuth2AuthorizationService`。

`InMemoryOAuth2AuthorizationService` 实现将 `OAuth2Authorization` 实例存储在内存中，建议仅在开发和测试期间使用。

`JdbcOAuth2AuthorizationService` 是一个 JDBC 实现，它使用 `JdbcOperations` 持久化 `OAuth2Authorization` 实例。

> Note
> OAuth2AuthorizationService 是一个可选组件，默认为 InMemoryOAuth2AuthorizationService。


以下示例显示如何注册 OAuth2AuthorizationService @Bean：

```java
@Bean
public OAuth2AuthorizationService authorizationService() {
	return new InMemoryOAuth2AuthorizationService();
}
```

或者，您可以通过 OAuth2AuthorizationServerConfigurer 配置 OAuth2AuthorizationService：

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

`OAuth2AuthorizationConsent` 是来自 `OAuth2` 授权请求流的授权“同意”（决定）的表示 - 例如，`authorization_code` 授权，它持有资源所有者授予客户端的权限。

当授权对客户端的访问时，资源所有者可以仅授予客户端请求的权限的子集。典型的用例是授权代码授权流程，其中客户端请求范围，资源所有者授予（或拒绝）对所请求范围的访问权限。

在完成 `OAuth2` 授权请求流程后，将创建（或更新）`OAuth2AuthorizationConsent` 并将授予的权限与客户端和资源所有者相关联。

OAuth2AuthorizationConsent 及其属性定义如下：

```java
public final class OAuth2AuthorizationConsent implements Serializable {
	private final String registeredClientId;    //(1)
	private final String principalName; //(2)
	private final Set<GrantedAuthority> authorities;    //(3)

	...

}
```

- registeredClientId：唯一标识RegisteredClient的ID。
- principalName：资源所有者的主体名称。
- 权限：资源所有者授予客户端的权限。权限可以表示范围、声明、权限、角色等。

# OAuth2AuthorizationConsentService(可选的)

`OAuth2AuthorizationConsentService` 是存储新授权同意和查询现有授权同意的中心组件。它主要由实现 OAuth2 授权请求流的组件使用——例如，authorization_code 授权。

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

`OAuth2TokenContext` 是一个上下文对象，它保存与 `OAuth2Token` 关联的信息，并由 `OAuth2TokenGenerator` 和 `OAuth2TokenCustomizer` 使用。

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

8 . `getAuthorizationGrant()`：处理授权授予的 `AuthenticationProvider` 使用的 `Authentication` 实例。


# OAuth2TokenGenerator

`OAuth2TokenGenerator` 负责从提供的 `OAuth2TokenContext` 中包含的信息生成 `OAuth2Token`。

生成的 `OAuth2Token` 主要取决于 `OAuth2TokenContext` 中指定的 `OAuth2TokenType` 的类型。

例如，当 `OAuth2TokenType` 的值为：

- `code`，就会生成`OAuth2AuthorizationCode`。

- `access_token`，然后生成`OAuth2AccessToken`。

- `refresh_token`，然后生成`OAuth2RefreshToken`。

- `id_token`，然后生成`OidcIdToken`。

此外，生成的`OAuth2AAccessToken`的格式是不同的，取决于为`RegisteredClient`配置的`TokenSettings.getAccessTokenFormat()`。

如果格式是`OAuth2TokenFormat.SELF_CONTAINED`（默认），那么就会生成一个`Jwt`。

如果格式是`OAuth2TokenFormat.REFERENCE`，那么就会生成一个 "不透明 "的令牌。

最后，如果生成的`OAuth2Token`有一组claims，并且实现了`ClaimAccessor`，那么索赔就可以从`OAuth2Authorization.Token.getClaims()`中获得。

`OAuth2TokenGenerator`主要由实现授权授予处理的组件使用--例如，`authorization_code`、`client_credentials`和`refresh_token`。

提供的实现是`OAuth2AccessTokenGenerator`、`OAuth2RefreshTokenGenerator`和`JwtGenerator`。`OAuth2AccessTokenGenerator`生成一个 "不透明的"（`OAuth2TokenFormat.REFERENCE`）访问令牌，而`JwtGenerator`生成一个`Jwt（OAuth2TokenFormat.SELF_CONTAINED）`。

> Note
> OAuth2TokenGenerator 是一个可选组件，默认为由 OAuth2AccessTokenGenerator 和 OAuth2RefreshTokenGenerator 组成的 DelegatingOAuth2TokenGenerator。


> Note
> 如果注册了 JwtEncoder @Bean 或 JWKSource<SecurityContext> @Bean，则在 DelegatingOAuth2TokenGenerator 中额外组合了一个 JwtGenerator。


`OAuth2TokenGenerator` 提供了极大的灵活性，因为它可以支持 `access_token` 和 `refresh_token` 的任何自定义令牌格式。


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

# OAuth2TokenCustomizer

`OAuth2TokenCustomizer` 提供了自定义 `OAuth2Token` 属性的能力，这些属性可在提供的 `OAuth2TokenContext` 中访问。 

`OAuth2TokenGenerator` 使用它来让它在生成 `OAuth2Token` 之前自定义它的属性。

使用通用类型 `OAuth2TokenClaimsContext`（实现 `OAuth2TokenContext`）声明的 `OAuth2TokenCustomizer<OAuth2TokenClaimsContext>` 提供了自定义“不透明”`OAuth2AccessToken` 声明的能力。 

`OAuth2TokenClaimsContext.getClaims()` 提供对 `OAuth2TokenClaimsSet.Builder` 的访问，允许添加、替换和删除声明。

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


使用通用类型的 `JwtEncodingContext`（实现 `OAuth2TokenContext`）声明的 `OAuth2TokenCustomizer<JwtEncodingContext>` 提供了自定义 `Jwt` 的标头和声明的能力。 

`JwtEncodingContext.getHeaders()` 提供对 `JwsHeader.Builder` 的访问，允许添加、替换和删除标头。 

`JwtEncodingContext.getClaims()` 提供对 `JwtClaimsSet.Builder` 的访问，允许添加、替换和删除声明。

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

# 协议端点







