import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

import '../root/root.dart';
import '../screens/activity/activity.dart';
import '../screens/activity/buyer/bank_details.dart';
import '../screens/activity/buyer/cash_on_delivery.dart';
import '../screens/activity/buyer/order_received.dart';
import '../screens/activity/buyer/payment_option.dart';
import '../screens/activity/buyer/processing_payment.dart';
import '../screens/activity/buyer/review_order.dart';
import '../screens/activity/buyer/review_submitted.dart';
import '../screens/activity/buyer/view_reviews.dart';
import '../screens/activity/order_details.dart' as activity_order_details;
import '../screens/activity/seller/order_confirmed.dart';
import '../screens/activity/seller/payment_confirmed.dart';
import '../screens/activity/seller/shipped_out.dart';
import '../screens/activity/subscriptions/subscription_payment_method.dart';
import '../screens/activity/subscriptions/subscription_plan.screen.dart';
import '../screens/activity/subscriptions/subscription_schedule_buyer.dart';
import '../screens/activity/subscriptions/subscription_schedule_create.dart';
import '../screens/activity/subscriptions/subscription_schedule_seller.dart';
import '../screens/activity/subscriptions/subscriptions.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/auth/invite_screen.dart';
import '../screens/auth/profile_registration.dart';
import '../screens/auth/register_screen.dart';
import '../screens/bottom_navigation.dart';
import '../screens/cart/cart_confirmation.dart';
import '../screens/cart/checkout.dart';
import '../screens/cart/checkout_cart.dart';
import '../screens/cart/checkout_schedule.dart';
import '../screens/cart/checkout_shop.dart';
import '../screens/chat/chat.dart';
import '../screens/chat/chat_details.dart';
import '../screens/chat/chat_profile.dart';
import '../screens/chat/shared_media.dart';
import '../screens/discover/categories_landing.dart';
import '../screens/discover/discover.dart';
import '../screens/discover/explore_categories.dart';
import '../screens/discover/product_detail.dart';
import '../screens/discover/product_reviews.dart';
import '../screens/discover/report_product.dart';
import '../screens/discover/search.dart';
import '../screens/home/draft_post.dart';
import '../screens/home/home.dart';
import '../screens/home/notifications.dart';
import '../screens/home/post_details.dart';
import '../screens/home/report_post.dart';
import '../screens/profile/add_product/add_product.dart';
import '../screens/profile/add_product/confirmation.dart';
import '../screens/profile/add_shop/add_bank.dart';
import '../screens/profile/add_shop/add_bank_details.dart';
import '../screens/profile/add_shop/add_shop.dart';
import '../screens/profile/add_shop/customize_availability.dart';
import '../screens/profile/add_shop/edit_shop.dart';
import '../screens/profile/add_shop/payment_options.dart';
import '../screens/profile/add_shop/shop_confirmation.dart';
import '../screens/profile/add_shop/shop_schedule.dart';
import '../screens/profile/edit_profile.dart';
import '../screens/profile/profile_posts.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/profile/settings/invite_a_friend/invite_a_friend.dart';
import '../screens/profile/settings/my_account/reset_password.dart';
import '../screens/profile/settings/settings.dart';
import '../screens/profile/shop/user_shop.dart';
import '../screens/profile/wishlist_screen.dart';
import '../screens/welcome_screen.dart';
import '../services/api/api.dart';
import '../services/api/client/lokal_http_client.dart';
import '../services/api_service.dart';
import '../services/application_logger.dart';
import '../services/auth_service.dart';
import '../services/database/database.dart';
import '../widgets/photo_view_gallery/gallery/gallery_asset_photo_view.dart';
import '../widgets/photo_view_gallery/gallery/gallery_network_photo_view.dart';
import '../widgets/reset_password_received.dart';
import '../widgets/verification/verify_confirmation_screen.dart';
import '../widgets/verification/verify_screen.dart';
import 'app_router.dart';

