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
    "isAccepted" boolean NOT NULL,
    "whoAccept" character varying(20),
    "isActive" boolean DEFAULT false NOT NULL,
    "inProcessing" boolean DEFAULT false NOT NULL
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
-- Name: events_tmp_acc; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.events_tmp_acc (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    src text NOT NULL,
    "isActive" boolean NOT NULL,
    type integer NOT NULL,
    "time" integer NOT NULL,
    "order" integer NOT NULL,
    tmpid integer NOT NULL
);


ALTER TABLE public.events_tmp_acc OWNER TO admin;

--
-- Name: events_tmp_acc_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.events_tmp_acc_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.events_tmp_acc_id_seq OWNER TO admin;

--
-- Name: events_tmp_acc_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public.events_tmp_acc_id_seq OWNED BY public.events_tmp_acc.id;


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
-- Name: tmp_acc; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.tmp_acc (
    id integer NOT NULL,
    name character varying(30) NOT NULL,
    author character varying(20) NOT NULL,
    isprivate boolean NOT NULL,
    canview boolean DEFAULT true NOT NULL,
    last_modify character varying(30) DEFAULT '0'::character varying NOT NULL
);


ALTER TABLE public.tmp_acc OWNER TO admin;

--
-- Name: tmp_acc_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.tmp_acc_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tmp_acc_id_seq OWNER TO admin;

--
-- Name: tmp_acc_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public.tmp_acc_id_seq OWNED BY public.tmp_acc.id;


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
-- Name: events_tmp_acc id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.events_tmp_acc ALTER COLUMN id SET DEFAULT nextval('public.events_tmp_acc_id_seq'::regclass);


--
-- Name: log id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.log ALTER COLUMN id SET DEFAULT nextval('public.log_id_seq'::regclass);


--
-- Name: tmp id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.tmp ALTER COLUMN id SET DEFAULT nextval('public.tmp_id_seq'::regclass);


--
-- Name: tmp_acc id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.tmp_acc ALTER COLUMN id SET DEFAULT nextval('public.tmp_acc_id_seq'::regclass);


--
-- Name: tokens id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.tokens ALTER COLUMN id SET DEFAULT nextval('public.tokens_id_seq'::regclass);


--
-- Data for Name: ads; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.ads (id, name, comment, "timeOfLife", author, translate) FROM stdin;
94	Появилось 	вначале	2023-02-15	admin	t
95	Появилось 	сверху	2023-02-15	admin	t
96	Появилось 	тут	2023-02-15	admin	f
97	Появилось 	где-то там сверху внизу вправа слева у тебя в жопе	2023-02-15	admin	t
99	Тест	даты	2023-03-03	admin	t
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
34	malashin	moder	$argon2id$v=19$m=65536,t=3,p=4$EMw7QaZKMtbA86Xus409jA$634WgxUocMJbmTq0pTNfp6uHYMrhVV6WMcxRywq6Zeg
48	admin	admin	$argon2id$v=19$m=65536,t=3,p=4$C8q5Dheb0rc+8KcvD7sDDA$oZOsLHVpqSN8iGvWEFMoIjJBp4IcYfWTe9JvVaLZUrE
22	admin1	admin	$2b$08$MuwagbtN08lE0QRF3JaGvOXcUKqyBJURk8Rf2wg0Wl82RHCoDcNDW
\.


--
-- Data for Name: events; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.events (id, name, src, "isActive", type, "time", "order") FROM stdin;
\.


--
-- Data for Name: events_req_form; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.events_req_form (id, name, comment, date, isspecial, author, lesson, breaktime, lunch, screen, "isAccepted", "whoAccept", "isActive", "inProcessing") FROM stdin;
12	Fuck	this shit	2023-02-15	f	admin	EMPTY	-	-	1	f	\N	f	f
13	dsfd	dsfs	2023-02-15	f	admin	А Я ЕЩЁ ТУТ	-	-	1	f	\N	f	f
14	Тест удачный	Так точно	2023-02-15	f	admin	Копия теста	-	-	1	f	\N	f	f
15	Тест 2	Полет?	2023-02-15	f	admin	TEST	-	А Я ЕЩЁ ТУТ	1	f	\N	f	f
16	длдл	длдл	2023-02-15	t	admin	Стандарт	-	-	1	f	\N	f	f
17	длдл	длдл	2023-02-15	t	admin	Стандарт	-	-	1	f	\N	f	f
18	Тест		2023-02-15	f	admin	А Я ЕЩЁ ТУТ	-	-	1	f	\N	f	f
19	Тест		2023-02-15	f	admin	А Я ЕЩЁ ТУТ	-	-	1	f	\N	f	f
20	antutu		2023-02-15	f	admin	А Я ЕЩЁ ТУТ	-	-	1	f	\N	f	f
\.


