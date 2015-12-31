window.urlToBlob = (url, cb)->
  xhr = new XMLHttpRequest
  xhr.open 'GET', url, true
  xhr.responseType = 'arraybuffer'

  xhr.onload = (e) ->
    # Obtain a blob: URL for the image data.
    arrayBufferView = new Uint8Array(@response)
    blob = new Blob([ arrayBufferView ], type: 'image/jpeg')
    cb(blob)

  xhr.send()
