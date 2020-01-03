# 色設定が使えるようにする
autoload -Uz colors && colors

# もしかして機能
setopt correct

# カレントディレクトリが変更された場合のhook関数
function chpwd() {
  ls -lFGa # このlsは MacOS の ls
}

# PROMPT変数内で変数参照を可能にする
setopt prompt_subst

# コマンド失敗時に色変え表示する
# %(?.xxx.yyy)という形式で記述
status_prompt () {
  local color
  color="%(?.${fg[green]}.${fg[red]})"
  echo "${color}❯${reset_color}"
}

# もしかしての表示
suggest_view () {
  local color yes no abort edit message

  color="${fg[magenta]}"

  yes="${fg[green]}Yes(y)${reset_color}"
  no="${fg[magenta]}No(n)${reset_color}"
  abort="${fg[red]}Stop(a)${reset_color}"
  edit="${fg[cyan]}Edit(e)${reset_color}"

  message="${color} ❯ %B%r？%b${reset_color} [${yes}, ${no}, ${abort}, ${edit}] "

  echo "${suggest}${message}"
}

# ブランチ名を色付きで表示させるメソッド
function git_current_branch {
  local branch_name st branch_status

  if [ ! -e  ".git" ]; then
    # gitで管理されていないディレクトリは何も返さない
    return
  fi
  branch_name=`git rev-parse --abbrev-ref HEAD 2> /dev/null`
  st=`git status 2> /dev/null`
  if [[ -n `echo "$st" | grep "^nothing to"` ]]; then
    # 全てcommitされてクリーンな状態
    branch_status="%F{green}$branch_name ❯%f"
  elif [[ -n `echo "$st" | grep "^Untracked files"` ]]; then
    # gitに管理されていないファイルがある状態
    branch_status="%F{red}$branch_name? ❯%f"
  elif [[ -n `echo "$st" | grep "^Changes not staged for commit"` ]]; then
    # git addされていないファイルがある状態
    branch_status="%F{red}$branch_name* ❯%f"
  elif [[ -n `echo "$st" | grep "^Changes to be committed"` ]]; then
    # git commitされていないファイルがある状態
    branch_status="%F{yellow}$branch_name! ❯%f"
  elif [[ -n `echo "$st" | grep "^rebase in progress"` ]]; then
    # コンフリクトが起こった状態
    echo "%F{red}$branch_name! (no branch) ❯%f"
    return
  else
    # 上記以外の状態の場合は青色で表示させる
    branch_status="%F{blue}"
  fi
  # ブランチ名を色付きで表示する
  echo "${branch_status}"
}

# プロンプト
PROMPT='
 %F{yellow}%~%f
 `git_current_branch``status_prompt` '

# もしかして時のプロンプト指定
SPROMPT='`suggest_view`'

# nodebreのパス
export PATH=$HOME/.nodebrew/current/bin:$PATH

# 履歴ファイルの保存先
export HISTFILE=${HOME}/.zsh_history

# メモリに保存される履歴の件数
export HISTSIZE=1000

# 履歴ファイルに保存される履歴の件数
export SAVEHIST=100000

# 重複を記録しない
setopt hist_ignore_dups

# 開始と終了を記録
setopt EXTENDED_HISTORY

# ファイル名の展開でディレクトリにマッチした場合 末尾に / を付加
setopt mark_dirs
