class Type {
  final String? name;
  String? get assetImage => 'assets/images/types/$name.png';

  int? get mainColor => _typeColor[name];

  Type({this.name});
}

final _typeColor = {
  'bug': 0xff9dc431,
  'dark': 0xff5b5365,
  'dragon': 0xff0969c1,
  'electric': 0xfff4d23c,
  'fairy': 0xffec8de4,
  'fighting': 0xffce406a,
  'fire': 0xffff9c54,
  'flying': 0xff90aade,
  'ghost': 0xff5468ad,
  'grass': 0xff60ba55,
  'ground': 0xffd97745,
  'ice': 0xff73cebf,
  'normal': 0xff9199a1,
  'poison': 0xffa666c8,
  'psychic': 0xfffa6e74,
  'rock': 0xffc7b78a,
  'steel': 0xff54879d,
  'water': 0xff4d92d5,
};