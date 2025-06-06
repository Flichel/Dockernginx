#!/bin/sh

# Prueba: El servidor responde con 200
STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost)
if [ "$STATUS" = "200" ]; then
  echo "✅ Prueba 1: Servidor responde con 200 OK"
else
  echo "❌ Prueba 1: Falló. Código de estado: $STATUS"
  exit 1
fi

# Prueba: El contenido contiene texto esperado
curl -s http://localhost | grep -q "¡Hola desde Docker!"
if [ $? -eq 0 ]; then
  echo "✅ Prueba 2: El contenido HTML es correcto"
else
  echo "❌ Prueba 2: El contenido HTML no es el esperado"
  exit 1
fi
