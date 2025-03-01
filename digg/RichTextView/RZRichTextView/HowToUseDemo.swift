//
//  RZCustomRichTextViewModel.swift
//  RZRichTextView_Example
//
//  Created by rztime on 2023/8/1.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit
//import RZRichTextView
import QuicklySwift
//import TZImagePickerController
import Kingfisher

/// 使用时，直接将此代码复制到项目中，并完成相关FIXME的地方即可
@objc
public extension RZRichTextViewModel {
    /// 如果有需要自定义实现资源下载，可以放开代码，并实现sync_imageBy、async_imageBy方法
    static var configure: RZRichTextViewConfigure = {
        /// 一些与textView无关的配置,不方便写在viewModel里,所以提取出来配置在configure里
        let tempConfigure = RZRichTextViewConfigure.shared
        /// 这个颜色将生成一张图片,用于占据textView里的附件图片
        tempConfigure.attachBackgroundColor = .clear
        /// 支持有序无序 默认true
        tempConfigure.tabEnable = true
        /// 支持块 默认false
        tempConfigure.quoteEnable = true
        /// 块\列表只能存在一个 ,默认true,(false时可以同时存在)
        tempConfigure.quoteOrTab = true
        /// 无序符号配置
        tempConfigure.ulSymbol = "·"
        //tempConfigure.ulSymbol = "*"
        tempConfigure.ulSymbolAlignment = .right
        /// 如果设置，将固定无序符号的font
        tempConfigure.ulSymbolFont = nil // .systemFont(ofSize: 14, weight: .medium)
        /// 引用背景色
        tempConfigure.quoteColor = .qhex(0xcccccc)
        /// 转换为html时,blockquote的style
        tempConfigure.blockquoteStyle = #"border-left: 5px solid #eeeeee;"#
        // 其他配置可查看并参照RZRichTextViewConfigure
        /// 同步获取图片(参照内部默认配置方法)
//        tempConfigure.sync_imageBy = { source in
//        
//        }
        /// 异步获取图片(参照内部默认配置方法)
//        tempConfigure.async_imageBy = { source, complete in
//           
//        }
        return tempConfigure
    }()
    class func shared(edit: Bool = true) -> RZRichTextViewModel {
        /// 自定义遮罩view 默认RZAttachmentInfoLayerView
//        RZAttachmentOption.register(attachmentLayer: RZAttachmentInfoLayerView.self)
        
        let configure = RZRichTextViewModel.configure
        
