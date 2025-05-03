import 'dart:io';
import 'package:foap/helper/imports/common_import.dart';
import 'package:foap/screens/chat/chat_history.dart';
import 'package:foap/screens/content_creator_view.dart';
import 'package:foap/screens/settings_menu/packages_screen.dart';
import '../../components/force_update_view.dart';
import '../../main.dart';
import '../add_on/ui/reel/reels.dart';
import '../home_feed/home_feed_screen.dart';
import '../profile/my_profile.dart';
import '../settings_menu/settings_controller.dart';
import 'explore.dart';

class DashboardController extends GetxController {
  RxInt currentIndex = 5.obs;
  RxInt unreadMsgCount = 0.obs;
  RxBool isLoading = false.obs;

  indexChanged(int index) {
    currentIndex.value = index;
  }

  updateUnreadMessageCount(int count) {
    unreadMsgCount.value = count;
  }
}

class DashboardScreen extends StatefulWidget {
  bool isHomeView;
  DashboardScreen({this.isHomeView = false, super.key});

  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<DashboardScreen> {
  final DashboardController _dashboardController = Get.find();
  final SettingsController _settingsController = Get.find();

  List<Widget> widgets = [
    ChatHistory(isDashboard: true),
    const Reels(
      needBackBtn: false,
    ),
    ContentCreatorView(isComingFromDashboard: true),
    // PackagesagesScreen(isComingFromDashboard: true),
    HomeFeedScreen(),
    const MyProfile(showBack: false),

  ];
  bool hasPermission = false;

  @override
  void initState() {
    isAnyPageInStack = true;

    super.initState();
  }
 
  @override
  Widget build(BuildContext context) {
    return Obx(() => _dashboardController.isLoading.value == true
        ? SizedBox(
            height: Get.height,
            width: Get.width,
            child: const Center(child: CircularProgressIndicator()),
          )
        : _settingsController.forceUpdate.value == true
            ? ForceUpdateView()
            : _settingsController.appearanceChanged?.value == null
                ? Container()
                : AppScaffold(
                    backgroundColor: AppColorConstants.backgroundColor,
                    // body: widgets[_dashboardController.currentIndex.value],

                    body: IndexedStack(
                      index: _dashboardController.currentIndex.value,
                      children: widgets.map((e) {
                        if (e is HomeFeedScreen) {
                          return HomeFeedScreen();
                        } else {
                          return e;
                        }
                      }).toList(),
                    ),
                    floatingActionButtonLocation:
                        FloatingActionButtonLocation.centerDocked,
                    bottomNavigationBar: SizedBox(
                      height: Platform.isIOS ? 100 : 80,
                      width: Get.width,
                      child: BottomNavigationBar(
                        iconSize: 25,
                        type: BottomNavigationBarType.fixed,
                        selectedLabelStyle: TextStyle(
                            color: checkCurrentIndex(
                                    _dashboardController.currentIndex.value)
                                ? AppColorConstants.red
                                : AppColorConstants.blackColor),
                        selectedItemColor: checkCurrentIndex(
                                _dashboardController.currentIndex.value)
                            ? AppColorConstants.red
                            : AppColorConstants.blackColor,
                        items: [
                          BottomNavigationBarItem(
                            icon: Image.asset(
                              'assets/Icons/Chat.png',
                              height: 20,
                              color: checkCurrentIndex(0)
                                  ? AppColorConstants.red
                                  : Colors.black,
                            ),
                            label: 'Chat',
                          ),
                          BottomNavigationBarItem(
                            icon: Image.asset(
                              'assets/Icons/Reels.webp',
                              height: 20,
                              color: checkCurrentIndex(1)
                                  ? AppColorConstants.red
                                  : Colors.black,
                            ),
                            label: 'Reels',
                          ),
                          BottomNavigationBarItem(
                            icon: Container(
                              padding: EdgeInsets.all(12),
                              height: 45,
                              width: 45,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.white),
                              child: Image.asset(
                                "assets/Icons/add_post.png",
                                height: 20,
                                color: checkCurrentIndex(2)
                                    ? AppColorConstants.red
                                    : Colors.black,
                              ),
                            ),
                            label: '',
                          ),
                          BottomNavigationBarItem(
                            icon: Icon(Icons.home, color: checkCurrentIndex(4)
                                ? AppColorConstants.red
                                : Colors.black, size: 20,),
                            label: 'Home',
                          ),
                          BottomNavigationBarItem(
                            icon: Image.asset(
                              'assets/Icons/Profile.png',
                              height: 20,
                              color: checkCurrentIndex(4)
                                  ? AppColorConstants.red
                                  : Colors.black,
                            ),
                            label: 'Profile',
                          ),
                        ],
                        backgroundColor: AppColorConstants.whiteColor,
                        currentIndex:
                            _dashboardController.currentIndex.value > 3
                                ? 0
                                : _dashboardController.currentIndex.value,
                        onTap: (index) {
                          _dashboardController.indexChanged(index);
                        },
                      ),
                    ),
                  ));
  }

  bool checkCurrentIndex(int index) {
    if (_dashboardController.currentIndex.value == 5) {
      return false;
    } else if (_dashboardController.currentIndex.value == index) {
      return true;
    } else {
      return false;
    }
  }

  void onTabTapped(int index) async {
    // if (index == 2) {
    //   Future.delayed(
    //     Duration.zero,
    //     () => showGeneralDialog(
    //         context: context,
    //         pageBuilder: (context, animation, secondaryAnimation) =>
    //             const AddPostScreen(
    //               postType: PostType.basic,
    //             )),
    //   );
    // } else {
    Future.delayed(
        Duration.zero, () => _dashboardController.indexChanged(index));
    // }
  }
}
