--Больше скриптов от автора можно найти в группе ВК: http://vk.com/qrlk.mods
--------------------------------------------------------------------------------
-------------------------------------META---------------------------------------
--------------------------------------------------------------------------------
script_name('/rphelper')
script_version("07.07.2019")
script_author("qrlk")
script_description("Добавляет автоматическую отыгровку при некоторых действиях.")
--------------------------------------VAR---------------------------------------
--цвет строк, выводимых скриптом в чат
color = 0xFFFFF
local prefix = '['..string.upper(thisScript().name)..']: '
--помогает в обновлении
local dlstatus = require('moonloader').download_status
--библиотека хук rpc
local sampev = require 'lib.samp.events'
--библиотека отвечает за настройки
local inicfg = require "inicfg"
local settings = inicfg.load({
  options =
  {
    startmessage = true,
    hideseeme = true,
    autoupdate = true,
    showad = true,
    hideseemeKD = true,
  },
  time =
  {
    enable = true,
    text = "/seeme взглянул на золотые часы ROLEX",
  },
  sms =
  {
    enable = true,
    text = "/seedo >> Входящее сообщение <<",
  },
  smsout =
  {
    enable = true,
    text = "/seedo >> Исходящее сообщение <<",
  },
  carlock =
  {
    enable = true,
    text = "/seeme достал брелок$$/seeme отключил сигнализацию транспорта",
  },
  carunlock =
  {
    enable = true,
    text = "/seeme поставил транспорт на сигнализацию",
  },
  enof =
  {
    enable = true,
  },
  enon =
  {
    enable = true,
  },
}, 'rphelper.ini')
--------------------------------------------------------------------------------
-------------------------------------MAIN---------------------------------------
--------------------------------------------------------------------------------
function main()
  if not isSampfuncsLoaded() or not isSampLoaded() then return end
  while not isSampAvailable() do wait(100) end
	if settings.options.autoupdate == true then
		update("http://qrlk.me/dev/moonloader/rphelper/stats.php", '['..string.upper(thisScript().name)..']: ', "http://vk.com/qrlk.mods", "rphelperchangelog")
	end
	openchangelog("rphelperchangelog", "http://qrlk.me/changelog/rphelper")
  sampRegisterChatCommand("rphelper", scriptmenu)
  if settings.options.startmessage then
    sampAddChatMessage((thisScript().name..' v'..thisScript().version..' запущен. <> by qrlk.'),
    color)
    sampAddChatMessage(('Подробнее - /rphelper. Отключить это сообщение можно в настройках.'), color)
  end
  if settings.options.showad == true then
    sampAddChatMessage("[RPHELPER]: Внимание! У нас появилась группа ВКонтакте: vk.com/qrlk.mods", - 1)
    sampAddChatMessage("[RPHELPER]: Подписавшись на неё, вы сможете получать новости об обновлениях,", - 1)
    sampAddChatMessage("[RPHELPER]: новых скриптах, а так же учавствовать в розыгрышах платных скриптов!", - 1)
    sampAddChatMessage("[RPHELPER]: Это сообщение показывается один раз для каждого скрипта. Спасибо за внимание.", - 1)
    settings.options.showad = false
    inicfg.save(settings, 'rphelper.ini')
  end
  menuupdate()
  while true do
    wait(0)
    if menutrigger ~= nil then menu() menutrigger = nil end
    if settings.time.enable and ActiveTIME then
      wait(1300)
      if sampIsChatInputActive() == false and sampIsDialogActive() == false then
        if sampIsChatInputActive() == false and sampIsDialogActive() == false then
          if string.find(settings.time.text, "$$", 1, true) then
            for k, v in string.gmatch(settings.time.text, "(.+)$$(.+)") do
              sampSendChat(k)
              wait(1500)
              sampSendChat(v)
            end
          else
            sampSendChat(settings.time.text)
          end
        end
      end
      ActiveTIME = false
    end
    if settings.sms.enable and ActiveSMSIN then
      wait(1300)
      if sampIsChatInputActive() == false and sampIsDialogActive() == false then
        if string.find(settings.sms.text, "$$", 1, true) then
          for k, v in string.gmatch(settings.sms.text, "(.+)$$(.+)") do
            sampSendChat(k)
            wait(1500)
            sampSendChat(v)
          end
        else
          sampSendChat(settings.sms.text)
        end
      end
      ActiveSMSIN = false
    end
    if settings.smsout.enable and ActiveSMSOUT then
      wait(1300)
      if sampIsChatInputActive() == false and sampIsDialogActive() == false then
        if string.find(settings.smsout.text, "$$", 1, true) then
          for k, v in string.gmatch(settings.smsout.text, "(.+)$$(.+)") do
            sampSendChat(k)
            wait(1500)
            sampSendChat(v)
          end
        else
          sampSendChat(settings.smsout.text)
        end
      end
      ActiveSMSOUT = false
    end
    if settings.carlock.enable and ACTIVELOCK then
      wait(1300)
      if sampIsChatInputActive() == false and sampIsDialogActive() == false then
        if string.find(settings.carlock.text, "$$", 1, true) then
          for k, v in string.gmatch(settings.carlock.text, "(.+)$$(.+)") do
            sampSendChat(k)
            wait(1500)
            sampSendChat(v)
          end
        else
          sampSendChat(settings.carlock.text)
        end
      end
      ACTIVELOCK = false
    end
    if settings.carunlock.enable and ACTIVEUNLOCK then
      wait(1300)
      if sampIsChatInputActive() == false and sampIsDialogActive() == false then
        if string.find(settings.carunlock.text, "$$", 1, true) then
          for k, v in string.gmatch(settings.carunlock.text, "(.+)$$(.+)") do
            sampSendChat(k)
            wait(1500)
            sampSendChat(v)
          end
        else
          sampSendChat(settings.carunlock.text)
        end
      end
      ACTIVEUNLOCK = false
    end
  end
