# Лабораторна робота 5: Нормалізація бази даних

Виконала Мамішева Шаргія з ІО-41.
## Цілі

- **Пошук надлишковості та аномалій:** виявлення потенційної надлишковості даних (наприклад, повторювані значення) або аномалій оновлення (проблеми вставки/оновлення/видалення) у поточній схемі.
- **Перелік функціональних залежностей:** визначте та перелічіть функціональні залежності (ФЗ) для кожної проблемної таблиці.
- **Перевірка нормальних форм:** оцініть поточну нормальну форму кожної таблиці (1NF, 2NF, 3NF) на основі її функціональних залежностей (ФЗ) та структури ключа.
- **Застосування нормалізації:** перетворення таблиць у вищі нормальні форми (до 3НФ) для усунення часткових та транзитивних залежностей.

---
У файлі sql2 я нормалізувала два проблемні місця:

`room_types.amenities` винесено в окремі таблиці `amenities` і `room_type_amenities`
`guests.address` розбито через довідник `cities`, а в `guests` лишився `street_address`


# 1. Початкова схема бази даних

Початкова база даних містить такі таблиці:

- `hotels`
- `room_types`
- `rooms`
- `guests`
- `bookings`

## 1.1 Початковий дизайн таблиць

### Таблиця `hotels`
Атрибути:
- `hotel_id` — первинний ключ
- `name`
- `location`
- `star_rating`

### Таблиця `room_types`
Атрибути:
- `room_type_id` — первинний ключ
- `type_name`
- `description`
- `capacity`
- `amenities`

### Таблиця `rooms`
Атрибути:
- `room_id` — первинний ключ
- `hotel_id` — зовнішній ключ
- `room_type_id` — зовнішній ключ
- `room_number`
- `floor_number`
- `price_per_night`
- `status`

### Таблиця `guests`
Атрибути:
- `guest_id` — первинний ключ
- `first_name`
- `last_name`
- `date_of_birth`
- `phone`
- `email`
- `passport_number`
- `address`

### Таблиця `bookings`
Атрибути:
- `booking_id` — первинний ключ
- `guest_id` — зовнішній ключ
- `room_id` — зовнішній ключ
- `check_in_date`
- `check_out_date`
- `booking_status`
- `created_at`

---

# 2. Функціональні залежності початкової схеми

## 2.1 Таблиця `hotels`
Функціональна залежність:
- `hotel_id -> name, location, star_rating`

Кандидатний ключ:
- `hotel_id`

---

## 2.2 Таблиця `room_types`
Функціональні залежності:
- `room_type_id -> type_name, description, capacity, amenities`
- `type_name -> room_type_id, description, capacity, amenities`

Кандидатні ключі:
- `room_type_id`
- `type_name`

Проблема:
- атрибут `amenities` містить перелік значень в одному полі, наприклад: `Wi-Fi, TV, душ`. Це означає, що поле не є атомарним.

---

## 2.3 Таблиця `rooms`
Функціональні залежності:
- `room_id -> hotel_id, room_type_id, room_number, floor_number, price_per_night, status`
- `(hotel_id, room_number) -> room_id, room_type_id, floor_number, price_per_night, status`

Кандидатні ключі:
- `room_id`
- `(hotel_id, room_number)`

---

## 2.4 Таблиця `guests`
Функціональні залежності:
- `guest_id -> first_name, last_name, date_of_birth, phone, email, passport_number, address`
- `email -> guest_id, first_name, last_name, date_of_birth, phone, passport_number, address`
- `passport_number -> guest_id, first_name, last_name, date_of_birth, phone, email, address`

Кандидатні ключі:
- `guest_id`
- `email`
- `passport_number`

Проблема:
- атрибут `address` зберігає складене текстове значення, наприклад `Київ, Україна`, що ускладнює аналіз та може спричинити дублювання даних про місто і країну.

---

## 2.5 Таблиця `bookings`
Функціональна залежність:
- `booking_id -> guest_id, room_id, check_in_date, check_out_date, booking_status, created_at`

Кандидатний ключ:
- `booking_id`

---

# 3. Аналіз нормальних форм початкової схеми

## 3.1 Перевірка на 1НФ

Перша нормальна форма вимагає, щоб усі атрибути були атомарними і не містили множинних значень.

### Таблиця `hotels`
Таблиця перебуває у 1НФ, оскільки всі поля є атомарними.

### Таблиця `rooms`
Таблиця перебуває у 1НФ, оскільки всі значення атомарні.

### Таблиця `guests`
Формально таблиця перебуває у 1НФ, бо поле `address` є одним текстовим значенням. Але з точки зору проєктування це поле є слабо структурованим.

