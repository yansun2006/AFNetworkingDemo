//
//  ServerURL.m
//  CorpKnowlGroup
//
//  Created by yuson on 11-8-12.
//  Copyright 2011 DNE. All rights reserved.
//

#import "ServerURL.h"
#import "Common.h"

//服务器测试环境
//static NSString *g_restPrefixURL    = @"http://vn-functional.chinacloudapp.cn:2084/sloth2/";        //Restful API 服务器
//static NSString *g_chatPrefixURL	= @"http://vn-functional.chinacloudapp.cn:3001/";               //Node 聊天服务器
//static NSString *g_nginxPrefixURL	= @"http://vn-functional.chinacloudapp.cn/sloth-app/";          //Ngnix 服务器

static NSString *g_restPrefixURL    = @"http://vn-functional.chinacloudapp.cn/findest/";        //Restful API 服务器
static NSString *g_chatPrefixURL	= @"http://vn-functional.chinacloudapp.cn:10005/";               //Node 聊天服务器
static NSString *g_nginxPrefixURL	= @"http://vn-functional.chinacloudapp.cn/findest-app/";          //Ngnix 服务器


//////////////////////////////////////////////////////////////////////////////////////////////

static NSString *g_updateAppURL	= @"";
static NSString *g_formUploadFileURL = @"upload";
static NSString *g_loginToRESTServerURL = @"mobilelogin";
static NSString *g_logoutActionURL = @"mobilelogout";
static NSString *g_allCompanyListURL = @"register/deptList";
static NSString *g_getLoginInfoURL  = @"mobile/account/user/getUser";
static NSString *g_messageListMyAllURL = @"mobile/search/stream/toMe";
static NSString *g_getMessageListPersonalURL  = @"mobile/search/stream/toMyself";
static NSString *g_messageListMyGroupURL  = @"mobile/search/stream/myTeam";
static NSString *g_getMessageListFromMeURL  = @"mobile/search/stream/fromMe";
static NSString *g_messageListFromDraftURL = @"mobile/search/stream/draft";
static NSString *g_noticeListURL = @"mobile/notice/list";

static NSString *g_uploadFileURL	= @"mobile/attachment/fileUpload";
static NSString *g_sessionMsgListURL	= @"mobile/stream/returnList";//{titleId}
static NSString *g_editUserPasswordURL	= @"mobile/account/user/updateSelfPasswd";
static NSString *g_userDetailURL	= @"mobile/webUser/userDetail";//{id}
static NSString *g_syncAllMemberURL	= @"mobile/webUser/userContacts";
static NSString *g_editUserInfoURL	= @"mobile/webUser/update";
static NSString *g_allGroupListURL	= @"mobile/team/getAllTeamForMobile";//@"mobile/team/queryAllTeam";
static NSString *g_createGroupURL	= @"mobile/team/addteam";
static NSString *g_editGroupURL	= @"mobile/team/updateTeamInfo";
static NSString *g_dismissGroupURL	= @"mobile/team/deleteTeam";
static NSString *g_transferGroupURL	= @"mobile/team/updateTeamcreater";
static NSString *g_joinGroupURL	= @"mobile/team/addMember";
static NSString *g_exitGroupURL	= @"mobile/team/deleteMember";
static NSString *g_groupMemberListURL	= @"mobile/team/queryTeamMembers";
static NSString *g_publishMsgURL	= @"mobile/stream/new";
static NSString *g_deleteMessageURL	= @"mobile/stream/delete";//--/{id}
static NSString *g_shareBlog	= @"mobile/blog/blogs";
static NSString *g_shareDetailBlog	= @"mobile/blog";//--/{id}
static NSString *g_sharePaiserBlog	= @"mobile/blog/mentionBlog";
static NSString *g_commentListBlog	= @"mobile/blogComment/comments";
static NSString *g_createComment	= @"mobile/blogComment/create";
static NSString *g_deleteComment	= @"mobile/blogComment/delete";
static NSString *g_operateVote	= @"mobile/vote/reply";
static NSString *g_operateSchedule	= @"mobile/schedule/reply";
static NSString *g_addTagToMessageURL	= @"mobile/tag/add";//--/{streamId}/{tagIds}
static NSString *g_removeTagFromMessageURL	= @"mobile/tag/delete";//--/{streamId}/{tagId}

