#!/bin/bash
# ================================================================
# COBOL道場 → GitHub (Bluebird4320/Cobol) デプロイスクリプト
# 実行場所: このファイルと同じディレクトリ（cobol-dojo/）
# 事前準備: gh auth login 済み
# ================================================================

set -e

GITHUB_USER="Bluebird4320"
REPO_NAME="Cobol"
REMOTE_URL="https://github.com/${GITHUB_USER}/${REPO_NAME}.git"

echo "=========================================="
echo "🚀 COBOL道場 → GitHub デプロイ開始"
echo "リポジトリ: ${REMOTE_URL}"
echo "=========================================="

# ── 1. git 初期化（未初期化の場合のみ） ──────────────────────
if [ ! -d ".git" ]; then
  echo "📁 git init..."
  git init
  git branch -M main
fi

# ── 2. リモートの設定 ─────────────────────────────────────────
if git remote | grep -q "origin"; then
  echo "🔗 リモートURLを更新: ${REMOTE_URL}"
  git remote set-url origin "${REMOTE_URL}"
else
  echo "🔗 リモートを追加: ${REMOTE_URL}"
  git remote add origin "${REMOTE_URL}"
fi

# ── 3. .gitignore を作成 ──────────────────────────────────────
cat > .gitignore << 'GITIGNORE'
.DS_Store
*.swp
*.bak
node_modules/
GITIGNORE
echo "📝 .gitignore を作成しました"

# ── 4. 全ファイルをステージング ───────────────────────────────
git add .

# 変更があるかチェック
if git diff --cached --quiet; then
  echo "ℹ️  変更なし（最新の状態です）"
else
  TIMESTAMP=$(date '+%Y-%m-%d %H:%M')
  git commit -m "🎓 COBOL道場 更新 ${TIMESTAMP}"
  echo "✅ コミット完了"
fi

# ── 5. プッシュ ───────────────────────────────────────────────
echo "⬆️  プッシュ中..."
git push -u origin main
echo "✅ プッシュ完了"

# ── 6. GitHub Pages 有効化（初回のみ） ───────────────────────
echo ""
echo "🌐 GitHub Pages を有効化..."
gh api \
  --method POST \
  -H "Accept: application/vnd.github+json" \
  "/repos/${GITHUB_USER}/${REPO_NAME}/pages" \
  -f build_type=legacy \
  -f source='{"branch":"main","path":"/"}' \
  2>/dev/null && echo "✅ GitHub Pages 有効化完了" \
  || echo "ℹ️  GitHub Pages は既に設定済みです（スキップ）"

echo ""
echo "=========================================="
echo "🎉 デプロイ完了！"
echo ""
echo "リポジトリ : https://github.com/${GITHUB_USER}/${REPO_NAME}"
echo "公開URL    : https://${GITHUB_USER}.github.io/${REPO_NAME}/"
echo ""
echo "※ GitHub Pages の反映まで数分かかります"
echo "=========================================="
