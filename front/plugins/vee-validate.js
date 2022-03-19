import Vue from 'vue'
import { ValidationProvider, ValidationObserver, extend, localize } from 'vee-validate'
// inmportするルール
import { between, max, required, email, min, alpha_num as alphaNum, confirmed } from 'vee-validate/dist/rules';
import ja from 'vee-validate/dist/locale/ja.json';

localize('ja', ja);

// inmportするルール
extend('required', required);
extend('email', email);
extend('min', min)
extend('alpha_num', alphaNum)
extend('confirmed', confirmed)
extend('max', max)
extend('between', between)


Vue.component('ValidationProvider', ValidationProvider);
Vue.component('ValidationObserver', ValidationObserver)