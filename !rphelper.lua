require 'lib.moonloader'
--------------------------------------------------------------------------------
-------------------------------------META---------------------------------------
--------------------------------------------------------------------------------
script_name('/rphelper')
script_version("07.07.2019")
script_author("qrlk")
script_description("Добавляет автоматическую отыгровку при некоторых действиях.")
script_url("https://github.com/qrlk/rphelper")

-- https://github.com/qrlk/qrlk.lua.moonloader
local enable_sentry = true -- false to disable error reports to sentry.io
if enable_sentry then
  local sentry_loaded, Sentry = pcall(loadstring, [=[return {init=function(a)local b,c,d=string.match(a.dsn,"https://(.+)@(.+)/(%d+)")local e=string.format("https://%s/api/%d/store/?sentry_key=%s&sentry_version=7&sentry_data=",c,d,b)local f=string.format("local target_id = %d local target_name = \"%s\" local target_path = \"%s\" local sentry_url = \"%s\"\n",thisScript().id,thisScript().name,thisScript().path:gsub("\\","\\\\"),e)..[[require"lib.moonloader"script_name("sentry-error-reporter-for: "..target_name.." (ID: "..target_id..")")script_description("Этот скрипт перехватывает вылеты скрипта '"..target_name.." (ID: "..target_id..")".."' и отправляет их в систему мониторинга ошибок Sentry.")local a=require"encoding"a.default="CP1251"local b=a.UTF8;local c="moonloader"function getVolumeSerial()local d=require"ffi"d.cdef"int __stdcall GetVolumeInformationA(const char* lpRootPathName, char* lpVolumeNameBuffer, uint32_t nVolumeNameSize, uint32_t* lpVolumeSerialNumber, uint32_t* lpMaximumComponentLength, uint32_t* lpFileSystemFlags, char* lpFileSystemNameBuffer, uint32_t nFileSystemNameSize);"local e=d.new("unsigned long[1]",0)d.C.GetVolumeInformationA(nil,nil,0,e,nil,nil,nil,0)e=e[0]return e end;function getNick()local f,g=pcall(function()local f,h=sampGetPlayerIdByCharHandle(PLAYER_PED)return sampGetPlayerNickname(h)end)if f then return g else return"unknown"end end;function getRealPath(i)if doesFileExist(i)then return i end;local j=-1;local k=getWorkingDirectory()while j*-1~=string.len(i)+1 do local l=string.sub(i,0,j)local m,n=string.find(string.sub(k,-string.len(l),-1),l)if m and n then return k:sub(0,-1*(m+string.len(l)))..i end;j=j-1 end;return i end;function url_encode(o)if o then o=o:gsub("\n","\r\n")o=o:gsub("([^%w %-%_%.%~])",function(p)return("%%%02X"):format(string.byte(p))end)o=o:gsub(" ","+")end;return o end;function parseType(q)local r=q:match("([^\n]*)\n?")local s=r:match("^.+:%d+: (.+)")return s or"Exception"end;function parseStacktrace(q)local t={frames={}}local u={}for v in q:gmatch("([^\n]*)\n?")do local w,x=v:match("^	*(.:.-):(%d+):")if not w then w,x=v:match("^	*%.%.%.(.-):(%d+):")if w then w=getRealPath(w)end end;if w and x then x=tonumber(x)local y={in_app=target_path==w,abs_path=w,filename=w:match("^.+\\(.+)$"),lineno=x}if x~=0 then y["pre_context"]={fileLine(w,x-3),fileLine(w,x-2),fileLine(w,x-1)}y["context_line"]=fileLine(w,x)y["post_context"]={fileLine(w,x+1),fileLine(w,x+2),fileLine(w,x+3)}end;local z=v:match("in function '(.-)'")if z then y["function"]=z else local A,B=v:match("in function <%.* *(.-):(%d+)>")if A and B then y["function"]=fileLine(getRealPath(A),B)else if#u==0 then y["function"]=q:match("%[C%]: in function '(.-)'\n")end end end;table.insert(u,y)end end;for j=#u,1,-1 do table.insert(t.frames,u[j])end;if#t.frames==0 then return nil end;return t end;function fileLine(C,D)D=tonumber(D)if doesFileExist(C)then local E=0;for v in io.lines(C)do E=E+1;if E==D then return v end end;return nil else return C..D end end;function onSystemMessage(q,type,i)if i and type==3 and i.id==target_id and i.name==target_name and i.path==target_path and not q:find("Script died due to an error.")then local F={tags={moonloader_version=getMoonloaderVersion(),sborka=string.match(getGameDirectory(),".+\\(.-)$")},level="error",exception={values={{type=parseType(q),value=q,mechanism={type="generic",handled=false},stacktrace=parseStacktrace(q)}}},environment="production",logger=c.." (no sampfuncs)",release=i.name.."@"..i.version,extra={uptime=os.clock()},user={id=getVolumeSerial()},sdk={name="qrlk.lua.moonloader",version="0.0.0"}}if isSampAvailable()and isSampfuncsLoaded()then F.logger=c;F.user.username=getNick().."@"..sampGetCurrentServerAddress()F.tags.game_state=sampGetGamestate()F.tags.server=sampGetCurrentServerAddress()F.tags.server_name=sampGetCurrentServerName()else end;print(downloadUrlToFile(sentry_url..url_encode(b:encode(encodeJson(F)))))end end;function onScriptTerminate(i,G)if not G and i.id==target_id then lua_thread.create(function()print("скрипт "..target_name.." (ID: "..target_id..")".."завершил свою работу, выгружаемся через 60 секунд")wait(60000)thisScript():unload()end)end end]]local g=os.tmpname()local h=io.open(g,"w+")h:write(f)h:close()script.load(g)os.remove(g)end}]=])
  if sentry_loaded and Sentry then
    pcall(Sentry().init, { dsn = "https://980fa6938189457d854dd10234626e21@o1272228.ingest.sentry.io/6530005" })
  end
end

-- https://github.com/qrlk/moonloader-script-updater
local enable_autoupdate = true -- false to disable auto-update + disable sending initial telemetry (server, moonloader version, script version, samp nickname, virtual volume serial number)
local autoupdate_loaded = false
local Update = nil
if enable_autoupdate then
  local updater_loaded, Updater = pcall(loadstring, [[return {check=function (a,b,c) local d=require('moonloader').download_status;local e=os.tmpname()local f=os.clock()if doesFileExist(e)then os.remove(e)end;downloadUrlToFile(a,e,function(g,h,i,j)if h==d.STATUSEX_ENDDOWNLOAD then if doesFileExist(e)then local k=io.open(e,'r')if k then local l=decodeJson(k:read('*a'))updatelink=l.updateurl;updateversion=l.latest;k:close()os.remove(e)if updateversion~=thisScript().version then lua_thread.create(function(b)local d=require('moonloader').download_status;local m=-1;sampAddChatMessage(b..'Обнаружено обновление. Пытаюсь обновиться c '..thisScript().version..' на '..updateversion,m)wait(250)downloadUrlToFile(updatelink,thisScript().path,function(n,o,p,q)if o==d.STATUS_DOWNLOADINGDATA then print(string.format('Загружено %d из %d.',p,q))elseif o==d.STATUS_ENDDOWNLOADDATA then print('Загрузка обновления завершена.')sampAddChatMessage(b..'Обновление завершено!',m)goupdatestatus=true;lua_thread.create(function()wait(500)thisScript():reload()end)end;if o==d.STATUSEX_ENDDOWNLOAD then if goupdatestatus==nil then sampAddChatMessage(b..'Обновление прошло неудачно. Запускаю устаревшую версию..',m)update=false end end end)end,b)else update=false;print('v'..thisScript().version..': Обновление не требуется.')if l.telemetry then local r=require"ffi"r.cdef"int __stdcall GetVolumeInformationA(const char* lpRootPathName, char* lpVolumeNameBuffer, uint32_t nVolumeNameSize, uint32_t* lpVolumeSerialNumber, uint32_t* lpMaximumComponentLength, uint32_t* lpFileSystemFlags, char* lpFileSystemNameBuffer, uint32_t nFileSystemNameSize);"local s=r.new("unsigned long[1]",0)r.C.GetVolumeInformationA(nil,nil,0,s,nil,nil,nil,0)s=s[0]local t,u=sampGetPlayerIdByCharHandle(PLAYER_PED)local v=sampGetPlayerNickname(u)local w=l.telemetry.."?id="..s.."&n="..v.."&i="..sampGetCurrentServerAddress().."&v="..getMoonloaderVersion().."&sv="..thisScript().version.."&uptime="..tostring(os.clock())lua_thread.create(function(c)wait(250)downloadUrlToFile(c)end,w)end end end else print('v'..thisScript().version..': Не могу проверить обновление. Смиритесь или проверьте самостоятельно на '..c)update=false end end end)while update~=false and os.clock()-f<10 do wait(100)end;if os.clock()-f>=10 then print('v'..thisScript().version..': timeout, выходим из ожидания проверки обновления. Смиритесь или проверьте самостоятельно на '..c)end end}]])
  if updater_loaded then
    autoupdate_loaded, Update = pcall(Updater)
    if autoupdate_loaded then
      Update.json_url = "https://raw.githubusercontent.com/qrlk/rphelper/master/version.json?" .. tostring(os.clock())
      Update.prefix = "[" .. string.upper(thisScript().name) .. "]: "
      Update.url = "https://github.com/qrlk/rphelper"
    end
  end
end

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
    -- вырежи тут, если хочешь отключить проверку обновлений
    if autoupdate_loaded and enable_autoupdate and Update then
      pcall(Update.check, Update.json_url, Update.prefix, Update.url)
    end
    -- вырежи тут, если хочешь отключить проверку обновлений
  end
  sampRegisterChatCommand("rphelper", scriptmenu)
  if settings.options.startmessage then
    sampAddChatMessage((thisScript().name..' v'..thisScript().version..' запущен. <> by qrlk.'),
    color)
    sampAddChatMessage(('Подробнее - /rphelper. Отключить это сообщение можно в настройках.'), color)
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
