# $fb
#   save data fetched from facebook
# $facebook
#   call methods for access fb

window.$fb =
  token: null
  userID: null
  picture: null
  perms: "public_profile,user_photos"
  appId: '267188576687915'
  afterLogin: (response)->
    $fb.token  = response.authResponse.accessToken
    $fb.userID = response.authResponse.userID;
    $facebook.getUserPicture()
    $('body').addClass('fb-connected')
  afterUserPictureLoaded: ->
    # callback code here
  sample: 'http://assets.staging.iing.tw/badges/659dade0ea0d3a0a9e9e5c05fe3c71e6'

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
  $facebook.getLoginStatus()
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
    url = "/" + $fb.userID + "/picture?width=500&height=500"
    FB.api url, (result)->
      $fb.picture = result.data.url
      $util.urlToBlob $fb.picture, (blob)->
        loadImage [blob]
        $fb.afterUserPictureLoaded()
  getLoginStatus: ->
    FB.getLoginStatus (response) ->
      status = response.status
      if status == 'connected'
        $fb.afterLogin(response)
      else if status == 'not_authorized'
        # options['not_connected'](response)
      else
        # options['not_connected'](response)
  dialogLogin: (callback)->
    FB.login ((response)->
      callback(response)
      xx(response)
    ), scope: $fb.perms
  uploadPicture: ->
    xx(getBase64())
    FB.api '/me/photos', 'post', (
      access_token: $fb.token
      url: $fb.sample
      caption: "http://iing.tw"
    ), (response)->
      if response.id
        url = "https://m.facebook.com/photo.php?fbid=" + response.id + "&prof=1"
        window.open(url, "", "width=550, height=460, menubar=no, resizable=no, scrollbars=no, status=no, titlebar=no, toolbar=no")

window.$facebook = new Facebook()
