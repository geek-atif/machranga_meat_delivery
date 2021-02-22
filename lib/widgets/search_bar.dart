import '../models/home_page_model.dart';
import '../util/constant.dart';
import '../util/styling.dart';
import 'package:flutter/material.dart';

class MySearchBar extends StatelessWidget {
  final Size screenSize;
  HomePageModel homePageModel;
  MySearchBar({this.screenSize, this.homePageModel});

  @override
  Widget build(BuildContext context) {
    return Container(
     
      decoration: new BoxDecoration(
        boxShadow: [
          new BoxShadow(
            color: AppTheme.boxShadow,
            blurRadius: 20.0,
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context)
              .pushNamed(Constant.SEARCH_SCREEN, arguments: homePageModel);
        },
        child: Card(
          child: Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 8),
                child: Icon(
                  Icons.search,
                  color: AppTheme.redButtonColor,
                  size: 25,
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 8),
                child: Text(
                  'Search Products',
                  style: TextStyle(
                      color: AppTheme.serachColor,
                      fontFamily: 'Muli',
                      fontSize: 16),
                ),
              ),
            ],
          ),
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(64),
          ),
        ),
      ),
    );

    //   return Container(
    //     margin: EdgeInsets.all(10),
    //     child: SearchBar<Post>(
    //       loader: Text("loading..."),
    //       searchBarStyle: SearchBarStyle(
    //         backgroundColor: Colors.white,
    //         borderRadius: BorderRadius.circular(45),
    //       ),
    //       hintText: "Search Products",
    //       hintStyle: TextStyle(
    //         color: Color(0xFFC9C9C9),
    //         //height: 20
    //       ),
    //       //cancellationWidget: Text("Cancel"),
    //       icon: Icon(
    //         Icons.search,
    //         color: Color(0xFFDD2121),
    //       ),
    //       onSearch: search,
    //       onItemFound: (Post post, int index) {
    //         return ListTile(
    //           title: Text(post.title),
    //           subtitle: Text(post.description),
    //         );
    //       },
    //     ),
    //   );
    // }

    // Future<List<Post>> search(String search) async {
    //     await Future.delayed(Duration(seconds: 2));
    //     return List.generate(search.length, (int index) {
    //       return Post(
    //         "Title : $search $index",
    //         "Description :$search $index",
    //       );
    //     });
  }
}