static NSString *g_createAlbumFolderURL         = @"mobile/imageFolder/addImageFolder";
static NSString *g_modifyAlbumFolderURL         = @"mobile/imageFolder/updateImageFolder";
static NSString *g_removeAlbumFolderURL         = @"mobile/imageFolder/deleteImageFolder";//--/id
static NSString *g_getMyFolderURL               = @"mobile/imageFolder/myfolder";
static NSString *g_getGroupFolderURL            = @"mobile/imageFolder/queryfolder";
static NSString *g_getPublicFolderURL           = @"mobile/imageFolder/queryfolder";
static NSString *g_getImageFolderURL            = @"mobile/imageFolder/findImageFolderById";//--/id
static NSString *g_addImageIntoFolderURL        = @"mobile/imageFolder/addImage";
static NSString *g_addImagesIntoFolderURL       = @"mobile/imageFolder/addImages";
static NSString *g_removeImageFromFolderURL     = @"mobile/imageFolder/deleteImage";
static NSString *g_removeImagesFromFolderURL    = @"mobile/imageFolder/deleteImages";
static NSString *g_copyImageToPublicURL         = @"mobile/imageFolder/addImageToSystem";
static NSString *g_addImageCommentURL         = @"mobile/imageFolder/addImageComment";
static NSString *g_queryImagePraiseURL        = @"mobile/imageFolder/queryPraise";//--/id
static NSString *g_queryImageDetailInfoURL    = @"mobile/imageFolder/imageById";//-/id
static NSString *g_praiseImageURL             = @"mobile/imageFolder/addImageMention";
static NSString *g_publishShare               = @"mobile/blog/create";
static NSString *g_ShareDraft                 = @"mobile/blog/drafts";
static NSString *g_searchMessageListURL    = @"mobile/search/stream/list";
static NSString *g_messageDetailURL        = @"mobile/stream";//-{id}

static NSString *g_questNewListURL         = @"mobile/question/question";
static NSString *g_questHotListURL         = @"mobile/question/hotQuestion";
static NSString *g_questUnAnswerListURL    = @"mobile/question/unAnswerQuestion";
static NSString *g_answerListURLURL        = @"mobile/3.0/answer/list";
static NSString *g_questDetailURL          = @"mobile/3.0/question";
static NSString *g_questDeleteURL          = @"mobile/3.0/question/delete";
static NSString *g_answerDeleteURL         = @"mobile/3.0/answer/delete";
static NSString *g_answerSolutionURL       = @"mobile/answer/solutionQuestion";
static NSString *g_answerPaiserURL         = @"mobile/3.0/answer/mention";
static NSString *g_askUserURL              = @"mobile/3.0/question/invite";
static NSString *g_createAnswerURL         = @"mobile/3.0/answer/save";
static NSString *g_createQuestURL          = @"mobile/3.0/question/save";
static NSString *g_answerPraiseList        = @"mobile/3.0/answer/mention/users";

static NSString *g_noticeNumURL = @"mobile/remind/allRemindCount";
static NSString *g_allNotifyTypeUnreadNumURL = @"mobile/remind/allRemindCount";
static NSString *g_myNotifyListURL = @"mobile/remind/getMyselfRemindList";//mobile/remind/myselfRemind";
static NSString *g_groupNotifyListURL = @"mobile/remind/getTeamRemindList";//mobile/remind/teamRemind";
static NSString *g_setAllNotifyToReadURL = @"mobile/remind/setAllMessagesWereRead";

static NSString *g_myAttentionUserListURL = @"mobile/webUser/getAttentionListByPage";
static NSString *g_integrationSortURL = @"mobile/webUser/findUsersByIntegral";
static NSString *g_addAttentionURL = @"mobile/relation/addRelation";
static NSString *g_cancelAttentionURL = @"mobile/relation/cancelRelation";
static NSString *g_registerUserURL = @"register";
static NSString *g_sendIdentifyingCodeURL = @"register/validateCode?phoneNumber=";
static NSString *g_setNotifyTypeToReadURL = @"mobile/remind/setOneMessageWasRead";
static NSString *g_sendChangePwdIdentifyingCodeURL = @"register/forgotpw?loginName=";
static NSString *g_changePasswordURL = @"register/resetpw";
static NSString *g_deleteShareArticleURL = @"mobile/blog/delete";//--/{id}
static NSString *g_setTheNoticeToReadURL = @"mobile/remind/setOneRemindHasReaded";//--/{id}
static NSString *g_searchShareListURL = @"mobile/blog/fuzzyBlogs";
static NSString *g_searchQAListURL = @"mobile/question/fuzzyQuestions";
static NSString *g_addCollectionURL = @"mobile/store/create";
static NSString *g_cancelCollectionURL = @"mobile/store/delete";
static NSString *g_collectionBlogURL = @"mobile/3.0/home/store/list";
static NSString *g_collectionQuestionURL = @"mobile/store/questions";
static NSString *g_drawLotteryActionURL = @"mobile/lottery";
static NSString *g_allUserListByPageURL = @"mobile/webUser/userLists";
static NSString *g_activityListURL = @"mobile/3.0/activity/list";
static NSString *g_activityProjectListURL = @"mobile/signup/findProject";//--/{blogId}
static NSString *g_signupActivityProjectURL = @"mobile/3.0/project/signup";
static NSString *g_activityProjectUserListURL = @"mobile/signup/signupListForCreator";//--/{pid}
static NSString *g_activityProjectByIDURL = @"mobile/signup/projectDetail";//--/{pid}

