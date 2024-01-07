import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:frappe_app/config/frappe_palette.dart';
import 'package:frappe_app/config/palette.dart';
import 'package:frappe_app/form/controls/control.dart';
import 'package:frappe_app/model/doctype_response.dart';
import 'package:frappe_app/model/login_request.dart';
import 'package:frappe_app/ui/common/ui_helpers.dart';
import 'package:frappe_app/ui/views/login/components/frappe_logo.dart';
import 'package:frappe_app/ui/views/login/components/password_field.dart';
import 'package:frappe_app/utils/enums.dart';
import 'package:frappe_app/utils/http.dart';
import 'package:frappe_app/widgets/frappe_button.dart';
import 'package:stacked/stacked.dart';

import 'login_viewmodel.dart';

class LoginView extends StackedView<LoginViewModel> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    LoginViewModel viewModel,
    Widget? child,
  ) {
    final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            verticalSpaceBig,
            FrappeLogo(),
            verticalSpaceMedium,
            Text(
              'Login to Frappe',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            verticalSpaceMedium,
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  FormBuilder(
                    key: _fbKey,
                    child: Column(
                      children: <Widget>[
                        buildDecoratedControl(
                          control: FormBuilderTextField(
                            name: 'serverURL',
                            // initialValue: model.savedCreds.serverURL,
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                              FormBuilderValidators.url(),
                            ]),
                            decoration: Palette.formFieldDecoration(
                              label: "Server URL",
                            ),
                          ),
                          field: DoctypeField(
                            fieldname: 'serverUrl',
                            label: "Server URL",
                          ),
                        ),
                        buildDecoratedControl(
                          control: FormBuilderTextField(
                            name: 'usr',
                            // initialValue: model.savedCreds.usr,
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                            ]),
                            decoration: Palette.formFieldDecoration(
                              label: "Email Address",
                            ),
                          ),
                          field: DoctypeField(
                              fieldname: "email", label: "Email Address"),
                        ),
                        PasswordField(),
                        FrappeFlatButton(
                          title: "model.loginButtonLabel",
                          fullWidth: true,
                          height: 46,
                          buttonType: ButtonType.primary,
                          onPressed: () async {
                            FocusScope.of(context).requestFocus(
                              FocusNode(),
                            );

                            if (_fbKey.currentState != null) {
                              if (_fbKey.currentState!.saveAndValidate()) {
                                var formValue = _fbKey.currentState?.value;

                                try {
                                  await setBaseUrl(formValue!["serverURL"]);

                                  var loginRequest = LoginRequest(
                                    usr: formValue["usr"].trimRight(),
                                    pwd: formValue["pwd"],
                                  );

                                  var loginResponse = await model.login(
                                    loginRequest,
                                  );

                                  if (loginResponse.verification != null &&
                                      loginResponse.tmpId != null) {
                                    showModalBottomSheet(
                                      context: context,
                                      useRootNavigator: true,
                                      isScrollControlled: true,
                                      builder: (context) =>
                                          VerificationBottomSheetView(
                                        loginRequest: loginRequest,
                                        tmpId: loginResponse.tmpId!,
                                        message:
                                            loginResponse.verification!.prompt,
                                      ),
                                    );
                                  } else {
                                    NavigationHelper.pushReplacement(
                                      context: context,
                                      page: HomeView(),
                                    );
                                  }
                                } on ErrorResponse catch (e) {
                                  if (e.statusCode == HttpStatus.unauthorized) {
                                    FrappeAlert.errorAlert(
                                      title: "Not Authorized",
                                      subtitle: e.statusMessage,
                                      context: context,
                                    );
                                  } else {
                                    FrappeAlert.errorAlert(
                                      title: "Error",
                                      subtitle: e.statusMessage,
                                      context: context,
                                    );
                                  }
                                } catch (e) {
                                  print("$e");
                                  FrappeAlert.errorAlert(
                                    title: "Error",
                                    subtitle: "Internal error occured!",
                                    context: context,
                                  );
                                }
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  LoginViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      LoginViewModel();
}

class VerificationBottomSheetView extends StatefulWidget {
  final String message;
  final String tmpId;
  final LoginRequest loginRequest;

  VerificationBottomSheetView({
    required this.message,
    required this.tmpId,
    required this.loginRequest,
  });

  @override
  _VerificationBottomSheetViewState createState() =>
      _VerificationBottomSheetViewState();
}

class _VerificationBottomSheetViewState
    extends State<VerificationBottomSheetView> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return BaseView<LoginViewModel>(
      builder: (context, model, child) => AnimatedPadding(
        padding: MediaQuery.of(context).viewInsets,
        duration: const Duration(milliseconds: 100),
        child: FractionallySizedBox(
          heightFactor: 0.4,
          child: FrappeBottomSheet(
            title: 'Verification',
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Text(widget.message),
                  SizedBox(
                    height: 10,
                  ),
                  FormBuilder(
                    key: _fbKey,
                    child: buildDecoratedControl(
                      control: FormBuilderTextField(
                        name: 'otp',
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                        decoration: Palette.formFieldDecoration(
                          label: "Verification",
                        ),
                      ),
                      field: DoctypeField(
                        fieldname: 'otp',
                        label: "Verification",
                      ),
                    ),
                  ),
                  FrappeFlatButton(
                    title: model.loginButtonLabel,
                    fullWidth: true,
                    height: 46,
                    buttonType: ButtonType.primary,
                    onPressed: () async {
                      FocusScope.of(context).requestFocus(
                        FocusNode(),
                      );

                      if (_fbKey.currentState != null) {
                        if (_fbKey.currentState!.saveAndValidate()) {
                          var formValue = _fbKey.currentState?.value;
                          widget.loginRequest.tmpId = widget.tmpId;
                          widget.loginRequest.otp = formValue!["otp"];
                          widget.loginRequest.cmd = "login";

                          try {
                            await model.login(widget.loginRequest);

                            NavigationHelper.pushReplacement(
                              context: context,
                              page: HomeView(),
                            );
                          } catch (e) {
                            var _e = e as ErrorResponse;

                            if (_e.statusCode == HttpStatus.unauthorized) {
                              FrappeAlert.errorAlert(
                                title: "Not Authorized",
                                subtitle: _e.statusMessage,
                                context: context,
                              );
                            } else {
                              FrappeAlert.errorAlert(
                                title: "Error",
                                subtitle: _e.statusMessage,
                                context: context,
                              );
                            }
                          }
                        }
                      }
                    },
                  ),
                  Container(
                    height: 100,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}