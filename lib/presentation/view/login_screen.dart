import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:task_manager_app/core/constants/app_strings.dart';
import 'package:task_manager_app/core/extensions/text_styles.dart';
import 'package:task_manager_app/presentation/widgets/text_form_fields.dart';

import '../../app/routes/routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/show_snack_bar.dart';
import '../manager/auth/auth_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isSecure = false;
  double initialChildSize = 0.60;
  late TextEditingController usernameController;
  late TextEditingController passwordController;
  final GlobalKey<FormState> formKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    usernameController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          state.maybeWhen(
              orElse: () {},
              success: () => context.goNamed(Routes.homeScreen),
              failure: (message) => ShowSnackbar.showCheckTopSnackBar(
                    context,
                    text: message,
                    type: SnackBarType.error,
                  ));
        },
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppStrings.login,
                    style: context.titleLarge
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: MediaQuery.sizeOf(context).height * 0.07),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          AppStrings.username,
                          style: context.titleMedium,
                        ),
                      ),
                      TextFormFieldCustom(
                        hintText: AppStrings.username,
                        controller: usernameController,
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.sizeOf(context).height * 0.01),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          AppStrings.password,
                          style: context.titleMedium,
                        ),
                      ),
                      TextFormFieldPassword(
                        controller: passwordController,
                        validator: (v) {
                          if (v!.isEmpty) {
                            return AppStrings.enterPassword;
                          }
                          return null;
                        },
                      )
                    ],
                  ),
                  SizedBox(height: MediaQuery.sizeOf(context).height * 0.1),
                  BlocConsumer<AuthBloc, AuthState>(
                    listener: (context, state) {
                      state.maybeMap(
                        success: (model) async {
                          context.goNamed(Routes.homeScreen);
                          ShowSnackbar.showCheckTopSnackBar(
                            context,
                            text: AppStrings.welcomeBack,
                            type: SnackBarType.success,
                          );
                        },
                        failure: (v) async {
                          ShowSnackbar.showCheckTopSnackBar(
                            context,
                            text: v.message,
                            type: SnackBarType.error,
                          );
                        },
                        orElse: () {},
                      );
                    },
                    builder: (context, state) {
                      return ElevatedButton(
                          onPressed: _onPressedMethod,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.lightGreen,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            fixedSize: Size(
                              MediaQuery.sizeOf(context).width * 0.9,
                              MediaQuery.sizeOf(context).height * 0.08,
                            ),
                          ),
                          child: state.maybeWhen(
                            orElse: () {
                              return Text(
                                AppStrings.login,
                                style: context.titleMedium
                                    .copyWith(color: AppColors.white),
                              );
                            },
                            loading: () {
                              return const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: AppColors.white,
                                  strokeWidth: 3,
                                ),
                              );
                            },
                          ));
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onPressedMethod() {
    if (formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            AuthEvent.login(
              username: usernameController.text,
              password: passwordController.text,
            ),
          );
    }
  }
}
