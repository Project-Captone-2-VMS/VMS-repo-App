//setup environment Production
class AppConstants {
  String get baseUrl => 'http://192.168.102.220:8080/api';
}

//setup environment Staging
class StagingAppConstants extends AppConstants {}

//set up environment Development
class DevelopmentAppConstants extends StagingAppConstants {}
