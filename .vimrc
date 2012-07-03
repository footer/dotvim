""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"common set
"""""""""""""""""""""""""""""""""""""""""""""""""""""""
let mapleader=","
let g:mapleader=","

"pathogen--
"Manage your 'runtimepath' with ease.  In practical terms, pathogen.vim makes it super easy to install plugins and runtime files in their own private directories. 
runtime bundle/vim-pathogen/autoload/pathogen.vim
call pathogen#infect()
"call pathogen#runtime_append_all_bundles()

colorscheme elflord          " 着色方案
set nocp
set list                     " 显示Tab符，使用一高亮竖线代替
set listchars=tab:\|\ ,
set autoindent
set tabstop=4                " 设置tab键的宽度
set shiftwidth=4             " 换行时行间交错使用4个空格
set backspace=2              " 设置退格键可用
set cindent shiftwidth=4     " 自动缩进4空格
set smartindent              " 智能自动缩进
set ai!                      " 设置自动缩进
set number                   " 显示行号
set ruler                    " 右下角显示光标位置的状态行
set laststatus=2
set ignorecase               " 忽略搜索大小写
set smartcase                " 当搜索关键字中包含大写字母的时候不忽略大小写
set cmdheight=2              " 命令行高度
set history=400              " 
set hlsearch
set incsearch
if exists("&autoread")
	set autoread
endif
"set cursorline               " 突出显示本行
if has("gui_running")
	set guioptions-=m
	set guioptions-=T
	set guioptions-=I
	set guioptions-=L
	set guioptions-=r
	set guioptions-=R
endif


" 设置编码
set fenc=utf-8
set encoding=utf-8
set fileencodings=utf-8,gbk,cp936,latin-1
set termencoding=utf-8

nmap <silent> <C-N> :cn<CR>
nmap <silent> <C-P> :cp<CR>
nmap <silent> <leader>h :noh<CR>
" nmap qq :qa<CR>
nmap <leader>q :q<CR>
nmap <leader>Q :qa<CR>
set keywordprg=dict

fun MySys()
	if has("win32")
		return "windows"
	elseif has("unix")
		return "unix"
	else
		return "mac"
	endif
endf

filetype indent on           " 针对不同的文件类型采用不同的缩进格式
filetype plugin on           " 针对不同的文件类型加载对应的插件
filetype plugin indent on    " 启用自动补全
syntax enable                " 打开语法高亮
syntax on                    " 打开文件类型检测

"quick edit .vimrc : type ',e' in normal mode
nmap <leader>e :e! ~/.vimrc<CR>
nmap <leader>w :w<CR>
autocmd! bufwritepost .vimrc source ~/.vimrc

set vb t_vb=                 " 关闭提示音
set hidden                   " 允许在有未保存的修改时切换缓冲区
" ======= 引号 && 括号自动匹配 ======= "
" :inoremap ( ()<ESC>i
" :inoremap ) <c-r>=ClosePair(')')<CR>
" :inoremap { {}<ESC>i
" :inoremap } <c-r>=ClosePair('}')<CR>
" :inoremap [ []<ESC>i
" :inoremap ] <c-r>=ClosePair(']')<CR>
" :inoremap < <><ESC>i
" :inoremap > <c-r>=ClosePair('>')<CR>
" :inoremap " ""<ESC>i
" :inoremap ' ''<ESC>i
" :inoremap ` ``<ESC>i

function ClosePair(char)
	if getline('.')[col('.') - 1] == a:char
		return "\<Right>"
	else
		return a:char
	endif
endf

au BufRead,BufNewFile *.asm,*.c,*.cpp,*.java,*.cs,*.sh,*.lua,*.pl,*.pm,*.py,*.rb,*.erb,*.hs,*.vim 2match Underlined /.\%81v/
au BufRead,BufNewFile *.txt setlocal ft=txt
" Ctrl + H            将光标移到行首
imap <c-h> <ESC>I
" Ctrl + J            将光标移到下一行的行首
imap <c-j> <ESC>jI
" Ctrl + K            将光标移到上一行的末尾
imap <c-k> <ESC>kA
" Ctrl + L            将光标移到行尾
imap <c-l> <ESC>A
" Ctrl + Z            取代ESC模式键
imap <c-z> <ESC>

