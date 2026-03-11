#!/bin/bash
# ================================================================
# COBOL道場 GitHub セットアップスクリプト
# 実行場所: /Users/yoshikawasho/Desktop/cobol-dojo/
# 事前準備: gh auth login 済み、または git認証済み
# ================================================================

set -e

REPO_NAME="cobol-dojo"
GITHUB_USER=$(gh api user --jq .login 2>/dev/null || echo "YOUR_USERNAME")

echo "=========================================="
echo "⚡ COBOL道場 GitHub セットアップ開始"
echo "=========================================="

# git初期化
git init
git add .
git commit -m "初回コミット: COBOL道場 v1.0.0"

# GitHubにリポジトリ作成＆プッシュ
gh repo create "$REPO_NAME" \
  --public \
  --description "⚡ COBOLエンジニア向け学習アプリ" \
  --source=. \
  --remote=origin \
  --push

# GitHub Pages を有効化
gh api \
  --method POST \
  -H "Accept: application/vnd.github+json" \
  "/repos/$GITHUB_USER/$REPO_NAME/pages" \
  -f build_type=legacy \
  -f source='{"branch":"main","path":"/"}' \
  2>/dev/null || echo "GitHub Pages設定: 手動でSettings > Pages > main branchを設定してください"

echo ""
echo "=========================================="
echo "✅ セットアップ完了！"
echo "リポジトリ: https://github.com/$GITHUB_USER/$REPO_NAME"
echo "公開URL: https://$GITHUB_USER.github.io/$REPO_NAME/"
echo "※ GitHub Pagesが反映されるまで数分かかります"
echo "=========================================="
