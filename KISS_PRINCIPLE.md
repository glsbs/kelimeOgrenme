# KISS Prensibi Uygulaması - kelimeOgrenme (Flutter)

Bu projede KISS (Keep It Simple, Stupid) prensibine uygun şekilde basit ve anlaşılır kod yazımı hedeflenmiştir.

---

## 🔹 Uygulanan Basitlik İlkeleri

- Her dosya tek bir sorumluluk taşır:
  - `kelimelerim_page.dart`: öğrenilen kelimeler
  - `wordle_page.dart`: oyun sayfası
  - `statistics_page.dart`: kullanıcı istatistikleri
- Ortak kullanılan bileşenler `widgets/` altında yeniden kullanılabilir şekilde yazılmıştır.

---

## ✅ Örnekler

- `custom_input_decoration.dart`: tüm input alanlarında tekrar eden stil yapılarını sadeleştirir.
- `auth_gate.dart`: giriş kontrolünü tek başına üstlenir, ayrı sayfalara yönlendirme yapar.
- Gereksiz state yönetimi yapılmamış, sade yapı korunmuştur.

---

## 🎯 Genel
kelimeOgrenme projesinde sadelik, okunabilirlik ve tekrar kullanım hedeflenmiştir. Kodlar olabildiğince anlaşılır ve düzenlidir.
