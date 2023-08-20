import 'package:flutter/material.dart';
import 'package:my_tiny_map/db_model/memory_model.dart';
import 'package:my_tiny_map/db_repository/sql_memory_CRUD.dart';

class MemoryProvider extends ChangeNotifier {
  final SqlMemoryCRUD _sqlMemoryCRUD = SqlMemoryCRUD();

  List<MemoryModel> _memorys = [];

  List<MemoryModel> get memorys => _memorys;

  Future<int> addMemory(MemoryModel memoryModel) async {
    var newMemoryIdx = await _sqlMemoryCRUD.memoryModelInsert(memoryModel);
    memoryModel.idx = newMemoryIdx;
    _memorys.add(memoryModel);

    notifyListeners();
    return newMemoryIdx;
  }

  Future<void> updateMemory(MemoryModel memoryModel) async {
    await _sqlMemoryCRUD.memoryModelUpdate(memoryModel);
    _memorys[_memorys.indexWhere((element) => element.idx == memoryModel.idx)] =
        memoryModel;
    notifyListeners();
  }

  Future<void> deleteMemory(int idx) async {
    await _sqlMemoryCRUD.memoryModelDelete(idx);
    _memorys.removeWhere((element) => element.idx == idx);
    notifyListeners();
  }

  Future<void> fetchMemory() async {
    _memorys = await _sqlMemoryCRUD.fetchMemorys();
    notifyListeners();
  }

  MemoryModel searchMemory(int idx) {
    var memoryModel =
        _memorys[_memorys.indexWhere((element) => element.idx == idx)];
    return memoryModel;
  }
}
