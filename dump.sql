--

-- PostgreSQL database dump

--

-- Dumped from database version 14.3

-- Dumped by pg_dump version 14.3

SET statement_timeout = 0;

SET lock_timeout = 0;

SET idle_in_transaction_session_timeout = 0;

SET client_encoding = 'UTF8';

SET standard_conforming_strings = on;

SELECT pg_catalog.set_config('search_path', '', false);

SET check_function_bodies = false;

SET xmloption = content;

SET client_min_messages = warning;

SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--

-- Name: ads; Type: TABLE; Schema: public; Owner: admin

--

CREATE TABLE
    public.ads (
        id integer NOT NULL,
        name character varying(255) NOT NULL,
        comment
            text,
            "timeOfLife" character varying(255) NOT NULL,
            author character varying(255) NOT NULL,
            translate boolean DEFAULT false NOT NULL
    );

ALTER TABLE public.ads OWNER TO admin;

--

-- Name: COLUMN ads."timeOfLife"; Type: COMMENT; Schema: public; Owner: admin

--

COMMENT
    ON COLUMN public.ads."timeOfLife" IS 'Момент (время + дата), по достижении  которого объявление будет автоматически удалено. ';

--

-- Name: ads_id_seq; Type: SEQUENCE; Schema: public; Owner: admin

--

ALTER TABLE public.ads
ALTER COLUMN id
ADD
    GENERATED ALWAYS AS IDENTITY (
        SEQUENCE NAME public.ads_id_seq START
        WITH
            1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1
    );

--

-- Name: ec_role; Type: TABLE; Schema: public; Owner: admin

--

CREATE TABLE
    public.ec_role (
        id integer NOT NULL,
        role character varying(255)
    );

ALTER TABLE public.ec_role OWNER TO admin;

--

-- Name: ec_role_id_seq; Type: SEQUENCE; Schema: public; Owner: admin

--

CREATE SEQUENCE
    public.ec_role_id_seq AS integer START
WITH
    1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;

ALTER TABLE public.ec_role_id_seq OWNER TO admin;

--

-- Name: ec_role_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin

--

ALTER SEQUENCE public.ec_role_id_seq OWNED BY public.ec_role.id;

--

-- Name: ec_user; Type: TABLE; Schema: public; Owner: admin

--

CREATE TABLE
    public.ec_user (
        id integer NOT NULL,
        name character varying(255) NOT NULL,
        role character varying(255) NOT NULL,
        passhash character varying(255) NOT NULL
    );

ALTER TABLE public.ec_user OWNER TO admin;

--

-- Name: ec_user_id_seq; Type: SEQUENCE; Schema: public; Owner: admin

--

CREATE SEQUENCE
    public.ec_user_id_seq AS integer START
WITH
    1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;

ALTER TABLE public.ec_user_id_seq OWNER TO admin;

--

-- Name: ec_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin

--

ALTER SEQUENCE public.ec_user_id_seq OWNED BY public.ec_user.id;

--

-- Name: events; Type: TABLE; Schema: public; Owner: admin

--

CREATE TABLE
    events (
        id SERIAL PRIMARY KEY,
        name character varying NOT NULL,
        src character varying NOT NULL,
        "isActive" boolean DEFAULT true NOT NULL,
        type integer NOT NULL,
        "time" integer NOT NULL,
        "order" integer NOT NULL,
        FOREIGN KEY (id) REFERENCES events_tmp (id)
    );

ALTER TABLE public.events OWNER TO admin;

--

-- Name: events_cur; Type: TABLE; Schema: public; Owner: admin

--

CREATE TABLE
    events_req_form (
        id SERIAL PRIMARY KEY,
        "name" character varying(50) NOT NULL,
        "comment" TEXT,
        "date" character varying(10) NOT NULL,
        "isspecial" BOOLEAN NOT NULL,
        "author" character varying(20) NOT NULL,
        "lesson" character varying(30) NOT NULL,
        "break" character varying(30) NOT NULL,
        "lunch" character varying(30) NOT NULL,
        "screen" INTEGER,
        "isAccepted" BOOLEAN NOT NULL
    );

