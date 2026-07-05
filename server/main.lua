local QBCore = exports['qb-core']:GetCoreObject()


QBCore.Functions.CreateCallback('atm-robbery:canStart', function(source, cb)
  local Player = QBCore.Functions.GetPlayer(source)

  if not Player then return cb(false, "Jogador não encontrado") end

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
