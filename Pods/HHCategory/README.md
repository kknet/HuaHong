# HHCategory

pod组件化
步骤
1.git上创建项目HHCategory
2. 本地创建项目：pod lib create HHCategory
3.将打包好的静态库放到Class文件夹下
4.编辑.podspec文件
5.本地项目与远程仓库关联：git remote add origin https://github.com/huahong1124/HHCategory.git
6.将原文件上传git ：git add . ; git commit ;git push;
7.打tag ：git tag 0.1.0 ;  git push - -tags;
8.验证.podspec文件： pod lib lint(本地)  pod spec lint HHCategory.podspec --allow-warnings
9. 注册（已注册可忽略）：pod trunk register 2330669775@qq.com huahong1124
10.pod trunk push HHCategory.podspec --allow-warnings

解决搜索不到的问题：
删除~/Library/Caches/CocoaPods目录下的search_index.json文件

pod setup成功后会生成~/Library/Caches/CocoaPods/search_index.json文件。
终端输入rm ~/Library/Caches/CocoaPods/search_index.json
删除成功后再执行pod search

