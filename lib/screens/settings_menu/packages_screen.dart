import 'package:foap/helper/imports/common_import.dart';
import 'package:foap/helper/imports/setting_imports.dart';
import 'package:foap/screens/dashboard/dashboard_screen.dart';
import '../../controllers/misc/subscription_packages_controller.dart';

class PackagesScreen extends StatefulWidget {
  bool isComingFromDashboard;
  PackagesScreen({this.isComingFromDashboard = false, super.key});

  @override
  PackagesScreenState createState() => PackagesScreenState();
}

class PackagesScreenState extends State<PackagesScreen> {
  final SubscriptionPackageController packageController = Get.find();
  final SettingsController settingsController = Get.find();
  final DashboardController _dashboardController = Get.find();

  @override
  void initState() {
    super.initState();

    settingsController.getSettings();
    packageController.initiate();
  }

  @override
  void dispose() {
    packageController.subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: AppColorConstants.whiteColor,
      appBar: widget.isComingFromDashboard
          ? AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.pop(context);
                  // _dashboardController.currentIndex.value = 5;
                },
              ),
              centerTitle: true,
              backgroundColor: AppColorConstants.whiteColor,
              title: Text(packagesString.tr),
            )
          : null,
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (!widget.isComingFromDashboard)
          backNavigationBar(title: packagesString.tr),
        const Expanded(child: CoinPackagesWidget()),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            BodyLargeText(watchAdsString.tr,
                weight: TextWeight.bold, color: AppColorConstants.themeColor),
            const SizedBox(height: 10),
            Obx(() => BodyMediumText(
                  settingsController.setting.value == null
                      ? watchAdsRewardString.tr
                          .replaceAll('coins_value', loadingString.tr)
                      : watchAdsRewardString.tr.replaceAll(
                          'coins_value',
                          settingsController
                              .setting.value!.watchVideoRewardCoins
                              .toString()),
                )),
            const SizedBox(height: 20),
            Center(
              child: SizedBox(
                height: 45,
                child: AppThemeButton(
                    text: watchAdsString.tr,
                    onPress: () {
                      packageController.showRewardedAds();
                    }),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ).hp(DesignConstants.horizontalPadding)
      ]),
    );
  }
}
