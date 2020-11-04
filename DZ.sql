/*База данных, содержащая фильмы и актеров, а также с пользователями, которые определяют рейтинги фильмов. Кол-во таблиц: 11. 
Имеются выборки(они же представления) для определения наград фильмов, определения актерского состава и определения рейтингов фильмов. 
Триггеры определения возраста актеров и пользователей. */

drop database if exists MyCinemabase;
create database MyCinemabase;

use MyCinemabase;

drop table if exists movies;
create table movies(
	id serial primary key,
	title varchar(250),
	release_date date,
    poster_id bigint unsigned unique,
    trailer_id bigint unsigned unique,
	rating float default 0,
    director varchar(250),
	genres varchar(250),
	country varchar(50),
    description text,
	index(title),
	index(release_date),
	index(director),
	index(genres)
);

drop table if exists posters;
create table posters(
	id serial primary key,
    filename varchar(256),
    movie_id bigint unsigned,
    foreign key (movie_id) references movies(id)
);

drop table if exists trailers;
create table trailers(
	id serial primary key,
    filename varchar(250),
    movie_id bigint unsigned,
    foreign key (movie_id) references movies(id)
);

drop table if exists stars;
create table stars(
	id serial primary key,
    name varchar(250),
    photo_id bigint unsigned,
    career varchar(250),
    birthday date,
    age tinyint unsigned,
    hometown varchar(50),
    genres varchar(250),
    total_films SMALLINT unsigned,
    index (name),
    index (age)
);

-- триггер подсчета возраста звезды

drop trigger if exists star_age;
delimiter //
create trigger star_age before insert on stars
for each row
begin
    set new.age = timestampdiff(year, new.birthday, now());
end//
delimiter ;

drop table if exists movies_stars;
create table movies_stars(
	movie_id bigint unsigned not null,
	star_id bigint unsigned not null,
	primary key(movie_id, star_id),
	foreign key (movie_id) references movies (id),
	foreign key (star_id) references stars (id)
);

drop table if exists star_photos;
create table star_photos(
	id serial primary key,
    filename varchar(250), 
    star_id bigint unsigned not null,
	foreign key (star_id) references stars (id)
);

/*alter table stars 
add foreign key (photo_id) references star_photos(id);*/

drop table if exists users;
create table users(
	id serial primary key,
    nickname varchar(250) unique,
    name varchar(250),
    mail varchar(250) unique,
    birthday date,
    age tinyint unsigned,
	hometown varchar(50),
    index(nickname)
);

-- триггер подсчета возраста пользователя
drop trigger if exists user_age;
delimiter //
create trigger user_age before insert on users
for each row
begin
    set new.age = timestampdiff(year, new.birthday, now());
end//
delimiter ;


drop table if exists user_ratings;
create table user_ratings(
	movie_id bigint unsigned not null,
    user_id bigint unsigned not null,
    rating tinyint unsigned not null,
    primary key(movie_id, user_id),
    foreign key (movie_id) references movies(id),
	foreign key (user_id) references users(id)
);

drop table if exists reviews;
create table reviews(
    movie_id bigint unsigned not null,
    user_id bigint unsigned not null,
    body text,
    primary key(user_id, movie_id),
    foreign key (movie_id) references movies(id),
    foreign key (user_id) references users(id),
   	created_at datetime default current_timestamp,
	updated_at datetime default current_timestamp on update current_timestamp
);

drop table if exists awards;
create table awards(
	id serial primary key,
	name varchar(250),
    index(name)
);

drop table if exists movie_awards;
create table movie_awards(
	award_id bigint unsigned not null,
    movie_id bigint unsigned not null,
    primary key(award_id, movie_id),
    foreign key (movie_id) references movies(id),
	foreign key (award_id) references awards(id)
);

-- Скрипты заполнения БД.

insert into movies (id, title, release_date, poster_id, trailer_id, director, genres, country, description) values (1, 'Shout', '2019-01-11', 1, 1, 'Forbes Geaves', 'Drama', 'Czech Republic', 'Nunc rhoncus dui vel sem. Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.');
insert into movies (id, title, release_date, poster_id, trailer_id, director, genres, country, description) values (2, 'Loneliness of the Long Distance Runner, The', '2006-07-30', 2, 2, 'Herta Paternoster', 'Drama', 'Poland', 'Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.');
insert into movies (id, title, release_date, poster_id, trailer_id, director, genres, country, description) values (3, 'Posto, Il', '1996-05-06', 3, 3, 'Phyllida Taffs', 'Drama', 'China', 'Duis mattis egestas metus. Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.');
insert into movies (id, title, release_date, poster_id, trailer_id, director, genres, country, description) values (4, 'Chronic Town', '2017-07-06', 4, 4, 'Hammad Hankard', 'Action|Drama|Thriller', 'Switzerland', 'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis. Sed ante. Vivamus tortor. Duis mattis egestas metus. Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum.');
insert into movies (id, title, release_date, poster_id, trailer_id, director, genres, country, description) values (5, 'Tainted', '2018-12-26', 5, 5, 'Alford Frotton', 'Comedy|Thriller', 'Slovenia', 'In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl. Aenean lectus. Pellentesque eget nunc.');
insert into movies (id, title, release_date, poster_id, trailer_id, director, genres, country, description) values (6, 'Kronos (a.k.a. Captain Kronos: Vampire Hunter)', '1991-10-10', 6, 6, 'Calypso Garrick', 'Horror', 'Australia', 'Vivamus in felis eu sapien cursus vestibulum. Proin eu mi. Nulla ac enim.');
insert into movies (id, title, release_date, poster_id, trailer_id, director, genres, country, description) values (7, 'Take Me Home', '2007-11-13', 7, 7, 'Marius Strathdee', 'Comedy|Romance', 'China', 'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis. Sed ante. Vivamus tortor. Duis mattis egestas metus.');
insert into movies (id, title, release_date, poster_id, trailer_id, director, genres, country, description) values (8, 'Coherence', '2010-06-19', 8, 8, 'Pattie Spiteri', 'Drama|Mystery|Sci-Fi|Thriller', 'Portugal', 'Mauris sit amet eros. Suspendisse accumsan tortor quis turpis. Sed ante. Vivamus tortor. Duis mattis egestas metus.');
insert into movies (id, title, release_date, poster_id, trailer_id, director, genres, country, description) values (9, 'Tommy Boy', '2013-08-16', 9, 9, 'Eadmund Krystof', 'Comedy', 'Canada', 'In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat. Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula.');
insert into movies (id, title, release_date, poster_id, trailer_id, director, genres, country, description) values (10, 'Mosquito Net, The (La mosquitera)', '2004-03-14', 10, 10, 'Shep Olenov', 'Drama', 'Oman', 'Etiam pretium iaculis justo. In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.');

