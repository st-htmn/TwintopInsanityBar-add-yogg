local _, TRB = ...
local _, _, classIndexId = UnitClass("player")
if classIndexId == 4 then --Only do this if we're on a Rogue!
	TRB.Functions.Class = TRB.Functions.Class or {}
	TRB.Functions.Character:ResetSnapshotData()
	
	local barContainerFrame = TRB.Frames.barContainerFrame
	local resource2Frame = TRB.Frames.resource2Frame
	local resourceFrame = TRB.Frames.resourceFrame
	local castingFrame = TRB.Frames.castingFrame
	local passiveFrame = TRB.Frames.passiveFrame
	local barBorderFrame = TRB.Frames.barBorderFrame

	local targetsTimerFrame = TRB.Frames.targetsTimerFrame
	local timerFrame = TRB.Frames.timerFrame
	local combatFrame = TRB.Frames.combatFrame

	Global_TwintopResourceBar = {}
	TRB.Data.character = {}

	local specCache = {
		assassination = {
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
		outlaw = {
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
		-- Assassination
		specCache.assassination.Global_TwintopResourceBar = {
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

		specCache.assassination.character = {
			guid = UnitGUID("player"),
---@diagnostic disable-next-line: missing-parameter
			specGroup = GetActiveSpecGroup(),
			specId = 1,
			maxResource = 100,
			maxResource2 = 5,
			effects = {
			}
		}

		specCache.assassination.spells = {
			-- Class Poisons
			cripplingPoison = {
				id = 3409,
				name = "",
				icon = "",
				isTalent = false
			},
			woundPoison = {
				id = 8680,
				name = "",
				icon = "",
				isTalent = false
			},
			numbingPoison = {
				id = 5760,
				name = "",
				icon = "",
				isTalent = true
			},
			atrophicPoison = {
				id = 392388,
				name = "",
				icon = "",
				isTalent = true
			},

			-- Assassination Poisons
			deadlyPoison = {
				id = 2818,
				name = "",
				icon = "",
				isTalent = true
			},
			amplifyingPoison = {
				id = 383414,
				name = "",
				icon = "",
				isTalent = true
			},

			-- Rogue Class Baseline Abilities
			stealth = {
				id = 1784,
				name = "",
				icon = ""
			},
			ambush = {
				id = 8676,
				name = "",
				icon = "",
				energy = -50,
				comboPointsGenerated = 2,
				stealth = true,
				texture = "",
				thresholdId = 1,
				settingKey = "ambush",
				--isSnowflake = true,
				thresholdUsable = false,
				baseline = true
			},
			cheapShot = {
				id = 1833,
				name = "",
				icon = "",
				energy = -40,
				comboPointsGenerated = 1,
				stealth = true,
				texture = "",
				thresholdId = 2,
				settingKey = "cheapShot",
				--isSnowflake = false,
				rushedSetup = true,
				thresholdUsable = false,
				baseline = true
			},
			crimsonVial = {
				id = 185311,
				name = "",
				icon = "",
				energy = -20,
				comboPointsGenerated = 0,
				texture = "",
				thresholdId = 3,
				settingKey = "crimsonVial",
				hasCooldown = true,
				cooldown = 30,
				nimbleFingers = true,
				thresholdUsable = false,
				baseline = true
			},
			distract = {
				id = 1725,
				name = "",
				icon = "",
				energy = -30,
				comboPointsGenerated = 0,
				texture = "",
				thresholdId = 4,
				settingKey = "distract",
				hasCooldown = true,
				cooldown = 30,
				rushedSetup = true,
				thresholdUsable = false,
				baseline = true
			},
			kidneyShot = {
				id = 408,
				name = "",
				icon = "",
				energy = -25,
				comboPoints = true,
				texture = "",
				thresholdId = 5,
				settingKey = "kidneyShot",
				hasCooldown = true,
				cooldown = 20,
				rushedSetup = true,
				thresholdUsable = false,
				baseline = true
			},
			sliceAndDice = {
				id = 315496,
				name = "",
				icon = "",
				energy = -25,
				comboPoints = true,
				texture = "",
				thresholdId = 6,
				settingKey = "sliceAndDice",
				hasCooldown = false,
				thresholdUsable = false,
				isSnowflake = true,
				pandemicTimes = {
					12 * 0.3, -- 0 CP, show same as if we had 1
					12 * 0.3,
					18 * 0.3,
					24 * 0.3,
					30 * 0.3,
					36 * 0.3,
					42 * 0.3,
					48 * 0.3
				},
				baseline = true
			},
			feint = {
				id = 1966,
				name = "",
				icon = "",
				energy = -35,
				comboPointsGenerated = 0,
				texture = "",
				thresholdId = 7,
				settingKey = "feint",
				hasCooldown = true,
				cooldown = 15,
				nimbleFingers = true,
				thresholdUsable = false,
				isTalent = false,
				baseline = true
			},

			--Rogue Talent Abilities
			shiv = {
				id = 5938,
				name = "",
				icon = "",
				energy = -20,
				comboPointsGenerated = 1,
				texture = "",
				thresholdId = 8,
				settingKey = "shiv",
				hasCooldown = true,
				isSnowflake = true,
				cooldown = 25,
				thresholdUsable = false,
				isTalent = true,
				baseline = true
			},
			sap = {
				id = 6770,
				name = "",
				icon = "",
				energy = -35,
				comboPointsGenerated = 0,
				stealth = true,
				texture = "",
				thresholdId = 9,
				settingKey = "sap",
				rushedSetup = true,
				thresholdUsable = false,
				isTalent = true
			},
			nimbleFingers = {
				id = 378427,
				name = "",
				icon = "",
				energyMod = -10,
				isTalent = true
			},
			gouge = {
				id = 1776,
				name = "",
				icon = "",
				energy = -25,
				comboPointsGenerated = 1,
				texture = "",
				thresholdId = 10,
				settingKey = "gouge",
				hasCooldown = true,
				thresholdUsable = false,
				cooldown = 15,
				isTalent = true
			},
			subterfuge = {
				id = 108208,
				name = "",
				icon = "",
				isTalent = true
			},
			rushedSetup = {
				id = 378803,
				name = "",
				icon = "",
				energyMod = 0.8,
				isTalent = true
			},
			tightSpender = {
				id = 381621,
				name = "",
				icon = "",
				energyMod = 0.9,
				isTalent = true
			},
			echoingReprimand = {
				id = 385616,
				name = "",
				icon = "",
				energy = -10,
				comboPointsGenerated = 2,
				texture = "",
				thresholdId = 11,
				settingKey = "echoingReprimand",
				hasCooldown = true,
				isSnowflake = true,
				thresholdUsable = false,
				cooldown = 45,
				buffId = {
					323558, -- 2
					323559, -- 3
					323560, -- 4
					354835, -- 4
					354838, -- 5
				}
			},
			--TODO: Finish implementing Shadow Dance
			shadowDance = {
				id = 185313,
				name = "",
				icon = "",
				isTalent = true
			},

			-- Assassination Baseline Abilities
			envenom = {
				id = 32645,
				name = "",
				icon = "",
				energy = -35,
				comboPoints = true,
				texture = "",
				thresholdId = 12,
				settingKey = "envenom",
				thresholdUsable = false,
				baseline = true
			},
			fanOfKnives = {
				id = 51723,
				name = "",
				icon = "",
				energy = -35,
				comboPointsGenerated = 1,
				texture = "",
				thresholdId = 13,
				settingKey = "fanOfKnives",
				thresholdUsable = false,
				baseline = true
			},
			garrote = {
				id = 703,
				name = "",
				icon = "",
				energy = -45,
				comboPointsGenerated = 1,
				texture = "",
				thresholdId = 14,
				settingKey = "garrote",
				hasCooldown = true,
				cooldown = 6,
				thresholdUsable = false,
				pandemicTime = 18 * 0.3,
				baseline = true,
				isSnowflake = true
			},
			mutilate = {
				id = 1329,
				name = "",
				icon = "",
				energy = -50,
				comboPointsGenerated = 2,
				texture = "",
				thresholdId = 15,
				settingKey = "mutilate",
				thresholdUsable = false,
				baseline = true
			},
			poisonedKnife = {
				id = 185565,
				name = "",
				icon = "",
				energy = -40,
				comboPointsGenerated = 1,
				texture = "",
				thresholdId = 16,
				settingKey = "poisonedKnife",
				thresholdUsable = false,
				baseline = true
			},
			rupture = {
				id = 1943,
				name = "",
				icon = "",
				energy = -25,
				comboPoints = true,
				texture = "",
				thresholdId = 17,
				settingKey = "rupture",
				thresholdUsable = false,
				pandemicTimes = {
					8 * 0.3, -- 0 CP, show same as if we had 1
					8 * 0.3,
					12 * 0.3,
					16 * 0.3,
					20 * 0.3,
					24 * 0.3,
					28 * 0.3,
					32 * 0.3,
				},
				baseline = true
			},

			-- Assassination Spec Abilities
			internalBleeding = {
				id = 381627,
				name = "",
				icon = "",
				isTalent = true
			},
			lightweightShiv = {
				id = 394983,
				name = "",
				icon = "",
				isTalent = true
			},
			crimsonTempest = {
				id = 121411,
				name = "",
				icon = "",
				energy = -30,
				comboPoints = true,
				texture = "",
				thresholdId = 18,
				settingKey = "crimsonTempest",
				thresholdUsable = false,
				pandemicTimes = {
					4 * 0.3, -- 0 CP, show same as if we had 1
					4 * 0.3,
					6 * 0.3,
					8 * 0.3,
					10 * 0.3,
					12 * 0.3,
					14 * 0.3,
					16 * 0.3, -- Kyrian ability buff
				},
				isTalent = true
			},
			improvedGarrote = {
				id = 381632,
				name = "",
				icon = "",
				stealthBuffId = 392401,
				buffId = 392403,
				isTalent = true
			},
			exsanguinate = {
				id = 200806,
				name = "",
				icon = "",
				energy = -25,
				texture = "",
				thresholdId = 19,
				settingKey = "exsanguinate",
				hasCooldown = true,
				isSnowflake = true,
				thresholdUsable = false,
				cooldown = 45,
				isTalent = true
			},
			-- TODO: Add Doomblade as a bleed
			blindside = {
				id = 121153,
				name = "",
				icon = "",
				duration = 10,
				isTalent = true
			},
			tinyToxicBlade = {
				id = 381800,
				name = "",
				icon = "",
				isTalent = true
			},
			serratedBoneSpike = {
				id = 385424,
				name = "",
				icon = "",
				energy = -15,
				comboPointsGenerated = 2,
				texture = "",
				thresholdId = 20,
				settingKey = "serratedBoneSpike",
				hasCooldown = true,
				isSnowflake = true,
				debuffId = 324073,
				isTalent = true
			},
			sepsis = {
				id = 385408,
				name = "",
				icon = "",
				energy = -25,
				comboPointsGenerated = 1,
				texture = "",
				thresholdId = 21,
				settingKey = "sepsis",
				hasCooldown = true,
				isSnowflake = true,
				cooldown = 90,
				buffId = 375939,
				isTalent = true
			},
			kingsbane = {
				id = 385627,
				name = "",
				icon = "",
				energy = -35,
				comboPointsGenerated = 1,
				texture = "",
				thresholdId = 22,
				settingKey = "kingsbane",
				hasCooldown = true,
				cooldown = 60,
				isTalent = true
			},

			-- PvP
			deathFromAbove = {
				id = 269513,
				name = "",
				icon = "",
				energy = -25,
				texture = "",
				thresholdId = 23,
				settingKey = "deathFromAbove",
				comboPoints = true,
				hasCooldown = true,
				isPvp = true,
				thresholdUsable = false,
				cooldown = 30
			},
			dismantle = {
				id = 207777,
				name = "",
				icon = "",
				energy = -25,
				texture = "",
				thresholdId = 24,
				settingKey = "dismantle",
				hasCooldown = true,
				isPvp = true,
				thresholdUsable = false,
				cooldown = 45
			},

			adrenalineRush = {
				id = 13750,
				name = "",
				icon = "",
			},
		}

		specCache.assassination.snapshot.energyRegen = 0
		specCache.assassination.snapshot.comboPoints = 0
		specCache.assassination.snapshot.audio = {
			overcapCue = false
		}
		specCache.assassination.snapshot.targetData = {
			ttdIsActive = false,
			currentTargetGuid = nil,
			--Bleeds
			garrote = 0,
			rupture = 0,
			internalBleeding = 0,
			crimsonTempest = 0,
			serratedBoneSpike = 0,
			--Poisons
			deadlyPoison = 0,
			cripplingPoison = 0,
			woundPoison = 0,
			numbingPoison = 0,
			atrophicPoison = 0,
			amplifyingPoison = 0,
			targets = {}
		}
		specCache.assassination.snapshot.crimsonVial = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.assassination.snapshot.distract = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.assassination.snapshot.kidneyShot = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.assassination.snapshot.sliceAndDice = {
			spellId = nil,
			endTime = nil
		}
		specCache.assassination.snapshot.shiv = {
			startTime = nil,
			duration = 0,
			enabled = false,
			charges = 0,
			maxCharges = 1
		}
		specCache.assassination.snapshot.feint = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.assassination.snapshot.gouge = {
			startTime = nil,
			duration = 0
		}
		specCache.assassination.snapshot.improvedGarrote = {
			spellId = nil,
			endTime = nil,
			isActiveStealth = false,
			isActive = false
		}

		specCache.assassination.snapshot.echoingReprimand = {
			isActive = false,
			startTime = nil,
			duration = 0,
		}
		for x = 1, 7 do -- 1, 6, and 7 CPs doesn't get it, but including it just in case it gets added/changed
			specCache.assassination.snapshot.echoingReprimand[x] = {
				endTime = nil,
				duration = 0,
				enabled = false,
				comboPoints = 0
			}
		end

		specCache.assassination.snapshot.garrote = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.assassination.snapshot.exsanguinate = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.assassination.snapshot.serratedBoneSpike = {
			isActive = false,
			-- Charges
			charges = 0,
			startTime = nil,
			duration = 0
		}
		specCache.assassination.snapshot.sepsis = {
			isActive = false,
			startTime = nil,
			endTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.assassination.snapshot.kingsbane = {
			spellId = nil,
			endTime = nil,
			duration = 0
		}
		specCache.assassination.snapshot.deathFromAbove = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.assassination.snapshot.blindside = {
			isActive = false,
			spellId = nil,
			endTime = nil,
			duration = 0
		}
		specCache.assassination.snapshot.deathFromAbove = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.assassination.snapshot.dismantle = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.assassination.snapshot.subterfuge = {
			isActive = false
		}

		specCache.assassination.barTextVariables = {
			icons = {},
			values = {}
		}


		-- Outlaw
		specCache.outlaw.Global_TwintopResourceBar = {
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

		specCache.outlaw.character = {
			guid = UnitGUID("player"),
---@diagnostic disable-next-line: missing-parameter
			specGroup = GetActiveSpecGroup(),
			specId = 1,
			maxResource = 100,
			maxResource2 = 5,
			effects = {
			}
		}

		specCache.outlaw.spells = {
			-- Class Poisons
			cripplingPoison = {
				id = 3409,
				name = "",
				icon = "",
				isTalent = false
			},
			woundPoison = {
				id = 8680,
				name = "",
				icon = "",
				isTalent = false
			},
			numbingPoison = {
				id = 5760,
				name = "",
				icon = "",
				isTalent = true
			},
			atrophicPoison = {
				id = 392388,
				name = "",
				icon = "",
				isTalent = true
			},

			-- Outlaw Poisons
			
			-- Rogue Class Baseline Abilities
			stealth = {
				id = 1784,
				name = "",
				icon = ""
			},
			ambush = {
				id = 8676,
				name = "",
				icon = "",
				energy = -50,
				comboPointsGenerated = 2,
				stealth = true,
				texture = "",
				thresholdId = 1,
				settingKey = "ambush",
				--isSnowflake = true,
				thresholdUsable = false,
				baseline = true
			},
			cheapShot = {
				id = 1833,
				name = "",
				icon = "",
				energy = -40,
				comboPointsGenerated = 1,
				stealth = true,
				texture = "",
				thresholdId = 2,
				settingKey = "cheapShot",
				--isSnowflake = false,
				rushedSetup = true,
				thresholdUsable = false,
				baseline = true
			},
			crimsonVial = {
				id = 185311,
				name = "",
				icon = "",
				energy = -20,
				comboPointsGenerated = 0,
				texture = "",
				thresholdId = 3,
				settingKey = "crimsonVial",
				hasCooldown = true,
				cooldown = 30,
				nimbleFingers = true,
				thresholdUsable = false,
				baseline = true
			},
			distract = {
				id = 1725,
				name = "",
				icon = "",
				energy = -30,
				comboPointsGenerated = 0,
				texture = "",
				thresholdId = 4,
				settingKey = "distract",
				hasCooldown = true,
				cooldown = 30,
				rushedSetup = true,
				thresholdUsable = false,
				baseline = true
			},
			kidneyShot = {
				id = 408,
				name = "",
				icon = "",
				energy = -25,
				comboPoints = true,
				texture = "",
				thresholdId = 5,
				settingKey = "kidneyShot",
				hasCooldown = true,
				cooldown = 20,
				rushedSetup = true,
				thresholdUsable = false,
				baseline = true
			},
			sliceAndDice = {
				id = 315496,
				name = "",
				icon = "",
				energy = -25,
				comboPoints = true,
				texture = "",
				thresholdId = 6,
				settingKey = "sliceAndDice",
				hasCooldown = false,
				thresholdUsable = false,
				isSnowflake = true,
				pandemicTimes = {
					12 * 0.3, -- 0 CP, show same as if we had 1
					12 * 0.3,
					18 * 0.3,
					24 * 0.3,
					30 * 0.3,
					36 * 0.3,
					42 * 0.3,
					48 * 0.3
				},
				baseline = true
			},
			feint = {
				id = 1966,
				name = "",
				icon = "",
				energy = -35,
				comboPointsGenerated = 0,
				texture = "",
				thresholdId = 7,
				settingKey = "feint",
				hasCooldown = true,
				cooldown = 15,
				nimbleFingers = true,
				thresholdUsable = false,
				isTalent = false,
				baseline = true
			},

			--Rogue Talent Abilities
			shiv = {
				id = 5938,
				name = "",
				icon = "",
				energy = -20,
				comboPointsGenerated = 1,
				texture = "",
				thresholdId = 8,
				settingKey = "shiv",
				hasCooldown = true,
				isSnowflake = true,
				cooldown = 25,
				thresholdUsable = false,
				isTalent = true,
				baseline = true
			},
			sap = {
				id = 6770,
				name = "",
				icon = "",
				energy = -35,
				comboPointsGenerated = 0,
				stealth = true,
				texture = "",
				thresholdId = 9,
				settingKey = "sap",
				rushedSetup = true,
				thresholdUsable = false,
				isTalent = true
			},
			nimbleFingers = {
				id = 378427,
				name = "",
				icon = "",
				energyMod = -10,
				isTalent = true
			},
			gouge = {
				id = 1776,
				name = "",
				icon = "",
				energy = -25,
				comboPointsGenerated = 1,
				texture = "",
				thresholdId = 10,
				settingKey = "gouge",
				hasCooldown = true,
				thresholdUsable = false,
				cooldown = 15,
				dirtyTricks = true,
				isTalent = true
			},
			subterfuge = {
				id = 108208,
				name = "",
				icon = "",
				isTalent = true
			},
			rushedSetup = {
				id = 378803,
				name = "",
				icon = "",
				energyMod = 0.8,
				isTalent = true
			},
			tightSpender = {
				id = 381621,
				name = "",
				icon = "",
				energyMod = 0.9,
				isTalent = true
			},
			echoingReprimand = {
				id = 385616,
				name = "",
				icon = "",
				energy = -10,
				comboPointsGenerated = 2,
				texture = "",
				thresholdId = 11,
				settingKey = "echoingReprimand",
				hasCooldown = true,
				isSnowflake = true,
				thresholdUsable = false,
				cooldown = 45,
				buffId = {
					323558, -- 2
					323559, -- 3
					323560, -- 4
					354835, -- 4
					354838, -- 5
				}
			},
			--TODO: Finish implementing Shadow Dance
			shadowDance = {
				id = 185313,
				name = "",
				icon = "",
				isTalent = true
			},

			-- Outlaw Baseline Abilities
			betweenTheEyes = {
				id = 315341,
				name = "",
				icon = "",
				energy = -25,
				comboPoints = true,
				texture = "",
				thresholdId = 12,
				settingKey = "betweenTheEyes",
				hasCooldown = true,
				isSnowflake = true,
				thresholdUsable = false,
				cooldown = 45,
				restlessBlades = true,
				baseline = true
			},
			dispatch = {
				id = 2098,
				name = "",
				icon = "",
				energy = -35,
				comboPoints = true,
				texture = "",
				thresholdId = 13,
				settingKey = "dispatch",
				thresholdUsable = false,
				baseline = true
			},
			pistolShot = {
				id = 185763,
				name = "",
				icon = "",
				energy = -40,
				comboPointsGenerated = 1,
				texture = "",
				thresholdId = 14,
				settingKey = "pistolShot",
				hasCooldown = false,
				isSnowflake = true,
				thresholdUsable = false,
				baseline = true
			},
			sinisterStrike = {
				id = 193315,
				name = "",
				icon = "",
				energy = -45,
				comboPointsGenerated = 1,
				texture = "",
				thresholdId = 15,
				settingKey = "sinisterStrike",
				hasCooldown = false,
				isSnowflake = true,
				thresholdUsable = false,
				baseline = true
			},
			opportunity = {
				id = 195627,
				name = "",
				icon = "",
				energyModifier = 0.5,
				baseline = true,
				isTalent = true
			},
			bladeFlurry = {
				id = 13877,
				name = "",
				icon = "",
				energy = -15,
				texture = "",
				thresholdId = 16,
				settingKey = "bladeFlurry",
				hasCooldown = true,
				thresholdUsable = false,
				cooldown = 30,
				restlessBlades = true,
				baseline = true,
				isTalent = true
			},

			-- Outlaw Spec Abilities
			adrenalineRush = {
				id = 13750,
				name = "",
				icon = "",
				restlessBlades = true,
				isTalent = true
			},
			restlessBlades = {
				id = 79096,
				name = "",
				icon = "",
				isTalent = true
			},
			dirtyTricks = {
				id = 108216,
				name = "",
				icon = "",
				isTalent = true
			},
			rollTheBones = {
				id = 315508,
				name = "",
				icon = "",
				energy = -25,
				texture = "",
				thresholdId = 17,
				settingKey = "rollTheBones",
				hasCooldown = true,
				thresholdUsable = false,
				cooldown = 45,
				restlessBlades = true
			},

			-- Roll the Bones
			broadside = {
				id = 193356,
				name = "",
				icon = "",
			},
			buriedTreasure = {
				id = 199600,
				name = "",
				icon = "",
			},
			grandMelee = {
				id = 193358,
				name = "",
				icon = "",
			},
			ruthlessPrecision = {
				id = 193357,
				name = "",
				icon = "",
			},
			skullAndCrossbones = {
				id = 199603,
				name = "",
				icon = "",
			},
			trueBearing = {
				id = 193359,
				name = "",
				icon = "",
			},
			countTheOdds = {
				id = 381982,
				name = "",
				icon = "",
				duration = 5
			},

			sepsis = {
				id = 385408,
				name = "",
				icon = "",
				energy = -25,
				comboPointsGenerated = 1,
				texture = "",
				thresholdId = 18,
				settingKey = "sepsis",
				hasCooldown = true,
				isSnowflake = true,
				cooldown = 90,
				buffId = 375939,
				restlessBlades = true,
				isTalent = true
			},
			ghostlyStrike = {
				id = 196937,
				name = "",
				icon = "",
				energy = -30,
				comboPointsGenerated = 1,
				texture = "",
				thresholdId = 19,
				settingKey = "ghostlyStrike",
				hasCooldown = true,
				thresholdUsable = false,
				isTalent = true,
				cooldown = 35,
				restlessBlades = true
			},
			bladeRush = {
				id = 271877,
				name = "",
				icon = "",
				isTalent = true,
				energy = 25,
				duration = 5,
				cooldown = 45,
				restlessBlades = true
			},
			dreadblades = {
				id = 343142,
				name = "",
				icon = "",
				energy = -50,
				texture = "",
				thresholdId = 20,
				settingKey = "dreadblades",
				hasCooldown = true,
				isTalent = true,
				thresholdUsable = false,
				cooldown = 90,
				restlessBlades = true
			},
			keepItRolling = {
				id = 381989,
				name = "",
				icon = "",
				isTalent = true,
				duration = 30,
				cooldown = 60 * 7,
				restlessBlades = true
			},
			-- TODO: Implement this!
			greenskinsWickers = {
				id = 386823,
				name = "",
				icon = "",
				isTalent = true
			},

			-- PvP
			deathFromAbove = {
				id = 269513,
				name = "",
				icon = "",
				energy = -25,
				texture = "",
				thresholdId = 21,
				settingKey = "deathFromAbove",
				comboPoints = true,
				hasCooldown = true,
				isPvp = true,
				thresholdUsable = false,
				cooldown = 30
			},
			dismantle = {
				id = 207777,
				name = "",
				icon = "",
				energy = -25,
				texture = "",
				thresholdId = 22,
				settingKey = "dismantle",
				hasCooldown = true,
				isPvp = true,
				thresholdUsable = false,
				cooldown = 45
			},
		}

		specCache.outlaw.snapshot.energyRegen = 0
		specCache.outlaw.snapshot.comboPoints = 0
		specCache.outlaw.snapshot.audio = {
			overcapCue = false
		}
		specCache.outlaw.snapshot.targetData = {
			ttdIsActive = false,
			currentTargetGuid = nil,
			--Poisons
			cripplingPoison = 0,
			woundPoison = 0,
			numbingPoison = 0,
			atrophicPoison = 0,
			targets = {}
		}
		specCache.outlaw.snapshot.crimsonVial = {
			startTime = nil,
			duration = 0
		}
		specCache.outlaw.snapshot.distract = {
			startTime = nil,
			duration = 0
		}
		specCache.outlaw.snapshot.feint = {
			startTime = nil,
			duration = 0
		}
		specCache.outlaw.snapshot.kidneyShot = {
			startTime = nil,
			duration = 0
		}
		specCache.outlaw.snapshot.shiv = {
			startTime = nil,
			duration = 0,
			charges = 0,
			maxCharges = 1
		}
		specCache.outlaw.snapshot.gouge = {
			startTime = nil,
			duration = 0
		}
		specCache.outlaw.snapshot.betweenTheEyes = {
			startTime = nil,
			duration = 0
		}
		specCache.outlaw.snapshot.bladeFlurry = {
			startTime = nil,
			duration = 0
		}
		specCache.outlaw.snapshot.bladeRush = {
			spellId = nil,
			endTime = nil,
			startTime = nil,
			duration = 0
		}
		specCache.outlaw.snapshot.ghostlyStrike = {
			startTime = nil,
			duration = 0
		}
		specCache.outlaw.snapshot.dreadblades = {
			startTime = nil,
			duration = 0
		}
		specCache.outlaw.snapshot.sliceAndDice = {
			spellId = nil,
			endTime = nil
		}
		specCache.outlaw.snapshot.opportunity = {
			isActive = false,
			spellId = nil,
			endTime = nil,
			duration = 0
		}
		specCache.outlaw.snapshot.subterfuge = {
			isActive = false
		}

		specCache.outlaw.snapshot.echoingReprimand = {
			isActive = false,
			startTime = nil,
			duration = 0,
		}
		for x = 1, 7 do -- 1, 6, and 7 CPs doesn't get it, but including it just in case it gets added/changed
			specCache.outlaw.snapshot.echoingReprimand[x] = {
				endTime = nil,
				duration = 0,
				enabled = false,
				comboPoints = 0
			}
		end
		
		specCache.outlaw.snapshot.sepsis = {
			isActive = false,
			startTime = nil,
			endTime = nil,
			duration = 0,
			enabled = false
		}

		specCache.outlaw.snapshot.deathFromAbove = {
			startTime = nil,
			duration = 0
		}
		specCache.outlaw.snapshot.dismantle = {
			startTime = nil,
			duration = 0
		}
		specCache.outlaw.snapshot.rollTheBones = {
			buffs = {
				broadside = {
					endTime = nil,
					duration = 0,
					spellId = nil,
					fromCountTheOdds = false
				},
				buriedTreasure = {
					endTime = nil,
					duration = 0,
					spellId = nil,
					fromCountTheOdds = false
				},
				grandMelee = {
					endTime = nil,
					duration = 0,
					spellId = nil,
					fromCountTheOdds = false
				},
				ruthlessPrecision = {
					endTime = nil,
					duration = 0,
					spellId = nil,
					fromCountTheOdds = false
				},
				skullAndCrossbones = {
					endTime = nil,
					duration = 0,
					spellId = nil,
					fromCountTheOdds = false
				},
				trueBearing = {
					endTime = nil,
					duration = 0,
					spellId = nil,
					fromCountTheOdds = false
				}
			},
			count = 0,
			temporaryCount = 0,
			startTime = nil,
			duration = 0,
			goodBuffs = false,
			remaining = 0
		}

		specCache.outlaw.barTextVariables = {
			icons = {},
			values = {}
		}
	end

	local function Setup_Assassination()
		if TRB.Data.character and TRB.Data.character.specId == GetSpecialization() then
			return
		end

		TRB.Functions.Character:FillSpecializationCacheSettings(TRB.Data.settings, specCache, "rogue", "assassination")
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.assassination)
	end

	local function Setup_Outlaw()
		if TRB.Data.character and TRB.Data.character.specId == GetSpecialization() then
			return
		end

		TRB.Functions.Character:FillSpecializationCacheSettings(TRB.Data.settings, specCache, "rogue", "outlaw")
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.outlaw)
	end

	local function FillSpellData_Assassination()
		Setup_Assassination()
		local spells = TRB.Functions.Spell:FillSpellData(specCache.assassination.spells)
		
		-- This is done here so that we can get icons for the options menu!
		specCache.assassination.barTextVariables.icons = {
			{ variable = "#casting", icon = "", description = "The icon of the Energy generating spell you are currently hardcasting", printInSettings = true },
			{ variable = "#item_ITEMID_", icon = "", description = "Any item's icon available via its item ID (e.g.: #item_18609_).", printInSettings = true },
			{ variable = "#spell_SPELLID_", icon = "", description = "Any spell's icon available via its spell ID (e.g.: #spell_2691_).", printInSettings = true },

			{ variable = "#atrophicPoison", icon = spells.atrophicPoison.icon, description = spells.atrophicPoison.name, printInSettings = true },
			{ variable = "#amplifyingPoison", icon = spells.amplifyingPoison.icon, description = spells.amplifyingPoison.name, printInSettings = true },
			{ variable = "#blindside", icon = spells.blindside.icon, description = spells.blindside.name, printInSettings = true },
			{ variable = "#crimsonTempest", icon = spells.crimsonTempest.icon, description = spells.crimsonTempest.name, printInSettings = true },
			{ variable = "#ct", icon = spells.crimsonTempest.icon, description = spells.crimsonTempest.name, printInSettings = false },
			{ variable = "#cripplingPoison", icon = spells.cripplingPoison.icon, description = spells.cripplingPoison.name, printInSettings = true },
			{ variable = "#cp", icon = spells.cripplingPoison.icon, description = spells.cripplingPoison.name, printInSettings = false },
			{ variable = "#deadlyPoison", icon = spells.deadlyPoison.icon, description = spells.deadlyPoison.name, printInSettings = true },
			{ variable = "#dp", icon = spells.deadlyPoison.icon, description = spells.deadlyPoison.name, printInSettings = false },
			{ variable = "#deathFromAbove", icon = spells.deathFromAbove.icon, description = spells.deathFromAbove.name, printInSettings = true },
			{ variable = "#dismantle", icon = spells.dismantle.icon, description = spells.dismantle.name, printInSettings = true },
			{ variable = "#echoingReprimand", icon = spells.echoingReprimand.icon, description = spells.echoingReprimand.name, printInSettings = true },
			{ variable = "#garrote", icon = spells.garrote.icon, description = spells.garrote.name, printInSettings = true },
			{ variable = "#internalBleeding", icon = spells.internalBleeding.icon, description = spells.internalBleeding.name, printInSettings = true },
			{ variable = "#ib", icon = spells.internalBleeding.icon, description = spells.internalBleeding.name, printInSettings = false },
			{ variable = "#numbingPoison", icon = spells.numbingPoison.icon, description = spells.numbingPoison.name, printInSettings = true },
			{ variable = "#np", icon = spells.numbingPoison.icon, description = spells.numbingPoison.name, printInSettings = false },
			{ variable = "#rupture", icon = spells.rupture.icon, description = spells.rupture.name, printInSettings = true },
			{ variable = "#sad", icon = spells.sliceAndDice.icon, description = spells.sliceAndDice.name, printInSettings = true },
			{ variable = "#sliceAndDice", icon = spells.sliceAndDice.icon, description = spells.sliceAndDice.name, printInSettings = false },
			{ variable = "#sepsis", icon = spells.sepsis.icon, description = spells.sepsis.name, printInSettings = true },
			{ variable = "#serratedBoneSpike", icon = spells.serratedBoneSpike.icon, description = spells.serratedBoneSpike.name, printInSettings = true },
			{ variable = "#stealth", icon = spells.stealth.icon, description = spells.stealth.name, printInSettings = true },
			{ variable = "#woundPoison", icon = spells.woundPoison.icon, description = spells.woundPoison.name, printInSettings = true },
			{ variable = "#wp", icon = spells.woundPoison.icon, description = spells.woundPoison.name, printInSettings = false },
		}
		specCache.assassination.barTextVariables.values = {
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
			{ variable = "$inStealth", description = "Are you currently considered to be in stealth? LOGIC VARIABLE ONLY!", printInSettings = true, color = false },


			{ variable = "$energy", description = "Current Energy", printInSettings = true, color = false },
			{ variable = "$resource", description = "Current Energy", printInSettings = false, color = false },
			{ variable = "$energyMax", description = "Maximum Energy", printInSettings = true, color = false },
			{ variable = "$resourceMax", description = "Maximum Energy", printInSettings = false, color = false },
			{ variable = "$casting", description = "Builder Energy from Hardcasting Spells", printInSettings = false, color = false },
			{ variable = "$casting", description = "Spender Energy from Hardcasting Spells", printInSettings = false, color = false },
			{ variable = "$passive", description = "Energy from Passive Sources including Regen and Barbed Shot buffs", printInSettings = true, color = false },
			{ variable = "$regen", description = "Energy from Passive Regen", printInSettings = true, color = false },
			{ variable = "$regenEnergy", description = "Energy from Passive Regen", printInSettings = false, color = false },
			{ variable = "$energyRegen", description = "Energy from Passive Regen", printInSettings = false, color = false },
			{ variable = "$energyPlusCasting", description = "Current + Casting Energy Total", printInSettings = false, color = false },
			{ variable = "$resourcePlusCasting", description = "Current + Casting Energy Total", printInSettings = false, color = false },
			{ variable = "$energyPlusPassive", description = "Current + Passive Energy Total", printInSettings = true, color = false },
			{ variable = "$resourcePlusPassive", description = "Current + Passive Energy Total", printInSettings = false, color = false },
			{ variable = "$energyTotal", description = "Current + Passive + Casting Energy Total", printInSettings = true, color = false },
			{ variable = "$resourceTotal", description = "Current + Passive + Casting Energy Total", printInSettings = false, color = false },
			
			{ variable = "$comboPoints", description = "Current Combo Points", printInSettings = true, color = false },
			{ variable = "$comboPointsMax", description = "Maximum Combo Points", printInSettings = true, color = false },

			{ variable = "$sadTime", description = "Time remaining on Slice and Dice buff", printInSettings = true, color = false },
			{ variable = "$sliceAndDiceTime", description = "Time remaining on Slice and Dice buff", printInSettings = false, color = false },

			-- Bleeds
			{ variable = "$isBleeding", description = "Does your current target have a bleed active on it? Logic variable only!", printInSettings = true, color = false },
			{ variable = "$ctCount", description = "Number of Crimson Tempest bleeds active on targets", printInSettings = true, color = false },
			{ variable = "$crimsonTempestCount", description = "Number of Crimson Tempest bleeds active on targets", printInSettings = false, color = false },
			{ variable = "$ctTime", description = "Time remaining on Crimson Tempest on your current target", printInSettings = true, color = false },
			{ variable = "$crimsonTempestTime", description = "Time remaining on Crimson Tempest on your current target", printInSettings = false, color = false },

			{ variable = "$garroteCount", description = "Number of Garrote bleeds active on targets", printInSettings = true, color = false },
			{ variable = "$garroteTime", description = "Time remaining on Garrote on your current target", printInSettings = true, color = false },

			{ variable = "$ibCount", description = "Number of Internal Bleeding bleeds active on targets", printInSettings = true, color = false },
			{ variable = "$internalBleedingCount", description = "Number of Internal Bleeding bleeds active on targets", printInSettings = false, color = false },
			{ variable = "$ibTime", description = "Time remaining on Internal Bleeding on your current target", printInSettings = true, color = false },
			{ variable = "$internalBleedingTime", description = "Time remaining on Internal Bleeding on your current target", printInSettings = false, color = false },

			{ variable = "$ruptureCount", description = "Number of Rupture bleeds active on targets", printInSettings = true, color = false },
			{ variable = "$ruptureTime", description = "Time remaining on Rupture on your current target", printInSettings = true, color = false },
		
			{ variable = "$sbsCount", description = "Number of Serrated Bone Spike bleeds active on targets", printInSettings = true, color = false },
			{ variable = "$serratedBoneSpikeCount", description = "Number of Serrated Bone Spike bleeds active on targets", printInSettings = false, color = false },

			-- Poisons
			
			{ variable = "$amplifyingPoisonCount", description = "Number of Amplifying Poisons active on targets", printInSettings = false, color = false },
			{ variable = "$amplifyingPoisonTime", description = "Time remaining on Amplifying Poison on your current target", printInSettings = false, color = false },

			{ variable = "$atrophicPoisonCount", description = "Number of Atrophic Poisons active on targets", printInSettings = false, color = false },
			{ variable = "$atrophicPoisonTime", description = "Time remaining on Atrophic Poison on your current target", printInSettings = false, color = false },

			{ variable = "$cpCount", description = "Number of Crippling Poisons active on targets", printInSettings = true, color = false },
			{ variable = "$cripplingPoisonCount", description = "Number of Crippling Poisons active on targets", printInSettings = false, color = false },
			{ variable = "$cpTime", description = "Time remaining on Crippling Poison on your current target", printInSettings = true, color = false },
			{ variable = "$cripplingPoisonTime", description = "Time remaining on Crippling Poisons on your current target", printInSettings = false, color = false },

			{ variable = "$dpCount", description = "Number of Deadly Poisons active on targets", printInSettings = true, color = false },
			{ variable = "$deadlyPoisonCount", description = "Number of Deadly Poisons active on targets", printInSettings = false, color = false },
			{ variable = "$dpTime", description = "Time remaining on Deadly Poisons on your current target", printInSettings = true, color = false },
			{ variable = "$deadlyPoisonTime", description = "Time remaining on Deadly Poisons on your current target", printInSettings = false, color = false },

			{ variable = "$npCount", description = "Number of Numbing Poisons active on targets", printInSettings = true, color = false },
			{ variable = "$numbingPoisonCount", description = "Number of Numbing Poisons active on targets", printInSettings = false, color = false },
			{ variable = "$npTime", description = "Time remaining on Numbing Poison on your current target", printInSettings = true, color = false },
			{ variable = "$numbingPoisonTime", description = "Time remaining on Numbing Poison on your current target", printInSettings = false, color = false },

			{ variable = "$wpCount", description = "Number of Wound Poisons active on targets", printInSettings = true, color = false },
			{ variable = "$woundPoisonCount", description = "Number of Wound Poisons active on targets", printInSettings = false, color = false },
			{ variable = "$wpTime", description = "Time remaining on Wound Poison on your current target", printInSettings = true, color = false },
			{ variable = "$woundPoisonTime", description = "Time remaining on Wound Poison on your current target", printInSettings = false, color = false },

			-- Proc
			{ variable = "$blindsideTime", description = "Time remaining on Blindside proc", printInSettings = true, color = false },


			{ variable = "$ttd", description = "Time To Die of current target in MM:SS format", printInSettings = true, color = true },
			{ variable = "$ttdSeconds", description = "Time To Die of current target in seconds", printInSettings = true, color = true }
		}

		specCache.assassination.spells = spells
	end

	local function FillSpellData_Outlaw()
		Setup_Outlaw()
		local spells = TRB.Functions.Spell:FillSpellData(specCache.outlaw.spells)

		-- This is done here so that we can get icons for the options menu!
		specCache.outlaw.barTextVariables.icons = {
			{ variable = "#casting", icon = "", description = "The icon of the Energy generating spell you are currently hardcasting", printInSettings = true },
			{ variable = "#item_ITEMID_", icon = "", description = "Any item's icon available via its item ID (e.g.: #item_18609_).", printInSettings = true },
			{ variable = "#spell_SPELLID_", icon = "", description = "Any spell's icon available via its spell ID (e.g.: #spell_2691_).", printInSettings = true },

			{ variable = "#adrenalineRush", icon = spells.adrenalineRush.icon, description = spells.adrenalineRush.name, printInSettings = true },
			{ variable = "#betweenTheEyes", icon = spells.betweenTheEyes.icon, description = spells.betweenTheEyes.name, printInSettings = true },
			{ variable = "#bladeFlurry", icon = spells.bladeFlurry.icon, description = spells.bladeFlurry.name, printInSettings = true },
			{ variable = "#bladeRush", icon = spells.bladeRush.icon, description = spells.bladeRush.name, printInSettings = true },
			{ variable = "#broadside", icon = spells.broadside.icon, description = spells.broadside.name, printInSettings = true },
			{ variable = "#buriedTreasure", icon = spells.buriedTreasure.icon, description = spells.buriedTreasure.name, printInSettings = true },
			{ variable = "#deathFromAbove", icon = spells.deathFromAbove.icon, description = spells.deathFromAbove.name, printInSettings = true },
			{ variable = "#dirtyTricks", icon = spells.dirtyTricks.icon, description = spells.dirtyTricks.name, printInSettings = true },
			{ variable = "#dispatch", icon = spells.dispatch.icon, description = spells.dispatch.name, printInSettings = true },
			{ variable = "#dismantle", icon = spells.dismantle.icon, description = spells.dismantle.name, printInSettings = true },
			{ variable = "#dreadblades", icon = spells.dreadblades.icon, description = spells.dreadblades.name, printInSettings = true },
			{ variable = "#cripplingPoison", icon = spells.cripplingPoison.icon, description = spells.cripplingPoison.name, printInSettings = true },
			{ variable = "#cp", icon = spells.cripplingPoison.icon, description = spells.cripplingPoison.name, printInSettings = false },
			{ variable = "#dismantle", icon = spells.dismantle.icon, description = spells.dismantle.name, printInSettings = true },
			{ variable = "#echoingReprimand", icon = spells.echoingReprimand.icon, description = spells.echoingReprimand.name, printInSettings = true },
			{ variable = "#ghostlyStrike", icon = spells.ghostlyStrike.icon, description = spells.ghostlyStrike.name, printInSettings = true },
			{ variable = "#grandMelee", icon = spells.grandMelee.icon, description = spells.grandMelee.name, printInSettings = true },
			{ variable = "#numbingPoison", icon = spells.numbingPoison.icon, description = spells.numbingPoison.name, printInSettings = true },
			{ variable = "#np", icon = spells.numbingPoison.icon, description = spells.numbingPoison.name, printInSettings = false },
			{ variable = "#opportunity", icon = spells.opportunity.icon, description = spells.opportunity.name, printInSettings = true },
			{ variable = "#pistolShot", icon = spells.pistolShot.icon, description = spells.pistolShot.name, printInSettings = true },
			{ variable = "#rollTheBones", icon = spells.rollTheBones.icon, description = spells.rollTheBones.name, printInSettings = true },
			{ variable = "#ruthlessPrecision", icon = spells.ruthlessPrecision.icon, description = spells.ruthlessPrecision.name, printInSettings = true },
			{ variable = "#sad", icon = spells.sliceAndDice.icon, description = spells.sliceAndDice.name, printInSettings = true },
			{ variable = "#sliceAndDice", icon = spells.sliceAndDice.icon, description = spells.sliceAndDice.name, printInSettings = false },
			{ variable = "#sepsis", icon = spells.sepsis.icon, description = spells.sepsis.name, printInSettings = true },
			{ variable = "#sinisterStrike", icon = spells.sinisterStrike.icon, description = spells.sinisterStrike.name, printInSettings = true },
			{ variable = "#skullAndCrossbones", icon = spells.skullAndCrossbones.icon, description = spells.skullAndCrossbones.name, printInSettings = true },
			{ variable = "#stealth", icon = spells.stealth.icon, description = spells.stealth.name, printInSettings = true },
			{ variable = "#trueBearing", icon = spells.trueBearing.icon, description = spells.trueBearing.name, printInSettings = true },
			{ variable = "#woundPoison", icon = spells.woundPoison.icon, description = spells.woundPoison.name, printInSettings = true },
			{ variable = "#wp", icon = spells.woundPoison.icon, description = spells.woundPoison.name, printInSettings = false },
		}
		specCache.outlaw.barTextVariables.values = {
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
			{ variable = "$inStealth", description = "Are you currently considered to be in stealth? LOGIC VARIABLE ONLY!", printInSettings = true, color = false },


			{ variable = "$energy", description = "Current Energy", printInSettings = true, color = false },
			{ variable = "$resource", description = "Current Energy", printInSettings = false, color = false },
			{ variable = "$energyMax", description = "Maximum Energy", printInSettings = true, color = false },
			{ variable = "$resourceMax", description = "Maximum Energy", printInSettings = false, color = false },
			{ variable = "$casting", description = "Builder Energy from Hardcasting Spells", printInSettings = false, color = false },
			{ variable = "$casting", description = "Spender Energy from Hardcasting Spells", printInSettings = false, color = false },
			{ variable = "$passive", description = "Energy from Passive Sources including Regen and Barbed Shot buffs", printInSettings = true, color = false },
			{ variable = "$regen", description = "Energy from Passive Regen", printInSettings = true, color = false },
			{ variable = "$regenEnergy", description = "Energy from Passive Regen", printInSettings = false, color = false },
			{ variable = "$energyRegen", description = "Energy from Passive Regen", printInSettings = false, color = false },
			{ variable = "$energyPlusCasting", description = "Current + Casting Energy Total", printInSettings = false, color = false },
			{ variable = "$resourcePlusCasting", description = "Current + Casting Energy Total", printInSettings = false, color = false },
			{ variable = "$energyPlusPassive", description = "Current + Passive Energy Total", printInSettings = true, color = false },
			{ variable = "$resourcePlusPassive", description = "Current + Passive Energy Total", printInSettings = false, color = false },
			{ variable = "$energyTotal", description = "Current + Passive + Casting Energy Total", printInSettings = true, color = false },
			{ variable = "$resourceTotal", description = "Current + Passive + Casting Energy Total", printInSettings = false, color = false },
			
			{ variable = "$comboPoints", description = "Current Combo Points", printInSettings = true, color = false },
			{ variable = "$comboPointsMax", description = "Maximum Combo Points", printInSettings = true, color = false },

			{ variable = "$rtbCount", description = "Current number of Roll the Bones buffs active", printInSettings = true, color = false },
			{ variable = "$rollTheBonesCount", description = "Current number of Roll the Bones buffs active", printInSettings = false, color = false },

			{ variable = "$rtbTemporaryCount", description = "Current number of full Roll the Bones buffs active", printInSettings = true, color = false },
			{ variable = "$rollTheBonesTemporaryCount", description = "Current number of temporary Roll the Bones buffs (from Count the Odds) active", printInSettings = false, color = false },


			{ variable = "$rtbAllCount", description = "Current number of Roll the Bones buffs active from all sources", printInSettings = true, color = false },
			{ variable = "$rollTheBonesAllCount", description = "Current number of Roll the Bones buffs active from all sources", printInSettings = false, color = false },
			
			{ variable = "$rtbBuffTime", description = "Time remaining on your Roll the Bones buffs (not from Count the Odds)", printInSettings = true, color = false },
			{ variable = "$rollTheBonesBuffTime", description = "Time remaining on your Roll the Bones buffs (not from Count the Odds)", printInSettings = false, color = false },
			
			{ variable = "$rtbGoodBuff", description = "Are the current Roll the Bones buffs good or not? Good is defined as any two buffs, Broadside, or True Bearing. Logic variable only!", printInSettings = true, color = false },
			{ variable = "$rollTheBonesGoodBuff", description = "Are the current Roll the Bones buffs good or not? Good is defined as any two buffs, Broadside, or True Bearing. Logic variable only!", printInSettings = false, color = false },

			{ variable = "$broadsideTime", description = "Time remaining on Broadside buff (from Roll the Bones)", printInSettings = true, color = false },
			{ variable = "$buriedTreasureTime", description = "Time remaining on Burried Treasure buff (from Roll the Bones)", printInSettings = true, color = false },
			{ variable = "$grandMeleeTime", description = "Time remaining on Grand Melee buff (from Roll the Bones)", printInSettings = true, color = false },
			{ variable = "$ruthlessPrecisionTime", description = "Time remaining on Ruthless Precision buff (from Roll the Bones)", printInSettings = true, color = false },
			{ variable = "$skullAndCrossbonesTime", description = "Time remaining on Skull and Crossbones buff (from Roll the Bones)", printInSettings = true, color = false },
			{ variable = "$trueBearingTime", description = "Time remaining on True Bearing buff (from Roll the Bones)", printInSettings = true, color = false },

			{ variable = "$sadTime", description = "Time remaining on Slice and Dice buff", printInSettings = true, color = false },
			{ variable = "$sliceAndDiceTime", description = "Time remaining on Slice and Dice buff", printInSettings = false, color = false },

			-- Proc
			{ variable = "$opportunityTime", description = "Time remaining on Opportunity proc", printInSettings = true, color = false },

			-- Poisons
			{ variable = "$cpCount", description = "Number of Crippling Poisons active on targets", printInSettings = true, color = false },
			{ variable = "$cripplingPoisonCount", description = "Number of Crippling Poisons active on targets", printInSettings = false, color = false },
			{ variable = "$cpTime", description = "Time remaining on Crippling Poison on your current target", printInSettings = true, color = false },
			{ variable = "$cripplingPoisonTime", description = "Time remaining on Crippling Poisons on your current target", printInSettings = false, color = false },

			{ variable = "$dpCount", description = "Number of Deadly Poisons active on targets", printInSettings = true, color = false },
			{ variable = "$deadlyPoisonCount", description = "Number of Deadly Poisons active on targets", printInSettings = false, color = false },
			{ variable = "$dpTime", description = "Time remaining on Deadly Poisons on your current target", printInSettings = true, color = false },
			{ variable = "$deadlyPoisonTime", description = "Time remaining on Deadly Poisons on your current target", printInSettings = false, color = false },

			{ variable = "$npCount", description = "Number of Numbing Poisons active on targets", printInSettings = true, color = false },
			{ variable = "$numbingPoisonCount", description = "Number of Numbing Poisons active on targets", printInSettings = false, color = false },
			{ variable = "$npTime", description = "Time remaining on Numbing Poison on your current target", printInSettings = true, color = false },
			{ variable = "$numbingPoisonTime", description = "Time remaining on Numbing Poison on your current target", printInSettings = false, color = false },

			{ variable = "$ttd", description = "Time To Die of current target in MM:SS format", printInSettings = true, color = true },
			{ variable = "$ttdSeconds", description = "Time To Die of current target in seconds", printInSettings = true, color = true }
		}

		specCache.outlaw.spells = spells
	end

	local function IsTargetBleeding(guid)
		if guid == nil then
			guid = TRB.Data.snapshot.targetData.currentTargetGuid
		end

		if TRB.Data.snapshot.targetData.targets[guid] == nil then
			return false
		end

		local specId = GetSpecialization()

		if specId == 1 then -- Assassination
			return TRB.Data.snapshot.targetData.targets[guid].garrote or TRB.Data.snapshot.targetData.targets[guid].rupture or TRB.Data.snapshot.targetData.targets[guid].internalBleeding or TRB.Data.snapshot.targetData.targets[guid].crimsonTempest
		end
		return false
	end
	
	local function GetSliceAndDiceRemainingTime()
		return TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshot.sliceAndDice)
	end

	local function GetBlindsideRemainingTime()
		return TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshot.blindside)
	end

	local function GetOpportunityRemainingTime()
		return TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshot.opportunity)
	end
	
	local function CalculateAbilityResourceValue(resource, nimbleFingers, rushedSetup, comboPoints)
		local modifier = 1.0

		if comboPoints == true and TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.tightSpender) then
			modifier = modifier * TRB.Data.spells.tightSpender.energyMod
		end

		-- TODO: validate how Nimble Fingers reduces energy costs. Is it before or after percentage modifiers? Assuming before for now
		if nimbleFingers == true and TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.nimbleFingers) then
			resource = resource + TRB.Data.spells.nimbleFingers.energyMod
		end

		if rushedSetup == true and TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.rushedSetup) then
			modifier = modifier * TRB.Data.spells.rushedSetup.energyMod
		end

		return resource * modifier
	end

	local function UpdateCastingResourceFinal()
		TRB.Data.snapshot.casting.resourceFinal = CalculateAbilityResourceValue(TRB.Data.snapshot.casting.resourceRaw)
	end

	local function RefreshTargetTracking()
		local currentTime = GetTime()
		local specId = GetSpecialization()
		
		if specId == 1 then -- Assassination
			-- Bleeds
			local crimsonTempestTotal = 0
			local garroteTotal = 0
			local internalBleedingTotal = 0
			local ruptureTotal = 0
			local serratedBoneSpikeTotal = 0
			-- Poisons
			local amplifyingPoisonTotal = 0
			local atrophicPoisonTotal = 0
			local cripplingPoisonTotal = 0
			local deadlyPoisonTotal = 0
			local numbingPoisonTotal = 0
			local woundPoisonTotal = 0
			for guid,count in pairs(TRB.Data.snapshot.targetData.targets) do
				if (currentTime - TRB.Data.snapshot.targetData.targets[guid].lastUpdate) > 20 then
					-- Bleeds
					TRB.Data.snapshot.targetData.targets[guid].garrote = false
					TRB.Data.snapshot.targetData.targets[guid].garroteRemaining = 0
					TRB.Data.snapshot.targetData.targets[guid].rupture = false
					TRB.Data.snapshot.targetData.targets[guid].ruptureRemaining = 0
					TRB.Data.snapshot.targetData.targets[guid].internalBleeding = false
					TRB.Data.snapshot.targetData.targets[guid].internalBleedingRemaining = 0
					TRB.Data.snapshot.targetData.targets[guid].crimsonTempest = false
					TRB.Data.snapshot.targetData.targets[guid].crimsonTempestRemaining = 0
					TRB.Data.snapshot.targetData.targets[guid].serratedBoneSpike = false
					-- Poisons
					TRB.Data.snapshot.targetData.targets[guid].amplifyingPoison = false
					TRB.Data.snapshot.targetData.targets[guid].amplifyingPoisonRemaining = 0
					TRB.Data.snapshot.targetData.targets[guid].atrophicPoison = false
					TRB.Data.snapshot.targetData.targets[guid].atrophicPoisonRemaining = 0
					TRB.Data.snapshot.targetData.targets[guid].cripplingPoison = false
					TRB.Data.snapshot.targetData.targets[guid].cripplingPoisonRemaining = 0
					TRB.Data.snapshot.targetData.targets[guid].deadlyPoison = false
					TRB.Data.snapshot.targetData.targets[guid].deadlyPoisonRemaining = 0
					TRB.Data.snapshot.targetData.targets[guid].numbingPoison = false
					TRB.Data.snapshot.targetData.targets[guid].numbingPoisonRemaining = 0
					TRB.Data.snapshot.targetData.targets[guid].woundPoison = false
					TRB.Data.snapshot.targetData.targets[guid].woundPoisonRemaining = 0
				else
					-- Bleeds
					if TRB.Data.snapshot.targetData.targets[guid].crimsonTempest == true then
						crimsonTempestTotal = crimsonTempestTotal + 1
					end
					if TRB.Data.snapshot.targetData.targets[guid].garrote == true then
						garroteTotal = garroteTotal + 1
					end
					if TRB.Data.snapshot.targetData.targets[guid].internalBleeding == true then
						internalBleedingTotal = internalBleedingTotal + 1
					end
					if TRB.Data.snapshot.targetData.targets[guid].rupture == true then
						ruptureTotal = ruptureTotal + 1
					end
					if TRB.Data.snapshot.targetData.targets[guid].serratedBoneSpike == true then
						serratedBoneSpikeTotal = serratedBoneSpikeTotal + 1
					end
					-- Poisons
					if TRB.Data.snapshot.targetData.targets[guid].amplifyingPoison == true then
						amplifyingPoisonTotal = amplifyingPoisonTotal + 1
					end
					if TRB.Data.snapshot.targetData.targets[guid].atrophicPoison == true then
						atrophicPoisonTotal = atrophicPoisonTotal + 1
					end
					if TRB.Data.snapshot.targetData.targets[guid].cripplingPoison == true then
						cripplingPoisonTotal = cripplingPoisonTotal + 1
					end
					if TRB.Data.snapshot.targetData.targets[guid].deadlyPoison == true then
						deadlyPoisonTotal = deadlyPoisonTotal + 1
					end
					if TRB.Data.snapshot.targetData.targets[guid].numbingPoison == true then
						numbingPoisonTotal = numbingPoisonTotal + 1
					end
					if TRB.Data.snapshot.targetData.targets[guid].woundPoison == true then
						woundPoisonTotal = woundPoisonTotal + 1
					end
				end
			end
			--Bleeds
			TRB.Data.snapshot.targetData.crimsonTempest = crimsonTempestTotal
			TRB.Data.snapshot.targetData.garrote = garroteTotal
			TRB.Data.snapshot.targetData.internalBleeding = internalBleedingTotal
			TRB.Data.snapshot.targetData.rupture = ruptureTotal
			TRB.Data.snapshot.targetData.serratedBoneSpike = serratedBoneSpikeTotal
			--Poisons
			TRB.Data.snapshot.targetData.amplifyingPoison = amplifyingPoisonTotal
			TRB.Data.snapshot.targetData.atrophicPoison = atrophicPoisonTotal
			TRB.Data.snapshot.targetData.cripplingPoison = cripplingPoisonTotal
			TRB.Data.snapshot.targetData.deadlyPoison = deadlyPoisonTotal
			TRB.Data.snapshot.targetData.numbingPoison = numbingPoisonTotal
			TRB.Data.snapshot.targetData.woundPoison = woundPoisonTotal
		elseif specId == 2 then -- Outlaw
			-- Poisons
			local cripplingPoisonTotal = 0
			local woundPoisonTotal = 0
			local numbingPoisonTotal = 0
			for guid,count in pairs(TRB.Data.snapshot.targetData.targets) do
				if (currentTime - TRB.Data.snapshot.targetData.targets[guid].lastUpdate) > 20 then
					-- Poisons
					TRB.Data.snapshot.targetData.targets[guid].cripplingPoison = false
					TRB.Data.snapshot.targetData.targets[guid].cripplingPoisonRemaining = 0
					TRB.Data.snapshot.targetData.targets[guid].woundPoison = false
					TRB.Data.snapshot.targetData.targets[guid].woundPoisonRemaining = 0
					TRB.Data.snapshot.targetData.targets[guid].numbingPoison = false
					TRB.Data.snapshot.targetData.targets[guid].numbingPoisonRemaining = 0
				else
					-- Poisons
					if TRB.Data.snapshot.targetData.targets[guid].cripplingPoison == true then
						cripplingPoisonTotal = cripplingPoisonTotal + 1
					end
					if TRB.Data.snapshot.targetData.targets[guid].woundPoison == true then
						woundPoisonTotal = woundPoisonTotal + 1
					end
					if TRB.Data.snapshot.targetData.targets[guid].numbingPoison == true then
						numbingPoisonTotal = numbingPoisonTotal + 1
					end
				end
			end
			--Poisons
			TRB.Data.snapshot.targetData.cripplingPoison = cripplingPoisonTotal
			TRB.Data.snapshot.targetData.woundPoison = woundPoisonTotal
			TRB.Data.snapshot.targetData.numbingPoison = numbingPoisonTotal
		end
	end

	local function TargetsCleanup(clearAll)
		TRB.Functions.Target:TargetsCleanup(clearAll)
		if clearAll == true then
			local specId = GetSpecialization()
			if specId == 1 then
				--Bleeds
				TRB.Data.snapshot.targetData.crimsonTempest = 0
				TRB.Data.snapshot.targetData.internalBleeding = 0
				TRB.Data.snapshot.targetData.garrote = 0
				TRB.Data.snapshot.targetData.rupture = 0
				TRB.Data.snapshot.targetData.serratedBoneSpike = 0
				--Poisons
				TRB.Data.snapshot.targetData.atrophicPoison = 0
				TRB.Data.snapshot.targetData.amplifyingPoison = 0
				TRB.Data.snapshot.targetData.cripplingPoison = 0
				TRB.Data.snapshot.targetData.deadlyPoison = 0
				TRB.Data.snapshot.targetData.numbingPoison = 0
				TRB.Data.snapshot.targetData.woundPoison = 0
			elseif specId == 2 then
				--Poisons
				TRB.Data.snapshot.targetData.atrophicPoison = 0
				TRB.Data.snapshot.targetData.cripplingPoison = 0
				TRB.Data.snapshot.targetData.woundPoison = 0
				TRB.Data.snapshot.targetData.numbingPoison = 0
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

		for k, v in pairs(TRB.Data.spells) do
			local spell = TRB.Data.spells[k]
			if spell ~= nil and spell.id ~= nil and spell.energy ~= nil and spell.energy < 0 and spell.thresholdId ~= nil and spell.settingKey ~= nil then
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
		TRB.Frames.resource2ContainerFrame:Show()

		TRB.Functions.Bar:Construct(settings)
		
		if specId == 1 or specId == 2 then
			TRB.Functions.Bar:SetPosition(settings, TRB.Frames.barContainerFrame)
		end
	end

	local function RefreshLookupData_Assassination()
		local _
		--Spec specific implementation
		local currentTime = GetTime()

		-- This probably needs to be pulled every refresh
		TRB.Data.snapshot.energyRegen, _ = GetPowerRegen()

		--$overcap
		local overcap = TRB.Functions.Class:IsValidVariableForSpec("$overcap")

		local currentEnergyColor = TRB.Data.settings.rogue.assassination.colors.text.current
		local castingEnergyColor = TRB.Data.settings.rogue.assassination.colors.text.casting

		if TRB.Functions.Class:IsValidVariableForSpec("$inCombat") then
			if TRB.Data.settings.rogue.assassination.colors.text.overcapEnabled and overcap then
				currentEnergyColor = TRB.Data.settings.rogue.assassination.colors.text.overcap
				castingEnergyColor = TRB.Data.settings.rogue.assassination.colors.text.overcap
			elseif TRB.Data.settings.rogue.assassination.colors.text.overThresholdEnabled then
				local _overThreshold = false
				for k, v in pairs(TRB.Data.spells) do
					local spell = TRB.Data.spells[k]
					if	spell ~= nil and spell.thresholdUsable == true then
						_overThreshold = true
						break
					end
				end

				if _overThreshold then
					currentEnergyColor = TRB.Data.settings.rogue.assassination.colors.text.overThreshold
					castingEnergyColor = TRB.Data.settings.rogue.assassination.colors.text.overThreshold
				end
			end
		end

		if TRB.Data.snapshot.casting.resourceFinal < 0 then
			castingEnergyColor = TRB.Data.settings.rogue.assassination.colors.text.spending
		end

		--$energy
		local currentEnergy = string.format("|c%s%.0f|r", currentEnergyColor, TRB.Data.snapshot.resource)
		--$casting
		local castingEnergy = string.format("|c%s%.0f|r", castingEnergyColor, TRB.Data.snapshot.casting.resourceFinal)
		--$passive
		local _regenEnergy = 0
		local _passiveEnergy
		local _passiveEnergyMinusRegen

		local _gcd = TRB.Functions.Character:GetCurrentGCDTime(true)

		if TRB.Data.settings.rogue.assassination.generation.enabled then
			if TRB.Data.settings.rogue.assassination.generation.mode == "time" then
				_regenEnergy = TRB.Data.snapshot.energyRegen * (TRB.Data.settings.rogue.assassination.generation.time or 3.0)
			else
				_regenEnergy = TRB.Data.snapshot.energyRegen * ((TRB.Data.settings.rogue.assassination.generation.gcds or 2) * _gcd)
			end
		end

		--$regenEnergy
		local regenEnergy = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.assassination.colors.text.passive, _regenEnergy)

		_passiveEnergy = _regenEnergy
		_passiveEnergyMinusRegen = _passiveEnergy - _regenEnergy

		local passiveEnergy = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.assassination.colors.text.passive, _passiveEnergy)
		local passiveEnergyMinusRegen = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.assassination.colors.text.passive, _passiveEnergyMinusRegen)
		--$energyTotal
		local _energyTotal = math.min(_passiveEnergy + TRB.Data.snapshot.casting.resourceFinal + TRB.Data.snapshot.resource, TRB.Data.character.maxResource)
		local energyTotal = string.format("|c%s%.0f|r", currentEnergyColor, _energyTotal)
		--$energyPlusCasting
		local _energyPlusCasting = math.min(TRB.Data.snapshot.casting.resourceFinal + TRB.Data.snapshot.resource, TRB.Data.character.maxResource)
		local energyPlusCasting = string.format("|c%s%.0f|r", castingEnergyColor, _energyPlusCasting)
		--$energyPlusPassive
		local _energyPlusPassive = math.min(_passiveEnergy + TRB.Data.snapshot.resource, TRB.Data.character.maxResource)
		local energyPlusPassive = string.format("|c%s%.0f|r", currentEnergyColor, _energyPlusPassive)


		-- Bleeds
		-- TODO: Somehow account for pandemic being variable
		--$ctCount and $ctTime
		local _ctCount = TRB.Data.snapshot.targetData.crimsonTempest or 0
		local ctCount = tostring(_ctCount)
		local _ctTime = 0
		local ctTime
		
		--$garroteCount and $garroteTime
		local _garroteCount = TRB.Data.snapshot.targetData.garrote or 0
		local garroteCount = tostring(_garroteCount)
		local _garroteTime = 0
		local garroteTime
		
		--$ibCount and $ibTime
		local _ibCount = TRB.Data.snapshot.targetData.internalBleeding or 0
		local ibCount = tostring(_ibCount)
		local _ibTime = 0
		local ibTime
		
		--$ruptureCount and $ruptureTime
		local _ruptureCount = TRB.Data.snapshot.targetData.rupture or 0
		local ruptureCount = tostring(_ruptureCount)
		local _ruptureTime = 0
		local ruptureTime
		
		-- Poisons
		--$cpCount and $cpTime
		local _cpCount = TRB.Data.snapshot.targetData.cripplingPoison or 0
		local cpCount = tostring(_cpCount)
		local _cpTime = 0
		local cpTime
				
		--$dpCount and $cpTime
		local _dpCount = TRB.Data.snapshot.targetData.deadlyPoison or 0
		local dpCount = tostring(_dpCount)
		local _dpTime = 0
		local dpTime
				
		--$amplifyingPoisonCount and $amplifyingPoisonTime
		local _amplifyingPoisonCount = TRB.Data.snapshot.targetData.amplifyingPoison or 0
		local amplifyingPoisonCount = tostring(_amplifyingPoisonCount)
		local _amplifyingPoisonTime = 0
		local amplifyingPoisonTime
				
		--$npCount and $npTime
		local _npCount = TRB.Data.snapshot.targetData.numbingPoison or 0
		local npCount = tostring(_npCount)
		local _npTime = 0
		local npTime
				
		--$npCount and $npTime
		local _atrophicPoisonCount = TRB.Data.snapshot.targetData.atrophicPoison or 0
		local atrophicPoisonCount = tostring(_atrophicPoisonCount)
		local _atrophicPoisonTime = 0
		local atrophicPoisonTime
				
		--$wpCount and $wpTime
		local _wpCount = TRB.Data.snapshot.targetData.woundPoison or 0
		local wpCount = tostring(_wpCount)
		local _wpTime = 0
		local wpTime
		
		--$sbsCount
		local _sbsCount = TRB.Data.snapshot.targetData.serratedBoneSpike or 0
		local sbsCount = tostring(_sbsCount)
		local _sbsOnTarget = false


		if TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid] ~= nil then
			_ctTime = TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].crimsonTempestRemaining or 0
			_garroteTime = TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].garroteRemaining or 0
			_ibTime = TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].internalBleedingRemaining or 0
			_ruptureTime = TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].ruptureRemaining or 0
			_cpTime = TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].cripplingPoisonRemaining or 0
			_dpTime = TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].deadlyPoisonRemaining or 0
			_npTime = TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].numbingPoisonRemaining or 0
			_atrophicPoisonTime = TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].atrophicPoisonRemaining or 0
			_amplifyingPoisonTime = TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].amplifyingPoisonRemaining or 0
			_wpTime = TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].woundPoisonRemaining or 0
			_sbsOnTarget = TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].serratedBoneSpike or false
		end


		if TRB.Data.settings.rogue.assassination.colors.text.dots.enabled and TRB.Data.snapshot.targetData.currentTargetGuid ~= nil and not UnitIsDeadOrGhost("target") and UnitCanAttack("player", "target") then
			-- Bleeds
			if _ctTime > TRB.Data.spells.crimsonTempest.pandemicTimes[TRB.Data.snapshot.resource2 + 1] then
				ctCount = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.up, _ctCount)
				ctTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.up, _ctTime)
			elseif _ctTime > 0 then
				ctCount = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.pandemic, _ctCount)
				ctTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.pandemic, _ctTime)
			else
				ctCount = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.down, _ctCount)
				ctTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.down, 0)
			end

			if _garroteTime > TRB.Data.spells.garrote.pandemicTime then
				garroteCount = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.up, _garroteCount)
				garroteTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.up, _garroteTime)
			elseif _garroteTime > 0 then
				garroteCount = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.pandemic, _garroteCount)
				garroteTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.pandemic, _garroteTime)
			else
				garroteCount = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.down, _garroteCount)
				garroteTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.down, 0)
			end
						
			if _ibTime > 0 then
				ibCount = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.up, _ibCount)
				ibTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.up, _ibTime)
			else
				ibCount = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.down, _ibCount)
				ibTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.down, 0)
			end

			if _ruptureTime > TRB.Data.spells.rupture.pandemicTimes[TRB.Data.snapshot.resource2 + 1] then
				ruptureCount = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.up, _ruptureCount)
				ruptureTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.up, _ruptureTime)
			elseif _ruptureTime > 0 then
				ruptureCount = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.pandemic, _ruptureCount)
				ruptureTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.pandemic, _ruptureTime)
			else
				ruptureCount = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.down, _ruptureCount)
				ruptureTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.down, 0)
			end

			--Poisons
			if _cpTime > 0 then
				cpCount = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.up, _cpCount)
				cpTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.up, _cpTime)
			else
				cpCount = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.down, _cpCount)
				cpTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.down, 0)
			end

			if _dpTime > 0 then
				dpCount = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.up, _dpCount)
				dpTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.up, _dpTime)
			else
				dpCount = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.down, _dpCount)
				dpTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.down, 0)
			end

			if _npTime > 0 then
				npCount = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.up, _npCount)
				npTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.up, _npTime)
			else
				npCount = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.down, _npCount)
				npTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.down, 0)
			end

			if _wpTime > 0 then
				wpCount = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.up, _wpCount)
				wpTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.up, _wpTime)
			else
				wpCount = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.down, _wpCount)
				wpTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.down, 0)
			end

			if _atrophicPoisonTime > 0 then
				atrophicPoisonCount = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.up, _atrophicPoisonCount)
				atrophicPoisonTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.up, _atrophicPoisonTime)
			else
				atrophicPoisonCount = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.down, _atrophicPoisonCount)
				atrophicPoisonTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.down, 0)
			end

			if _amplifyingPoisonTime > 0 then
				amplifyingPoisonCount = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.up, _amplifyingPoisonCount)
				amplifyingPoisonTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.up, _amplifyingPoisonTime)
			else
				amplifyingPoisonCount = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.down, _amplifyingPoisonCount)
				amplifyingPoisonTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.down, 0)
			end

			if _sbsOnTarget == false and TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.serratedBoneSpike) then
				sbsCount = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.down, _sbsCount)
			else
				sbsCount = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.up, _sbsCount)
			end
		else
			-- Bleeds
			ctTime = string.format("%.1f", _ctTime)
			garroteTime = string.format("%.1f", _garroteTime)
			ibTime = string.format("%.1f", _ibTime)
			ruptureTime = string.format("%.1f", _ruptureTime)

			-- Poisons
			amplifyingPoisonTime = string.format("%.1f", _amplifyingPoisonTime)
			atrophicPoisonTime = string.format("%.1f", _atrophicPoisonTime)
			cpTime = string.format("%.1f", _cpTime)
			dpTime = string.format("%.1f", _dpTime)
			npTime = string.format("%.1f", _npTime)
			wpTime = string.format("%.1f", _wpTime)
		end
		

		--$sadTime
		local _sadTime = 0
		local sadTime
		if TRB.Data.snapshot.sliceAndDice.spellId ~= nil then
			_sadTime = GetSliceAndDiceRemainingTime()
		end
		
		if _sadTime > TRB.Data.spells.sliceAndDice.pandemicTimes[TRB.Data.snapshot.resource2 + 1] then
			sadTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.up, _sadTime)
		elseif _sadTime > 0 then
			sadTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.pandemic, _sadTime)
		else
			sadTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.assassination.colors.text.dots.down, 0)
		end

		
		--$blindsideTime
		local _blindsideTime = GetBlindsideRemainingTime()
		local blindsideTime = "0.0"
		if _blindsideTime ~= nil then
			blindsideTime = string.format("%.1f", _blindsideTime)
		end

		----------------------------

		Global_TwintopResourceBar.resource.passive = _passiveEnergy
		Global_TwintopResourceBar.resource.regen = _regenEnergy
		Global_TwintopResourceBar.dots = {
			amplifyingPoisonCount = _amplifyingPoisonCount,
			atrophicPoisonCount = _atrophicPoisonCount,
			cripplingPoisonCount = _cpCount,
			deadlyPoisonCount = _dpCount,
			numbingPoisonCount = _npCount,
			woundPoisonCount = _wpCount,
			crimsonTempestCount = _ctCount,
			garroteCount = _garroteCount,
			internalBleedingCount = _ibCount,
			ruptureCount = _ruptureCount,
			serratedBoneSpikeCount = _sbsCount
		}

		local lookup = TRB.Data.lookup or {}
		lookup["#amplifyingPoison"] = TRB.Data.spells.amplifyingPoison.icon
		lookup["#atrophicPoison"] = TRB.Data.spells.atrophicPoison.icon
		lookup["#blindside"] = TRB.Data.spells.blindside.icon
		lookup["#crimsonTempest"] = TRB.Data.spells.crimsonTempest.icon
		lookup["#ct"] = TRB.Data.spells.crimsonTempest.icon
		lookup["#cripplingPoison"] = TRB.Data.spells.cripplingPoison.icon
		lookup["#cp"] = TRB.Data.spells.cripplingPoison.icon
		lookup["#deadlyPoison"] = TRB.Data.spells.deadlyPoison.icon
		lookup["#dp"] = TRB.Data.spells.deadlyPoison.icon
		lookup["#deathFromAbove"] = TRB.Data.spells.deathFromAbove.icon
		lookup["#dismantle"] = TRB.Data.spells.dismantle.icon
		lookup["#echoingReprimand"] = TRB.Data.spells.echoingReprimand.icon
		lookup["#garrote"] = TRB.Data.spells.garrote.icon
		lookup["#internalBleeding"] = TRB.Data.spells.internalBleeding.icon
		lookup["#ib"] = TRB.Data.spells.internalBleeding.icon
		lookup["#numbingPoison"] = TRB.Data.spells.numbingPoison.icon
		lookup["#np"] = TRB.Data.spells.numbingPoison.icon
		lookup["#rupture"] = TRB.Data.spells.rupture.icon
		lookup["#sad"] = TRB.Data.spells.sliceAndDice.icon
		lookup["#sliceAndDice"] = TRB.Data.spells.sliceAndDice.icon
		lookup["#sepsis"] = TRB.Data.spells.sepsis.icon
		lookup["#serratedBoneSpike"] = TRB.Data.spells.serratedBoneSpike.icon
		lookup["#stealth"] = TRB.Data.spells.stealth.icon
		lookup["#woundPoison"] = TRB.Data.spells.woundPoison.icon
		lookup["#wp"] = TRB.Data.spells.woundPoison.icon

		lookup["$energyPlusCasting"] = energyPlusCasting
		lookup["$energyTotal"] = energyTotal
		lookup["$energyMax"] = TRB.Data.character.maxResource
		lookup["$energy"] = currentEnergy
		lookup["$resourcePlusCasting"] = energyPlusCasting
		lookup["$resourcePlusPassive"] = energyPlusPassive
		lookup["$resourceTotal"] = energyTotal
		lookup["$resourceMax"] = TRB.Data.character.maxResource
		lookup["$resource"] = currentEnergy
		lookup["$casting"] = castingEnergy
		lookup["$comboPoints"] = TRB.Data.character.resource2
		lookup["$comboPointsMax"] = TRB.Data.character.maxResource2
		lookup["$amplifyingPoisonCount"] = amplifyingPoisonCount
		lookup["$amplifyingPoisonTime"] = amplifyingPoisonTime
		lookup["$atrophicPoisonCount"] = atrophicPoisonCount
		lookup["$atrophicPoisonTime"] = atrophicPoisonTime
		lookup["$cpCount"] = cpCount
		lookup["$cripplingPoisonCount"] = cpCount
		lookup["$cpTime"] = cpTime
		lookup["$cripplingPoisonTime"] = cpTime
		lookup["$dpCount"] = dpCount
		lookup["$deadlyPoisonCount"] = dpCount
		lookup["$dpTime"] = dpTime
		lookup["$deadlyPoisonTime"] = dpTime
		lookup["$npCount"] = npCount
		lookup["$numbingPoisonCount"] = npCount
		lookup["$npTime"] = npTime
		lookup["$numbingPoisonTime"] = npTime
		lookup["$wpCount"] = wpCount
		lookup["$woundPoisonCount"] = wpCount
		lookup["$wpTime"] = wpTime
		lookup["$woundPoisonTime"] = wpTime
		lookup["$ctCount"] = ctCount
		lookup["$crimsonTempestCount"] = ctCount
		lookup["$ctTime"] = ctTime
		lookup["$crimsonTempestTime"] = ctTime
		lookup["$garroteCount"] = garroteCount
		lookup["$garroteTime"] = garroteTime
		lookup["$ibCount"] = ibCount
		lookup["$internalBleedingCount"] = ibCount
		lookup["$ibTime"] = ibTime
		lookup["$internalBleedingTime"] = ibTime
		lookup["$ruptureCount"] = ruptureCount
		lookup["$ruptureTime"] = ruptureTime
		lookup["$sbsCount"] = sbsCount
		lookup["$serratedBoneSpikeCount"] = sbsCount
		lookup["$sadTime"] = sadTime
		lookup["$sliceAndDiceTime"] = sadTime
		lookup["$blindsideTime"] = blindsideTime
		lookup["$isBleeding"] = ""
		lookup["$inStealth"] = ""

		if TRB.Data.character.maxResource == TRB.Data.snapshot.resource then
			lookup["$passive"] = passiveEnergyMinusRegen
		else
			lookup["$passive"] = passiveEnergy
		end

		lookup["$regen"] = regenEnergy
		lookup["$regenEnergy"] = regenEnergy
		lookup["$energyRegen"] = regenEnergy
		lookup["$overcap"] = overcap
		lookup["$resourceOvercap"] = overcap
		lookup["$energyOvercap"] = overcap
		TRB.Data.lookup = lookup

		local lookupLogic = TRB.Data.lookupLogic or {}
		lookupLogic["$energyPlusCasting"] = _energyPlusCasting
		lookupLogic["$energyTotal"] = _energyTotal
		lookupLogic["$energyMax"] = TRB.Data.character.maxResource
		lookupLogic["$energy"] = TRB.Data.snapshot.resource
		lookupLogic["$resourcePlusCasting"] = _energyPlusCasting
		lookupLogic["$resourcePlusPassive"] = _energyPlusPassive
		lookupLogic["$resourceTotal"] = _energyTotal
		lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
		lookupLogic["$resource"] = TRB.Data.snapshot.resource
		lookupLogic["$casting"] = TRB.Data.snapshot.casting.resourceFinal
		lookupLogic["$comboPoints"] = TRB.Data.character.resource2
		lookupLogic["$comboPointsMax"] = TRB.Data.character.maxResource2
		lookupLogic["$amplifyingPoisonCount"] = amplifyingPoisonCount
		lookupLogic["$amplifyingPoisonTime"] = amplifyingPoisonTime
		lookupLogic["$atrophicPoisonCount"] = atrophicPoisonCount
		lookupLogic["$atrophicPoisonTime"] = atrophicPoisonTime
		lookupLogic["$cpCount"] = _cpCount
		lookupLogic["$cripplingPoisonCount"] = _cpCount
		lookupLogic["$cpTime"] = _cpTime
		lookupLogic["$cripplingPoisonTime"] = _cpTime
		lookupLogic["$dpCount"] = _dpCount
		lookupLogic["$deadlyPoisonCount"] = _dpCount
		lookupLogic["$dpTime"] = _dpTime
		lookupLogic["$deadlyPoisonTime"] = _dpTime
		lookupLogic["$npCount"] = _npCount
		lookupLogic["$numbingPoisonCount"] = _npCount
		lookupLogic["$npTime"] = _npTime
		lookupLogic["$numbingPoisonTime"] = _npTime
		lookupLogic["$wpCount"] = _wpCount
		lookupLogic["$woundPoisonCount"] = _wpCount
		lookupLogic["$wpTime"] = _wpTime
		lookupLogic["$woundPoisonTime"] = _wpTime
		lookupLogic["$ctCount"] = _ctCount
		lookupLogic["$crimsonTempestCount"] = _ctCount
		lookupLogic["$ctTime"] = _ctTime
		lookupLogic["$crimsonTempestTime"] = _ctTime
		lookupLogic["$garroteCount"] = _garroteCount
		lookupLogic["$garroteTime"] = _garroteTime
		lookupLogic["$ibCount"] = _ibCount
		lookupLogic["$internalBleedingCount"] = _ibCount
		lookupLogic["$ibTime"] = _ibTime
		lookupLogic["$internalBleedingTime"] = _ibTime
		lookupLogic["$ruptureCount"] = _ruptureCount
		lookupLogic["$ruptureTime"] = _ruptureTime
		lookupLogic["$sbsCount"] = _sbsCount
		lookupLogic["$serratedBoneSpikeCount"] = _sbsCount
		lookupLogic["$sadTime"] = _sadTime
		lookupLogic["$sliceAndDiceTime"] = _sadTime
		lookupLogic["$blindsideTime"] = _blindsideTime
		lookupLogic["$isBleeding"] = ""
		lookupLogic["$inStealth"] = ""

		if TRB.Data.character.maxResource == TRB.Data.snapshot.resource then
			lookupLogic["$passive"] = _passiveEnergyMinusRegen
		else
			lookupLogic["$passive"] = _passiveEnergy
		end

		lookupLogic["$regen"] = _regenEnergy
		lookupLogic["$regenEnergy"] = _regenEnergy
		lookupLogic["$energyRegen"] = _regenEnergy
		lookupLogic["$overcap"] = overcap
		lookupLogic["$resourceOvercap"] = overcap
		lookupLogic["$energyOvercap"] = overcap
		TRB.Data.lookupLogic = lookupLogic
	end

	local function RefreshLookupData_Outlaw()
		local _
		--Spec specific implementation
		local currentTime = GetTime()

		-- This probably needs to be pulled every refresh
		TRB.Data.snapshot.energyRegen, _ = GetPowerRegen()

		--$overcap
		local overcap = TRB.Functions.Class:IsValidVariableForSpec("$overcap")

		local currentEnergyColor = TRB.Data.settings.rogue.outlaw.colors.text.current
		local castingEnergyColor = TRB.Data.settings.rogue.outlaw.colors.text.casting

		if TRB.Functions.Class:IsValidVariableForSpec("$inCombat") then
			if TRB.Data.settings.rogue.outlaw.colors.text.overcapEnabled and overcap then
				currentEnergyColor = TRB.Data.settings.rogue.outlaw.colors.text.overcap
				castingEnergyColor = TRB.Data.settings.rogue.outlaw.colors.text.overcap
			elseif TRB.Data.settings.rogue.outlaw.colors.text.overThresholdEnabled then
				local _overThreshold = false
				for k, v in pairs(TRB.Data.spells) do
					local spell = TRB.Data.spells[k]
					if	spell ~= nil and spell.thresholdUsable == true then
						_overThreshold = true
						break
					end
				end

				if _overThreshold then
					currentEnergyColor = TRB.Data.settings.rogue.outlaw.colors.text.overThreshold
					castingEnergyColor = TRB.Data.settings.rogue.outlaw.colors.text.overThreshold
				end
			end
		end

		if TRB.Data.snapshot.casting.resourceFinal < 0 then
			castingEnergyColor = TRB.Data.settings.rogue.outlaw.colors.text.spending
		end

		--$energy
		local currentEnergy = string.format("|c%s%.0f|r", currentEnergyColor, TRB.Data.snapshot.resource)
		--$casting
		local castingEnergy = string.format("|c%s%.0f|r", castingEnergyColor, TRB.Data.snapshot.casting.resourceFinal)
		--$passive
		local _regenEnergy = 0
		local _passiveEnergy
		local _passiveEnergyMinusRegen

		local _gcd = TRB.Functions.Character:GetCurrentGCDTime(true)

		if TRB.Data.settings.rogue.outlaw.generation.enabled then
			if TRB.Data.settings.rogue.outlaw.generation.mode == "time" then
				_regenEnergy = TRB.Data.snapshot.energyRegen * (TRB.Data.settings.rogue.outlaw.generation.time or 3.0)
			else
				_regenEnergy = TRB.Data.snapshot.energyRegen * ((TRB.Data.settings.rogue.outlaw.generation.gcds or 2) * _gcd)
			end
		end

		--$regenEnergy
		local regenEnergy = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.outlaw.colors.text.passive, _regenEnergy)

		_passiveEnergy = _regenEnergy
		_passiveEnergyMinusRegen = _passiveEnergy - _regenEnergy

		local passiveEnergy = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.outlaw.colors.text.passive, _passiveEnergy)
		local passiveEnergyMinusRegen = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.outlaw.colors.text.passive, _passiveEnergyMinusRegen)
		--$energyTotal
		local _energyTotal = math.min(_passiveEnergy + TRB.Data.snapshot.casting.resourceFinal + TRB.Data.snapshot.resource, TRB.Data.character.maxResource)
		local energyTotal = string.format("|c%s%.0f|r", currentEnergyColor, _energyTotal)
		--$energyPlusCasting
		local _energyPlusCasting = math.min(TRB.Data.snapshot.casting.resourceFinal + TRB.Data.snapshot.resource, TRB.Data.character.maxResource)
		local energyPlusCasting = string.format("|c%s%.0f|r", castingEnergyColor, _energyPlusCasting)
		--$energyPlusPassive
		local _energyPlusPassive = math.min(_passiveEnergy + TRB.Data.snapshot.resource, TRB.Data.character.maxResource)
		local energyPlusPassive = string.format("|c%s%.0f|r", currentEnergyColor, _energyPlusPassive)

		-- Poisons
		--$cpCount and $cpTime
		local _cpCount = TRB.Data.snapshot.targetData.cripplingPoison or 0
		local cpCount = tostring(_cpCount)
		local _cpTime = 0
		local cpTime
			
		--$npCount and $npTime
		local _npCount = TRB.Data.snapshot.targetData.numbingPoison or 0
		local npCount = tostring(_npCount)
		local _npTime = 0
		local npTime
				
		--$wpCount and $wpTime
		local _wpCount = TRB.Data.snapshot.targetData.woundPoison or 0
		local wpCount = tostring(_wpCount)
		local _wpTime = 0
		local wpTime


		if TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid] ~= nil then
			_npTime = TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].numbingPoisonRemaining or 0
			_wpTime = TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].woundPoisonRemaining or 0
		end


		if TRB.Data.settings.rogue.outlaw.colors.text.dots.enabled and TRB.Data.snapshot.targetData.currentTargetGuid ~= nil and not UnitIsDeadOrGhost("target") and UnitCanAttack("player", "target") then
			--Poisons
			if _cpTime > 0 then
				cpCount = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.outlaw.colors.text.dots.up, _cpCount)
				cpTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.outlaw.colors.text.dots.up, _cpTime)
			else
				cpCount = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.outlaw.colors.text.dots.down, _cpCount)
				cpTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.outlaw.colors.text.dots.down, 0)
			end

			if _npTime > 0 then
				npCount = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.outlaw.colors.text.dots.up, _npCount)
				npTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.outlaw.colors.text.dots.up, _npTime)
			else
				npCount = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.outlaw.colors.text.dots.down, _npCount)
				npTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.outlaw.colors.text.dots.down, 0)
			end

			if _wpTime > 0 then
				wpCount = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.outlaw.colors.text.dots.up, _wpCount)
				wpTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.outlaw.colors.text.dots.up, _wpTime)
			else
				wpCount = string.format("|c%s%.0f|r", TRB.Data.settings.rogue.outlaw.colors.text.dots.down, _wpCount)
				wpTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.outlaw.colors.text.dots.down, 0)
			end
		else
			-- Poisons
			cpTime = string.format("%.1f", _cpTime)
			npTime = string.format("%.1f", _npTime)
			wpTime = string.format("%.1f", _wpTime)
		end

		local rollTheBonesCount = TRB.Data.snapshot.rollTheBones.count
		local rollTheBonesTemporaryCount = TRB.Data.snapshot.rollTheBones.temporaryCount
		local rollTheBonesAllCount = TRB.Data.snapshot.rollTheBones.count + TRB.Data.snapshot.rollTheBones.temporaryCount

		--$sadTime
		local _sadTime = 0
		local sadTime
		if TRB.Data.snapshot.sliceAndDice.spellId ~= nil then
			_sadTime = GetSliceAndDiceRemainingTime()
		end
		
		if _sadTime > TRB.Data.spells.sliceAndDice.pandemicTimes[TRB.Data.snapshot.resource2 + 1] then
			sadTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.outlaw.colors.text.dots.up, _sadTime)
		elseif _sadTime > 0 then
			sadTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.outlaw.colors.text.dots.pandemic, _sadTime)
		else
			sadTime = string.format("|c%s%.1f|r", TRB.Data.settings.rogue.outlaw.colors.text.dots.down, 0)
		end

		--$rtbBuffTime
		local _rtbBuffTime = TRB.Data.snapshot.rollTheBones.remaining
		local rtbBuffTime = string.format("%.1f", _rtbBuffTime)

		--$broadsideTime
		local _broadsideTime = TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshot.rollTheBones.buffs.broadside)
		local broadsideTime = string.format("%.1f", _broadsideTime)

		--$buriedTreasureTime
		local _buriedTreasureTime = TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshot.rollTheBones.buffs.buriedTreasure)
		local buriedTreasureTime = string.format("%.1f", _buriedTreasureTime)

		--$grandMeleeTime
		local _grandMeleeTime = TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshot.rollTheBones.buffs.grandMelee)
		local grandMeleeTime = string.format("%.1f", _grandMeleeTime)

		--$ruthlessPrecisionTime
		local _ruthlessPrecisionTime = TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshot.rollTheBones.buffs.ruthlessPrecision)
		local ruthlessPrecisionTime = string.format("%.1f", _ruthlessPrecisionTime)

		--$skullAndCrossbonesTime
		local _skullAndCrossbonesTime = TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshot.rollTheBones.buffs.skullAndCrossbones)
		local skullAndCrossbonesTime = string.format("%.1f", _skullAndCrossbonesTime)

		--$trueBearingTime
		local _trueBearingTime = TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshot.rollTheBones.buffs.trueBearing)
		local trueBearingTime = string.format("%.1f", _trueBearingTime)
		
		--$opportunityTime
		local _opportunityTime = GetOpportunityRemainingTime()
		local opportunityTime = string.format("%.1f", _opportunityTime)

		----------------------------

		Global_TwintopResourceBar.resource.passive = _passiveEnergy
		Global_TwintopResourceBar.resource.regen = _regenEnergy
		Global_TwintopResourceBar.dots = {
			cripplingPoisonCount = _cpCount,
			numbingPoisonCount = _npCount,
			woundPoisonCount = _wpCount
		}

		local lookup = TRB.Data.lookup or {}
		lookup["#adrenalineRush"] = TRB.Data.spells.adrenalineRush.icon
		lookup["#betweenTheEyes"] = TRB.Data.spells.betweenTheEyes.icon
		lookup["#bladeFlurry"] = TRB.Data.spells.bladeFlurry.icon
		lookup["#bladeRush"] = TRB.Data.spells.bladeRush.icon
		lookup["#broadside"] = TRB.Data.spells.broadside.icon
		lookup["#buriedTreasure"] = TRB.Data.spells.buriedTreasure.icon
		lookup["#deathFromAbove"] = TRB.Data.spells.numbingPoison.icon
		lookup["#dirtyTricks"] = TRB.Data.spells.dirtyTricks.icon
		lookup["#dispatch"] = TRB.Data.spells.dispatch.icon
		lookup["#dismantle"] = TRB.Data.spells.numbingPoison.icon
		lookup["#dreadblades"] = TRB.Data.spells.dreadblades.icon
		lookup["#cripplingPoison"] = TRB.Data.spells.cripplingPoison.icon
		lookup["#cp"] = TRB.Data.spells.cripplingPoison.icon
		lookup["#dismantle"] = TRB.Data.spells.dismantle.icon
		lookup["#echoingReprimand"] = TRB.Data.spells.echoingReprimand.icon
		lookup["#ghostlyStrike"] = TRB.Data.spells.ghostlyStrike.icon
		lookup["#grandMelee"] = TRB.Data.spells.grandMelee.icon
		lookup["#numbingPoison"] = TRB.Data.spells.numbingPoison.icon
		lookup["#np"] = TRB.Data.spells.numbingPoison.icon
		lookup["#opportunity"] = TRB.Data.spells.opportunity.icon
		lookup["#pistolShot"] = TRB.Data.spells.pistolShot.icon
		lookup["#rollTheBones"] = TRB.Data.spells.rollTheBones.icon
		lookup["#ruthlessPrecision"] = TRB.Data.spells.ruthlessPrecision.icon
		lookup["#sad"] = TRB.Data.spells.sliceAndDice.icon
		lookup["#sliceAndDice"] = TRB.Data.spells.sliceAndDice.icon
		lookup["#sepsis"] = TRB.Data.spells.sepsis.icon
		lookup["#sinisterStrike"] = TRB.Data.spells.sinisterStrike.icon
		lookup["#skullAndCrossbones"] = TRB.Data.spells.skullAndCrossbones.icon
		lookup["#stealth"] = TRB.Data.spells.stealth.icon
		lookup["#trueBearing"] = TRB.Data.spells.trueBearing.icon
		lookup["#woundPoison"] = TRB.Data.spells.woundPoison.icon
		lookup["#wp"] = TRB.Data.spells.woundPoison.icon

		lookup["$energyPlusCasting"] = energyPlusCasting
		lookup["$energyTotal"] = energyTotal
		lookup["$energyMax"] = TRB.Data.character.maxResource
		lookup["$energy"] = currentEnergy
		lookup["$resourcePlusCasting"] = energyPlusCasting
		lookup["$resourcePlusPassive"] = energyPlusPassive
		lookup["$resourceTotal"] = energyTotal
		lookup["$resourceMax"] = TRB.Data.character.maxResource
		lookup["$resource"] = currentEnergy
		lookup["$casting"] = castingEnergy
		lookup["$comboPoints"] = TRB.Data.character.resource2
		lookup["$comboPointsMax"] = TRB.Data.character.maxResource2
		lookup["$cpCount"] = cpCount
		lookup["$cripplingPoisonCount"] = cpCount
		lookup["$cpTime"] = cpTime
		lookup["$cripplingPoisonTime"] = cpTime
		lookup["$npCount"] = npCount
		lookup["$numbingPoisonCount"] = npCount
		lookup["$npTime"] = npTime
		lookup["$numbingPoisonTime"] = npTime
		lookup["$wpCount"] = wpCount
		lookup["$woundPoisonCount"] = wpCount
		lookup["$wpTime"] = wpTime
		lookup["$woundPoisonTime"] = wpTime
		lookup["$sadTime"] = sadTime
		lookup["$sliceAndDiceTime"] = sadTime
		lookup["$opportunityTime"] = opportunityTime
		lookup["$rtbCount"] = rollTheBonesCount
		lookup["$rollTheBonesCount"] = rollTheBonesCount
		lookup["$rtbAllCount"] = rollTheBonesAllCount
		lookup["$rollTheBonesAllCount"] = rollTheBonesAllCount
		lookup["$rtbTemporaryCount"] = rollTheBonesTemporaryCount
		lookup["$rollTheBonesTemporaryCount"] = rollTheBonesTemporaryCount
		lookup["$rtbBuffTime"] = rtbBuffTime
		lookup["$rollTheBonesBuffTime"] = rtbBuffTime
		lookup["$broadsideTime"] = broadsideTime
		lookup["$buriedTreasureTime"] = buriedTreasureTime
		lookup["$grandMeleeTime"] = grandMeleeTime
		lookup["$ruthlessPrecisionTime"] = ruthlessPrecisionTime
		lookup["$skullAndCrossbonesTime"] = skullAndCrossbonesTime
		lookup["$trueBearingTime"] = trueBearingTime

		if TRB.Data.character.maxResource == TRB.Data.snapshot.resource then
			lookup["$passive"] = passiveEnergyMinusRegen
		else
			lookup["$passive"] = passiveEnergy
		end

		lookup["$regen"] = regenEnergy
		lookup["$regenEnergy"] = regenEnergy
		lookup["$energyRegen"] = regenEnergy
		lookup["$overcap"] = overcap
		lookup["$resourceOvercap"] = overcap
		lookup["$energyOvercap"] = overcap
		lookup["$inStealth"] = ""
		TRB.Data.lookup = lookup

		local lookupLogic = TRB.Data.lookupLogic or {}
		lookupLogic["$energyPlusCasting"] = _energyPlusCasting
		lookupLogic["$energyTotal"] = _energyTotal
		lookupLogic["$energyMax"] = TRB.Data.character.maxResource
		lookupLogic["$energy"] = TRB.Data.snapshot.resource
		lookupLogic["$resourcePlusCasting"] = _energyPlusCasting
		lookupLogic["$resourcePlusPassive"] = _energyPlusPassive
		lookupLogic["$resourceTotal"] = _energyTotal
		lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
		lookupLogic["$resource"] = TRB.Data.snapshot.resource
		lookupLogic["$casting"] = TRB.Data.snapshot.casting.resourceFinal
		lookupLogic["$comboPoints"] = TRB.Data.character.resource2
		lookupLogic["$comboPointsMax"] = TRB.Data.character.maxResource2
		lookupLogic["$cpCount"] = _cpCount
		lookupLogic["$cripplingPoisonCount"] = _cpCount
		lookupLogic["$cpTime"] = _cpTime
		lookupLogic["$cripplingPoisonTime"] = _cpTime
		lookupLogic["$npCount"] = _npCount
		lookupLogic["$numbingPoisonCount"] = _npCount
		lookupLogic["$npTime"] = _npTime
		lookupLogic["$numbingPoisonTime"] = _npTime
		lookupLogic["$wpCount"] = _wpCount
		lookupLogic["$woundPoisonCount"] = _wpCount
		lookupLogic["$wpTime"] = _wpTime
		lookupLogic["$woundPoisonTime"] = _wpTime
		lookupLogic["$sadTime"] = _sadTime
		lookupLogic["$sliceAndDiceTime"] = _sadTime
		lookupLogic["$opportunityTime"] = _opportunityTime
		lookupLogic["$rtbCount"] = rollTheBonesCount
		lookupLogic["$rollTheBonesCount"] = rollTheBonesCount
		lookupLogic["$rtbAllCount"] = rollTheBonesAllCount
		lookupLogic["$rollTheBonesAllCount"] = rollTheBonesAllCount
		lookupLogic["$rtbTemporaryCount"] = rollTheBonesTemporaryCount
		lookupLogic["$rollTheBonesTemporaryCount"] = rollTheBonesTemporaryCount
		lookupLogic["$rtbBuffTime"] = _rtbBuffTime
		lookupLogic["$rollTheBonesBuffTime"] = _rtbBuffTime
		lookupLogic["$broadsideTime"] = _broadsideTime
		lookupLogic["$buriedTreasureTime"] = _buriedTreasureTime
		lookupLogic["$grandMeleeTime"] = _grandMeleeTime
		lookupLogic["$ruthlessPrecisionTime"] = _ruthlessPrecisionTime
		lookupLogic["$skullAndCrossbonesTime"] = _skullAndCrossbonesTime
		lookupLogic["$trueBearingTime"] = _trueBearingTime

		if TRB.Data.character.maxResource == TRB.Data.snapshot.resource then
			lookupLogic["$passive"] = _passiveEnergyMinusRegen
		else
			lookupLogic["$passive"] = _passiveEnergy
		end

		lookupLogic["$regen"] = _regenEnergy
		lookupLogic["$regenEnergy"] = _regenEnergy
		lookupLogic["$energyRegen"] = _regenEnergy
		lookupLogic["$overcap"] = overcap
		lookupLogic["$resourceOvercap"] = overcap
		lookupLogic["$energyOvercap"] = overcap
		lookupLogic["$inStealth"] = ""
		TRB.Data.lookupLogic = lookupLogic
	end

	local function FillSnapshotDataCasting(spell)
		local currentTime = GetTime()
		TRB.Data.snapshot.casting.startTime = currentTime
		TRB.Data.snapshot.casting.resourceRaw = spell.energy
		TRB.Data.snapshot.casting.resourceFinal = CalculateAbilityResourceValue(spell.energy)
		TRB.Data.snapshot.casting.spellId = spell.id
		TRB.Data.snapshot.casting.icon = spell.icon
	end

	local function CastingSpell()
		local specId = GetSpecialization()
		local currentSpell = UnitCastingInfo("player")
		local currentChannel = UnitChannelInfo("player")

		if currentSpell == nil and currentChannel == nil then
			TRB.Functions.Character:ResetCastingSnapshotData()
			return false
		else
			if specId == 1 or specId == 2 then
				if currentSpell == nil then
					local spellName = select(1, currentChannel)
						TRB.Functions.Character:ResetCastingSnapshotData()
						return false
					--See Priest implementation for handling channeled spells
				else
					local spellName = select(1, currentSpell)
					return false
				end
			end
			TRB.Functions.Character:ResetCastingSnapshotData()
			return false
		end
	end

	local function UpdateSnapshot()
		TRB.Functions.Character:UpdateSnapshot()
		local currentTime = GetTime()

		_, _, _, _, _, TRB.Data.snapshot.sliceAndDice.endTime, _, _, _, TRB.Data.snapshot.sliceAndDice.spellId = TRB.Functions.Aura:FindBuffById(TRB.Data.spells.sliceAndDice.id)

		if TRB.Data.snapshot.distract.startTime ~= nil and currentTime > (TRB.Data.snapshot.distract.startTime + TRB.Data.snapshot.distract.duration) then
			TRB.Data.snapshot.distract.startTime = nil
			TRB.Data.snapshot.distract.duration = 0
		end

		if TRB.Data.snapshot.feint.startTime ~= nil and currentTime > (TRB.Data.snapshot.feint.startTime + TRB.Data.snapshot.feint.duration) then
			TRB.Data.snapshot.feint.startTime = nil
			TRB.Data.snapshot.feint.duration = 0
		end

		if TRB.Data.snapshot.kidneyShot.startTime ~= nil and currentTime > (TRB.Data.snapshot.kidneyShot.startTime + TRB.Data.snapshot.kidneyShot.duration) then
			TRB.Data.snapshot.kidneyShot.startTime = nil
			TRB.Data.snapshot.kidneyShot.duration = 0
		end
		
