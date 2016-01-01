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

window.$util = new Util()
