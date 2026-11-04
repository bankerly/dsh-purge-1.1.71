# 来源与署名 / Provenance & Attribution

本仓库是 **dsh-purge v1.1.71** 的源码存档（source archive），不是本项目原创。

| 项 | 值 |
|---|---|
| 上游项目 / Upstream | [YuJunZhiXue/dsh-purge](https://github.com/YuJunZhiXue/dsh-purge) |
| 版本 / Version | 1.1.71 |
| 上游作者 / Author | 小杨（YuJunZhiXue） |
| 许可证 / License | MIT（见 [LICENSE](LICENSE)，版权行原样保留：`Copyright (c) 2026 小杨`） |
| 本存档来源 / Archive origin | npm 打包产物 `dsh-purge-1.1.71.tgz`，解包后原样提交 |
| 打包时间 / Packed at | 2026-10-11 |
| 目标宿主 / Target | `dshTarget`: 0.2.0-rc.2（DeepSeek Harness 0.2 官方桌面 / `dsh web`） |

## 为什么有这个仓库

上游 GitHub 已不再提供 v1.1.71：`git/ref/tags/v1.1.71` 返回 404，可见的最早标签是 v1.1.73；npm registry 上 `dsh-purge/1.1.71`、`1.1.72`、`1.1.73`、`1.1.74`、`1.1.90` 均 404，只挂 `latest = 1.2.1`。本仓库用于留存这一版的完整源码，便于审计、对照与按 0.2.0-rc.2 复现。

## 与原版的差异

不含任何功能改动：

1. 新增本文件 `NOTICE.md` 与 `PUBLISH.md`；
2. 在本文件与两份 README 顶部加了来源说明段落；
3. 移除了 `.github/workflows/release.yml`。该工作流的发布条件是 `if: github.repository == 'YuJunZhiXue/dsh-purge'`，在本存档仓库上永远不会触发；而且 GitHub 会拒绝用未带 `workflow` scope 的令牌推送包含工作流的提交，保留它会让仓库无法用只含 `repo` 权限的令牌更新。工作流原文仍可在上游仓库查到。

代码、补丁表、`package.json`、`LICENSE`、`skills/`、`docs/` 与 tgz 内原件逐字节一致。

## 已知未包含的修复

原机在 2026-10-29 手工修过 `lib/net-scope.js` 里 `parkDenial` 的守卫（`maxLoggedStep` / `hasOpenStep`），起因是 region gate 在 `agent/pre-step` 钩子里写 `step/start` + 假拒答 + `step/end`，与宿主即将使用的 step 号相撞，导致同一轮出现两个 `step 1`、`session.v4.jsonl.zstd` 校验失败、会话历史无法加载。

**该修复不在本仓库**——tgz 打包于 2026-10-11，早于那次修复，所以这里是修复前的干净 1.1.71。原机上的修复后文件为 `lib/net-scope.js`（26,527 B），修复前备份为 `lib/net-scope.js.bak-stepfix-20261029-212500`（24,945 B），均未随包分发。

## 使用须知

上游 README 的约束沿用：非盈利、不得商业售卖或黑灰产牟利；借用名称、思路、代码或提示词**必须署名并标明来源仓库**（即本文件表格第一行的上游地址）。许可证为 MIT，按现状提供，无任何担保。
