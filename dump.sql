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

CREATE TABLE public.ads (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    comment text,
    "timeOfLife" character varying(255) NOT NULL,
    author character varying(255) NOT NULL,
    translate boolean DEFAULT false NOT NULL
);


ALTER TABLE public.ads OWNER TO admin;

--
-- Name: COLUMN ads."timeOfLife"; Type: COMMENT; Schema: public; Owner: admin
--

COMMENT ON COLUMN public.ads."timeOfLife" IS 'Момент (время + дата), по достижении  которого объявление будет автоматически удалено. ';


--
-- Name: ads_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

ALTER TABLE public.ads ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.ads_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: ec_role; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.ec_role (
    id integer NOT NULL,
    role character varying(255)
);


ALTER TABLE public.ec_role OWNER TO admin;

--
-- Name: ec_role_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.ec_role_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ec_role_id_seq OWNER TO admin;

--
-- Name: ec_role_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public.ec_role_id_seq OWNED BY public.ec_role.id;


--
-- Name: ec_user; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.ec_user (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    role character varying(255) NOT NULL,
    passhash character varying(255) NOT NULL
);


ALTER TABLE public.ec_user OWNER TO admin;

--
-- Name: ec_user_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.ec_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ec_user_id_seq OWNER TO admin;

--
-- Name: ec_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public.ec_user_id_seq OWNED BY public.ec_user.id;


--
-- Name: events; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.events (
    id integer NOT NULL,
    name character varying NOT NULL,
    src character varying NOT NULL,
    "isActive" boolean DEFAULT true NOT NULL,
    type integer NOT NULL,
    "time" integer NOT NULL,
    "order" integer NOT NULL
);


ALTER TABLE public.events OWNER TO admin;

--
-- Name: events_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.events_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.events_id_seq OWNER TO admin;

--
-- Name: events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public.events_id_seq OWNED BY public.events.id;


--
-- Name: events_req_form; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.events_req_form (
    id integer NOT NULL,
    name character varying(30) NOT NULL,
    comment text,
    date character varying(10) NOT NULL,
    isspecial boolean NOT NULL,
    author character varying(20) NOT NULL,
    lesson character varying(30) NOT NULL,
    breaktime character varying(30) NOT NULL,
    lunch character varying(30) NOT NULL,
    screen integer,
    "isAccepted" boolean NOT NULL
);


ALTER TABLE public.events_req_form OWNER TO admin;

--
-- Name: events_req_form_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.events_req_form_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.events_req_form_id_seq OWNER TO admin;

--
-- Name: events_req_form_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public.events_req_form_id_seq OWNED BY public.events_req_form.id;


--
-- Name: events_tmp; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.events_tmp (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    src text NOT NULL,
    "isActive" boolean NOT NULL,
    type integer NOT NULL,
    "time" integer NOT NULL,
    "order" integer NOT NULL,
    tmpid integer NOT NULL
);


ALTER TABLE public.events_tmp OWNER TO admin;

--
-- Name: events_tmp_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.events_tmp_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.events_tmp_id_seq OWNER TO admin;

--
-- Name: events_tmp_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public.events_tmp_id_seq OWNED BY public.events_tmp.id;


--
-- Name: events_tmp_tmpid_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.events_tmp_tmpid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.events_tmp_tmpid_seq OWNER TO admin;

--
-- Name: events_tmp_tmpid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public.events_tmp_tmpid_seq OWNED BY public.events_tmp.tmpid;


