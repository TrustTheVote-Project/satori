--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: accounts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE accounts (
    id integer NOT NULL,
    state_id integer,
    name character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    website character varying,
    suspended boolean DEFAULT false NOT NULL
);


--
-- Name: accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE accounts_id_seq OWNED BY accounts.id;


--
-- Name: demog_files; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE demog_files (
    id integer NOT NULL,
    election_id integer,
    account_id integer,
    filename character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    uploaded_at timestamp without time zone,
    uploader_id integer,
    records_count integer,
    origin character varying NOT NULL,
    origin_uniq character varying,
    create_date timestamp without time zone NOT NULL,
    hash_alg character varying NOT NULL
);


--
-- Name: demog_files_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE demog_files_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: demog_files_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE demog_files_id_seq OWNED BY demog_files.id;


--
-- Name: demog_records; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE demog_records (
    id integer NOT NULL,
    demog_file_id integer,
    election_id integer,
    account_id integer,
    voter_id character varying,
    jurisdiction character varying,
    reg_date date,
    year_of_birth integer,
    reg_status character varying,
    gender character varying,
    race character varying,
    political_party_name character varying,
    overseas boolean,
    military boolean,
    protected boolean,
    disabled boolean,
    absentee_ongoing boolean,
    absentee_in_this_election boolean,
    precinct_split_id character varying,
    zip_code character varying
);


--
-- Name: demog_records_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE demog_records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: demog_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE demog_records_id_seq OWNED BY demog_records.id;


--
-- Name: elections; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE elections (
    id integer NOT NULL,
    name character varying,
    held_on date,
    voter_start_on date,
    voter_end_on date,
    reg_deadline_on date,
    ab_req_deadline_on date,
    ab_rec_deadline_on date,
    ffd_deadline_on date,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    account_id integer,
    owner_id integer
);


--
-- Name: elections_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE elections_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: elections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE elections_id_seq OWNED BY elections.id;


--
-- Name: transaction_records; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE transaction_records (
    id integer NOT NULL,
    log_id integer,
    voter_id character varying NOT NULL,
    recorded_at timestamp without time zone NOT NULL,
    action character varying NOT NULL,
    jurisdiction character varying NOT NULL,
    form character varying,
    form_note character varying,
    leo character varying,
    notes character varying,
    comment character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    election_id integer,
    account_id integer
);


--
-- Name: events_by_county; Type: MATERIALIZED VIEW; Schema: public; Owner: -; Tablespace: 
--

CREATE MATERIALIZED VIEW events_by_county AS
 SELECT transaction_records.election_id,
    transaction_records.jurisdiction,
    1 AS section,
    concat(transaction_records.action, ' - ', transaction_records.form) AS key,
    count(*) AS cnt
   FROM transaction_records
  WHERE (transaction_records.form IS NOT NULL)
  GROUP BY transaction_records.election_id, transaction_records.jurisdiction, concat(transaction_records.action, ' - ', transaction_records.form)
UNION ALL
 SELECT transaction_records.election_id,
    transaction_records.jurisdiction,
    2 AS section,
    'Other'::text AS key,
    count(*) AS cnt
   FROM transaction_records
  WHERE (transaction_records.form IS NULL)
  GROUP BY transaction_records.election_id, transaction_records.jurisdiction, 'Other'::text
  ORDER BY 3, 2, 4
  WITH NO DATA;


--
-- Name: events_by_county_by_demog; Type: MATERIALIZED VIEW; Schema: public; Owner: -; Tablespace: 
--