//聊天记录/////////////////////////////////////////////////////////////////////////////////
static NSString *g_historyChatSessionURL = @"api/historySession";
static NSString *g_sendSingleChatURL = @"api/smessage";
static NSString *g_historyChatUserURL = @"api/findSMessage";
static NSString *g_singleChatConByCIdURL = @"api/smessage";//--/{id}
static NSString *g_sendGroupChatURL = @"api/gmessage";
static NSString *g_groupHistoryChatURL = @"api/findGMessage";
static NSString *g_groupChatConByCId = @"api/gmessage";//--/{id}
static NSString *g_createOrUpdateChatDiscussionURL = @"api/invite";
static NSString *g_chatGroupInfoURL = @"api/getGroup";
static NSString *g_setPushSwitchURL = @"api/pushBlackList";
static NSString *g_setTopChatURL           = @"api/stick";
static NSString *g_deleteChatGroupMemberURL = @"api/reject";
static NSString *g_selfExitChatGroupURL     = @"api/exitGroup";
static NSString *g_transferChatGroupAdminURL    = @"api/handOver";
static NSString *g_chatSingleInfoURL        = @"api/getWhisperSet";
static NSString *g_clearChatRecordURL       = @"api/clearChatRecord";
static NSString *g_deleteChatSessionByIDURL = @"api/removeHistorySession";
static NSString *g_renameChatDiscussionURL  = @"api/renameGroup";
static NSString *g_joinedGroupChatListURL  = @"api/findMyGroup?name=";
///////////////////////////////////////////////////////////////////////////////////

static NSString *g_blogCommentListByPageURL = @"mobile/blogComment/commentList";
static NSString *g_shareInfoURL = @"mobile/snapshot/snapshot";
static NSString *g_userHeaderImageURL = @"mobile/webUser/img";//--/{id}
static NSString *g_shareListByTypeAndTagURL = @"mobile/blog/fuzzyBlogs";
static NSString *g_leagueTypeListURL = @"mobile/football/leagueList";
static NSString *g_interLeagueListURL = @"mobile/3.0/football/fixture/list";
static NSString *g_chinaLeagueListURL = @"mobile/football/zhongchao";//--/{blogId}
static NSString *g_myLeagueListURL = @"mobile/football/myQuiz";
static NSString *g_commitLeagueURL = @"mobile/3.0/football/quiz";
static NSString *g_praiseShareCommentURL = @"mobile/blogComment/mention";//--/{id}
static NSString *g_questionSurveyURL = @"mobile/survey/table";//--/{id}
static NSString *g_questionListURL = @"mobile/survey/field/list";//--/{id}
static NSString *g_commitSurveyURL = @"mobile/survey/values/submit";//--/{id}
static NSString *g_tagVoListByTypeURL = @"mobile/tag/query";//--/{id}
static NSString *g_signupMeetingURL = @"mobile/meeting/signup";
static NSString *g_commitSuggestionURL = @"mobile/suggestion/create";
static NSString *g_suggestionListURL = @"mobile/suggestion/list";
static NSString *g_suggestionBaseDataListURL = @"mobile/suggestion/option";
static NSString *g_suggestionDetailURL = @"mobile/suggestion";//--/{id}
static NSString *g_commitSuggestionReviewURL = @"mobile/suggestion/update";//--/{id}
static NSString *g_integrationListURL = @"mobile/3.0/user/integral/list";
static NSString *g_signInByDayURL = @"mobile/webUser/sign";
static NSString *g_integrationOperationURL = @"mobile/webUser/integral/maintain";
static NSString *g_integralByShareToThirdURL = @"mobile/blog/link/integral";//--/{blogId}
static NSString *g_shareLotteryURL = @"lottery/index.html";//--/id=95&type=lottery
static NSString *g_companyUserByTrueNameURL = @"mobile/account/user/dept/findByTrueName";//?term=XXX
static NSString *g_hotUserListURL = @"mobile/webUser/hot";
static NSString *g_selfRankUserListURL = @"mobile/webUser/myRanking";
static NSString *g_notifyListByTypeURL = @"mobile/remind/query";
static NSString *g_companyRankingListURL = @"mobile/dept/ranking";
static NSString *g_fansListURL = @"mobile/webUser/fans";
static NSString *g_meetingPlaceListURL = @"mobile/meetingRoom/place/list";
static NSString *g_meetingRoomListByPlaceURL = @"mobile/meetingRoom";
static NSString *g_cancelReserveMeetingRoomURL = @"mobile/meetingRoom/cancel";///{roomId}/{timeId}
static NSString *g_reserveMeetingRoomURL = @"mobile/meetingRoom/book";
static NSString *g_meetingRoomDetailURL = @"mobile/meetingRoom/booklist";
static NSString *g_myReserveMeetingListURL = @"mobile/meetingRoom/mybooklist";
static NSString *g_uploadWeixinCardPhotoURL = @"upload-card";
static NSString *g_shareWeixinCardImage = @"downloadFile/avatar/logo_1.png";
static NSString *g_meetingRoomListByParameterURL = @"mobile/3.0/meetingRoom/quick/search";
static NSString *g_praiseShareBlogURL = @"mobile/3.0/home/mention/list";
static NSString *g_topShareListURL = @"mobile/3.0/home/top";
static NSString *g_blogListByTypeURL = @"mobile/3.0/home/list";
static NSString *g_attentionShareListURL = @"mobile/3.0/home/attention/list";
static NSString *g_shieldUserByIdURL = @"mobile/3.0/user/shield";///{shieldUserId}
static NSString *g_reportUserURL = @"mobile/3.0/user/report";
static NSString *g_dictionaryConfigDataURL = @"query/dict/list?type=";//{type}
static NSString *g_restoreShieldUserByIdURL = @"mobile/3.0/user/shield/release";
static NSString *g_shieldUserListURL = @"mobile/3.0/user/shield/list";
static NSString *g_sharePraiseListURL = @"mobile/blog/mention/users";
static NSString *g_betListURL = @"mobile/3.0/football/score/conf/list";
static NSString *g_loginToCheXiangServerURL = @"mobile/webUser/chexiang/login";
static NSString *g_unbindCheXiangAccountURL = @"mobile/webUser/chexiang/logout";
static NSString *g_homeActivityListURL = @"mobile/3.0/activity/home";
static NSString *g_activityDetailURL = @"mobile/3.0/activity";
static NSString *g_activityUserListURL = @"mobile/3.0/project/signup/users";
static NSString *g_activityPraiseListURL = @"mobile/3.0/activity/mention/users";
static NSString *g_activityCommentListByPageURL = @"mobile/3.0/activity/comment/list";
static NSString *g_activityPraiseActionURL = @"mobile/3.0/activity/mention";
static NSString *g_praiseActivityCommentURL = @"mobile/3.0/activity/comment/mention";
static NSString *g_deleteActivityCommentURL = @"mobile/3.0/activity/comment/delete";
static NSString *g_activityCreateCommentURL = @"mobile/3.0/activity/comment/create";
static NSString *g_recommendAttentionUserListURL = @"mobile/3.0/user/suggest/attention";
static NSString *g_verifyCheXiangAccountURL = @"mobile/webUser/chexiang/account";
static NSString *g_myJobListURL = @"mobile/3.0/user/work/self";
static NSString *g_remainJobListURL = @"mobile/3.0/user/work/list";
static NSString *g_addJobURL = @"mobile/3.0/user/work/add";
static NSString *g_removeJobURL = @"mobile/3.0/user/work/remove";
static NSString *g_homeSearchDataURL = @"mobile/3.0/home/hotTag";
static NSString *g_setNoticeToReadByTypeURL = @"mobile/remind/setOneMessageWasRead";
static NSString *g_deleteNoticeByIDURLURL = @"mobile/remind/delete";
static NSString *g_deleteNoticeByTypeURLURL = @"mobile/remind/delete/type";
static NSString *g_updatePushSwitchSettingURL = @"mobile/3.0/remind/conf/save";
static NSString *g_pushSwitchSettingListURL = @"mobile/3.0/remind/conf/list";
static NSString *g_checkLoginNameURL = @"register/checkLoginName?loginName=";
static NSString *g_getPhoneCodeURL = @"register/validate/phone";

