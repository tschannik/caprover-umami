CREATE TABLE migrations (
    id serial PRIMARY KEY,
    name varchar(255) UNIQUE NOT NULL
);

CREATE TABLE account (
    user_id serial PRIMARY KEY,
    username varchar(255) UNIQUE NOT NULL,
    PASSWORD varchar(60) NOT NULL,
    is_admin bool NOT NULL DEFAULT false,
    created_at timestamp WITH time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp WITH time zone DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE website (
    website_id serial PRIMARY KEY,
    website_uuid uuid UNIQUE NOT NULL,
    user_id int NOT NULL REFERENCES account(user_id) ON DELETE CASCADE,
    name varchar(100) NOT NULL,
    domain varchar(500),
    share_id varchar(64) UNIQUE,
    created_at timestamp WITH time zone DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE SESSION (
    session_id serial PRIMARY KEY,
    session_uuid uuid UNIQUE NOT NULL,
    website_id int NOT NULL REFERENCES website(website_id) ON DELETE CASCADE,
    created_at timestamp WITH time zone DEFAULT CURRENT_TIMESTAMP,
    hostname varchar(100),
    browser varchar(20),
    os varchar(20),
    device varchar(20),
    screen varchar(11),
    language varchar(35),
    country char(2)
);

CREATE TABLE pageview (
    view_id serial PRIMARY KEY,
    website_id int NOT NULL REFERENCES website(website_id) ON DELETE CASCADE,
    session_id int NOT NULL REFERENCES SESSION(session_id) ON DELETE CASCADE,
    created_at timestamp WITH time zone DEFAULT CURRENT_TIMESTAMP,
    url varchar(500) NOT NULL,
    referrer varchar(500)
);

CREATE TABLE event (
    event_id serial PRIMARY KEY,
    website_id int NOT NULL REFERENCES website(website_id) ON DELETE CASCADE,
    session_id int NOT NULL REFERENCES SESSION(session_id) ON DELETE CASCADE,
    created_at timestamp WITH time zone DEFAULT CURRENT_TIMESTAMP,
    url varchar(500) NOT NULL,
    event_type varchar(50) NOT NULL,
    event_value varchar(50) NOT NULL
);

CREATE INDEX website_user_id_idx ON website(user_id);

CREATE INDEX session_created_at_idx ON SESSION(created_at);

CREATE INDEX session_website_id_idx ON SESSION(website_id);

CREATE INDEX pageview_created_at_idx ON pageview(created_at);

CREATE INDEX pageview_website_id_idx ON pageview(website_id);

CREATE INDEX pageview_session_id_idx ON pageview(session_id);

CREATE INDEX pageview_website_id_created_at_idx ON pageview(website_id, created_at);

CREATE INDEX pageview_website_id_session_id_created_at_idx ON pageview(website_id, session_id, created_at);

CREATE INDEX event_created_at_idx ON event(created_at);

CREATE INDEX event_website_id_idx ON event(website_id);

CREATE INDEX event_session_id_idx ON event(session_id);

INSERT INTO
    account (username, PASSWORD, is_admin)
VALUES
    (
        'admin',
        '$2b$10$BUli0c.muyCW1ErNJc3jL.vFRFtFJWrT8/GcR4A.sUdCznaXiqFXa',
        TRUE
    );

INSERT INTO
    migrations (name)
VALUES
    ('initial');