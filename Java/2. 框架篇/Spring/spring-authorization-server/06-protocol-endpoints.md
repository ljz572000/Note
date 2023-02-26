# Protocol Endpoints

`OAuth2AuthorizationEndpointConfigurer` provides the ability to customize the `OAuth2 Authorization endpoint`. It defines extension points that let you customize the pre-processing, main processing, and post-processing logic for `OAuth2 authorization requests`.

`OAuth2AuthorizationEndpointConfigurer` provides the following configuration options:

```java
@Bean
public SecurityFilterChain authorizationServerSecurityFilterChain(HttpSecurity http) throws Exception {
	OAuth2AuthorizationServerConfigurer authorizationServerConfigurer =
		new OAuth2AuthorizationServerConfigurer();
	http.apply(authorizationServerConfigurer);

	authorizationServerConfigurer
		.authorizationEndpoint(authorizationEndpoint ->
			authorizationEndpoint
				.authorizationRequestConverter(authorizationRequestConverter)   (1)
				.authorizationRequestConverters(authorizationRequestConvertersConsumer) (2)
				.authenticationProvider(authenticationProvider) (3)
				.authenticationProviders(authenticationProvidersConsumer)   (4)
				.authorizationResponseHandler(authorizationResponseHandler) (5)
				.errorResponseHandler(errorResponseHandler) (6)
				.consentPage("/oauth2/v1/authorize")    (7)
		);

	return http.build();
}


```

1. authorizationRequestConverter(): Adds an `AuthenticationConverter` (pre-processor) used when attempting to extract an `OAuth2 authorization request` (or consent) from `HttpServletRequest` to an instance of `OAuth2AuthorizationCodeRequestAuthenticationToken` or `OAuth2AuthorizationConsentAuthenticationToken`.
2. `authorizationRequestConverters()`: Sets the `Consumer` providing access to the `List` of default and (optionally) added `AuthenticationConverter`'s allowing the ability to add, remove, or customize a specific `AuthenticationConverter`.
3. `authenticationProvider()`: Adds an `AuthenticationProvider` (main processor) used for authenticating the `OAuth2AuthorizationCodeRequestAuthenticationToken` or `OAuth2AuthorizationConsentAuthenticationToken`.
4. `authenticationProviders()`: Sets the `Consumer` providing access to the `List` of default and (optionally) added `AuthenticationProvider`'s allowing the ability to add, remove, or customize a specific `AuthenticationProvider`.
5. `authorizationResponseHandler()`: The `AuthenticationSuccessHandler` (post-processor) used for handling an “authenticated” `OAuth2AuthorizationCodeRequestAuthenticationToken` and returning the OAuth2AuthorizationResponse.
6. `errorResponseHandler()`: The `AuthenticationFailureHandler` (post-processor) used for handling an `OAuth2AuthorizationCodeRequestAuthenticationException` and returning the OAuth2Error response.
7. `consentPage()`: The `URI` of the custom consent page to redirect resource owners to if consent is required during the authorization request flow.

# OAuth2 Authorization Endpoint

## Customizing Authorization Request Validation

# OAuth2 Token Endpoint

# OAuth2 Token Introspection Endpoint

# OAuth2 Token Revocation Endpoint

# OAuth2 Authorization Server Metadata Endpoint

# JWK Set Endpoint

# OpenID Connect 1.0 Provider Configuration Endpoint

# OpenID Connect 1.0 UserInfo Endpoint

# OpenID Connect 1.0 Client Registration Endpoint

