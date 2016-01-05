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

  uploadBase64: (base64, callback)->
    endpoing = "http://iing.tw/badges.json"
    w = window.open("/waiting.html", "wait", "width=500, height=500, menubar=no, resizable=no, scrollbars=no, status=no, titlebar=no, toolbar=no")
    $.post endpoing, { data: base64 }, (result)->
      callback(result.url, w)

window.$util = new Util()

window.xx = (v)->
  console.log(v)

