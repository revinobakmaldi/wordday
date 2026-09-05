import Foundation
import SwiftUI
import UIKit

struct TodayView: View {
    @EnvironmentObject private var learned: LearnedStore
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.colorScheme) private var colorScheme
    @State private var appeared = false

    private let today = Date()

    private var word: Word { WordLibrary.word(for: today) }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .topTrailing) {
                WordDayStyle.background.ignoresSafeArea()

                WordDayOrbit(diameter: 190, lineWidth: 24)
                    .offset(x: 102, y: -86)
                    .opacity(0.72)

                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        appHeader
                        editionHeader
                        WordCard(word: word)
                            .padding(.top, 28)
                        LearningGuideView(word: word)
                            .padding(.top, 28)
                        collectionProgress
                            .padding(.top, 28)
                        LearnedButton(word: word)
                            .padding(.top, 20)
                        LearnWithAIButton(word: word)
                            .padding(.top, 10)
                        tomorrowPreview
                            .padding(.top, 34)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 14)
                    .padding(.bottom, 38)
                    .opacity(appeared ? 1 : 0)
                    .offset(y: reduceMotion || appeared ? 0 : 16)
                }
                .scrollIndicators(.hidden)
            }
            .toolbar(.hidden, for: .navigationBar)
            .onAppear {
                guard !appeared else { return }
                if reduceMotion {
                    appeared = true
                } else {
                    withAnimation(.easeOut(duration: 0.55)) {
                        appeared = true
                    }
                }
            }
        }
    }

    private var appHeader: some View {
        HStack {
            Text("WORDDAY")
                .font(WordDayStyle.labelFont(size: 13))
                .tracking(2.5)
                .foregroundStyle(WordDayStyle.ink)

            Spacer()

            WordDayOrbit(diameter: 38, lineWidth: 3)
        }
        .frame(minHeight: 48)
    }

    private var editionHeader: some View {
        VStack(spacing: 10) {
            HStack {
                Label(
                    colorScheme == .dark ? "NIGHT EDITION" : "DAY EDITION",
                    systemImage: colorScheme == .dark ? "moonphase.waning.crescent" : "sun.max.fill"
                )
                Spacer()
                Text("PRACTICE · 10 SEC")
            }
            .font(WordDayStyle.labelFont(size: 10))
            .tracking(1.35)
            .foregroundStyle(WordDayStyle.accent)

            Rectangle()
                .fill(WordDayStyle.rule)
                .frame(height: 1)
        }
        .padding(.top, 13)
        .accessibilityElement(children: .combine)
    }

    private var collectionProgress: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .firstTextBaseline) {
                Text("SAVED")
                    .tracking(1.25)
                Spacer()
                Text("\(learned.learned.count) / \(WordLibrary.all.count)")
                    .monospacedDigit()
            }
            .font(WordDayStyle.labelFont(size: 9))
            .foregroundStyle(WordDayStyle.mutedInk)

            GeometryReader { proxy in
                ZStack(alignment: .leading) {
                    Rectangle().fill(WordDayStyle.rule)
                    Rectangle()
                        .fill(WordDayStyle.accent)
                        .frame(width: proxy.size.width * learnedProgress)
                }
            }
            .frame(height: 3)
            .accessibilityHidden(true)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(learned.learned.count) of \(WordLibrary.all.count) chunks saved")
    }

    private var learnedProgress: CGFloat {
        guard !WordLibrary.all.isEmpty else { return 0 }
        return min(CGFloat(learned.learned.count) / CGFloat(WordLibrary.all.count), 1)
    }

    private var tomorrowPreview: some View {
        HStack(alignment: .center, spacing: 14) {
            VStack(alignment: .leading, spacing: 5) {
                Text("TOMORROW")
                    .font(WordDayStyle.labelFont(size: 9))
                    .tracking(1.2)
                    .foregroundStyle(WordDayStyle.accent)

                Text("A fresh chunk lands at midnight.")
                    .font(WordDayStyle.bodyFont(size: 14))
                    .foregroundStyle(WordDayStyle.mutedInk)
            }

            Spacer()

            Image(systemName: "lock.fill")
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(WordDayStyle.mutedInk)
                .frame(width: 44, height: 44)
                .background(WordDayStyle.surface, in: Circle())
                .accessibilityHidden(true)
        }
        .padding(.top, 18)
        .overlay(alignment: .top) {
            Rectangle().fill(WordDayStyle.rule).frame(height: 1)
        }
        .accessibilityElement(children: .combine)
    }
}

