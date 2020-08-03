class Converter {
  static String convertPriceUsToBr(String value) {
    if (value.contains(".")) {
      String unit = value.split(".")[0];
      String decimal = value.split(".")[1];
      if (decimal.length == 1) {
        value = unit + "," + decimal + "0";
      } else {
        value = unit + "," + decimal;
      }
    } else if (value.length == 0){
      value = value + "0,00";
    } else {
      value = value + ",00";
    }
    return value;
  }
}