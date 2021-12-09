# LOKAL APP:

## Folder Structure

```
├──assets/
│  ├──animations/
│  ├──bottomNavIcons/
│  ├──fonts/
│  ├──payment/
│  └──sso/
│
├──functions/
│
├──lib/
│  ├──models/
│  ├──providers/
│  ├──root/
│  ├──screens/
│  ├──services/
│  ├──utils/
│  ├──view_models/
│  ├──widgets/
│  └──main.dart
│
├──library/
│  ├──bottom_navigation_bar/
```

1. ASSETS - LOGOS, IMAGES, ICONS, FONTS...
2. FUNCTIONS - CLOUD FUNCTIONS FOR FIREBASE (_currently unused_)
3. MODELS - COLLECTION OF DATA
4. PROVIDERS - VIEW_MODELS/CLASSES USED ACROSS DIFFERENT SCREENS
5. ROOT - ENTRY POINT OF MATERIALAPP
6. SCREENS - SCREENS OF THE APP.
7. SERVICES - INTERACTS WITH FIREBASE THAT OTHER CLASS CAN CALL. API.
8. UTILS - THEME, VALIDATION.. - FUNCTIONS USED THROUGHOUT THE APP. LOCALSTORAGE/SHAREPREFERENCES. NATIVE PLATFORM CALLS.
9. VIEW_MODELS - MIRROR SCREENS FOLDER, VIEWMODELS FOR EACH SCREEN/COMPONENT
10. WIDGETS - REUSABLE UI WIDGETS
11. LIBRARY - LIBRARIES/PACKAGES THAT WE WANT TO MAINTAIN OURSELVES

# Current Build Features

- [x] User Login
- [x] User Registration
- [x] Verification
- [x] Firebase/Firestore Timeline?
- [x] Add Shop
- [x] Edit shop
- [x] Add Product
- [x] Edit Product
- [x] Chat
- [x] Discovery
- [ ] Search
- [x] Purchasing/Ordering
- [x] Product Details
- [x] Cart
- [x] Checkout
- [x] Community Feed

# Requirements

Environment SDK for build: `>=2.7.0 <3.0.0` <br>
Flutter SDK for build: `2.0.5` <br>
Android SDK for build: `>=16.0 <=30.0`
