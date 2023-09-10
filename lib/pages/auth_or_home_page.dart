import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/pages/login_page.dart';
import 'package:shop/pages/products_overview_page.dart';

import '../models/auth.dart';

class AuthOrHomePage extends StatelessWidget {
  const AuthOrHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);
    return FutureBuilder(
      future: auth.tryAutoLogin(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.error != null) {
          return Center(
            child: Text('Ocorreu um erro'),
          );
        } else {
          return auth.isAuth ? ProductsOverviewPage() : LoginPage();
        }
      },
    );
  }
}
