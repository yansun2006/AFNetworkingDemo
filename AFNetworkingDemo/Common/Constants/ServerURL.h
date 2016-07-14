//
//  ServerURL.h
//  CorpKnowlGroup
//
//  Created by yuson on 11-8-12.
//  Copyright 2011 DNE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerURL : NSObject

+ (NSString *)getServerURL;
+ (NSString *)getChatServerURL;
+ (NSString *)getWholeURL:(NSString *)strURL;
+ (NSString *)getUploadFileURL;

+ (NSString *)getFormUploadFileURL;
+ (NSString *)getVersionUpdateURL;
+ (void)setVersionUpdateURL:(NSString*)strUpdateAppURL;

+ (NSString *)getFormatChatSessionID;
+ (NSString *)getLoginToRESTServerURL;
+ (NSString *)getLogoutActionURL;
+ (NSString *)getAllCompanyListURL;
+ (NSString *)getLoginInfoURL;
+ (NSString *)getMessageListPersonalURL;
+ (NSString *)getMessageListFromMeURL;
+ (NSString *)getSessionMsgListURL;
+ (NSString *)getEditUserPasswordURL;
+ (NSString *)getUserDetailURL;
+ (NSString *)getSyncAllMemberURL;
+ (NSString *)getEditUserInfoURL;
+ (NSString *)getAllGroupListURL;
+ (NSString *)getCreateGroupURL;
+ (NSString *)getEditGroupURL;
+ (NSString *)getDismissGroupURL;
+ (NSString *)getTransferGroupURL;
+ (NSString *)getJoinGroupURL;
+ (NSString *)getExitGroupURL;
+ (NSString *)getPublishMsgURL;
+ (NSString *)getDeleteMessageURL;
+ (NSString *)getShareBlog;
+ (NSString *)getShareDetailBlog;
+ (NSString *)getSharePaiserBlog;
+ (NSString *)getCommentListBlog;
+ (NSString *)getCreateComment;
+ (NSString *)getDeleteComment;
+ (NSString *)getOperateVoteURL;
+ (NSString *)getOperateScheduleURL;
+ (NSString *)getAddTagToMessageURL;
+ (NSString *)getRemoveTagFromMessageURL;
+ (NSString *)getCreateAlbumFolderURL;
+ (NSString *)getModifyAlbumFolderURL;
+ (NSString *)getRemoveAlbumFolderURL;
+ (NSString *)getMyAlbumFolderInfoURL;
+ (NSString *)getPublicAlbumFolderInfoURL;
+ (NSString *)getGroupAlbumFolderInfoURL;
+ (NSString *)getImageFolderFromIDURL;
+ (NSString *)getAddImageIntoFolderURL;
+ (NSString *)getAddImagesIntoFolderURL;
+ (NSString *)getRemoveImageFromFolderURL;
+ (NSString *)getRemoveImagesFromFolderURL;
+ (NSString *)getCopyImageToPublicURL;
+ (NSString *)getAddImageCommentURL;
+ (NSString *)getQueryImagePraiseURL;
+ (NSString *)getQueryImageDetailInfoURL;
+ (NSString *)getPraiseImageURL;
+ (NSString *)getSearchMessageListURL;
+ (NSString *)getPublishShare;
+ (NSString *)getShareDraft;
+ (NSString *)getMessageListFromDraftURL;
+ (NSString *)getMessageDetailURL;
//问答////////////////////////////////////////////////////////////////////////////////
+ (NSString *)getAnswerListURL;
+ (NSString *)getQuestListURL;
+ (NSString *)getQuestHotListURL;
+ (NSString *)getQuestUnAnswerListURL;
+ (NSString *)getQuestDetailURL;
+ (NSString *)getQuestDeleteURL;
+ (NSString *)getAnswerDeleteURL;
+ (NSString *)getAnswerSolutionURL;
+ (NSString *)getAnswerPaiserURL;
+ (NSString *)getAnswerPraiseListURL;
////////////////////////////////////////////////////////////////////////////////
+ (NSString *)getAllNotifyTypeUnreadNumURL;
+ (NSString *)getMyNotifyListURL;
+ (NSString *)getGroupNotifyListURL;
+ (NSString *)getSetAllNotifyToReadURL;
+ (NSString *)getMessageListMyGroupURL;
+ (NSString *)getMessageListMyAllURL;
+ (NSString *)getAskUserURL;
+ (NSString *)getNoticeListURL;
+ (NSString *)getCreateAnswerURL;
+ (NSString *)getCreateQuestURL;
+ (NSString *)getMyAttentionUserListURL;
+ (NSString *)getIntegrationSortURL;
+ (NSString *)getAddAttentionURL;
+ (NSString *)getCancelAttentionURL;
+ (NSString *)getSendIdentifyingCodeURL;
+ (NSString *)getRegisterUserURL;
+ (NSString *)getSetNotifyTypeToReadURL;
+ (NSString *)getSendChangePwdIdentifyingCodeURL;
+ (NSString *)getChangePasswordURL;
+ (NSString *)getDeleteShareArticleURL;
+ (NSString *)getSetTheNoticeToReadURL;
+ (NSString *)getSearchShareListURL;
+ (NSString *)getSearchQAListURL;
+ (NSString *)getAddCollectionURL;
+ (NSString *)getCancelCollectionURL;
+ (NSString *)getCollectionBlogURL;
+ (NSString *)getCollectionQuestionURL;
+ (NSString *)getDrawLotteryActionURL;
+ (NSString *)getAllUserListByPageURL;
+ (NSString *)getNoticeNumURL;
+ (NSString *)getActivityListURL;
+ (NSString *)getActivityProjectListURL;
+ (NSString *)getSignupActivityProjectURL;
+ (NSString *)getActivityProjectUserListURL;
+ (NSString *)getActivityProjectByIDURL;
+ (NSString *)getBlogCommentListByPageURL;
+ (NSString *)getShareListByTypeAndTagURL;

