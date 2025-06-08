# Code Smells Değerlendirmesi - kelimeOgrenme (Flutter)

kelimeOgrenme uygulaması geliştirilirken, kodun okunabilirliğini ve sürdürülebilirliğini bozan "code smell"lerden kaçınılmaya çalışılmıştır. Aşağıda tespit edilen ve önlenen kokular yer almaktadır.

---

## 🚫 1. Uzun Metotlar (Long Methods)
- Sayfa içi metotlar küçük ve işlevsel parçalara bölünmüştür.
  - Örnek: `login_page.dart`, `signup_page.dart`, `wordle_page.dart` içinde yapı ayrıştırılmıştır.
  - UI bileşenleri ayrı widget dosyalarında (`baslik_yazisi.dart`, `dikey_bosluk.dart`) tanımlanmıştır.

---

## 🔁 2. Yinelenen Kod (Duplicate Code)
- Ortak form stilleri ve padding’ler `widgets/` klasörüne alınarak merkezi hale getirilmiştir.
- `custom_input_decoration.dart` tüm form girişlerinde kullanılmıştır.

---

## 🔢 3. Magic Numbers
- Renk, boyut, padding gibi değerler `constants/colors.dart` dosyasında toplanmıştır.
- Kodda sabitler yerine isimlendirilmiş `const` kullanımı tercih edilmiştir.

---

## 👑 4. God Widget (Tanrı Widget)
- Sayfalar tek bir sorumluluk alacak şekilde modüler yapıya ayrılmıştır.
- `auth/` klasörü içindeki her dosya giriş sistemiyle ilgili tek bir işleve sahiptir (kayıt, giriş, şifre sıfırlama).

---

## 🔄 5. Karmaşık Koşullar (Complex Conditions)
- Koşullu yapılar açık ve sade tutulmuş, iç içe if/else yapılarından kaçınılmıştır.

---

## 🎯 Genel
Proje genelinde modüler yapı korunmuş, kod tekrarı azaltılmış ve bileşenler sadeleştirilmiştir. Bu sayede bakım ve genişletme kolaylaşmıştır.
