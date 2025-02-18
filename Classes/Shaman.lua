local _, TRB = ...
local _, _, classIndexId = UnitClass("player")
if classIndexId == 7 then --Only do this if we're on a Shaman!
	TRB.Functions.Class = TRB.Functions.Class or {}
	TRB.Functions.Character:ResetSnapshotData()
	
	local barContainerFrame = TRB.Frames.barContainerFrame
	local resourceFrame = TRB.Frames.resourceFrame
	local castingFrame = TRB.Frames.castingFrame
	local passiveFrame = TRB.Frames.passiveFrame
	local barBorderFrame = TRB.Frames.barBorderFrame

	local targetsTimerFrame = TRB.Frames.targetsTimerFrame
	local timerFrame = TRB.Frames.timerFrame
	local combatFrame = TRB.Frames.combatFrame
	
	local interfaceSettingsFrame = TRB.Frames.interfaceSettingsFrameContainer
	Global_TwintopResourceBar = {}
	TRB.Data.character = {}
	
	local specCache = {
		elemental = {
			snapshot = {},
			barTextVariables = {
				icons = {},
				values = {}
			},
			spells = {},
			talents = {},
			settings = {
				bar = nil,
				comboPoints = nil,
				displayBar = nil,
				font = nil,
				textures = nil,
				thresholds = nil
			}
		},
		enhancement = {
			snapshot = {},
			barTextVariables = {
				icons = {},
				values = {}
			},
			spells = {},
			talents = {},
			settings = {
				bar = nil,
				comboPoints = nil,
				displayBar = nil,
				font = nil,
				textures = nil,
				thresholds = nil
			}
		},
		restoration = {
			snapshot = {},
			barTextVariables = {
				icons = {},
				values = {}
			},
			spells = {},
			talents = {},
			settings = {
				bar = nil,
				comboPoints = nil,
				displayBar = nil,
				font = nil,
				textures = nil,
				thresholds = nil
			}
		}
	}

	local function FillSpecializationCache()
		-- Elemental
		Global_TwintopResourceBar = {
			ttd = 0,
			resource = {
				resource = 0,
				casting = 0,
				passive = 0
			},
			dots = {
				fsCount = 0
			},
			chainLightning = {
				targetsHit = 0
			}
		}
		
		specCache.elemental.character = {
			guid = UnitGUID("player"),
---@diagnostic disable-next-line: missing-parameter
			specGroup = GetActiveSpecGroup(),
			maxResource = 100,
			earthShockThreshold = 60,
			earthquakeThreshold = 60,
			effects = {
			},
			items = {
			}
		}

		specCache.elemental.spells = {
			-- Shaman Class Baseline Abilities
			lightningBolt = {
				id = 188196,
				name = "",
				icon = "",
				maelstrom = 8,
				overload = 3,
				baseline = true,
				primalFracture = true
			},
			flameShock = {
				id = 188389,
				name = "",
				icon = "",
				baseDuration = 18,
				pandemic = true,
				pandemicTime = 18 * 0.3
			},

			-- Elemental Baseline Abilities


			-- Shaman Class Talent Abilities
			lavaBurst = {
				id = 51505,
				name = "",
				icon = "",
				maelstrom = 10,
				isTalent = true,
				baseline = true,
				primalFracture = true
			},
			chainLightning = {
				id = 188443,
				name = "",
				icon = "",
				maelstrom = 4,
				overload = 3,
				isTalent = true,
				baseline = true
			},
			frostShock = {
				id = 196840,
				name = "",
				icon = "",
				maelstrom = 14,
				isTalent = true,
				primalFracture = true
			},
			hex = {
				id = 51514,
				name = "",
				icon = "",
				maelstrom = 8,
				isTalent = true
			},


			-- Elemental Talent Abilities
			earthShock = {
				id = 8042,
				name = "",
				icon = "",
				maelstrom = -60,
				texture = "",
				thresholdId = 1,
				settingKey = "earthShock",
				thresholdUsable = false,
				isTalent = true,
				baseline = true,
				isSnowflake = true
			},
			earthquake = {
				id = 61882,
				name = "",
				icon = "",
				maelstrom = -60,
				texture = "",
				thresholdId = 2,
				settingKey = "earthquake",
				thresholdUsable = false,
				isTalent = true,
				isSnowflake = true
			},
			inundate = {
				id = 378776,
				name = "",
				icon = "",
				maelstrom = 8,
				isTalent = true
			},
			flowOfPower = {
				id = 385923,
				name = "",
				icon = "",
				maelstromMod = {
					base = {
						[0] = {
							lightningBolt = 0,
							lavaBurst = 0
						},
						[1] = {
							lightningBolt = 2,
							lavaBurst = 2
						}
					},
					overload = {
						[0] = {
							lightningBolt = 0,
							lavaBurst = 0
						},
						[1] = {
							lightningBolt = 1,
							lavaBurst = 1
						}
					}
				},
				isTalent = true
			},
			icefury = {
				id = 210714,
				name = "",
				icon = "",
				maelstrom = 25,
				overload = 12,
				stacks = 4,
				duration = 15,
				isTalent = true,
				primalFracture = true
			},
			stormkeeper = {
				id = 191634,
				name = "",
				icon = "",
				stacks = 2,
				duration = 15
			},
			surgeOfPower = {
				id = 285514,
				name = "",
				icon = "",
				isTalent = true
			},
			eyeOfTheStorm = {
				id = 381708,
				name = "",
				icon = "",
				maelstromMod = {
					[0] = {
						earthShock = 0,
						earthquake = 0,
						elementalBlast = 0
					},
					[1] = {
						earthShock = -5,
						earthquake = -5,
						elementalBlast = -7
					},
					[2] = {
						earthShock = -10,
						earthquake = -10,
						elementalBlast = -15
					}
				},
				isTalent = true
			},
			powerOfTheMaelstrom = {
				id = 191877,
				name = "",
				icon = "",
				isTalent = true
			},
			elementalBlast = {
				id = 117014,
				name = "",
				icon = "",
				maelstrom = -90,
				thresholdId = 3,
				settingKey = "elementalBlast",
				thresholdUsable = false,
				isTalent = true,
				isSnowflake = true
			},
			echoesOfGreatSundering = {
				id = 384088,
				name = "",
				icon = "",
				isTalent = true
			},
			ascendance = {
				id = 114050,
				name = "",
				icon = "",
				isTalent = true
			},
			lavaBeam = {
				id = 114074,
				name = "",
				icon = "",
				maelstrom = 4, --Tooltip says 3, but spell ID 217891 and in game says 4
				overload = 3
			},

			lightningShield = {
				id = 192106,
				name = "",
				icon = "",
				maelstrom = 5
			},

			--TODO: Add Searing Flames passive maelstrom

			primalFracture = { -- T30 4P
				id = 410018,
				name = "",
				icon = "",
				maelstromMod = 1.5
			}
		}
		
		specCache.elemental.snapshot.audio = {
			playedEsCue = false
		}
		specCache.elemental.snapshot.ascendance = {
			spellId = nil,
			duration = 0,
			endTime = nil,
			remainingTime = 0
		}
		specCache.elemental.snapshot.chainLightning = {
			targetsHit = 0,
			hitTime = nil,
			hasStruckTargets = false
		}
		specCache.elemental.snapshot.surgeOfPower = {
			isActive = false
		}
		specCache.elemental.snapshot.powerOfTheMaelstrom = {
			isActive = false
		}
		specCache.elemental.snapshot.icefury = {
			isActive = false,
			stacks = 0,
			startTime = nil,
			maelstrom = 0
		}
		specCache.elemental.snapshot.stormkeeper = {
			isActive = false,
			stacks = 0,
			duration = 0,
			endTime = nil,
			spell = nil
		}
		specCache.elemental.snapshot.echoesOfGreatSundering = {
			isActive = false,
			duration = 0,
			endTime = nil
		}
		specCache.elemental.snapshot.primalFracture = {
			isActive = false,
			duration = 0,
			endTime = nil
		}
		specCache.elemental.snapshot.targetData = {
			ttdIsActive = false,
			currentTargetGuid = nil,
			flameShock = 0,
			targets = {}
		}

		-- Enhancement
		specCache.enhancement.Global_TwintopResourceBar = {
			ttd = 0,
			resource = {
				resource = 0,
				casting = 0,
				passive = 0,
				regen = 0
			},
			dots = {
			},
			isPvp = false
		}

		specCache.enhancement.character = {
			guid = UnitGUID("player"),
		---@diagnostic disable-next-line: missing-parameter
			specGroup = GetActiveSpecGroup(),
			specId = 1,
			maxResource = 10000,
			maxResource2 = 10,
			effects = {
			},
			items = {}
		}

		specCache.enhancement.spells = {
			-- Shaman Class Baseline Abilities
			flameShock = {
				id = 188389,
				name = "",
				icon = "",
				baseDuration = 18,
				pandemic = true,
				pandemicTime = 18 * 0.3
			},

			-- Enhancement Spec Baseline Abilities

			-- Shaman Class Talents
			
			-- Enhancement Spec Talent Abilities
			ascendance = {
				id = 114051,
				name = "",
				icon = "",
				isTalent = true
			},

		}

		specCache.enhancement.snapshot.manaRegen = 0
		specCache.enhancement.snapshot.audio = {
		}
		specCache.enhancement.snapshot.targetData = {
			ttdIsActive = false,
			currentTargetGuid = nil,
			targets = {},
		}
		specCache.enhancement.snapshot.ascendance = {
			spellId = nil,
			duration = 0,
			endTime = nil,
			remainingTime = 0
		}

		specCache.enhancement.barTextVariables = {
			icons = {},
			values = {}
		}

		
		-- Restoration
		specCache.restoration.Global_TwintopResourceBar = {
			ttd = 0,
			resource = {
				resource = 0,
				casting = 0,
				passive = 0
			},
			dots = {
				--swpCount = 0
			},
		}

		specCache.restoration.character = {
			guid = UnitGUID("player"),
---@diagnostic disable-next-line: missing-parameter
			specGroup = GetActiveSpecGroup(),
			maxResource = 100,
			effects = {
			},
			items = {
				potions = {
					aeratedManaPotionRank3 = {
						id = 191386,
						mana = 27600
					},
					aeratedManaPotionRank2 = {
						id = 191385,
						mana = 24000
					},
					aeratedManaPotionRank1 = {
						id = 191384,
						mana = 20869
					},
					potionOfFrozenFocusRank3 = {
						id = 191365,
						mana = 48300
					},
					potionOfFrozenFocusRank2 = {
						id = 191364,
						mana = 42000
					},
					potionOfFrozenFocusRank1 = {
						id = 191363,
						mana = 36521
					},
				},
				conjuredChillglobe = {
					id = 194300,
					isEquipped = false,
					equippedVersion = "lfr",
					manaThresholdPercent = 0.65,
					lfr = {
						bonusId = 7982,
						mana = 10877
					},
					normal = {
						bonusId = 7979,
						mana = 11735
					},
					heroic = {
						bonusId = 7980,
						mana = 14430
					},
					mythic = {
						bonusId = 7981,
						mana = 17625
					}
				},
				alchemyStone = false
			}
		}

		specCache.restoration.spells = {
			manaTideTotem = {
				id = 320763,
				name = "",
				icon = "",
				duration = 8
			},

			flameShock = {
				id = 188389,
				name = "",
				icon = "",
				baseDuration = 18,
				pandemic = true,
				pandemicTime = 18 * 0.3
			},
			ascendance = {
				id = 114052,
				name = "",
				icon = "",
				isTalent = true
			},

			-- External mana
			symbolOfHope = {
				id = 64901,
				name = "",
				icon = "",
				duration = 4.0, --Hasted
				manaPercent = 0.03,
				ticks = 3,
				tickId = 265144
			},
			innervate = {
				id = 29166,
				name = "",
				icon = "",
				duration = 10
			},

			-- Potions
			aeratedManaPotionRank1 = {
				itemId = 191384,
				spellId = 370607,
				name = "",
				icon = "",
				useSpellIcon = true,
				texture = "",
				thresholdId = 1,
				settingKey = "aeratedManaPotionRank1",
				thresholdUsable = false
			},
			aeratedManaPotionRank2 = {
				itemId = 191385,
				spellId = 370607,
				name = "",
				icon = "",
				useSpellIcon = true,
				texture = "",
				thresholdId = 2,
				settingKey = "aeratedManaPotionRank2",
				thresholdUsable = false
			},
			aeratedManaPotionRank3 = {
				itemId = 191386,
				spellId = 370607,
				name = "",
				icon = "",
				useSpellIcon = true,
				texture = "",
				thresholdId = 3,
				settingKey = "aeratedManaPotionRank3",
				thresholdUsable = false
			},
			potionOfFrozenFocusRank1 = {
				itemId = 191363,
				spellId = 371033,
				name = "",
				icon = "",
				useSpellIcon = true,
				texture = "",
				thresholdId = 4,
				settingKey = "potionOfFrozenFocusRank1",
				thresholdUsable = false,
				mana = 3652,
				duration = 10,
				ticks = 10
			},
			potionOfFrozenFocusRank2 = {
				itemId = 191364,
				spellId = 371033,
				name = "",
				icon = "",
				useSpellIcon = true,
				texture = "",
				thresholdId = 5,
				settingKey = "potionOfFrozenFocusRank2",
				thresholdUsable = false,
				mana = 4200,
				duration = 10,
				ticks = 10
			},
			potionOfFrozenFocusRank3 = {
				itemId = 191365,
				spellId = 371033,
				name = "",
				icon = "",
				useSpellIcon = true,
				texture = "",
				thresholdId = 6,
				settingKey = "potionOfFrozenFocusRank3",
				thresholdUsable = false,
				mana = 4830,
				duration = 10,
				ticks = 10
			},
			potionOfChilledClarity = {
				id = 371052,
				name = "",
				icon = ""
			},

			-- Conjured Chillglobe
			conjuredChillglobe = {
				itemId = 194300,
				spellId = 396391,
				name = "",
				icon = "",
				useSpellIcon = true,
				texture = "",
				thresholdId = 7,
				settingKey = "conjuredChillglobe",
				thresholdUsable = false,
				mana = 4830,
				duration = 10,
				ticks = 10
			},

			-- Alchemist Stone
			alchemistStone = {
				id = 17619,
				name = "",
				icon = "",
				manaModifier = 1.4,
				itemIds = {
					171323,
					175941,
					175942,
					175943
				}
			},

			-- Rashok's Molten Heart
			moltenRadiance = {
				id = 409898,
				name = "",
				icon = "",
			}

		}

		specCache.restoration.snapshot.manaRegen = 0
		specCache.restoration.snapshot.audio = {
			innervateCue = false
		}
		specCache.restoration.snapshot.targetData = {
			ttdIsActive = false,
			currentTargetGuid = nil,
			flameShock = 0,
			targets = {}
		}
		specCache.restoration.snapshot.innervate = {
			isActive = false,
			spellId = nil,
			duration = 0,
			endTime = nil,
			remainingTime = 0,
			mana = 0,
			modifier = 1
		}
		specCache.restoration.snapshot.manaTideTotem = {
			isActive = false,
			spellId = nil,
			duration = 0,
			endTime = nil,
			remainingTime = 0,
			mana = 0
		}
		specCache.restoration.snapshot.symbolOfHope = {
			isActive = false,
			ticksRemaining = 0,
			tickRate = 0,
			tickRateFound = false,
			previousTickTime = nil,
			firstTickTime = nil, -- First time we saw a tick.
			endTime = nil,
			resourceRaw = 0,
			resourceFinal = 0
		}
		specCache.restoration.snapshot.channeledManaPotion = {
			isActive = false,
			ticksRemaining = 0,
			mana = 0,
			endTime = nil,
			lastTick = nil
		}
		specCache.restoration.snapshot.potion = {
			onCooldown = false,
			startTime = nil,
			duration = 0
		}
		specCache.restoration.snapshot.potionOfChilledClarity = {
			spellId = nil,
			duration = 0,
			endTime = nil,
			remainingTime = 0,
			mana = 0,
			modifier = 1
		}
		specCache.restoration.snapshot.conjuredChillglobe = {
			onCooldown = false,
			startTime = nil,
			duration = 0
		}
		specCache.restoration.snapshot.ascendance = {
			spellId = nil,
			duration = 0,
			endTime = nil,
			remainingTime = 0
		}
		specCache.restoration.snapshot.moltenRadiance = {
			spellId = nil,
			startTime = nil,
			duration = 0,
			manaPerTick = 0,
			mana = 0
		}

		specCache.restoration.barTextVariables = {
			icons = {},
			values = {}
		}
	end

	local function Setup_Elemental()
		if TRB.Data.character and TRB.Data.character.specId == GetSpecialization() then
			return
		end

		TRB.Functions.Character:FillSpecializationCacheSettings(TRB.Data.settings, specCache, "shaman", "elemental")
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.elemental)
	end

	local function Setup_Enhancement()
		if TRB.Data.character and TRB.Data.character.specId == GetSpecialization() then
			return
		end

		TRB.Functions.Character:FillSpecializationCacheSettings(TRB.Data.settings, specCache, "shaman", "enhancement")
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.enhancement)
	end

	local function Setup_Restoration()
		if TRB.Data.character and TRB.Data.character.specId == GetSpecialization() then
			return
		end

		TRB.Functions.Character:FillSpecializationCacheSettings(TRB.Data.settings, specCache, "shaman", "restoration")
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.restoration)
	end

	local function FillSpellData_Elemental()
		Setup_Elemental()
		local spells = TRB.Functions.Spell:FillSpellData(specCache.elemental.spells)

		-- This is done here so that we can get icons for the options menu!
		specCache.elemental.barTextVariables.icons = {
			{ variable = "#casting", icon = "", description = "The icon of the Maelstrom generating spell you are currently hardcasting", printInSettings = true },
			{ variable = "#item_ITEMID_", icon = "", description = "Any item's icon available via its item ID (e.g.: #item_18609_).", printInSettings = true },
			{ variable = "#spell_SPELLID_", icon = "", description = "Any spell's icon available via its spell ID (e.g.: #spell_2691_).", printInSettings = true },

			{ variable = "#ascendance", icon = spells.ascendance.icon, description = spells.ascendance.name, printInSettings = true },
			{ variable = "#chainLightning", icon = spells.chainLightning.icon, description = spells.chainLightning.name, printInSettings = true },
			{ variable = "#elementalBlast", icon = spells.elementalBlast.icon, description = spells.elementalBlast.name, printInSettings = true },
			{ variable = "#eogs", icon = spells.echoesOfGreatSundering.icon, description = spells.echoesOfGreatSundering.name, printInSettings = true },
			{ variable = "#flameShock", icon = spells.flameShock.icon, description = spells.flameShock.name, printInSettings = true },
			{ variable = "#frostShock", icon = spells.frostShock.icon, description = spells.frostShock.name, printInSettings = true },
			{ variable = "#icefury", icon = spells.icefury.icon, description = spells.icefury.name, printInSettings = true },
			{ variable = "#lavaBeam", icon = spells.lavaBeam.icon, description = spells.lavaBeam.name, printInSettings = true },
			{ variable = "#lavaBurst", icon = spells.lavaBurst.icon, description = spells.lavaBurst.name, printInSettings = true },
			{ variable = "#lightningBolt", icon = spells.lightningBolt.icon, description = spells.lightningBolt.name, printInSettings = true },
			{ variable = "#lightningShield", icon = spells.lightningShield.icon, description = spells.lightningShield.name, printInSettings = true },
			{ variable = "#primalFracture", icon = spells.primalFracture.icon, description = spells.primalFracture.name, printInSettings = true },
			{ variable = "#stormkeeper", icon = spells.stormkeeper.icon, description = spells.stormkeeper.name, printInSettings = true },
		}
		specCache.elemental.barTextVariables.values = {
			{ variable = "$gcd", description = "Current GCD, in seconds", printInSettings = true, color = false },
			{ variable = "$haste", description = "Current Haste %", printInSettings = true, color = false },
			{ variable = "$hastePercent", description = "Current Haste %", printInSettings = false, color = false },
			{ variable = "$hasteRating", description = "Current Haste rating", printInSettings = true, color = false },
			{ variable = "$crit", description = "Current Critical Strike %", printInSettings = true, color = false },
			{ variable = "$critPercent", description = "Current Critical Strike %", printInSettings = false, color = false },
			{ variable = "$critRating", description = "Current Critical Strike rating", printInSettings = true, color = false },
			{ variable = "$mastery", description = "Current Mastery %", printInSettings = true, color = false },
			{ variable = "$masteryPercent", description = "Current Mastery %", printInSettings = false, color = false },
			{ variable = "$masteryRating", description = "Current Mastery rating", printInSettings = true, color = false },
			{ variable = "$vers", description = "Current Versatility % (damage increase/offensive)", printInSettings = true, color = false },
			{ variable = "$versPercent", description = "Current Versatility % (damage increase/offensive)", printInSettings = false, color = false },
			{ variable = "$versatility", description = "Current Versatility % (damage increase/offensive)", printInSettings = false, color = false },
			{ variable = "$oVers", description = "Current Versatility % (damage increase/offensive)", printInSettings = false, color = false },
			{ variable = "$oVersPercent", description = "Current Versatility % (damage increase/offensive)", printInSettings = false, color = false },
			{ variable = "$dVers", description = "Current Versatility % (damage reduction/defensive)", printInSettings = true, color = false },
			{ variable = "$dVersPercent", description = "Current Versatility % (damage reduction/defensive)", printInSettings = false, color = false },
			{ variable = "$versRating", description = "Current Versatility rating", printInSettings = true, color = false },
			{ variable = "$versatilityRating", description = "Current Versatility rating", printInSettings = false, color = false },

			{ variable = "$int", description = "Current Intellect", printInSettings = true, color = false },
			{ variable = "$intellect", description = "Current Intellect", printInSettings = false, color = false },
			{ variable = "$agi", description = "Current Agility", printInSettings = true, color = false },
			{ variable = "$agility", description = "Current Agility", printInSettings = false, color = false },
			{ variable = "$str", description = "Current Strength", printInSettings = true, color = false },
			{ variable = "$strength", description = "Current Strength", printInSettings = false, color = false },
			{ variable = "$stam", description = "Current Stamina", printInSettings = true, color = false },
			{ variable = "$stamina", description = "Current Stamina", printInSettings = false, color = false },
			
			{ variable = "$inCombat", description = "Are you currently in combat? LOGIC VARIABLE ONLY!", printInSettings = true, color = false },

			{ variable = "$maelstrom", description = "Current Maelstrom", printInSettings = true, color = false },
			{ variable = "$resource", description = "Current Maelstrom", printInSettings = false, color = false },
			{ variable = "$maelstromMax", description = "Maximum Maelstrom", printInSettings = true, color = false },
			{ variable = "$resourceMax", description = "Maximum Maelstrom", printInSettings = false, color = false },
			{ variable = "$casting", description = "Maelstrom from Hardcasting Spells", printInSettings = true, color = false },
			{ variable = "$passive", description = "Maelstrom from Passive Sources", printInSettings = true, color = false },
			{ variable = "$maelstromPlusCasting", description = "Current + Casting Maelstrom Total", printInSettings = true, color = false },
			{ variable = "$resourcePlusCasting", description = "Current + Casting Maelstrom Total", printInSettings = false, color = false },
			{ variable = "$maelstromPlusPassive", description = "Current + Passive Maelstrom Total", printInSettings = true, color = false },
			{ variable = "$resourcePlusPassive", description = "Current + Passive Maelstrom Total", printInSettings = false, color = false },
			{ variable = "$maelstromTotal", description = "Current + Passive + Casting Maelstrom Total", printInSettings = true, color = false },   
			{ variable = "$resourceTotal", description = "Current + Passive + Casting Maelstrom Total", printInSettings = false, color = false },   

			{ variable = "$fsCount", description = "Number of Flame Shocks active on targets", printInSettings = true, color = false },
			{ variable = "$fsTime", description = "Time remaining on Flame Shock on your current target", printInSettings = true, color = false },

			{ variable = "$ifStacks", description = "Number of Icefury Frost Shock stacks remaining", printInSettings = true, color = false },
			{ variable = "$ifMaelstrom", description = "Total Maelstrom from available Icefury Frost Shock stacks", printInSettings = true, color = false },
			{ variable = "$ifTime", description = "Time remaining on Icefury buff", printInSettings = true, color = false },

			{ variable = "$skStacks", description = "Number of Stormkeeper stacks remaining", printInSettings = true, color = false },
			{ variable = "$skTime", description = "Time remaining on Stormkeeper buff", printInSettings = true, color = false },

			{ variable = "$ascendanceTime", description = "Duration remaining of Ascendance", printInSettings = true, color = false },

			{ variable = "$eogsTime", description = "Time remaining on Echoes of Great Sundering buff", printInSettings = true, color = false },

			{ variable = "$pfTime", description = "Time remaining on Primal Fracture (T30 4P) buff", printInSettings = true, color = false },

			{ variable = "$ttd", description = "Time To Die of current target in MM:SS format", printInSettings = true, color = true },
			{ variable = "$ttdSeconds", description = "Time To Die of current target in seconds", printInSettings = true, color = true }
		}
		
		specCache.elemental.spells = spells
	end

	local function FillSpellData_Enhancement()
		Setup_Enhancement()
		local spells = TRB.Functions.Spell:FillSpellData(specCache.enhancement.spells)

		-- This is done here so that we can get icons for the options menu!
		specCache.enhancement.barTextVariables.icons = {
			{ variable = "#casting", icon = "", description = "The icon of the Mana generating spell you are currently hardcasting", printInSettings = true },
			{ variable = "#item_ITEMID_", icon = "", description = "Any item's icon available via its item ID (e.g.: #item_18609_).", printInSettings = true },
			{ variable = "#spell_SPELLID_", icon = "", description = "Any spell's icon available via its spell ID (e.g.: #spell_2691_).", printInSettings = true },
			
			{ variable = "#ascendance", icon = spells.ascendance.icon, description = spells.ascendance.name, printInSettings = true },
			{ variable = "#flameShock", icon = spells.flameShock.icon, description = spells.flameShock.name, printInSettings = true },
		}
		specCache.enhancement.barTextVariables.values = {
			{ variable = "$gcd", description = "Current GCD, in seconds", printInSettings = true, color = false },
			{ variable = "$haste", description = "Current Haste %", printInSettings = true, color = false },
			{ variable = "$hastePercent", description = "Current Haste %", printInSettings = false, color = false },
			{ variable = "$hasteRating", description = "Current Haste rating", printInSettings = true, color = false },
			{ variable = "$crit", description = "Current Critical Strike %", printInSettings = true, color = false },
			{ variable = "$critPercent", description = "Current Critical Strike %", printInSettings = false, color = false },
			{ variable = "$critRating", description = "Current Critical Strike rating", printInSettings = true, color = false },
			{ variable = "$mastery", description = "Current Mastery %", printInSettings = true, color = false },
			{ variable = "$masteryPercent", description = "Current Mastery %", printInSettings = false, color = false },
			{ variable = "$masteryRating", description = "Current Mastery rating", printInSettings = true, color = false },
			{ variable = "$vers", description = "Current Versatility % (damage increase/offensive)", printInSettings = true, color = false },
			{ variable = "$versPercent", description = "Current Versatility % (damage increase/offensive)", printInSettings = false, color = false },
			{ variable = "$versatility", description = "Current Versatility % (damage increase/offensive)", printInSettings = false, color = false },
			{ variable = "$oVers", description = "Current Versatility % (damage increase/offensive)", printInSettings = false, color = false },
			{ variable = "$oVersPercent", description = "Current Versatility % (damage increase/offensive)", printInSettings = false, color = false },
			{ variable = "$dVers", description = "Current Versatility % (damage reduction/defensive)", printInSettings = true, color = false },
			{ variable = "$dVersPercent", description = "Current Versatility % (damage reduction/defensive)", printInSettings = false, color = false },
			{ variable = "$versRating", description = "Current Versatility rating", printInSettings = true, color = false },
			{ variable = "$versatilityRating", description = "Current Versatility rating", printInSettings = false, color = false },

			{ variable = "$int", description = "Current Intellect", printInSettings = true, color = false },
			{ variable = "$intellect", description = "Current Intellect", printInSettings = false, color = false },
			{ variable = "$agi", description = "Current Agility", printInSettings = true, color = false },
			{ variable = "$agility", description = "Current Agility", printInSettings = false, color = false },
			{ variable = "$str", description = "Current Strength", printInSettings = true, color = false },
			{ variable = "$strength", description = "Current Strength", printInSettings = false, color = false },
			{ variable = "$stam", description = "Current Stamina", printInSettings = true, color = false },
			{ variable = "$stamina", description = "Current Stamina", printInSettings = false, color = false },
			
			{ variable = "$inCombat", description = "Are you currently in combat? LOGIC VARIABLE ONLY!", printInSettings = true, color = false },

			{ variable = "$mana", description = "Current Mana", printInSettings = true, color = false },
			{ variable = "$resource", description = "Current Mana", printInSettings = false, color = false },
			{ variable = "$manaMax", description = "Maximum Mana", printInSettings = true, color = false },
			{ variable = "$resourceMax", description = "Maximum Mana", printInSettings = false, color = false },
			
			{ variable = "$maelstromWeapon", description = "Current Maelstrom Weapon", printInSettings = true, color = false },
			{ variable = "$comboPoints", description = "Current Maelstrom Weapon", printInSettings = false, color = false },
			{ variable = "$maelstromWeaponMax", description = "Maximum Maelstrom Weapon", printInSettings = true, color = false },
			{ variable = "$comboPointsMax", description = "Maximum Maelstrom Weapon", printInSettings = false, color = false },

			{ variable = "$ascendanceTime", description = "Duration remaining of Ascendance", printInSettings = true, color = false },

			{ variable = "$fsCount", description = "Number of Flame Shocks active on targets", printInSettings = true, color = false },
			{ variable = "$fsTime", description = "Time remaining on Flame Shock on your current target", printInSettings = true, color = false },
			
			{ variable = "$ttd", description = "Time To Die of current target in MM:SS format", printInSettings = true, color = true },
			{ variable = "$ttdSeconds", description = "Time To Die of current target in seconds", printInSettings = true, color = true }
		}

		specCache.enhancement.spells = spells
	end

	local function FillSpellData_Restoration()
		Setup_Restoration()
		local spells = TRB.Functions.Spell:FillSpellData(specCache.restoration.spells)

		-- This is done here so that we can get icons for the options menu!
		specCache.restoration.barTextVariables.icons = {
			{ variable = "#casting", icon = "", description = "The icon of the mana spending spell you are currently casting", printInSettings = true },
			{ variable = "#item_ITEMID_", icon = "", description = "Any item's icon available via its item ID (e.g.: #item_18609_).", printInSettings = true },
			{ variable = "#spell_SPELLID_", icon = "", description = "Any spell's icon available via its spell ID (e.g.: #spell_2691_).", printInSettings = true },
			
			{ variable = "#ascendance", icon = spells.ascendance.icon, description = spells.ascendance.name, printInSettings = true },
			{ variable = "#mtt", icon = spells.manaTideTotem.icon, description = spells.manaTideTotem.name, printInSettings = true },
			{ variable = "#manaTideTotem", icon = spells.manaTideTotem.icon, description = spells.manaTideTotem.name, printInSettings = false },

			{ variable = "#mr", icon = spells.moltenRadiance.icon, description = spells.moltenRadiance.name, printInSettings = true },
			{ variable = "#moltenRadiance", icon = spells.moltenRadiance.icon, description = spells.moltenRadiance.name, printInSettings = false },

			{ variable = "#soh", icon = spells.symbolOfHope.icon, description = spells.symbolOfHope.name, printInSettings = true },
			{ variable = "#symbolOfHope", icon = spells.symbolOfHope.icon, description = spells.symbolOfHope.name, printInSettings = false },

			{ variable = "#amp", icon = spells.aeratedManaPotionRank1.icon, description = spells.aeratedManaPotionRank1.name, printInSettings = true },
			{ variable = "#aeratedManaPotion", icon = spells.aeratedManaPotionRank1.icon, description = spells.aeratedManaPotionRank1.name, printInSettings = false },
			{ variable = "#pocc", icon = spells.potionOfChilledClarity.icon, description = spells.potionOfChilledClarity.name, printInSettings = true },
			{ variable = "#potionOfChilledClarity", icon = spells.potionOfChilledClarity.icon, description = spells.potionOfChilledClarity.name, printInSettings = false },
			{ variable = "#poff", icon = spells.potionOfFrozenFocusRank1.icon, description = spells.potionOfFrozenFocusRank1.name, printInSettings = true },
			{ variable = "#potionOfFrozenFocus", icon = spells.potionOfFrozenFocusRank1.icon, description = spells.potionOfFrozenFocusRank1.name, printInSettings = false },
			{ variable = "#flameShock", icon = spells.flameShock.icon, description = spells.flameShock.name, printInSettings = true },
		}
		specCache.restoration.barTextVariables.values = {
			{ variable = "$gcd", description = "Current GCD, in seconds", printInSettings = true, color = false },
			{ variable = "$haste", description = "Current Haste %", printInSettings = true, color = false },
			{ variable = "$hastePercent", description = "Current Haste %", printInSettings = false, color = false },
			{ variable = "$hasteRating", description = "Current Haste rating", printInSettings = true, color = false },
			{ variable = "$crit", description = "Current Critical Strike %", printInSettings = true, color = false },
			{ variable = "$critPercent", description = "Current Critical Strike %", printInSettings = false, color = false },
			{ variable = "$critRating", description = "Current Critical Strike rating", printInSettings = true, color = false },
			{ variable = "$mastery", description = "Current Mastery %", printInSettings = true, color = false },
			{ variable = "$masteryPercent", description = "Current Mastery %", printInSettings = false, color = false },
			{ variable = "$masteryRating", description = "Current Mastery rating", printInSettings = true, color = false },
			{ variable = "$vers", description = "Current Versatility % (damage increase/offensive)", printInSettings = true, color = false },
			{ variable = "$versPercent", description = "Current Versatility % (damage increase/offensive)", printInSettings = false, color = false },
			{ variable = "$versatility", description = "Current Versatility % (damage increase/offensive)", printInSettings = false, color = false },
			{ variable = "$oVers", description = "Current Versatility % (damage increase/offensive)", printInSettings = false, color = false },
			{ variable = "$oVersPercent", description = "Current Versatility % (damage increase/offensive)", printInSettings = false, color = false },
			{ variable = "$dVers", description = "Current Versatility % (damage reduction/defensive)", printInSettings = true, color = false },
			{ variable = "$dVersPercent", description = "Current Versatility % (damage reduction/defensive)", printInSettings = false, color = false },
			{ variable = "$versRating", description = "Current Versatility rating", printInSettings = true, color = false },
			{ variable = "$versatilityRating", description = "Current Versatility rating", printInSettings = false, color = false },

			{ variable = "$int", description = "Current Intellect", printInSettings = true, color = false },
			{ variable = "$intellect", description = "Current Intellect", printInSettings = false, color = false },
			{ variable = "$agi", description = "Current Agility", printInSettings = true, color = false },
			{ variable = "$agility", description = "Current Agility", printInSettings = false, color = false },
			{ variable = "$str", description = "Current Strength", printInSettings = true, color = false },
			{ variable = "$strength", description = "Current Strength", printInSettings = false, color = false },
			{ variable = "$stam", description = "Current Stamina", printInSettings = true, color = false },
			{ variable = "$stamina", description = "Current Stamina", printInSettings = false, color = false },
			
			{ variable = "$inCombat", description = "Are you currently in combat? LOGIC VARIABLE ONLY!", printInSettings = true, color = false },

			{ variable = "$mana", description = "Current Mana", printInSettings = true, color = false },
			{ variable = "$resource", description = "Current Mana", printInSettings = false, color = false },
			{ variable = "$manaPercent", description = "Current Mana Percentage", printInSettings = true, color = false },
			{ variable = "$resourcePercent", description = "Current Mana Percentage", printInSettings = false, color = false },
			{ variable = "$manaMax", description = "Maximum Mana", printInSettings = true, color = false },
			{ variable = "$resourceMax", description = "Maximum Mana", printInSettings = false, color = false },
			{ variable = "$casting", description = "Mana from Hardcasting Spells", printInSettings = true, color = false },
			{ variable = "$passive", description = "Mana from Passive Sources", printInSettings = true, color = false },
			{ variable = "$manaPlusCasting", description = "Current + Casting Mana Total", printInSettings = true, color = false },
			{ variable = "$resourcePlusCasting", description = "Current + Casting Mana Total", printInSettings = false, color = false },
			{ variable = "$manaPlusPassive", description = "Current + Passive Mana Total", printInSettings = true, color = false },
			{ variable = "$resourcePlusPassive", description = "Current + Passive Mana Total", printInSettings = false, color = false },
			{ variable = "$manaTotal", description = "Current + Passive + Casting Mana Total", printInSettings = true, color = false },
			{ variable = "$resourceTotal", description = "Current + Passive + Casting Mana Total", printInSettings = false, color = false },

			{ variable = "$sohMana", description = "Mana from Symbol of Hope", printInSettings = true, color = false },
			{ variable = "$sohTime", description = "Time left on Symbol of Hope", printInSettings = true, color = false },
			{ variable = "$sohTicks", description = "Number of ticks left from Symbol of Hope", printInSettings = true, color = false },

			{ variable = "$innervateMana", description = "Passive mana regen while Innervate is active", printInSettings = true, color = false },
			{ variable = "$innervateTime", description = "Time left on Innervate", printInSettings = true, color = false },
									
			{ variable = "$mrMana", description = "Mana from Molten Radiance", printInSettings = true, color = false },
			{ variable = "$mrTime", description = "Time left on Molten Radiance", printInSettings = true, color = false },

			{ variable = "$mttMana", description = "Bonus passive mana regen while Mana Tide Totem is active", printInSettings = true, color = false },
			{ variable = "$mttTime", description = "Time left on Mana Tide Totem", printInSettings = true, color = false },
			
			{ variable = "$channeledMana", description = "Mana while channeling of Potion of Frozen Focus", printInSettings = true, color = false },

			{ variable = "$potionOfChilledClarityMana", description = "Passive mana regen while Potion of Chilled Clarity's effect is active", printInSettings = true, color = false },
			{ variable = "$potionOfChilledClarityTime", description = "Time left on Potion of Chilled Clarity's effect", printInSettings = true, color = false },

			{ variable = "$potionOfFrozenFocusTicks", description = "Number of ticks left channeling Potion of Frozen Focus", printInSettings = true, color = false },
			{ variable = "$potionOfFrozenFocusTime", description = "Amount of time, in seconds, remaining of your channel of Potion of Frozen Focus", printInSettings = true, color = false },
			
			{ variable = "$potionCooldown", description = "How long, in seconds, is left on your potion's cooldown in MM:SS format", printInSettings = true, color = false },
			{ variable = "$potionCooldownSeconds", description = "How long, in seconds, is left on your potion's cooldown in seconds", printInSettings = true, color = false },

			{ variable = "$fsCount", description = "Number of Flame Shocks active on targets", printInSettings = true, color = false },
			{ variable = "$fsTime", description = "Time remaining on Flame Shock on your current target", printInSettings = true, color = false },
			
			{ variable = "$ascendanceTime", description = "Duration remaining of Ascendance", printInSettings = true, color = false },

			{ variable = "$ttd", description = "Time To Die of current target in MM:SS format", printInSettings = true, color = true },
			{ variable = "$ttdSeconds", description = "Time To Die of current target in seconds", printInSettings = true, color = true }
		}

		specCache.restoration.spells = spells
	end

	local function RefreshTargetTracking()
		local currentTime = GetTime()
		local specId = GetSpecialization()

		if specId == 1 then
			local fsTotal = 0
			for guid,count in pairs(TRB.Data.snapshot.targetData.targets) do
				if (currentTime - TRB.Data.snapshot.targetData.targets[guid].lastUpdate) > 10 then
					TRB.Data.snapshot.targetData.targets[guid].flameShock = false
					TRB.Data.snapshot.targetData.targets[guid].flameShockRemaining = 0
				else
					if TRB.Data.snapshot.targetData.targets[guid].flameShock == true then
						fsTotal = fsTotal + 1
					end
				end
			end
			TRB.Data.snapshot.targetData.flameShock = fsTotal
		elseif specId == 2 then -- Enhancement
			local fsTotal = 0
			for guid,count in pairs(TRB.Data.snapshot.targetData.targets) do
				if (currentTime - TRB.Data.snapshot.targetData.targets[guid].lastUpdate) > 10 then
					TRB.Data.snapshot.targetData.targets[guid].flameShock = false
					TRB.Data.snapshot.targetData.targets[guid].flameShockRemaining = 0
				else
					if TRB.Data.snapshot.targetData.targets[guid].flameShock == true then
						fsTotal = fsTotal + 1
					end
				end
			end

			TRB.Data.snapshot.targetData.flameShock = fsTotal
		elseif specId == 3 then -- Restoration
			local fsTotal = 0
			for guid,count in pairs(TRB.Data.snapshot.targetData.targets) do
				if (currentTime - TRB.Data.snapshot.targetData.targets[guid].lastUpdate) > 10 then
					TRB.Data.snapshot.targetData.targets[guid].flameShock = false
					TRB.Data.snapshot.targetData.targets[guid].flameShockRemaining = 0
				else
					if TRB.Data.snapshot.targetData.targets[guid].flameShock == true then
						fsTotal = fsTotal + 1
					end
				end
			end

			TRB.Data.snapshot.targetData.flameShock = fsTotal
		end
	end

	local function TargetsCleanup(clearAll)
		TRB.Functions.Target:TargetsCleanup(clearAll)
		local specId = GetSpecialization()

		if specId == 1 then
			if clearAll == true then
				TRB.Data.snapshot.targetData.flameShock = 0
			end
		elseif specId == 2 then
		elseif specId == 3 then
			if clearAll == true then
				TRB.Data.snapshot.targetData.flameShock = 0
			end
		end
	end

	local function ConstructResourceBar(settings)
		local specId = GetSpecialization()
		local entries = TRB.Functions.Table:Length(resourceFrame.thresholds)
		if entries > 0 then
			for x = 1, entries do
				resourceFrame.thresholds[x]:Hide()
			end
		end
		
		local entriesPassive = TRB.Functions.Table:Length(passiveFrame.thresholds)
		if entriesPassive > 0 then
			for x = 1, entriesPassive do
				passiveFrame.thresholds[x]:Hide()
			end
		end

		if specId == 1 then
			for k, v in pairs(TRB.Data.spells) do
				local spell = TRB.Data.spells[k]
				if spell ~= nil and spell.id ~= nil and spell.maelstrom ~= nil and spell.maelstrom < 0 and spell.thresholdId ~= nil and spell.settingKey ~= nil then
					if TRB.Frames.resourceFrame.thresholds[spell.thresholdId] == nil then
						TRB.Frames.resourceFrame.thresholds[spell.thresholdId] = CreateFrame("Frame", nil, TRB.Frames.resourceFrame)
					end
					TRB.Functions.Threshold:ResetThresholdLine(TRB.Frames.resourceFrame.thresholds[spell.thresholdId], settings, true)
					TRB.Functions.Threshold:SetThresholdIcon(TRB.Frames.resourceFrame.thresholds[spell.thresholdId], spell.settingKey, settings)
	
					TRB.Frames.resourceFrame.thresholds[spell.thresholdId]:Show()
					TRB.Frames.resourceFrame.thresholds[spell.thresholdId]:SetFrameLevel(TRB.Data.constants.frameLevels.thresholdBase)
					TRB.Frames.resourceFrame.thresholds[spell.thresholdId]:Hide()
				end
			end
		elseif specId == 2 then
			for k, v in pairs(TRB.Data.spells) do
				local spell = TRB.Data.spells[k]
				if spell ~= nil and spell.id ~= nil and spell.maelstrom ~= nil and spell.maelstrom < 0 and spell.thresholdId ~= nil and spell.settingKey ~= nil then
					if TRB.Frames.resourceFrame.thresholds[spell.thresholdId] == nil then
						TRB.Frames.resourceFrame.thresholds[spell.thresholdId] = CreateFrame("Frame", nil, TRB.Frames.resourceFrame)
					end
					TRB.Functions.Threshold:ResetThresholdLine(TRB.Frames.resourceFrame.thresholds[spell.thresholdId], settings, true)
					TRB.Functions.Threshold:SetThresholdIcon(TRB.Frames.resourceFrame.thresholds[spell.thresholdId], spell.settingKey, settings)
	
					TRB.Frames.resourceFrame.thresholds[spell.thresholdId]:Show()
					TRB.Frames.resourceFrame.thresholds[spell.thresholdId]:SetFrameLevel(TRB.Data.constants.frameLevels.thresholdBase)
					TRB.Frames.resourceFrame.thresholds[spell.thresholdId]:Hide()
				end
			end
		elseif specId == 3 then
			for x = 1, 7 do
				if TRB.Frames.resourceFrame.thresholds[x] == nil then
					TRB.Frames.resourceFrame.thresholds[x] = CreateFrame("Frame", nil, TRB.Frames.resourceFrame)
				end

				TRB.Frames.resourceFrame.thresholds[x]:Show()
				TRB.Frames.resourceFrame.thresholds[x]:SetFrameLevel(TRB.Data.constants.frameLevels.thresholdBase)
				TRB.Frames.resourceFrame.thresholds[x]:Hide()
			end

			for x = 1, 5 do
				if TRB.Frames.passiveFrame.thresholds[x] == nil then
					TRB.Frames.passiveFrame.thresholds[x] = CreateFrame("Frame", nil, TRB.Frames.passiveFrame)
				end

				TRB.Frames.passiveFrame.thresholds[x]:Show()
				TRB.Frames.passiveFrame.thresholds[x]:SetFrameLevel(TRB.Data.constants.frameLevels.thresholdBase)
				TRB.Frames.passiveFrame.thresholds[x]:Hide()
			end
			
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[1], TRB.Data.spells.aeratedManaPotionRank1.settingKey, TRB.Data.settings.shaman.restoration)
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[2], TRB.Data.spells.aeratedManaPotionRank2.settingKey, TRB.Data.settings.shaman.restoration)
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[3], TRB.Data.spells.aeratedManaPotionRank3.settingKey, TRB.Data.settings.shaman.restoration)
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[4], TRB.Data.spells.potionOfFrozenFocusRank1.settingKey, TRB.Data.settings.shaman.restoration)
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[5], TRB.Data.spells.potionOfFrozenFocusRank2.settingKey, TRB.Data.settings.shaman.restoration)
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[6], TRB.Data.spells.potionOfFrozenFocusRank3.settingKey, TRB.Data.settings.shaman.restoration)
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[7], TRB.Data.spells.conjuredChillglobe.settingKey, TRB.Data.settings.shaman.restoration)
		end

		TRB.Functions.Bar:Construct(settings)

		if specId == 1 or
		(specId == 2 and TRB.Data.settings.core.experimental.specs.shaman.enhancement) or
		specId == 3 then
			TRB.Functions.Bar:SetPosition(settings, TRB.Frames.barContainerFrame)
		end
	end
	
	local function GetAscendanceRemainingTime()
		return TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshot.ascendance)
	end

	local function GetStormkeeperRemainingTime()
		return TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshot.stormkeeper)
	end
	
	local function GetEchoesOfGreatSunderingRemainingTime()
		return TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshot.echoesOfGreatSundering)
	end
	
	local function GetPrimalFractureRemainingTime()
		return TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshot.primalFracture)
	end
	
	
	local function GetIcefuryRemainingTime()
		return TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshot.icefury)
	end

	local function GetChanneledPotionRemainingTime()
		return TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshot.channeledManaPotion)
	end

	local function GetInnervateRemainingTime()
		return TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshot.innervate)
	end

	local function GetPotionOfChilledClarityRemainingTime()
		return TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshot.potionOfChilledClarity)
	end

	local function GetManaTideTotemRemainingTime()
		return TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshot.manaTideTotem)
	end

	local function GetMoltenRadianceRemainingTime()
		return TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshot.moltenRadiance)
	end

	local function GetSymbolOfHopeRemainingTime()
		return TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshot.symbolOfHope)
	end

	local function CalculateManaGain(mana, isPotion)
		if isPotion == nil then
			isPotion = false
		end

		local modifier = 1.0

		if isPotion then
			if TRB.Data.character.items.alchemyStone then
				modifier = modifier * TRB.Data.spells.alchemistStone.manaModifier
			end
		end

		return mana * modifier
	end

	local function RefreshLookupData_Elemental()
		--Spec specific implementation
		local currentTime = GetTime()

		--$overcap
		local overcap = TRB.Functions.Class:IsValidVariableForSpec("$overcap")

		local currentMaelstromColor = TRB.Data.settings.shaman.elemental.colors.text.currentMaelstrom
		local castingMaelstromColor = TRB.Data.settings.shaman.elemental.colors.text.castingMaelstrom

		local maelstromThreshold = TRB.Data.character.earthShockThreshold

		if TRB.Functions.Class:IsValidVariableForSpec("$inCombat") then
			if TRB.Data.settings.shaman.elemental.colors.text.overcapEnabled and overcap then 
				currentMaelstromColor = TRB.Data.settings.shaman.elemental.colors.text.overcapMaelstrom
				castingMaelstromColor = TRB.Data.settings.shaman.elemental.colors.text.overcapMaelstrom
			elseif TRB.Data.settings.shaman.elemental.colors.text.overThresholdEnabled and TRB.Data.snapshot.resource >= maelstromThreshold then
				currentMaelstromColor = TRB.Data.settings.shaman.elemental.colors.text.overThreshold
				castingMaelstromColor = TRB.Data.settings.shaman.elemental.colors.text.overThreshold
			end
		end

		--$maelstrom
		local currentMaelstrom = string.format("|c%s%.0f|r", currentMaelstromColor, TRB.Data.snapshot.resource)
		--$casting
		local castingMaelstrom = string.format("|c%s%.0f|r", castingMaelstromColor, TRB.Data.snapshot.casting.resourceFinal)
		--$passive
		local _passiveMaelstrom = 0

		local passiveMaelstrom = string.format("|c%s%.0f|r", TRB.Data.settings.shaman.elemental.colors.text.passiveMaelstrom, _passiveMaelstrom)
		--$maelstromTotal
		local _maelstromTotal = math.min(_passiveMaelstrom + TRB.Data.snapshot.casting.resourceFinal + TRB.Data.snapshot.resource, TRB.Data.character.maxResource)
		local maelstromTotal = string.format("|c%s%.0f|r", currentMaelstromColor, _maelstromTotal)
		--$maelstromPlusCasting
		local _maelstromPlusCasting = math.min(TRB.Data.snapshot.casting.resourceFinal + TRB.Data.snapshot.resource, TRB.Data.character.maxResource)
		local maelstromPlusCasting = string.format("|c%s%.0f|r", castingMaelstromColor, _maelstromPlusCasting)
		--$maelstromPlusPassive
		local _maelstromPlusPassive = math.min(_passiveMaelstrom + TRB.Data.snapshot.resource, TRB.Data.character.maxResource)
		local maelstromPlusPassive = string.format("|c%s%.0f|r", currentMaelstromColor, _maelstromPlusPassive)

		----------
		--$fsCount and $fsTime
		local _flameShockCount = TRB.Data.snapshot.targetData.flameShock or 0
		local flameShockCount = tostring(_flameShockCount)
		local _flameShockTime = 0
		
		if TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid] ~= nil then
			_flameShockTime = TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].flameShockRemaining or 0
		end

		local flameShockTime

		if TRB.Data.settings.shaman.elemental.colors.text.dots.enabled and TRB.Data.snapshot.targetData.currentTargetGuid ~= nil and not UnitIsDeadOrGhost("target") and UnitCanAttack("player", "target") then
			if TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid] ~= nil and TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].flameShock then
				if TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].flameShockRemaining > TRB.Data.spells.flameShock.pandemicTime then
					flameShockCount = string.format("|c%s%.0f|r", TRB.Data.settings.shaman.elemental.colors.text.dots.up, _flameShockCount)
					flameShockTime = string.format("|c%s%.1f|r", TRB.Data.settings.shaman.elemental.colors.text.dots.up, TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].flameShockRemaining)
				else
					flameShockCount = string.format("|c%s%.0f|r", TRB.Data.settings.shaman.elemental.colors.text.dots.pandemic, _flameShockCount)
					flameShockTime = string.format("|c%s%.1f|r", TRB.Data.settings.shaman.elemental.colors.text.dots.pandemic, TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].flameShockRemaining)
				end
			else
				flameShockCount = string.format("|c%s%.0f|r", TRB.Data.settings.shaman.elemental.colors.text.dots.down, _flameShockCount)
				flameShockTime = string.format("|c%s%.1f|r", TRB.Data.settings.shaman.elemental.colors.text.dots.down, 0)
			end
		else
			flameShockTime = string.format("%.1f", _flameShockTime)
		end

		----------
		--Icefury
		--$ifMaelstrom
		local icefuryMaelstrom = TRB.Data.snapshot.icefury.maelstrom or 0
		--$ifStacks
		local icefuryStacks = TRB.Data.snapshot.icefury.stacks or 0
		--$ifStacks
		local _icefuryTime = GetIcefuryRemainingTime()
		local icefuryTime = "0.0"
		if _icefuryTime > 0 then
			icefuryTime = string.format("%.1f", _icefuryTime)
		end

		--$skStacks
		local stormkeeperStacks = TRB.Data.snapshot.stormkeeper.stacks or 0
		--$skStacks
		local _stormkeeperTime = GetStormkeeperRemainingTime()
		local stormkeeperTime = "0.0"
		if stormkeeperStacks > 0 then
			stormkeeperTime = string.format("%.1f", _stormkeeperTime)
		end

		--$eogsTime
		local _eogsTime = GetEchoesOfGreatSunderingRemainingTime()

		local eogsTime = "0.0"
		if _eogsTime > 0 then
			eogsTime = string.format("%.1f", _eogsTime)
		end

		--$pfTime
		local _pfTime = GetPrimalFractureRemainingTime()

		local pfTime = "0.0"
		if _pfTime > 0 then
			pfTime = string.format("%.1f", _pfTime)
		end

		--$ascendanceTime
		local _ascendanceTime = TRB.Data.snapshot.ascendance.remainingTime
		local ascendanceTime = string.format("%.1f", _ascendanceTime)

		----------------------------

		Global_TwintopResourceBar.resource.passive = _passiveMaelstrom
		Global_TwintopResourceBar.resource.icefury = icefuryMaelstrom
		Global_TwintopResourceBar.dots = {
			fsCount = flameShockCount or 0,
		}
		Global_TwintopResourceBar.chainLightning = {
			targetsHit = TRB.Data.snapshot.chainLightning.targetsHit or 0
		}
		Global_TwintopResourceBar.icefury = {
			maelstrom = icefuryMaelstrom,
			stacks = icefuryStacks,
			remaining = icefuryTime
		}

		local lookup = TRB.Data.lookup or {}
		lookup["#ascendance"] = TRB.Data.spells.ascendance.icon
		lookup["#chainLightning"] = TRB.Data.spells.chainLightning.icon
		lookup["#elementalBlast"] = TRB.Data.spells.elementalBlast.icon
		lookup["#eogs"] = TRB.Data.spells.echoesOfGreatSundering.icon
		lookup["#flameShock"] = TRB.Data.spells.flameShock.icon
		lookup["#frostShock"] = TRB.Data.spells.frostShock.icon
		lookup["#icefury"] = TRB.Data.spells.icefury.icon
		lookup["#lavaBeam"] = TRB.Data.spells.lavaBeam.icon
		lookup["#lavaBurst"] = TRB.Data.spells.lavaBurst.icon
		lookup["#lightningBolt"] = TRB.Data.spells.lightningBolt.icon
		lookup["#lightningShield"] = TRB.Data.spells.lightningShield.icon
		lookup["#primalFracture"] = TRB.Data.spells.primalFracture.icon
		lookup["#stormkeeper"] = TRB.Data.spells.stormkeeper.icon
		lookup["$maelstromPlusCasting"] = maelstromPlusCasting
		lookup["$maelstromPlusPassive"] = maelstromPlusPassive
		lookup["$maelstromTotal"] = maelstromTotal
		lookup["$maelstromMax"] = TRB.Data.character.maxResource
		lookup["$maelstrom"] = currentMaelstrom
		lookup["$resourcePlusCasting"] = maelstromPlusCasting
		lookup["$resourcePlusPassive"] = maelstromPlusPassive
		lookup["$resourceTotal"] = maelstromTotal
		lookup["$resourceMax"] = TRB.Data.character.maxResource
		lookup["$resource"] = currentMaelstrom
		lookup["$casting"] = castingMaelstrom
		lookup["$passive"] = passiveMaelstrom
		lookup["$overcap"] = overcap
		lookup["$resourceOvercap"] = overcap
		lookup["$maelstromOvercap"] = overcap
		lookup["$ifMaelstrom"] = icefuryMaelstrom
		lookup["$ifStacks"] = icefuryStacks
		lookup["$ifTime"] = icefuryTime
		lookup["$skStacks"] = stormkeeperStacks
		lookup["$skTime"] = stormkeeperTime
		lookup["$eogsTime"] = eogsTime
		lookup["$fsCount"] = flameShockCount
		lookup["$fsTime"] = flameShockTime
		lookup["$ascendanceTime"] = ascendanceTime
		lookup["$pfTime"] = pfTime
		TRB.Data.lookup = lookup

		local lookupLogic = TRB.Data.lookupLogic or {}
		lookupLogic["$maelstromPlusCasting"] = _maelstromPlusCasting
		lookupLogic["$maelstromPlusPassive"] = _maelstromPlusPassive
		lookupLogic["$maelstromTotal"] = _maelstromTotal
		lookupLogic["$maelstromMax"] = TRB.Data.character.maxResource
		lookupLogic["$maelstrom"] = TRB.Data.snapshot.resource
		lookupLogic["$resourcePlusCasting"] = _maelstromPlusCasting
		lookupLogic["$resourcePlusPassive"] = _maelstromPlusPassive
		lookupLogic["$resourceTotal"] = _maelstromTotal
		lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
		lookupLogic["$resource"] = TRB.Data.snapshot.resource
		lookupLogic["$casting"] = TRB.Data.snapshot.casting.resourceFinal
		lookupLogic["$passive"] = _passiveMaelstrom
		lookupLogic["$overcap"] = overcap
		lookupLogic["$resourceOvercap"] = overcap
		lookupLogic["$maelstromOvercap"] = overcap
		lookupLogic["$ifMaelstrom"] = icefuryMaelstrom
		lookupLogic["$ifStacks"] = icefuryStacks
		lookupLogic["$ifTime"] = icefuryTime
		lookupLogic["$skStacks"] = stormkeeperStacks
		lookupLogic["$skTime"] = _stormkeeperTime
		lookupLogic["$eogsTime"] = _eogsTime
		lookupLogic["$fsCount"] = _flameShockCount
		lookupLogic["$fsTime"] = _flameShockTime
		lookupLogic["$ascendanceTime"] = _ascendanceTime
		lookupLogic["$pfTime"] = _pfTime
		TRB.Data.lookupLogic = lookupLogic
	end

	local function RefreshLookupData_Enhancement()
		local _
		--Spec specific implementation
		local currentTime = GetTime()
		local normalizedMana = TRB.Data.snapshot.resource / TRB.Data.resourceFactor

		-- This probably needs to be pulled every refresh
		TRB.Data.snapshot.manaRegen, _ = GetPowerRegen()
		local currentManaColor = TRB.Data.settings.shaman.enhancement.colors.text.current
		--$mana
		local manaPrecision = TRB.Data.settings.shaman.enhancement.manaPrecision or 1
		local currentMana = string.format("|c%s%s|r", currentManaColor, TRB.Functions.String:ConvertToShortNumberNotation(normalizedMana, manaPrecision, "floor", true))

		----------
		--$fsCount and $fsTime
		local _flameShockCount = TRB.Data.snapshot.targetData.flameShock or 0
		local flameShockCount = tostring(_flameShockCount)
		local _flameShockTime = 0
		
		if TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid] ~= nil then
			_flameShockTime = TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].flameShockRemaining or 0
		end

		local flameShockTime

		if TRB.Data.settings.shaman.enhancement.colors.text.dots.enabled and TRB.Data.snapshot.targetData.currentTargetGuid ~= nil and not UnitIsDeadOrGhost("target") and UnitCanAttack("player", "target") then
			if TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid] ~= nil and TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].flameShock then
				if TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].flameShockRemaining > TRB.Data.spells.flameShock.pandemicTime then
					flameShockCount = string.format("|c%s%.0f|r", TRB.Data.settings.shaman.enhancement.colors.text.dots.up, _flameShockCount)
					flameShockTime = string.format("|c%s%.1f|r", TRB.Data.settings.shaman.enhancement.colors.text.dots.up, TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].flameShockRemaining)
				else
					flameShockCount = string.format("|c%s%.0f|r", TRB.Data.settings.shaman.enhancement.colors.text.dots.pandemic, _flameShockCount)
					flameShockTime = string.format("|c%s%.1f|r", TRB.Data.settings.shaman.enhancement.colors.text.dots.pandemic, TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].flameShockRemaining)
				end
			else
				flameShockCount = string.format("|c%s%.0f|r", TRB.Data.settings.shaman.enhancement.colors.text.dots.down, _flameShockCount)
				flameShockTime = string.format("|c%s%.1f|r", TRB.Data.settings.shaman.enhancement.colors.text.dots.down, 0)
			end
		else
			flameShockTime = string.format("%.1f", _flameShockTime)
		end

		--$ascendanceTime
		local _ascendanceTime = TRB.Data.snapshot.ascendance.remainingTime
		local ascendanceTime = string.format("%.1f", _ascendanceTime)

		----------------------------
		Global_TwintopResourceBar.dots = {
			fsCount = flameShockCount or 0,
		}

		local lookup = TRB.Data.lookup or {}
		lookup["#ascendance"] = TRB.Data.spells.ascendance.icon
		lookup["#flameShock"] = TRB.Data.spells.flameShock.icon
		lookup["$manaMax"] = TRB.Data.character.maxResource
		lookup["$mana"] = currentMana
		lookup["$resourceMax"] = TRB.Data.character.maxResource
		lookup["$resource"] = currentMana
		lookup["$maelstromWeapon"] = TRB.Data.character.resource2
		lookup["$comboPoints"] = TRB.Data.character.resource2
		lookup["$maelstromWeaponMax"] = TRB.Data.character.maxResource2Raw
		lookup["$comboPointsMax"] = TRB.Data.character.maxResource2Raw
		lookup["$ascendanceTime"] = ascendanceTime
		lookup["$fsCount"] = flameShockCount
		lookup["$fsTime"] = flameShockTime
		TRB.Data.lookup = lookup

		local lookupLogic = TRB.Data.lookupLogic or {}
		lookupLogic["$manaMax"] = TRB.Data.character.maxResource
		lookupLogic["$mana"] = TRB.Data.snapshot.resource
		lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
		lookupLogic["$resource"] = TRB.Data.snapshot.resource
		lookupLogic["$casting"] = TRB.Data.snapshot.casting.resourceFinal
		lookupLogic["$essence"] = TRB.Data.character.resource2
		lookupLogic["$comboPoints"] = TRB.Data.character.resource2
		lookupLogic["$essenceMax"] = TRB.Data.character.maxResource2Raw
		lookupLogic["$comboPointsMax"] = TRB.Data.character.maxResource2Raw
		lookupLogic["$ascendanceTime"] = _ascendanceTime
		lookupLogic["$fsCount"] = _flameShockCount
		lookupLogic["$fsTime"] = _flameShockTime
		TRB.Data.lookupLogic = lookupLogic
	end

	local function RefreshLookupData_Restoration()
		local currentTime = GetTime()
		local normalizedMana = TRB.Data.snapshot.resource / TRB.Data.resourceFactor

		-- This probably needs to be pulled every refresh
