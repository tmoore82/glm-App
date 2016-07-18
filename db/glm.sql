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
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: additems(text[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION additems(newitems text[]) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
INSERT INTO product (name) VALUES (UNNEST(newItems)); END; $$;


ALTER FUNCTION public.additems(newitems text[]) OWNER TO postgres;

--
-- Name: get_items(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION get_items(plist text) RETURNS TABLE(store character varying, product character varying, brand character varying, category character varying, price real, size real, unit character varying, ppu real)
    LANGUAGE plpgsql
    AS $$
BEGIN
RETURN QUERY
SELECT store.name AS store, product.name AS product, brand.name AS brand, category.name AS category, item.price AS price, item.size AS size, unit.name AS unit, item.ppu AS ppu
FROM item
LEFT JOIN location on location.id = item.location
LEFT JOIN store ON store.id = location.store
LEFT JOIN brand ON brand.id = item.brand
LEFT JOIN product ON product.id = item.product
LEFT JOIN unit on unit.id = item.unit
LEFT JOIN category ON category.id = product.category
WHERE location.id IN (1,2,3)
AND product.name = ANY(plist::text[])
AND item.ppu = (SELECT MIN(i2.ppu) FROM item AS i2 WHERE i2.product = product.id) 
ORDER BY store.name, category.name, product.name; END; $$;


ALTER FUNCTION public.get_items(plist text) OWNER TO postgres;

--
-- Name: get_no_assoc(text[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION get_no_assoc(no_assoc text[]) RETURNS TABLE(names character varying)
    LANGUAGE plpgsql
    AS $$ BEGIN RETURN QUERY SELECT name FROM product WHERE name IN (SELECT UNNEST(no_assoc)) AND name NOT IN (SELECT name FROM product INNER JOIN item ON item.product = product.id); END; $$;


ALTER FUNCTION public.get_no_assoc(no_assoc text[]) OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: brand; Type: TABLE; Schema: public; Owner: tmoore82; Tablespace: 
--

CREATE TABLE brand (
    id integer NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE brand OWNER TO tmoore82;

--
-- Name: brand_id_seq; Type: SEQUENCE; Schema: public; Owner: tmoore82
--

CREATE SEQUENCE brand_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE brand_id_seq OWNER TO tmoore82;

--
-- Name: brand_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: tmoore82
--

ALTER SEQUENCE brand_id_seq OWNED BY brand.id;


--
-- Name: category; Type: TABLE; Schema: public; Owner: tmoore82; Tablespace: 
--

CREATE TABLE category (
    id integer NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE category OWNER TO tmoore82;

--
-- Name: category_id_seq; Type: SEQUENCE; Schema: public; Owner: tmoore82
--

CREATE SEQUENCE category_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE category_id_seq OWNER TO tmoore82;

--
-- Name: category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: tmoore82
--

ALTER SEQUENCE category_id_seq OWNED BY category.id;


--
-- Name: item; Type: TABLE; Schema: public; Owner: tmoore82; Tablespace: 
--

CREATE TABLE item (
    id integer NOT NULL,
    product integer NOT NULL,
    size real NOT NULL,
    unit integer NOT NULL,
    price real NOT NULL,
    ppu real NOT NULL,
    location integer NOT NULL,
    brand integer NOT NULL,
    multi boolean DEFAULT false,
    type integer,
    histlow real,
    vegan boolean
);


ALTER TABLE item OWNER TO tmoore82;

--
-- Name: item_id_seq; Type: SEQUENCE; Schema: public; Owner: tmoore82
--

CREATE SEQUENCE item_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE item_id_seq OWNER TO tmoore82;

--
-- Name: item_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: tmoore82
--

ALTER SEQUENCE item_id_seq OWNED BY item.id;


--
-- Name: location; Type: TABLE; Schema: public; Owner: tmoore82; Tablespace: 
--

CREATE TABLE location (
    id integer NOT NULL,
    store integer NOT NULL,
    address text NOT NULL,
    city text NOT NULL,
    state character varying(2) NOT NULL,
    zip character varying(10) NOT NULL,
    latitude real,
    longitude real
);


ALTER TABLE location OWNER TO tmoore82;

--
-- Name: location_id_seq; Type: SEQUENCE; Schema: public; Owner: tmoore82
--

CREATE SEQUENCE location_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE location_id_seq OWNER TO tmoore82;

--
-- Name: location_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: tmoore82
--

ALTER SEQUENCE location_id_seq OWNED BY location.id;


--
-- Name: product; Type: TABLE; Schema: public; Owner: tmoore82; Tablespace: 
--

CREATE TABLE product (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    category integer DEFAULT 14
);


ALTER TABLE product OWNER TO tmoore82;

--
-- Name: product_id_seq; Type: SEQUENCE; Schema: public; Owner: tmoore82
--

CREATE SEQUENCE product_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE product_id_seq OWNER TO tmoore82;

--
-- Name: product_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: tmoore82
--

ALTER SEQUENCE product_id_seq OWNED BY product.id;


--
-- Name: roles; Type: TABLE; Schema: public; Owner: tmoore82; Tablespace: 
--

CREATE TABLE roles (
    id integer NOT NULL,
    role character varying(255) NOT NULL
);


ALTER TABLE roles OWNER TO tmoore82;

--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: tmoore82
--

CREATE SEQUENCE roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE roles_id_seq OWNER TO tmoore82;

--
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: tmoore82
--

ALTER SEQUENCE roles_id_seq OWNED BY roles.id;


--
-- Name: store; Type: TABLE; Schema: public; Owner: tmoore82; Tablespace: 
--

CREATE TABLE store (
    id integer NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE store OWNER TO tmoore82;

--
-- Name: store_id_seq; Type: SEQUENCE; Schema: public; Owner: tmoore82
--

CREATE SEQUENCE store_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE store_id_seq OWNER TO tmoore82;

--
-- Name: store_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: tmoore82
--

ALTER SEQUENCE store_id_seq OWNED BY store.id;


--
-- Name: type; Type: TABLE; Schema: public; Owner: tmoore82; Tablespace: 
--

CREATE TABLE type (
    id integer NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE type OWNER TO tmoore82;

--
-- Name: type_id_seq; Type: SEQUENCE; Schema: public; Owner: tmoore82
--

CREATE SEQUENCE type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE type_id_seq OWNER TO tmoore82;

--
-- Name: type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: tmoore82
--

ALTER SEQUENCE type_id_seq OWNED BY type.id;


--
-- Name: unit; Type: TABLE; Schema: public; Owner: tmoore82; Tablespace: 
--

CREATE TABLE unit (
    id integer NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE unit OWNER TO tmoore82;

--
-- Name: unit_id_seq; Type: SEQUENCE; Schema: public; Owner: tmoore82
--

CREATE SEQUENCE unit_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE unit_id_seq OWNER TO tmoore82;

--
-- Name: unit_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: tmoore82
--

ALTER SEQUENCE unit_id_seq OWNED BY unit.id;


--
-- Name: user_roles; Type: TABLE; Schema: public; Owner: tmoore82; Tablespace: 
--

CREATE TABLE user_roles (
    user_id integer NOT NULL,
    role_id integer NOT NULL
);


ALTER TABLE user_roles OWNER TO tmoore82;

--
-- Name: users; Type: TABLE; Schema: public; Owner: tmoore82; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    username character varying(255) NOT NULL,
    password character varying(255) NOT NULL
);


ALTER TABLE users OWNER TO tmoore82;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: tmoore82
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE users_id_seq OWNER TO tmoore82;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: tmoore82
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: tmoore82
--

ALTER TABLE ONLY brand ALTER COLUMN id SET DEFAULT nextval('brand_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: tmoore82
--

ALTER TABLE ONLY category ALTER COLUMN id SET DEFAULT nextval('category_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: tmoore82
--

ALTER TABLE ONLY item ALTER COLUMN id SET DEFAULT nextval('item_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: tmoore82
--

ALTER TABLE ONLY location ALTER COLUMN id SET DEFAULT nextval('location_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: tmoore82
--

ALTER TABLE ONLY product ALTER COLUMN id SET DEFAULT nextval('product_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: tmoore82
--

ALTER TABLE ONLY roles ALTER COLUMN id SET DEFAULT nextval('roles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: tmoore82
--

ALTER TABLE ONLY store ALTER COLUMN id SET DEFAULT nextval('store_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: tmoore82
--

ALTER TABLE ONLY type ALTER COLUMN id SET DEFAULT nextval('type_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: tmoore82
--

ALTER TABLE ONLY unit ALTER COLUMN id SET DEFAULT nextval('unit_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: tmoore82
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Data for Name: brand; Type: TABLE DATA; Schema: public; Owner: tmoore82
--

COPY brand (id, name) FROM stdin;
1	Kroger
2	psst
3	Great Value
4	Arnold's
5	Clancy's
6	Healthy Life
7	Amy's
8	Earth Balance
9	Smart Balance
10	Lightlife
11	Coca-Cola
12	Dr. Pepper
13	Friendly Farms
14	Chex
15	Tofutti
16	(Unbranded)
17	King Arthur
18	Boulder
19	Tuscan Garden
20	Baker's Corner
21	Reggano
22	Lady's Choice
23	Spring Valley
24	Happy Harvest
\.


--
-- Name: brand_id_seq; Type: SEQUENCE SET; Schema: public; Owner: tmoore82
--

SELECT pg_catalog.setval('brand_id_seq', 24, true);


--
-- Data for Name: category; Type: TABLE DATA; Schema: public; Owner: tmoore82
--

COPY category (id, name) FROM stdin;
1	Produce
2	Cleaning
3	Pets
4	Home
5	Frozen
6	Baking
7	Spices
8	Health and Beauty
9	Specialty
10	Dairy
11	Meat
12	Misc
13	Pantry
14	(Uncategorized)
15	Vitamins
\.


--
-- Name: category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: tmoore82
--

SELECT pg_catalog.setval('category_id_seq', 15, true);


--
-- Data for Name: item; Type: TABLE DATA; Schema: public; Owner: tmoore82
--

COPY item (id, product, size, unit, price, ppu, location, brand, multi, type, histlow, vegan) FROM stdin;
108	79	14	1	2.46000004	0.175714284	3	16	\N	\N	2.46000004	\N
109	80	16	1	1.84000003	0.115000002	3	16	\N	\N	1.84000003	\N
110	82	12	1	0.680000007	0.0566666685	3	16	\N	\N	0.680000007	\N
111	83	8	1	0.25999999	0.0324999988	3	16	\N	\N	0.25999999	\N
112	84	16	1	1.98000002	0.123750001	3	16	\N	\N	1.98000002	\N
113	85	16	1	3.44000006	0.215000004	3	16	\N	\N	3.44000006	\N
114	86	32	1	1.5	0.046875	3	16	\N	\N	1.5	\N
115	87	8.5	1	1.74000001	0.204705879	3	16	\N	\N	1.74000001	\N
116	88	12	1	1.46000004	0.12166667	3	16	\N	\N	1.46000004	\N
117	89	12	1	1.96000004	0.163333327	3	16	\N	\N	1.96000004	\N
118	90	1	2	1.88	1.88	3	16	\N	\N	1.88	\N
119	1	64	1	2.78999996	0.0435937494	2	16	\N	\N	2.78999996	\N
120	2	1	2	1.99000001	1.99000001	2	16	\N	\N	1.99000001	\N
121	4	1	2	1.99000001	1.99000001	2	16	\N	\N	1.99000001	\N
122	5	46	1	2.19000006	0.0476086959	2	16	\N	\N	2.19000006	\N
123	6	1	3	0.99000001	0.99000001	2	16	\N	\N	0.99000001	\N
124	7	1	2	0.589999974	0.589999974	2	16	\N	\N	0.589999974	\N
125	8	15.5	1	0.689999998	0.0445161276	2	16	\N	\N	0.689999998	\N
126	8	16	1	1.59000003	0.0993750021	2	16	\N	\N	1.59000003	\N
127	10	16	1	1.69000006	0.105625004	2	16	\N	\N	1.69000006	\N
128	11	15	1	0.790000021	0.0526666678	2	16	\N	\N	0.790000021	\N
129	11	16	1	1.78999996	0.111874998	2	16	\N	\N	1.78999996	\N
130	13	16	1	1.38999999	0.0868749991	2	16	\N	\N	1.38999999	\N
131	15	16	1	1.99000001	0.124375001	2	16	\N	\N	1.99000001	\N
132	16	16	1	1.99000001	0.124375001	2	16	\N	\N	1.99000001	\N
133	17	32	1	2.8900001	0.0903125033	2	16	\N	\N	2.8900001	\N
134	18	32	1	2.8900001	0.0903125033	2	16	\N	\N	2.8900001	\N
135	19	4	2	3.99000001	0.997500002	2	16	\N	\N	3.99000001	\N
136	20	16	1	1.38999999	0.0868749991	2	16	\N	\N	1.38999999	\N
193	92	5	2	1.55999994	0.312000006	3	3	\N	\N	1.55999994	t
196	94	128	3	2.48000002	0.0193499997	3	3	\N	\N	2.48000002	t
197	82	6	1	0.360000014	0.0599999987	3	3	\N	\N	0.360000014	t
202	96	24	1	1	0.0416599996	3	3	\N	\N	1	t
67	22	16	1	2.07999992	0.129999995	3	6	\N	\N	2.07999992	\N
2	1	64	1	2.28999996	0.0357812494	1	13	\N	\N	2.28999996	t
199	55	376.440002	6	4.96999979	0.0131999999	3	16	\N	\N	4.96999979	t
194	93	5	2	3.97000003	0.79400003	3	17	\N	\N	3.97000003	t
200	95	200	6	1.49000001	0.0799999982	1	18	\N	\N	1.49000001	t
195	94	32	3	0.790000021	0.0250000004	1	19	\N	\N	0.790000021	t
192	92	5	2	1.38999999	0.277999997	1	20	\N	\N	1.38999999	t
198	91	32	1	1.28999996	0.0410000011	1	20	\N	\N	1.28999996	t
201	96	24	1	0.99000001	0.0412500016	1	21	\N	\N	0.99000001	t
203	94	32	3	0.779999971	0.0240000002	3	22	\N	\N	0.779999971	\N
3	2	3	2	2.99000001	0.99666667	1	16	\N	\N	2.99000001	\N
4	3	3	2	2.99000001	0.99666667	1	16	\N	\N	2.99000001	\N
5	4	3	2	2.69000006	0.896666646	1	16	\N	\N	2.69000006	\N
6	5	46	1	1.88999999	0.0410869569	1	16	\N	\N	1.88999999	\N
7	6	1	3	0.889999986	0.889999986	1	16	\N	\N	0.889999986	\N
8	7	1	2	0.439999998	0.439999998	1	16	\N	\N	0.439999998	\N
9	11	15.5	1	0.649999976	0.0419354849	1	16	\N	\N	0.649999976	\N
10	21	24	1	1.78999996	0.0745833367	1	16	\N	\N	1.78999996	\N
11	23	16	1	1.69000006	0.105625004	1	16	\N	\N	1.69000006	\N
12	24	32	1	1.78999996	0.0559374988	1	16	\N	\N	1.78999996	\N
13	25	32	1	1.28999996	0.0403124988	1	16	\N	\N	1.28999996	\N
14	28	32	1	0.99000001	0.0309375003	1	16	\N	\N	0.99000001	\N
15	29	1	3	1.99000001	1.99000001	1	16	\N	\N	1.99000001	\N
16	30	1	3	1.49000001	1.49000001	1	16	\N	\N	1.49000001	\N
17	31	17.2999992	1	1.78999996	0.10346821	1	16	\N	\N	1.78999996	\N
18	32	20	1	1.78999996	0.0895000026	1	16	\N	\N	1.78999996	\N
97	63	15	1	0.519999981	0.0346666649	3	3	\N	\N	0.519999981	\N
20	34	4.4000001	1	1.99000001	0.452272713	1	16	\N	\N	1.99000001	\N
21	35	12	1	1.78999996	0.149166673	1	16	\N	\N	1.78999996	\N
22	38	1	3	0.49000001	0.49000001	1	16	\N	\N	0.49000001	\N
23	39	20	3	2.49000001	0.124499999	1	16	\N	\N	2.49000001	\N
24	42	3	3	0.99000001	0.330000013	1	16	\N	\N	0.99000001	\N
25	44	32	1	3.98000002	0.124375001	1	16	\N	\N	3.98000002	\N
26	46	10	1	1.99000001	0.199000001	1	16	\N	\N	1.99000001	t
27	49	1	3	1.99000001	1.99000001	1	16	\N	\N	1.99000001	\N
28	50	8	1	1.69000006	0.211250007	1	16	\N	\N	1.69000006	\N
29	51	16.8999996	1	3.49000001	0.206508875	1	16	\N	\N	3.49000001	\N
30	52	5.5	1	0.99000001	0.180000007	1	16	\N	\N	0.99000001	\N
31	53	3	2	1.88999999	0.629999995	1	16	\N	\N	1.88999999	\N
32	59	5.5	1	0.889999986	0.161818177	1	16	\N	\N	0.889999986	\N
33	60	28	1	1.99000001	0.071071431	1	16	\N	\N	1.99000001	\N
34	62	18	1	1.49000001	0.0827777758	1	16	\N	\N	1.49000001	\N
35	63	15	1	0.629999995	0.0419999994	1	16	\N	\N	0.629999995	\N
36	64	3	3	2.49000001	0.829999983	1	16	\N	\N	2.49000001	\N
37	66	10	2	2.99000001	0.298999995	1	16	\N	\N	2.99000001	\N
38	69	24	1	1.88999999	0.0787499994	1	16	\N	\N	1.88999999	\N
39	70	26	1	0.389999986	0.0149999997	1	16	\N	\N	0.389999986	\N
40	71	8	1	3.49000001	0.436250001	1	16	\N	\N	3.49000001	\N
41	76	3	3	1.99000001	0.663333356	1	16	\N	\N	1.99000001	\N
42	77	4	2	1.59000003	0.397500008	1	16	\N	\N	1.59000003	\N
43	82	6	1	0.389999986	0.0649999976	1	16	\N	\N	0.389999986	\N
44	83	8	1	0.25	0.03125	1	16	\N	\N	0.25	\N
45	84	24	1	2.49000001	0.103749998	1	16	\N	\N	2.49000001	\N
46	85	16	1	3.49000001	0.218125001	1	16	\N	\N	3.49000001	\N
47	90	3	3	1.99000001	0.663333356	1	16	\N	\N	1.99000001	\N
48	1	64	1	2.3599999	0.0368749984	3	16	\N	\N	2.3599999	\N
49	2	3	2	3.1400001	1.04666662	3	16	\N	\N	3.1400001	\N
50	4	5	2	4.92000008	0.984000027	3	16	\N	\N	4.92000008	\N
51	5	46	1	1.96000004	0.042608697	3	16	\N	\N	1.96000004	\N
52	6	1	3	0.839999974	0.839999974	3	16	\N	\N	0.839999974	\N
53	7	1	2	0.589999974	0.589999974	3	16	\N	\N	0.589999974	\N
54	8	15.25	1	0.620000005	0.0406557359	3	16	\N	\N	0.620000005	\N
55	8	32	1	3.06999993	0.0959374979	3	16	\N	\N	3.06999993	\N
56	10	16	1	1.51999998	0.0949999988	3	16	\N	\N	1.51999998	\N
57	11	15.5	1	0.620000005	0.0399999991	3	16	\N	\N	0.620000005	\N
58	11	16	1	1.48000002	0.0925000012	3	16	\N	\N	1.48000002	\N
59	13	16	1	1.12	0.0700000003	3	16	\N	\N	1.12	\N
60	15	32	1	4.23999977	0.132499993	3	16	\N	\N	4.23999977	\N
61	16	16	1	1.98000002	0.123750001	3	16	\N	\N	1.98000002	\N
62	17	16	1	1.12	0.0700000003	3	16	\N	\N	1.12	\N
63	18	32	1	2.83999991	0.0887499973	3	16	\N	\N	2.83999991	\N
64	19	8	2	7.42000008	0.92750001	3	16	\N	\N	7.42000008	\N
65	20	16	1	1.48000002	0.0925000012	3	16	\N	\N	1.48000002	\N
66	21	24	1	2.68000007	0.111666664	3	16	\N	\N	2.68000007	\N
68	23	16	1	1.98000002	0.123750001	3	16	\N	\N	1.98000002	\N
69	24	32	1	1.88	0.0587499999	3	16	\N	\N	1.88	\N
70	25	32	1	1.12	0.0350000001	3	16	\N	\N	1.12	\N
71	26	6	1	2.48000002	0.413333327	3	16	\N	\N	2.48000002	\N
72	27	13	1	3.68000007	0.283076912	3	16	\N	\N	3.68000007	\N
73	28	32	1	0.860000014	0.0268750004	3	16	\N	\N	0.860000014	\N
74	29	1	3	2.55999994	2.55999994	3	16	\N	\N	2.55999994	\N
75	30	1	3	1.34000003	1.34000003	3	16	\N	\N	1.34000003	\N
76	31	15.6000004	1	2.3599999	0.151282057	3	16	\N	\N	2.3599999	\N
77	32	23.5	1	2.3599999	0.100425534	3	16	\N	\N	2.3599999	\N
78	33	11	1	1.77999997	0.161818177	3	16	\N	\N	1.77999997	\N
79	35	12	1	1.52999997	0.127499998	3	16	\N	\N	1.52999997	\N
80	36	18	1	7.17999983	0.398888886	3	16	\N	\N	7.17999983	\N
81	38	1	3	0.519999981	0.519999981	3	16	\N	\N	0.519999981	\N
82	39	12	3	1.97000003	0.164166674	3	16	\N	\N	1.97000003	\N
83	41	12	3	1.58000004	0.13166666	3	16	\N	\N	1.58000004	\N
84	44	16	1	2.98000002	0.186250001	3	16	\N	\N	2.98000002	\N
85	45	12	1	2.97000003	0.247500002	3	16	\N	\N	2.97000003	\N
86	46	12	1	2.98000002	0.248333335	3	16	\N	\N	2.98000002	t
87	47	16	1	1.53999996	0.0962499976	3	16	\N	\N	1.53999996	\N
88	48	16	1	1.88	0.1175	3	16	\N	\N	1.88	\N
89	49	1	3	2.11999989	2.11999989	3	16	\N	\N	2.11999989	\N
90	50	8	1	1.57000005	0.196250007	3	16	\N	\N	1.57000005	\N
91	51	51	1	8.93999958	0.175294116	3	16	\N	\N	8.93999958	\N
92	52	5.5	1	0.920000017	0.167272732	3	16	\N	\N	0.920000017	\N
93	53	3	2	1.94000006	0.646666646	3	16	\N	\N	1.94000006	\N
94	57	16	1	1	0.0625	3	16	\N	\N	1	\N
95	59	37.2000008	1	5.98000002	0.160752684	3	16	\N	\N	5.98000002	\N
96	62	28	1	2.07999992	0.0742857158	3	16	\N	\N	2.07999992	\N
98	64	1	3	0.400000006	0.400000006	3	16	\N	\N	0.400000006	\N
99	66	10	2	2.97000003	0.296999991	3	16	\N	\N	2.97000003	\N
100	67	13	1	1.48000002	0.113846153	3	16	\N	\N	1.48000002	\N
101	68	5	2	3.38000011	0.675999999	3	16	\N	\N	3.38000011	\N
102	69	70	1	4.65999985	0.0665714294	3	16	\N	\N	4.65999985	\N
103	70	26	1	0.419999987	0.0161538459	3	16	\N	\N	0.419999987	\N
104	72	2	3	1.48000002	0.74000001	3	16	\N	\N	1.48000002	\N
105	73	144	1	4.48000002	0.0311111119	3	16	\N	\N	4.48000002	\N
106	74	12	1	2.38000011	0.198333338	3	16	\N	\N	2.38000011	\N
107	77	4	2	1.74000001	0.435000002	3	16	\N	\N	1.74000001	\N
137	21	24	1	3.49000001	0.145416662	2	16	\N	\N	3.49000001	\N
138	22	16	1	2.58999991	0.161874995	2	16	\N	\N	2.58999991	\N
139	23	16	1	1.78999996	0.111874998	2	16	\N	\N	1.78999996	\N
140	24	32	1	1.59000003	0.049687501	2	16	\N	\N	1.59000003	\N
141	25	32	1	2.19000006	0.0684375018	2	16	\N	\N	2.19000006	\N
142	26	6	1	2.69000006	0.448333323	2	16	\N	\N	2.69000006	\N
143	27	15	1	3.69000006	0.246000007	2	16	\N	\N	3.69000006	\N
144	28	32	1	1.69000006	0.0528125018	2	16	\N	\N	1.69000006	\N
145	29	1	3	2.49000001	2.49000001	2	16	\N	\N	2.49000001	\N
146	31	17.2999992	1	1.99000001	0.115028903	2	16	\N	\N	1.99000001	\N
147	32	18.7000008	1	1.99000001	0.106417112	2	16	\N	\N	1.99000001	\N
148	33	10	1	1.28999996	0.128999993	2	16	\N	\N	1.28999996	\N
149	34	3.25	1	1.99000001	0.612307668	2	16	\N	\N	1.99000001	\N
150	35	12	1	2	0.166666672	2	16	\N	\N	2	\N
151	36	18	1	8.89000034	0.493888885	2	16	\N	\N	8.89000034	\N
152	37	8	1	3.3900001	0.423750013	2	16	\N	\N	3.3900001	\N
153	38	1	3	0.589999974	0.589999974	2	16	\N	\N	0.589999974	\N
154	39	20	3	3.28999996	0.164499998	2	16	\N	\N	3.28999996	\N
155	41	12	3	1.59000003	0.132499993	2	16	\N	\N	1.59000003	\N
156	42	1	2	2.99000001	2.99000001	2	16	\N	\N	2.99000001	\N
157	44	16	1	1.99000001	0.124375001	2	16	\N	\N	1.99000001	\N
158	45	12	1	3.8900001	0.324166656	2	16	\N	\N	3.8900001	\N
159	47	16	1	1.49000001	0.0931250006	2	16	\N	\N	1.49000001	\N
160	49	1	3	2.99000001	2.99000001	2	16	\N	\N	2.99000001	\N
161	50	8	1	2.3900001	0.298750013	2	16	\N	\N	2.3900001	\N
162	51	51	1	10.9899998	0.215490192	2	16	\N	\N	10.9899998	\N
163	52	1	3	0.689999998	0.689999998	2	16	\N	\N	0.689999998	\N
164	53	3	2	1.99000001	0.663333356	2	16	\N	\N	1.99000001	\N
165	57	16	1	1	0.0625	2	16	\N	\N	1	\N
166	59	10	1	2.28999996	0.229000002	2	16	\N	\N	2.28999996	\N
167	62	28	1	3.28999996	0.1175	2	16	\N	\N	3.28999996	\N
168	63	15	1	0.689999998	0.0460000001	2	16	\N	\N	0.689999998	\N
169	64	1	3	0.99000001	0.99000001	2	16	\N	\N	0.99000001	\N
170	66	5	2	2.99000001	0.59799999	2	16	\N	\N	2.99000001	\N
171	67	32	1	3.28999996	0.102812499	2	16	\N	\N	3.28999996	\N
172	68	2	2	1.88999999	0.944999993	2	16	\N	\N	1.88999999	\N
173	69	70	1	6.28999996	0.0898571461	2	16	\N	\N	6.28999996	\N
174	70	26	1	0.829999983	0.031923078	2	16	\N	\N	0.829999983	\N
175	71	8	1	4.98999977	0.623749971	2	16	\N	\N	4.98999977	\N
176	72	2	3	1.67999995	0.839999974	2	16	\N	\N	1.67999995	\N
177	73	144	1	4.98999977	0.034652777	2	16	\N	\N	4.98999977	\N
178	74	12	1	2.99000001	0.249166667	2	16	\N	\N	2.99000001	\N
179	77	4	2	1.88999999	0.472499996	2	16	\N	\N	1.88999999	\N
180	78	8	1	3.19000006	0.398750007	2	16	\N	\N	3.19000006	\N
181	79	14	1	1.78999996	0.127857149	2	16	\N	\N	1.78999996	\N
182	80	14	1	1.78999996	0.127857149	2	16	\N	\N	1.78999996	\N
183	82	6	1	0.689999998	0.115000002	2	16	\N	\N	0.689999998	\N
184	83	8	1	0.25	0.03125	2	16	\N	\N	0.25	\N
185	84	16	1	1.99000001	0.124375001	2	16	\N	\N	1.99000001	\N
186	85	16	1	4.48999977	0.280624986	2	16	\N	\N	4.48999977	\N
187	86	32	1	2.58999991	0.0809374973	2	16	\N	\N	2.58999991	\N
188	87	12.6999998	1	2.99000001	0.235433072	2	16	\N	\N	2.99000001	\N
189	88	12.6999998	1	1.99000001	0.156692907	2	16	\N	\N	1.99000001	\N
190	89	12	1	2.78999996	0.232500002	2	16	\N	\N	2.78999996	\N
191	90	1	2	1.88999999	1.88999999	2	16	\N	\N	1.88999999	\N
19	33	13	1	1.19000006	0.0915384591	1	5	\N	\N	1.19000006	\N
1	99	30	4	9.86999989	0.328999996	3	23	f	\N	9.86999989	\N
204	98	14.5	1	0.49000001	0.0337931029	1	24	f	1	0.49000001	\N
\.


--
-- Name: item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: tmoore82
--

SELECT pg_catalog.setval('item_id_seq', 223, true);


--
-- Data for Name: location; Type: TABLE DATA; Schema: public; Owner: tmoore82
--

COPY location (id, store, address, city, state, zip, latitude, longitude) FROM stdin;
1	1	4751 Lebanon Pike	Hermitage	TN	37076	\N	\N
2	2	4400 Lebanon Pike	Hermitage	TN	37076	\N	\N
3	3	4424 Lebanon Pike	Hermitage	TN	37076	\N	\N
4	4	4670 Lebanon Pike	Hermitage	TN	37076	\N	\N
5	5	3926 Lebanon Pike	Hermitage	TN	37076	\N	\N
6	6	4402 Lebanon Pike	Hermitage	TN	37076	\N	\N
7	7	4001 Central Pike	Hermitage	TN	37076	\N	\N
8	8	3636 Bell Rd	Nashville	TN	37214	\N	\N
\.


--
-- Name: location_id_seq; Type: SEQUENCE SET; Schema: public; Owner: tmoore82
--

SELECT pg_catalog.setval('location_id_seq', 8, true);


--
-- Data for Name: product; Type: TABLE DATA; Schema: public; Owner: tmoore82
--

COPY product (id, name, category) FROM stdin;
100	Peaches	1
101	Sweet Potatoes	1
102	White Rice	13
103	Curry Powder	7
104	Pumpkin	6
105	Allspice	7
106	Bay Leaf	7
107	Butternut Squash	1
108	Apricots	1
109	Quinoa	13
110	Spaghetti	13
111	Ground Ginger	7
112	Deoderant	14
113	Toilet Paper	14
114	Vital Wheat Gluten	14
134	Dish Detergent	14
1	Almond Milk	10
2	Fuji Apples	1
5	Unsweetened Applesauce	13
16	Mayacoba Beans	13
17	Navy Beans	13
32	Raisin Bran	13
67	Strawberry Preserves	13
68	Brown Rice	13
69	Salsa	13
70	Salt	7
72	Coke Zero 12 pack	13
73	Dr. Pepper 12 pack	13
74	Sour Cream	10
76	Yellow Squash	1
21	12 Grain Bread	13
22	Low Carb Bread	13
35	Chocolate Chips	6
6	Avocado	1
19	Pinto Beans	13
23	Broccoli	1
53	Yellow Onions	1
26	Burritos - Rice & Bean	5
66	Russet Potatoes	1
27	Margarine	10
11	Chickpeas	13
13	Kidney Beans	13
15	Large Lima Beans	13
28	Carrots	1
29	Cauliflower	1
36	Ground Cinnamon	7
37	Cream Cheese	10
38	Cucumber	1
39	Dishwasher Pacs	2
40	Disinfectant Wipes	2
41	Eggs	10
42	Garlic	1
46	Hummus	12
47	Green Lentils	13
48	Red Lenitls	13
50	Baby Bella Mushrooms	1
51	Olive Oil	6
52	Green Onions	1
62	Crunchy Peanut Butter	13
63	Peas	13
77	Sugar (Granulated)	6
78	Tempeh	1
7	Bananas	1
8	Black Beans	13
10	Black Eye Peas	13
20	Red Beans	13
24	Vegetable Broth	13
25	Sugar (Brown)	6
30	Celery	1
31	Bran Flakes	13
33	Tortilla Chips	13
34	Dark Chocolate Bars	6
44	Red Seedless Grapes	1
45	Hot Dogs	11
55	Paper Towels	2
64	Green Peppers	1
71	Turkey Sausage Snacks	13
58	Penne - Wheat	13
59	Peanut Butter Crackers	13
60	Pea Soup	13
61	Creamy Peanut Butter	13
18	Northern Beans	13
49	Artisan Lettuce	1
57	Penne - White	13
79	Extra Firm Tofu	1
80	Firm Tofu	1
81	Silken Tofu	1
82	Tomato Paste	13
83	Tomato Sauce	13
84	Tomatoes on the Vine	1
85	Sliced Turkey	11
86	Apple Cider Vinegar	6
87	Balsamic Vinegar	6
88	Red Wine Vinegar	6
89	Rice Vinegar	6
92	Flour (All Purpose)	6
93	Flour (Whole Wheat)	6
94	White Distilled Vinegar	6
95	Plastic Wrap	13
96	Pasta Sauce	13
90	Zucchini	1
3	McIntosh Apples	1
4	Red Delicious Apples	1
91	Sugar (Confectioner's)	6
129	Watercress	14
130	Spinach	14
97	Oregano	7
98	Green Beans	13
99	Prenatal Vitamins	15
\.


--
-- Name: product_id_seq; Type: SEQUENCE SET; Schema: public; Owner: tmoore82
--

SELECT pg_catalog.setval('product_id_seq', 147, true);


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: tmoore82
--

COPY roles (id, role) FROM stdin;
1	test
\.


--
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: tmoore82
--

SELECT pg_catalog.setval('roles_id_seq', 1, true);


--
-- Data for Name: store; Type: TABLE DATA; Schema: public; Owner: tmoore82
--

COPY store (id, name) FROM stdin;
1	Aldi
2	Kroger
3	Wal-Mart
4	Publix
5	Dollar General
6	CVS
7	Walgreens
8	Food Lion
\.


--
-- Name: store_id_seq; Type: SEQUENCE SET; Schema: public; Owner: tmoore82
--

SELECT pg_catalog.setval('store_id_seq', 8, true);


--
-- Data for Name: type; Type: TABLE DATA; Schema: public; Owner: tmoore82
--

COPY type (id, name) FROM stdin;
1	canned
2	dry
\.


--
-- Name: type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: tmoore82
--

SELECT pg_catalog.setval('type_id_seq', 2, true);


--
-- Data for Name: unit; Type: TABLE DATA; Schema: public; Owner: tmoore82
--

COPY unit (id, name) FROM stdin;
1	oz
2	lbs
3	fl oz
4	pcs
5	servings
6	sq ft
\.


--
-- Name: unit_id_seq; Type: SEQUENCE SET; Schema: public; Owner: tmoore82
--

SELECT pg_catalog.setval('unit_id_seq', 6, true);


--
-- Data for Name: user_roles; Type: TABLE DATA; Schema: public; Owner: tmoore82
--

COPY user_roles (user_id, role_id) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: tmoore82
--

COPY users (id, username, password) FROM stdin;
3	paulie	{SSHA}L+gjtTuB/WXh2J1pyQg63Pk1Zhj8DS4f
\.


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: tmoore82
--

SELECT pg_catalog.setval('users_id_seq', 3, true);


--
-- Name: brand_name_key; Type: CONSTRAINT; Schema: public; Owner: tmoore82; Tablespace: 
--

ALTER TABLE ONLY brand
    ADD CONSTRAINT brand_name_key UNIQUE (name);


--
-- Name: brand_pkey; Type: CONSTRAINT; Schema: public; Owner: tmoore82; Tablespace: 
--

ALTER TABLE ONLY brand
    ADD CONSTRAINT brand_pkey PRIMARY KEY (id);


--
-- Name: category_name_key; Type: CONSTRAINT; Schema: public; Owner: tmoore82; Tablespace: 
--

ALTER TABLE ONLY category
    ADD CONSTRAINT category_name_key UNIQUE (name);


--
-- Name: category_pkey; Type: CONSTRAINT; Schema: public; Owner: tmoore82; Tablespace: 
--

ALTER TABLE ONLY category
    ADD CONSTRAINT category_pkey PRIMARY KEY (id);


--
-- Name: item_pkey; Type: CONSTRAINT; Schema: public; Owner: tmoore82; Tablespace: 
--

ALTER TABLE ONLY item
    ADD CONSTRAINT item_pkey PRIMARY KEY (id);


--
-- Name: location_pkey; Type: CONSTRAINT; Schema: public; Owner: tmoore82; Tablespace: 
--

ALTER TABLE ONLY location
    ADD CONSTRAINT location_pkey PRIMARY KEY (id);


--
-- Name: product_name_key; Type: CONSTRAINT; Schema: public; Owner: tmoore82; Tablespace: 
--

ALTER TABLE ONLY product
    ADD CONSTRAINT product_name_key UNIQUE (name);


--
-- Name: product_pkey; Type: CONSTRAINT; Schema: public; Owner: tmoore82; Tablespace: 
--

ALTER TABLE ONLY product
    ADD CONSTRAINT product_pkey PRIMARY KEY (id);


--
-- Name: roles_pkey; Type: CONSTRAINT; Schema: public; Owner: tmoore82; Tablespace: 
--

ALTER TABLE ONLY roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: roles_role_key; Type: CONSTRAINT; Schema: public; Owner: tmoore82; Tablespace: 
--

ALTER TABLE ONLY roles
    ADD CONSTRAINT roles_role_key UNIQUE (role);


--
-- Name: store_name_key; Type: CONSTRAINT; Schema: public; Owner: tmoore82; Tablespace: 
--

ALTER TABLE ONLY store
    ADD CONSTRAINT store_name_key UNIQUE (name);


--
-- Name: store_pkey; Type: CONSTRAINT; Schema: public; Owner: tmoore82; Tablespace: 
--

ALTER TABLE ONLY store
    ADD CONSTRAINT store_pkey PRIMARY KEY (id);


--
-- Name: type_name_key; Type: CONSTRAINT; Schema: public; Owner: tmoore82; Tablespace: 
--

ALTER TABLE ONLY type
    ADD CONSTRAINT type_name_key UNIQUE (name);


--
-- Name: type_pkey; Type: CONSTRAINT; Schema: public; Owner: tmoore82; Tablespace: 
--

ALTER TABLE ONLY type
    ADD CONSTRAINT type_pkey PRIMARY KEY (id);


--
-- Name: unit_name_key; Type: CONSTRAINT; Schema: public; Owner: tmoore82; Tablespace: 
--

ALTER TABLE ONLY unit
    ADD CONSTRAINT unit_name_key UNIQUE (name);


--
-- Name: unit_pkey; Type: CONSTRAINT; Schema: public; Owner: tmoore82; Tablespace: 
--

ALTER TABLE ONLY unit
    ADD CONSTRAINT unit_pkey PRIMARY KEY (id);


--
-- Name: user_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: tmoore82; Tablespace: 
--

ALTER TABLE ONLY user_roles
    ADD CONSTRAINT user_roles_pkey PRIMARY KEY (user_id, role_id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: tmoore82; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users_username_key; Type: CONSTRAINT; Schema: public; Owner: tmoore82; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: item_brand_fkey; Type: FK CONSTRAINT; Schema: public; Owner: tmoore82
--

ALTER TABLE ONLY item
    ADD CONSTRAINT item_brand_fkey FOREIGN KEY (brand) REFERENCES brand(id);


--
-- Name: item_location_fkey; Type: FK CONSTRAINT; Schema: public; Owner: tmoore82
--

ALTER TABLE ONLY item
    ADD CONSTRAINT item_location_fkey FOREIGN KEY (location) REFERENCES location(id);


--
-- Name: item_product_fkey; Type: FK CONSTRAINT; Schema: public; Owner: tmoore82
--

ALTER TABLE ONLY item
    ADD CONSTRAINT item_product_fkey FOREIGN KEY (product) REFERENCES product(id);


--
-- Name: item_type_fkey; Type: FK CONSTRAINT; Schema: public; Owner: tmoore82
--

ALTER TABLE ONLY item
    ADD CONSTRAINT item_type_fkey FOREIGN KEY (type) REFERENCES type(id);


--
-- Name: item_unit_fkey; Type: FK CONSTRAINT; Schema: public; Owner: tmoore82
--

ALTER TABLE ONLY item
    ADD CONSTRAINT item_unit_fkey FOREIGN KEY (unit) REFERENCES unit(id);


--
-- Name: location_store_fkey; Type: FK CONSTRAINT; Schema: public; Owner: tmoore82
--

ALTER TABLE ONLY location
    ADD CONSTRAINT location_store_fkey FOREIGN KEY (store) REFERENCES store(id);


--
-- Name: product_category_fkey; Type: FK CONSTRAINT; Schema: public; Owner: tmoore82
--

ALTER TABLE ONLY product
    ADD CONSTRAINT product_category_fkey FOREIGN KEY (category) REFERENCES category(id);


--
-- Name: user_roles_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: tmoore82
--

ALTER TABLE ONLY user_roles
    ADD CONSTRAINT user_roles_role_id_fkey FOREIGN KEY (role_id) REFERENCES roles(id);


--
-- Name: user_roles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: tmoore82
--

ALTER TABLE ONLY user_roles
    ADD CONSTRAINT user_roles_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- Name: additems(text[]); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION additems(newitems text[]) FROM PUBLIC;
REVOKE ALL ON FUNCTION additems(newitems text[]) FROM postgres;
GRANT ALL ON FUNCTION additems(newitems text[]) TO postgres;
GRANT ALL ON FUNCTION additems(newitems text[]) TO PUBLIC;
GRANT ALL ON FUNCTION additems(newitems text[]) TO paulie;


--
-- Name: get_no_assoc(text[]); Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON FUNCTION get_no_assoc(no_assoc text[]) FROM PUBLIC;
REVOKE ALL ON FUNCTION get_no_assoc(no_assoc text[]) FROM postgres;
GRANT ALL ON FUNCTION get_no_assoc(no_assoc text[]) TO postgres;
GRANT ALL ON FUNCTION get_no_assoc(no_assoc text[]) TO PUBLIC;
GRANT ALL ON FUNCTION get_no_assoc(no_assoc text[]) TO paulie;


--
-- Name: brand; Type: ACL; Schema: public; Owner: tmoore82
--

REVOKE ALL ON TABLE brand FROM PUBLIC;
REVOKE ALL ON TABLE brand FROM tmoore82;
GRANT ALL ON TABLE brand TO tmoore82;
GRANT SELECT ON TABLE brand TO paulie;


--
-- Name: category; Type: ACL; Schema: public; Owner: tmoore82
--

REVOKE ALL ON TABLE category FROM PUBLIC;
REVOKE ALL ON TABLE category FROM tmoore82;
GRANT ALL ON TABLE category TO tmoore82;
GRANT SELECT ON TABLE category TO paulie;


--
-- Name: item; Type: ACL; Schema: public; Owner: tmoore82
--

REVOKE ALL ON TABLE item FROM PUBLIC;
REVOKE ALL ON TABLE item FROM tmoore82;
GRANT ALL ON TABLE item TO tmoore82;
GRANT SELECT ON TABLE item TO paulie;


--
-- Name: location; Type: ACL; Schema: public; Owner: tmoore82
--

REVOKE ALL ON TABLE location FROM PUBLIC;
REVOKE ALL ON TABLE location FROM tmoore82;
GRANT ALL ON TABLE location TO tmoore82;
GRANT SELECT ON TABLE location TO paulie;


--
-- Name: product; Type: ACL; Schema: public; Owner: tmoore82
--

REVOKE ALL ON TABLE product FROM PUBLIC;
REVOKE ALL ON TABLE product FROM tmoore82;
GRANT ALL ON TABLE product TO tmoore82;
GRANT SELECT,INSERT ON TABLE product TO paulie;


--
-- Name: product_id_seq; Type: ACL; Schema: public; Owner: tmoore82
--

REVOKE ALL ON SEQUENCE product_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE product_id_seq FROM tmoore82;
GRANT ALL ON SEQUENCE product_id_seq TO tmoore82;
GRANT USAGE ON SEQUENCE product_id_seq TO paulie;


--
-- Name: roles; Type: ACL; Schema: public; Owner: tmoore82
--

REVOKE ALL ON TABLE roles FROM PUBLIC;
REVOKE ALL ON TABLE roles FROM tmoore82;
GRANT ALL ON TABLE roles TO tmoore82;
GRANT SELECT ON TABLE roles TO paulie;


--
-- Name: store; Type: ACL; Schema: public; Owner: tmoore82
--

REVOKE ALL ON TABLE store FROM PUBLIC;
REVOKE ALL ON TABLE store FROM tmoore82;
GRANT ALL ON TABLE store TO tmoore82;
GRANT SELECT ON TABLE store TO paulie;


--
-- Name: type; Type: ACL; Schema: public; Owner: tmoore82
--

REVOKE ALL ON TABLE type FROM PUBLIC;
REVOKE ALL ON TABLE type FROM tmoore82;
GRANT ALL ON TABLE type TO tmoore82;
GRANT SELECT ON TABLE type TO paulie;


--
-- Name: unit; Type: ACL; Schema: public; Owner: tmoore82
--

REVOKE ALL ON TABLE unit FROM PUBLIC;
REVOKE ALL ON TABLE unit FROM tmoore82;
GRANT ALL ON TABLE unit TO tmoore82;
GRANT SELECT ON TABLE unit TO paulie;


--
-- Name: user_roles; Type: ACL; Schema: public; Owner: tmoore82
--

REVOKE ALL ON TABLE user_roles FROM PUBLIC;
REVOKE ALL ON TABLE user_roles FROM tmoore82;
GRANT ALL ON TABLE user_roles TO tmoore82;
GRANT SELECT ON TABLE user_roles TO paulie;


--
-- Name: users; Type: ACL; Schema: public; Owner: tmoore82
--

REVOKE ALL ON TABLE users FROM PUBLIC;
REVOKE ALL ON TABLE users FROM tmoore82;
GRANT ALL ON TABLE users TO tmoore82;
GRANT SELECT ON TABLE users TO paulie;


--
-- PostgreSQL database dump complete
--

