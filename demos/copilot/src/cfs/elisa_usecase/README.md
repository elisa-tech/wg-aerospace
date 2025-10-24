<!--
SPDX-License-Identifier: CC-BY-SA-4.0
-->

# ./.cabal-sandbox/bin/ogma cfs --app-target-dir output2 \
#          --input-file elisa_usecase/expressions.json \
#          --input-format elisa_usecase/json-format.cfg \
#          --prop-format literal \
#          --variable-db elisa_usecase/db.json \
#          --template-vars elisa_usecase/extra-vars.json \
#          --app-template-dir updated_template
./.cabal-sandbox/bin/ogma cfs \
          --app-template-dir updated_template \
          --app-target-dir output2 \
          --template-vars elisa_usecase/extra-vars.json \
          --input-file elisa_usecase/expressions.json \
          --input-format elisa_usecase/json-format.cfg \
          --prop-format literal \
          --variable-db elisa_usecase/db.json
cp elisa_usecase/extra.h output2/sample_app/fsw/src/
