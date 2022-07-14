import 'package:dokuro_flutter/constants/ui.dart';
import 'package:dokuro_flutter/services/theme/theme_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dokuro_flutter/controllers/welcome_controller.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('WelcomeScreen');
    final welcomeController = Get.find<WelcomeController>();

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            ConstrainedBox(
              constraints:
                  BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
              child: Image.asset('assets/images/welcome_image.png'),
            ),
            const SizedBox(height: 30),
            Text(
              "Welcome to our \n AloShip app",
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headline5
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              "Freedom book an shipper of your \n requirements.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context)
                    .textTheme
                    .bodyText1
                    ?.color
                    ?.withOpacity(0.64),
              ),
            ),
            const SizedBox(height: 5),
            // switch theme
            IconButton(
              icon: const Icon(Icons.lightbulb),
              color: Theme.of(context).appBarTheme.titleTextStyle?.color,
              onPressed: themeService.switchTheme,
            ),
            const SizedBox(height: 5),
            FittedBox(
              child: TextButton(
                  onPressed: () => welcomeController.onGetStarted(),
                  child: Row(
                    children: [
                      Text(
                        "Skip",
                        style: Theme.of(context).textTheme.bodyText1?.copyWith(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  ?.color
                                  ?.withOpacity(0.8),
                            ),
                      ),
                      const SizedBox(width: kDefaultPadding / 4),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Theme.of(context)
                            .textTheme
                            .bodyText1
                            ?.color
                            ?.withOpacity(0.8),
                      )
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }
}
