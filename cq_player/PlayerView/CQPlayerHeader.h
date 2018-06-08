//
//  CQPlayerHeader.h
//  cq_player
//
//  Created by chenq@kensence.com on 2018/6/8.
//  Copyright © 2018年 QiangChen. All rights reserved.
//

#ifndef CQPlayerHeader_h
#define CQPlayerHeader_h

///Masonry 约束宏
#define Mas_Top(superMas,top_float)  make.top.equalTo(superMas).with.offset(top_float)
#define Mas_left(superMas,Left_float) make.left.equalTo(superMas).with.offset(Left_float)
#define Mas_bottom(superMas,bottom_UInteger) make.bottom.equalTo(superMas).with.offset(-bottom_UInteger)
#define Mas_Right(superMas,Right_UInteger) make.right.equalTo(superMas).with.offset(-Right_UInteger)
#define Mas_Width(float_width) make.width.mas_offset(float_width)
#define Mas_height(float_height) make.height.mas_offset(float_height)






#endif /* CQPlayerHeader_h */
