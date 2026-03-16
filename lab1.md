# Лабораторна робота 1

## Збір вимог та розробка ER-діаграми

### Тема: Система бронювання готелю (Hotel Booking System)

---

# 1. Мета роботи

Метою лабораторної роботи є ознайомлення з процесом збору вимог до інформаційної системи та створення концептуальної моделі даних у вигляді ER-діаграми.  
У процесі роботи необхідно визначити основні сутності системи, їх атрибути та зв’язки між ними.

---

# 2. Опис системи

Система бронювання готелю призначена для управління інформацією про гостей, номери, бронювання та платежі.

Система повинна забезпечувати можливість:

- реєстрації гостей;
- зберігання інформації про номери готелю;
- створення та управління бронюваннями;
- фіксації платежів;
- обліку співробітників, які обробляють бронювання.

Основна мета системи — забезпечити ефективне зберігання та обробку даних, пов’язаних з бронюванням номерів у готелі.

---

# 3. Вимоги до системи

## 3.1 Потреби зацікавлених сторін

Адміністрація готелю потребує систему, яка дозволяє:

- зберігати інформацію про гостей;
- вести облік номерів та їх типів;
- створювати бронювання номерів;
- відстежувати дати заїзду та виїзду;
- реєструвати платежі;
- зберігати інформацію про співробітників, які обробляють бронювання.

---

## 3.2 Дані, які повинна зберігати система

Система повинна зберігати наступні дані:

- інформацію про гостей;
- інформацію про персонал;
- інформацію про номери;
- типи номерів;
- бронювання;
- платежі.

---

## 3.3 Бізнес-правила

У системі діють наступні правила:

- один гість може мати кілька бронювань;
- кожне бронювання належить одному гостю;
- один номер може бути заброньований багато разів у різні періоди часу;
- одне бронювання може включати один або кілька номерів;
- один співробітник може оформити багато бронювань;
- одне бронювання може мати кілька платежів;
- дата виїзду повинна бути пізнішою за дату заїзду;
- сума платежу повинна бути більшою за 0;
- один номер належить лише одному типу номера;
- один тип номера може включати багато номерів.

---

# 4. Сутності та їх атрибути

## Guest (Гість)

**Атрибути:**

- GuestID (Primary Key)
- FirstName
- LastName
- Phone
- Email
- PassportNumber

---

## Staff (Персонал)

**Атрибути:**

- StaffID (Primary Key)
- FirstName
- LastName
- Position
- Phone
- Email

---

## RoomType (Тип номера)

**Атрибути:**

- RoomTypeID (Primary Key)
- TypeName
- Capacity
- PricePerNight
- Description

---

## Room (Номер)

**Атрибути:**

- RoomID (Primary Key)
- RoomNumber
- Floor
- Status
- RoomTypeID (Foreign Key)

---

## Reservation (Бронювання)

**Атрибути:**

- ReservationID (Primary Key)
- GuestID (Foreign Key)
- StaffID (Foreign Key)
- CheckInDate
- CheckOutDate
- ReservationDate
- Status
- TotalAmount

---

## ReservationRoom

Асоціативна сутність для реалізації зв’язку між бронюванням та номером.

**Атрибути:**

- ReservationID (Primary Key, Foreign Key)
- RoomID (Primary Key, Foreign Key)
- PricePerNight
- NumberOfGuests

---

## Payment (Платіж)

**Атрибути:**

- PaymentID (Primary Key)
- ReservationID (Foreign Key)
- PaymentDate
- Amount
- PaymentMethod
- PaymentStatus

---

# 5. Опис зв’язків між сутностями

### Guest — Reservation

Зв’язок **1:N**.  
Один гість може зробити багато бронювань, але кожне бронювання належить одному гостю.

---

### Staff — Reservation

Зв’язок **1:N**.  
Один співробітник може оформити багато бронювань.

---

### RoomType — Room

Зв’язок **1:N**.  
Один тип номера може включати багато номерів.

---

### Reservation — Payment

Зв’язок **1:N**.  
Одне бронювання може мати один або кілька платежів.

---

### Reservation — Room

Зв’язок **N:M**.  
Одне бронювання може включати кілька номерів, а один номер може бути частиною багатьох бронювань у різний час.

Цей зв’язок реалізується через сутність **ReservationRoom**.

---

# 6. Припущення та обмеження

- кожен гість має унікальний GuestID;
- кожен номер має унікальний RoomNumber;
- кожен співробітник має унікальний StaffID;
- один номер не може бути заброньований двічі на однаковий період часу;
- дата виїзду повинна бути пізнішою за дату заїзду;
- сума платежу повинна бути більшою за нуль;
- кожен тип номера має місткість більше нуля.

---

# 7. ER-діаграма

ER-діаграма створюється у draw.io або іншому інструменті для моделювання баз даних.

Вона повинна містити такі сутності:

- Guest
- Staff
- RoomType
- Room
- Reservation
- ReservationRoom
- Payment

На діаграмі повинні бути позначені:

- первинні ключі (PK);
- зовнішні ключі (FK);
- кардинальності зв’язків.

---

# 8. Висновок

У ході виконання лабораторної роботи було проведено аналіз вимог до системи бронювання готелю.  
Було визначено основні сутності системи, їх атрибути та зв’язки між ними.

На основі зібраних вимог створено концептуальну ER-діаграму, яка відображає структуру даних майбутньої бази даних.  
Отримана модель може бути використана для подальшої реалізації бази даних у PostgreSQL та написання SQL-запитів у наступних лабораторних роботах.

## ER-діаграма

```mermaid
erDiagram
    GUEST ||--o{ RESERVATION : makes
    STAFF ||--o{ RESERVATION : processes
    ROOM_TYPE ||--o{ ROOM : includes
    RESERVATION ||--o{ PAYMENT : has
    RESERVATION ||--o{ RESERVATION_ROOM : contains
    ROOM ||--o{ RESERVATION_ROOM : assigned_to

    GUEST {
        int GuestID PK
        string FirstName
        string LastName
        string Phone
        string Email
        string PassportNumber
    }

    STAFF {
        int StaffID PK
        string FirstName
        string LastName
        string Position
        string Phone
        string Email
    }

    ROOM_TYPE {
        int RoomTypeID PK
        string TypeName
        int Capacity
        decimal PricePerNight
        string Description
    }

    ROOM {
        int RoomID PK
        string RoomNumber
        int Floor
        string Status
        int RoomTypeID FK
    }

    RESERVATION {
        int ReservationID PK
        int GuestID FK
        int StaffID FK
        date CheckInDate
        date CheckOutDate
        date ReservationDate
        string Status
        decimal TotalAmount
    }

    RESERVATION_ROOM {
        int ReservationID PK, FK
        int RoomID PK, FK
        decimal PricePerNight
        int NumberOfGuests
    }

    PAYMENT {
        int PaymentID PK
        int ReservationID FK
        date PaymentDate
        decimal Amount
        string PaymentMethod
        string PaymentStatus
    }