---@diagnostic disable-next-line: cast-local-type
		TRB.Data.snapshot.manaRegen, _ = GetPowerRegen()

		local currentManaColor = TRB.Data.settings.shaman.restoration.colors.text.current
		local castingManaColor = TRB.Data.settings.shaman.restoration.colors.text.casting

		--$mana
		local manaPrecision = TRB.Data.settings.shaman.restoration.manaPrecision or 1
		local currentMana = string.format("|c%s%s|r", currentManaColor, TRB.Functions.String:ConvertToShortNumberNotation(normalizedMana, manaPrecision, "floor", true))
		--$casting
		local _castingMana = TRB.Data.snapshot.casting.resourceFinal
		local castingMana = string.format("|c%s%s|r", castingManaColor, TRB.Functions.String:ConvertToShortNumberNotation(_castingMana, manaPrecision, "floor", true))

		--$sohMana
		local _sohMana = TRB.Data.snapshot.symbolOfHope.resourceFinal
		local sohMana = string.format("%s", TRB.Functions.String:ConvertToShortNumberNotation(_sohMana, manaPrecision, "floor", true))
		--$sohTicks
		local _sohTicks = TRB.Data.snapshot.symbolOfHope.ticksRemaining or 0
		local sohTicks = string.format("%.0f", _sohTicks)
		--$sohTime
		local _sohTime = GetSymbolOfHopeRemainingTime()
		local sohTime = string.format("%.1f", _sohTime)

		--$innervateMana
		local _innervateMana = TRB.Data.snapshot.innervate.mana
		local innervateMana = string.format("%s", TRB.Functions.String:ConvertToShortNumberNotation(_innervateMana, manaPrecision, "floor", true))
		--$innervateTime
		local _innervateTime = GetInnervateRemainingTime()
		local innervateTime = string.format("%.1f", _innervateTime)

		--$mttMana
		local _mttMana = TRB.Data.snapshot.manaTideTotem.mana
		local mttMana = string.format("%s", TRB.Functions.String:ConvertToShortNumberNotation(_mttMana, manaPrecision, "floor", true))
		--$mttTime
		local _mttTime = GetManaTideTotemRemainingTime()
		local mttTime = string.format("%.1f", _mttTime)

		--$mrMana
		local _mrMana = TRB.Data.snapshot.moltenRadiance.mana
		local mrMana = string.format("%s", TRB.Functions.String:ConvertToShortNumberNotation(_mrMana, manaPrecision, "floor", true))
		--$mrTime
		local _mrTime = GetMoltenRadianceRemainingTime()
		local mrTime = string.format("%.1f", _mrTime)

		--$potionCooldownSeconds
		local _potionCooldown = 0
		if TRB.Data.snapshot.potion.onCooldown then
			_potionCooldown = math.abs(TRB.Data.snapshot.potion.startTime + TRB.Data.snapshot.potion.duration - currentTime)
		end
		local potionCooldownSeconds = string.format("%.1f", _potionCooldown)
		local _potionCooldownMinutes = math.floor(_potionCooldown / 60)
		local _potionCooldownSeconds = _potionCooldown % 60
		--$potionCooldown
		local potionCooldown = string.format("%d:%0.2d", _potionCooldownMinutes, _potionCooldownSeconds)

		--$potionOfChilledClarityMana
		local _potionOfChilledClarityMana = TRB.Data.snapshot.potionOfChilledClarity.mana
		local potionOfChilledClarityMana = string.format("%s", TRB.Functions.String:ConvertToShortNumberNotation(_potionOfChilledClarityMana, manaPrecision, "floor", true))
		--$potionOfChilledClarityTime
		local _potionOfChilledClarityTime = GetPotionOfChilledClarityRemainingTime()
		local potionOfChilledClarityTime = string.format("%.1f", _potionOfChilledClarityTime)

		--$channeledMana
		local _channeledMana = CalculateManaGain(TRB.Data.snapshot.channeledManaPotion.mana, true)
		local channeledMana = string.format("%s", TRB.Functions.String:ConvertToShortNumberNotation(_channeledMana, manaPrecision, "floor", true))
		--$potionOfFrozenFocusTicks
		local _potionOfFrozenFocusTicks = TRB.Data.snapshot.channeledManaPotion.ticksRemaining or 0
		local potionOfFrozenFocusTicks = string.format("%.0f", _potionOfFrozenFocusTicks)
		--$potionOfFrozenFocusTime
		local _potionOfFrozenFocusTime = GetChanneledPotionRemainingTime()
		local potionOfFrozenFocusTime = string.format("%.1f", _potionOfFrozenFocusTime)
		--$passive
		local _passiveMana = _sohMana + _channeledMana + math.max(_innervateMana, _potionOfChilledClarityMana) + _mttMana + _mrMana
		local passiveMana = string.format("|c%s%s|r", TRB.Data.settings.shaman.restoration.colors.text.passive, TRB.Functions.String:ConvertToShortNumberNotation(_passiveMana, manaPrecision, "floor", true))
		--$manaTotal
		local _manaTotal = math.min(_passiveMana + TRB.Data.snapshot.casting.resourceFinal + normalizedMana, TRB.Data.character.maxResource)
		local manaTotal = string.format("|c%s%s|r", currentManaColor, TRB.Functions.String:ConvertToShortNumberNotation(_manaTotal, manaPrecision, "floor", true))
		--$manaPlusCasting
		local _manaPlusCasting = math.min(TRB.Data.snapshot.casting.resourceFinal + normalizedMana, TRB.Data.character.maxResource)
		local manaPlusCasting = string.format("|c%s%s|r", castingManaColor, TRB.Functions.String:ConvertToShortNumberNotation(_manaPlusCasting, manaPrecision, "floor", true))
		--$manaPlusPassive
		local _manaPlusPassive = math.min(_passiveMana + normalizedMana, TRB.Data.character.maxResource)
		local manaPlusPassive = string.format("|c%s%s|r", currentManaColor, TRB.Functions.String:ConvertToShortNumberNotation(_manaPlusPassive, manaPrecision, "floor", true))

		--$manaMax
		local manaMax = string.format("|c%s%s|r", currentManaColor, TRB.Functions.String:ConvertToShortNumberNotation(TRB.Data.character.maxResource, manaPrecision, "floor", true))

		--$manaPercent
		local maxResource = TRB.Data.character.maxResource

		if maxResource == 0 then
			maxResource = 1
		end
		local _manaPercent = (normalizedMana/maxResource)
		local manaPercent = string.format("|c%s%s|r", currentManaColor, TRB.Functions.Number:RoundTo(_manaPercent*100, manaPrecision, "floor"))

		----------
		--$fsCount and $fsTime
		local _flameShockCount = TRB.Data.snapshot.targetData.flameShock or 0
		local flameShockCount = tostring(_flameShockCount)
		local _flameShockTime = 0
		
		if TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid] ~= nil then
			_flameShockTime = TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].flameShockRemaining or 0
		end

		local flameShockTime

		if TRB.Data.settings.shaman.elemental.colors.text.dots.enabled and TRB.Data.snapshot.targetData.currentTargetGuid ~= nil and not UnitIsDeadOrGhost("target") and UnitCanAttack("player", "target") then
			if TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid] ~= nil and TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].flameShock then
				if TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].flameShockRemaining > TRB.Data.spells.flameShock.pandemicTime then
					flameShockCount = string.format("|c%s%.0f|r", TRB.Data.settings.shaman.elemental.colors.text.dots.up, _flameShockCount)
					flameShockTime = string.format("|c%s%.1f|r", TRB.Data.settings.shaman.elemental.colors.text.dots.up, TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].flameShockRemaining)
				else
					flameShockCount = string.format("|c%s%.0f|r", TRB.Data.settings.shaman.elemental.colors.text.dots.pandemic, _flameShockCount)
					flameShockTime = string.format("|c%s%.1f|r", TRB.Data.settings.shaman.elemental.colors.text.dots.pandemic, TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].flameShockRemaining)
				end
			else
				flameShockCount = string.format("|c%s%.0f|r", TRB.Data.settings.shaman.elemental.colors.text.dots.down, _flameShockCount)
				flameShockTime = string.format("|c%s%.1f|r", TRB.Data.settings.shaman.elemental.colors.text.dots.down, 0)
			end
		else
			flameShockTime = string.format("%.1f", _flameShockTime)
		end		

		--$ascendanceTime
		local _ascendanceTime = TRB.Data.snapshot.ascendance.remainingTime
		local ascendanceTime = string.format("%.1f", _ascendanceTime)

		Global_TwintopResourceBar.resource.passive = _passiveMana
		Global_TwintopResourceBar.resource.potionOfSpiritualClarity = _channeledMana or 0
		Global_TwintopResourceBar.resource.manaTideTotem = _mttMana or 0
		Global_TwintopResourceBar.resource.innervate = _innervateMana or 0
		Global_TwintopResourceBar.resource.symbolOfHope = _sohMana or 0
		Global_TwintopResourceBar.resource.moltenRadiance = _mrMana or 0
		Global_TwintopResourceBar.potionOfSpiritualClarity = {
			mana = _channeledMana,
			ticks = TRB.Data.snapshot.channeledManaPotion.ticksRemaining or 0
		}
		Global_TwintopResourceBar.symbolOfHope = {
			mana = _sohMana,
			ticks = TRB.Data.snapshot.symbolOfHope.ticksRemaining or 0
		}
		Global_TwintopResourceBar.dots = {
			fsCount = flameShockCount or 0,
		}


		local lookup = TRB.Data.lookup or {}
		lookup["#ascendance"] = TRB.Data.spells.ascendance.icon
		lookup["#flameShock"] = TRB.Data.spells.flameShock.icon
		lookup["#innervate"] = TRB.Data.spells.innervate.icon
		lookup["#mtt"] = TRB.Data.spells.manaTideTotem.icon
		lookup["#manaTideTotem"] = TRB.Data.spells.manaTideTotem.icon
		lookup["#mr"] = TRB.Data.spells.moltenRadiance.icon
		lookup["#moltenRadiance"] = TRB.Data.spells.moltenRadiance.icon
		lookup["#soh"] = TRB.Data.spells.symbolOfHope.icon
		lookup["#symbolOfHope"] = TRB.Data.spells.symbolOfHope.icon
		lookup["#potionOfFrozenFocus"] = TRB.Data.spells.potionOfFrozenFocusRank1.icon
		lookup["#amp"] = TRB.Data.spells.aeratedManaPotionRank1.icon
		lookup["#aeratedManaPotion"] = TRB.Data.spells.aeratedManaPotionRank1.icon
		lookup["#pocc"] = TRB.Data.spells.potionOfChilledClarity.icon
		lookup["#potionOfChilledClarity"] = TRB.Data.spells.potionOfChilledClarity.icon
		lookup["#poff"] = TRB.Data.spells.potionOfFrozenFocusRank1.icon
		lookup["#potionOfFrozenFocus"] = TRB.Data.spells.potionOfFrozenFocusRank1.icon
		lookup["$fsCount"] = flameShockCount
		lookup["$fsTime"] = flameShockTime
		lookup["$manaPlusCasting"] = manaPlusCasting
		lookup["$manaPlusPassive"] = manaPlusPassive
		lookup["$manaTotal"] = manaTotal
		lookup["$manaMax"] = manaMax
		lookup["$mana"] = currentMana
		lookup["$resourcePlusCasting"] = manaPlusCasting
		lookup["$resourcePlusPassive"] = manaPlusPassive
		lookup["$resourceTotal"] = manaTotal
		lookup["$resourceMax"] = manaMax
		lookup["$manaPercent"] = manaPercent
		lookup["$resourcePercent"] = manaPercent
		lookup["$resource"] = currentMana
		lookup["$casting"] = castingMana
		lookup["$passive"] = passiveMana
		lookup["$sohMana"] = sohMana
		lookup["$sohTime"] = sohTime
		lookup["$sohTicks"] = sohTicks
		lookup["$innervateMana"] = innervateMana
		lookup["$innervateTime"] = innervateTime
		lookup["$mrMana"] = mrMana
		lookup["$mrTime"] = mrTime
		lookup["$mttMana"] = mttMana
		lookup["$mttTime"] = mttTime
		lookup["$channeledMana"] = channeledMana
		lookup["$potionOfFrozenFocusTicks"] = potionOfFrozenFocusTicks
		lookup["$potionOfFrozenFocusTime"] = potionOfFrozenFocusTime
		lookup["$potionOfChilledClarityMana"] = potionOfChilledClarityMana
		lookup["$potionOfChilledClarityTime"] = potionOfChilledClarityTime
		lookup["$potionCooldown"] = potionCooldown
		lookup["$potionCooldownSeconds"] = potionCooldownSeconds
		lookup["$ascendanceTime"] = ascendanceTime
		TRB.Data.lookup = lookup

		local lookupLogic = TRB.Data.lookupLogic or {}
		lookupLogic["$manaPlusCasting"] = _manaPlusCasting
		lookupLogic["$manaPlusPassive"] = _manaPlusPassive
		lookupLogic["$manaTotal"] = _manaTotal
		lookupLogic["$manaMax"] = maxResource
		lookupLogic["$mana"] = normalizedMana
		lookupLogic["$resourcePlusCasting"] = _manaPlusCasting
		lookupLogic["$resourcePlusPassive"] = _manaPlusPassive
		lookupLogic["$resourceTotal"] = _manaTotal
		lookupLogic["$resourceMax"] = maxResource
		lookupLogic["$manaPercent"] = _manaPercent
		lookupLogic["$resourcePercent"] = _manaPercent
		lookupLogic["$resource"] = normalizedMana
		lookupLogic["$casting"] = _castingMana
		lookupLogic["$passive"] = _passiveMana
		lookupLogic["$sohMana"] = _sohMana
		lookupLogic["$sohTime"] = _sohTime
		lookupLogic["$sohTicks"] = _sohTicks
		lookupLogic["$innervateMana"] = _innervateMana
		lookupLogic["$innervateTime"] = _innervateTime
		lookupLogic["$mrMana"] = _mrMana
		lookupLogic["$mrTime"] = _mrTime
		lookupLogic["$mttMana"] = _mttMana
		lookupLogic["$mttTime"] = _mttTime
		lookupLogic["$channeledMana"] = _channeledMana
		lookupLogic["$potionOfFrozenFocusTicks"] = _potionOfFrozenFocusTicks
		lookupLogic["$potionOfFrozenFocusTime"] = _potionOfFrozenFocusTime
		lookupLogic["$potionCooldown"] = potionCooldown
		lookupLogic["$potionCooldownSeconds"] = potionCooldown
		lookupLogic["$potionOfChilledClarityMana"] = _potionOfChilledClarityMana
		lookupLogic["$potionOfChilledClarityTime"] = _potionOfChilledClarityTime
		lookupLogic["$fsCount"] = _flameShockCount
		lookupLogic["$fsTime"] = _flameShockTime
		lookupLogic["$ascendanceTime"] = _ascendanceTime
		TRB.Data.lookupLogic = lookupLogic
	end

	local function FillSnapshotDataCasting(spell, maelstromMod)
		maelstromMod = maelstromMod or 0
		local maelstromMultMod = 1

		if TRB.Data.snapshot.primalFracture.isActive then
			if spell.id == TRB.Data.spells.lavaBurst.id or
				spell.id == TRB.Data.spells.lightningBolt.id or
				spell.id == TRB.Data.spells.icefury.id or
				spell.id == TRB.Data.spells.frostShock.id
				then
				maelstromMultMod = TRB.Data.spells.primalFracture.maelstromMod
			end
		end

		local currentTime = GetTime()
		TRB.Data.snapshot.casting.startTime = currentTime
		TRB.Data.snapshot.casting.resourceRaw = (spell.maelstrom + maelstromMod) * maelstromMultMod
		TRB.Data.snapshot.casting.resourceFinal = (spell.maelstrom + maelstromMod) * maelstromMultMod
		TRB.Data.snapshot.casting.spellId = spell.id
		TRB.Data.snapshot.casting.icon = spell.icon
	end


	local function UpdateCastingResourceFinal_Restoration()
		-- Do nothing for now
		TRB.Data.snapshot.casting.resourceFinal = TRB.Data.snapshot.casting.resourceRaw * TRB.Data.snapshot.innervate.modifier * TRB.Data.snapshot.potionOfChilledClarity.modifier
	end

	local function CastingSpell()
		local specId = GetSpecialization()
		local affectingCombat = UnitAffectingCombat("player")
		local currentSpellName, _, _, currentSpellStartTime, currentSpellEndTime, _, _, _, currentSpellId = UnitCastingInfo("player")
		local currentChannelName, _, _, currentChannelStartTime, currentChannelEndTime, _, _, currentChannelId = UnitChannelInfo("player")

		if currentSpellName == nil and currentChannelName == nil then
			TRB.Functions.Character:ResetCastingSnapshotData()
			return false
		else
			if specId == 1 then
				if currentSpellName == nil then
					TRB.Functions.Character:ResetCastingSnapshotData()
					return false
					--See shaman implementation for handling channeled spells
				else
					if currentSpellId == TRB.Data.spells.lightningBolt.id then
						FillSnapshotDataCasting(TRB.Data.spells.lightningBolt, TRB.Data.spells.flowOfPower.maelstromMod.base[TRB.Data.talents[TRB.Data.spells.flowOfPower.id].currentRank].lightningBolt)

						if TRB.Data.snapshot.surgeOfPower.isActive then
							TRB.Data.snapshot.casting.resourceRaw = TRB.Data.snapshot.casting.resourceRaw + ((TRB.Data.spells.lightningBolt.overload + TRB.Data.spells.flowOfPower.maelstromMod.overload[TRB.Data.talents[TRB.Data.spells.flowOfPower.id].currentRank].lightningBolt) * 2)
							TRB.Data.snapshot.casting.resourceFinal = TRB.Data.snapshot.casting.resourceFinal + ((TRB.Data.spells.lightningBolt.overload + TRB.Data.spells.flowOfPower.maelstromMod.overload[TRB.Data.talents[TRB.Data.spells.flowOfPower.id].currentRank].lightningBolt) * 2)
						end
						
						if TRB.Data.snapshot.powerOfTheMaelstrom.isActive then
							TRB.Data.snapshot.casting.resourceRaw = TRB.Data.snapshot.casting.resourceRaw + TRB.Data.spells.lightningBolt.overload + TRB.Data.spells.flowOfPower.maelstromMod.overload[TRB.Data.talents[TRB.Data.spells.flowOfPower.id].currentRank].lightningBolt
							TRB.Data.snapshot.casting.resourceFinal = TRB.Data.snapshot.casting.resourceFinal + TRB.Data.spells.lightningBolt.overload + TRB.Data.spells.flowOfPower.maelstromMod.overload[TRB.Data.talents[TRB.Data.spells.flowOfPower.id].currentRank].lightningBolt
						end
					elseif currentSpellId == TRB.Data.spells.lavaBurst.id then
						FillSnapshotDataCasting(TRB.Data.spells.lavaBurst, TRB.Data.spells.flowOfPower.maelstromMod.base[TRB.Data.talents[TRB.Data.spells.flowOfPower.id].currentRank].lavaBurst)
					elseif currentSpellId == TRB.Data.spells.elementalBlast.id then
						FillSnapshotDataCasting(TRB.Data.spells.elementalBlast)
					elseif currentSpellId == TRB.Data.spells.icefury.id then
						FillSnapshotDataCasting(TRB.Data.spells.icefury)
					elseif currentSpellId == TRB.Data.spells.chainLightning.id or currentSpellId == TRB.Data.spells.lavaBeam.id then
						local spell = nil
						if currentSpellId == TRB.Data.spells.lavaBeam.id then
							spell = TRB.Data.spells.lavaBeam
						else
							spell = TRB.Data.spells.chainLightning
						end
						FillSnapshotDataCasting(spell)
						
						local currentTime = GetTime()
						local down, up, lagHome, lagWorld = GetNetStats()
						local latency = lagWorld / 1000

						if TRB.Data.snapshot.chainLightning.hitTime == nil then
							TRB.Data.snapshot.chainLightning.targetsHit = 1
							TRB.Data.snapshot.chainLightning.hitTime = currentTime
							TRB.Data.snapshot.chainLightning.hasStruckTargets = false
						elseif currentTime > (TRB.Data.snapshot.chainLightning.hitTime + (TRB.Functions.Character:GetCurrentGCDTime(true) * 4) + latency) then
							TRB.Data.snapshot.chainLightning.targetsHit = 1
						end

						if TRB.Data.snapshot.powerOfTheMaelstrom.isActive and currentSpellId == TRB.Data.spells.chainLightning.id then
							TRB.Data.snapshot.casting.resourceRaw = TRB.Data.snapshot.casting.resourceRaw + TRB.Data.spells.chainLightning.overload
							TRB.Data.snapshot.casting.resourceFinal = TRB.Data.snapshot.casting.resourceFinal + TRB.Data.spells.chainLightning.overload
						end

						TRB.Data.snapshot.casting.resourceRaw = TRB.Data.snapshot.casting.resourceRaw * TRB.Data.snapshot.chainLightning.targetsHit
						TRB.Data.snapshot.casting.resourceFinal = TRB.Data.snapshot.casting.resourceFinal * TRB.Data.snapshot.chainLightning.targetsHit
					elseif currentSpellId == TRB.Data.spells.hex.id and TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.inundate) and affectingCombat then
						FillSnapshotDataCasting(TRB.Data.spells.hex)
					else
						TRB.Functions.Character:ResetCastingSnapshotData()
						return false
					end
				end
				return true
			elseif specId == 2 then
				--[[if currentSpellName == nil then
					return true
				else]]
					TRB.Functions.Character:ResetCastingSnapshotData()
					return false
				--end
			elseif specId == 3 then	
				if currentSpellName == nil then
					TRB.Functions.Character:ResetCastingSnapshotData()
					return false
				else
					local _, _, spellIcon, _, _, _, spellId = GetSpellInfo(currentSpellName)

					if spellId then
						local manaCost = -TRB.Functions.Spell:GetSpellManaCost(spellId)

						TRB.Data.snapshot.casting.startTime = currentSpellStartTime / 1000
						TRB.Data.snapshot.casting.endTime = currentSpellEndTime / 1000
						TRB.Data.snapshot.casting.resourceRaw = manaCost
						TRB.Data.snapshot.casting.spellId = spellId
						TRB.Data.snapshot.casting.icon = string.format("|T%s:0|t", spellIcon)

						UpdateCastingResourceFinal_Restoration()
					else
						TRB.Functions.Character:ResetCastingSnapshotData()
						return false
					end
				end
				return true
			end
			TRB.Functions.Character:ResetCastingSnapshotData()
			return false
		end
	end

	local function UpdateIcefury()
		if TRB.Data.snapshot.icefury.isActive then
			local currentTime = GetTime()
			if TRB.Data.snapshot.icefury.startTime == nil or currentTime > (TRB.Data.snapshot.icefury.startTime + TRB.Data.spells.icefury.duration) then
				TRB.Data.snapshot.icefury.stacks = 0
				TRB.Data.snapshot.icefury.startTime = nil
				TRB.Data.snapshot.icefury.astralPower = 0
				TRB.Data.snapshot.icefury.isActive = false
			end
		end
	end

	local function UpdateStormkeeper()
		_, _, TRB.Data.snapshot.stormkeeper.stacks, _, TRB.Data.snapshot.stormkeeper.duration, TRB.Data.snapshot.stormkeeper.endTime, _, _, _, TRB.Data.snapshot.stormkeeper.spellId = TRB.Functions.Aura:FindBuffById(TRB.Data.spells.stormkeeper.id)
	end

	local function UpdateChanneledManaPotion(forceCleanup)
		if TRB.Data.snapshot.channeledManaPotion.isActive or forceCleanup then
			local currentTime = GetTime()
			if forceCleanup or TRB.Data.snapshot.channeledManaPotion.endTime == nil or currentTime > TRB.Data.snapshot.channeledManaPotion.endTime then
				TRB.Data.snapshot.channeledManaPotion.ticksRemaining = 0
				TRB.Data.snapshot.channeledManaPotion.endTime = nil
				TRB.Data.snapshot.channeledManaPotion.mana = 0
				TRB.Data.snapshot.channeledManaPotion.isActive = false
				TRB.Data.snapshot.channeledManaPotion.spellKey = nil
			else
				TRB.Data.snapshot.channeledManaPotion.ticksRemaining = math.ceil((TRB.Data.snapshot.channeledManaPotion.endTime - currentTime) / (TRB.Data.spells[TRB.Data.snapshot.channeledManaPotion.spellKey].duration / TRB.Data.spells[TRB.Data.snapshot.channeledManaPotion.spellKey].ticks))
				local nextTickRemaining = TRB.Data.snapshot.channeledManaPotion.endTime - currentTime - math.floor((TRB.Data.snapshot.channeledManaPotion.endTime - currentTime) / (TRB.Data.spells[TRB.Data.snapshot.channeledManaPotion.spellKey].duration / TRB.Data.spells[TRB.Data.snapshot.channeledManaPotion.spellKey].ticks))
				TRB.Data.snapshot.channeledManaPotion.mana = TRB.Data.snapshot.channeledManaPotion.ticksRemaining * CalculateManaGain(TRB.Data.spells[TRB.Data.snapshot.channeledManaPotion.spellKey].mana, true) + ((TRB.Data.snapshot.channeledManaPotion.ticksRemaining - 1 + nextTickRemaining) * TRB.Data.snapshot.manaRegen)
			end
		end
	end

	local function UpdateSymbolOfHope(forceCleanup)
		if TRB.Data.snapshot.symbolOfHope.isActive or forceCleanup then
			local currentTime = GetTime()
			if forceCleanup or TRB.Data.snapshot.symbolOfHope.endTime == nil or currentTime > TRB.Data.snapshot.symbolOfHope.endTime or currentTime > TRB.Data.snapshot.symbolOfHope.firstTickTime + TRB.Data.spells.symbolOfHope.duration or currentTime > TRB.Data.snapshot.symbolOfHope.firstTickTime + (TRB.Data.spells.symbolOfHope.ticks * TRB.Data.snapshot.symbolOfHope.tickRate) then
				TRB.Data.snapshot.symbolOfHope.ticksRemaining = 0
				TRB.Data.snapshot.symbolOfHope.tickRate = 0
				TRB.Data.snapshot.symbolOfHope.previousTickTime = nil
				TRB.Data.snapshot.symbolOfHope.firstTickTime = nil
				TRB.Data.snapshot.symbolOfHope.endTime = nil
				TRB.Data.snapshot.symbolOfHope.resourceRaw = 0
				TRB.Data.snapshot.symbolOfHope.resourceFinal = 0
				TRB.Data.snapshot.symbolOfHope.isActive = false
				TRB.Data.snapshot.symbolOfHope.tickRateFound = false
			else
				TRB.Data.snapshot.symbolOfHope.ticksRemaining = math.ceil((TRB.Data.snapshot.symbolOfHope.endTime - currentTime) / TRB.Data.snapshot.symbolOfHope.tickRate)
				local nextTickRemaining = TRB.Data.snapshot.symbolOfHope.endTime - currentTime - math.floor((TRB.Data.snapshot.symbolOfHope.endTime - currentTime) / TRB.Data.snapshot.symbolOfHope.tickRate)
				TRB.Data.snapshot.symbolOfHope.resourceRaw = 0

				for x = 1, TRB.Data.snapshot.symbolOfHope.ticksRemaining do
					local casterRegen = 0
					if TRB.Data.snapshot.casting.spellId == TRB.Data.spells.symbolOfHope.id then
						if x == 1 then
							casterRegen = nextTickRemaining * TRB.Data.snapshot.manaRegen
						else
							casterRegen = TRB.Data.snapshot.manaRegen
						end
					end

					local estimatedMana = TRB.Data.character.maxResource + TRB.Data.snapshot.symbolOfHope.resourceRaw + casterRegen - (TRB.Data.snapshot.resource / TRB.Data.resourceFactor)
					local nextTick = TRB.Data.spells.symbolOfHope.manaPercent * math.max(0, math.min(TRB.Data.character.maxResource, estimatedMana))
					TRB.Data.snapshot.symbolOfHope.resourceRaw = TRB.Data.snapshot.symbolOfHope.resourceRaw + nextTick + casterRegen
				end

				--Revisit if we get mana modifiers added
				TRB.Data.snapshot.symbolOfHope.resourceFinal = CalculateManaGain(TRB.Data.snapshot.symbolOfHope.resourceRaw, false)
			end
		end
	end

	local function UpdateInnervate()
		local currentTime = GetTime()

		if TRB.Data.snapshot.innervate.endTime ~= nil and currentTime > TRB.Data.snapshot.innervate.endTime then
			TRB.Data.snapshot.innervate.endTime = nil
			TRB.Data.snapshot.innervate.duration = 0
			TRB.Data.snapshot.innervate.remainingTime = 0
			TRB.Data.snapshot.innervate.mana = 0
			TRB.Data.snapshot.audio.innervateCue = false
		else
			TRB.Data.snapshot.innervate.remainingTime = GetInnervateRemainingTime()
			TRB.Data.snapshot.innervate.mana = TRB.Data.snapshot.innervate.remainingTime * TRB.Data.snapshot.manaRegen
		end
	end
	
	local function UpdatePotionOfChilledClarity()
		local currentTime = GetTime()

		if TRB.Data.snapshot.potionOfChilledClarity.endTime ~= nil and currentTime > TRB.Data.snapshot.potionOfChilledClarity.endTime then
			TRB.Data.snapshot.potionOfChilledClarity.endTime = nil
			TRB.Data.snapshot.potionOfChilledClarity.duration = 0
			TRB.Data.snapshot.potionOfChilledClarity.remainingTime = 0
			TRB.Data.snapshot.potionOfChilledClarity.mana = 0
			TRB.Data.snapshot.audio.potionOfChilledClarityCue = false
		else
			TRB.Data.snapshot.potionOfChilledClarity.remainingTime = GetPotionOfChilledClarityRemainingTime()
			TRB.Data.snapshot.potionOfChilledClarity.mana = TRB.Data.snapshot.potionOfChilledClarity.remainingTime * TRB.Data.snapshot.manaRegen
		end
	end

	local function UpdateManaTideTotem(forceCleanup)
		local currentTime = GetTime()

		if forceCleanup or (TRB.Data.snapshot.manaTideTotem.endTime ~= nil and currentTime > TRB.Data.snapshot.manaTideTotem.endTime) then
			TRB.Data.snapshot.manaTideTotem.endTime = nil
			TRB.Data.snapshot.manaTideTotem.duration = 0
			TRB.Data.snapshot.manaTideTotem.remainingTime = 0
			TRB.Data.snapshot.manaTideTotem.mana = 0
			TRB.Data.snapshot.audio.manaTideTotemCue = false
		else
			TRB.Data.snapshot.manaTideTotem.remainingTime = GetManaTideTotemRemainingTime()
			TRB.Data.snapshot.manaTideTotem.mana = TRB.Data.snapshot.manaTideTotem.remainingTime * (TRB.Data.snapshot.manaRegen / 2) --Only half of this is considered bonus
		end
	end

	local function UpdateMoltenRadiance(forceCleanup)
		local currentTime = GetTime()

		if forceCleanup or (TRB.Data.snapshot.moltenRadiance.endTime ~= nil and currentTime > TRB.Data.snapshot.moltenRadiance.endTime) then
			TRB.Data.snapshot.moltenRadiance.endTime = nil
			TRB.Data.snapshot.moltenRadiance.duration = 0
			TRB.Data.snapshot.moltenRadiance.remainingTime = 0
			TRB.Data.snapshot.moltenRadiance.mana = 0
			TRB.Data.snapshot.moltenRadiance.manaPerTick = 0
		elseif TRB.Data.snapshot.moltenRadiance.endTime ~= nil then
			TRB.Data.snapshot.moltenRadiance.remainingTime = GetMoltenRadianceRemainingTime()
			TRB.Data.snapshot.moltenRadiance.mana = TRB.Data.snapshot.moltenRadiance.manaPerTick * TRB.Functions.Number:RoundTo(TRB.Data.snapshot.moltenRadiance.remainingTime, 0, "ceil", true)
		end
	end

	local function UpdateSnapshot()
		local currentTime = GetTime()
		TRB.Functions.Character:UpdateSnapshot()
		
		if TRB.Data.snapshot.targetData.currentTargetGuid ~= nil and TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid] then
			if TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].flameShock then
				local expiration = select(6, TRB.Functions.Aura:FindDebuffById(TRB.Data.spells.flameShock.id, "target", "player"))
			
				if expiration ~= nil then
					TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].flameShockRemaining = expiration - currentTime
				end
			end
		end

		if TRB.Data.snapshot.ascendance.startTime ~= nil and currentTime > (TRB.Data.snapshot.ascendance.startTime + TRB.Data.snapshot.ascendance.duration) then
			TRB.Data.snapshot.ascendance.startTime = nil
			TRB.Data.snapshot.ascendance.duration = 0
			TRB.Data.snapshot.ascendance.remainingTime = 0
		else
			_, _, _, _, TRB.Data.snapshot.ascendance.duration, TRB.Data.snapshot.ascendance.endTime, _, _, _, TRB.Data.snapshot.ascendance.spellId = TRB.Functions.Aura:FindBuffById(TRB.Data.spells.ascendance.id)
			TRB.Data.snapshot.ascendance.remainingTime = GetAscendanceRemainingTime()
		end
	end

	local function UpdateSnapshot_Elemental()
		UpdateSnapshot()

		local currentTime = GetTime()
		UpdateIcefury()

		TRB.Data.character.earthShockThreshold = TRB.Data.character.earthShockThreshold
		TRB.Data.character.earthquakeThreshold = -(TRB.Data.spells.earthquake.maelstrom - TRB.Data.spells.eyeOfTheStorm.maelstromMod[TRB.Data.talents[TRB.Data.spells.eyeOfTheStorm.id].currentRank].earthquake)
	end

	local function UpdateSnapshot_Enhancement()
		UpdateSnapshot()
		
		local currentTime = GetTime()
		local _
	end

	local function UpdateSnapshot_Restoration()
		UpdateSnapshot()
		UpdateSymbolOfHope()
		UpdateChanneledManaPotion()
		UpdateInnervate()
		UpdatePotionOfChilledClarity()
		UpdateManaTideTotem()
		UpdateMoltenRadiance()

		local currentTime = GetTime()
		local _

		-- We have all the mana potion item ids but we're only going to check one since they're a shared cooldown
		TRB.Data.snapshot.potion.startTime, TRB.Data.snapshot.potion.duration, _ = GetItemCooldown(TRB.Data.character.items.potions.aeratedManaPotionRank1.id)
		if TRB.Data.snapshot.potion.startTime > 0 and TRB.Data.snapshot.potion.duration > 0 then
			TRB.Data.snapshot.potion.onCooldown = true
		else
			TRB.Data.snapshot.potion.onCooldown = false
		end

		TRB.Data.snapshot.conjuredChillglobe.startTime, TRB.Data.snapshot.conjuredChillglobe.duration, _ = GetItemCooldown(TRB.Data.character.items.conjuredChillglobe.id)
		if TRB.Data.snapshot.conjuredChillglobe.startTime > 0 and TRB.Data.snapshot.conjuredChillglobe.duration > 0 then
			TRB.Data.snapshot.conjuredChillglobe.onCooldown = true
		else
			TRB.Data.snapshot.conjuredChillglobe.onCooldown = false
		end
				
		if TRB.Data.snapshot.targetData.currentTargetGuid ~= nil and TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid] then
			if TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].flameShock then
				local expiration = select(6, TRB.Functions.Aura:FindDebuffById(TRB.Data.spells.flameShock.id, "target", "player"))
			
				if expiration ~= nil then
					TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].flameShockRemaining = expiration - currentTime
				end
			end
		end
	end

	local function UpdateResourceBar()
		local currentTime = GetTime()
		local refreshText = false
		local specId = GetSpecialization()
		local coreSettings = TRB.Data.settings.core
		local classSettings = TRB.Data.settings.shaman

		if specId == 1 then
			local specSettings = classSettings.elemental
			UpdateSnapshot_Elemental()
			TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specSettings, TRB.Frames.barContainerFrame)

			if TRB.Data.snapshot.isTracking then
				TRB.Functions.Bar:HideResourceBar()

				if specSettings.displayBar.neverShow == false then
					refreshText = true
					local passiveBarValue = 0
					local castingBarValue = 0
					local barBorderColor = specSettings.colors.bar.border

					if specSettings.colors.bar.overcapEnabled and TRB.Functions.Class:IsValidVariableForSpec("$overcap") and TRB.Functions.Class:IsValidVariableForSpec("$inCombat") then
						local barBorderColor = specSettings.colors.bar.borderOvercap

						if specSettings.audio.overcap.enabled and TRB.Data.snapshot.audio.overcapCue == false then
							TRB.Data.snapshot.audio.overcapCue = true
							---@diagnostic disable-next-line: redundant-parameter
							PlaySoundFile(specSettings.audio.overcap.sound, coreSettings.audio.channel.channel)
						end
					else
						TRB.Data.snapshot.audio.overcapCue = false
					end
					

					if specSettings.colors.bar.primalFracture.enabled and TRB.Functions.Class:IsValidVariableForSpec("$pfTime") then
						barBorderColor = specSettings.colors.bar.primalFracture.color
					end

					barBorderFrame:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(barBorderColor, true))

					TRB.Functions.Bar:SetValue(specSettings, resourceFrame, TRB.Data.snapshot.resource)

					if CastingSpell() and specSettings.bar.showCasting then
						castingBarValue = TRB.Data.snapshot.resource + TRB.Data.snapshot.casting.resourceFinal
					else
						castingBarValue = TRB.Data.snapshot.resource
					end

					TRB.Functions.Bar:SetValue(specSettings, castingFrame, castingBarValue)

					TRB.Functions.Bar:SetValue(specSettings, passiveFrame, passiveBarValue)

					local barColor = specSettings.colors.bar.base

					local pairOffset = 0
					for k, v in pairs(TRB.Data.spells) do
						local spell = TRB.Data.spells[k]
						if spell ~= nil and spell.id ~= nil and spell.maelstrom ~= nil and spell.maelstrom < 0 and spell.thresholdId ~= nil and spell.settingKey ~= nil then
							pairOffset = (spell.thresholdId - 1) * 3
							local resourceAmount = spell.maelstrom
							local currentResource = TRB.Data.snapshot.resource
							--TRB.Functions.Threshold:RepositionThreshold(specSettings, resourceFrame.thresholds[spell.thresholdId], resourceFrame, specSettings.thresholds.width, -resourceAmount, TRB.Data.character.maxResource)

							local showThreshold = true
							local thresholdColor = specSettings.colors.threshold.over
							local frameLevel = TRB.Data.constants.frameLevels.thresholdOver
							
							if spell.isSnowflake then -- These are special snowflakes that we need to handle manually
								if spell.id == TRB.Data.spells.earthShock.id then
									if spell.isTalent and not TRB.Functions.Talent:IsTalentActive(spell) then -- Talent not selected
										showThreshold = false
									elseif TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.elementalBlast) then
										showThreshold = false
									else
										resourceAmount = resourceAmount - TRB.Data.spells.eyeOfTheStorm.maelstromMod[TRB.Data.talents[TRB.Data.spells.eyeOfTheStorm.id].currentRank].earthShock
										
										if currentResource >= -resourceAmount then
											thresholdColor = specSettings.colors.threshold.over
										else
											thresholdColor = specSettings.colors.threshold.under
											frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
										end
									end
								elseif spell.id == TRB.Data.spells.elementalBlast.id then
									if spell.isTalent and not TRB.Functions.Talent:IsTalentActive(spell) then -- Talent not selected
										showThreshold = false
									else
										resourceAmount = resourceAmount - TRB.Data.spells.eyeOfTheStorm.maelstromMod[TRB.Data.talents[TRB.Data.spells.eyeOfTheStorm.id].currentRank].elementalBlast
										
										if currentResource >= -resourceAmount then
											thresholdColor = specSettings.colors.threshold.over
										else
											thresholdColor = specSettings.colors.threshold.under
											frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
										end
									end
								elseif spell.id == TRB.Data.spells.earthquake.id then
									if spell.isTalent and not TRB.Functions.Talent:IsTalentActive(spell) then -- Talent not selected
										showThreshold = false
									else
										resourceAmount = resourceAmount - TRB.Data.spells.eyeOfTheStorm.maelstromMod[TRB.Data.talents[TRB.Data.spells.eyeOfTheStorm.id].currentRank].earthquake

										if TRB.Data.snapshot.echoesOfGreatSundering.isActive then
											thresholdColor = specSettings.colors.threshold.echoesOfGreatSundering
											frameLevel = TRB.Data.constants.frameLevels.thresholdHighPriority
										elseif TRB.Data.snapshot.resource >= -resourceAmount then
											thresholdColor = specSettings.colors.threshold.over
											frameLevel = TRB.Data.constants.frameLevels.thresholdOver
										else
											thresholdColor = specSettings.colors.threshold.under
											frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
										end
									end
								end
							--The rest isn't used. Keeping it here for consistency until I can finish abstracting this whole mess out
							elseif spell.isTalent and not TRB.Functions.Talent:IsTalentActive(spell) then -- Talent not selected
								showThreshold = false
							elseif spell.isPvp and (not TRB.Data.character.isPvp or not TRB.Functions.Talent:IsTalentActive(spell)) then
								showThreshold = false
							elseif spell.hasCooldown then
								if (TRB.Data.snapshot[spell.settingKey].charges == nil or TRB.Data.snapshot[spell.settingKey].charges == 0) and
									(TRB.Data.snapshot[spell.settingKey].startTime ~= nil and currentTime < (TRB.Data.snapshot[spell.settingKey].startTime + TRB.Data.snapshot[spell.settingKey].duration)) then
									thresholdColor = specSettings.colors.threshold.unusable
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
								elseif currentResource >= -resourceAmount then
									thresholdColor = specSettings.colors.threshold.over
								else
									thresholdColor = specSettings.colors.threshold.under
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
								end
							else -- This is an active/available/normal spell threshold
								if currentResource >= -resourceAmount then
									thresholdColor = specSettings.colors.threshold.over
								else
									thresholdColor = specSettings.colors.threshold.under
									frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
								end
							end
							
							TRB.Functions.Threshold:RepositionThreshold(specSettings, resourceFrame.thresholds[spell.thresholdId], resourceFrame, specSettings.thresholds.width, -resourceAmount, TRB.Data.character.maxResource)

							TRB.Functions.Threshold:AdjustThresholdDisplay(spell, resourceFrame.thresholds[spell.thresholdId], showThreshold, frameLevel, pairOffset, thresholdColor, TRB.Data.snapshot[spell.settingKey], specSettings)
						end
					end

					if TRB.Data.snapshot.resource >= TRB.Data.character.earthShockThreshold then
						if specSettings.colors.bar.flashEnabled then
							TRB.Functions.Bar:PulseFrame(barContainerFrame, specSettings.colors.bar.flashAlpha, specSettings.colors.bar.flashPeriod)
						else
							barContainerFrame:SetAlpha(1.0)
						end

						if specSettings.audio.esReady.enabled and TRB.Data.snapshot.audio.playedEsCue == false then
							TRB.Data.snapshot.audio.playedEsCue = true
							---@diagnostic disable-next-line: redundant-parameter
							PlaySoundFile(specSettings.audio.esReady.sound, coreSettings.audio.channel.channel)
						end
					else
						barContainerFrame:SetAlpha(1.0)
						TRB.Data.snapshot.audio.playedEsCue = false
					end

					if TRB.Data.snapshot.ascendance.remainingTime > 0 then
						local timeLeft = TRB.Data.snapshot.ascendance.remainingTime
						local timeThreshold = 0
						local useEndOfAscendanceColor = false

						if specSettings.endOfAscendance.enabled then
							useEndOfAscendanceColor = true
							if specSettings.endOfAscendance.mode == "gcd" then
								local gcd = TRB.Functions.Character:GetCurrentGCDTime()
								timeThreshold = gcd * specSettings.endOfAscendance.gcdsMax
							elseif specSettings.endOfAscendance.mode == "time" then
								timeThreshold = specSettings.endOfAscendance.timeMax
							end
						end

						if useEndOfAscendanceColor and timeLeft <= timeThreshold then
							barColor = specSettings.colors.bar.inAscendance1GCD
						else
							barColor = specSettings.colors.bar.inAscendance
						end
					end
					
					resourceFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(barColor, true))					
				end
			end
			TRB.Functions.BarText:UpdateResourceBarText(specSettings, refreshText)
		elseif specId == 2 then
			local specSettings = classSettings.enhancement
			UpdateSnapshot_Enhancement()
			TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specSettings, TRB.Frames.barContainerFrame)

			if TRB.Data.snapshot.isTracking then
				TRB.Functions.Bar:HideResourceBar()

				if specSettings.displayBar.neverShow == false then
					refreshText = true
					local barColor = specSettings.colors.bar.base
					local barBorderColor = specSettings.colors.bar.border

					TRB.Functions.Bar:SetValue(specSettings, resourceFrame, TRB.Data.snapshot.resource)
					TRB.Functions.Bar:SetValue(specSettings, castingFrame, 0, 1)
					TRB.Functions.Bar:SetValue(specSettings, passiveFrame, 0, 1)

					barContainerFrame:SetAlpha(1.0)

					barBorderFrame:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(barBorderColor, true))
					
					if TRB.Data.snapshot.ascendance.remainingTime > 0 then
						local timeLeft = TRB.Data.snapshot.ascendance.remainingTime
						local timeThreshold = 0
						local useEndOfAscendanceColor = false

						if specSettings.endOfAscendance.enabled then
							useEndOfAscendanceColor = true
							if specSettings.endOfAscendance.mode == "gcd" then
								local gcd = TRB.Functions.Character:GetCurrentGCDTime()
								timeThreshold = gcd * specSettings.endOfAscendance.gcdsMax
							elseif specSettings.endOfAscendance.mode == "time" then
								timeThreshold = specSettings.endOfAscendance.timeMax
							end
						end

						if useEndOfAscendanceColor and timeLeft <= timeThreshold then
							barColor = specSettings.colors.bar.inAscendance1GCD
						else
							barColor = specSettings.colors.bar.inAscendance
						end
					end

					resourceFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(barColor, true))

					--[[
					local partial = UnitPartialPower("player", Enum.PowerType.Essence) / 1000
					local totalEssence = math.min(partial + TRB.Data.snapshot.resource2, TRB.Data.character.maxResource2Raw)
					--print(partial, partial + TRB.Data.snapshot.resource2, TRB.Data.snapshot.resource2)

					TRB.Frames.resource2Frames[1].resourceFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.comboPoints.base, true))
					TRB.Frames.resource2Frames[1].borderFrame:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.comboPoints.border, true))
					TRB.Frames.resource2Frames[1].containerFrame:SetBackdropColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.comboPoints.background, true))
					TRB.Functions.Bar:SetValue(specSettings, TRB.Frames.resource2Frames[1].resourceFrame, totalEssence, TRB.Data.character.maxResource2Raw)
					]]
					
					local cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha = TRB.Functions.Color:GetRGBAFromString(specSettings.colors.comboPoints.background, true)
					for x = 1, TRB.Data.character.maxResource2 do
						local cpBorderColor = specSettings.colors.comboPoints.border
						local cpColor = specSettings.colors.comboPoints.base
						local cpBR = cpBackgroundRed
						local cpBG = cpBackgroundGreen
						local cpBB = cpBackgroundBlue

						if TRB.Data.snapshot.resource2 >= x then
							TRB.Functions.Bar:SetValue(specSettings, TRB.Frames.resource2Frames[x].resourceFrame, 1, 1)
							if (specSettings.comboPoints.sameColor and TRB.Data.snapshot.resource2 == (TRB.Data.character.maxResource2 - 1)) or (not specSettings.comboPoints.sameColor and x == (TRB.Data.character.maxResource2 - 1)) then
								cpColor = specSettings.colors.comboPoints.penultimate
							elseif (specSettings.comboPoints.sameColor and TRB.Data.snapshot.resource2 == (TRB.Data.character.maxResource2)) or x == TRB.Data.character.maxResource2 then
								cpColor = specSettings.colors.comboPoints.final
							end
						elseif TRB.Data.snapshot.resource2+1 == x then
							local partial = UnitPartialPower("player", Enum.PowerType.Essence)
							TRB.Functions.Bar:SetValue(specSettings, TRB.Frames.resource2Frames[x].resourceFrame, partial, 1000)
						else
							TRB.Functions.Bar:SetValue(specSettings, TRB.Frames.resource2Frames[x].resourceFrame, 0, 1)
						end

						TRB.Frames.resource2Frames[x].resourceFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(cpColor, true))
						TRB.Frames.resource2Frames[x].borderFrame:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(cpBorderColor, true))
						TRB.Frames.resource2Frames[x].containerFrame:SetBackdropColor(cpBR, cpBG, cpBB, cpBackgroundAlpha)
					end
				end
			end
			TRB.Functions.BarText:UpdateResourceBarText(specSettings, refreshText)
		elseif specId == 3 then
			local specSettings = classSettings.restoration
			UpdateSnapshot_Restoration()
			TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specSettings, TRB.Frames.barContainerFrame)
			if TRB.Data.snapshot.isTracking then
				TRB.Functions.Bar:HideResourceBar()

				if specSettings.displayBar.neverShow == false then
					refreshText = true
					local passiveBarValue = 0
					local castingBarValue = 0
					local currentMana = TRB.Data.snapshot.resource / TRB.Data.resourceFactor
					local barBorderColor = specSettings.colors.bar.border

					if TRB.Data.snapshot.potionOfChilledClarity.isActive then
						if specSettings.colors.bar.potionOfChilledClarityBorderChange then
							barBorderColor = specSettings.colors.bar.potionOfChilledClarity
						end
					elseif TRB.Data.snapshot.innervate.isActive then
						if specSettings.colors.bar.innervateBorderChange then
							barBorderColor = specSettings.colors.bar.innervate
						end

						if specSettings.audio.innervate.enabled and TRB.Data.snapshot.audio.innervateCue == false then
							TRB.Data.snapshot.audio.innervateCue = true
