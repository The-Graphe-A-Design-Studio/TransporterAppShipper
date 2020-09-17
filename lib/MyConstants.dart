//API Key
const GoogleApiKey = "AIzaSyCSdJNFravZ9yjzisUAhLgohy_MWbS41XI";
const GoogleMapsKey = "AIzaSyDH8iEIWiHLIRcSsJWm8Fh1qbgwt0JRAc0";
const autoCompleteLink =
    "https://maps.googleapis.com/maps/api/place/autocomplete/json?key=$GoogleApiKey&components=country:in&types=(cities)&input=";
const autoCompleteLinkFullAdd =
    "https://maps.googleapis.com/maps/api/place/autocomplete/json?key=$GoogleApiKey&components=country:in&types=address&input=";

const RAZORPAY_ID = "rzp_test_Ox9H2BWMViEG65";
const RAZORPAY_SECRET = "2rOaeIWZt4iOJUjMJGXRk5dw";

//Basic Pages
const String splashPage = "/";

//Login or SignUp Pages
const String introLoginOptionPage = "/introLoginPage";
const String transporterOptionPage = "/transporterOptionPage";

//Pages which don't need LoggedIn User
const String emiCalculatorPage = "/emiCalculatorPage";
const String freightCalculatorPage = "/freightCalculatorPage";
const String tollCalculatorPage = "/tollCalculatorPage";
const String tripPlannerPage = "/tripPlannerPage";

//Pages once the user is LoggedIn - Transporter
const String homePageTransporter = "/homePageTransporter";
const String homePageTransporterNotVerified = "/homePageTransporterNotVerified";
const String uploadDocsTransporter = "/uploadDocsTransporter";
const String orderSummaryPage = "/orderSummaryPage";
const String requestTransportPage = "/requestTransportPage";
const String postLoad = "/postLoad";
const String subscription = "/subscription";
