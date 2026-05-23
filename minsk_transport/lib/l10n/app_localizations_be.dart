// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Belarusian (`be`).
class AppLocalizationsBe extends AppLocalizations {
  AppLocalizationsBe([String locale = 'be']) : super(locale);

  @override
  String get appTitle => 'Транспарт Мінска';

  @override
  String get routes => 'Маршруты';

  @override
  String get favorites => 'Абранае';

  @override
  String get history => 'Гісторыя';

  @override
  String get settings => 'Налады';

  @override
  String get all => 'Усе';

  @override
  String get bus => 'Аўтобус';

  @override
  String get trolleybus => 'Тралейбус';

  @override
  String get tram => 'Трамвай';

  @override
  String get noData => 'Няма дадзеных';

  @override
  String get clearHistory => 'Ачысціць гісторыю';

  @override
  String get language => 'Мова';

  @override
  String get theme => 'Тэма';

  @override
  String get version => 'Версія';

  @override
  String get platform => 'Платформа';

  @override
  String get stops => 'Прыпынкі';

  @override
  String get type => 'Тып';

  @override
  String get routeDetails => 'Дэталі маршруту';

  @override
  String get liveVehicle => 'Транспарт анлайн';

  @override
  String get noLiveVehicle => 'Няма актыўнага транспарту';

  @override
  String get loginTitle => 'Уваход у праграму';

  @override
  String get login => 'Увайсці';

  @override
  String get logout => 'Выйсці';

  @override
  String get email => 'Email';

  @override
  String get password => 'Пароль';

  @override
  String get loading => 'Загрузка...';

  @override
  String get requiredField => 'Абавязковае поле';

  @override
  String get invalidEmail => 'Некарэктны email';

  @override
  String get shortPassword => 'Пароль занадта кароткі';

  @override
  String get invalidCredentials => 'Няправільныя дадзеныя для ўваходу';

  @override
  String get loggedInAs => 'Уваход выкананы як';

  @override
  String get systemTheme => 'Сістэмная';

  @override
  String get lightTheme => 'Светлая';

  @override
  String get darkTheme => 'Цёмная';

  @override
  String travelTime(int minutes) {
    return '$minutes мін';
  }

  @override
  String routeNumber(String number) {
    return 'Маршрут $number';
  }
}
