//
//  URL加载错误码.swift
//  XiyouTeacher
//
//  Created by 细雨湮痕 on 2020/4/2.
//  Copyright © 2020 zhongkeqiyun. All rights reserved.
//

// MARK: - URL加载错误码
/*
 
 enum : NSInteger {
     NSURLErrorUnknown = -1,
     NSURLErrorCancelled = -999,
     NSURLErrorBadURL = -1000,
     NSURLErrorTimedOut = -1001,
     NSURLErrorUnsupportedURL = -1002,
     NSURLErrorCannotFindHost = -1003,
     NSURLErrorCannotConnectToHost = -1004,
     NSURLErrorNetworkConnectionLost = -1005,
     NSURLErrorDNSLookupFailed = -1006,
     NSURLErrorHTTPTooManyRedirects = -1007,
     NSURLErrorResourceUnavailable = -1008,
     NSURLErrorNotConnectedToInternet = -1009,
     NSURLErrorRedirectToNonExistentLocation = -1010,
     NSURLErrorBadServerResponse = -1011,
     NSURLErrorUserCancelledAuthentication = -1012,
     NSURLErrorUserAuthenticationRequired = -1013,
     NSURLErrorZeroByteResource = -1014,
     NSURLErrorCannotDecodeRawData = -1015,
     NSURLErrorCannotDecodeContentData = -1016,
     NSURLErrorCannotParseResponse = -1017,
     NSURLErrorAppTransportSecurityRequiresSecureConnection = -1022,
     NSURLErrorFileDoesNotExist = -1100,
     NSURLErrorFileIsDirectory = -1101,
     NSURLErrorNoPermissionsToReadFile = -1102,
     NSURLErrorDataLengthExceedsMaximum = -1103,
     NSURLErrorSecureConnectionFailed = -1200,
     NSURLErrorServerCertificateHasBadDate = -1201,
     NSURLErrorServerCertificateUntrusted = -1202,
     NSURLErrorServerCertificateHasUnknownRoot = -1203,
     NSURLErrorServerCertificateNotYetValid = -1204,
     NSURLErrorClientCertificateRejected = -1205,
     NSURLErrorClientCertificateRequired = -1206,
     NSURLErrorCannotLoadFromNetwork = -2000,
     NSURLErrorCannotCreateFile = -3000,
     NSURLErrorCannotOpenFile = -3001,
     NSURLErrorCannotCloseFile = -3002,
     NSURLErrorCannotWriteToFile = -3003,
     NSURLErrorCannotRemoveFile = -3004,
     NSURLErrorCannotMoveFile = -3005,
     NSURLErrorDownloadDecodingFailedMidStream = -3006,
     NSURLErrorDownloadDecodingFailedToComplete = -3007,
     NSURLErrorInternationalRoamingOff = -1018,
     NSURLErrorCallIsActive = -1019,
     NSURLErrorDataNotAllowed = -1020,
     NSURLErrorRequestBodyStreamExhausted = -1021,
     NSURLErrorBackgroundSessionRequiresSharedContainer = -995,
     NSURLErrorBackgroundSessionInUseByAnotherProcess = -996,
     NSURLErrorBackgroundSessionWasDisconnected = -997
 };
 
 -1（未知的错误）

 -999（请求被取消）

 -1000（请求的URL错误，无法启动请求）

 -1001（请求超时）

 -1002（不支持的URL Scheme）

 -1003（URL的host名称无法解析，即DNS有问题）

 -1004（连接host失败）

 -1005（连接过程中被中断）

 -1006（同- -1003）

 -1007（重定向次数超过限制）

 -1008（无法获取所请求的资源）

 -1009（断网状态）

 -1010（重定向到一个不存在的位置）

 -1011（服务器返回数据有误）

 -1012（身份验证请求被用户取消）

 -1013（访问资源需要身份验证）

 -1014（服务器报告URL数据不为空，却未返回任何数据）

 -1015（响应数据无法解码为已知内容编码）

 -1016（请求数据存在未知内容编码）

 -1017（响应数据无法解析）

 -1018（漫游时请求数据，但是漫游开关已关闭）

 -1019（EDGE、GPRS等网络不支持电话和流量同时进行，当正在通话过程中，请求失败错误码）

 -1020（手机网络不允许连接）

 -1021（请求的body流被耗尽）

 -1100（请求的文件路径上文件不存在）

 -1101（请求的文件只是一个目录，而非文件）

 -1102（缺少权限无法读取文件）

 -1103（资源数据大小超过最大限制）

 // SSL errors

 -1200（安全连接失败）
 -1201（服务器证书过期）
 -1202（不受信任的根服务器签名证书）
 -1203（服务器证书没有任何根服务器签名）
 -1204（服务器证书还未生效）
 -1205（服务器证书被拒绝）
 -1206（需要客户端证书来验证SSL连接）
 -2000（请求只能加载缓存中的数据，无法加载网络数据）
 // Download and file I/O errors

 -3000（下载操作无法创建文件）
 -3001（下载操作无法打开文件）
 -3002（下载操作无法关闭文件）
 -3003（下载操作无法写文件）
 -3004（下载操作无法删除文件）
 -3005（下载操作无法移动文件）
 -3006（下载操作在下载过程中，对编码文件进行解码时失败）
 -3007（下载操作在下载完成后，对编码文件进行解码时失败）
 
 */

// MARK: - Http协议常见的数字错误
/*
 
Http协议中数字错误的定义：
Status状态代码有三位数字组成，第一个数字定义了响应的类别，且有五种可能取值：

1xx:指示信息--表示请求已接收，继续处理。

2xx:成功--表示请求已被成功接收、理解、接受。

3xx:重定向--要完成请求必须进行更进一步的操作。

4xx:客户端错误--请求有语法错误或请求无法实现。

5xx:服务器端错误--服务器未能实现合法的请求

200 OK：客户端请求成功

400 Bad Request：客户端请求有语法错误，不能被服务器所理解

401 Unauthorized：请求未经授权，这个状态代码必须和WWW-Authenticate报头域一起使用

403 Forbidden：服务器收到请求，但是拒绝提供服务

404 Not Found：请求资源不存在

500 Internal Server Error：服务器发生不可预期的错误

503 Server Unavailable：服务器当前不能出来客户端的请求，一段时间后可能恢复正常。

*/
