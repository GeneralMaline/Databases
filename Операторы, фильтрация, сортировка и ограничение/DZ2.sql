DROP database IF EXISTS DZ;
create database DZ;

use DZ;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at VARCHAR(250),
  updated_at VARCHAR(250)
) COMMENT = 'Покупатели';

INSERT INTO users (name, created_at, updated_at) VALUES
  ('Геннадий', '20.10.2017 8:10', '20.10.2017 8:10'),
  ('Наталья', '7.5.2013 12:10', '7.5.2013 12:10'),
  ('Александр', '6.2.2008 3:50', '6.2.2008 3:50'),
  ('Сергей', '23.8.2014 11:35', '23.8.2014 11:35'),
  ('Иван', '20.3.2003 4:50', '20.3.2003 4:50'),
  ('Мария', '28.4.2010 5:20', '28.4.2010 5:20');

update users set created_at = str_to_date(created_at,'%d.%m.%Y %h:%i');
alter table users CHANGE created_at created_at DATETIME;
update users set updated_at = str_to_date(updated_at,'%d.%m.%Y %h:%i');
alter table users CHANGE updated_at updated_at DATETIME;

select name, created_at, updated_at from users;

-- функция str_to_date не поддерживает видимо время больше 12 часов. при 21 часе выдавал ошибку