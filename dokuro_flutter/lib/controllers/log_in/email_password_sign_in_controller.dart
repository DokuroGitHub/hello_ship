import 'dart:async';

import 'package:dokuro_flutter/constants/email_password_sign_in_strings.dart';
import 'package:dokuro_flutter/constants/string_validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:dokuro_flutter/services/auth_service.dart';

enum EmailPasswordSignInFormType { signIn, register, forgotPassword }

class EmailAndPasswordValidators {
  final TextInputFormatter emailInputFormatter =
      ValidatorInputFormatter(editingValidator: EmailEditingRegexValidator());
  final StringValidator emailSubmitValidator = EmailSubmitRegexValidator();
  final StringValidator passwordRegisterSubmitValidator =
      MinLengthStringValidator(8);
  final StringValidator passwordSignInSubmitValidator =
      NonEmptyStringValidator();
}

class EmailPasswordSignInController extends GetxController
    with EmailAndPasswordValidators {
  final authService = Get.find<AuthService>();
  late final FocusScopeNode node;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late RxBool isLoading;

  late RxString _email;
  late RxString _password;
  late Rx<EmailPasswordSignInFormType> formType;
  late RxBool _submitted;

  Future<bool> submit() async {
    try {
      updateWith(submitted: true);
      if (!canSubmit) {
        return false;
      }
      updateWith(isLoading: true);
      switch (formType.value) {
        case EmailPasswordSignInFormType.signIn:
          debugPrint('---------EmailPasswordSignInFormType.signIn------------');
          // dung email password lay token, tu token lay user
          var result = await authService.signInWithEmailPassword(
              _email.value, _password.value);
          debugPrint('submit, result: $result');
          if (result == null) {
            debugPrint('sign in failed');
            Get.showSnackbar(const GetSnackBar(
              title: 'Login failed',
              message: 'Can not connect to the server',
              duration: Duration(seconds: 2),
            ));
          } else {
            if (result['error'] != null) {
              debugPrint('result.error: ${result['error_description']}');
              Get.showSnackbar(GetSnackBar(
                title: 'Login failed',
                message: result['error_description'],
                duration: const Duration(seconds: 2),
              ));
            } else if (result['access_token'] != null) {
              Get.close(1);
              authService.accessToken.value = result['access_token'];
            } else {
              debugPrint('sign in failed');
            }
          }
          updateWith(isLoading: false);
          break;
        case EmailPasswordSignInFormType.register:
          //await AuthService().createUserWithEmailAndPassword(_email, _password);
          debugPrint(
              '---------EmailPasswordSignInFormType.register------------');
          //final result = await authService.signup(_email.value, _password.value);
          // show thong bao tao tai khoan thanh cong, quay lai dang nhap
          updateWith(isLoading: false);
          break;
        case EmailPasswordSignInFormType.forgotPassword:
          //await AuthService().sendPasswordResetEmail(_email);
          updateWith(isLoading: false);
          break;
      }
      return true;
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

  void updateEmail(String email) => updateWith(email: email);

  void updatePassword(String password) => updateWith(password: password);

  void updateFormType(EmailPasswordSignInFormType formType) {
    updateWith(
      email: '',
      password: '',
      formType: formType,
      isLoading: false,
      submitted: false,
    );
  }

  void updateWith({
    String? email,
    String? password,
    EmailPasswordSignInFormType? formType,
    bool? isLoading,
    bool? submitted,
  }) {
    _email.value = email ?? _email.value;
    _password.value = password ?? _password.value;
    this.formType.value = formType ?? this.formType.value;
    this.isLoading.value = isLoading ?? this.isLoading.value;
    _submitted.value = submitted ?? _submitted.value;
  }

  String get passwordLabelText {
    if (formType.value == EmailPasswordSignInFormType.register) {
      return EmailPasswordSignInStrings.password8CharactersLabel;
    }
    return EmailPasswordSignInStrings.passwordLabel;
  }

  // Getters
  String get primaryButtonText {
    return <EmailPasswordSignInFormType, String>{
          EmailPasswordSignInFormType.register:
              EmailPasswordSignInStrings.createAnAccount,
          EmailPasswordSignInFormType.signIn: EmailPasswordSignInStrings.signIn,
          EmailPasswordSignInFormType.forgotPassword:
              EmailPasswordSignInStrings.sendResetLink,
        }[formType.value] ??
        '';
  }

  String get secondaryButtonText {
    return <EmailPasswordSignInFormType, String>{
          EmailPasswordSignInFormType.register:
              EmailPasswordSignInStrings.haveAnAccount,
          EmailPasswordSignInFormType.signIn:
              EmailPasswordSignInStrings.needAnAccount,
          EmailPasswordSignInFormType.forgotPassword:
              EmailPasswordSignInStrings.backToSignIn,
        }[formType.value] ??
        '';
  }

  EmailPasswordSignInFormType get secondaryActionFormType {
    return <EmailPasswordSignInFormType, EmailPasswordSignInFormType>{
          EmailPasswordSignInFormType.register:
              EmailPasswordSignInFormType.signIn,
          EmailPasswordSignInFormType.signIn:
              EmailPasswordSignInFormType.register,
          EmailPasswordSignInFormType.forgotPassword:
              EmailPasswordSignInFormType.signIn,
        }[formType.value] ??
        EmailPasswordSignInFormType.signIn;
  }

  String get title {
    return <EmailPasswordSignInFormType, String>{
          EmailPasswordSignInFormType.register:
              EmailPasswordSignInStrings.register,
          EmailPasswordSignInFormType.signIn: EmailPasswordSignInStrings.signIn,
          EmailPasswordSignInFormType.forgotPassword:
              EmailPasswordSignInStrings.forgotPassword,
        }[formType.value] ??
        '';
  }

  String get errorAlertTitle {
    return <EmailPasswordSignInFormType, String>{
      EmailPasswordSignInFormType.register:
          EmailPasswordSignInStrings.registrationFailed,
      EmailPasswordSignInFormType.signIn:
          EmailPasswordSignInStrings.signInFailed,
      EmailPasswordSignInFormType.forgotPassword:
          EmailPasswordSignInStrings.passwordResetFailed,
    }[formType]!;
  }

  bool get canSubmitEmail {
    return emailSubmitValidator.isValid(_email.value);
  }

  bool get canSubmitPassword {
    if (formType.value == EmailPasswordSignInFormType.register) {
      return passwordRegisterSubmitValidator.isValid(_password.value);
    }
    return passwordSignInSubmitValidator.isValid(_password.value);
  }

  bool get canSubmit {
    final bool canSubmitFields =
        formType.value == EmailPasswordSignInFormType.forgotPassword
            ? canSubmitEmail
            : canSubmitEmail && canSubmitPassword;
    return canSubmitFields && !isLoading.value;
  }

  String? get emailErrorText {
    final bool showErrorText = _submitted.value && !canSubmitEmail;
    final String errorText = _email.isEmpty
        ? EmailPasswordSignInStrings.invalidEmailEmpty
        : EmailPasswordSignInStrings.invalidEmailErrorText;
    return showErrorText ? errorText : null;
  }

  String? get passwordErrorText {
    final bool showErrorText = _submitted.value && !canSubmitPassword;
    final String errorText = _password.value.isEmpty
        ? EmailPasswordSignInStrings.invalidPasswordEmpty
        : EmailPasswordSignInStrings.invalidPasswordTooShort;
    return showErrorText ? errorText : null;
  }

  void emailEditingComplete() {
    if (canSubmitEmail) {
      node.nextFocus();
    }
  }

  void passwordEditingComplete(BuildContext context) {
    if (!canSubmitEmail) {
      node.previousFocus();
      return;
    }
    submit();
  }

  void updateFormTypeClear(EmailPasswordSignInFormType formType) {
    updateFormType(formType);
    emailController.clear();
    passwordController.clear();
  }

  @override
  void onInit() {
    node = FocusScopeNode();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    _email = 'tamthoidetrong@gmail.com'.obs;
    _password = 'abc123??'.obs;
    emailController.text = _email.value;
    passwordController.text = _password.value;
    formType = EmailPasswordSignInFormType.signIn.obs;
    isLoading = false.obs;
    _submitted = false.obs;

    super.onInit();
  }

  @override
  void dispose() {
    node.dispose();
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }
}