CREATE TABLE
    tmp (
        id SERIAL PRIMARY KEY,
        name character varying(30) NOT NULL,
        author character varying(20) NOT NULL,
        isPrivate BOOLEAN NOT NULL
    );

ALTER TABLE public.events_cur OWNER TO admin;

--

-- Name: COLUMN events_cur."group"; Type: COMMENT; Schema: public; Owner: admin

--

COMMENT
    ON COLUMN public.events_cur."group" IS 'classes (занятия) / break (перерыв) /  bigbreak (обед) / special (особый)';

--

-- Name: COLUMN events_cur.author; Type: COMMENT; Schema: public; Owner: admin

--

COMMENT
    ON COLUMN public.events_cur.author IS 'Автор шаблона (кто отправил на утверждение)';

--

-- Name: events_id_seq; Type: SEQUENCE; Schema: public; Owner: admin

--

CREATE SEQUENCE
    public.events_id_seq AS integer START
WITH
    1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;

ALTER TABLE public.events_id_seq OWNER TO admin;

--

-- Name: events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin

--

ALTER SEQUENCE public.events_id_seq OWNED BY public.events.id;

--

-- Name: events_tmp; Type: TABLE; Schema: public; Owner: admin

--

CREATE TABLE
    events_tmp (
        id SERIAL PRIMARY KEY,
        name character varying(50) NOT NULL,
        src text NOT NULL,
        "isActive" boolean NOT NULL,
        type integer NOT NULL,
        "time" integer NOT NULL,
        "order" integer NOT NULL,
        tmpId SERIAL NOT NULL,
        FOREIGN KEY (tmpId) REFERENCES tmp (id)
    );

ALTER TABLE public.events_tmp OWNER TO admin;

--

-- Name: log; Type: TABLE; Schema: public; Owner: admin

--

CREATE TABLE
    log (
        id SERIAL PRIMARY KEY,
        object character varying(255) NOT NULL,
        type integer,
        username character varying(255) NOT NULL,
        date character varying(255) NOT NULL,
        "time" character varying(255) NOT NULL,
        e_group integer,
        name character varying(255),
        e_name_e character varying(255),
        e_src_type_s character varying(255),
        e_src_type_e character varying(255),
        e_src_s character varying(255),
        e_src_e character varying(255),
        e_timing_s integer,
        e_timing_e integer,
        a_author character varying(255),
        a_comment character varying(255),
        a_timeout timestamp without time zone,
        a_isauto boolean,
        a_translate boolean
    );

ALTER TABLE public.log OWNER TO admin;

--

-- Name: COLUMN log.object; Type: COMMENT; Schema: public; Owner: admin

--

COMMENT
    ON COLUMN public.log.object IS 'Объект, действие над которым логгируется (событие, объявление ...)';

--

-- Name: COLUMN log.type; Type: COMMENT; Schema: public; Owner: admin

--

COMMENT
    ON COLUMN public.log.type IS '0 - delete; 1 - add; 2 - update.';

--

-- Name: COLUMN log.username; Type: COMMENT; Schema: public; Owner: admin

--

COMMENT
    ON COLUMN public.log.username IS 'Какой негодняй это делает?';

--

-- Name: COLUMN log.date; Type: COMMENT; Schema: public; Owner: admin

--

COMMENT ON COLUMN public.log.date IS 'Когда?';

--

-- Name: COLUMN log."time"; Type: COMMENT; Schema: public; Owner: admin

--

COMMENT ON COLUMN public.log."time" IS 'Во сколько?';

--

-- Name: COLUMN log.e_group; Type: COMMENT; Schema: public; Owner: admin

--

