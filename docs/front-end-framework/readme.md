# 前端架构


## 目录结构

```sh
  ├── mock
  ├── public
  │   └── index.html
  │   └── favicon.png
  ├── src
    ├── assets                      # 静态资源
    ├── components                  # 全局公共组件
    ├── e2e                         # 端到端集成测试
    ├── models                      # 数据模型层
    ├── layout                      # 基础布局框架
    ├── router                      # 路由
    ├── service                     # 后台服务接口
    ├── styles                      # 全局样式
    ├── utils                       # 工具库
    ├── pages                       # 视图层: 具体功能页面
  │     └── User                    # 功能模块
            └── Login               # 子模块
                └── components      # 功能业务组件
  │             └── models          # 模块独有的数据模型
  │             └── test            # 单元测试
  │             └── User.vue        # 页面
    ├── App.vue                     #
    ├── main.js                     # 入口
  ├── test                          # 测试工具
  ├── styles                        # 全局样式
  ├── package.json
  └── vue.config.js                 # vue config
```


## 命名规范

### pages

  - 模块文件夹以大驼峰法命名（首字母大写）
  - 子模块文件夹以大驼峰法命名
  - vue 页面以大驼峰法命名

### models

以大驼峰法命名


## 开发规范

### 风格指南

- 参考 [vue官方风格指南](https://cn.vuejs.org/v2/style-guide/) ，使用到的优先级为B级。
- 使用 eslint 代码检查 ( @vue/standard )
- 编辑器规范使用 .editorconfig 配合 vscode 插件[EditorConfig for VS Code
](https://marketplace.visualstudio.com/items?itemName=EditorConfig.EditorConfig)

### scss规范

- 命名使用 [BEM](https://www.w3cplus.com/css/css-architecture-1.html) 规范， 配合scss mixin `b`
 `e` `m` 使用
 - 变量统一定义到公共var.scss 文件中