--
-- Data for Name: events_tmp; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.events_tmp (id, name, src, "isActive", type, "time", "order", tmpid) FROM stdin;
549	Карта К3	http://webrobo.mgul.ac.ru:3000/forms/K3_Pascal_map/	t	1	15	1	62
550	Гидра - Температура	http://webrobo.mgul.ac.ru:3000/forms/TV_Temp/	t	1	15	2	62
551	Карта К3	http://webrobo.mgul.ac.ru:3000/forms/K3_Pascal_map/	t	1	15	1	64
552	Карта Артек	http://webrobo.mgul.ac.ru:3000/forms/Artek_Pascal_map/	t	1	15	2	64
553	К3 - Артек	http://webrobo.mgul.ac.ru:3000/forms/K3-Artek/	t	1	15	3	64
554	Аудитории - Гидра	http://webrobo.mgul.ac.ru:3000/forms/Hydra-K3g/	t	1	15	4	64
615	Карта К3	http://webrobo.mgul.ac.ru:3000/forms/K3_Pascal_map/	t	1	15	1	66
616	Гидра - Температура	http://webrobo.mgul.ac.ru:3000/forms/TV_Temp/	t	1	15	2	66
555	Гидра - Влажность	http://webrobo.mgul.ac.ru:3000/forms/TV_Hum/	t	1	15	5	64
556	Гидра - Температура	http://webrobo.mgul.ac.ru:3000/forms/TV_Temp/	t	1	15	6	64
557	Карта К3	http://webrobo.mgul.ac.ru:3000/forms/K3_Pascal_map/	t	1	15	1	65
558	Карта Артек	http://webrobo.mgul.ac.ru:3000/forms/Artek_Pascal_map/	t	1	15	2	65
559	К3 - Артек	http://webrobo.mgul.ac.ru:3000/forms/K3-Artek/	t	1	15	3	65
560	Аудитории - Гидра	http://webrobo.mgul.ac.ru:3000/forms/Hydra-K3g/	t	1	15	4	65
623	Перерыв типа!	КАЙФУЕМ!	t	0	15	1	67
561	Гидра - Влажность	http://webrobo.mgul.ac.ru:3000/forms/TV_Hum/	t	1	15	5	65
562	Гидра - Температура	http://webrobo.mgul.ac.ru:3000/forms/TV_Temp/	t	1	15	6	65
563	Карта К3	http://webrobo.mgul.ac.ru:3000/forms/K3_Pascal_map/	t	1	15	1	71
564	Гидра - Температура	http://webrobo.mgul.ac.ru:3000/forms/TV_Temp/	t	1	15	2	71
630	Карта К3	http://webrobo.mgul.ac.ru:3000/forms/K3_Pascal_map/	t	1	15	1	68
631	Карта Артек	http://webrobo.mgul.ac.ru:3000/forms/Artek_Pascal_map/	t	1	15	2	68
632	К3 - Артек	http://webrobo.mgul.ac.ru:3000/forms/K3-Artek/	t	1	15	3	68
633	Аудитории - Гидра	http://webrobo.mgul.ac.ru:3000/forms/Hydra-K3g/	t	1	15	4	68
634	Гидра - Влажность	http://webrobo.mgul.ac.ru:3000/forms/TV_Hum/	t	1	15	5	68
635	Пойду	похаваю до отвала проца	t	0	15	6	68
636	К3 - Артек	http://webrobo.mgul.ac.ru:3000/forms/K3-Artek/	t	1	15	1	43
637	Карта К3	http://webrobo.mgul.ac.ru:3000/forms/K3_Pascal_map/	t	1	15	2	43
638	Аудитории - Гидра	http://webrobo.mgul.ac.ru:3000/forms/Hydra-K3g/	t	1	15	3	43
639	Гидра - Температура	http://webrobo.mgul.ac.ru:3000/forms/TV_Temp/	t	1	15	4	43
579	Карта К3	http://webrobo.mgul.ac.ru:3000/forms/K3_Pascal_map/	t	1	15	1	73
580	Карта Артек	http://webrobo.mgul.ac.ru:3000/forms/Artek_Pascal_map/	t	1	15	2	73
581	К3 - Артек	http://webrobo.mgul.ac.ru:3000/forms/K3-Artek/	t	1	15	3	73
582	Аудитории - Гидра	http://webrobo.mgul.ac.ru:3000/forms/Hydra-K3g/	t	1	15	4	73
583	Гидра - Влажность	http://webrobo.mgul.ac.ru:3000/forms/TV_Hum/	t	1	15	5	73
584	Гидра - Температура	http://webrobo.mgul.ac.ru:3000/forms/TV_Temp/	t	1	15	6	73
585	JustForTest	123123	t	1	15	7	73
\.


