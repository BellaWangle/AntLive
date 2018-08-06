//
//  commentview.m
//  iphoneLive
//
//  Created by 王敏欣 on 2017/8/5.
//  Copyright © 2017年 cat. All rights reserved.
//
#import "commentview.h"
#import "commentcell.h"
#import "commentModel.h"
#import <MJRefresh/MJRefresh.h>
@interface commentview ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UITextFieldDelegate,pushCommetnDetails>
{
    int count;//下拉次数
    MJRefreshAutoNormalFooter *footer;
    int ispush;
    UILabel *allCommentLabels;//显示全部评论
    BOOL isReply;//判断是否是回复
    UILabel *tableviewLine;
    UIView *tableheader;
    UIButton *finish;
    CGFloat _oldOffset;
}
@property(nonatomic,copy)NSString *videoid;//视频id
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)UITextField *textfield;//评论框
@property(nonatomic,strong)UIView *toolBar;//评论困底部view
@property(nonatomic,strong)NSMutableArray *itemsarray;//评论列表
@property(nonatomic,strong)NSMutableArray *modelarray;//评论模型
@property(nonatomic,copy)NSString *parentid;//回复的评论ID
@property(nonatomic,copy)NSString *commentid;//回复的评论commentid
@property(nonatomic,copy)NSString *touid;//回复的评论UID
@property(nonatomic,copy)NSString *hostid;//发布视频的人的id
@end
@implementation commentview
-(void)dealloc{
    NSLog(@"dealloc");
}
-(NSMutableArray *)modelarray{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in _itemsarray) {
        commentModel *model = [commentModel modelWithDic:dic];
        [model setmyframe:[_modelarray lastObject]];
        [array addObject:model];
    }
    _modelarray = array;
    return _modelarray;
}
//每次点击 获取最新评论列表
-(void)reloaddata{
    
    count+=1;
    _textfield.text = @"";
    _textfield.placeholder = YZMsg(@"说点什么。。");
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *url = [purl stringByAppendingFormat:@"service=Video.getComments&videoid=%@&p=%d&uid=%@",_videoid,count,[Config getOwnID]];
    [session POST:url parameters:nil
         progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
             NSNumber *number = [responseObject valueForKey:@"ret"] ;
             if([number isEqualToNumber:[NSNumber numberWithInt:200]])
             {
                 NSArray *data = [responseObject valueForKey:@"data"];
                 NSNumber *code = [data valueForKey:@"code"];
                 if([code isEqualToNumber:[NSNumber numberWithInt:0]])
                 {
                     NSDictionary *info = [[data valueForKey:@"info"] firstObject];
                     NSArray *commentlist = [info valueForKey:@"commentlist"];
            
                     int allcomments = [[NSString stringWithFormat:@"%@",[info valueForKey:@"comments"]] intValue];
                     allCommentLabels.text = [NSString stringWithFormat:@"%@(%d)",YZMsg(@"全部评论"),allcomments];
                     self.talkCount([NSString stringWithFormat:@"%@",[info valueForKey:@"comments"]] );
                     [_itemsarray addObjectsFromArray:commentlist];
                     [_tableview reloadData];

                 }
             }
              [self.tableview.mj_footer endRefreshing];
         }
          failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         [self.tableview.mj_footer endRefreshing];
     }];
    
    
}
-(instancetype)initWithFrame:(CGRect)frame hide:(commectblock)hide andvideoid:(NSString *)videoid andhostid:(NSString *)hostids count:(int)allcomments talkCount:(commectblock)talk detail:(commectblock)detail{
    self = [super initWithFrame:frame];
    if (self) {
        _oldOffset = 0;
         ispush = 0;//判断发消息的时候 数组滚动最上面
         count = 0;//上拉加载次数
        _parentid = @"0";
        _commentid = @"0";
        isReply = NO;//判断回复
        self.talkCount = talk;
        self.hide = hide;//点击隐藏事件
        _videoid = videoid;//获取视频id
        _hostid = hostids;
        _touid = hostids;
        _pushDetail = detail;
        _itemsarray = [NSMutableArray array];
        _modelarray = [NSMutableArray array];
        
        
        
        _toolBar = [[UIView alloc]initWithFrame:CGRectMake(0,_window_height - 50-statusbarHeight, _window_width, 50+statusbarHeight)];
        _toolBar.backgroundColor = RGB(248, 248, 248);
        
        
        
        //_toolBar顶部横线 和 顶部 view分割开
        UILabel *lineso = [[UILabel alloc]initWithFrame:CGRectMake(0,0,_window_width,1)];
        lineso.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [_toolBar addSubview:lineso];
        
        
        
        //设置输入框
        UIView *vcss  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        vcss.backgroundColor = [UIColor clearColor];
        _textfield = [[UITextField alloc]initWithFrame:CGRectMake(10,8, _window_width - 100, 34)];
        _textfield.backgroundColor = [UIColor whiteColor];
        _textfield.layer.masksToBounds = YES;
        _textfield.layer.cornerRadius = 17;
        _textfield.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
        _textfield.layer.borderWidth = 1.0;
        _textfield.placeholder = YZMsg(@"说点什么。。");
        _textfield.delegate = self;
        _textfield.returnKeyType = UIReturnKeyDone;
        [_toolBar addSubview:_textfield];
        _textfield.leftViewMode = UITextFieldViewModeAlways;
        _textfield.leftView = vcss;
        [_textfield addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        
        
        
        //发送按钮
        finish = [UIButton buttonWithType:0];
        finish.frame = CGRectMake(_window_width - 80,8,70,34);
        [finish setImage:[UIImage imageNamed:getImagename(@"发送按钮_无文字")] forState:0];
        [finish addTarget:self action:@selector(pushmessage) forControlEvents:UIControlEventTouchUpInside];
        [_toolBar addSubview:finish];
        
        
        
        tableheader = [[UIView alloc]initWithFrame:CGRectMake(0, _window_height*0.3 , _window_width,50)];
        tableheader.layer.masksToBounds = YES;
        tableheader.layer.cornerRadius = 10;
        tableheader.backgroundColor = RGB(248, 248, 248);
        
        
        
        //显示评论的数量
        allCommentLabels = [[UILabel alloc]initWithFrame:CGRectMake(20,0,_window_width/2,50)];
        allCommentLabels.textColor = RGB(123, 123, 123);;
        allCommentLabels.text = [NSString stringWithFormat:@"%@(%d)",YZMsg(@"全部评论"),allcomments];
        allCommentLabels.font = [UIFont systemFontOfSize:18];
        [tableheader addSubview:allCommentLabels];
        
        
        
        //关闭按钮
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(_window_width - 45,5,40,40);
        btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        btn.imageEdgeInsets = UIEdgeInsetsMake(10,10,10,10);
        [btn setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(hideself) forControlEvents:UIControlEventTouchUpInside];
        [tableheader addSubview:btn];
        
        
        
        //tableview顶部横线 和 顶部 view分割开
        UILabel *liness = [[UILabel alloc]initWithFrame:CGRectMake(0,49,_window_width,1)];
        liness.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [tableheader addSubview:liness];
        
        
        
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, _window_height*0.3 + 50, _window_width, _window_height*0.7 - 84-statusbarHeight)];
        _tableview.delegate   = self;
        _tableview.dataSource = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.backgroundColor = RGB(248, 248, 248);
        _tableview.layer.masksToBounds = YES;
        _tableview.layer.cornerRadius = 10;
        [self addSubview:_tableview];
        [self addSubview:_toolBar];
        
        
        
        //tableview顶部横线 和 顶部 view分割开
        tableviewLine = [[UILabel alloc]initWithFrame:CGRectMake(0, _window_height*0.3 + 49,_window_width,1)];
        tableviewLine.backgroundColor = [UIColor colorWithRed:198/255.0 green:198/255.0 blue:198/255.0 alpha:1];
        //[self addSubview:tableviewLine];
        
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
        
        
        [self reloaddata];
        footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(reloaddata)];
        self.tableview.mj_footer = footer;
        [footer setTitle:YZMsg(@"正在加载更多的数据...") forState:MJRefreshStateRefreshing];
        [footer setTitle:YZMsg(@"已经全部加载完毕") forState:MJRefreshStateIdle];
        footer.stateLabel.font = [UIFont systemFontOfSize:15.0f];
        footer.automaticallyHidden = YES;
        //commectdetails 页面传过来的 点赞
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload:) name:@"likesnums" object:nil];
        //commectdetails 页面传过来的 回复总数
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadcomments:) name:@"commentnums" object:nil];
    }
    return self;
}
//监听textfield
-(void)textFieldDidChange :(UITextField *)theTextField{
    NSLog( @"text changed: %@", theTextField.text);
    if (theTextField.text.length == 0) {
        [finish setImage:[UIImage imageNamed:getImagename(@"发送按钮_无文字")] forState:0];
    }
    else{
        [finish setImage:[UIImage imageNamed:@"发送按钮_有文字"] forState:0];
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self pushmessage];
    return YES;
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self hideself];
}
-(void)hideself{
    self.hide(@"1");
    [self endEditing:YES];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     [self.tableview deselectRowAtIndexPath:indexPath animated:NO];
    NSDictionary *subdic = _itemsarray[indexPath.row];
    _touid = [NSString stringWithFormat:@"%@",[subdic valueForKey:@"uid"]];
    if ([_touid isEqual:[Config getOwnID]]) {
        
        
        return;
    }

    [_textfield becomeFirstResponder];
    NSDictionary *userinfo = [subdic valueForKey:@"userinfo"];
    NSString *path = [NSString stringWithFormat:@"%@:%@",YZMsg(@"回复"),[userinfo valueForKey:@"user_nicename"]];
    _textfield.placeholder = path;
    _parentid = [NSString stringWithFormat:@"%@",[subdic valueForKey:@"id"]];
    _commentid = [NSString stringWithFormat:@"%@",[subdic valueForKey:@"commentid"]];
    isReply = YES;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    commentModel *model = _modelarray[indexPath.row];
    return model.rowH;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.modelarray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableview deselectRowAtIndexPath:indexPath animated:NO];
    commentcell *cell = [commentcell cellWithtableView:tableView];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone]; 
    cell.delegate = self;
    cell.model = _modelarray[indexPath.row];
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return tableheader;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}
//刷新评论数量
-(void)getNewCount:(int)counts{
     allCommentLabels.text = [NSString stringWithFormat:@"%@(%d)",YZMsg(@"全部评论"),counts];
}
-(void)reloadcomments:(NSNotification *)ns{
    NSDictionary *subdicsss = [ns userInfo];
    //904
    BOOL isLike = NO;
    int numbers;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (int i=0; i<_itemsarray.count; i++) {
        NSDictionary *subdic = _itemsarray[i];
        NSString *parentid = [NSString stringWithFormat:@"%@",[subdic valueForKey:@"id"]];
        NSString *myparentid = [NSString stringWithFormat:@"%@",[subdicsss valueForKey:@"commentid"]];
        if ([parentid isEqual:myparentid]) {
            dic = [NSMutableDictionary dictionaryWithDictionary:subdic];
            numbers = i;
            isLike = YES;
            break;
        }
    }
    if (isLike == YES) {
        [_itemsarray removeObject:dic];
        [dic setObject:[subdicsss valueForKey:@"commentnums"] forKey:@"replys"];
        [_itemsarray insertObject:dic atIndex:(NSInteger)numbers];
        [self.tableview reloadData];
    }
    
    
}
-(void)pushmessage{
    /*
     parentid  回复的评论ID
     commentid 回复的评论commentid
     touid     回复的评论UID
     如果只是评论 这三个传0
     */
    if (_textfield.text.length == 0) {
        [MBProgressHUD showError:YZMsg(@"请添加内容后再尝试")];
        return;
    }
     NSString *sendtouid = [NSString stringWithFormat:@"%@",_touid];
     NSString *sendcommentid = [NSString stringWithFormat:@"%@",_commentid];
     NSString *sendparentid = [NSString stringWithFormat:@"%@",_parentid];
     NSString *path = [NSString stringWithFormat:@"%@",_textfield.text];
    
    [self hideself];
    [self endEditing:YES];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *url = [purl stringByAppendingFormat:@"service=Video.setComment&videoid=%@&content=%@&uid=%@&token=%@&touid=%@&commentid=%@&parentid=%@",_videoid,path,[Config getOwnID],[Config getOwnToken],sendtouid,sendcommentid,sendparentid];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [session POST:url parameters:nil
         progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
             NSNumber *number = [responseObject valueForKey:@"ret"] ;
             NSArray *data = [responseObject valueForKey:@"data"];
             NSNumber *code = [data valueForKey:@"code"];
             if([number isEqualToNumber:[NSNumber numberWithInt:200]])
             {
         if([code isEqualToNumber:[NSNumber numberWithInt:0]])
          {
                     NSDictionary *info = [[data valueForKey:@"info"] firstObject];
                     //刷新评论数
                    int allcomments = [[NSString stringWithFormat:@"%@",[info valueForKey:@"comments"]] intValue];
                    allCommentLabels.text = [NSString stringWithFormat:@"%@(%d)",YZMsg(@"全部评论"),allcomments];
                    self.talkCount([NSString stringWithFormat:@"%@",[info valueForKey:@"comments"]] );
                    NSString *t2u = [NSString stringWithFormat:@"%@",[info valueForKey:@"t2u"]];//对方是否拉黑我
                if ([t2u isEqual:@"0"]) {
                         [MBProgressHUD showSuccess:minstr([data valueForKey:@"msg"])];
                         count = 0;
                         _itemsarray = nil;
                         _itemsarray = [NSMutableArray array];
                        //如果是回复 就发送 私信
                        if (![sendtouid isEqual:[Config getOwnID]]) {
                            NSString *sixincontent;
                            if (isReply) {
                                isReply = NO;
                                sixincontent = [NSString stringWithFormat:@"%@:%@",YZMsg(@"回复"),path];
                            }else{
                                sixincontent = [NSString stringWithFormat:@"%@:%@",YZMsg(@"评论"),path];
                            }
                            [JMSGConversation createSingleConversationWithUsername:_hostid completionHandler:^(id resultObject, NSError *error) {
                                JMSGConversation *msgConversation = resultObject;
                                JMSGMessage *message = nil;
                                JMSGOptionalContent *option = [[JMSGOptionalContent alloc]init];
                                option.noSaveNotification = YES;
                                JMSGTextContent *textContent = [[JMSGTextContent alloc] initWithText:sixincontent];
                                //添加附加字段
                                [textContent addStringExtra:[Config getavatar] forKey:@"avatar"];
                                message = [msgConversation createMessageWithContent:textContent];
                                [msgConversation sendMessage:message optionalContent:option];
                            }];
            }
            else{
                if (![sendtouid isEqual:[Config getOwnID]]) {
                    [MBProgressHUD showError:YZMsg(@"对方暂时拒绝接收您的消息")];
                }
            }
                }
          }
        }
    else{
        [MBProgressHUD showError:minstr([data valueForKey:@"msg"])];
    }
}
          failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         
     }];
             
}
#pragma mark -- 获取键盘高度
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat height = keyboardRect.origin.y;
    CGFloat yyyy = keyboardRect.size.height;
    _toolBar.frame = CGRectMake(0, height - 50, _window_width, 50);
    self.tableview.frame = CGRectMake(0, _window_height*0.3 + 50 - yyyy/2, _window_width, _window_height*0.7 - 84-statusbarHeight);
}
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    [UIView animateWithDuration:0.1 animations:^{
       _toolBar.frame = CGRectMake(0, _window_height - 50-statusbarHeight, _window_width, 50+statusbarHeight);
    }];
    _textfield.text = @"";
    _textfield.placeholder = YZMsg(@"说点什么。。");
    //论完后 把状态清零
    _touid = _hostid;
    _parentid = @"0";
    _commentid = @"0";
    self.tableview.frame = CGRectMake(0, _window_height*0.3 + 50, _window_width, _window_height*0.7 - 84-statusbarHeight);
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    

    
    [_textfield resignFirstResponder];
}

