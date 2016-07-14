//
//  FileBrowserViewController.h
//  SlothSecondProj
//
//  Created by 焱 孙 on 14-6-19.
//  Copyright (c) 2014年 visionet. All rights reserved.
//

#import "CommonViewController.h"
#import "FileVo.h"
#import "SYDownloadManager.h"
#import <MessageUI/MessageUI.h>

@interface FileBrowserViewController : CommonViewController

//1.download ui
@property(nonatomic,strong)UIScrollView *m_scrollView;
@property(nonatomic,strong)UIImageView *imgViewFileIcon;
@property(nonatomic,strong)UILabel *lblFileName;
@property(nonatomic,strong)UILabel *lblFileSize;

@property(nonatomic,strong)UIButton *btnDownload;
@property(nonatomic,strong)UIButton *btnOpenWithOtherApp;

@property(nonatomic,strong)UIView *viewDownloadContainer;
@property(nonatomic,strong)UILabel *lblDownloadProgress;
@property(nonatomic,strong)UIButton *btnCancel;
@property(nonatomic,strong)UIProgressView *progressViewDownload;

//2.show document


@property(nonatomic,weak)SYHTTPRequestOperation *m_request;
@property(nonatomic,strong)FileVo *m_fileVo;

@property(nonatomic,strong)UIDocumentInteractionController *documentInteractionController;

@end
