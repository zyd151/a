<script setup>
defineProps({
  visible: {
    type: Boolean,
    default: false
  },
  text: {
    type: String,
    default: ''
  }
})
</script>

<template>
  <transition name="toast">
    <div v-if="visible" class="toast">
      <span class="toast__icon">✓</span>
      <span>{{ text }}</span>
    </div>
  </transition>
</template>

<style scoped>
.toast {
  position: fixed;
  top: 32px;
  left: 50%;
  transform: translateX(-50%);
  z-index: 999;
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 12px 22px;
  border-radius: 14px;
  background: rgba(20, 30, 48, 0.92);
  border: 1px solid var(--line);
  color: #e8edf6;
  font-size: 15px;
  box-shadow: 0 18px 40px rgba(0, 0, 0, 0.45);
  backdrop-filter: blur(6px);
}

.toast__icon {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 22px;
  height: 22px;
  border-radius: 50%;
  background: linear-gradient(135deg, #ff8a3d, #ff5e62);
  color: #fff;
  font-size: 13px;
  font-weight: 700;
}

.toast-enter-active,
.toast-leave-active {
  transition: opacity 0.3s ease, transform 0.3s ease;
}

.toast-enter-from,
.toast-leave-to {
  opacity: 0;
  transform: translateX(-50%) translateY(-12px);
}
</style>