insert into posters (id, filename, movie_id) values (1, 'dc7eaa80555d41be6a2ef451bf516c1a', 7);
insert into posters (id, filename, movie_id) values (2, '014a9476cb33d9150e69b7355ade45fe', 2);
insert into posters (id, filename, movie_id) values (3, '67f690f037dfe9f461cc7982646fe652', 4);
insert into posters (id, filename, movie_id) values (4, '26646768dfb9fd0a1ad0f36fef0aecda', 3);
insert into posters (id, filename, movie_id) values (5, '156a7ee5a51605d5fcf46f05c0766c6d', 5);
insert into posters (id, filename, movie_id) values (6, '57f0f98d3e415b31a36d77a330f4c56e', 1);
insert into posters (id, filename, movie_id) values (7, 'dfba5de7d5d4bee4e3cf0c44d0f68645', 8);
insert into posters (id, filename, movie_id) values (8, 'b664afa9295a8de037559ab958fffe7c', 9);
insert into posters (id, filename, movie_id) values (9, '7b603cd4a03bac22d8160a83e290172d', 10);
insert into posters (id, filename, movie_id) values (10, '673aa1faa6a57f076095e5028c2750cb', 6);

insert into trailers (id, filename, movie_id) values (1, '8cc65320b2cde870e026358580f08ba4', 2);
insert into trailers (id, filename, movie_id) values (2, 'df15d50f8c715c467344da7027d569fc', 5);
insert into trailers (id, filename, movie_id) values (3, 'd34e906f899c944aca4dcc79e01c27e6', 8);
insert into trailers (id, filename, movie_id) values (4, '09ff62055741d8fba56b24fdbf2f28fb', 3);
insert into trailers (id, filename, movie_id) values (5, 'f5e4692b96c8ae2c7520274e0d9d62e6', 4);
insert into trailers (id, filename, movie_id) values (6, '26b008a3273f6f069455bed8a927c253', 6);
insert into trailers (id, filename, movie_id) values (7, 'd2fbd837b8ba7e1f2c72b20997a59b1f', 1);
insert into trailers (id, filename, movie_id) values (8, '22252098f306ea340d348fdfe60b5a94', 10);
insert into trailers (id, filename, movie_id) values (9, '74b94b941d8507efd4b9bee3f4df0072', 9);
insert into trailers (id, filename, movie_id) values (10, '403f19dddccc4426c1a43ddbc9cf302e', 7);

insert into stars (id, name, photo_id, career, birthday, hometown, genres, total_films) values (1, 'Dulci Weddell', 10, 'sed', '1986-05-05', 'Nunutba', 'Comedy', 3);
insert into stars (id, name, photo_id, career, birthday, hometown, genres, total_films) values (2, 'Agosto Kinneir', 4, 'urna', '1979-06-01', 'Carlos Tejedor', 'Drama', 4);
insert into stars (id, name, photo_id, career, birthday, hometown, genres, total_films) values (3, 'Nancie de Amaya', 29, 'sem', '1983-08-03', 'Santa Monica', 'Crime|Drama|Thriller', 2);
insert into stars (id, name, photo_id, career, birthday, hometown, genres, total_films) values (4, 'Aurelie Rolfo', 14, 'aliquet', '1973-12-17', 'Tabor', 'Horror|Sci-Fi', 8);
insert into stars (id, name, photo_id, career, birthday, hometown, genres, total_films) values (5, 'Othilie Verbrugghen', 17, 'donec', '1975-06-02', 'Brongkalan', 'Comedy|Romance', 9);
insert into stars (id, name, photo_id, career, birthday, hometown, genres, total_films) values (6, 'Cooper Heintz', 7, 'at', '1997-07-12', 'Tournavista', 'Comedy', 2);
insert into stars (id, name, photo_id, career, birthday, hometown, genres, total_films) values (7, 'Laney Oles', 11, 'quis', '1983-01-12', 'Urrô', 'Adventure|Comedy|Fantasy', 4);
insert into stars (id, name, photo_id, career, birthday, hometown, genres, total_films) values (8, 'Gallagher Coverley', 12, 'vestibulum', '2005-04-06', 'Seltjarnarnes', 'Documentary', 3);
insert into stars (id, name, photo_id, career, birthday, hometown, genres, total_films) values (9, 'Francklin McRonald', 24, 'dapibus', '1983-11-09', 'Al Jīzah', 'Drama|Romance', 3);
insert into stars (id, name, photo_id, career, birthday, hometown, genres, total_films) values (10, 'Sabra Tole', 9, 'maecenas', '1989-11-15', 'Rancharia', 'Drama', 4);
insert into stars (id, name, photo_id, career, birthday, hometown, genres, total_films) values (11, 'Clarey McLane', 2, 'cursus', '1990-06-10', 'Wangwu', 'Adventure|Sci-Fi', 9);
insert into stars (id, name, photo_id, career, birthday, hometown, genres, total_films) values (12, 'Inger Glentz', 3, 'praesent', '1993-08-22', 'Aldeia de Além', 'Comedy|Romance', 5);
insert into stars (id, name, photo_id, career, birthday, hometown, genres, total_films) values (13, 'Tessie Cadge', 8, 'augue', '2001-11-18', 'Yaroslavskaya', 'Comedy|Thriller', 8);
insert into stars (id, name, photo_id, career, birthday, hometown, genres, total_films) values (14, 'Eloisa Broschke', 13, 'odio', '1988-07-25', 'North Battleford', 'Drama|Mystery', 7);
insert into stars (id, name, photo_id, career, birthday, hometown, genres, total_films) values (15, 'Kimbra Lavender', 27, 'at', '1982-03-25', 'Badaogu', 'Drama|Romance', 2);
insert into stars (id, name, photo_id, career, birthday, hometown, genres, total_films) values (16, 'Cesya Aslett', 1, 'molestie', '1999-07-31', 'Željezno Polje', 'Drama', 5);
insert into stars (id, name, photo_id, career, birthday, hometown, genres, total_films) values (17, 'Haydon Clifft', 30, 'pede', '1998-10-22', 'Kostarea Satu', 'Action|Drama|Sci-Fi|Thriller', 1);
insert into stars (id, name, photo_id, career, birthday, hometown, genres, total_films) values (18, 'Andrey Salazar', 22, 'diam', '1987-02-16', 'Genisséa', 'Crime|Drama|Romance|Thriller', 10);
insert into stars (id, name, photo_id, career, birthday, hometown, genres, total_films) values (19, 'Casper Pym', 20, 'consequat', '1976-09-16', 'Nazca', 'Comedy|Drama|Romance', 7);
insert into stars (id, name, photo_id, career, birthday, hometown, genres, total_films) values (20, 'Petronella Franzelini', 28, 'habitasse', '1972-02-19', 'Peras Ruivas', 'Drama', 7);

