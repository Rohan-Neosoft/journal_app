import 'package:journal_app_using_bloc/Home/ui/sql_helper.dart';

class Util {
  Future<List<Map<String, dynamic>>> getItems() async {
    return SqlHelper.getItems();
  }

  Future<void> addItem(String title, String? description) async {
    await SqlHelper.createItem(title, description);
  }

  Future<List<Map<String, dynamic>>> getItemsById(int i) async {
    return SqlHelper.getItemById(i);
  }

  Future<List<Map<String, dynamic>>> getItemByisFav() async {
    return SqlHelper.getItemByisFav();
  }

  Future<void> updateItem(
      int id, String title, String? description, int? isFav) async {
    await SqlHelper.updateItem(id, title, description, isFav);
  }

  Future<void> deleteItem(int id) async {
    await SqlHelper.deleteItem(id);
  }
}
