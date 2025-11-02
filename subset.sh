#!/bin/bash

set -e

for CHARSET in us_ascii latin; do
  for EXT in ttf woff2; do
    for FACE in Sevka SevkaSlab SevkaFixed; do
      mkdir -p dist/${CHARSET/us\_/}/$EXT/$FACE
      FILES=$(ls dist/$FACE/${EXT^^})
      for FILE in $FILES; do
        glyphhanger --subset="dist/$FACE/${EXT^^}/$FILE" --formats=$EXT --${CHARSET^^}
        mv "dist/$FACE/${EXT^^}/${FILE%%."$EXT"}-subset.$EXT" "dist/${CHARSET/us_/}/$EXT/$FACE/$FILE"
      done
    done
  done
done