/// The core reading surface used by Today and phrase detail screens.
struct WordCard: View {
    let word: Word
    var trailingLabel: String? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("CHUNK · \(wordNumber)")
                Spacer()
                Text(trailingLabel ?? Date().formatted(.dateTime.month(.twoDigits).day(.twoDigits)))
                    .monospacedDigit()
            }
            .font(WordDayStyle.labelFont(size: 9))
            .tracking(1.3)
            .foregroundStyle(WordDayStyle.mutedInk)

            Text(word.phrase)
                .font(WordDayStyle.displayFont(size: 44))
                .fontWeight(.semibold)
                .minimumScaleFactor(0.64)
                .lineLimit(3)
                .foregroundStyle(WordDayStyle.ink)
                .padding(.top, 13)
                .accessibilityAddTraits(.isHeader)
                .accessibilityLabel(word.phrase)

            HStack(spacing: 10) {
                Text(word.label.uppercased())
                Rectangle()
                    .fill(WordDayStyle.accent)
                    .frame(width: 26, height: 2)
                    .accessibilityHidden(true)
                Text(word.intent.uppercased())
            }
            .font(WordDayStyle.labelFont(size: 10))
            .tracking(0.65)
            .foregroundStyle(WordDayStyle.mutedInk)
            .padding(.top, 9)

            Text(word.meaning)
                .font(WordDayStyle.bodyFont(size: 21))
                .fontWeight(.regular)
                .lineSpacing(6)
                .foregroundStyle(WordDayStyle.ink)
                .padding(.top, 27)

            Text("\"\(word.example)\"")
                .font(WordDayStyle.italicFont(size: 15))
                .lineSpacing(4)
                .foregroundStyle(WordDayStyle.mutedInk)
                .padding(.top, 20)

            HStack(spacing: 7) {
                Capsule()
                    .fill(WordDayStyle.accent)
                    .frame(width: 22, height: 5)

                ForEach(0..<4) { _ in
                    Circle()
                        .fill(WordDayStyle.rule)
                        .frame(width: 5, height: 5)
                }
            }
            .padding(.top, 24)
            .accessibilityHidden(true)
        }
    }

    private var wordNumber: String {
        let index = (WordLibrary.all.firstIndex(of: word) ?? 0) + 1
        return String(format: "%02d", index)
    }
}

struct LearningGuideView: View {
    let word: Word

    private let phraseColumns = [
        GridItem(.adaptive(minimum: 118), spacing: 8, alignment: .leading)
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(alignment: .firstTextBaseline) {
                Text("PRACTICE GUIDE")
                    .font(WordDayStyle.labelFont(size: 9))
                    .tracking(1.25)
                    .foregroundStyle(WordDayStyle.accent)

                Spacer()

                Text(word.tone.uppercased())
                    .font(WordDayStyle.labelFont(size: 8))
                    .tracking(0.9)
                    .foregroundStyle(WordDayStyle.mutedInk)
            }

            GuideSection(title: "How to use it") {
                Text(word.learningTip)
                    .font(WordDayStyle.bodyFont(size: 15))
                    .lineSpacing(3)
                    .foregroundStyle(WordDayStyle.ink)
            }

            GuideSection(title: "Examples") {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(Array(word.learningExamples.prefix(3).enumerated()), id: \.offset) { index, example in
                        HStack(alignment: .top, spacing: 10) {
                            Text(String(format: "%02d", index + 1))
                                .font(WordDayStyle.labelFont(size: 8))
                                .monospacedDigit()
                                .foregroundStyle(WordDayStyle.accent)
                                .frame(width: 22, alignment: .leading)

                            Text(example)
                                .font(WordDayStyle.italicFont(size: 14))
                                .lineSpacing(3)
                                .foregroundStyle(WordDayStyle.mutedInk)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
            }

            GuideSection(title: "Variants") {
                LazyVGrid(columns: phraseColumns, alignment: .leading, spacing: 8) {
                    ForEach(word.learningPhrases.prefix(6), id: \.self) { phrase in
                        Text(phrase)
                            .font(WordDayStyle.labelFont(size: 9))
                            .tracking(0.3)
                            .foregroundStyle(WordDayStyle.accent)
                            .lineLimit(1)
                            .minimumScaleFactor(0.78)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 7)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(WordDayStyle.surface, in: Capsule())
                    }
                }
            }

            if let avoidWhen = word.avoidWhen {
                GuideSection(title: "Use carefully") {
                    Text(avoidWhen)
                        .font(WordDayStyle.bodyFont(size: 15))
                        .lineSpacing(3)
                        .foregroundStyle(WordDayStyle.mutedInk)
                }
            }
        }
        .padding(.top, 18)
        .overlay(alignment: .top) {
            Rectangle()
                .fill(WordDayStyle.rule)
                .frame(height: 1)
        }
        .accessibilityElement(children: .contain)
    }
}

