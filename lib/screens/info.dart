import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:valid_sudoku/widgets/menu_button.dart';

class Info extends StatelessWidget {
  final bool isTipsOn;

  const Info({
    super.key,
    required this.isTipsOn
  });

  _launchWebsite(final String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      try {
        await launchUrl(uri);
      } on PlatformException {
        throw ArgumentError('Can\'t open website link: $url');
      }
    } else {
      throw ArgumentError('Can\'t open website link: $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
        appBar: AppBar(
            title: Text(
                'INFO',
                style: theme.textTheme.bodyLarge
            ),
            centerTitle: true,
            elevation: 0,
            backgroundColor: theme.canvasColor,
            automaticallyImplyLeading: false
        ),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MenuButton(
                    text: 'Rules',
                    color: MaterialStateProperty.all(Colors.blueAccent),
                    onPressed: () async {
                      try {
                        await _launchWebsite('https://www.sudoku.name/rules/en');
                      } on ArgumentError catch (error) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Notification'),
                            content: Text(error.message!),
                            actions: [
                              TextButton(
                                child: const Text('Ok'),
                                onPressed: () => Navigator.pop(context)
                              )
                            ]
                          )
                        );
                      }
                    }
                  ),
                  const SizedBox(height: 10),
                  MenuButton(
                    text: 'Author',
                    color: MaterialStateProperty.all(Colors.purpleAccent),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Author'),
                          content: const Text(
                            'Levon Khorasandzhian\n'
                            '\n'
                            'Github: lkhorasandzhian\n'
                            'Discord: Levon#4659',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black
                            ),
                          ),
                          actions: [
                            TextButton(
                              child: const Text('Ok'),
                              onPressed: () => Navigator.pop(context),
                            )
                          ]
                        )
                      );
                    }
                  ),
                  const SizedBox(height: 10),
                  MenuButton(
                      text: 'Back',
                      color: MaterialStateProperty.all(Colors.yellow),
                      onPressed: () => Navigator.pop(context)
                  )
                ]
            )
        )
    );
  }
}
