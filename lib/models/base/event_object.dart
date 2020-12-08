import 'package:vsongbook/utils/constants.dart';

class EventObject {
  int id;
  Object object;

  EventObject(
      {this.id: EventConstants.noInternetConnection, this.object: null});
}
