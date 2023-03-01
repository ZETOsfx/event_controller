--
-- PostgreSQL database dump
--

-- Dumped from database version 14.7 (Debian 14.7-1.pgdg110+1)
-- Dumped by pg_dump version 14.7 (Debian 14.7-1.pgdg110+1)

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

--
-- Name: pg_cron; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_cron WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION pg_cron; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_cron IS 'Job scheduler for PostgreSQL';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: ads; Type: TABLE; Schema: public; Owner: alexander_perelight
--

CREATE TABLE public.ads (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    comment text,
    "timeOfLife" character varying(10) NOT NULL,
    author character varying(20) NOT NULL,
    translate boolean DEFAULT false NOT NULL,
    personal character varying(20)
);


ALTER TABLE public.ads OWNER TO alexander_perelight;

--
-- Name: COLUMN ads."timeOfLife"; Type: COMMENT; Schema: public; Owner: alexander_perelight
--

COMMENT ON COLUMN public.ads."timeOfLife" IS 'Момент (время + дата), по достижении  которого объявление будет автоматически удалено. ';


--
-- Name: ads_id_seq; Type: SEQUENCE; Schema: public; Owner: alexander_perelight
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
-- Name: ec_role; Type: TABLE; Schema: public; Owner: alexander_perelight
--

CREATE TABLE public.ec_role (
    id integer NOT NULL,
    role character varying(10)
);


ALTER TABLE public.ec_role OWNER TO alexander_perelight;

--
-- Name: ec_role_id_seq; Type: SEQUENCE; Schema: public; Owner: alexander_perelight
--

CREATE SEQUENCE public.ec_role_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ec_role_id_seq OWNER TO alexander_perelight;

--
-- Name: ec_role_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: alexander_perelight
--

ALTER SEQUENCE public.ec_role_id_seq OWNED BY public.ec_role.id;


--
-- Name: ec_user; Type: TABLE; Schema: public; Owner: alexander_perelight
--

CREATE TABLE public.ec_user (
    id integer NOT NULL,
    name character varying(20) NOT NULL,
    role character varying(10) NOT NULL,
    passhash character varying(255) NOT NULL
);


ALTER TABLE public.ec_user OWNER TO alexander_perelight;

--
-- Name: ec_user_id_seq; Type: SEQUENCE; Schema: public; Owner: alexander_perelight
--

CREATE SEQUENCE public.ec_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ec_user_id_seq OWNER TO alexander_perelight;

--
-- Name: ec_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: alexander_perelight
--

ALTER SEQUENCE public.ec_user_id_seq OWNED BY public.ec_user.id;


--
-- Name: events; Type: TABLE; Schema: public; Owner: alexander_perelight
--

CREATE TABLE public.events (
    name character varying(30) NOT NULL,
    src text NOT NULL,
    "isActive" boolean DEFAULT true NOT NULL,
    type integer NOT NULL,
    "time" integer NOT NULL,
    "order" integer NOT NULL,
    screen integer DEFAULT 1 NOT NULL
);


ALTER TABLE public.events OWNER TO alexander_perelight;

--
-- Name: events_req_form; Type: TABLE; Schema: public; Owner: alexander_perelight
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
    "whoAccept" character varying(20) DEFAULT '-'::character varying NOT NULL,
    "isActive" boolean DEFAULT false NOT NULL,
    "inProcessing" boolean DEFAULT false NOT NULL
);


ALTER TABLE public.events_req_form OWNER TO alexander_perelight;

--
-- Name: events_req_form_id_seq; Type: SEQUENCE; Schema: public; Owner: alexander_perelight
--

CREATE SEQUENCE public.events_req_form_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.events_req_form_id_seq OWNER TO alexander_perelight;

--
-- Name: events_req_form_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: alexander_perelight
--

ALTER SEQUENCE public.events_req_form_id_seq OWNED BY public.events_req_form.id;


--
-- Name: events_tmp; Type: TABLE; Schema: public; Owner: alexander_perelight
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


ALTER TABLE public.events_tmp OWNER TO alexander_perelight;

--
-- Name: events_tmp_acc; Type: TABLE; Schema: public; Owner: alexander_perelight
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


ALTER TABLE public.events_tmp_acc OWNER TO alexander_perelight;

--
-- Name: events_tmp_acc_id_seq; Type: SEQUENCE; Schema: public; Owner: alexander_perelight
--

CREATE SEQUENCE public.events_tmp_acc_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.events_tmp_acc_id_seq OWNER TO alexander_perelight;

--
-- Name: events_tmp_acc_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: alexander_perelight
--

ALTER SEQUENCE public.events_tmp_acc_id_seq OWNED BY public.events_tmp_acc.id;


--
-- Name: events_tmp_id_seq; Type: SEQUENCE; Schema: public; Owner: alexander_perelight
--

CREATE SEQUENCE public.events_tmp_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.events_tmp_id_seq OWNER TO alexander_perelight;

--
-- Name: events_tmp_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: alexander_perelight
--

ALTER SEQUENCE public.events_tmp_id_seq OWNED BY public.events_tmp.id;


--
-- Name: events_tmp_tmpid_seq; Type: SEQUENCE; Schema: public; Owner: alexander_perelight
--

CREATE SEQUENCE public.events_tmp_tmpid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.events_tmp_tmpid_seq OWNER TO alexander_perelight;

--
-- Name: events_tmp_tmpid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: alexander_perelight
--

ALTER SEQUENCE public.events_tmp_tmpid_seq OWNED BY public.events_tmp.tmpid;


--
-- Name: log; Type: TABLE; Schema: public; Owner: alexander_perelight
--

