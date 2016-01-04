# $fb
#   save data fetched from facebook
# $facebook
#   call methods for access fb

# 本機開發請用 267188576687915
# 正式主機請用 1476442785996284
fbappid = if location.href.indexOf("iing.tw") >= 0 then '1476442785996284' else '267188576687915'
window.$fb =
  token: null
  userID: null
  picture: null
  perms: "public_profile,user_photos,publish_actions"
  appId: fbappid
  shareCapition: '' # 不要幫 user 下文案
  # 網頁 load 完後想要做啥
  afterPageLoad: ->
    # $facebook.getLoginStatus() # 先取消自動抓 fb 頭像
  # 檢查到有登入且有授權後
  afterLogin: (response)->
    $fb.token  = response.authResponse.accessToken
    $fb.userID = response.authResponse.userID;
    $facebook.getUserPicture()
    $('body').addClass('fb-connected')
  # 檢查到沒登入、或有登入沒授權
  notLogin: ->
    $('body').addClass('no-fb')
  # 開始檢查是否有登入和授權
  beforeGetLoginStatus: ->
    $('body').addClass('fb-get-login-status')
  # 結束檢查是否有登入和授權
  afterGetLoginStatus: ->
    $('body').removeClass('fb-get-login-status')
  # 檢查到有授權後，開始抓臉書頭像
  beforeUserPictureLoaded: ->
    $('body').addClass('fb-get-picture')
  # 已抓到臉書頭像
  afterUserPictureLoaded: ->
    $('body').removeClass('fb-get-picture')

((d, s, id) ->
  js = undefined
  fjs = d.getElementsByTagName(s)[0]
  if d.getElementById(id)
    return
  js = d.createElement(s)
  js.id = id
  js.src = '//connect.facebook.net/zh_TW/sdk.js'
  fjs.parentNode.insertBefore js, fjs
  return
) document, 'script', 'fb-root'

window.fbAsyncInit = ->
  FB.init
    appId: $fb.appId
    cookie: true
    xfbml: true
    version: 'v2.5'
  $fb.afterPageLoad()
  $('.js-fb-login').on 'click', ->
    $facebook.dialogLogin ->
      $facebook.getLoginStatus()
  $('.js-fb-upload').on 'click', ->
    if $fb.token  # 有登入
      $facebook.uploadPicture()
    else          # 沒登入
      $facebook.dialogLogin ->
        $facebook.getLoginStatus()
        # 可能 anchor 回去看自己的照片會比較好

class Facebook
  getUserPicture: ->
    $fb.beforeUserPictureLoaded()
    url = "/" + $fb.userID + "/picture?width=500&height=500"
    FB.api url, (result)->
      $fb.picture = result.data.url
      $util.urlToBlob $fb.picture, (blob)->
        loadImage [blob]
        $fb.afterUserPictureLoaded()
  getLoginStatus: ->
    $fb.beforeGetLoginStatus()
    FB.getLoginStatus (response) ->
      status = response.status
      if status == 'connected'
        $fb.afterLogin(response)
      else if status == 'not_authorized'
        $fb.notLogin()
      else
        $fb.notLogin()
      $fb.afterGetLoginStatus()
  dialogLogin: (callback)->
    FB.login ((response)->
      callback(response)
    ), scope: $fb.perms
  publishPost: (imgurl)->
    FB.api '/me/feed', 'post', (
      link: 'http://2.iing.tw'
      picture: imgurl
    ), (response)->
      xx(response.id)
  uploadPicture: ->
    endpoing = "http://staging.iing.tw/badges.json"
    $.post endpoing, { data: getBase64() }, (result)->
      $facebook.publishPost(result.url)
      FB.api '/me/photos', 'post', (
        access_token: $fb.token
        url: result.url
        caption: $fb.shareCapition
      ), (response)->
        if response.id
          url = "https://m.facebook.com/photo.php?fbid=" + response.id + "&prof=1"
          window.open(url, "", "width=550, height=460, menubar=no, resizable=no, scrollbars=no, status=no, titlebar=no, toolbar=no")

window.$facebook = new Facebook()
