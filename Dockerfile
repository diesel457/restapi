FROM dmapper/baseimage:3.0.3

ADD . /app

RUN \
  echo "@dmapper:registry=https://registry.npmjs.org/" >> ~/.npmrc && \
  echo "//registry.npmjs.org/:_authToken=c84e2ad7-5a9e-4ac3-9a42-fb4d0f81f3e7" >> ~/.npmrc && \
  cd /app && \
  npm link grunt-cli && \
  npm install && \
  grunt build && \
  STAGE=staging npm run build

WORKDIR /app

CMD forever build/server.js

EXPOSE 3000

# === Staging Config
# in the apps cluster:
# deis2 apps:create ft -r deis
# deis2 config:set STAGE=staging REDIS_URL=redis://10.142.0.7:6379/13 MONGO_URL=mongodb://10.142.0.4:27017,10.142.0.5:27017,10.142.0.6:27017/ft?replicaSet=rs1 -a ft
# deis2 domains:add ft.dmapper.co -a ft
