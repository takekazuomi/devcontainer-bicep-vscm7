---
marp: true
theme: gaia
_class: lead
paginate: true
backgroundColor: #fff
header: 'VS Code Meetup #7'
footer: 'Takekazu Omi @Baleen.Studio'
headingDivider: 1
inlineSVG: true
style: |
    section.right * , h6{
        text-align: right;
        overflow-wrap: normal;
    }
---
<style>
@import url('https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@700&display=swap');
section {
    font-family: 'Noto Sans JP', sans-serif;
}
</style>

# bicep :muscle: dev contaner
<!-- _class: right -->

![bg right:30%](https://live.staticflickr.com/65535/49121168526_80689c0490_b.jpg)

[VS Code Meetup #7](https://vscode.connpass.com/event/191614/)

###### by Takekazu Omi(*@Baleen.Studio*)

###### 2020/11/04 v1.0.1

![](./media/1x1.png)
![left w:300px](https://www.baleen.studio/img/company/img-symbol.png)

# 自己紹介

近江 武一 [@takekazuomi](https://twitter.com/takekazuomi)

- 会社作りました [baleen.studio](https://baleen.studio)
- [GitHub](https://github.com/takekazuomi)
  - Azure Quickstart template の elastic poolのBUG修正[PR](https://github.com/Azure/azure-quickstart-templates/pull/8440)
  - Azurite で、Table APIサポートを作り始めたので[PR](https://github.com/Azure/Azurite/pull/522)
- Blog [kyrt.in](https://kyrt.in)
  - [bicep 用 dev contaner](https://kyrt.in/2020/10/27/bicep_devcontaner.html) :point_left: 今日の話はこれ
  - [bicep moduleを使う](https://kyrt.in/2020/10/18/bicep_module.html)

# **はじめに**

ローカル、クラウド、プロダクションなど全方面で [docker](https://www.docker.com/) が便利。コンテナの活用で開発全体のライフサイクルを素早く回せるように :smile:

[VSCode Dev Container](https://code.visualstudio.com/docs/remote/containers)はローカル開発でのコンテナ活用例

- bicep (:muscle:) の紹介（新しい開発環境例として）
- Dev Container 自体は3分程度で作れる

※ローカル環境の魔窟化が避けられて嬉しい

# **bicep :muscle: の紹介**

今日の影の主役 [bicep](https://github.com/Azure/bicep), [v0.1.226-alpha](https://github.com/Azure/bicep/releases/tag/v0.1.226-alpha)

- Azure ARM Template のDSL、現在開発初期のα版
- json 直は辛い。DSLとLanguage Serverでサポートというのが基本アイデア
- ARM Template - bicep 間は薄いラッパーで相互手書きも容易
- コンパイラ（Transpilers）が、シングルバイナリー(.NET Core製)で、クロスププラットフォーム

# **bicep :muscle:の** :+1: :-1:

- :+1:
  - ARM Template直よりは100倍楽に書ける
  - 薄いラッパーなので、トラブルシューティングが楽
- :-1:
  - 未実装機能がある、copy,condition  [Known limitations](https://github.com/Azure/bicep#known-limitations)
  - ↑ 0.3 (ETA 12/15) ではサポートされる予定

ARM template のライティングツールの位置付けなら今からでも :smile:

# オレオレdev contaner

テンプレートから素材を選んで混ぜると概ねできる

1. 素材選択
2. 混ぜる
3. 完成 :smile:

[完成品 Bicep dev container](https://github.com/takekazuomi/devcontainer-bicep)

# 1. 素材(1)

- 大枠のテンプレート
  - [Development Container](https://github.com/microsoft/vscode-dev-containers/tree/v0.146.0/container-templates) のテンプレートからコピー
  - [dockerfile](https://github.com/microsoft/vscode-dev-containers/tree/v0.146.0/container-templates/dockerfile)単体と[docker-compose](https://github.com/microsoft/vscode-dev-containers/tree/v0.146.0/container-templates/docker-compose)に別で興味深い
- ベースとなるイメージを選ぶ
  - debian 用のlibrary-scriptsが揃っているのでdebianがお勧め
  - `mcr.microsoft.com/vscode/devcontainers/base:buster` を選択。Dockerfile は、[ここ](https://github.com/microsoft/vscode-dev-containers/tree/v0.146.0/containers/debian/.devcontainer)、修正後の[base.Dockerfile](https://github.com/takekazuomi/devcontainer-bicep/blob/main/.devcontainer/base.Dockerfile)

# 1. 素材(2)

- 一緒に使うツールのインストールスクリプトをコピー
  - `azcli`, `pwsh` を[vscode-dev-containers](https://github.com/microsoft/vscode-dev-containers/tree/v0.146.0/script-library)から、[library-scripts](https://github.com/takekazuomi/devcontainer-bicep/tree/main/.devcontainer/library-scripts) へコピー
- bicep 用インストールスクリプトの作成
  - [bicep-debian.sh](https://github.com/takekazuomi/devcontainer-bicep/blob/main/.devcontainer/library-scripts/bicep-debian.sh)

# 2. 混ぜる

- ベースとなる[Dockerfile](https://github.com/takekazuomi/devcontainer-bicep/blob/main/.devcontainer/base.Dockerfile)を作る
  - `RUN ... && ...` で実行するスクリプトを並べる
- place holderの[Dockerfile](https://github.com/takekazuomi/devcontainer-bicep/blob/main/.devcontainer/Dockerfile)を作る
  - 中身は`FROM`のみに近い
- [devcotainer.json](https://github.com/takekazuomi/devcontainer-bicep/blob/main/.devcontainer/devcontainer.json)を作る
  - `extensions` の内容は好みで適当に

[完成品 Bicep dev container](https://github.com/takekazuomi/devcontainer-bicep)

# 3. 完成

1. [このレポジトリ](https://github.com/takekazuomi/devcontainer-bicep/tree/v0.0.4)を clone する
2. `devcontainer-bicep/.devcontainer` の内容を自分のプロジェクトのルートにコピーする
3. VS Code でプロジェクトのルートを開く
4. **Remote-Containers: Reopen Folder in Container** で開き直す

※ 参考：[Dev Container の使い方](https://code.visualstudio.com/docs/remote/containers#_getting-started)

# まとめ

- dev container は、開発環境、ツール毎にスクリプトがブロック的に用意されている
- 組み合わせで好みのものが作れる。例えば、python + .NET Core開発とか、golang + az cli 開発とかも可
- ただ、ほとんどは debian/ubuntu 前提なので注意
- 中身は、shell script、真似して独自のものを作るのも容易
- 繰り返すけど、bicep :muscle: は便利

# 参考

- Dev Container 向けの [script-library](https://github.com/microsoft/vscode-dev-containers/blob/v0.146.0/script-library/README.md)。debian が多い。
- `az cli` が python製で多くのpyplを使っているようなコードの場合は、alpine のメリットがあまり無いのかなと思う。[Using Alpine can make Python Docker builds 50× slower](https://pythonspeed.com/articles/alpine-docker-python/)
- 今回のスライドは、[Marp]((https://github.com/marp-team/marp-cli#docker))を使いました。ありがとうございます。
- 今回のコンテンツ、[devcontainer-bicep-vscm7](https://github.com/takekazuomi/devcontainer-bicep-vscm7)
  - [https://www.slideshare.net/takekazuomi/bicep-dev-container](https://www.slideshare.net/takekazuomi/bicep-dev-container)

# 終

![bg auto](https://live.staticflickr.com/819/40713808344_00d29bb98c_h.jpg)
