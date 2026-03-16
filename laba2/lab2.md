# Лабораторна робота 2

## Перетворення ER-діаграми на схему PostgreSQL

### Тема: Система бронювання готелю (Hotel Booking System)

---

# 1. Мета роботи

Метою лабораторної роботи є перетворення концептуальної ER-діаграми системи бронювання готелю на реляційну схему PostgreSQL.  
У ході роботи необхідно створити таблиці бази даних, визначити первинні та зовнішні ключі, додати обмеження цілісності та заповнити таблиці тестовими даними.

---

# 2. Опис схеми бази даних

На основі ER-діаграми з лабораторної роботи 1 було створено реляційну схему для системи бронювання готелю.  
Кожна сутність ER-моделі була перетворена на окрему таблицю, а зв’язки між сутностями реалізовані за допомогою зовнішніх ключів.

У схемі використано такі таблиці:

- `guest`
- `staff`
- `room_type`
- `room`
- `reservation`
- `reservation_room`
- `payment`

---

# 3. Опис таблиць

## 3.1 Таблиця `guest`

Таблиця `guest` містить інформацію про гостей готелю.

**Стовпці:**
- `guest_id` — первинний ключ
- `first_name` — ім’я гостя
- `last_name` — прізвище гостя
- `phone` — номер телефону
- `email` — електронна пошта
- `passport_number` — номер паспорта

**Обмеження:**
- `guest_id` — `PRIMARY KEY`
- `phone` — `UNIQUE`
- `email` — `UNIQUE`
- `passport_number` — `UNIQUE`
- основні поля мають `NOT NULL`

---

## 3.2 Таблиця `staff`

Таблиця `staff` містить інформацію про працівників готелю.

**Стовпці:**
- `staff_id` — первинний ключ
- `first_name` — ім’я працівника
- `last_name` — прізвище працівника
- `position` — посада
- `phone` — телефон
- `email` — електронна пошта

**Обмеження:**
- `staff_id` — `PRIMARY KEY`
- `phone` — `UNIQUE`
- `email` — `UNIQUE`

---

## 3.3 Таблиця `room_type`

Таблиця `room_type` зберігає типи номерів.

**Стовпці:**
- `room_type_id` — первинний ключ
- `type_name` — назва типу номера
- `capacity` — місткість номера
- `price_per_night` — вартість за ніч
- `description` — опис

**Обмеження:**
- `room_type_id` — `PRIMARY KEY`
- `type_name` — `UNIQUE`
- `capacity > 0`
- `price_per_night > 0`

---

## 3.4 Таблиця `room`

Таблиця `room` містить інформацію про конкретні номери.

**Стовпці:**
- `room_id` — первинний ключ
- `room_number` — номер кімнати
- `floor` — поверх
- `status` — статус номера
- `room_type_id` — зовнішній ключ на `room_type`

**Обмеження:**
- `room_id` — `PRIMARY KEY`
- `room_number` — `UNIQUE`
- `floor >= 1`
- `status` може мати значення: `Available`, `Occupied`, `Maintenance`
- `room_type_id` — `FOREIGN KEY REFERENCES room_type(room_type_id)`

---

## 3.5 Таблиця `reservation`

Таблиця `reservation` зберігає інформацію про бронювання.

**Стовпці:**
- `reservation_id` — первинний ключ
- `guest_id` — зовнішній ключ на `guest`
- `staff_id` — зовнішній ключ на `staff`
- `check_in_date` — дата заїзду
- `check_out_date` — дата виїзду
- `reservation_date` — дата створення бронювання
- `status` — статус бронювання
- `total_amount` — загальна сума

**Обмеження:**
- `reservation_id` — `PRIMARY KEY`
- `guest_id` — `FOREIGN KEY REFERENCES guest(guest_id)`
- `staff_id` — `FOREIGN KEY REFERENCES staff(staff_id)`
- `check_out_date > check_in_date`
- `status` може мати значення: `New`, `Confirmed`, `Cancelled`, `Completed`
- `total_amount >= 0`

---

## 3.6 Таблиця `reservation_room`

Таблиця `reservation_room` реалізує зв’язок багато-до-багатьох між таблицями `reservation` та `room`.

**Стовпці:**
- `reservation_id` — зовнішній ключ на `reservation`
- `room_id` — зовнішній ключ на `room`
- `price_per_night` — ціна номера за ніч
- `number_of_guests` — кількість гостей у номері

**Обмеження:**
- складений первинний ключ: `PRIMARY KEY (reservation_id, room_id)`
- `reservation_id` — `FOREIGN KEY REFERENCES reservation(reservation_id)`
- `room_id` — `FOREIGN KEY REFERENCES room(room_id)`
- `price_per_night > 0`
- `number_of_guests > 0`

---

## 3.7 Таблиця `payment`

Таблиця `payment` зберігає інформацію про платежі.

**Стовпці:**
- `payment_id` — первинний ключ
- `reservation_id` — зовнішній ключ на `reservation`
- `payment_date` — дата оплати
- `amount` — сума платежу
- `payment_method` — спосіб оплати
- `payment_status` — статус платежу

**Обмеження:**
- `payment_id` — `PRIMARY KEY`
- `reservation_id` — `FOREIGN KEY REFERENCES reservation(reservation_id)`
- `amount > 0`
- `payment_method` може мати значення: `Cash`, `Card`, `Online`
- `payment_status` може мати значення: `Pending`, `Paid`, `Refunded`

---

# 4. Зв’язки між таблицями

У створеній схемі реалізовані такі зв’язки:

- один гість може мати багато бронювань  
  (`guest` 1 : N `reservation`)

- один працівник може оформлювати багато бронювань  
  (`staff` 1 : N `reservation`)

- один тип номера може включати багато номерів  
  (`room_type` 1 : N `room`)

- одне бронювання може мати багато платежів  
  (`reservation` 1 : N `payment`)

- одне бронювання може містити кілька номерів, і один номер може зустрічатися в різних бронюваннях  
  (`reservation` N : M `room` через `reservation_room`)

---

# 5. Використані обмеження

У схемі були використані такі обмеження цілісності:

- `PRIMARY KEY` — для унікальної ідентифікації записів
- `FOREIGN KEY` — для реалізації зв’язків між таблицями
- `NOT NULL` — для обов’язкових полів
- `UNIQUE` — для унікальних значень, таких як телефон, email, номер кімнати
- `CHECK` — для перевірки допустимих значень і правил, наприклад:
  - позитивна ціна
  - позитивна кількість гостей
  - коректний порядок дат
  - допустимі значення статусів

---

# 6. Тестові дані

Після створення таблиць кожна з них була заповнена тестовими даними за допомогою операторів `INSERT INTO`.  
У кожній таблиці було додано щонайменше 5 записів.

Тестові дані були вставлені в такому порядку:

1. `guest`
2. `staff`
3. `room_type`
4. `room`
5. `reservation`
6. `reservation_room`
7. `payment`

Такий порядок забезпечує коректне дотримання зовнішніх ключів.

---

# 7. Перевірка результатів

Після виконання SQL-скрипта в pgAdmin було перевірено:

- успішне створення всіх таблиць;
- успішне додавання тестових записів;
- коректність зв’язків між таблицями;
- відсутність помилок порушення обмежень;
- правильне відображення даних за допомогою запитів `SELECT * FROM ...`.

Для перевірки використовувались запити:

```sql
SELECT * FROM guest;
SELECT * FROM staff;
SELECT * FROM room_type;
SELECT * FROM room;
SELECT * FROM reservation;
SELECT * FROM reservation_room;
SELECT * FROM payment;
