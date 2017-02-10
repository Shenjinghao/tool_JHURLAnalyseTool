# tool_JHURLAnalyseTool
一款截取网络请求的url展示类工具


# Overview

![snapshot](https://github.com/Shenjinghao/tool_JHURLAnalyseTool/blob/master/snapshot/snapshot1.png)

![snapshot](https://github.com/Shenjinghao/tool_JHURLAnalyseTool/blob/master/snapshot/snapshot2.png)


#注册方法

``` objc
[NSURLProtocol registerClass:[JHURLAnalyseProtocol class]];
[[JHURLAnalyseManager defaultManager] registerUrlAnalyse];
```

#使用方法

真机调试，晃动手机会模态show出JHURLAnalyseListViewController页面。