---@diagnostic disable-next-line: cast-local-type
		TRB.Data.snapshot.shiv.charges, TRB.Data.snapshot.shiv.maxCharges, TRB.Data.snapshot.shiv.startTime, TRB.Data.snapshot.shiv.duration, _ = GetSpellCharges(TRB.Data.spells.shiv.id)
		if TRB.Data.snapshot.shiv.charges == TRB.Data.snapshot.shiv.maxCharges then
			TRB.Data.snapshot.shiv.startTime = nil
			TRB.Data.snapshot.shiv.duration = 0
		end

		if TRB.Data.snapshot.targetData.currentTargetGuid ~= nil and TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid] then
			if TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].atrophicPoison then
				local expiration = select(6, TRB.Functions.Aura:FindDebuffById(TRB.Data.spells.atrophicPoison.id, "target", "player"))

				if expiration ~= nil then
					TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].atrophicPoisonRemaining = expiration - currentTime
				end
			end

			if TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].cripplingPoison then
				local expiration = select(6, TRB.Functions.Aura:FindDebuffById(TRB.Data.spells.cripplingPoison.id, "target", "player"))

				if expiration ~= nil then
					TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].cripplingPoisonRemaining = expiration - currentTime
				end
			end
			
			if TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].numbingPoison then
				local expiration = select(6, TRB.Functions.Aura:FindDebuffById(TRB.Data.spells.numbingPoison.id, "target", "player"))

				if expiration ~= nil then
					TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].numbingPoisonRemaining = expiration - currentTime
				end
			end
			
			if TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].woundPoison then
				local expiration = select(6, TRB.Functions.Aura:FindDebuffById(TRB.Data.spells.woundPoison.id, "target", "player"))

				if expiration ~= nil then
					TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].woundPoisonRemaining = expiration - currentTime
				end
			end
		end

		if TRB.Data.snapshot.echoingReprimand.startTime ~= nil and currentTime > (TRB.Data.snapshot.echoingReprimand.startTime + TRB.Data.snapshot.echoingReprimand.duration) then
			TRB.Data.snapshot.echoingReprimand.startTime = nil
			TRB.Data.snapshot.echoingReprimand.duration = 0
		end
	
		if TRB.Data.snapshot.deathFromAbove.startTime ~= nil and currentTime > (TRB.Data.snapshot.deathFromAbove.startTime + TRB.Data.snapshot.deathFromAbove.duration) then
			TRB.Data.snapshot.deathFromAbove.startTime = nil
			TRB.Data.snapshot.deathFromAbove.duration = 0
		end

		if TRB.Data.snapshot.dismantle.startTime ~= nil and currentTime > (TRB.Data.snapshot.dismantle.startTime + TRB.Data.snapshot.dismantle.duration) then
			TRB.Data.snapshot.dismantle.startTime = nil
			TRB.Data.snapshot.dismantle.duration = 0
		end

		if TRB.Data.snapshot.crimsonVial.startTime ~= nil and currentTime > (TRB.Data.snapshot.crimsonVial.startTime + TRB.Data.snapshot.crimsonVial.duration) then
			TRB.Data.snapshot.crimsonVial.startTime = nil
			TRB.Data.snapshot.crimsonVial.duration = 0
		end
	end

	local function UpdateSnapshot_Assassination()
		UpdateSnapshot()
		local currentTime = GetTime()
		local _

		if TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.improvedGarrote) then
			_, _, _, _, _, TRB.Data.snapshot.improvedGarrote.endTime, _, _, _, TRB.Data.snapshot.improvedGarrote.spellId = TRB.Functions.Aura:FindBuffById(TRB.Data.spells.improvedGarrote.buffId)
		end

		if TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.serratedBoneSpike) then
