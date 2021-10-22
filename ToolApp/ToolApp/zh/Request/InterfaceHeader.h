//
//  InterfaceHeader.h
//  Consultant
//
//  Created by 张志华 on 2020/6/4.
//  Copyright © 2020 zhangzhihua. All rights reserved.
//  129个接口 2020.10.19

#ifndef InterfaceHeader_h
#define InterfaceHeader_h
#import <UIKit/UIKit.h>

#if MACRO_DEBUG_PRODUCT == 0//测试
    ///测试测评报告地址
    static NSString * _Nullable const NetWorkTestReportPath  = @"http://123.56.146.82/reportTest?testId=";
    ///测试服务器前缀
    static NSString * _Nullable const NetWorkHttpPath = @"http://123.56.146.82:9002/";
    ///测试图片路径前缀
    static NSString * _Nullable const PicHeaderPath   = @"http://123.56.146.82:9002/";

#elif MACRO_DEBUG_PRODUCT == 1//发布
    ///正式测评报告地址
    static NSString * _Nullable const NetWorkTestReportPath  = @"http://file.yilianzixun.com/report?testId=";

    ///最初的正式
    static NSString * _Nullable const NetWorkHttpPath     = @"https://www.yilianzixun.com:9002/";
    static NSString * _Nullable const PicHeaderPath     = @"https://www.yilianzixun.com:9002/";

    ///不兼容更新时切换的域名
//    static NSString * _Nullable const NetWorkHttpPath     = @"http://www.yilianzixun.cn:9002/";
//    static NSString * _Nullable const PicHeaderPath     = @"http://www.yilianzixun.cn:9002/";

#else
#endif



//登录注册
static NSString * _Nullable const HTTPImageCode = @"imageCode"; //图片验证码
static NSString * _Nullable const HTTPNumberCode = @"verifyCode"; //短信验证码
static NSString * _Nullable const HTTPRegister = @"register"; //注册
static NSString * _Nullable const HTTPLogin = @"login"; //登录
static NSString * _Nullable const HTTPExpire = @"expire"; //延长过期时间
static NSString * _Nullable const HTTPCaptcha = @"captcha"; //v2.1 咨询师提现获取验证码

//基础信息
static NSString * _Nullable const HTTPBaseInfo = @"base/info"; //查看个人完整资料
static NSString * _Nullable const HTTPBaseAddInfo = @"base/addInfo"; //v2.1 提交保存基础信息
static NSString * _Nullable const HTTPBaseSaveInfo = @"base/saveInfo"; //咨询师提交个人基础信息
static NSString * _Nullable const HTTPBaseGetDict = @"base/dict"; //获取学历、流派、擅长领域、资质的字典信息
static NSString * _Nullable const HTTPBaseHospital = @"base/hospital"; //获取医院信息
static NSString * _Nullable const HTTPBaseDepartment = @"base/department"; //获取科室信息
static NSString * _Nullable const HTTPBaseTitle = @"base/title"; //获取职称信息
static NSString * _Nullable const HTTPBaseIdentity = @"base/identity"; //获取咨询师选择的身份信息
static NSString * _Nullable const HTTPBaseSaveIdentity = @"base/saveIdentity"; //保存咨询师选择的身份信息

//个人中心
static NSString * _Nullable const HTTPCenterInfo = @"center/info"; //个人中心查看个人信息
static NSString * _Nullable const HTTPCenterMyQRCode = @"center/myQRCode"; //获取咨询师名片二维码的链接
static NSString * _Nullable const HTTPCenterIncomeList = @"center/incomeList"; //咨询师的全部收入、退款流水清单
static NSString * _Nullable const HTTPCenterMonthIncome = @"center/monthIncome"; //咨询师的每月收入统计
static NSString * _Nullable const HTTPCenterSaveSignature = @"center/saveSignature"; //保存医生电子签名
static NSString * _Nullable const HTTPCenterBroker = @"center/broker"; //获取医生绑定的经纪人信息
static NSString * _Nullable const HTTPCenterBindBroker = @"center/bindBroker"; //扫描二维码绑定一个经纪人
static NSString * _Nullable const HTTPCenterUnbind = @"center/unbind"; //直接解绑一个经纪人
static NSString * _Nullable const HTTPCenterMyService = @"center/myService"; //v2.1 获取我的服务信息
static NSString * _Nullable const HTTPCenterCashInfo = @"center/cashInfo"; //v2.1 获取提现和银行卡信息
static NSString * _Nullable const HTTPCenterAddCard = @"center/addCard"; //v2.1 添加银行卡
static NSString * _Nullable const HTTPCenterWithdraw = @"center/withdraw"; //v2.1 发起提现申请
static NSString * _Nullable const HTTPCenterWithdrawAmount = @"center/withdrawAmount"; //v2.1 获取咨询师提现金额统计
static NSString * _Nullable const HTTPCenterWithdrawList = @"center/withdrawList"; //v2.1 获取咨询师提现列表
static NSString * _Nullable const HTTPCenterDeleteCard = @"center/deleteCard";  //v2.1 删除银行卡
static NSString * _Nullable const HTTPCenterQRCode = @"center/consultQRCode";  //v2.1 获取咨询师名片的信息和二维码的链接

