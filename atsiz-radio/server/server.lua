ESX               = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem('radio', function(source)

	local xPlayer = ESX.GetPlayerFromId(source)
	local battery = xPlayer.getInventoryItem('battery').count

	if battery > 0 then
	TriggerClientEvent('ls-radio:use', source)
else
	TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Yanında pil yok!' })
end

end)

ESX.RegisterUsableItem('telefontamir', function(source)
	TriggerClientEvent('atsiz-phone:bar', source);
	Citizen.Wait(7500)
	local xPlayer = ESX.GetPlayerFromId(source)
	local telefontamir = xPlayer.getInventoryItem('telefontamir').count
	local phoneitem = xPlayer.getInventoryItem('phone')
	if phoneitem.count >= 1 then
		if telefontamir >= 1 then
			xPlayer.removeInventoryItem('telefontamir', 1)
			Citizen.Wait(1000)
			xPlayer.removeInventoryItem('bozuktelefon', 1)
			Citizen.Wait(1000)
			xPlayer.addInventoryItem('phone', 1)
		end
	end
end)

ESX.RegisterUsableItem('telsiztamir', function(source)
	TriggerClientEvent('atsiz-radio:bar', source);
	Citizen.Wait(7500)
	local xPlayer = ESX.GetPlayerFromId(source)
	local telsiztamir = xPlayer.getInventoryItem('telsiztamir').count
	local radioitem = xPlayer.getInventoryItem('radio')
	if radioitem.count >= 1 then
		if telsiztamir >= 1 then
			xPlayer.removeInventoryItem('telsiztamir', 1)
			Citizen.Wait(1000)
			xPlayer.removeInventoryItem('bozuktelsiz', 1)
			Citizen.Wait(1000)
			xPlayer.addInventoryItem('radio', 1)
		end
	end
end)

RegisterServerEvent("atsiz-radio:nakitpara")
AddEventHandler("atsiz-radio:nakitpara", function()
    local xPlayer = ESX.GetPlayerFromId(source)

    local nakitpara = xPlayer.getMoney()
     if nakitpara > 0 then
     xPlayer.removeMoney(nakitpara)
	 TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Suya girdiğin için üzerindeki bütün paralar ıslandı. Artık kullanamazsın.',  length = 3000})
    end
end)

RegisterServerEvent("atsiz-radio:karapara")
AddEventHandler("atsiz-radio:karapara", function()
    local xPlayer = ESX.GetPlayerFromId(source)

    local karapara = xPlayer.getAccount('black_money').money
     if karapara > 0 then
     xPlayer.removeAccountMoney('black_money', karapara)
	 TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Suya girdiğin için üzerindeki bütün kara paralar ıslandı. Artık kullanamazsın.',  length = 3000})
    end
end)

RegisterServerEvent("atsiz-radio:telefon")
AddEventHandler("atsiz-radio:telefon", function()
    local xPlayer = ESX.GetPlayerFromId(source)

    local telefon = xPlayer.getInventoryItem("phone")["count"]
     if telefon > 0 then
     xPlayer.removeInventoryItem("phone", telefon)
     xPlayer.addInventoryItem('kiriktelefon', 1)
	 TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Suya girdiğin için telefonun bozuldu.',  length = 3000})
    end
end)

RegisterServerEvent("atsiz-radio:telsiz")
AddEventHandler("atsiz-radio:telsiz", function()
    local xPlayer = ESX.GetPlayerFromId(source)

    local telefon = xPlayer.getInventoryItem("radio")["count"]
     if telsiz > 0 then
     xPlayer.removeInventoryItem("radio", telsiz)
     xPlayer.addInventoryItem('bozuktelsiz', 1)
	 TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Suya girdiğin için telsiz bozuldu!',  length = 3000})
    end
end)

-- checking is player have item

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1000)
    local xPlayers = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
          if xPlayer ~= nil then
              if xPlayer.getInventoryItem('radio').count == 0 then

                local source = xPlayers[i]
                TriggerClientEvent('ls-radio:onRadioDrop', source)

                break
              end
            end
          end
        end
      end)

      ESX.RegisterServerCallback('ls-radio:getItemAmount', function(source, cb, item)
        local xPlayer = ESX.GetPlayerFromId(source)
        local qtty = xPlayer.getInventoryItem(item).count
        cb(qtty)
    end)
