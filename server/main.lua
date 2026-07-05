local QBCore = exports['qb-core']:GetCoreObject()
local cooldowns = {}


QBCore.Functions.CreateCallback('atm-robbery:canStart', function(source, cb, index)
  local Player = QBCore.Functions.GetPlayer(source)

  if not Player then return cb(false, "Jogador não encontrado") end

  if cooldowns[index] and cooldowns[index] > os.time() then
    return cb(false, "Este ATM já foi roubado recentemente")
  end

  local item = Player.Functions.GetItemByName(Config.RequiredItem)

  if not item or item.amount < 1 then
    return cb(false, "Você precisa de uma C4 para roubar")
  end

  cb(true)
end)


RegisterNetEvent('atm-robbery:plantC4', function()
  local src = source
  local Player = QBCore.Functions.GetPlayer(src)

  if not Player then return end

  Player.Functions.RemoveItem(Config.RequiredItem, 1)
  TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.RequiredItem], 'remove')
end)

RegisterNetEvent('atm-robbery:collectReward', function(index)
  local src = source
  local Player = QBCore.Functions.GetPlayer(src)
  if not Player then return end

  local coord = Config.Locations[index]
  if not coord then return end

  local ped = GetPlayerPed(src)
  local pos = GetEntityCoords(ped)
  if #(pos - coord) > 5.0 then return end

  if cooldowns[index] and cooldowns[index] > os.time() then
    return TriggerClientEvent('QBCore:Notify', src, 'Este ATM já foi roubado recentemente', 'error')
  end

  local reward = math.random(Config.Reward.min, Config.Reward.max)
  local info = { worth = reward }

  local added = Player.Functions.AddItem('markedbills', 1, false, info)
  if not added then
    return TriggerClientEvent('QBCore:Notify', src, 'Seu inventário está cheio', 'error')
  end

  cooldowns[index] = os.time() + (Config.Cooldown / 1000)

  TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['markedbills'], 'add')
  TriggerClientEvent('QBCore:Notify', src, ('Você pegou notas marcadas ($%d)'):format(reward), 'success')
end)
