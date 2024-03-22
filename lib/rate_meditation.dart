import 'package:flutter/material.dart';
import 'providers/theme_provider.dart';
import 'package:provider/provider.dart';

class RateMeditationDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final gradient = themeProvider.currentGradient;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: ShaderMask(
        shaderCallback: (bounds) => gradient.createShader(
          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
        ),
        child: Text(
          'Rate Your Meditation',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white, // This color will be overwritten by the shader
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'How was your Experience today, Denis?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16, // Slightly larger text for readability
              ),
            ),
            SizedBox(height: 24), // More space for aesthetic reasons
            Wrap(
              alignment: WrapAlignment.spaceEvenly,
              // Even spacing for aesthetics
              children: List.generate(5, (index) {
                int i = index + 1;
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  // Spacing around each button
                  child: InkWell(
                    onTap: () {
                      print('Selected rating: $i');
                      Navigator.pop(
                          context, i); // Close dialog and pass selected rating
                    },
                    borderRadius: BorderRadius.circular(5),
                    // Match container border radius
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: gradient, // Apply the gradient here
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4, // Shadow for a 3D effect
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: SizedBox(
                        width: 48,
                        height: 48,
                        child: Center(
                          child: Text(
                            '$i',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
