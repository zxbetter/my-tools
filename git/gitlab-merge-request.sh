#!/bin/bash
#version: v1.0.0
#author: zxbetter
#license: MIT
#contact: zhangxinbetter@gmail.com
#site: https://zxbetter.github.io
#time: 2020-08-29 14:35:55
# -----------------------------------------------------------------------------
# 提交Gitlab合并请求
# ------------------------------------------------------------------------------

set -eo pipefail

if [ "X$0" = "X" ]; then
    shift
fi

SCRIPTPATH=$(cd $(dirname "$0"); pwd)

# 根路径
export APP_HOME="${SCRIPTPATH%/my-tools/*}/my-tools"
# 引入git通用模块
. "${APP_HOME}/utils/git.sh"

# 定义变量
# 当前分支
CURRENT_BRANCH=$(git_current_branch)
# 远程仓库地址
REMOTE_URL=$(git_remote_url)
# 合并请求的源分支，默认是当前分支
SOURCE_BRANCH="${CURRENT_BRANCH}"
# 合并请求的目标地址
TARGET_BRANCH=""

# 定义函数
# 帮助函数
helpu() {
cat << EOF

usage: $0 <option>

提交Gitlab合并请求。

OPTIONS:
  [--remote-url    | -R] 远程仓库地址
  [--source-branch | -S] 合并请求的源分支
  [--target-branch | -T] 合并请求的目标地址
  [--help          | -H] 帮助
EOF

exit
}

# 解析参数
while [ True ]; do
if [ "$1" = "--help" -o "$1" = "-H" ]; then
    helpu
elif [ "$1" = "--remote-url" -o "$1" = "-R" ]; then
    REMOTE_URL="${2}"
    shift 2
elif [ "$1" = "--source-branch" -o "$1" = "-S" ]; then
    SOURCE_BRANCH="${2}"
    shift 2
elif [ "$1" = "--target-branch" -o "$1" = "-T" ]; then
    TARGET_BRANCH="${2}"
    shift 2
else
    break
fi
done

if [ "X${REMOTE_URL}" = "X" -o "X${SOURCE_BRANCH}" = "X" -o "X${TARGET_BRANCH}" = "X" ]; then
    helpu
fi

# 执行逻辑

notice_msg "提交Gitlab合并请求"
echo "    当前分支: ${CURRENT_BRANCH}"
echo "    远程仓库地址: ${REMOTE_URL}"
echo "    源分支: ${SOURCE_BRANCH}"
echo "    目标分支: ${TARGET_BRANCH}"

echo " "
MERGE_URL="${REMOTE_URL%.git*}/-/merge_requests/new?merge_request%5Bsource_branch%5D=${SOURCE_BRANCH}&merge_request%5Btarget_branch%5D=${TARGET_BRANCH}"
echo "创建合并请求：${MERGE_URL}"
open_url "${MERGE_URL}"

notice_msg "完成!"
