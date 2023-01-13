import 'package:innovimmobilier/utilities/constants/colors.dart';
import 'package:innovimmobilier/utilities/constants/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NoConnexion extends StatelessWidget {
  const NoConnexion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: AppColors.white,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "assets/images/signal_searching.svg",
            width: AppDimensions.width200,
          ),
          SizedBox(
            height: AppDimensions.height20,
          ),
          Text(
            'Aucune connexion internet',
            style: TextStyle(
              fontSize: AppDimensions.font18,
              color: Colors.black,
            ),
          ),
          Container(
            padding: EdgeInsets.all(AppDimensions.height30),
            child: Text(
              'Veuillez vérifier que vos données mobiles ou connexion wifi sont activées.',
              maxLines: 2,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppDimensions.font14,
                color: Colors.black.withOpacity(0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
