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

function BazaarBotScreenPlay:start()
	local pBazaarBot = getCreatureObject(self.BazaarBotID)
	
	if (pBazaarBot == nil) then
		self:logFull("ERROR: BazaarBot character does not exist! Please create it on an ADMIN ACCOUNT and configure bin/screenplays/custom/bazaarbot/BazaarBotScreenPlay.lua to use the system.")
		return
	end

	self:validateEvent("BazaarBotAddArmor", "addMoreArmor", 10000)
	self:validateEvent("BazaarBotAddClothing", "addMoreClothing", 20000)
	self:validateEvent("BazaarBotAddFood", "addMoreFood", 30000)
	self:validateEvent("BazaarBotAddFurniture", "addMoreFurniture", 40000)
	self:validateEvent("BazaarBotAddArtisanItems", "addMoreArtisanItems", 50000)
	self:validateEvent("BazaarBotAddMedicine", "addMoreMedicine", 60000)
	self:validateEvent("BazaarBotAddStructures", "addMoreStructures", 70000)
	self:validateEvent("BazaarBotAddVehicles", "addMoreVehicles", 80000)
	self:validateEvent("BazaarBotAddWeapons", "addMoreWeapons", 90000)

	self:validateEvent("BazaarBotAddLoot", "addMoreLoot", 100000)
	
	-- Schedule inventory purging
	if (hasServerEvent("BazaarBotCleanInventory")) then
		rescheduleServerEvent("BazaarBotCleanInventory", 180 * 1000)
	else
		createServerEvent(180 * 1000, "BazaarBotScreenPlay", "checkInventory", "BazaarBotCleanInventory")
	end
	-- end
end

function BazaarBotScreenPlay:validateEvent(eventName, functionName, freq)
	self:logTroubleshoot("Validating event for: " .. eventName)
	if (hasServerEvent(eventName)) then
		local eventID = getServerEventID(eventName)
		local timeLeft = getServerEventTimeLeft(eventID)
		self:logTroubleshoot(eventName .. " is active and time left is: " .. timeLeft)
		if (timeLeft < freq or timeLeft > 86400000) then
			self:logTroubleshoot("Rescheduling event for " .. eventName .. " for " .. freq / 1000 .. "s")
			rescheduleServerEvent(eventName, freq)
		end
	else
		self:logTroubleshoot("Event " .. eventName .. " is not active and we are creating event")
		createServerEvent(freq * 1000, "BazaarBotScreenPlay", functionName, eventName)
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

-- A full inventory will prevent the creation and listing of new items
function BazaarBotScreenPlay:checkInventory()
	local pBazaarBot = getCreatureObject(self.BazaarBotID)
	local pInventory = CreatureObject(pBazaarBot):getSlottedObject("inventory")
	if (pInventory == nil) then
		self:logTroubleshoot("checkInventory: pInventory is nil")
	end
	self:cleanInventory(pBazaarBot, pInventory)
end

function BazaarBotScreenPlay:cleanInventory(pBazaarBot, pInventory)
	self:logFull("BazaarBotScreenPlay: Cleaning my inventory. This may kick out an error message about a table not being in range, which you can ignone.")

	while (SceneObject(pInventory):getContainerObjectsSize() > 0) do
		local pItem = SceneObject(pInventory):getContainerObject(0)
		if (pItem == nil) then
			self:logTroubleshoot("cleanInventory: pItem is nil")
			return
		end

		SceneObject(pItem):destroyObjectFromDatabase()
		SceneObject(pItem):destroyObjectFromWorld()
	end
	if (not hasServerEvent("BazaarBotCleanInventory")) then
		createServerEvent(1 * 24 * 60 * 60 * 1000, "BazaarBotScreenPlay", "checkInventory", "BazaarBotCleanInventory")
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
	self:logFull("Scheduled " .. configTable.functionName .. " to run again in " .. tostring(configTable.freq) .. " seconds.")
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
											self:logFull("Craft: " .. configTable.functionName .. "() Failed: " .. template)
                    end
                end
            end
        end
    end
    self:checkInventory()
    self:logListing("Craft: " .. configTable.functionName .. "() OK")
end

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
		self:logFull("Error locating target inventory")
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
					local lootLevelFactor = (BBLootPriceRanges[indexGroup].minPrice) * (lootLevel / 300 + 1)
					if (indexGroup == 1 or indexGroup == 3 or indexGroup == 5) then
						lootLevelFactor = (BBLootPriceRanges[indexGroup].minPrice)
					end

					local price = getRandomNumber(lootLevelFactor, BBLootPriceRanges[indexGroup].maxPrice)

					local junkValue = TangibleObject(pItem):getJunkValue()

					if (junkValue > price) then
							price = junkValue * 2
					end

					bazaarBotListItem(pBazaarBot, pItem, pVendor, self.itemDescription, price)
					self:logListing("Loot: " .. SceneObject(pItem):getObjectName() .. " (" .. tostring(lootLevel) .. ") " .. tostring(price) .. "cr")
			else
					self:logFull("Loot: " .. lootName .. " (" ..tostring(lootLevel) .. ") failed")
			end
	end
	self:checkInventory()
end

registerScreenPlay("BazaarBotScreenPlay", true)
