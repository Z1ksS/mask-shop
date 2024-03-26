<template>
  <div id="mask-shop">
    <!-- Поворот персонажа -->
    <div class="content-player-rotate" @mousedown="MouseButtonPressed($event, true)" @mouseup="MouseButtonPressed(false)" @mousemove="RotateCamera($event)" @mouseout="MouseButtonPressed(false)" @wheel="OnWheel($event)"></div>
    <!-- Правый верхний угол -->
    <ul class="content-right-top-wrap">
      <li>
        <span>Отдаление/Приближение персонажа</span>
        <img src="./img/left-button.svg" alt="#">
      </li>
      <li>
        <span>Осмотреть (удерживать)</span>
        <img src="./img/mouse-wheel.svg" alt="#">
      </li>
    </ul>
    <!-- Основной левый блок -->
    <div class="content-left-wrap">
      <div class="mask-shop__logo">
        <span>Mask Shop</span>
        <img src="./img/masks.svg" alt="#">
      </div>
      <div class="content-left-selected-info-wrap">
        <p class="content-left-selected-info-title">Выберите элемент</p>
        <div class="content-left-selected-info-numbers">
          <p class="content-left-selected-info-numbers-text-select">{{ selectedMask + 1 }}/&nbsp;</p><p class="content-left-selected-info-numbers-text">{{ masksList.length }}</p>
        </div>
      </div>
      <div class="content-left-search">
        <input v-model="searchMask" type="text" @input="ChangeInput"/>
        <img src="./img/search.svg" alt="#">
      </div>
      <div class="content-left-list-wrap"> 
        <div v-for="(mask, n) in masksList" :key="n">
          <div v-if="!mask.hide" @click="SelectMask(n)" class="content-left-list-item-wrap" :class="{'content-center-body-part-wrap-select': n === selectedMask}">
            <p class="content-left-list-item-name">{{ mask.label }}</p>
            <div class="content-left-list-item-price-wrap">
              <p class="content-left-list-item-price-text">{{ mask.price }}</p>
              <p class="content-left-list-item-price-img">$</p>
            </div>
            <img src="./img/masks.svg" alt="#" v-if="n === selectedMask">
          </div>
        </div>
      </div>
    </div>
    <!-- Дополнительный правый блок блок -->
    <div class="content-right-wrap">
      <transition name="hide-mask-notifications"> <!-- Уведомления -->
        <notifications-component class="content-right__notifications" ref="_Notifications"/>
      </transition>
      <div class="content-right__result-mask-wrap">
        <div class="content-right__mask-name-weight-wrap">
          <div class="content-right__mask-name-weight--name">{{ resultMaskShop.label }}</div>
          <div class="content-right__mask-name-weight--weight-wrap" v-if="masksList[selectedMask]">
            <div class="content-right__mask-name-weight--weight-wrap--num">{{ (masksList[selectedMask].weight * resultMaskShop.count).toFixed(2) }}</div>
            <div class="content-right__mask-name-weight--weight-wrap--text">кг.</div>
          </div>
        </div>
        <div class="content-right__mask-color-wrap" v-if="masksList[selectedMask] && masksList[selectedMask].colors">
          <div class="content-right__mask-color-title">Расцветка</div>
          <div class="content-right__mask-color-select-wrap">
            <div @click="SwitchingMaskColor('prev')">
              <arrow-ico class="content-right__mask-color-left-arrow content-right__mask-color-arrow-active"/>
            </div>
            <p class="content-right__mask-color-select-color">{{ resultMaskShop.active }}</p>
            <p class="content-right__mask-color-length-color">/{{ masksList[selectedMask].colors.length }}</p>
            <div @click="SwitchingMaskColor('next')">
              <arrow-ico class="content-right__mask-color-right-arrow content-right__mask-color-arrow-active"/>
            </div> 
          </div>
        </div>
        <div class="content-right__mask-count-wrap">
          <div class="content-right__mask-count-title">Количество</div>
          <div class="content-right__mask-count-select-wrap">
            <div @click="QuantityMask('minus')">
              <minus-ico class="content-right__mask-count-minus content-right__mask-count-active"/>
            </div>
            <p class="content-right__mask-count-count-text">{{ resultMaskShop.count }}</p>
            <div @click="QuantityMask('plus')">
              <plus-ico class="content-right__mask-count-plus content-right__mask-count-active"/>
            </div>
          </div>
        </div>
        <div class="content-right__mask-price-wrap">
          <p class="content-right__mask-price-title">Цена</p>
          <div class="content-right__mask-price-block-wrap">
            <p class="content-right__mask-price">{{ resultMaskShop.price * resultMaskShop.count }}</p>
            <p class="content-right__mask-price-dollar">$</p>
          </div>
        </div>
        <div class="content-right__mask-btns-wrap">
          <button @click="PayForService('bank')" class="content-right__mask-btns-btn">Картой</button>
          <button @click="PayForService('cash')" class="content-right__mask-btns-btn">Наличными</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import ArrowIco from './icon/ArrowIco.vue';
