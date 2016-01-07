class Util
  urlToBlob: (url, callback)->
    xhr = new XMLHttpRequest
    xhr.open 'GET', url, true
    xhr.responseType = 'arraybuffer'

    xhr.onload = (e) ->
      # Obtain a blob: URL for the image data.
      arrayBufferView = new Uint8Array(@response)
      blob = new Blob([ arrayBufferView ], type: 'image/png')
      callback(blob)

    xhr.send()

  getBackgroundSize: (string)->
    size = string.split(' ');
    [pix2int(size[0]), pix2int(size[1])];

  getBackgroundPosition: (string)->
    position = string.split(' ');
    [pix2int(position[0]), pix2int(position[1])];

  getBackgroundCenterPoint: (size, position)->
    [size[0]*0.5 + position[0],size[1]*0.5 + position[1]]

  getImgSize: (src)->
    newImg = new Image();
    newImg.src = src;
    [newImg.width, newImg.height]

  getBackgroundImageUrl: (element)->
    url = element.css('background-image')
    url.replace(/^url\(["']?/, '').replace(/["']?\)$/, '')

  pix2int = (string)->
    parseFloat(string.replace('px',''));

  downloadByBase64: (base64, callback)->
    $util.uploadBase64 base64, (url, w)->
      if $util.isDesktop() && !$util.isSafari()
        $util.urlToBlob url, (blob)->
          w.close()
          saveAs(blob, 'iing-no-2.png')
      else
        callback(url, w)
  uploadBase64: (base64, callback)->
    endpoing = "http://iing.tw/badges.json"
    directDownload = false
    if $util.isFBWebview()
      w = window
    else
      w = window.open("/waiting.html", "wait", "width=500, height=500, menubar=no, resizable=no, scrollbars=no, status=no, titlebar=no, toolbar=no")
    $.post endpoing, { data: base64 }, (result)->
      callback(result.url, w)

  resizeWindow: (w, width, height)->
    if w.outerWidth
      w.resizeTo(
          width + (w.outerWidth - w.innerWidth),
          height + (w.outerHeight - w.innerHeight)
      )
    else
      w.resizeTo(500, 500)
      w.resizeTo(
          width + (500 - w.document.body.offsetWidth),
          height + (500 - w.document.body.offsetHeight)
      )

  isFBWebview: ->
    navigator.userAgent.match(/FB/)

  isDesktop: ->
    WURFL.form_factor == 'Desktop'

  isSafari: ->
    /^((?!chrome|android).)*safari/i.test(navigator.userAgent)

window.$util = new Util()

window.xx = (v)->
  console.log(v)

# document.write(WURFL.complete_device_name)
# document.write(WURFL.form_factor)
# document.write(WURFL.is_mobile)
