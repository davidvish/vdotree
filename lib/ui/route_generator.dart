import 'package:IQRA/ui/widgets/featured_grid_movie_tv.dart';
import 'package:IQRA/ui/widgets/last_watched_movies.dart';
import 'package:IQRA/ui/widgets/recently_added_movies.dart';
import 'package:IQRA/ui/widgets/recently_added_tv_series.dart';
import 'package:flutter/material.dart';
import 'package:IQRA/ui/gateways/in_app_payment.dart';
import 'package:IQRA/ui/screens/actors_movies_grid.dart';
import 'package:IQRA/ui/screens/apply_coupon_screen.dart';
import 'package:IQRA/ui/screens/change_password_screen.dart';
import 'package:IQRA/ui/screens/create_screen_profile.dart';
import 'package:IQRA/ui/screens/forgot_password_screen.dart';
import 'package:IQRA/ui/screens/live_video_grid.dart';
import 'package:IQRA/ui/screens/manage_profile_screen.dart';
import 'package:IQRA/ui/screens/notification_detail_screen.dart';
import 'package:IQRA/ui/screens/update_profile_screen.dart';
import 'package:IQRA/ui/screens/watch_history_screen.dart';
import '../ui/gateways/paypal/PaypalPayment.dart';
import '../ui/gateways/paystack_payment.dart';
import '../ui/screens/actor_screen.dart';
import '../ui/screens/director_screen.dart';
import '../ui/screens/multi_screen.dart';
import '../ui/screens/app_settings_screen.dart';
import '../ui/screens/blog_list_screen.dart';
import '../ui/screens/donation_screen.dart';
import '../ui/screens/video_detail_screen.dart';
import 'package:page_transition/page_transition.dart';
import '../ui/screens/notifications_screen.dart';
import '../common/route_paths.dart';
import '../ui/screens/bottom_navigations_bar.dart';
import 'gateways/bank_payment.dart';
import '../ui/screens/blog_screen.dart';
import '../ui/screens/faq_screen.dart';
import '../ui/screens/login_home.dart';
import '../ui/screens/login_screen.dart';
import '../ui/screens/membership_screen.dart';
import '../ui/screens/other_history_screen.dart';
import '../ui/screens/pay_history_screen.dart';
import 'gateways/paytm_payment.dart';
import 'gateways/razor_payment.dart';
import '../ui/screens/register_screen.dart';
import '../ui/screens/select_payment_screen.dart';
import '../ui/screens/stripe_history_screen.dart';
import 'gateways/stripe_payment.dart';
import '../ui/screens/subscription_plan_screen.dart';
import '../ui/screens/intro_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/video_grid_screen.dart';
import 'shared/actors_grid.dart';
import 'shared/top_grid_view.dart';
import 'widgets/grid_movie_tv.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case RoutePaths.splashScreen:
        SplashScreen argument = args;
        return MaterialPageRoute(
            builder: (context) => SplashScreen(
                  token: argument.token,
                ));
      case RoutePaths.introSlider:
        return PageTransition(
            child: IntroScreen(), type: PageTransitionType.rightToLeft);
      case RoutePaths.loginHome:
        return PageTransition(
            child: LoginHome(), type: PageTransitionType.rightToLeft);
      case RoutePaths.login:
        return MaterialPageRoute(builder: (context) => LoginScreen());
      case RoutePaths.register:
        return MaterialPageRoute(builder: (context) => RegisterScreen());
      case RoutePaths.bottomNavigationHome:
        return MaterialPageRoute(builder: (_) => MyBottomNavigationBar());
      case RoutePaths.membership:
        return MaterialPageRoute(builder: (context) => MembershipScreen());
      case RoutePaths.faq:
        return PageTransition(
            child: FAQScreen(), type: PageTransitionType.rightToLeft);
      case RoutePaths.createScreen:
        return PageTransition(
            child: CreateMultiProfile(), type: PageTransitionType.rightToLeft);
      case RoutePaths.multiScreen:
        return PageTransition(
            child: MultiScreen(), type: PageTransitionType.rightToLeft);
      case RoutePaths.actorScreen:
        ActorScreen argument = args;
        return MaterialPageRoute(
            builder: (context) => ActorScreen(argument.actor));
      case RoutePaths.directorScreen:
        DirectorScreen argument = args;
        return MaterialPageRoute(
            builder: (context) => DirectorScreen(argument.index));
      case RoutePaths.blog:
        BlogScreen argument = args;
        return MaterialPageRoute(
            builder: (context) => BlogScreen(argument.index));
      case RoutePaths.blogList:
        return PageTransition(
            child: BlogListScreen(), type: PageTransitionType.rightToLeft);
      case RoutePaths.donation:
        return PageTransition(
            child: DonationScreen(), type: PageTransitionType.rightToLeft);
      case RoutePaths.notifications:
        return PageTransition(
            child: NotificationsScreen(), type: PageTransitionType.rightToLeft);
      case RoutePaths.notificationDetail:
        NotificationDetailScreen argument = args;
        return PageTransition(
            child: NotificationDetailScreen(argument.title, argument.message),
            type: PageTransitionType.rightToLeft);
      case RoutePaths.subscriptionPlans:
        return PageTransition(
            child: SubPlanScreen(), type: PageTransitionType.rightToLeft);
      case RoutePaths.applyCoupon:
        ApplyCouponScreen argument = args;
        return PageTransition(
            child: ApplyCouponScreen(argument.amount),
            type: PageTransitionType.rightToLeft);
      case RoutePaths.selectPayment:
        SelectPaymentScreen argument = args;
        return MaterialPageRoute(
            builder: (context) => SelectPaymentScreen(argument.planIndex));
      case RoutePaths.paymentHistory:
        return MaterialPageRoute(builder: (context) => PaymentHistoryScreen());
      case RoutePaths.stripeHistory:
        return MaterialPageRoute(builder: (context) => StripeHistoryScreen());
      case RoutePaths.otherHistory:
        return MaterialPageRoute(builder: (context) => OtherHistoryScreen());
      case RoutePaths.manageProfile:
        return MaterialPageRoute(builder: (context) => ManageProfileScreen());
      case RoutePaths.changePassword:
        return MaterialPageRoute(builder: (context) => ChangePasswordScreen());
      case RoutePaths.updateProfile:
        return MaterialPageRoute(builder: (context) => UpdateProfileScreen());
      case RoutePaths.bankPayment:
        return MaterialPageRoute(builder: (context) => BankPayment());
      case RoutePaths.razorpay:
        RazorPayment argument = args;
        return MaterialPageRoute(
            builder: (context) =>
                RazorPayment(argument.index, argument.payAmount));
      // case RoutePaths.stripe:
      //   StripePayment argument = args;
      //   return MaterialPageRoute(
      //       builder: (context) =>
      //           StripePayment(argument.index, argument.couponCode));
      case RoutePaths.braintree:
  
      case RoutePaths.paypal:
        PaypalPayment argument = args;
        return MaterialPageRoute(
            builder: (context) => PaypalPayment(
                  onFinish: argument.onFinish,
                  currency: argument.currency,
                  userFirstName: argument.userFirstName,
                  userLastName: argument.userLastName,
                  userEmail: argument.userEmail,
                  payAmount: argument.payAmount,
                  planIndex: argument.planIndex,
                ));
      // case RoutePaths.paytm:
      //   PaytmPayment argument = args;
      //   return MaterialPageRoute(
      //       builder: (context) =>
      //           PaytmPayment(argument.index, argument.payAmount));
      // case RoutePaths.paystack:
      //   PaystackPayment argument = args;
      //   return MaterialPageRoute(
      //       builder: (context) =>
      //           PaystackPayment(argument.index, argument.payAmount));
      case RoutePaths.inApp:
        InApp argument = args;
        return MaterialPageRoute(builder: (context) => InApp(argument.index));
      case RoutePaths.forgotPassword:
        ForgotPassword argument = args;
        return MaterialPageRoute(
            builder: (context) => ForgotPassword(argument.email));
      case RoutePaths.topVideos:
        return MaterialPageRoute(builder: (context) => TopGridView());
      case RoutePaths.liveGrid:
        return MaterialPageRoute(builder: (context) => LiveVideoGrid());
      case RoutePaths.actorMoviesGrid:
        ActorMoviesGrid argument = args;
        return MaterialPageRoute(
            builder: (context) => ActorMoviesGrid(argument.actorDetails));
      case RoutePaths.genreVideos:
        VideoGridScreen argument = args;
        return MaterialPageRoute(
            builder: (context) => VideoGridScreen(
                argument.id, argument.title, argument.genreDataList));
      case RoutePaths.gridVideos:
        GridMovieTV argument = args;
        return MaterialPageRoute(
            builder: (context) => GridMovieTV(argument.type));
      case RoutePaths.featuredGridVideos:
        FeaturedGridMovieTV argument = args;
        return MaterialPageRoute(
            builder: (context) => FeaturedGridMovieTV(argument.type));
      case RoutePaths.watchHistoryMovieData:
        LastWatchedGridMovieTV argument = args;
        return MaterialPageRoute(
            builder: (context) => LastWatchedGridMovieTV(argument.type));
      case RoutePaths.recentGridMovieVideos:
        RecentlyAddedGridMovieTV argument = args;
        return MaterialPageRoute(
            builder: (context) => RecentlyAddedGridMovieTV(argument.type));
      case RoutePaths.recentGridTvSeriesVideos:
        RecentlyAddedGridTVSeries argument = args;
        return MaterialPageRoute(
            builder: (context) => RecentlyAddedGridTVSeries(argument.type));
      case RoutePaths.actorsGrid:
        return MaterialPageRoute(builder: (context) => ActorsGrid());
      case RoutePaths.watchHistory:
        return PageTransition(
            child: WatchHistoryScreen(), type: PageTransitionType.rightToLeft);
      case RoutePaths.videoDetail:
        VideoDetailScreen argument = args;
        return MaterialPageRoute(
            builder: (context) => VideoDetailScreen(argument.videoDetail));
      case RoutePaths.appSettings:
        return PageTransition(
            child: AppSettingsScreen(), type: PageTransitionType.rightToLeft);
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
