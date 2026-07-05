RegisterNUICallback('finishGame', function(data, cb)
  local success = data.success
  print('sucess kkkkkkkkkkk', success)
  cb({})
end);


RegisterCommand('teste', function()
  print('teste')
  SetNuiFocus(true, true)
  SendNUIMessage({
    action = "show"
  })
end, false)
