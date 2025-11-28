import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';

import 'src/core/constants.dart';
import 'src/core/router.dart';
import 'src/core/themes.dart';
import 'src/core/utils.dart';
import 'src/features/business/bloc/business_bloc.dart';
import 'src/features/business/data/business_repository.dart';
import 'src/features/business/models/business.dart';
import 'src/features/client/bloc/client_bloc.dart';
import 'src/features/client/data/client_repository.dart';
import 'src/features/client/models/client.dart';
import 'src/features/home/bloc/home_bloc.dart';
import 'src/features/internet/bloc/internet_bloc.dart';
import 'src/features/invoice/bloc/invoice_bloc.dart';
import 'src/features/invoice/data/invoice_repository.dart';
import 'src/features/invoice/data/photo_repository.dart';
import 'src/features/invoice/models/invoice.dart';
import 'src/features/invoice/models/photo.dart';
import 'src/features/item/bloc/item_bloc.dart';
import 'src/features/item/data/item_repository.dart';
import 'src/features/item/models/item.dart';
import 'src/features/onboard/data/onboard_repository.dart';
import 'src/features/profile/data/profile_repository.dart';
import 'src/features/vip/bloc/vip_bloc.dart';
import 'src/features/vip/data/vip_repository.dart';
import 'src/features/vip/screens/vip_screen.dart';

// final colors = Theme.of(context).extension<MyColors>()!;

// adb tcpip 5555 && adb connect 192.168.0.190

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final prefs = await SharedPreferences.getInstance();
  // await prefs.clear();

  final path = join(await getDatabasesPath(), 'data.db');
  // await deleteDatabase(path);

  final db = await openDatabase(
    path,
    version: 1,
    onCreate: (db, version) async {
      logger('CREATE');
      await db.execute(Invoice.create);
      await db.execute(Photo.create);
      await db.execute(Business.create);
      await db.execute(Client.create);
      await db.execute(Item.create);
    },
  );

  String? userID = prefs.getString(Keys.userID);

  if (userID == null) {
    userID = const Uuid().v4();
    await prefs.setString(Keys.userID, userID);
  }

  await VipScreen.configure(userID);

  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // await FirebaseAnalytics.instance.setUserId(id: userID);

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<OnboardRepository>(
          create: (context) => OnboardRepositoryImpl(prefs: prefs),
        ),
        RepositoryProvider<ProfileRepository>(
          create: (context) => ProfileRepositoryImpl(prefs: prefs),
        ),
        RepositoryProvider<VipRepository>(
          create: (context) => VipRepositoryImpl(prefs: prefs),
        ),
        RepositoryProvider<InvoiceRepository>(
          create: (context) => InvoiceRepositoryImpl(db: db),
        ),
        RepositoryProvider<PhotoRepository>(
          create: (context) => PhotoRepositoryImpl(db: db),
        ),
        RepositoryProvider<BusinessRepository>(
          create: (context) => BusinessRepositoryImpl(db: db),
        ),
        RepositoryProvider<ClientRepository>(
          create: (context) => ClientRepositoryImpl(db: db),
        ),
        RepositoryProvider<ItemRepository>(
          create: (context) => ItemRepositoryImpl(db: db),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => HomeBloc()),
          BlocProvider(
            create: (context) => InternetBloc()..add(CheckInternet()),
          ),
          BlocProvider(
            create: (context) => VipBloc(
              repository: context.read<VipRepository>(),
            )..add(CheckVip()),
          ),
          BlocProvider(
            create: (context) => InvoiceBloc(
              invoiceRepository: context.read<InvoiceRepository>(),
              photoRepository: context.read<PhotoRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => BusinessBloc(
              repository: context.read<BusinessRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => ClientBloc(
              repository: context.read<ClientRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => ItemBloc(
              repository: context.read<ItemRepository>(),
            ),
          ),
        ],
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          themeMode: ThemeMode.light,
          theme: Themes(isDark: false).theme,
          darkTheme: Themes(isDark: true).theme,
          routerConfig: routerConfig,
        ),
      ),
    ),
  );
}