--
-- Data for Name: events_tmp_acc; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.events_tmp_acc (id, name, src, "isActive", type, "time", "order", tmpid) FROM stdin;
87	Карта К3	http://webrobo.mgul.ac.ru:3000/forms/K3_Pascal_map/	t	1	15	1	31
88	Карта Артек	http://webrobo.mgul.ac.ru:3000/forms/Artek_Pascal_map/	t	1	15	2	31
89	К3 - Артек	http://webrobo.mgul.ac.ru:3000/forms/K3-Artek/	t	1	15	3	31
90	Аудитории - Гидра	http://webrobo.mgul.ac.ru:3000/forms/Hydra-K3g/	t	1	15	4	31
91	Гидра - Влажность	http://webrobo.mgul.ac.ru:3000/forms/TV_Hum/	t	1	15	5	31
92	Гидра - Температура	http://webrobo.mgul.ac.ru:3000/forms/TV_Temp/	t	1	15	6	31
93	JustForTest	123123	t	1	15	7	31
94	Карта К3	http://webrobo.mgul.ac.ru:3000/forms/K3_Pascal_map/	t	1	15	1	32
95	Гидра - Температура	http://webrobo.mgul.ac.ru:3000/forms/TV_Temp/	t	1	15	2	32
96	Карта К3	http://webrobo.mgul.ac.ru:3000/forms/K3_Pascal_map/	t	1	15	1	33
97	Гидра - Температура	http://webrobo.mgul.ac.ru:3000/forms/TV_Temp/	t	1	15	2	33
98	Карта К3	http://webrobo.mgul.ac.ru:3000/forms/K3_Pascal_map/	t	1	15	1	34
99	Карта Артек	http://webrobo.mgul.ac.ru:3000/forms/Artek_Pascal_map/	t	1	15	2	34
100	К3 - Артек	http://webrobo.mgul.ac.ru:3000/forms/K3-Artek/	t	1	15	3	34
101	Аудитории - Гидра	http://webrobo.mgul.ac.ru:3000/forms/Hydra-K3g/	t	1	15	4	34
102	Гидра - Влажность	http://webrobo.mgul.ac.ru:3000/forms/TV_Hum/	t	1	15	5	34
103	Гидра - Температура	http://webrobo.mgul.ac.ru:3000/forms/TV_Temp/	t	1	15	6	34
104	JustForTest	123123	t	1	15	7	34
105	К3 - Артек	http://webrobo.mgul.ac.ru:3000/forms/K3-Artek/	t	1	15	1	35
106	Карта К3	http://webrobo.mgul.ac.ru:3000/forms/K3_Pascal_map/	t	1	15	2	35
107	Аудитории - Гидра	http://webrobo.mgul.ac.ru:3000/forms/Hydra-K3g/	t	1	15	3	35
108	Гидра - Температура	http://webrobo.mgul.ac.ru:3000/forms/TV_Temp/	t	1	15	4	35
109	К3 - Артек	http://webrobo.mgul.ac.ru:3000/forms/K3-Artek/	t	1	15	1	36
110	Карта К3	http://webrobo.mgul.ac.ru:3000/forms/K3_Pascal_map/	t	1	15	2	36
111	Аудитории - Гидра	http://webrobo.mgul.ac.ru:3000/forms/Hydra-K3g/	t	1	15	3	36
112	Гидра - Температура	http://webrobo.mgul.ac.ru:3000/forms/TV_Temp/	t	1	15	4	36
113	Карта К3	http://webrobo.mgul.ac.ru:3000/forms/K3_Pascal_map/	t	1	15	1	37
114	Карта Артек	http://webrobo.mgul.ac.ru:3000/forms/Artek_Pascal_map/	t	1	15	2	37
115	К3 - Артек	http://webrobo.mgul.ac.ru:3000/forms/K3-Artek/	t	1	15	3	37
116	Аудитории - Гидра	http://webrobo.mgul.ac.ru:3000/forms/Hydra-K3g/	t	1	15	4	37
117	Гидра - Влажность	http://webrobo.mgul.ac.ru:3000/forms/TV_Hum/	t	1	15	5	37
118	Гидра - Температура	http://webrobo.mgul.ac.ru:3000/forms/TV_Temp/	t	1	15	6	37
119	JustForTest	123123	t	1	15	7	37
120	Карта К3	http://webrobo.mgul.ac.ru:3000/forms/K3_Pascal_map/	t	1	15	1	38
121	Карта Артек	http://webrobo.mgul.ac.ru:3000/forms/Artek_Pascal_map/	t	1	15	2	38
122	К3 - Артек	http://webrobo.mgul.ac.ru:3000/forms/K3-Artek/	t	1	15	3	38
123	Аудитории - Гидра	http://webrobo.mgul.ac.ru:3000/forms/Hydra-K3g/	t	1	15	4	38
124	Гидра - Влажность	http://webrobo.mgul.ac.ru:3000/forms/TV_Hum/	t	1	15	5	38
125	Гидра - Температура	http://webrobo.mgul.ac.ru:3000/forms/TV_Temp/	t	1	15	6	38
126	JustForTest	123123	t	1	15	7	38
127	Карта К3	http://webrobo.mgul.ac.ru:3000/forms/K3_Pascal_map/	t	1	15	1	39
128	Карта Артек	http://webrobo.mgul.ac.ru:3000/forms/Artek_Pascal_map/	t	1	15	2	39
129	К3 - Артек	http://webrobo.mgul.ac.ru:3000/forms/K3-Artek/	t	1	15	3	39
130	Аудитории - Гидра	http://webrobo.mgul.ac.ru:3000/forms/Hydra-K3g/	t	1	15	4	39
131	Гидра - Влажность	http://webrobo.mgul.ac.ru:3000/forms/TV_Hum/	t	1	15	5	39
132	Гидра - Температура	http://webrobo.mgul.ac.ru:3000/forms/TV_Temp/	t	1	15	6	39
133	JustForTest	123123	t	1	15	7	39
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
70	EMPTY	admin	t	f	admin
71	Копия теста	admin	t	f	admin
69	empty	admin	t	f	admin
73	А Я ЕЩЁ ТУТ	Brigade7	f	t	brigade2
66	Пары_тест	admin	t	f	admin
67	Перерыв_тест	admin	t	f	admin
68	Обед_тест	admin	t	f	admin
43	Стандарт	admin	f	t	admin
62	TEST	admin	t	f	admin
64	New	admin	t	f	admin
65	admin	admin	t	f	admin
\.


