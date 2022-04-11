import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plwha/res/custom_colors.dart';
import '../../screens/sign_in_screen.dart';
import '../../screens/user_info_screen.dart';
import '../../services/auth.dart';
import '../searchbar/search_bar.dart';
import 'app_bar_title.dart';

class HomeAppBarUI extends StatelessWidget{
  const HomeAppBarUI({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return AppBar(
      elevation: 0,
      backgroundColor: CustomColors.firebaseNavy,
      title: const AppBarTitle(),
      actions:
      <Widget>[
        Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const SearchPage()
                    ));
              },
              child: const Icon(
                Icons.search,
                size: 26.0,
              ),
            )
        ),

        PopupMenuButton(
            color: CustomColors.firebaseNavy,
            // add icon, by default "3 dot" icon
            // icon: Icon(Icons.book)
            itemBuilder: (context) {
              return [
                PopupMenuItem<int>(
                  value: 0,
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.person, size: 18,),
                        SizedBox(width: 5,),
                        Text(" Profile"),
                      ]
                  ),
                ),

                PopupMenuItem<int>(
                  value: 1,
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.info, size: 18,),
                        SizedBox(width: 5,),
                        Text(" About PLWHA"),
                      ]
                  ),
                ),

                PopupMenuItem<int>(
                  value: 2,
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(
                          Icons.arrow_left, size: 18,),
                        SizedBox(width: 5,),
                        Text(" Logout"),
                      ]
                  ),
                ),
              ];
            },
            onSelected: (value) {
              if (value == 0) {
                User user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => UserInfoScreen(
                        user: user,
                      ),
                    ),
                  );
                }
              } else if (value == 1) {
                _showMyDialog(context);
              } else if (value == 2) {
                _logoutUser(context);
              }
              try {} on Exception catch (_, e) {
                  print(e);
              }
            }
        ),
      ],
    );
  }
  Future<void> _showMyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('PEOPLE LIVING WITH HIV/AIS PROJECT'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text("The Project titled People Living with HIV and Aids (PLWHA) is coordinated under the Faculty of Law Mzumbe University "
                    "in collaboration with the University of Ghent in Belgium. HIV/AIDS is a major development crisis"
                    "affecting the whole population and all sectors. Being an economic, social, and cultural problem, HIV/AIDS"
                    "discrimination and stigma is one of the greatest challenges in the prevention and control of the epidemic. Often, people"
                    "living with HIV/AIDS are deprived of health and social protection."),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close', style: TextStyle(
                color: CustomColors.firebaseBackground
              ),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  _logoutUser(BuildContext context) async{

    await AuthMethods.signOut();
    Navigator.of(context)
        .pushReplacement(routeToSignInScreen());

  }
  PageRoute routeToSignInScreen() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const SignInScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(-1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
