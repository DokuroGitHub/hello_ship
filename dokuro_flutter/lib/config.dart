// ignore_for_file: constant_identifier_names, non_constant_identifier_names, file_names

const serverDomain = 'dokuro20220606.herokuapp.com';
const portHttp = '80';
const portHttps = '443';

/// Auth0 Variables
class Auth0Config {
  /// 'dev-4q6howh8.us.auth0.com'
  static const AUTH0_DOMAIN = 'dev-4q6howh8.us.auth0.com';

  /// 'FQ3CjvkHBdpN5aexowvA8AvBqrX0cai0'
  static const AUTH0_NATIVE_CLIENT_ID = 'FQ3CjvkHBdpN5aexowvA8AvBqrX0cai0';

  /// 'com.auth0.flutterdemo://login-callback'
  static const AUTH0_REDIRECT_URI = 'com.dokuro.dokuroflutter://login-callback';

  /// 'https://dev-4q6howh8.us.auth0.com';
  static const AUTH0_ISSUER = 'https://$AUTH0_DOMAIN';

  /// 'https://dev-4q6howh8.us.auth0.com/userinfo'
  static const AUTH0_USER_INFO = 'https://$AUTH0_DOMAIN/userinfo';

  /// 'https://dev-4q6howh8.us.auth0.com/userinfo'
  static Uri get AUTH0_USER_INFO_URI =>
      Uri(scheme: 'https', host: AUTH0_DOMAIN, path: 'userinfo');

  /// 'https://dev-4q6howh8.us.auth0.com/api/v2/'
  static const AUTH0_AUDIENCE = 'https://$AUTH0_DOMAIN/api/v2/';
}

class HerokuConfig {
  /// 'dokuro20220606.herokuapp.com';
  static const SERVER_DOMAIN = 'dokuro20220606.herokuapp.com';

  /// 80;
  static const PORT_HTTP = 80;

  /// 443;
  static const PORT_HTTPS = 443;

  /// https://dokuro20220606.herokuapp.com/auth/login_with_email_password_auth0
  static Uri get LOGIN_WITH_EMAIL_PASSWORD_AUTH0_URI => Uri(
      scheme: 'https',
      host: SERVER_DOMAIN,
      port: PORT_HTTPS,
      path: 'auth/login_with_email_password_auth0');
}

class LocalServerConfig {
  /// '192.168.2.10';
  static const SERVER_DOMAIN = '192.168.2.10';

  /// 5000;
  static const PORT_HTTP = 5000;

  /// http://192.168.2.10:5000/auth/login_with_email_password_auth0
  static Uri get LOGIN_WITH_EMAIL_PASSWORD_AUTH0_URI => Uri(
      scheme: 'http',
      host: SERVER_DOMAIN,
      port: PORT_HTTP,
      path: 'auth/login_with_email_password_auth0');
}
