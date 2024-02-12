# Usamos una imagen base de Python 3.8
FROM python:3.8

RUN curl -L https://sourceforge.net/projects/ta-lib/files/ta-lib/0.4.0/ta-lib-0.4.0-src.tar.gz/download?use_mirror=deac-ams -o ta-lib.tar.gz \
  && tar -xvzf ta-lib.tar.gz \
  && cd ta-lib \
  && ./configure --prefix=/usr \
  && make \
  && make install \
  && cd .. \
  && rm -rf /app/ta-lib /app/ta-lib.tar.gz
  
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