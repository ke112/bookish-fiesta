//
//  ZhDownloadManager.m
//  Consultant
//
//  Created by 张志华 on 9/15/20.
//  Copyright © 2020 zhangzhihua. All rights reserved.
//

#import "ZhDownloadManager.h"
#import <CommonCrypto/CommonDigest.h>

NSString * const ZhDownloadProgressDidChangeNotification = @"ZhDownloadProgressDidChangeNotification";
NSString * const ZhDownloadStateDidChangeNotification = @"ZhDownloadStateDidChangeNotification";
NSString * const ZhDownloadInfoKey = @"ZhDownloadInfoKey";
#define DownloadNoteCenter [NSNotificationCenter defaultCenter]

/** 存放所有的文件大小 */
static NSMutableDictionary *_totalFileSizes;
/** 存放所有的文件大小的文件路径 */
static NSString *_totalFileSizesFile;
/** 根文件夹 */
static NSString * const ZhDownloadRootDir = @"si-downloadRoot";
/** 默认manager的标识 */
static NSString * const ZhDowndloadManagerDefaultIdentifier = @"si-downloadmanager";

@implementation NSString (_Download)
- (NSString *)prependCaches
{
    return [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:self];
}

- (NSString *)MD5
{
    // 得出bytes
    const char *cstring = self.UTF8String;
    unsigned char bytes[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cstring, (CC_LONG)strlen(cstring), bytes);
    
    // 拼接
    NSMutableString *md5String = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [md5String appendFormat:@"%02x", bytes[i]];
    }
    return md5String;
}

- (NSInteger)fileSize
{
    return [[[NSFileManager defaultManager] attributesOfItemAtPath:self error:nil][NSFileSize] integerValue];
}

- (NSString *)encodedURL
{
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]", NULL,kCFStringEncodingUTF8));
}

@end


@interface ZhDownloadInfo ()
{
    ZhDownloadState _state;
    NSInteger _totalBytesWritten;
}

/** 下载状态 */
@property (nonatomic, assign) ZhDownloadState state;
/** 这次写入的数量 */
@property (nonatomic, assign) NSInteger bytesWritten;
/** 已下载的数量 */
@property (nonatomic, assign) NSInteger totalBytesWritten;
/** 文件的总大小 */
@property (nonatomic, assign) NSInteger totalBytesExpectedToWrite;
/** 文件名(MD5) */
@property (copy, nonatomic) NSString *filename;
/** 文件路径 */
@property (copy, nonatomic) NSString *file;
/** 文件名 */
@property (copy, nonatomic) NSString *name;
/** 文件url */
@property (copy, nonatomic) NSString *url;
/** 下载的错误信息 */
@property (nonatomic, strong) NSError *error;


/** 存放所有的进度回调 */
@property (copy, nonatomic) ZhDownloadProgressChangeBlock progressChangeBlock;
/** 存放所有的完毕回调 */
@property (copy, nonatomic) ZhDownloadStateChangeBlock stateChangeBlock;
/** 任务 */
@property (nonatomic, strong) NSURLSessionDataTask *task;
/** 文件流 */
@property (nonatomic, strong) NSOutputStream *stream;

@end