@implementation ServerURL

+ (NSString *)getServerURL
{
    return g_restPrefixURL;
}

+ (NSString *)getChatServerURL
{
    return g_chatPrefixURL;
}

///////////////////////////////////////////////////////////////////
+ (NSString *)getWholeURL:(NSString *)strURL
{
    NSString *strRetURL = @"";
    if (strURL == nil || (id)strURL == [NSNull null])
    {
        strRetURL = @"";
    }
    else
    {
        strRetURL = [NSString stringWithFormat:@"%@%@",g_restPrefixURL,strURL];
    }
    return strRetURL;
}

+ (NSString *)getUploadFileURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_uploadFileURL];
}

//AFNetworking 文件上传 (multipart form-data)
+ (NSString *)getFormUploadFileURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_formUploadFileURL];
}

+ (NSString *)getVersionUpdateURL
{
    //版本更新URL
    return g_updateAppURL;
}

+ (void)setVersionUpdateURL:(NSString*)strUpdateAppURL
{
    g_updateAppURL = strUpdateAppURL;
}

+ (NSString *)getFormatChatSessionID
{
    return [NSString stringWithFormat:@";nsid=%@",[Common getChatSessionID]];
}

+ (NSString *)getLoginToRESTServerURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_loginToRESTServerURL];
}

+ (NSString *)getAllCompanyListURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_allCompanyListURL];
}

+ (NSString *)getLoginInfoURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_getLoginInfoURL];
}

+ (NSString *)getMessageListPersonalURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_getMessageListPersonalURL];
}

+ (NSString *)getMessageListFromMeURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_getMessageListFromMeURL];
}

+ (NSString *)getSessionMsgListURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_sessionMsgListURL];
}

+ (NSString *)getEditUserPasswordURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_editUserPasswordURL];
}

+ (NSString *)getUserDetailURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_userDetailURL];
}

+ (NSString *)getSyncAllMemberURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_syncAllMemberURL];
}

+ (NSString *)getEditUserInfoURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_editUserInfoURL];
}

+ (NSString *)getAllGroupListURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_allGroupListURL];
}

+ (NSString *)getCreateGroupURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_createGroupURL];
}

+ (NSString *)getEditGroupURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_editGroupURL];
}

+ (NSString *)getDismissGroupURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_dismissGroupURL];
}

+ (NSString *)getTransferGroupURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_transferGroupURL];
}

+ (NSString *)getJoinGroupURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_joinGroupURL];
}

+ (NSString *)getExitGroupURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_exitGroupURL];
}

