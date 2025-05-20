import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travellookup/blocs/blog_bloc.dart';
import 'package:travellookup/blocs/bookmark_bloc.dart';
import 'package:travellookup/blocs/comments_bloc.dart';
import 'package:travellookup/blocs/featured_bloc.dart';
import 'package:travellookup/blocs/internet_bloc.dart';
import 'package:travellookup/blocs/notification_bloc.dart';
import 'package:travellookup/blocs/other_places_bloc.dart';
import 'package:travellookup/blocs/popular_places_bloc.dart';
import 'package:travellookup/blocs/recent_places_bloc.dart';
import 'package:travellookup/blocs/recommanded_places_bloc.dart';
import 'package:travellookup/blocs/search_bloc.dart';
import 'package:travellookup/blocs/sign_in_bloc.dart';
import 'package:travellookup/blocs/sp_state_one.dart';
import 'package:travellookup/blocs/sp_state_two.dart';
import 'package:travellookup/blocs/state_bloc.dart';
import 'package:travellookup/core/utils/initial_bindings.dart';
import 'package:travellookup/firebase_options.dart';
import 'package:travellookup/router/app_routes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(EasyLocalization(
    supportedLocales: [Locale('vi'), Locale('en')],
    path: 'assets/translations',
    fallbackLocale: Locale('vi'),
    startLocale: Locale('vi'),
    useOnlyLangCode: true,
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<BlogBloc>(
          create: (context) => BlogBloc(),
        ),
        ChangeNotifierProvider<InternetBloc>(
          create: (context) => InternetBloc(),
        ),
        ChangeNotifierProvider<SignInBloc>(
          create: (context) => SignInBloc(),
        ),
        ChangeNotifierProvider<CommentsBloc>(
          create: (context) => CommentsBloc(),
        ),
        ChangeNotifierProvider<BookmarkBloc>(
          create: (context) => BookmarkBloc(),
        ),
        ChangeNotifierProvider<PopularPlacesBloc>(
          create: (context) => PopularPlacesBloc(),
        ),
        ChangeNotifierProvider<RecentPlacesBloc>(
          create: (context) => RecentPlacesBloc(),
        ),
        ChangeNotifierProvider<RecommandedPlacesBloc>(
          create: (context) => RecommandedPlacesBloc(),
        ),
        ChangeNotifierProvider<FeaturedBloc>(
          create: (context) => FeaturedBloc(),
        ),
        ChangeNotifierProvider<SearchBloc>(create: (context) => SearchBloc()),
        ChangeNotifierProvider<NotificationBloc>(
            create: (context) => NotificationBloc()),
        ChangeNotifierProvider<StateBloc>(create: (context) => StateBloc()),
        ChangeNotifierProvider<SpecialStateOneBloc>(
            create: (context) => SpecialStateOneBloc()),
        ChangeNotifierProvider<SpecialStateTwoBloc>(
            create: (context) => SpecialStateTwoBloc()),
        ChangeNotifierProvider<OtherPlacesBloc>(
            create: (context) => OtherPlacesBloc()),
      ],
      child: GetMaterialApp(
        supportedLocales: context.supportedLocales,
        localizationsDelegates: context.localizationDelegates,
        locale: context.locale,
        debugShowCheckedModeBanner: false,
        title: 'Travel Look Up',
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        initialRoute: AppRoutes.onBoarding,
        getPages: AppRoutes.pages,
        initialBinding: InitialBindings(),
      ),
    );
  }
}

// width: 360
// height: 687