import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [vue()],
  server: {
    host: true,
    port: 5173,
    strictPort: false,
    // 开发期将 /user 请求代理到后端 Spring Boot（端口 8081），规避跨域
    proxy: {
      '/user': {
        target: 'http://localhost:8081',
        changeOrigin: true
      }
    }
  }
})