+ (NSString *)getPublishMsgURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_publishMsgURL];
}

+ (NSString *)getDeleteMessageURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_deleteMessageURL];
}

+ (NSString *)getShareBlog
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_shareBlog];
}

+ (NSString *)getShareDetailBlog
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_shareDetailBlog];
}

+ (NSString *)getSharePaiserBlog
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_sharePaiserBlog];
}

+ (NSString *)getActivityPraiseActionURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_activityPraiseActionURL];
}

+ (NSString *)getCommentListBlog
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_commentListBlog];
}

+ (NSString *)getCreateComment
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_createComment];
}

+ (NSString *)getDeleteComment
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_deleteComment];
}

+ (NSString *)getDeleteActivityCommentURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_deleteActivityCommentURL];
}

+ (NSString *)getOperateVoteURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_operateVote];
}

+ (NSString *)getOperateScheduleURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_operateSchedule];
}

+ (NSString *)getAddTagToMessageURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_addTagToMessageURL];
}

+ (NSString *)getRemoveTagFromMessageURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_removeTagFromMessageURL];
}

+ (NSString *) getCreateAlbumFolderURL
{
    return [NSString stringWithFormat:@"%@%@",g_restPrefixURL,g_createAlbumFolderURL];
}

+ (NSString *) getModifyAlbumFolderURL
{
    return [NSString stringWithFormat:@"%@%@",g_restPrefixURL,g_modifyAlbumFolderURL];
}

+ (NSString *) getRemoveAlbumFolderURL
{
    return [NSString stringWithFormat:@"%@%@",g_restPrefixURL,g_removeAlbumFolderURL];
}

+ (NSString *) getMyAlbumFolderInfoURL
{
    return [NSString stringWithFormat:@"%@%@",g_restPrefixURL,g_getMyFolderURL];
}

+ (NSString *) getPublicAlbumFolderInfoURL
{
    return [NSString stringWithFormat:@"%@%@",g_restPrefixURL,g_getPublicFolderURL];
}

+ (NSString *) getGroupAlbumFolderInfoURL
{
    return [NSString stringWithFormat:@"%@%@",g_restPrefixURL,g_getGroupFolderURL];
}

+ (NSString *) getImageFolderFromIDURL
{
    return [NSString stringWithFormat:@"%@%@",g_restPrefixURL,g_getImageFolderURL];
}

+ (NSString *) getAddImageIntoFolderURL
{
    return [NSString stringWithFormat:@"%@%@",g_restPrefixURL,g_addImageIntoFolderURL];
}

+ (NSString *) getAddImagesIntoFolderURL
{
    return [NSString stringWithFormat:@"%@%@",g_restPrefixURL,g_addImagesIntoFolderURL];
}

+ (NSString *) getRemoveImageFromFolderURL
{
    return [NSString stringWithFormat:@"%@%@",g_restPrefixURL,g_removeImageFromFolderURL];
}

+ (NSString *) getRemoveImagesFromFolderURL
{
    return [NSString stringWithFormat:@"%@%@",g_restPrefixURL,g_removeImagesFromFolderURL];
}

+ (NSString *) getCopyImageToPublicURL
{
    return [NSString stringWithFormat:@"%@%@",g_restPrefixURL,g_copyImageToPublicURL];
}

+ (NSString *) getAddImageCommentURL
{
    return [NSString stringWithFormat:@"%@%@",g_restPrefixURL,g_addImageCommentURL];
}

+ (NSString *)getQueryImagePraiseURL
{
    return [NSString stringWithFormat:@"%@%@",g_restPrefixURL,g_queryImagePraiseURL];
}

+ (NSString *)getQueryImageDetailInfoURL;
{
    return [NSString stringWithFormat:@"%@%@",g_restPrefixURL,g_queryImageDetailInfoURL];
}

+(NSString *)getPraiseImageURL
{
    return [NSString stringWithFormat:@"%@%@",g_restPrefixURL,g_praiseImageURL];
}

+(NSString *)getSearchMessageListURL
{
    return [NSString stringWithFormat:@"%@%@",g_restPrefixURL,g_searchMessageListURL];
}

+(NSString *)getPublishShare
{
    return [NSString stringWithFormat:@"%@%@",g_restPrefixURL,g_publishShare];
}

+(NSString *)getShareDraft
{
    return [NSString stringWithFormat:@"%@%@",g_restPrefixURL,g_ShareDraft];
}

+ (NSString *)getMessageListFromDraftURL
{
    return [NSString stringWithFormat:@"%@%@",g_restPrefixURL,g_messageListFromDraftURL];
}

+ (NSString *)getMessageDetailURL
{
    return [NSString stringWithFormat:@"%@%@",g_restPrefixURL,g_messageDetailURL];
}

+ (NSString *)getQuestListURL
{
    return [NSString stringWithFormat:@"%@%@",g_restPrefixURL,g_questNewListURL];
}

+ (NSString *)getAnswerListURL
{
    return [NSString stringWithFormat:@"%@%@",g_restPrefixURL,g_answerListURLURL];
}

+ (NSString *)getQuestHotListURL
{
    return [NSString stringWithFormat:@"%@%@",g_restPrefixURL,g_questHotListURL];
}

