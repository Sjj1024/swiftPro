//
//  ContentView.swift
//  swiftPro
//
//  Created by song on 2024/5/21.
//

import Alamofire
import AVKit
import GIFImage
import Kingfisher
import SwiftUI
import VideoPlayer

private var videoURLs: [URL] = [
    URL(string: "https://vfx.mtime.cn/Video/2019/06/29/mp4/190629004821240734.mp4")!,
    URL(string: "https://vfx.mtime.cn/Video/2019/06/27/mp4/190627231412433967.mp4")!,
    URL(string: "https://vfx.mtime.cn/Video/2019/06/25/mp4/190625091024931282.mp4")!,
    URL(string: "https://vfx.mtime.cn/Video/2019/06/16/mp4/190616155507259516.mp4")!,
    URL(string: "https://vfx.mtime.cn/Video/2019/06/15/mp4/190615103827358781.mp4")!,
    URL(string: "https://vfx.mtime.cn/Video/2019/06/05/mp4/190605101703931259.mp4")!,
]

struct ContentView: View {
    // 本地文件
    let localMp4Url = Bundle.main.url(forResource: "localMp4", withExtension: "mp4")

    // 远程视频
    let remoteUrl = URL(string: "https://vfx.mtime.cn/Video/2019/06/15/mp4/190615103827358781.mp4")
    
    // 获取当前播放时间
    func getTimeString() -> String {
        let m = Int(time.seconds / 60)
        let s = Int(time.seconds.truncatingRemainder(dividingBy: 60))
        return String(format: "%d:%02d", arguments: [m, s])
    }
    
    // 获取视频所有的时间
    func getTotalDurationString() -> String {
        let m = Int(totalDuration / 60)
        let s = Int(totalDuration.truncatingRemainder(dividingBy: 60))
        return String(format: "%d:%02d", arguments: [m, s])
    }
    
    // 视频列表索引
    @State var index = 0
    // 播放状态
    @State private var play: Bool = true
    // 视频播放时间
    @State private var time: CMTime = .zero
    // 是否自动播放
    @State private var autoReplay: Bool = true
    // 是否开启声音（mute：沉默的，无声的）
    @State private var mute: Bool = false
    // 视频播放状态文字提示
    @State private var stateText: String = ""
    // 总共持续时间
    @State private var totalDuration: Double = 0
    // 播放速度
    @State private var speedRate: Float = 1.2

    // 使用状态来跟踪播放状态
    @State private var isPlaying = false

    var body: some View {
        VStack(content: {
            // 视频播放控制是通过绑定变量来实现的
            VideoPlayer(url: videoURLs[index % videoURLs.count], play: $play, time: $time)
                .autoReplay(autoReplay)
                .mute(mute)
                .speedRate(speedRate)
                .onBufferChanged { progress in print("onBufferChanged \(progress)") }
                .onPlayToEndTime { print("onPlayToEndTime") }
                .onReplay { print("onReplay") }
                .onStateChanged { state in
                    switch state {
                    case .loading:
                        self.stateText = "Loading..."
                    case .playing(let totalDuration):
                        self.stateText = "Playing!"
                        self.totalDuration = totalDuration
                    case .paused(let playProgress, let bufferProgress):
                        self.stateText = "Paused: play \(Int(playProgress * 100))% buffer \(Int(bufferProgress * 100))%"
                    case .error(let error):
                        self.stateText = "Error: \(error)"
                    }
                }
                .aspectRatio(1.78, contentMode: .fit)
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.7), radius: 6, x: 0, y: 2)
                .padding()
            
            // 视频状态
            Text(stateText)
                .padding()
            
            // 视频控制：暂停/声音控制/自动重播/后退前进5秒/下一个视频
            HStack {
                Button(self.play ? "Pause" : "Play") {
                    self.play.toggle()
                }

                Divider().frame(height: 20)

                Button(self.mute ? "Sound Off" : "Sound On") {
                    self.mute.toggle()
                }

                Divider().frame(height: 20)

                Button(self.autoReplay ? "Auto Replay On" : "Auto Replay Off") {
                    self.autoReplay.toggle()
                }
            }

            HStack {
                Button("Backward 5s") {
                    self.time = CMTimeMakeWithSeconds(max(0, self.time.seconds - 5), preferredTimescale: self.time.timescale)
                }

                Divider().frame(height: 20)
                
                Text("\(getTimeString()) / \(getTotalDurationString())")

                Divider().frame(height: 20)

                Button("Forward 5s") {
                    self.time = CMTimeMakeWithSeconds(min(self.totalDuration, self.time.seconds + 5), preferredTimescale: self.time.timescale)
                }
            }

            Button("Next Video") { self.index += 1 }
            
        })
    }
}

#Preview {
    ContentView()
}