        let viewModel = RZRichTextViewModel.init()
        viewModel.canEdit = edit
        /// 支持块时,插入块的入口
        if configure.quoteEnable {
            viewModel.inputItems.insert(.init(type: .quote, image: RZRichImage.imageWith("quote"), highlight: RZRichImage.imageWith("quote")), at: 2)
        }
        /// 链接颜色
        viewModel.defaultLinkTypingAttributes = [.foregroundColor: UIColor.qhex(0x307bf6), .underlineColor: UIColor.qhex(0x307bf6), .underlineStyle: NSUnderlineStyle.single.rawValue]
        /// 显示音频文件名字
//        viewModel.showAudioName = false
        /// 音频高度
        viewModel.audioAttachmentHeight = 60
        /// 无限制
        viewModel.maxInputLenght = 0
        /// 显示已输入字数
        viewModel.showcountType = .hidden
        viewModel.countLabelLocation = .bottomRight(x: 1, y: 1)
        /// 空格回车规则
        viewModel.spaceRule = .removeEnd
        /// 当超出长度限制时，会回调此block
        viewModel.morethanInputLength = { [weak viewModel] in
            // FIXME: 这里按需求，可以添加Toast提示
            if viewModel?.canEdit ?? true {
                print("----超出输入字数上限")
            }
        }
        viewModel.shouldInteractWithURL = { url in
            // 如果是自定义跳转，则 return false
            return true
        }
        viewModel.uploadAttachmentsComplete.subscribe({ value in
            print("上传是否完成：\(value)")
        }, disposebag: viewModel)
        /// 有新的附件插入时，需在附件的infoLayer上，添加自定义的视图，用于显示图片、视频、音频，以及交互
        viewModel.reloadAttachmentInfoIfNeed = { [weak viewModel] info in            
            /// 绑定操作，用于重传，删除、预览等功能
            info.operation.subscribe({ [weak viewModel] value in
                switch value {
                case .none: break
                case .delete(let info): // 删除
                    viewModel?.textView?.removeAttachment(info)
                case .preview(let info):// 预览
                    // FIXME: 此处自行实现预览音视频图片的功能, 重新编辑时，取src等数据
//                    let allattachments = viewModel?.textView?.attachments
//                    let index = allattachments?.firstIndex(where: {$0 == info})
                    if let asset = info.asset {
                        // 预览播放
                        let vc = TZPhotoPreviewController.init()
                        var i: UInt = 2
                        switch info.type {
                        case .image:break
                        case .video: i = 3
                        case .audio: i = 4
                        }
                        vc.models = [TZAssetModel.init(asset: asset, type: .init(i))]
                        qAppFrame.present(vc, animated: true, completion: nil)
                    } else if let url = info.poster ?? info.src {
//                        let vc = PreviewMediaViewController(url: url)
//                        qAppFrame.present(vc, animated: true, completion: nil)
                    }
                case .upload(let info): // 上传 以及点击重新上传时，将会执行
                    // FIXME: 此处自行实现上传功能，通过info获取里边的image、asset、filePath， 上传的进度需要设置到info.uploadStatus
                    UploadTaskTest.uploadFile(id: info, testVM: info) { [weak info] progress, url in
                        if progress < 1 {
                            info?.uploadStatus.accept(.uploading(progress: progress))
                        } else {
                            info?.uploadStatus.accept(.complete(success: true, info: "上传完成"))
                            switch info?.type ?? .image {
                            case .image:
                                info?.src = url
                            case .audio:
                                info?.src = ""
                            case .video:
                                info?.src = ""
                                info?.poster = ""
                            }
                        }
                    }
                }
            }, disposebag: info.dispose)
        }
        /// 自定义功能，自行实现的话需要返回true，返回false时由内部方法实现
        viewModel.didClickedAccessoryItem = { [weak viewModel] item in
            switch item.type {
            case .media:  /// 自定义添加附件，选择了附件之后，插入到textView即可
                if !(viewModel?.textView?.canInsertContent() ?? false) {
                    viewModel?.morethanInputLength?()
                    return true
                }
                // FIXME: 此处自行实现选择音视频、图片的功能，将数据写入到RZAttachmentInfo，并调用viewModel.textView?.insetAttachment(info)即可
                QActionSheetController.show(options: .init(options: [.action("图片"), .cancel("取消")])) { [weak viewModel] index in
                    if index < 0 { return }
//                    if index == 2, let viewModel = viewModel {
//                        let info = RZAttachmentInfo.init(type: .audio, image: nil, asset: nil, filePath: "file:///Users/rztime/Downloads/123.m4a", maxWidth: viewModel.attachmentMaxWidth, audioHeight: viewModel.audioAttachmentHeight)
//                        /// 插入音频
//                        viewModel.textView?.insetAttachment(info)
//                        return
//                    }
                    let vc = TZImagePickerController.init(maxImagesCount: 1, delegate: nil)
                    vc?.allowPickingImage = true
//                    vc?.allowPickingImage = index == 0
//                    vc?.allowPickingVideo = index == 1
                    vc?.allowTakeVideo = false
                    vc?.allowTakePicture = false
                    vc?.allowCrop = true
                    vc?.didFinishPickingPhotosHandle = { [weak viewModel] (photos, assets, _) in
                        if let image = photos?.first, let asset = assets?.first as? PHAsset, let viewModel = viewModel {
                            let info = RZAttachmentInfo.init(type: .image, image: image, asset: asset, filePath: nil, maxWidth: viewModel.attachmentMaxWidth, audioHeight: viewModel.audioAttachmentHeight)
                            /// 插入图片
                            viewModel.textView?.insetAttachment(info)
                        }
                    }
                    vc?.didFinishPickingVideoHandle = { [weak viewModel] (image, asset) in
                        if let image = image, let asset = asset, let viewModel = viewModel {
                            let info = RZAttachmentInfo.init(type: .video, image: image, asset: asset, filePath: nil, maxWidth: viewModel.attachmentMaxWidth, audioHeight: viewModel.audioAttachmentHeight)
                            /// 插入视频
                            viewModel.textView?.insetAttachment(info)
                        }
                    }
                    if let vc = vc {
                        qAppFrame.present(vc, animated: true, completion: nil)
                    }
                }
                return true
            case.image:
                break
            case .video:
                break
            case .audio:
                break
            case .custom1:
                if let item = viewModel?.inputItems.first(where: {$0.type == .custom1}) {
                    item.selected = !item.selected
                    /// 刷新工具条item
                    viewModel?.reloadDataWithAccessoryView?()
                    print("自定义功能1")
                }
                return true
            default:
                break
            }
            return false
        }
        return viewModel
    }
}
/// 模拟上传
class UploadTaskTest {
    ///  模拟上传，testVM主要用于释放timer
    class func uploadFile(id: Any, testVM: NSObject, progress:((_ progress: CGFloat, _ url: String) -> Void)?) {
        
        if let info = testVM as? RZAttachmentInfo {
            if let image = info.image, let imageData = image.jpegData(compressionQuality: 0.6) {
                let viewModel = SLRecordViewModel()
                viewModel.updateImage(imageData) { total, complete in
                    let p = complete / total
                    DispatchQueue.main.async {
                        progress?(p, "")
                    }
                } resultHandler: { success, url in
                    if success {
                        DispatchQueue.main.async {
                            progress?(1, url)
                        }
                    }
                }
            }
        }
//        
//        var p: CGFloat = 0
//        Timer.qtimer(interval: 0.5, target: testVM, repeats: true, mode: RunLoop.Mode.common) { timer in
//            p += 0.1
//            progress?(p)
//            if p >= 1 {
//                timer.invalidate()
//            }
//        }
    }
}
