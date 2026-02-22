#!/bin/sh
set -e

echo "Патчим WireGuard.js для поддержки AmneziaWG 2.0 (S3, S4, I1-I5) и настраиваемого имени интерфейса..."

cd /app/lib

# Поддержка переменной WG_CONFIG_NAME для имени интерфейса
WG_NAME="${WG_CONFIG_NAME:-wg0}"
if [ "$WG_NAME" != "wg0" ]; then
  echo "Меняем имя интерфейса с wg0 на $WG_NAME..."
  # Заменяем все вхождения wg0 на новое имя
  sed -i "s/wg0/$WG_NAME/g" WireGuard.js
fi

# Добавляем S3, S4, I1-I5 в деструктуризацию config
sed -i '/^  H4,$/a\  S3,\n  S4,\n  I1,\n  I2,\n  I3,\n  I4,\n  I5,' WireGuard.js

# Добавляем S3, S4, I1-I5 в объект server
sed -i '/^            h4: H4,$/a\            s3: S3,\n            s4: S4,\n            i1: I1,\n            i2: I2,\n            i3: I3,\n            i4: I4,\n            i5: I5,' WireGuard.js

# Добавляем S3, S4, I1-I5 в шаблон конфигурации
sed -i '/^H4 = \${config\.server\.h4}$/a\S3 = ${config.server.s3}\nS4 = ${config.server.s4}\nI1 = ${config.server.i1}\nI2 = ${config.server.i2}\nI3 = ${config.server.i3}\nI4 = ${config.server.i4}\nI5 = ${config.server.i5}' WireGuard.js

echo "Патч применен успешно!"
