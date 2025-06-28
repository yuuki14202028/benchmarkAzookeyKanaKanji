# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.
常に日本語で返答してください。

## Project Overview

This is a Swift Package Manager project that implements a Japanese Kana-Kanji conversion testing tool using AzooKeyKanaKanjiConverter. The project tests the conversion accuracy of Japanese text using a neural conversion system called "Zenzai" with a GGUF model file.

## Architecture

- **Sources/azookeyKanaKanji/main.swift**: Main executable that implements conversion testing logic
- **Package.swift**: Swift Package Manager configuration with dependency on AzooKeyKanaKanjiConverter
- **dict/corpus.1.txt**: Test corpus data file with format `|reading|actual|conversion|`
- **zenz.gguf**: Neural model file for Zenzai-powered conversion (72MB)
- **userDict/**: User dictionary directory for personalized learning
- **sharedContainer/**: Shared container for conversion state
- **llama.cpp/**: Embedded llama.cpp library for neural inference

The main conversion flow:
1. Loads test data from corpus.1.txt
2. Creates a KanaKanjiConverter instance with Zenzai neural mode enabled
3. For each test case, inserts reading text into ComposingText
4. Requests conversion candidates and compares with expected results
5. Outputs color-coded results (green=exact match, yellow=in candidates, red=missed)

## Commands

### Build and Run
```bash
swift build
swift run
```

### Build for Release
```bash
swift build -c release
```

### Run Tests
```bash
swift test
```

## Dependencies

- **AzooKeyKanaKanjiConverter**: Core kana-kanji conversion engine
- **KanaKanjiConverterModuleWithDefaultDictionary**: Module with built-in Japanese dictionary
- The project uses Swift 6.1+ with C++ interoperability enabled

## Key Configuration

The converter is configured with:
- N_best: 50 candidates
- Zenzai neural mode enabled with 10 inference limit
- Japanese prediction enabled
- Learning disabled for testing consistency
- NFKC normalization for consistent text comparison