@implementation ZhDownloadInfo
- (NSString *)file
{
    if (_file == nil) {
        _file = [[NSString stringWithFormat:@"%@/%@", ZhDownloadRootDir, self.filename] prependCaches];
    }
    
    if (_file && ![[NSFileManager defaultManager] fileExistsAtPath:_file]) {
        NSString *dir = [_file stringByDeletingLastPathComponent];
        [[NSFileManager defaultManager] createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return _file;
}

- (NSString *)filename
{
    if (_filename == nil) {
        NSString *pathExtension = self.url.pathExtension;
        if (pathExtension.length) {
            _filename = [NSString stringWithFormat:@"%@.%@", self.url.MD5, pathExtension];
        } else {
            _filename = self.url.MD5;
        }
    }
    return _filename;
}
-(NSString *)name{
    if (_name == nil) {
        NSString *pathExtension = self.url.pathExtension;
        if (pathExtension.length) {
            _name = [NSString stringWithFormat:@"%@", [self.url lastPathComponent]];
        } else {
            _name = self.url;
        }
        _name = [_name stringByRemovingPercentEncoding];
    }
    return _name;
}
- (NSOutputStream *)stream
{
    if (_stream == nil) {
        _stream = [NSOutputStream outputStreamToFileAtPath:self.file append:YES];
    }
    return _stream;
}

- (NSInteger)totalBytesWritten
{
    return self.file.fileSize;
}

- (NSInteger)totalBytesExpectedToWrite
{
    if (!_totalBytesExpectedToWrite) {
        _totalBytesExpectedToWrite = [_totalFileSizes[self.url] integerValue];
    }
    return _totalBytesExpectedToWrite;
}

- (ZhDownloadState)state
{
    // 如果是下载完毕
    if (self.totalBytesExpectedToWrite && self.totalBytesWritten == self.totalBytesExpectedToWrite) {
        return ZhDownloadStateCompleted;
    }
    
    // 如果下载失败
    if (self.task.error) return ZhDownloadStateNone;
    
    return _state;
}


/** 初始化任务 */
- (void)setupTask:(NSURLSession *)session
{
    if (self.task) return;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    NSString *range = [NSString stringWithFormat:@"bytes=%zd-", self.totalBytesWritten];
    [request setValue:range forHTTPHeaderField:@"Range"];
    
    self.task = [session dataTaskWithRequest:request];
    // 设置描述
    self.task.taskDescription = self.url;
}


/** 通知进度改变 */
- (void)notifyProgressChange
{
    !self.progressChangeBlock ? : self.progressChangeBlock(self.bytesWritten, self.totalBytesWritten, self.totalBytesExpectedToWrite,self.totalBytesWritten*1.0/self.totalBytesExpectedToWrite);
    [DownloadNoteCenter postNotificationName:ZhDownloadProgressDidChangeNotification
                                      object:self
                                    userInfo:@{ZhDownloadInfoKey : self}];
}

/** 通知下载完毕 */
- (void)notifyStateChange
{
    !self.stateChangeBlock ? : self.stateChangeBlock(self.state, self.file, self.error);
    [DownloadNoteCenter postNotificationName:ZhDownloadStateDidChangeNotification
                                      object:self
                                    userInfo:@{ZhDownloadInfoKey : self}];
}

#pragma mark - 状态控制
- (void)setState:(ZhDownloadState)state
{
    ZhDownloadState oldState = self.state;
    if (state == oldState) return;
    
    _state = state;
    
    // 发通知
    [self notifyStateChange];
}

/** 取消 */
- (void)cancel
{
    if (self.state == ZhDownloadStateCompleted || self.state == ZhDownloadStateNone) return;
    
    [self.task cancel];
    self.state = ZhDownloadStateNone;
}

/** 恢复 */
- (void)resume
{
    if (self.state == ZhDownloadStateCompleted || self.state == ZhDownloadStateResumed) return;
    
    [self.task resume];
    self.state = ZhDownloadStateResumed;
}

/** 等待下载 */
- (void)willResume
{
    if (self.state == ZhDownloadStateCompleted || self.state == ZhDownloadStateWillResume) return;
    
    self.state = ZhDownloadStateWillResume;
}

/** 暂停 */
- (void)suspend
{
    if (self.state == ZhDownloadStateCompleted || self.state == ZhDownloadStateSuspened) return;
    
    if (self.state == ZhDownloadStateResumed) { // 如果是正在下载
        [self.task suspend];
        self.state = ZhDownloadStateSuspened;
    } else { // 如果是等待下载
        self.state = ZhDownloadStateNone;
    }
}

#pragma mark - 代理方法处理
- (void)didReceiveResponse:(NSHTTPURLResponse *)response
{
    // 获得文件总长度
    if (!self.totalBytesExpectedToWrite) {
        self.totalBytesExpectedToWrite = [response.allHeaderFields[@"Content-Length"] integerValue] + self.totalBytesWritten;
        // 存储文件总长度
        _totalFileSizes[self.url] = @(self.totalBytesExpectedToWrite);
        [_totalFileSizes writeToFile:_totalFileSizesFile atomically:YES];
    }
    
    // 打开流
    [self.stream open];
    
    // 清空错误
    self.error = nil;
}

- (void)didReceiveData:(NSData *)data
{
    // 写数据
    NSInteger result = [self.stream write:data.bytes maxLength:data.length];
    
    if (result == -1) {
        self.error = self.stream.streamError;
        [self.task cancel]; // 取消请求
    }else{
        self.bytesWritten = data.length;
        [self notifyProgressChange]; // 通知进度改变
    }
}

- (void)didCompleteWithError:(NSError *)error
{
    // 关闭流
    [self.stream close];
    self.bytesWritten = 0;
    self.stream = nil;
    self.task = nil;
    
    // 错误(避免nil的error覆盖掉之前设置的self.error)
    self.error = error ? error : self.error;
    
    // 通知(如果下载完毕 或者 下载出错了)
    if (self.state == ZhDownloadStateCompleted || error) {
        // 设置状态
        self.state = error ? ZhDownloadStateNone : ZhDownloadStateCompleted;
        if (error == nil) {
            [self notifyStateChange];
        }
    }
}
@end


@interface ZhDownloadManager () <NSURLSessionDataDelegate>
/** session */
@property (nonatomic, strong) NSURLSession *session;
/** 存放所有文件的下载信息 */
@property (nonatomic, strong) NSMutableArray *downloadInfoArray;
/** 是否正在批量处理 */
@property (assign, nonatomic, getter=isBatching) BOOL batching;

@end


@implementation ZhDownloadManager

/** 存放所有的manager */
static NSMutableDictionary *_managers;
/** 锁 */
static NSRecursiveLock *_lock;

+ (void)initialize
{
    _totalFileSizesFile = [[NSString stringWithFormat:@"%@/%@", ZhDownloadRootDir, @"ZhDownloadFileSizes.plist".MD5] prependCaches];
    
    _totalFileSizes = [NSMutableDictionary dictionaryWithContentsOfFile:_totalFileSizesFile];
    if (_totalFileSizes == nil) {
        _totalFileSizes = [NSMutableDictionary dictionary];
    }
    
    _managers = [NSMutableDictionary dictionary];
    
    _lock = [[NSRecursiveLock alloc] init];
}

+ (instancetype)defaultManager
{
    return [self managerWithIdentifier:ZhDowndloadManagerDefaultIdentifier];
}

+ (instancetype)manager
{
    return [[self alloc] init];
}

+ (instancetype)managerWithIdentifier:(NSString *)identifier
{
    if (identifier == nil) return [self manager];
    
    ZhDownloadManager *mgr = _managers[identifier];
    if (!mgr) {
        mgr = [self manager];
        _managers[identifier] = mgr;
    }
    return mgr;
}

#pragma mark - 懒加载
- (NSURLSession *)session
{
    if (!_session) {
        // 配置
        NSURLSessionConfiguration *cfg = [NSURLSessionConfiguration defaultSessionConfiguration];
        // session
        self.session = [NSURLSession sessionWithConfiguration:cfg delegate:self delegateQueue:self.queue];
    }
    return _session;
}

- (NSOperationQueue *)queue
{
    if (!_queue) {
        self.queue = [[NSOperationQueue alloc] init];
        self.queue.maxConcurrentOperationCount = 1;
    }
    return _queue;
}

- (NSMutableArray *)downloadInfoArray
{
    if (!_downloadInfoArray) {
        self.downloadInfoArray = [NSMutableArray array];
    }
    return _downloadInfoArray;
}


#pragma mark - 公共方法
- (ZhDownloadInfo *)download:(NSString *)url
           toDestinationPath:(NSString *)destinationPath
                    progress:(ZhDownloadProgressChangeBlock)progress
                       state:(ZhDownloadStateChangeBlock)state
{
    if (url == nil) return nil;
    
    // 下载信息
    ZhDownloadInfo *info = [self downloadInfoForURL:url];
    
    // 设置block
    info.progressChangeBlock = progress;
    info.stateChangeBlock = state;
    
    // 设置文件路径
    if (destinationPath) {
        info.file = destinationPath;
        info.filename = [destinationPath lastPathComponent];
    }
    
    // 如果已经下载完毕
    if (info.state == ZhDownloadStateCompleted) {
        // 完毕
        [info notifyStateChange];
        return info;
    } else if (info.state == ZhDownloadStateResumed) {
        return info;
    }
    
    // 创建任务
    [info setupTask:self.session];
    
    // 开始任务
    [self resume:url];
    
    return info;
}

- (ZhDownloadInfo *)download:(NSString *)url
                    progress:(ZhDownloadProgressChangeBlock)progress
                       state:(ZhDownloadStateChangeBlock)state
{
    return [self download:url toDestinationPath:nil progress:progress state:state];
}

- (ZhDownloadInfo *)download:(NSString *)url state:(ZhDownloadStateChangeBlock)state
{
    return [self download:url toDestinationPath:nil progress:nil state:state];
}

- (ZhDownloadInfo *)download:(NSString *)url
{
    return [self download:url toDestinationPath:nil progress:nil state:nil];
}

#pragma mark - 文件操作
/**
 * 让第一个等待下载的文件开始下载
 */
- (void)resumeFirstWillResume
{
    if (self.isBatching) return;
    
    ZhDownloadInfo *willInfo = (ZhDownloadInfo*)[self.downloadInfoArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"state==%d", ZhDownloadStateWillResume]].firstObject;
    [self resume:willInfo.url];
}

- (void)cancelAll
{
    [self.downloadInfoArray enumerateObjectsUsingBlock:^(ZhDownloadInfo *info, NSUInteger idx, BOOL *stop) {
        [self cancel:info.url];
    }];
}

+ (void)cancelAll
{
    [_managers.allValues makeObjectsPerformSelector:@selector(cancelAll)];
}

- (void)suspendAll
{
    self.batching = YES;
    [self.downloadInfoArray enumerateObjectsUsingBlock:^(ZhDownloadInfo *info, NSUInteger idx, BOOL *stop) {
        [self suspend:info.url];
    }];
    self.batching = NO;
}

+ (void)suspendAll
{
    [_managers.allValues makeObjectsPerformSelector:@selector(suspendAll)];
}

- (void)resumeAll
{
    [self.downloadInfoArray enumerateObjectsUsingBlock:^(ZhDownloadInfo *info, NSUInteger idx, BOOL *stop) {
        [self resume:info.url];
    }];
}

+ (void)resumeAll
{
    [_managers.allValues makeObjectsPerformSelector:@selector(resumeAll)];
}

- (void)cancel:(NSString *)url
{
    if (url == nil) return;
    
    // 取消
    [[self downloadInfoForURL:url] cancel];
    
    // 这里不需要取出第一个等待下载的，因为调用cancel会触发-URLSession:task:didCompleteWithError:
    //    [self resumeFirstWillResume];
}

- (void)suspend:(NSString *)url
{
    if (url == nil) return;
    
    // 暂停
    [[self downloadInfoForURL:url] suspend];
    
    // 取出第一个等待下载的
    [self resumeFirstWillResume];
}

- (void)resume:(NSString *)url
{
    if (url == nil) return;
    
    // 获得下载信息
    ZhDownloadInfo *info = [self downloadInfoForURL:url];
    
    // 正在下载的
    NSArray *downloadingDownloadInfoArray = [self.downloadInfoArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"state==%d", ZhDownloadStateResumed]];
    if (self.maxDownloadingCount && downloadingDownloadInfoArray.count == self.maxDownloadingCount) {
        // 等待下载
        [info willResume];
    } else {
        // 继续
        [info resume];
    }
}

