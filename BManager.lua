util.require_no_lag("natives-1627063482")
handle_ptr = memory.alloc(13*8)

util.toast("BManager edits by XxRagulxX#9490, By King")
localVer = 1.7
local response = false


-- Stats functions 
async_http.init("raw.githubusercontent.com", "/XxRagulxX/Business-manager/main/version.lua", function(output)
    currentVer = tonumber(output)
    response = true
    if localVer ~= currentVer then
        util.toast("Business Manager version is available, update the lua to get the newest version.")
        menu.action(menu.my_root(), "Update Lua", {}, "", function()
            async_http.init('raw.githubusercontent.com','/XxRagulxX/Business-manager/main/BManager.lua',function(a)
                local err = select(2,load(a))
                if err then
                    util.toast("Script failed to download. Please try again later. If this continues to happen then manually update via github.")
                return end
                local f = io.open(filesystem.scripts_dir()..SCRIPT_RELPATH, "wb")
                f:write(a)
                f:close()
                util.toast("Successfully updated Business Manager, please restart the script :)")
                util.stop_script()
            end)
            async_http.dispatch()
        end)
    end
end, function() response = true end)
async_http.dispatch()
repeat 
    util.yield()
until response

function MP_INDEX()
    return "MP" .. util.get_char_slot() .. "_"
end
function IS_MPPLY(Stat)
    local Stats = {
        "MP_PLAYING_TIME",
    }

    for i = 1, #Stats do
        if Stat == Stats[i] then
            return true
        end
    end

    if string.find(Stat, "MPPLY_") then
        return true
    else
        return false
    end
end
function ADD_MP_INDEX(Stat)
    if not IS_MPPLY(Stat) then
        Stat = MP_INDEX() .. Stat
    end
    return Stat
end
------Testing own BOOL function 

function STAT_GET_INT(Stat)
    local IntPTR = memory.alloc_int()
    STATS.STAT_GET_INT(util.joaat(ADD_MP_INDEX(Stat)), IntPTR, -1)
    return memory.read_int(IntPTR)
end
function STAT_GET_FLOAT(Stat)
    local FloatPTR = memory.alloc_int()
    STATS.STAT_GET_FLOAT(util.joaat(ADD_MP_INDEX(Stat)), FloatPTR, -1)
    return tonumber(string.format("%.3f", memory.read_float(FloatPTR)))
end
function STAT_GET_BOOL(Stat)
    if STAT_GET_INT(Stat) == 0 then
        return "false"
    elseif STAT_GET_INT(Stat) == 1 then
        return "true"
    else
        return "STAT_UNKNOWN"
    end 
end
function STAT_GET_STRING(Stat)
    return STATS.STAT_GET_STRING(util.joaat(ADD_MP_INDEX(Stat)), -1)
end
function SET_INT_GLOBAL(Global, Value)
    memory.write_int(memory.script_global(Global), Value)
end
function SET_FLOAT_GLOBAL(Global, Value)
    memory.write_float(memory.script_global(Global), Value)
end

function GET_INT_GLOBAL(Global)
    return memory.read_int(memory.script_global(Global))
end

function SET_PACKED_INT_GLOBAL(StartGlobal, EndGlobal, Value)
    for i = StartGlobal, EndGlobal do
        SET_INT_GLOBAL(262145 + i, Value)
    end
end

function SET_INT_LOCAL(Script, Local, Value)
    if memory.script_local(Script, Local) ~= 0 then
        memory.write_int(memory.script_local(Script, Local), Value)
    end
end
function SET_FLOAT_LOCAL(Script, Local, Value)
    if memory.script_local(Script, Local) ~= 0 then
        memory.write_float(memory.script_local(Script, Local), Value)
    end
end

function GET_INT_LOCAL(Script, Local)
    if memory.script_local(Script, Local) ~= 0 then
        local Value = memory.read_int(memory.script_local(Script, Local))
        if Value ~= nil then
            return Value
        end
    end
end
function TELEPORT(X, Y, Z)
    ENTITY.SET_ENTITY_COORDS(players.user_ped(), X, Y, Z)
end
---------------------------------------------------------------------
local HCName = "Business Manager"
function log(content)
    if verbose then
        util.log("[KINGSCRIPT] " .. content)
    end
end

ocoded_for = 1.61
is_loading = true

log("Setting up lists")
log("Done setting up lists.")

-- Display function 

function hasValue( tbl, str )
    local f = false
    for i = 1, #tbl do
        if type( tbl[i] ) == "table" then
            f = hasValue( tbl[i], str )  
            if f then break end  
        elseif tbl[i] == str then
            return true
        end
    end
    return f
