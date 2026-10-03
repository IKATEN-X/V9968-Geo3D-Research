# 素材と公開前の確認事項

この文書は既存の素材説明から確認できた出典を記録したものです。ROM全体に一括の利用許諾を与えるものではありません。

## 街並みデモの動画看板

対象: `geo3d-city/GEO3D_CITY.ROM`、`geo3d-city-sc8/GEO3D_CITY_SC8.ROM`。

作品: Caminandes: Llamigos — Blender Foundation / Blender Institute。

原作品: https://studio.blender.org/projects/caminandes-3/

元素材の説明に記録されているライセンス: Creative Commons Attribution 3.0 (CC BY 3.0)。https://creativecommons.org/licenses/by/3.0/

加工: 元動画から4コマを抜き出して64×36へ縮小。SC5版は街並みの16色パレット、SC8版は固定GRB色へ量子化し、看板のテクスチャとして使用しています。動画本体や音声は同梱していません。

## 出典・配布条件の記録が不足しているもの

- `3d-flatpolygon/v9968-flat.rom`: ユーザー提供 `BG.jpg` が背景としてROM内に入っています。出典と配布条件はこの作業領域に記録されていません。
- `geo3d-dance/GEO_DANCE.ROM`: ユーザー提供のフリー素材動画から推論した骨格のモーションを使用しています。元動画そのものやCSVは同梱しませんが、元動画の具体的な出典と配布条件は未記録です。
- `geo3d-mesh-snake/GEO_SNAKE.ROM`: ユーザーが編集した `assets/snake.png` の絵をSCREEN 8用に変換して収録しています。原画の出典と再配布条件は未記録です。
- `paper-dance-2d/PAPER_DANCE.ROM`: ユーザー提供の人物PNGと骨格推論CSVから生成したテクスチャ・動作データを収録しています。元PNG・CSV自体は同梱しませんが、原画と推論元動画を含む素材の出典・再配布条件は未確認です。
- 各デモのソフトウェア全体: 開発フォルダに共通のLICENSE指定がないため、本フォルダでは独自にライセンスを選んでいません。

## 同梱していない依存物

エミュレーター本体、MSX BIOS／システムROM、NextorのカーネルとOS／DOSコマンド、動画再生用ディスク、元MP4、PCプレビュー用素材は同梱していません。

Geo RealityはFinal Realityを参考にした独自モデルと演出で、参照動画から抽出した画像・音声・モデルはROMへ入れていません。背景は生成画像、モデルやテクスチャは本デモ用に作成したものです。
