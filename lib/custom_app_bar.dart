import 'package:flutter/material.dart';
import 'actual_settings_screen.dart';
import 'background_sounds/sound_settings.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showSettingsButton;
  final bool showSoundSettingsButton;

  CustomAppBar({
    super.key,
    required this.title,
    this.showSettingsButton = true,
    this.showSoundSettingsButton = true,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> actions = [];

    if (showSoundSettingsButton) {
      actions.add(
        IconButton(
          icon: Icon(Icons.music_note, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SoundSelectionScreen(),
              ),
            );
          },
        ),
      );
    }

    if (showSettingsButton) {
      actions.add(
        IconButton(
          icon: Icon(Icons.settings, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ActualSettingsScreen(),
              ),
            );
          },
        ),
      );
    }

    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
