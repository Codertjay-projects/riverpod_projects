import 'package:codertjay_gram/views/constants/strings.dart';
import 'package:codertjay_gram/views/components/rich_text/base_text.dart';
import 'package:codertjay_gram/views/components/rich_text/rich_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginViewSignup extends StatelessWidget {
  const LoginViewSignup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichTextWidget(
      styleForAll: Theme.of(context).textTheme.subtitle1?.copyWith(height: 1.5),
      texts: [
        BaseText.plain(
          text: Strings.dontHaveAnAccount,
        ),
        BaseText.plain(
          text: Strings.signUpOn,
        ),
        BaseText.link(
            text: Strings.facebook,
            onTapped: () {
              launchUrl(
                Uri.parse(
                  Strings.facebookSignupUrl,
                ),
              );
            }),
        BaseText.plain(
          text: Strings.orCreateAnAccountOn,
        ),
        BaseText.link(
            text: Strings.google,
            onTapped: () {
              launchUrl(
                Uri.parse(
                  Strings.googleSignupUrl,
                ),
              );
            }),
      ],
    );
  }
}