insert into movies_stars (movie_id, star_id) values (8, 15);
insert into movies_stars (movie_id, star_id) values (5, 1);
insert into movies_stars (movie_id, star_id) values (10, 8);
insert into movies_stars (movie_id, star_id) values (4, 15);
insert into movies_stars (movie_id, star_id) values (2, 10);
insert into movies_stars (movie_id, star_id) values (9, 10);
insert into movies_stars (movie_id, star_id) values (5, 17);
insert into movies_stars (movie_id, star_id) values (1, 6);
insert into movies_stars (movie_id, star_id) values (9, 12);
insert into movies_stars (movie_id, star_id) values (7, 5);
insert into movies_stars (movie_id, star_id) values (4, 13);
insert into movies_stars (movie_id, star_id) values (3, 14);
insert into movies_stars (movie_id, star_id) values (5, 6);
insert into movies_stars (movie_id, star_id) values (6, 19);
insert into movies_stars (movie_id, star_id) values (7, 3);
insert into movies_stars (movie_id, star_id) values (1, 13);
insert into movies_stars (movie_id, star_id) values (1, 2);
insert into movies_stars (movie_id, star_id) values (10, 15);
insert into movies_stars (movie_id, star_id) values (10, 16);
insert into movies_stars (movie_id, star_id) values (7, 9);
insert into movies_stars (movie_id, star_id) values (2, 2);
insert into movies_stars (movie_id, star_id) values (1, 17);
insert into movies_stars (movie_id, star_id) values (8, 8);
insert into movies_stars (movie_id, star_id) values (8, 14);
insert into movies_stars (movie_id, star_id) values (4, 3);
insert into movies_stars (movie_id, star_id) values (5, 5);
insert into movies_stars (movie_id, star_id) values (9, 4);
insert into movies_stars (movie_id, star_id) values (2, 11);
insert into movies_stars (movie_id, star_id) values (9, 9);
insert into movies_stars (movie_id, star_id) values (8, 18);
insert into movies_stars (movie_id, star_id) values (10, 7);
insert into movies_stars (movie_id, star_id) values (5, 12);
insert into movies_stars (movie_id, star_id) values (2, 8);
insert into movies_stars (movie_id, star_id) values (2, 7);
insert into movies_stars (movie_id, star_id) values (10, 3);
insert into movies_stars (movie_id, star_id) values (8, 16);
insert into movies_stars (movie_id, star_id) values (9, 11);
insert into movies_stars (movie_id, star_id) values (6, 4);
insert into movies_stars (movie_id, star_id) values (9, 6);
insert into movies_stars (movie_id, star_id) values (3, 5);
insert into movies_stars (movie_id, star_id) values (9, 20);
insert into movies_stars (movie_id, star_id) values (5, 9);
insert into movies_stars (movie_id, star_id) values (10, 14);
insert into movies_stars (movie_id, star_id) values (4, 9);
insert into movies_stars (movie_id, star_id) values (5, 4);
insert into movies_stars (movie_id, star_id) values (3, 18);
insert into movies_stars (movie_id, star_id) values (6, 20);
insert into movies_stars (movie_id, star_id) values (7, 19);
insert into movies_stars (movie_id, star_id) values (10, 20);

insert into star_photos (id, filename, star_id) values (1, 'tincidunt', 6);
insert into star_photos (id, filename, star_id) values (2, 'leo', 3);
insert into star_photos (id, filename, star_id) values (3, 'sociis', 14);
insert into star_photos (id, filename, star_id) values (4, 'aliquet', 4);
insert into star_photos (id, filename, star_id) values (5, 'enim', 5);
insert into star_photos (id, filename, star_id) values (6, 'amet', 9);
insert into star_photos (id, filename, star_id) values (7, 'vestibulum', 18);
insert into star_photos (id, filename, star_id) values (8, 'in', 8);
insert into star_photos (id, filename, star_id) values (9, 'elementum', 16);
insert into star_photos (id, filename, star_id) values (10, 'ut', 15);
insert into star_photos (id, filename, star_id) values (11, 'proin', 10);
insert into star_photos (id, filename, star_id) values (12, 'praesent', 17);
insert into star_photos (id, filename, star_id) values (13, 'tristique', 12);
insert into star_photos (id, filename, star_id) values (14, 'ipsum', 19);
insert into star_photos (id, filename, star_id) values (15, 'sapien', 7);
insert into star_photos (id, filename, star_id) values (16, 'ultrices', 13);
insert into star_photos (id, filename, star_id) values (17, 'eget', 1);
insert into star_photos (id, filename, star_id) values (18, 'turpis', 20);
insert into star_photos (id, filename, star_id) values (19, 'sit', 2);
insert into star_photos (id, filename, star_id) values (20, 'commodo', 11);

