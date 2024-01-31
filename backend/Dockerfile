# Usamos una imagen base de Python 3.8
FROM python:3.8-slim-buster

# Establecemos un directorio de trabajo
WORKDIR /usr/src/app

# Copiamos los archivos necesarios al contenedor
COPY requirements.txt ./
COPY server.py ./

# Instalamos las dependencias
RUN pip install --no-cache-dir -r requirements.txt

# Exponemos el puerto 5000
EXPOSE 5000

# Comando para ejecutar la aplicación
CMD ["python", "./server.py"]
