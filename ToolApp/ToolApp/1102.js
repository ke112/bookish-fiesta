require('UIColor');
defineClass('ViewController',['data','totalCount'], {
//    init:function (){
//    	self == self.super().init();
//    	self.setData(["a","b"]);
//    	self.setTotalCount("2");
//    	return self;
//    },
    init: function() {
         self = self.super().init()
         self.setData(["a", "b"])     //添加新的 Property (id data)
         self.setTotalCount(2)
         return self
      },
    viewDidLoad: function() {
//        self.super().viewDidLoad();
        self.ORIGviewDidLoad();
        // Do any additional setup after loading the view.
        self.view().setBackgroundColor(UIColor.grayColor());
        self.setTitle("标题222");
//        self.setUrl("2222222");
//        var totalCount = self.totalCount();
//        self.setTitle(totalCount);
//        var _data = self.valueForKey("_data11");
//        console.log(_data);
//        self.setTitle(_data[0]);
    },
});
