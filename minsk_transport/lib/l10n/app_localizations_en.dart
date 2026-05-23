// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Minsk Transport';

  @override
  String get routes => 'Routes';

  @override
  String get favorites => 'Favorites';

  @override
  String get history => 'History';

  @override
  String get settings => 'Settings';

  @override
  String get all => 'All';

  @override
  String get bus => 'Bus';

  @override
  String get trolleybus => 'Trolleybus';

  @override
  String get tram => 'Tram';

  @override
  String get noData => 'No data';

  @override
  String get clearHistory => 'Clear history';

  @override
  String get language => 'Language';

  @override
  String get theme => 'Theme';

  @override
  String get version => 'Version';

  @override
  String get platform => 'Platform';

  @override
  String get stops => 'Stops';

  @override
  String get type => 'Type';

  @override
  String get routeDetails => 'Route details';

  @override
  String get liveVehicle => 'Live vehicle';

  @override
  String get noLiveVehicle => 'No active vehicle';

  @override
  String get loginTitle => 'Sign in';

  @override
  String get login => 'Login';

  @override
  String get logout => 'Logout';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get loading => 'Loading...';

  @override
  String get requiredField => 'Required field';

  @override
  String get invalidEmail => 'Invalid email';

  @override
  String get shortPassword => 'Password is too short';

  @override
  String get invalidCredentials => 'Invalid credentials';

  @override
  String get loggedInAs => 'Logged in as';

  @override
  String get systemTheme => 'System';

  @override
  String get lightTheme => 'Light';

  @override
  String get darkTheme => 'Dark';

  @override
  String travelTime(int minutes) {
    return '$minutes min';
  }

  @override
  String routeNumber(String number) {
    return 'Route $number';
  }
}
