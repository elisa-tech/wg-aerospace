#!/bin/bash

# SPDX-License-Identifier: MIT

ogma cfs -p literal --input-file elisa_usecase/expressions.json -f elisa_usecase/json-format.cfg --variable-db elisa_usecase/db.json --app-template-dir updated_template/ --template-vars elisa_usecase/extra-vars.json --app-target-dir apps/
cp ../monitors/Main.hs apps/copilot_app/fsw/src/
cp ../monitors/Auxiliary.hs apps/copilot_app/fsw/src/
