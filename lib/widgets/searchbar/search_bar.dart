import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:plwha/res/custom_colors.dart';
// Search Page
class SearchPage extends StatefulWidget {
  const SearchPage({Key key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final bool _validate = false;
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.firebaseNavy,
      appBar: AppBar(
          backgroundColor: CustomColors.firebaseNavy,
          // The search area here
          title: Container(
            width: double.infinity,
            height: 40,
            decoration: BoxDecoration(
                color:CustomColors.firebaseBackground, borderRadius: BorderRadius.circular(5)),
            child: TextField(
              style: TextStyle(color: CustomColors.firebaseNavy),
              controller:_controller,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                  errorText: _validate ? 'Value Can\'t Be Empty' : null,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: CustomColors.firebaseNavy,style: BorderStyle.solid
                    ),
                  ),
                  prefixIcon: Icon(Icons.search,color: CustomColors.firebaseNavy,),
                  suffixIcon: GestureDetector(
                      onTap: () {
                        _controller.clear();
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                      child:const Icon(Icons.clear)
                  ),
                  hintText: "Search here",
                  hintStyle:TextStyle(
                    fontSize: 13,
                    color:  CustomColors.firebaseNavyLightInput,
                  ),
                  enabledBorder:const OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color(0xFFFFFFFF),style: BorderStyle.solid
                    ),
                  ),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  )
              ),
            ),
          )
      ),
    );
  }
}