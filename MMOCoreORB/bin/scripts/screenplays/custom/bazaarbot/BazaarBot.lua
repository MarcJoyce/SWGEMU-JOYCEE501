includeFile("custom/bazaarbot/table_resources.lua")
includeFile("custom/bazaarbot/table_armor.lua")
includeFile("custom/bazaarbot/table_medicine.lua")
includeFile("custom/bazaarbot/table_food.lua")
includeFile("custom/bazaarbot/table_weapons.lua")
includeFile("custom/bazaarbot/table_item_artisan.lua")
includeFile("custom/bazaarbot/table_structures.lua")
includeFile("custom/bazaarbot/table_furniture.lua")
includeFile("custom/bazaarbot/table_clothing.lua")
includeFile("custom/bazaarbot/table_loot.lua")
includeFile("custom/bazaarbot/table_vehicles.lua")

BazaarBotScreenPlay = ScreenPlay:new {
	numberOfActs = 1,
	BazaarBotID = 281475000105551, -- Make a character named BazaarBot and put its PlayerID number here (/getPlayerID BazaarBot).
	terminalIDs = {4685572}, -- One SNAPSHOT FILE LOADED Bazaar Terminal ObjectID per region/city you want to (randomly) sell items in
	itemDescription = "", -- Optional message in the description window.
	listingsInit = 10, -- On first boot after this system is installed, the server will loop this many times through the add functions
}

registerScreenPlay("BazaarBotScreenPlay", true)

function BazaarBotScreenPlay:start()
	local pBazaarBot = getCreatureObject(self.BazaarBotID)
	
	if (pBazaarBot == nil) then
		printf("ERROR: BazaarBot character does not exist! Please create it on an ADMIN ACCOUNT and configure bin/screenplays/custom/bazaarbot/BazaarBotScreenPlay.lua to use the system.")
		return
	end

	-- Testing trigger object (WARNING: ANY PLAYER CAN INTERACT WITH IT!)
	--self:loadTestingObject()

	-- Populate a new server's bazaar 
  --   local init = getQuestStatus("BazaarBotScreenPlay:Initialized")
	
	-- if (init == nil) then
	-- 	createServerEvent(300*1000, "BazaarBotScreenPlay", "initializeListings", "BazaarBotInitializeListings")
	-- else
		-- Schedule the lister events for after server has fully booted
	-- if (hasServerEvent("BazaarBotStartEvents")) then
	-- 		rescheduleServerEvent("BazaarBotStartEvents", 300 * 1000)
	-- else
	-- 		createServerEvent(300 * 1000, "BazaarBotScreenPlay", "startEvents", "BazaarBotStartEvents")
	-- end

	if (hasServerEvent("BazaarBotAddArmor")) then
		-- rescheduleServerEvent("BazaarBotAddArmor", BBArmorConfig.freq * 1000)
	else
		createServerEvent(BBArmorConfig.freq * 1000, "BazaarBotScreenPlay", "addMoreArmor", "BazaarBotAddArmor")
	end

	if (hasServerEvent("BazaarBotAddClothing")) then
		-- rescheduleServerEvent("BazaarBotAddClothing", BBClothingConfig.freq * 1000)
	else
		createServerEvent(BBClothingConfig.freq * 1000, "BazaarBotScreenPlay", "addMoreClothing", "BazaarBotAddClothing")
	end

	if (hasServerEvent("BazaarBotAddFood")) then
		-- rescheduleServerEvent("BazaarBotAddFood", BBFoodConfig.freq * 1000)
	else
		createServerEvent(BBFoodConfig.freq * 1000, "BazaarBotScreenPlay", "addMoreFood", "BazaarBotAddFood")
	end

	if (hasServerEvent("BazaarBotAddFurniture")) then
		-- rescheduleServerEvent("BazaarBotAddFurniture", BBFurnitureConfig.freq * 1000)
	else
		createServerEvent(BBFurnitureConfig.freq * 1000, "BazaarBotScreenPlay", "addMoreFurniture", "BazaarBotAddFurniture")
	end

	if (hasServerEvent("BazaarBotAddArtisanItems")) then
		-- rescheduleServerEvent("BazaarBotAddArtisanItems", BBArtisanItemsConfig.freq * 1000)
	else
		createServerEvent(BBArtisanItemsConfig.freq * 1000, "BazaarBotScreenPlay", "addMoreArtisanItems", "BazaarBotAddArtisanItems")
	end

	if (hasServerEvent("BazaarBotAddLoot")) then
		-- rescheduleServerEvent("BazaarBotAddLoot", BBLootConfig.freq * 1000)
	else
		createServerEvent(BBLootConfig.freq * 1000, "BazaarBotScreenPlay", "addMoreLoot", "BazaarBotAddLoot")
	end

	if (hasServerEvent("BazaarBotAddMedicine")) then
		-- rescheduleServerEvent("BazaarBotAddMedicine", BBMedicineConfig.freq * 1000)
	else
		createServerEvent(BBMedicineConfig.freq * 1000, "BazaarBotScreenPlay", "addMoreMedicine", "BazaarBotAddMedicine")
	end

	if (hasServerEvent("BazaarBotAddStructures")) then
		-- rescheduleServerEvent("BazaarBotAddStructures", BBStructuresConfig.freq * 1000)
	else
		createServerEvent(BBStructuresConfig.freq * 1000, "BazaarBotScreenPlay", "addMoreStructures", "BazaarBotAddStructures")
	end

	if (hasServerEvent("BazaarBotAddVehicles")) then
		-- rescheduleServerEvent("BazaarBotAddVehicles", BBVehiclesConfig.freq * 1000)
	else
		createServerEvent(BBVehiclesConfig.freq * 1000, "BazaarBotScreenPlay", "addMoreVehicles", "BazaarBotAddVehicles")
	end

	if (hasServerEvent("BazaarBotAddWeapons")) then
		-- rescheduleServerEvent("BazaarBotAddWeapons", BBWeaponsConfig.freq * 1000)
	else
		createServerEvent(BBWeaponsConfig.freq * 1000, "BazaarBotScreenPlay", "addMoreWeapons", "BazaarBotAddWeapons")
	end
	
	-- Schedule inventory purging
	if (hasServerEvent("BazaarBotCleanInventory")) then
		rescheduleServerEvent("BazaarBotCleanInventory", 180 * 1000)
	else
			createServerEvent(180 * 1000, "BazaarBotScreenPlay", "checkInventory", "BazaarBotCleanInventory")
	end
	-- end