--
-- Data for Name: tmp_acc; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.tmp_acc (id, name, author, isprivate, canview, last_modify) FROM stdin;
30	EMPTY	admin	t	f	admin
31	А Я ЕЩЁ ТУТ	Brigade7	f	t	brigade2
32	Копия теста	admin	t	f	admin
33	TEST	admin	t	f	admin
34	А Я ЕЩЁ ТУТ	Brigade7	f	t	brigade2
35	Стандарт	admin	f	t	admin
36	Стандарт	admin	f	t	admin
37	А Я ЕЩЁ ТУТ	Brigade7	f	t	brigade2
38	А Я ЕЩЁ ТУТ	Brigade7	f	t	brigade2
39	А Я ЕЩЁ ТУТ	Brigade7	f	t	brigade2
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
204	99	52
206	97	52
207	96	52
208	95	52
209	94	52
210	99	49
212	97	49
213	96	49
214	95	49
215	94	49
192	99	48
194	97	48
195	96	48
196	95	48
197	94	48
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

SELECT pg_catalog.setval('public.events_req_form_id_seq', 20, true);


--
-- Name: events_tmp_acc_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.events_tmp_acc_id_seq', 133, true);


--
-- Name: events_tmp_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.events_tmp_id_seq', 585, true);


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
-- Name: tmp_acc_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.tmp_acc_id_seq', 39, true);


--
-- Name: tmp_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.tmp_id_seq', 73, true);


--
-- Name: tokens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.tokens_id_seq', 1, false);


--
-- Name: user_ads_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.user_ads_id_seq', 215, true);


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
-- Name: events_tmp_acc events_tmp_acc_pk; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.events_tmp_acc
    ADD CONSTRAINT events_tmp_acc_pk PRIMARY KEY (id);


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
-- Name: tmp_acc tmp_acc_pk; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.tmp_acc
    ADD CONSTRAINT tmp_acc_pk PRIMARY KEY (id);


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
-- Name: events_tmp_acc_id_uindex; Type: INDEX; Schema: public; Owner: admin
--

CREATE UNIQUE INDEX events_tmp_acc_id_uindex ON public.events_tmp_acc USING btree (id);


--
-- Name: tmp_acc_id_uindex; Type: INDEX; Schema: public; Owner: admin
--

CREATE UNIQUE INDEX tmp_acc_id_uindex ON public.tmp_acc USING btree (id);


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

