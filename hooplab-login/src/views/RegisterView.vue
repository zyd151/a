<script setup>
import { ref, onUnmounted } from 'vue'
import { useRouter } from 'vue-router'
import CourtPanel from '../components/CourtPanel.vue'
import Toast from '../components/Toast.vue'
import { register } from '../api/auth'

const router = useRouter()

const form = ref({
  account: '',
  password: '',
  confirm: ''
})
const error = ref('')
const toastVisible = ref(false)
let timer = null

async function onSubmit() {
  const { account, password, confirm } = form.value
  if (!account.trim() || !password.trim()) {
    error.value = '请输入账号和密码'
    return
  }
  if (password !== confirm) {
    error.value = '两次输入的密码不一致'
    return
  }
  error.value = ''
  try {
    await register(account.trim(), password)
    toastVisible.value = true
    clearTimeout(timer)
    timer = setTimeout(() => {
      toastVisible.value = false
      router.push('/')
    }, 1600)
  } catch (e) {
    error.value = e.message || '注册失败'
  }
}

onUnmounted(() => clearTimeout(timer))
</script>

<template>
  <div class="stage">
    <CourtPanel />
    <section class="reg">
      <h2 class="reg__title">创建账号</h2>
      <p class="reg__sub">加入 HoopLab，开启你的篮球之旅</p>

      <form class="reg__form" @submit.prevent="onSubmit">
        <label class="reg__field">
          <span>账号</span>
          <input v-model="form.account" type="text" placeholder="手机号 / 邮箱" />
        </label>

        <label class="reg__field">
          <span>密码</span>
          <input v-model="form.password" type="password" placeholder="设置密码" />
        </label>

        <label class="reg__field">
          <span>确认密码</span>
          <input v-model="form.confirm" type="password" placeholder="再次输入密码" />
        </label>

        <p v-if="error" class="reg__error">{{ error }}</p>

        <button class="reg__submit" type="submit">注 册</button>

        <div class="reg__foot">
          <span>已有账号？</span>
          <a href="#" @click.prevent="router.push('/')">返回登录</a>
        </div>
      </form>
    </section>
  </div>

  <Toast :visible="toastVisible" text="注册成功，请登录" />
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

.reg {
  padding: 48px 48px;
  display: flex;
  flex-direction: column;
  justify-content: center;
  background: rgba(10, 17, 32, 0.4);
}

.reg__title {
  margin: 0;
  font-size: 26px;
  font-weight: 700;
}

.reg__sub {
  margin: 8px 0 24px;
  font-size: 14px;
  color: rgba(232, 237, 246, 0.6);
}

.reg__form {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.reg__field {
  display: flex;
  flex-direction: column;
  gap: 8px;
  font-size: 13px;
  color: rgba(232, 237, 246, 0.8);
}

.reg__field input {
  height: 46px;
  padding: 0 14px;
  border-radius: 12px;
  border: 1px solid var(--line);
  background: rgba(255, 255, 255, 0.04);
  color: #e8edf6;
  font-size: 15px;
  outline: none;
  transition: border-color 0.2s, box-shadow 0.2s;
}

.reg__field input:focus {
  border-color: #ff8a3d;
  box-shadow: 0 0 0 3px rgba(255, 138, 61, 0.18);
}

.reg__field input::placeholder {
  color: rgba(232, 237, 246, 0.35);
}

.reg__error {
  margin: -2px 0 0;
  font-size: 13px;
  color: #ff6b6b;
}

.reg__submit {
  margin-top: 6px;
  height: 48px;
  border: 0;
  border-radius: 12px;
  background: linear-gradient(135deg, #ff8a3d, #ff5e62);
  color: #fff;
  font-size: 16px;
  font-weight: 700;
  letter-spacing: 2px;
  cursor: pointer;
  transition: transform 0.15s, box-shadow 0.2s;
}

.reg__submit:hover {
  transform: translateY(-1px);
  box-shadow: 0 12px 24px rgba(255, 94, 98, 0.32);
}

.reg__foot {
  margin-top: 14px;
  font-size: 13px;
  color: rgba(232, 237, 246, 0.6);
  text-align: center;
}

.reg__foot a {
  color: #ff8a3d;
  text-decoration: none;
  margin-left: 4px;
}

@media (max-width: 900px) {
  .stage {
    grid-template-columns: 1fr;
    border-radius: 0;
    border: 0;
    min-height: 100vh;
    box-shadow: none;
  }
  .reg {
    padding: 40px 28px;
  }
}
</style>
