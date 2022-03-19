import Vue from 'vue'
import { ValidationProvider, extend, localize } from 'vee-validate'
import { required, email } from 'vee-validate/dist/rules';
import ja from 'vee-validate/dist/locale/ja.json';

localize('ja', ja);

// inmportするルール
extend('required', required);
extend('email', email);

Vue.component('ValidationProvider', ValidationProvider);