+ (NSString *)getQuestUnAnswerListURL
{
    return [NSString stringWithFormat:@"%@%@",g_restPrefixURL,g_questUnAnswerListURL];
}

+ (NSString *)getQuestDetailURL
{
    return [NSString stringWithFormat:@"%@%@",g_restPrefixURL,g_questDetailURL];
}

+ (NSString *)getQuestDeleteURL
{
    return [NSString stringWithFormat:@"%@%@",g_restPrefixURL,g_questDeleteURL];
}

+ (NSString *)getAnswerDeleteURL
{
    return [NSString stringWithFormat:@"%@%@",g_restPrefixURL,g_answerDeleteURL];
}

+ (NSString *)getAnswerSolutionURL
{
    return [NSString stringWithFormat:@"%@%@",g_restPrefixURL,g_answerSolutionURL];
}

+ (NSString *)getAnswerPaiserURL
{
    return [NSString stringWithFormat:@"%@%@",g_restPrefixURL,g_answerPaiserURL];
}

+ (NSString *)getAnswerPraiseListURL;
{
    return [NSString stringWithFormat:@"%@%@",g_restPrefixURL,g_answerPraiseList];
}

+ (NSString *)getAllNotifyTypeUnreadNumURL
{
    return [NSString stringWithFormat:@"%@%@",g_restPrefixURL,g_allNotifyTypeUnreadNumURL];
}

+ (NSString *)getMyNotifyListURL
{
    return [NSString stringWithFormat:@"%@%@",g_restPrefixURL,g_myNotifyListURL];
}

+ (NSString *)getGroupNotifyListURL
{
    return [NSString stringWithFormat:@"%@%@",g_restPrefixURL,g_groupNotifyListURL];
}

+ (NSString *)getSetAllNotifyToReadURL
{
    return [NSString stringWithFormat:@"%@%@",g_restPrefixURL,g_setAllNotifyToReadURL];
}

+ (NSString *)getMessageListMyGroupURL
{
    return [NSString stringWithFormat:@"%@%@",g_restPrefixURL,g_messageListMyGroupURL];
}

+ (NSString *)getMessageListMyAllURL
{
    return [NSString stringWithFormat:@"%@%@",g_restPrefixURL,g_messageListMyAllURL];
}

+ (NSString *)getAskUserURL
{
    return [NSString stringWithFormat:@"%@%@",g_restPrefixURL,g_askUserURL];
}

+ (NSString *)getNoticeListURL
{
    return [NSString stringWithFormat:@"%@%@",g_restPrefixURL,g_noticeListURL];
}

+ (NSString *)getCreateAnswerURL
{
    return [NSString stringWithFormat:@"%@%@",g_restPrefixURL,g_createAnswerURL];
}

+ (NSString *)getCreateQuestURL
{
    return [NSString stringWithFormat:@"%@%@",g_restPrefixURL,g_createQuestURL];
}

+ (NSString *)getMyAttentionUserListURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_myAttentionUserListURL];
}

+ (NSString *)getIntegrationSortURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_integrationSortURL];
}

+ (NSString *)getAddAttentionURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_addAttentionURL];
}

+ (NSString *)getCancelAttentionURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_cancelAttentionURL];
}

+ (NSString *)getRegisterUserURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_registerUserURL];
}

+ (NSString *)getSendIdentifyingCodeURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_sendIdentifyingCodeURL];
}

+ (NSString *)getSetNotifyTypeToReadURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_setNotifyTypeToReadURL];
}

+ (NSString *)getSendChangePwdIdentifyingCodeURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_sendChangePwdIdentifyingCodeURL];
}

+ (NSString *)getChangePasswordURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_changePasswordURL];
}

+ (NSString *)getDeleteShareArticleURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_deleteShareArticleURL];
}

+ (NSString *)getSetTheNoticeToReadURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_setTheNoticeToReadURL];
}

+ (NSString *)getSearchShareListURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_searchShareListURL];
}

+ (NSString *)getSearchQAListURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_searchQAListURL];
}

+ (NSString *)getAddCollectionURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_addCollectionURL];
}

+ (NSString *)getCancelCollectionURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_cancelCollectionURL];
}

+ (NSString *)getCollectionBlogURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_collectionBlogURL];
}

+ (NSString *)getCollectionQuestionURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_collectionQuestionURL];
}

+ (NSString *)getDrawLotteryActionURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_drawLotteryActionURL];
}

+ (NSString *)getAllUserListByPageURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_allUserListByPageURL];
}

+ (NSString *)getNoticeNumURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_noticeNumURL];
}

+ (NSString *)getActivityListURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_activityListURL];
}

+ (NSString *)getActivityProjectListURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_activityProjectListURL];
}

+ (NSString *)getSignupActivityProjectURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_signupActivityProjectURL];
}

+ (NSString *)getActivityProjectUserListURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_activityProjectUserListURL];
}

+ (NSString *)getActivityProjectByIDURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_activityProjectByIDURL];
}

+ (NSString *)getLogoutActionURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_logoutActionURL];
}