CREATE MATERIALIZED VIEW events_by_county_by_demog AS
 WITH records AS (
         SELECT t.election_id,
            t.jurisdiction,
            t.action,
            t.form,
            COALESCE(d.gender, 'No gender'::character varying) AS gender,
                CASE
                    WHEN ((d.overseas = true) OR (d.military = true)) THEN 'UOCAVA'::text
                    ELSE 'Local'::text
                END AS overseas
           FROM (transaction_records t
             LEFT JOIN demog_records d ON (((t.voter_id)::text = (d.voter_id)::text)))
          WHERE (t.election_id = d.election_id)
        ), valid_records AS (
         SELECT records.election_id,
            records.jurisdiction,
            records.action,
            records.form,
            records.gender,
            records.overseas
           FROM records
          WHERE (records.form IS NOT NULL)
        ), invalid_records AS (
         SELECT records.election_id,
            records.jurisdiction,
            records.action,
            records.form,
            records.gender,
            records.overseas
           FROM records
          WHERE (records.form IS NULL)
        )
 SELECT valid_records.election_id,
    valid_records.jurisdiction,
    1 AS section,
    concat(valid_records.action, (' - '::text || (valid_records.gender)::text)) AS key,
    count(*) AS cnt
   FROM valid_records
  GROUP BY valid_records.election_id, valid_records.jurisdiction, concat(valid_records.action, (' - '::text || (valid_records.gender)::text))
UNION ALL
 SELECT valid_records.election_id,
    valid_records.jurisdiction,
    2 AS section,
    concat(valid_records.action, (' - '::text || valid_records.overseas)) AS key,
    count(*) AS cnt
   FROM valid_records
  GROUP BY valid_records.election_id, valid_records.jurisdiction, concat(valid_records.action, (' - '::text || valid_records.overseas))
UNION ALL
 SELECT valid_records.election_id,
    valid_records.jurisdiction,
    3 AS section,
    concat(valid_records.action, (' - '::text || (valid_records.form)::text), (' - '::text || (valid_records.gender)::text)) AS key,
    count(*) AS cnt
   FROM valid_records
  GROUP BY valid_records.election_id, valid_records.jurisdiction, concat(valid_records.action, (' - '::text || (valid_records.form)::text), (' - '::text || (valid_records.gender)::text))
UNION ALL
 SELECT valid_records.election_id,
    valid_records.jurisdiction,
    4 AS section,
    concat(valid_records.action, (' - '::text || (valid_records.form)::text), (' - '::text || valid_records.overseas)) AS key,
    count(*) AS cnt
   FROM valid_records
  GROUP BY valid_records.election_id, valid_records.jurisdiction, concat(valid_records.action, (' - '::text || (valid_records.form)::text), (' - '::text || valid_records.overseas))
UNION ALL
 SELECT invalid_records.election_id,
    invalid_records.jurisdiction,
    5 AS section,
    concat(('Other - '::text || (invalid_records.gender)::text)) AS key,
    count(*) AS cnt
   FROM invalid_records
  GROUP BY invalid_records.election_id, invalid_records.jurisdiction, concat(('Other - '::text || (invalid_records.gender)::text))
UNION ALL
 SELECT invalid_records.election_id,
    invalid_records.jurisdiction,
    6 AS section,
    concat(('Other - '::text || invalid_records.overseas)) AS key,
    count(*) AS cnt
   FROM invalid_records
  GROUP BY invalid_records.election_id, invalid_records.jurisdiction, concat(('Other - '::text || invalid_records.overseas))
  ORDER BY 3, 2, 4
  WITH NO DATA;


--
-- Name: events_by_locality; Type: MATERIALIZED VIEW; Schema: public; Owner: -; Tablespace: 
--

CREATE MATERIALIZED VIEW events_by_locality AS
 SELECT transaction_records.election_id,
    transaction_records.jurisdiction,
    1 AS section,
    concat(transaction_records.action, ' - ', transaction_records.form) AS key,
    count(*) AS cnt
   FROM transaction_records
  GROUP BY transaction_records.election_id, transaction_records.jurisdiction, concat(transaction_records.action, ' - ', transaction_records.form)
  ORDER BY 1::integer, transaction_records.jurisdiction, concat(transaction_records.action, ' - ', transaction_records.form)
  WITH NO DATA;


--
-- Name: events_by_locality_by_demog_views; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE events_by_locality_by_demog_views (
    id integer NOT NULL
);


--
-- Name: events_by_locality_by_demog_views_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE events_by_locality_by_demog_views_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: events_by_locality_by_demog_views_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE events_by_locality_by_demog_views_id_seq OWNED BY events_by_locality_by_demog_views.id;


--
-- Name: events_by_locality_by_gender; Type: MATERIALIZED VIEW; Schema: public; Owner: -; Tablespace: 
--