end
-- Set RGB (Display Fonts)
function to_rgb(r, g, b, a)
    local color = {}
    color.r = r
    color.g = g
    color.b = b
    color.a = a
    return color
end
black = to_rgb(0.0,0.0,0.0,1.0)
white = to_rgb(1.0,1.0,1.0,1.0)
red = to_rgb(1,0,0,1)
green = to_rgb(0,1,0,1)
blue = to_rgb(0.0,0.0,1.0,1.0)
-- Commands 
-------------------------------------------------
-- Musiness Banager Lite Integration .. 
local Musiness_Banager = menu.list(menu.my_root(),"Musiness Banager Lite",{},"Musiness Banager should be turn on in order to use this :D",function();end)
business_monitor = {"monitorforgery","monitorweed","monitorcash","monitormeth","monitorcocaine","monitorbunker"}
menu.toggle(Musiness_Banager, 'Show Business', {"mbbusinessroottoggles"}, "Toggles Monitor, MC, Bunker to true/false", function(on)
    if on then
        util.toast("All Monitors are activated :D")
        for name,newname in pairs(business_monitor) do
            menu.trigger_commands(newname .. " on")
        end
    else
        util.toast("All Monitors are deactivated :(")
        for name,newname in pairs(business_monitor) do
            menu.trigger_commands(newname .. " off")
        end
    end
end)
business_resupply={"resupplyforgery","resupplyweed","resupplycash","resupplymeth","resupplycocaine","resupplybunker"}
menu.toggle(Musiness_Banager, 'Auto Resupply', {"mbbusinessresupplytoggles"}, "Toggles Resupply, MC, Bunker to true/false", function(on)
    if on then
        util.toast("Auto Resupplys are activated :D")
        for name_1,newname_1 in pairs(business_resupply) do
            menu.trigger_commands(newname_1 .. " on")
        end
    else
        util.toast("Auto Resupplys are deactivated :(")
        for name_1,newname_1 in pairs(business_resupply) do
            menu.trigger_commands(newname_1 .. " off")
        end
    end
end)
business_maxproduction = {"maxprodbunker","maxprodforgery","maxprodweed","maxprodcash","maxprodmeth","maxprodcocaine"}
menu.toggle(Musiness_Banager, 'Max Production', {"mbbusinessmaxproductiontoggles"}, "Toggles Max production, MC, Bunker to true/false", function(on)
    if on then
        util.toast("Max Production activated :D")
        for name_2,newname_2 in pairs(business_maxproduction) do
            menu.trigger_commands(newname_2 .. " on")
        end
    else
        util.toast("Max Production are deactivated :(")
        for name_2,newname_2 in pairs(business_maxproduction) do
            menu.trigger_commands(newname_2 .. " off")
        end
    end
end)
local Auto_Money = menu.list(Musiness_Banager,'Auto Money Maker',{},"Auto Warehouse Money Maker",function();end)
menu.toggle_loop(Auto_Money, 'Auto Sell Crate', {"loopsellacrate"}, 'Auto sell a crate all x seconds', function()
    menu.trigger_commands("sellacrate")
    util.yield(seconds * 1000)
end)
menu.action(Auto_Money,'Start this before',{},"Toggles all the options required",function()
    menu.trigger_commands("monitorcargo on")
    menu.trigger_commands("maxsellcargo on")
    menu.trigger_commands("nobuycdcargo on")
    menu.trigger_commands("nosellcdcargo on")
    menu.trigger_commands("autocompletespecialbuy on")
    menu.trigger_commands("autocompletespecialsell on")
    util.toast("All toggles are activated :D")
end)
local Teleport_place = menu.list(Musiness_Banager,'Teleport',{},"Business Teleport",function();end)
menu.action(Teleport_place,'Forgery',{},"Teleport to Forgery",function()
    menu.trigger_commands("tpbusinessforgery")
end)
menu.action(Teleport_place,'Weed',{},"Teleport to Weed",function()
    menu.trigger_commands("tpbusinessweed")
end)
menu.action(Teleport_place,'Cash',{},"Teleport to Cash",function()
    menu.trigger_commands("tpbusinesscash")
end)
menu.action(Teleport_place,'Cocaine',{},"Teleport to Cocaine",function()
    menu.trigger_commands("tpbusinesscocaine")
end)
menu.action(Teleport_place,'Meth',{},"Teleport to Meth",function()
    menu.trigger_commands("tpbusinessmeth")
end)
menu.action(Teleport_place,'Bunker',{},"Teleport to Bunker",function()
    menu.trigger_commands("tpbunker1")
end)
menu.action(Teleport_place,'Nightclub',{},"Teleport to Nightclub",function()
    menu.trigger_commands("tpnightclub")
end)
menu.action(Teleport_place,'Warehouse',{},"Teleport to Warehouse",function()
    menu.trigger_commands("tptocargowarehouse")
end)