//聊天记录/////////////////////////////////////////////////////////////////////////////////
+ (NSString *)getHistoryChatSessionURL
{
    return [NSString stringWithFormat:@"%@%@",g_chatPrefixURL,g_historyChatSessionURL];
}

+ (NSString *)getSendSingleChatURL
{
    return [NSString stringWithFormat:@"%@%@",g_chatPrefixURL,g_sendSingleChatURL];
}

+ (NSString *)getSingleChatConByCIdURL
{
    return [NSString stringWithFormat:@"%@%@",g_chatPrefixURL,g_singleChatConByCIdURL];
}

+ (NSString *)getHistoryChatUserURL
{
    return [NSString stringWithFormat:@"%@%@",g_chatPrefixURL,g_historyChatUserURL];
}

+ (NSString *)getSendGroupChatURL
{
    return [NSString stringWithFormat:@"%@%@",g_chatPrefixURL,g_sendGroupChatURL];
}

+ (NSString *)getGroupChatConByCIdURL
{
    return [NSString stringWithFormat:@"%@%@", g_chatPrefixURL, g_groupChatConByCId];
}

+ (NSString *)getGroupHistoryChatURL
{
    return [NSString stringWithFormat:@"%@%@", g_chatPrefixURL, g_groupHistoryChatURL];
}

+ (NSString *)getCreateOrUpdateChatDiscussionURL
{
    return [NSString stringWithFormat:@"%@%@", g_chatPrefixURL, g_createOrUpdateChatDiscussionURL];
}

+ (NSString *)getChatGroupInfoURL
{
    return [NSString stringWithFormat:@"%@%@", g_chatPrefixURL, g_chatGroupInfoURL];
}

+ (NSString *)getSetPushSwitchURL
{
    return [NSString stringWithFormat:@"%@%@", g_chatPrefixURL, g_setPushSwitchURL];
}

+ (NSString *)getSetTopChatURL
{
    return [NSString stringWithFormat:@"%@%@", g_chatPrefixURL, g_setTopChatURL];
}

+ (NSString *)getDeleteChatGroupMemberURL
{
    return [NSString stringWithFormat:@"%@%@", g_chatPrefixURL, g_deleteChatGroupMemberURL];
}

+ (NSString *)getSelfExitChatGroupURL
{
    return [NSString stringWithFormat:@"%@%@", g_chatPrefixURL, g_selfExitChatGroupURL];
}

+ (NSString *)getTransferChatGroupAdminURL
{
    return [NSString stringWithFormat:@"%@%@", g_chatPrefixURL, g_transferChatGroupAdminURL];
}

+ (NSString *)getChatSingleInfoURL
{
    return [NSString stringWithFormat:@"%@%@", g_chatPrefixURL, g_chatSingleInfoURL];
}

+ (NSString *)getClearChatRecordURL
{
    return [NSString stringWithFormat:@"%@%@", g_chatPrefixURL, g_clearChatRecordURL];
}

+ (NSString *)getDeleteChatSessionByIDURL
{
    return [NSString stringWithFormat:@"%@%@", g_chatPrefixURL, g_deleteChatSessionByIDURL];
}

+ (NSString *)getRenameChatDiscussionURL
{
    return [NSString stringWithFormat:@"%@%@", g_chatPrefixURL, g_renameChatDiscussionURL];
}

+ (NSString *)getJoinedGroupChatListURL
{
    return [NSString stringWithFormat:@"%@%@", g_chatPrefixURL, g_joinedGroupChatListURL];
}
///////////////////////////////////////////////////////////////////////////////////

+ (NSString *)getBlogCommentListByPageURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_blogCommentListByPageURL];
}

+ (NSString *)getShareInfoURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_shareInfoURL];
}

+ (NSString *)getUserHeaderImageURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_userHeaderImageURL];
}

+ (NSString *)getShareListByTypeAndTagURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_shareListByTypeAndTagURL];
}

+ (NSString *)getLeagueTypeListURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_leagueTypeListURL];
}

+ (NSString *)getInterLeagueListURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_interLeagueListURL];
}

+ (NSString *)getChinaLeagueListURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_chinaLeagueListURL];
}

+ (NSString *)getMyLeagueListURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_myLeagueListURL];
}

+ (NSString *)getCommitLeagueURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_commitLeagueURL];
}

+ (NSString *)getPraiseShareCommentURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_praiseShareCommentURL];
}

+ (NSString *)getPraiseActivityCommentURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_praiseActivityCommentURL];
}

+ (NSString *)getQuestionSurveyURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_questionSurveyURL];
}

+ (NSString *)getQuestionListURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_questionListURL];
}

+ (NSString *)getCommitSurveyURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_commitSurveyURL];
}

+ (NSString *)getTagVoListByTypeURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_tagVoListByTypeURL];
}

+ (NSString *)getSignupMeetingURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_signupMeetingURL];
}

+ (NSString *)getCommitSuggestionURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_commitSuggestionURL];
}

+ (NSString *)getSuggestionListURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_suggestionListURL];
}

+ (NSString *)getSuggestionBaseDataListURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_suggestionBaseDataListURL];
}

