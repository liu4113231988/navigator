# 部署 / 升级检查清单

## Supabase 数据库

- [ ] 已在 SQL Editor 完整执行最新 `supabase.sql`
- [ ] `nav_sites.sort_order` 允许 NULL
- [ ] `nav_sites.favorite_at` 字段已存在
- [ ] `nav_categories` / `nav_sites` 已启用 RLS
- [ ] authenticated 用户的 SELECT / INSERT / UPDATE / DELETE 正常

## Supabase Storage

- [ ] 已创建 Public Bucket：`site-icons`
- [ ] 上传策略只允许登录用户写入自己的 UID 目录
- [ ] 删除策略只允许用户删除自己的对象
- [ ] 手动上传 PNG / JPG / WebP / SVG / ICO 后刷新仍能显示
- [ ] 不上传图标时显示网站名称首字
- [ ] 页面不再依赖 Google favicon 或其他第三方 Logo 地址
- [ ] 替换 / 删除网站图标后，旧 Storage 文件能够被清理

## Supabase Auth

- [ ] Site URL = `https://liu4113231988.github.io/navigator/`
- [ ] Redirect URLs 已加入 `https://liu4113231988.github.io/navigator/`
- [ ] 注册 → 邮箱确认 → 回调地址正确
- [ ] 已确认登录和退出正常

## GitHub Pages

- [ ] 仓库为 `liu4113231988/navigator`
- [ ] 文件位于 `main` 分支根目录
- [ ] Pages = Deploy from a branch → `main` → `/ (root)`
- [ ] 能打开 `https://liu4113231988.github.io/navigator/`

## 功能验收

- [ ] 默认打开“常用”Tab
- [ ] 分类可以新增、改名、调整排序、删除
- [ ] 分类排序值越小越靠前
- [ ] 同一个网址不能重复保存到不同分类
- [ ] 网站可以单独设置排序值
- [ ] 同一分类内网站按排序值由小到大
- [ ] 网站排序留空时按创建时间由早到晚
- [ ] 收藏后，最近收藏的网站排在收藏 Tab 前面
- [ ] 取消收藏后，该网站从收藏 Tab 消失
- [ ] 另一浏览器登录同账号后，分类、网站、排序、收藏和上传图标一致
