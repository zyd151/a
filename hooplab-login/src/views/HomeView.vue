<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { getUserInfo, getStats, recordTraining, logout as clearAuth } from '../api/auth'

const router = useRouter()
const user = ref(null)
const stats = ref(null)
const loading = ref(true)

// 记录训练表单状态
const showRecord = ref(false)
const shots = ref(null)
const hits = ref(null)
const recError = ref('')
const recording = ref(false)

const today = new Date().toLocaleDateString('zh-CN', {
  year: 'numeric',
  month: 'long',
  day: 'numeric',
  weekday: 'long'
})

// 由后端返回的真实统计组装成卡片
const statCards = computed(() => [
  { label: '本周训练', value: stats.value?.weekTrainCount ?? '-', unit: '次' },
  { label: '累计投篮', value: stats.value?.totalShots ?? '-', unit: '球' },
  { label: '命中率', value: stats.value?.hitRate ?? '-', unit: '%' }
])

onMounted(async () => {
  try {
    user.value = await getUserInfo()
    stats.value = await getStats()
  } catch (e) {
    // 未登录或 token 失效，回到登录页
    router.push('/')
  } finally {
    loading.value = false
  }
})

async function submitRecord() {
  recError.value = ''
  const s = Number(shots.value)
  const h = Number(hits.value)
  if (!s || s < 1) {
    recError.value = '请输入有效的投篮数（至少 1）'
    return
  }
  if (h < 0 || h > s) {
    recError.value = '命中数需在 0 到投篮数之间'
    return
  }
  recording.value = true
  try {
    stats.value = await recordTraining(s, h)
    showRecord.value = false
    shots.value = null
    hits.value = null
  } catch (e) {
    recError.value = e.message || '记录失败'
  } finally {
    recording.value = false
  }
}

function logout() {
  clearAuth()
  router.push('/')
}
</script>

<template>
  <div class="home">
    <header class="home__bar">
      <div class="home__brand">🏀 HoopLab</div>
      <div class="home__right">
        <span class="home__user" v-if="user">{{ user.nickname || user.account }}</span>
        <button class="home__logout" @click="logout">退出登录</button>
      </div>
    </header>

    <main class="home__main">
      <div class="home__hero">
        <p class="home__date">{{ today }}</p>
        <h1>{{ user ? '欢迎回来，' + (user.nickname || user.account) : '欢迎来到球场' }}</h1>
        <p class="home__tip">今天也要保持手感，来一场痛快训练吧。</p>
      </div>

      <section class="home__stats">
        <div v-for="s in statCards" :key="s.label" class="home__card">
          <div class="home__value">{{ s.value }}<span>{{ s.unit }}</span></div>
          <div class="home__label">{{ s.label }}</div>
        </div>
      </section>

      <section class="home__record">
        <button class="home__record-btn" @click="showRecord = !showRecord">+ 记录一次训练</button>
        <div v-if="showRecord" class="home__record-form">
          <label class="home__rec-field">
            <span>投篮数</span>
            <input v-model.number="shots" type="number" min="1" placeholder="例如 100" />
          </label>
          <label class="home__rec-field">
            <span>命中数</span>
            <input v-model.number="hits" type="number" min="0" placeholder="例如 60" />
          </label>
          <p v-if="recError" class="home__rec-error">{{ recError }}</p>
          <div class="home__rec-actions">
            <button class="home__rec-submit" :disabled="recording" @click="submitRecord">保存</button>
            <button class="home__rec-cancel" @click="showRecord = false">取消</button>
          </div>
        </div>
      </section>

      <section class="home__court">
        <svg viewBox="0 0 800 360" class="home__court-svg" aria-hidden="true">
          <rect x="20" y="20" width="760" height="320" rx="10" fill="none" stroke="rgba(255,255,255,0.16)" stroke-width="2" />
          <line x1="400" y1="20" x2="400" y2="340" stroke="rgba(255,255,255,0.14)" stroke-width="2" />
          <circle cx="400" cy="180" r="70" fill="none" stroke="rgba(255,255,255,0.14)" stroke-width="2" />
          <rect x="300" y="20" width="200" height="110" fill="none" stroke="rgba(255,255,255,0.16)" stroke-width="2" />
          <rect x="300" y="230" width="200" height="110" fill="none" stroke="rgba(255,255,255,0.16)" stroke-width="2" />
          <circle cx="400" cy="110" r="34" fill="none" stroke="rgba(255,255,255,0.16)" stroke-width="2" />
          <circle cx="400" cy="250" r="34" fill="none" stroke="rgba(255,255,255,0.16)" stroke-width="2" />
          <circle cx="400" cy="80" r="9" fill="none" stroke="#ff8a3d" stroke-width="3" />
          <circle cx="400" cy="280" r="9" fill="none" stroke="#ff8a3d" stroke-width="3" />
        </svg>
      </section>
    </main>
  </div>