### Таблиця `bookings`
Таблиця перебуває у 1НФ.

### Таблиця `room_types`
Таблиця **не відповідає 1НФ**, оскільки поле `amenities` містить перелік кількох значень в одному атрибуті.

**Висновок:** початкова схема не повністю відповідає 1НФ через таблицю `room_types`.

---

## 3.2 Перевірка на 2НФ

Друга нормальна форма вимагає:
- таблиця має бути у 1НФ;
- кожен неключовий атрибут повинен залежати від усього ключа, а не від його частини.

У даній схемі всі первинні ключі прості, а не складені. Тому часткових залежностей немає.

**Висновок:** усі таблиці, які вже знаходяться у 1НФ, автоматично відповідають 2НФ.

---

## 3.3 Перевірка на 3НФ

Третя нормальна форма вимагає:
- таблиця має бути у 2НФ;
- не повинно бути транзитивних залежностей між неключовими атрибутами.

### Таблиця `guests`
Поле `address` потенційно містить у собі декілька логічних частин: населений пункт, країну, вулицю тощо. Через це один і той самий населений пункт може дублюватися у багатьох записах. Це створює ризик транзитивних залежностей на кшталт:

- `guest_id -> address`
- `address -> city, country`

Отже, таблиця `guests` доцільно додатково нормалізувати.

### Таблиця `room_types`
Поле `amenities` порушує 1НФ, тому таблиця не може вважатися такою, що перебуває у 3НФ.

**Загальний висновок:** початкова схема не є повністю нормальною до 3НФ.

---

# 4. Виявлені проблеми та аномалії

## 4.1 Проблема в таблиці `room_types`
Поле `amenities` містить список зручностей в одному рядку. Наприклад:

- `Wi-Fi, TV, душ`
- `Wi-Fi, TV, кондиціонер`
- `Wi-Fi, TV, джакузі, міні-бар`

### Аномалії:
- **аномалія вставки:** не можна додати нову зручність окремо, не змінюючи рядок типу номера;
- **аномалія оновлення:** при зміні назви зручності потрібно редагувати всі рядки вручну;
- **аномалія видалення:** при видаленні типу номера можна втратити інформацію про зручність.

---

## 4.2 Проблема в таблиці `guests`
Поле `address` є занадто загальним і може містити повторювану інформацію про місто й країну.

### Аномалії:
- **аномалія дублювання:** однакові міста і країни повторюються в багатьох записах;
- **аномалія оновлення:** якщо треба змінити назву міста або виправити написання, доведеться редагувати багато рядків;
- **аномалія вставки:** неможливо централізовано додати місто як довідникове значення.

---

# 5. Нормалізація схеми

## 5.1 Перехід до 1НФ

### Проблемна таблиця: `room_types`

Початковий варіант:
- `room_type_id`
- `type_name`
- `description`
- `capacity`
- `amenities`

Поле `amenities` є неатомарним, тому для досягнення 1НФ воно має бути винесене в окремі таблиці.

### Нові таблиці:
1. `amenities`
   - `amenity_id` — первинний ключ
   - `amenity_name`

2. `room_type_amenities`
   - `room_type_id` — зовнішній ключ
   - `amenity_id` — зовнішній ключ
   - складений первинний ключ: (`room_type_id`, `amenity_id`)

### Результат
Кожна зручність тепер зберігається окремо, а зв’язок між типом номера та зручністю реалізовано через проміжну таблицю. Це усуває повторювані групи та забезпечує 1НФ.

---

## 5.2 Перехід до 2НФ

Після усунення неатомарного поля всі таблиці перебувають у 1НФ. У схемі відсутні складені первинні ключі в основних таблицях, тому часткових залежностей немає.

Таблиця `room_type_amenities` має складений первинний ключ (`room_type_id`, `amenity_id`), але інших неключових атрибутів у ній немає. Тому вона також відповідає 2НФ.

### Результат
Після змін схема відповідає 2НФ.

---

## 5.3 Перехід до 3НФ

### Проблемна таблиця: `guests`

Початковий варіант:
- `guest_id`
- `first_name`
- `last_name`
- `date_of_birth`
- `phone`
- `email`
- `passport_number`
- `address`

Поле `address` може містити і вулицю, і місто, і країну. Для усунення дублювання інформації про міста було виконано декомпозицію.

### Нові таблиці:
1. `cities`
   - `city_id` — первинний ключ
   - `city_name`
   - `country`

2. оновлена таблиця `guests`
   - `guest_id`
   - `first_name`
   - `last_name`
   - `date_of_birth`
   - `phone`
   - `email`
   - `passport_number`
   - `street_address`
   - `city_id` — зовнішній ключ

