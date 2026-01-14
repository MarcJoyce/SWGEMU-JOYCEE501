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
	AdminPlayerID = 281474993546765,
	terminalIDs = {4685572},
	itemDescription = "This item has been produced by the BazaarBot.",
}

function BazaarBotScreenPlay:start()
	self:validateEvent("BazaarBotAddArmor", "addMoreArmor", 1)
	self:validateEvent("BazaarBotAddClothing", "addMoreClothing", 2)
	self:validateEvent("BazaarBotAddFood", "addMoreFood", 3)
	self:validateEvent("BazaarBotAddFurniture", "addMoreFurniture", 4)
	self:validateEvent("BazaarBotAddArtisanItems", "addMoreArtisanItems", 5)
	self:validateEvent("BazaarBotAddMedicine", "addMoreMedicine", 6)
	self:validateEvent("BazaarBotAddStructures", "addMoreStructures", 7)
	self:validateEvent("BazaarBotAddVehicles", "addMoreVehicles", 8)
	self:validateEvent("BazaarBotAddWeapons", "addMoreWeapons", 9)
	self:validateEvent("BazaarBotAddLoot", "addMoreLoot", 10)

	-- if (hasServerEvent("BazaarBotCleanInventory")) then
	-- 	rescheduleServerEvent("BazaarBotCleanInventory", 180 * 1000)
	-- else
	-- 	createServerEvent(180 * 1000, "BazaarBotScreenPlay", "checkInventory", "BazaarBotCleanInventory")
	-- end
end

function BazaarBotScreenPlay:validateEvent(eventName, functionName, freq)
	self:logTroubleshoot("Validating event for: " .. eventName)

	if (hasServerEvent(eventName)) then
		local eventID = getServerEventID(eventName)
		local timeLeft = getServerEventTimeLeft(eventID)
		self:logTroubleshoot(eventName .. " is active and time left is: " .. timeLeft)
		if (timeLeft < freq or timeLeft > 86400000) then
			self:logTroubleshoot("Rescheduling event for " .. eventName .. " for " .. freq .. "s")
			rescheduleServerEvent(eventName, freq * 30 * 1000)
		end
	else
		self:logTroubleshoot("Event " .. eventName .. " is not active and we are creating event")
		createServerEvent(freq * 30 * 1000, "BazaarBotScreenPlay", functionName, eventName)
	end
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
	self:logFull("BazaarBotScreenPlay: All listing events have now started and will repeat on their own periodically.\n")
end

function BazaarBotScreenPlay:checkInventory()
  local pBazaarBot = getCreatureObject(self.AdminPlayerID)
	local offlineMode = false
	if (pBazaarBot == nil) then
			pBazaarBot = getObjectFromDatabase(self.AdminPlayerID)
			if (pBazaarBot ~= nil) then
					offlineMode = true
			end
	end

	if (pBazaarBot == nil) then
			self:logTroubleshoot("checkInventory: BazaarBot is offline or not found, will retry in 5 minutes")
			if (not hasServerEvent("BazaarBotCleanInventory")) then
					createServerEvent(5 * 60 * 1000, "BazaarBotScreenPlay", "checkInventory", "BazaarBotCleanInventory")
			else
					rescheduleServerEvent("BazaarBotCleanInventory", 5 * 60 * 1000)
			end
			return
	end

	local pInventory = CreatureObject(pBazaarBot):getSlottedObject("inventory")
	if (pInventory == nil) then
			self:logTroubleshoot("checkInventory: pInventory is nil")
			return
	end
	self:cleanInventory(pBazaarBot, pInventory, offlineMode)
end

