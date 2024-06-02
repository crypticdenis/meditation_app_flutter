import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/gong_provider.dart';
import '../providers/theme_provider.dart';
import 'package:meditation_app_flutter/common_definitions.dart';
import '../Profile/sign_in.dart';

class GongSelectionScreen extends StatelessWidget {
  const GongSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    Future<bool> _onWillPop(BuildContext context) async {
      final gongProvider = Provider.of<GongProvider>(context, listen: false);

      if (gongProvider.isRestrictedGongPlayed &&
          !gongProvider.isAuthenticated)  {
        final result = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Sign In Required'),
            content: Text('Sign in now to unlock this gong.'),
            actions: [
              TextButton(
                onPressed: () {
                  gongProvider.toggleGongEnabled();
                  Navigator.of(context).pop(true);
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => SignInScreen(
                      onLoginSuccess: () {
                        final gongProvider =
                            Provider.of<GongProvider>(context, listen: false);
                        if (!gongProvider.gongEnabled) {
                          gongProvider.toggleGongEnabled();
                        }
                        Navigator.of(context).pop();
                      },
                    ),
                  );
                },
                child: Text('Sign In'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('Cancel'),
              ),
            ],
          ),
        );
        return result ?? false;
      } else {
        Navigator.of(context).pop();
        return true;
      }
    }

    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        extendBodyBehindAppBar: false,
        body: Container(
          decoration: BoxDecoration(
            gradient: themeProvider.currentGradient,
          ),
          child: Column(
            children: [
              const SizedBox(height: 50),
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => _onWillPop(context),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    buildSectionHeader('Gongs'),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Consumer<GongProvider>(
                        builder: (context, gongProvider, child) {
                          return Switch(
                            value: gongProvider.gongEnabled,
                            onChanged: (bool value) {
                              gongProvider.toggleGongEnabled();
                            },
                            activeColor: Colors.white,
                            inactiveThumbColor: Colors.red,
                            inactiveTrackColor: Colors.grey,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: Container(
                    child: GridView.builder(
                        padding: const EdgeInsets.all(10.0),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                        ),
                        itemCount:
                            Provider.of<GongProvider>(context).gongData.length,
                        itemBuilder: (context, index) {
                          final gongProvider =
                              Provider.of<GongProvider>(context);
                          final gong = gongProvider.gongData[index];
                          final gongName = gong['name'];
                          final isSelected =
                              index == gongProvider.currentGongIndex;
                          final imageUrl = gongProvider.imageUrls[index];
                          print("Gong Image URL: $imageUrl");
                          final isRestricted = gong['restricted'];
                          final isAuthenticated = gongProvider.isAuthenticated;

                          return GestureDetector(
                            onTap: () => gongProvider.setGong(index),
                            child: Opacity(
                              opacity: isSelected ? 1.0 : 0.5,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                  image: DecorationImage(
                                    image: NetworkImage(imageUrl),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    Positioned.fill(
                                      child: ShaderMask(
                                        shaderCallback: (rect) {
                                          return LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Colors.transparent,
                                              Colors.black,
                                            ],
                                            stops: [0.5, 1],
                                          ).createShader(rect);
                                        },
                                        blendMode: BlendMode.darken,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            image: DecorationImage(
                                              image: NetworkImage(imageUrl),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        child: Text(
                                          gongName,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    if (isRestricted && !isAuthenticated)
                                      Align(
                                        alignment: Alignment.center,
                                        child: Icon(
                                          Icons.lock,
                                          color: Colors.white,
                                          size: 48,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
