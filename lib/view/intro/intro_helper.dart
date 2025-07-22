class IntroHelper {
  getImage(int i) {
    return 'assets/images/intro${i + 1}.png';
  }

  geTitle(int i) {
    List title = [
      "خدمات التجميل",
      "تصميم الازياء",
      "خدمات الصحة والجمال"
    ];
    return title[i];
  }

  geSubTitle(int i) {
    List subTitle = [
      "احصلي على خدمات التجميل من أفضل خبيرات تجميل متخصصين",
      "احصل على أفضل التصاميم من أفضل خبيرات التصميم لدينا",
      "استفيدي من خدمات الصحة والجمال لدينا للحصول على أفضل خدمة"
    ];
    return subTitle[i];
  }
}
