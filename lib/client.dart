import 'package:appwrite/appwrite.dart';

class MyClient {
  Client client = Client();
  get myCleint {
    return client
        .setEndpoint('https://cloud.appwrite.io/v1')
        .setProject('63e501600fd3f4f97f20')
        .setSelfSigned(status: true);
  }
}