COMMENT
    ON COLUMN public.log.e_group IS 'СОБЫТИЕ: Группировка действий с событиями в "БОЛЬШИЕ логи"';

--

-- Name: COLUMN log.name; Type: COMMENT; Schema: public; Owner: admin

--

COMMENT ON COLUMN public.log.name IS 'Имя события (нач) / Заголовок';

--

-- Name: COLUMN log.e_name_e; Type: COMMENT; Schema: public; Owner: admin

--

COMMENT
    ON COLUMN public.log.e_name_e IS 'СОБЫТИЕ: Имя события после изменения (Если это Update)';

--

-- Name: COLUMN log.e_src_type_s; Type: COMMENT; Schema: public; Owner: admin

--

COMMENT
    ON COLUMN public.log.e_src_type_s IS 'СОБЫТИЕ: Тип события (нач)';

--

-- Name: COLUMN log.e_src_type_e; Type: COMMENT; Schema: public; Owner: admin

--

COMMENT
    ON COLUMN public.log.e_src_type_e IS 'СОБЫТИЕ: Тип события (кон)';

--

-- Name: COLUMN log.e_src_s; Type: COMMENT; Schema: public; Owner: admin

--

COMMENT
    ON COLUMN public.log.e_src_s IS 'СОБЫТИЕ: Ссылка на ресурс (нач)';

--

-- Name: COLUMN log.e_src_e; Type: COMMENT; Schema: public; Owner: admin

--

COMMENT
    ON COLUMN public.log.e_src_e IS 'СОБЫТИЕ: Ссылка на ресурс (кон)';

--

-- Name: COLUMN log.e_timing_s; Type: COMMENT; Schema: public; Owner: admin

--

COMMENT ON COLUMN public.log.e_timing_s IS 'СОБЫТИЕ: Тайминг (нач)';

--

-- Name: COLUMN log.e_timing_e; Type: COMMENT; Schema: public; Owner: admin

--

COMMENT ON COLUMN public.log.e_timing_e IS 'СОБЫТИЕ: Тайминг (кон)';

--

-- Name: COLUMN log.a_author; Type: COMMENT; Schema: public; Owner: admin

--

COMMENT ON COLUMN public.log.a_author IS 'ОБЪЯВЛЕНИЕ: Автор';

--

-- Name: COLUMN log.a_comment; Type: COMMENT; Schema: public; Owner: admin

--

COMMENT ON COLUMN public.log.a_comment IS 'Текст объявления';

--

-- Name: COLUMN log.a_timeout; Type: COMMENT; Schema: public; Owner: admin

--

COMMENT
    ON COLUMN public.log.a_timeout IS 'ОБЪЯВЛЕНИЕ: Дата + время, до которых актуально событие';

--

-- Name: COLUMN log.a_isauto; Type: COMMENT; Schema: public; Owner: admin

--

COMMENT
    ON COLUMN public.log.a_isauto IS 'ОБЪЯВЛЕНИЕ: Было удалено автоматически системой.';

--

-- Name: COLUMN log.a_translate; Type: COMMENT; Schema: public; Owner: admin

--

COMMENT
    ON COLUMN public.log.a_translate IS 'ОБЪЯВЛЕНИЕ: Вывод на трансляцию';

--

-- Name: log_id_seq; Type: SEQUENCE; Schema: public; Owner: admin

--

ALTER TABLE public.log
ALTER COLUMN id
ADD
    GENERATED ALWAYS AS IDENTITY (
        SEQUENCE NAME public.log_id_seq START
        WITH
            1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1
    );

--

-- Name: table_name_id_seq; Type: SEQUENCE; Schema: public; Owner: admin

--

CREATE SEQUENCE
    public.table_name_id_seq START
WITH
    1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;

ALTER TABLE public.table_name_id_seq OWNER TO admin;

--

-- Name: tokens; Type: TABLE; Schema: public; Owner: admin

--