private struct GuideSection<Content: View>: View {
    let title: String
    @ViewBuilder var content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 9) {
            Text(title.uppercased())
                .font(WordDayStyle.labelFont(size: 8))
                .tracking(1.05)
                .foregroundStyle(WordDayStyle.mutedInk)

            content
        }
    }
}

private struct LearnedButton: View {
    @EnvironmentObject private var learned: LearnedStore
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    let word: Word

    private var isLearned: Bool { learned.isLearned(word) }

    var body: some View {
        Button {
            withAnimation(reduceMotion ? nil : .easeOut(duration: 0.22)) {
                learned.toggle(word)
            }
        } label: {
            HStack(spacing: 10) {
                Image(systemName: isLearned ? "checkmark" : "plus")
                    .font(.system(size: 12, weight: .black))

                Text(isLearned ? "SAVED" : "SAVE CHUNK")
                    .font(WordDayStyle.labelFont(size: 10))
                    .tracking(1.1)

                Spacer()

                Image(systemName: "arrow.up.right")
                    .font(.system(size: 11, weight: .bold))
                    .accessibilityHidden(true)
            }
            .foregroundStyle(isLearned ? WordDayStyle.accentInk : WordDayStyle.accent)
            .padding(.horizontal, 16)
            .frame(minHeight: 54)
            .background(isLearned ? WordDayStyle.success : WordDayStyle.background)
            .overlay {
                Rectangle()
                    .stroke(isLearned ? WordDayStyle.success : WordDayStyle.accent, lineWidth: 1.5)
            }
        }
        .buttonStyle(.plain)
        .contentShape(Rectangle())
        .accessibilityLabel(isLearned ? "Remove \(word.phrase) from saved chunks" : "Save \(word.phrase)")
        .accessibilityHint("Updates your saved chunk count")
    }
}

struct LearnWithAIButton: View {
    let word: Word

    @State private var isShowingShareSheet = false

    var body: some View {
        Button {
            isShowingShareSheet = true
        } label: {
            HStack(spacing: 10) {
                Image(systemName: "sparkles")
                    .font(.system(size: 12, weight: .black))

                Text("LEARN WITH AI")
                    .font(WordDayStyle.labelFont(size: 10))
                    .tracking(1.1)

                Spacer()

                Image(systemName: "square.and.arrow.up")
                    .font(.system(size: 11, weight: .bold))
                    .accessibilityHidden(true)
            }
            .foregroundStyle(WordDayStyle.accent)
            .padding(.horizontal, 16)
            .frame(minHeight: 54)
            .background(WordDayStyle.background)
            .overlay {
                Rectangle()
                    .stroke(WordDayStyle.rule, lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
        .contentShape(Rectangle())
        .sheet(isPresented: $isShowingShareSheet, onDismiss: {
            isShowingShareSheet = false
        }) {
            ActivityShareSheet(
                item: word.aiLearningPrompt,
                subject: "Learn this English chunk",
                isPresented: $isShowingShareSheet
            )
        }
        .accessibilityLabel("Share \(word.phrase) with an AI app")
        .accessibilityHint("Opens the share sheet with a learning prompt")
    }
}

private struct ActivityShareSheet: UIViewControllerRepresentable {
    let item: String
    let subject: String
    @Binding var isPresented: Bool

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: [item], applicationActivities: nil)
        controller.setValue(subject, forKey: "subject")
        controller.completionWithItemsHandler = { _, _, _, _ in
            DispatchQueue.main.async {
                isPresented = false
            }
        }
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview("After Dark") {
    TodayView()
        .environmentObject(LearnedStore.shared)
        .preferredColorScheme(.dark)
}

#Preview("After Dawn") {
    TodayView()
        .environmentObject(LearnedStore.shared)
        .preferredColorScheme(.light)
}