---@diagnostic disable-next-line: redundant-parameter
							PlaySoundFile(specSettings.audio.innervate.sound, coreSettings.audio.channel.channel)
						end
					end

					barBorderFrame:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(barBorderColor, true))

					TRB.Functions.Bar:SetValue(specSettings, resourceFrame, currentMana)

					if CastingSpell() and specSettings.bar.showCasting  then
						castingBarValue = currentMana + TRB.Data.snapshot.casting.resourceFinal
					else
						castingBarValue = currentMana
					end

					TRB.Functions.Bar:SetValue(specSettings, castingFrame, castingBarValue)

					TRB.Functions.Threshold:ManageCommonHealerThresholds(currentMana, castingBarValue, specSettings, TRB.Data.snapshot.potion, TRB.Data.snapshot.conjuredChillglobe, TRB.Data.character, resourceFrame, CalculateManaGain)

					local passiveValue = 0
					if specSettings.bar.showPassive then
						if TRB.Data.snapshot.channeledManaPotion.isActive then
							passiveValue = passiveValue + TRB.Data.snapshot.channeledManaPotion.mana
		
							if (castingBarValue + passiveValue) < TRB.Data.character.maxResource then
								TRB.Functions.Threshold:RepositionThreshold(specSettings, TRB.Frames.passiveFrame.thresholds[1], passiveFrame, specSettings.thresholds.width, (passiveValue + castingBarValue), TRB.Data.character.maxResource)
		---@diagnostic disable-next-line: undefined-field
								TRB.Frames.passiveFrame.thresholds[1].texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.threshold.mindbender, true))
								TRB.Frames.passiveFrame.thresholds[1]:Show()
							else
								TRB.Frames.passiveFrame.thresholds[1]:Hide()
							end
						else
							TRB.Frames.passiveFrame.thresholds[1]:Hide()
						end

						if TRB.Data.snapshot.innervate.mana > 0 or TRB.Data.snapshot.potionOfChilledClarity.mana > 0 then
							passiveValue = passiveValue + math.max(TRB.Data.snapshot.innervate.mana, TRB.Data.snapshot.potionOfChilledClarity.mana)
		
							if (castingBarValue + passiveValue) < TRB.Data.character.maxResource then
								TRB.Functions.Threshold:RepositionThreshold(specSettings, TRB.Frames.passiveFrame.thresholds[1], passiveFrame, specSettings.thresholds.width, (passiveValue + castingBarValue), TRB.Data.character.maxResource)
