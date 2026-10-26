<script setup>
// 左侧球场视觉面板：用 SVG 绘制半场球场线条 + 品牌信息
</script>

<template>
  <aside class="court">
    <div class="court__glow"></div>

    <svg
      class="court__lines"
      viewBox="0 0 360 480"
      preserveAspectRatio="xMidYMid slice"
      aria-hidden="true"
    >
      <!-- 外框 -->
      <rect x="20" y="20" width="320" height="440" rx="8" fill="none" stroke="rgba(255,255,255,0.16)" stroke-width="2" />
      <!-- 中线 -->
      <line x1="20" y1="240" x2="340" y2="240" stroke="rgba(255,255,255,0.14)" stroke-width="2" />
      <!-- 中圈 -->
      <circle cx="180" cy="240" r="56" fill="none" stroke="rgba(255,255,255,0.14)" stroke-width="2" />
      <!-- 罚球区 -->
      <rect x="110" y="240" width="140" height="150" fill="none" stroke="rgba(255,255,255,0.16)" stroke-width="2" />
      <!-- 罚球圈 -->
      <circle cx="180" cy="300" r="46" fill="none" stroke="rgba(255,255,255,0.16)" stroke-width="2" />
      <!-- 三分弧 -->
      <path d="M 40 460 L 40 360 A 140 140 0 0 1 320 360 L 320 460" fill="none" stroke="rgba(255,255,255,0.14)" stroke-width="2" />
      <!-- 篮筐 -->
      <circle cx="180" cy="356" r="10" fill="none" stroke="#ff8a3d" stroke-width="3" />
      <line x1="160" y1="356" x2="200" y2="356" stroke="#ff8a3d" stroke-width="2" />
    </svg>

    <div class="court__brand">
      <div class="court__logo">🏀</div>
      <h1>HoopLab</h1>
      <p>登上球场，开启你的训练日常</p>
    </div>
  </aside>
</template>

<style scoped>
.court {
  position: relative;
  min-height: 520px;
  overflow: hidden;
  background: linear-gradient(160deg, #14233f 0%, #0c1730 100%);
  display: flex;
  align-items: flex-end;
  padding: 40px 36px;
}

.court__glow {
  position: absolute;
  top: -120px;
  left: -80px;
  width: 320px;
  height: 320px;
  background: radial-gradient(circle, rgba(255, 138, 61, 0.35), transparent 70%);
  filter: blur(10px);
  pointer-events: none;
}

.court__lines {
  position: absolute;
  inset: 0;
  width: 100%;
  height: 100%;
  opacity: 0.9;
}

.court__brand {
  position: relative;
  z-index: 1;
}

.court__logo {
  font-size: 44px;
  line-height: 1;
  margin-bottom: 14px;
}

.court__brand h1 {
  margin: 0;
  font-size: 34px;
  letter-spacing: 1px;
  font-weight: 800;
}

.court__brand p {
  margin: 10px 0 0;
  font-size: 14px;
  color: rgba(232, 237, 246, 0.7);
}
</style>