@StackedApp(
  routes: [
    AdaptiveRoute(page: Root, initial: true),
    AdaptiveRoute(page: WelcomeScreen),
    AdaptiveRoute(page: DraftPost),
    AdaptiveRoute(page: InvitePage),
    AdaptiveRoute(page: Notifications),
    AdaptiveRoute(page: ProfileRegistration),
    AdaptiveRoute(page: GalleryAssetPhotoView),
    AdaptiveRoute(page: GalleryNetworkPhotoView),
    AdaptiveRoute(page: VerifyConfirmationScreen),
    AdaptiveRoute(page: RegisterScreen),
    AdaptiveRoute(page: VerifyScreen),
    AdaptiveRoute(page: ForgotPasswordScreen),
    AdaptiveRoute(page: ResetPasswordReceived),
    // for bottom navigation
    AdaptiveRoute(page: BottomNavigation),
    AdaptiveRoute(
      page: Home,
      children: [
        AdaptiveRoute(page: Home, maintainState: true),
        AdaptiveRoute(page: PostDetails),
        AdaptiveRoute(page: Notifications),
        AdaptiveRoute(page: ReportPost),
      ],
    ),
    AdaptiveRoute(
      page: Discover,
      children: [
        AdaptiveRoute(page: Discover, maintainState: true),
        AdaptiveRoute(page: ExploreCategories),
        AdaptiveRoute(page: CategoriesLanding),
        AdaptiveRoute(page: ProductDetail),
        AdaptiveRoute(page: Search),
        AdaptiveRoute(page: CheckoutCart),
        AdaptiveRoute(page: ShopCheckout),
        AdaptiveRoute(page: Checkout),
        AdaptiveRoute(page: CheckoutSchedule),
        AdaptiveRoute(page: CartConfirmation),
        AdaptiveRoute(page: SubscriptionPaymentMethod),
        AdaptiveRoute(page: ProductReviews),
        AdaptiveRoute(page: ReportProduct),
        AdaptiveRoute(page: SubscriptionScheduleCreate),
      ],
    ),
    AdaptiveRoute(
      page: Chat,
      children: [
        AdaptiveRoute(page: Chat, maintainState: true),
        AdaptiveRoute(page: ChatDetails),
        AdaptiveRoute(page: ChatProfile),
        AdaptiveRoute(page: SharedMedia),
      ],
    ),
    AdaptiveRoute(
      page: Activity,
      children: [
        AdaptiveRoute(page: Activity, maintainState: true),
        AdaptiveRoute(page: Subscriptions),
        AdaptiveRoute(page: ProcessingPayment),
        AdaptiveRoute(page: BankDetails),
        AdaptiveRoute(page: CashOnDelivery),
        AdaptiveRoute(page: SubscriptionPlanScreen),
        AdaptiveRoute(page: OrderConfirmed),
        AdaptiveRoute(page: PaymentOptionScreen),
        AdaptiveRoute(page: PaymentConfirmed),
        AdaptiveRoute(page: ShippedOut),
        AdaptiveRoute(page: OrderReceived),
        AdaptiveRoute(page: activity_order_details.OrderDetails),
        AdaptiveRoute(page: ReviewOrder),
        AdaptiveRoute(page: ReviewSubmitted),
        AdaptiveRoute(page: ViewReviews),
        AdaptiveRoute(page: SubscriptionScheduleBuyer),
        AdaptiveRoute(page: SubscriptionScheduleSeller),
      ],
    ),
    AdaptiveRoute(
      page: ProfileScreen,
      children: [
        AdaptiveRoute(page: ProfileScreen, maintainState: true),
        AdaptiveRoute(page: EditProfile),
        AdaptiveRoute(page: Settings),
        AdaptiveRoute(page: UserShop),
        AdaptiveRoute(page: AddShop),
        AdaptiveRoute(page: ShopSchedule),
        AdaptiveRoute(page: CustomizeAvailability),
        AdaptiveRoute(page: SetUpPaymentOptions),
        AdaptiveRoute(page: AddShopConfirmation),
        AdaptiveRoute(page: AddProduct),
        AdaptiveRoute(page: WishlistScreen),
        AdaptiveRoute(page: InviteAFriend),
        AdaptiveRoute(page: EditShop),
        AdaptiveRoute(page: AddProductConfirmation),
        AdaptiveRoute(page: VerifyScreen),
        AdaptiveRoute(page: VerifyConfirmationScreen),
        AdaptiveRoute(page: AddBank),
        AdaptiveRoute(page: AddBankDetails),
        AdaptiveRoute(page: ResetPasswordReceived),
        AdaptiveRoute(page: ProfilePosts),
        AdaptiveRoute(page: ResetPasswordScreen),
      ],
    ),
  ],
  dependencies: [
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: PersistentTabController),
    LazySingleton(classType: AppRouter),
    LazySingleton(classType: APIService),
    LazySingleton<LokalHttpClient>(
      classType: LokalHttpClient,
      // dispose: lokalHttpClientDispose,
    ),
    LazySingleton(classType: AuthService),
    LazySingleton(classType: ActivityAPI),
    LazySingleton(classType: CategoryAPI),
    LazySingleton(classType: ChatAPI),
    LazySingleton(classType: CommentsAPI),
    LazySingleton(classType: CommunityAPI),
    LazySingleton(classType: ConversationAPI),
    LazySingleton(classType: InviteAPI),
    LazySingleton(classType: OrderAPI),
    LazySingleton(classType: ProductAPI),
    LazySingleton(classType: SearchAPI),
    LazySingleton(classType: ShopAPI),
    LazySingleton(classType: SubscriptionPlanAPI),
    LazySingleton(classType: UserAPI),
    LazySingleton(classType: Database),
  ],
)
class AppSetup {}

void lokalHttpClientDispose(LokalHttpClient client) {
  client.client.close();
}