#pragma mark - 获得下载信息
- (ZhDownloadInfo *)downloadInfoForURL:(NSString *)url
{
    if (url == nil) return nil;
    
    ZhDownloadInfo *info = (ZhDownloadInfo *)[self.downloadInfoArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"url==%@", url]].firstObject;
    if (info == nil) {
        info = [[ZhDownloadInfo alloc] init];
        info.url = url; // 设置url
        [self.downloadInfoArray addObject:info];
    }
    return info;
}

/** 删除本地某个文件 */
- (void)deleteWithUrl:(NSString *)url{
    if (url == nil) return;

    // 下载信息
    ZhDownloadInfo *info = [self downloadInfoForURL:url];
    info.state = ZhDownloadStateNone;
    NSError *error;
    if ([[NSFileManager defaultManager] removeItemAtPath:info.file error:&error]) {
        NSLog(@"删除成功 : %@",url);
    } else {
        NSLog(@"删除失败 : %@",url);
    }
    [self cancel:url];
}
/** 删除本地所有文件 */
- (void)deleteAll{
    NSString *filePath = [[NSString stringWithFormat:@"%@", ZhDownloadRootDir] prependCaches];
    NSError *error;
    if ([[NSFileManager defaultManager] removeItemAtPath:filePath error:&error]) {
        NSLog(@"删除所有成功");
    } else {
        NSLog(@"删除所有失败");
    }
    [[self class] cancelAll];
}

#pragma mark - <NSURLSessionDataDelegate>
- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSHTTPURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    // 获得下载信息
    ZhDownloadInfo *info = [self downloadInfoForURL:dataTask.taskDescription];
    
    // 处理响应
    [info didReceiveResponse:response];
    
    // 继续
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data
{
    // 获得下载信息
    ZhDownloadInfo *info = [self downloadInfoForURL:dataTask.taskDescription];
    
    // 处理数据
    [info didReceiveData:data];
}

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error
{
    // 获得下载信息
    ZhDownloadInfo *info = [self downloadInfoForURL:task.taskDescription];
    
    // 处理结束
    [info didCompleteWithError:error];
    
    // 恢复等待下载的
    [self resumeFirstWillResume];
}

@end