//聊天记录/////////////////////////////////////////////////////////////////////////////////
+ (NSString *)getHistoryChatSessionURL;
+ (NSString *)getSendSingleChatURL;
+ (NSString *)getSingleChatConByCIdURL;
+ (NSString *)getHistoryChatUserURL;
+ (NSString *)getSendGroupChatURL;
+ (NSString *)getGroupChatConByCIdURL;
+ (NSString *)getGroupHistoryChatURL;
+ (NSString *)getCreateOrUpdateChatDiscussionURL;
+ (NSString *)getChatGroupInfoURL;
+ (NSString *)getSetPushSwitchURL;
+ (NSString *)getSetTopChatURL;
+ (NSString *)getDeleteChatGroupMemberURL;
+ (NSString *)getSelfExitChatGroupURL;
+ (NSString *)getTransferChatGroupAdminURL;
+ (NSString *)getChatSingleInfoURL;
+ (NSString *)getClearChatRecordURL;
+ (NSString *)getDeleteChatSessionByIDURL;
+ (NSString *)getRenameChatDiscussionURL;
+ (NSString *)getJoinedGroupChatListURL;
///////////////////////////////////////////////////////////////////////////////////
+ (NSString *)getShareInfoURL;
+ (NSString *)getUserHeaderImageURL;
+ (NSString *)getLeagueTypeListURL;
+ (NSString *)getInterLeagueListURL;
+ (NSString *)getChinaLeagueListURL;
+ (NSString *)getMyLeagueListURL;
+ (NSString *)getCommitLeagueURL;
+ (NSString *)getPraiseShareCommentURL;
+ (NSString *)getQuestionSurveyURL;
+ (NSString *)getQuestionListURL;
+ (NSString *)getCommitSurveyURL;
+ (NSString *)getTagVoListByTypeURL;
+ (NSString *)getSignupMeetingURL;
+ (NSString *)getCommitSuggestionURL;
+ (NSString *)getSuggestionListURL;
+ (NSString *)getSuggestionBaseDataListURL;
+ (NSString *)getSuggestionDetailURL;
+ (NSString *)getCommitSuggestionReviewURL;
+ (NSString *)getIntegrationListURL;
+ (NSString *)getSignInByDayURL;
+ (NSString *)getIntegrationOperationURL;
+ (NSString *)getIntegralByShareToThirdURL;
+ (NSString *)getShareLotteryURL;
+ (NSString *)getCompanyUserByTrueNameURL;
+ (NSString *)getHotUserListURL;
+ (NSString *)getSelfRankUserListURL;
+ (NSString *)getNotifyListByTypeURL;
+ (NSString *)getCompanyRankingListURL;
+ (NSString *)getFansListURL;

+ (NSString *)getMeetingPlaceListURL;
+ (NSString *)getMeetingRoomListByPlaceURL;
+ (NSString *)getCancelReserveMeetingRoomURL;
+ (NSString *)getReserveMeetingRoomURL;
+ (NSString *)getMeetingRoomDetailURL;
+ (NSString *)getMyReserveMeetingListURL;
+ (NSString *)getUploadWeixinCardPhotoURL;
+ (NSString *)getShareWeixinCardImageURL;
+ (NSString *)getMeetingRoomListByParameterURL;
+ (NSString *)getPraiseShareBlogURL;
+ (NSString *)getTopShareListURL;
+ (NSString *)getBlogListByTypeURL;
+ (NSString *)getAttentionShareListURL;
+ (NSString *)getShieldUserByIdURL;
+ (NSString *)getReportUserURL;
+ (NSString *)getDictionaryConfigDataURL;
+ (NSString *)getRestoreShieldUserByIdURL;
+ (NSString *)getShieldUserListURL;
+ (NSString *)getSharePraiseListURL;
+ (NSString *)getBetListURL;
+ (NSString *)getLoginToCheXiangServerURL;
+ (NSString *)getUnbindCheXiangAccountURL;
+ (NSString *)getHomeActivityListURL;
+ (NSString *)getActivityDetailURL;
+ (NSString *)getActivityUserListURL;
+ (NSString *)getActivityPraiseListURL;
+ (NSString *)getActivityCommentListByPageURL;
+ (NSString *)getActivityPraiseActionURL;
+ (NSString *)getPraiseActivityCommentURL;
+ (NSString *)getDeleteActivityCommentURL;
+ (NSString *)getActivityCreateCommentURL;
+ (NSString *)getRecommendAttentionUserListURL;
+ (NSString *)getVerifyCheXiangAccountURL;
+ (NSString *)getMyJobListURL;
+ (NSString *)getRemainJobListURL;
+ (NSString *)getAddJobURL;
+ (NSString *)getRemoveJobURL;
+ (NSString *)getHomeSearchDataURL;
+ (NSString *)getSetNoticeToReadByTypeURL;
+ (NSString *)getDeleteNoticeByIDURL;
+ (NSString *)getDeleteNoticeByTypeURL;
+ (NSString *)getCheckLoginPhoneServerURL;
+ (NSString *)getPhoneCodeServerURL;
+ (NSString *)getUpdatePushSwitchSettingURL;
+ (NSString *)getPushSwitchSettingListURL;

@end