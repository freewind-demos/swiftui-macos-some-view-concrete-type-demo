import SwiftUI

// 这是主界面；专门拿来把 `some View` 讲白。
struct ContentView: View {
  // 这是右侧日志。
  @State private var logs: [String] = []

  // 这是会员模式开关；用来证明“内容能变，但具体外层类型仍可固定”。
  @State private var isMemberMode = false

  // 主界面布局。
  var body: some View {
    // 用纵向布局包住顶部与主体。
    VStack(alignment: .leading, spacing: 16) {
      headerCard

      HStack(alignment: .top, spacing: 16) {
        examplesPanel
        lessonPanel
      }
    }
    .padding(20)
    .frame(minWidth: 1180, minHeight: 820)
  }

  // 顶部说明卡。
  private var headerCard: some View {
    // 这里对外只写 `some View`。
    VStack(alignment: .leading, spacing: 10) {
      Text("`some View` = 具体类型已定，只是名字先藏起来")
        .font(.system(size: 28, weight: .bold))

      Text("你可以把它想成外卖盒。外面只知道“这是 1 份餐”，编译器却早就知道里面是 `Text`、`HStack` 还是 `VStack`。")
        .foregroundStyle(.secondary)

      HStack(spacing: 10) {
        badge("外面只看见 View")
        badge("里面仍是具体类型")
        badge("不是随便乱变")
      }
    }
    .padding(18)
    .background(.thinMaterial)
    .clipShape(RoundedRectangle(cornerRadius: 16))
  }

  // 左侧示例区。
  private var examplesPanel: some View {
    // 放 3 个固定小例子，再放 1 个可切换但外层形状不变的例子。
    VStack(alignment: .leading, spacing: 16) {
      Text("左边：看 4 种 `some View` 体感")
        .font(.headline)

      PlainTextTokenView(text: "这块背后其实就是 Text") {
        logs.insert("PlainTextTokenView 对外写 `some View`，里面具体是 Text。", at: 0)
      }

      PriceRowView(name: "拿铁", price: "¥18") {
        logs.insert("PriceRowView 对外写 `some View`，里面具体是 HStack。", at: 0)
      }

      SummaryCardView(
        title: "日报卡片",
        bodyText: "这里内部组合了标题、正文、按钮。对外仍只说：我返回某个具体 View。"
      ) {
        logs.insert("SummaryCardView 对外写 `some View`，里面具体是 VStack 这一整套结构。", at: 0)
      }

      Toggle("会员模式", isOn: $isMemberMode)
        .toggleStyle(.switch)

      memberBanner
    }
    .padding(18)
    .frame(width: 560, alignment: .topLeading)
    .background(.regularMaterial)
    .clipShape(RoundedRectangle(cornerRadius: 16))
  }

  // 会员横幅示例。
  private var memberBanner: some View {
    // 这里文案和颜色会变，但外层结构始终还是同 1 个 HStack。
    HStack(spacing: 12) {
      Image(systemName: isMemberMode ? "crown.fill" : "cart.fill")
        .foregroundStyle(isMemberMode ? .yellow : .blue)

      VStack(alignment: .leading, spacing: 4) {
        Text(isMemberMode ? "会员模式已开" : "普通模式")
          .font(.headline)

        Text(isMemberMode ? "折扣、徽章、文案都变了，但这个属性背后的具体类型仍然固定。" : "你看到样子在变，但编译器看到的外层返回形状仍是同 1 套结构。")
          .foregroundStyle(.secondary)
      }

      Spacer()

      Button("记录这个例子") {
        logs.insert("memberBanner 也写成 `some View`。虽然状态切换后内容变化，但它背后的外层具体类型仍固定。", at: 0)
      }
    }
    .padding(16)
    .background(isMemberMode ? Color.yellow.opacity(0.12) : Color.blue.opacity(0.08))
    .clipShape(RoundedRectangle(cornerRadius: 14))
  }

