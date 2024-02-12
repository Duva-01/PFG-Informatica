--
-- PostgreSQL database dump
--

-- Dumped from database version 16.1 (Debian 16.1-1.pgdg120+1)
-- Dumped by pg_dump version 16.1 (Debian 16.1-1.pgdg120+1)

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
-- Name: accion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.accion (
    id_accion integer NOT NULL,
    nombre character varying(255),
    codigoticker character varying(10)
);


ALTER TABLE public.accion OWNER TO postgres;

--
-- Name: accion_id_accion_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.accion_id_accion_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.accion_id_accion_seq OWNER TO postgres;

--
-- Name: accion_id_accion_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.accion_id_accion_seq OWNED BY public.accion.id_accion;


--
-- Name: accionesfavoritas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.accionesfavoritas (
    id_favorito integer NOT NULL,
    id_usuario integer,
    id_accion integer
);


ALTER TABLE public.accionesfavoritas OWNER TO postgres;

--
-- Name: accionesfavoritas_id_favorito_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.accionesfavoritas_id_favorito_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.accionesfavoritas_id_favorito_seq OWNER TO postgres;

--
-- Name: accionesfavoritas_id_favorito_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.accionesfavoritas_id_favorito_seq OWNED BY public.accionesfavoritas.id_favorito;


