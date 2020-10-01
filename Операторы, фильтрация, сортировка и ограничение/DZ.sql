DROP database IF EXISTS DZ;
create database DZ;

use DZ;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at DATETIME, -- DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME -- DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Покупатели';

INSERT INTO users (name, birthday_at) VALUES
  ('Геннадий', '1990-10-05'),
  ('Наталья', '1984-11-12'),
  ('Александр', '1985-05-20'),
  ('Сергей', '1988-02-14'),
  ('Иван', '1998-01-12'),
  ('Мария', '1992-08-29');
  
update users set created_at = now() where created_at is null;
update users set updated_at = now() where updated_at is null;
-- Чтобы провернуть эту махинацию, пришлось отключить Safe mode в настройках воркбенча)