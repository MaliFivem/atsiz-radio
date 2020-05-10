

ESX = nil
local PlayerData                = {}
local yuzenoyuncu = PlayerPedId()
local telefon = true           -- EĞER TELEFONUNUZUN BOZULMASINI İSTEMİYORSANIZ 'false' YAPIN.
local telsiz = true 	       -- EĞER TELSİZİN BOZULMASINI İSTEMİYORSANIZ 'false' YAPIN.
local karapara = false        -- EĞER KARA PARA'LARINIZIN ISLANMASINI/BOZULMASINI İSTEMİYORSANIZ 'false' YAPIN.
local nakitpara = false       -- EĞER NAKİT PARA'LARINIZIN ISLANMASINI/BOZULMASINI İSTEMİYORSANIZ 'false' YAPIN.

Citizen.CreateThread(function()
  while ESX == nil do
      TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
       while true do
         Citizen.Wait(1200)
        if IsEntityInWater(yuzenoyuncu) and IsPedSwimming(yuzenoyuncu) then
          if nakitpara == true then 
          TriggerServerEvent('atsiz-radio:nakitpara')
		  if telefon == true then
		  TriggerServerEvent('atsiz-radio:telefon')
		   if karapara == true then
		  TriggerServerEvent('atsiz-radio:karapara')
		  if telsiz == true then
		  TriggerServerEvent('atsiz-radio:telsiz')
						          end
				                                 end
					end
				end
			end
		end
	   end
     end
end)

RegisterNetEvent('atsiz-radio:bar')
AddEventHandler('atsiz-radio:bar', function()
	local oyuncu = PlayerPedId() 
	TaskStartScenarioInPlace(PlayerPedId(), 'WORLD_HUMAN_STAND_MOBILE', 0, false)
	ClearPedTasks(oyuncu)
	exports['progressBars']:startUI(7500, "Telsiz tamir ediliyor.")
	Citizen.Wait(7500)
	ClearPedTasks(oyuncu)
end)

RegisterNetEvent('atsiz-phone:bar')
AddEventHandler('atsiz-phone:bar', function()
	local oyuncu = PlayerPedId() 
	TaskStartScenarioInPlace(PlayerPedId(), 'WORLD_HUMAN_STAND_MOBILE', 0, false)
	ClearPedTasks(oyuncu)
	exports['progressBars']:startUI(7500, "Telefon tamir ediliyor.")
	Citizen.Wait(7500)
	ClearPedTasks(oyuncu)
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)


local radioMenu = false

function PrintChatMessage(text)
    TriggerEvent('chatMessage', "system", { 255, 0, 0 }, text)
end



function enableRadio(enable)
  
  if enable == true then
    if Config.DPEmotes then
      ExecuteCommand('e radio')
    else
      PhonePlayText()
      newPhoneProp()
    end
      SetNuiFocus(true, true)
      radioMenu = enable

      SendNUIMessage({

      type = "enableui",
        enable = enable

    })
  elseif enable == false then
    if Config.DPEmotes then
      ExecuteCommand('e c')
    else
      PhonePlayOut()
      deletePhone()
    end
    SetNuiFocus(true, true)
      radioMenu = enable

      SendNUIMessage({

      type = "enableui",
        enable = enable

    })
  end
end

--- sprawdza czy komenda /radio jest włączony

RegisterCommand('telsiz', function(source, args)
  ESX.TriggerServerCallback('ls-radio:getItemAmount', function(qtty)
    if qtty > 0 and Config.enableCmd then
      enableRadio(true)
    else
      exports['mythic_notify']:SendAlert('error', 'Telsize sahip değilsin!')
    end
  end, 'radio')
end, false)

-- radio test

RegisterCommand('frekanskontrol', function(source, args)
  local playerName = GetPlayerName(PlayerId())
  local data = exports.tokovoip_script:getPlayerData(playerName, "radio:channel")

  print(tonumber(data))

  if data == "nil" then
    exports['mythic_notify']:SendAlert('inform', Config.messages['not_on_radio'])
  else
   exports['mythic_notify']:SendAlert('inform', Config.messages['on_radio'] .. data .. '.00 MHz </b>')
 end

end, false)

-- dołączanie do radia