nmap <c-h> <c-w>h
nmap <c-j> <c-w>j
nmap <c-k> <c-w>k
nmap <c-l> <c-w>l
""""""""""""""""""""""""""""""
" lookupfile setting
" """"""""""""""""""""""""""""""
let g:LookupFile_MinPatLength = 2               "最少输入2个字符才开始查找
let g:LookupFile_PreserveLastPattern = 0        "不保存上次查找的字符串
let g:LookupFile_PreservePatternHistory = 1     "保存查找历史
let g:LookupFile_AlwaysAcceptFirst = 1          "回车打开第一个匹配项目
let g:LookupFile_AllowNewFiles = 0              "不允许创建不存在的文件
if filereadable("./filenametags")                "设置tag文件的名字
	let g:LookupFile_TagExpr = '"./filenametags"'
endif
" lookup file with ignore case
function! LookupFile_IgnoreCaseFunc(pattern)
	let _tags = &tags
	try
		let &tags = eval(g:LookupFile_TagExpr)
		let newpattern = '\c' . a:pattern
		let tags = taglist(newpattern)
	catch
		echohl ErrorMsg | echo "Exception: " . v:exception |
		echohl NONE
		return ""
	finally
		let &tags = _tags
	endtry

	" show the matches for what is typed so far.
	let files = map(tags, 'v:val["filename"]')
	return files
endf
let g:LookupFile_LookupFunc = 'LookupFile_IgnoreCaseFunc'
"映射LookupFile为,lk
nmap <silent> <leader>lk :LUTags<cr>
"映射LUBufs为,ll
nmap <silent> <leader>ll :LUBufs<cr>
"映射LUWalk为,lw
nmap <silent> <leader>lw :LUWalk<cr>
function Genfilenametags()
	exec "!echo -e '\\!_TAG_FILE_SORTED\t2\t/2=foldcase/' > filenametags"
	exec "!find -name '*.cpp' -type f -printf '\\%f\\t\\%p\\t1\\n' -o -name '*.c' -type f -printf '\\%f\\t\\%p\\t1\\n' -o -name '*.h' -type f -printf '\\%f\\t\\%p\\t1\\n' >> filenametags"
endf
"""""""""""""""""""""""""""""""""""""""""""""""
" TagList 
"""""""""""""""""""""""""""""""""""""""""""""""
let Tlist_Show_One_File=1                    " 只显示当前文件的tags
let Tlist_Exit_OnlyWindow=1                  "
" 如果Taglist窗口是最后一个窗口则退出Vim
let Tlist_Use_Right_Window=0                 " 在左侧窗口中显示
let Tlist_File_Fold_Auto_Close=1             " 自动折叠
let Tlist_Ctags_Cmd = 'ctags'
" 打开taglist面板: ',tl'
nmap <silent> <leader>tl :Tlist<CR><c-l>
""""""""""""""""""""""""""""""""""""""""""""""
" NERD tree
""""""""""""""""""""""""""""""""""""""""""""""
nmap <silent> <leader>nt :NERDTree<CR>
let g:NERDTreeWinPos = "right"

""""""""""""""""""""""""""""""""""""""""""""""
" omnicppcomplete
""""""""""""""""""""""""""""""""""""""""""""""
map <F12> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>

""""""""""""""""""""""""""""""""""""""""""""""
" MiniBufExplorer
""""""""""""""""""""""""""""""""""""""""""""""
" 多个文件切换 可使用鼠标双击相应文件名进行切换
let g:miniBufExplMapWindowNavVim=1
let g:miniBufExplMapWindowNavArrows=1
let g:miniBufExplMapCTabSwitchBufs=1
let g:miniBufExplModSelTarget=1
let g:miniBufExplorerMoreThanOne=0
nmap <C-Tab> :bn<CR>

"""""""""""""""""""""""""""""""""""""""""""""
" OmniCppComplete
"""""""""""""""""""""""""""""""""""""""""""""
let OmniCpp_NamespaceSearch = 1
let OmniCpp_GlobalScopeSearch = 1
let OmniCpp_ShowAccess = 1
let OmniCpp_ShowPrototypeInAbbr = 1 " show function parameters
let OmniCpp_MayCompleteDot = 1 " autocomplete after .
let OmniCpp_MayCompleteArrow = 1 " autocomplete after ->
let OmniCpp_MayCompleteScope = 1 " autocomplete after ::
let OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD"]
" automatically open and close the popup menu / preview window
au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
set completeopt=menuone,menu,longest,preview

if has("cscope")
	set csprg=cscope
	set csto=1
	set cst
	set nocsverb
	" add any database in current directory
	if filereadable("cscope.out")
		let csbufname=expand("%:h")
		exec "cs add cscope.out ".csbufname
	endif
	set csverb
endif

nmap <C-@>s :cs find s <C-R>=expand("<cword>")<CR><CR>
nmap <C-@>g :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <C-@>c :cs find c <C-R>=expand("<cword>")<CR><CR>
nmap <C-@>t :cs find t <C-R>=expand("<cword>")<CR><CR>
nmap <C-@>e :cs find e <C-R>=expand("<cword>")<CR><CR>
nmap <C-@>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <C-@>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nmap <C-@>d :cs find d <C-R>=expand("<cword>")<CR><CR>
"ctags -R --c++-kinds=+px --fields=+iaS --extra=+q

function Do_CsTag()
	if(executable('cscope') && has("cscope") )
		if MySys() == "linux"
			silent! execute "!find .  -name '*.h' -o -name '*.c' -o -name '*.cpp' -o -name '*.java' -o -name '*.cs' > cscope.files"
		else
			silent!  execute "!dir /b *.c,*.cpp,*.h,*.java,*.cs >> cscope.files"
		endif
		silent!  execute "!cscope -Rbq "
		if filereadable("cscope.out")
		silent!  execute "cs add cscope.out"
		endif
	endif
endf


