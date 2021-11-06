<template>
  <v-form
    ref="form"
  >
    <v-text-field
      v-model="name"
      :counter="10"
      :label="nameLabel"
    ></v-text-field>

    <v-text-field
      v-model="address"
      label="住所"
    ></v-text-field>

    <v-select
   
      label="Item"
    ></v-select>

    <v-checkbox
      label="現在募集中のもののみ表示しますか？"
    ></v-checkbox>

    <v-btn
      color="success"
      class="mr-4"
      @click="sendInput"
    >
    絞り込む
    </v-btn>

  </v-form>
</template>

<script>
export default {
  data: () => ({
    name: '',
    address: ''
  }),
  methods: {
    sendInput() {
      this.$emit('search-button-click', this.name, this.address)
      this.$modal.hide('search-modal')
    }
  },
  computed: {
    nameLabel() {
      return this.$cookies.get('user') === 'user' ? '病院名' : 'お名前'
    }
  }
}

</script>