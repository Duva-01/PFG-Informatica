# Usamos una imagen base de Python 3.8
FROM python:3.8

# Establecemos un directorio de trabajo
WORKDIR /app

# Copiamos los archivos necesarios al contenedor
COPY requirements.txt requirements.txt

# Instalamos las dependencias
RUN pip install --no-cache-dir -r requirements.txt

# Copiamos el resto del código fuente de la aplicación al contenedor
COPY . .

# Exponemos el puerto 5000
EXPOSE 5000

# Comando para ejecutar la aplicación
CMD ["flask", "run", "--host=0.0.0.0"]