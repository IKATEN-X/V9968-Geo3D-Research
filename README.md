# V9968 + Geo3D Research

V9968／Geo3Dの表現と性能を探るデモの、実行用ROMをまとめた配布用スナップショットです。2026-10-04時点でR800版12本とZ80版7本、計19本を収録しています。Geo RealityはFOV切り替え対応版、Geo3Dダンスは床と背景を追加した版です。

**R800版12本は内蔵V9968（VDPポート98h～9Ch）構成を基準とした配布版です。** 追加したZ80版7本は、Geo3D対応openMSXの内蔵98h系と外付け88h系の両方で動作確認したROMです。外付け専用の別ROMではなく、起動時にポートを選びます。実機での速度・動作は未検証です。

このフォルダ全体をコピーすれば、元の開発フォルダを参照せずに使用できます。モデル、テクスチャ、骨格の姿勢データなど、ROMデモに必要なデータは各ROMに収録済みです。Node.js、アセンブラ、ソース、元動画、CSVは起動に不要です。

エミュレーター本体、MSX BIOS／システムROM、マシンデータは含みません。別途、下記の対応エミュレーターを用意してください。

## 収録内容

### R800版（12本）

| ID | 内容 | エミュレーター |
|---|---|---|
| `3d-wireframe` | 正二十面体6個・ワイヤーフレーム | V9968版openMSX |
| `3d-flatpolygon` | フラット描画・背景とのマスク透過 | V9968版openMSX |
| `3d-texturecube` | 操作できるテクスチャキューブ | V9968版openMSX |
| `palette-erode` | 円形の残像、減光、erosion | V9968版openMSX |
| `v9968-streaming` | RAM→VRAM転送ベンチの生ROM | V9968版openMSX |
| `geo3d-cube` | Geo3D立方体・ワイヤーフレーム | Geo3D対応blueMSX+ |
| `geo3d-city` | 街並み・SC5・4コマ看板 | Geo3D対応blueMSX+ |
| `geo3d-city-sc8` | 街並み・SC8・4コマ看板 | Geo3D対応blueMSX+ |
| `geo3d-final-reality` | Geo Realityメガデモ・4段階FOV切り替え | Geo3D対応blueMSX+ |
| `geo3d-dance` | 丹田固定のダンス・グリッド床と夜景 | Geo3D対応blueMSX+ |
| `geo3d-mesh-snake` | テクスチャ付き蛇のメッシュ変形・8の字移動 | Geo3D対応blueMSX+ |
| `paper-dance-2d` | 骨格データによる1枚絵の2Dダンス変形 | Geo3D対応blueMSX+ |

### Z80版（7本）

| ID | 内容 | エミュレーター |
|---|---|---|
| `geo3d-cube-z80` | 回転するGeo3D立方体・SCREEN 5 | Geo3D対応openMSX |
| `geo3d-city-z80` | 街並み・SCREEN 5・4コマ看板 | Geo3D対応openMSX |
| `geo3d-city-sc8-z80` | 街並み・SCREEN 8・4コマ看板 | Geo3D対応openMSX |
| `geo3d-final-reality-z80` | Geo Realityメガデモ | Geo3D対応openMSX |
| `geo3d-dance-z80` | 丹田固定の3Dダンス・床と夜景 | Geo3D対応openMSX |
| `geo3d-mesh-snake-z80` | テクスチャ付き蛇・8の字経路 | Geo3D対応openMSX |
| `paper-dance-2d-z80` | 骨格データによる1枚絵の2Dダンス変形 | Geo3D対応openMSX |

`v9968-streaming` は動画再生ROMではありません。単独起動すると裏ページへ転送するため基本的に画面は空で、数値結果も表示しません。測定には開発版の計測ハーネスが必要です。この配布にはROMの保存用として収録しています。

メタボール試作は配布対象外です。動画プレイヤーのCOM、変換済み動画、Nextorディスクは現段階では含めていません。PC用骨格プレビュー、旧デバッグ／比較ROM、テスト、スクリーンショット、個人設定も除外しています。

## 起動

PowerShellでこのフォルダを開き、一覧と操作方法を確認できます。

```powershell
.\run.ps1 -List
(Get-Content .\demos.json -Raw -Encoding UTF8 | ConvertFrom-Json).demos |
    Select-Object id,cpu,controls
```

Geo3D対応blueMSX+を指定して起動する例：

