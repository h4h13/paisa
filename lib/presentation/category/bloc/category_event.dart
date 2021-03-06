part of 'category_bloc.dart';

@immutable
abstract class CategoryEvent {}

class FetchCategoriesEvent extends CategoryEvent {}

class CategoryRefreshEvent extends CategoryEvent {}

class EditCategoryEvent extends CategoryEvent {
  final String title;
  final String description;
  final int icon;
  final double? budget;

  EditCategoryEvent({
    required this.title,
    required this.description,
    required this.icon,
    this.budget,
  });
}

class CategoryUpdateEvent extends CategoryEvent {
  final Category category;

  CategoryUpdateEvent(this.category);
}

class CategoryDeleteEvent extends CategoryEvent {
  final Category category;

  CategoryDeleteEvent(this.category);
}
