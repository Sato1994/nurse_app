<template>

<div class="flex flex-wrap -m-4">
  <div v-for="target in targets" :key="target.id" class="xl:w-1/3 md:w-1/2 p-4">
    <div class="border border-gray-200 p-6 rounded-lg">
      <div class="w-10 h-10 inline-flex items-center justify-center rounded-full bg-indigo-100 text-indigo-500 mb-4">
        <svg fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" class="w-6 h-6" viewBox="0 0 24 24">
          <path d="M22 12h-4l-3 9L9 3l-3 9H2"></path>
        </svg>
      </div>
      <h2 class="text-lg text-gray-900 font-medium title-font mb-2">{{target.name}}</h2>
      <p class="leading-snung text-base">住所：{{target.address}}</p>
      <p class="leading-snung text-base">募集中？{{target.wanted === true ? '募集中' : '募集してません'}}</p>
      <p class="leading-snung text-base">プロフィール：{{target.profile}}</p>
    </div>
  </div>
</div>



</template>



<script>

export default {

  props: {
    targets: Array
  },
  



  
}



</script>