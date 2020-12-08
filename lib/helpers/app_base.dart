
bool isNumeric(String s) {
 if (s == null) {
   return false;
 }
 return double.tryParse(s) != null;
}

String refineTitle(String songTitle)
{
  return songTitle.replaceAll("''L", "'l").replaceAll("''", "'");
}

String refineContent(String songContent)
{
  return songContent.replaceAll("''", "'").replaceAll("\\n", " ");
}