RegisterNUICallback('joinRadio', function(data, cb)
    local _source = source
    local PlayerData = ESX.GetPlayerData(_source)
    local playerName = GetPlayerName(PlayerId())
    local getPlayerRadioChannel = exports.tokovoip_script:getPlayerData(playerName, "radio:channel")

    if tonumber(data.channel) ~= tonumber(getPlayerRadioChannel) then
        if tonumber(data.channel) <= Config.RestrictedChannels then
          if(PlayerData.job.name == 'police' or PlayerData.job.name == 'ambulance' or PlayerData.job.name == 'fire') then
            exports.tokovoip_script:removePlayerFromRadio(getPlayerRadioChannel)
            exports.tokovoip_script:setPlayerData(playerName, "radio:channel", tonumber(data.channel), true);
            exports.tokovoip_script:addPlayerToRadio(tonumber(data.channel))
            exports['mythic_notify']:SendAlert('inform', Config.messages['joined_to_radio'] .. data.channel .. '.00 MHz </b>')
          elseif not (PlayerData.job.name == 'police' or PlayerData.job.name == 'ambulance') then
            --- info że nie możesz dołączyć bo nie jesteś policjantem
            exports['mythic_notify']:SendAlert('error', Config.messages['restricted_channel_error'])
          end
        end
        if tonumber(data.channel) > Config.RestrictedChannels then
          exports.tokovoip_script:removePlayerFromRadio(getPlayerRadioChannel)
          exports.tokovoip_script:setPlayerData(playerName, "radio:channel", tonumber(data.channel), true);
          exports.tokovoip_script:addPlayerToRadio(tonumber(data.channel))
          exports['mythic_notify']:SendAlert('inform', Config.messages['joined_to_radio'] .. data.channel .. '.00 MHz </b>')
        end
      else
        exports['mythic_notify']:SendAlert('error', Config.messages['you_on_radio'] .. data.channel .. '.00 MHz </b>')
      end
      --[[
    exports.tokovoip_script:removePlayerFromRadio(getPlayerRadioChannel)
    exports.tokovoip_script:setPlayerData(playerName, "radio:channel", tonumber(data.channel), true);
    exports.tokovoip_script:addPlayerToRadio(tonumber(data.channel))
    PrintChatMessage("radio: " .. data.channel)
    print('radiook')
      ]]--
    cb('ok')
end)

-- opuszczanie radia

RegisterNUICallback('leaveRadio', function(data, cb)
   local playerName = GetPlayerName(PlayerId())
   local getPlayerRadioChannel = exports.tokovoip_script:getPlayerData(playerName, "radio:channel")

    if getPlayerRadioChannel == "nil" then
      exports['mythic_notify']:SendAlert('inform', Config.messages['not_on_radio'])
        else
          exports.tokovoip_script:removePlayerFromRadio(getPlayerRadioChannel)
          exports.tokovoip_script:setPlayerData(playerName, "radio:channel", "nil", true)
          exports['mythic_notify']:SendAlert('inform', Config.messages['you_leave'] .. getPlayerRadioChannel .. '.00 MHz </b>')
    end

   cb('ok')

end)

RegisterNetEvent('fizzfau-radio:leave')
AddEventHandler('fizzfau-radio:leave', function()
  exports.tokovoip_script:removePlayerFromRadio(getPlayerRadioChannel)
  exports.tokovoip_script:setPlayerData(playerName, "radio:channel", "nil", true)
  exports['mythic_notify']:SendAlert('inform', Config.messages['you_leave'] .. getPlayerRadioChannel .. '.00 MHz </b>')
end)

RegisterNUICallback('escape', function(data, cb)

    enableRadio(false)
    SetNuiFocus(false, false)


    cb('ok')
end)

-- net eventy

RegisterNetEvent('ls-radio:use')
AddEventHandler('ls-radio:use', function()
  enableRadio(true)
end)

RegisterNetEvent('ls-radio:onRadioDrop')
AddEventHandler('ls-radio:onRadioDrop', function(source)
  local playerName = GetPlayerName(source)
  local getPlayerRadioChannel = exports.tokovoip_script:getPlayerData(playerName, "radio:channel")


  if getPlayerRadioChannel ~= "nil" then

    exports.tokovoip_script:removePlayerFromRadio(getPlayerRadioChannel)
    exports.tokovoip_script:setPlayerData(playerName, "radio:channel", "nil", true)
    exports['ls_notify']:SendAlert('inform', Config.messages['you_leave'] .. getPlayerRadioChannel .. '.00 MHz </b>')

end
end)

Citizen.CreateThread(function()
    while true do
        if radioMenu then
            DisableControlAction(0, 1, guiEnabled) -- LookLeftRight
            DisableControlAction(0, 2, guiEnabled) -- LookUpDown

            DisableControlAction(0, 142, guiEnabled) -- MeleeAttackAlternate

            DisableControlAction(0, 106, guiEnabled) -- VehicleMouseControlOverride

            if IsDisabledControlJustReleased(0, 142) then -- MeleeAttackAlternate
                SendNUIMessage({
                    type = "click"
                })
            end
        end
        Citizen.Wait(0)
    end
end)