end

function BazaarBotScreenPlay:startEvents()
	self:addMoreArmor()
	self:addMoreMedicine()
	self:addMoreFood()
	self:addMoreWeapons()
	self:addMoreArtisanItems()
	self:addMoreStructures()
	self:addMoreFurniture()
	self:addMoreClothing()
	self:addMoreLoot()
	self:addMoreVehicles()
	printf("BazaarBotScreenPlay: All listing events have now started and will repeat on their own periodically.\n")
end

-- function BazaarBotScreenPlay:initializeListings()
-- 	printf("BazaarBotScreenPlay: Populating bazaar with items and resources for the first time...\n")
-- 	for i = 1, self.listingsInit do
-- 		self:addMoreArmor()
-- 		self:addMoreMedicine()
-- 		self:addMoreFood()
-- 		self:addMoreWeapons()
-- 		self:addMoreArtisanItems()
-- 		-- self:addMoreStructures()
-- 		self:addMoreFurniture()
-- 		self:addMoreClothing()
-- 		self:addMoreLoot()
-- 	end
-- 	setQuestStatus("BazaarBotScreenPlay:Initialized", 1)
-- 	printf("BazaarBotScreenPlay: Initialized!\n")
-- end

-- A full inventory will prevent the creation and listing of new items
function BazaarBotScreenPlay:checkInventory()
	local pBazaarBot = getCreatureObject(self.BazaarBotID)
	local pInventory = CreatureObject(pBazaarBot):getSlottedObject("inventory")
	local itemInInventory = math.tointeger(SceneObject(pInventory):getContainerObjectsSize())
	
	-- if (itemInInventory > 1) then
	-- self:cleanInventory(pBazaarBot, pInventory)
	-- end
	self:cleanInventory(pBazaarBot, pInventory)
end

function BazaarBotScreenPlay:cleanInventory(pBazaarBot, pInventory)
	printf("BazaarBotScreenPlay: Cleaning my inventory. This may kick out an error message about a table not being in range, which you can igone.\n")
	
	while (itemInInventory ~= nil) do
		local pItem = SceneObject(pInventory):getContainerObject(i)
		
		SceneObject(pItem):destroyObjectFromWorld()
		SceneObject(pItem):destroyObjectFromDatabase()
		
		itemInInventory = math.tointeger(SceneObject(pInventory):getContainerObjectsSize())
	end

	createServerEvent(1 * 24 * 60 * 60 * 1000, "BazaarBotScreenPlay", "checkInventory", "BazaarBotCleanInventory")
	
	printf("BazaarBotScreenPlay: Done!\n")
