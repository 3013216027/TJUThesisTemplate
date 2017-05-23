# TJUThesisTemplate

美味源自[tjuthesis](https://code.google.com/archive/p/tjuthesis/)

中文译文请移步分支[translation](//github.com/3013216027/TJUThesisTemplate/tree/translation)

### 环境

- 编译环境。OS X可能需要`brew`安装`zsh`，也可直接使用原生的bash；Windows安装后，注意检查相应的可执行文件路径是否已加入环境变量`PATH`中；Linux用户可以自己解决下面的所有问题，不作其它说明。

    | 操作系统 | LaTeX发行版 | 终端环境 |
    |:-------:|:----------:|:------:|
    | Windows 10 专业版 | [TexLive](https://www.tug.org/texlive/) | 首推[babun](http://babun.github.io/)或[cygwin](https://www.cygwin.com/) |
    | OS X | [MacTeX](http://www.tug.org/mactex/) | 均可，推荐zsh+tmux/screen，tmux/screen提供终端分屏/多屏等功能 |
- 编辑环境，推荐[Sublime Text 3](https://www.sublimetext.com/3)。当然其它编辑器也是吼的，不过使用时注意编码方式，至少要用`UTF-8`。
    + 插件管理器: [Package Control](https://packagecontrol.io/)
    + 其它插件推荐: `LaTeXTools`、`ConvertToUTF8`、`SideBarEnhancements`等。插件很多，众口难调，但多数时候看看[最受欢迎的插件](https://packagecontrol.io/browse/popular)，挑几款自己受用的就好了。

### 编译和配置说明
0. 尽量将编译、打开pdf、清理文件等需要重复进行的操作在`makefile`中写好，原模板使用`.bat`批处理。
1. `makefile`中的`run`（打开生成的pdf）直接调用`PDF_VIEWER`命令完成，可直接修改为自己环境中的pdf阅读器。OS X下可用`open`/`open -a Skim.app`，Windows下推荐`SumatraPDF`，Linux可考虑`apropos`。
2. 编译方法
    + 如何编译：用xelatex完整编译一般需要`xelatex`（基本，字体渲染等）+`bibtex`（参考文献，依赖上一步生成的aux文件）+`xelatex`（目录生成）+`xelatex`（文献引用链接）四步。使用`latex`或者`pdflatex`等编译方式类似之。具体过程参考[makefile](https://github.com/3013216027/TJUThesisTemplate/blob/master/makefile)。基本命令包括：
        - `make`或`make build`或`make default`：执行上面4步编译，生成对应的pdf。
        - `make clean`：清理中间文件，如`xxx.aux`。
        - `make cleanAll`：清理中间文件和生成的pdf文件。
        - `make run`：打开生成的pdf文件。
        - `make touch`：刷新pdf文件的时间戳，没啥用。
    + 为什么使用XeLaTeX：为了中文支持。`CJK`宏包渲染的汉字在Windows下看起来锯齿感十足，XeLaTex中对应的宏包为`xeCJK`。

3. 说明
    + Windows下使用的特别说明：如果发现编译速度很慢，总在某一处卡住，一般是因为没有预建立字体缓存。安装了新字体后，需要通过`fc-cache`来建立字体缓存，并且务必保证缓存目录(`<texlive>/texmf-var/fonts/cache/`)的写权限以及建立缓存时具有管理员权限。我的解决办法是设置`xelatex.exe`和`fc-cache.exe`的属性，勾选以管理员运行，然后运行`fc-cahe -fsv`来强制刷新缓存。为保险和方便起见，我的`babun`也是以管理员身份执行的，设置方法：在`babun.bat`中可以看到，babun的终端实质上是`mintty`，因此设置`mintty.exe`以管理员身份运行即可。上述设置的前提是，你所用的电脑是自己的，并且已经拥有管理员权限，若非如此，需要从组策略中启用超级管理员账户，然后给自己管理员授权或直接使用超级管理员账户。最后，Windows的非专业版不保证可以自如地使用管理员权限，比如家庭版或者某些出厂预装被阉割过的版本。
    + 模板结构：主文档为`tjumain.tex`，通过`input`和`include`命令包含其它tex文档。按顺序引入的文档分别是：
        1. 开始时分别引入`setup/`下的`package.tex`和`format.tex`来引入宏包和其它设置、定义。
        2. 其次引入`preface/`下的`cover.tex`，通过`makecover`命令生成封面和摘要页。
        3. 然后引入`body/`下的各正文章节。
        4. 接着引入`appendix/`下的英文文献和中文译文。
        5. 最后引入`references/`下的`TJUThesis.bst`以设置参考文献的格式，并引入`reference.bib`插入参考文献
        6. 最后的最后，引入`appendix/`下的`acknowledgements.tex`，即“致谢”。
    + 在`format.tex`中可对中文字体、表格、标题等内容的格式进行设置，如需修改中文字体，可依次检查`package.tex`中对应引入的宏包（此处为`xecjk`），然后搜索并查阅该宏包的文档[xeCJK.pdf](http://tug.ctan.org/macros/xetex/latex/xecjk/xeCJK.pdf)，即可解决大部分调整需求。
    + `format.tex`中在原模板上引入的一些宏如下，均为我在写作过程中为了使用方便加入的，所以如果你不需要，可自行去除：

        | 宏命令 | 说明 | 样例 |
        |:-----:|:----:|:---:|
        | `mean` | 均值 | `x的均值是$\mean{x} = \frac{1}{n}{\sum_{i=1}^{n}{x_i}}$` |
        | `norm` | 范数 | `x的2范数为$\norm{x}_2$` |
        | `inner` | 内积 | `x和y的内积为$\inner{x,y}$`
        | `abs` | 绝对值 | `x的绝对值是$\abs{x}$` |
        | `distance` | 距离 | `定义二者的\textbf{KL核}为$KLD(x_i\distance x_j)$` |
        | `argmin` | 就是argmin | `上述求解目标可以转化为$$\argmin_{x}{\times \sum_{i=1}^{n}{(x - y_i)^2}}$$` |
        | `argmax` | 和argmin类似 | 略 |
        | `todo` | 打草稿时添加备忘标记用 | `\todo{图片待补充}`会生成一段红色的文字`TODO: 图片待补充` |
    + 封面的学校名称字样和校徽标志是是从学校官网抠下来，然后用[vectormagic](https://vectormagic.com/)生成的矢量图，相比原模板清晰度有所改善，你也可以在[这里](https://qyetfu.site/download/tju_logo.zip)可以下载到对应的ai原件，然后自行微调校名颜色等。
    + [ ] `package.tex`中有一些包比较古老，比如用于表格单元斜线分隔的`slashbox`，因为开源问题已经被剔除了，现在用的是`diagbox`。有空清理一遍。