import MinusIco from './icon/MinusIco.vue';
import PlusIco from './icon/PlusIco.vue';

import NotificationsComponent from '../_Notifications.vue';
import { InvokingNuiCallback } from '@/CustomMethods';

export default {
  name: 'MaskStore',
  components: {ArrowIco, MinusIco, PlusIco, NotificationsComponent},
  data() {
    return {
      masksList: [ // Список масок 
        
      ],
      searchMask: '', // (Поиск)
      selectedMask: 0, // Текущая выбранная маска из списка
      resultMaskShop: { // Параметры выбранной маски
        label: '',
        price: 0,
        weight: 0.0,
        colors: [],
        active: 1,
        count: 1
      },
      mouse_pressed: 0,
    }
  },
  methods: {
    message(event) { // Запросы которые приходят в браузер
      let e = event.data
      if (e.call == 'mask_store_open') {
        document.addEventListener('keyup', this.OnKeyUp);
      }
    },
    OnKeyUp(event) { // Клавиша была нажата
      if (event.which == 27) { // Esc
        console.log("escape menu done");
        document.removeEventListener('keyup', this.OnKeyUp); 

        InvokingNuiCallback(`closeUI`, {test: "true"}, function(response) {
          console.log(response);
        });
      }
    },
    ChangeInput() { // Поиск
      for (let i = 0; i < this.masksList.length; i++) { 
        let data = this.masksList[i].label.toLowerCase().includes(this.searchMask.toLowerCase());
        this.masksList[i].hide = !data;
      }
    },
    SwitchingMaskColor(type) { // Выбор цвета
      if (type == 'next') {
        if (this.resultMaskShop.active < this.resultMaskShop.colors.length)
          this.resultMaskShop.active += 1;
      } else {
        if (this.resultMaskShop.active > 1)
          this.resultMaskShop.active -= 1;
      }

      InvokingNuiCallback(`chooseColor`, {mask: this.selectedMask, texture: this.resultMaskShop.active}, function(response) {
        console.log(response);
      });
    },
    QuantityMask(type) { // Выбор кол-ва
      if (type == 'plus') 
        this.resultMaskShop.count += 1;
      else if (this.resultMaskShop.count > 1)
        this.resultMaskShop.count -= 1;
    },
    SelectMask(number) { // Выбор маски
      this.selectedMask = number;
      this.resultMaskShop.label = this.masksList[number].label;
      this.resultMaskShop.price = this.masksList[number].price;
      this.resultMaskShop.weight = this.masksList[number].weight;
      this.resultMaskShop.colors = this.masksList[number].colors;
      this.resultMaskShop.active = 1;
      this.resultMaskShop.count = 1;

      InvokingNuiCallback('chooseMask', {mask: number, texture: this.resultMaskShop.active}, function(response) {
        console.log(response);
      });
    },
    MouseButtonPressed(event, result) { // Игрок зажал кнопку мыши в области (Повороты)
      if (result) this.mouse_pressed = event.pageX;
      else this.mouse_pressed = false;
    },
    RotateCamera(event) { // Игрок перемещает мыш в области (Повороты)
      if (this.mouse_pressed) {
        if (this.mouse_pressed + 2 < event.pageX) { // Право
          this.mouse_pressed = event.pageX;

          InvokingNuiCallback(`rotateCamera`, {rotation: 35}, function(response) {
            console.log(response);
          });
          console.log('Right');
        } else if (this.mouse_pressed - 2 > event.pageX) { // Лево
          this.mouse_pressed = event.pageX;

          InvokingNuiCallback(`rotateCamera`, {rotation: -35}, function(response) {
            console.log(response);
          });
          console.log('Left');
        }
      }
    },
    OnWheel(event) { // Приближение отдаление камеры (Колесо мыши)
      let dir = Math.sign(event.deltaY);

      InvokingNuiCallback(`zoomCamera`, {zoom: dir}, function(response) {
        console.log(response);
      });

      console.log(dir);
    },
    PayForService(payType) { // Покупка
      console.log('Покупка: ' + payType);

      InvokingNuiCallback(`buyMask`, {selectedMask: this.selectedMask, maskParams: this.resultMaskShop}, function(response) {
        console.log(response);
      });
    },
    ForTheTest() { // Для теста в браузере
      this.masksList = [
        {label: 'Первая', price: 1500, weight: 0.33, colors: [22, 11, 13, 15]},
        {label: 'Вторая', price: 1234, weight: 0.12, colors: [0]}
      ]
      this.selectedMask = 0;
      this.resultMaskShop.label = this.masksList[this.selectedMask].label;
      this.resultMaskShop.price = this.masksList[this.selectedMask].price;
      this.resultMaskShop.weight = this.masksList[this.selectedMask].weight;
      this.resultMaskShop.colors = this.masksList[this.selectedMask].colors;
      this.resultMaskShop.active = 1;
      this.resultMaskShop.count = 1;
    }
  },
  mounted() {
    document.addEventListener('keyup', this.OnKeyUp);

    window.addEventListener('message', event => {
      const message = event.data;

      if (message.call == 'notification') {
        if (message.type == 'notEnoughMoney') {
          this.$refs._Notifications.AddNotifications('Внимание', 'У вас недостаточно средств для покупки!', 5000, 'error.svg', '#ff0000');
        } else if(message.type == "success") {
          this.$refs._Notifications.AddNotifications('Успешно', 'Вы успешно совершили покупку!', 5000, 'positively.svg', '#00FF48');
        } else if(message.type == "alreadyBought") {
          this.$refs._Notifications.AddNotifications('Внимание', 'У вас уже есть данная маска!', 5000, 'error.svg', '#ff0000');
        }
      }
    });

    this.masksList = {
        1: {label: 'Mask 1', price: 1500, weight: 0.33, colors: [0, 1]},
        2: {label: 'Mask 2', price: 1234, weight: 0.12, colors: [0, 1, 2]},
        5: {label: 'Mask 5', price: 899, weight: 0.12, colors: [0, 1, 2, 5, 3]},
        6: {label: 'Mask 6', price: 999, weight: 0.12, colors: [0, 1, 4]},
        14: {label: 'Mask 14', price: 123, weight: 0.42, colors: [0, 1, 2, 3 , 4, 5, 6, 7, 8, 9, 10]}
    };
    //this.ForTheTest();
    //this.$refs._Notifications.AddNotifications('Внимание!', 'Пример уведомления!', 5000, 'positively.svg', '#00FF48');

  }
}
</script>

<style lang="sass" scoped>
@import "~@/assets/fonts/akrobat/akrobat.css"
@import "~@/assets/fonts/gilroy/gilroy.css"
@import "~@/components/mask-shope/style/mask-store.sass"
</style>