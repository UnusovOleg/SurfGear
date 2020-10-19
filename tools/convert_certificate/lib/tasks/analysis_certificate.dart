import 'dart:io';

/// We are looking in the certificate file.
const _textContent = 'BEGIN CERTIFICATE';

/// Is a PEM certificate
///
/// todo: тут стоит рассмотреть подход к проверки, расширений больше
/// todo: https://rtfm.co.ua/tlsssl-der-vs-pem-tipy-fajlov-i-ix-konvertaciya/
Future<bool> analysisCertificate(File file) async {
  String content;
  try {
    content = await file.readAsString();
  } on FileSystemException {
    /// When trying to read a binary, an error will be emitted
    return false;
  }

  return content.contains(_textContent) ? true : false;
}
