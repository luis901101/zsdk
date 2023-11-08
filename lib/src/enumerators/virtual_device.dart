/// Created by luis901101 on 2020-02-11.
enum VirtualDevice {
  none('none'),
  aplD('apl-d'),
  aplI('apl-i'),
  aplE('apl-e'),
  aplL('apl-l'),
  aplM('apl-m'),
  aplMi('apl-mi'),
  aplO('apl-o'),
  aplT('apl-t'),
  pdf('pdf'),
  ;

  final String name;
  const VirtualDevice(this.name);

  static VirtualDevice? valueOf(String? name) {
    for (final item in values) {
      if(item.name == name) return item;
    }
    return null;
  }
}
