(function(d, s, id) {
    var js, fjs = d.getElementsByTagName(s)[0];
    if (d.getElementById(id)) return;
    js = d.createElement(s); js.id = id;
    js.src = "//connect.facebook.net/zh_TW/sdk.js";
    fjs.parentNode.insertBefore(js, fjs);
  }(document, 'script', 'fb-root'));

$fbToken = null;

window.fbAsyncInit = function() {
  FB.init({
    appId      : '267188576687915',
    cookie     : true,  // enable cookies to allow the server to access
                        // the session
    xfbml      : true,  // parse social plugins on this page
    version    : 'v2.2' // use version 2.2
  });
  FB.getLoginStatus(function(response) {
    if (response.status === 'connected') {
      $fbToken = response.authResponse.accessToken;
    }
  } );
}


function publishFacebook(canvas){
  console.log('dentro publish');
  var dataURL = canvas.toDataURL("image/png")
  var blob = dataURLtoBlob(dataURL)
  var formData = new FormData();
  console.log(blob)
  formData.append("source", blob)
  console.log(formData);
  $.ajax({
    type: "POST",
    data: formData,
    url: "https://graph.facebook.com/me/photos?access_token="+$fbToken,
    success: function(data){
      console.log(data)
    },
    error: function(data){
      console.log(data)
    },
  });
}


function dataURLtoBlob(dataurl) {
    var arr = dataurl.split(','), mime = arr[0].match(/:(.*?);/)[1],
        bstr = atob(arr[1]), n = bstr.length, u8arr = new Uint8Array(n);
    while(n--){
        u8arr[n] = bstr.charCodeAt(n);
    }
    return new Blob([u8arr], {type:mime});
}
