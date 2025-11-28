import 'package:go_router/go_router.dart';

import '../features/business/models/business.dart';
import '../features/business/screens/edit_business_screen.dart';
import '../features/invoice/screens/invoice_search_screen.dart';
import '../features/signature/screens/signature_screen.dart';
import '../features/client/models/client.dart';
import '../features/client/screens/edit_client_screen.dart';
import '../features/home/screens/home_screen.dart';
import '../features/invoice/models/invoice.dart';
import '../features/invoice/models/photo.dart';
import '../features/invoice/screens/edit_invoice_screen.dart';
import '../features/invoice/screens/invoice_customize_screen.dart';
import '../features/invoice/screens/invoice_details_screen.dart';
import '../features/invoice/screens/invoice_preview_screen.dart';
import '../features/invoice/screens/photo_screen.dart';
import '../features/item/models/item.dart';
import '../features/item/screens/edit_item_screen.dart';
import '../features/onboard/screens/business_info_screen.dart';
import '../features/onboard/screens/onboard_screen.dart';
import '../features/splash/screens/splash_screen.dart';
import '../features/vip/screens/vip_screen.dart';

final routerConfig = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: HomeScreen.routePath,
      builder: (context, state) => HomeScreen(
        showPaywall: state.extra as bool,
      ),
    ),

    // onboard
    GoRoute(
      path: OnboardScreen.routePath,
      builder: (context, state) => const OnboardScreen(),
    ),
    GoRoute(
      path: BusinessInfoScreen.routePath,
      builder: (context, state) => const BusinessInfoScreen(),
    ),

    // invoice
    GoRoute(
      path: InvoiceSearchScreen.routePath,
      builder: (context, state) => const InvoiceSearchScreen(),
    ),
    GoRoute(
      path: InvoiceDetailsScreen.routePath,
      builder: (context, state) => InvoiceDetailsScreen(
        invoice: state.extra as Invoice,
      ),
    ),
    GoRoute(
      path: InvoicePreviewScreen.routePath,
      builder: (context, state) => InvoicePreviewScreen(
        invoice: state.extra as Invoice,
      ),
    ),
    GoRoute(
      path: InvoiceCustomizeScreen.routePath,
      builder: (context, state) => InvoiceCustomizeScreen(
        invoice: state.extra as Invoice,
      ),
    ),
    GoRoute(
      path: EditInvoiceScreen.routePath,
      builder: (context, state) => EditInvoiceScreen(
        invoice: state.extra as Invoice?,
      ),
    ),
    GoRoute(
      path: PhotoScreen.routePath,
      builder: (context, state) => PhotoScreen(
        photo: state.extra as Photo,
      ),
    ),

    // business
    GoRoute(
      path: EditBusinessScreen.routePath,
      builder: (context, state) => EditBusinessScreen(
        business: state.extra as Business?,
      ),
    ),

    // client
    GoRoute(
      path: EditClientScreen.routePath,
      builder: (context, state) => EditClientScreen(
        client: state.extra as Client?,
      ),
    ),

    // item
    GoRoute(
      path: EditItemScreen.routePath,
      builder: (context, state) => EditItemScreen(
        item: state.extra as Item?,
      ),
    ),

    // signature
    GoRoute(
      path: SignatureScreen.routePath,
      builder: (context, state) => const SignatureScreen(),
    ),

    // vip
    GoRoute(
      path: VipScreen.routePath,
      builder: (context, state) => const VipScreen(),
    ),
  ],
);
