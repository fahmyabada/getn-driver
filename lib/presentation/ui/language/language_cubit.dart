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
    "Arabic": "عربي",
    "English": "إنجليزي",
  };

  Map<String, Object> textEn = {
    'Arabic': 'Arabic',
    'English': 'English',
    'CarRegistration': 'Car Registration',
    'FrontCarLicenseImage': 'Front Car License Image',
    'BackCarLicenseImage': 'Back Car License Image',
    'Gallery': 'Gallery',
    'Save': 'Save',
    'DriverInformation': 'Driver Information',
    'FrontNationalId': 'Front NationalId',
    'Update': 'Update',
    'BackNationalId': 'Back NationalId',
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
    'haveNotAccount': 'You Don\'t have an account,',
    'SignUpNow': 'Sign Up Now',
    'CompleteRegistration': 'Complete your Registration',
    'PersonalInformation': 'Personal Information',
    'FullName': 'Full Name',
    'EnterFullName': 'Enter Full Name Please..',
    'EnterEmail': 'Enter Email Please..',
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
    'CountryCodeMotFound': 'country code not found',
    'VerifyIdentity': 'Verify your identity',
    'VerifyIdentityRegister':
        'Verify your identity by taking a selfie shot of your photo For the verification of something',
    'VerifyIdentityFrontNationalId':
        'Verify your front NationalId by taking shot of your photo',
    'VerifyIdentityBackNationalId':
        'Verify your back NationalId by taking shot of your photo',
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
    'AboutUs': 'About Us',
    'ContactUs': 'Contact Us',
    'FAQs': 'FAQs',
    'Policies': 'Policies',
    'RequestDetails': 'Request Details',
    'ClientNotHavePhone': 'this client not have phone...',
    'CallClient': 'Call Client',
    'Status': 'Status :',
    'PaymentStatus': 'Payment Status :',
    'TripStartDate': 'Trip Start Date',
    'PickedLocation': 'Picked Location',
    'PickedPoint': 'Picked Point',
    'Distance': 'Distance',
    'Points': 'Points',
    '1KmPoints': '1 Km Points',
    'Requests': 'Requests',
    'refId': 'refId:',
    'Days': 'Days',
    'UsedPoints': 'Used Points',
    'TotalDistance': 'Total Distance',
    'TotalPrice': 'Total Price',
    'current': 'current',
    'upcoming': 'upcoming',
    'past': 'past',
    'pending': 'pending',
    'Setting': 'Setting',
    'ChooseDestination': 'choose your destination',
    'Info': 'Info',
    'Select': 'Select',
    'BranchDetails': 'Branch Details',
    'AboutPlace': 'About Place',
    'Details': 'Details',
    'selectThis': 'select this',
    'Branches': 'Branches',
    'searchLocation': 'search location',
    'TripDetails': 'Trip Details',
    'SelectNextDestination': 'Select Next Destination',
    'SetOnMap': 'Set on map',
    'RecommendedPlaces': 'Recommended Places',
    'Request': 'Request',
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
    'BankName': 'Bank Name',
    'EnterBankName': 'Enter Bank Name Please..',
    'Account Number': 'Account Number',
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
    'UncorrectCode': 'uncorrect code',
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
    'CancelationFee': 'you will charged a cancelation fee..',
    'Done': 'Done',
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