insert into users (id, nickname, name, mail, birthday, hometown) values (1, 'nisi', 'Reggy Becconsall', 'rbecconsall0@intel.com', '2000-07-24', 'Nyapar');
insert into users (id, nickname, name, mail, birthday, hometown) values (2, 'sed', 'Leila Landor', 'llandor1@thetimes.co.uk', '1980-11-02', 'Sophia Antipolis');
insert into users (id, nickname, name, mail, birthday, hometown) values (3, 'tempus', 'Lynelle Cottey', 'lcottey2@go.com', '1998-04-28', 'Socorro');
insert into users (id, nickname, name, mail, birthday, hometown) values (4, 'morbi', 'Rodie Morritt', 'rmorritt3@ox.ac.uk', '2001-05-25', 'Anjirmuara');
insert into users (id, nickname, name, mail, birthday, hometown) values (5, 'ac', 'Staci Filippazzo', 'sfilippazzo4@google.com.br', '1996-11-26', 'Qionghai');
insert into users (id, nickname, name, mail, birthday, hometown) values (6, 'nec', 'Kiley Madders', 'kmadders5@nymag.com', '1989-01-19', 'Hāfizābād');
insert into users (id, nickname, name, mail, birthday, hometown) values (7, 'cubilia', 'Rocky De Brett', 'rde6@berkeley.edu', '2002-04-20', 'Borek');
insert into users (id, nickname, name, mail, birthday, hometown) values (8, 'quis', 'Joann Huske', 'jhuske7@chron.com', '1987-11-07', 'Triolet');
insert into users (id, nickname, name, mail, birthday, hometown) values (9, 'molestie', 'Amara Bousfield', 'abousfield8@miibeian.gov.cn', '1995-06-28', 'Oslo');
insert into users (id, nickname, name, mail, birthday, hometown) values (10, 'venenatis', 'Marline Brailey', 'mbrailey9@cbslocal.com', '1994-06-15', 'Quipot');
insert into users (id, nickname, name, mail, birthday, hometown) values (11, 'adipiscing', 'Cindelyn Emsley', 'cemsleya@admin.ch', '2001-10-25', 'Manique de Baixo');
insert into users (id, nickname, name, mail, birthday, hometown) values (12, 'consequat', 'Lucilia Screach', 'lscreachb@devhub.com', '1992-03-09', 'Dimovo');
insert into users (id, nickname, name, mail, birthday, hometown) values (13, 'ante', 'Aubert Cass', 'acassc@theatlantic.com', '1984-09-19', 'Shahe');
insert into users (id, nickname, name, mail, birthday, hometown) values (14, 'at', 'Nola Jurs', 'njursd@fc2.com', '2002-12-30', 'Artemivs’k');
insert into users (id, nickname, name, mail, birthday, hometown) values (15, 'in', 'Michel Fallen', 'mfallene@loc.gov', '2009-07-03', 'Molochnoye');
insert into users (id, nickname, name, mail, birthday, hometown) values (16, 'dante', 'Burt Eagleton', 'beagletonf@yandex.ru', '2004-02-19', 'Yaita');
insert into users (id, nickname, name, mail, birthday, hometown) values (17, 'montes', 'Tina Vlasov', 'tvlasovg@stumbleupon.com', '1990-03-18', 'Zhongling');
insert into users (id, nickname, name, mail, birthday, hometown) values (18, 'erat', 'Iseabal Philippart', 'iphilipparth@yale.edu', '2006-11-27', 'Zabłocie');
insert into users (id, nickname, name, mail, birthday, hometown) values (19, 'eget', 'Tades Elcoat', 'telcoati@ning.com', '1981-12-27', 'Tomepampa');
insert into users (id, nickname, name, mail, birthday, hometown) values (20, 'pede', 'Gorden Klulik', 'gklulikj@yale.edu', '1999-01-21', 'Tanguiéta');
insert into users (id, nickname, name, mail, birthday, hometown) values (21, 'turpis', 'Cristal Bradnock', 'cbradnockk@theatlantic.com', '2000-10-12', 'Bendosari');
insert into users (id, nickname, name, mail, birthday, hometown) values (22, 'blandit', 'Gualterio Mourbey', 'gmourbeyl@gizmodo.com', '2007-03-09', 'Altay');
insert into users (id, nickname, name, mail, birthday, hometown) values (23, 'neque', 'Harri Deary', 'hdearym@furl.net', '1985-11-08', 'Timeng');
insert into users (id, nickname, name, mail, birthday, hometown) values (24, 'portus', 'Carie Oliver', 'colivern@icio.us', '2007-11-30', 'Moyuan');
insert into users (id, nickname, name, mail, birthday, hometown) values (25, 'sit', 'Grannie Edmenson', 'gedmensono@cbsnews.com', '2008-03-16', 'Totora');
insert into users (id, nickname, name, mail, birthday, hometown) values (26, 'non', 'Shawn Danilevich', 'sdanilevichp@elegantthemes.com', '2007-03-08', 'Ubajami');
insert into users (id, nickname, name, mail, birthday, hometown) values (27, 'commodo', 'Alexio Alvarado', 'aalvaradoq@unicef.org', '1983-05-31', 'Al Jafr');
insert into users (id, nickname, name, mail, birthday, hometown) values (28, 'id', 'Martina Hairsnape', 'mhairsnaper@imdb.com', '2005-09-11', 'Edsbyn');
insert into users (id, nickname, name, mail, birthday, hometown) values (29, 'nulla', 'Lyn Gerb', 'lgerbs@stumbleupon.com', '1989-08-08', 'Shatki');
insert into users (id, nickname, name, mail, birthday, hometown) values (30, 'ultrices', 'Sherwynd Lees', 'sleest@cdbaby.com', '1997-03-26', 'Sukabumi');

