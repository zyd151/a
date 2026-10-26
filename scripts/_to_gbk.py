# -*- coding: utf-8 -*-
"""把 scripts 目录下的 .bat 文件统一转成 GBK(936) 编码，并去掉 BOM。"""
import os
import glob

BASE = os.path.dirname(os.path.abspath(__file__))
files = sorted(glob.glob(os.path.join(BASE, "*.bat")))

for path in files:
    with open(path, "r", encoding="utf-8") as f:
        content = f.read()
    # 统一换行符为 CRLF，Windows 批处理更稳
    content = content.replace("\r\n", "\n").replace("\n", "\r\n")
    with open(path, "w", encoding="gbk", errors="strict", newline="") as f:
        f.write(content)
    print("OK  %s" % os.path.basename(path))