CREATE MATERIALIZED VIEW events_by_locality_by_gender AS
 WITH records AS (
         SELECT t.election_id,
            t.jurisdiction,
            t.action,
            t.form,
            d.gender
           FROM (transaction_records t
             LEFT JOIN demog_records d ON (((t.voter_id)::text = (d.voter_id)::text)))
          WHERE (t.election_id = d.election_id)
        ), voters AS (
         SELECT demog_records.election_id,
            demog_records.jurisdiction,
            demog_records.gender
           FROM demog_records
        )
 SELECT voters.election_id,
    voters.jurisdiction,
    'Registered Voters'::text AS key,
    count(*) AS total,
    count(*) FILTER (WHERE ((voters.gender)::text = 'Male'::text)) AS male,
    count(*) FILTER (WHERE ((voters.gender)::text = 'Female'::text)) AS female
   FROM voters
  GROUP BY voters.election_id, voters.jurisdiction
UNION ALL
 SELECT records.election_id,
    records.jurisdiction,
    concat(records.action, (' - '::text || (records.form)::text)) AS key,
    count(*) AS total,
    count(*) FILTER (WHERE ((records.gender)::text = 'Male'::text)) AS male,
    count(*) FILTER (WHERE ((records.gender)::text = 'Female'::text)) AS female
   FROM records
  WHERE (((records.action)::text = ANY ((ARRAY['approve'::character varying, 'reject'::character varying])::text[])) AND (records.form IS NOT NULL))
  GROUP BY records.election_id, records.jurisdiction, concat(records.action, (' - '::text || (records.form)::text))
UNION ALL
 SELECT records.election_id,
    records.jurisdiction,
    records.action AS key,
    count(*) AS total,
    count(*) FILTER (WHERE ((records.gender)::text = 'Male'::text)) AS male,
    count(*) FILTER (WHERE ((records.gender)::text = 'Female'::text)) AS female
   FROM records
  WHERE ((records.action)::text = ANY ((ARRAY['cancelVoterRecord'::character varying, 'voterPollCheckin'::character varying])::text[]))
  GROUP BY records.election_id, records.jurisdiction, records.action
UNION ALL
 SELECT records.election_id,
    records.jurisdiction,
    records.action AS key,
    count(*) AS total,
    count(*) FILTER (WHERE ((records.gender)::text = 'Male'::text)) AS male,
    count(*) FILTER (WHERE ((records.gender)::text = 'Female'::text)) AS female
   FROM records
  WHERE (((records.action)::text = 'sentToVoter'::text) AND ((records.form)::text = ANY ((ARRAY['VoterCard'::character varying, 'AbsenteeBallot'::character varying])::text[])))
  GROUP BY records.election_id, records.jurisdiction, records.action
UNION ALL
 SELECT records.election_id,
    records.jurisdiction,
    records.action AS key,
    count(*) AS total,
    count(*) FILTER (WHERE ((records.gender)::text = 'Male'::text)) AS male,
    count(*) FILTER (WHERE ((records.gender)::text = 'Female'::text)) AS female
   FROM records
  WHERE (((records.form)::text = 'AbsenteeBallot'::text) AND ((records.action)::text = ANY ((ARRAY['receive'::character varying, 'returnedUndelivered'::character varying])::text[])))
  GROUP BY records.election_id, records.jurisdiction, records.action
  ORDER BY 2, 3
  WITH NO DATA;


--
-- Name: events_by_locality_by_uocava; Type: MATERIALIZED VIEW; Schema: public; Owner: -; Tablespace: 
--

CREATE MATERIALIZED VIEW events_by_locality_by_uocava AS
 WITH records AS (
         SELECT t.election_id,
            t.jurisdiction,
            t.action,
            t.form,
            ((d.overseas = true) OR (d.military = true)) AS uocava
           FROM (transaction_records t
             LEFT JOIN demog_records d ON (((t.voter_id)::text = (d.voter_id)::text)))
          WHERE (t.election_id = d.election_id)
        ), voters AS (
         SELECT demog_records.election_id,
            demog_records.jurisdiction,
            demog_records.voter_id,
            ((demog_records.overseas = true) OR (demog_records.military = true)) AS uocava
           FROM demog_records
        )
 SELECT voters.election_id,
    voters.jurisdiction,
    'Registered Voters'::text AS key,
    count(*) AS total,
    count(*) FILTER (WHERE (voters.uocava = true)) AS uocava,
    count(*) FILTER (WHERE (voters.uocava = false)) AS local
   FROM voters
  GROUP BY voters.election_id, voters.jurisdiction
