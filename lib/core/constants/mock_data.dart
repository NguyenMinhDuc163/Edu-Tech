

import 'package:ed_tech/init.dart';
import 'package:ed_tech/modules/payment/model/credit_card_model.dart';
import 'package:ed_tech/modules/reviews/model/review_model.dart';

class MockData {


  static List<CreditCardModel> cards = [
    CreditCardModel(
      cardHolderFullName: 'Hemendra Mali',
      cardNumber: '5254123412347690',
      validThru: '10/24',
      cardType: 'Visa Classic',
      balance: 3763.87,
      backgroundColor: Colors.orange,
    ),
    CreditCardModel(
      cardHolderFullName: 'Nguyen Van A',
      cardNumber: '4111111111111111',
      validThru: '11/25',
      cardType: 'Visa Gold',
      balance: 1200.50,
      backgroundColor: Colors.blue,
    ),
    CreditCardModel(
      cardHolderFullName: 'Tran Thi B',
      cardNumber: '4000123412345678',
      validThru: '09/26',
      cardType: 'Visa Platinum',
      balance: 980.00,
      backgroundColor: Colors.black,
    ),
  ];
  static List<ReviewModel> reviews = [
    ReviewModel(
      name: "Jenny Wilson",
      avatarUrl: "",
      rating: 4.8,
      date: "13 Sep, 2020",
      content:
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque malesuada eget vitae amet Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque malesuada eget vitae amet Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque malesuada eget vitae amet...",
    ),
    ReviewModel(
      name: "Jenny Wilson",
      avatarUrl: "",
      rating: 4.8,
      date: "13 Sep, 2020",
      content:
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque malesuada eget vitae amet...",
    ),
    ReviewModel(
      name: "Jenny Wilson",
      avatarUrl: "",
      rating: 4.8,
      date: "13 Sep, 2020",
      content:
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque malesuada eget vitae amet...",
    ),
    ReviewModel(
      name: "Jenny Wilson",
      avatarUrl: "",
      rating: 4.8,
      date: "13 Sep, 2020",
      content:
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque malesuada eget vitae amet...",
    ),
  ];

}
