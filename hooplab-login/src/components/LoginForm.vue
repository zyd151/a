<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { login } from '../api/auth'

const emit = defineEmits(['success'])
const router = useRouter()

const account = ref('')
const password = ref('')
const error = ref('')

async function onSubmit() {
  if (!account.value.trim() || !password.value.trim()) {
    error.value = '请输入账号和密码'
    return
  }
  error.value = ''
  try {
    await login(account.value.trim(), password.value)
    emit('success')
  } catch (e) {
    error.value = e.message || '登录失败'
  }
}
</script>

<template>
  <section class="login">
    <h2 class="login__title">欢迎回来</h2>
    <p class="login__sub">登录 HoopLab，继续你的篮球之旅</p>

    <form class="login__form" @submit.prevent="onSubmit">
      <label class="login__field">
        <span>账号</span>
        <input
          v-model="account"
          type="text"
          autocomplete="username"
          placeholder="手机号 / 邮箱"
        />
      </label>

      <label class="login__field">
        <span>密码</span>
        <input
          v-model="password"
          type="password"
          autocomplete="current-password"
          placeholder="请输入密码"
        />
      </label>

      <p v-if="error" class="login__error">{{ error }}</p>

      <button class="login__submit" type="submit">登 录</button>

      <div class="login__foot">
        <span>还没有账号？</span>
        <a href="#" @click.prevent="router.push('/register')">立即注册</a>
      </div>
    </form>
  </section>
</template>

<style scoped>
.login {
  padding: 56px 48px;
  display: flex;
  flex-direction: column;
  justify-content: center;
  background: rgba(10, 17, 32, 0.4);
}

.login__title {
  margin: 0;
  font-size: 26px;
  font-weight: 700;
}

.login__sub {
  margin: 8px 0 28px;
  font-size: 14px;
  color: rgba(232, 237, 246, 0.6);
}

.login__form {
  display: flex;
  flex-direction: column;
  gap: 18px;
}

.login__field {
  display: flex;
  flex-direction: column;
  gap: 8px;
  font-size: 13px;
  color: rgba(232, 237, 246, 0.8);
}

.login__field input {
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

.login__field input:focus {
  border-color: #ff8a3d;
  box-shadow: 0 0 0 3px rgba(255, 138, 61, 0.18);
}

.login__field input::placeholder {
  color: rgba(232, 237, 246, 0.35);
}

.login__error {
  margin: -4px 0 0;
  font-size: 13px;
  color: #ff6b6b;
}

.login__submit {
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

.login__submit:hover {
  transform: translateY(-1px);
  box-shadow: 0 12px 24px rgba(255, 94, 98, 0.32);
}

.login__foot {
  margin-top: 14px;
  font-size: 13px;
  color: rgba(232, 237, 246, 0.6);
  text-align: center;
}

.login__foot a {
  color: #ff8a3d;
  text-decoration: none;
  margin-left: 4px;
}

@media (max-width: 900px) {
  .login {
    padding: 40px 28px;
  }
}
</style>