---@diagnostic disable-next-line: redundant-parameter, cast-local-type
			TRB.Data.snapshot.serratedBoneSpike.charges, TRB.Data.snapshot.serratedBoneSpike.maxCharges, TRB.Data.snapshot.serratedBoneSpike.startTime, TRB.Data.snapshot.serratedBoneSpike.duration, _ = GetSpellCharges(TRB.Data.spells.serratedBoneSpike.id)
		else
			TRB.Data.snapshot.serratedBoneSpike.charges = 0
			TRB.Data.snapshot.serratedBoneSpike.startTime = nil
			TRB.Data.snapshot.serratedBoneSpike.duration = 0
		end

		if TRB.Data.snapshot.exsanguinate.startTime ~= nil and currentTime > (TRB.Data.snapshot.exsanguinate.startTime + TRB.Data.snapshot.exsanguinate.duration) then
			TRB.Data.snapshot.exsanguinate.startTime = nil
			TRB.Data.snapshot.exsanguinate.duration = 0
		end

		if TRB.Data.snapshot.garrote.startTime ~= nil and currentTime > (TRB.Data.snapshot.garrote.startTime + TRB.Data.snapshot.garrote.duration) then
			TRB.Data.snapshot.garrote.startTime = nil
			TRB.Data.snapshot.garrote.duration = 0
		end

		if TRB.Data.snapshot.kingsbane.startTime ~= nil and currentTime > (TRB.Data.snapshot.kingsbane.startTime + TRB.Data.snapshot.kingsbane.duration) then
			TRB.Data.snapshot.kingsbane.startTime = nil
			TRB.Data.snapshot.kingsbane.duration = 0
		end

		if TRB.Data.snapshot.targetData.currentTargetGuid ~= nil and TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid] then
			if TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].amplifyingPoison then
				local expiration = select(6, TRB.Functions.Aura:FindDebuffById(TRB.Data.spells.amplifyingPoison.id, "target", "player"))

				if expiration ~= nil then
					TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].amplifyingPoisonRemaining = expiration - currentTime
				end
			end

			if TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].deadlyPoison then
				local expiration = select(6, TRB.Functions.Aura:FindDebuffById(TRB.Data.spells.deadlyPoison.id, "target", "player"))

				if expiration ~= nil then
					TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].deadlyPoisonRemaining = expiration - currentTime
				end
			end

			if TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].crimsonTempest then
				local expiration = select(6, TRB.Functions.Aura:FindDebuffById(TRB.Data.spells.crimsonTempest.id, "target", "player"))

				if expiration ~= nil then
					TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].crimsonTempestRemaining = expiration - currentTime
				end
			end
			
			if TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].garrote then
				local expiration = select(6, TRB.Functions.Aura:FindDebuffById(TRB.Data.spells.garrote.id, "target", "player"))

				if expiration ~= nil then
					TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].garroteRemaining = expiration - currentTime
				end
			end
			
			if TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].internalBleeding then
				local expiration = select(6, TRB.Functions.Aura:FindDebuffById(TRB.Data.spells.internalBleeding.id, "target", "player"))

				if expiration ~= nil then
					TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].internalBleedingRemaining = expiration - currentTime
				end
			end
			
			if TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].rupture then
				local expiration = select(6, TRB.Functions.Aura:FindDebuffById(TRB.Data.spells.rupture.id, "target", "player"))

				if expiration ~= nil then
					TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].ruptureRemaining = expiration - currentTime
				end
			end
		end
	end

	local function UpdateSnapshot_Outlaw()
		UpdateSnapshot()
		local currentTime = GetTime()
		local _
		
		if TRB.Data.snapshot.bladeRush.startTime ~= nil then
			---@diagnostic disable-next-line: redundant-parameter
			TRB.Data.snapshot.bladeRush.startTime, TRB.Data.snapshot.bladeRush.duration, _, _ = GetSpellCooldown(TRB.Data.spells.bladeRush.id)
			if TRB.Data.snapshot.bladeRush.startTime ~= nil and currentTime > (TRB.Data.snapshot.bladeRush.startTime + TRB.Data.snapshot.bladeRush.duration) then
				TRB.Data.snapshot.bladeRush.startTime = nil
				TRB.Data.snapshot.bladeRush.duration = 0
			end
		end

		if TRB.Data.snapshot.bladeFlurry.startTime ~= nil then
			---@diagnostic disable-next-line: redundant-parameter
			TRB.Data.snapshot.bladeFlurry.startTime, TRB.Data.snapshot.bladeFlurry.duration, _, _ = GetSpellCooldown(TRB.Data.spells.bladeFlurry.id)
			if TRB.Data.snapshot.bladeFlurry.startTime ~= nil and currentTime > (TRB.Data.snapshot.bladeFlurry.startTime + TRB.Data.snapshot.bladeFlurry.duration) then
				TRB.Data.snapshot.bladeFlurry.startTime = nil
				TRB.Data.snapshot.bladeFlurry.duration = 0
			end
		end

		if TRB.Data.snapshot.betweenTheEyes.startTime ~= nil then
			---@diagnostic disable-next-line: redundant-parameter
			TRB.Data.snapshot.betweenTheEyes.startTime, TRB.Data.snapshot.betweenTheEyes.duration, _, _ = GetSpellCooldown(TRB.Data.spells.betweenTheEyes.id)
			if TRB.Data.snapshot.betweenTheEyes.startTime ~= nil and currentTime > (TRB.Data.snapshot.betweenTheEyes.startTime + TRB.Data.snapshot.betweenTheEyes.duration) then
				TRB.Data.snapshot.betweenTheEyes.startTime = nil
				TRB.Data.snapshot.betweenTheEyes.duration = 0
			end
		end

		if TRB.Data.snapshot.dreadblades.startTime ~= nil then
			---@diagnostic disable-next-line: redundant-parameter
			TRB.Data.snapshot.dreadblades.startTime, TRB.Data.snapshot.dreadblades.duration, _, _ = GetSpellCooldown(TRB.Data.spells.dreadblades.id)
			if TRB.Data.snapshot.dreadblades.startTime ~= nil and currentTime > (TRB.Data.snapshot.dreadblades.startTime + TRB.Data.snapshot.dreadblades.duration) then
				TRB.Data.snapshot.dreadblades.startTime = nil
				TRB.Data.snapshot.dreadblades.duration = 0
			end
		end

		if TRB.Data.snapshot.ghostlyStrike.startTime ~= nil then
			---@diagnostic disable-next-line: redundant-parameter
			TRB.Data.snapshot.ghostlyStrike.startTime, TRB.Data.snapshot.ghostlyStrike.duration, _, _ = GetSpellCooldown(TRB.Data.spells.ghostlyStrike.id)
			if TRB.Data.snapshot.ghostlyStrike.startTime ~= nil and currentTime > (TRB.Data.snapshot.ghostlyStrike.startTime + TRB.Data.snapshot.ghostlyStrike.duration) then
				TRB.Data.snapshot.ghostlyStrike.startTime = nil
				TRB.Data.snapshot.ghostlyStrike.duration = 0
			end
		end

		if TRB.Data.snapshot.gouge.startTime ~= nil and currentTime > (TRB.Data.snapshot.gouge.startTime + TRB.Data.snapshot.gouge.duration) then
			TRB.Data.snapshot.gouge.startTime = nil
			TRB.Data.snapshot.gouge.duration = 0
		end

		if TRB.Data.snapshot.rollTheBones.startTime ~= nil then	
			---@diagnostic disable-next-line: redundant-parameter
			TRB.Data.snapshot.rollTheBones.startTime, TRB.Data.snapshot.rollTheBones.duration, _, _ = GetSpellCooldown(TRB.Data.spells.rollTheBones.id)

			if TRB.Data.snapshot.rollTheBones.startTime ~= nil and currentTime > (TRB.Data.snapshot.rollTheBones.startTime + TRB.Data.snapshot.rollTheBones.duration) then
				TRB.Data.snapshot.rollTheBones.startTime = nil
				TRB.Data.snapshot.rollTheBones.duration = 0
			end
		end
		
		local rollTheBonesCount = 0
		local rollTheBonesTemporaryCount = 0
		local highestRemaining = 0
		for _, v in pairs(TRB.Data.snapshot.rollTheBones.buffs) do
			local remaining = TRB.Functions.Spell:GetRemainingTime(v)
			if remaining > 0 then
				if v.fromCountTheOdds then
					rollTheBonesTemporaryCount = rollTheBonesTemporaryCount + 1
				else
					rollTheBonesCount = rollTheBonesCount + 1
					if remaining > highestRemaining then
						highestRemaining = remaining
					end
				end
			end
		end
		TRB.Data.snapshot.rollTheBones.count = rollTheBonesCount
		TRB.Data.snapshot.rollTheBones.temporaryCount = rollTheBonesTemporaryCount
		TRB.Data.snapshot.rollTheBones.remaining = highestRemaining

		if TRB.Data.snapshot.rollTheBones.count >= 2 or TRB.Data.snapshot.rollTheBones.buffs.broadside.duration > 0 or TRB.Data.snapshot.rollTheBones.buffs.trueBearing.duration > 0 then
			TRB.Data.snapshot.rollTheBones.goodBuffs = true
		else
			TRB.Data.snapshot.rollTheBones.goodBuffs = false
		end
	end

	local function UpdateSnapshot_Subtlety()
		UpdateSnapshot()
		local currentTime = GetTime()
	end

	local function UpdateResourceBar()
		local currentTime = GetTime()
		local refreshText = false
		local specId = GetSpecialization()
		local coreSettings = TRB.Data.settings.core
		local classSettings = TRB.Data.settings.rogue

		if specId == 1 then
			local specSettings = classSettings.assassination
			UpdateSnapshot_Assassination()
			TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specSettings, TRB.Frames.barContainerFrame)

			if TRB.Data.snapshot.isTracking then
				TRB.Functions.Bar:HideResourceBar()

				if specSettings.displayBar.neverShow == false then
					refreshText = true
					local passiveBarValue = 0
					local castingBarValue = 0
					local gcd = TRB.Functions.Character:GetCurrentGCDTime(true)

					local passiveValue = 0
					if specSettings.bar.showPassive then
						if specSettings.generation.enabled then
							if specSettings.generation.mode == "time" then
								passiveValue = (TRB.Data.snapshot.energyRegen * (specSettings.generation.time or 3.0))
							else
								passiveValue = (TRB.Data.snapshot.energyRegen * ((specSettings.generation.gcds or 2) * gcd))
							end
						end
					end

					if CastingSpell() and specSettings.bar.showCasting then
						castingBarValue = TRB.Data.snapshot.resource + TRB.Data.snapshot.casting.resourceFinal
					else
						castingBarValue = TRB.Data.snapshot.resource
					end

					if castingBarValue < TRB.Data.snapshot.resource then --Using a spender
						if -TRB.Data.snapshot.casting.resourceFinal > passiveValue then
							passiveBarValue = castingBarValue + passiveValue
							TRB.Functions.Bar:SetValue(specSettings, resourceFrame, castingBarValue)
							TRB.Functions.Bar:SetValue(specSettings, castingFrame, passiveBarValue)
							TRB.Functions.Bar:SetValue(specSettings, passiveFrame, TRB.Data.snapshot.resource)
							castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.passive, true))
							passiveFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.spending, true))
						else
							passiveBarValue = castingBarValue + passiveValue
							TRB.Functions.Bar:SetValue(specSettings, resourceFrame, castingBarValue)
							TRB.Functions.Bar:SetValue(specSettings, passiveFrame, passiveBarValue)
							TRB.Functions.Bar:SetValue(specSettings, castingFrame, TRB.Data.snapshot.resource)
							castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.spending, true))
							passiveFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.passive, true))
						end
					else
						passiveBarValue = castingBarValue + passiveValue
						TRB.Functions.Bar:SetValue(specSettings, resourceFrame, TRB.Data.snapshot.resource)
						TRB.Functions.Bar:SetValue(specSettings, passiveFrame, passiveBarValue)
						TRB.Functions.Bar:SetValue(specSettings, castingFrame, castingBarValue)
						castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.casting, true))
						passiveFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.passive, true))
					end

					local pairOffset = 0
					for k, v in pairs(TRB.Data.spells) do
						local spell = TRB.Data.spells[k]
						if spell ~= nil and spell.id ~= nil and spell.energy ~= nil and spell.energy < 0 and spell.thresholdId ~= nil and spell.settingKey ~= nil then
							local energyAmount = CalculateAbilityResourceValue(spell.energy, spell.nimbleFingers, spell.rushedSetup, spell.comboPoints)
							TRB.Functions.Threshold:RepositionThreshold(specSettings, resourceFrame.thresholds[spell.thresholdId], resourceFrame, specSettings.thresholds.width, -energyAmount, TRB.Data.character.maxResource)

							local showThreshold = true
							local thresholdColor = specSettings.colors.threshold.over
							local frameLevel = TRB.Data.constants.frameLevels.thresholdOver

							if spell.stealth and not IsStealthed() then -- Don't show stealthed lines when unstealthed.
								if spell.id == TRB.Data.spells.ambush.id then		
									if TRB.Data.snapshot.subterfuge.isActive or TRB.Data.spells.sepsis.isActive then
										if TRB.Data.snapshot.resource >= -energyAmount then
											thresholdColor = specSettings.colors.threshold.over
										else
											thresholdColor = specSettings.colors.threshold.under
											frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
										end
									elseif TRB.Data.snapshot.blindside.isActive then
										thresholdColor = specSettings.colors.threshold.over
									else
										showThreshold = false
									end
								elseif TRB.Data.snapshot.subterfuge.isActive or TRB.Data.spells.sepsis.isActive then
									if TRB.Data.snapshot.resource >= -energyAmount then
										thresholdColor = specSettings.colors.threshold.over
									else
										thresholdColor = specSettings.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								else
									showThreshold = false
								end
							else
								if spell.isSnowflake then -- These are special snowflakes that we need to handle manually
									if spell.id == TRB.Data.spells.exsanguinate.id then
										if not TRB.Functions.Talent:IsTalentActive(spell) then -- Talent not selected
											showThreshold = false
										elseif not IsTargetBleeding(TRB.Data.snapshot.targetData.currentTargetGuid) or (TRB.Data.snapshot[spell.settingKey].startTime ~= nil and currentTime < (TRB.Data.snapshot[spell.settingKey].startTime + TRB.Data.snapshot[spell.settingKey].duration)) then
											thresholdColor = specSettings.colors.threshold.unusable
											frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
										elseif TRB.Data.snapshot.resource >= -energyAmount then
											thresholdColor = specSettings.colors.threshold.over
										else
											thresholdColor = specSettings.colors.threshold.under
											frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
										end
									elseif spell.id == TRB.Data.spells.shiv.id then
										if not TRB.Functions.Talent:IsTalentActive(spell) then -- Talent not selected
											showThreshold = false
										elseif TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.tinyToxicBlade) then -- Don't show this threshold
											showThreshold = false
										elseif TRB.Data.snapshot[spell.settingKey].charges == 0 then
											thresholdColor = specSettings.colors.threshold.unusable
											frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
										elseif TRB.Data.snapshot.resource >= -energyAmount then
											thresholdColor = specSettings.colors.threshold.over
										else
											thresholdColor = specSettings.colors.threshold.under
											frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
										end
									elseif spell.id == TRB.Data.spells.echoingReprimand.id then
										if not TRB.Functions.Talent:IsTalentActive(spell) then -- Talent not selected
											showThreshold = false
										elseif TRB.Data.snapshot[spell.settingKey].startTime ~= nil and currentTime < (TRB.Data.snapshot[spell.settingKey].startTime + TRB.Data.snapshot[spell.settingKey].duration) then
											thresholdColor = specSettings.colors.threshold.unusable
											frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
										elseif TRB.Data.snapshot.resource >= -energyAmount then
											thresholdColor = specSettings.colors.threshold.over
										else
											thresholdColor = specSettings.colors.threshold.under
											frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
										end
									elseif spell.id == TRB.Data.spells.sepsis.id then
										if not TRB.Functions.Talent:IsTalentActive(spell) then -- Talent not selected
											showThreshold = false
										elseif TRB.Data.snapshot[spell.settingKey].startTime ~= nil and currentTime < (TRB.Data.snapshot[spell.settingKey].startTime + TRB.Data.snapshot[spell.settingKey].duration) then
											thresholdColor = specSettings.colors.threshold.unusable
											frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
										elseif TRB.Data.snapshot.resource >= -energyAmount then
											thresholdColor = specSettings.colors.threshold.over
										else
											thresholdColor = specSettings.colors.threshold.under
											frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
										end
									elseif spell.id == TRB.Data.spells.serratedBoneSpike.id then
										if not TRB.Functions.Talent:IsTalentActive(spell) then -- Talent not selected
											showThreshold = false
										elseif TRB.Data.snapshot[spell.settingKey].charges == 0 then
											thresholdColor = specSettings.colors.threshold.unusable
											frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
										elseif TRB.Data.snapshot.resource >= -energyAmount then
											thresholdColor = specSettings.colors.threshold.over
										else
											thresholdColor = specSettings.colors.threshold.under
											frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
										end
									elseif spell.id == TRB.Data.spells.sliceAndDice.id then
										if TRB.Data.snapshot.resource >= -energyAmount then
											thresholdColor = specSettings.colors.threshold.over
										else
											thresholdColor = specSettings.colors.threshold.under
											frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
										end

										if GetSliceAndDiceRemainingTime() > TRB.Data.spells.sliceAndDice.pandemicTimes[TRB.Data.snapshot.resource2 + 1] then
											frameLevel = TRB.Data.constants.frameLevels.thresholdBase
										else
											frameLevel = TRB.Data.constants.frameLevels.thresholdHighPriority
										end
									elseif spell.id == TRB.Data.spells.garrote.id then
										if not TRB.Functions.Talent:IsTalentActive(spell) then -- Talent not selected
											showThreshold = false
										else
											if TRB.Data.snapshot.improvedGarrote.isActiveStealth or TRB.Data.snapshot.improvedGarrote.isActive then
												thresholdColor = specSettings.colors.threshold.special
												frameLevel = TRB.Data.constants.frameLevels.thresholdHighPriority
											elseif TRB.Data.snapshot[spell.settingKey].startTime ~= nil and currentTime < (TRB.Data.snapshot[spell.settingKey].startTime + TRB.Data.snapshot[spell.settingKey].duration) then
												thresholdColor = specSettings.colors.threshold.unusable
												frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
											elseif TRB.Data.snapshot.resource >= -energyAmount then
												thresholdColor = specSettings.colors.threshold.over
											else
												thresholdColor = specSettings.colors.threshold.under
												frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
											end
										end
									end
								elseif spell.isPvp and (not TRB.Data.character.isPvp or not TRB.Functions.Talent:IsTalentActive(spell)) then
									showThreshold = false
								elseif spell.isTalent and not TRB.Functions.Talent:IsTalentActive(spell) then -- Talent not selected
									showThreshold = false
								elseif spell.hasCooldown then
									if (TRB.Data.snapshot[spell.settingKey].charges == nil or TRB.Data.snapshot[spell.settingKey].charges == 0) and
										(TRB.Data.snapshot[spell.settingKey].startTime ~= nil and currentTime < (TRB.Data.snapshot[spell.settingKey].startTime + TRB.Data.snapshot[spell.settingKey].duration)) then
										thresholdColor = specSettings.colors.threshold.unusable
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
									elseif TRB.Data.snapshot.resource >= -energyAmount then
										thresholdColor = specSettings.colors.threshold.over
									else
										thresholdColor = specSettings.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								else -- This is an active/available/normal spell threshold
									if TRB.Data.snapshot.resource >= -energyAmount then
										thresholdColor = specSettings.colors.threshold.over
									else
										thresholdColor = specSettings.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								end
							end

							if spell.comboPoints == true and TRB.Data.snapshot.resource2 == 0 then
								thresholdColor = specSettings.colors.threshold.unusable
								frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
							end

							TRB.Functions.Threshold:AdjustThresholdDisplay(spell, resourceFrame.thresholds[spell.thresholdId], showThreshold, frameLevel, pairOffset, thresholdColor, TRB.Data.snapshot[spell.settingKey], specSettings)
						end
						pairOffset = pairOffset + 3
					end

					local barColor = specSettings.colors.bar.base

					local affectingCombat = UnitAffectingCombat("player")

					if affectingCombat then
						local sadTime = GetSliceAndDiceRemainingTime()
						if sadTime == 0 then
							barColor = specSettings.colors.bar.noSliceAndDice
						elseif sadTime < TRB.Data.spells.sliceAndDice.pandemicTimes[TRB.Data.snapshot.resource2 + 1] then
							barColor = specSettings.colors.bar.sliceAndDicePandemic
						end
					end

					local barBorderColor = specSettings.colors.bar.border
					if IsStealthed() or TRB.Data.snapshot.subterfuge.isActive or TRB.Data.spells.sepsis.isActive then
						barBorderColor = specSettings.colors.bar.borderStealth
					elseif specSettings.colors.bar.overcapEnabled and TRB.Functions.Class:IsValidVariableForSpec("$overcap") and TRB.Functions.Class:IsValidVariableForSpec("$inCombat") then
						barBorderColor = specSettings.colors.bar.borderOvercap

						if specSettings.audio.overcap.enabled and TRB.Data.snapshot.audio.overcapCue == false then
							TRB.Data.snapshot.audio.overcapCue = true
							---@diagnostic disable-next-line: redundant-parameter
							PlaySoundFile(specSettings.audio.overcap.sound, coreSettings.audio.channel.channel)
						end
					else
						TRB.Data.snapshot.audio.overcapCue = false
					end

					barContainerFrame:SetAlpha(1.0)

					barBorderFrame:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(barBorderColor, true))

					resourceFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(barColor, true))
					
					local sbsCp = 0
					
					if specSettings.comboPoints.spec.serratedBoneSpikeColor and TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.serratedBoneSpike) and TRB.Data.snapshot.targetData.currentTargetGuid ~= nil and TRB.Data.snapshot.serratedBoneSpike.charges > 0 then
						sbsCp = 1 + TRB.Data.snapshot.targetData.serratedBoneSpike

						if TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid] == nil or
							TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].serratedBoneSpike == false then
							sbsCp = sbsCp + 1
						end
					end

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
						else
							TRB.Functions.Bar:SetValue(specSettings, TRB.Frames.resource2Frames[x].resourceFrame, 0, 1)
						end

						if TRB.Data.snapshot.echoingReprimand[x].enabled then
							cpColor = specSettings.colors.comboPoints.echoingReprimand
							
							if sbsCp > 0 and x > TRB.Data.snapshot.resource2 and x <= (TRB.Data.snapshot.resource2 + sbsCp) and not specSettings.comboPoints.consistentUnfilledColor then
								cpBorderColor = specSettings.colors.comboPoints.serratedBoneSpike
							else
								cpBorderColor = specSettings.colors.comboPoints.echoingReprimand
							end

							if not specSettings.comboPoints.consistentUnfilledColor then
								cpBR, cpBG, cpBB, _ = TRB.Functions.Color:GetRGBAFromString(specSettings.colors.comboPoints.echoingReprimand, true)
							end
						elseif sbsCp > 0 and x > TRB.Data.snapshot.resource2 and x <= (TRB.Data.snapshot.resource2 + sbsCp) then
							cpBorderColor = specSettings.colors.comboPoints.serratedBoneSpike
							
							if not specSettings.comboPoints.consistentUnfilledColor then
								cpBR, cpBG, cpBB, _ = TRB.Functions.Color:GetRGBAFromString(specSettings.colors.comboPoints.serratedBoneSpike, true)
							end
						end
						TRB.Frames.resource2Frames[x].resourceFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(cpColor, true))
						TRB.Frames.resource2Frames[x].borderFrame:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(cpBorderColor, true))
						TRB.Frames.resource2Frames[x].containerFrame:SetBackdropColor(cpBR, cpBG, cpBB, cpBackgroundAlpha)
					end
				end
			end
			TRB.Functions.BarText:UpdateResourceBarText(specSettings, refreshText)
		elseif specId == 2 then
			local specSettings = classSettings.outlaw
			UpdateSnapshot_Outlaw()
			TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specSettings, TRB.Frames.barContainerFrame)

			if TRB.Data.snapshot.isTracking then
				TRB.Functions.Bar:HideResourceBar()

				if specSettings.displayBar.neverShow == false then
					refreshText = true
					local passiveBarValue = 0
					local castingBarValue = 0
					local gcd = TRB.Functions.Character:GetCurrentGCDTime(true)

					local passiveValue = 0
					if specSettings.bar.showPassive then
						if specSettings.generation.enabled then
							if specSettings.generation.mode == "time" then
								passiveValue = (TRB.Data.snapshot.energyRegen * (specSettings.generation.time or 3.0))
							else
								passiveValue = (TRB.Data.snapshot.energyRegen * ((specSettings.generation.gcds or 2) * gcd))
							end
						end
					end

					if CastingSpell() and specSettings.bar.showCasting then
						castingBarValue = TRB.Data.snapshot.resource + TRB.Data.snapshot.casting.resourceFinal
					else
						castingBarValue = TRB.Data.snapshot.resource
					end

					if castingBarValue < TRB.Data.snapshot.resource then --Using a spender
						if -TRB.Data.snapshot.casting.resourceFinal > passiveValue then
							passiveBarValue = castingBarValue + passiveValue
							TRB.Functions.Bar:SetValue(specSettings, resourceFrame, castingBarValue)
							TRB.Functions.Bar:SetValue(specSettings, castingFrame, passiveBarValue)
							TRB.Functions.Bar:SetValue(specSettings, passiveFrame, TRB.Data.snapshot.resource)
							castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.passive, true))
							passiveFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.spending, true))
						else
							passiveBarValue = castingBarValue + passiveValue
							TRB.Functions.Bar:SetValue(specSettings, resourceFrame, castingBarValue)
							TRB.Functions.Bar:SetValue(specSettings, passiveFrame, passiveBarValue)
							TRB.Functions.Bar:SetValue(specSettings, castingFrame, TRB.Data.snapshot.resource)
							castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.spending, true))
							passiveFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.passive, true))
						end
					else
						passiveBarValue = castingBarValue + passiveValue
						TRB.Functions.Bar:SetValue(specSettings, resourceFrame, TRB.Data.snapshot.resource)
						TRB.Functions.Bar:SetValue(specSettings, passiveFrame, passiveBarValue)
						TRB.Functions.Bar:SetValue(specSettings, castingFrame, castingBarValue)
						castingFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.casting, true))
						passiveFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.passive, true))
					end

					local pairOffset = 0
					for k, v in pairs(TRB.Data.spells) do
						local spell = TRB.Data.spells[k]
						if spell ~= nil and spell.id ~= nil and spell.energy ~= nil and spell.energy < 0 and spell.thresholdId ~= nil and spell.settingKey ~= nil then	
							local energyAmount = CalculateAbilityResourceValue(spell.energy, spell.nimbleFingers, spell.rushedSetup, spell.comboPoints)
							TRB.Functions.Threshold:RepositionThreshold(specSettings, resourceFrame.thresholds[spell.thresholdId], resourceFrame, specSettings.thresholds.width, -energyAmount, TRB.Data.character.maxResource)

							local showThreshold = true
							local thresholdColor = specSettings.colors.threshold.over
							local frameLevel = TRB.Data.constants.frameLevels.thresholdOver

							if spell.stealth and not IsStealthed() then -- Don't show stealthed lines when unstealthed.
								if spell.id == TRB.Data.spells.ambush.id then
									if TRB.Data.snapshot.sepsis.isActive then
										if TRB.Data.snapshot.resource >= -energyAmount then
											thresholdColor = TRB.Data.settings.rogue.outlaw.colors.threshold.over
										else
											thresholdColor = TRB.Data.settings.rogue.outlaw.colors.threshold.under
											frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
										end
									else
										showThreshold = false
									end
								elseif TRB.Data.snapshot.sepsis.isActive then
									if TRB.Data.snapshot.resource >= -energyAmount then
										thresholdColor = TRB.Data.settings.rogue.outlaw.colors.threshold.over
									else
										thresholdColor = TRB.Data.settings.rogue.outlaw.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								else
									showThreshold = false
								end
							else
								if spell.isSnowflake then -- These are special snowflakes that we need to handle manually
									if spell.id == TRB.Data.spells.shiv.id then
										if TRB.Data.snapshot[spell.settingKey].startTime ~= nil and currentTime < (TRB.Data.snapshot[spell.settingKey].startTime + TRB.Data.snapshot[spell.settingKey].duration) then
											thresholdColor = specSettings.colors.threshold.unusable
											frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
										elseif TRB.Data.snapshot.resource >= -energyAmount then
											thresholdColor = specSettings.colors.threshold.over
										else
											thresholdColor = specSettings.colors.threshold.under
											frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
										end
									elseif spell.id == TRB.Data.spells.echoingReprimand.id then
										if not TRB.Functions.Talent:IsTalentActive(spell) then -- Talent not selected
											showThreshold = false
										elseif TRB.Data.snapshot[spell.settingKey].startTime ~= nil and currentTime < (TRB.Data.snapshot[spell.settingKey].startTime + TRB.Data.snapshot[spell.settingKey].duration) then
											thresholdColor = specSettings.colors.threshold.unusable
											frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
										elseif TRB.Data.snapshot.resource >= -energyAmount then
											thresholdColor = specSettings.colors.threshold.over
										else
											thresholdColor = specSettings.colors.threshold.under
											frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
										end
									elseif spell.id == TRB.Data.spells.sepsis.id then
										if not TRB.Functions.Talent:IsTalentActive(spell) then -- Talent not selected
											showThreshold = false
										elseif TRB.Data.snapshot[spell.settingKey].startTime ~= nil and currentTime < (TRB.Data.snapshot[spell.settingKey].startTime + TRB.Data.snapshot[spell.settingKey].duration) then
											thresholdColor = specSettings.colors.threshold.unusable
											frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
										elseif TRB.Data.snapshot.resource >= -energyAmount then
											thresholdColor = specSettings.colors.threshold.over
										else
											thresholdColor = specSettings.colors.threshold.under
											frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
										end
									elseif spell.id == TRB.Data.spells.sinisterStrike.id then
										if TRB.Data.snapshot.resource >= -energyAmount then
											if TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshot.rollTheBones.buffs.skullAndCrossbones) > 0 then
												thresholdColor = specSettings.colors.threshold.special
												frameLevel = TRB.Data.constants.frameLevels.thresholdHighPriority
											else
												thresholdColor = specSettings.colors.threshold.over
											end
										else
											if TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshot.rollTheBones.buffs.skullAndCrossbones) > 0 then
												thresholdColor = specSettings.colors.threshold.special
												frameLevel = TRB.Data.constants.frameLevels.thresholdHighPriority
											else
												thresholdColor = specSettings.colors.threshold.under
												frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
											end
										end
									elseif spell.id == TRB.Data.spells.pistolShot.id then
										local opportunityTime = TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshot.opportunity)

										if opportunityTime > 0 then
											energyAmount = energyAmount * TRB.Data.spells.opportunity.energyModifier
											TRB.Functions.Threshold:RepositionThreshold(specSettings, resourceFrame.thresholds[spell.thresholdId], resourceFrame, specSettings.thresholds.width, -energyAmount, TRB.Data.character.maxResource)
										end

										if TRB.Data.snapshot.resource >= -energyAmount then
											if opportunityTime > 0 then
												thresholdColor = specSettings.colors.threshold.special
												frameLevel = TRB.Data.constants.frameLevels.thresholdHighPriority
											else
												thresholdColor = specSettings.colors.threshold.over
											end
										else
											if opportunityTime > 0 then
												thresholdColor = specSettings.colors.threshold.special
												frameLevel = TRB.Data.constants.frameLevels.thresholdHighPriority
											else
												thresholdColor = specSettings.colors.threshold.under
												frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
											end
										end
									elseif spell.id == TRB.Data.spells.betweenTheEyes.id then
										if TRB.Data.snapshot[spell.settingKey].startTime ~= nil and currentTime < (TRB.Data.snapshot[spell.settingKey].startTime + TRB.Data.snapshot[spell.settingKey].duration) then
											thresholdColor = specSettings.colors.threshold.unusable
											frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
										elseif TRB.Data.snapshot.resource >= -energyAmount then
											if TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshot.rollTheBones.buffs.ruthlessPrecision) > 0 then
												thresholdColor = specSettings.colors.threshold.special
												frameLevel = TRB.Data.constants.frameLevels.thresholdHighPriority
											else
												thresholdColor = specSettings.colors.threshold.over
											end
										else
											if TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshot.rollTheBones.buffs.ruthlessPrecision) > 0 then
												thresholdColor = specSettings.colors.threshold.special
												frameLevel = TRB.Data.constants.frameLevels.thresholdHighPriority
											else
												thresholdColor = specSettings.colors.threshold.under
												frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
											end
										end
									elseif spell.id == TRB.Data.spells.sliceAndDice.id then
										if TRB.Data.snapshot.resource >= -energyAmount then
											thresholdColor = specSettings.colors.threshold.over
										else
											thresholdColor = specSettings.colors.threshold.under
											frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
										end

										if GetSliceAndDiceRemainingTime() > TRB.Data.spells.sliceAndDice.pandemicTimes[TRB.Data.snapshot.resource2 + 1] then
											frameLevel = TRB.Data.constants.frameLevels.thresholdBase
										else
											frameLevel = TRB.Data.constants.frameLevels.thresholdHighPriority
										end
									end
								elseif spell.isPvp and (not TRB.Data.character.isPvp or not TRB.Functions.Talent:IsTalentActive(spell)) then
									showThreshold = false
								elseif spell.isTalent and not TRB.Functions.Talent:IsTalentActive(spell) then -- Talent not selected
									showThreshold = false
								elseif spell.hasCooldown then
									if (TRB.Data.snapshot[spell.settingKey].charges == nil or TRB.Data.snapshot[spell.settingKey].charges == 0) and
										(TRB.Data.snapshot[spell.settingKey].startTime ~= nil and currentTime < (TRB.Data.snapshot[spell.settingKey].startTime + TRB.Data.snapshot[spell.settingKey].duration)) then
										thresholdColor = specSettings.colors.threshold.unusable
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
									elseif TRB.Data.snapshot.resource >= -energyAmount then
										thresholdColor = specSettings.colors.threshold.over
									else
										thresholdColor = specSettings.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								else -- This is an active/available/normal spell threshold
									if TRB.Data.snapshot.resource >= -energyAmount then
										thresholdColor = specSettings.colors.threshold.over
									else
										thresholdColor = specSettings.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								end
							end

							if spell.comboPoints == true and TRB.Data.snapshot.resource2 == 0 then
								thresholdColor = specSettings.colors.threshold.unusable
								frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
							end

							TRB.Functions.Threshold:AdjustThresholdDisplay(spell, resourceFrame.thresholds[spell.thresholdId], showThreshold, frameLevel, pairOffset, thresholdColor, TRB.Data.snapshot[spell.settingKey], specSettings)
						end
						pairOffset = pairOffset + 3
					end

					local barColor = specSettings.colors.bar.base

					local affectingCombat = UnitAffectingCombat("player")

					if affectingCombat then
						local sadTime = GetSliceAndDiceRemainingTime()
						if sadTime == 0 then
							barColor = specSettings.colors.bar.noSliceAndDice
						elseif sadTime < TRB.Data.spells.sliceAndDice.pandemicTimes[TRB.Data.snapshot.resource2 + 1] then
							barColor = specSettings.colors.bar.sliceAndDicePandemic
						end
					end

					local barBorderColor = specSettings.colors.bar.border

					if IsStealthed() or TRB.Data.snapshot.sepsis.isActive then
						barBorderColor = specSettings.colors.bar.borderStealth
					elseif TRB.Data.snapshot.rollTheBones.goodBuffs == true and TRB.Data.snapshot.rollTheBones.startTime == nil then
						barBorderColor = specSettings.colors.bar.borderRtbGood
					elseif TRB.Data.snapshot.rollTheBones.goodBuffs == false and TRB.Data.snapshot.rollTheBones.startTime == nil then
						barBorderColor = specSettings.colors.bar.borderRtbBad
					elseif specSettings.colors.bar.overcapEnabled and TRB.Functions.Class:IsValidVariableForSpec("$overcap") and TRB.Functions.Class:IsValidVariableForSpec("$inCombat") then
						barBorderColor = specSettings.colors.bar.borderOvercap

						if specSettings.audio.overcap.enabled and TRB.Data.snapshot.audio.overcapCue == false then
							TRB.Data.snapshot.audio.overcapCue = true
							---@diagnostic disable-next-line: redundant-parameter
							PlaySoundFile(specSettings.audio.overcap.sound, coreSettings.audio.channel.channel)
						end
					else
						TRB.Data.snapshot.audio.overcapCue = false
					end

					barContainerFrame:SetAlpha(1.0)

					barBorderFrame:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(barBorderColor, true))

					resourceFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(barColor, true))
					
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
						else
							TRB.Functions.Bar:SetValue(specSettings, TRB.Frames.resource2Frames[x].resourceFrame, 0, 1)
						end

						if TRB.Data.snapshot.echoingReprimand[x].enabled then
							cpColor = specSettings.colors.comboPoints.echoingReprimand
							cpBorderColor = specSettings.colors.comboPoints.echoingReprimand

							if not specSettings.comboPoints.consistentUnfilledColor then
								cpBR, cpBG, cpBB, _ = TRB.Functions.Color:GetRGBAFromString(specSettings.colors.comboPoints.echoingReprimand, true)
							end
						end

						TRB.Frames.resource2Frames[x].resourceFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(cpColor, true))
						TRB.Frames.resource2Frames[x].borderFrame:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(cpBorderColor, true))
						TRB.Frames.resource2Frames[x].containerFrame:SetBackdropColor(cpBR, cpBG, cpBB, cpBackgroundAlpha)
					end
				end
			end
			TRB.Functions.BarText:UpdateResourceBarText(specSettings, refreshText)
		end
	end

	barContainerFrame:SetScript("OnEvent", function(self, event, ...)
		local currentTime = GetTime()
		local triggerUpdate = false
		local _
		local specId = GetSpecialization()

		if event == "COMBAT_LOG_EVENT_UNFILTERED" then
			local time, type, _, sourceGUID, sourceName, _, _, destGUID, destName, _, _, spellId, spellName = CombatLogGetCurrentEventInfo() --, _, _, _,_,_,_,_,spellcritical,_,_,_,_ = ...

			if sourceGUID == TRB.Data.character.guid then
				if specId == 1 and TRB.Data.barConstructedForSpec == "assassination" then --Assassination
					if spellId == TRB.Data.spells.exsanguinate.id then
						if type == "SPELL_CAST_SUCCESS" then
							TRB.Data.snapshot.exsanguinate.startTime = currentTime
							TRB.Data.snapshot.exsanguinate.duration = TRB.Data.spells.exsanguinate.cooldown
						end
					elseif spellId == TRB.Data.spells.blindside.id then
						TRB.Functions.Aura:SnapshotGenericAura(spellId, type, TRB.Data.snapshot.blindside)
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then
							if TRB.Data.settings.rogue.assassination.audio.blindside.enabled then
								---@diagnostic disable-next-line: redundant-parameter
								PlaySoundFile(TRB.Data.settings.rogue.assassination.audio.blindside.sound, TRB.Data.settings.core.audio.channel.channel)
							end
						end
					elseif spellId == TRB.Data.spells.subterfuge.id then
						TRB.Functions.Aura:SnapshotGenericAura(spellId, type, TRB.Data.snapshot.subterfuge, true)
					elseif spellId == TRB.Data.spells.garrote.id then
						if TRB.Functions.Class:InitializeTarget(destGUID) then
							if type == "SPELL_CAST_SUCCESS" then
								if not((TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.subterfuge) and IsStealthed()) or TRB.Data.spells.subterfuge.isActive) then
									TRB.Data.snapshot.garrote.startTime = currentTime
									TRB.Data.snapshot.garrote.duration = TRB.Data.spells.garrote.cooldown
								end

								if TRB.Data.snapshot.improvedGarrote.isActiveStealth or TRB.Data.snapshot.improvedGarrote.isActiveStealth then
									TRB.Data.snapshot.garrote.startTime = nil
									TRB.Data.snapshot.garrote.duration = 0
								end
							elseif type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Garrote Applied to Target
								TRB.Data.snapshot.targetData.targets[destGUID].garrote = true
								if type == "SPELL_AURA_APPLIED" then
									TRB.Data.snapshot.targetData.garrote = TRB.Data.snapshot.targetData.garrote + 1
								end
								triggerUpdate = true
							elseif type == "SPELL_AURA_REMOVED" then
								TRB.Data.snapshot.targetData.targets[destGUID].garrote = false
								TRB.Data.snapshot.targetData.targets[destGUID].garroteRemaining = 0
								TRB.Data.snapshot.targetData.garrote = TRB.Data.snapshot.targetData.garrote - 1
								triggerUpdate = true
							--elseif type == "SPELL_PERIODIC_DAMAGE" then
							end
						end
					elseif spellId == TRB.Data.spells.rupture.id then
						if TRB.Functions.Class:InitializeTarget(destGUID) then
							if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Rupture Applied to Target
								TRB.Data.snapshot.targetData.targets[destGUID].rupture = true
								if type == "SPELL_AURA_APPLIED" then
									TRB.Data.snapshot.targetData.rupture = TRB.Data.snapshot.targetData.rupture + 1
								end
								triggerUpdate = true
							elseif type == "SPELL_AURA_REMOVED" then
								TRB.Data.snapshot.targetData.targets[destGUID].rupture = false
								TRB.Data.snapshot.targetData.targets[destGUID].ruptureRemaining = 0
								TRB.Data.snapshot.targetData.rupture = TRB.Data.snapshot.targetData.rupture - 1
								triggerUpdate = true
							--elseif type == "SPELL_PERIODIC_DAMAGE" then
							end
						end
					elseif spellId == TRB.Data.spells.internalBleeding.id then
						if TRB.Functions.Class:InitializeTarget(destGUID) then
							if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- IB Applied to Target
								TRB.Data.snapshot.targetData.targets[destGUID].internalBleeding = true
								if type == "SPELL_AURA_APPLIED" then
									TRB.Data.snapshot.targetData.internalBleeding = TRB.Data.snapshot.targetData.internalBleeding + 1
								end
								triggerUpdate = true
							elseif type == "SPELL_AURA_REMOVED" then
								TRB.Data.snapshot.targetData.targets[destGUID].internalBleeding = false
								TRB.Data.snapshot.targetData.targets[destGUID].internalBleedingRemaining = 0
								TRB.Data.snapshot.targetData.internalBleeding = TRB.Data.snapshot.targetData.internalBleeding - 1
								triggerUpdate = true
							--elseif type == "SPELL_PERIODIC_DAMAGE" then
							end
						end
					elseif spellId == TRB.Data.spells.crimsonTempest.id then
						if TRB.Functions.Class:InitializeTarget(destGUID) then
							if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- CT Applied to Target
								TRB.Data.snapshot.targetData.targets[destGUID].crimsonTempest = true
								if type == "SPELL_AURA_APPLIED" then
									TRB.Data.snapshot.targetData.crimsonTempest = TRB.Data.snapshot.targetData.crimsonTempest + 1
								end
								triggerUpdate = true
							elseif type == "SPELL_AURA_REMOVED" then
								TRB.Data.snapshot.targetData.targets[destGUID].crimsonTempest = false
								TRB.Data.snapshot.targetData.targets[destGUID].crimsonTempestRemaining = 0
								TRB.Data.snapshot.targetData.crimsonTempest = TRB.Data.snapshot.targetData.crimsonTempest - 1
								triggerUpdate = true
							--elseif type == "SPELL_PERIODIC_DAMAGE" then
							end
						end
					elseif spellId == TRB.Data.spells.deadlyPoison.id then
						if TRB.Functions.Class:InitializeTarget(destGUID) then
							if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- DP Applied to Target
								TRB.Data.snapshot.targetData.targets[destGUID].deadlyPoison = true
								if type == "SPELL_AURA_APPLIED" then
									TRB.Data.snapshot.targetData.deadlyPoison = TRB.Data.snapshot.targetData.deadlyPoison + 1
								end
								triggerUpdate = true
							elseif type == "SPELL_AURA_REMOVED" then
								TRB.Data.snapshot.targetData.targets[destGUID].deadlyPoison = false
								TRB.Data.snapshot.targetData.targets[destGUID].deadlyPoisonRemaining = 0
								TRB.Data.snapshot.targetData.deadlyPoison = TRB.Data.snapshot.targetData.deadlyPoison - 1
								triggerUpdate = true
							--elseif type == "SPELL_PERIODIC_DAMAGE" then
							end
						end
					elseif spellId == TRB.Data.spells.amplifyingPoison.id then
						if TRB.Functions.Class:InitializeTarget(destGUID) then
							if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Amplifying Poison Applied to Target
								TRB.Data.snapshot.targetData.targets[destGUID].amplifyingPoison = true
								if type == "SPELL_AURA_APPLIED" then
									TRB.Data.snapshot.targetData.amplifyingPoison = TRB.Data.snapshot.targetData.amplifyingPoison + 1
								end
								triggerUpdate = true
							elseif type == "SPELL_AURA_REMOVED" then
								TRB.Data.snapshot.targetData.targets[destGUID].amplifyingPoison = false
								TRB.Data.snapshot.targetData.targets[destGUID].amplifyingPoisonRemaining = 0
								TRB.Data.snapshot.targetData.amplifyingPoison = TRB.Data.snapshot.targetData.amplifyingPoison - 1
								triggerUpdate = true
							--elseif type == "SPELL_PERIODIC_DAMAGE" then
							end
						end
					elseif spellId == TRB.Data.spells.kingsbane.id then
						if type == "SPELL_CAST_SUCCESS" then
							TRB.Data.snapshot.kingsbane.startTime = currentTime
							TRB.Data.snapshot.kingsbane.duration = TRB.Data.spells.kingsbane.cooldown
						end
					elseif spellId == TRB.Data.spells.serratedBoneSpike.id then
						if type == "SPELL_CAST_SUCCESS" then -- Serrated Bone Spike
							---@diagnostic disable-next-line: redundant-parameter, cast-local-type
							TRB.Data.snapshot.serratedBoneSpike.charges, TRB.Data.snapshot.serratedBoneSpike.maxCharges, TRB.Data.snapshot.serratedBoneSpike.startTime, TRB.Data.snapshot.serratedBoneSpike.duration, _ = GetSpellCharges(TRB.Data.spells.serratedBoneSpike.id)
						end
					elseif spellId == TRB.Data.spells.serratedBoneSpike.debuffId then
						if TRB.Functions.Class:InitializeTarget(destGUID) then
							if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Applied to Target
								TRB.Data.snapshot.targetData.targets[destGUID].serratedBoneSpike = true
								triggerUpdate = true
							elseif type == "SPELL_AURA_REMOVED" then
								TRB.Data.snapshot.targetData.targets[destGUID].serratedBoneSpike = false
								TRB.Data.snapshot.targetData.serratedBoneSpike = TRB.Data.snapshot.targetData.serratedBoneSpike - 1
								triggerUpdate = true
							--elseif type == "SPELL_PERIODIC_DAMAGE" then
							end
						end
					elseif spellId == TRB.Data.spells.crimsonVial.id then
						if type == "SPELL_CAST_SUCCESS" then
							TRB.Data.snapshot.crimsonVial.startTime = currentTime
							TRB.Data.snapshot.crimsonVial.duration = TRB.Data.spells.crimsonVial.cooldown
						end
					elseif spellId == TRB.Data.spells.improvedGarrote.stealthBuffId then
						TRB.Functions.Aura:SnapshotGenericAura(spellId, type, TRB.Data.snapshot.improvedGarrote, true)
					elseif spellId == TRB.Data.spells.improvedGarrote.buffId then
						TRB.Functions.Aura:SnapshotGenericAura(spellId, type, TRB.Data.snapshot.improvedGarrote)
					end
				elseif specId == 2 and TRB.Data.barConstructedForSpec == "outlaw" then
					if spellId == TRB.Data.spells.betweenTheEyes.id then
						if type == "SPELL_CAST_SUCCESS" then
							TRB.Data.snapshot.betweenTheEyes.startTime = currentTime
							TRB.Data.snapshot.betweenTheEyes.duration = TRB.Data.spells.betweenTheEyes.cooldown
						end
					elseif spellId == TRB.Data.spells.bladeFlurry.id then
						if type == "SPELL_CAST_SUCCESS" then
							TRB.Data.snapshot.bladeFlurry.startTime = currentTime
							TRB.Data.snapshot.bladeFlurry.duration = TRB.Data.spells.bladeFlurry.cooldown
						end
					elseif spellId == TRB.Data.spells.dreadblades.id then
						if type == "SPELL_CAST_SUCCESS" then
							TRB.Data.snapshot.dreadblades.startTime = currentTime
							TRB.Data.snapshot.dreadblades.duration = TRB.Data.spells.dreadblades.cooldown
						end
					elseif spellId == TRB.Data.spells.ghostlyStrike.id then
						if type == "SPELL_CAST_SUCCESS" then
							TRB.Data.snapshot.ghostlyStrike.startTime = currentTime
							TRB.Data.snapshot.ghostlyStrike.duration = TRB.Data.spells.ghostlyStrike.cooldown
						end
					elseif spellId == TRB.Data.spells.gouge.id then
						if type == "SPELL_CAST_SUCCESS" then
							TRB.Data.snapshot.gouge.startTime = currentTime
							TRB.Data.snapshot.gouge.duration = TRB.Data.spells.gouge.cooldown
						end
					elseif spellId == TRB.Data.spells.rollTheBones.id then
						if type == "SPELL_CAST_SUCCESS" then
							TRB.Data.snapshot.rollTheBones.startTime = currentTime
							TRB.Data.snapshot.rollTheBones.duration = TRB.Data.spells.rollTheBones.cooldown
						end
					elseif spellId == TRB.Data.spells.opportunity.id then
						TRB.Functions.Aura:SnapshotGenericAura(spellId, type, TRB.Data.snapshot.opportunity)
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then
							if TRB.Data.settings.rogue.outlaw.audio.opportunity.enabled then
								---@diagnostic disable-next-line: redundant-parameter
								PlaySoundFile(TRB.Data.settings.rogue.outlaw.audio.opportunity.sound, TRB.Data.settings.core.audio.channel.channel)
							end
						end
					elseif spellId == TRB.Data.spells.broadside.id then
						TRB.Functions.Aura:SnapshotGenericAura(spellId, type, TRB.Data.snapshot.rollTheBones.buffs.broadside)
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then
							if TRB.Data.snapshot.rollTheBones.buffs.broadside.duration > TRB.Data.spells.countTheOdds.duration then
								TRB.Data.snapshot.rollTheBones.buffs.broadside.fromCountTheOdds = false
							else
								TRB.Data.snapshot.rollTheBones.buffs.broadside.fromCountTheOdds = true
							end
						elseif type == "SPELL_AURA_REMOVED" then
							TRB.Data.snapshot.rollTheBones.buffs.broadside.fromCountTheOdds = false
						end
					elseif spellId == TRB.Data.spells.buriedTreasure.id then
						TRB.Functions.Aura:SnapshotGenericAura(spellId, type, TRB.Data.snapshot.rollTheBones.buffs.buriedTreasure)
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then
							if TRB.Data.snapshot.rollTheBones.buffs.buriedTreasure.duration > TRB.Data.spells.countTheOdds.duration then
								TRB.Data.snapshot.rollTheBones.buffs.buriedTreasure.fromCountTheOdds = false
							else
								TRB.Data.snapshot.rollTheBones.buffs.buriedTreasure.fromCountTheOdds = true
							end
						elseif type == "SPELL_AURA_REMOVED" then
							TRB.Data.snapshot.rollTheBones.buffs.buriedTreasure.fromCountTheOdds = false
						end
					elseif spellId == TRB.Data.spells.grandMelee.id then
						TRB.Functions.Aura:SnapshotGenericAura(spellId, type, TRB.Data.snapshot.rollTheBones.buffs.grandMelee)
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then
							if TRB.Data.snapshot.rollTheBones.buffs.grandMelee.duration > TRB.Data.spells.countTheOdds.duration then
								TRB.Data.snapshot.rollTheBones.buffs.grandMelee.fromCountTheOdds = false
							else
								TRB.Data.snapshot.rollTheBones.buffs.grandMelee.fromCountTheOdds = true
							end
						elseif type == "SPELL_AURA_REMOVED" then
							TRB.Data.snapshot.rollTheBones.buffs.grandMelee.fromCountTheOdds = false
						end
					elseif spellId == TRB.Data.spells.ruthlessPrecision.id then
						TRB.Functions.Aura:SnapshotGenericAura(spellId, type, TRB.Data.snapshot.rollTheBones.buffs.ruthlessPrecision)
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then
							if TRB.Data.snapshot.rollTheBones.buffs.ruthlessPrecision.duration > TRB.Data.spells.countTheOdds.duration then
								TRB.Data.snapshot.rollTheBones.buffs.ruthlessPrecision.fromCountTheOdds = false
							else
								TRB.Data.snapshot.rollTheBones.buffs.ruthlessPrecision.fromCountTheOdds = true
							end
						elseif type == "SPELL_AURA_REMOVED" then
							TRB.Data.snapshot.rollTheBones.buffs.ruthlessPrecision.fromCountTheOdds = false
						end
					elseif spellId == TRB.Data.spells.skullAndCrossbones.id then
						TRB.Functions.Aura:SnapshotGenericAura(spellId, type, TRB.Data.snapshot.rollTheBones.buffs.skullAndCrossbones)
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then
							if TRB.Data.snapshot.rollTheBones.buffs.skullAndCrossbones.duration > TRB.Data.spells.countTheOdds.duration then
								TRB.Data.snapshot.rollTheBones.buffs.skullAndCrossbones.fromCountTheOdds = false
							else
								TRB.Data.snapshot.rollTheBones.buffs.skullAndCrossbones.fromCountTheOdds = true
							end
						elseif type == "SPELL_AURA_REMOVED" then
							TRB.Data.snapshot.rollTheBones.buffs.skullAndCrossbones.fromCountTheOdds = false
						end
					elseif spellId == TRB.Data.spells.trueBearing.id then
						TRB.Functions.Aura:SnapshotGenericAura(spellId, type, TRB.Data.snapshot.rollTheBones.buffs.trueBearing)
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then
							if TRB.Data.snapshot.rollTheBones.buffs.trueBearing.duration > TRB.Data.spells.countTheOdds.duration then
								TRB.Data.snapshot.rollTheBones.buffs.trueBearing.fromCountTheOdds = false
							else
								TRB.Data.snapshot.rollTheBones.buffs.trueBearing.fromCountTheOdds = true
							end
						elseif type == "SPELL_AURA_REMOVED" then
							TRB.Data.snapshot.rollTheBones.buffs.trueBearing.fromCountTheOdds = false
						end
					elseif spellId == TRB.Data.spells.keepItRolling.id then
						if type == "SPELL_CAST_SUCCESS" then
							if TRB.Data.snapshot.rollTheBones.buffs.broadside.duration > 0 then
								TRB.Data.snapshot.rollTheBones.buffs.broadside.duration = TRB.Data.snapshot.rollTheBones.buffs.broadside.duration + TRB.Data.spells.keepItRolling.duration
							end
							if TRB.Data.snapshot.rollTheBones.buffs.buriedTreasure.duration > 0 then
								TRB.Data.snapshot.rollTheBones.buffs.buriedTreasure.duration = TRB.Data.snapshot.rollTheBones.buffs.buriedTreasure.duration + TRB.Data.spells.keepItRolling.duration
							end
							if TRB.Data.snapshot.rollTheBones.buffs.grandMelee.duration > 0 then
								TRB.Data.snapshot.rollTheBones.buffs.grandMelee.duration = TRB.Data.snapshot.rollTheBones.buffs.grandMelee.duration + TRB.Data.spells.keepItRolling.duration
							end
							if TRB.Data.snapshot.rollTheBones.buffs.ruthlessPrecision.duration > 0 then
								TRB.Data.snapshot.rollTheBones.buffs.ruthlessPrecision.duration = TRB.Data.snapshot.rollTheBones.buffs.ruthlessPrecision.duration + TRB.Data.spells.keepItRolling.duration
							end
							if TRB.Data.snapshot.rollTheBones.buffs.skullAndCrossbones.duration > 0 then
								TRB.Data.snapshot.rollTheBones.buffs.skullAndCrossbones.duration = TRB.Data.snapshot.rollTheBones.buffs.skullAndCrossbones.duration + TRB.Data.spells.keepItRolling.duration
							end
							if TRB.Data.snapshot.rollTheBones.buffs.trueBearing.duration > 0 then
								TRB.Data.snapshot.rollTheBones.buffs.trueBearing.duration = TRB.Data.snapshot.rollTheBones.buffs.trueBearing.duration + TRB.Data.spells.keepItRolling.duration
							end
						end
					end
				end

				-- Spec agnostic
				if spellId == TRB.Data.spells.crimsonVial.id then
					if type == "SPELL_CAST_SUCCESS" then
						TRB.Data.snapshot.crimsonVial.startTime = currentTime
						TRB.Data.snapshot.crimsonVial.duration = TRB.Data.spells.crimsonVial.cooldown
					end
				elseif spellId == TRB.Data.spells.sliceAndDice.id then
					TRB.Functions.Aura:SnapshotGenericAura(spellId, type, TRB.Data.snapshot.sliceAndDice)
				elseif spellId == TRB.Data.spells.distract.id then
					if type == "SPELL_CAST_SUCCESS" then
						TRB.Data.snapshot.distract.startTime = currentTime
						TRB.Data.snapshot.distract.duration = TRB.Data.spells.distract.cooldown
					end
				elseif spellId == TRB.Data.spells.feint.id then
					if type == "SPELL_CAST_SUCCESS" then
						TRB.Data.snapshot.feint.startTime = currentTime
						TRB.Data.snapshot.feint.duration = TRB.Data.spells.feint.cooldown
					end
				elseif spellId == TRB.Data.spells.kidneyShot.id then
					if type == "SPELL_CAST_SUCCESS" then
						TRB.Data.snapshot.kidneyShot.startTime = currentTime
						TRB.Data.snapshot.kidneyShot.duration = TRB.Data.spells.kidneyShot.cooldown
					end
				elseif spellId == TRB.Data.spells.shiv.id then
					if type == "SPELL_CAST_SUCCESS" then
						TRB.Data.snapshot.shiv.startTime = currentTime
						TRB.Data.snapshot.shiv.duration = TRB.Data.spells.shiv.cooldown
					end
				elseif spellId == TRB.Data.spells.adrenalineRush.id then
					if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REMOVED" then -- For right now, just redo the CheckCharacter() to get update Energy values
						TRB.Functions.Class:CheckCharacter()
					end
				elseif spellId == TRB.Data.spells.echoingReprimand.id then
					if type == "SPELL_CAST_SUCCESS" then
						TRB.Data.snapshot.echoingReprimand.startTime = currentTime
						TRB.Data.snapshot.echoingReprimand.duration = TRB.Data.spells.echoingReprimand.cooldown
					end
				elseif spellId == TRB.Data.spells.echoingReprimand.buffId[1] or spellId == TRB.Data.spells.echoingReprimand.buffId[2] or spellId == TRB.Data.spells.echoingReprimand.buffId[3] or spellId == TRB.Data.spells.echoingReprimand.buffId[4] or spellId == TRB.Data.spells.echoingReprimand.buffId[5] then
					local cpEntry = 1

					if spellId == TRB.Data.spells.echoingReprimand.buffId[1] then
						cpEntry = 2
					elseif spellId == TRB.Data.spells.echoingReprimand.buffId[2] then
						cpEntry = 3
					elseif spellId == TRB.Data.spells.echoingReprimand.buffId[3] or spellId == TRB.Data.spells.echoingReprimand.buffId[4] then
						cpEntry = 4
					elseif spellId == TRB.Data.spells.echoingReprimand.buffId[5] then
						cpEntry = 5
					end

					if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Echoing Reprimand Applied to Target
						TRB.Data.snapshot.echoingReprimand[cpEntry].enabled = true
						_, _, TRB.Data.snapshot.echoingReprimand[cpEntry].comboPoints, _, TRB.Data.snapshot.echoingReprimand[cpEntry].duration, TRB.Data.snapshot.echoingReprimand[cpEntry].endTime, _, _, _, TRB.Data.snapshot.echoingReprimand[cpEntry].spellId = TRB.Functions.Aura:FindBuffById(spellId)
					elseif type == "SPELL_AURA_REMOVED" then
						TRB.Data.snapshot.echoingReprimand[cpEntry].enabled = false
						TRB.Data.snapshot.echoingReprimand[cpEntry].spellId = nil
						TRB.Data.snapshot.echoingReprimand[cpEntry].endTime = nil
						TRB.Data.snapshot.echoingReprimand[cpEntry].comboPoints = 0
					end
				elseif spellId == TRB.Data.spells.sepsis.id then
					if type == "SPELL_CAST_SUCCESS" then
						TRB.Data.snapshot.sepsis.startTime = currentTime
						TRB.Data.snapshot.sepsis.duration = TRB.Data.spells.sepsis.cooldown
					end
				elseif spellId == TRB.Data.spells.sepsis.buffId then
					TRB.Functions.Aura:SnapshotGenericAura(spellId, type, TRB.Data.snapshot.sepsis, true)
					if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then
						if TRB.Data.settings.rogue.assassination.audio.sepsis.enabled then
							---@diagnostic disable-next-line: redundant-parameter
							PlaySoundFile(TRB.Data.settings.rogue.assassination.audio.sepsis.sound, TRB.Data.settings.core.audio.channel.channel)
						end
					end
				elseif spellId == TRB.Data.spells.cripplingPoison.id then
					if TRB.Functions.Class:InitializeTarget(destGUID) then
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- CP Applied to Target
							TRB.Data.snapshot.targetData.targets[destGUID].cripplingPoison = true
							if type == "SPELL_AURA_APPLIED" then
								TRB.Data.snapshot.targetData.cripplingPoison = TRB.Data.snapshot.targetData.cripplingPoison + 1
							end
							triggerUpdate = true
						elseif type == "SPELL_AURA_REMOVED" then
							TRB.Data.snapshot.targetData.targets[destGUID].cripplingPoison = false
							TRB.Data.snapshot.targetData.targets[destGUID].cripplingPoisonRemaining = 0
							TRB.Data.snapshot.targetData.cripplingPoison = TRB.Data.snapshot.targetData.cripplingPoison - 1
							triggerUpdate = true
						--elseif type == "SPELL_PERIODIC_DAMAGE" then
						end
					end
				elseif spellId == TRB.Data.spells.woundPoison.id then
					if TRB.Functions.Class:InitializeTarget(destGUID) then
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- WP Applied to Target
							TRB.Data.snapshot.targetData.targets[destGUID].woundPoison = true
							if type == "SPELL_AURA_APPLIED" then
								TRB.Data.snapshot.targetData.woundPoison = TRB.Data.snapshot.targetData.woundPoison + 1
							end
							triggerUpdate = true
						elseif type == "SPELL_AURA_REMOVED" then
							TRB.Data.snapshot.targetData.targets[destGUID].woundPoison = false
							TRB.Data.snapshot.targetData.targets[destGUID].woundPoisonRemaining = 0
							TRB.Data.snapshot.targetData.woundPoison = TRB.Data.snapshot.targetData.woundPoison - 1
							triggerUpdate = true
						--elseif type == "SPELL_PERIODIC_DAMAGE" then
						end
					end
				elseif spellId == TRB.Data.spells.numbingPoison.id then
					if TRB.Functions.Class:InitializeTarget(destGUID) then
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- NP Applied to Target
							TRB.Data.snapshot.targetData.targets[destGUID].numbingPoison = true
							if type == "SPELL_AURA_APPLIED" then
								TRB.Data.snapshot.targetData.numbingPoison = TRB.Data.snapshot.targetData.numbingPoison + 1
							end
							triggerUpdate = true
						elseif type == "SPELL_AURA_REMOVED" then
							TRB.Data.snapshot.targetData.targets[destGUID].numbingPoison = false
							TRB.Data.snapshot.targetData.targets[destGUID].numbingPoisonRemaining = 0
							TRB.Data.snapshot.targetData.numbingPoison = TRB.Data.snapshot.targetData.numbingPoison - 1
							triggerUpdate = true
						--elseif type == "SPELL_PERIODIC_DAMAGE" then
						end
					end
				elseif spellId == TRB.Data.spells.atrophicPoison.id then
					if TRB.Functions.Class:InitializeTarget(destGUID) then
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Atrophic Poison Applied to Target
							TRB.Data.snapshot.targetData.targets[destGUID].atrophicPoison = true
							if type == "SPELL_AURA_APPLIED" then
								TRB.Data.snapshot.targetData.atrophicPoison = TRB.Data.snapshot.targetData.atrophicPoison + 1
							end
							triggerUpdate = true
						elseif type == "SPELL_AURA_REMOVED" then
							TRB.Data.snapshot.targetData.targets[destGUID].atrophicPoison = false
							TRB.Data.snapshot.targetData.targets[destGUID].atrophicPoisonRemaining = 0
							TRB.Data.snapshot.targetData.atrophicPoison = TRB.Data.snapshot.targetData.atrophicPoison - 1
							triggerUpdate = true
						--elseif type == "SPELL_PERIODIC_DAMAGE" then
						end
					end
				elseif spellId == TRB.Data.spells.deathFromAbove.id then
					if type == "SPELL_CAST_SUCCESS" then
						TRB.Data.snapshot.deathFromAbove.startTime = currentTime
						TRB.Data.snapshot.deathFromAbove.duration = TRB.Data.spells.deathFromAbove.cooldown
					end
				elseif spellId == TRB.Data.spells.dismantle.id then
					if type == "SPELL_CAST_SUCCESS" then
						TRB.Data.snapshot.dismantle.startTime = currentTime
						TRB.Data.snapshot.dismantle.duration = TRB.Data.spells.dismantle.cooldown
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
			TRB.Functions.Bar:UpdateSanityCheckValues(TRB.Data.settings.rogue.assassination)
			TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.rogue.assassination)
			specCache.assassination.talents = TRB.Functions.Talent:GetTalents()
			FillSpellData_Assassination()
			TRB.Functions.Character:LoadFromSpecializationCache(specCache.assassination)
			TRB.Functions.RefreshLookupData = RefreshLookupData_Assassination

			if TRB.Data.barConstructedForSpec ~= "assassination" then
				TRB.Data.barConstructedForSpec = "assassination"
				ConstructResourceBar(specCache.assassination.settings)
			else
				TRB.Functions.Bar:SetPosition(TRB.Data.settings.rogue.assassination, TRB.Frames.barContainerFrame)
			end
		elseif specId == 2 then
			TRB.Functions.Bar:UpdateSanityCheckValues(TRB.Data.settings.rogue.outlaw)
			TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.rogue.outlaw)
			specCache.outlaw.talents = TRB.Functions.Talent:GetTalents()
			FillSpellData_Outlaw()
			TRB.Functions.Character:LoadFromSpecializationCache(specCache.outlaw)
			TRB.Functions.RefreshLookupData = RefreshLookupData_Outlaw

			if TRB.Data.barConstructedForSpec ~= "outlaw" then
				TRB.Data.barConstructedForSpec = "outlaw"
				ConstructResourceBar(specCache.outlaw.settings)
			else
				TRB.Functions.Bar:SetPosition(TRB.Data.settings.rogue.outlaw, TRB.Frames.barContainerFrame)
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
		if classIndexId == 4 then
			if (event == "ADDON_LOADED" and arg1 == "TwintopInsanityBar") then
				if not TRB.Details.addonData.loaded then
					TRB.Details.addonData.loaded = true

					local settings = TRB.Options.Rogue.LoadDefaultSettings()
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
							TRB.Data.settings.rogue.assassination = TRB.Functions.LibSharedMedia:ValidateLsmValues("Assassination Rogue", TRB.Data.settings.rogue.assassination)
							TRB.Data.settings.rogue.outlaw = TRB.Functions.LibSharedMedia:ValidateLsmValues("Outlaw Rogue", TRB.Data.settings.rogue.outlaw)
							--TRB.Data.settings.rogue.subtlety = TRB.Functions.LibSharedMedia:ValidateLsmValues("Subtlety Rogue", TRB.Data.settings.rogue.subtlety)
							
							FillSpellData_Assassination()
							FillSpellData_Outlaw()
							--FillSpellData_Subtlety()
							TRB.Data.barConstructedForSpec = nil
							SwitchSpec()
							TRB.Options.Rogue.ConstructOptionsPanel(specCache)
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
---@diagnostic disable-next-line: missing-parameter
		TRB.Functions.Character:CheckCharacter()
		TRB.Data.character.className = "rogue"
		TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.Energy)
		local maxComboPoints = UnitPowerMax("player", Enum.PowerType.ComboPoints)
		local settings = nil

		if specId == 1 then
			settings = TRB.Data.settings.rogue.assassination
		elseif specId == 2 then
			settings = TRB.Data.settings.rogue.outlaw
		end
		
		if settings ~= nil then
			if maxComboPoints ~= TRB.Data.character.maxResource2 then
				TRB.Data.character.maxResource2 = maxComboPoints
				TRB.Functions.Bar:SetPosition(settings, TRB.Frames.barContainerFrame)
			end
		end
	end

	function TRB.Functions.Class:EventRegistration()
		local specId = GetSpecialization()
		if specId == 1 and TRB.Data.settings.core.enabled.rogue.assassination == true then
			TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.rogue.assassination)
			TRB.Data.specSupported = true
		elseif specId == 2 and TRB.Data.settings.core.enabled.rogue.outlaw == true then
			TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.rogue.outlaw)
			TRB.Data.specSupported = true
		else
			--TRB.Data.resource = MANA
			TRB.Data.specSupported = false
			targetsTimerFrame:SetScript("OnUpdate", nil)
			timerFrame:SetScript("OnUpdate", nil)
			barContainerFrame:UnregisterEvent("UNIT_POWER_FREQUENT")
			barContainerFrame:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
			combatFrame:UnregisterEvent("PLAYER_REGEN_DISABLED")
			combatFrame:UnregisterEvent("PLAYER_REGEN_ENABLED")
			TRB.Details.addonData.registered = false
			barContainerFrame:Hide()
		end

		if TRB.Data.specSupported then
			TRB.Data.resource = Enum.PowerType.Energy
			TRB.Data.resourceFactor = 1
			TRB.Data.resource2 = Enum.PowerType.ComboPoints
			TRB.Data.resource2Factor = 1

			TRB.Functions.Class:CheckCharacter()

			targetsTimerFrame:SetScript("OnUpdate", function(self, sinceLastUpdate) targetsTimerFrame:onUpdate(sinceLastUpdate) end)
			timerFrame:SetScript("OnUpdate", function(self, sinceLastUpdate) timerFrame:onUpdate(sinceLastUpdate) end)
			barContainerFrame:RegisterEvent("UNIT_POWER_FREQUENT")
			barContainerFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
			combatFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
			combatFrame:RegisterEvent("PLAYER_REGEN_ENABLED")

			TRB.Details.addonData.registered = true
		end
		TRB.Functions.Bar:HideResourceBar()
	end

	function TRB.Functions.Class:HideResourceBar(force)
		local affectingCombat = UnitAffectingCombat("player")
		local specId = GetSpecialization()

		if specId == 1 then
			if not TRB.Data.specSupported or force or ((not affectingCombat) and
				(not UnitInVehicle("player")) and (
					(not TRB.Data.settings.rogue.assassination.displayBar.alwaysShow) and (
						(not TRB.Data.settings.rogue.assassination.displayBar.notZeroShow) or
						(TRB.Data.settings.rogue.assassination.displayBar.notZeroShow and TRB.Data.snapshot.resource == TRB.Data.character.maxResource)
					)
				)) then
				TRB.Frames.barContainerFrame:Hide()
				TRB.Data.snapshot.isTracking = false
			else
				TRB.Data.snapshot.isTracking = true
				if TRB.Data.settings.rogue.assassination.displayBar.neverShow == true then
					TRB.Frames.barContainerFrame:Hide()
				else
					TRB.Frames.barContainerFrame:Show()
				end
			end
		elseif specId == 2 then
			if not TRB.Data.specSupported or force or ((not affectingCombat) and
				(not UnitInVehicle("player")) and (
					(not TRB.Data.settings.rogue.outlaw.displayBar.alwaysShow) and (
						(not TRB.Data.settings.rogue.outlaw.displayBar.notZeroShow) or
						(TRB.Data.settings.rogue.outlaw.displayBar.notZeroShow and TRB.Data.snapshot.resource == TRB.Data.character.maxResource)
					)
				)) then
				TRB.Frames.barContainerFrame:Hide()
				TRB.Data.snapshot.isTracking = false
			else
				TRB.Data.snapshot.isTracking = true
				if TRB.Data.settings.rogue.outlaw.displayBar.neverShow == true then
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
				if specId == 1 then
					--Bleeds
					TRB.Data.snapshot.targetData.targets[guid].garrote = false
					TRB.Data.snapshot.targetData.targets[guid].garroteRemaining = 0
					TRB.Data.snapshot.targetData.targets[guid].rupture = false
					TRB.Data.snapshot.targetData.targets[guid].ruptureRemaining = 0
					TRB.Data.snapshot.targetData.targets[guid].internalBleeding = false
					TRB.Data.snapshot.targetData.targets[guid].internalBleedingRemaining = 0
					TRB.Data.snapshot.targetData.targets[guid].crimsonTempest = false
					TRB.Data.snapshot.targetData.targets[guid].crimsonTempestRemaining = 0
					TRB.Data.snapshot.targetData.targets[guid].serratedBoneSpike = false
					--Poisons
					TRB.Data.snapshot.targetData.targets[guid].amplifyingPoison = false
					TRB.Data.snapshot.targetData.targets[guid].amplifyingPoisonRemaining = 0
					TRB.Data.snapshot.targetData.targets[guid].atrophicPoison = false
					TRB.Data.snapshot.targetData.targets[guid].atrophicPoisonRemaining = 0
					TRB.Data.snapshot.targetData.targets[guid].deadlyPoison = false
					TRB.Data.snapshot.targetData.targets[guid].deadlyPoisonRemaining = 0
					TRB.Data.snapshot.targetData.targets[guid].cripplingPoison = false
					TRB.Data.snapshot.targetData.targets[guid].cripplingPoisonRemaining = 0
					TRB.Data.snapshot.targetData.targets[guid].woundPoison = false
					TRB.Data.snapshot.targetData.targets[guid].woundPoisonRemaining = 0
					TRB.Data.snapshot.targetData.targets[guid].numbingPoison = false
					TRB.Data.snapshot.targetData.targets[guid].numbingPoisonRemaining = 0
				elseif specId == 2 then
					--Poisons
					TRB.Data.snapshot.targetData.targets[guid].cripplingPoison = false
					TRB.Data.snapshot.targetData.targets[guid].cripplingPoisonRemaining = 0
					TRB.Data.snapshot.targetData.targets[guid].woundPoison = false
					TRB.Data.snapshot.targetData.targets[guid].woundPoisonRemaining = 0
					TRB.Data.snapshot.targetData.targets[guid].numbingPoison = false
					TRB.Data.snapshot.targetData.targets[guid].numbingPoisonRemaining = 0
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
			settings = TRB.Data.settings.rogue.assassination
		elseif specId == 2 then
			settings = TRB.Data.settings.rogue.outlaw
		end

		if specId == 1 then --Assassination
			-- Bleeds
			if var == "$isBleeding" then
				if IsTargetBleeding() then
					valid = true
				end
			elseif var == "$ctCount" or var == "$crimsonTempestCount" then
				if TRB.Data.snapshot.targetData.crimsonTempest > 0 then
					valid = true
				end
			elseif var == "$ctTime" or var == "$crimsonTempestTime" then
				if not UnitIsDeadOrGhost("target") and
					UnitCanAttack("player", "target") and
					TRB.Data.snapshot.targetData.currentTargetGuid ~= nil and
					TRB.Data.snapshot.targetData.targets ~= nil and
					TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid] ~= nil and
					TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].crimsonTempestRemaining > 0 then
					valid = true
				end
			elseif var == "$garroteCount" then
				if TRB.Data.snapshot.targetData.garrote > 0 then
					valid = true
				end
			elseif var == "$garroteTime" then
				if not UnitIsDeadOrGhost("target") and
					UnitCanAttack("player", "target") and
					TRB.Data.snapshot.targetData.currentTargetGuid ~= nil and
					TRB.Data.snapshot.targetData.targets ~= nil and
					TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid] ~= nil and
					TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].garroteRemaining > 0 then
					valid = true
				end
			elseif var == "$ibCount" or var == "$internalBleedingCount" then
				if TRB.Data.snapshot.targetData.internalBleeding > 0 then
					valid = true
				end
			elseif var == "$ibTime" or var == "$internalBleedingTime" then
				if not UnitIsDeadOrGhost("target") and
					UnitCanAttack("player", "target") and
					TRB.Data.snapshot.targetData.currentTargetGuid ~= nil and
					TRB.Data.snapshot.targetData.targets ~= nil and
					TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid] ~= nil and
					TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].internalBleedingRemaining > 0 then
					valid = true
				end
			elseif var == "$ruptureCount" then
				if TRB.Data.snapshot.targetData.rupture > 0 then
					valid = true
				end
			elseif var == "$ruptureTime" then
				if not UnitIsDeadOrGhost("target") and
					UnitCanAttack("player", "target") and
					TRB.Data.snapshot.targetData.currentTargetGuid ~= nil and
					TRB.Data.snapshot.targetData.targets ~= nil and
					TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid] ~= nil and
					TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].ruptureRemaining > 0 then
					valid = true
				end
			elseif var == "$dpCount" or var == "$deadlyPoisonCount" then
				if TRB.Data.snapshot.targetData.deadlyPoison > 0 then
					valid = true
				end
			elseif var == "$dpTime" or var == "$deadlyPoisonTime" then
				if not UnitIsDeadOrGhost("target") and
					UnitCanAttack("player", "target") and
					TRB.Data.snapshot.targetData.currentTargetGuid ~= nil and
					TRB.Data.snapshot.targetData.targets ~= nil and
					TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid] ~= nil and
					TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].deadlyPoisonRemaining > 0 then
					valid = true
				end
			elseif var == "$amplifyingPoisonCount" then
				if TRB.Data.snapshot.targetData.amplifyingPoison > 0 then
					valid = true
				end
			elseif var == "$amplifyingPoisonTime" then
				if not UnitIsDeadOrGhost("target") and
					UnitCanAttack("player", "target") and
					TRB.Data.snapshot.targetData.currentTargetGuid ~= nil and
					TRB.Data.snapshot.targetData.targets ~= nil and
					TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid] ~= nil and
					TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].amplifyingPoisonRemaining > 0 then
					valid = true
				end
			-- Other abilities
			elseif var == "$blindsideTime" then
				if TRB.Data.snapshot.blindside.spellId ~= nil then
					valid = true
				end
			end
		elseif specId == 2 then --Outlaw
			-- Roll the Bones buff counts
			if var == "$rtbCount" or var == "$rollTheBonesCount" then
				if TRB.Data.snapshot.rollTheBones.count > 0 then
					valid = true
				end
			elseif var == "$rtbTemporaryCount" or var == "$rollTheBonesTemporaryCount" then
				if TRB.Data.snapshot.rollTheBones.temporaryCount > 0 then
					valid = true
				end
			elseif var == "$rtbAllCount" or var == "$rollTheBonesAllCount" then
				if TRB.Data.snapshot.rollTheBones.count > 0 or TRB.Data.snapshot.rollTheBones.temporaryCount > 0 then
					valid = true
				end
			elseif var == "$rtbBuffTime" or var == "$rollTheBonesBuffTime" then
				if TRB.Data.snapshot.rollTheBones.remaining > 0 then
					valid = true
				end
			-- Roll the Bones Buffs
			elseif var == "$broadsideTime" then
				if TRB.Data.snapshot.rollTheBones.buffs.broadside.duration > 0 then
					valid = true
				end
			elseif var == "$buriedTreasureTime" then
				if TRB.Data.snapshot.rollTheBones.buffs.buriedTreasure.duration > 0 then
					valid = true
				end
			elseif var == "$grandMeleeTime" then
				if TRB.Data.snapshot.rollTheBones.buffs.grandMelee.duration > 0 then
					valid = true
				end
			elseif var == "$ruthlessPrecisionTime" then
				if TRB.Data.snapshot.rollTheBones.buffs.ruthlessPrecision.duration > 0 then
					valid = true
				end
			elseif var == "$skullAndCrossbonesTime" then
				if TRB.Data.snapshot.rollTheBones.buffs.skullAndCrossbones.duration > 0 then
					valid = true
				end
			elseif var == "$trueBearingTime" then
				if TRB.Data.snapshot.rollTheBones.buffs.trueBearing.duration > 0 then
					valid = true
				end
			-- Other abilities
			elseif var == "$opportunityTime" then
				if TRB.Data.snapshot.opportunity.spellId ~= nil then
					valid = true
				end
			elseif var == "$rtbGoodBuff" or var == "$rollTheBonesGoodBuff" then
				if TRB.Data.snapshot.rollTheBones.goodBuffs == true then
					valid = true
				end
			end
		--[[elseif specId == 3 then --Survivial]]
		end

		if var == "$resource" or var == "$energy" then
			if TRB.Data.snapshot.resource > 0 then
				valid = true
			end
		elseif var == "$resourceMax" or var == "$energyMax" then
			valid = true
		elseif var == "$resourceTotal" or var == "$energyTotal" then
			if TRB.Data.snapshot.resource > 0 or
				(TRB.Data.snapshot.casting.resourceRaw ~= nil and TRB.Data.snapshot.casting.resourceRaw ~= 0)
				then
				valid = true
			end
		elseif var == "$resourcePlusCasting" or var == "$energyPlusCasting" then
			if TRB.Data.snapshot.resource > 0 or
				(TRB.Data.snapshot.casting.resourceRaw ~= nil and TRB.Data.snapshot.casting.resourceRaw ~= 0) then
				valid = true
			end
		elseif var == "$overcap" or var == "$energyOvercap" or var == "$resourceOvercap" then
			local threshold = ((TRB.Data.snapshot.resource / TRB.Data.resourceFactor) + TRB.Data.snapshot.casting.resourceFinal)
			if settings.overcap.mode == "relative" and (TRB.Data.character.maxResource + settings.overcap.relative) < threshold then
				return true
			elseif settings.overcap.mode == "fixed" and settings.overcap.fixed < threshold then
				return true
			end
		elseif var == "$resourcePlusPassive" or var == "$energyPlusPassive" then
			if TRB.Data.snapshot.resource > 0 then
				valid = true
			end
		elseif var == "$casting" then
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
		elseif var == "$regen" or var == "$regenEnergy" or var == "$energyRegen" then
			if TRB.Data.snapshot.resource < TRB.Data.character.maxResource and
				((settings.generation.mode == "time" and settings.generation.time > 0) or
				(settings.generation.mode == "gcd" and settings.generation.gcds > 0)) then
				valid = true
			end
		elseif var == "$comboPoints" then
			valid = true
		elseif var == "$comboPointsMax" then
			valid = true
		elseif var == "$sadTime" or var == "$sliceAndDiceTime" then
			if TRB.Data.snapshot.sliceAndDice.spellId ~= nil then
				valid = true
			end
		elseif var == "$sbsCount" or var == "$serratedBoneSpikeCount" then
			if TRB.Data.snapshot.targetData.serratedBoneSpike > 0 then
				valid = true
			end
		-- Poisons
		elseif var == "$cpCount" or var == "$cripplingPoisonCount" then
			if TRB.Data.snapshot.targetData.cripplingPoison > 0 then
				valid = true
			end
		elseif var == "$cpTime" or var == "$cripplingPoisonTime" then
			if not UnitIsDeadOrGhost("target") and
				UnitCanAttack("player", "target") and
				TRB.Data.snapshot.targetData.currentTargetGuid ~= nil and
				TRB.Data.snapshot.targetData.targets ~= nil and
				TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid] ~= nil and
				TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].cripplingPoisonRemaining > 0 then
				valid = true
			end
		elseif var == "$npCount" or var == "$numbingPoisonCount" then
			if TRB.Data.snapshot.targetData.numbingPoison > 0 then
				valid = true
			end
		elseif var == "$npTime" or var == "$numbingPoisonTime" then
			if not UnitIsDeadOrGhost("target") and
				UnitCanAttack("player", "target") and
				TRB.Data.snapshot.targetData.currentTargetGuid ~= nil and
				TRB.Data.snapshot.targetData.targets ~= nil and
				TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid] ~= nil and
				TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].numbingPoisonRemaining > 0 then
				valid = true
			end
		elseif var == "$atrophicPoisonCount" then
			if TRB.Data.snapshot.targetData.atrophicPoison > 0 then
				valid = true
			end
		elseif var == "$atrophicPoisonPoisonTime" then
			if not UnitIsDeadOrGhost("target") and
				UnitCanAttack("player", "target") and
				TRB.Data.snapshot.targetData.currentTargetGuid ~= nil and
				TRB.Data.snapshot.targetData.targets ~= nil and
				TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid] ~= nil and
				TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].atrophicPoisonRemaining > 0 then
				valid = true
			end
		elseif var == "$wpCount" or var == "$woundPoisonCount" then
			if TRB.Data.snapshot.targetData.woundPoison > 0 then
				valid = true
			end
		elseif var == "$wpTime" or var == "$woundPoisonTime" then
			if not UnitIsDeadOrGhost("target") and
				UnitCanAttack("player", "target") and
				TRB.Data.snapshot.targetData.currentTargetGuid ~= nil and
				TRB.Data.snapshot.targetData.targets ~= nil and
				TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid] ~= nil and
				TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].woundPoisonRemaining > 0 then
				valid = true
			end
		elseif var == "$inStealth" then
			if IsStealthed() then
				valid = true
			end
		end

		return valid
	end

	--HACK to fix FPS
	local updateRateLimit = 0

	function TRB.Functions.Class:TriggerResourceBarUpdates()
		local specId = GetSpecialization()
		if specId ~= 1 and specId ~= 2 then
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