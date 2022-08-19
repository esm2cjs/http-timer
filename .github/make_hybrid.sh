#!/bin/bash

# un-ignore build folder
sed -i 's#/build##' .gitignore
sed -i 's#build/##' .gitignore

TSCONFIG=$(cat tsconfig.json \
	| sed 's|//.*||' \
	| jq --tab '
		.compilerOptions.outDir = "build/esm"
		| .include = ["source"]
	')
echo "$TSCONFIG" > tsconfig.json

# fix tests
mv tests/test.ts tests/test.mts
sed -i "s#../source/#../build/esm/#g" tests/test.mts

# # Replace module imports in all js files
# modules=( human-signals, is-stream, npm-run-path, onetime, strip-final-newline )
# for file in {esm,test}{,/**}/*.js ; do
# 	for mod in "${modules[@]}" ; do
# 		sed -i "s#'$mod'#'@esm2cjs/$mod'#g" "$file"
# 	done
# done


# # patch test files to be ESM and look in the right places
# for file in test{,/**}/*.js ; do
# 	sed -i "s#.js#.mjs#g" "$file"
# 	sed -i -E "s#../lib/([a-zA-Z0-9]+).mjs'#../esm/lib/\1.js'#g" "$file"
# 	sed -i "s#../index.mjs'#../esm/index.js'#g" "$file"
# 	mv -- "$file" "${file%.js}.mjs"
# done

PJSON=$(cat package.json | jq --tab '
	del(.type)
	| .description = .description + ". This is a fork of " + .name + ", but with CommonJS support."
	| .repository = "esm2cjs/http-timer"
	| .name = "@esm2cjs/http-timer"
	| .author = { "name": "Dominic Griesel", "email": "d.griesel@gmx.net" }
	| .publishConfig = { "access": "public" }
	| .funding = "https://github.com/sponsors/AlCalzone"
	| .main = "build/cjs/index.js"
	| .module = "build/esm/index.js"
	| .files = ["build/"]
	| .exports = {}
	| .exports["."].import = "./build/esm/index.js"
	| .exports["."].require = "./build/cjs/index.js"
	| .exports["./package.json"] = "./package.json"
	| .types = "build/esm/index.d.ts"
	| .typesVersions = {}
	| .typesVersions["*"] = {}
	| .typesVersions["*"]["build/esm/index.d.ts"] = ["build/esm/index.d.ts"]
	| .typesVersions["*"]["build/cjs/index.d.ts"] = ["build/esm/index.d.ts"]
	| .typesVersions["*"]["*"] = ["build/esm/*"]
	| .scripts["to-cjs"] = "esm2cjs --in build/esm --out build/cjs -t node12"
	| .xo.ignores = ["build", "tests/", "**/*.d.ts"]
	| .ava.extensions.mts = "module"
')
echo "$PJSON" > package.json

npm i

npm i -D @alcalzone/esm2cjs
npm run to-cjs
npm uninstall -D @alcalzone/esm2cjs

PJSON=$(cat package.json | jq --tab 'del(.scripts["to-cjs"])')
echo "$PJSON" > package.json

npm test
