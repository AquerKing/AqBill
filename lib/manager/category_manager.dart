import 'package:bill/data/category_model.dart';
import 'package:bill/extension/result.dart';
import 'package:bill/resources/svg_icon.dart';

class CategoryManager {
  static final CategoryManager _instance = CategoryManager._internal();
  factory CategoryManager() => _instance;
  CategoryManager._internal();

  // 直接使用字面值ID和图标，完全移除对照表引用
  final Map<String, Map<int, CategoryModel>> _registeredCategory = {
    'Expense': {
      10001: ExpenseCategory.fullyConstruct(
        id: 10001,
        icon: SvgIcons.food,
        name: 'Daily Food',
        description: 'Meals, snacks, and grocery purchases',
      ),
      10002: ExpenseCategory.fullyConstruct(
        id: 10002,
        icon: SvgIcons.house,
        name: 'Housing',
        description: 'Rent, mortgage, utilities, and home supplies',
      ),
      10003: ExpenseCategory.fullyConstruct(
        id: 10003,
        icon: SvgIcons.transportation,
        name: 'Transportation',
        description: 'Public transit, fuel, and vehicle maintenance',
      ),
      10004: ExpenseCategory.fullyConstruct(
        id: 10004,
        icon: SvgIcons.clothes,
        name: 'Clothing & Beauty',
        description: 'Apparel, cosmetics, and personal grooming',
      ),
      10005: ExpenseCategory.fullyConstruct(
        id: 10005,
        icon: SvgIcons.healthcare,
        name: 'Healthcare',
        description: 'Medications, doctor visits, and health products',
      ),
      10006: ExpenseCategory.fullyConstruct(
        id: 10006,
        icon: SvgIcons.entertainment,
        name: 'Entertainment',
        description: 'Movies, games, hobbies, and leisure activities',
      ),
      10007: ExpenseCategory.fullyConstruct(
        id: 10007,
        icon: SvgIcons.education,
        name: 'Education',
        description: 'Courses, books, and learning materials',
      ),
      10008: ExpenseCategory.fullyConstruct(
        id: 10008,
        icon: SvgIcons.social,
        name: 'Social & Gifts',
        description: 'Dining out, presents, and social events',
      ),
      10009: ExpenseCategory.fullyConstruct(
        id: 10009,
        icon: SvgIcons.family,
        name: 'Family & Parenting',
        description: 'Childcare, family supplies, and related expenses',
      ),
      10010: ExpenseCategory.fullyConstruct(
        id: 10010,
        icon: SvgIcons.misc,
        name: 'Miscellaneous',
        description: 'Other unclassified daily expenses',
      ),
      10000: ExpenseCategory.fullyConstruct(
        id: 10000,
        icon: SvgIcons.error,
        name: 'Unknown',
        description: 'Uncategorized or unrecognized expenses',
      ),
    },
    'Income': {
      20001: IncomeCategory.fullyConstruct(
        id: 20001,
        icon: SvgIcons.salary,
        name: 'Salary',
        description: 'Regular employment income',
      ),
      20002: IncomeCategory.fullyConstruct(
        id: 20002,
        icon: SvgIcons.investment,
        name: 'Investment',
        description: 'Returns from stocks, funds, or property',
      ),
      20003: IncomeCategory.fullyConstruct(
        id: 20003,
        icon: SvgIcons.scholarship,
        name: 'Scholarship',
        description: 'Educational grants or financial aid',
      ),
      20004: IncomeCategory.fullyConstruct(
        id: 20004,
        icon: SvgIcons.pocketMoney,
        name: 'Pocket Money',
        description: 'Allowances or casual financial support',
      ),
      20005: IncomeCategory.fullyConstruct(
        id: 20005,
        icon: SvgIcons.refund,
        name: 'Refund',
        description: 'Reimbursements for returned items or overpayments',
      ),
      20006: IncomeCategory.fullyConstruct(
        id: 20006,
        icon: SvgIcons.misc,
        name: 'Miscellaneous',
        description: 'Other unclassified sources of income',
      ),
      20000: IncomeCategory.fullyConstruct(
        id: 20000,
        icon: SvgIcons.error,
        name: 'Unknown',
        description: 'Uncategorized or unrecognized income',
      ),
    },
  };

  Iterable get categories {
    return _registeredCategory.values;
  }

  List<CategoryModel> getCategories(bool isExpense) {
    if (isExpense) {
      List<CategoryModel> categories =
          _registeredCategory['Expense']!.values.toList();
      categories.removeWhere((item) => item.id == 10000);
      return categories;
    } else {
      List<CategoryModel> categories =
          _registeredCategory['Income']!.values.toList();
      categories.removeWhere((item) => item.id == 20000);
      return categories;
    }
  }

  /// 通过ID删除Category
  Result<String> delete(int categoryId) {
    bool exists = false;
    String? type;

    for (var entry in _registeredCategory.entries) {
      if (entry.value.containsKey(categoryId)) {
        exists = true;
        type = entry.key;
        break;
      }
    }

    if (!exists) {
      return Result.failure(
        'CategoryManager: Cannot delete inexistent category with id \'$categoryId\'',
      );
    }

    if (categoryId == 10000 || categoryId == 20000) {
      return Result.failure(
        'CategoryManager: Cannot delete default unknown category.',
      );
    }

    _registeredCategory[type]!.remove(categoryId);
    return Result.success();
  }

  /// 注册Category（使用类别ID作为键）
  Result<String> register(CategoryModel model) {
    String type = model is ExpenseCategory ? 'Expense' : 'Income';

    if (_registeredCategory[type]!.containsKey(model.id)) {
      return Result.failure(
        'CategoryManager: Failed to register category, id ${model.id} already exists.',
      );
    }

    _registeredCategory[type]!.putIfAbsent(model.id, () => model);
    return Result.success();
  }

  /// 通过类型和ID获取Category
  CategoryModel get(int categoryId) {
    if (categoryId >= 10000 && categoryId < 20000) {
      return _registeredCategory['Expense']![categoryId]!;
    } else {
      return _registeredCategory['Income']![categoryId]!;
    }
  }
}
