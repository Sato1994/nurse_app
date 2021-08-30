<template>
<v-container>
  <v-row>
    
    <v-col
        v-for="target in targets" :key="target.id"  cols="12" sm="6" md="6" lg="4"
    >
    <v-card
      class="mx-auto"
      max-width="400"
    >
      <v-img
        class="white--text align-end"
        height="200px"
        src="https://cdn.vuetifyjs.com/images/cards/docks.jpg"
      >
        <v-card-title>
          {{target.name}}
        </v-card-title>
      </v-img>

      <v-card-subtitle class="pb-0">
        {{target.address}}
      </v-card-subtitle>

      <v-card-text class="text--primary">
        <div>{{target.wanted === true ? '募集中' : '募集してません'}}</div>

        <div>{{target.profile}}</div>
      </v-card-text>

      <v-card-actions>
        <v-btn
          color="orange"
          text
        >
          Share
        </v-btn>

        <v-btn
          color="orange"
          text
        >
          Explore
        </v-btn>
      </v-card-actions>
    </v-card>
    </v-col>
    
  </v-row>
</v-container>
</template>

<script>

export default {

  props: {
    targets: {
      type: Array,
      default: () => []
    }
  }

 

}



</script>