</template>

<style scoped>
.home {
  width: 100%;
  min-height: 100vh;
  display: flex;
  flex-direction: column;
}

.home__bar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 18px 32px;
  border-bottom: 1px solid var(--line);
  background: rgba(10, 17, 32, 0.5);
  backdrop-filter: blur(8px);
}

.home__brand {
  font-size: 20px;
  font-weight: 800;
  letter-spacing: 0.5px;
}

.home__right {
  display: flex;
  align-items: center;
  gap: 14px;
}

.home__user {
  font-size: 14px;
  color: rgba(232, 237, 246, 0.85);
}

.home__logout {
  height: 38px;
  padding: 0 18px;
  border-radius: 10px;
  border: 1px solid var(--line);
  background: transparent;
  color: rgba(232, 237, 246, 0.85);
  font-size: 14px;
  cursor: pointer;
  transition: border-color 0.2s, color 0.2s;
}

.home__logout:hover {
  border-color: #ff8a3d;
  color: #ff8a3d;
}

.home__main {
  flex: 1;
  max-width: 960px;
  width: 100%;
  margin: 0 auto;
  padding: 40px 24px 56px;
}

.home__date {
  margin: 0;
  font-size: 14px;
  color: rgba(232, 237, 246, 0.55);
}

.home__hero h1 {
  margin: 8px 0 10px;
  font-size: 34px;
  font-weight: 800;
}

.home__tip {
  margin: 0;
  color: rgba(232, 237, 246, 0.7);
}

.home__stats {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 18px;
  margin: 32px 0;
}

.home__card {
  padding: 22px;
  border-radius: 16px;
  border: 1px solid var(--line);
  background: linear-gradient(160deg, rgba(20, 35, 63, 0.6), rgba(10, 17, 32, 0.4));
}

.home__value {
  font-size: 30px;
  font-weight: 800;
  color: #ff8a3d;
}

.home__value span {
  font-size: 15px;
  font-weight: 600;
  color: rgba(232, 237, 246, 0.7);
  margin-left: 4px;
}

.home__label {
  margin-top: 6px;
  font-size: 13px;
  color: rgba(232, 237, 246, 0.6);
}

.home__court {
  border-radius: 18px;
  border: 1px solid var(--line);
  background: linear-gradient(160deg, #14233f, #0c1730);
  padding: 18px;
  overflow: hidden;
}

.home__record {
  margin: 22px 0;
}

.home__record-btn {
  height: 44px;
  padding: 0 22px;
  border-radius: 12px;
  border: 1px dashed rgba(255, 138, 61, 0.6);
  background: rgba(255, 138, 61, 0.08);
  color: #ff8a3d;
  font-size: 15px;
  font-weight: 600;
  cursor: pointer;
  transition: background 0.2s, transform 0.15s;
}

.home__record-btn:hover {
  background: rgba(255, 138, 61, 0.16);
  transform: translateY(-1px);
}

.home__record-form {
  margin-top: 14px;
  padding: 20px;
  display: flex;
  flex-wrap: wrap;
  align-items: flex-end;
  gap: 16px;
  border-radius: 16px;
  border: 1px solid var(--line);
  background: rgba(10, 17, 32, 0.4);
}

.home__rec-field {
  display: flex;
  flex-direction: column;
  gap: 8px;
  font-size: 13px;
  color: rgba(232, 237, 246, 0.8);
}

.home__rec-field input {
  width: 160px;
  height: 42px;
  padding: 0 14px;
  border-radius: 10px;
  border: 1px solid var(--line);
  background: rgba(255, 255, 255, 0.04);
  color: #e8edf6;
  font-size: 15px;
  outline: none;
  transition: border-color 0.2s, box-shadow 0.2s;
}

.home__rec-field input:focus {
  border-color: #ff8a3d;
  box-shadow: 0 0 0 3px rgba(255, 138, 61, 0.18);
}

.home__rec-error {
  width: 100%;
  margin: 0;
  font-size: 13px;
  color: #ff6b6b;
}

.home__rec-actions {
  display: flex;
  gap: 12px;
}

.home__rec-submit {
  height: 42px;
  padding: 0 22px;
  border: 0;
  border-radius: 10px;
  background: linear-gradient(135deg, #ff8a3d, #ff5e62);
  color: #fff;
  font-size: 15px;
  font-weight: 700;
  cursor: pointer;
}

.home__rec-submit:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.home__rec-cancel {
  height: 42px;
  padding: 0 18px;
  border: 1px solid var(--line);
  border-radius: 10px;
  background: transparent;
  color: rgba(232, 237, 246, 0.8);
  font-size: 15px;
  cursor: pointer;
}

.home__court-svg {
  width: 100%;
  height: auto;
  display: block;
}

@media (max-width: 640px) {
  .home__stats {
    grid-template-columns: 1fr;
  }
}
</style>