//产品服务
static NSString * _Nullable const HTTPProductList = @"product/list"; //产品列表
static NSString * _Nullable const HTTPProductSetStatus = @"product/setStatus"; //设置状态
static NSString * _Nullable const HTTPProductSetPrice = @"product/setPrice"; //设置价格
static NSString * _Nullable const HTTPProductHave = @"product/have"; //获取咨询师已有的产品服务列表
static NSString * _Nullable const HTTPProductFavorList = @"product/favorList"; //v2.1 获取首单优惠列表
static NSString * _Nullable const HTTPProductSetFavor = @"product/setFavor"; //v2.1 设置首单优惠
static NSString * _Nullable const HTTPProductOffStatus = @"product/offStatus"; //v2.1 获取服务挂断状态
static NSString * _Nullable const HTTPProductSetOffStatus = @"product/setOffStatus"; //v2.1 设置服务挂断状态

//排期
static NSString * _Nullable const HTTPScheduleFixed = @"schedule/fixed"; //获取固定排期
static NSString * _Nullable const HTTPScheduleSaveFixed = @"schedule/saveFixed"; //设置固定排期
static NSString * _Nullable const HTTPScheduleTemp = @"schedule/temp"; //获取临时排期
static NSString * _Nullable const HTTPScheduleSaveTemp = @"schedule/saveTemp"; //设置临时排期
static NSString * _Nullable const HTTPScheduleDeleteTemp = @"schedule/deleteTemp"; //删除临时排期
static NSString * _Nullable const HTTPScheduleSetStatus = @"schedule/setStatus"; //设置排期开关的打开、关闭
static NSString * _Nullable const HTTPScheduleStatus = @"schedule/status"; //获取排期开关状态
static NSString * _Nullable const HTTPScheduleDeleteFixed = @"schedule/deleteFixed"; //删除固定排期
static NSString * _Nullable const HTTPScheduleDeleteAllTemp = @"schedule/deleteAllTemp";  //删除一天的临时排期
static NSString * _Nullable const HTTPScheduleTempDate = @"schedule/tempDate"; //获取已排的临时排期的日期
static NSString * _Nullable const HTTPScheduleList = @"schedule/list"; //获取咨询师一周的可用排期列表

//系统内容
static NSString * _Nullable const HTTPSysMessages = @"sys/messages"; //系统通知
static NSString * _Nullable const HTTPSysSaveFeedback = @"sys/saveFeedback"; //意见反馈
static NSString * _Nullable const HTTPSysVersion = @"sys/version"; //检查更新

//来访者
static NSString * _Nullable const HTTPUserVisitors = @"user/visitors"; //获取来访者列表
static NSString * _Nullable const HTTPUserInfo = @"user/info"; //获取来访者基本信息
static NSString * _Nullable const HTTPUserTests = @"user/tests"; //获取测评结果
static NSString * _Nullable const HTTPUserReport = @"reportTest?testId="; //来访者测评的结果报告
static NSString * _Nullable const HTTPUserRecords = @"user/records"; //获取来访者的咨询记录
static NSString * _Nullable const HTTPUserRecord = @"user/record"; //获取咨询记录的详细内容
static NSString * _Nullable const HTTPUserHealth = @"user/health"; //获取来访者身体健康档案的基础信息
static NSString * _Nullable const HTTPUserSummaries = @"user/summaries"; //获取来访者的健康咨询记录
static NSString * _Nullable const HTTPUserSummaryDetail = @"user/summaryDetail"; //获取健康咨询记录的总结及建议

//消息管理
static NSString * _Nullable const HTTPMsghasReferral = @"msg/hasReferral"; //获取是否有其他咨询师转介了当前咨询师给当前咨询人
static NSString * _Nullable const HTTPMsgSaveMsg = @"msg/saveMsg"; //获取是否有其他咨询师转介了当前咨询师给当前咨询人
static NSString * _Nullable const HTTPMsgConference = @"msg/conference"; //根据预约单创建视频会议
static NSString * _Nullable const HTTPMsgReferral = @"msg/referral"; //获取转介单的详细信息
static NSString * _Nullable const HTTPMsmReferDoctor = @"msg/referDoctor"; //转介其他的医生给当前咨询人
static NSString * _Nullable const HTTPMsgSaveServeMsg = @"msg/saveServeMsg"; //保存图文咨询聊天内容
static NSString * _Nullable const HTTPMsgReferConsult = @"msg/referConsult"; //转介其他的咨询师给当前咨询人

