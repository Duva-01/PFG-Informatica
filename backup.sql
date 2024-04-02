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
-- Name: articulosaprendizaje; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.articulosaprendizaje (
    id integer NOT NULL,
    seccion character varying(255) NOT NULL,
    titulo character varying(255) NOT NULL,
    imageurl text NOT NULL,
    resumen text NOT NULL,
    contenido text NOT NULL
);


ALTER TABLE public.articulosaprendizaje OWNER TO postgres;

--
-- Name: articulosaprendizaje_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.articulosaprendizaje_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.articulosaprendizaje_id_seq OWNER TO postgres;

--
-- Name: articulosaprendizaje_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.articulosaprendizaje_id_seq OWNED BY public.articulosaprendizaje.id;


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
-- Name: notificaciones; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notificaciones (
    id integer NOT NULL,
    usuario_id integer NOT NULL,
    mensaje text NOT NULL,
    fecha timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.notificaciones OWNER TO postgres;

--
-- Name: notificaciones_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.notificaciones_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.notificaciones_id_seq OWNER TO postgres;

--
-- Name: notificaciones_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.notificaciones_id_seq OWNED BY public.notificaciones.id;


--
-- Name: reset_clave_token; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reset_clave_token (
    id integer NOT NULL,
    usuario_id integer NOT NULL,
    token character varying(100) NOT NULL,
    fecha_expiracion timestamp without time zone NOT NULL
);


ALTER TABLE public.reset_clave_token OWNER TO postgres;

--
-- Name: reset_clave_token_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.reset_clave_token_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.reset_clave_token_id_seq OWNER TO postgres;

--
-- Name: reset_clave_token_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.reset_clave_token_id_seq OWNED BY public.reset_clave_token.id;


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
-- Name: articulosaprendizaje id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.articulosaprendizaje ALTER COLUMN id SET DEFAULT nextval('public.articulosaprendizaje_id_seq'::regclass);


--
-- Name: cartera id_cartera; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cartera ALTER COLUMN id_cartera SET DEFAULT nextval('public.cartera_id_cartera_seq'::regclass);


--
-- Name: notificaciones id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notificaciones ALTER COLUMN id SET DEFAULT nextval('public.notificaciones_id_seq'::regclass);


--
-- Name: reset_clave_token id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reset_clave_token ALTER COLUMN id SET DEFAULT nextval('public.reset_clave_token_id_seq'::regclass);


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
4	3	13
5	3	15
\.


--
-- Data for Name: articulosaprendizaje; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.articulosaprendizaje (id, seccion, titulo, imageurl, resumen, contenido) FROM stdin;
1	IntroFinanzas	¿Qué son las finanzas?	https://finanzaspara.com/wp-content/uploads/2023/09/Que-son-las-finanzas-2.png	Introducción al concepto de finanzas y su importancia en la vida cotidiana.	## ¿Qué son las finanzas?\\n\\nLas finanzas se refieren al estudio del manejo del dinero y cómo los individuos, empresas y gobiernos adquieren, gastan y administran el capital necesario para cumplir sus objetivos. Este campo abarca una amplia gama de actividades, desde la banca hasta la inversión y el análisis de riesgos.\\n\\n![Imagen de Finanzas](https://finanzaspara.com/wp-content/uploads/2023/09/Que-son-las-finanzas-2.png)\\n\\n### Importancia de las finanzas\\n\\nLas finanzas juegan un papel crucial en casi todos los aspectos de la vida moderna. Algunas de las razones por las que las finanzas son tan importantes incluyen:\\n\\n- **Toma de decisiones**: Las finanzas proporcionan las herramientas y análisis necesarios para tomar decisiones informadas sobre inversiones, créditos y gestión de riesgos.\\n\\n- **Planificación financiera**: Ayuda tanto a individuos como a organizaciones a planificar su futuro, asegurando que tengan los recursos necesarios para alcanzar sus objetivos.\\n\\n- **Optimización de recursos**: A través de la presupuestación y la administración eficiente del capital, las finanzas permiten la optimización de los recursos disponibles.\\n\\n#### Ejemplo simple:\\nSupongamos que tienes un presupuesto mensual de \\$1000. Usar principios financieros básicos te puede ayudar a determinar cómo dividir ese dinero entre ahorros, gastos esenciales y lujos, maximizando tu bienestar general.\\n\\n#### Ejemplo financiero:\\nEn una empresa, decidir si invertir en un nuevo proyecto puede implicar calcular el valor presente neto (VPN) del proyecto y compararlo con otros posibles usos del capital. Esto requiere entender conceptos financieros como el flujo de caja, la tasa de descuento y el período de recuperación de la inversión.\\n\\n### Campos de estudio en finanzas\\n\\nLas finanzas se dividen generalmente en tres categorías principales:\\n\\n1. **Finanzas personales**: Se centra en cómo los individuos o familias ganan, gastan y ahorran dinero. También trata sobre la planificación financiera para la educación, la jubilación, y la inversión personal.\\n\\n2. **Finanzas corporativas**: Trata sobre cómo las empresas manejan sus fuentes de financiamiento, estructura de capital, y decisiones de inversión para maximizar el valor para los accionistas.\\n\\n3. **Finanzas públicas**: Implica el estudio de la política fiscal y monetaria, la gestión de los ingresos y gastos del sector público, y cómo afectan la economía en general.\\n\\n#### Tabla de comparación:\\n\\n| Categoría          | Foco                                      | Ejemplo de Actividad         |\\n|--------------------|-------------------------------------------|------------------------------|\\n| Finanzas personales| Individuos y familias                     | Planificación para la jubilación |\\n| Finanzas corporativas| Empresas                                 | Estructuración de capital    |\\n| Finanzas públicas  | Sector público y políticas económicas     | Gestión de deuda pública     |\\n\\n### Conceptos fundamentales en finanzas\\n\\nAlgunos conceptos fundamentales que subyacen en el campo de las finanzas incluyen:\\n\\n- **Valor del dinero en el tiempo**: Este concepto establece que un dólar hoy vale más que un dólar en el futuro debido a su potencial de inversión. Se puede calcular usando fórmulas de valor presente (VP) y valor futuro (VF).\\n\\n  \\[ VP = \\frac{FV}{(1 + r)^n} \\]\\n  \\n  Donde \\( FV \\) es el valor futuro, \\( r \\) es la tasa de interés y \\( n \\) es el número de periodos.\\n\\n- **Diversificación**: Estrategia de inversión para reducir el riesgo combinando una variedad de inversiones dentro de una cartera.\\n\\n- **Riesgo y rendimiento**: Principio que indica que a mayor riesgo asumido, potencialmente mayor será el retorno esperado de una inversión.\\n\\n'
2	IntroFinanzas	Historia de las finanzas	https://e00-expansion.uecdn.es/assets/multimedia/imagenes/2016/07/20/14690066920665.jpg	Un recorrido por la evolución de las finanzas a través del tiempo.	## Historia de las finanzas\\n\\nLa historia de las finanzas es una fascinante travesía a través del tiempo, mostrando cómo la humanidad ha gestionado los recursos desde las sociedades antiguas hasta la era digital moderna.\\n\\n![Evolución de las Finanzas](https://e00-expansion.uecdn.es/assets/multimedia/imagenes/2016/07/20/14690066920665.jpg)\\n\\n### Momentos clave en la historia de las finanzas\\n\\nLa gestión del dinero y el valor ha sido crucial para el desarrollo de las civilizaciones. Aquí se destacan algunos hitos importantes:\\n\\n- **Mesopotamia y el trueque (3000 a.C. aproximadamente)**: Las primeras sociedades utilizaban sistemas de trueque para el intercambio de bienes y servicios. \\n\\n- **Monedas de Lydia (alrededor del 600 a.C.)**: Lydia, en lo que hoy es Turquía, introdujo las primeras monedas de metal, lo que facilitó el comercio y la acumulación de riqueza.\\n\\n- **Bancos del Renacimiento (Siglo XV)**: Los bancos modernos comenzaron a surgir en Italia, ofreciendo servicios como el cambio de moneda, préstamos y la custodia de valores.\\n\\n- **Revolución Industrial (Siglo XVIII y XIX)**: La expansión de las empresas y el comercio a gran escala requirió sistemas financieros más sofisticados, incluyendo la creación de mercados de valores.\\n\\n- **Era digital y las criptomonedas (Siglo XXI)**: La tecnología ha transformado las finanzas, introduciendo la banca en línea, las fintech y las criptomonedas como Bitcoin.\\n\\n#### Evolución de las herramientas financieras\\n\\n| Periodo             | Herramienta Financiera    | Impacto                                      |\\n|---------------------|---------------------------|----------------------------------------------|\\n| Antigüedad          | Trueque                   | Intercambio de bienes sin necesidad de dinero|\\n| 600 a.C.            | Monedas de metal          | Estándarización y facilidad en el comercio   |\\n| Siglo XV            | Bancos modernos           | Diversificación de servicios financieros     |\\n| Siglos XVIII y XIX  | Mercados de valores       | Inversión y financiamiento empresarial       |\\n| Siglo XXI           | Criptomonedas             | Innovación en transacciones y almacenamiento de valor |\\n\\n### Importancia de conocer la historia financiera\\n\\nEntender la evolución de las finanzas permite apreciar cómo las innovaciones han resuelto desafíos económicos a lo largo del tiempo y cómo pueden surgir nuevas soluciones para los problemas actuales. Además, ofrece perspectivas sobre la estabilidad económica, la inflación, y cómo las políticas financieras afectan a la sociedad.\\n
3	IntroFinanzas	Principales conceptos financieros	https://image.slidesharecdn.com/conceptosfinancierosbsicos-171001040305/85/conceptos-financieros-bsicos-5-320.jpg?cb=1665625650	Exploración de los conceptos clave en finanzas que todos deberían conocer.	## Principales conceptos financieros\\n\\nComprender los conceptos financieros fundamentales es crucial para la gestión eficaz del dinero tanto a nivel personal como empresarial.\\n\\n![Conceptos Financieros Clave](https://image.slidesharecdn.com/conceptosfinancierosbsicos-171001040305/85/conceptos-financieros-bsicos-5-320.jpg?cb=1665625650)\\n\\n### Conceptos clave explicados\\n\\n1. **Inversión**: Consiste en colocar capital con la expectativa de obtener un retorno financiero. Las inversiones pueden variar desde la compra de acciones en la bolsa hasta la adquisición de bienes raíces.\\n\\n2. **Interés compuesto**: Es el interés calculado tanto sobre el capital inicial como sobre los intereses acumulados de periodos anteriores. Esto puede aumentar significativamente el valor de una inversión a lo largo del tiempo.\\n\\n    \\[ A = P(1 + r/n)^{nt} \\]\\n\\n    Donde \\(A\\) es el monto final, \\(P\\) el principal, \\(r\\) la tasa de interés anual, \\(n\\) el número de veces que el interés se compone por año, y \\(t\\) los años.\\n\\n3. **Riesgo y rendimiento**: Representa la premisa de que a mayor riesgo asociado a una inversión, mayor es el potencial de rendimiento. Elegir dónde invertir implica balancear estos dos factores según las metas y tolerancia al riesgo del inversor.\\n\\n4. **Diversificación**: La práctica de invertir en una variedad de activos para reducir el riesgo. Al diversificar, el rendimiento negativo de una inversión puede ser compensado por el rendimiento positivo de otra.\\n\\n5. **Valor del dinero en el tiempo**: Este concepto destaca que un dólar disponible hoy vale más que un dólar recibido en el futuro debido a su potencial de inversión.\\n\\n#### Tabla de inversión y retorno esperado\\n\\n| Tipo de Inversión  | Riesgo     | Retorno Esperado  |\\n|--------------------|------------|-------------------|\\n| Cuenta de ahorros  | Bajo       | 1-2%              |\\n| Bonos              | Medio      | 2-5%              |\\n| Acciones           | Alto       | 5-10%+            |\\n\\n### Conclusión\\n\\nEntender estos conceptos es vital para la toma de decisiones financieras informadas, ya sea para la gestión de finanzas personales o la estrategia empresarial. Conocimientos financieros sólidos permiten a individuos y empresas maximizar sus recursos y alcanzar sus objetivos económicos.\\n
4	IntroFinanzas	Cómo empezar a invertir	https://www.thepowermba.com/es/wp-content/uploads/2022/07/Empezar-a-invertir-1024x409.jpg	Guía básica para aquellos que deseen comenzar a invertir su dinero.	## Cómo empezar a invertir\\n\\nIniciar en el mundo de las inversiones es un paso crucial para construir riqueza y alcanzar la libertad financiera. Sin embargo, puede ser abrumador sin una guía clara.\\n\\n![Iniciar Inversiones](https://www.thepowermba.com/es/wp-content/uploads/2022/07/Empezar-a-invertir-1024x409.jpg)\\n\\n### Pasos iniciales para invertir\\n\\n1. **Educación Financiera**: Antes de invertir, es esencial entender los fundamentos de las finanzas y las inversiones. Recursos como libros, cursos en línea y podcasts pueden ser de gran ayuda.\\n\\n2. **Definir Objetivos de Inversión**: Tener claros los objetivos financieros ayudará a elegir las inversiones adecuadas. Por ejemplo, ahorrar para la jubilación o la educación de los hijos.\\n\\n3. **Establecer un Presupuesto de Inversión**: Determina cuánto dinero puedes invertir de manera regular sin comprometer tus gastos esenciales.\\n\\n4. **Abrir una Cuenta de Inversión**: Selecciona una plataforma de inversión o un corredor de bolsa con buena reputación y baja comisión.\\n\\n5. **Diversificar**: Invierte en una variedad de activos para minimizar el riesgo. Esto incluye acciones, bonos, fondos mutuos, y más.\\n\\n6. **Monitorizar y Ajustar**: Revisa periódicamente tu cartera de inversiones y realiza ajustes según sea necesario para alinearse con tus objetivos financieros.\\n\\n#### Ejemplo de diversificación de cartera\\n\\n| Tipo de Activo     | Porcentaje del Portafolio |\\n|--------------------|---------------------------|\\n| Acciones           | 50%                       |\\n| Bonos              | 30%                       |\\n| Fondos Indexados   | 20%                       |\\n\\n### Consideraciones importantes\\n\\n- **Riesgo vs. Retorno**: Entiende tu tolerancia al riesgo antes de realizar inversiones.\\n- **Costos de Inversión**: Ten en cuenta las comisiones y tasas asociadas con diferentes tipos de inversiones.\\n- **Planificación a Largo Plazo**: La inversión es más efectiva como una estrategia a largo plazo.\\n\\n### Conclusión\\n\\nComenzar a invertir puede parecer desafiante, pero con la educación adecuada y una planificación cuidadosa, puede convertirse en una poderosa herramienta para alcanzar la seguridad financiera y los objetivos de vida.\\n
6	Inversion	Análisis Fundamental vs. Análisis Técnico	https://media.licdn.com/dms/image/C4D12AQFHGzu0cn4j-w/article-cover_image-shrink_600_2000/0/1594657000983?e=2147483647&v=beta&t=TnKOZXV6AMtBoem6T_ZyLLBIBxoNYPP8CdJ7jLTUUSY	Exploración de las dos principales metodologías de análisis utilizadas en la selección de inversiones, ofreciendo una comparación detallada entre el análisis fundamental y el técnico, sus aplicaciones prácticas y ejemplos reales.	## Análisis Fundamental vs. Análisis Técnico\r\n\r\nLa selección efectiva de inversiones es fundamental para cualquier estrategia de inversión exitosa. Entre las metodologías más destacadas para evaluar oportunidades de inversión se encuentran el análisis fundamental y el análisis técnico. Estos enfoques ofrecen perspectivas distintas pero complementarias sobre el valor y el comportamiento potencial de los activos financieros.\r\n\r\n### Análisis Fundamental\r\n\r\nEl análisis fundamental se centra en evaluar el valor intrínseco de una inversión, examinando factores económicos, financieros, cualitativos y cuantitativos. \r\n\r\n![Análisis Fundamental vs. Análisis Técnico](https://media.licdn.com/dms/image/C4D12AQFHGzu0cn4j-w/article-cover_image-shrink_600_2000/0/1594657000983?e=2147483647&v=beta&t=TnKOZXV6AMtBoem6T_ZyLLBIBxoNYPP8CdJ7jLTUUSY)\r\n\r\n#### Principios Clave\r\n\r\n- **Salud Financiera**: Evaluación de balances, estados de resultados y flujos de caja.\r\n- **Indicadores Económicos**: Análisis del entorno macroeconómico y su impacto en el sector.\r\n- **Valoración**: Uso de ratios como Precio/Ganancia (P/E), Precio/Valor Contable (P/B), y otros para determinar si una acción está subvaluada o sobrevaluada.\r\n\r\n#### Fórmula del P/E\r\nUna herramienta esencial en el análisis fundamental es el ratio Precio/Ganancia (P/E), que mide la relación entre el precio de mercado de una acción y sus ganancias por acción (EPS).\r\n\r\nP/E = Precio de Mercado por Acción / Ganancia por Acción\r\n\r\nEste indicador ayuda a los inversores a estimar el valor de mercado relativo de una empresa.\r\n\r\n### Análisis Técnico\r\n\r\nA diferencia del análisis fundamental, el análisis técnico se enfoca en el estudio de los patrones de precios y volúmenes de trading del mercado, utilizando gráficos e indicadores para predecir futuros movimientos de precios.\r\n\r\n#### Principios Clave\r\n\r\n- **Tendencias del Mercado**: Identificación de tendencias ascendentes, descendentes o laterales en los precios de los activos.\r\n- **Patrones Gráficos**: Análisis de formaciones como cabezas y hombros, triángulos y banderas que pueden indicar movimientos futuros de precios.\r\n- **Indicadores Técnicos**: Uso de herramientas como medias móviles, RSI (Índice de Fuerza Relativa) y MACD (Convergencia/Divergencia de Medias Móviles) para analizar el momento del mercado.\r\n\r\n#### Media Móvil\r\nLas medias móviles suavizan el movimiento del precio para identificar tendencias. Una estrategia común es observar el cruce de medias móviles de corto y largo plazo.\r\n\r\nMedia Móvil Simple = Suma de Precios de Cierre / Número de Periodos\r\n\r\n### Comparación de Métodos\r\n\r\n- **Enfoque Temporal**: Mientras el análisis fundamental es ideal para inversiones a largo plazo basadas en el valor intrínseco, el análisis técnico es preferido por traders a corto plazo interesados en patrones de precio y volumen.\r\n- **Aplicabilidad**: El análisis fundamental se utiliza ampliamente para acciones y bonos, mientras que el técnico es aplicable a cualquier activo con datos de precios históricos.\r\n\r\n### Caso de Estudio: Aplicación en la Selección de Acciones\r\n\r\nUn inversor puede combinar ambos análisis para tomar decisiones informadas. Por ejemplo, podría usar el análisis fundamental para seleccionar una empresa con sólidos fundamentos y luego aplicar el análisis técnico para determinar el momento óptimo de compra o venta basado en los patrones del mercado.\r\n
5	Inversion	Fundamentos de la Inversión	https://sinergiaformacion.es/wp-content/uploads/2014/12/fundamentos-inversion.jpg	Introducción a los conceptos básicos de inversión, tipos de activos invertibles y la importancia de la diversificación.	## Fundamentos de la Inversión\r\n\r\nInvertir es el acto de dedicar recursos, generalmente dinero, con la expectativa de generar ingresos o ganancias. Comprender los fundamentos de la inversión es crucial para cualquier persona que busque tomar decisiones financieras informadas y construir una base sólida para su futuro financiero.\r\n\r\n![Fundamentos de la Inversión](https://sinergiaformacion.es/wp-content/uploads/2014/12/fundamentos-inversion.jpg)\r\n\r\n### Conceptos básicos de inversión\r\n\r\n1. **Valor del Dinero en el Tiempo**: El principio del valor del dinero en el tiempo nos dice que el valor de una cantidad de dinero recibida hoy es más grande que el mismo monto recibido en una fecha futura. Esto se debe al potencial de ganancia a través de la inversión. La fórmula para calcular el valor futuro (VF) es VF = VP * (1 + r)^n, donde VP es el valor presente, r es la tasa de interés por período, y n es el número de períodos.\r\n\r\n2. **Riesgo vs. Retorno**: Existe una relación directa entre el nivel de riesgo asumido en una inversión y el retorno esperado. Las inversiones con mayor riesgo, como las acciones, suelen ofrecer la posibilidad de mayores retornos para compensar al inversor por asumir ese riesgo adicional.\r\n\r\n3. **Diversificación**: Diversificar la cartera de inversión significa invertir en una variedad de activos para reducir el riesgo. La idea es que si una inversión disminuye en valor, otra podría aumentar o mantener su valor, equilibrando así las pérdidas.\r\n\r\n4. **Comprensión del Mercado**: Tener un conocimiento básico de cómo funcionan los mercados financieros puede ayudar a los inversores a tomar decisiones más informadas. Esto incluye entender los ciclos económicos, cómo las noticias y eventos globales pueden afectar los mercados, y el papel de la oferta y la demanda.\r\n\r\n### Tipos de activos invertibles\r\n\r\n- **Acciones**: Representan una fracción de la propiedad en una empresa y su valor puede aumentar si la empresa crece y se vuelve más rentable. Sin embargo, también son susceptibles a la volatilidad del mercado.\r\n\r\n- **Bonos**: Son préstamos que los inversores hacen a emisores corporativos o gubernamentales a cambio de pagos de intereses regulares y la devolución del principal en una fecha futura. Se consideran menos riesgosos que las acciones.\r\n\r\n- **Fondos Mutuos**: Permiten a los inversores comprar una cesta de acciones, bonos u otros valores, lo que proporciona una diversificación instantánea incluso con una inversión relativamente pequeña.\r\n\r\n- **Bienes Raíces**: La inversión en propiedades puede generar ingresos a través del alquiler y potencial de apreciación del valor de la propiedad. Sin embargo, requiere un compromiso de capital significativo y puede tener una liquidez limitada.\r\n\r\n- **Criptomonedas**: Aunque ofrecen un alto potencial de retorno, las criptomonedas son extremadamente volátiles y su mercado está menos regulado que otros activos financieros.\r\n\r\n#### Ejemplo de diversificación en activos\r\n\r\n| Tipo de Activo  | Ejemplo                   | Característica Clave         |\r\n|-----------------|---------------------------|------------------------------|\r\n| Acciones        | Empresas tecnológicas     | Potencial de alto crecimiento|\r\n| Bonos           | Bonos gubernamentales     | Ingresos estables y seguros  |\r\n| Fondos Mutuos   | Fondo índice S&P 500      | Diversificación instantánea  |\r\n| Bienes Raíces   | Propiedades de alquiler   | Ingreso pasivo               |\r\n| Criptomonedas   | Bitcoin, Ethereum         | Alta volatilidad             |\r\n\r\n### Consideraciones importantes\r\n\r\n- **Análisis de Riesgo**: Antes de realizar cualquier inversión, es crucial evaluar tu tolerancia al riesgo y cómo se alinea con tus objetivos financieros a largo plazo.\r\n\r\n- **Costos de Inversión**: Siempre ten en cuenta las comisiones y tasas asociadas con diferentes tipos de inversiones y cómo pueden afectar tus retornos.\r\n\r\n- **Educación Continua**: El mundo de las inversiones está siempre en cambio, por lo que es importante mantenerse informado y continuar educándose sobre nuevos productos de inversión y estrategias.\r\n\r\nInvertir con conocimiento y una estrategia bien considerada puede abrir la puerta a la seguridad financiera y la acumulación de riqueza a largo plazo.
7	Inversion	Estrategias de Inversión a Largo Plazo	https://media.licdn.com/dms/image/D5612AQGaoqPHH43Stw/article-cover_image-shrink_720_1280/0/1702342971125?e=2147483647&v=beta&t=xa8qcllf49UUVddKOkJhaMoRxKXfHhD9OC-vGTa2uSA	Ventajas y enfoques de la inversión a largo plazo, incluyendo la inversión en valor y crecimiento.	## Estrategias de Inversión a Largo Plazo\r\n\r\nInvertir con una perspectiva a largo plazo es una filosofía que prioriza la acumulación de riqueza gradual a través del tiempo. Esta aproximación requiere paciencia, disciplina y un enfoque en el valor intrínseco y el crecimiento potencial de las inversiones, más que en las fluctuaciones de precios a corto plazo.\r\n\r\n### Beneficios de Invertir a Largo Plazo\r\n\r\n- **Compuesto del Interés**: La reinversión de ganancias permite el crecimiento exponencial de la inversión inicial.\r\n- **Mitigación de Riesgos**: La inversión a largo plazo proporciona tiempo para recuperarse de las bajadas del mercado.\r\n- **Eficiencia Fiscal**: Menores tasas impositivas sobre ganancias de capital a largo plazo en muchas jurisdicciones.\r\n\r\n### Inversión en Valor\r\n\r\nLa inversión en valor implica la selección de acciones que se perciben como subvaluadas en comparación con su valor intrínseco. Los inversores en valor buscan empresas con fundamentos sólidos pero cuyas acciones se negocian a un precio inferior a su valor real.\r\n\r\n- **Indicadores Clave**: Ratios financieros como P/E, P/B, y dividend yield.\r\n\r\n### Inversión en Crecimiento\r\n\r\nPor otro lado, la inversión en crecimiento se enfoca en empresas que presentan potencial para un crecimiento significativo en sus ingresos o ganancias, incluso si sus acciones parecen "caras" en términos tradicionales.\r\n\r\n- **Características de las Empresas de Crecimiento**: Innovación, liderazgo en el mercado y expansión de ingresos.\r\n\r\n### Ejemplos de Éxito a Largo Plazo\r\n\r\n- **Warren Buffett y Berkshire Hathaway**: Una de las historias de éxito más emblemáticas de inversión en valor.\r\n- **Amazon y Google**: Ejemplos de inversiones en crecimiento que han redefinido industrias enteras.\r\n\r\n### Consejos para Inversores a Largo Plazo\r\n\r\n- **Investigación Rigurosa**: Entender profundamente las empresas en las que invierte.\r\n- **Diversificación**: No poner todos los huevos en una misma canasta.\r\n- **Paciencia**: Mantenerse firme incluso en mercados volátiles.\r\n\r\nInvertir a largo plazo es una estrategia probada para construir riqueza. Requiere una mentalidad enfocada en el futuro y una comprensión sólida de los fundamentos y tendencias de crecimiento de las inversiones.
9	Economia	Principios Económicos Básicos	https://pbs.twimg.com/media/Dr5dwvMWoAEZLZq.jpg	Introducción a los principios fundamentales de la economía, incluyendo oferta y demanda, cómo los precios se determinan en el mercado, y el rol del gobierno en la economía.	## Principios Económicos Básicos\r\n\r\nLa economía juega un papel crucial en nuestras vidas, influenciando desde decisiones individuales hasta políticas gubernamentales a gran escala. Comprender sus principios básicos es esencial para navegar el mundo moderno.\r\n\r\n### Oferta y Demanda\r\n\r\nLa oferta y la demanda son las fuerzas fundamentales que hacen funcionar los mercados. Determinan la cantidad de bienes y servicios ofrecidos en el mercado y a qué precio.\r\n\r\n- **Ley de la Demanda**: Existe una relación inversa entre el precio de un bien y la cantidad demandada. A medida que el precio de un bien aumenta, la demanda por este disminuye, y viceversa.\r\n  \r\n- **Ley de la Oferta**: Hay una relación directa entre el precio de un bien y la cantidad ofrecida. A medida que el precio aumenta, los productores están dispuestos a ofrecer más del bien, y viceversa.\r\n\r\n### Determinación de Precios en el Mercado\r\n\r\nEl punto donde la curva de oferta y demanda se intersectan es el equilibrio del mercado. Aquí, la cantidad demandada por los consumidores es igual a la cantidad ofrecida por los productores, estableciendo el precio de equilibrio.\r\nPrecio de Equilibrio = Donde la Cantidad Demandada = Cantidad Ofrecida\r\n### El Rol del Gobierno en la Economía\r\n\r\nEl gobierno puede influir en la economía de múltiples maneras, incluyendo:\r\n\r\n- **Política Fiscal**: Ajustes en el gasto público y en la tasa de impuestos para influir en la economía.\r\n  \r\n- **Política Monetaria**: Manipulación de la oferta monetaria y tasas de interés para controlar la inflación y estabilizar la moneda.\r\n\r\n### Ejemplo Práctico: Análisis de un Mercado Específico\r\n\r\nConsideremos el mercado de la vivienda. Si los intereses hipotecarios bajan, la demanda de casas aumentará, lo que a su vez puede aumentar los precios de las casas si la oferta no crece al mismo ritmo.\r\n\r\nEste análisis simplificado muestra cómo la oferta y demanda afectan los precios y cómo las políticas gubernamentales pueden influir en estos elementos fundamentales de la economía.\r\n\r\nLos principios económicos básicos no solo son fundamentales para los economistas, sino para cualquier persona que busque entender cómo funcionan los mercados y tomar decisiones informadas en su vida cotidiana.\r\n\r\n
8	Inversion	Riesgos y Mitigación en Inversiones	https://mesfix.com/blog/wp-content/uploads/2019/04/inversion-segura-destacada.png	Identificación de riesgos comunes en inversiones y estrategias para mitigarlos, enfatizando en la importancia de la evaluación de riesgos y la gestión del riesgo en el proceso de inversión.	## Riesgos y Mitigación en Inversiones\r\n\r\nInvertir siempre implica algún nivel de riesgo. Sin embargo, comprender estos riesgos y saber cómo mitigarlos puede marcar la diferencia entre el éxito y el fracaso en la construcción de un portafolio robusto y rentable.\r\n\r\n### Tipos de Riesgos de Inversión\r\n\r\n- **Riesgo de Mercado**: Refiere a la posibilidad de que el valor de una inversión disminuya debido a factores económicos o eventos que afectan al mercado en general.\r\n- **Riesgo de Crédito**: El riesgo de que un emisor de deuda no cumpla con los términos del contrato, afectando el retorno de la inversión.\r\n- **Riesgo de Liquidez**: La dificultad de vender rápidamente una inversión a un precio justo debido a la falta de compradores.\r\n- **Riesgo de Tasas de Interés**: La posibilidad de que las fluctuaciones en las tasas de interés afecten el valor de las inversiones en bonos.\r\n\r\n### Estrategias de Mitigación\r\n\r\n- **Diversificación**: La estrategia más efectiva para reducir el riesgo de inversión es diversificar el portafolio entre varios tipos de activos, sectores e incluso geografías.\r\n  \r\n- **Análisis de Sensibilidad**: Consiste en evaluar cómo cambios en factores externos, como las tasas de interés o el crecimiento económico, pueden afectar a las inversiones.\r\n  \r\n- **Hedging (Cobertura)**: Uso de instrumentos financieros derivados para protegerse contra movimientos adversos del mercado.\r\n  \r\n- **Asignación de Activos**: Ajustar la proporción de diferentes tipos de activos en el portafolio basándose en el análisis del ciclo económico, la tolerancia al riesgo y los objetivos de inversión.\r\n\r\n### Importancia de la Evaluación de Riesgos\r\n\r\nRealizar una evaluación de riesgos antes de invertir es crucial. Esta evaluación debe considerar la volatilidad del mercado, el entorno económico y los objetivos específicos del inversor. Comprender y aceptar el nivel de riesgo con el que uno se siente cómodo es esencial para tomar decisiones de inversión informadas.\r\n\r\n### Herramientas y Técnicas para la Gestión del Riesgo\r\n\r\n- **Órdenes de Stop-Loss**: Establecer órdenes de venta automáticas para limitar las pérdidas.\r\n- **Rebalanceo de Portafolio**: Ajustar periódicamente la distribución de activos en el portafolio para mantener el nivel deseado de riesgo.\r\n- **Análisis Fundamental y Técnico**: Evaluar las inversiones potenciales desde una perspectiva tanto cuantitativa como cualitativa para identificar riesgos y oportunidades.\r\n\r\nLa gestión de riesgos es una parte integral de cualquier estrategia de inversión exitosa. Adoptar un enfoque proactivo y utilizar una combinación de estrategias de mitigación puede ayudar a proteger su portafolio de inversiones contra eventos adversos, maximizando al mismo tiempo el potencial de retorno a largo plazo.
11	Economia	Teorías Económicas Contemporáneas	https://encolombia.com/wp-content/uploads/2022/10/Economia-Evolutiva.jpg	Descripción de las principales teorías económicas que influyen en las políticas actuales, explorando el contraste entre Keynesianismo y Monetarismo, la importancia de la Economía del Comportamiento, y el impacto de estas teorías en la formulación de políticas económicas.	## Teorías Económicas Contemporáneas\r\n\r\nEl estudio de la economía está dominado por varias teorías que intentan explicar cómo funcionan los mercados, cómo se toman las decisiones económicas y cómo se pueden gestionar las economías para promover la prosperidad y el bienestar. Este artículo explora algunas de las teorías económicas más influyentes de los tiempos modernos y su impacto en las políticas económicas globales.\r\n\r\n### Keynesianismo vs. Monetarismo\r\n\r\n- **Keynesianismo**: Basada en las ideas de John Maynard Keynes, esta teoría sostiene que la demanda agregada es el principal motor de la economía y que la gestión de esta demanda a través de la política fiscal (gasto público y tributación) puede ayudar a mitigar los efectos de las recesiones y promover el empleo. La fórmula básica del multiplicador keynesiano ilustra cómo un incremento en el gasto puede tener un efecto amplificado en el ingreso nacional:\r\nMultiplicador = 1 / (1 - Propensión Marginal a Consumir)\r\n- **Monetarismo**: Encabezado por Milton Friedman, el monetarismo argumenta que la oferta de dinero es el factor más importante que determina el crecimiento económico, la inflación y el desempleo. La política monetaria, particularmente el control de la cantidad de dinero y las tasas de interés, se considera el instrumento más efectivo para regular la economía. La ecuación de intercambio de Fisher forma la base de esta teoría:\r\nMV = PQ\r\nDonde M es la oferta monetaria, V es la velocidad del dinero, P es el nivel de precios y Q es el volumen de bienes y servicios producidos.\r\n\r\n### Economía del Comportamiento\r\n\r\nLa economía del comportamiento desafía la noción tradicional de que los agentes económicos son completamente racionales y siempre maximizan su utilidad. Incorpora conocimientos de la psicología para entender cómo las emociones y el pensamiento irracional afectan las decisiones económicas. Un ejemplo es el concepto de "aversión a la pérdida", que sugiere que las personas sienten la pérdida de una manera más intensa que el beneficio de una ganancia equivalente.\r\n\r\n### Impacto de las Teorías en las Políticas Económicas\r\n\r\nLas teorías económicas contemporáneas han modelado significativamente las políticas económicas a nivel mundial. Por ejemplo, las medidas de estímulo fiscal adoptadas durante la crisis financiera de 2008 se inspiraron en principios keynesianos, mientras que las políticas de objetivo de inflación de muchos bancos centrales reflejan influencias monetaristas.\r\n\r\nEl debate entre estas teorías continúa influyendo en cómo los países abordan desafíos económicos como la inflación, el desempleo y el crecimiento económico, demostrando que la economía es una disciplina dinámica y en constante evolución.\r\n\r\nLas teorías económicas no solo guían la formulación de políticas económicas sino que también ofrecen a los individuos y a las empresas un marco para tomar decisiones informadas en un mundo complejo y globalizado.
10	Economia	Inflación y sus Efectos	https://blog.edufinet.com/wp-content/uploads/2022/05/inflacion-2022.jpg	Exploración del concepto de inflación, sus causas principales, efectos en la economía y las finanzas personales, y estrategias para la protección contra la inflación.	## Inflación y sus Efectos\r\n\r\nLa inflación es un fenómeno económico caracterizado por el aumento sostenido de los precios de bienes y servicios en un país durante un periodo de tiempo. Entender la inflación es crucial para individuos, inversores y formuladores de políticas debido a su amplio impacto en la economía.\r\n\r\n### ¿Qué es la Inflación?\r\n\r\nLa inflación se mide generalmente a través del Índice de Precios al Consumidor (IPC), que refleja el precio promedio de una canasta de bienes y servicios consumidos por los hogares.\r\nTasa de Inflación = ((IPC del año actual - IPC del año anterior) / IPC del año anterior) * 100\r\n\r\n### Causas Principales de la Inflación\r\n\r\n- **Inflación de Demanda**: Ocurre cuando la demanda agregada de bienes y servicios supera la oferta.\r\n- **Inflación de Costos**: Surge por el aumento en los costos de producción, como materiales y salarios, que son traspasados al consumidor en forma de precios más altos.\r\n- **Inflación Monetaria**: Resulta del aumento de la oferta monetaria en la economía más rápidamente que el crecimiento económico.\r\n\r\n### Efectos de la Inflación\r\n\r\n- **Pérdida del Poder Adquisitivo**: El dinero pierde valor, lo que afecta la capacidad de compra de los individuos.\r\n- **Distorsión en la Inversión**: La incertidumbre sobre el valor futuro del dinero puede llevar a decisiones de inversión subóptimas.\r\n- **Impacto en los Ahorros**: Los ahorros pueden depreciarse en términos reales si las tasas de interés no superan la tasa de inflación.\r\n\r\n### Estrategias de Protección contra la Inflación\r\n\r\n- **Inversiones en Activos Reales**: Bienes raíces y materias primas suelen mantener su valor durante periodos de inflación.\r\n- **Bonos Protegidos contra la Inflación**: Como los TIPS en Estados Unidos, cuyo principal se ajusta según el IPC.\r\n- **Diversificación Internacional**: Invertir en mercados internacionales puede proporcionar protección contra la inflación doméstica.\r\n\r\n### Ejemplo Práctico: Análisis del Efecto de la Inflación\r\n\r\nSupongamos una tasa de inflación del 3% anual. Si un artículo cuesta $100 hoy, costará aproximadamente $103 en un año, asumiendo que toda la inflación se traspase a los precios de los bienes.\r\n\r\n#### Tabla de Inflación Anual\r\n\r\n| Año | Tasa de Inflación | Precio del Artículo |\r\n|-----|-------------------|---------------------|\r\n| 1   | 3%                | $103.00             |\r\n| 2   | 3%                | $106.09             |\r\n| 3   | 3%                | $109.27             |\r\n\r\nLa inflación no solo afecta la economía a gran escala, sino también las finanzas personales, influenciando desde el costo de la vida hasta las estrategias de inversión y ahorro. Comprender sus mecanismos y efectos permite tomar decisiones más informadas y proteger el valor real del dinero a lo largo del tiempo.
12	Economia	Globalización Económica	https://mercado.com.ar/wp/wp-content/uploads/2020/12/globalizacio%CC%81n.jpg	Análisis de la globalización y su impacto en la economía mundial, explorando los beneficios, desafíos y casos de estudio sobre economías emergentes.	## Globalización Económica\r\n\r\nLa globalización económica se refiere al creciente intercambio de bienes, servicios, tecnología, capital y conocimiento a nivel mundial. Este fenómeno ha transformado la manera en que las economías operan, promoviendo una mayor interdependencia entre los países.\r\n\r\n### ¿Qué es la Globalización?\r\n\r\nLa globalización implica la integración de mercados nacionales en una economía global. Es un proceso impulsado por el comercio internacional y la inversión, y facilitado por la innovación tecnológica.\r\n\r\n### Beneficios de la Globalización\r\n\r\n- **Crecimiento Económico**: Acceso a mercados más amplios para bienes y servicios.\r\n- **Eficiencia y Innovación**: Competencia global que estimula la innovación y la eficiencia en producción.\r\n- **Transferencia de Tecnología**: Difusión de nuevas tecnologías a través de fronteras.\r\n\r\n### Desafíos de la Globalización\r\n\r\n- **Desigualdad**: Potencial aumento de la brecha entre ricos y pobres dentro y entre países.\r\n- **Pérdida de Soberanía**: Limitaciones en la capacidad de los gobiernos para controlar sus propias economías.\r\n- **Impacto Ambiental**: Aumento en la producción y consumo que puede llevar a un deterioro ambiental.\r\n\r\n### Globalización y Comercio Internacional\r\n\r\nEl comercio internacional es un pilar clave de la globalización, permitiendo el flujo de bienes y servicios entre países. Las políticas comerciales, como los acuerdos de libre comercio, juegan un papel crucial en este proceso.\r\n\r\n#### Ejemplo de Tabla de Comercio Internacional\r\n\r\n| País     | Exportaciones | Importaciones | Balanza Comercial |\r\n|----------|---------------|---------------|-------------------|\r\n| País A   | $500M         | $400M         | +$100M            |\r\n| País B   | $300M         | $450M         | -$150M            |\r\n\r\n### Casos de Estudio: Economías Emergentes\r\n\r\nLas economías emergentes han experimentado un crecimiento significativo gracias a la globalización. Por ejemplo, China e India han visto cómo la apertura de sus economías al comercio global y la inversión extranjera ha impulsado su crecimiento económico y reducido la pobreza.\r\n\r\n### El Futuro de la Globalización\r\n\r\nEl futuro de la globalización es incierto, con tendencias hacia el proteccionismo y la reevaluación de acuerdos comerciales. Sin embargo, la integración económica global sigue siendo una fuerza poderosa que modela el desarrollo económico, la política y las relaciones internacionales.\r\n\r\nLa globalización económica ha traído oportunidades y desafíos significativos para las naciones del mundo. Comprender su dinámica es esencial para navegar en el complejo panorama económico actual y para tomar decisiones informadas tanto a nivel de políticas como en la gestión empresarial.
\.


--
-- Data for Name: cartera; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cartera (id_cartera, id_usuario, saldo, total_depositado, total_retirado, total_transacciones) FROM stdin;
3	3	10624.049987792969	2000	200	8
4	4	10000	0	0	0
\.


--
-- Data for Name: notificaciones; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notificaciones (id, usuario_id, mensaje, fecha) FROM stdin;
1	3	Tu acción favorita AAPL ha tenido una variación significativa de 1.68% en las últimas 24 horas.	2024-03-21 09:30:58.677721
2	3	Tu acción favorita AMZN ha tenido una variación significativa de 1.14% en las últimas 24 horas.	2024-03-21 09:31:00.485942
3	3	Tu acción favorita GOOGL ha tenido una variación significativa de 0.50% en las últimas 24 horas.	2024-03-21 09:31:01.788161
4	3	Tu acción favorita NVDA ha tenido una variación significativa de 0.64% en las últimas 24 horas.	2024-03-21 09:31:03.197157
5	3	Tu acción favorita PYPL ha tenido una variación significativa de 2.31% en las últimas 24 horas.	2024-03-21 09:31:04.720217
6	3	Tu acción favorita AAPL ha tenido una variación significativa de 1.68% en las últimas 24 horas.	2024-03-21 09:31:17.875123
7	3	Tu acción favorita AMZN ha tenido una variación significativa de 1.14% en las últimas 24 horas.	2024-03-21 09:31:19.210056
8	3	Tu acción favorita GOOGL ha tenido una variación significativa de 0.50% en las últimas 24 horas.	2024-03-21 09:31:21.930063
9	3	Tu acción favorita NVDA ha tenido una variación significativa de 0.64% en las últimas 24 horas.	2024-03-21 09:31:23.176764
10	3	Tu acción favorita PYPL ha tenido una variación significativa de 2.31% en las últimas 24 horas.	2024-03-21 09:31:24.470317
11	3	Tu acción favorita AAPL ha tenido una variación significativa de 1.68% en las últimas 24 horas.	2024-03-21 09:31:37.762286
12	3	Tu acción favorita AMZN ha tenido una variación significativa de 1.14% en las últimas 24 horas.	2024-03-21 09:31:39.219303
13	3	Tu acción favorita GOOGL ha tenido una variación significativa de 0.50% en las últimas 24 horas.	2024-03-21 09:31:40.452993
\.


--
-- Data for Name: reset_clave_token; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.reset_clave_token (id, usuario_id, token, fecha_expiracion) FROM stdin;
2	4	688188	2024-03-17 18:05:17.21589
3	4	828154	2024-03-17 18:14:23.493397
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
6	3	1	compra	0	182.52000427246094	2024-02-24 18:51:41.653991
7	3	1	compra	3	182.52000427246094	2024-02-24 19:01:59.936197
8	3	1	venta	3	182.52000427246094	2024-02-24 19:05:07.898669
\.


--
-- Data for Name: usuario; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.usuario (id, nombre, apellido, "contraseña", email) FROM stdin;
3	David	Martinez	scrypt:32768:8:1$4fXQjnW5Cj3SQvG7$092908433e708c961f34c8344110f6147e893c45e3b01d0d3095f83861f64f59302478574938d9ebff69eff25d727d27ed17b16a15199bce20773cc1a51c815f	david@gmail.com
4	David	Martinez	scrypt:32768:8:1$BIae9G7g5DwF91a9$8408f6274c91fe0e4fc554dcd1ad635bd68146230e2372a8e1463835ac715ae4c77a726ac61ec0bc661707aa800289c8bc9725b84293e80a9b50db868952ff26	martinezdiaz.d@gmail.com
\.


--
-- Name: accion_id_accion_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.accion_id_accion_seq', 156, true);


--
-- Name: accionesfavoritas_id_favorito_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.accionesfavoritas_id_favorito_seq', 5, true);


--
-- Name: articulosaprendizaje_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.articulosaprendizaje_id_seq', 12, true);


--
-- Name: cartera_id_cartera_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cartera_id_cartera_seq', 4, true);


--
-- Name: notificaciones_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.notificaciones_id_seq', 13, true);


--
-- Name: reset_clave_token_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.reset_clave_token_id_seq', 3, true);


--
-- Name: transaccion_id_transaccion_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.transaccion_id_transaccion_seq', 8, true);


--
-- Name: usuario_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.usuario_id_seq', 4, true);


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
-- Name: articulosaprendizaje articulosaprendizaje_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.articulosaprendizaje
    ADD CONSTRAINT articulosaprendizaje_pkey PRIMARY KEY (id);


--
-- Name: cartera cartera_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cartera
    ADD CONSTRAINT cartera_pkey PRIMARY KEY (id_cartera);


--
-- Name: notificaciones notificaciones_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notificaciones
    ADD CONSTRAINT notificaciones_pkey PRIMARY KEY (id);


--
-- Name: reset_clave_token reset_clave_token_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reset_clave_token
    ADD CONSTRAINT reset_clave_token_pkey PRIMARY KEY (id);


--
-- Name: reset_clave_token reset_clave_token_token_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reset_clave_token
    ADD CONSTRAINT reset_clave_token_token_key UNIQUE (token);


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
-- Name: notificaciones notificaciones_usuario_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notificaciones
    ADD CONSTRAINT notificaciones_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES public.usuario(id);


--
-- Name: reset_clave_token reset_clave_token_usuario_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reset_clave_token
    ADD CONSTRAINT reset_clave_token_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES public.usuario(id);


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

