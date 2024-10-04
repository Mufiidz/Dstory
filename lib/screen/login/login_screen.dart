import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../../components/background/animated_background_widget.dart';
import '../../components/background/cubit/animated_background_cubit.dart';
import '../../components/export_components.dart';
import '../../di/injection.dart';
import '../../generated/locale_keys.g.dart';
import '../../model/user.dart';
import '../../utils/export_utils.dart';
import '../home/home_screen.dart';
import '../register/register_screen.dart';
import 'cubit/login_cubit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends LifecycleEventHandler<LoginScreen> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  late final LoginCubit _cubit;
  late final LoadingDialog _loadingDialog;
  bool _isHidePassword = true;
  late final AnimatedBackgroundCubit _cubitBackground;

  @override
  void initState() {
    _cubit = getIt<LoginCubit>()..userCheck();
    _loadingDialog = getIt<LoadingDialog>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppbarWidget(
        'Login',
        actions: const <Widget>[LocaleButton()],
        showBackButton: false,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
        titleColor: Colors.white,
      ),
      body: BlocListener<LoginCubit, LoginState>(
        bloc: _cubit,
        listener: (BuildContext context, LoginState state) {
          _loadingDialog.show(context, state.isLoading);
          if (state.isSuccess || state.isLoggedIn) {
            AppRoute.clearAll(const HomeScreen());
            _formKey.currentState?.reset();
          }
          if (state.isError) {
            context.snackbar.showSnackBar(SnackbarWidget(
              state.message,
              context,
              state: SnackbarState.error,
            ));
          }
        },
        child: Stack(
          children: <Widget>[
            AnimatedBackgroundWidget(
              onInit: (AnimatedBackgroundCubit cubit) =>
                  _cubitBackground = cubit,
            ),
            SafeArea(
              child: ListWidget<Widget>(
                _contents,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                isSeparated: true,
                itemBuilder: (BuildContext context, Widget item, int index) =>
                    item,
                separatorBuilder:
                    (BuildContext context, Widget item, int index) =>
                        const SpacerWidget(16),
              ),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> get _contents => <Widget>[
        FormBuilder(
            key: _formKey,
            child: Column(children: <Widget>[
              TextFieldWidget('email',
                  label: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(width: 1, color: Colors.white),
                  ),
                  labelStyle: const TextStyle(color: Colors.white),
                  style: const TextStyle(color: Colors.white),
                  validators: <String? Function(String? p1)>[
                    FormBuilderValidators.email(),
                    FormBuilderValidators.required()
                  ]),
              const SpacerWidget(16),
              TextFieldWidget('password',
                  onSubmitted: (String? value) => _onSubmit(context),
                  label: LocaleKeys.password.tr(),
                  obscureText: _isHidePassword,
                  suffixIcon: IconButton(
                    onPressed: () =>
                        setState(() => _isHidePassword = !_isHidePassword),
                    icon: Icon(
                      _isHidePassword ? Icons.visibility : Icons.visibility_off,
                      color: Colors.white,
                    ),
                  ),
                  labelStyle: const TextStyle(color: Colors.white),
                  style: const TextStyle(color: Colors.white),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(width: 1, color: Colors.white),
                  ),
                  validators: <String? Function(String? p1)>[
                    FormBuilderValidators.required()
                  ]),
            ])),
        const SpacerWidget(16),
        Center(
          child: Text.rich(TextSpan(children: <TextSpan>[
            TextSpan(
                text: '${context.tr(LocaleKeys.dont_have_account)} ',
                style: const TextStyle(color: Colors.white)),
            TextSpan(
                text: LocaleKeys.register.tr(),
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.lightBlue),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    _cubitBackground.stopGradient();
                    AppRoute.to(const RegisterScreen()).then(
                        (dynamic value) => _cubitBackground.startGradient());
                  })
          ])),
        ),
        ElevatedButton(
            onPressed: () => _onSubmit(context), child: const Text('Login'))
      ];

  void _onSubmit(BuildContext context) async {
    final FormBuilderState? formKeyState = _formKey.currentState;
    if (formKeyState == null || !formKeyState.validate()) return;
    formKeyState.save();

    final UserDTO user = UserDTO.fromJson(formKeyState.value);
    _cubit.login(user);
  }

  @override
  void dispose() {
    final FormBuilderState? formKeyState = _formKey.currentState;
    if (formKeyState != null) {
      formKeyState
        ..deactivate()
        ..dispose();
    }
    super.dispose();
  }
}