//聊天管理
static NSString * _Nullable const HTTPChatBookDates = @"chat/bookDates"; //获取咨询师某天可预约得全部时间列表
static NSString * _Nullable const HTTPChatApplyEdit = @"chat/applyEdit"; //咨询师申请修改新的预约时间
static NSString * _Nullable const HTTPChatCheckEdit = @"chat/checkEdit"; //咨询师审核用户的预约时间修改请求
static NSString * _Nullable const HTTPChatScales = @"chat/scales"; //获取可用的推荐量表
static NSString * _Nullable const HTTPChatRecommendScale = @"chat/recommendScale"; //给用户推荐量表
static NSString * _Nullable const HTTPChatSaveFollow = @"chat/saveFollow"; //收藏其他的咨询师
static NSString * _Nullable const HTTPChatCancelFollow = @"chat/cancelFollow"; //取消收藏的咨询师
static NSString * _Nullable const HTTPChatFollows = @"chat/followConsults"; //获取收藏的咨询师列表
static NSString * _Nullable const HTTPChatConsults = @"chat/consults"; //获取全部的咨询师列表
static NSString * _Nullable const HTTPChatReport = @"chat/report"; //来访者测评的结果报告
static NSString * _Nullable const HTTPChatEditStatus = @"chat/editStatus"; //咨询师查询申请的预约日期的修改状态
static NSString * _Nullable const HTTPChatUsedDates = @"chat/usedDates";  //获取咨询师被占用的时间列表
static NSString * _Nullable const HTTPChatArrange = @"chat/arrange";  //咨询师给不排期的预约单安排时间
static NSString * _Nullable const HTTPChatFollowDoctors = @"chat/followDoctors"; //获取收藏的医生列表
static NSString * _Nullable const HTTPChatDoctors = @"chat/doctors"; //获取全部的医生列表

//单据管理
static NSString * _Nullable const HTTPBookInfo = @"book/info"; //私信页面所需的预约单、用户的基本信息
static NSString * _Nullable const HTTPBookList = @"book/list"; //获取全部的预约单
static NSString * _Nullable const HTTPBookDetail = @"book/detail"; //获取预约单详细信息
static NSString * _Nullable const HTTPBookConfirm = @"book/confirm"; //咨询师确认服务完成
static NSString * _Nullable const HTTPBookStart = @"book/start"; //咨询师开始发起咨询
static NSString * _Nullable const HTTPBookAccept = @"book/accept"; //咨询师接通视频咨询
static NSString * _Nullable const HTTPBookUserBreak = @"book/userBreak"; //咨询师点击来访者爽约
static NSString * _Nullable const HTTPBookSaveRecord = @"book/saveRecord"; //添加咨询记录
static NSString * _Nullable const HTTPBookHangUp = @"book/hangUp"; //咨询师主动挂断咨询服务
static NSString * _Nullable const HTTPBookSaveSummary = @"book/saveSummary"; //健康咨询添加咨询总结
static NSString * _Nullable const HTTPBookBrief = @"book/brief"; //获取预约单简单信息
static NSString * _Nullable const HTTPBookIsSchedule = @"book/isSchedule"; //需手动确认时间的预约单查看安排时间的状态

