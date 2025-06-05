# Imagen base con Nginx
FROM nginx:alpine

# Elimina la página de bienvenida por defecto
RUN rm -rf /usr/share/nginx/html/*

# Copia tus archivos HTML y CSS al contenedor
COPY index.html /usr/share/nginx/html/
COPY styles.css /usr/share/nginx/html/

# Expone el puerto 80
EXPOSE 80

# El contenedor se ejecuta con Nginx
CMD ["nginx", "-g", "daemon off;"]