### Результат
Інформація про місто та країну більше не дублюється в кожному записі гостя. Це зменшує надлишковість і усуває ризик транзитивних залежностей.

---

# 6. Оригінальний та перероблений дизайн таблиць

## 6.1 Зміни для `room_types`

### Було:
```sql
CREATE TABLE room_types (
    room_type_id SERIAL PRIMARY KEY,
    type_name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    capacity INTEGER NOT NULL CHECK (capacity > 0),
    amenities TEXT
);
```
Стало:
```sql
CREATE TABLE room_types (
    room_type_id SERIAL PRIMARY KEY,
    type_name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    capacity INTEGER NOT NULL CHECK (capacity > 0)
);

CREATE TABLE amenities (
    amenity_id SERIAL PRIMARY KEY,
    amenity_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE room_type_amenities (
    room_type_id INTEGER NOT NULL,
    amenity_id INTEGER NOT NULL,
    PRIMARY KEY (room_type_id, amenity_id),
    FOREIGN KEY (room_type_id) REFERENCES room_types(room_type_id) ON DELETE CASCADE,
    FOREIGN KEY (amenity_id) REFERENCES amenities(amenity_id) ON DELETE CASCADE
);
```

Приклад через `ALTER TABLE`:
```sql
ALTER TABLE room_types DROP COLUMN amenities;
```

6.2 Зміни для `guests`

Було:
```sql
CREATE TABLE guests (
    guest_id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    date_of_birth DATE,
    phone VARCHAR(30),
    email VARCHAR(150) UNIQUE,
    passport_number VARCHAR(50) UNIQUE,
    address VARCHAR(255)
);
```
Стало:
```sql
CREATE TABLE cities (
    city_id SERIAL PRIMARY KEY,
    city_name VARCHAR(100) NOT NULL,
    country VARCHAR(100) NOT NULL,
    CONSTRAINT uq_city_country UNIQUE (city_name, country)
);

CREATE TABLE guests (
    guest_id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    date_of_birth DATE,
    phone VARCHAR(30),
    email VARCHAR(150) UNIQUE,
    passport_number VARCHAR(50) UNIQUE,
    street_address VARCHAR(150),
    city_id INTEGER,
    FOREIGN KEY (city_id) REFERENCES cities(city_id) ON DELETE SET NULL
);
```
Приклад через `ALTER TABLE`

```sql
ALTER TABLE guests DROP COLUMN address;
ALTER TABLE guests ADD COLUMN street_address VARCHAR(150);
ALTER TABLE guests ADD COLUMN city_id INTEGER;
ALTER TABLE guests
ADD CONSTRAINT fk_guests_city
FOREIGN KEY (city_id) REFERENCES cities(city_id) ON DELETE SET NULL;
```
7. Фінальна схема у 3НФ

Після нормалізації схема містить такі таблиці:

`hotels`
`cities`
`room_types`
`amenities`
`room_type_amenities`
`rooms`
`guests`
`bookings`

7.1 Обґрунтування відповідності 3НФ

`hotels`

Усі неключові атрибути залежать тільки від `hotel_id`. Транзитивних залежностей немає.

`cities`

Усі неключові атрибути залежать тільки від `city_id`. Таблиця відповідає 3НФ.

`room_types`

Після вилучення amenities усі атрибути залежать тільки від `room_type_id.`

`amenities`

Містить один факт про одну зручність. Відповідає 3НФ.

`room_type_amenities`

Містить лише зв’язок між двома сутностями. Неключових атрибутів немає.

`rooms`

Усі атрибути залежать тільки від `room_id`.

`guests`

Після поділу адреси атрибути залежать тільки від `guest_id`, а інформація про місто винесена окремо.

`bookings`

Усі атрибути залежать тільки від `booking_id.`

8. Висновок

У ході виконання лабораторної роботи було проаналізовано початкову схему бази даних системи бронювання готельних номерів. Було встановлено, що основною проблемою початкової схеми є неатомарний атрибут `amenities` у таблиці `room_types`, а також недостатньо структуроване поле `address` у таблиці `guests.`

Для усунення цих недоліків виконано нормалізацію:

поле `amenities` винесено в окрему довідникову таблицю `amenities` та таблицю зв’язку `room_type_amenities`;
атрибут address замінено на street_address і зовнішній ключ `city_id`, а інформацію про міста та країни винесено до таблиці `cities`.

У результаті схема бази даних була приведена до 3НФ. Це дозволило зменшити надлишковість даних, усунути потенційні аномалії вставки, оновлення та видалення, а також підвищити цілісність і зручність подальшого супроводу бази даних.

<img width="1255" height="980" alt="image" src="https://github.com/user-attachments/assets/0f4599f1-b62f-49d2-aab5-32b9ef768970" />

