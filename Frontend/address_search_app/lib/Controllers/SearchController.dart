import 'dart:async';
import 'package:address_search_app/Models/SearchModel.dart';
import 'package:address_search_app/Services/SearchService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Searchcontroller extends GetxController {
  final textController = TextEditingController();
  var searchText = "".obs;
  final Searchservice _service = Searchservice();

  var results = <Searchmodel>[].obs;
  var isLoading = false.obs;

  Timer? _debounce;

  void searchAddress(String query) {
    searchText.value = query;

    if (_debounce?.isActive ?? false) _debounce?.cancel();

    // Bật loading ngay khi nhập
    if (query.isNotEmpty) {
      isLoading.value = true;
    } else {
      results.clear();
      isLoading.value = false;
      return;
    }

    // Gọi API sau khi dừng gõ 1s
    _debounce = Timer(const Duration(seconds: 1), () async {
      try {
        final data = await _service.searchAddress(query);
        results.assignAll(data);
      } catch (e) {
        results.clear();
      } finally {
        isLoading.value = false; // Tắt loading khi xong
      }
    });
  }

  void clearSearch() {
    textController.clear();
    searchText.value = "";
    results.clear();
    isLoading.value = false; // tắt luôn loading khi clear
  }
}
