#!/bin/sh

log2file() {
  LOGFILE="$1" ; shift
  { "$@" 2>&1 ; echo $? >"/tmp/~pipestatus.$$" ; } | tee -a "$LOGFILE"
  MYPIPESTATUS="`cat \"/tmp/~pipestatus.$$\"`"
  rm -f "/tmp/~pipestatus.$$"
  return $MYPIPESTATUS
}

if [ -n "$only" ]
then
  mkdir -p tmp
  rm -rf tmp/test.log

  log2file tmp/test.log ./node_modules/.bin/wdio || (((cat tmp/test.log | grep 'A session id is required for this command') || (cat tmp/test.log | grep 'failed to close UI debuggers')) && (pkill -9 chromium || true) && ./node_modules/.bin/wdio)

  #true && ( ./node_modules/.bin/wdio > >( tee -a tmp/log.txt ) 2>&1 ) || (cat tpm/log.txt | grep 'failed to close UI debuggers' && ./node_modules/.bin/wdio)

  #if [ -n "$TRAVIS" ]; then
  #  mkdir -p tmp
  #  true && (./node_modules/.bin/wdio > >( tee -a tmp/log.txt ) 2>&1) || (cat tpm/log.txt | grep 'failed to close UI debuggers' && ./node_modules/.bin/wdio)
  #else
  #  ./node_modules/.bin/wdio
  #fi
elif [ -n "$TRAVIS" ]
then
  # Find all test files and launch them with 'only' env var to start
  # the server on clean db and clean browsers each time.
  # If any test fails, exit immediately without running the rest of files
  # http://stackoverflow.com/q/26484443

  #npm install -g selenium-standalone@latest
  #selenium-standalone install
  #selenium-standalone start > /dev/null 2>&1 &
  #sleep 5

  if [ $BROWSER = "firefox" ]; then
    find ./test/e2e -name '*.mocha.coffee' -print0 | xargs -0 -n1 sh -c 'echo TEST "$0" && only="$0" ./node_modules/.bin/wdio && sleep 5 || exit 255'
  else
    find ./test/e2e -name '*.mocha.coffee' -print0 | xargs -0 -n1 sh -c 'echo TEST "$0" && only="$0" ./node_modules/.bin/wdio && sleep 3 && (pkill -9 chromium || true) && (pkill -9 chromedriver || true) && (pkill -9 selenium-standalone || true) && (pkill -9 node || true) && (pkill -9 npm || true) && sleep 3 && (true && selenium-standalone start > /dev/null 2>&1 &) && sleep 5 || exit 255'
  fi
else
  # Find all test files and launch them with 'only' env var to start
  # the server on clean db and clean browsers each time.
  # If any test fails, exit immediately without running the rest of files
  # http://stackoverflow.com/q/26484443
  find ./test/e2e -name '*.mocha.coffee' -print0 | xargs -0 -n1 sh -c 'echo TEST "$0" && only="$0" ./node_modules/.bin/wdio && sleep 3 || exit 255'
fi