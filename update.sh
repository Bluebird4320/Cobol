#!/bin/bash
# ================================================================
# COBOL道場 更新デプロイ（2回目以降）
# 使い方: bash update.sh "コミットメッセージ"
# ================================================================

MSG="${1:-COBOL道場 更新 $(date '+%Y-%m-%d %H:%M')}"

echo "⬆️  GitHub へ更新デプロイ..."
git add .
git commit -m "🎓 ${MSG}" || echo "変更なし"
git push origin main
echo "✅ 完了: https://github.com/Bluebird4320/Cobol"