```powershell
.\run.ps1 -Demo geo3d-dance -Emulator 'D:\blueMSX+\blueMSX+.exe'
.\run.ps1 -Demo geo3d-final-reality -Emulator 'D:\blueMSX+\blueMSX+.exe'
.\run.ps1 -Demo geo3d-mesh-snake -Emulator 'D:\blueMSX+\blueMSX+.exe'
.\run.ps1 -Demo paper-dance-2d -Emulator 'D:\blueMSX+\blueMSX+.exe'
```

V9968版openMSXを指定して起動する例：

```powershell
.\run.ps1 -Demo 3d-wireframe -Emulator 'C:\openMSX-V9968\openmsx.exe'
.\run.ps1 -Demo palette-erode -Emulator 'C:\openMSX-V9968\openmsx.exe'
```

Z80版は**Geo3D対応版openMSX**で、Z80のMSX2/2+・V9968・Geo3Dを備えた機種を選んでROMを読み込めます。手動で読み込む場合、`geo3d-cube-z80`と`geo3d-city-z80`は通常ROM（`Normal`）、残る5本は`ASCII16`を指定してください。内蔵構成はGeo3D拡張`geo3d`、外付け構成は`HRA_V9968`と`geo3d88`を使用します。外付けでは映像ソースも`V9968`へ切り替えます。

Z80版用の起動補助も使用できます。`-CbiosDirectory`には、3個のC-BIOS MSX2 ROMがあるフォルダを指定します。検証後、このリポジトリのGit対象外`.local`へだけコピーします。C-BIOS ROM本体は配布していません。

```powershell
.\run.ps1 -Demo geo3d-cube-z80 -Emulator 'D:\openmsx-21.0\openmsx.exe' -CbiosDirectory 'D:\blueMSX+\Machines\MSX2 - C-BIOS'
.\run.ps1 -Demo paper-dance-2d-z80 -Emulator 'D:\openmsx-21.0\openmsx.exe' -CbiosDirectory 'D:\blueMSX+\Machines\MSX2 - C-BIOS' -External
```

エミュレーターの場所はご自身の配置先へ変更してください。実行前にROMの容量とSHA-256を検査します。`-DryRun` を付けると引数・パスの確認だけを行い、起動、設定ファイル作成、環境変数の変更をしません。ランチャーにビルドやダウンロード処理はありません。

R800版のopenMSXデモの既定機種は内蔵VDPの `Panasonic_FS-A1ST(V9968)` です。Z80版Geo3Dの既定機種は内蔵用`C-BIOS_MSX2_V9968`、`-External`では外付け用`C-BIOS_MSX2_Z80`です。エミュレーターの隣に対応する`share`ディレクトリが必要です。機種定義、外付けVDP定義、映像切替用Tclは`emulator`に同梱しています。

R800版Geo3DはGeo3D対応blueMSX+の`MSXturboR - Panasonic FS-A1ST(V9968)`を使用します。エミュレーターの隣に`Machines`ディレクトリが必要です。標準版のblueMSXやopenMSXではGeo3Dは動きません。R800版では街SC8／メガデモ／各ダンス／蛇はASCII16、立方体／街SC5は自動検出を使います。Z80版は上記のNormal／ASCII16指定に従ってください。

R800版Geo3Dの外付け88h構成は、この配布版では未検証・未対応です。Z80版7本は内蔵98h系と外付け88h系の両方をGeo3D対応openMSXで確認しました。ただし実機の速度・動作は保証しません。

起動後に作られる設定、クイックセーブ等はこのフォルダの `.local` に保存し、Git対象外にしています。開発版やエミュレーター本体の設定は書き換えません。

## 公開時の注意

このフォルダにはGitリポジトリと `LICENSE` が設定されています。外部素材には、リポジトリの設定とは別に素材ごとの利用条件が適用されます。

街並み看板とダンスの動きの元データは [NOTICE.md](NOTICE.md) に記録しています。両ダンスで使う骨格データの推論元は[動画ACの動画6876](https://video-ac.com/video/6876)で、動画ACはクレジット表記不要と案内しています。ただし利用規約上の組込み・頒布条件は別の確認事項です。`.local` やエミュレーター／BIOS／OSを追加して公開しないでください。

各ROMは元の正式な起動スクリプトが選ぶ生成物をそのままコピーしてあり、`demos.json` に容量とSHA-256を記録しています。今後ROMを差し替える場合は、対応する記録も更新してください。