UNION ALL
 SELECT records.election_id,
    records.jurisdiction,
    concat(records.action, (' - '::text || (records.form)::text)) AS key,
    count(*) AS total,
    count(*) FILTER (WHERE (records.uocava = true)) AS uocava,
    count(*) FILTER (WHERE (records.uocava = false)) AS local
   FROM records
  WHERE (((records.action)::text = ANY ((ARRAY['approve'::character varying, 'reject'::character varying])::text[])) AND (records.form IS NOT NULL))
  GROUP BY records.election_id, records.jurisdiction, concat(records.action, (' - '::text || (records.form)::text))
UNION ALL
 SELECT records.election_id,
    records.jurisdiction,
    records.action AS key,
    count(*) AS total,
    count(*) FILTER (WHERE (records.uocava = true)) AS uocava,
    count(*) FILTER (WHERE (records.uocava = false)) AS local
   FROM records
  WHERE ((records.action)::text = ANY ((ARRAY['cancelVoterRecord'::character varying, 'voterPollCheckin'::character varying])::text[]))
  GROUP BY records.election_id, records.jurisdiction, records.action
UNION ALL
 SELECT records.election_id,
    records.jurisdiction,
    records.action AS key,
    count(*) AS total,
    count(*) FILTER (WHERE (records.uocava = true)) AS uocava,
    count(*) FILTER (WHERE (records.uocava = false)) AS local
   FROM records
  WHERE (((records.action)::text = 'sentToVoter'::text) AND ((records.form)::text = ANY ((ARRAY['VoterCard'::character varying, 'AbsenteeBallot'::character varying])::text[])))
  GROUP BY records.election_id, records.jurisdiction, records.action
UNION ALL
 SELECT records.election_id,
    records.jurisdiction,
    records.action AS key,
    count(*) AS total,
    count(*) FILTER (WHERE (records.uocava = true)) AS uocava,
    count(*) FILTER (WHERE (records.uocava = false)) AS local
   FROM records
  WHERE (((records.form)::text = 'AbsenteeBallot'::text) AND ((records.action)::text = ANY ((ARRAY['receive'::character varying, 'returnedUndelivered'::character varying])::text[])))
  GROUP BY records.election_id, records.jurisdiction, records.action
  ORDER BY 2, 3
  WITH NO DATA;


--
-- Name: registration_requests; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE registration_requests (
    id integer NOT NULL,
    organization_name character varying NOT NULL,
    state character varying NOT NULL,
    website character varying,
    admin_title character varying NOT NULL,
    admin_email character varying NOT NULL,
    admin_phone character varying,
    archived boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    admin_first_name character varying,
    admin_last_name character varying,
    rejected boolean DEFAULT false NOT NULL
);


--
-- Name: registration_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE registration_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: registration_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE registration_requests_id_seq OWNED BY registration_requests.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: states; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE states (
    id integer NOT NULL,
    code character varying NOT NULL,
    name character varying NOT NULL
);


--
-- Name: states_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE states_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: states_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE states_id_seq OWNED BY states.id;


