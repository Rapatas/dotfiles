#!/bin/sh

command -v qmake >/dev/null 2>&1 || { echo >&2 "Could not find 'qmake' in your \$PATH. Aborting."; exit 1; }

cd /dev/shm/
git clone \
  --branch v5.11.2 \
  --depth 1 \
  https://github.com/qt/qtmqtt
cd qtmqtt

sed -i "s/|| d->filter == QLatin1Char('#')/|| d->filter == QLatin1String(\"#\")/g" src/mqtt/qmqtttopicfilter.cpp
sed -i "s/if (level != QLatin1Char('+') && level != topicLevels.at(i))/if (level != QLatin1String(\"+\") \&\& level != topicLevels.at(i))/g" src/mqtt/qmqtttopicfilter.cpp

mkdir build && cd build
qmake ..
make -j $(nproc)
sudo make install

sudo sed -i "s/5.11.2 \${_Qt5Mqtt_FIND_VERSION_EXACT}/5.7.1 \${_Qt5Mqtt_FIND_VERSION_EXACT}/g" /opt/Qt5.7.1/5.7/gcc_64/lib/cmake/Qt5Mqtt/Qt5MqttConfig.cmake

sudo ldconfig
