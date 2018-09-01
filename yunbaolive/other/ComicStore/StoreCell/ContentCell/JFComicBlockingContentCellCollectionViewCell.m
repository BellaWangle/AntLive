//
//  JFComicBlockingContentCellCollectionViewCell.m
//  ComicReader
//
//  Created by Mr_J on 16/4/30.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "JFComicBlockingContentCellCollectionViewCell.h"

@implementation JFComicBlockingContentCellCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setContentModel:(ListContentModel *)contentModel{
    _contentModel = contentModel;
    [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:contentModel.cover_image_url]];
    self.titleLabel.text = contentModel.title;
}

@end
