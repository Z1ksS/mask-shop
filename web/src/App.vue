<template>
  <div>
    <MaskStore v-if="load.MaskStore" />
  </div>
</template>

<script>
export default {
  name: 'App',
  data: () => ({
    load: {
      MaskStore: false
    }
  }),
  methods: {
    LoadComponent(name, bool) {
      this.load[name] = bool;
    }
  },
  components: {
    MaskStore: () => import('./components/mask-shope/MaskStore.vue'), 
  },
  created() {
    window.addEventListener('message', event => {
      const message = event.data;

      if (message.call == 'mask_store_open') {
        this.LoadComponent('MaskStore', message.show);
      }
    });
  }
}
</script>

<style>
* {
  margin: 0;
  padding: 0 ;
  box-sizing: border-box;
}

@import "~@/assets/fonts/akrobat/akrobat.css";
@import "~@/assets/fonts/gilroy/gilroy.css";
</style>