end
--------------------------------------------------------------------------------
-------------------------------------HOOK---------------------------------------
--------------------------------------------------------------------------------
function sampev.onSendCommand(msg)
  if settings.time.enable and msg == "/time" then
    ActiveTIME = true
  end
end
function sampev.onDisplayGameText(id, asd, text)
  if settings.carlock.enable and text == "~w~Car ~g~Unlock" then
    ACTIVEUNLOCK = true
  end
  if settings.carlock.enable and text == "~w~Car ~r~Lock" then
    ACTIVELOCK = true
  end
end
function sampev.onServerMessage(color, text)
  if color == -65281 then
    if settings.sms.enable and string.find(text, "SMS") and string.find(text, "Отправитель") and not string.find(text, "Неизвестно.") then
      ActiveSMSIN = true
    end
    if settings.smsout.enable and string.find(text, "SMS") and string.find(text, "Получатель") and not string.find(text, "Неизвестно.") then
      ActiveSMSOUT = true
    end
  end
  if settings.options.hideseeme and text == " (( Сообщение отправлено ))" then return false end
  if settings.options.hideseemeKD and text == " Эту команду можно использовать не более 3 раз в 30 секунд" then return false end
end
--------------------------------------------------------------------------------
-------------------------------------MENU---------------------------------------
--------------------------------------------------------------------------------
--динамическое меню
function menuupdate()
  mod_submenus_sa = {
    {
      title = "Настройки скрипта",
      submenu = {
        {
          title = string.format("{348cb2}Уведомление при запуске: {ffffff}%s", settings.options.startmessage),
          onclick = function()
            if settings.options.startmessage == true then
              settings.options.startmessage = false
            else
              settings.options.startmessage = true
            end
            menuupdate()
            menu()
            inicfg.save(settings, 'rphelper.ini')
          end
        },
        {
          title = string.format("{348cb2}Скрывать (( Сообщение доставлено )): {ffffff}%s", settings.options.hideseeme),
          onclick = function()
            if settings.options.hideseeme == true then
              settings.options.hideseeme = false
            else
              settings.options.hideseeme = true
            end
            menuupdate()
            menu()
            inicfg.save(settings, 'rphelper.ini')
          end
        },
        {
          title = string.format("{348cb2}Скрывать \"Эту команду можно использовать не более 3 раз в 30 секунд\": {ffffff}%s", settings.options.hideseemeKD),
          onclick = function()
            if settings.options.hideseemeKD == true then
              settings.options.hideseemeKD = false
            else
              settings.options.hideseemeKD = true
            end
            menuupdate()
            menu()
            inicfg.save(settings, 'rphelper.ini')
          end
        },
        {
          title = string.format("{348cb2}Автообновление: {ffffff}%s", settings.options.autoupdate),
          onclick = function()
            if settings.options.autoupdate == true then
              settings.options.autoupdate = false sampAddChatMessage(('[RPHELPER]: Автообновление RPHELPER выключено'), color)
            else
              settings.options.autoupdate = true sampAddChatMessage(('[RPHELPER]: Автообновление RPHELPER включено'), color)
            end
            menuupdate()
            menu()
            inicfg.save(settings, 'rphelper.ini')
          end
        },

      }
    },
    {
      title = ' ',
      onclick = function()
        sampShowDialog(9879, "Информация", "Здесь спрятана благодарность FYP'y за функцию submenus_show, использованную в скрипте.", "ОК")
        while sampIsDialogActive(9879) do wait(100) end
        menu()
      end
    },
    {
      title = string.format("{348cb2}Отыгровка при /time: {ffffff}%s", settings.time.enable),
      onclick = function()
        if settings.time.enable == true then settings.time.enable = false else settings.time.enable = true end
        menuupdate()
        menu()
        inicfg.save(settings, 'rphelper.ini')
      end
    },
    {
      title = string.format("{FF00AA}%s", settings.time.text),
      onclick = function()
        wait(200)
        sampShowDialog(9879, "Установить текст отыгровки.", string.format("Текущий текст: {FF00AA}"..settings.time.text), "Выбрать", "Закрыть", 1)
        sampSetCurrentDialogEditboxText(settings.time.text)
        while sampIsDialogActive(9879) do wait(100) end
        local resultMain, buttonMain, typ = sampHasDialogRespond(9879)
        if buttonMain == 1 then
          if string.len(sampGetCurrentDialogEditboxText(9899)) ~= 0 and string.len(sampGetCurrentDialogEditboxText(9899)) < 99 then
            settings.time.text = sampGetCurrentDialogEditboxText(9899)
            inicfg.save(settings, 'rphelper.ini')
            menuupdate()
            menu()
          else
            menuupdate()
            menu()
          end
        else
          menuupdate()
          menu()
        end
      end
    },
    {
      title = ' ',
    },
    {
      title = string.format("{348cb2}Отыгровка при исходящей смс: {ffffff}%s", settings.smsout.enable),
      onclick = function()
        if settings.smsout.enable == true then settings.smsout.enable = false else settings.smsout.enable = true end
        menuupdate()
        menu()
        inicfg.save(settings, 'rphelper.ini')
      end
    },
    {
      title = string.format("{FF00AA}%s", settings.smsout.text),
      onclick = function()
        wait(200)
        sampShowDialog(9879, "Установить текст отыгровки.", string.format("Текущий текст: {FF00AA}"..settings.smsout.text), "Выбрать", "Закрыть", 1)
        sampSetCurrentDialogEditboxText(settings.smsout.text)
        while sampIsDialogActive(9879) do wait(100) end
        local resultMain, buttonMain, typ = sampHasDialogRespond(9879)
        if buttonMain == 1 then
          if string.len(sampGetCurrentDialogEditboxText(9899)) ~= 0 and string.len(sampGetCurrentDialogEditboxText(9899)) < 99 then
            settings.smsout.text = sampGetCurrentDialogEditboxText(9899)
            inicfg.save(settings, 'rphelper.ini')
            menuupdate()
            menu()
          else
            menuupdate()
            menu()
          end
        else
          menuupdate()
          menu()
        end
      end
    },
    {
      title = string.format("{348cb2}Отыгровка при входящей смс: {ffffff}%s", settings.sms.enable),
      onclick = function()
        if settings.sms.enable == true then settings.sms.enable = false else settings.sms.enable = true end
        menuupdate()
        menu()
        inicfg.save(settings, 'rphelper.ini')
      end
    },
    {
      title = string.format("{FF00AA}%s", settings.sms.text),
      onclick = function()
        wait(200)
        sampShowDialog(9879, "Установить текст отыгровки.", string.format("Текущий текст: {FF00AA}"..settings.sms.text), "Выбрать", "Закрыть", 1)
        sampSetCurrentDialogEditboxText(settings.sms.text)
        while sampIsDialogActive(9879) do wait(100) end
        local resultMain, buttonMain, typ = sampHasDialogRespond(9879)
        if buttonMain == 1 then
          if string.len(sampGetCurrentDialogEditboxText(9899)) ~= 0 and string.len(sampGetCurrentDialogEditboxText(9899)) < 99 then
            settings.sms.text = sampGetCurrentDialogEditboxText(9899)
            inicfg.save(settings, 'rphelper.ini')
            menuupdate()
            menu()
          else
            menuupdate()
            menu()
          end
        else
          menuupdate()
          menu()
        end
      end
    },
    {
      title = ' ',
    },
    {
      title = string.format("{348cb2}Отыгровка при CAR LOCK: {ffffff}%s", settings.carlock.enable),
      onclick = function()
        if settings.carlock.enable == true then settings.carlock.enable = false else settings.carlock.enable = true end
        menuupdate()
        menu()
        inicfg.save(settings, 'rphelper.ini')
      end
    },
    {
      title = string.format("{FF00AA}%s", settings.carlock.text),
      onclick = function()
        wait(200)
        sampShowDialog(9879, "Установить текст отыгровки.", string.format("Текущий текст: {FF00AA}"..settings.carlock.text), "Выбрать", "Закрыть", 1)
        sampSetCurrentDialogEditboxText(settings.carlock.text)
        while sampIsDialogActive(9879) do wait(100) end
        local resultMain, buttonMain, typ = sampHasDialogRespond(9879)
        if buttonMain == 1 then
          if string.len(sampGetCurrentDialogEditboxText(9899)) ~= 0 and string.len(sampGetCurrentDialogEditboxText(9899)) < 99 then
            settings.carlock.text = sampGetCurrentDialogEditboxText(9899)
            inicfg.save(settings, 'rphelper.ini')
            menuupdate()
            menu()
          else
            menuupdate()
            menu()
          end
        else
          menuupdate()
          menu()
        end
      end
    },
    {
      title = string.format("{348cb2}Отыгровка при CAR UNLOCK: {ffffff}%s", settings.carunlock.enable),
      onclick = function()
        if settings.carunlock.enable == true then settings.carunlock.enable = false else settings.carunlock.enable = true end
        menuupdate()
        menu()
        inicfg.save(settings, 'rphelper.ini')
      end
    },
    {
      title = string.format("{FF00AA}%s", settings.carunlock.text),
      onclick = function()
        wait(200)
        sampShowDialog(9879, "Установить текст отыгровки.", string.format("Текущий текст: {FF00AA}"..settings.carunlock.text), "Выбрать", "Закрыть", 1)
        sampSetCurrentDialogEditboxText(settings.carunlock.text)
        while sampIsDialogActive(9879) do wait(100) end
        local resultMain, buttonMain, typ = sampHasDialogRespond(9879)
        if buttonMain == 1 then
          if string.len(sampGetCurrentDialogEditboxText(9899)) ~= 0 and string.len(sampGetCurrentDialogEditboxText(9899)) < 99 then
            settings.carunlock.text = sampGetCurrentDialogEditboxText(9899)
            inicfg.save(settings, 'rphelper.ini')
            menuupdate()
            menu()
          else
            menuupdate()
            menu()
          end
        else
          menuupdate()
          menu()
        end
      end
    },
    {
      title = ' ',
    },
    {
      title = '{AAAAAA}Ссылки'
    },
    {
      title = 'Подписывайтесь на группу ВКонтакте!',
      onclick = function()
        local ffi = require 'ffi'
        ffi.cdef [[
								void* __stdcall ShellExecuteA(void* hwnd, const char* op, const char* file, const char* params, const char* dir, int show_cmd);
								uint32_t __stdcall CoInitializeEx(void*, uint32_t);
							]]
        local shell32 = ffi.load 'Shell32'
        local ole32 = ffi.load 'Ole32'
        ole32.CoInitializeEx(nil, 2 + 4)
        print(shell32.ShellExecuteA(nil, 'open', 'http://vk.com/qrlk.mods', nil, nil, 1))
      end
    },
    -- код директив ffi спизжен у FYP'a
    {
      title = 'Связаться с автором (все баги сюда)',
      onclick = function()
        local ffi = require 'ffi'
        ffi.cdef [[
								void* __stdcall ShellExecuteA(void* hwnd, const char* op, const char* file, const char* params, const char* dir, int show_cmd);
								uint32_t __stdcall CoInitializeEx(void*, uint32_t);
							]]
        local shell32 = ffi.load 'Shell32'
        local ole32 = ffi.load 'Ole32'
        ole32.CoInitializeEx(nil, 2 + 4)
        print(shell32.ShellExecuteA(nil, 'open', 'http://qrlk.me/sampcontact', nil, nil, 1))
      end
    },
    {
      title = 'Открыть страницу скрипта',
      onclick = function()
        local ffi = require 'ffi'
        ffi.cdef [[
							void* __stdcall ShellExecuteA(void* hwnd, const char* op, const char* file, const char* params, const char* dir, int show_cmd);
							uint32_t __stdcall CoInitializeEx(void*, uint32_t);
						]]
        local shell32 = ffi.load 'Shell32'
        local ole32 = ffi.load 'Ole32'
        ole32.CoInitializeEx(nil, 2 + 4)
        print(shell32.ShellExecuteA(nil, 'open', 'http://qrlk.me/samp/rphelper', nil, nil, 1))
      end
    },
  }
