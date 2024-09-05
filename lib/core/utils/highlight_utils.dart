import 'package:flutter/material.dart';

List<TextSpan> highlightSearchResult(String source, String query) {
  if (query.isEmpty || !source.toLowerCase().contains(query.toLowerCase())) {
    return [TextSpan(text: source)];
  }

  // Создаем RegExp для поиска вхождений query
  final regExp = RegExp(RegExp.escape(query), caseSensitive: false);

  // Получаем все совпадения
  final matches = regExp.allMatches(source);

  int lastMatchEnd = 0;
  final List<TextSpan> children = [];

  for (var match in matches) {
    // Добавляем текст до текущего совпадения
    if (match.start != lastMatchEnd) {
      children.add(TextSpan(
        text: source.substring(lastMatchEnd, match.start),
      ));
    }

    // Добавляем выделенный текст
    children.add(TextSpan(
      text: source.substring(match.start, match.end),
      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
    ));

    // Обновляем конец последнего совпадения
    lastMatchEnd = match.end;
  }

  // Добавляем оставшийся текст после последнего совпадения
  if (lastMatchEnd < source.length) {
    children.add(TextSpan(
      text: source.substring(lastMatchEnd),
    ));
  }

  return children;
}
