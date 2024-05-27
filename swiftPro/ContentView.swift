//
//  ContentView.swift
//  swiftPro
//
//  Created by song on 2024/5/21.
//

import Alamofire
import Kingfisher
import SwiftUI

struct ContentView: View {
    // 加载网络数据
    func load_data() {
        // 准备一个url
        let url = "https://github.com/xiaoyouxinqing/PostDemo/raw/master/PostDemo/Resources/PostListData_hot_1.json"
        // 使用Alamofile发起请求
        AF.request(url).responseData(completionHandler: { res in
            // response.result为枚举类型，所以需要使用switch
            switch res.result {
                case let .success(Data):
                    // 将Data类型的数据转为Json字符串
                    let jsonString = try? JSONSerialization.jsonObject(with: Data)
                    // 打印json字符串
                    print("success\(String(describing: jsonString))")
                case let .failure(error):
                    print("error\(error)")
            }
            // print("响应数据：\(res.result)")
        })
    }

    // get请求
    func getData() {
        print("发送get请求")
        // 准备一个url
        let url = "https://github.com/xiaoyouxinqing/PostDemo/raw/master/PostDemo/Resources/PostListData_hot_1.json"
        // 使用Alamofile发起请求，默认是GET
        AF.request(url).responseData(completionHandler: { res in
            // response.result为枚举类型，所以需要使用switch
            switch res.result {
                case let .success(Data):
                    // 将Data类型的数据转为Json字符串
                    let jsonString = try? JSONSerialization.jsonObject(with: Data)
                    // 打印json字符串
                    print("success\(String(describing: jsonString))")
                case let .failure(error):
                    print("error\(error)")
            }
            // print("响应数据：\(res.result)")
        })
    }

    // post请求
    func postData() {
        print("发送post请求")
        let urlStr = "https://api.weixin.qq.com/wxa/business/getuserphonenumber"
        // payload 数据
        let payload = ["name": "hibo", "password": "123456"]
        AF.request(urlStr, method: .post, parameters: payload).responseJSON { response in
            switch response.result {
                case let .success(json):
                    print("post response: \(json)")
                case let .failure(error):
                    print("error:\(error)")
            }
        }
    }

    // 下载文件
    func downFile() {
        print("下载文件")
        let url = "https://hadoappusage.oss-cn-shanghai.aliyuncs.com/static/mini_image/10003.jpg"
        // 指定下载文件夹
        let downDir = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
        // 发送下载请求
        AF.download(url, to: downDir).downloadProgress { progress in
            print("下载进度: \(progress)")
        }.responseData { response in
            if let data = response.value {
                print("下载完成")
            }
        }
    }

    // 上传表单
    func putForm() {
        print("上传表单")
    }

    var body: some View {
        VStack {
            KFImage(URL(string: "https://hadoappusage.oss-cn-shanghai.aliyuncs.com/static/mini_image/10003.jpg")).resizable().frame(height: 200)
            Button(action: {
                load_data()
            }, label: {
                Text("获取数据").font(/*@START_MENU_TOKEN@*/ .title/*@END_MENU_TOKEN@*/).foregroundColor(.white).padding(10)
            }).background(.orange).cornerRadius(10)
            Button(action: /*@START_MENU_TOKEN@*/ {}/*@END_MENU_TOKEN@*/, label: {
                Text("GET请求").font(/*@START_MENU_TOKEN@*/ .title/*@END_MENU_TOKEN@*/).foregroundColor(.white).padding(10)
            }).background(.red).cornerRadius(10)
            Button(action: {
                postData()
            }, label: { Text("POST请求").padding(10).font(/*@START_MENU_TOKEN@*/ .title/*@END_MENU_TOKEN@*/).foregroundColor(.white) }).background(.blue).cornerRadius(10)
            // 下载文件
            Button(action: {
                print("下载文件")
                downFile()
            }, label: {
                Text("下载文件").font(/*@START_MENU_TOKEN@*/ .title/*@END_MENU_TOKEN@*/).foregroundColor(.white).padding(10)
            }).background(.yellow).cornerRadius(10)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
