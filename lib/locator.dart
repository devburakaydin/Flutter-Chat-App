import 'package:chat_app/repository/user_repository.dart';
import 'package:chat_app/services/firebase_auth_service.dart';
import 'package:chat_app/services/firestore_db_service.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => FirebaseAuthService());
  locator.registerLazySingleton(() => UserRepository());
  locator.registerLazySingleton(() => FirebaseDbService());
}
