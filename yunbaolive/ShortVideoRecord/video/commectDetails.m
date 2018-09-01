//
//  commectDetails.m
//  iphoneLive
//
//  Created by 王敏欣 on 2017/9/6.
//  Copyright © 2017年 cat. All rights reserved.
//

#import "commectDetails.h"
#import "detailcell.h"
#import "detailmodel.h"
#import <MJRefresh/MJRefresh.h>
#import "detailHead.h"
@interface commectDetails ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,pushCommetnDetails>
{
    UIView *_toolBar;
    UITextField *textField;
    int count;//下拉次数;
    bool isself;
    int ispush;
    bool isselected;
    MJRefreshAutoNormalFooter *footer;
    NSString *commectid;
    NSString *parentid;
    NSString *touid;
    NSString *getlistParentid;
    NSMutableDictionary *topdic;
    detailHead *header;//tableview表头
    CGFloat tableviewHeaderHeight;
    UIButton *finish;
}
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)NSMutableArray *itemsarray;//回复列表
@property(nonatomic,strong)NSMutableArray *modelarray;//回复模型
@end
@implementation commectDetails
-(void)pushDetails:(NSDictionary *)commentdic{
    
    
}
-(NSMutableArray *)modelarray{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in _itemsarray) {
        detailmodel *model = [detailmodel modelWithDic:dic];
        [model setmyframe:[_modelarray lastObject]];
        [array addObject:model];
    }
    _modelarray = array;
    return _modelarray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setHostCommetn];
    tableviewHeaderHeight = 0;
     ispush = 0;//判断发消息的时候 数组滚动最上面
     count = 0;//上拉加载次数
     _itemsarray = [NSMutableArray array];
     _modelarray = [NSMutableArray array];
    
    
    //用于回复
    commectid = [_hostDic valueForKey:@"commentid"];
    parentid  = [_hostDic valueForKey:@"parentid"];
    touid     = [_hostDic valueForKey:@"ID"];
    
    
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = YZMsg(@"查看回复");
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    UIButton *canclebtn = [UIButton buttonWithType:0];
    canclebtn.frame = CGRectMake(0,0,20,20);
    [canclebtn setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
    [canclebtn setImageEdgeInsets:UIEdgeInsetsMake(1,1,1,1)];
    [canclebtn addTarget:self action:@selector(cancle) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:canclebtn];
    
    //设置列表
    [self setTableView];
    //设置发消息框
    [self setToolBar];
    //请求数据
    [self getcommentlist];
        
    header = [[detailHead alloc]init];
    [header justdoit:topdic comment:^(id type) {
        //获取点赞总数
        NSDictionary *subdic = @{
                                 @"commentid":[_hostDic valueForKey:@"parentid"],
                                 @"likes":type,
                                 @"islike":@"1"
                                 };
        [[NSNotificationCenter defaultCenter] postNotificationName:@"likesnums" object:nil userInfo:subdic];        
    }];
    tableviewHeaderHeight = header.contentRect.size.height + 130;
    header.frame = CGRectMake(0, 0, _window_width, tableviewHeaderHeight);
    [self.tableview beginUpdates];
    [self.tableview setTableHeaderView:header];
    [self.tableview setSectionHeaderHeight:tableviewHeaderHeight];
    [self.tableview endUpdates];
    //显示回复总数
    header.allComments.text = [NSString stringWithFormat:@"%@%@(%@)",@"   ",YZMsg(@"全部回复"),[_hostDic valueForKey:@"allcommecnts"]];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)setHostCommetn{
    //设置顶部显示评论内容
    NSDictionary *userinfo = @{
                               @"avatar":[_hostDic valueForKey:@"avatar"],
                               @"user_nicename":[_hostDic valueForKey:@"user_nicename"],
                               };
    topdic = [NSMutableDictionary dictionaryWithDictionary:userinfo];
    [topdic setObject:userinfo forKey:@"userinfo"];
    [topdic setObject:[_hostDic valueForKey:@"likes"] forKey:@"likes"];
    [topdic setObject:[_hostDic valueForKey:@"islike"] forKey:@"islike"];
    [topdic setObject:[_hostDic valueForKey:@"content"] forKey:@"content"];
    [topdic setObject:[_hostDic valueForKey:@"datetime"] forKey:@"datetime"];
    [topdic setObject:[_hostDic valueForKey:@"parentid"] forKey:@"parentid"];
    [topdic setObject:@"0" forKey:@"touid"];
}
-(void)getcommentlist{

        count+=1;
        isselected = NO;
        textField.text = @"";
        textField.placeholder = [NSString stringWithFormat:@"%@%@:",YZMsg(@"回复"),[_hostDic valueForKey:@"user_nicename"]];
        AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
        NSString *url = [purl stringByAppendingFormat:@"service=Video.getReplys&commentid=%@&p=%d&uid=%@",[_hostDic valueForKey:@"parentid"],count,[Config getOwnID]];
        
        [session POST:url parameters:nil
             progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                 NSNumber *number = [responseObject valueForKey:@"ret"] ;
                 if([number isEqualToNumber:[NSNumber numberWithInt:200]])
                 {
                     NSArray *data = [responseObject valueForKey:@"data"];
                     
                     
                     NSNumber *code = [data valueForKey:@"code"];
                     if([code isEqualToNumber:[NSNumber numberWithInt:0]])
                     {
                         NSArray *info = [data valueForKey:@"info"];
                         [_itemsarray addObjectsFromArray:info];
                         [_tableview reloadData];
                         if (ispush == 1) {
                             [_tableview setContentOffset:CGPointMake(0,128) animated:YES];
                             ispush = 0;
                         }
                     }
                 }
                 [self.tableview.mj_footer endRefreshing];
             }
              failure:^(NSURLSessionDataTask *task, NSError *error)
         {
             [self.tableview.mj_footer endRefreshing];
         }];
}
-(void)cancle{
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadcomments" object:nil];
}
-(void)setTableView{
    _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0,0, _window_width, _window_height - 114)];
    _tableview.delegate   = self;
    _tableview.dataSource = self;
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableview.backgroundColor = RGB(248, 248, 248);
    [self.view addSubview:_tableview];
    footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getcommentlist)];
    self.tableview.mj_footer = footer;
    [footer setTitle:YZMsg(@"正在加载更多的数据...") forState:MJRefreshStateRefreshing];
    [footer setTitle:YZMsg(@"已经全部加载完毕") forState:MJRefreshStateIdle];
    footer.stateLabel.font = [UIFont systemFontOfSize:15.0f];
    footer.automaticallyHidden = YES;
}
-(void)setToolBar{
    _toolBar = [[UIView alloc]initWithFrame:CGRectMake(0,_window_height - 114, _window_width,50)];
    _toolBar.backgroundColor = RGB(248, 248, 248);
    [self.view addSubview:_toolBar];
    
    //设置输入框
    UIView *vc  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    vc.backgroundColor = [UIColor clearColor];
    textField = [[UITextField alloc]initWithFrame:CGRectMake(10,8, _window_width - 100, 34)];
    textField.backgroundColor = [UIColor whiteColor];
    textField.layer.masksToBounds = YES;
    textField.layer.cornerRadius = 17;
    textField.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    textField.layer.borderWidth = 1.0;
    textField.placeholder = [NSString stringWithFormat:@"%@%@:",YZMsg(@"回复"),[_hostDic valueForKey:@"user_nicename"]];
    textField.delegate = self;
    textField.returnKeyType = UIReturnKeyDone;
    [_toolBar addSubview:textField];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = vc;
    [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    finish = [UIButton buttonWithType:0];
    finish.frame = CGRectMake(_window_width - 80,8,70,34);
    [finish setImage:[UIImage imageNamed:getImagename(@"发送按钮_无文字")] forState:0];

    [finish addTarget:self action:@selector(pushmessage) forControlEvents:UIControlEventTouchUpInside];
    [_toolBar addSubview:finish];
    
    //键盘监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}
//监听textfield
-(void)textFieldDidChange :(UITextField *)theTextField{
    NSLog( @"text changed: %@", theTextField.text);
    if (theTextField.text.length == 0) {
        [finish setImage:[UIImage imageNamed:getImagename(@"发送按钮_无文字")] forState:0];
    }
    else{
        [finish setImage:[UIImage imageNamed:getImagename(@"发送按钮_有文字")] forState:0];
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableview deselectRowAtIndexPath:indexPath animated:NO];
    detailcell *cell = [detailcell cellWithtableView:tableView];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.model = _modelarray[indexPath.row];
    cell.delegate = self;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    detailmodel *model = _modelarray[indexPath.row];
    return model.rowH;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.modelarray.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        [self.tableview deselectRowAtIndexPath:indexPath animated:NO];
        NSDictionary *subdic = _itemsarray[indexPath.row];
    
        touid = [NSString stringWithFormat:@"%@",[subdic valueForKey:@"uid"]];
    
       textField.placeholder = [NSString stringWithFormat:@"%@%@:",YZMsg(@"回复"),[[subdic valueForKey:@"userinfo"] valueForKey:@"user_nicename"]];

        if ([touid isEqual:[Config getOwnID]]) {
        
        
         return;
        }
        [textField becomeFirstResponder];
        parentid = [subdic valueForKey:@"id"];
        commectid = [subdic valueForKey:@"commentid"];
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self pushmessage];
    return YES;
}
-(void)pushmessage{
    if (textField.text.length == 0) {
        [MBProgressHUD showError:YZMsg(@"请添加内容后再尝试")];
        return;
    }
    if ([touid isEqual:[Config getOwnID]]) {
        [MBProgressHUD showError:YZMsg(@"不用给自己回复")];
        return;
    }
    NSString *path = [NSString stringWithFormat:@"%@",textField.text];
    NSString *sendtouid = [NSString stringWithFormat:@"%@",touid];
    NSString *sendcommectid = [NSString stringWithFormat:@"%@",commectid];
    NSString *sendparentid = [NSString stringWithFormat:@"%@",parentid];
    
    [self cancle];
    [self.view endEditing:YES];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *url = [purl stringByAppendingFormat:@"service=Video.setComment&videoid=%@&content=%@&uid=%@&token=%@&touid=%@&commentid=%@&parentid=%@",[_hostDic valueForKey:@"videoid"],path,[Config getOwnID],[Config getOwnToken],sendtouid,sendcommectid,sendparentid];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [session POST:url parameters:nil
         progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
             NSNumber *number = [responseObject valueForKey:@"ret"] ;
             if([number isEqualToNumber:[NSNumber numberWithInt:200]])
             {
                 NSArray *data = [responseObject valueForKey:@"data"];
                 NSNumber *code = [data valueForKey:@"code"];
                 if([code isEqualToNumber:[NSNumber numberWithInt:0]])
                 {
                     //更新评论数量
                     NSDictionary *info = [[data valueForKey:@"info"] firstObject];
                     NSString *replys   = [NSString stringWithFormat:@"%@",[info valueForKey:@"replys"]];
                     //显示回复总数
                     header.allComments.text = [NSString stringWithFormat:@"%@%@(%@)",@"   ",YZMsg(@"全部回复"),replys];

                     //获取总评论数
                     NSString *newComments = [NSString stringWithFormat:@"%@",[info valueForKey:@"comments"]];
                        NSDictionary *dic = @{
                                               @"allComments":newComments,
                                               @"replys":replys
                                             };
                     
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"allComments" object:nil userInfo:dic];
                     NSString *isattent = [NSString stringWithFormat:@"%@",[info valueForKey:@"isattent"]];//对方是否
                     NSString *t2u = [NSString stringWithFormat:@"%@",[info valueForKey:@"t2u"]];//对方是否拉黑我
                     if ([t2u isEqual:@"0"]) {
                         
                    [MBProgressHUD showSuccess:minstr([data valueForKey:@"msg"])];
                         
                        count = 0;
                        _itemsarray = nil;
                        _itemsarray = [NSMutableArray array];
                        ispush = 1;
                        if (![sendtouid isEqual:[Config getOwnID]]) {
                             NSString *sixincontent = [NSString stringWithFormat:@"%@:%@",YZMsg(@"回复"),path];
                            [JMSGConversation createSingleConversationWithUsername:sendtouid completionHandler:^(id resultObject, NSError *error) {
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
                             //增加回复数量
                             NSDictionary *subdic = @{
                                                      @"commentid":[_hostDic valueForKey:@"parentid"],
                                                      @"commentnums":replys
                                                      };
                             [[NSNotificationCenter defaultCenter] postNotificationName:@"commentnums" object:nil userInfo:subdic];
                    }
                     else{
                         if (![sendtouid isEqual:[Config getOwnID]]) {
                             [MBProgressHUD showError:YZMsg(@"对方暂时拒绝接收您的消息")];
                         }
                     }
                 }
                 else{
                     [MBProgressHUD showError:minstr([data valueForKey:@"msg"])];
                 }
              }
            }
          failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         
     }];
}
//这个地方找到点赞的字典，在数组中删除再重新插入 处理点赞
-(void)makeLikeRloadList:(NSString *)commectids andLikes:(NSString *)likes islike:(NSString *)islike{
    
    BOOL isLike = NO;
    int numbers;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    for (int i=0; i<_itemsarray.count; i++) {
        NSDictionary *subdic = _itemsarray[i];
        NSString *myparentid = [NSString stringWithFormat:@"%@",[subdic valueForKey:@"id"]];
        if ([myparentid isEqual:commectids]) {
            
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
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
#pragma mark -- 获取键盘高度
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat height = keyboardRect.origin.y;
    _toolBar.frame = CGRectMake(0, height - 114, _window_width, 50);
}
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    [UIView animateWithDuration:0.1 animations:^{
        _toolBar.frame = CGRectMake(0, _window_height  - 114, _window_width, 50);
    }];
    commectid = [_hostDic valueForKey:@"commentid"];
    parentid  = [_hostDic valueForKey:@"parentid"];
    touid     = [_hostDic valueForKey:@"ID"];
    textField.text = @"";
    textField.placeholder = [NSString stringWithFormat:@"%@%@:",YZMsg(@"回复"),[_hostDic valueForKey:@"user_nicename"]];
}
@end
