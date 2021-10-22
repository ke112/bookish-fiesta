//
//  ZhDownloadManager.h
//  Consultant
//
//  Created by 张志华 on 9/15/20.
//  Copyright © 2020 zhangzhihua. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 下载进度发生改变的通知 */
extern NSString *const ZhDownloadProgressDidChangeNotification;
/** 下载状态发生改变的通知 */
extern NSString *const ZhDownloadStateDidChangeNotification;
/** 利用这个key从通知中取出对应的DownloadInfo对象 */
extern NSString *const ZhDownloadInfoKey;

/** 下载状态 */
typedef NS_ENUM(NSInteger, ZhDownloadState) {
    
    ZhDownloadStateNone = 0,     // 闲置状态（除后面几种状态以外的其他状态）
    ZhDownloadStateWillResume,   // 即将下载（等待下载）
    ZhDownloadStateResumed,      // 下载中
    ZhDownloadStateSuspened,     // 暂停中
    ZhDownloadStateCompleted     // 已经完全下载完毕
    
} NS_ENUM_AVAILABLE_IOS(2_0);


/**
 *  跟踪下载进度的Block回调
 *
 *  @param bytesWritten              【这次回调】写入的数据量
 *  @param totalBytesWritten         【目前总共】写入的数据量
 *  @param totalBytesExpectedToWrite 【最终需要】写入的数据量
 */
typedef void (^ZhDownloadProgressChangeBlock)(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite,CGFloat progress);

/**
 *  状态改变的Block回调
 *
 *  @param file     文件的下载路径
 *  @param error    失败的描述信息
 */
typedef void (^ZhDownloadStateChangeBlock)(ZhDownloadState state, NSString *file, NSError *error);

#pragma mark - 下载的描述信息
@interface ZhDownloadInfo : NSObject
/** 下载状态 */
@property (assign, nonatomic, readonly) ZhDownloadState state;
/** 这次写入的数量 */
@property (assign, nonatomic, readonly) NSInteger bytesWritten;
/** 已下载的数量 */
@property (assign, nonatomic, readonly) NSInteger totalBytesWritten;
/** 文件的总大小 */
@property (assign, nonatomic, readonly) NSInteger totalBytesExpectedToWrite;
/** 文件名(MD5) */
@property (copy, nonatomic, readonly) NSString *filename;
/** 文件路径 */
@property (copy, nonatomic, readonly) NSString *file;
/** 文件名 */
@property (copy, nonatomic, readonly) NSString *name;
/** 文件url */
@property (copy, nonatomic, readonly) NSString *url;
/** 下载的错误信息 */
@property (strong, nonatomic, readonly) NSError *error;

@end

@interface ZhDownloadManager : NSObject

/** 回调的队列 */
@property (nonatomic, strong) NSOperationQueue *queue;
/** 最大同时下载数 */
@property (nonatomic, assign) int maxDownloadingCount;

+ (instancetype)defaultManager;
+ (instancetype)manager;
+ (instancetype)managerWithIdentifier:(NSString *)identifier;

/** 全部文件取消下载(一旦被取消了，需要重新调用download方法) */
- (void)cancelAll;

/** 全部文件取消下载(一旦被取消了，需要重新调用download方法) */
+ (void)cancelAll;

/** 取消下载某个文件(一旦被取消了，需要重新调用download方法) */
- (void)cancel:(NSString *)url;

/** 全部文件暂停下载 */
- (void)suspendAll;

/** 全部文件暂停下载 */
+ (void)suspendAll;

/** 暂停下载某个文件 */
- (void)suspend:(NSString *)url;

/** 全部文件开始\继续下载 */
- (void)resumeAll;

/** 全部文件开始\继续下载 */
+ (void)resumeAll;

/** 开始\继续下载某个文件 */
- (void)resume:(NSString *)url;

/** 获得某个文件的下载信息 */
- (ZhDownloadInfo *)downloadInfoForURL:(NSString *)url;

/** 删除本地某个文件 */
- (void)deleteWithUrl:(NSString *)url;

/** 删除本地所有文件 */
- (void)deleteAll;

/** 下载一个文件 */
- (ZhDownloadInfo *)download:(NSString *)url;

/**
 *  下载一个文件
 *
 *  @param url      文件的URL路径
 *  @param state    状态改变的回调
 *
 *  @return YES     代表文件已经下载完毕
 */
- (ZhDownloadInfo *)download:(NSString *)url
                       state:(ZhDownloadStateChangeBlock)state;

/**
 *  下载一个文件
 *
 *  @param url          文件的URL路径
 *  @param progress     下载进度的回调
 *  @param state        状态改变的回调
 *
 *  @return YES代表文件已经下载完毕
 */
- (ZhDownloadInfo *)download:(NSString *)url
                    progress:(ZhDownloadProgressChangeBlock)progress
                       state:(ZhDownloadStateChangeBlock)state;

/**
 *  下载一个文件
 *
 *  @param url              文件的URL路径
 *  @param destinationPath  文件的存放路径
 *  @param progress         下载进度的回调
 *  @param state            状态改变的回调
 *
 *  @return YES代表文件已经下载完毕
 */
- (ZhDownloadInfo *)download:(NSString *)url
           toDestinationPath:(NSString *)destinationPath
                    progress:(ZhDownloadProgressChangeBlock)progress
                       state:(ZhDownloadStateChangeBlock)state;

@end
