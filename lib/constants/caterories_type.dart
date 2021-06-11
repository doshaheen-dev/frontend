import 'package:portfolio_management/models/categories_model.dart';

class CateroriesType {
  static List<CategoriesModel> raiseCapital = [
    CategoriesModel(
        name: "Private Equity",
        image: "assets/images/raise_capital/private_equity.png",
        detail: ""),
    CategoriesModel(
        name: "Venture Capital",
        image: "assets/images/raise_capital/venture_capital.png",
        detail: ""),
    CategoriesModel(
        name: "Real Estate Investments",
        image: "assets/images/raise_capital/real_estate.png",
        detail: ""),
    CategoriesModel(
        name: "Listed Equity",
        image: "assets/images/raise_capital/equity_financing.png",
        detail: ""),
    CategoriesModel(
        name: "Bonds/Fixed income portfolio",
        image: "assets/images/raise_capital/bond_fixed_income.png",
        detail: ""),
    CategoriesModel(
        name: "Others",
        image: "assets/images/raise_capital/debt.png",
        detail: "")
  ];

  static List<CategoriesModel> invenstmentManager = [
    CategoriesModel(
        name: "Fund Manager",
        image: "assets/images/investment_solutions/fund_manager.png",
        detail: "",
        onTap: () async {}),
    CategoriesModel(
        name: "Portfolio Manager",
        image: "assets/images/investment_solutions/portfolio_manager.png",
        detail: ""),
    CategoriesModel(
        name: "Wealth Manager",
        image: "assets/images/investment_solutions/wealth_manager.png",
        detail: "")
  ];
}
