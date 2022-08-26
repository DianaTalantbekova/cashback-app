import 'package:cashback_app/commons/text_style_helper.dart';
import 'package:cashback_app/global_widgets/feliz_logo_widget.dart';
import 'package:cashback_app/screens/auth_screen/bloc/auth_bloc.dart';
import 'package:cashback_app/screens/auth_screen/forgout_password/forgout_pass_screen.dart';
import 'package:cashback_app/screens/auth_screen/local_widgets/auth_button_widget.dart';
import 'package:cashback_app/screens/auth_screen/local_widgets/auth_textfield_widget.dart';
import 'package:cashback_app/screens/auth_screen/sign_up_screen/local_widgets/authBox_widget.dart';
import 'package:cashback_app/screens/buyer/buyer_navigation_widget.dart/buyer_navigation_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late AuthBloc authBloc;

  @override
  void initState() {
    authBloc = AuthBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        bloc: authBloc,
        listener: (context, state) {
          if (state is AuthErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
              ),
            );
          }
          if (state is AuthSuccessState) {
            var box = Hive.box("userNameBox");
            box.put("username", phoneNumberController.text);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: ((context) => const BuyerNavigationWidget(
                      currentIndex: 0,
                    )),
              ),
            );
          }
        },
        builder: (context, state) {
          return Stack(
            children: <Widget>[
              const FelizLogoWidget(),
              Positioned(
                top: 231.h,
                left: 37.w,
                right: 37.w,
                child: AuthBoxWidget(
                  functionBox: 'Введите свои данные',
                  listWidgets: [
                    SizedBox(height: 50.h),
                    const AuthTextFieldWidget(
                      hintext: "Номер телефона",
                      textInputType: TextInputType.number,
                    ),
                    SizedBox(height: 23.h),
                    const AuthTextFieldWidget(
                      hintext: "Пароль",
                      textInputType: TextInputType.text,
                    ),
                    SizedBox(height: 5.h),
                    TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ForgoutPasswordScreen(),
                        ),
                      ),
                      child: Text(
                        'Забыли пароль?',
                        style: TextStyleHelper.forgotPass,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 28.h, bottom: 31.h),
                      child: AuthButtonWidget(
                        width: 98,
                        txtButton: 'ВОЙТИ',
                        function: () {
                          authBloc.add(
                            GetSignInEvent(
                              userpassword: passwordController.text,
                              phoneNumber: phoneNumberController.text,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
