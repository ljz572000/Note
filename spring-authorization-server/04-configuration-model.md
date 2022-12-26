# Configuration Model

## Default configuration

`OAuth2AuthorizationServerConfiguration` is a `@Configuration` that provides the minimal default configuration for an OAuth2 authorization server.


`OAuth2AuthorizationServerConfiguration` uses `OAuth2AuthorizationServerConfigurer` to apply the default configuration and registers a `SecurityFilterChain` `@Bean` composed of all the infrastructure components supporting an OAuth2 authorization server.

The OAuth2 authorization server `SecurityFilterChain` `@Bean` is configured with the following default protocol endpoints:

- [OAuth2 Authorization endpoint](https://docs.spring.io/spring-authorization-server/docs/current/reference/html/protocol-endpoints.html#oauth2-authorization-endpoint)

- [OAuth2 Token endpoint](https://docs.spring.io/spring-authorization-server/docs/current/reference/html/protocol-endpoints.html#oauth2-token-endpoint)

- [OAuth2 Token Introspection endpoint](https://docs.spring.io/spring-authorization-server/docs/current/reference/html/protocol-endpoints.html#oauth2-token-introspection-endpoint)

- [OAuth2 Token Revocation endpoint](https://docs.spring.io/spring-authorization-server/docs/current/reference/html/protocol-endpoints.html#oauth2-token-revocation-endpoint)

- [OAuth2 Authorization Server Metadata endpoint](https://docs.spring.io/spring-authorization-server/docs/current/reference/html/protocol-endpoints.html#oauth2-authorization-server-metadata-endpoint)

- [JWK Set endpoint](https://docs.spring.io/spring-authorization-server/docs/current/reference/html/protocol-endpoints.html#jwk-set-endpoint)

The following example shows how to use `OAuth2AuthorizationServerConfiguration` to apply the minimal default configuration:

```java
@Configuration
@Import(OAuth2AuthorizationServerConfiguration.class)
public class AuthorizationServerConfig {

	@Bean
	public RegisteredClientRepository registeredClientRepository() {
		List<RegisteredClient> registrations = ...
		return new InMemoryRegisteredClientRepository(registrations);
	}

	@Bean
	public JWKSource<SecurityContext> jwkSource() {
		RSAKey rsaKey = ...
		JWKSet jwkSet = new JWKSet(rsaKey);
		return (jwkSelector, securityContext) -> jwkSelector.select(jwkSet);
	}
}
```

> The `authorization_code` grant requires the resource owner to be authenticated. Therefore, a user authentication mechanism **must** be configured in addition to the default OAuth2 security configuration.
>


`OpenID Connect 1.0` is disabled in the default configuration. The following example shows how to enable OpenID Connect 1.0 by initializing the `OidcConfigurer`:

```java
@Bean
public SecurityFilterChain authorizationServerSecurityFilterChain(HttpSecurity http) throws Exception {
	OAuth2AuthorizationServerConfiguration.applyDefaultSecurity(http);

	http.getConfigurer(OAuth2AuthorizationServerConfigurer.class)
		.oidc(Customizer.withDefaults());	// Initialize `OidcConfigurer`

	return http.build();
}
```

In addition to the default protocol endpoints, the OAuth2 authorization server `SecurityFilterChain` `@Bean` is configured with the following OpenID Connect 1.0 protocol endpoints:

- [OpenID Connect 1.0 Provider Configuration endpoint](https://docs.spring.io/spring-authorization-server/docs/current/reference/html/protocol-endpoints.html#oidc-provider-configuration-endpoint)

- [OpenID Connect 1.0 UserInfo endpoint](https://docs.spring.io/spring-authorization-server/docs/current/reference/html/protocol-endpoints.html#oidc-user-info-endpoint)

The following example shows how to register a `JwtDecoder` `@Bean`:

```java
@Bean
public JwtDecoder jwtDecoder(JWKSource<SecurityContext> jwkSource) {
	return OAuth2AuthorizationServerConfiguration.jwtDecoder(jwkSource);
}
```

The main intent of `OAuth2AuthorizationServerConfiguration` is to provide a convenient method to apply the minimal default configuration for an OAuth2 authorization server. However, in most cases, customizing the configuration will be required.

- intent n.目的，意图；故意

# Customizing the configuration

`OAuth2AuthorizationServerConfigurer` provides the ability to fully customize the security configuration for an OAuth2 authorization server.

It lets you specify the core components to use - for example, `RegisteredClientRepository`, `OAuth2AuthorizationService`, `OAuth2TokenGenerator`, and others.
 
Furthermore, it lets you customize the request processing logic for the protocol endpoints – for example, `authorization endpoint`, `token endpoint`, `token introspection endpoint`, and others.

- furthermore adv. 此外，而且
- introspection n.内省；反省

`OAuth2AuthorizationServerConfigurer` provides the following configuration options:

```java
@Bean
public SecurityFilterChain authorizationServerSecurityFilterChain(HttpSecurity http) throws Exception {
	OAuth2AuthorizationServerConfigurer authorizationServerConfigurer =
		new OAuth2AuthorizationServerConfigurer();
	http.apply(authorizationServerConfigurer);

	authorizationServerConfigurer
		.registeredClientRepository(registeredClientRepository) (1)
		.authorizationService(authorizationService) (2)
		.authorizationConsentService(authorizationConsentService)   (3)
		.authorizationServerSettings(authorizationServerSettings) (4)
		.tokenGenerator(tokenGenerator) (5)
		.clientAuthentication(clientAuthentication -> { })  (6)
		.authorizationEndpoint(authorizationEndpoint -> { })    (7)
		.tokenEndpoint(tokenEndpoint -> { })    (8)
		.tokenIntrospectionEndpoint(tokenIntrospectionEndpoint -> { })  (9)
		.tokenRevocationEndpoint(tokenRevocationEndpoint -> { })    (10)
		.authorizationServerMetadataEndpoint(authorizationServerMetadataEndpoint -> { })    (11)
		.oidc(oidc -> oidc
			.providerConfigurationEndpoint(providerConfigurationEndpoint -> { })    (12)
			.userInfoEndpoint(userInfoEndpoint -> { })  (13)
			.clientRegistrationEndpoint(clientRegistrationEndpoint -> { })  (14)
		);

	return http.build();
}
```
1. authenticationConverter(): Adds an AuthenticationConverter (pre-processor) used when attempting to extract client credentials from HttpServletRequest to an instance of OAuth2ClientAuthenticationToken.


2. authenticationConverters(): Sets the Consumer providing access to the List of default and (optionally) added AuthenticationConverter's allowing the ability to add, remove, or customize a specific AuthenticationConverter.

3. authenticationProvider(): Adds an AuthenticationProvider (main processor) used for authenticating the OAuth2ClientAuthenticationToken.

4. authenticationProviders(): Sets the Consumer providing access to the List of default and (optionally) added AuthenticationProvider's allowing the ability to add, remove, or customize a specific AuthenticationProvider.

5. authenticationSuccessHandler(): The AuthenticationSuccessHandler (post-processor) used for handling a successful client authentication and associating the OAuth2ClientAuthenticationToken to the SecurityContext.

6. errorResponseHandler(): The AuthenticationFailureHandler (post-processor) used for handling a failed client authentication and returning the OAuth2Error response.