-----------------------------------------
local MC_Business = menu.list(menu.my_root(),"MC Business",{},"",function();end)
bm_meth = false
menu.toggle(MC_Business, "Meth", {"bm_meth"}, "", function(on)
    if on then
        bm_meth = true
        bus_ticks = bus_ticks + 1
    else
        bm_meth = false
        bus_ticks = bus_ticks - 1
    end
end, false)
bm_weed = false
menu.toggle(MC_Business, "Weed", {"bm_weed"}, "", function(on)
    if on then
        bm_weed = true
        bus_ticks = bus_ticks + 1
    else
        bm_weed = false
        bus_ticks = bus_ticks - 1
    end
end, false)

bm_documents = false
menu.toggle(MC_Business, "Forgery", {"bm_forgery"}, "", function(on)
    if on then
        bm_documents = true
        bus_ticks = bus_ticks + 1
    else
        bm_documents = false
        bus_ticks = bus_ticks - 1
    end
end, false)

bm_cocaine = false
menu.toggle(MC_Business, "Cocaine", {"bm_cocaine"}, "", function(on)
    if on then
        bm_cocaine = true
        bus_ticks = bus_ticks + 1
    else
        bm_cocaine = false
        bus_ticks = bus_ticks - 1
    end
end, false)


bm_cash = false
menu.toggle(MC_Business, "Cash", {"bm_cash"}, "", function(on)
    if on then
        bm_cash = true
        bus_ticks = bus_ticks + 1
    else
        bm_cash = false
        bus_ticks = bus_ticks - 1
    end
end, false)
bm_bunker = false
menu.toggle(MC_Business, "Bunker", {"bm_bunker"}, "", function(on)
    if on then
        bm_bunker = true
        bus_ticks = bus_ticks + 1
    else
        bm_bunker = false
        bus_ticks = bus_ticks - 1
    end
end, false)
local Night_club = menu.list(menu.my_root(),"Nightclub",{},"",function();end)
menu.toggle(Night_club, "Hub Cargo", {"bm_cargonc"}, "", function(on)
    if on then
        bm_cargonc = true
        bus_ticks = bus_ticks + 1
    else
        bm_cargonc = false
        bus_ticks = bus_ticks - 1
    end
end, false)
menu.toggle(Night_club, "Hub Forgery", {"bm_forgerync"}, "", function(on)
    if on then
        bm_forgerync = true
        bus_ticks = bus_ticks + 1
    else
        bm_forgerync = false
        bus_ticks = bus_ticks - 1
    end
end, false)
menu.toggle(Night_club, "Hub Weed", {"bm_weednc"}, "", function(on)
    if on then
        bm_weednc = true
        bus_ticks = bus_ticks + 1
    else
        bm_weednc = false
        bus_ticks = bus_ticks - 1
    end
end, false)
menu.toggle(Night_club, "Hub Cocaine", {"bm_cocainenc"}, "", function(on)
    if on then
        bm_cocainenc = true
        bus_ticks = bus_ticks + 1
    else
        bm_cocainenc = false
        bus_ticks = bus_ticks - 1
    end
end, false)
menu.toggle(Night_club, "Hub Cash", {"bm_cashnc"}, "", function(on)
    if on then
        bm_cashnc = true
        bus_ticks = bus_ticks + 1
    else
        bm_cashnc = false
        bus_ticks = bus_ticks - 1
    end
end, false)
menu.toggle(Night_club, "Hub Meth", {"bm_methnc"}, "", function(on)
    if on then
        bm_methnc = true
        bus_ticks = bus_ticks + 1
    else
        bm_methnc = false
        bus_ticks = bus_ticks - 1
    end
end, false)
menu.toggle(Night_club, "Hub Weapons", {"bm_weaponsnc"}, "", function(on)
    if on then
        bm_weaponsnc = true
        bus_ticks = bus_ticks + 1
    else
        bm_weaponsnc = false
        bus_ticks = bus_ticks - 1
    end
end, false)
bm_nightclubsafe = false
menu.toggle(Night_club, "Nightclub safe", {"bm_safe"}, "", function(on)
    if on then
        bm_nightclubsafe = true
        bus_ticks = bus_ticks + 1
    else
        bm_nightclubsafe = false
        bus_ticks = bus_ticks - 1
    end
end, false)
bm_nightclubpopularity = false
menu.toggle(Night_club, "Nightclub popularity", {"bm_safe_pop"}, "", function(on)
    if on then
        bm_nightclubpopularity = true
        bus_ticks = bus_ticks + 1
    else
        bm_nightclubpopularity = false
        bus_ticks = bus_ticks - 1
    end
end, false)
bm_arcadesafe = false
menu.toggle(Night_club, "Arcade Safe", {"bm_safe_arcade"}, "", function(on)
    if on then
        bm_arcadesafe = true
        bus_ticks = bus_ticks + 1
    else
        bm_arcadesafe = false
        bus_ticks = bus_ticks - 1
    end
end, false)
bm_agencysafe = false
menu.toggle(Night_club, "Agency Safe", {"bm_safe_agency"}, "", function(on)
    if on then
        bm_agencysafe = true
        bus_ticks = bus_ticks + 1
    else
        bm_agencysafe = false
        bus_ticks = bus_ticks - 1
    end
end, false)