function BazaarBotScreenPlay:cleanInventory(pBazaarBot, pInventory)
    self:logFull("BazaarBotScreenPlay: Cleaning my inventory. This may kick out an error message about a table not being in range, which you can ignore.")
    local limit = 80
    local count = 0
    
	while (SceneObject(pInventory):getContainerObjectsSize() > 0 and count < limit) do
        local pItem = SceneObject(pInventory):getContainerObject(0)
        if (pItem == nil) then break end

        SceneObject(pItem):destroyObjectFromDatabase()
        if (not offlineMode) then
            SceneObject(pItem):destroyObjectFromWorld()
        end
        count = count + 1
    end

    if (count >= limit) then
        self:logTroubleshoot("cleanInventory: reached safety limit while cleaning inventory (" .. tostring(limit) .. ")")
    end

    if (not hasServerEvent("BazaarBotCleanInventory")) then
        -- createServerEvent(1 * 24 * 60 * 60 * 1000, "BazaarBotScreenPlay", "checkInventory", "BazaarBotCleanInventory")
    end
    self:logFull("BazaarBotScreenPlay: Done!")
end

function BazaarBotScreenPlay:logFull(message)
	local outputFile = "log/bazaarbot_full.log"
	logToFile(message, outputFile)
end

function BazaarBotScreenPlay:logListing(message)
	local outputFile = "log/bazaarbot_listings.log"
	logToFile(message, outputFile)
	self:logFull(message)
end

function BazaarBotScreenPlay:logTroubleshoot(message)
	local outputFile = "log/bazaarbot_troubleshoot.log"
	logToFile(message, outputFile)
end