  // 右侧讲解区。
  private var lessonPanel: some View {
    // 把规则、比喻、日志放一起。
    VStack(alignment: .leading, spacing: 14) {
      Text("右边：把 `some View` 的误区掰正")
        .font(.headline)

      insightCard(
        title: "第 1 层理解",
        bodyText: "`some View` 不是“没有具体类型”。而是“有具体类型，但先不告诉你类型名”。"
      )

      insightCard(
        title: "第 2 层理解",
        bodyText: "同 1 个属性或函数，背后不能今天是 Text、明天是 HStack，然后还假装自己是同 1 个固定返回类型。"
      )

      insightCard(
        title: "外卖盒比喻",
        bodyText: "顾客只知道拿到 1 份餐。厨房其实早就定好了里面装什么。`some View` 就是把“里面具体装什么”先藏起来。"
      )

      Text("日志")
        .font(.headline)

      ScrollView {
        LazyVStack(alignment: .leading, spacing: 10) {
          ForEach(Array(logs.enumerated()), id: \.offset) { _, line in
            Text(line)
              .font(.system(.body, design: .monospaced))
              .frame(maxWidth: .infinity, alignment: .leading)
              .padding(12)
              .background(Color.primary.opacity(0.04))
              .clipShape(RoundedRectangle(cornerRadius: 10))
          }
        }
      }
      .overlay {
        if logs.isEmpty {
          Text("点左边按钮，或切换会员模式后点“记录这个例子”。")
            .foregroundStyle(.secondary)
        }
      }
    }
    .padding(18)
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    .background(.regularMaterial)
    .clipShape(RoundedRectangle(cornerRadius: 16))
  }

  // 通用说明卡。
  private func insightCard(title: String, bodyText: String) -> some View {
    // 这个函数也写 `some View`；不暴露具体卡片类型名。
    VStack(alignment: .leading, spacing: 8) {
      Text(title)
        .font(.headline)

      Text(bodyText)
        .foregroundStyle(.secondary)
    }
    .padding(14)
    .background(Color.primary.opacity(0.04))
    .clipShape(RoundedRectangle(cornerRadius: 12))
  }

  // 顶部小标签。
  private func badge(_ text: String) -> some View {
    // 小标签对外也只说自己是某个 View。
    Text(text)
      .font(.caption.weight(.medium))
      .padding(.horizontal, 10)
      .padding(.vertical, 6)
      .background(Color.primary.opacity(0.06))
      .clipShape(Capsule())
  }
}

// 这是最小文本例子。
struct PlainTextTokenView: View {
  // 注入文案。
  let text: String

  // 注入点击回调。
  let onTap: () -> Void

  // 这个小组件的界面描述。
  var body: some View {
    // 实际核心就是 1 段文字加 1 个按钮。
    VStack(alignment: .leading, spacing: 10) {
      Text(text)
        .font(.title3.weight(.semibold))

      Button("记录 Text 例子") {
        onTap()
      }
    }
    .padding(16)
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(Color.pink.opacity(0.08))
    .clipShape(RoundedRectangle(cornerRadius: 14))
  }
}

// 这是横向行例子。
struct PriceRowView: View {
  // 左侧名字。
  let name: String

  // 右侧价格。
  let price: String

  // 点击回调。
  let onTap: () -> Void

  // 这个小组件的界面描述。
  var body: some View {
    // 这里的外层形状就是 HStack。
    HStack(spacing: 12) {
      VStack(alignment: .leading, spacing: 4) {
        Text(name)
          .font(.headline)

        Text("这行背后是固定 HStack")
          .font(.caption)
          .foregroundStyle(.secondary)
      }

      Spacer()

      Text(price)
        .font(.title3.weight(.bold))

      Button("记 1 次") {
        onTap()
      }
    }
    .padding(16)
    .background(Color.green.opacity(0.08))
    .clipShape(RoundedRectangle(cornerRadius: 14))
  }
}

// 这是组合卡片例子。
struct SummaryCardView: View {
  // 卡片标题。
  let title: String

  // 卡片正文。
  let bodyText: String

  // 点击回调。
  let onTap: () -> Void

  // 这个小组件的界面描述。
  var body: some View {
    // 这里的具体类型会很长，但我们没必要把类型名直接写出来。
    VStack(alignment: .leading, spacing: 12) {
      Text(title)
        .font(.title3.weight(.semibold))

      Text(bodyText)
        .foregroundStyle(.secondary)

      Button("记录组合结构") {
        onTap()
      }
    }
    .padding(16)
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(Color.orange.opacity(0.08))
    .clipShape(RoundedRectangle(cornerRadius: 14))
  }
}