+ (NSString *)getSuggestionDetailURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_suggestionDetailURL];
}

+ (NSString *)getCommitSuggestionReviewURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_commitSuggestionReviewURL];
}

+ (NSString *)getIntegrationListURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_integrationListURL];
}

+ (NSString *)getSignInByDayURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_signInByDayURL];
}

+ (NSString *)getIntegrationOperationURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_integrationOperationURL];
}

+ (NSString *)getIntegralByShareToThirdURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_integralByShareToThirdURL];
}

//Ngnix 服务
+ (NSString *)getShareLotteryURL
{
    return [NSString stringWithFormat:@"%@%@", g_nginxPrefixURL, g_shareLotteryURL];
}

+ (NSString *)getCompanyUserByTrueNameURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_companyUserByTrueNameURL];
}

+ (NSString *)getHotUserListURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_hotUserListURL];
}

+ (NSString *)getSelfRankUserListURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_selfRankUserListURL];
}

+ (NSString *)getNotifyListByTypeURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_notifyListByTypeURL];
}

+ (NSString *)getCompanyRankingListURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_companyRankingListURL];
}

+ (NSString *)getFansListURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_fansListURL];
}

+ (NSString *)getMeetingPlaceListURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_meetingPlaceListURL];
}

+ (NSString *)getMeetingRoomListByPlaceURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_meetingRoomListByPlaceURL];
}

+ (NSString *)getCancelReserveMeetingRoomURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_cancelReserveMeetingRoomURL];
}

+ (NSString *)getReserveMeetingRoomURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_reserveMeetingRoomURL];
}

+ (NSString *)getMeetingRoomDetailURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_meetingRoomDetailURL];
}

+ (NSString *)getMyReserveMeetingListURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_myReserveMeetingListURL];
}

+ (NSString *)getUploadWeixinCardPhotoURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_uploadWeixinCardPhotoURL];
}

+ (NSString *)getShareWeixinCardImageURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_shareWeixinCardImage];
}

+ (NSString *)getMeetingRoomListByParameterURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_meetingRoomListByParameterURL];
}

+ (NSString *)getPraiseShareBlogURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_praiseShareBlogURL];
}

+ (NSString *)getTopShareListURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_topShareListURL];
}

+ (NSString *)getBlogListByTypeURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_blogListByTypeURL];
}

+ (NSString *)getAttentionShareListURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_attentionShareListURL];
}

+ (NSString *)getShieldUserByIdURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_shieldUserByIdURL];
}

+ (NSString *)getReportUserURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_reportUserURL];
}

+ (NSString *)getDictionaryConfigDataURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_dictionaryConfigDataURL];
}

+ (NSString *)getRestoreShieldUserByIdURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_restoreShieldUserByIdURL];
}

+ (NSString *)getShieldUserListURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_shieldUserListURL];
}

+ (NSString *)getSharePraiseListURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_sharePraiseListURL];
}

+ (NSString *)getBetListURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_betListURL];
}

+ (NSString *)getLoginToCheXiangServerURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_loginToCheXiangServerURL];
}

+ (NSString *)getUnbindCheXiangAccountURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_unbindCheXiangAccountURL];
}

+ (NSString *)getHomeActivityListURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_homeActivityListURL];
}

+ (NSString *)getActivityDetailURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_activityDetailURL];
}

+ (NSString *)getActivityUserListURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_activityUserListURL];
}

+ (NSString *)getActivityPraiseListURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_activityPraiseListURL];
}

+ (NSString *)getActivityCommentListByPageURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_activityCommentListByPageURL];
}

+ (NSString *)getActivityCreateCommentURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_activityCreateCommentURL];
}

+ (NSString *)getRecommendAttentionUserListURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_recommendAttentionUserListURL];
}

+ (NSString *)getVerifyCheXiangAccountURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_verifyCheXiangAccountURL];
}

+ (NSString *)getMyJobListURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_myJobListURL];
}

+ (NSString *)getRemainJobListURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_remainJobListURL];
}

+ (NSString *)getAddJobURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_addJobURL];
}

+ (NSString *)getRemoveJobURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_removeJobURL];
}

+ (NSString *)getHomeSearchDataURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_homeSearchDataURL];
}

+ (NSString *)getSetNoticeToReadByTypeURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_setNoticeToReadByTypeURL];
}

+ (NSString *)getDeleteNoticeByIDURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_deleteNoticeByIDURLURL];
}

+(NSString *)getCheckLoginPhoneServerURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_checkLoginNameURL];
}
+(NSString *)getPhoneCodeServerURL
{
    return [NSString stringWithFormat:@"%@%@",g_restPrefixURL,g_getPhoneCodeURL];
}
+ (NSString *)getDeleteNoticeByTypeURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_deleteNoticeByTypeURLURL];
}

+ (NSString *)getUpdatePushSwitchSettingURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_updatePushSwitchSettingURL];
}

+ (NSString *)getPushSwitchSettingListURL
{
    return [NSString stringWithFormat:@"%@%@", g_restPrefixURL, g_pushSwitchSettingListURL];
}

@end