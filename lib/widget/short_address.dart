
String shortenAddress(String fullAddress) {
  if (fullAddress.contains('Jakarta Selatan')) {
    return 'Jakarta Selatan, Jakarta';
  } else if (fullAddress.contains('Jakarta Barat')) {
    return 'Jakarta Barat, Jakarta';
  } else if (fullAddress.contains('Jakarta Timur')) {
    return 'Jakarta Timur, Jakarta';
  } else if (fullAddress.contains('Jakarta Utara')) {
    return 'Jakarta Utara, Jakarta';
  }
  else {
    return 'Jakarta';
  }
}