---@diagnostic disable-next-line: undefined-field
								TRB.Frames.passiveFrame.thresholds[1].texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.threshold.mindbender, true))
								TRB.Frames.passiveFrame.thresholds[1]:Show()
							else
								TRB.Frames.passiveFrame.thresholds[1]:Hide()
							end
						else
							TRB.Frames.passiveFrame.thresholds[1]:Hide()
						end

						if TRB.Data.snapshot.innervate.mana > 0 then
							passiveValue = passiveValue + TRB.Data.snapshot.innervate.mana

							if (castingBarValue + passiveValue) < TRB.Data.character.maxResource then
								TRB.Functions.Threshold:RepositionThreshold(specSettings, TRB.Frames.passiveFrame.thresholds[2], passiveFrame, specSettings.thresholds.width, (passiveValue + castingBarValue), TRB.Data.character.maxResource)
---@diagnostic disable-next-line: undefined-field
								TRB.Frames.passiveFrame.thresholds[2].texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.threshold.mindbender, true))
								TRB.Frames.passiveFrame.thresholds[2]:Show()
							else
								TRB.Frames.passiveFrame.thresholds[2]:Hide()
							end
						else
							TRB.Frames.passiveFrame.thresholds[2]:Hide()
						end

						if TRB.Data.snapshot.symbolOfHope.resourceFinal > 0 then
							passiveValue = passiveValue + TRB.Data.snapshot.symbolOfHope.resourceFinal

							if (castingBarValue + passiveValue) < TRB.Data.character.maxResource then
								TRB.Functions.Threshold:RepositionThreshold(specSettings, TRB.Frames.passiveFrame.thresholds[3], passiveFrame, specSettings.thresholds.width, (passiveValue + castingBarValue), TRB.Data.character.maxResource)
