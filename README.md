# DistSlideSegment
slide segment
usage: 
// 项目信息 infoVC = [[ProjectInfoVC alloc] init]; 
// 取证材料 materialVC = [[ProjectMaterialVC alloc] init];

NSArray *viewsArray = @[infoVC.view,materialVC.view]; NSArray *titlesArray = @[@"项目信息",@"取证材料"];

slideSegment = [[DistSlideSegment alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) controllerViewsArray:viewsArray titlesArray:titlesArray]; slideSegment.backgroundColor = [UIColor whiteColor]; 
[self.view addSubview:slideSegment];
