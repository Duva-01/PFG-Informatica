# APP para Asesoramiento Financiero Bursátil

## Introducción

Este proyecto fin de grado, desarrollado por David Martínez Díaz bajo la supervisión de Jose Manuel Zurita López, se centra en el diseño e implementación de una aplicación de asesoramiento financiero bursátil. Esta aplicación está diseñada para usuarios con diversos niveles de conocimiento financiero, permitiéndoles realizar simulaciones virtuales de inversiones con datos en tiempo real y recomendaciones basadas en análisis bursátil.

### ¿Cómo funciona la aplicación?

[![APP para Asesoramiento Financiero Bursátil](https://img.youtube.com/vi/Xo1dega6FgY/0.jpg)](https://www.youtube.com/watch?v=Xo1dega6FgY)


## Características

- **Análisis en Tiempo Real**: La aplicación recopila datos en tiempo real de los mercados financieros a través de APIs confiables como Yahoo Finance, proporcionando a los usuarios información actualizada y relevante para la toma de decisiones.
- **Personalización de Inversiones**: Ofrece recomendaciones personalizadas de inversión basadas en el perfil y objetivos de cada usuario.
- **Gestión de Cartera**: Los usuarios pueden crear y gestionar sus propias carteras de inversión, lo que facilita el seguimiento y evaluación de sus inversiones a lo largo del tiempo.
- **Interfaz Intuitiva**: Desarrollada con Flutter para frontend y Flask para backend, la aplicación garantiza una experiencia de usuario fluida y accesible tanto en dispositivos móviles como en plataformas de escritorio.
- **Educación Financiera**: Integra secciones educativas para usuarios que desean aprender más sobre inversiones y finanzas, ayudando a los usuarios a tomar decisiones informadas.

## Tecnologías Utilizadas

- **Flutter**: Utilizado para el desarrollo del frontend, proporcionando una interfaz rica y responsiva.
- **Flask**: Aplicado en el backend para manejar la lógica de negocios, la gestión de bases de datos y la integración con APIs externas.
- **APIs Externas**: Yahoo Finance para datos bursátiles en tiempo real y otras APIs para noticias financieras y análisis de mercado.
- **Base de Datos**: Implementación de bases de datos para almacenar información de usuario y transacciones de inversión.

## Instalación y Configuración

### Requisitos Previos
Asegúrate de tener Docker y Docker Compose instalados en tu máquina para manejar los contenedores y dependencias del proyecto.

### Clonar el repositorio:
```bash
git clone https://github.com/Duva-01/PFG-Informatica.git
cd PFG-Informatica
```

### Configuración de Backend
1. **Construir y ejecutar los contenedores de Docker:**
   ```bash
   cd backend
   docker-compose up --build
   ```

2. **Instalar dependencias de Python:**
   ```bash
   pip install -r requirements.txt
   ```

### Configuración de Frontend
1. **Instalar dependencias de Flutter:**
   ```bash
   cd ../grownomics
   flutter pub get
   ```

2. **Ejecutar la aplicación:**
   ```bash
   flutter run
   ```

### Ejecutar pruebas
Para ejecutar las pruebas unitarias y de integración, sigue estos comandos:

```bash
# Para backend
cd backend
python -m unittest discover tests

# Para frontend
cd ../grownomics
flutter test
```


## Acceso Web y Administración

- **Página Web**: Acceda a la aplicación desde cualquier navegador visitando [grownomics.com](http://143.47.44.251:5000/)
- **Acceso Administrador**: Los administradores pueden ingresar a la sección de administración en [grownomics.com/admin](http://143.47.44.251:5000/admin) para gestionar usuarios, configuraciones y datos de la aplicación.

## Descarga de la Aplicación

- **Google Play Store**: Puedes descargar la aplicación desde la Google Play Store a través de este enlace: [Descargar APP Financiera - Grownomics](https://play.google.com/store/apps/details?id=com.david.grownomicspfg&pcampaignid=web_share)

[![Grownomics](http://developer.android.com/images/brand/en_generic_rgb_wo_45.png)](https://play.google.com/store/apps/details?id=com.david.grownomicspfg&pcampaignid=web_share)

## Uso

Para comenzar a usar la aplicación, regístrese a través de la interfaz de usuario proporcionada y siga las instrucciones en pantalla para configurar su perfil de inversión. 

Puede agregar acciones a su cartera, configurar alertas de precios, y visualizar análisis y recomendaciones basadas en su configuración personal.

## Contribuir
Si desea contribuir al proyecto, por favor siga las siguientes instrucciones:

* Fork el repositorio
* Cree una nueva rama para cada característica o mejora
* Realice sus cambios
* Envíe una pull request

## Contacto
**Desarrollador:** David Martínez Díaz - martdiaz01.d@gmail.com


[![GitHub](https://upload.wikimedia.org/wikipedia/commons/thumb/9/91/Octicons-mark-github.svg/35px-Octicons-mark-github.svg.png)](https://github.com/Duva-01)
[![LinkedIn](https://upload.wikimedia.org/wikipedia/commons/thumb/c/ca/LinkedIn_logo_initials.png/35px-LinkedIn_logo_initials.png)](https://www.linkedin.com/in/dmartinez01/)


## Copyright y Licencia

Copyright (C) 2024, David Martínez Díaz