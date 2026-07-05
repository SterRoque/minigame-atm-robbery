local QBCore = exports['qb-core']:GetCoreObject()
local isBusy = false
local plantedAtmIndex = nil
local collectableAtmIndex = nil

local DISTANCE_INTERACT = 2.0


local function getNearbyATM()
  local pos = GetEntityCoords(PlayerPedId())

  for i, atmCoord in ipairs(Config.Locations) do
    if #(pos - atmCoord) <= DISTANCE_INTERACT then
      return i, atmCoord
    end
  end
end

CreateThread(function()
  while true do
    local sleep = 1000
    local index, coord = getNearbyATM()

    if index then
      sleep = 0

      if collectableAtmIndex == index then
        DrawText3D(coord, "[~g~E~w~] Coletar dinheiro")

        if IsControlJustReleased(0, 38) and not isBusy then
          -- CollectMoney(index, coord)
          print('coletando dinheiro')
        end
      elseif not isBusy then
        DrawText3D(coord, "[~g~G~w~] Roubar")
        if IsControlJustReleased(0, 47) then
          StartRobbery(index, coord)
          print('iniciando o roubo')
        end
      end
    end
    Wait(sleep)
  end
end)

function StartRobbery(index, coord)
  isBusy = true

  QBCore.Functions.TriggerCallback('atm-robbery:canStart', function(canStart, reason)
    if not canStart then
      QBCore.Functions.Notify(reason or "Você não pode iniciar o roubo agora", "error")
      isBusy = false
      return
    end

    plantedAtmIndex = index
    SetNuiFocus(true, true)
    SendNUIMessage({ action = 'show' })
  end, coord)
end

RegisterNUICallback('finishGame', function(data, cb)
  SetNuiFocus(false, false)
  SendNUIMessage({ action = 'hide' })
  cb({})

  if data.success then
    print('plantando c4')
  else
    QBCore.Functions.Notify('Você falhou em arrombar o ATM', 'error')
    isBusy = false
    plantedAtmIndex = nil
  end
end)

function DrawText3D(coord, text)
  SetTextScale(0.35, 0.35)
  SetTextFont(4)
  SetTextProportional(1)
  SetTextColour(255, 255, 255, 215)
  SetTextEntry('STRING')
  SetTextCentre(true)
  AddTextComponentString(text)
  SetDrawOrigin(coord.x, coord.y, coord.z + 1.0, 0)
  DrawText(0.0, 0.0)
  ClearDrawOrigin()
end