---@diagnostic disable-next-line: undefined-field
								TRB.Frames.passiveFrame.thresholds[3].texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.threshold.mindbender, true))
								TRB.Frames.passiveFrame.thresholds[3]:Show()
							else
								TRB.Frames.passiveFrame.thresholds[3]:Hide()
							end
						else
							TRB.Frames.passiveFrame.thresholds[3]:Hide()
						end

						if TRB.Data.snapshot.manaTideTotem.mana > 0 then
							passiveValue = passiveValue + TRB.Data.snapshot.manaTideTotem.mana

							if (castingBarValue + passiveValue) < TRB.Data.character.maxResource then
								TRB.Functions.Threshold:RepositionThreshold(specSettings, TRB.Frames.passiveFrame.thresholds[4], passiveFrame, specSettings.thresholds.width, (passiveValue + castingBarValue), TRB.Data.character.maxResource)
---@diagnostic disable-next-line: undefined-field
								TRB.Frames.passiveFrame.thresholds[4].texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.threshold.mindbender, true))
								TRB.Frames.passiveFrame.thresholds[4]:Show()
							else
								TRB.Frames.passiveFrame.thresholds[4]:Hide()
							end
						else
							TRB.Frames.passiveFrame.thresholds[4]:Hide()
						end

						if TRB.Data.snapshot.moltenRadiance.mana > 0 then
							passiveValue = passiveValue + TRB.Data.snapshot.moltenRadiance.mana

							if (castingBarValue + passiveValue) < TRB.Data.character.maxResource then
								TRB.Functions.Threshold:RepositionThreshold(specSettings, TRB.Frames.passiveFrame.thresholds[5], passiveFrame, specSettings.thresholds.width, (passiveValue + castingBarValue), TRB.Data.character.maxResource)
