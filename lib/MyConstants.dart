//API Key
const GoogleApiKey = "AIzaSyCSdJNFravZ9yjzisUAhLgohy_MWbS41XI";
const autoCompleteLink =
    "https://maps.googleapis.com/maps/api/place/autocomplete/json?key=$GoogleApiKey&components=country:in&types=(cities)&input=";

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
const String uploadDocsTransporter = "/uploadDocsTransporter";
const String newTransportingOrderPage = "/newTransportingOrderPage";
const String orderSummaryPage = "/orderSummaryPage";
const String requestTransportPage = "/requestTransportPage";
