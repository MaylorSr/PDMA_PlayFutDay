import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:playfutday_flutter/config/locator.config.dart';

import '../services/localstorage_service.dart';

final getIt = GetIt.instance;

@InjectableInit()
void configureDependencies() => getIt.init();
void setupAsyncDependencies() {
  getIt.registerSingletonAsync<LocalStorageService>(
      () => LocalStorageService.getInstance());
}
