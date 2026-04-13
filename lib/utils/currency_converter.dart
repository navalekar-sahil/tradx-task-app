String formatPrice({required double price, required String currencyType}) {
  double convertedPrice;
  String symbol;

  switch (currencyType.toLowerCase()) {
    case "usd":
      convertedPrice = price * 0.012;
      symbol = "\$";
      break;

    case "eur":
      convertedPrice = price * 0.011;
      symbol = "€";
      break;

    case "inr":
    default:
      convertedPrice = price;
      symbol = "₹";
  }

  return "$symbol${convertedPrice.toStringAsFixed(2)}";
}