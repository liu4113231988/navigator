# 起航导航

个人导航站，部署在 GitHub Pages，使用 Supabase 提供登录、数据库和图标存储。

在线地址：

```text
https://liu4113231988.github.io/navigator/
```

Supabase Project：

```text
https://iqfgmwiifvopplaqkspq.supabase.co
```

## 当前功能

- GitHub Pages 静态部署
- Supabase Auth 邮箱注册 / 登录
- 分类新增、改名、排序、删除
- 网站新增、编辑、排序、收藏、删除
- 同一用户的网址唯一：一个网址只能存在于一个分类
- 每个分类内的网站排序互相独立
- 网站排序值由小到大；排序为空时按创建时间由早到晚
- 收藏按收藏时间排序，最近收藏的排在前面
- 网站图标仅支持手动上传到 Supabase Storage
- 未上传图标时显示网站名称首字，不调用第三方 favicon / Logo 服务
- 天气地区和主题保存在当前浏览器

## 仓库结构

当前项目为单页面部署：

```text
navigator/
├── .nojekyll
├── index.html
├── supabase.sql
├── README.md
├── DEPLOY-CHECKLIST.md
└── LICENSE
```

## 1. Supabase 数据库

进入：

```text
Supabase Dashboard → SQL Editor
```

执行仓库中的最新 `supabase.sql`。

脚本可以重复执行，会：

- 创建 / 更新 `nav_categories`
- 创建 / 更新 `nav_sites`
- 配置 RLS
- 配置 authenticated 数据权限
- 让 `nav_sites.sort_order` 支持 NULL
- 增加 `favorite_at` 收藏时间字段
- 为旧收藏回填一个近似收藏时间
- 配置 `site-icons` 的 Storage 上传 / 删除策略

现有项目升级到当前版本时，也建议重新完整执行一次最新的 `supabase.sql`。

## 2. Storage 图标 Bucket

在 Supabase：

```text
Storage → New bucket
```

创建：

```text
Bucket ID: site-icons
Public bucket: 开启
```

图标只允许登录用户上传到自己的 UID 目录：

```text
site-icons/{auth.uid()}/{uuid}.png
```

页面只使用手动上传的图标。删除或替换图标时，会尝试同时清理 Storage 中的旧文件。

## 3. Auth URL

进入：

```text
Authentication → URL Configuration
```

设置：

```text
Site URL
https://liu4113231988.github.io/navigator/
```

Redirect URLs 至少加入：

```text
https://liu4113231988.github.io/navigator/
```

## 4. GitHub Pages

仓库：

```text
liu4113231988/navigator
```

GitHub：

```text
Settings → Pages
Source: Deploy from a branch
Branch: main
Folder: / (root)
```

发布地址：

```text
https://liu4113231988.github.io/navigator/
```

## 5. 排序规则

### 分类排序

`nav_categories.sort_order`：

- 数值越小越靠前
- 数值相同则按创建时间由早到晚
- 新建分类默认放到当前最大排序值之后

### 网站排序

每个分类单独计算：

- `sort_order` 有值：由小到大
- 排序值相同：创建时间由早到晚
- `sort_order` 为空：排在有明确排序值的网站之后，再按创建时间由早到晚

### 收藏排序

收藏不使用各分类的 `sort_order` 混排。

- 收藏时写入 `favorite_at`
- 收藏 Tab 按 `favorite_at` 从新到旧排列
- 取消收藏时清空 `favorite_at`

## 6. 网站唯一性

数据库约束：

```sql
unique (user_id, url)
```

因此同一个账号下，同一个规范化后的网址只能保存一次，也只能属于一个分类。

## 7. 安全说明

前端仅使用 Supabase Publishable key，数据权限由 RLS 控制。

不要向 GitHub 提交：

- Supabase Secret key
- `service_role` key
- 数据库密码

`site-icons` 是 Public Bucket，因此图片可公开读取；上传和删除仍由 Storage RLS 限制到当前登录用户。
