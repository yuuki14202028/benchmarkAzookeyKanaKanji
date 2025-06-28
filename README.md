# azookeyKanaKanji

AzooKeyKanaKanjiConverterとzenzモデルの日本語かな漢字変換テストツール

## 概要

このプロジェクトは、AzooKeyKanaKanjiConverterのかな漢字変換の精度をテストするためのSwiftプロジェクトです。

### 結果

| モデル                                                                                              | 設定                          | 候補内正解数 | 第一候補正解数 | 総データ数 | 候補内正解率 | 第一候補正解率 |
|--------------------------------------------------------------------------------------------------|-----------------------------|--------|---------|-------|--------|---------|
| AzooKeyKanaKanjiConverter, [zenz-v3-small](https://huggingface.co/Miwa-Keita/zenz-v3-small-gguf) | N_best=50, inferenceLimit=1 | 1351   | 1182    | 1745  | 77.4%  | 67.7%   |
| [Mozc辞書](https://github.com/google/mozc/tree/master/src/data/dictionary_oss)（単純な実装）                                                                                    | N_best=50                   | 1689   | 1107    | 1745  | 96.8%  | 63.4%   |

**表の説明:**
- **候補内正解数**: 変換候補のいずれかに正解が含まれる数
- **第一候補正解数**: 第一候補が正解である数  
- **候補内正解率**: 候補内正解数 ÷ 総データ数 × 100
- **第一候補正解率**: 第一候補正解数 ÷ 総データ数 × 100   

## 機能

- 日本語かな漢字変換のテスト実行
- zenzニューラルモデルによる高精度変換
- テストコーパスを使用した変換精度の評価
- カラーコード付き結果表示（緑=完全一致、黄=候補内、赤=未一致）

## アーキテクチャ

```
azookeyKanaKanji/
├── Sources/azookeyKanaKanji/main.swift  # メイン
├── Package.swift                        # Swift Package Manager設定
├── dict/corpus.1.txt                    # Anthyコーパス
├── zenz.gguf                            # Zenzai (ダウンロードしてください。)
├── userDict/                            # ユーザー辞書ディレクトリ
├── sharedContainer/                     # 変換状態の共有コンテナ
└── llama.cpp/                           # 組み込みllama.cppライブラリ (ダウンロードしてください。)
```

## 必要な環境

- Swift 6.1以上
- Windows

## 依存関係

- **AzooKeyKanaKanjiConverter**: AzooKeyかな漢字変換エンジン

## インストールと実行

適時、参照してください。  
[Windowsで動かすためのllama.cpp](https://github.com/fkunn1326/llama.cpp/releases/)  
[AzooKeyKanaKanjiConverterをWindowsで動かす](https://github.com/azooKey/AzooKeyKanaKanjiConverter/blob/develop/Docs/about_windows_support.md)  
[Anthyのコーパス](https://github.com/netsphere-labs/anthy/blob/master/corpus/corpus.1.txt)

### インストール

1. AzooKeyKanaKanjiConverterをWindowsで動かすを参照してください。
2. Windowsで動かすためのllama.cppをダウンロードしてください。
3. [zenz](https://huggingface.co/Miwa-Keita/zenz-v3-small-gguf)をダウンロードしてください。

### 実行

```bash
swift run
```

## 変換フロー

1. corpus.1.txtからテストデータを読み込み
2. Zenzaiニューラルモード有効でKanaKanjiConverterインスタンスを作成
3. 各テストケースに対して読みテキストをComposingTextに挿入
4. 変換候補を要求し期待結果と比較
5. カラーコード付きで結果を出力

## 設定

変換器は以下の設定で動作します：

- N_best: 50候補
- Zenzaiニューラルモード有効（推論制限1）
- 日本語予測有効
- テスト一貫性のため学習無効
- 一貫したテキスト比較のためNFKC正規化

## 参考
ありがとうございます！

- [AzooKeyKanaKanjiConverter](https://github.com/azooKey/AzooKeyKanaKanjiConverter)
- [zenz](https://huggingface.co/Miwa-Keita/zenz-v3-small-gguf)
- [fkunn1326/azooKey-Windows](https://github.com/fkunn1326/azooKey-Windows)