----------------------------------------------------------------------------------------------
--- Teleport's 

local TELEPORT_PLACE = menu.list(menu.my_root(),"Teleport",{},"",function();end)
menu.action(TELEPORT_PLACE,"Arcade",{},"[" .. "Business" .. "]", function()
    TELEPORT(-617.95984, 284.6434, 81.68355)
end)
menu.action(TELEPORT_PLACE,"MC Product",{},"Teleports to the blue objective",function()
    local pPickup = HUD.GET_BLIP_COORDS(HUD.GET_NEXT_BLIP_INFO_ID(501))
    local hPickup = HUD.GET_BLIP_COORDS(HUD.GET_NEXT_BLIP_INFO_ID(64))
    local bPickup = HUD.GET_BLIP_COORDS(HUD.GET_NEXT_BLIP_INFO_ID(427))
    local plPickup = HUD.GET_BLIP_COORDS(HUD.GET_NEXT_BLIP_INFO_ID(423))
                    HUD.GET_BLIP_COORDS(HUD.GET_NEXT_BLIP_INFO_ID(501))
                    HUD.GET_BLIP_COORDS(HUD.GET_NEXT_BLIP_INFO_ID(64))
                    HUD.GET_BLIP_COORDS(HUD.GET_NEXT_BLIP_INFO_ID(427))
                    HUD.GET_BLIP_COORDS(HUD.GET_NEXT_BLIP_INFO_ID(423))
        if pPickup.x == 0 and pPickup.y == 0 and pPickup.z == 0 then

        elseif pPickup.x ~= 0 and pPickup.y ~= 0 and pPickup.z ~= 0 then
            ENTITY.SET_ENTITY_COORDS(players.user_ped(), pPickup.x - 1.5, pPickup.y , pPickup.z, false, false, false, false) 
            util.toast("TP to MC Product")
        end 
        if hPickup.x == 0 and hPickup.y == 0 and hPickup.z == 0 then

        elseif hPickup.x ~= 0 and hPickup.y ~= 0 and hPickup.z ~= 0 then
            ENTITY.SET_ENTITY_COORDS(players.user_ped(), hPickup.x- 1.5, hPickup.y, hPickup.z, false, false, false, false) 
            util.toast("TP to Heli")
        end 
        if bPickup.x == 0 and bPickup.y == 0 and bPickup.z == 0 then

        elseif bPickup.x ~= 0 and bPickup.y ~= 0 and bPickup.z ~= 0 then
            ENTITY.SET_ENTITY_COORDS(players.user_ped(), bPickup.x, bPickup.y, bPickup.z + 1.0 , false, false, false, false) 
            util.toast("TP to Boat")
        end 
        if plPickup.x == 0 and plPickup.y == 0 and plPickup.z == 0 then

        elseif plPickup.x ~= 0 and plPickup.y ~= 0 and plPickup.z ~= 0 then
            ENTITY.SET_ENTITY_COORDS(players.user_ped(), plPickup.x, plPickup.y + 1.5, plPickup.z - 1, false, false, false, false) 
            util.toast("TP to Plane")
        else                 util.toast("No MC Product Found")   
        end
end)
menu.action(TELEPORT_PLACE,"Bunker Product",{},"Teleports to the blue objective",function()
    local sPickup = HUD.GET_BLIP_COORDS(HUD.GET_NEXT_BLIP_INFO_ID(556))
    local dPickup = HUD.GET_BLIP_COORDS(HUD.GET_NEXT_BLIP_INFO_ID(561))
    local fPickup = HUD.GET_BLIP_COORDS(HUD.GET_NEXT_BLIP_INFO_ID(477))
    local plPickup = HUD.GET_BLIP_COORDS(HUD.GET_NEXT_BLIP_INFO_ID(423))
                    HUD.GET_BLIP_COORDS(HUD.GET_NEXT_BLIP_INFO_ID(556))
                    HUD.GET_BLIP_COORDS(HUD.GET_NEXT_BLIP_INFO_ID(561))
                    HUD.GET_BLIP_COORDS(HUD.GET_NEXT_BLIP_INFO_ID(477))
                    HUD.GET_BLIP_COORDS(HUD.GET_NEXT_BLIP_INFO_ID(423))
        if sPickup.x == 0 and sPickup.y == 0 and sPickup.z == 0 then
        elseif sPickup.x ~= 0 and sPickup.y ~= 0 and sPickup.z ~= 0 then
            ENTITY.SET_ENTITY_COORDS(players.user_ped(), sPickup.x, sPickup.y + 2.0, sPickup.z - 1.0, false, false, false, false) 
            util.toast("TP to Supplies")
        end 
        if dPickup.x == 0 and dPickup.y == 0 and dPickup.z == 0 then
        elseif dPickup.x ~= 0 and dPickup.y ~= 0 and dPickup.z ~= 0 then
            ENTITY.SET_ENTITY_COORDS(players.user_ped(), dPickup.x, dPickup.y, dPickup.z, false, false, false, false) 
            util.toast("TP to Dune")
        end 
        if fPickup.x == 0 and fPickup.y == 0 and fPickup.z == 0 then
        elseif fPickup.x ~= 0 and fPickup.y ~= 0 and fPickup.z ~= 0 then
            ENTITY.SET_ENTITY_COORDS(players.user_ped(), fPickup.x, fPickup.y, fPickup.z + 1.0 , false, false, false, false) 
            util.toast("TP to Flatbed")
        else                 util.toast ("No Bunker Supplies Found")   

        end 
end)
menu.action(TELEPORT_PLACE,"Weed Farm",{},"Teleports to the blue objective",function()
    TELEPORT(102.4776, 175.84846, 104.71797)    
end)
menu.action(TELEPORT_PLACE,"Meth Lab",{},"Teleports to the blue objective",function()
    TELEPORT(1454.7223, -1651.7913, 66.996445)    
end)
menu.action(TELEPORT_PLACE,"Cocaine lockup",{},"Teleports to the blue objective",function()
    TELEPORT(-1462.7239, -381.78534, 38.84075)    
end)
menu.action(TELEPORT_PLACE,"Document forgery",{},"Teleports to the blue objective",function()
    TELEPORT(298.9974, -759.0858, 29.39186)    
end)
menu.action(TELEPORT_PLACE,"Counterfeit cash",{},"Teleports to the blue objective",function()
    TELEPORT(-1171.1252, -1380.7395, 4.96877)    
end)
bus_comms = {"bmsafe","bmcargonc","bmforgerync","bmcocainenc","bmcashnc","bmmethnc","bmweednc","bmweaponsnc", "bmbunker", "bmcash", "bmcocaine", "bmforgery", "bmweed", "bmmeth","bmsafepop","bmsafearcade","bmsafeagency"}
menu.toggle(menu.my_root(), "Show All Business", {"bm_allon"}, "Helps you turn on all the business with oneclick", function(on)
    if on then
        for k,val in pairs(bus_comms) do
            menu.trigger_commands(val .. " on")
        end
    else
        for k,val in pairs(bus_comms) do
            menu.trigger_commands(val .. " off")
        end
    end
end)
menu.toggle(menu.my_root(), "Underlay", {"bm_underlay"}, "Shows an underlay under the text. Makes clear to view", function(on)
    bm_underlay = on
end, false)
menu.toggle_loop(menu.my_root(),"MC Business Resupply Discount", {},"Make sure use this before accessing the laptop!", function()
    SET_INT_GLOBAL(262145 + 18998, 1000) 
end, function()
    SET_INT_GLOBAL(262145 + 18998, 15000)
end)
menu.toggle_loop(menu.my_root(),"Bunker Resupply Discount", {},"Make sure use this before accessing the laptop!", function()
    SET_INT_GLOBAL(262145 + 21599, 1000) 
    SET_INT_GLOBAL(262145 + 21600, 1000) 
end, function()
    SET_INT_GLOBAL(262145 + 21599, 15000)
    SET_INT_GLOBAL(262145 + 21600, 15000)
end)
menu.toggle_loop(menu.my_root(),"Single MC Vehicle Sell", {},"Makes always number of MC business selling's vehicle is one.", function()
    if GET_INT_LOCAL("gb_biker_contraband_sell", 696 + 17) ~= 0 then
        SET_INT_LOCAL("gb_biker_contraband_sell", 696 + 17, 0)
    end
end)
function get_last_mp_char()
    log("alloc 4 bytes, get_last_mp_char")
    local outptr = memory.alloc(4)
    STATS.STAT_GET_INT(MISC.GET_HASH_KEY("MPPLY_LAST_MP_CHAR"), outptr, -1)
    local out = memory.read_int(outptr)
    log("get_last_mp_char free mem")
    memory.free(outptr)
    return out
