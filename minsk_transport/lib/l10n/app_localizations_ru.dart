// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Транспорт Минска';

  @override
  String get routes => 'Маршруты';

  @override
  String get favorites => 'Избранное';

  @override
  String get history => 'История';

  @override
  String get settings => 'Настройки';

  @override
  String get all => 'Все';

  @override
  String get bus => 'Автобус';

  @override
  String get trolleybus => 'Троллейбус';

  @override
  String get tram => 'Трамвай';

  @override
  String get noData => 'Нет данных';

  @override
  String get clearHistory => 'Очистить историю';

  @override
  String get language => 'Язык';

  @override
  String get theme => 'Тема';

  @override
  String get version => 'Версия';

  @override
  String get platform => 'Платформа';

  @override
  String get stops => 'Остановки';

  @override
  String get type => 'Тип';

  @override
  String get routeDetails => 'Детали маршрута';

  @override
  String get liveVehicle => 'Транспорт онлайн';

  @override
  String get noLiveVehicle => 'Нет активного транспорта';

  @override
  String get loginTitle => 'Вход в приложение';

  @override
  String get login => 'Войти';

  @override
  String get logout => 'Выйти';

  @override
  String get email => 'Email';

  @override
  String get password => 'Пароль';

  @override
  String get loading => 'Загрузка...';

  @override
  String get requiredField => 'Обязательное поле';

  @override
  String get invalidEmail => 'Некорректный email';

  @override
  String get shortPassword => 'Пароль слишком короткий';

  @override
  String get invalidCredentials => 'Неверные данные для входа';

  @override
  String get loggedInAs => 'Выполнен вход как';

  @override
  String get systemTheme => 'Системная';

  @override
  String get lightTheme => 'Светлая';

  @override
  String get darkTheme => 'Тёмная';

  @override
  String travelTime(int minutes) {
    return '$minutes мин';
  }

  @override
  String routeNumber(String number) {
    return 'Маршрут $number';
  }
}
