# Kuaijizhang
一个记账类的iOS app

##待解决的BUG
1.账单发生日期数据，进入到realm数据库中，以＋8个小时显示，提出realm数据库后，又正常显示。
2.修改账单的时候当类别或者账单的子类是一个的时候，会发生崩溃，由于在pickerview的delegate传row造成的。
3.测试DateHelper类
4.viewmodel如果重新被赋值，则在viewmodel增加的数据改变监听闭包处理程序没有添加，导致数据变化无法坚挺 －重新优化数据变化闭包架构 二改变闭包添加位置。
5.处理drawrect方法中绘制的直线覆盖了消费类型图片。
