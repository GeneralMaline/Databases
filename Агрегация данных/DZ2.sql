DROP database IF EXISTS DZ;
create database DZ;

use DZ;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Покупатели';

INSERT INTO users (name, birthday_at) VALUES
  ('Геннадий', '1990-10-05'),
  ('Наталья', '1984-11-12'),
  ('Александр', '1985-05-20'),
  ('Сергей', '1988-02-14'),
  ('Иван', '1998-01-12'),
  ('Мария', '1992-08-29'),
  ('Максим', '1980-08-18'),
  ('Николай', '1992-03-26'),
  ('Елена', '1983-06-10');

select round(avg(timestampdiff(year, birthday_at, now())), 2) as Average_age from users; -- Подсчет среднего возраста

update users set birthday_at = DATE_FORMAT(birthday_at, '2020-%m-%d'); -- меняет год на текущий
select COUNT(*), DATE_FORMAT(birthday_at, '%W') as dayweek from users group by dayweek; -- выводит в какие дни недели сколько ДР