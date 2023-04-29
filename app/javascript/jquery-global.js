// fix bootstrap require jquery issue:
// https://github.com/parcel-bundler/parcel/issues/3644
//
import jquery from "jquery"
window.$ = jquery;
window.jQuery = jquery;
globalThis.jQuery = jquery;

