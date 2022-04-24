import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/email_password_sign_in_strings.dart';
import '../../controllers/log_in/email_password_sign_in_controller.dart';

class EmailPasswordSignInScreen extends StatelessWidget {
  const EmailPasswordSignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('EmailPasswordSignInScreen');
    final emailPasswordSignInController =
        Get.put(EmailPasswordSignInController());

    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(emailPasswordSignInController.title),
        leading: BackButton(
          color: Theme.of(context).appBarTheme.titleTextStyle?.color,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: LayoutBuilder(builder: (context, constraints) {
            return Container(
              width: min(constraints.maxWidth, 600),
              padding: const EdgeInsets.all(16.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Obx(() =>
                      _buildContent(emailPasswordSignInController, context)),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildEmailField(
      EmailPasswordSignInController emailPasswordSignInController) {
    return TextFormField(
      key: const Key('email'),
      controller: emailPasswordSignInController.emailController,
      decoration: InputDecoration(
        labelText: EmailPasswordSignInStrings.emailLabel,
        hintText: EmailPasswordSignInStrings.emailHint,
        errorText: emailPasswordSignInController.emailErrorText,
        enabled: !emailPasswordSignInController.isLoading.value,
      ),
      autocorrect: false,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.emailAddress,
      keyboardAppearance: Brightness.light,
      onEditingComplete: emailPasswordSignInController.emailEditingComplete,
      inputFormatters: [
        emailPasswordSignInController.emailInputFormatter,
      ],
    );
  }

  Widget _buildPasswordField(
      EmailPasswordSignInController emailPasswordSignInController,
      BuildContext context) {
    return TextFormField(
      key: const Key('password'),
      controller: emailPasswordSignInController.passwordController,
      decoration: InputDecoration(
        labelText: emailPasswordSignInController.passwordLabelText,
        errorText: emailPasswordSignInController.passwordErrorText,
        enabled: !emailPasswordSignInController.isLoading.value,
      ),
      obscureText: true,
      autocorrect: false,
      textInputAction: TextInputAction.done,
      keyboardAppearance: Brightness.light,
      onEditingComplete: () =>
          emailPasswordSignInController.passwordEditingComplete(context),
    );
  }

  Widget _buildContent(
      EmailPasswordSignInController emailPasswordSignInController,
      BuildContext context) {
    return FocusScope(
      node: emailPasswordSignInController.node,
      child: Form(
        onChanged: () => emailPasswordSignInController.updateWith(
            email: emailPasswordSignInController.emailController.text,
            password: emailPasswordSignInController.passwordController.text),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(height: 8.0),
            _buildEmailField(emailPasswordSignInController),
            if (emailPasswordSignInController.formType.value !=
                EmailPasswordSignInFormType.forgotPassword) ...<Widget>[
              const SizedBox(height: 8.0),
              _buildPasswordField(emailPasswordSignInController, context),
            ],
            const SizedBox(height: 8.0),
            ElevatedButton(
                onPressed: emailPasswordSignInController.isLoading.value
                    ? null
                    : () => emailPasswordSignInController.submit(),
                child: Text(emailPasswordSignInController.primaryButtonText)),
            const SizedBox(height: 8.0),
            ElevatedButton(
              key: const Key('secondary-button'),
              child: Text(emailPasswordSignInController.secondaryButtonText),
              onPressed: emailPasswordSignInController.isLoading.value
                  ? null
                  : () => emailPasswordSignInController.updateFormTypeClear(
                      emailPasswordSignInController.secondaryActionFormType),
            ),
            const SizedBox(height: 8.0),
            if (emailPasswordSignInController.formType.value ==
                EmailPasswordSignInFormType.signIn)
              ElevatedButton(
                key: const Key('tertiary-button'),
                child: const Text(
                    EmailPasswordSignInStrings.forgotPasswordQuestion),
                onPressed: emailPasswordSignInController.isLoading.value
                    ? null
                    : () => emailPasswordSignInController.updateFormTypeClear(
                        EmailPasswordSignInFormType.forgotPassword),
              ),
          ],
        ),
      ),
    );
  }
}
