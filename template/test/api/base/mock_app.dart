import 'package:network/network.dart';
import 'package:flutter_template/interactor/user/user_interactor.dart';
import 'package:flutter_template/interactor/user/repository/user_repository.dart';
import 'package:flutter_template/interactor/network/status_mapper.dart';
import 'package:flutter_template/interactor/network/header_builder.dart';
import 'package:flutter_template/interactor/token/token_storage.dart';
import 'package:flutter_template/util/sp_helper.dart';
import 'package:flutter_template/interactor/common/urls.dart';

/// Моковый компонент для тестирования сервисного слоя
class MockAppComponent {
    RxHttp http;

    UserInteractor userInteractor;
    AuthInfoStorage authStorage;
    PreferencesHelper preferencesHelper;

    MockAppComponent() {

        authStorage = AuthInfoStorage(preferencesHelper);
        preferencesHelper = PreferencesHelper();

        http = _initHttp(authStorage);

        userInteractor = UserInteractor(
            UserRepository(http),
        );
    }

    RxHttp _initHttp(AuthInfoStorage authStorage) {
        var dioHttp = DioHttp(
            config: HttpConfig(
                TEST_URL,
                Duration(seconds: 30),
            ),
            errorMapper: DefaultStatusMapper(),
            headersBuilder: DefaultHeaderBuilder(authStorage),
        );
        return RxHttpDelegate(dioHttp);
    }
}