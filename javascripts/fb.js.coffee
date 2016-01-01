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
    version: 'v2.2'
  $facebook.getLoginStatus()
  $('.js-fb-login').on 'click', ->
    $facebook.dialogLogin ->
      $facebook.getLoginStatus()



class Facebook
  getUserPicture: ->
    url = "/" + $fb.userID + "/picture?width=500&height=500"
    FB.api url, (result)->
      $fb.picture = result.data.url
      $util.urlToBlob $fb.picture, (blob)->
        loadImage [blob]
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

window.$facebook = new Facebook()
