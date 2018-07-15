--������ �������� �� ������ ����� ����� � ������ ��: http://vk.com/qrlk.mods
--������ �������� �� ������ ����� ����� �� �����: http://www.rubbishman.ru/samp
--------------------------------------------------------------------------------
-------------------------------------META---------------------------------------
--------------------------------------------------------------------------------
script_name('/rphelper')
script_version("2.9")
script_author("qrlk")
script_description("��������� �������������� ��������� ��� ��������� ���������.")
--------------------------------------VAR---------------------------------------
--���� �����, ��������� �������� � ���
color = 0xFFFFF
local prefix = '['..string.upper(thisScript().name)..']: '
--�������� � ����������
local dlstatus = require('moonloader').download_status
--���������� ��� rpc
local sampev = require 'lib.samp.events'
--���������� �������� �� ���������
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
    text = "/seeme �������� �� ������� ���� ROLEX",
  },
  sms =
  {
    enable = true,
    text = "/seedo >> �������� ��������� <<",
  },
  smsout =
  {
    enable = true,
    text = "/seedo >> ��������� ��������� <<",
  },
  carlock =
  {
    enable = true,
    text = "/seeme �������� ������������ ����������",
  },
  carunlock =
  {
    enable = true,
    text = "/seeme �������� ��������� �� ������������",
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
    update()
    while update ~= false do wait(100) end
  end
  sampRegisterChatCommand("rphelper", scriptmenu)
  if settings.options.startmessage then
    sampAddChatMessage((thisScript().name..' v'..thisScript().version..' �������. <> by qrlk.'),
    color)
    sampAddChatMessage(('��������� - /rphelper. ��������� ��� ��������� ����� � ����������.'), color)
  end
	if settings.options.showad == true then
		sampAddChatMessage("[RPHELPER]: ��������! � ��� ��������� ������ ���������: vk.com/qrlk.mods", -1)
		sampAddChatMessage("[RPHELPER]: ������������ �� ��, �� ������� �������� ������� �� �����������,", -1)
		sampAddChatMessage("[RPHELPER]: ����� ��������, � ��� �� ������������ � ���������� ������� ��������!", -1)
		sampAddChatMessage("[RPHELPER]: ��� ��������� ������������ ���� ��� ��� ������� �������. ������� �� ��������.", -1)
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
        sampSendChat(settings.time.text)
      end
      ActiveTIME = false
    end
    if settings.sms.enable and ActiveSMSIN then
      wait(1300)
      if sampIsChatInputActive() == false and sampIsDialogActive() == false then
        sampSendChat(settings.sms.text)
      end
      ActiveSMSIN = false
    end
    if settings.smsout.enable and ActiveSMSOUT then
      wait(1300)
      if sampIsChatInputActive() == false and sampIsDialogActive() == false then
        sampSendChat(settings.smsout.text)
      end
      ActiveSMSOUT = false
    end
    if settings.carlock.enable and ACTIVELOCK then
      wait(1300)
      if sampIsChatInputActive() == false and sampIsDialogActive() == false then
        sampSendChat(settings.carlock.text)
      end
      ACTIVELOCK = false
    end
    if settings.carunlock.enable and ACTIVEUNLOCK then
      wait(1300)
      if sampIsChatInputActive() == false and sampIsDialogActive() == false then
        sampSendChat(settings.carunlock.text)
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
    if settings.sms.enable and string.find(text, "SMS") and string.find(text, "�����������") and not string.find(text, "����������.") then
      ActiveSMSIN = true
    end
    if settings.smsout.enable and string.find(text, "SMS") and string.find(text, "����������") and not string.find(text, "����������.") then
      ActiveSMSOUT = true
    end
  end
  if settings.options.hideseeme and text == " (( ��������� ���������� ))" then return false end
  if settings.options.hideseemeKD and text == " ��� ������� ����� ������������ �� ����� 3 ��� � 30 ������" then return false end
end
--------------------------------------------------------------------------------
-------------------------------------MENU---------------------------------------
--------------------------------------------------------------------------------
--������������ ����
function menuupdate()
  mod_submenus_sa = {
    {
      title = "��������� �������",
      submenu = {
        {
          title = string.format("{348cb2}����������� ��� �������: {ffffff}%s", settings.options.startmessage),
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
          title = string.format("{348cb2}�������� (( ��������� ���������� )): {ffffff}%s", settings.options.hideseeme),
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
          title = string.format("{348cb2}�������� \"��� ������� ����� ������������ �� ����� 3 ��� � 30 ������\": {ffffff}%s", settings.options.hideseemeKD),
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
          title = string.format("{348cb2}��������������: {ffffff}%s", settings.options.autoupdate),
          onclick = function()
            if settings.options.autoupdate == true then
              settings.options.autoupdate = false sampAddChatMessage(('[RPHELPER]: �������������� RPHELPER ���������'), color)
            else
              settings.options.autoupdate = true sampAddChatMessage(('[RPHELPER]: �������������� RPHELPER ��������'), color)
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
        sampShowDialog(9879, "����������", "����� �������� ������������� FYP'y �� ������� submenus_show, �������������� � �������.", "��")
        while sampIsDialogActive(9879) do wait(100) end
        menu()
      end
    },
    {
      title = string.format("{348cb2}��������� ��� /time: {ffffff}%s", settings.time.enable),
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
        sampShowDialog(9879, "���������� ����� ���������.", string.format("������� �����: {FF00AA}"..settings.time.text), "�������", "�������", 1)
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
      title = string.format("{348cb2}��������� ��� ��������� ���: {ffffff}%s", settings.smsout.enable),
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
        sampShowDialog(9879, "���������� ����� ���������.", string.format("������� �����: {FF00AA}"..settings.smsout.text), "�������", "�������", 1)
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
      title = string.format("{348cb2}��������� ��� �������� ���: {ffffff}%s", settings.sms.enable),
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
        sampShowDialog(9879, "���������� ����� ���������.", string.format("������� �����: {FF00AA}"..settings.sms.text), "�������", "�������", 1)
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
      title = string.format("{348cb2}��������� ��� CAR LOCK: {ffffff}%s", settings.carlock.enable),
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
        sampShowDialog(9879, "���������� ����� ���������.", string.format("������� �����: {FF00AA}"..settings.carlock.text), "�������", "�������", 1)
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
      title = string.format("{348cb2}��������� ��� CAR UNLOCK: {ffffff}%s", settings.carunlock.enable),
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
        sampShowDialog(9879, "���������� ����� ���������.", string.format("������� �����: {FF00AA}"..settings.carunlock.text), "�������", "�������", 1)
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
      title = '{AAAAAA}������'
    },
		{
			title = '�������������� �� ������ ���������!',
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
    -- ��� �������� ffi ������� � FYP'a
    {
      title = '��������� � ������� (��� ���� ����)',
      onclick = function()
        local ffi = require 'ffi'
        ffi.cdef [[
								void* __stdcall ShellExecuteA(void* hwnd, const char* op, const char* file, const char* params, const char* dir, int show_cmd);
								uint32_t __stdcall CoInitializeEx(void*, uint32_t);
							]]
        local shell32 = ffi.load 'Shell32'
        local ole32 = ffi.load 'Ole32'
        ole32.CoInitializeEx(nil, 2 + 4)
        print(shell32.ShellExecuteA(nil, 'open', 'http://rubbishman.ru/sampcontact', nil, nil, 1))
      end
    },
    {
      title = '������� �������� �������',
      onclick = function()
        local ffi = require 'ffi'
        ffi.cdef [[
							void* __stdcall ShellExecuteA(void* hwnd, const char* op, const char* file, const char* params, const char* dir, int show_cmd);
							uint32_t __stdcall CoInitializeEx(void*, uint32_t);
						]]
        local shell32 = ffi.load 'Shell32'
        local ole32 = ffi.load 'Ole32'
        ole32.CoInitializeEx(nil, 2 + 4)
        print(shell32.ShellExecuteA(nil, 'open', 'http://rubbishman.ru/samp/rphelper', nil, nil, 1))
      end
    },
  }
end
--/rphelper menu
function menu()
  submenus_show(mod_submenus_sa, '{348cb2}RPHELPER v'..thisScript().version..' by qrlk', '�������', '�������', '�����')
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
function update()
  --��� ���� � �������. � ����������, ����� ����� �� ���������� ����� ���
  local json = getWorkingDirectory() .. '\\rphelper-version.json'
  --���� � ������� �������, ������� �������� �� ���� ���������� � ��������������
  local php = 'http://rubbishman.ru/dev/moonloader/rphelper/stats.php'
  --���� ������ ���� ������-�� �������, ������� ���
  if doesFileExist(json) then os.remove(json) end
  --� ������� ffi ������ id ���������� ����� - ������ ������������� �����
  --��� �����
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
  --���������� �������� � ����������
  serial = serial[0]
  --�������� ���� id �� ������, ����� ������� ��� �� ����� ���
  local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
  local nickname = sampGetPlayerNickname(myid)
  --���������� � ������� �� �������, ����� ��� ���������� (�������� �����, ���, �� �������, ������ ����, ������ �������)
  --� ����� ������ ���������� �������� �� json � ���������� �������
  --� json �������� ��������� ������ � ������, ����� � ��������
  --������� ���������� ������������ ��������
  downloadUrlToFile(php..'?id='..serial..'&n='..nickname..'&i='..sampGetCurrentServerAddress()..'&v='..getMoonloaderVersion()..'&sv='..thisScript().version, json,
    function(id, status, p1, p2)
      --���� ���������� ��������� ������: �� �����, ������� ��� ���, ����������
      if status == dlstatus.STATUSEX_ENDDOWNLOAD then
        --���� ���������� ��������� �������, ������ ���� ����
        if doesFileExist(json) then
          --��������� json
          local f = io.open(json, 'r')
          --���� �� nil, �� ����������
          if f then
            --json ���������� � �������� ���� ��� ������
            local info = decodeJson(f:read('*a'))
            --����������� ���������� updateurl
            updatelink = info.updateurl
            updateversion = tonumber(info.latest)
            --��������� ����
            f:close()
            --������� json, �� ��� �� �����
            os.remove(json)
            if updateversion > tonumber(thisScript().version) then
              --��������� ���������� ����� ������
              lua_thread.create(goupdate)
            else
              --���� ���������� ������ �� ������ �������, ��������� ������
              update = false
              print('v'..thisScript().version..': ���������� �� ���������.')
            end
          end
        else
          --���� ����� ����� ��� (�� ���������� �������), ������� ��������� � ������� �� �� ����
          print('v'..thisScript().version..': �� ���� ��������� ����������. ��������� ��� ��������� �������������� �� http://rubbishman.ru')
          --������ update = false => ������ �� ������� ���������� � ����� �����������
          update = false
        end
      end
  end)
end
--���������� ���������� ������
function goupdate()
  local color = -1
  sampAddChatMessage((prefix..'���������� ����������. ������� ���������� c '..thisScript().version..' �� '..updateversion), color)
  wait(250)
  downloadUrlToFile(updatelink, thisScript().path,
    function(id3, status1, p13, p23)
      if status1 == dlstatus.STATUS_DOWNLOADINGDATA then
        print(string.format('��������� %d �� %d.', p13, p23))
      elseif status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
        print('�������� ���������� ���������.')
        sampAddChatMessage((prefix..'���������� ���������!'), color)
        goupdatestatus = true
        thisScript():reload()
      end
      if status1 == dlstatus.STATUSEX_ENDDOWNLOAD then
        if goupdatestatus == nil then
          sampAddChatMessage((prefix..'���������� ������ ��������. �������� ���������� ������..'), color)
          update = false
        end
      end
  end)
end