CREATE TABLE
    public.tokens (
        id integer NOT NULL,
        user_id integer NOT NULL,
        role character varying(100) NOT NULL,
        token character varying(300) NOT NULL
    );

ALTER TABLE public.tokens OWNER TO admin;

--

-- Name: tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: admin

--

CREATE SEQUENCE
    public.tokens_id_seq AS integer START
WITH
    1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;

ALTER TABLE public.tokens_id_seq OWNER TO admin;

--

-- Name: tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin

--

ALTER SEQUENCE public.tokens_id_seq OWNED BY public.tokens.id;

--

-- Name: user_ads; Type: TABLE; Schema: public; Owner: admin

--

CREATE TABLE
    public.user_ads (
        id integer NOT NULL,
        ads_id integer DEFAULT 0 NOT NULL,
        user_id integer DEFAULT 0 NOT NULL
    );

ALTER TABLE public.user_ads OWNER TO admin;

--

-- Name: user_ads_id_seq; Type: SEQUENCE; Schema: public; Owner: admin

--

ALTER TABLE public.user_ads
ALTER COLUMN id
ADD
    GENERATED ALWAYS AS IDENTITY (
        SEQUENCE NAME public.user_ads_id_seq START
        WITH
            1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1
    );

--

-- Name: ec_role id; Type: DEFAULT; Schema: public; Owner: admin

--

ALTER TABLE ONLY public.ec_role
ALTER COLUMN id
SET
    DEFAULT nextval(
        'public.ec_role_id_seq' :: regclass
    );

--

-- Name: ec_user id; Type: DEFAULT; Schema: public; Owner: admin

--

ALTER TABLE ONLY public.ec_user
ALTER COLUMN id
SET
    DEFAULT nextval(
        'public.ec_user_id_seq' :: regclass
    );

--

-- Name: tokens id; Type: DEFAULT; Schema: public; Owner: admin

--

ALTER TABLE ONLY public.tokens
ALTER COLUMN id
SET
    DEFAULT nextval(
        'public.tokens_id_seq' :: regclass
    );

--

-- Data for Name: ads; Type: TABLE DATA; Schema: public; Owner: admin

--

COPY public.ads (
        id, name,
        comment
,
            "timeOfLife",
            author,
            translate
    )
FROM stdin;

77	fisting	ass	2023-02-05	admin	f
\.


--
-- Data for Name: ec_role; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.ec_role (id, role) FROM stdin;

1	admin
2	moder
3	adsender
4	editor
\.


--
-- Data for Name: ec_user; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.ec_user (id, name, role, passhash) FROM stdin;

34 malashin moder $argon2id$v=19$m=65536,t=3,p=4$EMw7QaZKMtbA86Xus409jA$634WgxUocMJbmTq0pTNfp6uHYMrhVV6WMcxRywq6Zeg
41	brigade1	editor	$argon2id$ v = 19 $m = 65536,
t = 3,
p = 4 $eNBP1 + 32 lB9zk3LddxlcFQ$ + q5RJeBGO8KddvVGgKd6dzPt3qfbh + tP3BD4hw6jutg 48 admin admin $argon2id$v=19$m=65536,t=3,p=4$C8q5Dheb0rc+8KcvD7sDDA$oZOsLHVpqSN8iGvWEFMoIjJBp4IcYfWTe9JvVaLZUrE
22	admin1	admin	$2b$08$MuwagbtN08lE0QRF3JaGvOXcUKqyBJURk8Rf2wg0Wl82RHCoDcNDW
49	lapashina	adsender	$argon2id$ v = 19 $m = 65536,
t = 3,
p = 4 $FBf0YrIsbS3pRbzlbVPjiQ$rPXpgT8t7+zSMJXzXCAnckCvamII9KKnhCozgwRlTec
\.


--
-- Data for Name: events; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.events (id, name, src, "isActive", type, "time", "order") FROM stdin;

\.