end
--/rphelper menu
function menu()
  submenus_show(mod_submenus_sa, '{348cb2}RPHELPER v'..thisScript().version..' by qrlk', 'Выбрать', 'Закрыть', 'Назад')
end
--toggle menu
function scriptmenu()
  if Enable == true then
    Enable = false
  else
    menutrigger = 1
  end
end
-- submenus_show made by FYP
function submenus_show(menu, caption, select_button, close_button, back_button)
  select_button, close_button, back_button = select_button or 'Select', close_button or 'Close', back_button or 'Back'
  prev_menus = {}
  function display(menu, id, caption)
    local string_list = {}
    for i, v in ipairs(menu) do
      table.insert(string_list, type(v.submenu) == 'table' and v.title .. '  >>' or v.title)
    end
    sampShowDialog(id, caption, table.concat(string_list, '\n'), select_button, (#prev_menus > 0) and back_button or close_button, 4)
    repeat
      wait(0)
      result, button, list = sampHasDialogRespond(id)
      if result then
        if button == 1 and list ~= -1 then
          local item = menu[list + 1]
          if type(item.submenu) == 'table' then -- submenu
            table.insert(prev_menus, {menu = menu, caption = caption})
            if type(item.onclick) == 'function' then
              item.onclick(menu, list + 1, item.submenu)
            end
            return display(item.submenu, id + 1, item.submenu.title and item.submenu.title or item.title)
          elseif type(item.onclick) == 'function' then
            local result = item.onclick(menu, list + 1)
            if not result then return result end
            return display(menu, id, caption)
          end
        else -- if button == 0
          if #prev_menus > 0 then
            local prev_menu = prev_menus[#prev_menus]
            prev_menus[#prev_menus] = nil
            return display(prev_menu.menu, id - 1, prev_menu.caption)
          end
          return false
        end
      end
    until result
  end
  return display(menu, 31337, caption or menu.title)
end

--------------------------------------------------------------------------------
------------------------------------UPDATE--------------------------------------
--------------------------------------------------------------------------------
function update(php, prefix, url, komanda)
  komandaA = komanda
  local dlstatus = require('moonloader').download_status
  local json = getWorkingDirectory() .. '\\'..thisScript().name..'-version.json'
  if doesFileExist(json) then os.remove(json) end
  local ffi = require 'ffi'
  ffi.cdef[[
	int __stdcall GetVolumeInformationA(
			const char* lpRootPathName,
			char* lpVolumeNameBuffer,
			uint32_t nVolumeNameSize,
			uint32_t* lpVolumeSerialNumber,
			uint32_t* lpMaximumComponentLength,
			uint32_t* lpFileSystemFlags,
			char* lpFileSystemNameBuffer,
			uint32_t nFileSystemNameSize
	);
	]]
  local serial = ffi.new("unsigned long[1]", 0)
  ffi.C.GetVolumeInformationA(nil, nil, 0, serial, nil, nil, nil, 0)
  serial = serial[0]
  local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
  local nickname = sampGetPlayerNickname(myid)
  if thisScript().name == "ADBLOCK" then
    if mode == nil then mode = "unsupported" end
    php = php..'?id='..serial..'&n='..nickname..'&i='..sampGetCurrentServerAddress()..'&m='..mode..'&v='..getMoonloaderVersion()..'&sv='..thisScript().version
  else
    php = php..'?id='..serial..'&n='..nickname..'&i='..sampGetCurrentServerAddress()..'&v='..getMoonloaderVersion()..'&sv='..thisScript().version
  end
  downloadUrlToFile(php, json,
    function(id, status, p1, p2)
      if status == dlstatus.STATUSEX_ENDDOWNLOAD then
        if doesFileExist(json) then
          local f = io.open(json, 'r')
          if f then
            local info = decodeJson(f:read('*a'))
            updatelink = info.updateurl
            updateversion = info.latest
            if info.changelog ~= nil then
              changelogurl = info.changelog
            end
            f:close()
            os.remove(json)
            if updateversion ~= thisScript().version then
              lua_thread.create(function(prefix, komanda)
                local dlstatus = require('moonloader').download_status
                local color = -1
                sampAddChatMessage((prefix..'Обнаружено обновление. Пытаюсь обновиться c '..thisScript().version..' на '..updateversion), color)
                wait(250)
                downloadUrlToFile(updatelink, thisScript().path,
                  function(id3, status1, p13, p23)
                    if status1 == dlstatus.STATUS_DOWNLOADINGDATA then
                      print(string.format('Загружено %d из %d.', p13, p23))
                    elseif status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
                      print('Загрузка обновления завершена.')
                      if komandaA ~= nil then
                        sampAddChatMessage((prefix..'Обновление завершено! Подробнее об обновлении - /'..komandaA..'.'), color)
                      end
                      goupdatestatus = true
                      lua_thread.create(function() wait(500) thisScript():reload() end)
                    end
                    if status1 == dlstatus.STATUSEX_ENDDOWNLOAD then
                      if goupdatestatus == nil then
                        sampAddChatMessage((prefix..'Обновление прошло неудачно. Запускаю устаревшую версию..'), color)
                        update = false
                      end
                    end
                  end
                )
                end, prefix
              )
            else
              update = false
              print('v'..thisScript().version..': Обновление не требуется.')
            end
          end
        else
          print('v'..thisScript().version..': Не могу проверить обновление. Смиритесь или проверьте самостоятельно на '..url)
          update = false
        end
      end
    end
  )
  while update ~= false do wait(100) end
end

function openchangelog(komanda, url)
  sampRegisterChatCommand(komanda,
    function()
      lua_thread.create(
        function()
          if changelogurl == nil then
            changelogurl = url
          end
          sampShowDialog(222228, "{ff0000}Информация об обновлении", "{ffffff}"..thisScript().name.." {ffe600}собирается открыть свой changelog для вас.\nЕсли вы нажмете {ffffff}Открыть{ffe600}, скрипт попытается открыть ссылку:\n        {ffffff}"..changelogurl.."\n{ffe600}Если ваша игра крашнется, вы можете открыть эту ссылку сами.", "Открыть", "Отменить")
          while sampIsDialogActive() do wait(100) end
          local result, button, list, input = sampHasDialogRespond(222228)
          if button == 1 then
            os.execute('explorer "'..changelogurl..'"')
          end
        end
      )
    end
  )
end
