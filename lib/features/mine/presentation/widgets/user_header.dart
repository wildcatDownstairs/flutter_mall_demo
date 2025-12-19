import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:io';
import '../../bloc/mine_bloc.dart';

class UserHeader extends StatelessWidget {
  const UserHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MineBloc, MineState>(
      builder: (context, state) {
        final user = state.user;
        if (user == null) {
          return const SliverToBoxAdapter(child: SizedBox.shrink());
        }

        return SliverAppBar(
          expandedHeight: 320.0,
          pinned: true,
          stretch: true,
          backgroundColor: const Color(0xFF0B0B10),
          elevation: 0,
          title: Text(
            '@${user.username}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('演示：二维码')),
                );
              },
              icon: const Icon(Icons.qr_code_rounded, color: Colors.white),
              tooltip: '二维码',
            ),
            IconButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('演示：菜单')),
                );
              },
              icon: const Icon(Icons.menu_rounded, color: Colors.white),
              tooltip: '菜单',
            ),
            const SizedBox(width: 6),
          ],
          flexibleSpace: FlexibleSpaceBar(
            stretchModes: const [StretchMode.zoomBackground],
            background: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF0B0B10),
                        Color(0xFF11111B),
                        Color(0xFF0B0B10),
                      ],
                      stops: [0.0, 0.55, 1.0],
                    ),
                  ),
                ),
                Positioned(
                  top: -70,
                  right: -70,
                  child: Container(
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF25F4EE).withOpacity(0.18),
                          const Color(0xFFFE2C55).withOpacity(0.18),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -80,
                  left: -80,
                  child: Container(
                    width: 240,
                    height: 240,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFFFE2C55).withOpacity(0.14),
                          const Color(0xFF25F4EE).withOpacity(0.14),
                        ],
                      ),
                    ),
                  ),
                ),
                SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 72, 16, 12),
                    child: Column(
                      children: [
                        _buildAvatar(context, user.avatarUrl),
                        const SizedBox(height: 12),
                        Text(
                          user.username,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'ID: ${user.id} · ${user.memberLevel}',
                          style: const TextStyle(
                            color: Colors.white60,
                            fontSize: 12,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.06),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(color: Colors.white10),
                          ),
                          child: Text(
                            '「${user.points}」积分 · 点击头像可更换',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              height: 1.1,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAvatar(BuildContext context, String? url) {
    final imageProvider = _resolveAvatarImageProvider(url);
    return GestureDetector(
      onTap: () => _showImagePicker(context),
      child: Stack(
        children: [
          Container(
            width: 92,
            height: 92,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2.5),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: ClipOval(
              child: imageProvider == null
                  ? Container(
                      color: Colors.white.withOpacity(0.08),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.person,
                        size: 42,
                        color: Colors.white70,
                      ),
                    )
                  : Image(
                      image: imageProvider,
                      width: 92,
                      height: 92,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.white.withOpacity(0.08),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.person,
                            size: 42,
                            color: Colors.white70,
                          ),
                        );
                      },
                    ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFF25F4EE), Color(0xFFFE2C55)],
                ),
                border: Border.all(color: const Color(0xFF0B0B10), width: 2),
              ),
              child: const Icon(
                Icons.camera_alt,
                color: Colors.black,
                size: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  ImageProvider<Object>? _resolveAvatarImageProvider(String? urlOrPath) {
    if (urlOrPath == null || urlOrPath.isEmpty) return null;

    if (urlOrPath.startsWith('http://') || urlOrPath.startsWith('https://')) {
      return CachedNetworkImageProvider(urlOrPath);
    }

    String path = urlOrPath;
    if (urlOrPath.startsWith('file://')) {
      try {
        path = Uri.parse(urlOrPath).toFilePath();
      } catch (_) {
        path = urlOrPath.replaceFirst('file://', '');
      }
    }

    final file = File(path);
    if (!file.existsSync()) return null;
    return FileImage(file);
  }

  Future<void> _showImagePicker(BuildContext context) async {
    final picker = ImagePicker();
    final bloc = context.read<MineBloc>();
    
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('从相册选择'),
              onTap: () async {
                Navigator.pop(ctx);
                final picked = await picker.pickImage(source: ImageSource.gallery);
                if (picked != null) {
                  bloc.add(UpdateAvatar(picked.path));
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('拍照'),
              onTap: () async {
                Navigator.pop(ctx);
                final picked = await picker.pickImage(source: ImageSource.camera);
                if (picked != null) {
                  bloc.add(UpdateAvatar(picked.path));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
