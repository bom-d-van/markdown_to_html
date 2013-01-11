# ViewAssets
ViewAssets(VA) 是一个简单的 Javascript, Stylesheets 依赖管理器。 根据 Rails 3.2 中的 asset pipeline，它会默认加载所有的 assets 资源，这样其实对于富 JS 应用而言并不是特别有利。因为每个页面有可能都包含着大量其它页面都需要用到的文件资源。VA 就是为了解决这个问题而提出来的。它支持每个页面都能够加载自己需要的 assets 资源，同时也保留了 assets pipeline 自动处理依赖的优点。   

简单的概括这个 <span style='color:red;'>gem</span> 就是它将在 view 中 *.html.erb 中声明的依赖转移到 js/css 文件中。在特定的文件(manifest file)中使用规定的语法(directive)声明依赖。   

## Example

下面的目录是一个 rails 项目的 public 文件夹。

    .
    ├── 404.html
    ├── 422.html
    ├── 500.html
    ├── app
    │   ├── javascripts
    │   │   ├── application.js
    │   │   ├── bar
    │   │   │   ├── index
    │   │   │   │   ├── index.js
    │   │   │   │   └── others.js
    │   │   │   └── show.js
    │   │   └── foo
    │   │       ├── foo.js
    │   │       ├── index
    │   │       │   ├── index.js
    │   │       │   └── others.js
    │   │       └── show.js
    │   └── stylesheets
    │       ├── application.css
    │       ├── bar
    │       │   ├── index
    │       │   │   ├── index.css
    │       │   │   └── others.css
    │       │   └── show.css
    │       └── foo
    │           ├── foo.css
    │           ├── index
    │           │   ├── index.css
    │           │   └── others.css
    │           └── show.css
    ├── favicon.ico
    ├── lib
    │   ├── javascripts
    │   │   ├── lib1.js
    │   │   └── lib2.js
    │   └── stylesheets
    │       ├── lib1.css
    │       └── lib2.css
    └── vendor
        ├── javascripts
        │   ├── vendor1.js
        │   └── vendor2.js
        └── stylesheets
            ├── vendor1.css
            └── vendor2.css

有如下的依赖声明：

/vendor/javascripts/vendor1.js

```js
//= require_vendor vendor2
```

/lib/javascripts/lib1.js

```js
//= require_vendor lib2
```

/app/javascripts/application.js

```js
/**
 *= require_vendor vendor1
 *= require_lib lib1
 */
```

/app/javascripts/bar/show.js

```js
//= reuquire index/others.js
```

当访问 `bar/show`(比如：`localhost:3000/bar/show`) 时，可以看到在其 `html` 文件中的 `head` 有下面的几个 `script` 自动插入了：

    <script src="vendor2.js" type="text/javascript"></script>
    <script src="vendor1.js" type="text/javascript"></script>
    <script src="lib2.js" type="text/javascript"></script>
    <script src="lib1.js" type="text/javascript"></script>
    <script src="application.js" type="text/javascript"></script>
    <script src="index/others.js" type="text/javascript"></script>


## CONVENTIONS/RULES

使用 rake view_assets:init 任务，VA 会在 public 目录中添加下面的文件结构:

    |- vendor
        |- javascripts
        |- stylesheets
    |- lib
        |- javascripts
        |- stylesheets
    |- app
        |- javascripts
            |-application.js
        |- stylesheets
            |-application.css

和 rails assets pipeline 相似，它有三种目录存放 js 以及 css 文件。每种类型的含义都和 pipeline 相同。

    vendor
    用于存放如 Extjs, JQuery 等外部库。

    lib
    用于存放自己拓展的功能，比如一些拓展于 Extjs 的库或者一些其它公用的拓展功能等。

    app
    用于存放每个页面需要用到的资源。

### manifest file

**NOTE**  
下面例子讲述的时候大都直接使用 javascript 当例子，stylesheets 的所有规则几乎和 javascripts 一致。如有不同会单独提示。

manifest file 指的是用于声明文件依赖的文件，**只有在这个文件中声明依赖才是有效的**，因为 VA 只会解析 manifest file，并为你关联好依赖。

三个不同的目录有各自特点的 manifest file。

#### In Vendor & Lib

对于 vendor 和 lib 资源，manifest file 可以是如下形式：

