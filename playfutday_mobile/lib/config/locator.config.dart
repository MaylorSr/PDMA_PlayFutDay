// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:playfutday_flutter/repositories/authentication_repository.dart'
    as _i4;
import 'package:playfutday_flutter/repositories/user_repository.dart' as _i5;
import 'package:playfutday_flutter/rest/rest_client.dart' as _i3;
import 'package:playfutday_flutter/services/authentication_service.dart' as _i6;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:playfutday_flutter/services/user_service/user_service.dart' as _i7;
import '../repositories/post_repository/post_repository.dart' as _i5;
import 'package:playfutday_flutter/services/post_service/post_service.dart'
    as _i7;



/// ignore_for_file: unnecessary_lambdas
/// ignore_for_file: lines_longer_than_80_chars
extension GetItInjectableX on _i1.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.singleton<_i3.RestAuthenticatedClient>(_i3.RestAuthenticatedClient());
    gh.singleton<_i3.RestClient>(_i3.RestClient());
    gh.singleton<_i4.AuthenticationRepository>(_i4.AuthenticationRepository());
    gh.singleton<_i5.PostRepository>(_i5.PostRepository());
    gh.singleton<_i5.UserRepository>(_i5.UserRepository());
    gh.singleton<_i6.JwtAuthenticationService>(_i6.JwtAuthenticationService());
    gh.singleton<_i7.PostService>(_i7.PostService());
    gh.singleton<_i7.UserService>(_i7.UserService());
    

    return this;
  }
}