insert into user_ratings (movie_id, user_id, rating) values (4, 3, 8);
insert into user_ratings (movie_id, user_id, rating) values (1, 6, 0);
insert into user_ratings (movie_id, user_id, rating) values (7, 2, 1);
insert into user_ratings (movie_id, user_id, rating) values (8, 25, 6);
insert into user_ratings (movie_id, user_id, rating) values (3, 10, 8);
insert into user_ratings (movie_id, user_id, rating) values (5, 25, 4);
insert into user_ratings (movie_id, user_id, rating) values (7, 5, 6);
insert into user_ratings (movie_id, user_id, rating) values (6, 20, 0);
insert into user_ratings (movie_id, user_id, rating) values (5, 10, 4);
insert into user_ratings (movie_id, user_id, rating) values (3, 28, 1);
insert into user_ratings (movie_id, user_id, rating) values (7, 20, 2);
insert into user_ratings (movie_id, user_id, rating) values (7, 29, 2);
insert into user_ratings (movie_id, user_id, rating) values (8, 10, 1);
insert into user_ratings (movie_id, user_id, rating) values (3, 21, 2);
insert into user_ratings (movie_id, user_id, rating) values (6, 7, 7);
insert into user_ratings (movie_id, user_id, rating) values (6, 4, 7);
insert into user_ratings (movie_id, user_id, rating) values (10, 15, 4);
insert into user_ratings (movie_id, user_id, rating) values (1, 11, 9);
insert into user_ratings (movie_id, user_id, rating) values (10, 4, 4);
insert into user_ratings (movie_id, user_id, rating) values (9, 14, 6);
insert into user_ratings (movie_id, user_id, rating) values (5, 24, 9);
insert into user_ratings (movie_id, user_id, rating) values (4, 19, 3);
insert into user_ratings (movie_id, user_id, rating) values (10, 22, 2);
insert into user_ratings (movie_id, user_id, rating) values (5, 23, 10);
insert into user_ratings (movie_id, user_id, rating) values (3, 13, 1);
insert into user_ratings (movie_id, user_id, rating) values (3, 15, 10);
insert into user_ratings (movie_id, user_id, rating) values (10, 13, 3);
insert into user_ratings (movie_id, user_id, rating) values (6, 28, 10);
insert into user_ratings (movie_id, user_id, rating) values (4, 13, 9);
insert into user_ratings (movie_id, user_id, rating) values (9, 24, 10);
insert into user_ratings (movie_id, user_id, rating) values (9, 26, 7);
insert into user_ratings (movie_id, user_id, rating) values (3, 23, 9);
insert into user_ratings (movie_id, user_id, rating) values (9, 17, 7);
insert into user_ratings (movie_id, user_id, rating) values (1, 26, 6);
insert into user_ratings (movie_id, user_id, rating) values (2, 19, 0);
insert into user_ratings (movie_id, user_id, rating) values (9, 1, 2);
insert into user_ratings (movie_id, user_id, rating) values (10, 6, 4);
insert into user_ratings (movie_id, user_id, rating) values (1, 5, 9);
insert into user_ratings (movie_id, user_id, rating) values (4, 18, 6);
insert into user_ratings (movie_id, user_id, rating) values (4, 12, 4);
insert into user_ratings (movie_id, user_id, rating) values (3, 17, 3);
insert into user_ratings (movie_id, user_id, rating) values (9, 5, 1);
insert into user_ratings (movie_id, user_id, rating) values (9, 29, 10);
insert into user_ratings (movie_id, user_id, rating) values (9, 13, 2);
insert into user_ratings (movie_id, user_id, rating) values (9, 15, 3);
insert into user_ratings (movie_id, user_id, rating) values (3, 8, 2);
insert into user_ratings (movie_id, user_id, rating) values (9, 3, 9);
insert into user_ratings (movie_id, user_id, rating) values (8, 15, 4);
insert into user_ratings (movie_id, user_id, rating) values (8, 4, 0);
insert into user_ratings (movie_id, user_id, rating) values (3, 9, 4);
insert into user_ratings (movie_id, user_id, rating) values (8, 13, 10);
insert into user_ratings (movie_id, user_id, rating) values (4, 7, 0);
insert into user_ratings (movie_id, user_id, rating) values (7, 3, 6);
insert into user_ratings (movie_id, user_id, rating) values (2, 13, 0);
insert into user_ratings (movie_id, user_id, rating) values (4, 22, 6);
insert into user_ratings (movie_id, user_id, rating) values (7, 1, 2);
insert into user_ratings (movie_id, user_id, rating) values (8, 23, 3);
insert into user_ratings (movie_id, user_id, rating) values (7, 7, 8);
insert into user_ratings (movie_id, user_id, rating) values (3, 19, 4);
insert into user_ratings (movie_id, user_id, rating) values (8, 27, 6);
insert into user_ratings (movie_id, user_id, rating) values (2, 20, 4);
insert into user_ratings (movie_id, user_id, rating) values (4, 24, 1);
insert into user_ratings (movie_id, user_id, rating) values (6, 14, 5);
insert into user_ratings (movie_id, user_id, rating) values (7, 22, 1);
insert into user_ratings (movie_id, user_id, rating) values (6, 13, 3);
insert into user_ratings (movie_id, user_id, rating) values (4, 26, 6);
insert into user_ratings (movie_id, user_id, rating) values (6, 5, 1);
insert into user_ratings (movie_id, user_id, rating) values (5, 29, 5);
insert into user_ratings (movie_id, user_id, rating) values (5, 28, 4);
insert into user_ratings (movie_id, user_id, rating) values (8, 12, 10);
insert into user_ratings (movie_id, user_id, rating) values (3, 12, 10);
insert into user_ratings (movie_id, user_id, rating) values (9, 4, 0);
insert into user_ratings (movie_id, user_id, rating) values (8, 7, 1);
insert into user_ratings (movie_id, user_id, rating) values (2, 23, 2);
insert into user_ratings (movie_id, user_id, rating) values (1, 13, 2);
insert into user_ratings (movie_id, user_id, rating) values (8, 9, 1);
insert into user_ratings (movie_id, user_id, rating) values (1, 9, 2);
insert into user_ratings (movie_id, user_id, rating) values (1, 14, 0);
insert into user_ratings (movie_id, user_id, rating) values (3, 25, 0);
insert into user_ratings (movie_id, user_id, rating) values (1, 30, 7);
insert into user_ratings (movie_id, user_id, rating) values (9, 20, 8);
insert into user_ratings (movie_id, user_id, rating) values (5, 13, 2);
insert into user_ratings (movie_id, user_id, rating) values (5, 3, 8);
insert into user_ratings (movie_id, user_id, rating) values (5, 12, 9);
insert into user_ratings (movie_id, user_id, rating) values (4, 30, 8);
insert into user_ratings (movie_id, user_id, rating) values (7, 10, 10);
insert into user_ratings (movie_id, user_id, rating) values (5, 7, 6);
insert into user_ratings (movie_id, user_id, rating) values (9, 6, 6);
insert into user_ratings (movie_id, user_id, rating) values (9, 2, 10);
insert into user_ratings (movie_id, user_id, rating) values (3, 24, 5);
insert into user_ratings (movie_id, user_id, rating) values (5, 16, 9);
insert into user_ratings (movie_id, user_id, rating) values (1, 2, 1);
insert into user_ratings (movie_id, user_id, rating) values (1, 20, 4);
insert into user_ratings (movie_id, user_id, rating) values (5, 5, 3);
insert into user_ratings (movie_id, user_id, rating) values (4, 11, 1);
insert into user_ratings (movie_id, user_id, rating) values (8, 2, 6);
insert into user_ratings (movie_id, user_id, rating) values (4, 14, 8);
insert into user_ratings (movie_id, user_id, rating) values (1, 25, 10);
insert into user_ratings (movie_id, user_id, rating) values (8, 6, 5);
insert into user_ratings (movie_id, user_id, rating) values (2, 18, 7);
insert into user_ratings (movie_id, user_id, rating) values (1, 4, 0);
insert into user_ratings (movie_id, user_id, rating) values (4, 1, 5);
insert into user_ratings (movie_id, user_id, rating) values (6, 12, 4);
insert into user_ratings (movie_id, user_id, rating) values (7, 23, 7);
insert into user_ratings (movie_id, user_id, rating) values (2, 30, 8);
insert into user_ratings (movie_id, user_id, rating) values (8, 1, 0);
insert into user_ratings (movie_id, user_id, rating) values (1, 15, 3);
insert into user_ratings (movie_id, user_id, rating) values (8, 26, 3);
insert into user_ratings (movie_id, user_id, rating) values (1, 3, 0);
insert into user_ratings (movie_id, user_id, rating) values (7, 21, 6);
insert into user_ratings (movie_id, user_id, rating) values (10, 11, 0);
insert into user_ratings (movie_id, user_id, rating) values (2, 1, 2);
insert into user_ratings (movie_id, user_id, rating) values (8, 5, 7);
insert into user_ratings (movie_id, user_id, rating) values (9, 11, 8);
insert into user_ratings (movie_id, user_id, rating) values (3, 27, 8);
insert into user_ratings (movie_id, user_id, rating) values (10, 18, 6);
insert into user_ratings (movie_id, user_id, rating) values (6, 2, 3);
insert into user_ratings (movie_id, user_id, rating) values (1, 1, 0);
insert into user_ratings (movie_id, user_id, rating) values (5, 27, 2);
insert into user_ratings (movie_id, user_id, rating) values (4, 10, 6);
insert into user_ratings (movie_id, user_id, rating) values (3, 18, 5);
insert into user_ratings (movie_id, user_id, rating) values (3, 29, 5);
insert into user_ratings (movie_id, user_id, rating) values (7, 26, 4);
insert into user_ratings (movie_id, user_id, rating) values (6, 11, 4);
insert into user_ratings (movie_id, user_id, rating) values (2, 16, 3);
insert into user_ratings (movie_id, user_id, rating) values (10, 23, 7);
insert into user_ratings (movie_id, user_id, rating) values (5, 8, 0);
insert into user_ratings (movie_id, user_id, rating) values (6, 29, 10);
insert into user_ratings (movie_id, user_id, rating) values (1, 8, 5);
insert into user_ratings (movie_id, user_id, rating) values (1, 29, 2);
insert into user_ratings (movie_id, user_id, rating) values (3, 22, 1);
insert into user_ratings (movie_id, user_id, rating) values (6, 21, 7);
insert into user_ratings (movie_id, user_id, rating) values (4, 28, 3);
insert into user_ratings (movie_id, user_id, rating) values (1, 12, 1);
insert into user_ratings (movie_id, user_id, rating) values (10, 28, 5);
insert into user_ratings (movie_id, user_id, rating) values (2, 3, 8);
insert into user_ratings (movie_id, user_id, rating) values (9, 18, 4);
insert into user_ratings (movie_id, user_id, rating) values (9, 10, 5);
insert into user_ratings (movie_id, user_id, rating) values (7, 28, 3);
insert into user_ratings (movie_id, user_id, rating) values (8, 28, 7);
insert into user_ratings (movie_id, user_id, rating) values (3, 14, 9);
insert into user_ratings (movie_id, user_id, rating) values (3, 7, 0);
insert into user_ratings (movie_id, user_id, rating) values (10, 29, 10);
insert into user_ratings (movie_id, user_id, rating) values (1, 19, 8);
insert into user_ratings (movie_id, user_id, rating) values (2, 12, 1);
insert into user_ratings (movie_id, user_id, rating) values (5, 26, 3);
insert into user_ratings (movie_id, user_id, rating) values (10, 19, 4);
insert into user_ratings (movie_id, user_id, rating) values (7, 24, 9);
insert into user_ratings (movie_id, user_id, rating) values (3, 30, 6);
insert into user_ratings (movie_id, user_id, rating) values (6, 15, 2);