--
-- Name: tenet_settings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE tenet_settings (
    id integer NOT NULL,
    name character varying NOT NULL,
    value text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: tenet_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tenet_settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tenet_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tenet_settings_id_seq OWNED BY tenet_settings.id;


--
-- Name: transaction_logs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE transaction_logs (
    id integer NOT NULL,
    election_id integer,
    origin character varying NOT NULL,
    origin_uniq character varying,
    create_date timestamp without time zone NOT NULL,
    hash_alg character varying NOT NULL,
    filename character varying,
    records_count integer DEFAULT 0,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    account_id integer,
    uploaded_at timestamp without time zone,
    uploader_id integer,
    earliest_event_at timestamp without time zone,
    latest_event_at timestamp without time zone,
    events_count integer
);


--
-- Name: transaction_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE transaction_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transaction_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE transaction_logs_id_seq OWNED BY transaction_logs.id;


--
-- Name: transaction_records_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE transaction_records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transaction_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE transaction_records_id_seq OWNED BY transaction_records.id;


--
-- Name: upload_jobs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE upload_jobs (
    id integer NOT NULL,
    uuid character varying NOT NULL,
    election_id integer,
    url character varying NOT NULL,
    kind character varying NOT NULL,
    state character varying NOT NULL,
    progress integer DEFAULT 0 NOT NULL,
    error character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    filename character varying
);


--
-- Name: upload_jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE upload_jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: upload_jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE upload_jobs_id_seq OWNED BY upload_jobs.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    account_id integer NOT NULL,
    login character varying NOT NULL,
    crypted_password character varying NOT NULL,
    salt character varying NOT NULL,
    first_name character varying NOT NULL,
    last_name character varying NOT NULL,
    email character varying NOT NULL,
    admin boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    remember_me_token character varying,
    remember_me_token_expires_at timestamp without time zone,
    reset_password_token character varying,
    reset_password_token_expires_at timestamp without time zone,
    reset_password_email_sent_at timestamp without time zone,
    phone character varying,
    title character varying,
    last_login_at timestamp without time zone,
    last_logout_at timestamp without time zone,
    last_activity_at timestamp without time zone,
    password_set boolean DEFAULT false NOT NULL,
    last_login_from_ip_address character varying,
    role character varying,
    ssh_public_key text,
    suspended boolean DEFAULT false NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY accounts ALTER COLUMN id SET DEFAULT nextval('accounts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY demog_files ALTER COLUMN id SET DEFAULT nextval('demog_files_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY demog_records ALTER COLUMN id SET DEFAULT nextval('demog_records_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY elections ALTER COLUMN id SET DEFAULT nextval('elections_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY events_by_locality_by_demog_views ALTER COLUMN id SET DEFAULT nextval('events_by_locality_by_demog_views_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY registration_requests ALTER COLUMN id SET DEFAULT nextval('registration_requests_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY states ALTER COLUMN id SET DEFAULT nextval('states_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tenet_settings ALTER COLUMN id SET DEFAULT nextval('tenet_settings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY transaction_logs ALTER COLUMN id SET DEFAULT nextval('transaction_logs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY transaction_records ALTER COLUMN id SET DEFAULT nextval('transaction_records_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY upload_jobs ALTER COLUMN id SET DEFAULT nextval('upload_jobs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (id);


--
-- Name: demog_files_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY demog_files
    ADD CONSTRAINT demog_files_pkey PRIMARY KEY (id);


--
-- Name: demog_records_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY demog_records
    ADD CONSTRAINT demog_records_pkey PRIMARY KEY (id);


--
-- Name: elections_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY elections
    ADD CONSTRAINT elections_pkey PRIMARY KEY (id);


--
-- Name: events_by_locality_by_demog_views_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY events_by_locality_by_demog_views
    ADD CONSTRAINT events_by_locality_by_demog_views_pkey PRIMARY KEY (id);


--
-- Name: registration_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY registration_requests
    ADD CONSTRAINT registration_requests_pkey PRIMARY KEY (id);


--
-- Name: states_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY states
    ADD CONSTRAINT states_pkey PRIMARY KEY (id);


--
-- Name: tenet_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY tenet_settings
    ADD CONSTRAINT tenet_settings_pkey PRIMARY KEY (id);


--
-- Name: transaction_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY transaction_logs
    ADD CONSTRAINT transaction_logs_pkey PRIMARY KEY (id);


--
-- Name: transaction_records_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY transaction_records
    ADD CONSTRAINT transaction_records_pkey PRIMARY KEY (id);


--
-- Name: upload_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY upload_jobs
    ADD CONSTRAINT upload_jobs_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: demog_records_voter_id_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX demog_records_voter_id_idx ON demog_records USING btree (voter_id);


--
-- Name: index_accounts_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_accounts_on_name ON accounts USING btree (name);


--
-- Name: index_accounts_on_state_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_accounts_on_state_id ON accounts USING btree (state_id);


--
-- Name: index_accounts_on_suspended; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_accounts_on_suspended ON accounts USING btree (suspended);


--
-- Name: index_demog_files_on_account_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_demog_files_on_account_id ON demog_files USING btree (account_id);


--
-- Name: index_demog_files_on_election_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_demog_files_on_election_id ON demog_files USING btree (election_id);


--
-- Name: index_demog_records_on_account_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_demog_records_on_account_id ON demog_records USING btree (account_id);


--
-- Name: index_demog_records_on_demog_file_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_demog_records_on_demog_file_id ON demog_records USING btree (demog_file_id);


--
-- Name: index_demog_records_on_election_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_demog_records_on_election_id ON demog_records USING btree (election_id);


--
-- Name: index_elections_on_account_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_elections_on_account_id ON elections USING btree (account_id);


--
-- Name: index_elections_on_owner_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_elections_on_owner_id ON elections USING btree (owner_id);


--
-- Name: index_registration_requests_on_archived; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_registration_requests_on_archived ON registration_requests USING btree (archived);


--
-- Name: index_registration_requests_on_rejected; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_registration_requests_on_rejected ON registration_requests USING btree (rejected);


--
-- Name: index_tenet_settings_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_tenet_settings_on_name ON tenet_settings USING btree (name);


--
-- Name: index_transaction_logs_on_account_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_transaction_logs_on_account_id ON transaction_logs USING btree (account_id);


--
-- Name: index_transaction_logs_on_election_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_transaction_logs_on_election_id ON transaction_logs USING btree (election_id);


--
-- Name: index_transaction_records_on_account_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_transaction_records_on_account_id ON transaction_records USING btree (account_id);


--
-- Name: index_transaction_records_on_election_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_transaction_records_on_election_id ON transaction_records USING btree (election_id);


--
-- Name: index_transaction_records_on_log_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_transaction_records_on_log_id ON transaction_records USING btree (log_id);


--
-- Name: index_upload_jobs_on_election_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_upload_jobs_on_election_id ON upload_jobs USING btree (election_id);


--
-- Name: index_upload_jobs_on_uuid; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_upload_jobs_on_uuid ON upload_jobs USING btree (uuid);


--
-- Name: index_users_on_account_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_account_id ON users USING btree (account_id);


--
-- Name: index_users_on_last_logout_at_and_last_activity_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_last_logout_at_and_last_activity_at ON users USING btree (last_logout_at, last_activity_at);


--
-- Name: index_users_on_login; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_login ON users USING btree (login);


--
-- Name: index_users_on_remember_me_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_remember_me_token ON users USING btree (remember_me_token);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: index_users_on_ssh_public_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_ssh_public_key ON users USING btree (ssh_public_key);


--
-- Name: index_users_on_suspended; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_suspended ON users USING btree (suspended);


--
-- Name: transaction_records_voter_id_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX transaction_records_voter_id_idx ON transaction_records USING btree (voter_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: fk_rails_0964d2ab67; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY upload_jobs
    ADD CONSTRAINT fk_rails_0964d2ab67 FOREIGN KEY (election_id) REFERENCES elections(id);


--
-- Name: fk_rails_28da69ad0a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY elections
    ADD CONSTRAINT fk_rails_28da69ad0a FOREIGN KEY (account_id) REFERENCES accounts(id);


--
-- Name: fk_rails_4aa2fc9cdb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY demog_records
    ADD CONSTRAINT fk_rails_4aa2fc9cdb FOREIGN KEY (election_id) REFERENCES elections(id);


--
-- Name: fk_rails_6512a62f26; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY transaction_logs
    ADD CONSTRAINT fk_rails_6512a62f26 FOREIGN KEY (election_id) REFERENCES elections(id);


--
-- Name: fk_rails_8e7be79420; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY demog_files
    ADD CONSTRAINT fk_rails_8e7be79420 FOREIGN KEY (election_id) REFERENCES elections(id);


--
-- Name: fk_rails_92170bd48f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY transaction_logs
    ADD CONSTRAINT fk_rails_92170bd48f FOREIGN KEY (account_id) REFERENCES accounts(id);


--
-- Name: fk_rails_9f7d283e05; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY transaction_records
    ADD CONSTRAINT fk_rails_9f7d283e05 FOREIGN KEY (election_id) REFERENCES elections(id);


--
-- Name: fk_rails_b022e0f3a7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY demog_records
    ADD CONSTRAINT fk_rails_b022e0f3a7 FOREIGN KEY (demog_file_id) REFERENCES demog_files(id);


--
-- Name: fk_rails_c4df84fd9c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY demog_records
    ADD CONSTRAINT fk_rails_c4df84fd9c FOREIGN KEY (account_id) REFERENCES accounts(id);


--
-- Name: fk_rails_c62a4b57b6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY demog_files
    ADD CONSTRAINT fk_rails_c62a4b57b6 FOREIGN KEY (account_id) REFERENCES accounts(id);


--
-- Name: fk_rails_c866615bdb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY transaction_records
    ADD CONSTRAINT fk_rails_c866615bdb FOREIGN KEY (account_id) REFERENCES accounts(id);


--
-- Name: fk_rails_d975b0d9a5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY transaction_records
    ADD CONSTRAINT fk_rails_d975b0d9a5 FOREIGN KEY (log_id) REFERENCES transaction_logs(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20150709123935');

INSERT INTO schema_migrations (version) VALUES ('20150709123936');

INSERT INTO schema_migrations (version) VALUES ('20150709123937');

INSERT INTO schema_migrations (version) VALUES ('20150709123938');

INSERT INTO schema_migrations (version) VALUES ('20150709123939');

INSERT INTO schema_migrations (version) VALUES ('20150709123940');

INSERT INTO schema_migrations (version) VALUES ('20150709123941');

INSERT INTO schema_migrations (version) VALUES ('20150709123942');

INSERT INTO schema_migrations (version) VALUES ('20150709123943');

INSERT INTO schema_migrations (version) VALUES ('20150709123944');

INSERT INTO schema_migrations (version) VALUES ('20150709123945');

INSERT INTO schema_migrations (version) VALUES ('20150709123946');

INSERT INTO schema_migrations (version) VALUES ('20150709123947');

INSERT INTO schema_migrations (version) VALUES ('20150709123948');

INSERT INTO schema_migrations (version) VALUES ('20150709123949');

INSERT INTO schema_migrations (version) VALUES ('20150709123950');

INSERT INTO schema_migrations (version) VALUES ('20150709123951');

INSERT INTO schema_migrations (version) VALUES ('20150709123952');

INSERT INTO schema_migrations (version) VALUES ('20150709123953');

INSERT INTO schema_migrations (version) VALUES ('20150709123954');

INSERT INTO schema_migrations (version) VALUES ('20150709142637');

INSERT INTO schema_migrations (version) VALUES ('20150710063202');

INSERT INTO schema_migrations (version) VALUES ('20150710071410');

INSERT INTO schema_migrations (version) VALUES ('20150710112041');

INSERT INTO schema_migrations (version) VALUES ('20150713045612');

INSERT INTO schema_migrations (version) VALUES ('20150716131332');

INSERT INTO schema_migrations (version) VALUES ('20150716133402');

INSERT INTO schema_migrations (version) VALUES ('20150716133548');

INSERT INTO schema_migrations (version) VALUES ('20150720065824');

INSERT INTO schema_migrations (version) VALUES ('20150723114119');

INSERT INTO schema_migrations (version) VALUES ('20150723132720');

INSERT INTO schema_migrations (version) VALUES ('20150723133323');

INSERT INTO schema_migrations (version) VALUES ('20150727073117');

INSERT INTO schema_migrations (version) VALUES ('20150727081034');

INSERT INTO schema_migrations (version) VALUES ('20150727101036');

INSERT INTO schema_migrations (version) VALUES ('20150730075527');

INSERT INTO schema_migrations (version) VALUES ('20150730104745');

INSERT INTO schema_migrations (version) VALUES ('20150730105427');

INSERT INTO schema_migrations (version) VALUES ('20150730122713');

INSERT INTO schema_migrations (version) VALUES ('20150803135637');

INSERT INTO schema_migrations (version) VALUES ('20150803140719');

INSERT INTO schema_migrations (version) VALUES ('20150804103137');

INSERT INTO schema_migrations (version) VALUES ('20150804103656');

INSERT INTO schema_migrations (version) VALUES ('20150804123823');

