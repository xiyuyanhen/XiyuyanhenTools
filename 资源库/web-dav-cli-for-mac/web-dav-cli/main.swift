//
//  main.swift
//  web-dav-cli
//
//  Created by 葉冠暉 on 2021/2/14.
//  Copyright © 2021 葉冠暉. All rights reserved.
//

import Foundation

let webdavEvent=WebDavEvent(url:"https://dav.jianguoyun.com/dav",rootPath: "/我的坚果云",user:"xiyuyanhen@163.com",password: "auk7zybe3qfjd66q")

webdavEvent.ls()

//webdavEvent.createFolder()
//webdavEvent.remove(path:"/new folder")
//webdavEvent.download(path: "/test1234.txt", localPath: NSHomeDirectory()+"/test1234.txt")
//webdavEvent.upload(path: "/testupload.txt", localPath: NSHomeDirectory()+"/testupload.txt")
//webdavEvent.move(path: "/test1234.txt", to: "/新增資料夾/test1234.txt")
//webdavEvent.copy(path: "/test1234.txt", to: "/新增資料夾/test1234.txt")

RunLoop.main.run()
