# 起航导航 — GitHub Pages + Supabase

本版本已经针对下面的 GitHub Pages 地址完成配置：

```text
https://liu4113231988.github.io/navigator/
```

Supabase Project：

```text
https://iqfgmwiifvopplaqkspq.supabase.co
```

## 仓库结构

请创建一个公开仓库：

```text
navigator
```

然后把本目录中的文件直接放到仓库 `main` 分支根目录：

```text
navigator/
├── .nojekyll
├── index.html
├── app.css
├── app.js
├── config.js
├── supabase.sql
└── README.md
```

网页静态资源全部使用 `./` 相对路径，因此适配项目级 Pages 的 `/navigator/` 子路径。

## 第一步：Supabase 初始化

进入 Supabase Dashboard → SQL Editor，完整执行 `supabase.sql` 一次。

它会创建：

- `nav_categories`
- `nav_sites`
- RLS（Row Level Security）策略
- authenticated 用户所需的数据表权限

不要关闭 RLS。

## 第二步：Supabase Auth URL 配置

进入：

```text
Authentication → URL Configuration
```

设置：

```text
Site URL
https://liu4113231988.github.io/navigator/
```

在 Redirect URLs 中至少加入：

```text
https://liu4113231988.github.io/navigator/
```

如果 Supabase 控制台支持通配规则，也可以额外加入：

```text
https://liu4113231988.github.io/navigator/**
```

当前前端注册确认邮件的 `emailRedirectTo` 已固定为：

```text
https://liu4113231988.github.io/navigator/
```

## 第三步：GitHub Pages

在 GitHub 创建仓库：

```text
liu4113231988/navigator
```

上传本目录文件到仓库根目录后：

1. 打开仓库 `Settings`
2. 点击 `Pages`
3. `Build and deployment` → `Source` 选择 `Deploy from a branch`
4. Branch 选择 `main`
5. Folder 选择 `/ (root)`
6. 保存

发布成功后访问：

```text
https://liu4113231988.github.io/navigator/
```

## 第四步：第一次登录

1. 打开导航站
2. 右上角点击“登录”
3. 输入邮箱和密码后点击“注册”
4. 如果 Supabase 开启邮箱验证，到邮箱点击确认链接
5. 返回导航站登录
6. 第一次登录会自动初始化默认分类和站点

以后新增、编辑、删除、收藏都会直接写入 Supabase，不需要重新部署 GitHub Pages。

## 安全说明

`config.js` 中只有 Supabase Publishable key。Publishable key 可以存在浏览器前端；真正的数据访问限制由 RLS 完成。

**禁止**把下面任何内容提交到 GitHub：

- Secret key
- `service_role` key
- 数据库密码
