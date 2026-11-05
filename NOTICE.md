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

## 0.2.2 适配（2026-11-05）

发布后又做了一轮宿主适配，目标是 **DSH 0.2.2-rc.1**。改动全部集中在 `lib/core.js`，共 20 条补丁从 skipped 变成 applied（界面 52/67 → 62/67 组，按条数 52 → 72 / 82）。

| 补丁 | 为什么原来 skipped | 改法 |
|---|---|---|
| #67 AGENT_LOOP_MESSAGES_GUARD | 0.2.2 在 `turn()` 里多包一层 `try`，缩进 4→5 tab | pattern/replace 各加一个 `\t` |
| #74 ASSEMBLE_BEFORE_PRESTEP | `assemble(...)` 单行调用变多行对象 | 锚点改到 `inbox.claim` 那一行 |
| #60 OFFICIAL_RUN_CODE_APPROVAL_NEUTRAL | 包名 `dsh-tools-ptc` → `dsh-tool-executor-ptc` | 别名映射加新路径 |
| #62 OFFICIAL_TOOL_ASK_FAILOPEN | 代码在 `dsh-tools/lib/types/pipeline.js`，且 `if` 块化、改单引号 | 映射加 pipeline.js；pattern 改块形式 |
| #14 ESCALATION_GRANT_UNCONDITIONAL | 新增 `displayReason: escalationDisplayReason(...)` 字段 | pattern/replace 补该行 |
| #77 REWIND_DROP_SENT_ON_APPEND | `this.revised.clear()` 变成 `if (this.revised.size > 0) ...` | 同步改 pattern/replace |
| #53 WEB_SURFACE_PROHIBITION | 文案重写为 `whose URL the runtime context names` | 改 pattern + markers |
| #32 WEB_SURFACE_IDENTITY_NEUTRAL | 同上；且源里写 `DeepSeek-Harness`（连字符），宿主是 `DeepSeek Harness`（空格） | 改 pattern；删掉已不存在的第二段 |
| #54 DELIVERABLE_DO_NOT | 包从 `dsh-client-ui-deliverables` 迁到 `dsh-deliverable-file-references` | 映射加新包 |
| #82 DESKTOP_SHELL_PROFILE_FALLBACK | 锚定的 import 整段消失 | 改锚到 `import "node:timers/promises";` |

剩下 4 条（#76 / #80 / #40 / #17）在 0.2.2 上属于**设计上不适用**，不是失败：
#76 的 pattern 是官方英文身份句，用户预设已改成中文；#80 是撤销型补丁，没有可撤销的东西；#40 是 0.1.5 遗留；#17 实际已生效，只是状态判定路径不同。

用法：把本仓库的 `lib/core.js` 覆盖到 `node_modules/dsh-purge/lib/core.js`（或直接覆盖 `plugins/dsh-purge-1.1.71/lib/core.js` 后重装），再跑 `dsh-purge --apply`。