#pragma mark cell代理方法
//这个地方找到点赞的字典，在数组中删除再重新插入 处理点赞
-(void)makeLikeRloadList:(NSString *)commectid andLikes:(NSString *)likes islike:(NSString *)islike{

    BOOL isLike = NO;
    int numbers;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (int i=0; i<_itemsarray.count; i++) {
        NSDictionary *subdic = _itemsarray[i];
        NSString *parentid = [NSString stringWithFormat:@"%@",[subdic valueForKey:@"id"]];
        
        if ([parentid isEqual:commectid]) {
            
            dic = [NSMutableDictionary dictionaryWithDictionary:subdic];
            
            numbers = i;
            
            isLike = YES;
            
            break;
        }
    }
    if (isLike == YES) {
          [_itemsarray removeObject:dic];
          [dic setObject:likes forKey:@"likes"];
          [dic setObject:islike forKey:@"islike"];
          [_itemsarray insertObject:dic atIndex:(NSInteger)numbers];
        [self.tableview reloadData];
    }
}
-(void)reload:(NSNotification *)ns{
    NSDictionary *subdicsss = [ns userInfo];
    //904
    BOOL isLike = NO;
    int numbers;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (int i=0; i<_itemsarray.count; i++) {
        NSDictionary *subdic = _itemsarray[i];
        NSString *parentid = [NSString stringWithFormat:@"%@",[subdic valueForKey:@"id"]];
        NSString *myparentid = [NSString stringWithFormat:@"%@",[subdicsss valueForKey:@"commentid"]];
        if ([parentid isEqual:myparentid]) {
            dic = [NSMutableDictionary dictionaryWithDictionary:subdic];
            numbers = i;
            isLike = YES;
            break;
        }
    }
    if (isLike == YES) {
        [_itemsarray removeObject:dic];
        [dic setObject:[subdicsss valueForKey:@"likes"] forKey:@"likes"];
        [dic setObject:@"1" forKey:@"islike"];
        [_itemsarray insertObject:dic atIndex:(NSInteger)numbers];
        [self.tableview reloadData];
    }
}
-(void)pushDetails:(NSDictionary *)commentdic{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:commentdic];
    [dic setObject:_videoid forKey:@"videoid"];
    
    self.pushDetail(dic);
}
@end
