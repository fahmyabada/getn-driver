import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'language_state.dart';

class LanguageCubit extends Cubit<LanguageState> {
  LanguageCubit() : super(LanguageInitial());

  bool isEn = true;

  static LanguageCubit get(context) => BlocProvider.of(context);

  Map<String, Object> textAr = {
    'successDelete': 'تم الحذف بنجاح',
    'reason': 'سبب حذف الحساب',
    'SendRequest': 'ارسل الطلب',
    'EnterReason': 'أدخل السبب أولاً من فضلك',
    'titleDeleteAccount': 'هل تريد حذف حسابك الشخصي؟',
    'contentDeleteAccount': 'إذا كنت متاكد من ذلك, قم بإدخال اسباب الحذف الخاص بك ومن ثم قم بإارسال الطلب',
    'DeleteAccount': 'حذف الحساب',
    'NotificationSetting': 'يجب تفعيل الاشعارات اولا',
    'networkFailureMessage': 'لا يوجد انترنت',
    'egp': 'ج.م',
    'optTrip': 'قم بإدخال كود التأكيد الثنائي المرسل للعميل لبدء الرحلة',
    'lang': 'اللغة',
    'Arabic': 'عربي',
    'English': 'إنجليزي',
    'brief': 'مختصر',
    'Refresh': 'تحديث',
    'Retry': 'إعادة تحميل',
    'Accept': 'قبول',
    'Reject': 'رفض',
    'Ok': 'موافق',
    'Cancel': 'إلغاء',
    'comment': 'سبب الرفض',
    'EnterComment': 'أدخل التعليق أولا من فضلك',
    'networkNotAvailable': 'لا يوجد انترنت',
    'notPaidYet': 'لم يدفع بعد..',
    'CarRegistration': 'تسجيل السيارة',
    'CarMain': 'صورة السيارة',
    'FrontCarLicenseImage': 'صورة رخصة السيارة الأمامية',
    'BackCarLicenseImage': 'صورة رخصة السيارة الخلفية',
    'Gallery': 'الصور',
    'camera': 'كاميرا',
    'Save': 'حفظ',
    'NotHaveGalleryPlace': 'لا يوجد صور للمكان',
    'NotHaveGalleryBranch': 'لا يوجد صور للفرع',
    'DriverInformation': 'معلومات السائق',
    'FrontNationalId': 'الهوية الوطنية الأمامية',
    'Update': 'تحديث',
    'BackNationalId': 'الهوية الوطنية الخلفية',
    'FrontDriverLicence': 'رخصة القيادة الأمامية',
    'BackDriverLicence': 'رخصة القيادة الخلفية',
    'Done': 'تم',
    'Enter6-digit': 'أدخل الرمز المكون من 6 أرقام المرسل إلى',
    'EnterCode': 'ادخل الكود اولا...',
    'Next': 'التالي',
    'resend': 'إعادة إرسال ',
    'codeIn': 'كود في ',
    'pleaseFillAllData': 'يرجى ملء جميع البيانات أولا...',
    'CarNumber': 'رقم السيارة',
    'EnterCarNumber': 'ادخل رقم رقم السيارة..',
    'EnterPhone': 'ادخل رقم الهاتف اولا..',
    'haveNotAccount': 'ليس لديك حساب ، ',
    'SignUpNow': 'أفتح حساب الأن',
    'CompleteRegistration': 'إتمام عملية التسجيل',
    'PersonalInformation': 'المعلومات الشخصية',
    'FullName': 'الإسم بالكامل',
    'EnterFullName': 'ادخل الاسم بالكامل اولا..',
    'Email': 'البريد الإلكتروني',
    'EnterEmail': 'ادخل البريد الإلكتروني اولا..',
    'WhatsApp': 'واتس اب',
    'EnterWhatsApp': 'ادخل واتس اب اولا..',
    'Birthday': 'تاريخ الميلاد',
    'EnterBirthday': 'ادخل تاريخ الميلاد اولا..',
    'Address': 'العنوان',
    'ErrorGetCites': 'حدث خطا عن استدعاء المدن',
    'ErrorGetCountries': 'حدث خطا عند استدعاء الدول',
    'ErrorGetArea': 'حدث خطا عند استدعاء المناطق',
    'EnterAddress': 'ادخل العنوان اولا..',
    'Availabilities': 'التوافر',
    'Role': 'وظيفة',
    'read&agree': 'أؤكد أنني قد قرأت ووافقت على',
    'Terms&Condition': 'الشروط والاحكام ',
    'AndPrivacyPolicy': 'و سياسية الخصوصية',
    'PrivacyPolicy': 'سياسية الخصوصية',
    'CheckTerms&Condition': 'اطع علي الشروط والاحكام اولا..',
    'FillAllData':
        'تأكد من اختيار الصورة وملء المعلومات الشخصية والعنوان واضافة تاريخ التواجد',
    'CountryCodeMotFound': 'رمز الدولة غير موجود حاول مره ثانية',
    'SmsVerificationInvalid': 'رمز التحقق من الرسائل القصيرة المستخدم غير صالح',
    'SmsVerificationExpired':
        'انتهت صلاحية رمز الرسائل القصيرة. يرجى إعادة إرسال رمز التحقق للمحاولة مرة أخرى',
    'emptyOTP': 'لا يسمح بالمسافات يجب ادخال رقم',
    'VerifyIdentity': 'تحقق من هويتك',
    'VerifyIdentityRegister':
        'تحقق من هويتك من خلال التقاط صورة سيلفي لصورتك للتحقق من شيء ما',
    'VerifyIdentityFrontNationalId':
        'تحقق من هويتك الوطنية الأمامية من خلال التقاط صورة لصورتك',
    'VerifyIdentityBackNationalId':
        'تحقق من هويتك الوطنية الخلفية من خلال التقاط صورة لصورتك',
    'VerifyIdentityFrontDriverLicence':
        'تحقق من رخصة قيادتك الأمامية من خلال التقاط صورة لصورتك',
    'VerifyIdentityBackDriverLicence':
        'تحقق من رخصة قيادتك الخلفية من خلال التقاط صورة لصورتك',
    'ChoosePhoto': 'اختر صورة اولا...',
    'TakeImage': 'التقط صورة',
    'CameraPermissions':
        'تم رفض أذونات الكاميرا \n يجب تمكين الوصول إلى الكاميرا لالتقاط صورة \n يمكنك اختيار الإعداد وتمكين الكاميرا ثم المحاولة مرة أخرى',
    'MyAccount': 'حسابي',
    'NoImage': 'لا يوجد صورة',
    'Name': 'الاسم',
    'EnterName': 'ادخل الاسم اولا..',
    'MyCar': 'سيارتي',
    'AddCar': 'اضف سيارة',
    'Notifications': 'الإشعارات',
    'NotFoundData': 'لا يوجد معلومات',
    'NotFoundPlace': 'لا يوجد اماكن',
    'NotFoundTrip': 'لا يوجد رحلات',
    'AboutUs': 'عن الشركة',
    'ContactUs': 'تواصل معنا',
    'FAQs': 'الاسئلة والإجابات',
    'Policies': 'السياسات',
    'RequestDetails': 'تفاصيل الطلب',
    'ClientNotHavePhone': 'هذا العميل ليس لديه هاتف...',
    'CallClient': 'الاتصال بالعميل',
    'Status': 'الحالة :',
    'PaymentStatus': 'حالة الدفع :',
    'RequestStartDate': 'تاريخ بدء الطلب',
    'RequestEndDate': 'تاريخ انهاء الطلب',
    'TripStartDate': 'تاريخ بدء الرحلة',
    'PickedLocation': 'نقطه الالتقاء',
    'PickedPoint': 'نقطه الالتقاء',
    'StartPoint': 'نقطه البدء',
    'EndPoint': 'نقطه النهاية',
    'Distance': 'المسافة',
    'Points': 'النقاط',
    '1KmPoints': 'نقاط كل كم',
    'KM': 'كم',
    'Requests': 'الطلبات',
    'refId': 'الرقم المرجعي:',
    'Days': 'الايام',
    'consumptionPoints': 'النقاط المستهلكة',
    'consumptionKM': 'كيلوات مستهلكة',
    'extraPoints': 'نقاط اضافية',
    'extraKM': 'كيلوات اضافية',
    'UsedPoints': 'النقاط/اليوم',
    'TotalDistance': 'إجمالي المسافة',
    'packagesPoints': 'النقاط الاضافية',
    'TotalPrice': 'إجمالي السعر',
    'current': 'الحالية',
    'currentDay': 'اليوم الحالي',
    'upcoming': 'القادمة',
    'past': 'الماضية',
    'pending': 'قيد الإنتظار',
    'Setting': 'الإعدادات',
    'ChoosePlace': 'اختر المكان',
    'PlaceDescription': 'لا يوجد وصف للمكان',
    'selectCategory': 'اختر الفئة',
    'AddTrip': 'أضافة رحلة',
    'Info': 'معلومات',
    'Select': 'اختيار',
    'BranchDetails': 'تفاصيل الفرع',
    'AboutPlace': 'نبذه عن المكان',
    'Place': 'المكان',
    'Details': 'تفاصيل',
    'select': 'اختر',
    'Branches': 'الفروع',
    'Branch': 'الفرع',
    'searchLocation': 'موقع البحث',
    'TripDetails': 'تفاصيل الرحلة',
    'SelectNextDestination': 'حدد الوجهة التالية',
    'SetOnMap': 'تعيين على الخريطة',
    'RecommendedPlaces': 'الأماكن الموصى بها',
    'Request': 'طلب',
    'ChooseBranch': 'اختر فرع',
    'ChooseDestinationFirst': 'يجب عليك اختيار الوجهة أولاً..',
    'TripIs': 'الرحلة الان',
    'Running': 'مستمرة',
    'DoReject': 'هل تريد الرفض؟',
    'IfRejected':
        'إذا كنت تريد أن يتم رفضك ، يجب عليك أولاً إدخال سبب الرفض والضغط على "موافق" ..',
    'Trip': 'الرحلة',
    'AreEndTrip': 'هل أنت متأكد من إنهاء الرحلة..',
    'RequestTransaction': 'طلب تحويل',
    'AccountType': 'نوع الحساب',
    'swiftCode': 'سويفت كود',
    'EnterAccountType': 'ادخل نوع الحساب اولا..',
    'AccountName': 'اسم الحساب',
    'EnterAccountName': 'ادخل اسم الحساب اولا..',
    'BankName': 'اسم البنك',
    'EnterBankName': 'ادخل اسم البنك اولا..',
    'AccountNumber': 'رقم الحساب',
    'EnterAccountNumber': 'ادخل رقم الحساب اولا..',
    'iban': 'الايبان',
    'EnterIban': 'ادخل الايبان اولا..',
    'amount': 'المبلغ',
    'EnterAmount': 'ادخل المبلغ اولا..',
    'Phone': 'الرقم',
    'Visa': 'حساب بنكي',
    'MyWallet': 'محفظتي',
    'Balance': 'الرصيد',
    'Wallet': 'المحفظة',
    'Hold': 'قيد الانتظار',
    'LastTransactions': 'اخر التحويلات',
    'SuccessTransaction': 'صفقة ناجحة',
    'HaveNotMaps': 'ليس لديك خرائط ..',
    'WhatsappNoInstalled': 'whatsapp غير مثبت ، يرجى التثبيت..',
    'LoginSuccessfully': 'تم تسجيل الدخول بنجاح',
    'UncorrectCode': 'كود خطا',
    'RegisterFirstPlease': 'ليس لديك حساب سجل أولا من فضلك',
    'SignInPlease': 'لديك حساب بالفعل قم بتسجيل الدخول من فضلك',
    'SuccessfullyUpdate': 'تحديث بنجاح',
    'journeyStartedYet': 'الرحلة لم تبدأ بعد',
    'CreateSuccessfully': 'أنشئ بنجاح',
    'Location': 'الموقع',
    'LocationPermissions': 'تم رفض أذونات الموقع',
    'LocationPermissionsPermanently':
        'تم رفض أذونات الموقع بشكل دائم \n يجب تمكين موقع الوصول حتى نتمكن من تحديد موقعك \n اختر الإعداد وتمكين الموقع ثم حاول مرة أخرى',
    'EndRequest': 'هل أنت متأكد من إنهاء الطلب..',
    'Warning': 'تحذير',
    'needPoints1': 'هذ الرحلة تحتاج الي ',
    'needPoints2':
        ' نقطة وانت لا تملك نقاط كافية لتنفيذ الرحلة من فضلك اشتري نقاط اضافية وعاود المحاولة مره اخري',
    'lastTripDescription': 'لديك الآن رحلة نشطة هل تريد إلغاء الرحلة النشطة',
    'haveActivatedTrips': 'لديك الان رحلة نشطة يجب انهاء الرحلة اولا',
    'CancelationFee': 'ستفرض عليك رسوم إلغاء..',
    'Home': 'الصفحة الرئيسية',
    'SignOut': 'تسجيل الخروج',
    'MobileNumber10Digits': 'رقم الهاتف لا يقل عن 10 أرقام',
    'MobileNumber11Digits': 'رقم الهاتف لا يقل عن 11 أرقام',
    'signUpWithMobileNumber': 'قم بالتسجيل باستخدام رقم الهاتف المحمول',
    'signIn': 'تسجيل الدخول باستخدام رقم الهاتف',
    'clientNotPaidYet': 'العميل لم يقم بالدفع حتي الان',
    'title1': 'القيادة مع جيتن',
    'subTitle1':
        'اعمل بمرونة واكسب المال. قم بالتسجيل والانضمام إلى مجموعتنا الواسعة من السائقين المهرة ومتعددي اللغات.',
    'title2': 'سلامتك اولوية',
    'subTitle2':
        'نحن ملتزمون بدورنا وسلامتك هي مسؤوليتنا. نستخدم التكنولوجيا لتحقيق مستويات عالية من الامان. اصبح من السهل علي جميع التنقل.',
    'title3': 'كن شريكاً',
    'subTitle3': 'أنتم شركاؤنا في النجاح. خدمتك والشعور بالرضا هو هدف لنا.',
    'title4': 'استمتع بالرحلة',
    'subTitle4': 'أفضل تطبيق لحجز السيارات لرحلتك البحرية والمريحة',
    'title5': 'اختر اللغة',
    'ChooseLangFirst': 'اختر اللغة اولا',
    'getStarted': 'ابدء',
  };

