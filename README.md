
<!-- README.md is generated from README.Rmd. Please edit that file -->

# yq: An R client to access ‘YuQue’ API <img src="https://github.com/openbiox/openbiox-wiki/blob/master/static/img/logo-long.png" align="right" width="200"/>

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![AppVeyor build
status](https://ci.appveyor.com/api/projects/status/github/ShixiangWang/yq?branch=master&svg=true)](https://ci.appveyor.com/project/ShixiangWang/yq)
[![Travis build
status](https://travis-ci.org/ShixiangWang/yq.svg?branch=master)](https://travis-ci.org/ShixiangWang/yq)
[![Codecov test
coverage](https://codecov.io/gh/ShixiangWang/yq/branch/master/graph/badge.svg)](https://codecov.io/gh/ShixiangWang/yq?branch=master)
<!-- badges: end -->

## Installation

You can install the development version of **yq** from GitHub with:

``` r
remotes::install_github("openbiox/yq")
```

## Configuration

Firstly, you should let YuQue know who you are by running `yq_config()`.
You will need to answer some questions.

``` r
> library(yq)
> yq_config()
Please type your login name of YuQue: 
(type e to exit) shixiangwang
Do you want to input token? 
(type ENTER to proceed) 
Please type your token: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
Found token, checking it...
Saving info to ~/.yuque.json
Updating login
Updating token
Done. Enjoy this tool.
- Shixiang
```

Next, you can run `yq_whoami()` to check if your profile is right.

``` r
> yq_whoami()
type                : User
id                  : 471931
login               : shixiangwang
name                : 王诗翔
description         : https://shixiangwang.github.io/home/
books_count         : 3
public_books_count  : 2
followers_count     : 0
following_count     : 0
created_at          : 2019-09-01T09:21:50.000Z
updated_at          : 2019-09-03T06:43:10.000Z
limits              : 49899
```

> The token can be obtained from YuQue account. More please run
> `?yq_whoami` to see documentation.

## Usage

### Main API

The main API of **yq** package is `yq()` function. You can send any
queries to YuQue API URL <https://www.yuque.com/api/v2> or set custom
API URL by `.api_url` argument. All user functions are built on the top
of `yq()`.

``` r
args(yq)
#> function (endpoint, ..., .token = NULL, .destfile = NULL, .overwrite = FALSE, 
#>     .api_url = NULL, .method = "GET", .send_headers = NULL) 
#> NULL
```

### User functions

This package is under heavy development, many features shown in YuQue
API have not yet implemented. I will give a short intro to functions
available.

  - `yq_whoami` - return personal profile
  - `yq_token` - return your token used by API query
  - `yq_config` - set your login name and token (you can re-run it to
    reset)
  - `yq_list_groups` - return personal groups
  - `yq_list_public_groups` - return public groups
  - `yq_list_group_info` - return group info and your ability

### Show cases

``` r
yq_list_groups()
#> 优雅R 生信技能树 隐藏库
```

``` r
yq_list_groups(verbose = "all")
#> 
#> ---------------------------------------------------------------------------
#> login        name         books   topics   members   description           
#> ------------ ------------ ------- -------- --------- ----------------------
#> elegant-r    优雅R        1       0        1         「优雅R」公众号       
#> 
#> biotrainee   生信技能树   2       0        60        生信技能树 创建于     
#>                                                      2016年8月，是中国第   
#>                                                      一家专注于生信知识体  
#>                                                      系完善、促进生信学习  
#>                                                      交流的论坛。我们通过  
#>                                                      收集国内外生信学习资  
#>                                                      源，邀请大神分享的领  
#>                                                      域专业知识，发布菜鸟  
#>                                                      的真实学习笔记，搭建  
#>                                                      生信技术人员联盟，    
#> 
#> hidden       隐藏库       0       0        1         用来测试              
#> ---------------------------------------------------------------------------
#> 
#> Table: Info of Group
```

``` r
yq_list_public_groups()
#> guomics_protocol 通用电商团队模板 支持中心 大数据中心 供应链中心 研发中心 APP中心 运营中心 甩团 寄样 开智课程合作 电子签约h5 CMICT_基础知识库 运维 天印旗舰版 量化投资 财富号官方团队 人力行政部 Choppy Platform 教学资源
```

``` r
yq_list_group_info(login = "elegant-r")
#> 
#> ----------------------------------------------------------------
#> login       name    books   topics   members   description      
#> ----------- ------- ------- -------- --------- -----------------
#> elegant-r   优雅R   1       0        1         「优雅R」公众号  
#> ----------------------------------------------------------------
#> 
#> Table: Info of Group
#> 
#> 
#> -----------------------------------------------
#> level        read   create   update   destroy  
#> ------------ ------ -------- -------- ---------
#> overall      TRUE   NA       TRUE     TRUE     
#> 
#> group_user   NA     TRUE     TRUE     TRUE     
#> 
#> repo         NA     TRUE     TRUE     TRUE     
#> -----------------------------------------------
#> 
#> Table: Ability to Group
```

## Code of Conduct

Please note that the ‘yq’ project is released with a [Contributor Code
of Conduct](CODE_OF_CONDUCT.md). By contributing to this project, you
agree to abide by its terms.