---@diagnostic disable-next-line: undefined-field
								TRB.Frames.passiveFrame.thresholds[5].texture:SetColorTexture(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.threshold.mindbender, true))
								TRB.Frames.passiveFrame.thresholds[5]:Show()
							else
								TRB.Frames.passiveFrame.thresholds[5]:Hide()
							end
						else
							TRB.Frames.passiveFrame.thresholds[5]:Hide()
						end
					else
						TRB.Frames.passiveFrame.thresholds[1]:Hide()
						TRB.Frames.passiveFrame.thresholds[2]:Hide()
						TRB.Frames.passiveFrame.thresholds[3]:Hide()
						TRB.Frames.passiveFrame.thresholds[4]:Hide()
						TRB.Frames.passiveFrame.thresholds[5]:Hide()
					end

					passiveBarValue = castingBarValue + passiveValue
					if castingBarValue < TRB.Data.snapshot.resource then --Using a spender
						if -TRB.Data.snapshot.casting.resourceFinal > passiveValue then
							TRB.Functions.Bar:SetValue(specSettings, resourceFrame, castingBarValue)
							TRB.Functions.Bar:SetValue(specSettings, castingFrame, passiveBarValue)
							TRB.Functions.Bar:SetValue(specSettings, passiveFrame, TRB.Data.snapshot.resource)
							castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.passive, true))
							passiveFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.spending, true))
						else
							TRB.Functions.Bar:SetValue(specSettings, resourceFrame, castingBarValue)
							TRB.Functions.Bar:SetValue(specSettings, passiveFrame, passiveBarValue)
							TRB.Functions.Bar:SetValue(specSettings, castingFrame, TRB.Data.snapshot.resource)
							castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.spending, true))
							passiveFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.passive, true))
						end
					else
						TRB.Functions.Bar:SetValue(specSettings, resourceFrame, TRB.Data.snapshot.resource)
						TRB.Functions.Bar:SetValue(specSettings, passiveFrame, passiveBarValue)
						TRB.Functions.Bar:SetValue(specSettings, castingFrame, castingBarValue)
						castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.casting, true))
						passiveFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.passive, true))
					end

					local resourceBarColor = nil

					resourceBarColor = specSettings.colors.bar.base

					if TRB.Data.snapshot.ascendance.remainingTime > 0 then
						local timeLeft = TRB.Data.snapshot.ascendance.remainingTime
						local timeThreshold = 0
						local useEndOfAscendanceColor = false

						if specSettings.endOfAscendance.enabled then
							useEndOfAscendanceColor = true
							if specSettings.endOfAscendance.mode == "gcd" then
								local gcd = TRB.Functions.Character:GetCurrentGCDTime()
								timeThreshold = gcd * specSettings.endOfAscendance.gcdsMax
							elseif specSettings.endOfAscendance.mode == "time" then
								timeThreshold = specSettings.endOfAscendance.timeMax
							end
						end

						if useEndOfAscendanceColor and timeLeft <= timeThreshold then
							resourceBarColor = specSettings.colors.bar.inAscendance1GCD
						else
							resourceBarColor = specSettings.colors.bar.inAscendance
						end
					end

					resourceFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(resourceBarColor, true))
				end

				TRB.Functions.BarText:UpdateResourceBarText(specSettings, refreshText)
			end
		end
	end

	barContainerFrame:SetScript("OnEvent", function(self, event, ...)
		local currentTime = GetTime()
		local triggerUpdate = false
		local _
		local specId = GetSpecialization()

		if event == "COMBAT_LOG_EVENT_UNFILTERED" then
			local time, type, _, sourceGUID, sourceName, _, _, destGUID, destName, _, _, spellId, spellName = CombatLogGetCurrentEventInfo() --, _, _, _,_,_,_,_,spellcritical,_,_,_,_ = ...

			if destGUID == TRB.Data.character.guid then
				if specId == 3 and TRB.Data.barConstructedForSpec == "restoration" then -- Let's check raid effect mana stuff
					if type == "SPELL_ENERGIZE" and spellId == TRB.Data.spells.symbolOfHope.tickId then
						TRB.Data.snapshot.symbolOfHope.isActive = true
						if TRB.Data.snapshot.symbolOfHope.firstTickTime == nil then
							TRB.Data.snapshot.symbolOfHope.firstTickTime = currentTime
							TRB.Data.snapshot.symbolOfHope.previousTickTime = currentTime
							TRB.Data.snapshot.symbolOfHope.ticksRemaining = TRB.Data.spells.symbolOfHope.ticks
							TRB.Data.snapshot.symbolOfHope.tickRate = (TRB.Data.spells.symbolOfHope.duration / TRB.Data.spells.symbolOfHope.ticks)
							TRB.Data.snapshot.symbolOfHope.endTime = currentTime + TRB.Data.spells.symbolOfHope.duration
						else
							if TRB.Data.snapshot.symbolOfHope.ticksRemaining >= 1 then
								if sourceGUID ~= TRB.Data.character.guid then
									if not TRB.Data.snapshot.symbolOfHope.tickRateFound then
										TRB.Data.snapshot.symbolOfHope.tickRate = currentTime - TRB.Data.snapshot.symbolOfHope.previousTickTime
										TRB.Data.snapshot.symbolOfHope.tickRateFound = true
										TRB.Data.snapshot.symbolOfHope.endTime = currentTime + (TRB.Data.snapshot.symbolOfHope.tickRate * (TRB.Data.snapshot.symbolOfHope.ticksRemaining - 1))
									end

									if TRB.Data.snapshot.symbolOfHope.tickRate > (1.75 * 1.5) then -- Assume if its taken this long for a tick to happen, the rate is really half this and one was missed
										TRB.Data.snapshot.symbolOfHope.tickRate = TRB.Data.snapshot.symbolOfHope.tickRate / 2
										TRB.Data.snapshot.symbolOfHope.endTime = currentTime + (TRB.Data.snapshot.symbolOfHope.tickRate * (TRB.Data.snapshot.symbolOfHope.ticksRemaining - 2))
										TRB.Data.snapshot.symbolOfHope.tickRateFound = false
									end
								end
							end
							TRB.Data.snapshot.symbolOfHope.previousTickTime = currentTime
						end
						TRB.Data.snapshot.symbolOfHope.resourceRaw = TRB.Data.snapshot.symbolOfHope.ticksRemaining * TRB.Data.spells.symbolOfHope.manaPercent * TRB.Data.character.maxResource
						TRB.Data.snapshot.symbolOfHope.resourceFinal = CalculateManaGain(TRB.Data.snapshot.symbolOfHope.resourceRaw, false)
					elseif spellId == TRB.Data.spells.innervate.id then
						TRB.Functions.Aura:SnapshotGenericAura(spellId, type, TRB.Data.snapshot.innervate)
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then
							TRB.Data.snapshot.innervate.modifier = 0
							TRB.Data.snapshot.audio.innervateCue = false
						elseif type == "SPELL_AURA_REMOVED" then
							TRB.Data.snapshot.innervate.modifier = 1
							TRB.Data.snapshot.audio.innervateCue = false
						end
					elseif spellId == TRB.Data.spells.manaTideTotem.id then
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Gained buff or refreshed
							TRB.Data.snapshot.manaTideTotem.isActive = true
							TRB.Data.snapshot.manaTideTotem.duration = TRB.Data.spells.manaTideTotem.duration
							TRB.Data.snapshot.manaTideTotem.endTime = TRB.Data.spells.manaTideTotem.duration + currentTime
							TRB.Data.snapshot.audio.manaTideTotemCue = false
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							TRB.Data.snapshot.manaTideTotem.isActive = false
							TRB.Data.snapshot.manaTideTotem.spellId = nil
							TRB.Data.snapshot.manaTideTotem.duration = 0
							TRB.Data.snapshot.manaTideTotem.endTime = nil
							TRB.Data.snapshot.audio.manaTideTotemCue = false
						end
					elseif spellId == TRB.Data.spells.moltenRadiance.id then
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then
							local _
							_, _, _, _, TRB.Data.snapshot.moltenRadiance.duration, TRB.Data.snapshot.moltenRadiance.endTime, _, _, _, TRB.Data.snapshot.moltenRadiance.spellId, _, _, _, _, _, _, _, TRB.Data.snapshot.moltenRadiance.manaPerTick = TRB.Functions.Aura:FindBuffById(TRB.Data.spells.moltenRadiance.id)
							TRB.Data.snapshot.moltenRadiance.isActive = false
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							TRB.Data.snapshot.moltenRadiance.isActive = false
							TRB.Data.snapshot.moltenRadiance.spellId = nil
							TRB.Data.snapshot.moltenRadiance.duration = 0
							TRB.Data.snapshot.moltenRadiance.endTime = nil
							TRB.Data.snapshot.moltenRadiance.manaPerTick = 0
							TRB.Data.snapshot.moltenRadiance.mana = 0
						end
					end
				end
			end

			if sourceGUID == TRB.Data.character.guid then
				if specId == 1 and TRB.Data.barConstructedForSpec == "elemental" then
					if spellId == TRB.Data.spells.chainLightning.id or spellId == TRB.Data.spells.lavaBeam.id then
						if type == "SPELL_DAMAGE" then
							if TRB.Data.snapshot.chainLightning.hitTime == nil or currentTime > (TRB.Data.snapshot.chainLightning.hitTime + 0.1) then --This is a new hit
								TRB.Data.snapshot.chainLightning.targetsHit = 0
							end
							TRB.Data.snapshot.chainLightning.targetsHit = TRB.Data.snapshot.chainLightning.targetsHit + 1
							TRB.Data.snapshot.chainLightning.hitTime = currentTime
							TRB.Data.snapshot.chainLightning.hasStruckTargets = true
						end
					elseif spellId == TRB.Data.spells.icefury.id then
						if type == "SPELL_AURA_APPLIED" then -- Icefury
							TRB.Data.snapshot.icefury.isActive = true
							TRB.Data.snapshot.icefury.stacks = TRB.Data.spells.icefury.stacks
							TRB.Data.snapshot.icefury.maelstrom = TRB.Data.snapshot.icefury.stacks * TRB.Data.spells.frostShock.maelstrom
							TRB.Data.snapshot.icefury.startTime = currentTime
						elseif type == "SPELL_AURA_REMOVED" then
							TRB.Data.snapshot.icefury.isActive = false
							TRB.Data.snapshot.icefury.stacks = 0
							TRB.Data.snapshot.icefury.maelstrom = 0
							TRB.Data.snapshot.icefury.startTime = nil
						elseif type == "SPELL_AURA_REMOVED_DOSE" then
							TRB.Data.snapshot.icefury.stacks = TRB.Data.snapshot.icefury.stacks - 1
							TRB.Data.snapshot.icefury.maelstrom = TRB.Data.snapshot.icefury.stacks * TRB.Data.spells.frostShock.maelstrom
						end
					elseif spellId == TRB.Data.spells.stormkeeper.id then
						if type == "SPELL_AURA_APPLIED" then -- Stormkeeper
							TRB.Data.snapshot.stormkeeper.isActive = true
							UpdateStormkeeper()
						elseif type == "SPELL_AURA_REMOVED" then
							TRB.Data.snapshot.stormkeeper.isActive = false
							UpdateStormkeeper()
						elseif type == "SPELL_AURA_REMOVED_DOSE" then
							UpdateStormkeeper()
						end
					elseif spellId == TRB.Data.spells.surgeOfPower.id then
						TRB.Functions.Aura:SnapshotGenericAura(spellId, type, TRB.Data.snapshot.surgeOfPower, true)
					elseif spellId == TRB.Data.spells.powerOfTheMaelstrom.id then
						TRB.Functions.Aura:SnapshotGenericAura(spellId, type, TRB.Data.snapshot.powerOfTheMaelstrom, true)
					elseif spellId == TRB.Data.spells.echoesOfGreatSundering.id then
						TRB.Functions.Aura:SnapshotGenericAura(spellId, type, TRB.Data.snapshot.echoesOfGreatSundering)
					elseif spellId == TRB.Data.spells.primalFracture.id then
						TRB.Functions.Aura:SnapshotGenericAura(spellId, type, TRB.Data.snapshot.primalFracture)
					end					
				elseif specId == 2 and TRB.Data.barConstructedForSpec == "enhancement" then
				elseif specId == 3 and TRB.Data.barConstructedForSpec == "restoration" then
					if spellId == TRB.Data.spells.symbolOfHope.id then
						if type == "SPELL_AURA_REMOVED" then -- Lost Symbol of Hope
							-- Let UpdateSymbolOfHope() clean this up
							UpdateSymbolOfHope(true)
						end
					elseif spellId == TRB.Data.spells.potionOfFrozenFocusRank1.spellId then
						if type == "SPELL_AURA_APPLIED" then -- Gain Potion of Frozen Focus
							TRB.Data.snapshot.channeledManaPotion.spellKey = "potionOfFrozenFocusRank1"
							TRB.Data.snapshot.channeledManaPotion.isActive = true
							TRB.Data.snapshot.channeledManaPotion.ticksRemaining = TRB.Data.spells.potionOfFrozenFocusRank1.ticks
							TRB.Data.snapshot.channeledManaPotion.mana = TRB.Data.snapshot.channeledManaPotion.ticksRemaining * CalculateManaGain(TRB.Data.spells.potionOfFrozenFocusRank1.mana, true)
							TRB.Data.snapshot.channeledManaPotion.endTime = currentTime + TRB.Data.spells.potionOfFrozenFocusRank1.duration
						elseif type == "SPELL_AURA_REMOVED" then -- Lost Potion of Frozen Focus channel
							-- Let UpdateChanneledManaPotion() clean this up
							UpdateChanneledManaPotion(true)
						end
					elseif spellId == TRB.Data.spells.potionOfFrozenFocusRank2.spellId then
						if type == "SPELL_AURA_APPLIED" then -- Gain Potion of Frozen Focus
							TRB.Data.snapshot.channeledManaPotion.spellKey = "potionOfFrozenFocusRank2"
							TRB.Data.snapshot.channeledManaPotion.isActive = true
							TRB.Data.snapshot.channeledManaPotion.ticksRemaining = TRB.Data.spells.potionOfFrozenFocusRank2.ticks
							TRB.Data.snapshot.channeledManaPotion.mana = TRB.Data.snapshot.channeledManaPotion.ticksRemaining * CalculateManaGain(TRB.Data.spells.potionOfFrozenFocusRank2.mana, true)
							TRB.Data.snapshot.channeledManaPotion.endTime = currentTime + TRB.Data.spells.potionOfFrozenFocusRank2.duration
						elseif type == "SPELL_AURA_REMOVED" then -- Lost Potion of Frozen Focus channel
							-- Let UpdateChanneledManaPotion() clean this up
							UpdateChanneledManaPotion(true)
						end
					elseif spellId == TRB.Data.spells.potionOfFrozenFocusRank3.spellId then
						if type == "SPELL_AURA_APPLIED" then -- Gain Potion of Frozen Focus
							TRB.Data.snapshot.channeledManaPotion.spellKey = "potionOfFrozenFocusRank3"
							TRB.Data.snapshot.channeledManaPotion.isActive = true
							TRB.Data.snapshot.channeledManaPotion.ticksRemaining = TRB.Data.spells.potionOfFrozenFocusRank3.ticks
							TRB.Data.snapshot.channeledManaPotion.mana = TRB.Data.snapshot.channeledManaPotion.ticksRemaining * CalculateManaGain(TRB.Data.spells.potionOfFrozenFocusRank3.mana, true)
							TRB.Data.snapshot.channeledManaPotion.endTime = currentTime + TRB.Data.spells.potionOfFrozenFocusRank3.duration
						elseif type == "SPELL_AURA_REMOVED" then -- Lost Potion of Frozen Focus channel
							-- Let UpdateChanneledManaPotion() clean this up
							UpdateChanneledManaPotion(true)
						end			
					elseif spellId == TRB.Data.spells.potionOfChilledClarity.id then
						TRB.Functions.Aura:SnapshotGenericAura(spellId, type, TRB.Data.snapshot.potionOfChilledClarity)
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then
							TRB.Data.snapshot.potionOfChilledClarity.modifier = 0
						elseif type == "SPELL_AURA_REMOVED" then
							TRB.Data.snapshot.potionOfChilledClarity.modifier = 1
						end
					end
				end

				-- Spec agnostic abilities
				if spellId == TRB.Data.spells.ascendance.id then
					TRB.Functions.Aura:SnapshotGenericAura(spellId, type, TRB.Data.snapshot.ascendance)
				elseif spellId == TRB.Data.spells.flameShock.id then
					if TRB.Functions.Class:InitializeTarget(destGUID) then
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- FS Applied to Target
							TRB.Data.snapshot.targetData.targets[destGUID].flameShock = true
							if type == "SPELL_AURA_APPLIED" then
								TRB.Data.snapshot.targetData.flameShock = TRB.Data.snapshot.targetData.flameShock + 1
							end
							triggerUpdate = true
						elseif type == "SPELL_AURA_REMOVED" then
							TRB.Data.snapshot.targetData.targets[destGUID].flameShock = false
							TRB.Data.snapshot.targetData.targets[destGUID].flameShockRemaining = 0
							TRB.Data.snapshot.targetData.flameShock = TRB.Data.snapshot.targetData.flameShock - 1
							triggerUpdate = true
						--elseif type == "SPELL_PERIODIC_DAMAGE" then
						end
					end
				end
			end

			if destGUID ~= TRB.Data.character.guid and (type == "UNIT_DIED" or type == "UNIT_DESTROYED" or type == "SPELL_INSTAKILL") then -- Unit Died, remove them from the target list.
				TRB.Functions.Target:RemoveTarget(destGUID)
				RefreshTargetTracking()
				triggerUpdate = true
			end

			if UnitIsDeadOrGhost("player") then -- We died/are dead go ahead and purge the list
				TargetsCleanup(true)
				triggerUpdate = true
			end
		end

		if triggerUpdate then
			TRB.Functions.Class:TriggerResourceBarUpdates()
		end
	end)

	function targetsTimerFrame:onUpdate(sinceLastUpdate)
		local currentTime = GetTime()
		self.sinceLastUpdate = self.sinceLastUpdate + sinceLastUpdate
		if self.sinceLastUpdate >= 1 then -- in seconds
			TargetsCleanup()
			RefreshTargetTracking()
			TRB.Functions.Class:TriggerResourceBarUpdates()
			self.sinceLastUpdate = 0
		end
	end

	combatFrame:SetScript("OnEvent", function(self, event, ...)
		if event =="PLAYER_REGEN_DISABLED" then
			TRB.Functions.Bar:ShowResourceBar()
		else
			TRB.Functions.Bar:HideResourceBar()
		end
	end)

	local function SwitchSpec()
		barContainerFrame:UnregisterEvent("UNIT_POWER_FREQUENT")
		barContainerFrame:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		local specId = GetSpecialization()
		if specId == 1 then
			TRB.Functions.Bar:UpdateSanityCheckValues(TRB.Data.settings.shaman.elemental)
			TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.shaman.elemental)
			specCache.elemental.talents = TRB.Functions.Talent:GetTalents()
			FillSpellData_Elemental()
			TRB.Functions.Character:LoadFromSpecializationCache(specCache.elemental)
			TRB.Functions.RefreshLookupData = RefreshLookupData_Elemental

			if TRB.Data.barConstructedForSpec ~= "elemental" then
				TRB.Data.barConstructedForSpec = "elemental"
				ConstructResourceBar(specCache.elemental.settings)
			end
		elseif specId == 2 then-- and TRB.Data.settings.core.experimental.specs.shaman.enhancement then
			TRB.Functions.Bar:UpdateSanityCheckValues(TRB.Data.settings.shaman.enhancement)
			TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.shaman.enhancement)
			specCache.enhancement.talents = TRB.Functions.Talent:GetTalents()
			FillSpellData_Enhancement()
			TRB.Functions.Character:LoadFromSpecializationCache(specCache.enhancement)
			TRB.Functions.RefreshLookupData = RefreshLookupData_Enhancement

			if TRB.Data.barConstructedForSpec ~= "enhancement" then
				TRB.Data.barConstructedForSpec = "enhancement"
				ConstructResourceBar(specCache.enhancement.settings)
			end
		elseif specId == 3 then
			TRB.Functions.Bar:UpdateSanityCheckValues(TRB.Data.settings.shaman.restoration)
			TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.shaman.restoration)
			specCache.restoration.talents = TRB.Functions.Talent:GetTalents()
			FillSpellData_Restoration()
			TRB.Functions.Character:LoadFromSpecializationCache(specCache.restoration)
			TRB.Functions.RefreshLookupData = RefreshLookupData_Restoration

			if TRB.Data.barConstructedForSpec ~= "restoration" then
				TRB.Data.barConstructedForSpec = "restoration"
				ConstructResourceBar(specCache.restoration.settings)
			end
		else
			TRB.Data.barConstructedForSpec = nil
		end
		TRB.Functions.Class:EventRegistration()
	end

	resourceFrame:RegisterEvent("ADDON_LOADED")
	resourceFrame:RegisterEvent("TRAIT_CONFIG_UPDATED")
	resourceFrame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
	resourceFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
	resourceFrame:RegisterEvent("PLAYER_LOGOUT") -- Fired when about to log out
	resourceFrame:SetScript("OnEvent", function(self, event, arg1, ...)
		local specId = GetSpecialization() or 0
		if classIndexId == 7 then
			if (event == "ADDON_LOADED" and arg1 == "TwintopInsanityBar") then
				if not TRB.Details.addonData.loaded then
					TRB.Details.addonData.loaded = true

					local settings = TRB.Options.Shaman.LoadDefaultSettings()
					if TwintopInsanityBarSettings then
						TRB.Options:PortForwardSettings()
						TRB.Data.settings = TRB.Functions.Table:Merge(settings, TwintopInsanityBarSettings)
						TRB.Data.settings = TRB.Options:CleanupSettings(TRB.Data.settings)
					else
						TRB.Data.settings = settings
					end
					FillSpecializationCache()

					SLASH_TWINTOP1 	= "/twintop"
					SLASH_TWINTOP2 	= "/tt"
					SLASH_TWINTOP3 	= "/tib"
					SLASH_TWINTOP4 	= "/tit"
					SLASH_TWINTOP5 	= "/ttib"
					SLASH_TWINTOP6 	= "/ttit"
					SLASH_TWINTOP7 	= "/trb"
					SLASH_TWINTOP8 	= "/trt"
					SLASH_TWINTOP9 	= "/ttrt"
					SLASH_TWINTOP10 = "/ttrb"
				end
			end

			if event == "PLAYER_LOGOUT" then
				TwintopInsanityBarSettings = TRB.Data.settings
			end

			if TRB.Details.addonData.loaded and specId > 0 then
				if not TRB.Details.addonData.optionsPanel then
					TRB.Details.addonData.optionsPanel = true
					-- To prevent false positives for missing LSM values, delay creation a bit to let other addons finish loading.
					C_Timer.After(0, function()
						C_Timer.After(1, function()
							TRB.Data.barConstructedForSpec = nil
							TRB.Data.settings.shaman.elemental = TRB.Functions.LibSharedMedia:ValidateLsmValues("Elemental Shaman", TRB.Data.settings.shaman.elemental)
							TRB.Data.settings.shaman.enhancement = TRB.Functions.LibSharedMedia:ValidateLsmValues("Elemental Shaman", TRB.Data.settings.shaman.enhancement)
							TRB.Data.settings.shaman.restoration = TRB.Functions.LibSharedMedia:ValidateLsmValues("Restoration Shaman", TRB.Data.settings.shaman.restoration)
							FillSpellData_Elemental()
							FillSpellData_Enhancement()
							FillSpellData_Restoration()

							SwitchSpec()
							TRB.Options.Shaman.ConstructOptionsPanel(specCache)
							-- Reconstruct just in case
							if TRB.Data.barConstructedForSpec and specCache[TRB.Data.barConstructedForSpec] and specCache[TRB.Data.barConstructedForSpec].settings then
								ConstructResourceBar(specCache[TRB.Data.barConstructedForSpec].settings)
							end
							TRB.Functions.Class:EventRegistration()
							TRB.Functions.News:Init()
						end)
					end)
				end

				if event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_SPECIALIZATION_CHANGED" or event == "TRAIT_CONFIG_UPDATED" then
					SwitchSpec()
				end
			end
		end
	end)

	function TRB.Functions.Class:CheckCharacter()
		local specId = GetSpecialization()
		TRB.Functions.Character:CheckCharacter()
		TRB.Data.character.className = "shaman"
		
		if specId == 1 then
			TRB.Data.character.specName = "elemental"
