//
//  ViewController.m
//  AFNetworkingDemo
//
//  Created by 焱 孙 on 16/6/1.
//  Copyright © 2016年 焱 孙. All rights reserved.
//

#import "ViewController.h"
#import "ServerProvider.h"
#import "Common.h"
#import "FileBrowserViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//登录
- (IBAction)loginAction {
    [Common showProgressView:@"登录中..." view:self.view modal:NO];
    [ServerProvider loginToRestServer:@"xuetao" andPwd:@"123456" result:^(ServerReturnInfo *retInfo) {
        [Common hideProgressView:self.view];
        if (retInfo.bSuccess)
        {
            NSLog(@"登录成功");//登录成功
        }
        else
        {
            [Common tipAlert:retInfo.strErrorMsg];
        }
    }];
}

- (IBAction)downloadAction:(UIButton *)sender {
    //存在FileID,跳转到下载打开模块
    FileBrowserViewController *fileBrowserViewController = [[FileBrowserViewController alloc]init];
    FileVo *fileVo = [[FileVo alloc]init];
    fileVo.strID = @"1";
    fileVo.strName = @"55d99e5939342913.mp4";
    fileVo.strFileURL = @"http://mvvideo1.meitudata.com/55d99e5939342913.mp4";
    fileVo.lFileSize = 15558062;
    fileBrowserViewController.m_fileVo = fileVo;
    [self.navigationController pushViewController:fileBrowserViewController animated:YES];
    
//    //存在FileID,跳转到下载打开模块
//    FileBrowserViewController *fileBrowserViewController = [[FileBrowserViewController alloc]init];
//    FileVo *fileVo = [[FileVo alloc]init];
//    fileVo.strID = @"2";
//    fileVo.strName = @"user_info_2016-05-21.xlsx";
//    fileVo.strFileURL = @"http://180.166.66.226:43214/wukuang/downloadFile/2016-06-01/document/44ef7290-5529-4234-88ae-edd38f1234d4-6706.xlsx";
//    fileVo.lFileSize = 102917;
//    fileBrowserViewController.m_fileVo = fileVo;
//    [self.navigationController pushViewController:fileBrowserViewController animated:YES];
    
//    //存在FileID,跳转到下载打开模块
//    FileBrowserViewController *fileBrowserViewController = [[FileBrowserViewController alloc]init];
//    FileVo *fileVo = [[FileVo alloc]init];
//    fileVo.strID = @"1030";
//    fileVo.strName = @"[我们如何思维].(美)杜威.扫描版.PDF";
//    fileVo.strFileURL = @"http://180.166.66.226:43214/wukuang/downloadFile/2016-05-27/document/9f151e2e-d556-4c89-8a71-6dcb1668c7fe-1838.PDF";
//    fileVo.lFileSize = 20495296;
//    fileBrowserViewController.m_fileVo = fileVo;
//    [self.navigationController pushViewController:fileBrowserViewController animated:YES];
}


@end
