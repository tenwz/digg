//
//  SLCommentFeedEntity.h
//  digg
//
//  Created by hey on 2024/10/18.
//

#import <Foundation/Foundation.h>


@interface SLCommentFeedEntity : NSObject
//{
//"articleId": 9, //⽂章Id
//"commentId": 4, //评论Id
//"title": "杂志之死", //⽂章标题
//"url": "https://news.ycombinator.com/item?id=41547773", //⽂章地址
//"avatar": null, //⽤户的头像
//"username": "blackpaper", //⽤户的昵称
//"gmtCreate": 1728934004000, //⽤户发布评论的时间戳
//"content": "A", //⽤户发布评论的内容
//"articleCommentCnt": 0, //当前⽂章的评论数
//"replyToArticle": true, // 这个评论是不是直接回复⽂章的，false则是回复评
//"replyId": 9, //如果是回复⽂章的，则是articleId，如果是回复评论的则是comm
//"replyUserId": 2, //如果是回复评论的，则是被回复⼈的userId
//"replyUsername": null, //如果是回复评论的，则是被回复⼈的username
//"replyContent": null //如果是回复评论的，则是被回复⼈发表的评论
//}

@property (nonatomic, copy) NSString *articleId;
@property (nonatomic, copy) NSString *commentId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, assign) NSTimeInterval gmtCreate;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) NSInteger articleCommentCnt;
// 这个评论是不是直接回复⽂章的，false则是回复评
@property (nonatomic, assign) BOOL replyToArticle;
//如果是回复⽂章的，则是articleId，如果是回复评论的则是comm
@property (nonatomic, copy) NSString *replyId;
@property (nonatomic, copy) NSString *replyUserId;
@property (nonatomic, copy) NSString *replyUsername;
@property (nonatomic, copy) NSString *replyContent;
@end