end

function BazaarBotScreenPlay:logListing(message)
	local outputFile = "log/bazaarbot_listings.log"
	logToFile(message, outputFile)
end

function BazaarBotScreenPlay:chooseBazaarTerminal()
	local vendorID = 0

	if (#self.terminalIDs > 1) then
		vendorID = self.vendorIDs[getRandomNumber(1, #self.terminalIDs)]
	else
		vendorID = self.terminalIDs[1]
	end
	
	local pVendor = getSceneObject(vendorID)
	
	return pVendor
end

-- Crafted Item Functions

function BazaarBotScreenPlay:addMoreArmor()
	self:addMoreCraftedItems(BBArmorConfig, BBArmorItems)
end

function BazaarBotScreenPlay:addMoreMedicine()
	self:addMoreCraftedItems(BBMedicineConfig, BBMedicineItems)
end

function BazaarBotScreenPlay:addMoreFood()
	self:addMoreCraftedItems(BBFoodConfig, BBFoodItems)
end

function BazaarBotScreenPlay:addMoreWeapons()
	self:addMoreCraftedItems(BBWeaponsConfig, BBWeaponsItems)
end

function BazaarBotScreenPlay:addMoreArtisanItems()
	self:addMoreCraftedItems(BBArtisanConfig, BBArtisanItems)
end

function BazaarBotScreenPlay:addMoreStructures()
	self:addMoreCraftedItems(BBStructuresConfig, BBStructuresItems)
end

function BazaarBotScreenPlay:addMoreFurniture()
	self:addMoreCraftedItems(BBFurnitureConfig, BBFurnitureItems)
end

function BazaarBotScreenPlay:addMoreClothing()
	self:addMoreCraftedItems(BBClothingConfig, BBClothingItems)
end

function BazaarBotScreenPlay:addMoreVehicles()
	self:addMoreCraftedItems(BBVehicleConfig, BBVehcileItems)
end

function BazaarBotScreenPlay:addMoreCraftedItems(configTable, itemTable)
	self:checkInventory()
	self:listCraftedItems(configTable, itemTable)
	
	-- local nextTime = configTable.freq * 1000 + getRandomNumber(1,300000)
    local nextTime = configTable.freq * 1000;
	
	if (hasServerEvent(configTable.eventName)) then
		rescheduleServerEvent(configTable.eventName, nextTime)
	else
		createServerEvent(nextTime, "BazaarBotScreenPlay", configTable.functionName, configTable.eventName)
	end
end

function BazaarBotScreenPlay:listCraftedItems(configTable, itemTable)
    local pVendor = self:chooseBazaarTerminal()
    local pBazaarBot = getCreatureObject(self.BazaarBotID)
    local listedOK = false
    
    -- Get the listing chance from config, default to 100% if not specified
    local listingChance = configTable.listingChance or 100
    
    for j = 1, #itemTable do
        -- Roll for each item group based on listingChance
        if getRandomNumber(1, 100) <= listingChance then
            for i = 1, itemTable[j][2] do -- quantity
                for k = 5, #itemTable[j] do -- items in each group/index
                    local template = configTable.path .. itemTable[j][k] .. ".iff"
                    local altTemplate = itemTable[j][4]
                    local crateQuantity = itemTable[j][3]
                
                    -- Determine item quality
                    local excellent = getRandomNumber(1, 100)
                    local minQuality = configTable.qualityMin
                    local maxQuality = configTable.qualityAvg
                    
                    if (excellent > 89) then
                        minQuality = configTable.qualityAvg
                        maxQuality = configTable.qualityMax
                    elseif (excellent > 99) then
                        minQuality = configTable.qualityMax + 1
                        maxQuality = configTable.qualityMax + 5
                    end
                
                    local quality = getRandomNumber(minQuality,maxQuality)
                    local price = itemTable[j][1] * ((quality/200) + 1) * crateQuantity
                    
                    local pItem = bazaarBotCreateCraftedItem(pBazaarBot, template, crateQuantity, quality, altTemplate)

                    if (pItem ~= nil) then
                        bazaarBotListItem(pBazaarBot, pItem, pVendor, self.itemDescription, price)
                    else
                        self:logListing("Craft: " .. configTable.functionName .. "() Failed: " .. template)
                        return
                    end
                end
            end
        end
    end
    
    self:logListing("Craft: " .. configTable.functionName .. "() OK")
end

-- function BazaarBotScreenPlay:listCraftedItems(configTable, itemTable)
-- 	local pVendor = self:chooseBazaarTerminal()
-- 	local pBazaarBot = getCreatureObject(self.BazaarBotID)
-- 	local listedOK = false
	
-- 	for j = 1, #itemTable do
-- 		for i = 1, itemTable[j][2] do -- quantity
-- 			for k = 5, #itemTable[j] do -- items in each group/index
-- 				local template = configTable.path .. itemTable[j][k] .. ".iff"
-- 				local altTemplate = itemTable[j][4]
-- 				local crateQuantity = itemTable[j][3]
			
-- 				-- Determine item quality
-- 				local excellent = getRandomNumber(1, 100)
-- 				local minQuality = configTable.qualityMin
-- 				local maxQuality = configTable.qualityAvg
				
-- 				if (excellent > 89) then
-- 					minQuality = configTable.qualityAvg
-- 					maxQuality = configTable.qualityMax
-- 				elseif (excellent > 99) then
-- 					minQuality = configTable.qualityMax + 1
-- 					maxQuality = configTable.qualityMax + 5
-- 				end
			
-- 				local quality = getRandomNumber(minQuality,maxQuality)
-- 				local price = itemTable[j][1] * ((quality/200) + 1) * crateQuantity
				
-- 				local pItem = bazaarBotCreateCraftedItem(pBazaarBot, template, crateQuantity, quality, altTemplate)

-- 				if (pItem ~= nil) then
-- 					bazaarBotListItem(pBazaarBot, pItem, pVendor, self.itemDescription, price)
-- 				else
-- 					self:logListing("Craft: " .. configTable.functionName .. "() Failed: " .. template)
-- 					return
-- 				end
-- 			end
-- 		end
-- 	end
	
-- 	self:logListing("Craft: " .. configTable.functionName .. "() OK")
-- end


-- Loot functions

function BazaarBotScreenPlay:addMoreLoot() 
		self:checkInventory()
    local nextTime = (BBLootConfig.freq) * 1000

    if (hasServerEvent(BBLootConfig.eventName)) then
        rescheduleServerEvent(BBLootConfig.eventName, nextTime)
    else
        createServerEvent(nextTime, "BazaarBotScreenPlay", BBLootConfig.functionName, BBLootConfig.eventName)
    end 

    local pVendor = self:chooseBazaarTerminal()

    local pBazaarBot = getCreatureObject(self.BazaarBotID)

    local pInventory = CreatureObject(pBazaarBot):getSlottedObject("inventory")

    if pInventory == nil then
        printf("Error locating target inventory\n")
        return nil
    end

    for i = 1, BBLootConfig.quantity do
        local rarity = getRandomNumber(1, 100)

        local indexGroup = 1

        if (rarity == 100) then
			indexGroup = 9 -- Extremely Rare		
		elseif (rarity > 96) then
			indexGroup = getRandomNumber(7,8) -- Rare
		elseif (rarity > 69) then
			indexGroup = getRandomNumber(5,6) -- Uncommon
		elseif (rarity > 0) then
			indexGroup = getRandomNumber(1,4) -- Common
		end

        local lootName = BBLootItems[indexGroup][getRandomNumber(1, #BBLootItems[indexGroup])]
        
        local lootLevel = getRandomNumber(BBLootConfig.minLevel, BBLootConfig.maxLevel)

        local pItem = bazaarBotCreateLootItem(pBazaarBot, lootName, lootLevel, true)

        if (pItem ~= nil) then
            local lootLevelFactor = (BBLootPriceRanges[indexGroup].minPrice) * (lootLevel / 250 + 1)

            local price = getRandomNumber(lootLevelFactor, BBLootPriceRanges[indexGroup].maxPrice)

            local junkValue = TangibleObject(pItem):getJunkValue()

            if (junkValue > price) then
                price = junkValue * 2
            end

            bazaarBotListItem(pBazaarBot, pItem, pVendor, self.itemDescription, price)
            self:logListing("Loot: " .. SceneObject(pItem):getObjectName() .. " (" .. tostring(lootLevel) .. ") " .. tostring(price) .. "cr")
        else
            self:logListing("Loot: " .. lootName .. " (" ..tostring(lootLevel) .. ") failed")
        end
    end

end