CREATE TABLE public.log (
    id integer NOT NULL,
    object character varying(20) NOT NULL,
    type integer,
    username character varying(20) NOT NULL,
    date character varying(10) NOT NULL,
    "time" character varying(15) NOT NULL,
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


ALTER TABLE public.log OWNER TO alexander_perelight;

--
-- Name: log_id_seq; Type: SEQUENCE; Schema: public; Owner: alexander_perelight
--

CREATE SEQUENCE public.log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.log_id_seq OWNER TO alexander_perelight;

--
-- Name: log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: alexander_perelight
--

ALTER SEQUENCE public.log_id_seq OWNED BY public.log.id;


--
-- Name: table_name_id_seq; Type: SEQUENCE; Schema: public; Owner: alexander_perelight
--

CREATE SEQUENCE public.table_name_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.table_name_id_seq OWNER TO alexander_perelight;

--
-- Name: tmp; Type: TABLE; Schema: public; Owner: alexander_perelight
--

CREATE TABLE public.tmp (
    id integer NOT NULL,
    name character varying(30) NOT NULL,
    author character varying(20) NOT NULL,
    isprivate boolean NOT NULL,
    canview boolean DEFAULT true NOT NULL,
    last_modify character varying(20) DEFAULT '0'::character varying NOT NULL
);


ALTER TABLE public.tmp OWNER TO alexander_perelight;

--
-- Name: COLUMN tmp.last_modify; Type: COMMENT; Schema: public; Owner: alexander_perelight
--

COMMENT ON COLUMN public.tmp.last_modify IS 'Последние изменения внесены профилем ______.';


--
-- Name: tmp_acc; Type: TABLE; Schema: public; Owner: alexander_perelight
--

CREATE TABLE public.tmp_acc (
    id integer NOT NULL,
    name character varying(30) NOT NULL,
    author character varying(20) NOT NULL,
    isprivate boolean NOT NULL,
    canview boolean DEFAULT true NOT NULL,
    last_modify character varying(20) DEFAULT '0'::character varying NOT NULL,
    "from" integer NOT NULL
);


ALTER TABLE public.tmp_acc OWNER TO alexander_perelight;

--
-- Name: tmp_acc_id_seq; Type: SEQUENCE; Schema: public; Owner: alexander_perelight
--

CREATE SEQUENCE public.tmp_acc_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tmp_acc_id_seq OWNER TO alexander_perelight;

--
-- Name: tmp_acc_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: alexander_perelight
--

ALTER SEQUENCE public.tmp_acc_id_seq OWNED BY public.tmp_acc.id;


--
-- Name: tmp_id_seq; Type: SEQUENCE; Schema: public; Owner: alexander_perelight
--

CREATE SEQUENCE public.tmp_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tmp_id_seq OWNER TO alexander_perelight;

--
-- Name: tmp_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: alexander_perelight
--

ALTER SEQUENCE public.tmp_id_seq OWNED BY public.tmp.id;


--
-- Name: tokens; Type: TABLE; Schema: public; Owner: alexander_perelight
--

CREATE TABLE public.tokens (
    id integer NOT NULL,
    user_id integer NOT NULL,
    role character varying(100) NOT NULL,
    token character varying(300) NOT NULL
);


ALTER TABLE public.tokens OWNER TO alexander_perelight;

--
-- Name: tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: alexander_perelight
--

CREATE SEQUENCE public.tokens_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tokens_id_seq OWNER TO alexander_perelight;

--
-- Name: tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: alexander_perelight
--

ALTER SEQUENCE public.tokens_id_seq OWNED BY public.tokens.id;


--
-- Name: user_ads; Type: TABLE; Schema: public; Owner: alexander_perelight
--

CREATE TABLE public.user_ads (
    id integer NOT NULL,
    ads_id integer DEFAULT 0 NOT NULL,
    user_id integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.user_ads OWNER TO alexander_perelight;

--
-- Name: user_ads_id_seq; Type: SEQUENCE; Schema: public; Owner: alexander_perelight
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
-- Name: ec_role id; Type: DEFAULT; Schema: public; Owner: alexander_perelight
--

ALTER TABLE ONLY public.ec_role ALTER COLUMN id SET DEFAULT nextval('public.ec_role_id_seq'::regclass);


--
-- Name: ec_user id; Type: DEFAULT; Schema: public; Owner: alexander_perelight
--

ALTER TABLE ONLY public.ec_user ALTER COLUMN id SET DEFAULT nextval('public.ec_user_id_seq'::regclass);


--
-- Name: events_req_form id; Type: DEFAULT; Schema: public; Owner: alexander_perelight
--

ALTER TABLE ONLY public.events_req_form ALTER COLUMN id SET DEFAULT nextval('public.events_req_form_id_seq'::regclass);


--
-- Name: events_tmp id; Type: DEFAULT; Schema: public; Owner: alexander_perelight
--

ALTER TABLE ONLY public.events_tmp ALTER COLUMN id SET DEFAULT nextval('public.events_tmp_id_seq'::regclass);


--
-- Name: events_tmp tmpid; Type: DEFAULT; Schema: public; Owner: alexander_perelight
--

ALTER TABLE ONLY public.events_tmp ALTER COLUMN tmpid SET DEFAULT nextval('public.events_tmp_tmpid_seq'::regclass);


--
-- Name: events_tmp_acc id; Type: DEFAULT; Schema: public; Owner: alexander_perelight
--

ALTER TABLE ONLY public.events_tmp_acc ALTER COLUMN id SET DEFAULT nextval('public.events_tmp_acc_id_seq'::regclass);


--
-- Name: log id; Type: DEFAULT; Schema: public; Owner: alexander_perelight
--

ALTER TABLE ONLY public.log ALTER COLUMN id SET DEFAULT nextval('public.log_id_seq'::regclass);


--
-- Name: tmp id; Type: DEFAULT; Schema: public; Owner: alexander_perelight
--

ALTER TABLE ONLY public.tmp ALTER COLUMN id SET DEFAULT nextval('public.tmp_id_seq'::regclass);


--
-- Name: tmp_acc id; Type: DEFAULT; Schema: public; Owner: alexander_perelight
--

ALTER TABLE ONLY public.tmp_acc ALTER COLUMN id SET DEFAULT nextval('public.tmp_acc_id_seq'::regclass);


--
-- Name: tokens id; Type: DEFAULT; Schema: public; Owner: alexander_perelight
--

ALTER TABLE ONLY public.tokens ALTER COLUMN id SET DEFAULT nextval('public.tokens_id_seq'::regclass);


--
-- Data for Name: job; Type: TABLE DATA; Schema: cron; Owner: alexander_perelight
--

COPY cron.job (jobid, schedule, command, nodename, nodeport, database, username, active, jobname) FROM stdin;
6	01 00 * * *	DO $$ BEGIN\nUPDATE public.events_req_form\nSET "isActive" = false\nWHERE\n    "isActive" = true\n    AND "isAccepted" = true;\n\nUPDATE public.events_req_form\nSET "isActive" = true\nWHERE "date" = (\n        SELECT MAX("date")\n        FROM\n            public.events_req_form\n        WHERE (\n                to_date("date", 'YYYY-MM-DD') <= current_date\n            )\n    )\n    AND "isAccepted" = true;\n\nDELETE FROM\n    public.events_tmp_acc\nWHERE "tmpid" = (\n        SELECT "id"\n        FROM public.tmp_acc\n        WHERE "from" = (\n                SELECT "id"\n                FROM\n                    public.events_req_form\n                WHERE\n                    to_date("date", 'YYYY-MM-DD') < to_date( (\n                            SELECT\n                                "date"\n                            FROM\n                                public.events_req_form\n                            WHERE\n                                "isActive" = true\n                        ),\n                        'YYYY-MM-DD'\n                    )\n                    AND "isAccepted" = true\n            )\n    );\n\nDELETE FROM public.tmp_acc\nWHERE "from" = (\n        SELECT "id"\n        FROM\n            public.events_req_form\n        WHERE\n            to_date("date", 'YYYY-MM-DD') < to_date( (\n                    SELECT\n                        "date"\n                    FROM\n                        public.events_req_form\n                    WHERE\n                        "isActive" = true\n                ),\n                'YYYY-MM-DD'\n            )\n            AND "isAccepted" = true\n    );\n\nDELETE FROM\n    public.events_req_form\nWHERE\n    to_date("date", 'YYYY-MM-DD') < to_date( (\n            SELECT "date"\n            FROM\n                public.events_req_form\n            WHERE\n                "isActive" = true\n        ),\n        'YYYY-MM-DD'\n    )\n    AND "isAccepted" = true;\n\nTRUNCATE public.events;\n\nINSERT INTO public.events\nSELECT\n    "name",\n    "src",\n    "isActive",\n    "type",\n    "time",\n    "order"\nFROM public.events_tmp_acc\nWHERE "tmpid" = (\n        SELECT "id"\n        FROM public.tmp_acc\n        WHERE "name" = (\n                SELECT lunch\n                FROM\n                    public.events_req_form\n                WHERE\n                    "isActive" = true\n            )\n            AND "from" = (\n                SELECT "id"\n                FROM\n                    public.events_req_form\n                WHERE\n                    "isActive" = true\n            )\n    )\n    AND "isActive" = true;\n\nEND $$ 	localhost	5432	ecdb	alexander_perelight	t	Новый день
12	50 12 * * *	DO $$ BEGIN TRUNCATE public.events;\n\nINSERT INTO public.events\nSELECT\n    "name",\n    "src",\n    "isActive",\n    "type",\n    "time",\n    "order"\nFROM public.events_tmp_acc\nWHERE "tmpid" = (\n        SELECT "id"\n        FROM public.tmp_acc\n        WHERE "name" = (\n                SELECT lesson\n                FROM\n                    public.events_req_form\n                WHERE\n                    "isActive" = true\n            )\n            AND "from" = (\n                SELECT "id"\n                FROM\n                    public.events_req_form\n                WHERE\n                    "isActive" = true\n            )\n    )\n    AND "isActive" = true;\n\nEND $$ 	localhost	5432	ecdb	alexander_perelight	t	Пара 3
7	20 8 * * *	DO $$ BEGIN TRUNCATE public.events;\n\nINSERT INTO public.events\nSELECT\n    "name",\n    "src",\n    "isActive",\n    "type",\n    "time",\n    "order"\nFROM public.events_tmp_acc\nWHERE "tmpid" = (\n        SELECT "id"\n        FROM public.tmp_acc\n        WHERE "name" = (\n                SELECT\n                    breaktime\n                FROM\n                    public.events_req_form\n                WHERE\n                    "isActive" = true\n            )\n            AND "from" = (\n                SELECT "id"\n                FROM\n                    public.events_req_form\n                WHERE\n                    "isActive" = true\n            )\n    )\n    AND "isActive" = true;\n\nEND $$ 	localhost	5432	ecdb	alexander_perelight	t	Перерыв перед парами
8	40 8 * * *	DO $$ BEGIN TRUNCATE public.events;\n\nINSERT INTO public.events\nSELECT\n    "name",\n    "src",\n    "isActive",\n    "type",\n    "time",\n    "order"\nFROM public.events_tmp_acc\nWHERE "tmpid" = (\n        SELECT "id"\n        FROM public.tmp_acc\n        WHERE "name" = (\n                SELECT lesson\n                FROM\n                    public.events_req_form\n                WHERE\n                    "isActive" = true\n            )\n            AND "from" = (\n                SELECT "id"\n                FROM\n                    public.events_req_form\n                WHERE\n                    "isActive" = true\n            )\n    )\n    AND "isActive" = true;\n\nEND $$ 	localhost	5432	ecdb	alexander_perelight	t	Пара 1
9	10 16 * * *	  DO $$ BEGIN TRUNCATE public.events;\n\nINSERT INTO public.events\nSELECT\n    "name",\n    "src",\n    "isActive",\n    "type",\n    "time",\n    "order"\nFROM public.events_tmp_acc\nWHERE "tmpid" = (\n        SELECT "id"\n        FROM public.tmp_acc\n        WHERE "name" = (\n                SELECT\n                    breaktime\n                FROM\n                    public.events_req_form\n                WHERE\n                    "isActive" = true\n            )\n            AND "from" = (\n                SELECT "id"\n                FROM\n                    public.events_req_form\n                WHERE\n                    "isActive" = true\n            )\n    )\n    AND "isActive" = true;\n\nEND $$ 	localhost	5432	ecdb	alexander_perelight	t	Перерыв
10	25 10 * * *	DO $$ BEGIN TRUNCATE public.events;\n\nINSERT INTO public.events\nSELECT\n    "name",\n    "src",\n    "isActive",\n    "type",\n    "time",\n    "order"\nFROM public.events_tmp_acc\nWHERE "tmpid" = (\n        SELECT "id"\n        FROM public.tmp_acc\n        WHERE "name" = (\n                SELECT lesson\n                FROM\n                    public.events_req_form\n                WHERE\n                    "isActive" = true\n            )\n            AND "from" = (\n                SELECT "id"\n                FROM\n                    public.events_req_form\n                WHERE\n                    "isActive" = true\n            )\n    )\n    AND "isActive" = true;\n\nEND $$ 	localhost	5432	ecdb	alexander_perelight	t	Пара 2
11	00 12 * * *	DO $$ BEGIN TRUNCATE public.events;\n\nINSERT INTO public.events\nSELECT\n    "name",\n    "src",\n    "isActive",\n    "type",\n    "time",\n    "order"\nFROM public.events_tmp_acc\nWHERE "tmpid" = (\n        SELECT "id"\n        FROM public.tmp_acc\n        WHERE "name" = (\n                SELECT lunch\n                FROM\n                    public.events_req_form\n                WHERE\n                    "isActive" = true\n            )\n            AND "from" = (\n                SELECT "id"\n                FROM\n                    public.events_req_form\n                WHERE\n                    "isActive" = true\n            )\n    )\n    AND "isActive" = true;\n\nEND $$ 	localhost	5432	ecdb	alexander_perelight	t	Обед
14	35 14 * * *	DO $$ BEGIN TRUNCATE public.events;\n\nINSERT INTO public.events\nSELECT\n    "name",\n    "src",\n    "isActive",\n    "type",\n    "time",\n    "order"\nFROM public.events_tmp_acc\nWHERE "tmpid" = (\n        SELECT "id"\n        FROM public.tmp_acc\n        WHERE "name" = (\n                SELECT lesson\n                FROM\n                    public.events_req_form\n                WHERE\n                    "isActive" = true\n            )\n            AND "from" = (\n                SELECT "id"\n                FROM\n                    public.events_req_form\n                WHERE\n                    "isActive" = true\n            )\n    )\n    AND "isActive" = true;\n\nEND $$ 	localhost	5432	ecdb	alexander_perelight	t	Пара 4
16	20 16 * * *	  DO $$ BEGIN TRUNCATE public.events;\n\nINSERT INTO public.events\nSELECT\n    "name",\n    "src",\n    "isActive",\n    "type",\n    "time",\n    "order"\nFROM public.events_tmp_acc\nWHERE "tmpid" = (\n        SELECT "id"\n        FROM public.tmp_acc\n        WHERE "name" = (\n                SELECT lesson\n                FROM\n                    public.events_req_form\n                WHERE\n                    "isActive" = true\n            )\n            AND "from" = (\n                SELECT "id"\n                FROM\n                    public.events_req_form\n                WHERE\n                    "isActive" = true\n            )\n    )\n    AND "isActive" = true;\n\nEND $$ 	localhost	5432	ecdb	alexander_perelight	t	Пара 5
17	55 17 * * *	DO $$ BEGIN TRUNCATE public.events;\n\nINSERT INTO public.events\nSELECT\n    "name",\n    "src",\n    "isActive",\n    "type",\n    "time",\n    "order"\nFROM public.events_tmp_acc\nWHERE "tmpid" = (\n        SELECT "id"\n        FROM public.tmp_acc\n        WHERE "name" = (\n                SELECT lunch\n                FROM\n                    public.events_req_form\n                WHERE\n                    "isActive" = true\n            )\n            AND "from" = (\n                SELECT "id"\n                FROM\n                    public.events_req_form\n                WHERE\n                    "isActive" = true\n            )\n    )\n    AND "isActive" = true;\n\nEND $$ 	localhost	5432	ecdb	alexander_perelight	t	Конец пар
20	15 10 * * *	DO $$ BEGIN TRUNCATE public.events;\n\nINSERT INTO public.events\nSELECT\n    "name",\n    "src",\n    "isActive",\n    "type",\n    "time",\n    "order"\nFROM public.events_tmp_acc\nWHERE "tmpid" = (\n        SELECT "id"\n        FROM public.tmp_acc\n        WHERE "name" = (\n                SELECT\n                    breaktime\n                FROM\n                    public.events_req_form\n                WHERE\n                    "isActive" = true\n            )\n            AND "from" = (\n                SELECT "id"\n                FROM\n                    public.events_req_form\n                WHERE\n                    "isActive" = true\n            )\n    )\n    AND "isActive" = true;\n\nEND $$ 	localhost	5432	ecdb	alexander_perelight	t	Перерыв 1
24	25 14 * * *	DO $$ BEGIN TRUNCATE public.events;\n\nINSERT INTO public.events\nSELECT\n    "name",\n    "src",\n    "isActive",\n    "type",\n    "time",\n    "order"\nFROM public.events_tmp_acc\nWHERE "tmpid" = (\n        SELECT "id"\n        FROM public.tmp_acc\n        WHERE "name" = (\n                SELECT\n                    breaktime\n                FROM\n                    public.events_req_form\n                WHERE\n                    "isActive" = true\n            )\n            AND "from" = (\n                SELECT "id"\n                FROM\n                    public.events_req_form\n                WHERE\n                    "isActive" = true\n            )\n    )\n    AND "isActive" = true;\n\nEND $$ 	localhost	5432	ecdb	alexander_perelight	t	Перерыв 3
26	10 16 * * *	DO $$ BEGIN TRUNCATE public.events;\n\nINSERT INTO public.events\nSELECT\n    "name",\n    "src",\n    "isActive",\n    "type",\n    "time",\n    "order"\nFROM public.events_tmp_acc\nWHERE "tmpid" = (\n        SELECT "id"\n        FROM public.tmp_acc\n        WHERE "name" = (\n                SELECT\n                    breaktime\n                FROM\n                    public.events_req_form\n                WHERE\n                    "isActive" = true\n            )\n            AND "from" = (\n                SELECT "id"\n                FROM\n                    public.events_req_form\n                WHERE\n                    "isActive" = true\n            )\n    )\n    AND "isActive" = true;\n\nEND $$ 	localhost	5432	ecdb	alexander_perelight	t	Перерыв 4
29	30 3 * * *	 \n\tUPDATE public.events_req_form \n\tSET "inProcessing" = false\n\tWHERE\n    \t"inProcessing" = true\n	localhost	5432	ecdb	alexander_perelight	t	Сброс обработок
30	1 0 * * * 	 DELETE FROM\n    public.ads\nWHERE\n    to_date("timeOfLife", 'YYYY-MM-DD') <= current_date\n   	localhost	5432	ecdb	alexander_perelight	t	Очистка неактуальных событий
\.


--
-- Data for Name: job_run_details; Type: TABLE DATA; Schema: cron; Owner: alexander_perelight
--

COPY cron.job_run_details (jobid, runid, job_pid, database, username, command, status, return_message, start_time, end_time) FROM stdin;
14	37	73	ecdb	alexander_perelight	DO $$ BEGIN TRUNCATE public.events;\n\nINSERT INTO public.events\nSELECT\n    "name",\n    "src",\n    "isActive",\n    "type",\n    "time",\n    "order"\nFROM public.events_tmp_acc\nWHERE "tmpid" = (\n        SELECT "id"\n        FROM public.tmp_acc\n        WHERE "name" = (\n                SELECT lesson\n                FROM\n                    public.events_req_form\n                WHERE\n                    "isActive" = true\n            )\n            AND "from" = (\n                SELECT "id"\n                FROM\n                    public.events_req_form\n                WHERE\n                    "isActive" = true\n            )\n    )\n    AND "isActive" = true;\n\nEND $$ 	succeeded	DO	2023-02-28 14:35:00.017862+03	2023-02-28 14:35:00.024301+03
9	39	274	ecdb	alexander_perelight	  DO $$ BEGIN TRUNCATE public.events;\n\nINSERT INTO public.events\nSELECT\n    "name",\n    "src",\n    "isActive",\n    "type",\n    "time",\n    "order"\nFROM public.events_tmp_acc\nWHERE "tmpid" = (\n        SELECT "id"\n        FROM public.tmp_acc\n        WHERE "name" = (\n                SELECT\n                    breaktime\n                FROM\n                    public.events_req_form\n                WHERE\n                    "isActive" = true\n            )\n            AND "from" = (\n                SELECT "id"\n                FROM\n                    public.events_req_form\n                WHERE\n                    "isActive" = true\n            )\n    )\n    AND "isActive" = true;\n\nEND $$ 	succeeded	DO	2023-02-28 16:40:20.061878+03	2023-02-28 16:40:20.076039+03
26	38	273	ecdb	alexander_perelight	DO $$ BEGIN TRUNCATE public.events;\n\nINSERT INTO public.events\nSELECT\n    "name",\n    "src",\n    "isActive",\n    "type",\n    "time",\n    "order"\nFROM public.events_tmp_acc\nWHERE "tmpid" = (\n        SELECT "id"\n        FROM public.tmp_acc\n        WHERE "name" = (\n                SELECT\n                    breaktime\n                FROM\n                    public.events_req_form\n                WHERE\n                    "isActive" = true\n            )\n            AND "from" = (\n                SELECT "id"\n                FROM\n                    public.events_req_form\n                WHERE\n                    "isActive" = true\n            )\n    )\n    AND "isActive" = true;\n\nEND $$ 	succeeded	DO	2023-02-28 16:40:20.067295+03	2023-02-28 16:40:20.086136+03
17	41	277	ecdb	alexander_perelight	DO $$ BEGIN TRUNCATE public.events;\n\nINSERT INTO public.events\nSELECT\n    "name",\n    "src",\n    "isActive",\n    "type",\n    "time",\n    "order"\nFROM public.events_tmp_acc\nWHERE "tmpid" = (\n        SELECT "id"\n        FROM public.tmp_acc\n        WHERE "name" = (\n                SELECT lunch\n                FROM\n                    public.events_req_form\n                WHERE\n                    "isActive" = true\n            )\n            AND "from" = (\n                SELECT "id"\n                FROM\n                    public.events_req_form\n                WHERE\n                    "isActive" = true\n            )\n    )\n    AND "isActive" = true;\n\nEND $$ 	succeeded	DO	2023-02-28 18:01:26.033123+03	2023-02-28 18:01:26.042239+03
16	40	275	ecdb	alexander_perelight	  DO $$ BEGIN TRUNCATE public.events;\n\nINSERT INTO public.events\nSELECT\n    "name",\n    "src",\n    "isActive",\n    "type",\n    "time",\n    "order"\nFROM public.events_tmp_acc\nWHERE "tmpid" = (\n        SELECT "id"\n        FROM public.tmp_acc\n        WHERE "name" = (\n                SELECT lesson\n                FROM\n                    public.events_req_form\n                WHERE\n                    "isActive" = true\n            )\n            AND "from" = (\n                SELECT "id"\n                FROM\n                    public.events_req_form\n                WHERE\n                    "isActive" = true\n            )\n    )\n    AND "isActive" = true;\n\nEND $$ 	succeeded	DO	2023-02-28 16:40:20.068726+03	2023-02-28 16:40:20.100028+03
9	33	488	ecdb	alexander_perelight	  DO $$ BEGIN TRUNCATE public.events;\n\nINSERT INTO public.events\nSELECT\n    "name",\n    "src",\n    "isActive",\n    "type",\n    "time",\n    "order"\nFROM public.events_tmp_acc\nWHERE "tmpid" = (\n        SELECT "id"\n        FROM public.tmp_acc\n        WHERE "name" = (\n                SELECT\n                    breaktime\n                FROM\n                    public.events_req_form\n                WHERE\n                    "isActive" = true\n            )\n            AND "from" = (\n                SELECT "id"\n                FROM\n                    public.events_req_form\n                WHERE\n                    "isActive" = true\n            )\n    )\n    AND "isActive" = true;\n\nEND $$ 	succeeded	DO	2023-02-27 16:10:00.024606+03	2023-02-27 16:10:00.049837+03
6	30	155	ecdb	alexander_perelight	DO $$\nBEGIN\nUPDATE public.events_req_form SET 'isActive' = false WHERE 'isActive' = true ;\nUPDATE public.events_req_form SET 'isActive' = false WHERE 'isActive' = true ;\nUPDATE public.events_req_form SET 'isActive' = true WHERE MAX('date' <= CAST(GETDATE() as DATE));\nDELETE FROM public.events_req_form WHERE 'date' < (SELECT 'date' FROM public.events_req_form WHERE 'isActive' = true ); \nINSERT INTO public.events SELECT 'id', 'name', 'src', 'isActive', 'type', 'time', 'order' FROM public.events_tmp_acc WHERE 'tmpid' = ( \n        SELECT 'id' FROM public.tmp_acc WHERE 'name' = (\n                SELECT 'lunch' FROM public.events_req_form WHERE 'isActive' = true) AND 'from' = (\n                           SELECT 'id' FROM public.events_req_form WHERE 'isActive' = true ) ) AND 'isActive' = 'true' ;\nEND $$\n	failed	ERROR:  syntax error at or near "'isActive'"\nLINE 3: UPDATE public.events_req_form SET 'isActive' = false WHERE '...\n                                          ^\n	2023-02-25 00:55:00.038427+03	2023-02-25 00:55:00.045604+03
6	29	358	ecdb	alexander_perelight	DO $$\nBEGIN\nUPDATE public.events_req_form SET 'isActive' = false WHERE 'isActive' = true ;\nUPDATE public.events_req_form SET 'isActive' = false WHERE 'isActive' = true ;\nUPDATE public.events_req_form SET 'isActive' = true WHERE MAX('date' <= CAST(GETDATE() as DATE));\nDELETE FROM public.events_req_form WHERE 'date' < (SELECT 'date' FROM public.events_req_form WHERE 'isActive' = true ); \nINSERT INTO public.events SELECT 'id', 'name', 'src', 'isActive', 'type', 'time', 'order' FROM public.events_tmp_acc WHERE 'tmpid' = ( \n        SELECT 'id' FROM public.tmp_acc WHERE 'name' = (\n                SELECT 'lunch' FROM public.events_req_form WHERE 'isActive' = true) AND 'from' = (\n                           SELECT 'id' FROM public.events_req_form WHERE 'isActive' = true ) ) AND 'isActive' = 'true' ;\nEND $$\n	failed	ERROR:  syntax error at or near "'isActive'"\nLINE 3: UPDATE public.events_req_form SET 'isActive' = false WHERE '...\n                                          ^\n	2023-02-24 00:55:00.009923+03	2023-02-24 00:55:00.011504+03
16	34	511	ecdb	alexander_perelight	  DO $$ BEGIN TRUNCATE public.events;\n\nINSERT INTO public.events\nSELECT\n    "name",\n    "src",\n    "isActive",\n    "type",\n    "time",\n    "order"\nFROM public.events_tmp_acc\nWHERE "tmpid" = (\n        SELECT "id"\n        FROM public.tmp_acc\n        WHERE "name" = (\n                SELECT lesson\n                FROM\n                    public.events_req_form\n                WHERE\n                    "isActive" = true\n            )\n            AND "from" = (\n                SELECT "id"\n                FROM\n                    public.events_req_form\n                WHERE\n                    "isActive" = true\n            )\n    )\n    AND "isActive" = true;\n\nEND $$ 	succeeded	DO	2023-02-27 16:20:00.013552+03	2023-02-27 16:20:00.019811+03
26	32	487	ecdb	alexander_perelight	DO $$ BEGIN TRUNCATE public.events;\n\nINSERT INTO public.events\nSELECT\n    "name",\n    "src",\n    "isActive",\n    "type",\n    "time",\n    "order"\nFROM public.events_tmp_acc\nWHERE "tmpid" = (\n        SELECT "id"\n        FROM public.tmp_acc\n        WHERE "name" = (\n                SELECT\n                    breaktime\n                FROM\n                    public.events_req_form\n                WHERE\n                    "isActive" = true\n            )\n            AND "from" = (\n                SELECT "id"\n                FROM\n                    public.events_req_form\n                WHERE\n                    "isActive" = true\n            )\n    )\n    AND "isActive" = true;\n\nEND $$ 	succeeded	DO	2023-02-27 16:10:00.023246+03	2023-02-27 16:10:00.044495+03
14	31	276	ecdb	alexander_perelight	  	succeeded	0 rows	2023-02-27 14:35:00.019729+03	2023-02-27 14:35:00.020092+03
17	35	755	ecdb	alexander_perelight	DO $$ BEGIN TRUNCATE public.events;\n\nINSERT INTO public.events\nSELECT\n    "name",\n    "src",\n    "isActive",\n    "type",\n    "time",\n    "order"\nFROM public.events_tmp_acc\nWHERE "tmpid" = (\n        SELECT "id"\n        FROM public.tmp_acc\n        WHERE "name" = (\n                SELECT lunch\n                FROM\n                    public.events_req_form\n                WHERE\n                    "isActive" = true\n            )\n            AND "from" = (\n                SELECT "id"\n                FROM\n                    public.events_req_form\n                WHERE\n                    "isActive" = true\n            )\n    )\n    AND "isActive" = true;\n\nEND $$ 	succeeded	DO	2023-02-27 17:55:00.016572+03	2023-02-27 17:55:00.023814+03
24	36	41	ecdb	alexander_perelight	DO $$ BEGIN TRUNCATE public.events;\n\nINSERT INTO public.events\nSELECT\n    "name",\n    "src",\n    "isActive",\n    "type",\n    "time",\n    "order"\nFROM public.events_tmp_acc\nWHERE "tmpid" = (\n        SELECT "id"\n        FROM public.tmp_acc\n        WHERE "name" = (\n                SELECT\n                    breaktime\n                FROM\n                    public.events_req_form\n                WHERE\n                    "isActive" = true\n            )\n            AND "from" = (\n                SELECT "id"\n                FROM\n                    public.events_req_form\n                WHERE\n                    "isActive" = true\n            )\n    )\n    AND "isActive" = true;\n\nEND $$ 	succeeded	DO	2023-02-28 14:25:00.019539+03	2023-02-28 14:25:00.030597+03
\.


--
-- Data for Name: ads; Type: TABLE DATA; Schema: public; Owner: alexander_perelight
--

COPY public.ads (id, name, comment, "timeOfLife", author, translate, personal) FROM stdin;
100	Всем встать!	Начинает работу Event Controller!	9999-01-01	admin	t	\N
105	Запрос отклонён	Модератор admin отклонил ваш запрос "undefined". \nКомментарий модератора: 1	2023-3-1	System	f	brigade2
106	Запрос отклонён	Модератор admin отклонил ваш запрос "dfdf". \nКомментарий модератора: Исправить ошибки.	2023-3-1	System	f	admin
107	Запрос отклонён	Модератор malashin отклонил ваш запрос "Just For Test". \nКомментарий модератора: Исправить ошибки. Лентяи, ой я не могу 	2023-3-1	System	f	brigade2
108	поора	пииисать	2023-02-28	admin	f	\N
109	Запрос отклонён	Модератор malashin отклонил ваш запрос "new". \nКомментарий модератора: kakoy takoy new	2023-3-1	System	f	brigade2
\.


--
-- Data for Name: ec_role; Type: TABLE DATA; Schema: public; Owner: alexander_perelight
--

COPY public.ec_role (id, role) FROM stdin;
1	admin
2	moder
3	adsender
4	editor
\.


--
-- Data for Name: ec_user; Type: TABLE DATA; Schema: public; Owner: alexander_perelight
--

COPY public.ec_user (id, name, role, passhash) FROM stdin;
49	lapashina	adsender	$argon2id$v=19$m=65536,t=3,p=4$FBf0YrIsbS3pRbzlbVPjiQ$rPXpgT8t7+zSMJXzXCAnckCvamII9KKnhCozgwRlTec
52	brigade2	editor	$argon2id$v=19$m=65536,t=3,p=4$mDGMs6HitOdb0b3MSkgVtQ$3bKxx/YlikI471Gps2bikufLZP+WdiUJPUqMlxfmHjY
48	admin	admin	$argon2id$v=19$m=65536,t=3,p=4$C8q5Dheb0rc+8KcvD7sDDA$oZOsLHVpqSN8iGvWEFMoIjJBp4IcYfWTe9JvVaLZUrE
22	admin1	admin	$2b$08$MuwagbtN08lE0QRF3JaGvOXcUKqyBJURk8Rf2wg0Wl82RHCoDcNDW
55	malashin	moder	$argon2id$v=19$m=65536,t=3,p=4$Xw+14xuY78pCpaSK91MsEw$p9wJgZHBZWUEKTFlnyDPvBmzPRvw4P0me/rVS2xPS5g
\.


--
-- Data for Name: events; Type: TABLE DATA; Schema: public; Owner: alexander_perelight
--

COPY public.events (name, src, "isActive", type, "time", "order", screen) FROM stdin;
\.


--
-- Data for Name: events_req_form; Type: TABLE DATA; Schema: public; Owner: alexander_perelight
--

COPY public.events_req_form (id, name, comment, date, isspecial, author, lesson, breaktime, lunch, screen, "isAccepted", "whoAccept", "isActive", "inProcessing") FROM stdin;
44	тест3		2023-02-28	t	admin	TEST	-	-	1	t	admin	t	f
43	тест2		2023-03-12	t	admin	Копия теста	-	-	1	t	admin	f	f
45	ыыы малаша		2023-03-02	f	admin	Kasha Malasha	-	-	1	t	admin	f	f
37	Я тут новый		2024-05-14	f	admin	empty	-	EMPTY	1	t	admin	f	f
48	hmn		2023-02-28	t	admin	MADE_BY_MODER	-	-	1	f	malashin	f	f
\.


--
-- Data for Name: events_tmp; Type: TABLE DATA; Schema: public; Owner: alexander_perelight
--

COPY public.events_tmp (id, name, src, "isActive", type, "time", "order", tmpid) FROM stdin;
654	Карта К3	http://webrobo.mgul.ac.ru:3000/forms/K3_Pascal_map/	t	1	15	1	80
655	Карта Артек	http://webrobo.mgul.ac.ru:3000/forms/Artek_Pascal_map/	t	1	15	2	80
656	К3 - Артек	http://webrobo.mgul.ac.ru:3000/forms/K3-Artek/	t	1	15	3	80
615	Карта К3	http://webrobo.mgul.ac.ru:3000/forms/K3_Pascal_map/	t	1	15	1	66
616	Гидра - Температура	http://webrobo.mgul.ac.ru:3000/forms/TV_Temp/	t	1	15	2	66
663	Карта К3	http://webrobo.mgul.ac.ru:3000/forms/K3_Pascal_map/	t	1	15	1	81
664	Карта Артек	http://webrobo.mgul.ac.ru:3000/forms/Artek_Pascal_map/	t	1	15	2	81
665	К3 - Артек	http://webrobo.mgul.ac.ru:3000/forms/K3-Artek/	t	1	15	3	81
623	Перерыв типа!	КАЙФУЕМ!	t	0	15	1	67
666	Аудитории - Гидра	http://webrobo.mgul.ac.ru:3000/forms/Hydra-K3g/	t	1	15	4	81
667	Гидра - Влажность	http://webrobo.mgul.ac.ru:3000/forms/TV_Hum/	t	1	15	5	81
630	Карта К3	http://webrobo.mgul.ac.ru:3000/forms/K3_Pascal_map/	t	1	15	1	68
631	Карта Артек	http://webrobo.mgul.ac.ru:3000/forms/Artek_Pascal_map/	t	1	15	2	68
632	К3 - Артек	http://webrobo.mgul.ac.ru:3000/forms/K3-Artek/	t	1	15	3	68
633	Аудитории - Гидра	http://webrobo.mgul.ac.ru:3000/forms/Hydra-K3g/	t	1	15	4	68
634	Гидра - Влажность	http://webrobo.mgul.ac.ru:3000/forms/TV_Hum/	t	1	15	5	68
635	Пойду	похаваю до отвала проца	t	0	15	6	68
668	Гидра - Температура	http://webrobo.mgul.ac.ru:3000/forms/TV_Temp/	t	1	15	6	81
579	Карта К3	http://webrobo.mgul.ac.ru:3000/forms/K3_Pascal_map/	t	1	15	1	73
580	Карта Артек	http://webrobo.mgul.ac.ru:3000/forms/Artek_Pascal_map/	t	1	15	2	73
581	К3 - Артек	http://webrobo.mgul.ac.ru:3000/forms/K3-Artek/	t	1	15	3	73
582	Аудитории - Гидра	http://webrobo.mgul.ac.ru:3000/forms/Hydra-K3g/	t	1	15	4	73
583	Гидра - Влажность	http://webrobo.mgul.ac.ru:3000/forms/TV_Hum/	t	1	15	5	73
584	Гидра - Температура	http://webrobo.mgul.ac.ru:3000/forms/TV_Temp/	t	1	15	6	73
585	JustForTest	123123	t	1	15	7	73
675	Карта К3	http://webrobo.mgul.ac.ru:3000/forms/K3_Pascal_map/	t	1	15	1	82
676	Карта Артек	http://webrobo.mgul.ac.ru:3000/forms/Artek_Pascal_map/	t	1	15	2	82
677	К3 - Артек	http://webrobo.mgul.ac.ru:3000/forms/K3-Artek/	t	1	15	3	82
678	Аудитории - Гидра	http://webrobo.mgul.ac.ru:3000/forms/Hydra-K3g/	t	1	15	4	82
679	Гидра - Влажность	http://webrobo.mgul.ac.ru:3000/forms/TV_Hum/	t	1	15	5	82
680	Гидра - Температура	http://webrobo.mgul.ac.ru:3000/forms/TV_Temp/	t	1	15	6	82
681	Карта К3	http://webrobo.mgul.ac.ru:3000/forms/K3_Pascal_map/	t	1	15	1	83
682	Карта Артек	http://webrobo.mgul.ac.ru:3000/forms/Artek_Pascal_map/	t	1	15	2	83
683	К3 - Артек	http://webrobo.mgul.ac.ru:3000/forms/K3-Artek/	t	1	15	3	83
684	Аудитории - Гидра	http://webrobo.mgul.ac.ru:3000/forms/Hydra-K3g/	t	1	15	4	83
685	Гидра - Влажность	http://webrobo.mgul.ac.ru:3000/forms/TV_Hum/	t	1	15	5	83
686	Гидра - Температура	http://webrobo.mgul.ac.ru:3000/forms/TV_Temp/	t	1	15	6	83
692	Карта К3	http://webrobo.mgul.ac.ru:3000/forms/K3_Pascal_map/	t	1	15	1	79
693	Карта Артек	http://webrobo.mgul.ac.ru:3000/forms/Artek_Pascal_map/	t	1	15	2	79
694	К3 - Артек	http://webrobo.mgul.ac.ru:3000/forms/K3-Artek/	t	1	15	3	79
695	Аудитории - Гидра	http://webrobo.mgul.ac.ru:3000/forms/Hydra-K3g/	t	1	15	4	79
696	Гидра - Влажность	http://webrobo.mgul.ac.ru:3000/forms/TV_Hum/	t	1	15	5	79
\.


--
-- Data for Name: events_tmp_acc; Type: TABLE DATA; Schema: public; Owner: alexander_perelight
--

COPY public.events_tmp_acc (id, name, src, "isActive", type, "time", "order", tmpid) FROM stdin;
239	Гидра - Температура	http://webrobo.mgul.ac.ru:3000/forms/TV_Temp/	t	1	15	1	76
240	Карта К3	http://webrobo.mgul.ac.ru:3000/forms/K3_Pascal_map/	t	1	15	2	76
241	Карта К3	http://webrobo.mgul.ac.ru:3000/forms/K3_Pascal_map/	t	1	15	1	77
242	Гидра - Температура	http://webrobo.mgul.ac.ru:3000/forms/TV_Temp/	t	1	15	2	77
243	Карта К3	http://webrobo.mgul.ac.ru:3000/forms/K3_Pascal_map/	t	1	15	1	78
244	Карта Артек	http://webrobo.mgul.ac.ru:3000/forms/Artek_Pascal_map/	t	1	15	2	78
245	К3 - Артек	http://webrobo.mgul.ac.ru:3000/forms/K3-Artek/	t	1	15	3	78
246	Аудитории - Гидра	http://webrobo.mgul.ac.ru:3000/forms/Hydra-K3g/	t	1	15	4	78
247	Гидра - Влажность	http://webrobo.mgul.ac.ru:3000/forms/TV_Hum/	t	1	15	5	78
248	Гидра - Температура	http://webrobo.mgul.ac.ru:3000/forms/TV_Temp/	t	1	15	6	78
251	Карта К3	http://webrobo.mgul.ac.ru:3000/forms/K3_Pascal_map/	t	1	15	1	82
252	Карта Артек	http://webrobo.mgul.ac.ru:3000/forms/Artek_Pascal_map/	t	1	15	2	82
253	К3 - Артек	http://webrobo.mgul.ac.ru:3000/forms/K3-Artek/	t	1	15	3	82
254	Аудитории - Гидра	http://webrobo.mgul.ac.ru:3000/forms/Hydra-K3g/	t	1	15	4	82
255	Гидра - Влажность	http://webrobo.mgul.ac.ru:3000/forms/TV_Hum/	t	1	15	5	82
256	Гидра - Температура	http://webrobo.mgul.ac.ru:3000/forms/TV_Temp/	t	1	15	6	82
\.


--
-- Data for Name: log; Type: TABLE DATA; Schema: public; Owner: alexander_perelight
--

COPY public.log (id, object, type, username, date, "time", e_group, name, e_name_e, e_src_type_s, e_src_type_e, e_src_s, e_src_e, e_timing_s, e_timing_e, a_author, a_comment, a_timeout, a_isauto, a_translate) FROM stdin;
\.


--
-- Data for Name: tmp; Type: TABLE DATA; Schema: public; Owner: alexander_perelight
--

COPY public.tmp (id, name, author, isprivate, canview, last_modify) FROM stdin;
70	EMPTY	admin	t	f	admin
73	А Я ЕЩЁ ТУТ	Brigade7	f	t	brigade2
66	Пары_тест	admin	t	f	admin
67	Перерыв_тест	admin	t	f	admin
68	Обед_тест	admin	t	f	admin
80	bew	admin	t	t	admin
81	MADE_BY_MODER	malashin	t	t	malashin
82	Default	System	t	t	System
83	прпрпррп	brigade2	t	f	brigade2
79	new	admin	f	t	brigade2
\.


--
-- Data for Name: tmp_acc; Type: TABLE DATA; Schema: public; Owner: alexander_perelight
--

COPY public.tmp_acc (id, name, author, isprivate, canview, last_modify, "from") FROM stdin;
65	empty	admin	t	f	admin	37
66	EMPTY	admin	t	f	admin	37
76	Копия теста	admin	t	f	admin	43
77	TEST	admin	t	f	admin	44
78	Kasha Malasha	malashin	t	t	malashin	45
82	MADE_BY_MODER	malashin	t	t	malashin	48
\.


--
-- Data for Name: tokens; Type: TABLE DATA; Schema: public; Owner: alexander_perelight
--

COPY public.tokens (id, user_id, role, token) FROM stdin;
\.


--
-- Data for Name: user_ads; Type: TABLE DATA; Schema: public; Owner: alexander_perelight
--

COPY public.user_ads (id, ads_id, user_id) FROM stdin;
262	108	52
263	107	52
264	106	52
265	105	52
266	100	52
267	108	48
268	107	48
269	106	48
270	105	48
271	100	48
272	108	55
273	107	55
274	106	55
275	105	55
276	100	55
277	109	52
\.


--
-- Name: jobid_seq; Type: SEQUENCE SET; Schema: cron; Owner: alexander_perelight
--

SELECT pg_catalog.setval('cron.jobid_seq', 30, true);


--
-- Name: runid_seq; Type: SEQUENCE SET; Schema: cron; Owner: alexander_perelight
--

SELECT pg_catalog.setval('cron.runid_seq', 41, true);


--
-- Name: ads_id_seq; Type: SEQUENCE SET; Schema: public; Owner: alexander_perelight
--

SELECT pg_catalog.setval('public.ads_id_seq', 109, true);


--
-- Name: ec_role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: alexander_perelight
--

SELECT pg_catalog.setval('public.ec_role_id_seq', 1, false);


--
-- Name: ec_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: alexander_perelight
--

SELECT pg_catalog.setval('public.ec_user_id_seq', 56, true);


--
-- Name: events_req_form_id_seq; Type: SEQUENCE SET; Schema: public; Owner: alexander_perelight
--

SELECT pg_catalog.setval('public.events_req_form_id_seq', 54, true);


--
-- Name: events_tmp_acc_id_seq; Type: SEQUENCE SET; Schema: public; Owner: alexander_perelight
--

SELECT pg_catalog.setval('public.events_tmp_acc_id_seq', 285, true);


--
-- Name: events_tmp_id_seq; Type: SEQUENCE SET; Schema: public; Owner: alexander_perelight
--

SELECT pg_catalog.setval('public.events_tmp_id_seq', 696, true);


--
-- Name: events_tmp_tmpid_seq; Type: SEQUENCE SET; Schema: public; Owner: alexander_perelight
--

SELECT pg_catalog.setval('public.events_tmp_tmpid_seq', 1, true);


--
-- Name: log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: alexander_perelight
--

SELECT pg_catalog.setval('public.log_id_seq', 177, true);


--
-- Name: table_name_id_seq; Type: SEQUENCE SET; Schema: public; Owner: alexander_perelight
--

SELECT pg_catalog.setval('public.table_name_id_seq', 1, false);


--
-- Name: tmp_acc_id_seq; Type: SEQUENCE SET; Schema: public; Owner: alexander_perelight
--

SELECT pg_catalog.setval('public.tmp_acc_id_seq', 88, true);


--
-- Name: tmp_id_seq; Type: SEQUENCE SET; Schema: public; Owner: alexander_perelight
--

SELECT pg_catalog.setval('public.tmp_id_seq', 83, true);


--
-- Name: tokens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: alexander_perelight
--

SELECT pg_catalog.setval('public.tokens_id_seq', 1, false);


--
-- Name: user_ads_id_seq; Type: SEQUENCE SET; Schema: public; Owner: alexander_perelight
--

SELECT pg_catalog.setval('public.user_ads_id_seq', 277, true);


--
-- Name: ads ads_pkey; Type: CONSTRAINT; Schema: public; Owner: alexander_perelight
--

ALTER TABLE ONLY public.ads
    ADD CONSTRAINT ads_pkey PRIMARY KEY (id);


--
-- Name: ec_role ec_role_pkey; Type: CONSTRAINT; Schema: public; Owner: alexander_perelight
--

ALTER TABLE ONLY public.ec_role
    ADD CONSTRAINT ec_role_pkey PRIMARY KEY (id);


--
-- Name: ec_user ec_user_pkey; Type: CONSTRAINT; Schema: public; Owner: alexander_perelight
--

ALTER TABLE ONLY public.ec_user
    ADD CONSTRAINT ec_user_pkey PRIMARY KEY (id);


--
-- Name: events_req_form events_req_form_pkey; Type: CONSTRAINT; Schema: public; Owner: alexander_perelight
--

ALTER TABLE ONLY public.events_req_form
    ADD CONSTRAINT events_req_form_pkey PRIMARY KEY (id);


--
-- Name: events_tmp_acc events_tmp_acc_pk; Type: CONSTRAINT; Schema: public; Owner: alexander_perelight
--

ALTER TABLE ONLY public.events_tmp_acc
    ADD CONSTRAINT events_tmp_acc_pk PRIMARY KEY (id);


--
-- Name: events_tmp events_tmp_pkey; Type: CONSTRAINT; Schema: public; Owner: alexander_perelight
--

ALTER TABLE ONLY public.events_tmp
    ADD CONSTRAINT events_tmp_pkey PRIMARY KEY (id);


--
-- Name: log log_pkey; Type: CONSTRAINT; Schema: public; Owner: alexander_perelight
--

ALTER TABLE ONLY public.log
    ADD CONSTRAINT log_pkey PRIMARY KEY (id);


--
-- Name: tmp_acc tmp_acc_pk; Type: CONSTRAINT; Schema: public; Owner: alexander_perelight
--

ALTER TABLE ONLY public.tmp_acc
    ADD CONSTRAINT tmp_acc_pk PRIMARY KEY (id);


--
-- Name: tmp tmp_pkey; Type: CONSTRAINT; Schema: public; Owner: alexander_perelight
--

ALTER TABLE ONLY public.tmp
    ADD CONSTRAINT tmp_pkey PRIMARY KEY (id);


--
-- Name: tokens tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: alexander_perelight
--

ALTER TABLE ONLY public.tokens
    ADD CONSTRAINT tokens_pkey PRIMARY KEY (id);


--
-- Name: user_ads user_ads_pkey; Type: CONSTRAINT; Schema: public; Owner: alexander_perelight
--

ALTER TABLE ONLY public.user_ads
    ADD CONSTRAINT user_ads_pkey PRIMARY KEY (id);


--
-- Name: events_tmp_acc_id_uindex; Type: INDEX; Schema: public; Owner: alexander_perelight
--

CREATE UNIQUE INDEX events_tmp_acc_id_uindex ON public.events_tmp_acc USING btree (id);


--
-- Name: tmp_acc_id_uindex; Type: INDEX; Schema: public; Owner: alexander_perelight
--

CREATE UNIQUE INDEX tmp_acc_id_uindex ON public.tmp_acc USING btree (id);


--
-- Name: events_tmp events_tmp_tmpid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: alexander_perelight
--

ALTER TABLE ONLY public.events_tmp
    ADD CONSTRAINT events_tmp_tmpid_fkey FOREIGN KEY (tmpid) REFERENCES public.tmp(id);


--
-- Name: job cron_job_policy; Type: POLICY; Schema: cron; Owner: alexander_perelight
--

CREATE POLICY cron_job_policy ON cron.job USING ((username = CURRENT_USER));


--
-- Name: job_run_details cron_job_run_details_policy; Type: POLICY; Schema: cron; Owner: alexander_perelight
--

CREATE POLICY cron_job_run_details_policy ON cron.job_run_details USING ((username = CURRENT_USER));


--
-- Name: job; Type: ROW SECURITY; Schema: cron; Owner: alexander_perelight
--

ALTER TABLE cron.job ENABLE ROW LEVEL SECURITY;

--
-- Name: job_run_details; Type: ROW SECURITY; Schema: cron; Owner: alexander_perelight
--

ALTER TABLE cron.job_run_details ENABLE ROW LEVEL SECURITY;

--
-- PostgreSQL database dump complete
--

