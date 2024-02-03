import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class CategoriesSection extends StatefulWidget {
  final Set<String> accionesFavoritas;
  final Function(String) toggleFavorite;

  CategoriesSection({
    required this.accionesFavoritas,
    required this.toggleFavorite,
  });

  @override
  _CategoriesSectionState createState() => _CategoriesSectionState();
}

class _CategoriesSectionState extends State<CategoriesSection> {
  int selectedCategoryIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CategoryButton(
          texto: 'Favoritos',
          icono: Icon(Icons.star),
          isSelected: selectedCategoryIndex == 0,
          onPressed: () {
            setState(() {
              selectedCategoryIndex = 0;
            });
          },
        ),
        CategoryButton(
          texto: 'Calientes',
          icono: Icon(Icons.local_fire_department),
          isSelected: selectedCategoryIndex == 1,
          onPressed: () {
            setState(() {
              selectedCategoryIndex = 1;
            });
          },
        ),
        CategoryButton(
          texto: 'Punto de vista',
          icono: Icon(Icons.remove_red_eye),
          isSelected: selectedCategoryIndex == 2,
          onPressed: () {
            setState(() {
              selectedCategoryIndex = 2;
            });
          },
        ),
      ],
    );
  }
}

class CategoryButton extends StatelessWidget {
  final String texto;
  final Icon icono;
  final bool isSelected;
  final VoidCallback onPressed;

  CategoryButton({
    required this.texto,
    required this.icono,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (isSelected) {
              return Color(0xFF2F8B62);
            }

            return Colors.transparent;
          },
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
      child: Row(
        children: [
          AutoSizeText(
            texto,
            style: TextStyle(
              fontSize: 14,
              color: isSelected ? Colors.white : Color(0xFF2F8B62),
            ),
          ),
          SizedBox(width: 8),
          Icon(
            icono.icon,
            color: isSelected ? Colors.white : Color(0xFF2F8B62),
          ),
        ],
      ),
    );
  }
}