//咨询师管理
static NSString * _Nullable const HTTPConsultFailReason = @"consult/failReason"; //查看审核失败原因
static NSString * _Nullable const HTTPConsultExamine = @"consult/examine"; //咨询师提交审核
static NSString * _Nullable const HTTPConsultInfo = @"consult/info"; //获取咨询师的基本信息
static NSString * _Nullable const HTTPConsultSaveType = @"consult/saveType"; //咨询师提交擅长领域信息
static NSString * _Nullable const HTTPConsultSaveBrief = @"consult/saveBrief"; //咨询师提交一句话简介
static NSString * _Nullable const HTTPConsultSaveIntro = @"consult/saveIntro"; //咨询师提交个人详细介绍
static NSString * _Nullable const HTTPConsultSaveTraining = @"consult/saveTraining"; //咨询师提交培训经历
static NSString * _Nullable const HTTPConsultDetail = @"consult/detail"; //获取咨询师的详细信息
static NSString * _Nullable const HTTPConsultQualifyInfo = @"consult/qualifyInfo"; //v2.1 获取咨询师流派和资质信息
static NSString * _Nullable const HTTPConsultSaveQualify = @"consult/saveQualify"; //v2.1 保存每条资质信息
static NSString * _Nullable const HTTPConsultSaveQualifyInfo = @"consult/saveQualifyInfo"; //v2.1 保存资质和流派信息
static NSString * _Nullable const HTTPConsultBaseInfo = @"consult/baseInfo"; //v2.1 获取咨询师的基本信息
static NSString * _Nullable const HTTPConsultSaveBase = @"consult/saveBase"; //v2.1 保存咨询师的基本信息
static NSString * _Nullable const HTTPConsultSaveAcademic = @"consult/saveAcademic"; //v2.1 保存每条教育经历
static NSString * _Nullable const HTTPConsultTrainingInfo = @"consult/trainingInfo"; //v2.1 获取咨询师培训和经历
static NSString * _Nullable const HTTPConsultSaveLongTrain = @"consult/saveLongTrain"; //v2.1 保存每条长程培训经历
static NSString * _Nullable const HTTPConsultSaveShortTrain = @"consult/saveShortTrain"; //v2.1 保存每条短期培训经历
static NSString * _Nullable const HTTPConsultSaveExperience = @"consult/saveExperience"; //v2.1 保存每条线下个人咨询经历
static NSString * _Nullable const HTTPConsultSaveSupervise = @"consult/saveSupervise"; //v2.1 保存每条督导经历
static NSString * _Nullable const HTTPConsultSavePractice = @"consult/savePractice"; //v2.1 保存每条个人体验
static NSString * _Nullable const HTTPConsultSaveTrainInfo = @"consult/saveTrainInfo"; //v2.1 保存全部培训经历、线下咨询、督导经历、个人体验
static NSString * _Nullable const HTTPConsultFieldInfo = @"consult/fieldInfo"; //v2.1 获取咨询师擅长和介绍
static NSString * _Nullable const HTTPConsultSaveFieldInfo = @"consult/saveFieldInfo"; //v2.1 保存咨询师擅长和介绍
static NSString * _Nullable const HTTPConsultDetailInfo = @"consult/detailInfo"; //v2.1 获取咨询师详细信息
static NSString * _Nullable const HTTPConsultQualifyList = @"consult/qualifyList"; //v2.1 获取咨询师的资质列表
static NSString * _Nullable const HTTPConsultSetPriorQualify = @"consult/setPriorQualify"; //v2.1 设置默认显示的资质
static NSString * _Nullable const HTTPConsultUpgrade = @"consult/upgrade"; //v2.1 咨询师升级


//医生管理
static NSString * _Nullable const HTTPDoctorInfo = @"doctor/info";  //获取医生基础信息和认证信息
static NSString * _Nullable const HTTPDoctorSaveBase = @"doctor/saveBase"; //保存医生基本信息
static NSString * _Nullable const HTTPDoctorSaveFile = @"doctor/saveFile"; //保存医生实名认证的图片，包括电子签名、身份证正反面、胸牌
static NSString * _Nullable const HTTPDoctorSaveQualify = @"doctor/saveQualify"; //保存医生资格证图片
static NSString * _Nullable const HTTPDoctorSavePractice = @"doctor/savePractice"; //保存医生执业证图片
static NSString * _Nullable const HTTPDoctorSaveTitle = @"doctor/saveTitle"; //保存医生职称证图片
static NSString * _Nullable const HTTPDoctorSaveLogo = @"doctor/saveLogo";  //保存医生正面照图片
static NSString * _Nullable const HTTPDoctorSaveBrief = @"doctor/saveBrief"; //保存医生擅长领域和自我介绍
static NSString * _Nullable const HTTPDoctorExamine = @"doctor/examine"; //医生信息提交审核
static NSString * _Nullable const HTTPDoctorStatus = @"doctor/status"; //医生信息提交审核
static NSString * _Nullable const HTTPDoctorFailReason = @"doctor/failReason"; //获取医生身份审核拒绝原因
static NSString * _Nullable const HTTPDoctorBrief = @"doctor/brief"; //获取医生擅长领域和个人介绍
static NSString * _Nullable const HTTPDoctorBase = @"doctor/base"; //获取医生详细基础信息
static NSString * _Nullable const HTTPDoctorDetail = @"doctor/detail"; //获取医生详细信息

//服务单管理
static NSString * _Nullable const HTTPServelist = @"serve/list"; //获取全部的图文咨询服务单
static NSString * _Nullable const HTTPServeInfo = @"serve/info"; //私信页面所需的服务单、用户的信息
static NSString * _Nullable const HTTPServeStart = @"serve/start"; //图文咨询咨询师开始咨询
static NSString * _Nullable const HTTPServeAddNum = @"serve/addNum"; //咨询师给用户赠送追问次数
static NSString * _Nullable const HTTPServeSaveSummary = @"serve/saveSummary"; //咨询师给服务单添加咨询总结



#endif /* InterfaceHeader_h */