function BazaarBotScreenPlay:chooseBazaarTerminal()
	local vendorID = 0

	if (#self.terminalIDs > 1) then
		vendorID = self.terminalIDs[getRandomNumber(1, #self.terminalIDs)]
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
	self:addMoreCraftedItems(BBVehicleConfig, BBVehicleItems)
end

function BazaarBotScreenPlay:addMoreCraftedItems(configTable, itemTable)
	self:listCraftedItems(configTable, itemTable)
	
	local nextTime = configTable.freq * 1000;
	-- local nextTime = 60 * 2 * 1000;

	if (hasServerEvent(configTable.eventName)) then
		rescheduleServerEvent(configTable.eventName, nextTime)
	else
		createServerEvent(nextTime, "BazaarBotScreenPlay", configTable.functionName, configTable.eventName)
	end 
	self:logFull("Scheduled " .. configTable.functionName .. " to run again in " .. tostring(nextTime / 1000) .. " seconds.")
end

function BazaarBotScreenPlay:listCraftedItems(configTable, itemTable)
    local pVendor = self:chooseBazaarTerminal()
    local pBazaarBot = getCreatureObject(self.AdminPlayerID)
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
						if (altTemplate == 0) then
                        	altTemplate = nil
                    	end
                    local crateQuantity = itemTable[j][3]
                
                    -- Determine item quality
                    local excellent = getRandomNumber(1, 100)
                    local minQuality = configTable.qualityMin
                    local maxQuality = configTable.qualityAvg
                    
                    if (excellent > 95) then
                        minQuality = configTable.qualityMax + 1
                        maxQuality = configTable.qualityMax + 5
                    elseif (excellent > 89) then
                        minQuality = configTable.qualityAvg
                        maxQuality = configTable.qualityMax
                    end
                
                    local quality = getRandomNumber(minQuality, maxQuality)
                    local price = itemTable[j][1] * (((quality/200) + 1) * crateQuantity) * 3
                  
										
					local pItem = bazaarBotCreateCraftedItemAndList(pBazaarBot, template, crateQuantity, quality, altTemplate, pVendor, self.itemDescription, price)
					self:logListing("Loot: " .. SceneObject(pItem):getObjectName() .. " (quality: " .. tostring(quality) .. ") " .. tostring(price) .. "cr")
					-- self:checkInventory()
										
                    -- local pItem = bazaarBotCreateCraftedItem(pBazaarBot, template, crateQuantity, quality, altTemplate)

                    -- if (pItem ~= nil) then
										-- 	bazaarBotListItem(pBazaarBot, pItem, pVendor, self.itemDescription, price)
										-- 	self:logListing("Loot: " .. SceneObject(pItem):getObjectName() .. " (quality: " .. tostring(quality) .. ") " .. tostring(price) .. "cr")
										-- 	self:checkInventory()
                    -- else
										-- 	self:logFull("Craft: " .. configTable.functionName .. ":" .. template .. "() Failed")
										-- 	self:checkInventory()
                    -- end
                end
            end
        end
    end
    -- self:checkInventory()
end

function BazaarBotScreenPlay:addMoreLoot() 
	-- self:checkInventory()
	local nextTime = (BBLootConfig.freq) * 1000

	if (hasServerEvent(BBLootConfig.eventName)) then
			rescheduleServerEvent(BBLootConfig.eventName, nextTime)
	else
			createServerEvent(nextTime, "BazaarBotScreenPlay", BBLootConfig.functionName, BBLootConfig.eventName)
	end 

	local pVendor = self:chooseBazaarTerminal()

	local pBazaarBot = getCreatureObject(self.AdminPlayerID)

	local pInventory = CreatureObject(pBazaarBot):getSlottedObject("inventory")

	if pInventory == nil then
		self:logFull("Error locating target inventory")
		return nil
	end

	for i = 1, BBLootConfig.quantity do
		local rarity = getRandomNumber(1, 100)

		local indexGroup = 1

		if (rarity > 95) then
			indexGroup = 9 -- Extremely Rare		
		elseif (rarity > 79) then
			indexGroup = getRandomNumber(7,8) -- Rare
		elseif (rarity > 49) then
			indexGroup = getRandomNumber(5,6) -- Uncommon
		elseif (rarity > 0) then
			indexGroup = getRandomNumber(1,4) -- Common
		end

		local lootName = BBLootItems[indexGroup][getRandomNumber(1, #BBLootItems[indexGroup])]
		
		local lootLevel = getRandomNumber(BBLootConfig.minLevel, BBLootConfig.maxLevel)

		local lootLevelFactor = (BBLootPriceRanges[indexGroup].minPrice) * (lootLevel / 300 + 1)

		if (indexGroup == 1 or indexGroup == 3 or indexGroup == 5) then
			lootLevelFactor = (BBLootPriceRanges[indexGroup].minPrice)
		end

		local price = getRandomNumber(lootLevelFactor, BBLootPriceRanges[indexGroup].maxPrice) * 1.5

		local pItem = bazaarBotCreateLootItem(pBazaarBot, lootName, lootLevel, true, pVendor, self.itemDescription, price)
		self:logListing("Loot: lootName: " .. lootName .. ", objectName: " .. SceneObject(pItem):getObjectName() .. " (level: " .. tostring(lootLevel) .. ") " .. tostring(price) .. "cr")

		-- local pItem = bazaarBotCreateLootItem(pBazaarBot, lootName, lootLevel, true)

		-- if (pItem ~= nil) then
		-- 		local lootLevelFactor = (BBLootPriceRanges[indexGroup].minPrice) * (lootLevel / 300 + 1)
		-- 		if (indexGroup == 1 or indexGroup == 3 or indexGroup == 5) then
		-- 			lootLevelFactor = (BBLootPriceRanges[indexGroup].minPrice)
		-- 		end

		-- 		local price = getRandomNumber(lootLevelFactor, BBLootPriceRanges[indexGroup].maxPrice)

		-- 		local junkValue = TangibleObject(pItem):getJunkValue()

		-- 		if (junkValue > price) then
		-- 				price = junkValue * 2
		-- 		end

		-- 		bazaarBotListItem(pBazaarBot, pItem, pVendor, self.itemDescription, price)
		-- 		self:logListing("Loot: " .. SceneObject(pItem):getObjectName() .. " (level: " .. tostring(lootLevel) .. ") " .. tostring(price) .. "cr")
		-- else
		-- 		self:logFull("Loot: " .. lootName .. " (" ..tostring(lootLevel) .. ") failed")
		-- end
	end
end

registerScreenPlay("BazaarBotScreenPlay", true)
