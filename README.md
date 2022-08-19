# @esm2cjs/http-timer

This is a fork of https://github.com/szmarczak/http-timer, but automatically patched to support ESM **and** CommonJS, unlike the original repository.

## Install

You can use an npm alias to install this package under the original name:

```
npm i @szmarczak/http-timer@npm:@esm2cjs/http-timer
```

```jsonc
// package.json
"dependencies": {
    "@szmarczak/http-timer": "npm:@esm2cjs/http-timer"
}
```

but `npm` might dedupe this incorrectly when other packages depend on the replaced package. If you can, prefer using the scoped package directly:

```
npm i @esm2cjs/http-timer
```

```jsonc
// package.json
"dependencies": {
    "@esm2cjs/http-timer": "^ver.si.on"
}
```

## Usage

```js
// Using ESM import syntax
import timer from "@esm2cjs/http-timer";

// Using CommonJS require()
const timer = require("@esm2cjs/http-timer").default;
```

> **Note:**
> Because the original module uses `export default`, you need to append `.default` to the `require()` call.

For more details, please see the original [repository](https://github.com/szmarczak/http-timer).

## Sponsoring

To support my efforts in maintaining the ESM/CommonJS hybrid, please sponsor [here](https://github.com/sponsors/AlCalzone).

To support the original author of the module, please sponsor [here](https://github.com/szmarczak/http-timer).
