script_name('/rphelper')
script_version("1.0")
script_author("James_Bond/rubbishman/Coulson")
script_description("Добавляет отыгровку при некоторых действиях.")
color = 0x348cb2
local dlstatus = require('moonloader').download_status
local sampev = require 'lib.samp.events'
local inicfg = require "inicfg"
update = true
local settings = inicfg.load({
	options =
	{
		startmessage = true,
		hideseeme = true,
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
		text = "/seeme отключил сигнализацию транспорта",
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
end

function sampev.onSetVehicleParamsEx(test, test1, test2, test3)
	resulfura, handlefura = sampGetCarHandleBySampVehicleId(test) --112
	if resulfura then
		veh = storeCarCharIsInNoSave(PLAYER_PED)
		if getDriverOfCar(handlefura) == 1 then
			if settings.enon.enable and test1.engine == 1 and veh == handlefura then ACTIVEENON = true end
			if settings.enof.enable and test1.engine == 0 and veh == handlefura then ACTIVEENOF = true end
		end
	end
end

function main()
	if not isSampfuncsLoaded() or not isSampLoaded() then return end
	while not isSampAvailable() do wait(100) end
	update()
	while update == true do wait(100) end
	sampRegisterChatCommand("rphelper", scriptmenu)
	if settings.options.startmessage then
		sampAddChatMessage((thisScript().name..' v'..thisScript().version..' by rubbishman (он же James_Bond, он же Phil_Coulson) запущен.'),
		0x348cb2)
		sampAddChatMessage(('Подробнее - /rphelper. Отключить это сообщение можно в настройках.'), 0x348cb2)
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
		if settings.enon.enable and ACTIVEENON then
			wait(1000)
			if sampIsChatInputActive() == false and sampIsDialogActive() == false then
				sampSendChat("/seeme завел двигатель "..getVehicleName(getCarModel(storeCarCharIsInNoSave(PLAYER_PED))))
			end
			ACTIVEENON = false
		end
		if settings.enof.enable and ACTIVEENOF then
			wait(1000)
			if sampIsChatInputActive() == false and sampIsDialogActive() == false then
				sampSendChat("/seeme заглушил двигатель "..getVehicleName(getCarModel(storeCarCharIsInNoSave(PLAYER_PED))))
			end
			ACTIVEENOF = false
		end
	end
end

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
			title = string.format("{348cb2}Отыгровка при включении двигателя: {ffffff}%s", settings.enon.enable),
			onclick = function()
				if settings.enon.enable == true then settings.enon.enable = false else settings.enon.enable = true end
				menuupdate()
				menu()
				inicfg.save(settings, 'rphelper.ini')
			end
		},
		{
			title = string.format("{348cb2}Отыгровка при выключении двигателя: {ffffff}%s", settings.enof.enable),
			onclick = function()
				if settings.enof.enable == true then settings.enof.enable = false else settings.enof.enable = true end
				menuupdate()
				menu()
				inicfg.save(settings, 'rphelper.ini')
			end
		},
	}
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

--/rgg menu
function menu()
	submenus_show(mod_submenus_sa, '{348cb2}rphelper v'..thisScript().version..' by rubbishman', 'Выбрать', 'Закрыть', 'Назад')
end
--toggle menu
function scriptmenu()
	if Enable == true then Enable = false else
		menutrigger = 1
	end
end

names =
{
	[400] = "Landstalker",
	[401] = "Bravura",
	[402] = "Buffalo",
	[403] = "Linerunner",
	[404] = "Perenniel",
	[405] = "Sentinel",
	[406] = "Dumper",
	[407] = "Firetruck",
	[408] = "Trashmaster",
	[409] = "Stretch",
	[410] = "Manana",
	[411] = "Infernus",
	[412] = "Voodoo",
	[413] = "Pony",
	[414] = "Mule",
	[415] = "Cheetah",
	[416] = "Ambulance",
	[417] = "Leviathan",
	[418] = "Moonbeam",
	[419] = "Esperanto",
	[420] = "Taxi",
	[421] = "Washington",
	[422] = "Bobcat",
	[423] = "Mr. Whoopee",
	[424] = "BF Injection",
	[425] = "Hunter",
	[426] = "Premier",
	[427] = "Enforcer",
	[428] = "Securicar",
	[429] = "Banshee",
	[430] = "Predator",
	[431] = "Bus",
	[432] = "Rhino",
	[433] = "Barracks",
	[434] = "Hotknife",
	[435] = "Article Trailer",
	[436] = "Previon",
	[437] = "Coach",
	[438] = "Cabbie",
	[439] = "Stallion",
	[440] = "Rumpo",
	[441] = "RC Bandit",
	[442] = "Romero",
	[443] = "Packer",
	[444] = "Monster",
	[445] = "Admiral",
	[446] = "Squallo",
	[447] = "Seasparrow",
	[448] = "Pizzaboy",
	[449] = "Tram",
	[450] = "Article Trailer 2",
	[451] = "Turismo",
	[452] = "Speeder",
	[453] = "Reefer",
	[454] = "Tropic",
	[455] = "Flatbed",
	[456] = "Yankee",
	[457] = "Caddy",
	[458] = "Solair",
	[459] = "Topfun Van",
	[460] = "Skimmer",
	[461] = "PCJ-600",
	[462] = "Faggio",
	[463] = "Freeway",
	[464] = "RC Baron",
	[565] = "RC Raider",
	[466] = "Glendale",
	[467] = "Oceanic",
	[468] = "Sanchez",
	[469] = "Sparrow",
	[470] = "Patriot",
	[471] = "Quad",
	[472] = "Coastguard",
	[473] = "Dinghy",
	[474] = "Hermes",
	[475] = "Sabre",
	[476] = "Rustler",
	[477] = "350",
	[478] = "Walton",
	[479] = "Regina",
	[480] = "Comet",
	[481] = "BMX",
	[482] = "Burrito",
	[483] = "Camper",
	[484] = "Marquis",
	[485] = "Baggage",
	[486] = "Dozer",
	[487] = "Maverick",
	[488] = "SAN News Maverick",
	[489] = "Rancher",
	[490] = "FBI Rancher",
	[491] = "Virgo",
	[492] = "Greenwood",
	[493] = "Jetmax",
	[494] = "Hotring Racer",
	[495] = "Sandking",
	[496] = "Blista Compact",
	[497] = "Police Maverick",
	[498] = "Boxville",
	[499] = "Benson",
	[500] = "Mesa",
	[501] = "RC Goblin",
	[502] = "Hotring Racer A",
	[503] = "Hotring Racer B",
	[504] = "Bloodring Banger",
	[505] = "Rancher Lure",
	[506] = "Super GT",
	[507] = "Elegant",
	[508] = "Journey",
	[509] = "Bike",
	[510] = "Mountain Bike",
	[511] = "Beagle",
	[512] = "Cropduster",
	[513] = "Stuntplane",
	[514] = "Tanker",
	[515] = "Roadtrain",
	[516] = "Nebula",
	[517] = "Majestic",
	[518] = "Buccaneer",
	[519] = "Shamal",
	[520] = "Hydra",
	[521] = "FCR-900",
	[522] = "NRG-500",
	[523] = "HPV1000",
	[524] = "Cement Truck",
	[525] = "Towtruck",
	[526] = "Fortune",
	[527] = "Cadrona",
	[528] = "FBI Truck",
	[529] = "Willard",
	[530] = "Forklift",
	[531] = "Tractor",
	[532] = "Combine Harvester",
	[533] = "Feltzer",
	[534] = "Remington",
	[535] = "Slamvan",
	[536] = "Blade",
	[537] = "Freight",
	[538] = "Brownstreak",
	[539] = "Vortex",
	[540] = "Vincent",
	[541] = "Bullet",
	[542] = "Clover",
	[543] = "Sadler",
	[544] = "Firetruck LA",
	[545] = "Hustler",
	[546] = "Intruder",
	[547] = "Primo",
	[548] = "Cargobob",
	[549] = "Tampa",
	[550] = "Sunrise",
	[551] = "Merit",
	[552] = "Utility Van",
	[553] = "Nevada",
	[554] = "Yosemite",
	[555] = "Windsor",
	[556] = "Monster A",
	[557] = "Monster B",
	[558] = "Uranus",
	[559] = "Jester",
	[560] = "Sultan",
	[561] = "Stratum",
	[562] = "Elegy",
	[563] = "Raindance",
	[564] = "RC Tiger",
	[565] = "Flash",
	[566] = "Tahoma",
	[567] = "Savanna",
	[568] = "Bandito",
	[569] = "Freight Flat Trailer",
	[570] = "Streak Trailer",
	[571] = "Kart",
	[572] = "Mower",
	[573] = "Dune",
	[574] = "Sweeper",
	[575] = "Broadway",
	[576] = "Tornado",
	[577] = "AT400",
	[578] = "DFT-30",
	[579] = "Huntley",
	[580] = "Stafford",
	[581] = "BF-400",
	[582] = "Newsvan",
	[583] = "Tug",
	[584] = "Petrol Trailer",
	[585] = "Emperor",
	[586] = "Wayfarer",
	[587] = "Euros",
	[588] = "Hotdog",
	[589] = "Club",
	[590] = "Freight Box Trailer",
	[591] = "Article Trailer 3",
	[592] = "Andromada",
	[593] = "Dodo",
	[594] = "RC Cam",
	[595] = "Launch",
	[596] = "Police Car",
	[597] = "Police Car",
	[598] = "Police Car",
	[599] = "Police Ranger",
	[600] = "Picador",
	[601] = "S.W.A.T.",
	[602] = "Alpha",
	[603] = "Phoenix",
	[604] = "Glendale Shit",
	[605] = "Sadler Shit",
	[606] = "Baggage Trailer A",
	[607] = "Baggage Trailer B",
	[608] = "Tug Stairs Trailer",
	[609] = "Boxville",
	[610] = "Farm Trailer",
	[611] = "Utility Trailer",
}

function getVehicleName(id)
	return names[id]
end

function update()
	local fpath = os.getenv('TEMP') .. '\\om-version.json'
	downloadUrlToFile('http://rubbishman.ru/dev/samp/rphelper/version.json', fpath, function(id, status, p1, p2)
		if status == dlstatus.STATUS_ENDDOWNLOADDATA then
		local f = io.open(fpath, 'r')
		if f then
			local info = decodeJson(f:read('*a'))
			updatelink = info.updateurl
			if info and info.latest then
				version = tonumber(info.latest)
				if version > tonumber(thisScript().version) then
					lua_thread.create(goupdate)
				else
					update = false
				end
			end
		end
	end
end)
end
--скачивание актуальной версии
function goupdate()
sampAddChatMessage(("[RPHELPER]: Обнаружено обновление. Попробую обновиться.."), color)
sampAddChatMessage(("[RPHELPER]: Текущая версия: "..thisScript().version..". Новая версия: "..version), color)
wait(300)
downloadUrlToFile(updatelink, thisScript().path, function(id3, status1, p13, p23)
	if status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
	sampAddChatMessage(("[RPHELPER]: Обновление завершено!"), color)
	thisScript():reload()
end
end)
end
