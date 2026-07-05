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
