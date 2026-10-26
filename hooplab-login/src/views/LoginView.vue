<script setup>
import { ref, onUnmounted } from 'vue'
import { useRouter } from 'vue-router'
import CourtPanel from '../components/CourtPanel.vue'
import LoginForm from '../components/LoginForm.vue'
import Toast from '../components/Toast.vue'

const router = useRouter()
const toastVisible = ref(false)
let timer = null

function handleSuccess() {
  clearTimeout(timer)
  toastVisible.value = true
  timer = setTimeout(() => {
    toastVisible.value = false
    router.push('/home')
  }, 1600)
}

onUnmounted(() => clearTimeout(timer))
</script>

<template>
  <div class="stage">
    <CourtPanel />
    <LoginForm @success="handleSuccess" />
  </div>

  <Toast :visible="toastVisible" text="登录成功，正在进入球场…" />
</template>

<style scoped>
.stage {
  position: relative;
  z-index: 1;
  width: 100%;
  max-width: 1080px;
  display: grid;
  grid-template-columns: 1.05fr 0.95fr;
  border-radius: 26px;
  overflow: hidden;
  background: linear-gradient(160deg, #0e1524 0%, #0a1120 100%);
  border: 1px solid var(--line);
  box-shadow: 0 40px 90px rgba(0, 0, 0, 0.55), 0 0 0 1px rgba(255, 255, 255, 0.03) inset;
}

@media (max-width: 900px) {
  .stage {
    grid-template-columns: 1fr;
    border-radius: 0;
    border: 0;
    min-height: 100vh;
    box-shadow: none;
  }
}
</style>
