Config = {}

Config.RestrictedChannels = 10 -- Şifreli kanalları belirler. Ne kadar arttırırsanız o kadar kanal şifreli olur.
Config.enableCmd = true --  /telsiz komutu ile bağlanmak istiyorsanız true yapın.

Config.messages = {

  ['not_on_radio'] = 'Herhangi bir frekansa bağlı değilsiniz!',
  ['on_radio'] = 'Radyo frekansına bağlısınız! <b>',
  ['joined_to_radio'] = 'Radyo frekansına bağlandınız! <b>',
  ['restricted_channel_error'] = 'Şifreli kanallara giremezsiniz!',
  ['you_on_radio'] = 'Zaten bir kanala bağlısınız! <b>',
  ['you_leave'] = 'Kanalı terk ettiniz! <b>'

}