end
function get_business_slot_supplies(slot)
    prefix = "MP" .. get_last_mp_char() .. "_"
    log("alloc 4 bytes, get_business_slot_supplies")
    local outptr = memory.alloc(4)
    STATS.STAT_GET_INT(MISC.GET_HASH_KEY(prefix .. "MATTOTALFORFACTORY" .. slot), outptr, -1)
    local out = memory.read_int(outptr)
    log("get_business_slot_supplies free mem")
    memory.free(outptr)
    return out
end
function get_hub_product_of_type(id)
    prefix = "MP" .. get_last_mp_char() .. "_"
    log("alloc 4 bytes, get_hub_product_of_type")
    local outptr = memory.alloc(4)
    STATS.STAT_GET_INT(MISC.GET_HASH_KEY(prefix .. "HUB_PROD_TOTAL_" .. id), outptr, -1)
    local out = memory.read_int(outptr)
    log("get_hub_product_of_type free mem")
    memory.free(outptr)
    return out
end
function get_business_slot_product(slot)
    log("alloc 4 bytes, get_business_slot_product")
    prefix = "MP" .. get_last_mp_char() .. "_"
    local outptr = memory.alloc(4)
    STATS.STAT_GET_INT(MISC.GET_HASH_KEY(prefix .. "PRODTOTALFORFACTORY" .. slot), outptr, -1)
    local out = memory.read_int(outptr)
    log("get_business_slot_product free mem")
    memory.free(outptr)
    return out
