create table if not exists roles(
	id SERIAL primary key,
	code text,
	label text
);

insert into roles(code,label) values('admin', 'Администратор'),('manager', 'Руководитель'),('employee', 'Сотрудник');

create table if not exists users(
	id SERIAL primary key,
	login text,
	pass text,
	fio text,
	id_role INT REFERENCES roles (id),
	is_blocked INT default 0
);

insert into users(login, pass,fio,id_role,is_blocked) values
('admin', '098f6bcd4621d373cade4e832627b4f6', 'Тестовый Администратор', 1, 0),
('manager', '098f6bcd4621d373cade4e832627b4f6', 'Тестовый Руководитель', 2, 0),
('employee', '098f6bcd4621d373cade4e832627b4f6', 'Тестовый Сотрудник', 3, 0);

create table if not exists clients(
	id SERIAL primary key,
	label TEXT
);

insert into clients(label) values('Тестовый клиент');

create table if not exists order_statuses(
	id SERIAL primary key,
	label TEXT
);

insert into order_statuses(label) values
(10, 'Проект'),
(20, 'В работе'),
(30, 'Завершён');

create table if not exists orders(
	id SERIAL primary key,
	label TEXT,
	id_status INT NOT NULL DEFAULT 10,
	id_client INT REFERENCES clients(id),
	amount NUMERIC(20,2)
);

create table if not exists order_items(
	id SERIAL primary key,
	label TEXT,
	id_order INT REFERENCES orders(id),
	amount NUMERIC(20,2)
);

create table if not exists payment_types(
	id SERIAL primary key,
	label TEXT
);

insert into payment_types(label) values
(10, 'Аванс'),
(20, 'Основной');

create table if not exists payments(
	id SERIAL primary key,
	id_order INT,
	id_payment_type INT REFERENCES payment_types(id),
	amount NUMERIC(20,2)
);