insert into reviews (movie_id, user_id, body, created_at, updated_at) values (5, 17, 'Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat. Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.', '2008-10-07', '2002-07-23');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (2, 17, 'Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis. Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem. Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus. Pellentesque at nulla. Suspendisse potenti.', '2012-11-21', '2009-06-03');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (10, 17, 'Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est. Phasellus sit amet erat. Nulla tempus.', '2010-08-30', '2005-10-17');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (5, 8, 'Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem. Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.', '2010-07-20', '2001-05-30');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (5, 5, 'Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est.', '2007-06-01', '2011-07-28');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (6, 14, 'Morbi vel lectus in quam fringilla rhoncus. Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero. Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.', '2017-07-01', '2015-01-31');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (6, 21, 'Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo. Aliquam quis turpis eget elit sodales scelerisque.', '2013-06-30', '2003-09-25');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (1, 10, 'Mauris lacinia sapien quis libero. Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh. In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam.', '2019-10-19', '2007-08-04');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (8, 22, 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', '2018-01-04', '2012-10-20');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (7, 27, 'In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem. Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit. Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque. Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.', '2017-04-20', '2008-08-04');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (6, 6, 'Nulla mollis molestie lorem. Quisque ut erat. Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.', '2020-10-05', '2019-07-15');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (1, 16, 'Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat. Nulla nisl. Nunc nisl.', '2012-10-17', '2020-08-07');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (8, 23, 'Aenean auctor gravida sem. Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio. Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo.', '2020-05-25', '2014-06-24');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (4, 1, 'Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros. Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat. In congue.', '2016-10-08', '2006-03-19');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (6, 15, 'Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', '2019-09-18', '2016-04-07');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (4, 28, 'Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est. Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum. Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem. Duis aliquam convallis nunc.', '2005-05-19', '2017-01-04');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (1, 1, 'Proin eu mi.', '2004-10-22', '2003-09-17');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (4, 25, 'Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', '2010-11-06', '2004-02-25');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (4, 7, 'Mauris lacinia sapien quis libero. Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh. In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.', '2017-09-30', '2016-10-18');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (2, 2, 'Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros. Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue.', '2001-12-08', '2019-07-08');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (10, 25, 'Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus. Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Etiam vel augue.', '2006-09-19', '2017-11-16');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (2, 11, 'Sed ante. Vivamus tortor. Duis mattis egestas metus. Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est.', '2001-06-08', '2004-11-22');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (8, 16, 'Etiam justo. Etiam pretium iaculis justo. In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus. Nulla ut erat id mauris vulputate elementum.', '2015-11-21', '2009-01-14');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (7, 24, 'Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo.', '2016-05-18', '2012-08-25');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (2, 4, 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit. Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue.', '2010-10-01', '2002-05-07');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (2, 1, 'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti. Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.', '2009-02-09', '2017-08-08');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (10, 16, 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit. Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue.', '2019-09-14', '2014-03-30');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (5, 14, 'Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti. Nullam porttitor lacus at turpis.', '2005-11-04', '2016-02-26');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (1, 18, 'Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros. Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat. In congue.', '2003-11-25', '2005-08-23');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (1, 15, 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros. Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat. In congue. Etiam justo. Etiam pretium iaculis justo. In hac habitasse platea dictumst. Etiam faucibus cursus urna.', '2009-11-27', '2015-01-17');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (8, 5, 'Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc.', '2017-09-08', '2016-02-06');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (8, 30, 'Morbi a ipsum. Integer a nibh. In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.', '2017-12-21', '2011-01-04');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (5, 9, 'Nam dui. Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius. Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.', '2016-04-17', '2015-01-01');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (8, 6, 'Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh. In quis justo. Maecenas rhoncus aliquam lacus.', '2012-01-20', '2020-06-23');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (4, 12, 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue.', '2018-04-18', '2014-08-25');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (4, 11, 'Nullam varius. Nulla facilisi. Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus. Phasellus in felis.', '2003-11-24', '2014-10-07');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (5, 10, 'In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.', '2002-07-05', '2004-12-21');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (7, 16, 'Aliquam erat volutpat. In congue.', '2016-01-19', '2006-03-28');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (7, 15, 'Morbi ut odio. Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.', '2003-02-10', '2003-02-14');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (3, 17, 'Nulla mollis molestie lorem. Quisque ut erat. Curabitur gravida nisi at nibh.', '2011-03-23', '2020-04-23');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (7, 5, 'In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante.', '2013-05-22', '2017-09-10');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (6, 7, 'In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo. Aliquam quis turpis eget elit sodales scelerisque.', '2020-10-23', '2001-10-27');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (8, 7, 'Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus. Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt.', '2014-07-02', '2001-07-23');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (4, 10, 'In hac habitasse platea dictumst.', '2010-04-26', '2018-02-09');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (9, 22, 'Aenean lectus. Pellentesque eget nunc.', '2007-05-03', '2014-09-28');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (10, 13, 'Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat. Praesent blandit. Nam nulla.', '2017-05-02', '2012-11-29');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (3, 10, 'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti. Nullam porttitor lacus at turpis.', '2013-03-13', '2008-06-30');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (5, 30, 'Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam.', '2019-10-14', '2011-04-08');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (6, 16, 'Nullam varius. Nulla facilisi. Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus. Phasellus in felis. Donec semper sapien a libero.', '2011-09-29', '2016-10-29');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (6, 22, 'In sagittis dui vel nisl.', '2002-06-27', '2001-09-24');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (7, 1, 'Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.', '2011-02-02', '2016-01-13');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (3, 27, 'Vivamus in felis eu sapien cursus vestibulum. Proin eu mi. Nulla ac enim.', '2016-03-21', '2012-08-22');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (1, 27, 'Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem. Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio. Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo.', '2001-09-15', '2012-06-21');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (8, 24, 'Praesent lectus. Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis. Duis consequat dui nec nisi volutpat eleifend.', '2012-06-05', '2003-11-01');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (1, 4, 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus. Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio.', '2014-04-16', '2017-11-28');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (1, 3, 'Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros. Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat. In congue. Etiam justo.', '2013-12-14', '2002-04-04');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (5, 6, 'Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti. Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris. Morbi non lectus.', '2006-08-13', '2016-12-28');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (5, 15, 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero. Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh. In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo.', '2004-01-22', '2018-11-11');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (4, 2, 'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat. Curabitur gravida nisi at nibh.', '2002-08-11', '2002-10-02');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (1, 7, 'Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus. Curabitur at ipsum ac tellus semper interdum.', '2003-04-15', '2002-09-26');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (4, 3, 'Aenean auctor gravida sem. Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio. Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', '2018-06-03', '2015-02-03');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (3, 28, 'Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl. Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.', '2007-11-11', '2012-12-08');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (5, 22, 'Etiam justo. Etiam pretium iaculis justo. In hac habitasse platea dictumst. Etiam faucibus cursus urna.', '2010-11-30', '2005-05-18');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (3, 25, 'Morbi a ipsum.', '2013-06-25', '2002-01-10');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (4, 8, 'Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem. Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus. Pellentesque at nulla. Suspendisse potenti.', '2011-10-03', '2010-08-27');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (5, 11, 'Integer non velit. Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque. Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus. In sagittis dui vel nisl. Duis ac nibh.', '2010-09-16', '2003-08-21');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (10, 9, 'Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula.', '2003-05-12', '2016-07-10');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (9, 23, 'Aenean lectus.', '2008-01-19', '2007-01-30');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (9, 19, 'Nunc nisl. Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum. In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.', '2015-01-28', '2020-05-19');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (3, 29, 'Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus. Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Etiam vel augue.', '2002-04-26', '2014-12-28');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (4, 9, 'Integer ac neque. Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus. In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus. Suspendisse potenti. In eleifend quam a odio.', '2005-02-22', '2015-03-23');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (8, 17, 'In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem. Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit. Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue.', '2020-08-01', '2008-03-13');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (5, 13, 'Morbi a ipsum. Integer a nibh.', '2005-02-03', '2011-03-16');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (8, 14, 'Vivamus vel nulla eget eros elementum pellentesque.', '2018-03-04', '2012-08-06');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (3, 18, 'Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus. Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero. Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh. In quis justo. Maecenas rhoncus aliquam lacus.', '2001-02-18', '2001-06-08');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (1, 14, 'Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus. Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat. Curabitur gravida nisi at nibh.', '2015-06-18', '2017-04-15');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (6, 17, 'Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti. Nullam porttitor lacus at turpis.', '2019-05-14', '2018-01-03');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (5, 24, 'Mauris sit amet eros. Suspendisse accumsan tortor quis turpis. Sed ante. Vivamus tortor. Duis mattis egestas metus. Aenean fermentum. Donec ut mauris eget massa tempor convallis.', '2020-04-27', '2009-02-09');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (10, 18, 'Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl. Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est. Phasellus sit amet erat.', '2020-07-12', '2019-04-12');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (3, 30, 'In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat. Nulla nisl. Nunc nisl. Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa.', '2001-03-24', '2016-01-13');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (9, 20, 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti. Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris. Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.', '2009-04-08', '2008-12-17');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (5, 2, 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros. Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat. In congue. Etiam justo. Etiam pretium iaculis justo. In hac habitasse platea dictumst. Etiam faucibus cursus urna.', '2003-07-19', '2014-12-26');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (9, 3, 'Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam.', '2015-05-07', '2020-10-29');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (9, 17, 'Vivamus in felis eu sapien cursus vestibulum. Proin eu mi.', '2005-07-26', '2019-01-17');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (2, 24, 'Aenean lectus. Pellentesque eget nunc.', '2016-09-27', '2015-02-16');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (7, 28, 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est.', '2014-02-26', '2008-02-11');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (3, 19, 'Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat. In congue. Etiam justo. Etiam pretium iaculis justo. In hac habitasse platea dictumst.', '2005-12-09', '2012-12-04');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (4, 20, 'Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi. Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla.', '2011-11-04', '2017-11-17');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (9, 12, 'Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien.', '2008-02-15', '2001-04-20');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (3, 1, 'Fusce consequat. Nulla nisl. Nunc nisl. Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa.', '2011-01-31', '2008-02-22');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (7, 12, 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero. Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh. In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo.', '2007-08-17', '2012-10-24');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (10, 23, 'Aliquam non mauris. Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis. Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem. Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.', '2010-01-07', '2012-09-12');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (4, 29, 'Suspendisse potenti. Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', '2015-03-12', '2006-08-04');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (6, 5, 'Nunc nisl. Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum. In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.', '2017-03-14', '2000-12-04');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (7, 17, 'Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum. Proin eu mi. Nulla ac enim.', '2016-09-12', '2016-05-02');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (3, 2, 'Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est. Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum. Proin eu mi. Nulla ac enim.', '2018-01-08', '2005-05-28');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (6, 8, 'Donec semper sapien a libero. Nam dui. Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius. Integer ac leo. Pellentesque ultrices mattis odio.', '2002-04-24', '2008-03-23');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (9, 30, 'Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla.', '2000-11-19', '2012-06-01');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (5, 16, 'Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem. Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus. Pellentesque at nulla.', '2005-04-04', '2004-09-20');
insert into reviews (movie_id, user_id, body, created_at, updated_at) values (6, 13, 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem. Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo.', '2013-11-24', '2008-02-06');

insert into awards (id, name) values (1, 'et');
insert into awards (id, name) values (2, 'at');
insert into awards (id, name) values (3, 'diam');
insert into awards (id, name) values (4, 'consequat');
insert into awards (id, name) values (5, 'id');
insert into awards (id, name) values (6, 'duis');

insert into movie_awards (award_id, movie_id) values (6, 7);
insert into movie_awards (award_id, movie_id) values (5, 5);
insert into movie_awards (award_id, movie_id) values (4, 9);
insert into movie_awards (award_id, movie_id) values (4, 4);
insert into movie_awards (award_id, movie_id) values (6, 8);
insert into movie_awards (award_id, movie_id) values (5, 6);
insert into movie_awards (award_id, movie_id) values (6, 2);
insert into movie_awards (award_id, movie_id) values (2, 5);
insert into movie_awards (award_id, movie_id) values (3, 7);
insert into movie_awards (award_id, movie_id) values (2, 8);
insert into movie_awards (award_id, movie_id) values (4, 10);
insert into movie_awards (award_id, movie_id) values (1, 3);
insert into movie_awards (award_id, movie_id) values (3, 8);
insert into movie_awards (award_id, movie_id) values (3, 6);
insert into movie_awards (award_id, movie_id) values (2, 2);
insert into movie_awards (award_id, movie_id) values (1, 7);
insert into movie_awards (award_id, movie_id) values (1, 4);
insert into movie_awards (award_id, movie_id) values (6, 9);
insert into movie_awards (award_id, movie_id) values (1, 1);
insert into movie_awards (award_id, movie_id) values (4, 8);

/*alter table movies 
add foreign key (poster_id) references posters(id);*/

/*alter table movies movies
add foreign key (trailer_id) references trailers(id);*/

-- Выборка показывает награды и фильмы.

select a.id as award_id, a.name as award, m.title as movie from awards a 
join movie_awards ma
join movies m
	on a.id = ma.award_id
    where ma.movie_id = m.id;

-- Представвление с актерскими составами фильмов.

CREATE VIEW Movies_cast AS 
select m.id, m.title, cast.cast from movies m
join 
	(select m.id as id, group_concat(s.name) as cast from movies m
		join stars s
		join movies_stars ms
			on s.id = ms.star_id
			where ms.movie_id = m.id
			group by m.id) as cast
	on m.id = cast.id;
    
select * from Movies_cast;

-- Представление с рейтингом фильма с сортировкой по рейтингу
CREATE VIEW Rating AS 
select m.id, m.title, avg(r.rating) as rating from user_ratings r
join movies m
	where r.movie_id = m.id
    group by title
    order by rating desc;

select * from rating;