  Map<String, Object> textEn = {
    'successDelete': 'Deleted successfully',
    'reason': 'The reason for deleting the account',
    'SendRequest': 'Send a request',
    'EnterReason': 'Enter Reason First Please..',
    'titleDeleteAccount': 'Do you want to delete your account?',
    'contentDeleteAccount': 'if yes, enter your reasons and send a request to our support team.',
    'DeleteAccount': 'Delete Account',
    'NotificationSetting': 'Notifications must be activated first',
    'networkFailureMessage': 'network not available',
    'egp': 'EGP',
    'optTrip':
        'Enter two-step verification code has been sent to the client to start the trip',
    'lang': 'Language',
    'Arabic': 'Arabic',
    'English': 'English',
    'brief': 'Brief',
    'Refresh': 'Refresh',
    'Retry': 'Retry',
    'Accept': 'Accept',
    'Reject': 'Reject',
    'Ok': 'Ok',
    'Cancel': 'Cancel',
    'comment': 'comment',
    'EnterComment': 'Enter Comment First Please..',
    'networkNotAvailable': 'network not available',
    'notPaidYet': 'not paid yet..',
    'CarRegistration': 'Car Registration',
    'CarMain': 'Car Main',
    'FrontCarLicenseImage': 'Front Car License Image',
    'BackCarLicenseImage': 'Back Car License Image',
    'Gallery': 'Gallery',
    'camera': 'Camera',
    'Save': 'Save',
    'NotHaveGalleryPlace': 'Not Have Gallery Place',
    'NotHaveGalleryBranch': 'Not Have Gallery Branch',
    'DriverInformation': 'Driver Information',
    'FrontNationalId': 'Front National Id',
    'Update': 'Update',
    'BackNationalId': 'Back National Id',
    'FrontDriverLicence': 'Front Driver Licence',
    'BackDriverLicence': 'Back Driver Licence',
    'Done': 'Done',
    'Enter6-digit': 'Enter the 6- digit code sent to',
    'EnterCode': 'Enter Code Please...',
    'Next': 'Next',
    'resend': 'resend ',
    'codeIn': 'code in ',
    'pleaseFillAllData': 'please fill all data first...',
    'CarNumber': 'Car Number',
    'EnterCarNumber': 'Enter Car Number Please..',
    'EnterPhone': 'Enter Phone Please..',
    'haveNotAccount': 'You Don\'t have an account, ',
    'SignUpNow': 'Sign Up Now',
    'CompleteRegistration': 'Complete your Registration',
    'PersonalInformation': 'Personal Information',
    'FullName': 'Full Name',
    'EnterFullName': 'Enter Full Name Please..',
    'Email': 'Email',
    'WhatsApp': 'WhatsApp',
    'EnterWhatsApp': 'Enter WhatsApp Please..',
    'Birthday': 'Birthday',
    'EnterBirthday': 'Enter Birthday Please..',
    'Address': 'Address',
    'ErrorGetCites': 'error occurred when get Cites',
    'ErrorGetCountries': 'error occurred when get Countries',
    'ErrorGetArea': 'error occurred when get Area',
    'EnterAddress': 'Enter Address Please..',
    'Availabilities': 'Availabilities',
    'Role': 'Role',
    'read&agree': 'i confirm that i have read & agree to the',
    'Terms&Condition': 'Terms & Condition ',
    'AndPrivacyPolicy': 'and Privacy Policy',
    'PrivacyPolicy': 'Privacy Policy',
    'CheckTerms&Condition': 'check in Terms & condition first..',
    'FillAllData':
        'Be sure to choose image and fill personal information ,address and availability',
    'CountryCodeMotFound': 'country code not found, try again',
    'SmsVerificationInvalid': 'The sms verification code used is invalid',
    'SmsVerificationExpired':
        'The sms code has expired. Please re-send the verification code to try again',
    'emptyOTP': 'Spaces are not allowed. You must enter a number',
    'VerifyIdentity': 'Verify your identity',
    'VerifyIdentityRegister':
        'Verify your identity by taking a selfie shot of your photo For the verification of something',
    'VerifyIdentityFrontNationalId':
        'Verify your front National Id by taking shot of your photo',
    'VerifyIdentityBackNationalId':
        'Verify your back National Id by taking shot of your photo',
    'VerifyIdentityFrontDriverLicence':
        'Verify your front driver licence by taking shot of your photo',
    'VerifyIdentityBackDriverLicence':
        'Verify your back driver licence by taking shot of your photo',
    'ChoosePhoto': 'choose photo first please...',
    'TakeImage': 'Take Image',
    'CameraPermissions':
        'Camera permissions denied\n You must enable the access camera to take photo \n you can choose setting and enable camera then try back',
    'MyAccount': 'My Account',
    'NoImage': 'No image',
    'Name': 'Name',
    'EnterName': 'Enter Name Please..',
    'MyCar': 'My Car',
    'AddCar': 'Add Car',
    'Notifications': 'Notifications',
    'NotFoundData': 'Not Found Data',
    'NotFoundPlace': 'Not Found Place',
    'NotFoundTrip': 'Not Found Trip',
    'AboutUs': 'About Us',
    'ContactUs': 'Contact Us',
    'FAQs': 'FAQs',
    'Policies': 'Policies',
    'RequestDetails': 'Request Details',
    'ClientNotHavePhone': 'this client not have phone...',
    'CallClient': 'Call Client',
    'Status': 'Status :',
    'PaymentStatus': 'Payment Status :',
    'RequestStartDate': 'Request Start Date',
    'RequestEndDate': 'Request End Date',
    'TripStartDate': 'Trip Start Date',
    'PickedLocation': 'Picked Location',
    'PickedPoint': 'Picked Point',
    'StartPoint': 'Start Point',
    'EndPoint': 'End Point',
    'Distance': 'Distance',
    'Points': 'Points',
    '1KmPoints': '1 Km Points',
    'Requests': 'Requests',
    'refId': 'refId:',
    'Days': 'Days',
    'consumptionPoints': 'Consumption Points',
    'consumptionKM': 'Consumption KM',
    'extraPoints': 'Extra Points',
    'extraKM': 'Extra KM',
    'UsedPoints': 'Points/Day',
    'TotalDistance': 'Total Km/D',
    'packagesPoints': 'Additional Points',
    'KM': 'KM',
    'TotalPrice': 'Total Price',
    'current': 'current',
    'currentDay': 'Current Day',
    'upcoming': 'upcoming',
    'past': 'past',
    'pending': 'pending',
    'Setting': 'Setting',
    'ChoosePlace': 'Choose Place',
    'PlaceDescription': 'Place don\'t have description',
    'selectCategory': 'Choose Category',
    'AddTrip': 'Add Trip',
    'Info': 'Info',
    'Select': 'Select',
    'BranchDetails': 'Details Branch',
    'AboutPlace': 'About Place',
    'Place': 'Place',
    'Details': 'Details',
    'select': 'Select',
    'Branches': 'Branches',
    'Branch': 'Branch',
    'searchLocation': 'search location',
    'TripDetails': 'Trip Details',
    'SelectNextDestination': 'Select Next Destination',
    'SetOnMap': 'Set on map',
    'RecommendedPlaces': 'Recommended Places',
    'Request': 'Request',
    'ChooseBranch': 'Choose Branch',
    'ChooseDestinationFirst': 'you should choose destination first..',
    'TripIs': 'Trip is',
    'Running': 'Running',
    'DoReject': 'Do you want to reject?',
    'IfRejected':
        'If you want to be rejected, you must first enter the reason for rejection and press OK..',
    'Trip': 'Trip',
    'AreEndTrip': 'are you sure to end trip..',
    'RequestTransaction': 'Request Transaction',
    'AccountType': 'Account Type',
    'EnterAccountType': 'Enter Account Type Please..',
    'AccountName': 'Account Name',
    'EnterAccountName': 'Enter Account Name Please..',
    'swiftCode': 'Swift Code',
    'BankName': 'Bank Name',
    'EnterBankName': 'Enter Bank Name Please..',
    'AccountNumber': 'Account Number',
    'EnterAccountNumber': 'Enter Account Number Please..',
    'iban': 'iban',
    'EnterIban': 'Enter iban Please..',
    'amount': 'amount',
    'EnterAmount': 'Enter amount Please..',
    'Phone': 'Phone',
    'Visa': 'Visa',
    'MyWallet': 'My Wallet',
    'Balance': 'Balance',
    'Wallet': 'Wallet',
    'Hold': 'Hold',
    'LastTransactions': 'Last Transactions',
    'SuccessTransaction': 'Success Transaction',
    'HaveNotMaps': 'you have not maps..',
    'WhatsappNoInstalled': 'whatsapp no installed, please installed..',
    'LoginSuccessfully': 'Login Successfully',
    'UncorrectCode': 'incorrect code',
    'RegisterFirstPlease':
        'You Don\'t have an account\nRegister first please...',
    'SignInPlease': 'Already you have account \n SignIn please..',
    'SuccessfullyUpdate': 'Successfully Update',
    'journeyStartedYet': 'The journey hasn\'t started yet',
    'CreateSuccessfully': 'Create Successfully',
    'Location': 'Location',
    'LocationPermissions': 'Location permissions are denied',
    'LocationPermissionsPermanently':
        'Location permissions are permanently denied\n You must enable the access location so that we can determine your location and save the visit\n choose setting and enable location then try back',
    'EndRequest': 'are you sure to end Request..',
    'Warning': 'Warning',
    'needPoints1': 'this trip need ',
    'needPoints2':
        ' points and you do not have enough points to carry out the trip.\n Please buy additional points and try again',
    'lastTripDescription':
        'you have now active trip do you want to cancel active trip',
    'haveActivatedTrips': 'you have now active trip you should end trip first',
    'CancelationFee': 'you will charged a cancelation fee..',
    'Home': 'Home',
    'SignOut': 'SignOut',
    'MobileNumber10Digits': 'The mobile number is not less than 10 digits',
    'MobileNumber11Digits': 'The mobile number is not less than 11 digits',
    'signUpWithMobileNumber': 'Sign Up With Mobile Number',
    'signIn': 'Sign In with mobile number',
    'title1': 'Drive with GetN',
    'subTitle1':
        'Work with flexibility and earn money. Sign up and join our wide range of skilled and multilingual drivers.',
    'title2': 'Your safety is a priority',
    'subTitle2':
        'We are committed to our and safety is a main concern. We use technology to achieve high levels of safety. it became easier for everyone to get around.',
    'title3': 'Be our partner',
    'subTitle3':
        'You are our success partners. Serving you and feeling with your satisfaction is a goal for us.',
    'title4': 'Enjoy Trip',
    'subTitle4':
        'The Best car booking app for your seafty and comfortable trip',
    'title5': 'Choose Language',
    'getStarted': 'Get Started',
    'clientNotPaidYet': 'client don\'t paid yet',
    'ChooseLangFirst': 'Choose Language First..',
  };

  changeLan(bool lan) {
    isEn = lan;
    getIt<SharedPreferences>().setBool("isEn", isEn);
    emit(LanguageEnState(isEn));
  }

  Object? getTexts(String txt) {
    if (isEn == true) return textEn[txt];
    return textAr[txt];
  }
}
