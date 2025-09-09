import 'package:address_search_app/Controllers/SearchController.dart';
import 'package:address_search_app/Models/SearchModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class Searchscreen extends StatelessWidget {
  final Searchcontroller controller = Get.put(Searchcontroller());

  Searchscreen({super.key});

  void _openGoogleMaps(Searchmodel place) async {
    final url = Uri.parse(
      "https://www.google.com/maps/dir/?api=1&destination=${place.lat},${place.lon}",
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(top: 55, left: 15, right: 15),
        child: Column(
          children: [
            // Ô tìm kiếm
            Obx(
              () => Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: TextField(
                  controller: controller.textController,
                  onChanged: (value) {
                    controller.searchText.value = value;
                    controller.searchAddress(value);
                  },
                  decoration: InputDecoration(
                    hintText: "Enter keyword",
                    hintStyle: const TextStyle(color: Colors.grey),
                    prefixIcon:
                        controller.isLoading.value
                            ? Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.black,
                                  ),
                                ),
                              ),
                            )
                            : const Icon(Icons.search, color: Colors.black),
                    suffixIcon:
                        controller.searchText.value.isNotEmpty
                            ? IconButton(
                              icon: const Icon(
                                Icons.clear,
                                color: Colors.black,
                              ),
                              onPressed: controller.clearSearch,
                            )
                            : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),

            // Danh sách kết quả
            Expanded(
              child: Obx(() {
                return ListView.builder(
                  itemCount: controller.results.length,
                  itemBuilder: (context, index) {
                    final place = controller.results[index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12.0,
                        horizontal: 8.0,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            color: Colors.black,
                            size: 25,
                          ),
                          const SizedBox(width: 8),

                          // Text địa điểm
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text:
                                        _highlightKeyword(
                                          place.displayName,
                                          controller.searchText.value,
                                        ).$1,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        _highlightKeyword(
                                          place.displayName,
                                          controller.searchText.value,
                                        ).$2,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(width: 8),

                          InkWell(
                            borderRadius: BorderRadius.circular(30),
                            onTap: () => _openGoogleMaps(place),
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: SvgPicture.asset(
                                "assets/icons/muiten.svg",
                                width: 25,
                                height: 25,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

// Hàm tiện ích để highlight
(String, String) _highlightKeyword(String text, String keyword) {
  if (keyword.isEmpty) return ("", text);
  final lowerText = text.toLowerCase();
  final lowerKey = keyword.toLowerCase();
  final index = lowerText.indexOf(lowerKey);

  if (index != -1) {
    final match = text.substring(index, index + keyword.length);
    final remaining = text.substring(index + keyword.length);
    return (match, remaining);
  }
  return ("", text);
}