--
-- Name: cartera; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cartera (
    id_cartera integer NOT NULL,
    id_usuario integer,
    saldo double precision DEFAULT 10000 NOT NULL,
    total_depositado double precision DEFAULT 0 NOT NULL,
    total_retirado double precision DEFAULT 0 NOT NULL,
    total_transacciones integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.cartera OWNER TO postgres;

--
-- Name: cartera_id_cartera_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cartera_id_cartera_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cartera_id_cartera_seq OWNER TO postgres;

--
-- Name: cartera_id_cartera_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cartera_id_cartera_seq OWNED BY public.cartera.id_cartera;


--
-- Name: transaccion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transaccion (
    id_transaccion integer NOT NULL,
    id_cartera integer,
    id_accion integer,
    tipo character varying(10) NOT NULL,
    cantidad integer NOT NULL,
    precio double precision NOT NULL,
    fecha timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.transaccion OWNER TO postgres;

--
-- Name: transaccion_id_transaccion_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.transaccion_id_transaccion_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.transaccion_id_transaccion_seq OWNER TO postgres;

--
-- Name: transaccion_id_transaccion_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.transaccion_id_transaccion_seq OWNED BY public.transaccion.id_transaccion;


--
-- Name: usuario; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usuario (
    id integer NOT NULL,
    nombre character varying(255),
    apellido character varying(255),
    "contraseña" character varying(255),
    email character varying(255)
);


ALTER TABLE public.usuario OWNER TO postgres;

--
-- Name: usuario_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.usuario_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.usuario_id_seq OWNER TO postgres;

--
-- Name: usuario_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.usuario_id_seq OWNED BY public.usuario.id;


--
-- Name: accion id_accion; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accion ALTER COLUMN id_accion SET DEFAULT nextval('public.accion_id_accion_seq'::regclass);


--
-- Name: accionesfavoritas id_favorito; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accionesfavoritas ALTER COLUMN id_favorito SET DEFAULT nextval('public.accionesfavoritas_id_favorito_seq'::regclass);


--
-- Name: cartera id_cartera; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cartera ALTER COLUMN id_cartera SET DEFAULT nextval('public.cartera_id_cartera_seq'::regclass);


--
-- Name: transaccion id_transaccion; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transaccion ALTER COLUMN id_transaccion SET DEFAULT nextval('public.transaccion_id_transaccion_seq'::regclass);


--
-- Name: usuario id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario ALTER COLUMN id SET DEFAULT nextval('public.usuario_id_seq'::regclass);


--
-- Data for Name: accion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.accion (id_accion, nombre, codigoticker) FROM stdin;
1	Apple Inc.	AAPL
2	Microsoft Corporation	MSFT
3	Amazon.com, Inc.	AMZN
4	Alphabet Inc.	GOOGL
5	Tesla, Inc.	TSLA
6	JPMorgan Chase & Co.	JPM
7	Johnson & Johnson	JNJ
8	Visa Inc.	V
9	The Procter & Gamble Company	PG
10	The Home Depot, Inc.	HD
11	Mastercard Incorporated	MA
12	UnitedHealth Group Incorporated	UNH
13	NVIDIA Corporation	NVDA
14	Bank of America Corporation	BAC
15	PayPal Holdings, Inc.	PYPL
16	Netflix, Inc.	NFLX
17	Adobe Inc.	ADBE
18	The Coca-Cola Company	KO
19	Comcast Corporation	CMCSA
20	Exxon Mobil Corporation	XOM
21	AT&T Inc.	T
22	Intel Corporation	INTC
23	Verizon Communications Inc.	VZ
24	Pfizer Inc.	PFE
25	The Walt Disney Company	DIS
26	Cisco Systems, Inc.	CSCO
27	Salesforce, Inc.	CRM
28	Walmart Inc.	WMT
29	Abbott Laboratories	ABT
30	PepsiCo, Inc.	PEP
31	NIKE, Inc.	NKE
32	McDonald's Corporation	MCD
33	Wells Fargo & Company	WFC
34	Chevron Corporation	CVX
35	The Boeing Company	BA
36	Airbnb, Inc.	ABNB
37	American Airlines Group Inc.	AAL
38	Delta Air Lines, Inc.	DAL
39	United Airlines Holdings, Inc.	UAL
40	Block, Inc.	SQ
41	Zoom Video Communications, Inc.	ZM
42	Roku, Inc.	ROKU
43	Snap Inc.	SNAP
44	DocuSign, Inc.	DOCU
45	Uber Technologies, Inc.	UBER
46	Lyft, Inc.	LYFT
47	Barrick Gold Corporation	GOLD
48	Target Corporation	TGT
49	Costco Wholesale Corporation	COST
50	Caterpillar Inc.	CAT
51	International Business Machines Corporation	IBM
52	Oracle Corporation	ORCL
53	CVS Health Corporation	CVS
54	FedEx Corporation	FDX
55	United Parcel Service, Inc.	UPS
56	United States Steel Corporation	X
57	Zscaler, Inc.	ZS
58	Datadog, Inc.	DDOG
59	Dover Corporation	DOV
60	Emerson Electric Co.	EMR
61	Exelon Corporation	EXC
62	Cummins Inc.	CMI
63	Lockheed Martin Corporation	LMT
64	Northrop Grumman Corporation	NOC
65	RTX Corporation	RTX
66	Regeneron Pharmaceuticals, Inc.	REGN
67	Amgen Inc.	AMGN
68	Gilead Sciences, Inc.	GILD
69	AbbVie Inc.	ABBV
70	Biogen Inc.	BIIB
71	Vertex Pharmaceuticals Incorporated	VRTX
72	Illumina, Inc.	ILMN
73	IDEXX Laboratories, Inc.	IDXX
74	Align Technology, Inc.	ALGN
75	Cadence Design Systems, Inc.	CDNS
76	Cognizant Technology Solutions Corporation	CTSH
77	NetEase, Inc.	NTES
78	Synopsys, Inc.	SNPS
79	Walgreens Boots Alliance, Inc.	WBA
80	Workday, Inc.	WDAY
81	Fidelity National Information Services, Inc.	FIS
82	Automatic Data Processing, Inc.	ADP
83	KLA Corporation	KLAC
84	Microchip Technology Incorporated	MCHP
85	Cintas Corporation	CTAS
86	Mettler-Toledo International Inc.	MTD
87	Arista Networks, Inc.	ANET
88	Monster Beverage Corporation	MNST
89	Xcel Energy Inc.	XEL
90	Yum! Brands, Inc.	YUM
91	Copart, Inc.	CPRT
92	Wix.com Ltd.	WIX
93	BioMarin Pharmaceutical Inc.	BMRN
94	Fox Corporation	FOX
95	Fox Corporation	FOXA
96	NetApp, Inc.	NTAP
97	Seagen Inc.	SGEN
98	Royal Caribbean Cruises Ltd.	RCL
99	AutoZone, Inc.	AZO
100	Analog Devices, Inc.	ADI
101	ResMed Inc.	RMD
102	PulteGroup, Inc.	PHM
103	Advanced Micro Devices, Inc.	AMD
104	Yum China Holdings, Inc.	YUMC
105	Lululemon Athletica Inc.	LULU
106	Albemarle Corporation	ALB
107	United Rentals, Inc.	URI
108	Charter Communications, Inc.	CHTR
109	Synchrony Financial	SYF
110	Fortinet, Inc.	FTNT
111	ServiceNow, Inc.	NOW
112	Zebra Technologies Corporation	ZBRA
113	Twilio Inc.	TWLO
114	Paycom Software, Inc.	PAYC
115	Applied Materials, Inc.	AMAT
116	Autodesk, Inc.	ADSK
117	CDW Corporation	CDW
118	Advance Auto Parts, Inc.	AAP
119	Invitae Corporation	NVTA
120	Western Digital Corporation	WDC
121	FLEETCOR Technologies, Inc.	FLT
122	RingCentral, Inc.	RNG
123	Match Group, Inc.	MTCH
124	Garmin Ltd.	GRMN
125	Wynn Resorts, Limited	WYNN
126	Ulta Beauty, Inc.	ULTA
127	Texas Instruments Incorporated	TXN
128	Seagate Technology Holdings plc	STX
129	NETGEAR, Inc.	NTGR
130	Pegasystems Inc.	PEGA
131	Okta, Inc.	OKTA
132	StoneCo Ltd.	STNE
133	Veeva Systems Inc.	VEEV
134	Palo Alto Networks, Inc.	PANW
135	Fair Isaac Corporation	FICO
136	HubSpot, Inc.	HUBS
137	The Trade Desk, Inc.	TTD
138	MongoDB, Inc.	MDB
139	Pinterest, Inc.	PINS
140	Fastly, Inc.	FSLY
141	CrowdStrike Holdings, Inc.	CRWD
142	Splunk Inc.	SPLK
143	PagerDuty, Inc.	PD
144	Etsy, Inc.	ETSY
145	Peloton Interactive, Inc.	PTON
146	Farfetch Limited	FTCH
147	CRISPR Therapeutics AG	CRSP
148	Shopify Inc.	SHOP
149	2U, Inc.	TWOU
150	Everbridge, Inc.	EVBG
151	Alteryx, Inc.	AYX
152	Banco Santander, S.A.	SAN
153	Banco Bilbao Vizcaya Argentaria, S.A.	BBVA
154	Telefónica, S.A.	TEF
155	American Shared Hospital Services	AMS
156	Saratoga Investment Corp. NT 23	SAB
\.


--
-- Data for Name: accionesfavoritas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.accionesfavoritas (id_favorito, id_usuario, id_accion) FROM stdin;
1	3	1
2	3	3
3	3	4
\.


--
-- Data for Name: cartera; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cartera (id_cartera, id_usuario, saldo, total_depositado, total_retirado, total_transacciones) FROM stdin;
3	3	8824.049987792969	0	0	5
\.


--
-- Data for Name: transaccion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.transaccion (id_transaccion, id_cartera, id_accion, tipo, cantidad, precio, fecha) FROM stdin;
1	3	1	compra	4	188.85000610351562	2024-02-12 14:21:20.133656
2	3	1	compra	3	188.85000610351562	2024-02-12 14:21:28.472531
3	3	1	venta	3	188.85000610351562	2024-02-12 14:21:38.049814
4	3	2	compra	2	420.54998779296875	2024-02-12 14:21:48.637008
5	3	2	venta	1	420.54998779296875	2024-02-12 14:21:55.898622
\.


--
-- Data for Name: usuario; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.usuario (id, nombre, apellido, "contraseña", email) FROM stdin;
3	David	Martinez	scrypt:32768:8:1$4fXQjnW5Cj3SQvG7$092908433e708c961f34c8344110f6147e893c45e3b01d0d3095f83861f64f59302478574938d9ebff69eff25d727d27ed17b16a15199bce20773cc1a51c815f	david@gmail.com
\.


--
-- Name: accion_id_accion_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.accion_id_accion_seq', 156, true);


--
-- Name: accionesfavoritas_id_favorito_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.accionesfavoritas_id_favorito_seq', 3, true);


--
-- Name: cartera_id_cartera_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cartera_id_cartera_seq', 3, true);


--
-- Name: transaccion_id_transaccion_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.transaccion_id_transaccion_seq', 5, true);


--
-- Name: usuario_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.usuario_id_seq', 3, true);


--
-- Name: accion accion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accion
    ADD CONSTRAINT accion_pkey PRIMARY KEY (id_accion);


--
-- Name: accionesfavoritas accionesfavoritas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accionesfavoritas
    ADD CONSTRAINT accionesfavoritas_pkey PRIMARY KEY (id_favorito);


--
-- Name: cartera cartera_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cartera
    ADD CONSTRAINT cartera_pkey PRIMARY KEY (id_cartera);


--
-- Name: transaccion transaccion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transaccion
    ADD CONSTRAINT transaccion_pkey PRIMARY KEY (id_transaccion);


--
-- Name: usuario usuario_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_email_key UNIQUE (email);


--
-- Name: usuario usuario_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_pkey PRIMARY KEY (id);


--
-- Name: accionesfavoritas accionesfavoritas_id_accion_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accionesfavoritas
    ADD CONSTRAINT accionesfavoritas_id_accion_fkey FOREIGN KEY (id_accion) REFERENCES public.accion(id_accion);


--
-- Name: accionesfavoritas accionesfavoritas_id_usuario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accionesfavoritas
    ADD CONSTRAINT accionesfavoritas_id_usuario_fkey FOREIGN KEY (id_usuario) REFERENCES public.usuario(id);


--
-- Name: cartera cartera_id_usuario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cartera
    ADD CONSTRAINT cartera_id_usuario_fkey FOREIGN KEY (id_usuario) REFERENCES public.usuario(id);


--
-- Name: transaccion transaccion_id_accion_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transaccion
    ADD CONSTRAINT transaccion_id_accion_fkey FOREIGN KEY (id_accion) REFERENCES public.accion(id_accion);


--
-- Name: transaccion transaccion_id_cartera_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transaccion
    ADD CONSTRAINT transaccion_id_cartera_fkey FOREIGN KEY (id_cartera) REFERENCES public.cartera(id_cartera);


--
-- PostgreSQL database dump complete
--

