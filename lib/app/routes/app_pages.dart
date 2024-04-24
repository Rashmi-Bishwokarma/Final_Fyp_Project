import 'package:get/get.dart';

import '../modules/WelcomePage/bindings/welcome_page_binding.dart';
import '../modules/WelcomePage/views/welcome_page_view.dart';
import '../modules/admin/bindings/admin_binding.dart';
import '../modules/admin/views/admin_view.dart';
import '../modules/adminProfile/bindings/admin_profile_binding.dart';
import '../modules/adminProfile/views/admin_profile_view.dart';
import '../modules/adminpayment/bindings/adminpayment_binding.dart';
import '../modules/adminpayment/views/adminpayment_view.dart';
import '../modules/dashboard/bindings/dashboard_binding.dart';
import '../modules/dashboard/views/dashboard_view.dart';
import '../modules/editJournal/bindings/edit_journal_binding.dart';
import '../modules/editJournal/views/edit_journal_view.dart';
import '../modules/explore/bindings/explore_binding.dart';
import '../modules/explore/views/explore_view.dart';
import '../modules/feedback/bindings/feedback_binding.dart';
import '../modules/feedback/views/feedback_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/journal/bindings/journal_binding.dart';
import '../modules/journal/views/journal_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/notify/bindings/notify_binding.dart';
import '../modules/notify/views/notify_view.dart';
import '../modules/payment/bindings/payment_binding.dart';
import '../modules/payment/views/payment_view.dart';
import '../modules/plans/bindings/plans_binding.dart';
import '../modules/plans/views/plans_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/settings/bindings/settings_binding.dart';
import '../modules/settings/views/settings_view.dart';
import '../modules/showJournal/bindings/showjournal_binding.dart';
import '../modules/showJournal/views/showjournal_view.dart';
import '../modules/showJournalAdmin/bindings/show_journal_admin_binding.dart';
import '../modules/showJournalAdmin/views/show_journal_admin_view.dart';
import '../modules/showNote/bindings/show_note_binding.dart';
import '../modules/showNote/views/show_note_view.dart';
import '../modules/sidebar/bindings/sidebar_binding.dart';
import '../modules/sidebar/views/sidebar_view.dart';
import '../modules/to_do_list/bindings/to_do_list_binding.dart';
import '../modules/to_do_list/views/to_do_list_view.dart';
import '../modules/user_home/bindings/user_home_binding.dart';
import '../modules/user_home/views/user_home_view.dart';
import '../modules/userlist/bindings/userlist_binding.dart';
import '../modules/userlist/views/userlist_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  // ignore: constant_identifier_names
  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.JOURNAL,
      page: () => const JournalView(),
      binding: JournalBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.SHOWJOURNAL,
      page: () => ShowJournalView(),
      binding: ShowjournalBinding(),
    ),
    GetPage(
      name: _Paths.TO_DO_LIST,
      page: () => ToDoListView(),
      binding: ToDoListBinding(),
    ),
    GetPage(
      name: _Paths.USER_HOME,
      page: () => UserHomeView(),
      binding: UserHomeBinding(),
    ),
    GetPage(
      name: _Paths.ADMIN,
      page: () => const AdminView(),
      binding: AdminBinding(),
    ),
    GetPage(
      name: _Paths.WELCOME_PAGE,
      page: () => const WelcomePageView(),
      binding: WelcomePageBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.SIDEBAR,
      page: () => const SidebarView(),
      binding: SidebarBinding(),
    ),
    GetPage(
      name: _Paths.SETTINGS,
      page: () => SettingsView(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_JOURNAL,
      page: () => const EditJournalView(),
      binding: EditJournalBinding(),
    ),
    GetPage(
      name: _Paths.EXPLORE,
      page: () => ExploreView(),
      binding: ExploreBinding(),
    ),
    GetPage(
      name: _Paths.SHOW_NOTE,
      page: () => ShowNoteView(),
      binding: ShowNoteBinding(),
    ),
    GetPage(
      name: _Paths.PAYMENT,
      page: () => PaymentView(),
      binding: PaymentBinding(),
    ),
    GetPage(
      name: _Paths.SHOW_JOURNAL_ADMIN,
      page: () => ShowJournalAdminView(),
      binding: ShowJournalAdminBinding(),
    ),
    GetPage(
      name: _Paths.DASHBOARD,
      page: () => DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: _Paths.FEEDBACK,
      page: () => const FeedbackView(),
      binding: FeedbackBinding(),
    ),
    GetPage(
      name: _Paths.USERLIST,
      page: () => UserListView(),
      binding: UserlistBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFY,
      page: () => const NotifyView(),
      binding: NotifyBinding(),
    ),
    GetPage(
      name: _Paths.ADMINPAYMENT,
      page: () => const AdminpaymentView(),
      binding: AdminpaymentBinding(),
    ),
    GetPage(
      name: _Paths.PLANS,
      page: () => const PlansView(),
      binding: PlansBinding(),
    ),
    GetPage(
      name: _Paths.ADMIN_PROFILE,
      page: () => AdminProfileView(),
      binding: AdminProfileBinding(),
    ),
  ];
}
