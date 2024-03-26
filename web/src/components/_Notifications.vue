<template>
  <div id="notifications" v-if="notifications.current">
    <img :src="require('@/assets/notifications/' + notifications.current.img)">
    <div class="notifications-content">
      <div class="notifications-content-title">{{ notifications.current.title }}</div>
      <div class="notifications-content-message">{{ notifications.current.message }}</div>
    </div>
    <div class="notifications-progress-bar">
      <div class="notifications-progress-bar-counter" 
        :style="{
          animationDuration: notifications.current.time / 1000 + 's',
          background: notifications.current.color, 
          boxShadow: '0px 0px calc(33px * var(--scale-coefficient)) 0px ' + notifications.current.color
        }">
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'AdditionalNotifications',
  data() {
    return {
      notifications: {
        current: null, 
        array: []
      },
    }
  },
  methods: {
    AddNotifications(title, message, time, img, color) {
      let cancellation = false;
      if (this.notifications.array.length > 0) {
        for (let i of this.notifications.array) 
          if (i.message == message && i.title == title) cancellation = true;
      } 
      if (!cancellation) {
        this.notifications.array.push({title: title, message: message, time: time, img: img, color: color})
        if (this.notifications.array.length == 1) this.UseNotifications();
      } 
    },
    UseNotifications() {
      if (this.notifications.array.length > 0) {
        this.notifications.current = this.notifications.array[0];
        setTimeout(()=> {
          this.notifications.array.splice(0, 1);
          this.notifications.current = null;
          setTimeout(()=> {
            this.UseNotifications();
          }, 800);
        }, this.notifications.array[0].time)
      }
    }
  },
}
</script>

<style lang="sass">
@import "~@/assets/fonts/gilroy/gilroy.css"
$first-font: Gilroy, sans-serif

@keyframes notifications-progress-bar
  0%
    width: 100%
  100%
    width: 0%

#notifications
  position: relative
  background-color: rgba(0, 0, 0, 0.70)
  border-radius: calc(10px * var(--scale-coefficient))
  padding: calc(15px * var(--scale-coefficient)) calc(10px * var(--scale-coefficient)) calc(15px * var(--scale-coefficient)) calc(18px * var(--scale-coefficient))
  display: flex
  justify-content: left
  img
    width: calc(43px * var(--scale-coefficient))
    height: calc(46px * var(--scale-coefficient))
  .notifications-content
    margin-left: calc(18px * var(--scale-coefficient))
    .notifications-content-title
      color: #FFF
      text-shadow: 0px 0px 4px rgba(0, 0, 0, 0.25)
      font-family: $first-font
      font-size: calc(18px * var(--scale-coefficient))
      font-style: normal
      font-weight: 500
      line-height: normal
    .notifications-content-message
      color: rgba(255, 255, 255, 0.90)
      text-shadow: 0px 0px 4px rgba(0, 0, 0, 0.25)
      font-family: $first-font
      font-size: calc(14px * var(--scale-coefficient))
      font-style: normal
      font-weight: 400
      line-height: calc(18px * var(--scale-coefficient))
      letter-spacing: 0.14px
      margin-top: calc(4px * var(--scale-coefficient))
  .notifications-progress-bar
    position: absolute
    left: 50%
    bottom: 0 
    transform: translateX(-50%)
    width: 95%
    height: calc(4px * var(--scale-coefficient))
    border-radius: calc(17px * var(--scale-coefficient))
    background: rgba(255, 255, 255, 0.15)
    .notifications-progress-bar-counter
      position: absolute
      left: 0
      top: 0
      height: 100%
      border-radius: calc(10px * var(--scale-coefficient))
      animation-name: notifications-progress-bar
</style>