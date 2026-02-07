import 'package:flutter/material.dart';

/// Mixin pour construire les champs de formulaire standardisés
/// Évite la répétition du code pour TextField, DropdownButton, Switch, etc.
mixin FormFieldBuilderMixin<T extends StatefulWidget> on State<T> {
  
  /// Construit un TextFormField standard
  Widget buildTextField(
    TextEditingController controller,
    String label, {
    String? hint,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    IconData? prefixIcon,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
          filled: true,
          fillColor: Colors.grey[50],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator,
      ),
    );
  }

  /// Construit un DropdownButtonFormField standard
  Widget buildDropdown(
    String? value,
    List<String> items,
    String label,
    Function(String?) onChanged, {
    IconData? prefixIcon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: DropdownButtonFormField<String>(
        initialValue: value,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
          filled: true,
          fillColor: Colors.grey[50],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        items: items
            .map((item) => DropdownMenuItem(
                  value: item,
                  child: Text(item),
                ))
            .toList(),
        onChanged: onChanged as void Function(String?)?,
      ),
    );
  }

  /// Construit un SwitchListTile standard
  Widget buildSwitch(
    bool value,
    String title,
    Function(bool) onChanged, {
    String? subtitle,
    IconData? leading,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: subtitle != null ? Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey[600])) : null,
        secondary: leading != null ? Icon(leading) : null,
        tileColor: Colors.grey[50],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  /// Construit un CheckboxListTile standard
  Widget buildCheckbox(
    bool value,
    String title,
    Function(bool?) onChanged, {
    String? subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: CheckboxListTile(
        value: value,
        onChanged: onChanged,
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: subtitle != null ? Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey[600])) : null,
        tileColor: Colors.grey[50],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  /// Construit une section avec titre
  Widget buildSection(String title, List<Widget> children, {IconData? icon, bool initiallyExpanded = false}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      child: ExpansionTile(
        initiallyExpanded: initiallyExpanded,
        leading: icon != null ? Icon(icon, color: Colors.indigo) : null,
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.indigo),
        ),
        children: children,
      ),
    );
  }

  /// Construit un titre de page
  Widget buildPageTitle(String title, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Icon(icon, size: 50, color: color),
          const SizedBox(height: 10),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          Divider(thickness: 2, color: color),
        ],
      ),
    );
  }

  /// Construit un bouton de navigation pour pagination
  Widget buildNavigationButtons(
    VoidCallback? onPrevious,
    VoidCallback? onNext,
    bool isLastPage,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Row(
        children: [
          if (onPrevious != null)
            Expanded(
              child: ElevatedButton.icon(
                onPressed: onPrevious,
                icon: const Icon(Icons.arrow_back),
                label: const Text('Précédent'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          if (onPrevious != null) const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: onNext,
              icon: Icon(isLastPage ? Icons.check : Icons.arrow_forward),
              label: Text(isLastPage ? 'Enregistrer' : 'Suivant'),
              style: ElevatedButton.styleFrom(
                backgroundColor: isLastPage ? Colors.green : Colors.indigo,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
