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
import 'cubit/register_cubit.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  late final RegisterCubit _cubit;
  late final LoadingDialog _loadingDialog;
  late final AnimatedBackgroundCubit _backgroundCubit;
  String _password = '';
  bool _isHidePassword = true;
  bool _isHideConfirmPassword = true;

  @override
  void initState() {
    _cubit = getIt<RegisterCubit>();
    _loadingDialog = getIt<LoadingDialog>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppbarWidget(
        LocaleKeys.register.tr(),
        actions: const <Widget>[LocaleButton()],
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
        backColor: Colors.white,
        titleColor: Colors.white,
      ),
      body: BlocListener<RegisterCubit, RegisterState>(
        bloc: _cubit,
        listener: (BuildContext context, RegisterState state) {
          _loadingDialog.show(context, state.isLoading);

          if (state.isError) {
            context.snackbar.showSnackBar(SnackbarWidget(
              state.message,
              context,
              state: SnackbarState.error,
            ));
          }

          if (state.isSuccess) {
            context.snackbar.showSnackBar(SnackbarWidget(
              state.message,
              context,
              state: SnackbarState.success,
            ));
            _formKey.currentState?.reset();
            AppRoute.back();
          }
        },
        child: Stack(
          children: <Widget>[
            AnimatedBackgroundWidget(
              onInit: (AnimatedBackgroundCubit cubit) =>
                  _backgroundCubit = cubit,
            ),
            SafeArea(
              child: ListWidget<Widget>(
                _contents,
                isSeparated: true,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
              TextFieldWidget('name',
                  textInputAction: TextInputAction.next,
                  label: LocaleKeys.name.tr(),
                  keyboardType: TextInputType.text,
                  hint: 'Jhon Doe',
                  labelStyle: const TextStyle(color: Colors.white),
                  style: const TextStyle(color: Colors.white),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(width: 1, color: Colors.white),
                  ),
                  validators: <String? Function(String? p1)>[
                    FormBuilderValidators.required()
                  ]),
              const SpacerWidget(16),
              TextFieldWidget('email',
                  label: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  labelStyle: const TextStyle(color: Colors.white),
                  style: const TextStyle(color: Colors.white),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(width: 1, color: Colors.white),
                  ),
                  validators: <String? Function(String? p1)>[
                    FormBuilderValidators.required(),
                    FormBuilderValidators.email()
                  ]),
              const SpacerWidget(16),
              TextFieldWidget('password',
                  label: context.tr(LocaleKeys.password),
                  obscureText: _isHidePassword,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  suffixIcon: IconButton(
                      onPressed: () =>
                          setState(() => _isHidePassword = !_isHidePassword),
                      icon: Icon(
                        _isHidePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.white,
                      )),
                  onChanged: (String? value) =>
                      setState(() => _password = value ?? ''),
                  labelStyle: const TextStyle(color: Colors.white),
                  style: const TextStyle(color: Colors.white),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(width: 1, color: Colors.white),
                  ),
                  validators: <String? Function(String? p1)>[
                    FormBuilderValidators.required(),
                    FormBuilderValidators.minLength(8)
                  ]),
              const SpacerWidget(16),
              TextFieldWidget('confimPassword',
                  label: LocaleKeys.confirm_password.tr(),
                  obscureText: _isHideConfirmPassword,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onSubmitted: (String? value) => _onSubmit(),
                  suffixIcon: IconButton(
                      onPressed: () => setState(() =>
                          _isHideConfirmPassword = !_isHideConfirmPassword),
                      icon: Icon(
                        _isHideConfirmPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.white,
                      )),
                  labelStyle: const TextStyle(color: Colors.white),
                  style: const TextStyle(color: Colors.white),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(width: 1, color: Colors.white),
                  ),
                  validators: <String? Function(String? p1)>[
                    FormBuilderValidators.required(),
                    FormBuilderValidators.equal(_password,
                        errorText: LocaleKeys.must_same_pw.tr()),
                  ]),
            ])),
        const SpacerWidget(16),
        Center(
          child: RichText(
              text: TextSpan(children: <TextSpan>[
            TextSpan(text: '${LocaleKeys.have_account.tr()} '),
            TextSpan(
                text: 'Login.',
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.blue),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    _backgroundCubit.stopGradient();
                    AppRoute.back();
                  }),
          ])),
        ),
        ElevatedButton(
            onPressed: _onSubmit, child: const Text(LocaleKeys.register).tr())
      ];

  void _onSubmit() {
    final FormBuilderState? formKeyState = _formKey.currentState;
    if (formKeyState == null || !formKeyState.validate()) return;
    formKeyState.save();

    final UserDTO user = UserDTO.fromJson(formKeyState.value);
    _cubit.register(user);
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
