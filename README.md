# gabriel_kobipay_assessment

Setup: Ensure you have an IDE (IntelliJ, Android Studio, Visual Studi Code), then in the IDE esure you have te emulator, flutter and dart packages setup, afterwards tap on tun to install on selected device or emulator (see official sites for more information). 

Libraries/Packages: (See pub.dev, and in project see pubspec.yaml) flutter_riverpod, json_annotation, riverpod_annotation, fl_chart, http, fluttertoast, riverpod_generator, flutter_multi_formatter, build_runner, json_serializable.

State management: Riverpod

On initialization of the app, the transaction data is fetched to populate the screen, the pie chart is populated with a total addition of thhe transactions, and when each transaction card is tapped, a screen containing each that transaction detail is drawn. User is also able to toggle between 'All', 'Credit', and 'Debit', usser is also able to search based in transaction amount. In the transaction detail, user is able to tap on the refund button wich toogles the transaction status to 'Refunded'.