---@diagnostic disable-next-line: missing-parameter
			TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.Maelstrom)

			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[TRB.Data.spells.earthShock.thresholdId], TRB.Data.spells.earthShock.settingKey, TRB.Data.settings.shaman.elemental)
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[TRB.Data.spells.elementalBlast.thresholdId], TRB.Data.spells.elementalBlast.settingKey, TRB.Data.settings.shaman.elemental)

			if (TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.elementalBlast) and TRB.Data.spells.elementalBlast.maelstrom < TRB.Data.character.maxResource) then
				TRB.Data.character.earthShockThreshold = -(TRB.Data.spells.elementalBlast.maelstrom - TRB.Data.spells.eyeOfTheStorm.maelstromMod[TRB.Data.talents[TRB.Data.spells.eyeOfTheStorm.id].currentRank].elementalBlast)
			else
				TRB.Data.character.earthShockThreshold = -(TRB.Data.spells.earthShock.maelstrom - TRB.Data.spells.eyeOfTheStorm.maelstromMod[TRB.Data.talents[TRB.Data.spells.eyeOfTheStorm.id].currentRank].earthShock)
			end
		elseif specId == 2 and TRB.Data.settings.core.experimental.specs.shaman.enhancement then
			TRB.Data.character.specName = "enhancement"
			local maxComboPoints = 10
			if maxComboPoints ~= TRB.Data.character.maxResource2 then
				TRB.Data.character.maxResource2 = maxComboPoints
				TRB.Functions.Bar:SetPosition(TRB.Data.settings.shaman.enhancement, TRB.Frames.barContainerFrame)
			end
		elseif specId == 3 then
			TRB.Data.character.specName = "restoration"
