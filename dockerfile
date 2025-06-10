# Imagen base con Nginx
FROM nginx:alpine

# Limpia el directorio de Nginx por defecto de forma recursiva y forzada,
# asegurando que todo su contenido se elimina ANTES de copiar los nuevos archivos.
RUN rm -rf /usr/share/nginx/html/* && \
    rm -rf /usr/share/nginx/html/.??* || true && \ # Para eliminar archivos/directorios ocultos
    mkdir -p /usr/share/nginx/html # Re-crea el directorio por si rm -rf lo eliminó al estar vacío, aunque no suele pasar con /*

# Copia tus archivos HTML y CSS al contenedor
COPY index.html /usr/share/nginx/html/
COPY styles.css /usr/share/nginx/html/

# Expone el puerto 80
EXPOSE 80

# El contenedor se ejecuta con Nginx
CMD ["nginx", "-g", "daemon off;"]