# V9968 + Geo3D Research

R800＋V9968／Geo3Dの表現と性能を探るデモの、実行用ROMだけをまとめた配布用スナップショットです。2026-10-03時点の12本を収録しています。Geo RealityはFOV切り替え対応版、Geo3Dダンスは床と背景を追加した版です。

**収録した12本はすべて内蔵V9968（VDPポート98h～9Ch）構成を基準とした配布版です。** 外付けVDP専用版は収録していません。ROMに外付けVDPの検出処理がある場合も、このパッケージの動作確認・起動手順は内蔵VDPを対象とします。

このフォルダ全体をコピーすれば、元の開発フォルダを参照せずに使用できます。モデル、テクスチャ、骨格の姿勢データなど、ROMデモに必要なデータは各ROMに収録済みです。Node.js、アセンブラ、ソース、元動画、CSVは起動に不要です。

エミュレーター本体、MSX BIOS／システムROM、マシンデータは含みません。別途、下記の対応エミュレーターを用意してください。

## 収録内容

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

`v9968-streaming` は動画再生ROMではありません。単独起動すると裏ページへ転送するため基本的に画面は空で、数値結果も表示しません。測定には開発版の計測ハーネスが必要です。この配布にはROMの保存用として収録しています。

メタボール試作は配布対象外です。動画プレイヤーのCOM、変換済み動画、Nextorディスクは現段階では含めていません。PC用骨格プレビュー、旧デバッグ／比較ROM、テスト、スクリーンショット、個人設定も除外しています。

## 起動

PowerShellでこのフォルダを開き、一覧と操作方法を確認できます。

```powershell
.\run.ps1 -List
(Get-Content .\demos.json -Raw -Encoding UTF8 | ConvertFrom-Json).demos |
    Select-Object id,controls
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

エミュレーターの場所はご自身の配置先へ変更してください。実行前にROMの容量とSHA-256を検査します。`-DryRun` を付けると引数・パスの確認だけを行い、起動、設定ファイル作成、環境変数の変更をしません。ランチャーにビルドやダウンロード処理はありません。

openMSXの既定機種は内蔵VDPの `Panasonic_FS-A1ST(V9968)` です。エミュレーターの隣に対応する `share` ディレクトリが必要です。ランチャーには外付けVDPを試す `-External` オプションもありますが、この配布版の動作確認対象外です。外付け用の定義と映像切替用Tclは `emulator` に同梱しています。

Geo3Dは `MSXturboR - Panasonic FS-A1ST(V9968)` を使用します。エミュレーターの隣に `Machines` ディレクトリが必要です。通常のblueMSXやopenMSXではGeo3Dは動きません。街SC8／メガデモ／各ダンス／蛇はASCII16を指定し、立方体／街SC5は従来どおり自動検出にします。Geo3Dダンスは4MiB・256バンク、2Dダンスは2MiB・128バンク対応が必要です。

Geo3Dの外付け88h構成は、このエミュレーター環境では未検証・未対応なのでランチャーの `-External` では起動しません。実機の速度と動作も保証するものではありません。R800を基本対象とし、Z80互換性は保証しません。

起動後に作られる設定、クイックセーブ等はこのフォルダの `.local` に保存し、Git対象外にしています。開発版やエミュレーター本体の設定は書き換えません。

## 公開時の注意

このフォルダにはGitリポジトリと `LICENSE` が設定されています。外部素材には、リポジトリの設定とは別に素材ごとの利用条件が適用されます。

街並み看板とダンスの動きの元データは [NOTICE.md](NOTICE.md) に記録しています。両ダンスで使う骨格データの推論元は[動画ACの動画6876](https://video-ac.com/video/6876)で、動画ACはクレジット表記不要と案内しています。ただし利用規約上の組込み・頒布条件は別の確認事項です。`.local` やエミュレーター／BIOS／OSを追加して公開しないでください。

各ROMは元の正式な起動スクリプトが選ぶ生成物をそのままコピーしてあり、`demos.json` に容量とSHA-256を記録しています。今後ROMを差し替える場合は、対応する記録も更新してください。