--
-- Name: log; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.log (
    id integer NOT NULL,
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
-- Name: log_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.log_id_seq OWNER TO admin;

--
-- Name: log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public.log_id_seq OWNED BY public.log.id;


--
-- Name: table_name_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.table_name_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.table_name_id_seq OWNER TO admin;

--
-- Name: tmp; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.tmp (
    id integer NOT NULL,
    name character varying(30) NOT NULL,
    author character varying(20) NOT NULL,
    isprivate boolean NOT NULL,
    canview boolean DEFAULT true NOT NULL,
    last_modify character varying(30) DEFAULT '0'::character varying NOT NULL
);


ALTER TABLE public.tmp OWNER TO admin;

--
-- Name: COLUMN tmp.last_modify; Type: COMMENT; Schema: public; Owner: admin
--

COMMENT ON COLUMN public.tmp.last_modify IS 'Последние изменения внесены профилем ______.';


--
-- Name: tmp_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.tmp_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tmp_id_seq OWNER TO admin;

--
-- Name: tmp_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public.tmp_id_seq OWNED BY public.tmp.id;


--
-- Name: tokens; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.tokens (
    id integer NOT NULL,
    user_id integer NOT NULL,
    role character varying(100) NOT NULL,
    token character varying(300) NOT NULL
);


ALTER TABLE public.tokens OWNER TO admin;

--
-- Name: tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.tokens_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tokens_id_seq OWNER TO admin;

--
-- Name: tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public.tokens_id_seq OWNED BY public.tokens.id;


--
-- Name: user_ads; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.user_ads (
    id integer NOT NULL,
    ads_id integer DEFAULT 0 NOT NULL,
    user_id integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.user_ads OWNER TO admin;

--
-- Name: user_ads_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

ALTER TABLE public.user_ads ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.user_ads_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: ec_role id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.ec_role ALTER COLUMN id SET DEFAULT nextval('public.ec_role_id_seq'::regclass);


--
-- Name: ec_user id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.ec_user ALTER COLUMN id SET DEFAULT nextval('public.ec_user_id_seq'::regclass);


--
-- Name: events id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.events ALTER COLUMN id SET DEFAULT nextval('public.events_id_seq'::regclass);


--
-- Name: events_req_form id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.events_req_form ALTER COLUMN id SET DEFAULT nextval('public.events_req_form_id_seq'::regclass);


--
-- Name: events_tmp id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.events_tmp ALTER COLUMN id SET DEFAULT nextval('public.events_tmp_id_seq'::regclass);


--
-- Name: events_tmp tmpid; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.events_tmp ALTER COLUMN tmpid SET DEFAULT nextval('public.events_tmp_tmpid_seq'::regclass);


--
-- Name: log id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.log ALTER COLUMN id SET DEFAULT nextval('public.log_id_seq'::regclass);


--
-- Name: tmp id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.tmp ALTER COLUMN id SET DEFAULT nextval('public.tmp_id_seq'::regclass);


--
-- Name: tokens id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.tokens ALTER COLUMN id SET DEFAULT nextval('public.tokens_id_seq'::regclass);


--
-- Data for Name: ads; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.ads (id, name, comment, "timeOfLife", author, translate) FROM stdin;
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
49	lapashina	adsender	$argon2id$v=19$m=65536,t=3,p=4$FBf0YrIsbS3pRbzlbVPjiQ$rPXpgT8t7+zSMJXzXCAnckCvamII9KKnhCozgwRlTec
52	brigade2	editor	$argon2id$v=19$m=65536,t=3,p=4$mDGMs6HitOdb0b3MSkgVtQ$3bKxx/YlikI471Gps2bikufLZP+WdiUJPUqMlxfmHjY
41	brigade1	editor	$argon2id$v=19$m=65536,t=3,p=4$eNBP1+32lB9zk3LddxlcFQ$+q5RJeBGO8KddvVGgKd6dzPt3qfbh+tP3BD4hw6jutg
34	malashin	moder	$argon2id$v=19$m=65536,t=3,p=4$EMw7QaZKMtbA86Xus409jA$634WgxUocMJbmTq0pTNfp6uHYMrhVV6WMcxRywq6Zeg
48	admin	admin	$argon2id$v=19$m=65536,t=3,p=4$C8q5Dheb0rc+8KcvD7sDDA$oZOsLHVpqSN8iGvWEFMoIjJBp4IcYfWTe9JvVaLZUrE
22	admin1	admin	$2b$08$MuwagbtN08lE0QRF3JaGvOXcUKqyBJURk8Rf2wg0Wl82RHCoDcNDW
50	Brigade7	editor	$argon2id$v=19$m=65536,t=3,p=4$nMyCnKoHr9LbYTQhZeXQsw$2pWeOp7FbSknWw8vcvZUXZ1Zh04zB6vvPYUN6brQBi4
51	Уважаемый	editor	$argon2id$v=19$m=65536,t=3,p=4$JWRu7Y2n8hlUDoJUR1OTKQ$x0z9dUz2V2bUxT8x/+tJmLMQiVkBLpJ4vxflf94iAkU
\.


--
-- Data for Name: events; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.events (id, name, src, "isActive", type, "time", "order") FROM stdin;
\.


--
-- Data for Name: events_req_form; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.events_req_form (id, name, comment, date, isspecial, author, lesson, breaktime, lunch, screen, "isAccepted") FROM stdin;
\.


--
-- Data for Name: events_tmp; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.events_tmp (id, name, src, "isActive", type, "time", "order", tmpid) FROM stdin;
479	1	1	t	0	15	1	51
378	Карта К3	http://webrobo.mgul.ac.ru:3000/forms/K3_Pascal_map/	t	1	15	1	43
379	Карта Артек	http://webrobo.mgul.ac.ru:3000/forms/Artek_Pascal_map/	t	1	15	2	43
380	К3 - Артек	http://webrobo.mgul.ac.ru:3000/forms/K3-Artek/	t	1	15	3	43
381	Аудитории - Гидра	http://webrobo.mgul.ac.ru:3000/forms/Hydra-K3g/	t	1	15	4	43
382	Гидра - Влажность	http://webrobo.mgul.ac.ru:3000/forms/TV_Hum/	t	1	15	5	43
383	Гидра - Температура	http://webrobo.mgul.ac.ru:3000/forms/TV_Temp/	t	1	15	6	43
486	Карта К3	http://webrobo.mgul.ac.ru:3000/forms/K3_Pascal_map/	t	1	15	1	56
487	Карта Артек	http://webrobo.mgul.ac.ru:3000/forms/Artek_Pascal_map/	t	1	15	2	56
488	К3 - Артек	http://webrobo.mgul.ac.ru:3000/forms/K3-Artek/	t	1	15	3	56
489	Аудитории - Гидра	http://webrobo.mgul.ac.ru:3000/forms/Hydra-K3g/	t	1	15	4	56
490	Гидра - Влажность	http://webrobo.mgul.ac.ru:3000/forms/TV_Hum/	t	1	15	5	56
491	Гидра - Температура	http://webrobo.mgul.ac.ru:3000/forms/TV_Temp/	t	1	15	6	56
498	Карта К3	http://webrobo.mgul.ac.ru:3000/forms/K3_Pascal_map/	t	1	15	1	57
499	Карта Артек	http://webrobo.mgul.ac.ru:3000/forms/Artek_Pascal_map/	t	1	15	2	57
500	К3 - Артек	http://webrobo.mgul.ac.ru:3000/forms/K3-Artek/	t	1	15	3	57
501	Аудитории - Гидра	http://webrobo.mgul.ac.ru:3000/forms/Hydra-K3g/	t	1	15	4	57
502	Гидра - Влажность	http://webrobo.mgul.ac.ru:3000/forms/TV_Hum/	t	1	15	5	57
503	Гидра - Температура	http://webrobo.mgul.ac.ru:3000/forms/TV_Temp/	t	1	15	6	57
510	Карта К3	http://webrobo.mgul.ac.ru:3000/forms/K3_Pascal_map/	t	1	15	1	58
511	Карта Артек	http://webrobo.mgul.ac.ru:3000/forms/Artek_Pascal_map/	t	1	15	2	58
512	К3 - Артек	http://webrobo.mgul.ac.ru:3000/forms/K3-Artek/	t	1	15	3	58
513	Аудитории - Гидра	http://webrobo.mgul.ac.ru:3000/forms/Hydra-K3g/	t	1	15	4	58
514	Гидра - Влажность	http://webrobo.mgul.ac.ru:3000/forms/TV_Hum/	t	1	15	5	58
515	Гидра - Температура	http://webrobo.mgul.ac.ru:3000/forms/TV_Temp/	t	1	15	6	58
457	Карта К3	http://webrobo.mgul.ac.ru:3000/forms/K3_Pascal_map/	t	1	15	1	50
458	Карта Артек	http://webrobo.mgul.ac.ru:3000/forms/Artek_Pascal_map/	t	1	15	2	50
459	К3 - Артек	http://webrobo.mgul.ac.ru:3000/forms/K3-Artek/	t	1	15	3	50
460	Аудитории - Гидра	http://webrobo.mgul.ac.ru:3000/forms/Hydra-K3g/	t	1	15	4	50
461	Гидра - Влажность	http://webrobo.mgul.ac.ru:3000/forms/TV_Hum/	t	1	15	5	50
462	Гидра - Температура	http://webrobo.mgul.ac.ru:3000/forms/TV_Temp/	t	1	15	6	50
529	Карта К3	http://webrobo.mgul.ac.ru:3000/forms/K3_Pascal_map/	t	1	15	1	59
530	Карта Артек	http://webrobo.mgul.ac.ru:3000/forms/Artek_Pascal_map/	t	1	15	2	59
531	К3 - Артек	http://webrobo.mgul.ac.ru:3000/forms/K3-Artek/	t	1	15	3	59
532	Аудитории - Гидра	http://webrobo.mgul.ac.ru:3000/forms/Hydra-K3g/	t	1	15	4	59
533	Гидра - Влажность	http://webrobo.mgul.ac.ru:3000/forms/TV_Hum/	t	1	15	5	59
534	Гидра - Температура	http://webrobo.mgul.ac.ru:3000/forms/TV_Temp/	t	1	15	6	59
535	dsds	sdsd	t	0	15	7	59
545	Карта К3	http://webrobo.mgul.ac.ru:3000/forms/K3_Pascal_map/	t	1	15	1	60
546	Карта Артек	http://webrobo.mgul.ac.ru:3000/forms/Artek_Pascal_map/	t	1	15	2	60
547	Гидра - Температура	http://webrobo.mgul.ac.ru:3000/forms/TV_Temp/	t	1	15	3	60
548	asd	asd	t	0	15	4	60
\.


--
-- Data for Name: log; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.log (id, object, type, username, date, "time", e_group, name, e_name_e, e_src_type_s, e_src_type_e, e_src_s, e_src_e, e_timing_s, e_timing_e, a_author, a_comment, a_timeout, a_isauto, a_translate) FROM stdin;
\.


--
-- Data for Name: tmp; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.tmp (id, name, author, isprivate, canview, last_modify) FROM stdin;
58	ДляТеста (но я не жадный)	Уважаемый	f	t	Уважаемый
59	wdqowh;lfqe	admin	t	t	admin
43	Стандарт	admin	f	t	Уважаемый
60	TEST	brigade1	f	t	admin
50	ФЫВфывЫФВ	Уважаемый	t	t	Уважаемый
51	sdfsdf	admin	t	f	admin
56	ДляТеста	admin	t	t	admin
57	ЭТОМОЁ	Уважаемый	f	t	Уважаемый
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
166	82	48
167	82	49
170	82	41
178	88	48
179	89	48
180	88	41
181	89	41
182	88	49
183	89	49
184	90	49
185	90	48
186	90	41
\.


--
-- Name: ads_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.ads_id_seq', 90, true);


--
-- Name: ec_role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.ec_role_id_seq', 1, false);


--
-- Name: ec_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.ec_user_id_seq', 54, true);


--
-- Name: events_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.events_id_seq', 1, true);


--
-- Name: events_req_form_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.events_req_form_id_seq', 1, false);


--
-- Name: events_tmp_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.events_tmp_id_seq', 548, true);


--
-- Name: events_tmp_tmpid_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.events_tmp_tmpid_seq', 1, true);


--
-- Name: log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.log_id_seq', 177, true);


--
-- Name: table_name_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.table_name_id_seq', 1, false);


--
-- Name: tmp_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.tmp_id_seq', 60, true);


--
-- Name: tokens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.tokens_id_seq', 1, false);


--
-- Name: user_ads_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.user_ads_id_seq', 186, true);


--
-- Name: ads ads_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.ads
    ADD CONSTRAINT ads_pkey PRIMARY KEY (id);


--
-- Name: ec_role ec_role_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.ec_role
    ADD CONSTRAINT ec_role_pkey PRIMARY KEY (id);


--
-- Name: ec_user ec_user_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.ec_user
    ADD CONSTRAINT ec_user_pkey PRIMARY KEY (id);


--
-- Name: events events_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- Name: events_req_form events_req_form_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.events_req_form
    ADD CONSTRAINT events_req_form_pkey PRIMARY KEY (id);


--
-- Name: events_tmp events_tmp_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.events_tmp
    ADD CONSTRAINT events_tmp_pkey PRIMARY KEY (id);


--
-- Name: log log_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.log
    ADD CONSTRAINT log_pkey PRIMARY KEY (id);


--
-- Name: tmp tmp_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.tmp
    ADD CONSTRAINT tmp_pkey PRIMARY KEY (id);


--
-- Name: tokens tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.tokens
    ADD CONSTRAINT tokens_pkey PRIMARY KEY (id);


--
-- Name: user_ads user_ads_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.user_ads
    ADD CONSTRAINT user_ads_pkey PRIMARY KEY (id);


--
-- Name: events events_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_id_fkey FOREIGN KEY (id) REFERENCES public.events_tmp(id);


--
-- Name: events_tmp events_tmp_tmpid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.events_tmp
    ADD CONSTRAINT events_tmp_tmpid_fkey FOREIGN KEY (tmpid) REFERENCES public.tmp(id);


--
-- PostgreSQL database dump complete
--

