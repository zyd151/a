// 与后端 springBootTest 的认证接口对接
// 后端基址 /user，由 vite.config.js 的 dev proxy 转发到 http://localhost:8081
const BASE = '/user'
const TOKEN_KEY = 'hooplab_token'

export function getToken() {
  return localStorage.getItem(TOKEN_KEY) || ''
}

export function setToken(token) {
  if (token) localStorage.setItem(TOKEN_KEY, token)
}

export function clearToken() {
  localStorage.removeItem(TOKEN_KEY)
}

async function request(url, options = {}) {
  const headers = { ...(options.headers || {}) }
  // 有 token 就自动带上（公开接口会忽略，受保护接口需要）
  const token = getToken()
  if (token && !headers['Authorization']) {
    headers['Authorization'] = `Bearer ${token}`
  }
  const res = await fetch(url, { ...options, headers })
  // 未登录 / 过期：后端返回 401 JSON
  if (res.status === 401) {
    clearToken()
    throw new Error('登录已过期，请重新登录')
  }
  const json = await res.json()
  // 后端统一返回 { code, message, data }，code=200 表示成功
  if (json.code !== 200) {
    throw new Error(json.message || '请求失败')
  }
  return json.data
}

function post(path, body) {
  return request(`${BASE}${path}`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(body)
  })
}

export function login(account, password) {
  return post('/login', { account, password }).then((data) => {
    // data = { token, user }
    setToken(data.token)
    return data
  })
}

export function register(account, password) {
  return post('/register', { account, password })
}

export function getUserInfo() {
  return request(`${BASE}/info`, { method: 'GET' })
}

export function getStats() {
  return request(`${BASE}/stats`, { method: 'GET' })
}

export function recordTraining(shots, hits) {
  return post('/training', { shots, hits })
}

export function logout() {
  clearToken()
}
