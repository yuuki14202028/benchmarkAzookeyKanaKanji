import KanaKanjiConverterModuleWithDefaultDictionary
import Foundation // ファイル読み込みや正規化に必要

let green = "\u{001B}[32m"
let yellow = "\u{001B}[33m"
let red = "\u{001B}[31m"
let end = "\u{001B}[0m"
// 色付けなしの場合は空文字列にする

// Scalaの test 関数に相当するSwiftの関数
@MainActor
func testKanaKanjiConversion(converter: KanaKanjiConverter, options: ConvertRequestOptions) {

    let filePath = "dict/corpus.1.txt" // ファイルパスを確認してください
    var data: [(read: String, actual: String)] = []

    print("ファイルを読み込みます: \(filePath)")
    
    do {
        let fileContent = try String(contentsOfFile: filePath, encoding: .utf8)
        let lines = fileContent.components(separatedBy: .newlines)
        print("ファイルから\(lines.count)行を読み込みました")

        data = lines.compactMap { line in
            // "| |" で分割する
            let components = line.components(separatedBy: "| |")
            if components.count == 2 {
                // "|" を除去する
                let read = components[0].filter { $0 != "|" }
                let surface = components[1].filter { $0 != "|" }
                // 空文字列でなければタプルを返す
                if !read.isEmpty && !surface.isEmpty {
                    return (read: read, actual: surface)
                }
            }
            return nil // 条件に合わない行は無視
        }
    } catch {
        print("ファイル読み込みエラー: \(error)")
        return // ファイルが読めなければ処理を中断
    }

    print("有効なデータ: \(data.count)件")
    
    guard !data.isEmpty else {
        print("ファイルからデータが読み込めませんでした。")
        return
    }

    var acCount = 0
    var okCount = 0
    var okCounts = Array(repeating: 0, count: 50)

    for item in data {
        let read = item.read
        let actualRaw = item.actual

        // --- kanaKanji (converter) を使った変換処理 ---
        var composingText = ComposingText()
        // Scala版の挙動に基づき、読み全体を一度に挿入
        composingText.insertAtCursorPosition(read, inputStyle: .direct) // .direct もライブラリ定義のenum値を想定

        // requestCandidates を呼び出し (ConversionResults, Candidate もライブラリ定義の型を想定)
        let results = converter.requestCandidates(composingText, options: options)

        // 候補リストを取得し、正規化と文字置換を行う
        // (results.mainResults が [Candidate] 型で、Candidate が .text プロパティを持つと想定)
        let candidateStrings = results.mainResults.map { candidate -> String in
            let normalized = candidate.text.precomposedStringWithCompatibilityMapping // NFKC正規化
            return normalized.replacingOccurrences(of: "、", with: ",").replacingOccurrences(of: "。", with: ".")
        }
        // --- 変換処理ここまで ---

        // 比較のために正解文字列も同様に正規化・置換
        let actualNormalized = actualRaw.precomposedStringWithCompatibilityMapping // NFKC正規化
        let actual = actualNormalized.replacingOccurrences(of: "、", with: ",").replacingOccurrences(of: "。", with: ".")

        // 最初の候補を取得
        let firstResult = candidateStrings.first ?? ""

        if firstResult == actual {
            print("\(green)actual: \(actual), result: \(firstResult), read: \(read)\(end)")
            acCount += 1
            okCount += 1
        } else if candidateStrings.contains(actual) {
            if let index = candidateStrings.firstIndex(of: actual) {
                okCounts[index] += 1
            }
            // 候補リストに正解が含まれているかチェック
            print("\(yellow)actual: \(actual), result: \(firstResult), read: \(read)\(end)")
            okCount += 1
        } else {
            print("\(red)actual: \(actual), result: \(firstResult), read: \(read)\(end)")
        }
    }

    print(okCounts)
    print("\(okCount)(\(acCount))/\(data.count)")
}

print("プログラムを開始します...")

let converter = KanaKanjiConverter()
print("KanaKanjiConverterを初期化しました")

let userDictURL = URL(string: "userDict")!
let sharedContainerURL = URL(string: "sharedContainer")!
let zenz = URL(string: "zenz.gguf")!

print("URLを設定しました:")
print("  userDict: \(userDictURL)")
print("  sharedContainer: \(sharedContainerURL)")
print("  zenz: \(zenz)")

let options = ConvertRequestOptions.withDefaultDictionary(
    N_best: 50,
    requireJapanesePrediction: false,
    requireEnglishPrediction: false,
    keyboardLanguage: .ja_JP,
    learningType: .nothing,
    memoryDirectoryURL: userDictURL,
    sharedContainerURL: sharedContainerURL,
    zenzaiMode:  .on(
            weight: zenz,
            inferenceLimit: 1,
            requestRichCandidates: true,
            personalizationMode: nil,
            versionDependentMode: .v3(
                .init(
                    leftSideContext: ""
                )
            )
        ),
    metadata: .init(versionString: "You App Version X")
)

print("変換オプションを設定しました")
print("テストを開始します...")

testKanaKanjiConversion(converter: converter, options: options)

while(true) {
    let input = readLine() ?? "";
     // --- kanaKanji (converter) を使った変換処理 ---
    var composingText = ComposingText()
    // Scala版の挙動に基づき、読み全体を一度に挿入
    composingText.insertAtCursorPosition(input, inputStyle: .direct) // .direct もライブラリ定義のenum値を想定

    let results = converter.requestCandidates(composingText, options: options)

    let candidateStrings = results.mainResults.map { candidate -> String in
        let normalized = candidate.text.precomposedStringWithCompatibilityMapping // NFKC正規化
        return normalized.replacingOccurrences(of: "、", with: ",").replacingOccurrences(of: "。", with: ".")
    }
    let firstResult = candidateStrings.first ?? ""
    print("\(input): \(firstResult)")
    candidateStrings.forEach { str in
        print(str)
    }
    

}