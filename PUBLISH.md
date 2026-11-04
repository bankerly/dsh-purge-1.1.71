# 发布到 GitHub / Publish

仓库已初始化并提交好，只差远端认证与 push。三种方式挑一种。

---

## 方式 A：有 Personal Access Token（最省事）

在 GitHub → Settings → Developer settings → Personal access tokens 建一个 **classic token**，勾 `repo` 权限（要发 release 再加 `workflow`）。

```powershell
cd C:\Users\Mic\Desktop\dsh-purge-1.1.71

# 1) 换成你自己的身份（只对本次 commit 生效）
git config user.name  "YOUR_NAME"
git config user.email "YOUR_EMAIL@users.noreply.github.com"
git commit --amend --reset-author --no-edit

# 2) 建空仓库（网页上建也行，名字建议 dsh-purge-1.1.71，不要勾 README）

# 3) 推
git remote add origin https://github.com/YOUR_USER/dsh-purge-1.1.71.git
git push -u origin master
```

push 时提示密码 = **粘贴 token**，不是 GitHub 登录密码。

---

## 方式 B：安装了 GitHub CLI

```powershell
winget install --id GitHub.cli
gh auth login          # 选 GitHub.com → HTTPS → 浏览器登录
cd C:\Users\Mic\Desktop\dsh-purge-1.1.71
gh repo create dsh-purge-1.1.71 --public --source=. --remote=origin --push
```

---

## 方式 C：SSH

```powershell
ssh-keygen -t ed25519 -C "your@email" -f $HOME\.ssh\id_ed25519
Get-Content $HOME\.ssh\id_ed25519.pub     # 贴到 GitHub → SSH and GPG keys
cd C:\Users\Mic\Desktop\dsh-purge-1.1.71
git remote add origin git@github.com:YOUR_USER/dsh-purge-1.1.71.git
git push -u origin master
```

---

## 推完建议做的三件事

1. **打标签**，让版本号可检索：
   ```powershell
   git tag -a v1.1.71 -m "dsh-purge 1.1.71 source archive (pre-fix, packed 2026-10-11)"
   git push origin v1.1.71
   ```
2. **把原始 tgz 挂到 Release**（`*.tgz` 已在 `.gitignore` 里，不进仓库主体）：
   在 Release 页面手动上传 `dsh-purge-1.1.71.tgz`（1,460,306 B，md5 `49485903584ef950091e83bca94d360f`）。
3. **仓库描述**写明来源，别让人误以为是你的项目：
   `source archive of dsh-purge v1.1.71 (upstream: YuJunZhiXue/dsh-purge), MIT, packed 2026-10-11`

---

## 注意

- `.github/workflows/release.yml` 带了，但它有 `if: github.repository == 'YuJunZhiXue/dsh-purge'`，在你自己的仓库上不会触发，也不会因为缺 secrets 报错。想彻底干净就删掉这个目录。
- 仓库建议先 **Public** 再考虑转 Private：这是 MIT 项目的存档，公开符合许可；如果只想自己留档，Private 也行。
- 不要往这个仓库里提交 `node_modules/`、`*.asar`、`lib/default-prompt-inject.md`——`.gitignore` 已经挡住了。