如果该资源只有一个文件，且直接放置于资源根目录下（即 vendor/javascritps 或者 lib/javascritps），则这个文件本身就是 manifest file，我们可以在文件的头部直接添加其文件依赖。

如果该资源有多个文件，且存放于同一个文件夹中，则该文件夹中的 index.js 文件被定义为 manifest file。

**NOTE**  
注意同一个文件夹内的依赖不需要声明，因为 VA 会自动将文件中所有的 assets 文件加载进来。

#### In App

对于 app 目录，它有两种 manifest file，一种是 controller 级别的，另一种是 action 级别的。

对于 controlle 级别的 manifest file，VA 类似 rails 的 views，如果这个 controller 本身存在自己的依赖，即（ 存在这个文件 /app/javascripts/:controller/:controller.js），则不会使用 /app/javascripts/application.js。

对于 action，则和 vendor、lib 相似，如果只有一个文件，则 manifest file 为 /app/javascripts/:controller/:action.js，如果该 action 有多个文件，则需要将其组织在以 action 为名的文件夹中，同时在这些中以 index 为名的文件为 manifest file。

**NOTE** VA 会自动将 `/app/javascripts/:controller/:action` 中所有的 assets 文件加载进来。

#### Others

在开发过程中并不一定要使用 manifest file，要注意的是如果有特别依赖要声明的时候，要声明于该文件中，这样 VA 才能正确的为你关联好依赖。

## DIRECTIVE

同样，VA 也可以在文件中声明依赖，声明的规则基本业余 pipeline 相似。js 中支持三种声明方式，css 中支持两种。

    for javascript  
      double-slash syntax => "//= require_vendor xxx"   
      space-asterisk syntax => " *= require_vendor xxx"   
      slash-asterisk syntax => "/*= require_vendor xxx */"  

    for stylesheets   
      space-asterisk syntax => " *= require_vendor xxx"   
      slash-asterisk syntax => "/*= require_vendor xxx */"  

上面列出的三种声明方式，而声明指令也有三个，分别是：

* `require_vendor` 会在 vendor 文件夹中寻找目的资源   
* `require_lib` 会在 lib 文件夹中寻找目的资源    
* `require` 会在 app 文件夹中寻找目的资源   

对于 `require` 指令，AV 主要提供的是对同一个 controller 下和不同 controller 下的资源进行加载，这些文件都不会被视为 manifest file，所以不会对其进行解析。

加载同一个 controller 的资源时，参数不要包含 controller 名字以及不能以 `/` 开头，任何以 `/` 开头的参数在 `require` 中会视为加载其他 controller 文件。

`require path/to/file`

加载不同 controller 的资源时

`require /other_controller/path/to/file`

## Arguments/Path

在 Directive 后跟着的依赖的参数。如：

```js
/**
 * require_vendor vendor1, vendor2        => <script src="/vendor/javascripts/vendor1.js" type="text/javascript"></script>
 *                                           <script src="/vendor/javascripts/vendor2.js" type="text/javascript"></script>
 *
 * require_lib lib1                       => <script src="/lib/javascripts/lib1.js" type="text/javascript"></script>
 * require_lib lib2                       => <script src="/lib/javascripts/lib2.js" type="text/javascript"></script>
 * require /other_controller/path/to/file => <script src="/app/javascripts/other_controller/path/to/tile.js" type="text/javascript"></script>
 */
```

## USAGE

在 Gemfile 中添加下面的代码：

`gem 'view_assets'`

接下来，需要在 `/app/helpers/application_helper.rb` include `ViewAssets`。

```ruby
module ApplicationHelper
  include ViewAssets
end
```

在你的 `/app/views/layouts/application.html.rb` 文件中需要添加下面代码：

```ruby
<%= include_assets_with_assets_mvc(params[:controller], params[:action]) %>
```

如果你的 controller 使用了自己的 layout 的话，则需要将在 `app/views/layouts/application.html.rb` 添加的代码也添加进去。
    
## OTHERS

虽然这个 gem 有一定的方便性，但毕竟这是个简单的设计，目前支持简单的依赖管理，并不是个像 assets pipeline 一样十分成熟的程序。目前它还不支持许多 assets pipeline 实现的事情，比如在 production 模式下自动将所有 assets 压缩成一个文件等。

This project rocks and uses MIT-LICENSE.