--
-- Data for Name: events_cur; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.events_cur (id, name, src, "isActive", type, "time", "order", "group", author) FROM stdin;

\.


--
-- Data for Name: events_tmp; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.events_tmp (id, name, src, "isActive", type, "time", "order", "group", author, "isPrivate") FROM stdin;

\.


--
-- Data for Name: log; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.log (id, object, type, username, date, "time", e_group, name, e_name_e, e_src_type_s, e_src_type_e, e_src_s, e_src_e, e_timing_s, e_timing_e, a_author, a_comment, a_timeout, a_isauto, a_translate) FROM stdin;

\.


--
-- Data for Name: tokens; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.tokens (id, user_id, role, token) FROM stdin;

\.


--
-- Data for Name: user_ads; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.user_ads (id, ads_id, user_id) FROM stdin;

156	77	48
158	77	41
160	77	49
\.


--
-- Name: ads_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.ads_id_seq', 78, true);

--

-- Name: ec_role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin

--

SELECT pg_catalog.setval('public.ec_role_id_seq', 1, false);

--

-- Name: ec_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin

--

SELECT pg_catalog.setval('public.ec_user_id_seq', 49, true);

--

-- Name: events_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin

--

SELECT pg_catalog.setval('public.events_id_seq', 359, true);

--

-- Name: log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin

--

SELECT pg_catalog.setval('public.log_id_seq', 196, true);

--

-- Name: table_name_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin

--

SELECT pg_catalog.setval('public.table_name_id_seq', 1, false);

--

-- Name: tokens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin

--

SELECT pg_catalog.setval('public.tokens_id_seq', 1, false);

--

-- Name: user_ads_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin

--

SELECT pg_catalog.setval('public.user_ads_id_seq', 161, true);

--

-- Name: ads ads_pkey; Type: CONSTRAINT; Schema: public; Owner: admin

--

ALTER TABLE ONLY public.ads
ADD
    CONSTRAINT ads_pkey PRIMARY KEY (id);

--

-- Name: ec_role ec_role_pkey; Type: CONSTRAINT; Schema: public; Owner: admin

--

ALTER TABLE ONLY public.ec_role
ADD
    CONSTRAINT ec_role_pkey PRIMARY KEY (id);

--

-- Name: ec_user ec_user_pkey; Type: CONSTRAINT; Schema: public; Owner: admin

--

ALTER TABLE ONLY public.ec_user
ADD
    CONSTRAINT ec_user_pkey PRIMARY KEY (id);

--

-- Name: events_cur events_cur_pkey; Type: CONSTRAINT; Schema: public; Owner: admin

--

ALTER TABLE
    ONLY public.events_cur
ADD
    CONSTRAINT events_cur_pkey PRIMARY KEY (id);

--

-- Name: events events_pk; Type: CONSTRAINT; Schema: public; Owner: admin

--

ALTER TABLE ONLY public.events
ADD
    CONSTRAINT events_pk PRIMARY KEY (id);

--

-- Name: events_tmp events_tmp_pkey; Type: CONSTRAINT; Schema: public; Owner: admin

--

ALTER TABLE
    ONLY public.events_tmp
ADD
    CONSTRAINT events_tmp_pkey PRIMARY KEY (id);

--

-- Name: log log_pkey; Type: CONSTRAINT; Schema: public; Owner: admin

--

ALTER TABLE ONLY public.log
ADD
    CONSTRAINT log_pkey PRIMARY KEY (id);

--

-- Name: tokens tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: admin

--

ALTER TABLE ONLY public.tokens
ADD
    CONSTRAINT tokens_pkey PRIMARY KEY (id);

--

-- Name: user_ads user_ads_pkey; Type: CONSTRAINT; Schema: public; Owner: admin

--

ALTER TABLE
    ONLY public.user_ads
ADD
    CONSTRAINT user_ads_pkey PRIMARY KEY (id);

--

-- PostgreSQL database dump complete

--