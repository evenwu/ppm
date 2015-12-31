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

window.$fbToken = null
window.$fbUserId = null

window.fbAsyncInit = ->
  FB.init
    appId: '267188576687915'
    cookie: true
    xfbml: true
    version: 'v2.2'
  FB.getLoginStatus (response) ->
    if response.status == 'connected'
      window.$fbToken  = response.authResponse.accessToken
      window.$fbUserId = response.authResponse.userID;
      url = "/" + $fbUserId + "/picture?width=500&height=500"
      FB.api url, (res)->
        urlToBlob res.data.url, (blob)->
          loadImage [blob]

