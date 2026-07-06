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
          CollectMoney(index, coord)
          print('coletando dinheiro')
        end
      elseif not isBusy then
        DrawText3D(coord, "[~g~G~w~] Roubar")
        if IsControlJustReleased(0, 47) then
          StartRobbery(index)
          print('iniciando o roubo')
        end
      end
    end
    Wait(sleep)
  end
end)

function StartRobbery(index)
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
  end, index)
end

RegisterNUICallback('finishGame', function(data, cb)
  SetNuiFocus(false, false)
  SendNUIMessage({ action = 'hide' })
  cb({})

  if data.success then
    print('plantando c4')
    PlantC4()
  else
    TriggerServerEvent('atm-robbery:plantC4')
    QBCore.Functions.Notify('Você falhou em arrombar o ATM', 'error')
    isBusy = false
    plantedAtmIndex = nil
  end
end)

function PlantC4()
  local ped = PlayerPedId()

  TriggerServerEvent('atm-robbery:plantC4')

  RequestAnimDict(Config.PlantAnim.dict)
  while not HasAnimDictLoaded(Config.PlantAnim.dict) do Wait(0) end

  TaskPlayAnim(ped, Config.PlantAnim.dict, Config.PlantAnim.name, 8.0, -8.0, Config.PlantAnim.duration, 0, 0, false,
    false, false)
  Wait(Config.PlantAnim.duration)
  ClearPedTasks(ped)

  QBCore.Functions.Notify('C4 plantado! Afaste-se!', 'primary')

  local index = plantedAtmIndex
  local coord = Config.Locations[index]

  CreateThread(function()
    local endTime = GetGameTimer() + Config.ExplosionDelay

    while GetGameTimer() < endTime do
      PlaySoundFromCoord(-1, 'Beep_Red', coord.x, coord.y, coord.z, "DLC_HEIST_HACKING_SNAKE_SOUNDS", false, 30, false)

      local remaining = endTime - GetGameTimer()

      if remaining < 3000 then
        Wait(200)
      elseif remaining < 7000 then
        Wait(400)
      else
        Wait(1000)
      end
    end

    AddExplosion(coord.x, coord.y, coord.z, 2, 1.0, true, false, 1.0)

    collectableAtmIndex = index
    isBusy = false
    QBCore.Functions.Notify('Dinheiro pronto para coletar', 'success')
  end)
end

function CollectMoney(index, coord)
  isBusy = true
  local ped = PlayerPedId()

  RequestAnimDict(Config.CollectAnim.dict)
  while not HasAnimDictLoaded(Config.CollectAnim.dict) do Wait(0) end
  TaskPlayAnim(ped, Config.CollectAnim.dict, Config.CollectAnim.name, 8.0, -8.0, -1, 1, 0, false, false, false)

  QBCore.Functions.Progressbar('collect_atm', 'Coletando dinheiro...', Config.CollectDuration, false, true, {
    disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = true
  }, {}, {}, {}, function()
    ClearPedTasks(ped)
    TriggerServerEvent('atm-robbery:collectReward', index)
    collectableAtmIndex = nil
    isBusy = false
  end, function()
    ClearPedTasks(ped)
    isBusy = false
    QBCore.Functions.Notify('Você cancelou', 'error')
  end)
end

function DrawText3D(coord, text)
  SetTextScale(0.35, 0.35)
  SetTextFont(4)
  SetTextProportional(true)
  SetTextColour(255, 255, 255, 215)
  SetTextEntry('STRING')
  SetTextCentre(true)
  AddTextComponentString(text)
  SetDrawOrigin(coord.x, coord.y, coord.z + 1.0, 0)
  DrawText(0.0, 0.0)
  ClearDrawOrigin()
end
