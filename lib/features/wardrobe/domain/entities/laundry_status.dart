enum LaundryStatus {
  clean,
  worn,
  inLaundry,
  washed;

  String get label => switch (this) {
    LaundryStatus.clean => 'Clean',
    LaundryStatus.worn => 'Worn',
    LaundryStatus.inLaundry => 'In Laundry',
    LaundryStatus.washed => 'Washed',
  };
}
