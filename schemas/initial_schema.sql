CREATE SCHEMA IF NOT EXISTS chat;

CREATE TABLE IF NOT EXISTS chat.user (
	id				SERIAL PRIMARY KEY,
	username		TEXT(16) NOT NULL,
	password_hash	TEXT NOT NULL,
	email			TEXT(64) NOT NULL,
	phone_number	TEXT(12),
	is_admin		BOOLEAN NOT NULL,
	last_login		TIMESTAMP,
	created_at		TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS chat.server (
	id				SERIAL PRIMARY KEY,
	name			TEXT(16) NOT NULL,
	location		TEXT NOT NULL,
	owner_user_id	BIGINT UNSIGNED NOT NULL,
	created_at		TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	
	FOREIGN KEY (owner_user_id) REFERENCES chat.user (id)
);

CREATE TABLE IF NOT EXISTS chat.channel (
	id				SERIAL PRIMARY KEY,
	name			TEXT(16) NOT NULL,
	server_id		BIGINT UNSIGNED NOT NULL,
	category_id		BIGINT UNSIGNED,
	created_at		TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

	FOREIGN KEY (server_id) REFERENCES chat.server (id),
	FOREIGN KEY (category_id) REFERENCES chat.category (id)
);

CREATE TABLE IF NOT EXISTS chat.message (
	id				SERIAL PRIMARY KEY,
	user_id			BIGINT UNSIGNED NOT NULL,
	channel_id		BIGINT UNSIGNED NOT NULL,
	created_at		TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	content			TEXT(2000) NOT NULL,

	FOREIGN KEY (user_id) REFERENCES chat.user (id),
	FOREIGN KEY (channel_id) REFERENCES chat.channel (id)
);

CREATE TABLE IF NOT EXISTS chat.category (
	id				SERIAL PRIMARY KEY,
	name			TEXT(16) NOT NULL
);

CREATE TABLE IF NOT EXISTS chat.server_member (
	id				SERIAL PRIMARY KEY,
	user_id			BIGINT UNSIGNED NOT NULL,
	server_id		BIGINT UNSIGNED NOT NULL,
	joined_at		TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

	FOREIGN KEY (user_id) REFERENCES chat.user (id),
	FOREIGN KEY (server_id) REFERENCES chat.server (id)
);

CREATE TABLE IF NOT EXISTS chat.role (
	id				SERIAL PRIMARY KEY,
	name			TEXT NOT NULL,
	server_id		BIGINT UNSIGNED NOT NULL,

	FOREIGN KEY (server_id) REFERENCES chat.server (id)
);

CREATE TABLE IF NOT EXISTS chat.permission (
	id				SERIAL PRIMARY KEY,
	name			TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS chat.role_permission (
	id				SERIAL PRIMARY KEY,
	role_id			BIGINT UNSIGNED NOT NULL,
	permission_id	BIGINT UNSIGNED NOT NULL,
	state			TINYINT NOT NULL,

	FOREIGN KEY (role_id) REFERENCES chat.role (id),
	FOREIGN KEY (permission_id) REFERENCES chat.permission (id)
);

CREATE TABLE IF NOT EXISTS chat.server_member_role (
	id				SERIAL PRIMARY KEY,
	member_id		BIGINT UNSIGNED NOT NULL,
	role_id			BIGINT UNSIGNED NOT NULL,

	FOREIGN KEY (member_id) REFERENCES chat.server_member (id),
	FOREIGN KEY (role_id) REFERENCES chat.role (id)
);

CREATE TABLE IF NOT EXISTS chat.channel_role (
	id				SERIAL PRIMARY KEY,
	channel_id		BIGINT UNSIGNED NOT NULL,
	role_id			BIGINT UNSIGNED NOT NULL,

	FOREIGN KEY (channel_id) REFERENCES chat.channel (id),
	FOREIGN KEY (role_id) REFERENCES chat.role (id)
);