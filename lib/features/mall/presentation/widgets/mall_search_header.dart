import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

class MallSearchHeader extends HookWidget {
  const MallSearchHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final searchController = useTextEditingController(text: '民宿');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: Colors.white,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 20, color: Colors.black),
            onPressed: () => context.pop(),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        hintText: '搜索',
                        hintStyle: TextStyle(color: Color(0xFF999999), fontSize: 14),
                      ),
                      style: const TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      searchController.clear();
                    },
                    child: const Icon(Icons.cancel, size: 16, color: Color(0xFFCCCCCC)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () {
              // Handle search
            },
            child: const Text(
              '搜索',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
