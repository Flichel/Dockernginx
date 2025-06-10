#!/bin/sh

IMAGE_NAME=$1
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0
TEST_TIMES="" # Para almacenar los tiempos de cada test

echo "Running image unit tests for: $IMAGE_NAME"
echo ""

# Función para ejecutar un test y capturar el resultado
run_test() {
  TEST_NAME="$1"
  COMMAND_TO_RUN="$2"
  TOTAL_TESTS=$((TOTAL_TESTS + 1))
  START_TIME=$(date +%s%N) # Tiempo de inicio en nanosegundos

  echo "  › ${TEST_NAME}"

  if eval "$COMMAND_TO_RUN"; then
    echo "    ✅ ${TEST_NAME} (PASSED)"
    PASSED_TESTS=$((PASSED_TESTS + 1))
    STATUS_EMOJI="✅"
  else
    echo "    ❌ ${TEST_NAME} (FAILED)"
    FAILED_TESTS=$((FAILED_TESTS + 1))
    STATUS_EMOJI="❌"
  fi

  END_TIME=$(date +%s%N) # Tiempo de fin en nanosegundos
  DURATION_MS=$(( (END_TIME - START_TIME) / 1000000 )) # Duración en milisegundos
  TEST_TIMES="${TEST_TIMES}${STATUS_EMOJI} ${TEST_NAME} (${DURATION_MS} ms)\n"
}

echo "Image Unit Tests:"

# --- Tests ---

# Prueba 1: Verificar que el usuario Nginx existe
run_test "User 'nginx' exists in the image" "docker run --rm $IMAGE_NAME id -u nginx >/dev/null 2>&1"

# Prueba 2: Verificar que el archivo index.html existe y es accesible
run_test "index.html file exists and is accessible" "docker run --rm $IMAGE_NAME stat /usr/share/nginx/html/index.html >/dev/null 2>&1"

# Prueba 3: Verificar que el archivo styles.css existe y es accesible
run_test "styles.css file exists and is accessible" "docker run --rm $IMAGE_NAME stat /usr/share/nginx/html/styles.css >/dev/null 2>&1"

# Prueba 4: Verificar que el directorio por defecto de Nginx fue limpiado
run_test "Nginx default directory was cleaned" "test \"\$(docker run --rm $IMAGE_NAME ls -A /usr/share/nginx/html/ | wc -l)\" -eq 0"

# Prueba 5: Verificar que el puerto 80 está expuesto (inspección de la imagen, no del contenedor ejecutándose)
# Esta prueba se basa en la inspección de metadatos de la imagen, no en la ejecución.
# Notar que 'docker inspect' es para los metadatos de la imagen, no para el estado del proceso en tiempo real.
run_test "Port 80 is exposed in Dockerfile metadata" "docker inspect --format='{{json .Config.ExposedPorts}}' $IMAGE_NAME | grep -q '\"80/tcp\":{}'"


# --- Resumen de resultados ---
echo ""
echo "Test Suites: 1 passed, 1 total" # Siempre será 1 test suite para este script
echo "Tests:     ${PASSED_TESTS} passed, ${FAILED_TESTS} failed, ${TOTAL_TESTS} total"
echo ""

echo -e "$TEST_TIMES" # Imprime los detalles de cada test con su tiempo

echo ""
if [ "$FAILED_TESTS" -gt 0 ]; then
  echo "❌ Some image unit tests failed."
  exit 1
else
  echo "✅ All image unit tests passed."
  exit 0
fi