---@diagnostic disable-next-line: missing-parameter
			TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.Mana)
			TRB.Functions.Spell:FillSpellDataManaCost(TRB.Data.spells)

			local trinket1ItemLink = GetInventoryItemLink("player", 13)
			local trinket2ItemLink = GetInventoryItemLink("player", 14)

			local alchemyStone = false
			local conjuredChillglobe = false
			local conjuredChillglobeVersion = ""
						
			if trinket1ItemLink ~= nil then
				for x = 1, TRB.Functions.Table:Length(TRB.Data.spells.alchemistStone.itemIds) do
					if alchemyStone == false then
						alchemyStone = TRB.Functions.Item:DoesItemLinkMatchId(trinket1ItemLink, TRB.Data.spells.alchemistStone.itemIds[x])
					else
						break
					end
				end

				if alchemyStone == false then
					conjuredChillglobe, conjuredChillglobeVersion = TRB.Functions.Item:CheckTrinketForConjuredChillglobe(trinket1ItemLink)
				end
			end

			if alchemyStone == false and trinket2ItemLink ~= nil then
				for x = 1, TRB.Functions.Table:Length(TRB.Data.spells.alchemistStone.itemIds) do
					if alchemyStone == false then
						alchemyStone = TRB.Functions.Item:DoesItemLinkMatchId(trinket2ItemLink, TRB.Data.spells.alchemistStone.itemIds[x])
					else
						break
					end
				end
			end

			if conjuredChillglobe == false and trinket2ItemLink ~= nil then
				conjuredChillglobe, conjuredChillglobeVersion = TRB.Functions.Item:CheckTrinketForConjuredChillglobe(trinket2ItemLink)
			end

			TRB.Data.character.items.alchemyStone = alchemyStone
			TRB.Data.character.items.conjuredChillglobe.isEquipped = conjuredChillglobe
			TRB.Data.character.items.conjuredChillglobe.equippedVersion = conjuredChillglobeVersion
		end
	end

	function TRB.Functions.Class:EventRegistration()
		local specId = GetSpecialization()
		if specId == 1 and TRB.Data.settings.core.enabled.shaman.elemental then
			TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.shaman.elemental)
			TRB.Data.specSupported = true
			TRB.Data.resource = Enum.PowerType.Maelstrom
			TRB.Data.resourceFactor = 1
			TRB.Data.resource2 = nil
			TRB.Data.resource2Id = nil
		elseif specId == 2 and TRB.Data.settings.core.enabled.shaman.enhancement then
			TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.shaman.enhancement)
			TRB.Data.specSupported = true
			TRB.Data.resource = Enum.PowerType.Mana
			TRB.Data.resourceFactor = 1
			TRB.Data.resource2 = "CUSTOM"
			TRB.Data.resource2Id = 344179
			TRB.Data.resource2Factor = 1
		elseif specId == 3 and TRB.Data.settings.core.enabled.shaman.restoration then
			TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.shaman.restoration)
			TRB.Data.specSupported = true
			TRB.Data.resource = Enum.PowerType.Mana
			TRB.Data.resourceFactor = 1
			TRB.Data.resource2 = nil
			TRB.Data.resource2Id = nil
		else
			TRB.Data.specSupported = false
		end

		if TRB.Data.specSupported then
			TRB.Functions.Class:CheckCharacter()

			targetsTimerFrame:SetScript("OnUpdate", function(self, sinceLastUpdate) targetsTimerFrame:onUpdate(sinceLastUpdate) end)
			timerFrame:SetScript("OnUpdate", function(self, sinceLastUpdate) timerFrame:onUpdate(sinceLastUpdate) end)
			TRB.Frames.barContainerFrame:RegisterEvent("UNIT_POWER_FREQUENT")
			TRB.Frames.barContainerFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
			combatFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
			combatFrame:RegisterEvent("PLAYER_REGEN_ENABLED")

			TRB.Details.addonData.registered = true
		else
			--TRB.Data.resource = MANA
			TRB.Data.specSupported = false
			targetsTimerFrame:SetScript("OnUpdate", nil)
			timerFrame:SetScript("OnUpdate", nil)
			TRB.Frames.barContainerFrame:UnregisterEvent("UNIT_POWER_FREQUENT")
			TRB.Frames.barContainerFrame:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
			combatFrame:UnregisterEvent("PLAYER_REGEN_DISABLED")
			combatFrame:UnregisterEvent("PLAYER_REGEN_ENABLED")
			TRB.Details.addonData.registered = false
			TRB.Frames.barContainerFrame:Hide()
		end
		TRB.Functions.Bar:HideResourceBar()
	end

	function TRB.Functions.Class:HideResourceBar(force)
		local affectingCombat = UnitAffectingCombat("player")
		local specId = GetSpecialization()

		if specId == 1 then
			if not TRB.Data.specSupported or force or GetSpecialization() ~= 1 or ((not affectingCombat) and
				(not UnitInVehicle("player")) and (
					(not TRB.Data.settings.shaman.elemental.displayBar.alwaysShow) and (
						(not TRB.Data.settings.shaman.elemental.displayBar.notZeroShow) or
						(TRB.Data.settings.shaman.elemental.displayBar.notZeroShow and TRB.Data.snapshot.resource == 0)
					)
				)) then
				TRB.Frames.barContainerFrame:Hide()
				TRB.Data.snapshot.isTracking = false
			else
				TRB.Data.snapshot.isTracking = true
				if TRB.Data.settings.shaman.elemental.displayBar.neverShow == true then
					TRB.Frames.barContainerFrame:Hide()
				else
					TRB.Frames.barContainerFrame:Show()
				end
			end
		elseif specId == 2 then
			if not TRB.Data.specSupported or force or ((not affectingCombat) and
				(not UnitInVehicle("player")) and (
					(not TRB.Data.settings.shaman.enhancement.displayBar.alwaysShow) and (
						(not TRB.Data.settings.shaman.enhancement.displayBar.notZeroShow) or
						(TRB.Data.settings.shaman.enhancement.displayBar.notZeroShow and TRB.Data.snapshot.resource == TRB.Data.character.maxResource and TRB.Data.snapshot.resource2 == 0)
					)
				)) then
				TRB.Frames.barContainerFrame:Hide()
				TRB.Data.snapshot.isTracking = false
			else
				TRB.Data.snapshot.isTracking = true
				if TRB.Data.settings.shaman.enhancement.displayBar.neverShow == true then
					TRB.Frames.barContainerFrame:Hide()
				else
					TRB.Frames.barContainerFrame:Show()
				end
			end
		elseif specId == 3 then
			if not TRB.Data.specSupported or force or ((not affectingCombat) and
				(not UnitInVehicle("player")) and (
					(not TRB.Data.settings.shaman.restoration.displayBar.alwaysShow) and (
						(not TRB.Data.settings.shaman.restoration.displayBar.notZeroShow) or
						(TRB.Data.settings.shaman.restoration.displayBar.notZeroShow and TRB.Data.snapshot.resource == TRB.Data.character.maxResource)
					)
				)) then
				TRB.Frames.barContainerFrame:Hide()
				TRB.Data.snapshot.isTracking = false
			else
				TRB.Data.snapshot.isTracking = true
				if TRB.Data.settings.shaman.restoration.displayBar.neverShow == true then
					TRB.Frames.barContainerFrame:Hide()
				else
					TRB.Frames.barContainerFrame:Show()
				end
			end
		else
			TRB.Frames.barContainerFrame:Hide()
			TRB.Data.snapshot.isTracking = false
		end
	end

	function TRB.Functions.Class:InitializeTarget(guid, selfInitializeAllowed)
		if (selfInitializeAllowed == nil or selfInitializeAllowed == false) and guid == TRB.Data.character.guid then
			return false
		end

		local specId = GetSpecialization()

		if guid ~= nil and guid ~= "" then
			if not TRB.Functions.Target:CheckTargetExists(guid) then
				TRB.Functions.Target:InitializeTarget(guid)
				if specId == 1 then -- Elemental
					TRB.Data.snapshot.targetData.targets[guid].flameShock = false
					TRB.Data.snapshot.targetData.targets[guid].flameShockRemaining = 0
				elseif specId == 2 then -- Enhancement
					TRB.Data.snapshot.targetData.targets[guid].flameShock = false
					TRB.Data.snapshot.targetData.targets[guid].flameShockRemaining = 0
				elseif specId == 3 then -- Restoration
					TRB.Data.snapshot.targetData.targets[guid].flameShock = false
					TRB.Data.snapshot.targetData.targets[guid].flameShockRemaining = 0
				end
			end
			TRB.Data.snapshot.targetData.targets[guid].lastUpdate = GetTime()
			return true
		end
		return false
	end

	function TRB.Functions.Class:IsValidVariableForSpec(var)
		local valid = TRB.Functions.BarText:IsValidVariableBase(var)
		if valid then
			return valid
		end
		local specId = GetSpecialization()
		local settings = nil
		if specId == 1 then
			settings = TRB.Data.settings.shaman.elemental
		elseif specId == 2 then
			settings = TRB.Data.settings.shaman.enhancement
		elseif specId == 3 then
			settings = TRB.Data.settings.shaman.restoration
		end

		if specId == 1 then
			if var == "$resource" or var == "$maelstrom" then
				if TRB.Data.snapshot.resource > 0 then
					valid = true
				end
			elseif var == "$resourceMax" or var == "$maelstromMax" then
				valid = true
			elseif var == "$resourceTotal" or var == "$maelstromTotal" then
				if TRB.Data.snapshot.resource > 0 or
					(TRB.Data.snapshot.casting.resourceRaw ~= nil and (TRB.Data.snapshot.casting.resourceRaw > 0 or TRB.Data.snapshot.casting.spellId == TRB.Data.spells.chainLightning.id or TRB.Data.snapshot.casting.spellId == TRB.Data.spells.lavaBeam.id)) then
					valid = true
				end
			elseif var == "$resourcePlusCasting" or var == "$maelstromPlusCasting" then
				if TRB.Data.snapshot.resource > 0 or
					(TRB.Data.snapshot.casting.resourceRaw ~= nil and (TRB.Data.snapshot.casting.resourceRaw > 0 or TRB.Data.snapshot.casting.spellId == TRB.Data.spells.chainLightning.id or TRB.Data.snapshot.casting.spellId == TRB.Data.spells.lavaBeam.id)) then
					valid = true
				end
			elseif var == "$overcap" or var == "$insanityOvercap" or var == "$resourceOvercap" then
				local threshold = ((TRB.Data.snapshot.resource / TRB.Data.resourceFactor) + TRB.Data.snapshot.casting.resourceFinal)
				if settings.overcap.mode == "relative" and (TRB.Data.character.maxResource + settings.overcap.relative) < threshold then
					return true
				elseif settings.overcap.mode == "fixed" and settings.overcap.fixed < threshold then
					return true
				end
			elseif var == "$resourcePlusPassive" or var == "$maelstromPlusPassive" then
				if TRB.Data.snapshot.resource > 0 then
					valid = true
				end
			elseif var == "$casting" then
				if TRB.Data.snapshot.casting.resourceRaw ~= nil and (TRB.Data.snapshot.casting.resourceRaw > 0 or TRB.Data.snapshot.casting.spellId == TRB.Data.spells.chainLightning.id) then
					valid = true
				end
			elseif var == "$passive" then
			elseif var == "$ifMaelstrom" then
				if TRB.Data.snapshot.icefury.maelstrom > 0 then
					valid = true
				end
			elseif var == "$ifStacks" then
				if TRB.Data.snapshot.icefury.stacks > 0 then
					valid = true
				end
			elseif var == "$ifTime" then
				if TRB.Data.snapshot.icefury.startTime ~= nil and TRB.Data.snapshot.icefury.startTime > 0 then
					valid = true
				end
			elseif var == "$skStacks" then
				if TRB.Data.snapshot.stormkeeper.stacks ~= nil and TRB.Data.snapshot.stormkeeper.stacks > 0 then
					valid = true
				end
			elseif var == "$skTime" then
				if TRB.Data.snapshot.stormkeeper.stacks ~= nil and TRB.Data.snapshot.stormkeeper.stacks > 0 then
					valid = true
				end
			elseif var == "$eogsTime" then
				if GetEchoesOfGreatSunderingRemainingTime() > 0 then
					valid = true
				end
			elseif var == "$pfTime" then
				if GetPrimalFractureRemainingTime() > 0 then
					valid = true
				end
			end
		elseif specId == 2 then --Enhancement
			if var == "$casting" then
				if TRB.Data.snapshot.casting.resourceRaw ~= nil and TRB.Data.snapshot.casting.resourceRaw ~= 0 then
					valid = true
				end
			elseif var == "$passive" then
				if TRB.Data.snapshot.resource < TRB.Data.character.maxResource and
					settings.generation.enabled and
					((settings.generation.mode == "time" and settings.generation.time > 0) or
					(settings.generation.mode == "gcd" and settings.generation.gcds > 0)) then
					valid = true
				end
			elseif var == "$resource" or var == "$mana" then
				if TRB.Data.snapshot.resource > 0 then
					valid = true
				end
			elseif var == "$resourceMax" or var == "$manaMax" then
				valid = true
			elseif var == "$resourceTotal" or var == "$manaTotal" then
				if TRB.Data.snapshot.resource > 0 or
					(TRB.Data.snapshot.casting.resourceRaw ~= nil and TRB.Data.snapshot.casting.resourceRaw ~= 0)
					then
					valid = true
				end
			elseif var == "$resourcePlusCasting" or var == "$manaPlusCasting" then
				if TRB.Data.snapshot.resource > 0 or
					(TRB.Data.snapshot.casting.resourceRaw ~= nil and TRB.Data.snapshot.casting.resourceRaw ~= 0) then
					valid = true
				end
			elseif var == "$resourcePlusPassive" or var == "$manaPlusPassive" then
				if TRB.Data.snapshot.resource > 0 then
					valid = true
				end
			elseif var == "$regen" or var == "$regenMana" or var == "$manaRegen" then
				if TRB.Data.snapshot.resource < TRB.Data.character.maxResource and
					((settings.generation.mode == "time" and settings.generation.time > 0) or
					(settings.generation.mode == "gcd" and settings.generation.gcds > 0)) then
					valid = true
				end
			elseif var == "$comboPoints" or var == "$maelstromWeapon" then
				valid = true
			elseif var == "$comboPointsMax"or var == "$maelstromWeaponMax" then
				valid = true
			end
		elseif specId == 3 then
			if var == "$resource" or var == "$mana" then
				valid = true
			elseif var == "$resourceMax" or var == "$manaMax" then
				valid = true
			elseif var == "$resourceTotal" or var == "$manaTotal" then
				valid = true
			elseif var == "$resourcePlusCasting" or var == "$manaPlusCasting" then
				valid = true
			elseif var == "$resourcePlusPassive" or var == "$manaPlusPassive" then
				valid = true
			elseif var == "$casting" then
				if TRB.Data.snapshot.casting.resourceRaw ~= nil and (TRB.Data.snapshot.casting.resourceRaw ~= 0) then
					valid = true
				end
			elseif var == "$passive" then
				if TRB.Functions.Class:IsValidVariableForSpec("$channeledMana") or
					TRB.Functions.Class:IsValidVariableForSpec("$sohMana") or
					TRB.Functions.Class:IsValidVariableForSpec("$innervateMana") or
					TRB.Functions.Class:IsValidVariableForSpec("$potionOfChilledClarityMana") or
					TRB.Functions.Class:IsValidVariableForSpec("$mttMana") or
					TRB.Functions.Class:IsValidVariableForSpec("$mrMana") then
					valid = true
				end
			elseif var == "$sohMana" then
				if TRB.Data.snapshot.symbolOfHope.resourceRaw > 0 then
					valid = true
				end
			elseif var == "$sohTime" then
				if TRB.Data.snapshot.symbolOfHope.isActive then
					valid = true
				end
			elseif var == "$sohTicks" then
				if TRB.Data.snapshot.symbolOfHope.isActive then
					valid = true
				end
			elseif var == "$innervateMana" then
				if TRB.Data.snapshot.innervate.mana > 0 then
					valid = true
				end
			elseif var == "$innervateTime" then
				if TRB.Data.snapshot.innervate.remainingTime > 0 then
					valid = true
				end
			elseif var == "$potionOfChilledClarityMana" then
				if TRB.Data.snapshot.potionOfChilledClarity.mana > 0 then
					valid = true
				end
			elseif var == "$potionOfChilledClarityTime" then
				if TRB.Data.snapshot.potionOfChilledClarity.remainingTime > 0 then
					valid = true
				end
			elseif var == "$mttMana" then
				if TRB.Data.snapshot.manaTideTotem.mana > 0 then
					valid = true
				end
			elseif var == "$mttTime" then
				if TRB.Data.snapshot.manaTideTotem.isActive then
					valid = true
				end
			elseif var == "$mrMana" then
				if TRB.Data.snapshot.moltenRadiance.mana > 0 then
					valid = true
				end
			elseif var == "$mrTime" then
				if TRB.Data.snapshot.moltenRadiance.isActive then
					valid = true
				end
			elseif var == "$channeledMana" then
				if TRB.Data.snapshot.channeledManaPotion.mana > 0 then
					valid = true
				end
			elseif var == "$potionOfFrozenFocusTicks" then
				if TRB.Data.snapshot.channeledManaPotion.ticksRemaining > 0 then
					valid = true
				end
			elseif var == "$potionOfFrozenFocusTime" then
				if GetChanneledPotionRemainingTime() > 0 then
					valid = true
				end
			elseif var == "$potionCooldown" then
				if TRB.Data.snapshot.potion.onCooldown then
					valid = true
				end
			elseif var == "$potionCooldownSeconds" then
				if TRB.Data.snapshot.potion.onCooldown then
					valid = true
				end
			end
		else
			valid = false
		end
		
		-- Spec Agnostic
		if var == "$fsCount" then
			if TRB.Data.snapshot.targetData.flameShock > 0 then
				valid = true
			end
		elseif var == "$fsTime" then
			if not UnitIsDeadOrGhost("target") and
				UnitCanAttack("player", "target") and
				TRB.Data.snapshot.targetData.currentTargetGuid ~= nil and
				TRB.Data.snapshot.targetData.targets ~= nil and
				TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid] ~= nil and
				TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].flameShockRemaining > 0 then
				valid = true
			end
		elseif var == "$ascendanceTime" then
			if TRB.Data.snapshot.ascendance.remainingTime ~= nil and TRB.Data.snapshot.ascendance.remainingTime > 0 then
				valid = true
			end
		end

		return valid
	end

	--HACK to fix FPS
	local updateRateLimit = 0

	function TRB.Functions.Class:TriggerResourceBarUpdates()
		local specId = GetSpecialization()
		if (specId ~= 1 and specId ~= 2 and specId ~= 3) or
			(specId == 2 and not TRB.Data.settings.core.experimental.specs.shaman.enhancement) then
			TRB.Functions.Bar:HideResourceBar(true)
			return
		end

		local currentTime = GetTime()

		if updateRateLimit + 0.05 < currentTime then
			updateRateLimit = currentTime
			UpdateResourceBar()
		end
	end
end