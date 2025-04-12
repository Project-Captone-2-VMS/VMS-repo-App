//setup environment Production
class AppConstants {
  String get baseUrl => 'http://10.0.2.2:8080/api';
}

//setup environment Staging 
class StagingAppConstants extends AppConstants {}

//set up environment Development
class DevelopmentAppConstants extends StagingAppConstants {}