end
function get_resupply_timer(slot)
    prefix = "MP" .. get_last_mp_char() .. "_"
    log("alloc 4 bytes, get_resupply_timer")
    local outptr = memory.alloc(4)
    STATS.STAT_GET_INT(MISC.GET_HASH_KEY(prefix .. "PAYRESUPPLYTIMER" .. slot), outptr, -1)
    local out = memory.read_int(outptr)
    log("get_resupply_timer free mem")
    memory.free(outptr)
    return out
end
function get_bunker_research()
    prefix = "MP" .. get_last_mp_char() .. "_"
    log("alloc 4 bytes, get_bunker_research")
    local outptr = memory.alloc(4)
    STATS.STAT_GET_INT(MISC.GET_HASH_KEY(prefix .. "RESEARCHTOTALFORFACTORY5"), outptr, -1)
    local out = memory.read_int(outptr)
    log("get_bunker_research free mem")
    memory.free(outptr)
    return out
    --RESEARCHTOTALFORFACTORY5 
end

-- this is a patch for if the default state makes the vehicle uses go negative  ( DEFAULT STATE VALUES )

meth_col = to_rgb(1, 1, 1, 1)
weed_col = to_rgb(1, 1, 1, 1)
bunker_col = to_rgb(1, 1, 1, 1)
cash_col = to_rgb(1, 1, 1, 1)
cocaine_col = to_rgb(1, 1, 1, 1)
forgery_col = to_rgb(1, 1, 1, 1)
cargo_col = to_rgb(1, 1, 1, 1)
weapons_col = to_rgb(1, 1, 1, 1)
meth_info = {"???", "???"}
weed_info = {"???", "???"}
cash_info = {"???", "???"}
cocaine_info = {"???", "???", "???"}
doc_info = {"???", "???"}
bunker_info = {"???", "???", "???"}
nightclub_info = {"???"}
bm_xoffset = 0
bm_uoffset = 0
bm_uwidth = 0.7
bus_ticks = 0
hub_cargonc = 0
hub_ticks = 0
hub_meth = 0
hub_weed = 0
hub_cocaine = 0
hub_forgery = 0
hub_counterfeit = 0
hub_cargo = 0
hub_weapons = 0
methbuses = {1, 6, 11, 16}
weedbuses = {2, 7, 12, 17}
cocbuses = {3, 8, 13, 18}
cashbuses = {4, 9, 14, 19}
docbuses = {5, 10, 15, 20}
bunkerbuses = {21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31}
nightclubs = {}
arcades = {}
cinestate_active = false
-- we are done loading!
is_loading = false
-----------------------------
while true do

    if bus_ticks > 0 then
        for i=0,5 do
            log("alloc 4 bytes, bus tick")
            local outptr = memory.alloc(4)
            STATS.STAT_GET_INT(MISC.GET_HASH_KEY("MP0_" .. "FACTORYSLOT" .. i), outptr, -1)
            local id = memory.read_int(outptr)
            if hasValue(methbuses, id) then
                meth_info = {get_business_slot_product(i), get_business_slot_supplies(i)}
            elseif hasValue(weedbuses, id) then
                weed_info = {get_business_slot_product(i), get_business_slot_supplies(i)}
            elseif hasValue(cocbuses, id) then
                cocaine_info = {get_business_slot_product(i), get_business_slot_supplies(i)}
            elseif hasValue(cashbuses, id) then
                cash_info = {get_business_slot_product(i), get_business_slot_supplies(i)}
            elseif hasValue(docbuses, id) then
                doc_info = {get_business_slot_product(i), get_business_slot_supplies(i)}
            elseif hasValue(bunkerbuses, id) then
                bunker_info = {get_business_slot_product(i), get_business_slot_supplies(i), get_bunker_research(i)}
            end
            log("bus ticks free mem")
            memory.free(outptr)
        end
        for i=0, 6 do
            local total = get_hub_product_of_type(i)
            if i == 0 then
                hub_cargo = total
            elseif i == 1 then
                hub_weapons = total
            elseif i == 2 then
                hub_cocaine = total
            elseif i == 3 then
                hub_meth = total
            elseif i == 4 then
                hub_weed = total
            elseif i == 5 then
                hub_forgery = total
            elseif i == 6 then
                hub_counterfeit = total
            end
        end
    end
    if util.is_session_started() then
        if bm_underlay then
            if bm_meth or bm_weed or bm_documents or bm_cocaine or bm_bunker or bm_cash or bm_nightclubsafe or bm_hub or bm_cargonc or hub_cash1 or hub_cocaine1 or hub_forgery1 or hub_weed1 or hub_meth1 or hub_w then
                local black = black
                black.a = 0.6
                directx.draw_rect(0.78 + bm_uoffset, 0.1, bm_uwidth, 0.45, black)
            end
        end
        local ct = 0
        if bm_meth then
            ct = ct + 0.14
            local line = "MC Meth: " .. meth_info[1] .. "/20 " .. meth_info[2] .. "% "
            directx.draw_text(1.0 + bm_xoffset, ct, line, 8, 0.8, meth_col, true)
        end

        if bm_weed then
            ct = ct + 0.03
            local line = "MC Weed: " .. weed_info[1] .. "/80 " .. weed_info[2] .. "% "
            directx.draw_text(1.0 + bm_xoffset, ct, line, 8, 0.8, weed_col, true)
        end

        if bm_documents then
            ct = ct + 0.03
            local line = "MC Forgery: " .. doc_info[1] .. "/60 " .. doc_info[2] .. "% "
            directx.draw_text(1.0 + bm_xoffset, ct, line, 8, 0.8, forgery_col, true)
        end


        if bm_cocaine then
            ct = ct + 0.03
            local line = "MC Cocaine: " .. cocaine_info[1] .. "/10 " .. cocaine_info[2] .. "% "
            directx.draw_text(1.0 + bm_xoffset, ct, line, 8, 0.8, cocaine_col, true)
        end


        if bm_cash then
            ct = ct + 0.03
            local line = "MC Counterfeit: " .. cash_info[1] .. "/40 " .. cash_info[2] .. "% "
            directx.draw_text(1.0 + bm_xoffset, ct, line, 8, 0.8, cash_col, true)
        end

        if bm_bunker then
            ct = ct + 0.03
            local line = "Bunker: " .. bunker_info[1] .. "/100 " .. bunker_info[2] .. "%, Research: " .. bunker_info[3] .. "% "
            directx.draw_text(1.0 + bm_xoffset, ct, line, 8, 0.8, bunker_col, true)
        end


        if bm_nightclubsafe then
            prefix = "MP" .. get_last_mp_char() .. "_"
            log("alloc 4 bytes, nightclubsafe")
            local safevalptr = memory.alloc(4)
            STATS.STAT_GET_INT(MISC.GET_HASH_KEY(prefix .. "CLUB_SAFE_CASH_VALUE"), safevalptr, -1)
            safeval = memory.read_int(safevalptr)
            log("nightclubsafe free mem")
            memory.free(safevalptr)
            ct = ct + 0.03
            directx.draw_text(1.0 + bm_xoffset, ct, "Nightclub Safe $ " .. safeval .. " ", 8, 0.8, cash_col, true)
        end
        if bm_nightclubpopularity then
            prefix = "MP" .. get_last_mp_char() .. "_"
            log("alloc 4 bytes, nightclubpopularity")
            local safevalptr = memory.alloc(4)
            STATS.STAT_GET_INT(MISC.GET_HASH_KEY(prefix .. "CLUB_POPULARITY"), safevalptr, -1)
            safeval = memory.read_int(safevalptr)
            log("nightclubpopularity free mem")
            memory.free(safevalptr)
            ct = ct + 0.03
            directx.draw_text(1.0 + bm_xoffset, ct, "Nightclub Popularity " .. safeval .. "% ", 8, 0.8, cash_col, true)
        end
        if bm_arcadesafe then
            prefix = "MP" .. get_last_mp_char() .. "_"
            log("alloc 4 bytes, Arcadesafe")
            local safevalptr = memory.alloc(4)
            STATS.STAT_GET_INT(MISC.GET_HASH_KEY(prefix .. "ARCADE_SAFE_CASH_VALUE"), safevalptr, -1)
            safeval = memory.read_int(safevalptr)
            log("Arcadesafe free mem")
            memory.free(safevalptr)
            ct = ct + 0.03
            directx.draw_text(1.0 + bm_xoffset, ct, "Arcade Safe $ " .. safeval .. " ", 8, 0.8, cash_col, true)
        end
        if bm_agencysafe then
            prefix = "MP" .. get_last_mp_char() .. "_"
            log("alloc 4 bytes, Agencysafe")
            local safevalptr = memory.alloc(4)
            STATS.STAT_GET_INT(MISC.GET_HASH_KEY(prefix .. "FIXER_SAFE_CASH_VALUE"), safevalptr, -1)
            safeval = memory.read_int(safevalptr)
            log("Arcadesafe free mem")
            memory.free(safevalptr)
            ct = ct + 0.03
            directx.draw_text(1.0 + bm_xoffset, ct, "Agency Safe $ " .. safeval .. " ", 8, 0.8, cash_col, true)
        end


        if bm_cargonc then
            ct = ct + 0.03
            local line = "Hub Cargo: " .. hub_cargo .. "/50 " 
            directx.draw_text(1.0 + bm_xoffset, ct, line, 8, 0.8,cargo_col, true)
        end
        if bm_forgerync then
            ct = ct + 0.03
            local line = "Hub Forgery: " .. hub_forgery .. "/60 " 
            directx.draw_text(1.0 + bm_xoffset, ct, line, 8, 0.8,forgery_col, true)
        end
        if bm_weednc then
            ct = ct + 0.03
            local line = "Hub Weed: " .. hub_weed .. "/80 " 
            directx.draw_text(1.0 + bm_xoffset, ct, line, 8, 0.8,weed_col, true)
        end
        if bm_cocainenc then
            ct = ct + 0.03
            local line = "Hub Cocaine: " .. hub_cocaine .. "/10 " 
            directx.draw_text(1.0 + bm_xoffset, ct, line, 8, 0.8,cocaine_col, true)
        end
        if bm_cashnc then
            ct = ct + 0.03
            local line = "Hub Counterfeit: " .. hub_counterfeit .. "/40 " 
            directx.draw_text(1.0 + bm_xoffset, ct, line, 8, 0.8,cash_col, true)
        end
        if bm_methnc then
            ct = ct + 0.03
            local line = "Hub Meth: " .. hub_meth .. "/20 " 
            directx.draw_text(1.0 + bm_xoffset, ct, line, 8, 0.8,meth_col, true)
        end
        if bm_weaponsnc then
            ct = ct + 0.03
            local line = "Hub Weapons: " .. hub_weapons .. "/100 " 
            directx.draw_text(1.0 + bm_xoffset, ct, line, 8, 0.8,weapons_col, true)
        end
    end

	util.yield()
end





