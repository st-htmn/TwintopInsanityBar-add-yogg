local _, TRB = ...
local _, _, classIndexId = UnitClass("player")
if classIndexId == 11 then --Only do this if we're on a Druid!
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
		balance = {
			snapshot = {},
			barTextVariables = {},
			settings = {
				bar = nil,
				comboPoints = nil,
				displayBar = nil,
				font = nil,
				textures = nil,
				thresholds = nil
			}
		},
		feral = {
			snapshot = {},
			barTextVariables = {},
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
			barTextVariables = {},
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
		-- Balance
		specCache.balance.Global_TwintopResourceBar = {
			ttd = 0,
			resource = {
				resource = 0,
				casting = 0,
				passive = 0
			},
			dots = {
				sunfireCount = 0,
				moonfireCount = 0,
				stellarFlareCount = 0
			},
			furyOfElune = {
				astralPower = 0,
				ticks = 0,
				remaining = 0
			}
		}
		
		specCache.balance.character = {
			guid = UnitGUID("player"),
---@diagnostic disable-next-line: missing-parameter
			specGroup = GetActiveSpecGroup(),
			maxResource = 100,
			starsurgeThreshold = 40,
			starfallThreshold = 50,
			pandemicModifier = 1.0,
			effects = {
			}
		}

		specCache.balance.spells = {
			-- Druid Class Baseline Abilities
			moonfire = {
				id = 164812,
				name = "",
				icon = "",
				astralPower = 6,
				pandemic = true,
				pandemicTime = 22 * 0.3,
				baseline = true
			},
		
			-- Druid Class Talents
			starfire = {
				id = 194153,
				name = "",
				icon = "",
				astralPower = 10,
				baseline = true,
				isTalent = true
			},
			starsurge = {
				id = 78674,
				name = "",
				icon = "",
				texture = "",
				astralPower = -40,
				thresholdId = 1,
				settingKey = "starsurge",
				thresholdUsable = false,
				isTalent = true,
				baseline = true,
				isSnowflake = true
			},
			starsurge2 = {
				id = 78674,
				name = "",
				icon = "",
				texture = "",
				astralPower = -80,
				thresholdId = 2,
				settingKey = "starsurge2",
				thresholdUsable = false,
				isTalent = true,
				baseline = true,
				isSnowflake = true
			},
			starsurge3 = {
				id = 78674,
				name = "",
				icon = "",
				texture = "",
				astralPower = -120,
				thresholdId = 3,
				settingKey = "starsurge3",
				thresholdUsable = false,
				isTalent = true,
				baseline = true,
				isSnowflake = true
			},
			moonkinForm = {
				id = 24858,
				name = "",
				icon = "",
				isTalent = true
			},
			sunfire = {
				id = 164815,
				name = "",
				icon = "",
				astralPower = 6,
				pandemic = true,
				pandemicTime = 18 * 0.3,
				isTalent = true
			},

			-- Balance Spec Baseline Abilities
			wrath = {
				id = 190984,
				name = "",
				icon = "",
				astralPower = 8
			},

			-- Balance Spec Talents
			eclipse = {
				id = 79577,
				name = "",
				icon = "",
				isTalent = true
			},
			eclipseSolar = {
				id = 48517,
				name = "",
				icon = ""
			},
			eclipseLunar = {
				id = 48518,
				name = "",
				icon = ""
			},
			naturesBalance = {
				id = 202430,
				name = "",
				icon = "",
				astralPower = 2,
				outOfCombatAstralPower = 6,
				tickRate = 3,
				isTalent = true
			},
			starfall = {
				id = 191034,
				name = "",
				icon = "",
				texture = "",
				astralPower = -50,
				thresholdId = 4,
				settingKey = "starfall",
				thresholdUsable = false,
				pandemic = true,
				pandemicTime = 8 * 0.3,
				isTalent = true,
				isSnowflake = true
			},
			stellarFlare = {
				id = 202347,
				name = "",
				icon = "",
				astralPower = 10,
				pandemic = true,
				pandemicTime = 24 * 0.3,
				isTalent = true
			},
			wildSurges = {
				id = 406890,
				name = "",
				icon = "",
				isTalent = true,
				modifier = 2
			},
			rattleTheStars = {
				id = 340049,
				name = "",
				icon = "",
				buffId = 393955,
				modifier = -0.05,
				isTalent = true
			},
			starweaver = {
				id = 393940,
				name = "",
				icon = "",
				isTalent = true
			},
			starweaversWarp = { --Free Starfall
				id = 393942,
				name = "",
				icon = ""
			},
			starweaversWeft = { --Free Starsurge
				id = 393944,
				name = "",
				icon = ""
			},
			celestialAlignment = {
				id = 194223,
				name = "",
				icon = "",
				isTalent = true
			},
			primordialArcanicPulsar = {
				id = 393960,
				name = "",
				icon = "",
				maxAstralPower = 600,
				isTalent = true
			},
			soulOfTheForest = {
				id = 114107,
				name = "",
				icon = "",
				modifier = {
					wrath = 0.3,
					starfire = 0.2
				},
				isTalent = true
			},
			-- TODO: Add Wild Mushroom + associated tracking
			incarnationChosenOfElune = {
				id = 102560,
				talentId = 394013,
				name = "",
				icon = "",
				isTalent = true
			},
			elunesGuidance = {
				id = 393991,
				name = "",
				icon = "",
				modifierStarsurge = -8,
				modifierStarfall = -10,
				isTalent = true
			},
			furyOfElune = {
				id = 202770,
				name = "",
				icon = "",
				astralPower = 2.5,
				duration = 8,
				ticks = 16,
				tickRate = 0.5,
				isTalent = true
			},
			newMoon = {
				id = 274281,
				name = "",
				icon = "",
				astralPower = 12,
				recharge = 20,
				isTalent = true
			},
			halfMoon = {
				id = 274282,
				name = "",
				icon = "",
				astralPower = 24
			},
			fullMoon = {
				id = 274283,
				name = "",
				icon = "",
				astralPower = 50
			},
			sunderedFirmament = {
				id = 394094,
				name = "",
				icon = "",
				buffId = 394108,
				astralPower = 0.5,
				duration = 8,
				ticks = 16,
				tickRate = 0.5,
				isTalent = true
			},
			touchTheCosmos = { -- T29 4P
				id = 394414,
				name = "",
				icon = "",
				astralPowerMod = -10
			}
		}
		
		specCache.balance.snapshot.audio = {
			playedSsCue = false,
			playedSfCue = false,
			playedstarweaverCue = false
		}

		specCache.balance.snapshot.targetData = {
			ttdIsActive = false,
			currentTargetGuid = nil,
			sunfire = 0,
			moonfire = 0,
			stellarFlare = 0,
			targets = {}
		}
		specCache.balance.snapshot.moonkinForm = {
			isActive = false
		}

		specCache.balance.snapshot.furyOfElune = {
			isActive = false,
			ticksRemaining = 0,
			startTime = nil,
			astralPower = 0
		}
		specCache.balance.snapshot.sunderedFirmament = {
			isActive = false,
			ticksRemaining = 0,
			startTime = nil,
			astralPower = 0
		}

		specCache.balance.snapshot.eclipseSolar = {
			isActive = false,
			spellId = nil,
			endTime = nil
		}
		specCache.balance.snapshot.eclipseLunar = {
			isActive = false,
			spellId = nil,
			endTime = nil
		}
		specCache.balance.snapshot.celestialAlignment = {
			isActive = false,
			spellId = nil,
			endTime = nil
		}
		specCache.balance.snapshot.incarnationChosenOfElune = {
			isActive = false,
			spellId = nil,
			endTime = nil
		}
		specCache.balance.snapshot.starfall = {
			isActive = false,
			spellId = nil,
			endTime = nil, --End of buff
			duration = 0, --Duration of buff
		}
		specCache.balance.snapshot.newMoon = {
			currentSpellId = nil,
			currentIcon = "",
			currentKey = "",
			checkAfter = nil,
			charges = 3,
			maxCharges = 3,
			startTime = nil,
			duration = 0
		}
		specCache.balance.snapshot.starweaversWarp = {
			isActive = false,
			spellId = nil,
			endTime = nil,
			duration = 0
		}
		specCache.balance.snapshot.starweaversWeft = {
			isActive = false,
			spellId = nil,
			endTime = nil,
			duration = 0
		}
		specCache.balance.snapshot.rattleTheStars = {
			isActive = false,
			spellId = nil,
			endTime = nil,
			duration = 0,
			stacks = 0
		}
		specCache.balance.snapshot.primordialArcanicPulsar = {
			currentAstralPower = 0
		}
		specCache.balance.snapshot.touchTheCosmos = {
			isActive = false,
			spellId = nil,
			endTime = nil,
			duration = 0
		}

		-- Feral
		specCache.feral.Global_TwintopResourceBar = {
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

		specCache.feral.character = {
			guid = UnitGUID("player"),
---@diagnostic disable-next-line: missing-parameter
			specGroup = GetActiveSpecGroup(),
			specId = 1,
			maxResource = 100,
			maxResource2 = 5,
			pandemicModifier = 1.0,
			effects = {
			}
		}

		specCache.feral.spells = {
			-- Racial abilities
			shadowmeld = {
				id = 58984,
				name = "",
				icon = ""
			},

			-- Druid Class Baseline Abilities
			catForm = {
				id = 768,
				name = "",
				icon = "",
				baseline = true
			},

			-- Druid Class Talents
			rake = {
				id = 155722,
				name = "",
				icon = "",
				energy = -35,
				comboPointsGenerated = 1,
				texture = "",
				thresholdId = 1,
				settingKey = "rake",
				thresholdUsable = false,
				hasSnapshot = true,
				pandemic = true,
				pandemicTime = 15 * 0.3,
				bonuses = {
					stealth = true,
					tigersFury = true
				},
				isTalent = true,
				baseline = true
			},
			thrash = {
				id = 405233,
				talentId = 106830,
				name = "",
				icon = "",
				energy = -40,
				comboPointsGenerated = 1,
				thresholdId = 2,
				texture = "",
				settingKey = "thrash",
				thresholdUsable = false,
				hasSnapshot = true,
				pandemic = true,
				pandemicTime = 15 * 0.3,
				bonuses = {
					momentOfClarity = true,
					tigersFury = true
				},
				isTalent = true
			},
			rip = {
				id = 1079,
				name = "",
				icon = "",
				energy = -20,
				comboPoints = true,
				thresholdId = 4,
				texture = "",
				settingKey = "rip",
				thresholdUsable = false,
				hasSnapshot = true,
				pandemicTimes = {
					8 * 0.3, -- 0 CP, show same as if we had 1
					8 * 0.3,
					12 * 0.3,
					16 * 0.3,
					20 * 0.3,
					24 * 0.3
				},
				bonuses = {
					bloodtalons = true,
					tigersFury = true
				},
				isTalent = true,
				baseline = true
			},
			maim = {
				id = 22570,
				name = "",
				icon = "",
				energy = -30,
				comboPoints = true,
				texture = "",
				thresholdId = 5,
				settingKey = "maim",
				hasCooldown = true,
				cooldown = 20,
				thresholdUsable = false,
				isTalent = true
			},
			sunfire = {
				id = 164815,
				name = "",
				icon = "",
				astralPower = 2,
				pandemic = true,
				pandemicTime = 13.5 * 0.3,
				isTalent = true
			},

			-- Feral Spec Baseline Abilities
			ferociousBite = {
				id = 22568,
				name = "",
				icon = "",
				energy = -25,
				energyMax = -50,
				comboPoints = true,
				texture = "",
				thresholdId = 6,
				settingKey = "ferociousBite",
				isSnowflake = true, -- Really between 25-50 energy, minus Relentless Predator
				thresholdUsable = false,
				relentlessPredator = true
			},
			ferociousBiteMinimum = {
				id = 22568,
				name = "",
				icon = "",
				energy = -25,
				comboPoints = true,
				texture = "",
				thresholdId = 7,
				settingKey = "ferociousBiteMinimum",
				isSnowflake = true,
				thresholdUsable = false,
				relentlessPredator = true
			},
			ferociousBiteMaximum = {
				id = 22568,
				name = "",
				icon = "",
				energy = -50,
				comboPoints = true,
				texture = "",
				thresholdId = 8,
				settingKey = "ferociousBiteMaximum",
				isSnowflake = true,
				thresholdUsable = false,
				relentlessPredator = true
			},
			prowl = {
				id = 5215,
				name = "",
				icon = "",
				idIncarnation = 102547,
				modifier = 1.6
			},
			shred = {
				id = 5221,
				name = "",
				icon = "",
				energy = -40,
				comboPointsGenerated = 1,
				texture = "",
				thresholdId = 9,
				settingKey = "shred",
				thresholdUsable = false,
				isClearcasting = true
			},
			swipe = {
				id = 106785,
				name = "",
				icon = "",
				energy = -35,
				comboPointsGenerated = 1,
				thresholdId = 3,
				texture = "",
				settingKey = "swipe",
				thresholdUsable = false,
				isSnowflake = true,
				isTalent = false,
				baseline = true
			},

			-- Feral Spec Talents
			tigersFury = {
				id = 5217,
				name = "",
				icon = "",
				modifier = 1.15,
				cooldown = 30,
				isTalent = true
			},
			omenOfClarity = {
				id = 16864,
				name = "",
				icon = "",
				isTalent = true
			},
			momentOfClarity = {
				id = 236068,
				name = "",
				icon = "",
				modifier = 1.15,
				isTalent = true
			},
			clearcasting = {
				id = 135700,
				name = "",
				icon = ""
			},
			primalWrath = {
				id = 285381,
				name = "",
				icon = "",
				energy = -20,
				comboPoints = true,
				thresholdId = 10,
				texture = "",
				settingKey = "primalWrath",
				isTalent = true,
				thresholdUsable = false
			},
			lunarInspiration = {
				id = 155580,
				name = "",
				icon = "",
				isTalent = true
			},
			moonfire = {
				id = 155625,
				name = "",
				icon = "",
				energy = -30,
				comboPointsGenerated = 1,
				thresholdId = 11,
				texture = "",
				settingKey = "moonfire",
				isSnowflake = true,
				thresholdUsable = false,
				hasSnapshot = true,
				pandemic = true,
				pandemicTime = 16 * 0.3,
				bonuses = {
					tigersFury = true
				}
			},
			suddenAmbush = {
				id = 384667,
				name = "",
				icon = "",
				isTalent = true
			},
			berserk = {
				id = 106951,
				name = "",
				icon = "",
				isTalent = true,
				energizeId = 343216,
				tickRate = 1.5
			},
			predatorySwiftness = {
				id = 69369,
				name = "",
				icon = "",
				isTalent = true
			},
			brutalSlash = {
				id = 202028,
				name = "",
				icon = "",
				cooldown = 8,
				isHasted = true,
				energy = -25,
				comboPointsGenerated = 1,
				thresholdId = 12,
				texture = "",
				settingKey = "brutalSlash",
				isSnowflake = true,
				isTalent = true,
				hasCooldown = true,
				thresholdUsable = false,
				isClearcasting = true
			},
			carnivorousInstinct = {
				id = 390902,
				name = "",
				icon = "",
				modifierPerStack = 0.06,
				isTalent = true
			},
			bloodtalons = {
				id = 145152,
				name = "",
				icon = "",
				window = 4,
				energy = -80, --Make this dynamic
				thresholdId = 13,
				texture = "",
				settingKey = "bloodtalons",
				isTalent = true,
				--isSnowflake = true,
				thresholdUsable = false,
				modifier = 1.25
			},
			feralFrenzy = {
				id = 274837,
				name = "",
				icon = "",
				energy = -25,
				comboPointsGenerated = 5,
				thresholdId = 14,
				texture = "",
				settingKey = "feralFrenzy",
				isTalent = true,
				hasCooldown = true,
				thresholdUsable = false
			},
			incarnationAvatarOfAshamane = {
				id = 102543,
				name = "",
				icon = "",
				energyModifier = 0.8
			}, 
			relentlessPredator = {
				id = 393771,
				name = "",
				icon = "",
				isTalent = true,
				energyModifier = 0.8
			},
			circleOfLifeAndDeath = {
				id = 391969,
				name = "",
				icon = "",
				isTalent = true,
				modifier = 0.75
			},
			apexPredatorsCraving = {
				id = 391882,
				name = "",
				icon = ""
			},
			
			-- T30 4P
			predatorRevealed = {
				id = 408468,
				name = "",
				icon = "",
				energizeId = 411344,
				tickRate = 2.0,
				spellKey = "predatorRevealed"
			}
		}

		specCache.feral.snapshot.energyRegen = 0
		specCache.feral.snapshot.comboPoints = 0
		specCache.feral.snapshot.audio = {
			overcapCue = false
		}
		specCache.feral.snapshot.targetData = {
			ttdIsActive = false,
			currentTargetGuid = nil,
			--Bleeds
			rake = 0,
			rip = 0,
			thrash = 0,
			--Other
			moonfire = 0,
			targets = {}
		}
		specCache.feral.snapshot.maim = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.feral.snapshot.brutalSlash = {
			startTime = nil,
			duration = 0,
			charges = 0,
			maxCharges = 3
		}
		specCache.feral.snapshot.feralFrenzy = {
			startTime = nil,
			duration = 0,
			enabled = false
		}
		specCache.feral.snapshot.clearcasting = {
			isActive = false,
			spellId = nil,
			duration = 0,
			endTime = nil,
			remainingTime = 0,
			stacks = 0,
			endTimeLeeway = nil
		}
		specCache.feral.snapshot.tigersFury = {
			spellId = nil,
			endTime = nil,
			duration = 0,
			cooldown = {
				startTime = nil,
				duration = 0
			}
		}
		specCache.feral.snapshot.shadowmeld = {
			isActive = false
		}
		specCache.feral.snapshot.prowl = {
			isActive = false
		}
		specCache.feral.snapshot.suddenAmbush = {
			spellId = nil,
			duration = 0,
			endTime = nil,
			endTimeLeeway = nil
		}
		specCache.feral.snapshot.berserk = {
			spellId = nil,
			endTime = nil,
			duration = 0,
			lastTick = nil,
			nextTick = nil,
			untilNextTick = 0,
			ticks = 0,
		}
		specCache.feral.snapshot.incarnationAvatarOfAshamane = {
			spellId = nil,
			endTime = nil,
			duration = 0
		}
		specCache.feral.snapshot.bloodtalons = {
			spellId = nil,
			endTime = nil,
			duration = 0,
			stacks = 0,
			endTimeLeeway = nil
		}
		specCache.feral.snapshot.apexPredatorsCraving = {
			spellId = nil,
			endTime = nil,
			duration = 0
		}
		specCache.feral.snapshot.predatorRevealed = {
			spellId = nil,
			endTime = nil,
			duration = 0,
			lastTick = nil,
			nextTick = nil,
			untilNextTick = 0,
			ticks = 0,
		}
		specCache.feral.snapshot.snapshots = {
			rake = 100,
			rip = 100,
			thrash = 100,
			moonfire = 100
		}

		-- Restoration
		specCache.restoration.Global_TwintopResourceBar = {
			ttd = 0,
			resource = {
				resource = 0,
				casting = 0,
				passive = 0,
			},
			dots = {
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
			-- Druid Class Baseline Abilities
			moonfire = {
				id = 164812,
				name = "",
				icon = "",
				astralPower = 2,
				pandemic = true,
				pandemicTime = 16 * 0.3
			},

			-- Druid Class Talents
			sunfire = {
				id = 164815,
				name = "",
				icon = "",
				isTalent = true,
				pandemic = true,
				pandemicTime = 12 * 0.3
			},

			-- Restoration Spec Baseline Abilities
			-- Restoration Spec Talents
			efflorescence = {
				id = 145205,
				name = "",
				icon = "",
				duration = 30,
				isTalent = true
			},
			incarnationTreeOfLife = {
				id = 117679,
				name = "",
				icon = ""
			},
			cenariusGuidance = {
				id = 393371,
				name = "",
				icon = "",
				isTalent = true
			},
			reforestation = {
				id = 392360,
				name = "",
				icon = "",
				--isTalent = true
			},
			clearcasting = {
				id = 16870,
				name = "",
				icon = ""
			},

			-- External mana
			innervate = { -- Technically a talent but we can get it from outside/don't do any talent checks with it
				id = 29166,
				name = "",
				icon = "",
				duration = 10
			},
			symbolOfHope = {
				id = 64901,
				name = "",
				icon = "",
				duration = 4.0, --Hasted
				manaPercent = 0.03,
				ticks = 3,
				tickId = 265144
			},
			manaTideTotem = {
				id = 320763,
				name = "",
				icon = "",
				duration = 8
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
			sunfire = 0,
			moonfire = 0,
			targets = {}
		}
		specCache.restoration.snapshot.efflorescence = {
			endTime = nil
		}
		specCache.restoration.snapshot.clearcasting = {
			isActive = false,
			spellId = nil,
			duration = 0,
			endTime = nil,
			remainingTime = 0,
			stacks = 0
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
		specCache.restoration.snapshot.moltenRadiance = {
			spellId = nil,
			startTime = nil,
			duration = 0,
			manaPerTick = 0,
			mana = 0
		}
		specCache.restoration.snapshot.incarnationTreeOfLife = {
			spellId = nil,
			endTime = nil
		}
		specCache.restoration.snapshot.reforestation = {
			stacks = 0
		}

		specCache.restoration.barTextVariables = {
			icons = {},
			values = {}
		}
	end

	local function Setup_Balance()
		if TRB.Data.character and TRB.Data.character.specId == GetSpecialization() then
			return
		end

		TRB.Functions.Character:FillSpecializationCacheSettings(TRB.Data.settings, specCache, "druid", "balance")
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.balance)
	end

	local function FillSpellData_Balance()
		Setup_Balance()
		local spells = TRB.Functions.Spell:FillSpellData(specCache.balance.spells)

		-- This is done here so that we can get icons for the options menu!
		specCache.balance.barTextVariables.icons = {
			{ variable = "#casting", icon = "", description = "The icon of the Astral Power generating spell you are currently hardcasting", printInSettings = true },
			{ variable = "#item_ITEMID_", icon = "", description = "Any item's icon available via its item ID (e.g.: #item_18609_).", printInSettings = true },
			{ variable = "#spell_SPELLID_", icon = "", description = "Any spell's icon available via its spell ID (e.g.: #spell_2691_).", printInSettings = true },

			{ variable = "#moonkinForm", icon = spells.moonkinForm.icon, description = "Moonkin Form", printInSettings = true },

			{ variable = "#wrath", icon = spells.wrath.icon, description = "Wrath", printInSettings = true },
			{ variable = "#starfire", icon = spells.starfire.icon, description = "Starfire", printInSettings = true },
			
			{ variable = "#sunfire", icon = spells.sunfire.icon, description = "Sunfire", printInSettings = true },
			{ variable = "#moonfire", icon = spells.moonfire.icon, description = "Moonfire", printInSettings = true },
			
			{ variable = "#starsurge", icon = spells.starsurge.icon, description = "Starsurge", printInSettings = true },
			{ variable = "#starfall", icon = spells.fullMoon.icon, description = "Starfall", printInSettings = true },
			{ variable = "#starweaver", icon = spells.starweaversWarp.icon .. " or " .. spells.starweaversWeft.icon, description = "Starweaver's Warp or Weft, whichever is active", printInSettings = true },
			{ variable = "#starweaversWarp", icon = spells.starweaversWarp.icon, description = spells.starweaversWarp.name, printInSettings = true },
			{ variable = "#starweaversWeft", icon = spells.starweaversWeft.icon, description = spells.starweaversWeft.name, printInSettings = true },

			{ variable = "#pulsar", icon = spells.primordialArcanicPulsar.icon, description = "Primordial Arcanic Pulsar", printInSettings = true },
			{ variable = "#pap", icon = spells.primordialArcanicPulsar.icon, description = "Primordial Arcanic Pulsar", printInSettings = false },
			{ variable = "#primordialArcanicPulsar", icon = spells.primordialArcanicPulsar.icon, description = "Primordial Arcanic Pulsar", printInSettings = false },

			{ variable = "#eclipse", icon = spells.incarnationChosenOfElune.icon .. spells.celestialAlignment.icon .. spells.eclipseSolar.icon .. " or " .. spells.eclipseLunar.icon, description = "Current active Eclipse", printInSettings = true },
			{ variable = "#celestialAlignment", icon = spells.celestialAlignment.icon, description = "Celestial Alignment", printInSettings = true },			
			{ variable = "#icoe", icon = spells.incarnationChosenOfElune.icon, description = "Incarnation: Chosen of Elune", printInSettings = true },			
			{ variable = "#coe", icon = spells.incarnationChosenOfElune.icon, description = "Incarnation: Chosen of Elune", printInSettings = false },			
			{ variable = "#incarnation", icon = spells.incarnationChosenOfElune.icon, description = "Incarnation: Chosen of Elune", printInSettings = false },			
			{ variable = "#incarnationChosenOfElune", icon = spells.incarnationChosenOfElune.icon, description = "Incarnation: Chosen of Elune", printInSettings = false },			
			{ variable = "#solar", icon = spells.eclipseSolar.icon, description = "Eclipse (Solar)", printInSettings = true },
			{ variable = "#eclipseSolar", icon = spells.eclipseSolar.icon, description = "Eclipse (Solar)", printInSettings = false },
			{ variable = "#solarEclipse", icon = spells.eclipseSolar.icon, description = "Eclipse (Solar)", printInSettings = false },
			{ variable = "#lunar", icon = spells.eclipseLunar.icon, description = "Eclipse (Lunar)", printInSettings = true },
			{ variable = "#eclipseLunar", icon = spells.eclipseLunar.icon, description = "Eclipse (Lunar)", printInSettings = false },
			{ variable = "#lunarEclipse", icon = spells.eclipseLunar.icon, description = "Eclipse (Lunar)", printInSettings = false },
			
			{ variable = "#naturesBalance", icon = spells.naturesBalance.icon, description = "Nature's Balance", printInSettings = true },
			
			{ variable = "#soulOfTheForest", icon = spells.soulOfTheForest.icon, description = "Soul of the Forest", printInSettings = true },
			
			{ variable = "#stellarFlare", icon = spells.stellarFlare.icon, description = "Stellar Flare", printInSettings = true },

			{ variable = "#foe", icon = spells.furyOfElune.icon, description = "Fury Of Elune", printInSettings = false },
			{ variable = "#furyOfElune", icon = spells.furyOfElune.icon, description = "Fury Of Elune", printInSettings = true },
			
			{ variable = "#sunderedFirmament", icon = spells.sunderedFirmament.icon, description = spells.sunderedFirmament.name, printInSettings = true },
			
			{ variable = "#newMoon", icon = spells.newMoon.icon, description = "New Moon", printInSettings = true },
			{ variable = "#halfMoon", icon = spells.halfMoon.icon, description = "Half Moon", printInSettings = true },
			{ variable = "#fullMoon", icon = spells.fullMoon.icon, description = "Full Moon", printInSettings = true },
			{ variable = "#moon", icon = spells.newMoon.icon .. spells.halfMoon.icon .. spells.fullMoon.icon, description = "Current Moon", printInSettings = true },
		}
		specCache.balance.barTextVariables.values = {
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

			{ variable = "$moonkinForm", description = "Currently in Moonkin Form. Logic variable only!", printInSettings = true, color = false },
			{ variable = "$eclipse", description = "Currently in any kind of Eclipse. Logic variable only!", printInSettings = true, color = false },
			{ variable = "$eclipseTime", description = "Remaining duration of Eclipse.", printInSettings = true, color = false },
			{ variable = "$lunar", description = "Currently in Eclipse (Lunar). Logic variable only!", printInSettings = true, color = false },
			{ variable = "$lunarEclipse", description = "Currently in Eclipse (Lunar). Logic variable only!", printInSettings = false, color = false },
			{ variable = "$eclipseLunar", description = "Currently in Eclipse (Lunar). Logic variable only!", printInSettings = false, color = false },
			{ variable = "$solar", description = "Currently in Eclipse (Solar). Logic variable only!", printInSettings = true, color = false },
			{ variable = "$solarEclipse", description = "Currently in Eclipse (Solar). Logic variable only!", printInSettings = false, color = false },
			{ variable = "$eclipseSolar", description = "Currently in Eclipse (Solar). Logic variable only!", printInSettings = false, color = false },
			{ variable = "$celestialAlignment", description = "Currently in/using CA/I: CoE. Logic variable only!", printInSettings = true, color = false },

			{ variable = "$pulsarCollected", description = "Current amount of Astral Power that Primordial Arcanic Pulsar has collected", printInSettings = true, color = false },
			{ variable = "$pulsarCollectedPercent", description = "Current percentage of Astral Power that Primordial Arcanic Pulsar has collected before triggering", printInSettings = true, color = false },
			{ variable = "$pulsarRemaining", description = "Amount of Astral Power remaining until Primordial Arcanic Pulsar grants Celestial Alignment", printInSettings = true, color = false },
			{ variable = "$pulsarRemainingPercent", description = "Percentage of Astral Power remaining until Primordial Arcanic Pulsar grants Celestial Alignment", printInSettings = true, color = false },
			{ variable = "$pulsarNextStarsurge", description = "Will the next Starsurge grant Celestial Alignment from Pulsar? Logic variable only!", printInSettings = true, color = false },
			{ variable = "$pulsarNextStarfall", description = "Will the next Starfall grant Celestial Alignment from Pulsar? Logic variable only!", printInSettings = true, color = false },
			{ variable = "$pulsarStarsurgeCount", description = "How many more Starsurges are required to grant Celestial Alignment from Pulsar", printInSettings = true, color = false },
			{ variable = "$pulsarStarfallCount", description = "How many more Starfalls are required to grant Celestial Alignment from Pulsar", printInSettings = true, color = false },

			{ variable = "$astralPower", description = "Current Astral Power", printInSettings = true, color = false },
			{ variable = "$resource", description = "Current Astral Power", printInSettings = false, color = false },
			{ variable = "$astralPowerMax", description = "Maximum Astral Power", printInSettings = true, color = false },
			{ variable = "$resourceMax", description = "Maximum Astral Power", printInSettings = false, color = false },
			{ variable = "$casting", description = "Astral Power from Hardcasting Spells", printInSettings = true, color = false },
			{ variable = "$passive", description = "Astral Power from Passive Sources", printInSettings = true, color = false },
			{ variable = "$astralPowerPlusCasting", description = "Current + Casting Astral Power Total", printInSettings = true, color = false },
			{ variable = "$resourcePlusCasting", description = "Current + Casting Astral Power Total", printInSettings = false, color = false },
			{ variable = "$astralPowerPlusPassive", description = "Current + Passive Astral Power Total", printInSettings = true, color = false },
			{ variable = "$resourcePlusPassive", description = "Current + Passive Astral Power Total", printInSettings = false, color = false },
			{ variable = "$astralPowerTotal", description = "Current + Passive + Casting Astral Power Total", printInSettings = true, color = false },   
			{ variable = "$resourceTotal", description = "Current + Passive + Casting Astral Power Total", printInSettings = false, color = false },	 
			{ variable = "$foeAstralPower", description = "Passive Astral Power incoming from Fury of Elune", printInSettings = true, color = false },   
			{ variable = "$foeTicks", description = "Number of ticks of Fury of Elune remaining", printInSettings = true, color = false },   
			{ variable = "$foeTime", description = "Amount of time remaining on Fury of Elune's effect", printInSettings = true, color = false },		
			{ variable = "$sunderedFirmamentAstralPower", description = "Passive Astral Power incoming from Sundered Firmament", printInSettings = true, color = false },   
			{ variable = "$sunderedFirmamentTicks", description = "Number of ticks of Sundered Firmament remaining", printInSettings = true, color = false },   
			{ variable = "$sunderedFirmamentTime", description = "Amount of time remaining on Sundered Firmament's effect", printInSettings = true, color = false },   

			{ variable = "$sunfireCount", description = "Number of Sunfires active on targets", printInSettings = true, color = false },
			{ variable = "$sunfireTime", description = "Time remaining on Sunfire on your current target", printInSettings = true, color = false },
			{ variable = "$moonfireCount", description = "Number of Moonfires active on targets", printInSettings = true, color = false },
			{ variable = "$moonfireTime", description = "Time remaining on Moonfire on your current target", printInSettings = true, color = false },
			{ variable = "$stellarFlareCount", description = "Number of Stellar Flares active on targets", printInSettings = true, color = false },
			{ variable = "$stellarFlareTime", description = "Time remaining on Stellar Flare on your current target", printInSettings = true, color = false },

			{ variable = "$moonAstralPower", description = "Amount of Astral Power your next New/Half/Full Moon cast will generate", printInSettings = true, color = false },   
			{ variable = "$moonCharges", description = "Number of charges you currently have for New/Half/Full Moon", printInSettings = true, color = false },   
			{ variable = "$moonCooldown", description = "Time remaining until your next New/Half/Full Moon recharge", printInSettings = true, color = false },
			{ variable = "$moonCooldownTotal", description = "Time remaining until New/Half/Full Moon has full charges", printInSettings = true, color = false },

			{ variable = "$starweaverTime", description = "Time remaining on Starweaver's Warp/Weft buff", printInSettings = true, color = false },
			{ variable = "$starweaver", description = "Starweaver's Warp/Weft proc is active. Logic variable only!", printInSettings = true, color = false },
			{ variable = "$starweaversWarp", description = "Starweaver's Warp proc is active. Logic variable only!", printInSettings = true, color = false },
			{ variable = "$starweaversWeft", description = "Starweaver's Warp proc is active. Logic variable only!", printInSettings = true, color = false },

			{ variable = "$ttd", description = "Time To Die of current target in MM:SS format", printInSettings = true, color = true },
			{ variable = "$ttdSeconds", description = "Time To Die of current target in seconds", printInSettings = true, color = true }
		}

		specCache.balance.spells = spells
	end

	local function Setup_Feral()
		if TRB.Data.character and TRB.Data.character.specId == GetSpecialization() then
			return
		end

		TRB.Functions.Character:FillSpecializationCacheSettings(TRB.Data.settings, specCache, "druid", "feral")
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.feral)
	end

	local function FillSpellData_Feral()
		Setup_Feral()
		local spells = TRB.Functions.Spell:FillSpellData(specCache.feral.spells)
		

		-- This is done here so that we can get icons for the options menu!
		specCache.feral.barTextVariables.icons = {
			{ variable = "#casting", icon = "", description = "The icon of the Astral Power generating spell you are currently hardcasting", printInSettings = true },
			{ variable = "#item_ITEMID_", icon = "", description = "Any item's icon available via its item ID (e.g.: #item_18609_).", printInSettings = true },
			{ variable = "#spell_SPELLID_", icon = "", description = "Any spell's icon available via its spell ID (e.g.: #spell_2691_).", printInSettings = true },

			{ variable = "#apexPredatorsCraving", icon = spells.apexPredatorsCraving.icon, description = spells.apexPredatorsCraving.name, printInSettings = true },
			{ variable = "#berserk", icon = spells.berserk.icon, description = spells.berserk.name, printInSettings = true },
			{ variable = "#bloodtalons", icon = spells.bloodtalons.icon, description = spells.bloodtalons.name, printInSettings = true },
			{ variable = "#brutalSlash", icon = spells.brutalSlash.icon, description = spells.brutalSlash.name, printInSettings = true },
			{ variable = "#carnivorousInstinct", icon = spells.carnivorousInstinct.icon, description = spells.carnivorousInstinct.name, printInSettings = true },
			{ variable = "#catForm", icon = spells.catForm.icon, description = spells.catForm.name, printInSettings = true },
			{ variable = "#clearcasting", icon = spells.clearcasting.icon, description = spells.clearcasting.name, printInSettings = true },
			{ variable = "#feralFrenzy", icon = spells.feralFrenzy.icon, description = spells.feralFrenzy.name, printInSettings = true },
			{ variable = "#ferociousBite", icon = spells.ferociousBite.icon, description = spells.ferociousBite.name, printInSettings = true },
			{ variable = "#incarnation", icon = spells.incarnationAvatarOfAshamane.icon, description = spells.incarnationAvatarOfAshamane.name, printInSettings = true },
			{ variable = "#incarnationAvatarOfAshamane", icon = spells.incarnationAvatarOfAshamane.icon, description = spells.incarnationAvatarOfAshamane.name, printInSettings = false },
			{ variable = "#lunarInspiration", icon = spells.lunarInspiration.icon, description = spells.lunarInspiration.name, printInSettings = true },
			{ variable = "#maim", icon = spells.maim.icon, description = spells.maim.name, printInSettings = true },
			{ variable = "#moonfire", icon = spells.moonfire.icon, description = spells.moonfire.name, printInSettings = true },
			{ variable = "#predatorySwiftness", icon = spells.predatorySwiftness.icon, description = spells.predatorySwiftness.name, printInSettings = true },
			{ variable = "#predatorRevealed", icon = spells.predatorRevealed.icon, description = spells.predatorRevealed.name, printInSettings = true },
			{ variable = "#primalWrath", icon = spells.primalWrath.icon, description = spells.primalWrath.name, printInSettings = true },
			{ variable = "#prowl", icon = spells.prowl.icon, description = spells.prowl.name, printInSettings = true },
			{ variable = "#stealth", icon = spells.prowl.icon, description = spells.prowl.name, printInSettings = false },
			{ variable = "#rake", icon = spells.rake.icon, description = spells.rake.name, printInSettings = true },
			{ variable = "#rip", icon = spells.rip.icon, description = spells.rip.name, printInSettings = true },
			{ variable = "#shadowmeld", icon = spells.shadowmeld.icon, description = spells.shadowmeld.name, printInSettings = true },
			{ variable = "#shred", icon = spells.shred.icon, description = spells.shred.name, printInSettings = true },
			{ variable = "#suddenAmbush", icon = spells.suddenAmbush.icon, description = spells.suddenAmbush.name, printInSettings = true },
			{ variable = "#swipe", icon = spells.swipe.icon, description = spells.swipe.name, printInSettings = true },
			{ variable = "#thrash", icon = spells.thrash.icon, description = spells.thrash.name, printInSettings = true },
			{ variable = "#tigersFury", icon = spells.tigersFury.icon, description = spells.tigersFury.name, printInSettings = true },
		}
		specCache.feral.barTextVariables.values = {
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
			{ variable = "$casting", description = "Energy from Hardcasting Spells", printInSettings = true, color = false },
			{ variable = "$passive", description = "Energy from Passive Sources", printInSettings = true, color = false },
			{ variable = "$energyPlusCasting", description = "Current + Casting Energy Total", printInSettings = true, color = false },
			{ variable = "$resourcePlusCasting", description = "Current + Casting Energy Total", printInSettings = false, color = false },
			{ variable = "$energyPlusPassive", description = "Current + Passive Energy Total", printInSettings = true, color = false },
			{ variable = "$resourcePlusPassive", description = "Current + Passive Energy Total", printInSettings = false, color = false },
			{ variable = "$energyTotal", description = "Current + Passive + Casting Energy Total", printInSettings = true, color = false },   
			{ variable = "$resourceTotal", description = "Current + Passive + Casting Energy Total", printInSettings = false, color = false },	 
			
			{ variable = "$comboPoints", description = "Current Combo Points", printInSettings = true, color = false },
			{ variable = "$comboPointsMax", description = "Maximum Combo Points", printInSettings = true, color = false },

			{ variable = "$ripCount", description = "Number of Rips active on targets", printInSettings = true, color = false },
			{ variable = "$ripTime", description = "Time remaining on Rip on your current target", printInSettings = true, color = false },
			{ variable = "$ripSnapshot", description = "Snapshot percentage of Rip on your current target", printInSettings = true, color = false },
			{ variable = "$ripPercent", description = "Snapshot percentage vs. recasting of Rip on your current target", printInSettings = true, color = false },
			{ variable = "$ripCurrent", description = "Current snapshot percentage damage if Rip was used right now", printInSettings = true, color = false },

			{ variable = "$rakeCount", description = "Number of Rakes active on targets", printInSettings = true, color = false },
			{ variable = "$rakeTime", description = "Time remaining on Rake on your current target", printInSettings = true, color = false },
			{ variable = "$rakeSnapshot", description = "Snapshot percentage of Rake on your current target", printInSettings = true, color = false },
			{ variable = "$rakePercent", description = "Snapshot percentage vs. recasting of Rake on your current target", printInSettings = true, color = false },
			{ variable = "$rakeCurrent", description = "Current snapshot percentage damage if Rake was used right now", printInSettings = true, color = false },
			
			{ variable = "$thrashCount", description = "Number of Thrashs active on targets", printInSettings = true, color = false },
			{ variable = "$thrashTime", description = "Time remaining on Thrash on your current target", printInSettings = true, color = false },
			{ variable = "$thrashSnapshot", description = "Snapshot percentage of Thrash on your current target", printInSettings = true, color = false },
			{ variable = "$thrashPercent", description = "Snapshot percentage vs. recasting of Thrash on your current target", printInSettings = true, color = false },
			{ variable = "$thrashCurrent", description = "Current snapshot percentage damage if Thrash was used right now", printInSettings = true, color = false },
			
			{ variable = "$moonfireCount", description = "Number of Lunar Inspiration's Moonfires active on targets", printInSettings = true, color = false },
			{ variable = "$moonfireTime", description = "Time remaining on Lunar Inspiration's Moonfire on your current target", printInSettings = true, color = false },
			{ variable = "$moonfireSnapshot", description = "Snapshot percentage of Lunar Inspiration's Moonfire on your current target", printInSettings = true, color = false },
			{ variable = "$moonfirePercent", description = "Snapshot percentage vs. recasting of Lunar Inspiration's Moonfire on your current target", printInSettings = true, color = false },
			{ variable = "$moonfireCurrent", description = "Current snapshot percentage damage if Lunar Inspiration's Moonfire was used right now", printInSettings = true, color = false },
			
			{ variable = "$lunarInspiration", description = "Is Lunar Inspiration currently talented. Logic variable only!", printInSettings = true, color = false },

			{ variable = "$brutalSlashCharges", description = "Number of charges you currently have for Brutal Slash (if talented)", printInSettings = true, color = false },
			{ variable = "$brutalSlashCooldown", description = "Time remaining until your next Brutal Slash recharge (if talented)", printInSettings = true, color = false },
			{ variable = "$brutalSlashCooldownTotal", description = "Time remaining until Brutal Slash has full charges (if talented)", printInSettings = true, color = false },  
			
			{ variable = "$bloodtalonsStacks", description = "Number of stacks of Bloodtalons available to use (if talented)", printInSettings = true, color = false },
			{ variable = "$bloodtalonsTime", description = "Time remaining on your Bloodtalons proc (if talented)", printInSettings = true, color = false },
			
			{ variable = "$clearcastingStacks", description = "Number of stacks of Clearcasting available to use", printInSettings = true, color = false },
			{ variable = "$clearcastingTime", description = "Time remaining on your Clearcasting proc", printInSettings = true, color = false },
			
			{ variable = "$berserkTime", description = "Time remaining on your Berserk or Incarnation: King of the Jungle buff", printInSettings = true, color = false },
			{ variable = "$incarnationTime", description = "Time remaining on your Berserk or Incarnation: King of the Jungle buff", printInSettings = false, color = false },

			{ variable = "$suddenAmbushTime", description = "Time remaining on your Sudden Ambush proc", printInSettings = true, color = false },
			
			{ variable = "$apexPredatorsCravingTime", description = "Time remaining on your Apex Predator's Craving proc (if equipped)", printInSettings = true, color = false },
			
			{ variable = "$tigersFuryTime", description = "Time remaining on your Tiger's Fury buff", printInSettings = true, color = false },
			{ variable = "$tigersFuryCooldownTime", description = "Time remaining on your Tiger's Fury ability cooldown", printInSettings = true, color = false },

			{ variable = "$predatorRevealedTime", description = "Time remaining on your Predator Revealed proc", printInSettings = true, color = false },
			{ variable = "$predatorRevealedTicks", description = "Number of remaining ticks / incoming Combo Points from your Predator Revealed proc", printInSettings = true, color = false },
			{ variable = "$predatorRevealedTickTime", description = "Time until the next tick / Combo Point generation occurs from your Predator Revealed proc", printInSettings = true, color = false },

			{ variable = "$ttd", description = "Time To Die of current target in MM:SS format", printInSettings = true, color = true },
			{ variable = "$ttdSeconds", description = "Time To Die of current target in seconds", printInSettings = true, color = true }
		}

		specCache.feral.spells = spells
	end

	local function Setup_Restoration()
		if TRB.Data.character and TRB.Data.character.specId == GetSpecialization() then
			return
		end

		TRB.Functions.Character:FillSpecializationCacheSettings(TRB.Data.settings, specCache, "druid", "restoration")
		TRB.Functions.Character:LoadFromSpecializationCache(specCache.restoration)
	end

	local function FillSpellData_Restoration()
		Setup_Restoration()
		local spells = TRB.Functions.Spell:FillSpellData(specCache.restoration.spells)

		-- This is done here so that we can get icons for the options menu!
		specCache.restoration.barTextVariables.icons = {
			{ variable = "#casting", icon = "", description = "The icon of the mana spending spell you are currently casting", printInSettings = true },
			{ variable = "#item_ITEMID_", icon = "", description = "Any item's icon available via its item ID (e.g.: #item_18609_).", printInSettings = true },
			{ variable = "#spell_SPELLID_", icon = "", description = "Any spell's icon available via its spell ID (e.g.: #spell_2691_).", printInSettings = true },

			{ variable = "#efflorescence", icon = spells.efflorescence.icon, description = spells.efflorescence.name, printInSettings = true },
			{ variable = "#clearcasting", icon = spells.clearcasting.icon, description = spells.clearcasting.name, printInSettings = true },
			{ variable = "#incarnation", icon = spells.incarnationTreeOfLife.icon, description = spells.incarnationTreeOfLife.name, printInSettings = true },
			{ variable = "#reforestation", icon = spells.reforestation.icon, description = spells.reforestation.name, printInSettings = true },
			
			{ variable = "#moonfire", icon = spells.moonfire.icon, description = "Moonfire", printInSettings = true },
			{ variable = "#sunfire", icon = spells.sunfire.icon, description = "Sunfire", printInSettings = true },
			
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
			{ variable = "#potionOfFrozenFocus", icon = spells.potionOfFrozenFocusRank1.icon, description = spells.potionOfFrozenFocusRank1.name, printInSettings = true },
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

			{ variable = "$incarnationTime", description = "Time remaining on Incarnation: Tree of Life", printInSettings = false, color = false },

			{ variable = "$reforestationStacks", description = "Current stacks of Reforestation", printInSettings = false, color = false },

			{ variable = "$sunfireCount", description = "Number of Sunfires active on targets", printInSettings = true, color = false },
			{ variable = "$sunfireTime", description = "Time remaining on Sunfire on your current target", printInSettings = true, color = false },
			{ variable = "$moonfireCount", description = "Number of Moonfires active on targets", printInSettings = true, color = false },
			{ variable = "$moonfireTime", description = "Time remaining on Moonfire on your current target", printInSettings = true, color = false },

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

			{ variable = "$efflorescenceTime", description = "Time remaining on Efflorescence", printInSettings = true, color = false },

			{ variable = "$clearcastingTime", description = "Time remaining on your Clearcasting proc", printInSettings = true, color = false },

			{ variable = "$ttd", description = "Time To Die of current target in MM:SS format", printInSettings = true, color = true },
			{ variable = "$ttdSeconds", description = "Time To Die of current target in seconds", printInSettings = true, color = true }
		}

		specCache.restoration.spells = spells
	end

	local function GetCurrentMoonSpell()
		local currentTime = GetTime()
		if GetSpecialization() == 1 and TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.newMoon) and (TRB.Data.snapshot.newMoon.checkAfter == nil or currentTime >= TRB.Data.snapshot.newMoon.checkAfter) then
			---@diagnostic disable-next-line: redundant-parameter
			TRB.Data.snapshot.newMoon.currentSpellId = select(7, GetSpellInfo(TRB.Data.spells.newMoon.name))

			if TRB.Data.snapshot.newMoon.currentSpellId == TRB.Data.spells.newMoon.id then
				TRB.Data.snapshot.newMoon.currentKey = "newMoon"
			elseif TRB.Data.snapshot.newMoon.currentSpellId == TRB.Data.spells.halfMoon.id then
				TRB.Data.snapshot.newMoon.currentKey = "halfMoon"
			elseif TRB.Data.snapshot.newMoon.currentSpellId == TRB.Data.spells.fullMoon.id then
				TRB.Data.snapshot.newMoon.currentKey = "fullMoon"
			else
				TRB.Data.snapshot.newMoon.currentKey = "newMoon"
			end
			TRB.Data.snapshot.newMoon.checkAfter = nil
			TRB.Data.snapshot.newMoon.currentIcon = TRB.Data.spells[TRB.Data.snapshot.newMoon.currentKey].icon
		else
			TRB.Data.snapshot.newMoon.currentSpellId = TRB.Data.spells.newMoon.id
			TRB.Data.snapshot.newMoon.currentKey = "newMoon"
			TRB.Data.snapshot.newMoon.checkAfter = nil
		end
	end
	
	local function CalculateAbilityResourceValue(resource, threshold, relentlessPredator)
		local modifier = 1.0
		local specId = GetSpecialization()

		if specId == 2 then
			if TRB.Data.snapshot.incarnationAvatarOfAshamane.isActive then
				modifier = modifier * TRB.Data.spells.incarnationAvatarOfAshamane.energyModifier
			end
			
			if relentlessPredator and TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.relentlessPredator) then
				modifier = modifier * TRB.Data.spells.relentlessPredator.energyModifier
			end
		end

		return resource * modifier
	end

	local function RefreshTargetTracking()
		local currentTime = GetTime()
		local specId = GetSpecialization()

		if specId == 1 then
			local sunfireTotal = 0
			local moonfireTotal = 0
			local stellarFlareTotal = 0
			for guid,count in pairs(TRB.Data.snapshot.targetData.targets) do
				if (currentTime - TRB.Data.snapshot.targetData.targets[guid].lastUpdate) > 10 then
					TRB.Data.snapshot.targetData.targets[guid].sunfire = false
					TRB.Data.snapshot.targetData.targets[guid].sunfireRemaining = 0
					TRB.Data.snapshot.targetData.targets[guid].moonfire = false
					TRB.Data.snapshot.targetData.targets[guid].moonfireRemaining = 0
					TRB.Data.snapshot.targetData.targets[guid].stellarFlare = false
					TRB.Data.snapshot.targetData.targets[guid].stellarFlareRemaining = 0
				else
					if TRB.Data.snapshot.targetData.targets[guid].sunfire == true then
						sunfireTotal = sunfireTotal + 1
					end
					
					if TRB.Data.snapshot.targetData.targets[guid].moonfire == true then
						moonfireTotal = moonfireTotal + 1
					end
					
					if TRB.Data.snapshot.targetData.targets[guid].stellarFlare == true then
						stellarFlareTotal = stellarFlareTotal + 1
					end
				end
			end

			TRB.Data.snapshot.targetData.sunfire = sunfireTotal
			TRB.Data.snapshot.targetData.moonfire = moonfireTotal
			TRB.Data.snapshot.targetData.stellarFlare = stellarFlareTotal
		elseif specId == 2 then
			local rakeTotal = 0
			local ripTotal = 0
			local thrashTotal = 0
			local moonfireTotal = 0
			for guid,count in pairs(TRB.Data.snapshot.targetData.targets) do
				if (currentTime - TRB.Data.snapshot.targetData.targets[guid].lastUpdate) > 10 then
					TRB.Data.snapshot.targetData.targets[guid].rake = false
					TRB.Data.snapshot.targetData.targets[guid].rakeRemaining = 0
					TRB.Data.snapshot.targetData.targets[guid].rakeSnapshot = 0
					TRB.Data.snapshot.targetData.targets[guid].rip = false
					TRB.Data.snapshot.targetData.targets[guid].ripRemaining = 0
					TRB.Data.snapshot.targetData.targets[guid].ripSnapshot = 0
					TRB.Data.snapshot.targetData.targets[guid].thrash = false
					TRB.Data.snapshot.targetData.targets[guid].thrashRemaining = 0
					TRB.Data.snapshot.targetData.targets[guid].thrashSnapshot = 0
					TRB.Data.snapshot.targetData.targets[guid].moonfire = false
					TRB.Data.snapshot.targetData.targets[guid].moonfireRemaining = 0
					TRB.Data.snapshot.targetData.targets[guid].moonfireSnapshot = 0
				else
					if TRB.Data.snapshot.targetData.targets[guid].rake == true then
						rakeTotal = rakeTotal + 1
					end
					
					if TRB.Data.snapshot.targetData.targets[guid].rip == true then
						ripTotal = ripTotal + 1
					end
					
					if TRB.Data.snapshot.targetData.targets[guid].thrash == true then
						thrashTotal = thrashTotal + 1
					end
					
					if TRB.Data.snapshot.targetData.targets[guid].moonfire == true then
						moonfireTotal = moonfireTotal + 1
					end
				end
			end

			TRB.Data.snapshot.targetData.rake = rakeTotal
			TRB.Data.snapshot.targetData.rip = ripTotal
			TRB.Data.snapshot.targetData.thrash = thrashTotal
			TRB.Data.snapshot.targetData.moonfire = moonfireTotal			
		elseif specId == 4 then -- Restoration
			local sunfireTotal = 0
			local moonfireTotal = 0
			for guid,count in pairs(TRB.Data.snapshot.targetData.targets) do
				if (currentTime - TRB.Data.snapshot.targetData.targets[guid].lastUpdate) > 10 then
					TRB.Data.snapshot.targetData.targets[guid].sunfire = false
					TRB.Data.snapshot.targetData.targets[guid].sunfireRemaining = 0
					TRB.Data.snapshot.targetData.targets[guid].moonfire = false
					TRB.Data.snapshot.targetData.targets[guid].moonfireRemaining = 0
				else
					if TRB.Data.snapshot.targetData.targets[guid].sunfire == true then
						sunfireTotal = sunfireTotal + 1
					end
					
					if TRB.Data.snapshot.targetData.targets[guid].moonfire == true then
						moonfireTotal = moonfireTotal + 1
					end
				end
			end

			TRB.Data.snapshot.targetData.sunfire = sunfireTotal
			TRB.Data.snapshot.targetData.moonfire = moonfireTotal
		end
	end

	local function TargetsCleanup(clearAll)
		TRB.Functions.Target:TargetsCleanup(clearAll)
		local specId = GetSpecialization()

		if specId == 1 then
			if clearAll == true then
				TRB.Data.snapshot.targetData.sunfire = 0
				TRB.Data.snapshot.targetData.moonfire = 0
				TRB.Data.snapshot.targetData.stellarFlare = 0
			end
		elseif specId == 2 then
			if clearAll == true then
				TRB.Data.snapshot.targetData.rake = 0
				TRB.Data.snapshot.targetData.rip = 0
				TRB.Data.snapshot.targetData.thrash = 0
				TRB.Data.snapshot.targetData.moonfire = 0
			end
		elseif specId == 4 then
			if clearAll == true then
				TRB.Data.snapshot.targetData.sunfire = 0
				TRB.Data.snapshot.targetData.moonfire = 0
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

		if specId == 1 then
			for x = 1, 4 do -- SS30, SS60, SS90, SF50
				if TRB.Frames.resourceFrame.thresholds[x] == nil then
					TRB.Frames.resourceFrame.thresholds[x] = CreateFrame("Frame", nil, TRB.Frames.resourceFrame)
				end

				TRB.Frames.resourceFrame.thresholds[x]:Show()
				TRB.Frames.resourceFrame.thresholds[x]:SetFrameLevel(TRB.Data.constants.frameLevels.thresholdBase)
				TRB.Frames.resourceFrame.thresholds[x]:Hide()
			end
			
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[1], TRB.Data.spells.starsurge.settingKey, settings)
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[2], TRB.Data.spells.starsurge2.settingKey, settings)
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[3], TRB.Data.spells.starsurge3.settingKey, settings)
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[4], TRB.Data.spells.starfall.settingKey, settings)
			TRB.Frames.resource2ContainerFrame:Hide()
		elseif specId == 2 then
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
		elseif specId == 4 then
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
			
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[1], TRB.Data.spells.aeratedManaPotionRank1.settingKey, TRB.Data.settings.druid.restoration)
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[2], TRB.Data.spells.aeratedManaPotionRank2.settingKey, TRB.Data.settings.druid.restoration)
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[3], TRB.Data.spells.aeratedManaPotionRank3.settingKey, TRB.Data.settings.druid.restoration)
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[4], TRB.Data.spells.potionOfFrozenFocusRank1.settingKey, TRB.Data.settings.druid.restoration)
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[5], TRB.Data.spells.potionOfFrozenFocusRank2.settingKey, TRB.Data.settings.druid.restoration)
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[6], TRB.Data.spells.potionOfFrozenFocusRank3.settingKey, TRB.Data.settings.druid.restoration)
			TRB.Functions.Threshold:SetThresholdIcon(resourceFrame.thresholds[7], TRB.Data.spells.conjuredChillglobe.settingKey, TRB.Data.settings.druid.restoration)
			TRB.Frames.resource2ContainerFrame:Hide()
		end

		TRB.Functions.Bar:Construct(settings)

		if specId == 1 or specId == 2 or specId == 4 then
			TRB.Functions.Bar:SetPosition(settings, TRB.Frames.barContainerFrame)
		end
	end
	
	local function GetTigersFuryCooldownRemainingTime()
		return TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshot.tigersFury.cooldown)
	end

	local function GetTigersFuryRemainingTime()
		return TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshot.tigersFury)
	end
	
	local function GetClearcastingRemainingTime(leeway)
		return TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshot.clearcasting, leeway)
	end
	
	local function GetBloodtalonsRemainingTime(leeway)
		return TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshot.bloodtalons, leeway)
	end
	
	local function GetBerserkRemainingTime()
		if TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.incarnationAvatarOfAshamane) then
			return TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshot.incarnationAvatarOfAshamane)
		else
			return TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshot.berserk)
		end
	end
		
	local function GetSuddenAmbushRemainingTime(leeway)
		return TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshot.suddenAmbush, leeway)
	end
	
	local function GetApexPredatorsCravingRemainingTime()
		return TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshot.apexPredatorsCraving)
	end
	
	local function GetPredatorRevealedRemainingTime()
		return TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshot.predatorRevealed)
	end

	local function GetEclipseRemainingTime()
		local remainingTime = 0
		local icon = nil

		if TRB.Data.snapshot.celestialAlignment.isActive then
			remainingTime = TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshot.celestialAlignment)
			icon = TRB.Data.spells.celestialAlignment.icon
		elseif TRB.Data.snapshot.incarnationChosenOfElune.isActive then
			remainingTime = TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshot.incarnationChosenOfElune)
			icon = TRB.Data.spells.incarnationChosenOfElune.icon
		elseif TRB.Data.snapshot.eclipseSolar.isActive then
			remainingTime = TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshot.eclipseSolar)
			icon = TRB.Data.spells.eclipseSolar.icon
		elseif TRB.Data.snapshot.eclipseLunar.isActive then
			remainingTime = TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshot.eclipseLunar)
			icon = TRB.Data.spells.eclipseLunar.icon
		end

		if remainingTime < 0 then
			remainingTime = 0
		end

		return remainingTime, icon
	end

	local function GetStarfallCooldownRemainingTime()
		if TRB.Data.snapshot.starfall.cdStartTime == nil then
			return 0
		end

		local currentTime = GetTime()
		local cdRemaining = math.max(0, TRB.Data.snapshot.starfall.cdDuration - (currentTime - TRB.Data.snapshot.starfall.cdStartTime))
		return cdRemaining
	end
	
	local function GetSunderedFirmamentRemainingTime()
		return TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshot.sunderedFirmament)
	end

	local function GetChanneledPotionRemainingTime()
		return TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshot.channeledManaPotion)
	end

	local function GetInnervateRemainingTime()
		return TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshot.innervate)
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
	
	local function GetFuryOfEluneRemainingTime()
		return TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshot.furyOfElune)
	end

	local function GetIncarnationTreeOfLifeRemainingTime()
		return TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshot.incarnationTreeOfLife)
	end

	local function GetEfflorescenceRemainingTime()
		return TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshot.efflorescence)
	end

	local function GetPotionOfChilledClarityRemainingTime()
		return TRB.Functions.Spell:GetRemainingTime(TRB.Data.snapshot.potionOfChilledClarity)
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

	local function GetCurrentSnapshot(bonuses)
		local snapshot = 1.0

		if bonuses.tigersFury == true and GetTigersFuryRemainingTime() > 0 then
			local tfBonus = TRB.Data.spells.carnivorousInstinct.modifierPerStack * TRB.Data.talents[TRB.Data.spells.carnivorousInstinct.id].currentRank

			snapshot = snapshot * (TRB.Data.spells.tigersFury.modifier + tfBonus)
		end

		if bonuses.momentOfClarity == true and TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.momentOfClarity) == true and ((TRB.Data.snapshot.clearcasting.stacks ~= nil and TRB.Data.snapshot.clearcasting.stacks > 0) or GetClearcastingRemainingTime(true) > 0) then
			snapshot = snapshot * TRB.Data.spells.momentOfClarity.modifier
		end

		if bonuses.bloodtalons == true and TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.bloodtalons) == true and ((TRB.Data.snapshot.bloodtalons.stacks ~= nil and TRB.Data.snapshot.bloodtalons.stacks > 0) or GetBloodtalonsRemainingTime(true) > 0) then
			snapshot = snapshot * TRB.Data.spells.bloodtalons.modifier
		end
		if bonuses.stealth == true and (
			TRB.Data.snapshot.shadowmeld.isActive or
			TRB.Data.snapshot.prowl.isActive or
			GetBerserkRemainingTime() > 0 or
			GetSuddenAmbushRemainingTime(true) > 0 or
			TRB.Data.snapshot.incarnationAvatarOfAshamane.isActive) then
			snapshot = snapshot * TRB.Data.spells.prowl.modifier
		end

		return snapshot
	end

	local function RefreshLookupData_Balance()
		local currentTime = GetTime()
		local normalizedAstralPower = TRB.Data.snapshot.resource / TRB.Data.resourceFactor

		--local moonkinFormActive = TRB.Data.snapshot.moonkinForm.isActive

		--$overcap
		local overcap = TRB.Functions.Class:IsValidVariableForSpec("$overcap")

		local currentAstralPowerColor = TRB.Data.settings.druid.balance.colors.text.current
		local castingAstralPowerColor = TRB.Data.settings.druid.balance.colors.text.casting

		local astralPowerThreshold = math.min(TRB.Data.character.starsurgeThreshold, TRB.Data.character.starfallThreshold)

		if TRB.Functions.Class:IsValidVariableForSpec("$inCombat") then
			if TRB.Data.settings.druid.balance.colors.text.overcapEnabled and overcap then 
				currentAstralPowerColor = TRB.Data.settings.druid.balance.colors.text.overcap
				castingAstralPowerColor = TRB.Data.settings.druid.balance.colors.text.overcap
			elseif TRB.Data.settings.druid.balance.colors.text.overThresholdEnabled and normalizedAstralPower >= astralPowerThreshold then
				currentAstralPowerColor = TRB.Data.settings.druid.balance.colors.text.overThreshold
				castingAstralPowerColor = TRB.Data.settings.druid.balance.colors.text.overThreshold
			end
		end

		--$astralPower
		local astralPowerPrecision = TRB.Data.settings.druid.balance.astralPowerPrecision or 0
		local currentAstralPower = string.format("|c%s%s|r", currentAstralPowerColor, TRB.Functions.Number:RoundTo(normalizedAstralPower, astralPowerPrecision, "floor"))
		--$casting
		local castingAstralPower = string.format("|c%s%s|r", castingAstralPowerColor, TRB.Functions.Number:RoundTo(TRB.Data.snapshot.casting.resourceFinal, astralPowerPrecision, "floor"))
		--$passive
		local _passiveAstralPower = TRB.Data.snapshot.furyOfElune.astralPower + TRB.Data.snapshot.sunderedFirmament.astralPower
		if TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.naturesBalance) then
			if UnitAffectingCombat("player") then
				_passiveAstralPower = _passiveAstralPower + TRB.Data.spells.naturesBalance.astralPower
			elseif normalizedAstralPower < 50 then
				_passiveAstralPower = _passiveAstralPower + TRB.Data.spells.naturesBalance.outOfCombatAstralPower
			end
		end

		local passiveAstralPower = string.format("|c%s%s|r", TRB.Data.settings.druid.balance.colors.text.passive, TRB.Functions.Number:RoundTo(_passiveAstralPower, astralPowerPrecision, "ceil"))
		--$astralPowerTotal
		local _astralPowerTotal = math.min(_passiveAstralPower + TRB.Data.snapshot.casting.resourceFinal + normalizedAstralPower, TRB.Data.character.maxResource)
		local astralPowerTotal = string.format("|c%s%s|r", currentAstralPowerColor, TRB.Functions.Number:RoundTo(_astralPowerTotal, astralPowerPrecision, "floor"))
		--$astralPowerPlusCasting
		local _astralPowerPlusCasting = math.min(TRB.Data.snapshot.casting.resourceFinal + normalizedAstralPower, TRB.Data.character.maxResource)
		local astralPowerPlusCasting = string.format("|c%s%s|r", castingAstralPowerColor, TRB.Functions.Number:RoundTo(_astralPowerPlusCasting, astralPowerPrecision, "floor"))
		--$astralPowerPlusPassive
		local _astralPowerPlusPassive = math.min(_passiveAstralPower + normalizedAstralPower, TRB.Data.character.maxResource)
		local astralPowerPlusPassive = string.format("|c%s%s|r", currentAstralPowerColor, TRB.Functions.Number:RoundTo(_astralPowerPlusPassive, astralPowerPrecision, "floor"))

		----------
		--$sunfireCount and $sunfireTime
		local _sunfireCount = TRB.Data.snapshot.targetData.sunfire or 0
		local sunfireCount = tostring(_sunfireCount)
		local _sunfireTime = 0
		
		if TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid] ~= nil then
			_sunfireTime = TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].sunfireRemaining or 0
		end

		local sunfireTime

		--$moonfireCount and $moonfireTime
		local _moonfireCount = TRB.Data.snapshot.targetData.moonfire or 0
		local moonfireCount = tostring(_moonfireCount)
		local _moonfireTime = 0
		
		if TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid] ~= nil then
			_moonfireTime = TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].moonfireRemaining or 0
		end

		local moonfireTime

		--$stellarFlareCount and $stellarFlareTime
		local _stellarFlareCount = TRB.Data.snapshot.targetData.stellarFlare or 0
		local stellarFlareCount = tostring(_stellarFlareCount)
		local _stellarFlareTime = 0
		
		if TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid] ~= nil then
			_stellarFlareTime = TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].stellarFlareRemaining or 0
		end

		local stellarFlareTime

		if TRB.Data.settings.druid.balance.colors.text.dots.enabled and TRB.Data.snapshot.targetData.currentTargetGuid ~= nil and not UnitIsDeadOrGhost("target") and UnitCanAttack("player", "target") then
			if TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid] ~= nil and TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].sunfire then
				if TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].sunfireRemaining > (TRB.Data.character.pandemicModifier * TRB.Data.spells.sunfire.pandemicTime) then
					sunfireCount = string.format("|c%s%.0f|r", TRB.Data.settings.druid.balance.colors.text.dots.up, _sunfireCount)
					sunfireTime = string.format("|c%s%.1f|r", TRB.Data.settings.druid.balance.colors.text.dots.up, TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].sunfireRemaining)
				else
					sunfireCount = string.format("|c%s%.0f|r", TRB.Data.settings.druid.balance.colors.text.dots.pandemic, _sunfireCount)
					sunfireTime = string.format("|c%s%.1f|r", TRB.Data.settings.druid.balance.colors.text.dots.pandemic, TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].sunfireRemaining)
				end
			else
				sunfireCount = string.format("|c%s%.0f|r", TRB.Data.settings.druid.balance.colors.text.dots.down, _sunfireCount)
				sunfireTime = string.format("|c%s%.1f|r", TRB.Data.settings.druid.balance.colors.text.dots.down, 0)
			end

			if TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid] ~= nil and TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].moonfire then
				if TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].moonfireRemaining > (TRB.Data.character.pandemicModifier * TRB.Data.spells.moonfire.pandemicTime) then
					moonfireCount = string.format("|c%s%.0f|r", TRB.Data.settings.druid.balance.colors.text.dots.up, _moonfireCount)
					moonfireTime = string.format("|c%s%.1f|r", TRB.Data.settings.druid.balance.colors.text.dots.up, TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].moonfireRemaining)
				else
					moonfireCount = string.format("|c%s%.0f|r", TRB.Data.settings.druid.balance.colors.text.dots.pandemic, _moonfireCount)
					moonfireTime = string.format("|c%s%.1f|r", TRB.Data.settings.druid.balance.colors.text.dots.pandemic, TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].moonfireRemaining)
				end
			else
				moonfireCount = string.format("|c%s%.0f|r", TRB.Data.settings.druid.balance.colors.text.dots.down, _moonfireCount)
				moonfireTime = string.format("|c%s%.1f|r", TRB.Data.settings.druid.balance.colors.text.dots.down, 0)
			end

			if TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid] ~= nil and TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].stellarFlare then
				if TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].stellarFlareRemaining > (TRB.Data.character.pandemicModifier * TRB.Data.spells.stellarFlare.pandemicTime) then
					stellarFlareCount = string.format("|c%s%.0f|r", TRB.Data.settings.druid.balance.colors.text.dots.up, _stellarFlareCount)
					stellarFlareTime = string.format("|c%s%.1f|r", TRB.Data.settings.druid.balance.colors.text.dots.up, TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].stellarFlareRemaining)
				else
					stellarFlareCount = string.format("|c%s%.0f|r", TRB.Data.settings.druid.balance.colors.text.dots.pandemic, _stellarFlareCount)
					stellarFlareTime = string.format("|c%s%.1f|r", TRB.Data.settings.druid.balance.colors.text.dots.pandemic, TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].stellarFlareRemaining)
				end
			else
				stellarFlareCount = string.format("|c%s%.0f|r", TRB.Data.settings.druid.balance.colors.text.dots.down, _stellarFlareCount)
				stellarFlareTime = string.format("|c%s%.1f|r", TRB.Data.settings.druid.balance.colors.text.dots.down, 0)
			end
		else
			sunfireTime = string.format("%.1f", _sunfireTime)
			moonfireTime = string.format("%.1f", _moonfireTime)
			stellarFlareTime = string.format("%.1f", _stellarFlareTime)
		end


		--$mdTime
		local _starweaverTime = 0
		if TRB.Data.snapshot.starweaversWarp.spellId ~= nil then
			_starweaverTime = math.abs(TRB.Data.snapshot.starweaversWarp.endTime - currentTime)
		elseif TRB.Data.snapshot.starweaversWarp.spellId ~= nil then
			_starweaverTime = math.abs(TRB.Data.snapshot.starweaversWeft.endTime - currentTime)
		end
		local starweaverTime = string.format("%.1f", _starweaverTime)

		----------
		--$foeAstralPower
		local foeAstralPower = TRB.Data.snapshot.furyOfElune.astralPower or 0
		--$foeTicks
		local foeTicks = TRB.Data.snapshot.furyOfElune.ticksRemaining or 0
		--$foeTime
		local _foeTime = GetFuryOfEluneRemainingTime()
		local foeTime = "0.0"
		if TRB.Data.snapshot.furyOfElune.startTime ~= nil then
			foeTime = string.format("%.1f", _foeTime)
		end
		
		----------
		--$foeAstralPower
		local sunderedFirmamentAstralPower = TRB.Data.snapshot.sunderedFirmament.astralPower or 0
		--$foeTicks
		local sunderedFirmamentTicks = TRB.Data.snapshot.sunderedFirmament.ticksRemaining or 0
		--$foeTime
		local _sunderedFirmamentTime = GetSunderedFirmamentRemainingTime()
		local sunderedFirmamentTime = "0.0"
		if TRB.Data.snapshot.sunderedFirmament.startTime ~= nil then
			sunderedFirmamentTime = string.format("%.1f",_sunderedFirmamentTime)
		end
		
		--New Moon
		local currentMoonIcon = TRB.Data.spells.newMoon.icon
		--$moonAstralPower
		local moonAstralPower = 0
		--$moonCharges
		local moonCharges = TRB.Data.snapshot.newMoon.charges
		--$moonCooldown
		local _moonCooldown = 0
		--$moonCooldownTotal
		local _moonCooldownTotal = 0
		if TRB.Data.snapshot.newMoon.currentKey ~= "" and TRB.Data.snapshot.newMoon.currentSpellId ~= nil then
			currentMoonIcon = TRB.Data.spells[TRB.Data.snapshot.newMoon.currentKey].icon
			moonAstralPower = TRB.Data.spells[TRB.Data.snapshot.newMoon.currentKey].astralPower

			if TRB.Data.snapshot.newMoon.startTime ~= nil and TRB.Data.snapshot.newMoon.charges < TRB.Data.snapshot.newMoon.maxCharges then
				_moonCooldown = math.max(0, TRB.Data.snapshot.newMoon.startTime + TRB.Data.snapshot.newMoon.duration - currentTime)
				_moonCooldownTotal = _moonCooldown + ((TRB.Data.snapshot.newMoon.maxCharges - TRB.Data.snapshot.newMoon.charges - 1) * TRB.Data.snapshot.newMoon.duration)
			end
		end
		local moonCooldown = string.format("%.1f", _moonCooldown)
		local moonCooldownTotal = string.format("%.1f", _moonCooldownTotal)

		--$eclipseTime
		local _eclispeTime, eclipseIcon = GetEclipseRemainingTime()
		local eclipseTime = "0.0"
		if _eclispeTime ~= nil then
			eclipseTime = string.format("%.1f", _eclispeTime)
		end

		--#starweaver

		local starweaverIcon = TRB.Data.spells.starweaversWarp.icon
		if TRB.Data.snapshot.starweaversWeft.isActive then
			starweaverIcon = TRB.Data.spells.starweaversWeft.icon
		end

		--$pulsar variables
		local pulsarCollected = TRB.Data.snapshot.primordialArcanicPulsar.currentAstralPower or 0
		local _pulsarCollectedPercent = pulsarCollected / TRB.Data.spells.primordialArcanicPulsar.maxAstralPower
		local pulsarCollectedPercent = string.format("%.1f", TRB.Functions.Number:RoundTo(_pulsarCollectedPercent * 100, 1))
		local pulsarRemaining = TRB.Data.spells.primordialArcanicPulsar.maxAstralPower - pulsarCollected
		local _pulsarRemainingPercent = pulsarRemaining / TRB.Data.spells.primordialArcanicPulsar.maxAstralPower
		local pulsarRemainingPercent = string.format("%.1f", TRB.Functions.Number:RoundTo(_pulsarRemainingPercent * 100, 1))
		--local pulsarNextStarsurge = ""
		--local pulsarNextStarfall = ""
		local pulsarStarsurgeCount = TRB.Functions.Number:RoundTo(pulsarRemaining / -TRB.Data.spells.starsurge.astralPower, 0, ceil, true)
		local pulsarStarfallCount = TRB.Functions.Number:RoundTo(pulsarRemaining / -TRB.Data.spells.starfall.astralPower, 0, ceil, true)
		
		----------------------------

		Global_TwintopResourceBar.resource.passive = _passiveAstralPower or 0
		Global_TwintopResourceBar.resource.furyOfElune = foeAstralPower or 0
		Global_TwintopResourceBar.resource.sunderedFirmament = sunderedFirmamentAstralPower or 0
		Global_TwintopResourceBar.dots = {
			sunfireCount = _sunfireCount or 0,
			moonfireCount = _moonfireCount or 0,
			stellarFlareCount = _stellarFlareCount or 0
		}
		Global_TwintopResourceBar.furyOfElune = {
			astralPower = foeAstralPower or 0,
			ticks = foeTicks or 0,
			remaining = foeTime or 0
		}
		Global_TwintopResourceBar.sunderedFirmament = {
			astralPower = sunderedFirmamentAstralPower or 0,
			ticks = sunderedFirmamentTicks or 0,
			remaining = sunderedFirmamentTime or 0
		}
		
		local lookup = TRB.Data.lookup or {}
		lookup["#wrath"] = TRB.Data.spells.wrath.icon
		lookup["#moonkinForm"] = TRB.Data.spells.moonkinForm.icon
		lookup["#starfire"] = TRB.Data.spells.starfire.icon
		lookup["#sunfire"] = TRB.Data.spells.sunfire.icon
		lookup["#moonfire"] = TRB.Data.spells.moonfire.icon
		lookup["#starsurge"] = TRB.Data.spells.starsurge.icon
		lookup["#starfall"] = TRB.Data.spells.starfall.icon
		lookup["#eclipse"] = eclipseIcon or TRB.Data.spells.celestialAlignment.icon
		lookup["#celestialAlignment"] = TRB.Data.spells.celestialAlignment.icon
		lookup["#icoe"] = TRB.Data.spells.incarnationChosenOfElune.icon
		lookup["#coe"] = TRB.Data.spells.incarnationChosenOfElune.icon
		lookup["#incarnation"] = TRB.Data.spells.incarnationChosenOfElune.icon
		lookup["#incarnationChosenOfElune"] = TRB.Data.spells.incarnationChosenOfElune.icon
		lookup["#solar"] = TRB.Data.spells.eclipseSolar.icon
		lookup["#eclipseSolar"] = TRB.Data.spells.eclipseSolar.icon
		lookup["#solarEclipse"] = TRB.Data.spells.eclipseSolar.icon
		lookup["#lunar"] = TRB.Data.spells.eclipseLunar.icon
		lookup["#eclipseLunar"] = TRB.Data.spells.eclipseLunar.icon
		lookup["#lunarEclipse"] = TRB.Data.spells.eclipseLunar.icon
		lookup["#naturesBalance"] = TRB.Data.spells.naturesBalance.icon
		lookup["#soulOfTheForest"] = TRB.Data.spells.soulOfTheForest.icon
		lookup["#foe"] = TRB.Data.spells.furyOfElune.icon
		lookup["#furyOfElune"] = TRB.Data.spells.furyOfElune.icon
		lookup["#sunderedFirmament"] = TRB.Data.spells.sunderedFirmament.icon
		lookup["#stellarFlare"] = TRB.Data.spells.stellarFlare.icon
		lookup["#newMoon"] = TRB.Data.spells.newMoon.icon
		lookup["#halfMoon"] = TRB.Data.spells.halfMoon.icon
		lookup["#fullMoon"] = TRB.Data.spells.fullMoon.icon
		lookup["#moon"] = currentMoonIcon
		lookup["#starweaver"] = starweaverIcon
		lookup["#starweaversWarp"] = TRB.Data.spells.starweaversWarp.icon
		lookup["#starweaversWeft"] = TRB.Data.spells.starweaversWeft.icon
		lookup["#pulsar"] = TRB.Data.spells.primordialArcanicPulsar.icon
		lookup["#pap"] = TRB.Data.spells.primordialArcanicPulsar.icon
		lookup["#primordialArcanicPulsar"] = TRB.Data.spells.primordialArcanicPulsar.icon
		lookup["$pulsarCollected"] = pulsarCollected
		lookup["$pulsarCollectedPercent"] = pulsarCollectedPercent
		lookup["$pulsarRemaining"] = pulsarRemaining
		lookup["$pulsarRemainingPercent"] = pulsarRemainingPercent
		lookup["$pulsarNextStarsurge"] = ""
		lookup["$pulsarNextStarfall"] = ""
		lookup["$pulsarStarsurgeCount"] = pulsarStarsurgeCount
		lookup["$pulsarStarfallCount"] = pulsarStarfallCount
		lookup["$moonkinForm"] = ""
		lookup["$eclipseTime"] = eclipseTime
		lookup["$eclipse"] = ""
		lookup["$lunar"] = ""
		lookup["$lunarEclipse"] = ""
		lookup["$eclipseLunar"] = ""
		lookup["$solar"] = ""
		lookup["$solarEclipse"] = ""
		lookup["$eclipseSolar"] = ""
		lookup["$celestialAlignment"] = ""
		lookup["$starweaverTime"] = starweaverTime
		lookup["$starweaversWarp"] = ""
		lookup["$starweaversWeft"] = ""
		lookup["$moonAstralPower"] = moonAstralPower
		lookup["$moonCharges"] = moonCharges
		lookup["$moonCooldown"] = moonCooldown
		lookup["$moonCooldownTotal"] = moonCooldownTotal
		lookup["$sunfireCount"] = sunfireCount
		lookup["$sunfireTime"] = sunfireTime
		lookup["$moonfireCount"] = moonfireCount
		lookup["$moonfireTime"] = moonfireTime
		lookup["$stellarFlareCount"] = stellarFlareCount
		lookup["$stellarFlareTime"] = stellarFlareTime
		lookup["$astralPowerPlusCasting"] = astralPowerPlusCasting
		lookup["$astralPowerPlusPassive"] = astralPowerPlusPassive
		lookup["$astralPowerTotal"] = astralPowerTotal
		lookup["$astralPowerMax"] = TRB.Data.character.maxResource
		lookup["$astralPower"] = currentAstralPower
		lookup["$resourcePlusCasting"] = astralPowerPlusCasting
		lookup["$resourcePlusPassive"] = astralPowerPlusPassive
		lookup["$resourceTotal"] = astralPowerTotal
		lookup["$resourceMax"] = TRB.Data.character.maxResource
		lookup["$resource"] = currentAstralPower
		lookup["$casting"] = castingAstralPower
		lookup["$passive"] = passiveAstralPower
		lookup["$overcap"] = overcap
		lookup["$resourceOvercap"] = overcap
		lookup["$astralPowerOvercap"] = overcap
		lookup["$foeAstralPower"] = foeAstralPower
		lookup["$foeTicks"] = foeTicks
		lookup["$foeTime"] = foeTime
		lookup["$sunderedFirmamentAstralPower"] = sunderedFirmamentAstralPower
		lookup["$sunderedFirmamentTicks"] = sunderedFirmamentTicks
		lookup["$sunderedFirmamentTime"] = sunderedFirmamentTime
		lookup["$talentStellarFlare"] = ""
		TRB.Data.lookup = lookup

		local lookupLogic = TRB.Data.lookupLogic or {}
		lookupLogic["$pulsarCollected"] = pulsarCollected
		lookupLogic["$pulsarCollectedPercent"] = _pulsarCollectedPercent
		lookupLogic["$pulsarRemaining"] = pulsarRemaining
		lookupLogic["$pulsarRemainingPercent"] = _pulsarRemainingPercent
		lookupLogic["$pulsarStarsurgeCount"] = pulsarStarsurgeCount
		lookupLogic["$pulsarStarfallCount"] = pulsarStarfallCount
		lookupLogic["$eclipseTime"] = _eclispeTime
		lookupLogic["$starweaverTime"] = _starweaverTime
		lookupLogic["$moonAstralPower"] = moonAstralPower
		lookupLogic["$moonCharges"] = moonCharges
		lookupLogic["$moonCooldown"] = _moonCooldown
		lookupLogic["$moonCooldownTotal"] = _moonCooldownTotal
		lookupLogic["$sunfireCount"] = _sunfireCount
		lookupLogic["$sunfireTime"] = _sunfireTime
		lookupLogic["$moonfireCount"] = _moonfireCount
		lookupLogic["$moonfireTime"] = _moonfireTime
		lookupLogic["$stellarFlareCount"] = _stellarFlareCount
		lookupLogic["$stellarFlareTime"] = _stellarFlareTime
		lookupLogic["$astralPowerPlusCasting"] = _astralPowerPlusCasting
		lookupLogic["$astralPowerPlusPassive"] = _astralPowerPlusPassive
		lookupLogic["$astralPowerTotal"] = _astralPowerTotal
		lookupLogic["$astralPowerMax"] = TRB.Data.character.maxResource
		lookupLogic["$astralPower"] = normalizedAstralPower
		lookupLogic["$resourcePlusCasting"] = _astralPowerPlusCasting
		lookupLogic["$resourcePlusPassive"] = _astralPowerPlusPassive
		lookupLogic["$resourceTotal"] = _astralPowerTotal
		lookupLogic["$resourceMax"] = TRB.Data.character.maxResource
		lookupLogic["$resource"] = normalizedAstralPower
		lookupLogic["$casting"] = currentAstralPower
		lookupLogic["$passive"] = _passiveAstralPower
		lookupLogic["$overcap"] = overcap
		lookupLogic["$resourceOvercap"] = overcap
		lookupLogic["$astralPowerOvercap"] = overcap
		lookupLogic["$foeAstralPower"] = foeAstralPower
		lookupLogic["$foeTicks"] = foeTicks
		lookupLogic["$foeTime"] = _foeTime
		lookupLogic["$sunderedFirmamentAstralPower"] = sunderedFirmamentAstralPower
		lookupLogic["$sunderedFirmamentTicks"] = sunderedFirmamentTicks
		lookupLogic["$sunderedFirmamentTime"] = _sunderedFirmamentTime
		TRB.Data.lookupLogic = lookupLogic
	end
	
	local function RefreshLookupData_Feral()
		local _

		-- Curren snapshot values if they were applied now
		local _currentSnapshotRip = TRB.Data.snapshot.snapshots.rip
		local _currentSnapshotRake = TRB.Data.snapshot.snapshots.rake
		local _currentSnapshotThrash = TRB.Data.snapshot.snapshots.thrash
		local _currentSnapshotMoonfire = TRB.Data.snapshot.snapshots.moonfire		

		--Spec specific implementation
		local currentTime = GetTime()

		-- This probably needs to be pulled every refresh
		TRB.Data.snapshot.energyRegen, _ = GetPowerRegen()

		--$overcap
		local overcap = TRB.Functions.Class:IsValidVariableForSpec("$overcap")

		local currentEnergyColor = TRB.Data.settings.druid.feral.colors.text.current
		local castingEnergyColor = TRB.Data.settings.druid.feral.colors.text.casting
		
		if TRB.Functions.Class:IsValidVariableForSpec("$inCombat") then
			if TRB.Data.settings.druid.feral.colors.text.overcapEnabled and overcap then
				currentEnergyColor = TRB.Data.settings.druid.feral.colors.text.overcap
				castingEnergyColor = TRB.Data.settings.druid.feral.colors.text.overcap
			elseif TRB.Data.settings.druid.feral.colors.text.overThresholdEnabled then
				local _overThreshold = false
				for k, v in pairs(TRB.Data.spells) do
					local spell = TRB.Data.spells[k]
					if	spell ~= nil and spell.thresholdUsable == true then
						_overThreshold = true
						break
					end
				end

				if _overThreshold then
					currentEnergyColor = TRB.Data.settings.druid.feral.colors.text.overThreshold
					castingEnergyColor = TRB.Data.settings.druid.feral.colors.text.overThreshold
				end
			end
		end

		if TRB.Data.snapshot.casting.resourceFinal < 0 then
			castingEnergyColor = TRB.Data.settings.druid.feral.colors.text.spending
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

		if TRB.Data.settings.druid.feral.generation.enabled then
			if TRB.Data.settings.druid.feral.generation.mode == "time" then
				_regenEnergy = TRB.Data.snapshot.energyRegen * (TRB.Data.settings.druid.feral.generation.time or 3.0)
			else
				_regenEnergy = TRB.Data.snapshot.energyRegen * ((TRB.Data.settings.druid.feral.generation.gcds or 2) * _gcd)
			end
		end

		--$regenEnergy
		local regenEnergy = string.format("|c%s%.0f|r", TRB.Data.settings.druid.feral.colors.text.passive, _regenEnergy)

		_passiveEnergy = _regenEnergy
		_passiveEnergyMinusRegen = _passiveEnergy - _regenEnergy

		local passiveEnergy = string.format("|c%s%.0f|r", TRB.Data.settings.druid.feral.colors.text.passive, _passiveEnergy)
		local passiveEnergyMinusRegen = string.format("|c%s%.0f|r", TRB.Data.settings.druid.feral.colors.text.passive, _passiveEnergyMinusRegen)
		--$energyTotal
		local _energyTotal = math.min(_passiveEnergy + TRB.Data.snapshot.casting.resourceFinal + TRB.Data.snapshot.resource, TRB.Data.character.maxResource)
		local energyTotal = string.format("|c%s%.0f|r", currentEnergyColor, _energyTotal)
		--$energyPlusCasting
		local _energyPlusCasting = math.min(TRB.Data.snapshot.casting.resourceFinal + TRB.Data.snapshot.resource, TRB.Data.character.maxResource)
		local energyPlusCasting = string.format("|c%s%.0f|r", castingEnergyColor, _energyPlusCasting)
		--$energyPlusPassive
		local _energyPlusPassive = math.min(_passiveEnergy + TRB.Data.snapshot.resource, TRB.Data.character.maxResource)
		local energyPlusPassive = string.format("|c%s%.0f|r", currentEnergyColor, _energyPlusPassive)

		
		----------
		--$ripCount and $ripTime
		local _ripCount = TRB.Data.snapshot.targetData.rip or 0
		local ripCount = tostring(_ripCount)
		local _ripTime = 0
		local ripTime
		local _ripSnapshot = 0
		local ripSnapshot
		local _ripPercent = 0
		local ripPercent
		local ripCurrent

		--$rakeCount and $rakeTime
		local _rakeCount = TRB.Data.snapshot.targetData.rake or 0
		local rakeCount = tostring(_rakeCount)
		local _rakeTime = 0
		local rakeTime
		local _rakeSnapshot = 0
		local rakeSnapshot
		local _rakePercent = 0
		local rakePercent
		local rakeCurrent

		--$thrashCount and $thrashTime
		local _thrashCount = TRB.Data.snapshot.targetData.thrash or 0
		local thrashCount = tostring(_thrashCount)
		local _thrashTime = 0
		local thrashTime
		local _thrashSnapshot = 0
		local thrashSnapshot
		local _thrashPercent = 0
		local thrashPercent
		local thrashCurrent

		--$moonfireCount and $moonfireTime
		local _moonfireCount = TRB.Data.snapshot.targetData.moonfire or 0
		local moonfireCount = tostring(_moonfireCount)
		local _moonfireTime = 0
		local moonfireTime
		local _moonfireSnapshot = 0
		local moonfireSnapshot
		local _moonfirePercent = 0
		local moonfirePercent
		local moonfireCurrent
		
		if TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid] ~= nil then
			_ripTime = TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].ripRemaining or 0
			_ripSnapshot = TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].ripSnapshot or 0
			_ripPercent = (_ripSnapshot / _currentSnapshotRip)
			_rakeTime = TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].rakeRemaining or 0
			_rakeSnapshot = TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].rakeSnapshot or 0
			_rakePercent = (_rakeSnapshot / _currentSnapshotRake)
			_thrashTime = TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].thrashRemaining or 0
			_thrashSnapshot = TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].thrashSnapshot or 0
			_thrashPercent = (_thrashSnapshot / _currentSnapshotThrash)
			_moonfireTime = TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].moonfireRemaining or 0
			_moonfireSnapshot = TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].moonfireSnapshot or 0
			_moonfirePercent = (_moonfireSnapshot / _currentSnapshotMoonfire)
		end

		if TRB.Data.settings.druid.feral.colors.text.dots.enabled and TRB.Data.snapshot.targetData.currentTargetGuid ~= nil and not UnitIsDeadOrGhost("target") and UnitCanAttack("player", "target") then
			if TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid] ~= nil and TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].rip then
				local ripColor = TRB.Data.settings.druid.feral.colors.text.dots.same
				if _ripPercent > 1 then
					ripColor = TRB.Data.settings.druid.feral.colors.text.dots.better
				elseif _ripPercent < 1 then
					ripColor = TRB.Data.settings.druid.feral.colors.text.dots.worse
				else
					ripColor = TRB.Data.settings.druid.feral.colors.text.dots.same
				end

				ripCount = string.format("|c%s%.0f|r", ripColor, _ripCount)
				ripSnapshot = string.format("|c%s%.0f|r", ripColor, TRB.Functions.Number:RoundTo(100 * _ripSnapshot, 0, "floor"))
				ripCurrent = string.format("|c%s%.0f|r", ripColor, TRB.Functions.Number:RoundTo(100 * _currentSnapshotRip, 0, "floor"))
				ripPercent = string.format("|c%s%.0f|r", ripColor, TRB.Functions.Number:RoundTo(100 * _ripPercent, 0, "floor"))
				ripTime = string.format("|c%s%.1f|r", ripColor, _ripTime)
			else
				ripCount = string.format("|c%s%.0f|r", TRB.Data.settings.druid.feral.colors.text.dots.down, _ripCount)
				ripSnapshot = string.format("|c%s%.0f|r", TRB.Data.settings.druid.feral.colors.text.dots.down, 0)
				ripCurrent = string.format("|c%s%.0f|r", TRB.Data.settings.druid.feral.colors.text.dots.down, TRB.Functions.Number:RoundTo(100 * _currentSnapshotRip, 0, "floor"))
				ripPercent = string.format("|c%s%.0f|r", TRB.Data.settings.druid.feral.colors.text.dots.down, 0)
				ripTime = string.format("|c%s%.1f|r", TRB.Data.settings.druid.feral.colors.text.dots.down, 0)
			end

			if TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid] ~= nil and TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].rake then
				local rakeColor = TRB.Data.settings.druid.feral.colors.text.dots.same
				if _rakePercent > 1 then
					rakeColor = TRB.Data.settings.druid.feral.colors.text.dots.better
				elseif _rakePercent < 1 then
					rakeColor = TRB.Data.settings.druid.feral.colors.text.dots.worse
				else
					rakeColor = TRB.Data.settings.druid.feral.colors.text.dots.same
				end

				rakeCount = string.format("|c%s%.0f|r", rakeColor, _rakeCount)
				rakeSnapshot = string.format("|c%s%.0f|r", rakeColor, TRB.Functions.Number:RoundTo(100 * _rakeSnapshot, 0, "floor"))
				rakeCurrent = string.format("|c%s%.0f|r", rakeColor, TRB.Functions.Number:RoundTo(100 * _currentSnapshotRake, 0, "floor"))
				rakePercent = string.format("|c%s%.0f|r", rakeColor, TRB.Functions.Number:RoundTo(100 * _rakePercent, 0, "floor"))
				rakeTime = string.format("|c%s%.1f|r", rakeColor, _rakeTime)
			else
				rakeCount = string.format("|c%s%.0f|r", TRB.Data.settings.druid.feral.colors.text.dots.down, _rakeCount)
				rakeSnapshot = string.format("|c%s%.0f|r", TRB.Data.settings.druid.feral.colors.text.dots.down, 0)
				rakeCurrent = string.format("|c%s%.0f|r", TRB.Data.settings.druid.feral.colors.text.dots.down, TRB.Functions.Number:RoundTo(100 * _currentSnapshotRake, 0, "floor"))
				rakePercent = string.format("|c%s%.0f|r", TRB.Data.settings.druid.feral.colors.text.dots.down, 0)
				rakeTime = string.format("|c%s%.1f|r", TRB.Data.settings.druid.feral.colors.text.dots.down, 0)
			end

			if TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid] ~= nil and TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].thrash then
				local thrashColor = TRB.Data.settings.druid.feral.colors.text.dots.same
				if _thrashPercent > 1 then
					thrashColor = TRB.Data.settings.druid.feral.colors.text.dots.better
				elseif _thrashPercent < 1 then
					thrashColor = TRB.Data.settings.druid.feral.colors.text.dots.worse
				else
					thrashColor = TRB.Data.settings.druid.feral.colors.text.dots.same
				end

				thrashCount = string.format("|c%s%.0f|r", thrashColor, _thrashCount)
				thrashSnapshot = string.format("|c%s%.0f|r", thrashColor, TRB.Functions.Number:RoundTo(100 * _thrashSnapshot, 0, "floor"))
				thrashCurrent = string.format("|c%s%.0f|r", thrashColor, TRB.Functions.Number:RoundTo(100 * _currentSnapshotThrash, 0, "floor"))
				thrashPercent = string.format("|c%s%.0f|r", thrashColor, TRB.Functions.Number:RoundTo(100 * _thrashPercent, 0, "floor"))
				thrashTime = string.format("|c%s%.1f|r", thrashColor, _thrashTime)
			else
				thrashCount = string.format("|c%s%.0f|r", TRB.Data.settings.druid.feral.colors.text.dots.down, _thrashCount)
				thrashSnapshot = string.format("|c%s%.0f|r", TRB.Data.settings.druid.feral.colors.text.dots.down, 0)
				thrashCurrent = string.format("|c%s%.0f|r", TRB.Data.settings.druid.feral.colors.text.dots.down, TRB.Functions.Number:RoundTo(100 * _currentSnapshotThrash, 0, "floor"))
				thrashPercent = string.format("|c%s%.0f|r", TRB.Data.settings.druid.feral.colors.text.dots.down, 0)
				thrashTime = string.format("|c%s%.1f|r", TRB.Data.settings.druid.feral.colors.text.dots.down, 0)
			end

			if TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.lunarInspiration) == true and TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid] ~= nil and TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].moonfire then
				local moonfireColor = TRB.Data.settings.druid.feral.colors.text.dots.same
				if _moonfirePercent > 1 then
					moonfireColor = TRB.Data.settings.druid.feral.colors.text.dots.better
				elseif _moonfirePercent < 1 then
					moonfireColor = TRB.Data.settings.druid.feral.colors.text.dots.worse
				else
					moonfireColor = TRB.Data.settings.druid.feral.colors.text.dots.same
				end

				moonfireCount = string.format("|c%s%.0f|r", moonfireColor, _moonfireCount)
				moonfireSnapshot = string.format("|c%s%.0f|r", moonfireColor, TRB.Functions.Number:RoundTo(100 * _moonfireSnapshot, 0, "floor"))
				moonfireCurrent = string.format("|c%s%.0f|r", moonfireColor, TRB.Functions.Number:RoundTo(100 * _currentSnapshotMoonfire, 0, "floor"))
				moonfirePercent = string.format("|c%s%.0f|r", moonfireColor, TRB.Functions.Number:RoundTo(100 * _moonfirePercent, 0, "floor"))
				moonfireTime = string.format("|c%s%.1f|r", moonfireColor, _moonfireTime)
			else
				moonfireCount = string.format("|c%s%.0f|r", TRB.Data.settings.druid.feral.colors.text.dots.down, _moonfireCount)
				moonfireSnapshot = string.format("|c%s%.0f|r", TRB.Data.settings.druid.feral.colors.text.dots.down, 0)
				moonfireCurrent = string.format("|c%s%.0f|r", TRB.Data.settings.druid.feral.colors.text.dots.down, TRB.Functions.Number:RoundTo(100 * _currentSnapshotMoonfire, 0, "floor"))
				moonfirePercent = string.format("|c%s%.0f|r", TRB.Data.settings.druid.feral.colors.text.dots.down, 0)
				moonfireTime = string.format("|c%s%.1f|r", TRB.Data.settings.druid.feral.colors.text.dots.down, 0)
			end
		else
			ripTime = string.format("%.1f", _ripTime)
			rakeTime = string.format("%.1f", _rakeTime)
			thrashTime = string.format("%.1f", _thrashTime)

			ripSnapshot = TRB.Functions.Number:RoundTo(100 * _ripSnapshot, 0, "floor", true)
			rakeSnapshot = TRB.Functions.Number:RoundTo(100 * _rakeSnapshot, 0, "floor", true)
			thrashSnapshot = TRB.Functions.Number:RoundTo(100 * _thrashSnapshot, 0, "floor", true)

			ripCurrent = TRB.Functions.Number:RoundTo(100 * _currentSnapshotRip, 0, "floor", true)
			rakeCurrent = TRB.Functions.Number:RoundTo(100 * _currentSnapshotRake, 0, "floor", true)
			thrashCurrent = TRB.Functions.Number:RoundTo(100 * _currentSnapshotThrash, 0, "floor", true)

			ripPercent = TRB.Functions.Number:RoundTo(100 * _ripPercent, 0, "floor", true)
			rakePercent = TRB.Functions.Number:RoundTo(100 * _rakePercent, 0, "floor", true)
			thrashPercent = TRB.Functions.Number:RoundTo(100 * _thrashPercent, 0, "floor", true)

			if TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.lunarInspiration) == true then
				moonfireTime = string.format("%.1f", _moonfireTime)
				moonfireSnapshot = TRB.Functions.Number:RoundTo(100 * _moonfireSnapshot, 0, "floor", true)
				moonfireCurrent = TRB.Functions.Number:RoundTo(100 * _currentSnapshotMoonfire, 0, "floor", true)
				moonfirePercent = TRB.Functions.Number:RoundTo(100 * _moonfirePercent, 0, "floor", true)
			else
				moonfireTime = string.format("%.1f", 0)
				moonfireSnapshot = 0
				moonfireCurrent = TRB.Functions.Number:RoundTo(100 * _currentSnapshotMoonfire, 0, "floor", true)
				moonfirePercent = 0
			end
		end
		
		--$brutalSlashCharges
		local brutalSlashCharges = TRB.Data.snapshot.brutalSlash.charges
		--$brutalSlashCooldown
		local _brutalSlashCooldown = 0
		--$brutalSlashCooldownTotal
		local _brutalSlashCooldownTotal = 0

		if TRB.Data.snapshot.brutalSlash.startTime ~= nil and TRB.Data.snapshot.brutalSlash.charges < TRB.Data.snapshot.brutalSlash.maxCharges then
			local _brutalSlashHastedCooldown = (TRB.Data.snapshot.brutalSlash.duration / (1 + (TRB.Data.snapshot.haste / 100)))
			_brutalSlashCooldown = math.max(0, TRB.Data.snapshot.brutalSlash.startTime + _brutalSlashHastedCooldown - currentTime)
			_brutalSlashCooldownTotal = _brutalSlashCooldown + ((TRB.Data.snapshot.brutalSlash.maxCharges - TRB.Data.snapshot.brutalSlash.charges - 1) * _brutalSlashHastedCooldown)
		end

		local brutalSlashCooldown = string.format("%.1f", _brutalSlashCooldown)
		local brutalSlashCooldownTotal = string.format("%.1f", _brutalSlashCooldownTotal)
		
		--$bloodtalonsStacks
		local bloodtalonsStacks = TRB.Data.snapshot.bloodtalons.stacks or 0

		--$bloodtalonsTime
		local _bloodtalonsTime = TRB.Data.snapshot.bloodtalons.remainingTime or 0
		local bloodtalonsTime = string.format("%.1f", _bloodtalonsTime)
		
		--$tigersFuryTime
		local _tigersFuryTime = GetTigersFuryRemainingTime()
		local tigersFuryTime = "0"
		if _tigersFuryTime ~= nil then
			tigersFuryTime = string.format("%.1f", _tigersFuryTime)
		end
		
		--$tigersFuryCooldownTime
		local _tigersFuryCooldownTime = GetTigersFuryCooldownRemainingTime()
		local tigersFuryCooldownTime = "0"
		if _tigersFuryCooldownTime ~= nil then
			tigersFuryCooldownTime = string.format("%.1f", _tigersFuryCooldownTime)
		end

		--$suddenAmbushTime
		local _suddenAmbushTime = GetSuddenAmbushRemainingTime()
		local suddenAmbushTime = "0"
		if _suddenAmbushTime ~= nil then
			suddenAmbushTime = string.format("%.1f", _suddenAmbushTime)
		end
		
		--$clearcastingStacks
		local clearcastingStacks = TRB.Data.snapshot.clearcasting.stacks or 0

		--$clearcastingTime
		local _clearcastingTime = TRB.Data.snapshot.clearcasting.remainingTime or 0
		local clearcastingTime = string.format("%.1f", _clearcastingTime)

		--$berserkTime (and $incarnationTime)
		local _berserkTime = GetBerserkRemainingTime()
		local berserkTime = string.format("%.1f", _berserkTime)

		--$apexPredatorsCravingTime
		local _apexPredatorsCravingTime = GetApexPredatorsCravingRemainingTime()
		local apexPredatorsCravingTime = "0"
		if _apexPredatorsCravingTime ~= nil then
			apexPredatorsCravingTime = string.format("%.1f", _apexPredatorsCravingTime)
		end
		
		--$predatorRevealedTime
		local _predatorRevealedTime = GetPredatorRevealedRemainingTime()
		local predatorRevealedTime = "0"
		if _predatorRevealedTime ~= nil then
			predatorRevealedTime = string.format("%.1f", _predatorRevealedTime)
		end

		--$predatorRevealedTicks 
		local _predatorRevealedTicks = TRB.Data.snapshot.predatorRevealed.ticks
		
		--$predatorRevealedTickTime
		local _predatorRevealedTickTime = TRB.Data.snapshot.predatorRevealed.untilNextTick
		local predatorRevealedTickTime = "0"
		if _predatorRevealedTickTime ~= nil then
			predatorRevealedTickTime = string.format("%.1f", _predatorRevealedTickTime)
		end

		----------------------------

		Global_TwintopResourceBar.resource.passive = _passiveEnergy or 0
		Global_TwintopResourceBar.dots = {
			ripCount = _ripCount or 0,
			rakeCount = _rakeCount or 0,
			thrashCount = _thrashCount or 0,
			moonfireCount = _moonfireCount or 0,
			ripPercent = _ripPercent or 0,
			rakePercent = _rakePercent or 0,
			thrashPercent = _thrashPercent or 0,
			moonfirePercent = _moonfirePercent or 0,
			ripSnapshot = _ripSnapshot or 0,
			rakeSnapshot = _rakeSnapshot or 0,
			thrashSnapshot = _thrashSnapshot or 0,
			moonfireSnapshot = _moonfireSnapshot or 0,
			ripCurrent = _currentSnapshotRip or 1,
			rakeCurrent = _currentSnapshotRake or 1,
			thrashCurrent = _currentSnapshotThrash or 1,
			moonfireCurrent = _currentSnapshotMoonfire or 0,
		}

		local lookup = TRB.Data.lookup or {}
		lookup["#berserk"] = TRB.Data.spells.berserk.icon
		lookup["#bloodtalons"] = TRB.Data.spells.bloodtalons.icon
		lookup["#brutalSlash"] = TRB.Data.spells.brutalSlash.icon
		lookup["#carnivorousInstinct"] = TRB.Data.spells.carnivorousInstinct.icon
		lookup["#catForm"] = TRB.Data.spells.catForm.icon
		lookup["#clearcasting"] = TRB.Data.spells.clearcasting.icon
		lookup["#feralFrenzy"] = TRB.Data.spells.feralFrenzy.icon
		lookup["#ferociousBite"] = TRB.Data.spells.ferociousBite.icon
		lookup["#incarnation"] = TRB.Data.spells.incarnationAvatarOfAshamane.icon
		lookup["#incarnationAvatarOfAshamane"] = TRB.Data.spells.incarnationAvatarOfAshamane.icon
		lookup["#lunarInspiration"] = TRB.Data.spells.lunarInspiration.icon
		lookup["#maim"] = TRB.Data.spells.maim.icon
		lookup["#moonfire"] = TRB.Data.spells.moonfire.icon
		lookup["#predatorRevealed"] = TRB.Data.spells.predatorRevealed.icon
		lookup["#predatorySwiftness"] = TRB.Data.spells.predatorySwiftness.icon
		lookup["#primalWrath"] = TRB.Data.spells.primalWrath.icon
		lookup["#prowl"] = TRB.Data.spells.prowl.icon
		lookup["#stealth"] = TRB.Data.spells.prowl.icon
		lookup["#rake"] = TRB.Data.spells.rake.icon
		lookup["#rip"] = TRB.Data.spells.rip.icon
		lookup["#shadowmeld"] = TRB.Data.spells.shadowmeld.icon
		lookup["#shred"] = TRB.Data.spells.shred.icon
		lookup["#suddenAmbush"] = TRB.Data.spells.suddenAmbush.icon
		lookup["#swipe"] = TRB.Data.spells.swipe.icon
		lookup["#thrash"] = TRB.Data.spells.thrash.icon
		lookup["#tigersFury"] = TRB.Data.spells.tigersFury.icon
		lookup["$ripCount"] = ripCount
		lookup["$ripTime"] = ripTime
		lookup["$ripSnapshot"] = ripSnapshot
		lookup["$ripCurrent"] = ripCurrent
		lookup["$ripPercent"] = ripPercent
		lookup["$rakeCount"] = rakeCount
		lookup["$rakeTime"] = rakeTime
		lookup["$rakeSnapshot"] = rakeSnapshot
		lookup["$rakeCurrent"] = rakeCurrent
		lookup["$rakePercent"] = rakePercent
		lookup["$thrashCount"] = thrashCount
		lookup["$thrashTime"] = thrashTime
		lookup["$thrashSnapshot"] = thrashSnapshot
		lookup["$thrashCurrent"] = thrashCurrent
		lookup["$thrashPercent"] = thrashPercent
		lookup["$moonfireCount"] = moonfireCount
		lookup["$moonfireTime"] = moonfireTime
		lookup["$moonfireSnapshot"] = moonfireSnapshot
		lookup["$moonfireCurrent"] = moonfireCurrent
		lookup["$moonfirePercent"] = moonfirePercent
		lookup["$lunarInspiration"] = ""

		lookup["$brutalSlashCharges"] = brutalSlashCharges
		lookup["$brutalSlashCooldown"] = brutalSlashCooldown
		lookup["$brutalSlashCooldownTotal"] = brutalSlashCooldownTotal
		lookup["$bloodtalonsStacks"] = bloodtalonsStacks
		lookup["$bloodtalonsTime"] = bloodtalonsTime
		lookup["$suddenAmbushTime"] = suddenAmbushTime
		lookup["$clearcastingStacks"] = clearcastingStacks
		lookup["$clearcastingTime"] = clearcastingTime
		lookup["$berserkTime"] = berserkTime
		lookup["$incarnationTime"] = berserkTime
		lookup["$apexPredatorsCravingTime"] = apexPredatorsCravingTime
		lookup["$tigersFuryTime"] = tigersFuryTime
		lookup["$tigersFuryCooldownTime"] = tigersFuryCooldownTime

		lookup["$predatorRevealedTime"] = predatorRevealedTime
		lookup["$predatorRevealedTicks"] = _predatorRevealedTicks
		lookup["$predatorRevealedTickTime"] = predatorRevealedTickTime

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
		lookup["$regen"] = regenEnergy
		lookup["$regenEnergy"] = regenEnergy
		lookup["$energyRegen"] = regenEnergy
		lookup["$overcap"] = overcap
		lookup["$resourceOvercap"] = overcap
		lookup["$energyOvercap"] = overcap
		lookup["$comboPoints"] = TRB.Data.character.resource2
		lookup["$comboPointsMax"] = TRB.Data.character.maxResource2
		lookup["$inStealth"] = ""
		TRB.Data.lookup = lookup
		

		local lookupLogic = TRB.Data.lookupLogic or {}
		lookupLogic["$ripCount"] = _ripCount
		lookupLogic["$ripTime"] = _ripTime
		lookupLogic["$ripSnapshot"] = _ripSnapshot
		lookupLogic["$ripCurrent"] = _currentSnapshotRip
		lookupLogic["$ripPercent"] = _ripPercent
		lookupLogic["$rakeCount"] = _rakeCount
		lookupLogic["$rakeTime"] = _rakeTime
		lookupLogic["$rakeSnapshot"] = _rakeSnapshot
		lookupLogic["$rakeCurrent"] = _currentSnapshotRake
		lookupLogic["$rakePercent"] = _rakePercent
		lookupLogic["$thrashCount"] = _thrashCount
		lookupLogic["$thrashTime"] = _thrashTime
		lookupLogic["$thrashSnapshot"] = _thrashSnapshot
		lookupLogic["$thrashCurrent"] = _currentSnapshotThrash
		lookupLogic["$thrashPercent"] = _thrashPercent
		lookupLogic["$moonfireCount"] = _moonfireCount
		lookupLogic["$moonfireTime"] = _moonfireTime
		lookupLogic["$moonfireSnapshot"] = _moonfireSnapshot
		lookupLogic["$moonfireCurrent"] = _currentSnapshotMoonfire
		lookupLogic["$moonfirePercent"] = _moonfirePercent
		lookupLogic["$brutalSlashCharges"] = brutalSlashCharges
		lookupLogic["$brutalSlashCooldown"] = _brutalSlashCooldown
		lookupLogic["$brutalSlashCooldownTotal"] = _brutalSlashCooldownTotal
		lookupLogic["$bloodtalonsStacks"] = bloodtalonsStacks
		lookupLogic["$bloodtalonsTime"] = _bloodtalonsTime
		lookupLogic["$suddenAmbushTime"] = _suddenAmbushTime
		lookupLogic["$clearcastingStacks"] = clearcastingStacks
		lookupLogic["$clearcastingTime"] = _clearcastingTime
		lookupLogic["$berserkTime"] = _berserkTime
		lookupLogic["$incarnationTime"] = _berserkTime
		lookupLogic["$apexPredatorsCravingTime"] = _apexPredatorsCravingTime
		lookupLogic["$tigersFuryTime"] = _tigersFuryTime
		lookupLogic["$tigersFuryCooldownTime"] = _tigersFuryCooldownTime
		lookupLogic["$predatorRevealedTime"] = _predatorRevealedTime
		lookupLogic["$predatorRevealedTicks"] = _predatorRevealedTicks
		lookupLogic["$predatorRevealedTickTime"] = _predatorRevealedTickTime
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
		lookupLogic["$regen"] = _regenEnergy
		lookupLogic["$regenEnergy"] = _regenEnergy
		lookupLogic["$energyRegen"] = _regenEnergy
		lookupLogic["$overcap"] = overcap
		lookupLogic["$resourceOvercap"] = overcap
		lookupLogic["$energyOvercap"] = overcap
		lookupLogic["$comboPoints"] = TRB.Data.character.resource2
		lookupLogic["$comboPointsMax"] = TRB.Data.character.maxResource2
		lookupLogic["$inStealth"] = ""
		TRB.Data.lookupLogic = lookupLogic
	end

	local function RefreshLookupData_Restoration()
		local currentTime = GetTime()
		local normalizedMana = TRB.Data.snapshot.resource / TRB.Data.resourceFactor

		-- This probably needs to be pulled every refresh
---@diagnostic disable-next-line: cast-local-type
		TRB.Data.snapshot.manaRegen, _ = GetPowerRegen()

		local currentManaColor = TRB.Data.settings.druid.restoration.colors.text.current
		local castingManaColor = TRB.Data.settings.druid.restoration.colors.text.casting

		--$mana
		local manaPrecision = TRB.Data.settings.druid.restoration.manaPrecision or 1
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
		local passiveMana = string.format("|c%s%s|r", TRB.Data.settings.druid.restoration.colors.text.passive, TRB.Functions.String:ConvertToShortNumberNotation(_passiveMana, manaPrecision, "floor", true))
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

		--$efflorescenceTime
		local _efflorescenceTime = GetEfflorescenceRemainingTime()
		local efflorescenceTime = string.format("%.1f", _efflorescenceTime)
	
		--$clearcastingTime
		local _clearcastingTime = TRB.Data.snapshot.clearcasting.remainingTime or 0
		local clearcastingTime = string.format("%.1f", _clearcastingTime)

		--$incarnationTime
		local _incarnationTime = GetIncarnationTreeOfLifeRemainingTime()
		local incarnationTime = string.format("%.1f", _incarnationTime)	

		--$reforestationStacks
		local reforestationStacks = TRB.Data.snapshot.reforestation.stacks or 0

		----------
		--$sunfireCount and $sunfireTime
		local _sunfireCount = TRB.Data.snapshot.targetData.sunfire or 0
		local sunfireCount = tostring(_sunfireCount)
		local _sunfireTime = 0
		
		if TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid] ~= nil then
			_sunfireTime = TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].sunfireRemaining or 0
		end

		local sunfireTime

		--$moonfireCount and $moonfireTime
		local _moonfireCount = TRB.Data.snapshot.targetData.moonfire or 0
		local moonfireCount = tostring(_moonfireCount)
		local _moonfireTime = 0
		
		if TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid] ~= nil then
			_moonfireTime = TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].moonfireRemaining or 0
		end

		local moonfireTime

		if TRB.Data.settings.druid.restoration.colors.text.dots.enabled and TRB.Data.snapshot.targetData.currentTargetGuid ~= nil and not UnitIsDeadOrGhost("target") and UnitCanAttack("player", "target") then
			if TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid] ~= nil and TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].sunfire then
				if TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].sunfireRemaining > TRB.Data.spells.sunfire.pandemicTime then
					sunfireCount = string.format("|c%s%.0f|r", TRB.Data.settings.druid.restoration.colors.text.dots.up, _sunfireCount)
					sunfireTime = string.format("|c%s%.1f|r", TRB.Data.settings.druid.restoration.colors.text.dots.up, TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].sunfireRemaining)
				else
					sunfireCount = string.format("|c%s%.0f|r", TRB.Data.settings.druid.restoration.colors.text.dots.pandemic, _sunfireCount)
					sunfireTime = string.format("|c%s%.1f|r", TRB.Data.settings.druid.restoration.colors.text.dots.pandemic, TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].sunfireRemaining)
				end
			else
				sunfireCount = string.format("|c%s%.0f|r", TRB.Data.settings.druid.restoration.colors.text.dots.down, _sunfireCount)
				sunfireTime = string.format("|c%s%.1f|r", TRB.Data.settings.druid.restoration.colors.text.dots.down, 0)
			end

			if TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid] ~= nil and TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].moonfire then
				if TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].moonfireRemaining > TRB.Data.spells.moonfire.pandemicTime then
					moonfireCount = string.format("|c%s%.0f|r", TRB.Data.settings.druid.restoration.colors.text.dots.up, _moonfireCount)
					moonfireTime = string.format("|c%s%.1f|r", TRB.Data.settings.druid.restoration.colors.text.dots.up, TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].moonfireRemaining)
				else
					moonfireCount = string.format("|c%s%.0f|r", TRB.Data.settings.druid.restoration.colors.text.dots.pandemic, _moonfireCount)
					moonfireTime = string.format("|c%s%.1f|r", TRB.Data.settings.druid.restoration.colors.text.dots.pandemic, TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].moonfireRemaining)
				end
			else
				moonfireCount = string.format("|c%s%.0f|r", TRB.Data.settings.druid.restoration.colors.text.dots.down, _moonfireCount)
				moonfireTime = string.format("|c%s%.1f|r", TRB.Data.settings.druid.restoration.colors.text.dots.down, 0)
			end
		else
			sunfireTime = string.format("%.1f", _sunfireTime)
			moonfireTime = string.format("%.1f", _moonfireTime)
		end



		----------

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
			sunfireCount = _sunfireCount or 0,
			moonfireCount = _moonfireCount or 0
		}


		local lookup = TRB.Data.lookup or {}
		lookup["#efflorescence"] = TRB.Data.spells.efflorescence.icon
		lookup["#incarnation"] = TRB.Data.spells.incarnationTreeOfLife.icon
		lookup["#clearcasting"] = TRB.Data.spells.clearcasting.icon
		lookup["#sunfire"] = TRB.Data.spells.sunfire.icon
		lookup["#moonfire"] = TRB.Data.spells.moonfire.icon
		lookup["#innervate"] = TRB.Data.spells.innervate.icon
		lookup["#mr"] = TRB.Data.spells.moltenRadiance.icon
		lookup["#moltenRadiance"] = TRB.Data.spells.moltenRadiance.icon
		lookup["#mtt"] = TRB.Data.spells.manaTideTotem.icon
		lookup["#manaTideTotem"] = TRB.Data.spells.manaTideTotem.icon
		lookup["#soh"] = TRB.Data.spells.symbolOfHope.icon
		lookup["#symbolOfHope"] = TRB.Data.spells.symbolOfHope.icon
		lookup["#amp"] = TRB.Data.spells.aeratedManaPotionRank1.icon
		lookup["#aeratedManaPotion"] = TRB.Data.spells.aeratedManaPotionRank1.icon
		lookup["#poff"] = TRB.Data.spells.potionOfFrozenFocusRank1.icon
		lookup["#potionOfFrozenFocus"] = TRB.Data.spells.potionOfFrozenFocusRank1.icon
		lookup["#pocc"] = TRB.Data.spells.potionOfChilledClarity.icon
		lookup["#potionOfChilledClarity"] = TRB.Data.spells.potionOfChilledClarity.icon
		lookup["#reforestation"] = TRB.Data.spells.reforestation.icon
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
		lookup["$efflorescenceTime"] = efflorescenceTime
		lookup["$clearcastingTime"] = clearcastingTime
		lookup["$sohMana"] = sohMana
		lookup["$sohTime"] = sohTime
		lookup["$sohTicks"] = sohTicks
		lookup["$innervateMana"] = innervateMana
		lookup["$innervateTime"] = innervateTime
		lookup["$sunfireCount"] = sunfireCount
		lookup["$sunfireTime"] = sunfireTime
		lookup["$moonfireCount"] = moonfireCount
		lookup["$moonfireTime"] = moonfireTime
		lookup["$incarnationTime"] = incarnationTime
		lookup["$reforestationStacks"] = reforestationStacks
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
		lookupLogic["$potionOfChilledClarityMana"] = _potionOfChilledClarityMana
		lookupLogic["$potionOfChilledClarityTime"] = _potionOfChilledClarityTime
		lookupLogic["$potionCooldown"] = potionCooldown
		lookupLogic["$potionCooldownSeconds"] = potionCooldown
		lookupLogic["$efflorescenceTime"] = _efflorescenceTime
		lookupLogic["$clearcastingTime"] = _clearcastingTime
		lookupLogic["$sunfireCount"] = _sunfireCount
		lookupLogic["$sunfireTime"] = _sunfireTime
		lookupLogic["$moonfireCount"] = _moonfireCount
		lookupLogic["$moonfireTime"] = _moonfireTime
		lookupLogic["$incarnationTime"] = _incarnationTime
		lookupLogic["$reforestationStacks"] = reforestationStacks
		TRB.Data.lookupLogic = lookupLogic
	end

	local function FillSnapshotDataCasting_Balance(spell)
		local currentTime = GetTime()
		TRB.Data.snapshot.casting.startTime = currentTime
		TRB.Data.snapshot.casting.resourceRaw = spell.astralPower
		TRB.Data.snapshot.casting.resourceFinal = spell.astralPower
		TRB.Data.snapshot.casting.spellId = spell.id
		TRB.Data.snapshot.casting.icon = spell.icon
	end	

	local function UpdateCastingResourceFinal()
		TRB.Data.snapshot.casting.resourceFinal = CalculateAbilityResourceValue(TRB.Data.snapshot.casting.resourceRaw)
	end

	local function UpdateCastingResourceFinal_Restoration()
		-- Do nothing for now
		TRB.Data.snapshot.casting.resourceFinal = TRB.Data.snapshot.casting.resourceRaw * TRB.Data.snapshot.innervate.modifier * TRB.Data.snapshot.potionOfChilledClarity.modifier
	end

	local function CastingSpell()
		local specId = GetSpecialization()
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
					--See druid implementation for handling channeled spells
				else
					if currentSpellId == TRB.Data.spells.wrath.id then
						FillSnapshotDataCasting_Balance(TRB.Data.spells.wrath)
						if TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.wildSurges) then
							TRB.Data.snapshot.casting.resourceFinal = TRB.Data.snapshot.casting.resourceFinal + TRB.Data.spells.wildSurges.modifier
						end
						if TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.soulOfTheForest) and TRB.Data.spells.eclipseSolar.isActive then
							TRB.Data.snapshot.casting.resourceFinal = TRB.Data.snapshot.casting.resourceFinal * (1 + TRB.Data.spells.soulOfTheForest.modifier.wrath)
						end
					elseif currentSpellId == TRB.Data.spells.starfire.id then
						FillSnapshotDataCasting_Balance(TRB.Data.spells.starfire)
						if TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.wildSurges) then
							TRB.Data.snapshot.casting.resourceFinal = TRB.Data.snapshot.casting.resourceFinal + TRB.Data.spells.wildSurges.modifier
						end
						--TODO: Track how many targets were hit by the last Starfire to guess how much bonus AP you'll get?
						--TRB.Data.snapshot.casting.resourceFinal = TRB.Data.snapshot.casting.resourceFinal * (1 + TRB.Data.spells.soulOfTheForest.modifier.wrath)
						--Warrior of Elune logic would go here if it didn't make it instant cast!
					elseif currentSpellId == TRB.Data.spells.sunfire.id then
						FillSnapshotDataCasting_Balance(TRB.Data.spells.sunfire)
					elseif currentSpellId == TRB.Data.spells.moonfire.id then
						FillSnapshotDataCasting_Balance(TRB.Data.spells.moonfire)
					elseif currentSpellId == TRB.Data.spells.stellarFlare.id then
						FillSnapshotDataCasting_Balance(TRB.Data.spells.stellarFlare)
					elseif currentSpellId == TRB.Data.spells.newMoon.id then
						FillSnapshotDataCasting_Balance(TRB.Data.spells.newMoon)
					elseif currentSpellId == TRB.Data.spells.halfMoon.id then
						FillSnapshotDataCasting_Balance(TRB.Data.spells.halfMoon)
					elseif currentSpellId == TRB.Data.spells.fullMoon.id then
						FillSnapshotDataCasting_Balance(TRB.Data.spells.fullMoon)
					else
						TRB.Functions.Character:ResetCastingSnapshotData()
						return false
					end
				end
				return true
			elseif specId == 2 then
				if currentSpellName == nil then
					TRB.Functions.Character:ResetCastingSnapshotData()
					return false
					--See druid implementation for handling channeled spells
				else
					TRB.Functions.Character:ResetCastingSnapshotData()
					return false
				end
			elseif specId == 4 then
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

	local function UpdateFuryOfElune()
		if TRB.Data.snapshot.furyOfElune.isActive then
			local currentTime = GetTime()
			if TRB.Data.snapshot.furyOfElune.startTime == nil or currentTime > (TRB.Data.snapshot.furyOfElune.startTime + TRB.Data.spells.furyOfElune.duration) then
				TRB.Data.snapshot.furyOfElune.ticksRemaining = 0
				TRB.Data.snapshot.furyOfElune.startTime = nil
				TRB.Data.snapshot.furyOfElune.astralPower = 0
				TRB.Data.snapshot.furyOfElune.isActive = false
			end
		end
	end

	local function UpdateSunderedFirmament()
		if TRB.Data.snapshot.sunderedFirmament.isActive then
			local currentTime = GetTime()
			if TRB.Data.snapshot.sunderedFirmament.startTime == nil or currentTime > (TRB.Data.snapshot.sunderedFirmament.startTime + TRB.Data.spells.sunderedFirmament.duration) then
				TRB.Data.snapshot.sunderedFirmament.ticksRemaining = 0
				TRB.Data.snapshot.sunderedFirmament.startTime = nil
				TRB.Data.snapshot.sunderedFirmament.astralPower = 0
				TRB.Data.snapshot.sunderedFirmament.isActive = false
			end
		end
	end

	local function CalculateIncomingComboPointsForEffect(spell, buffSnapshot, cpSnapshot)
		local currentTime = GetTime()
		local remainingTime = TRB.Functions.Spell:GetRemainingTime(buffSnapshot)

		if remainingTime > 0 then
			local untilNextTick = spell.tickRate - (currentTime - cpSnapshot.lastTick)
			local totalCps = TRB.Functions.Number:RoundTo(remainingTime / spell.tickRate, 0, "ceil", true) or 0

			if buffSnapshot.endTime < currentTime then
				totalCps = 1
				untilNextTick = 0
			elseif untilNextTick < 0 then
				totalCps = totalCps + 1
				untilNextTick = 0
			end

			cpSnapshot.ticks = totalCps
			cpSnapshot.nextTick = currentTime + untilNextTick
			cpSnapshot.untilNextTick = untilNextTick
		elseif cpSnapshot.lastTick ~= nil and buffSnapshot.endTime ~= nil then
			if (currentTime - buffSnapshot.endTime) < 0.2 then
				cpSnapshot.lastTick = nil
				cpSnapshot.ticks = 0
				cpSnapshot.nextTick = nil
				cpSnapshot.untilNextTick = 0
			end
		else
			buffSnapshot.duration = 0
			buffSnapshot.endTime = nil
			buffSnapshot.spellId = nil
			cpSnapshot.lastTick = nil
			cpSnapshot.ticks = 0
			cpSnapshot.nextTick = nil
			cpSnapshot.untilNextTick = 0
		end
	end

	local function UpdatePredatorRevealed()
		CalculateIncomingComboPointsForEffect(TRB.Data.spells.predatorRevealed, TRB.Data.snapshot.predatorRevealed, TRB.Data.snapshot.predatorRevealed)
	end

	local function UpdateBerserkIncomingComboPoints()
		if TRB.Data.snapshot.incarnationAvatarOfAshamane.isActive then
			CalculateIncomingComboPointsForEffect(TRB.Data.spells.berserk, TRB.Data.snapshot.incarnationAvatarOfAshamane, TRB.Data.snapshot.berserk)
		else
			CalculateIncomingComboPointsForEffect(TRB.Data.spells.berserk, TRB.Data.snapshot.berserk, TRB.Data.snapshot.berserk)
		end
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
			TRB.Data.snapshot.innervate.mana = TRB.Data.snapshot.innervate.remainingTime * TRB.Data.snapshot.manaRegen * (1-TRB.Data.snapshot.innervate.modifier)
		end
		
		if TRB.Data.snapshot.innervate.startTime ~= nil and currentTime > (TRB.Data.snapshot.innervate.startTime + TRB.Data.snapshot.innervate.duration) then
			TRB.Data.snapshot.innervate.startTime = nil
			TRB.Data.snapshot.innervate.duration = 0
			TRB.Data.snapshot.innervate.remainingTime = 0
		else
			TRB.Data.snapshot.innervate.remainingTime = GetInnervateRemainingTime()
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
		TRB.Functions.Character:UpdateSnapshot()
	end

	local function UpdateSnapshot_Balance()
		UpdateSnapshot()

		local currentTime = GetTime()

		local rattleTheStarsModifier = TRB.Data.snapshot.rattleTheStars.stacks * TRB.Data.spells.rattleTheStars.modifier
		local incarnationChosenOfEluneStarfallModifier = 0
		local incarnationChosenOfEluneStarsurgeModifier = 0

		if TRB.Data.snapshot.incarnationChosenOfElune.isActive and TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.elunesGuidance) then
			incarnationChosenOfEluneStarfallModifier = TRB.Data.spells.elunesGuidance.modifierStarfall
			incarnationChosenOfEluneStarsurgeModifier = TRB.Data.spells.elunesGuidance.modifierStarsurge
		end

		TRB.Data.character.starsurgeThreshold = (-TRB.Data.spells.starsurge.astralPower + incarnationChosenOfEluneStarsurgeModifier) * (1+rattleTheStarsModifier)
		TRB.Data.character.starfallThreshold = (-TRB.Data.spells.starfall.astralPower + incarnationChosenOfEluneStarfallModifier) * (1+rattleTheStarsModifier)

		TRB.Data.snapshot.moonkinForm.isActive = select(10, TRB.Functions.Aura:FindBuffById(TRB.Data.spells.moonkinForm.id))

		UpdateFuryOfElune()
		UpdateSunderedFirmament()
		GetCurrentMoonSpell()

		_, _, _, _, _, TRB.Data.snapshot.celestialAlignment.endTime, _, _, _, TRB.Data.snapshot.celestialAlignment.spellId = TRB.Functions.Aura:FindBuffById(TRB.Data.spells.celestialAlignment.id)
		_, _, _, _, _, TRB.Data.snapshot.incarnationChosenOfElune.endTime, _, _, _, TRB.Data.snapshot.incarnationChosenOfElune.spellId = TRB.Functions.Aura:FindBuffById(TRB.Data.spells.incarnationChosenOfElune.id)
		_, _, _, _, _, TRB.Data.snapshot.eclipseSolar.endTime, _, _, _, TRB.Data.snapshot.eclipseSolar.spellId = TRB.Functions.Aura:FindBuffById(TRB.Data.spells.eclipseSolar.id)
		_, _, _, _, _, TRB.Data.snapshot.eclipseLunar.endTime, _, _, _, TRB.Data.snapshot.eclipseLunar.spellId = TRB.Functions.Aura:FindBuffById(TRB.Data.spells.eclipseLunar.id)

		if TRB.Data.snapshot.targetData.currentTargetGuid ~= nil and TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid] then
			if TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].sunfire then
				local expiration = select(6, TRB.Functions.Aura:FindDebuffById(TRB.Data.spells.sunfire.id, "target", "player"))
			
				if expiration ~= nil then
					TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].sunfireRemaining = expiration - currentTime
				end
			end

			if TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].moonfire then
				local expiration = select(6, TRB.Functions.Aura:FindDebuffById(TRB.Data.spells.moonfire.id, "target", "player"))
			
				if expiration ~= nil then
					TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].moonfireRemaining = expiration - currentTime
				end
			end

			if TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].stellarFlare then
				local expiration = select(6, TRB.Functions.Aura:FindDebuffById(TRB.Data.spells.stellarFlare.id, "target", "player"))
			
				if expiration ~= nil then
					TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].stellarFlareRemaining = expiration - currentTime
				end
			end
		end

---@diagnostic disable-next-line: redundant-parameter, cast-local-type
		TRB.Data.snapshot.newMoon.charges, TRB.Data.snapshot.newMoon.maxCharges, TRB.Data.snapshot.newMoon.startTime, TRB.Data.snapshot.newMoon.duration, _ = GetSpellCharges(TRB.Data.spells.newMoon.id)

		if TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.primordialArcanicPulsar) then
			TRB.Data.snapshot.primordialArcanicPulsar.currentAstralPower = select(16, TRB.Functions.Aura:FindBuffById(TRB.Data.spells.primordialArcanicPulsar.id))
		end
	end

	local function UpdateSnapshot_Feral()
		UpdateSnapshot()
		local currentTime = GetTime()
		UpdateBerserkIncomingComboPoints()
		UpdatePredatorRevealed()
		
		if TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.incarnationAvatarOfAshamane) then
			-- Incarnation: King of the Jungle doesn't show up in-game as a combat log event. Check for it manually instead.
			local _, _, _, _, incDuration, incEndTime, _, _, _, incSpellId = TRB.Functions.Aura:FindBuffById(TRB.Data.spells.incarnationAvatarOfAshamane.id)
			if incDuration ~= nil then			
				TRB.Data.snapshot.incarnationAvatarOfAshamane.isActive = true
				TRB.Data.snapshot.incarnationAvatarOfAshamane.duration = incDuration
				TRB.Data.snapshot.incarnationAvatarOfAshamane.endTime = incEndTime
				TRB.Data.snapshot.incarnationAvatarOfAshamane.spellId = incSpellId
			else
				TRB.Data.snapshot.incarnationAvatarOfAshamane.isActive = false
				TRB.Data.snapshot.incarnationAvatarOfAshamane.spellId = nil
				TRB.Data.snapshot.incarnationAvatarOfAshamane.duration = 0
				TRB.Data.snapshot.incarnationAvatarOfAshamane.endTime = nil
			end
		end

		TRB.Data.snapshot.snapshots.rip = GetCurrentSnapshot(TRB.Data.spells.rip.bonuses)
		TRB.Data.snapshot.snapshots.rake = GetCurrentSnapshot(TRB.Data.spells.rake.bonuses)
		TRB.Data.snapshot.snapshots.thrash = GetCurrentSnapshot(TRB.Data.spells.thrash.bonuses)
		TRB.Data.snapshot.snapshots.moonfire = GetCurrentSnapshot(TRB.Data.spells.moonfire.bonuses)

		if TRB.Data.snapshot.maim.startTime ~= nil and currentTime > (TRB.Data.snapshot.maim.startTime + TRB.Data.snapshot.maim.duration) then
			TRB.Data.snapshot.maim.startTime = nil
			TRB.Data.snapshot.maim.duration = 0
		end

		if TRB.Data.snapshot.feralFrenzy.startTime ~= nil and currentTime > (TRB.Data.snapshot.feralFrenzy.startTime + TRB.Data.snapshot.feralFrenzy.duration) then
			TRB.Data.snapshot.feralFrenzy.startTime = nil
			TRB.Data.snapshot.feralFrenzy.duration = 0
		end

---@diagnostic disable-next-line: redundant-parameter
		_, _, TRB.Data.snapshot.clearcasting.stacks, _, TRB.Data.snapshot.clearcasting.duration, TRB.Data.snapshot.clearcasting.endTime, _, _, _, TRB.Data.snapshot.clearcasting.spellId = TRB.Functions.Aura:FindBuffById(TRB.Data.spells.clearcasting.id)
		TRB.Data.snapshot.clearcasting.remainingTime = GetClearcastingRemainingTime()
		
		if TRB.Data.snapshot.clearcasting.endTimeLeeway ~= nil and TRB.Data.snapshot.clearcasting.endTimeLeeway < currentTime then
			TRB.Data.snapshot.clearcasting.endTimeLeeway = nil
		end

		if TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.brutalSlash) then
---@diagnostic disable-next-line: redundant-parameter, cast-local-type
			TRB.Data.snapshot.brutalSlash.charges, TRB.Data.snapshot.brutalSlash.maxCharges, TRB.Data.snapshot.brutalSlash.startTime, TRB.Data.snapshot.brutalSlash.duration, _ = GetSpellCharges(TRB.Data.spells.brutalSlash.id)
		end
		
		if TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.bloodtalons) then
---@diagnostic disable-next-line: redundant-parameter
			_, _, TRB.Data.snapshot.bloodtalons.stacks, _, TRB.Data.snapshot.bloodtalons.duration, TRB.Data.snapshot.bloodtalons.endTime, _, _, _, TRB.Data.snapshot.bloodtalons.spellId = TRB.Functions.Aura:FindBuffById(TRB.Data.spells.bloodtalons.id)
			TRB.Data.snapshot.bloodtalons.remainingTime = GetBloodtalonsRemainingTime()
			
			if TRB.Data.snapshot.bloodtalons.endTimeLeeway ~= nil and TRB.Data.snapshot.bloodtalons.endTimeLeeway < currentTime then
				TRB.Data.snapshot.bloodtalons.endTimeLeeway = nil
			end
		end

		if TRB.Data.snapshot.suddenAmbush.endTimeLeeway ~= nil and TRB.Data.snapshot.suddenAmbush.endTimeLeeway < currentTime then
			TRB.Data.snapshot.suddenAmbush.endTimeLeeway = nil
		end

---@diagnostic disable-next-line: cast-local-type
		TRB.Data.snapshot.tigersFury.cooldown.startTime, TRB.Data.snapshot.tigersFury.cooldown.duration, _, _ = GetSpellCooldown(TRB.Data.spells.tigersFury.id)
		
		if TRB.Data.snapshot.targetData.currentTargetGuid ~= nil and TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid] then
			if TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].rip then
				local expiration = select(6, TRB.Functions.Aura:FindDebuffById(TRB.Data.spells.rip.id, "target", "player"))
			
				if expiration ~= nil then
					TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].ripRemaining = expiration - currentTime
				end
			end
			
			if TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].rake then
				local expiration = select(6, TRB.Functions.Aura:FindDebuffById(TRB.Data.spells.rake.id, "target", "player"))
			
				if expiration ~= nil then
					TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].rakeRemaining = expiration - currentTime
				end
			end
			
			if TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].thrash then
				local expiration = select(6, TRB.Functions.Aura:FindDebuffById(TRB.Data.spells.thrash.id, "target", "player"))
			
				if expiration ~= nil then
					TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].thrashRemaining = expiration - currentTime
				end
			end

			if TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].moonfire then
				local expiration = select(6, TRB.Functions.Aura:FindDebuffById(TRB.Data.spells.moonfire.id, "target", "player"))
			
				if expiration ~= nil then
					TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].moonfireRemaining = expiration - currentTime
				end
			end
		end
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
			if TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].sunfire then
				local expiration = select(6, TRB.Functions.Aura:FindDebuffById(TRB.Data.spells.sunfire.id, "target", "player"))
			
				if expiration ~= nil then
					TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].sunfireRemaining = expiration - currentTime
				end
			end

			if TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].moonfire then
				local expiration = select(6, TRB.Functions.Aura:FindDebuffById(TRB.Data.spells.moonfire.id, "target", "player"))
			
				if expiration ~= nil then
					TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].moonfireRemaining = expiration - currentTime
				end
			end
		end

		TRB.Data.snapshot.clearcasting.remainingTime = GetClearcastingRemainingTime()
		_, _, _, _, _, TRB.Data.snapshot.incarnationTreeOfLife.endTime, _, _, _, TRB.Data.snapshot.incarnationTreeOfLife.spellId = TRB.Functions.Aura:FindBuffById(TRB.Data.spells.incarnationTreeOfLife.id)
		_, _, TRB.Data.snapshot.reforestation.stacks, _, _, _, _, _, _, _ = TRB.Functions.Aura:FindBuffById(TRB.Data.spells.reforestation.id)
	end

	local function UpdateResourceBar()
		local currentTime = GetTime()
		local refreshText = false
		local specId = GetSpecialization()
		local coreSettings = TRB.Data.settings.core
		local classSettings = TRB.Data.settings.druid

		if specId == 1 then
			local specSettings = classSettings.balance
			UpdateSnapshot_Balance()

			TRB.Functions.Bar:SetPositionOnPersonalResourceDisplay(specSettings, TRB.Frames.barContainerFrame)

			if TRB.Data.snapshot.isTracking then
				TRB.Functions.Bar:HideResourceBar()

				if specSettings.displayBar.neverShow == false then
					refreshText = true
					local affectingCombat = UnitAffectingCombat("player")
					local passiveBarValue = 0
					local castingBarValue = 0
					local currentResource = TRB.Data.snapshot.resource / TRB.Data.resourceFactor
					local flashBar = false

					if specSettings.colors.bar.overcapEnabled and TRB.Functions.Class:IsValidVariableForSpec("$overcap") and TRB.Functions.Class:IsValidVariableForSpec("$inCombat") then
						barBorderFrame:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.borderOvercap, true))

						if specSettings.audio.overcap.enabled and TRB.Data.snapshot.audio.overcapCue == false then
							TRB.Data.snapshot.audio.overcapCue = true
							---@diagnostic disable-next-line: redundant-parameter
							PlaySoundFile(specSettings.audio.overcap.sound, coreSettings.audio.channel.channel)
						end
					else
						barBorderFrame:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(specSettings.colors.bar.border, true))
						TRB.Data.snapshot.audio.overcapCue = false
					end

					TRB.Functions.Bar:SetValue(specSettings, resourceFrame, currentResource)

					if CastingSpell() and specSettings.bar.showCasting then
						castingBarValue = currentResource + TRB.Data.snapshot.casting.resourceFinal
					else
						castingBarValue = currentResource
					end

					TRB.Functions.Bar:SetValue(specSettings, castingFrame, castingBarValue)

					if specSettings.bar.showPassive then
						passiveBarValue = currentResource + TRB.Data.snapshot.casting.resourceFinal + TRB.Data.snapshot.furyOfElune.astralPower + TRB.Data.snapshot.sunderedFirmament.astralPower

						if TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.naturesBalance) then
							if affectingCombat then
								passiveBarValue = passiveBarValue + TRB.Data.spells.naturesBalance.astralPower
							elseif currentResource < 50 then
								passiveBarValue = passiveBarValue + TRB.Data.spells.naturesBalance.outOfCombatAstralPower
							end
						end

						if TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.naturesBalance) and (affectingCombat or (not affectingCombat and currentResource < 50)) then

						else
							passiveBarValue = currentResource + TRB.Data.snapshot.casting.resourceFinal + TRB.Data.snapshot.furyOfElune.astralPower + TRB.Data.snapshot.sunderedFirmament.astralPower
						end
					else
						passiveBarValue = castingBarValue
					end

					TRB.Functions.Bar:SetValue(specSettings, passiveFrame, passiveBarValue)

					local pairOffset = 0
					for k, v in pairs(TRB.Data.spells) do
						local spell = TRB.Data.spells[k]
						if spell ~= nil and spell.id ~= nil and spell.astralPower ~= nil and spell.astralPower < 0 and spell.thresholdId ~= nil and spell.settingKey ~= nil then
							pairOffset = (spell.thresholdId - 1) * 3
							local resourceAmount = spell.astralPower * (1 + (TRB.Data.snapshot.rattleTheStars.stacks * TRB.Data.spells.rattleTheStars.modifier))
							TRB.Functions.Threshold:RepositionThreshold(specSettings, resourceFrame.thresholds[spell.thresholdId], resourceFrame, specSettings.thresholds.width, -resourceAmount, TRB.Data.character.maxResource)

							local showThreshold = true
							local thresholdColor = specSettings.colors.threshold.over
							local frameLevel = TRB.Data.constants.frameLevels.thresholdOver
							
							if spell.isSnowflake then -- These are special snowflakes that we need to handle manually
								if spell.settingKey == TRB.Data.spells.starsurge.settingKey then
									local redrawThreshold = false

									if TRB.Data.snapshot.incarnationChosenOfElune.isActive and TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.elunesGuidance) then
										resourceAmount = resourceAmount - TRB.Data.spells.elunesGuidance.modifierStarsurge
										redrawThreshold = true
									end

									if TRB.Data.snapshot.touchTheCosmos.isActive then
										resourceAmount = resourceAmount - TRB.Data.spells.touchTheCosmos.astralPowerMod
										redrawThreshold = true
									end

									if redrawThreshold then
										TRB.Functions.Threshold:RepositionThreshold(specSettings, resourceFrame.thresholds[spell.thresholdId], resourceFrame, specSettings.thresholds.width, -resourceAmount, TRB.Data.character.maxResource)
									end
									
									if spell.isTalent and not TRB.Functions.Talent:IsTalentActive(spell) then -- Talent not selected
										showThreshold = false
									elseif TRB.Data.snapshot.starweaversWeft.isActive then
										thresholdColor = specSettings.colors.threshold.over
									elseif currentResource >= TRB.Data.character.starsurgeThreshold then
										thresholdColor = specSettings.colors.threshold.over
									else
										thresholdColor = specSettings.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
									
									if showThreshold then
										if TRB.Data.snapshot.starweaversWeft.isActive and specSettings.audio.starweaversReady.enabled and TRB.Data.snapshot.audio.playedstarweaverCue == false then
											TRB.Data.snapshot.audio.playedstarweaverCue = true
											TRB.Data.snapshot.audio.playedSfCue = true
					---@diagnostic disable-next-line: redundant-parameter
											PlaySoundFile(specSettings.audio.starweaverProc.sound, coreSettings.audio.channel.channel)
										elseif specSettings.audio.ssReady.enabled and TRB.Data.snapshot.audio.playedSsCue == false then
											TRB.Data.snapshot.audio.playedSsCue = true
					---@diagnostic disable-next-line: redundant-parameter
											PlaySoundFile(specSettings.audio.ssReady.sound, coreSettings.audio.channel.channel)
										end
									else
										TRB.Data.snapshot.audio.playedSsCue = false
										TRB.Data.snapshot.audio.playedstarweaverCue = false
									end
								elseif spell.settingKey == TRB.Data.spells.starsurge2.settingKey then
									local redrawThreshold = false
									local touchTheCosmosMod = 0
									if TRB.Data.snapshot.incarnationChosenOfElune.isActive and TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.elunesGuidance) then
										resourceAmount = resourceAmount - (TRB.Data.spells.elunesGuidance.modifierStarsurge * 2)
										redrawThreshold = true
									end

									if TRB.Data.snapshot.touchTheCosmos.isActive then
										resourceAmount = resourceAmount - TRB.Data.spells.touchTheCosmos.astralPowerMod
										redrawThreshold = true
										touchTheCosmosMod = TRB.Data.spells.touchTheCosmos.astralPowerMod
									end

									if redrawThreshold then
										TRB.Functions.Threshold:RepositionThreshold(specSettings, resourceFrame.thresholds[spell.thresholdId], resourceFrame, specSettings.thresholds.width, -resourceAmount, TRB.Data.character.maxResource)
									end

									if spell.isTalent and not TRB.Functions.Talent:IsTalentActive(spell) then -- Talent not selected
										showThreshold = false
									elseif -resourceAmount >= TRB.Data.character.maxResource then
										showThreshold = false
									elseif specSettings.thresholds.starsurgeThresholdOnlyOverShow and
										   -(TRB.Data.character.starsurgeThreshold - touchTheCosmosMod) > currentResource then
										showThreshold = false
									elseif currentResource >= -resourceAmount then
										thresholdColor = specSettings.colors.threshold.over
									else
										thresholdColor = specSettings.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								elseif spell.settingKey == TRB.Data.spells.starsurge3.settingKey then
									local redrawThreshold = false
									local touchTheCosmosMod = 0
									if TRB.Data.snapshot.incarnationChosenOfElune.isActive and TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.elunesGuidance) then
										resourceAmount = resourceAmount - (TRB.Data.spells.elunesGuidance.modifierStarsurge * 3)
										redrawThreshold = true
									end

									if TRB.Data.snapshot.touchTheCosmos.isActive then
										resourceAmount = resourceAmount - TRB.Data.spells.touchTheCosmos.astralPowerMod
										redrawThreshold = true
										touchTheCosmosMod = TRB.Data.spells.touchTheCosmos.astralPowerMod
									end

									if redrawThreshold then	
										TRB.Functions.Threshold:RepositionThreshold(specSettings, resourceFrame.thresholds[spell.thresholdId], resourceFrame, specSettings.thresholds.width, -resourceAmount, TRB.Data.character.maxResource)
									end

									if spell.isTalent and not TRB.Functions.Talent:IsTalentActive(spell) then -- Talent not selected
										showThreshold = false
									elseif -resourceAmount >= TRB.Data.character.maxResource then
										showThreshold = false
									elseif specSettings.thresholds.starsurgeThresholdOnlyOverShow and
										   -((TRB.Data.character.starsurgeThreshold * 2) - touchTheCosmosMod) > currentResource then
										showThreshold = false
									elseif currentResource >= -resourceAmount then
										thresholdColor = specSettings.colors.threshold.over
									else
										thresholdColor = specSettings.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								elseif spell.id == TRB.Data.spells.starfall.id then
									local redrawThreshold = false
									if TRB.Data.snapshot.incarnationChosenOfElune.isActive and TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.elunesGuidance) then
										resourceAmount = resourceAmount - TRB.Data.spells.elunesGuidance.modifierStarfall
										redrawThreshold = true
									end

									if TRB.Data.snapshot.touchTheCosmos.isActive then
										resourceAmount = resourceAmount - TRB.Data.spells.touchTheCosmos.astralPowerMod
										redrawThreshold = true
									end

									if redrawThreshold then										
										TRB.Functions.Threshold:RepositionThreshold(specSettings, resourceFrame.thresholds[spell.thresholdId], resourceFrame, specSettings.thresholds.width, -resourceAmount, TRB.Data.character.maxResource)
									end

									if spell.isTalent and not TRB.Functions.Talent:IsTalentActive(spell) then -- Talent not selected
										showThreshold = false
									elseif currentResource >= TRB.Data.character.starfallThreshold then
										if TRB.Data.snapshot.starfall.isActive and (TRB.Data.snapshot.starfall.endTime - currentTime) > (TRB.Data.character.pandemicModifier * TRB.Data.spells.starfall.pandemicTime) then
											thresholdColor = specSettings.colors.threshold.starfallPandemic
										else
											thresholdColor = specSettings.colors.threshold.over
										end
									else
										thresholdColor = specSettings.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end

									if showThreshold then
										if TRB.Data.snapshot.starweaversWarp.isActive and specSettings.audio.starweaversReady.enabled and TRB.Data.snapshot.audio.playedstarweaverCue == false then
											TRB.Data.snapshot.audio.playedstarweaverCue = true
											TRB.Data.snapshot.audio.playedSfCue = true
											---@diagnostic disable-next-line: redundant-parameter
											PlaySoundFile(specSettings.audio.starweaverProc.sound, coreSettings.audio.channel.channel)
										elseif specSettings.audio.sfReady.enabled and TRB.Data.snapshot.audio.playedSfCue == false then
											TRB.Data.snapshot.audio.playedSfCue = true
											---@diagnostic disable-next-line: redundant-parameter
											PlaySoundFile(specSettings.audio.sfReady.sound, coreSettings.audio.channel.channel)
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

							TRB.Functions.Threshold:AdjustThresholdDisplay(spell, resourceFrame.thresholds[spell.thresholdId], showThreshold, frameLevel, pairOffset, thresholdColor, TRB.Data.snapshot[spell.settingKey], specSettings)
						end
					end
					
					if specSettings.colors.bar.flashSsEnabled and currentResource >= TRB.Data.character.starsurgeThreshold then
						flashBar = true
					end

					local barColor = specSettings.colors.bar.base

					if not TRB.Data.snapshot.moonkinForm.isActive and affectingCombat then
						barColor = specSettings.colors.bar.moonkinFormMissing
						if specSettings.colors.bar.flashEnabled then
							flashBar = true
						end
					elseif TRB.Data.snapshot.eclipseSolar.isActive or TRB.Data.spells.eclipseLunar.isActive or TRB.Data.spells.celestialAlignment.isActive or TRB.Data.spells.incarnationChosenOfElune.isActive then
						local timeThreshold = 0
						local useEndOfEclipseColor = false

						if specSettings.endOfEclipse.enabled and (not specSettings.endOfEclipse.celestialAlignmentOnly or TRB.Data.snapshot.celestialAlignment.isActive or TRB.Data.spells.incarnationChosenOfElune.isActive) then
							useEndOfEclipseColor = true
							if specSettings.endOfEclipse.mode == "gcd" then
								local gcd = TRB.Functions.Character:GetCurrentGCDTime()
								timeThreshold = gcd * specSettings.endOfEclipse.gcdsMax
							elseif specSettings.endOfEclipse.mode == "time" then
								timeThreshold = specSettings.endOfEclipse.timeMax
							end
						end

						if useEndOfEclipseColor and GetEclipseRemainingTime() <= timeThreshold then
							barColor = specSettings.colors.bar.eclipse1GCD
						else
							if TRB.Data.snapshot.celestialAlignment.isActive or TRB.Data.spells.incarnationChosenOfElune.isActive or (TRB.Data.spells.eclipseSolar.isActive and TRB.Data.spells.eclipseLunar.isActive) then
								barColor = specSettings.colors.bar.celestial
							elseif TRB.Data.snapshot.eclipseSolar.isActive then
								barColor = specSettings.colors.bar.solar
							else
								barColor = specSettings.colors.bar.lunar
							end
						end
					end

					resourceFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(barColor, true))
					barContainerFrame:SetAlpha(1.0)

					if flashBar then
						TRB.Functions.Bar:PulseFrame(barContainerFrame, specSettings.colors.bar.flashAlpha, specSettings.colors.bar.flashPeriod)
					end
				end
			end
			TRB.Functions.BarText:UpdateResourceBarText(specSettings, refreshText)
		elseif specId == 2 then
			local specSettings = classSettings.feral
			UpdateSnapshot_Feral()

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
							local energyAmount = CalculateAbilityResourceValue(spell.energy, true, spell.relentlessPredator)
							TRB.Functions.Threshold:RepositionThreshold(specSettings, resourceFrame.thresholds[spell.thresholdId], resourceFrame, specSettings.thresholds.width, -energyAmount, TRB.Data.character.maxResource)

							local showThreshold = true
							local thresholdColor = specSettings.colors.threshold.over
							local frameLevel = TRB.Data.constants.frameLevels.thresholdOver
							local overrideOk = true

							if spell.hasSnapshot and specSettings.thresholds.bleedColors then
								showThreshold = true
								overrideOk = false

								if UnitIsDeadOrGhost("target") or not UnitCanAttack("player", "target") or TRB.Data.snapshot.targetData.currentTargetGuid == nil then
									thresholdColor = specSettings.colors.text.dots.same
									frameLevel = TRB.Data.constants.frameLevels.thresholdBleedSame
								elseif TRB.Data.snapshot.targetData.targets == nil or TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid] == nil then
									thresholdColor = specSettings.colors.text.dots.down
									frameLevel = TRB.Data.constants.frameLevels.thresholdBleedDownOrWorse
								else
									local snapshotValue = (TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid][spell.settingKey .. "Snapshot"] or 1) / TRB.Data.snapshot.snapshots[spell.settingKey]
									local bleedUp = TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid][spell.settingKey]
									
									if not bleedUp then
										thresholdColor = specSettings.colors.text.dots.down
										frameLevel = TRB.Data.constants.frameLevels.thresholdBleedDownOrWorse
									elseif snapshotValue > 1 then
										thresholdColor = specSettings.colors.text.dots.better
										frameLevel = TRB.Data.constants.frameLevels.thresholdBleedBetter
									elseif snapshotValue < 1 then
										thresholdColor = specSettings.colors.text.dots.worse
										frameLevel = TRB.Data.constants.frameLevels.thresholdBleedDownOrWorse
									else
										thresholdColor = specSettings.colors.text.dots.same
										frameLevel = TRB.Data.constants.frameLevels.thresholdBleedSame
									end
								end

								if spell.id == TRB.Data.spells.moonfire.id and not TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.lunarInspiration) then
									showThreshold = false
								end
							elseif spell.isClearcasting and TRB.Data.snapshot.clearcasting.stacks ~= nil and TRB.Data.snapshot.clearcasting.stacks > 0 then
								if spell.id == TRB.Data.spells.brutalSlash.id then
									if not TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.brutalSlash) then
										showThreshold = false
									elseif TRB.Data.snapshot.brutalSlash.charges > 0 then
										thresholdColor = specSettings.colors.threshold.over
									else
										thresholdColor = specSettings.colors.threshold.unusable
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
									end
								elseif spell.id == TRB.Data.spells.swipe.id then
									if TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.brutalSlash) then
										showThreshold = false
									else
										thresholdColor = specSettings.colors.threshold.over
									end
								else
									thresholdColor = specSettings.colors.threshold.over
								end
							elseif spell.isSnowflake then -- These are special snowflakes that we need to handle manually
								if spell.id == TRB.Data.spells.ferociousBite.id and spell.settingKey == "ferociousBite" then
									TRB.Functions.Threshold:RepositionThreshold(specSettings, resourceFrame.thresholds[spell.thresholdId], resourceFrame, specSettings.thresholds.width, math.min(math.max(-energyAmount, TRB.Data.snapshot.resource), -CalculateAbilityResourceValue(TRB.Data.spells.ferociousBite.energyMax, true, true)), TRB.Data.character.maxResource)
									
									if TRB.Data.snapshot.resource >= -energyAmount or TRB.Data.snapshot.apexPredatorsCraving.isActive == true then
										thresholdColor = specSettings.colors.threshold.over
									else
										thresholdColor = specSettings.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								elseif spell.id == TRB.Data.spells.ferociousBiteMinimum.id and spell.settingKey == "ferociousBiteMinimum" then
									TRB.Functions.Threshold:RepositionThreshold(specSettings, resourceFrame.thresholds[spell.thresholdId], resourceFrame, specSettings.thresholds.width, -energyAmount, TRB.Data.character.maxResource)
									
									if TRB.Data.snapshot.resource >= -energyAmount or TRB.Data.snapshot.apexPredatorsCraving.isActive == true then
										thresholdColor = specSettings.colors.threshold.over
									else
										thresholdColor = specSettings.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								elseif spell.id == TRB.Data.spells.ferociousBiteMaximum.id and spell.settingKey == "ferociousBiteMaximum" then
									if TRB.Data.snapshot.resource >= -energyAmount or TRB.Data.snapshot.apexPredatorsCraving.isActive == true then
										thresholdColor = specSettings.colors.threshold.over
									else
										thresholdColor = specSettings.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								elseif spell.id == TRB.Data.spells.moonfire.id then
									if not TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.lunarInspiration) then
										showThreshold = false
									elseif TRB.Data.snapshot.resource >= -energyAmount then
										thresholdColor = specSettings.colors.threshold.over
									else
										thresholdColor = specSettings.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								elseif spell.id == TRB.Data.spells.swipe.id then
									if TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.brutalSlash) then
										showThreshold = false
									elseif TRB.Data.snapshot.resource >= -energyAmount then
										thresholdColor = specSettings.colors.threshold.over
									else
										thresholdColor = specSettings.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								elseif spell.id == TRB.Data.spells.brutalSlash.id then
									if not TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.brutalSlash) then
										showThreshold = false
									elseif TRB.Data.snapshot.brutalSlash.charges == 0 then
										thresholdColor = specSettings.colors.threshold.unusable
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
									elseif TRB.Data.snapshot.resource >= -energyAmount then
										thresholdColor = specSettings.colors.threshold.over
									else
										thresholdColor = specSettings.colors.threshold.under
										frameLevel = TRB.Data.constants.frameLevels.thresholdUnder
									end
								elseif spell.id == TRB.Data.spells.bloodtalons.id then
									--TODO: How much energy is required to start this? Then do we move it?
								end
							elseif spell.isTalent and not TRB.Functions.Talent:IsTalentActive(spell) then -- Talent not selected
								showThreshold = false
							elseif spell.isPvp and (not TRB.Data.character.isPvp or not TRB.Functions.Talent:IsTalentActive(spell)) then
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

							if overrideOk == true and spell.comboPoints == true and TRB.Data.snapshot.resource2 == 0 then
								thresholdColor = specSettings.colors.threshold.unusable
								frameLevel = TRB.Data.constants.frameLevels.thresholdUnusable
							end

							TRB.Functions.Threshold:AdjustThresholdDisplay(spell, resourceFrame.thresholds[spell.thresholdId], showThreshold, frameLevel, pairOffset, thresholdColor, TRB.Data.snapshot[spell.settingKey], specSettings)
						end
						pairOffset = pairOffset + 3
					end

					local barColor = specSettings.colors.bar.base
					
					if GetClearcastingRemainingTime() > 0 then
						barColor = specSettings.colors.bar.clearcasting
					end

					if (TRB.Data.snapshot.resource2 == 5 and TRB.Data.snapshot.resource >= -CalculateAbilityResourceValue(TRB.Data.spells.ferociousBiteMaximum.energy, true, true)) then
						barColor = specSettings.colors.bar.maxBite
					end

					if TRB.Data.snapshot.apexPredatorsCraving.isActive == true then
						barColor = specSettings.colors.bar.apexPredator
					end

					local barBorderColor = specSettings.colors.bar.border
					if IsStealthed() then
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
					
					local cpBackgroundRed, cpBackgroundGreen, cpBackgroundBlue, cpBackgroundAlpha = TRB.Functions.Color:GetRGBAFromString(specSettings.colors.comboPoints.background, true)

					local berserkTotalCps = TRB.Data.snapshot.berserk.ticks
					local berserkNextTick = TRB.Data.spells.berserk.tickRate - TRB.Data.snapshot.berserk.untilNextTick

					local prTime = GetPredatorRevealedRemainingTime()
					local prTotalCps = TRB.Data.snapshot.predatorRevealed.ticks
					local prNextTick = TRB.Data.spells.predatorRevealed.tickRate - TRB.Data.snapshot.predatorRevealed.untilNextTick

					local prTickShown = 0
					local berserkTickShown = 0

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
							if specSettings.comboPoints.generation and berserkTickShown == 0 and berserkTotalCps > 0 and (TRB.Data.snapshot.berserk.untilNextTick <= TRB.Data.snapshot.predatorRevealed.untilNextTick or prTickShown > 0 or prTotalCps == 0) then
								TRB.Functions.Bar:SetValue(specSettings, TRB.Frames.resource2Frames[x].resourceFrame, berserkNextTick * 1000, TRB.Data.spells.berserk.tickRate * 1000)
								berserkTickShown = 1

								if (specSettings.comboPoints.sameColor and TRB.Data.snapshot.resource2 == (TRB.Data.character.maxResource2 - 1)) or (not specSettings.comboPoints.sameColor and x == (TRB.Data.character.maxResource2 - 1)) then
									cpColor = specSettings.colors.comboPoints.penultimate
								elseif (specSettings.comboPoints.sameColor and TRB.Data.snapshot.resource2 == (TRB.Data.character.maxResource2)) or x == TRB.Data.character.maxResource2 then
									cpColor = specSettings.colors.comboPoints.final
								end
							elseif specSettings.comboPoints.generation and prTime ~= nil and prTime > 0 and x <= (TRB.Data.snapshot.resource2 + prTotalCps) then
								if x == TRB.Data.snapshot.resource2 + berserkTickShown + 1 then
									TRB.Functions.Bar:SetValue(specSettings, TRB.Frames.resource2Frames[x].resourceFrame, prNextTick * 1000, TRB.Data.spells.predatorRevealed.tickRate * 1000)
								else
									TRB.Functions.Bar:SetValue(specSettings, TRB.Frames.resource2Frames[x].resourceFrame, 0, 1)
								end

								prTickShown = prTickShown + 1

								if specSettings.comboPoints.spec.predatorRevealedColor and x > TRB.Data.snapshot.resource2 and x <= (TRB.Data.snapshot.resource2 + prTotalCps) then
									cpBorderColor = specSettings.colors.comboPoints.predatorRevealed
	
									if specSettings.comboPoints.sameColor ~= true then
										cpColor = specSettings.colors.comboPoints.predatorRevealed
									end
	
									if not specSettings.comboPoints.consistentUnfilledColor then
										cpBR, cpBG, cpBB, _ = TRB.Functions.Color:GetRGBAFromString(specSettings.colors.comboPoints.predatorRevealed, true)
									end
								elseif (specSettings.comboPoints.sameColor and TRB.Data.snapshot.resource2 == (TRB.Data.character.maxResource2 - 1)) or (not specSettings.comboPoints.sameColor and x == (TRB.Data.character.maxResource2 - 1)) then
									cpColor = specSettings.colors.comboPoints.penultimate
								elseif (specSettings.comboPoints.sameColor and TRB.Data.snapshot.resource2 == (TRB.Data.character.maxResource2)) or x == TRB.Data.character.maxResource2 then
									cpColor = specSettings.colors.comboPoints.final
								end
							else
								TRB.Functions.Bar:SetValue(specSettings, TRB.Frames.resource2Frames[x].resourceFrame, 0, 1)
							end
						end

						TRB.Frames.resource2Frames[x].resourceFrame:SetStatusBarColor(TRB.Functions.Color:GetRGBAFromString(cpColor, true))
						TRB.Frames.resource2Frames[x].borderFrame:SetBackdropBorderColor(TRB.Functions.Color:GetRGBAFromString(cpBorderColor, true))
						TRB.Frames.resource2Frames[x].containerFrame:SetBackdropColor(cpBR, cpBG, cpBB, cpBackgroundAlpha)
					end
				end
			end
			TRB.Functions.BarText:UpdateResourceBarText(specSettings, refreshText)
		elseif specId == 4 then
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
		
					local resourceBarColor = specSettings.colors.bar.base

					local affectingCombat = UnitAffectingCombat("player")

					if affectingCombat and TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.efflorescence) and GetEfflorescenceRemainingTime() == 0 then
						resourceBarColor = specSettings.colors.bar.noEfflorescence
					elseif GetClearcastingRemainingTime() > 0 then
						resourceBarColor = specSettings.colors.bar.clearcasting
					elseif GetIncarnationTreeOfLifeRemainingTime() > 0 and (TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.cenariusGuidance) or GetClearcastingRemainingTime() == 0) then
						local timeThreshold = 0
						local useEndOfIncarnationColor = false

						if specSettings.endOfIncarnation.enabled then
							useEndOfIncarnationColor = true
							if specSettings.endOfIncarnation.mode == "gcd" then
								local gcd = TRB.Functions.Character:GetCurrentGCDTime()
								timeThreshold = gcd * specSettings.endOfIncarnation.gcdsMax
							elseif specSettings.endOfIncarnation.mode == "time" then
								timeThreshold = specSettings.endOfIncarnation.timeMax
							end
						end

						if useEndOfIncarnationColor and GetIncarnationTreeOfLifeRemainingTime() <= timeThreshold then
							resourceBarColor = specSettings.colors.bar.incarnationEnd
						else
							resourceBarColor = specSettings.colors.bar.incarnation
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
				if specId == 4 and TRB.Data.barConstructedForSpec == "restoration" then -- Let's check raid effect mana stuff
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
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Gained buff or refreshed
							local modifier = 0
							TRB.Data.snapshot.innervate.isActive = true
							_, _, _, _, TRB.Data.snapshot.innervate.duration, TRB.Data.snapshot.innervate.endTime, _, _, _, TRB.Data.snapshot.innervate.spellId, _, _, _, _, _, modifier  = TRB.Functions.Aura:FindBuffById(TRB.Data.spells.innervate.id)
							TRB.Data.snapshot.innervate.modifier = (100 + modifier) / 100
							TRB.Data.snapshot.audio.innervateCue = false
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							TRB.Data.snapshot.innervate.isActive = false
							TRB.Data.snapshot.innervate.spellId = nil
							TRB.Data.snapshot.innervate.duration = 0
							TRB.Data.snapshot.innervate.endTime = nil
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
				if specId == 1 and TRB.Data.barConstructedForSpec == "balance" then
					if spellId == TRB.Data.spells.sunfire.id then
						if TRB.Functions.Class:InitializeTarget(destGUID) then
							if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Sunfire Applied to Target
								TRB.Data.snapshot.targetData.targets[destGUID].sunfire = true
								if type == "SPELL_AURA_APPLIED" then
									TRB.Data.snapshot.targetData.sunfire = TRB.Data.snapshot.targetData.sunfire + 1
								end
								triggerUpdate = true
							elseif type == "SPELL_AURA_REMOVED" then
								TRB.Data.snapshot.targetData.targets[destGUID].sunfire = false
								TRB.Data.snapshot.targetData.targets[destGUID].sunfireRemaining = 0
								TRB.Data.snapshot.targetData.sunfire = TRB.Data.snapshot.targetData.sunfire - 1
								triggerUpdate = true
							--elseif type == "SPELL_PERIODIC_DAMAGE" then
							end
						end
					elseif spellId == TRB.Data.spells.moonfire.id then
						if TRB.Functions.Class:InitializeTarget(destGUID) then
							if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Moonfire Applied to Target
								TRB.Data.snapshot.targetData.targets[destGUID].moonfire = true
								if type == "SPELL_AURA_APPLIED" then
									TRB.Data.snapshot.targetData.moonfire = TRB.Data.snapshot.targetData.moonfire + 1
								end
								triggerUpdate = true
							elseif type == "SPELL_AURA_REMOVED" then
								TRB.Data.snapshot.targetData.targets[destGUID].moonfire = false
								TRB.Data.snapshot.targetData.targets[destGUID].moonfireRemaining = 0
								TRB.Data.snapshot.targetData.moonfire = TRB.Data.snapshot.targetData.moonfire - 1
								triggerUpdate = true
							--elseif type == "SPELL_PERIODIC_DAMAGE" then
							end
						end
					elseif spellId == TRB.Data.spells.stellarFlare.id then
						if TRB.Functions.Class:InitializeTarget(destGUID) then
							if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Stellar Flare Applied to Target
								TRB.Data.snapshot.targetData.targets[destGUID].stellarFlare = true
								if type == "SPELL_AURA_APPLIED" then
									TRB.Data.snapshot.targetData.stellarFlare = TRB.Data.snapshot.targetData.stellarFlare + 1
								end
								triggerUpdate = true
							elseif type == "SPELL_AURA_REMOVED" then
								TRB.Data.snapshot.targetData.targets[destGUID].stellarFlare = false
								TRB.Data.snapshot.targetData.targets[destGUID].stellarFlareRemaining = 0
								TRB.Data.snapshot.targetData.stellarFlare = TRB.Data.snapshot.targetData.stellarFlare - 1
								triggerUpdate = true
							--elseif type == "SPELL_PERIODIC_DAMAGE" then
							end
						end
					elseif spellId == TRB.Data.spells.furyOfElune.id then
						if type == "SPELL_AURA_APPLIED" then -- Gain Fury of Elune
							TRB.Data.snapshot.furyOfElune.isActive = true
							TRB.Data.snapshot.furyOfElune.ticksRemaining = TRB.Data.spells.furyOfElune.ticks
							TRB.Data.snapshot.furyOfElune.astralPower = TRB.Data.snapshot.furyOfElune.ticksRemaining * TRB.Data.spells.furyOfElune.astralPower
							TRB.Data.snapshot.furyOfElune.startTime = currentTime
						elseif type == "SPELL_AURA_REMOVED" then
							TRB.Data.snapshot.furyOfElune.isActive = false
							TRB.Data.snapshot.furyOfElune.ticksRemaining = 0
							TRB.Data.snapshot.furyOfElune.astralPower = 0
							TRB.Data.snapshot.furyOfElune.startTime = nil
						elseif type == "SPELL_PERIODIC_ENERGIZE" then
							TRB.Data.snapshot.furyOfElune.ticksRemaining = TRB.Data.snapshot.furyOfElune.ticksRemaining - 1
							TRB.Data.snapshot.furyOfElune.astralPower = TRB.Data.snapshot.furyOfElune.ticksRemaining * TRB.Data.spells.furyOfElune.astralPower
						end
					elseif spellId == TRB.Data.spells.sunderedFirmament.buffId then
						if type == "SPELL_AURA_APPLIED" then -- Gain Sundered Firmament
							TRB.Data.snapshot.sunderedFirmament.isActive = true
							TRB.Data.snapshot.sunderedFirmament.ticksRemaining = TRB.Data.spells.sunderedFirmament.ticks
							TRB.Data.snapshot.sunderedFirmament.astralPower = TRB.Data.snapshot.sunderedFirmament.ticksRemaining * TRB.Data.spells.sunderedFirmament.astralPower
							TRB.Data.snapshot.sunderedFirmament.startTime = currentTime
						elseif type == "SPELL_AURA_REMOVED" then
							TRB.Data.snapshot.sunderedFirmament.isActive = false
							TRB.Data.snapshot.sunderedFirmament.ticksRemaining = 0
							TRB.Data.snapshot.sunderedFirmament.astralPower = 0
							TRB.Data.snapshot.sunderedFirmament.startTime = nil
						elseif type == "SPELL_PERIODIC_ENERGIZE" then
							TRB.Data.snapshot.sunderedFirmament.ticksRemaining = TRB.Data.snapshot.sunderedFirmament.ticksRemaining - 1
							TRB.Data.snapshot.sunderedFirmament.astralPower = TRB.Data.snapshot.sunderedFirmament.ticksRemaining * TRB.Data.spells.sunderedFirmament.astralPower
						end
					elseif spellId == TRB.Data.spells.eclipseSolar.id then
						TRB.Functions.Aura:SnapshotGenericAura(spellId, type, TRB.Data.snapshot.eclipseSolar)
					elseif spellId == TRB.Data.spells.eclipseLunar.id then
						TRB.Functions.Aura:SnapshotGenericAura(spellId, type, TRB.Data.snapshot.eclipseLunar)
					elseif spellId == TRB.Data.spells.celestialAlignment.id then
						TRB.Functions.Aura:SnapshotGenericAura(spellId, type, TRB.Data.snapshot.celestialAlignment)
					elseif spellId == TRB.Data.spells.incarnationChosenOfElune.id then
						TRB.Functions.Aura:SnapshotGenericAura(spellId, type, TRB.Data.snapshot.incarnationChosenOfElune)
					elseif spellId == TRB.Data.spells.starfall.id then
						TRB.Functions.Aura:SnapshotGenericAura(spellId, type, TRB.Data.snapshot.starfall)
					elseif spellId == TRB.Data.spells.starweaversWarp.id then
						TRB.Functions.Aura:SnapshotGenericAura(spellId, type, TRB.Data.snapshot.starweaversWarp)
					elseif spellId == TRB.Data.spells.starweaversWeft.id then
						TRB.Functions.Aura:SnapshotGenericAura(spellId, type, TRB.Data.snapshot.starweaversWeft)
					elseif spellId == TRB.Data.spells.rattleTheStars.buffId then
						TRB.Functions.Aura:SnapshotGenericAura(spellId, type, TRB.Data.snapshot.rattleTheStars)
						TRB.Functions.Class:CheckCharacter()
						triggerUpdate = true
					elseif spellId == TRB.Data.spells.newMoon.id then
						if type == "SPELL_CAST_SUCCESS" then
							TRB.Data.snapshot.newMoon.currentSpellId = TRB.Data.spells.halfMoon.id
							TRB.Data.snapshot.newMoon.currentKey = "halfMoon"
							TRB.Data.snapshot.newMoon.checkAfter = currentTime + 20
						end
					elseif spellId == TRB.Data.spells.halfMoon.id then
						if type == "SPELL_CAST_SUCCESS" then
							TRB.Data.snapshot.newMoon.currentSpellId = TRB.Data.spells.fullMoon.id
							TRB.Data.snapshot.newMoon.currentKey = "fullMoon"
							TRB.Data.snapshot.newMoon.checkAfter = currentTime + 20
						end
					elseif spellId == TRB.Data.spells.fullMoon.id then
						if type == "SPELL_CAST_SUCCESS" then
							-- New Moon doesn't like to behave when we do this
							TRB.Data.snapshot.newMoon.currentSpellId = TRB.Data.spells.newMoon.id
							TRB.Data.snapshot.newMoon.currentKey = "newMoon"
							TRB.Data.snapshot.newMoon.checkAfter = currentTime + 20
---@diagnostic disable-next-line: redundant-parameter
							TRB.Data.spells.newMoon.currentIcon = select(3, GetSpellInfo(202767)) -- Use the old Legion artifact spell ID since New Moon's icon returns incorrect for several seconds after casting Full Moon
						end
					elseif spellId == TRB.Data.spells.touchTheCosmos.id then
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Gained buff or refreshed
							TRB.Data.snapshot.touchTheCosmos.isActive = true
							_, _, _, _, TRB.Data.snapshot.touchTheCosmos.duration, TRB.Data.snapshot.touchTheCosmos.endTime, _, _, _, TRB.Data.snapshot.touchTheCosmos.spellId = TRB.Functions.Aura:FindBuffById(TRB.Data.spells.touchTheCosmos.id)
						elseif type == "SPELL_AURA_REMOVED" then -- Lost buff
							TRB.Data.snapshot.touchTheCosmos.isActive = false
							TRB.Data.snapshot.touchTheCosmos.spellId = nil
							TRB.Data.snapshot.touchTheCosmos.duration = 0
							TRB.Data.snapshot.touchTheCosmos.endTime = nil
						end
					end
				elseif specId == 2 and TRB.Data.barConstructedForSpec == "feral" then
					if spellId == TRB.Data.spells.rip.id then
						if TRB.Functions.Class:InitializeTarget(destGUID) then
							if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Rip Applied to Target
								TRB.Data.snapshot.targetData.targets[destGUID].rip = true
								if type == "SPELL_AURA_APPLIED" then
									TRB.Data.snapshot.targetData.rip = TRB.Data.snapshot.targetData.rip + 1
								end
								TRB.Data.snapshot.targetData.targets[destGUID].ripSnapshot = GetCurrentSnapshot(TRB.Data.spells.rip.bonuses)
								
								if TRB.Data.snapshot.bloodtalons.stacks == 0 then
									TRB.Data.snapshot.bloodtalons.endTimeLeeway = nil
								end
								triggerUpdate = true
							elseif type == "SPELL_AURA_REMOVED" then
								TRB.Data.snapshot.targetData.targets[destGUID].rip = false
								TRB.Data.snapshot.targetData.targets[destGUID].ripRemaining = 0
								TRB.Data.snapshot.targetData.targets[destGUID].ripSnapshot = 0
								TRB.Data.snapshot.targetData.rip = TRB.Data.snapshot.targetData.rip - 1
								triggerUpdate = true
							--elseif type == "SPELL_PERIODIC_DAMAGE" then
							end
						end
					elseif spellId == TRB.Data.spells.rake.id then
						if TRB.Functions.Class:InitializeTarget(destGUID) then
							if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Rake Applied to Target
								TRB.Data.snapshot.targetData.targets[destGUID].rake = true
								if type == "SPELL_AURA_APPLIED" then
									TRB.Data.snapshot.targetData.rake = TRB.Data.snapshot.targetData.rake + 1
								end
								TRB.Data.snapshot.targetData.targets[destGUID].rakeSnapshot = GetCurrentSnapshot(TRB.Data.spells.rake.bonuses)
								TRB.Data.snapshot.suddenAmbush.endTimeLeeway = nil
								triggerUpdate = true
							elseif type == "SPELL_AURA_REMOVED" then
								TRB.Data.snapshot.targetData.targets[destGUID].rake = false
								TRB.Data.snapshot.targetData.targets[destGUID].rakeRemaining = 0
								TRB.Data.snapshot.targetData.targets[destGUID].rakeSnapshot = 0
								TRB.Data.snapshot.targetData.rake = TRB.Data.snapshot.targetData.rake - 1
								triggerUpdate = true
							--elseif type == "SPELL_PERIODIC_DAMAGE" then
							end
						end
					elseif spellId == TRB.Data.spells.thrash.id then
						if TRB.Functions.Class:InitializeTarget(destGUID) then
							if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Thrash Applied to Target
								TRB.Data.snapshot.targetData.targets[destGUID].thrash = true
								if type == "SPELL_AURA_APPLIED" then
									TRB.Data.snapshot.targetData.thrash = TRB.Data.snapshot.targetData.thrash + 1
								end
								TRB.Data.snapshot.targetData.targets[destGUID].thrashSnapshot = GetCurrentSnapshot(TRB.Data.spells.thrash.bonuses)
								
								triggerUpdate = true
							elseif type == "SPELL_AURA_REMOVED" then
								TRB.Data.snapshot.targetData.targets[destGUID].thrash = false
								TRB.Data.snapshot.targetData.targets[destGUID].thrashRemaining = 0
								TRB.Data.snapshot.targetData.targets[destGUID].thrashSnapshot = 0
								TRB.Data.snapshot.targetData.thrash = TRB.Data.snapshot.targetData.thrash - 1
								triggerUpdate = true
							--elseif type == "SPELL_PERIODIC_DAMAGE" then
							end
						end
					elseif spellId == TRB.Data.spells.moonfire.id then
						if TRB.Functions.Class:InitializeTarget(destGUID) then
							if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Moonfire Applied to Target
								TRB.Data.snapshot.targetData.targets[destGUID].moonfire = true
								if type == "SPELL_AURA_APPLIED" then
									TRB.Data.snapshot.targetData.moonfire = TRB.Data.snapshot.targetData.moonfire + 1
								end
								TRB.Data.snapshot.targetData.targets[destGUID].moonfireSnapshot = GetCurrentSnapshot(TRB.Data.spells.moonfire.bonuses)
								triggerUpdate = true
							elseif type == "SPELL_AURA_REMOVED" then
								TRB.Data.snapshot.targetData.targets[destGUID].moonfire = false
								TRB.Data.snapshot.targetData.targets[destGUID].moonfireRemaining = 0
								TRB.Data.snapshot.targetData.targets[destGUID].moonfireSnapshot = 0
								TRB.Data.snapshot.targetData.moonfire = TRB.Data.snapshot.targetData.moonfire - 1
								triggerUpdate = true
							--elseif type == "SPELL_PERIODIC_DAMAGE" then
							end
						end
					elseif spellId == TRB.Data.spells.shadowmeld.id then
						TRB.Functions.Aura:SnapshotGenericAura(spellId, type, TRB.Data.snapshot.shadowmeld, true)
					elseif spellId == TRB.Data.spells.prowl.id or spellId == TRB.Data.spells.prowl.idIncarnation then
						TRB.Functions.Aura:SnapshotGenericAura(spellId, type, TRB.Data.snapshot.prowl, true)
					elseif spellId == TRB.Data.spells.suddenAmbush.id then
						TRB.Functions.Aura:SnapshotGenericAura(spellId, type, TRB.Data.snapshot.suddenAmbush)
						if type == "SPELL_AURA_REMOVED" then
							TRB.Data.snapshot.suddenAmbush.endTimeLeeway = currentTime + 0.1
						end
					elseif spellId == TRB.Data.spells.berserk.id then
						TRB.Functions.Aura:SnapshotGenericAura(spellId, type, TRB.Data.snapshot.berserk)
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" or type == "SPELL_AURA_REMOVED" then
							if type == "SPELL_AURA_APPLIED" then						
								TRB.Data.snapshot.berserk.lastTick = currentTime
							end
							UpdateBerserkIncomingComboPoints()
						end
					elseif spellId == TRB.Data.spells.incarnationAvatarOfAshamane.id then
						TRB.Functions.Aura:SnapshotGenericAura(spellId, type, TRB.Data.snapshot.incarnationAvatarOfAshamane)
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" or type == "SPELL_AURA_REMOVED" then
							if type == "SPELL_AURA_APPLIED" then
								TRB.Data.snapshot.berserk.lastTick = currentTime
							end
							UpdateBerserkIncomingComboPoints()
						end
					elseif spellId == TRB.Data.spells.berserk.energizeId then
						if type == "SPELL_ENERGIZE" then
							TRB.Data.snapshot.berserk.lastTick = currentTime
						end
					elseif spellId == TRB.Data.spells.clearcasting.id then
						TRB.Functions.Aura:SnapshotGenericAura(spellId, type, TRB.Data.snapshot.clearcasting)
					elseif spellId == TRB.Data.spells.tigersFury.id then
						TRB.Functions.Aura:SnapshotGenericAura(spellId, type, TRB.Data.snapshot.tigersFury)
					elseif spellId == TRB.Data.spells.bloodtalons.id then
						TRB.Functions.Aura:SnapshotGenericAura(spellId, type, TRB.Data.snapshot.bloodtalons)
						if type == "SPELL_AURA_REMOVED" then
							TRB.Data.snapshot.bloodtalons.endTimeLeeway = currentTime + 0.1
						end
					elseif spellId == TRB.Data.spells.apexPredatorsCraving.id then
						TRB.Functions.Aura:SnapshotGenericAura(spellId, type, TRB.Data.snapshot.apexPredatorsCraving)
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then
							if TRB.Data.settings.druid.feral.audio.apexPredatorsCraving.enabled then
								---@diagnostic disable-next-line: redundant-parameter
								PlaySoundFile(TRB.Data.settings.druid.feral.audio.apexPredatorsCraving.sound, TRB.Data.settings.core.audio.channel.channel)
							end
						end
					elseif spellId == TRB.Data.spells.predatorRevealed.id then
						TRB.Functions.Aura:SnapshotGenericAura(spellId, type, TRB.Data.snapshot.predatorRevealed)
						if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" or type == "SPELL_AURA_REMOVED" then
							if type == "SPELL_AURA_APPLIED" then
								TRB.Data.snapshot.predatorRevealed.lastTick = currentTime
							end
							UpdatePredatorRevealed()
						end
					elseif spellId == TRB.Data.spells.predatorRevealed.energizeId then
						if type == "SPELL_ENERGIZE" then
							TRB.Data.snapshot.predatorRevealed.lastTick = currentTime
						end
					end
				elseif specId == 4 and TRB.Data.barConstructedForSpec == "restoration" then
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
					elseif spellId == TRB.Data.spells.efflorescence.id then
						if type == "SPELL_CAST_SUCCESS" then
							TRB.Data.snapshot.efflorescence.endTime = currentTime + TRB.Data.spells.efflorescence.duration
						end
					elseif spellId == TRB.Data.spells.sunfire.id then
						if TRB.Functions.Class:InitializeTarget(destGUID) then
							if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Sunfire Applied to Target
								TRB.Data.snapshot.targetData.targets[destGUID].sunfire = true
								if type == "SPELL_AURA_APPLIED" then
									TRB.Data.snapshot.targetData.sunfire = TRB.Data.snapshot.targetData.sunfire + 1
								end
								triggerUpdate = true
							elseif type == "SPELL_AURA_REMOVED" then
								TRB.Data.snapshot.targetData.targets[destGUID].sunfire = false
								TRB.Data.snapshot.targetData.targets[destGUID].sunfireRemaining = 0
								TRB.Data.snapshot.targetData.sunfire = TRB.Data.snapshot.targetData.sunfire - 1
								triggerUpdate = true
							end
						end
					elseif spellId == TRB.Data.spells.moonfire.id then
						if TRB.Functions.Class:InitializeTarget(destGUID) then
							if type == "SPELL_AURA_APPLIED" or type == "SPELL_AURA_REFRESH" then -- Moonfire Applied to Target
								TRB.Data.snapshot.targetData.targets[destGUID].moonfire = true
								if type == "SPELL_AURA_APPLIED" then
									TRB.Data.snapshot.targetData.moonfire = TRB.Data.snapshot.targetData.moonfire + 1
								end
								triggerUpdate = true
							elseif type == "SPELL_AURA_REMOVED" then
								TRB.Data.snapshot.targetData.targets[destGUID].moonfire = false
								TRB.Data.snapshot.targetData.targets[destGUID].moonfireRemaining = 0
								TRB.Data.snapshot.targetData.moonfire = TRB.Data.snapshot.targetData.moonfire - 1
								triggerUpdate = true
							--elseif type == "SPELL_PERIODIC_DAMAGE" then
							end
						end
					elseif spellId == TRB.Data.spells.clearcasting.id then
						TRB.Functions.Aura:SnapshotGenericAura(spellId, type, TRB.Data.snapshot.clearcasting)
					elseif spellId == TRB.Data.spells.incarnationTreeOfLife.id then
						TRB.Functions.Aura:SnapshotGenericAura(spellId, type, TRB.Data.snapshot.incarnationTreeOfLife)
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
			TRB.Functions.Bar:UpdateSanityCheckValues(TRB.Data.settings.druid.balance)
			TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.druid.balance)
			specCache.balance.talents = TRB.Functions.Talent:GetTalents()
			FillSpellData_Balance()
			TRB.Functions.Character:LoadFromSpecializationCache(specCache.balance)
			TRB.Functions.RefreshLookupData = RefreshLookupData_Balance

			if TRB.Data.barConstructedForSpec ~= "balance" then
				TRB.Data.barConstructedForSpec = "balance"
				ConstructResourceBar(specCache.balance.settings)
			end
		elseif specId == 2 then
			TRB.Functions.Bar:UpdateSanityCheckValues(TRB.Data.settings.druid.feral)
			TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.druid.feral)
			specCache.feral.talents = TRB.Functions.Talent:GetTalents()
			FillSpellData_Feral()
			TRB.Functions.Character:LoadFromSpecializationCache(specCache.feral)
			TRB.Functions.RefreshLookupData = RefreshLookupData_Feral

			if TRB.Data.barConstructedForSpec ~= "feral" then
				TRB.Data.barConstructedForSpec = "feral"
				ConstructResourceBar(specCache.feral.settings)
			end
		elseif specId == 4 then
			TRB.Functions.Bar:UpdateSanityCheckValues(TRB.Data.settings.druid.restoration)
			TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.druid.restoration)
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
	resourceFrame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
	resourceFrame:RegisterEvent("TRAIT_CONFIG_UPDATED")
	resourceFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
	resourceFrame:RegisterEvent("PLAYER_LOGOUT") -- Fired when about to log out
	resourceFrame:SetScript("OnEvent", function(self, event, arg1, ...)
		local specId = GetSpecialization() or 0
		if classIndexId == 11 then
			if (event == "ADDON_LOADED" and arg1 == "TwintopInsanityBar") then
				if not TRB.Details.addonData.loaded then
					TRB.Details.addonData.loaded = true

					local settings = TRB.Options.Druid.LoadDefaultSettings()
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
							TRB.Data.settings.druid.balance = TRB.Functions.LibSharedMedia:ValidateLsmValues("Balance Druid", TRB.Data.settings.druid.balance)
							TRB.Data.settings.druid.feral = TRB.Functions.LibSharedMedia:ValidateLsmValues("Feral Druid", TRB.Data.settings.druid.feral)
							TRB.Data.settings.druid.restoration = TRB.Functions.LibSharedMedia:ValidateLsmValues("Restoration Druid", TRB.Data.settings.druid.restoration)
							
							FillSpellData_Balance()
							FillSpellData_Feral()
							FillSpellData_Restoration()

							TRB.Data.barConstructedForSpec = nil
							SwitchSpec()
							TRB.Options.Druid.ConstructOptionsPanel(specCache)
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
		TRB.Data.character.className = "druid"

		if specId == 1 then
			TRB.Data.character.specName = "balance"
---@diagnostic disable-next-line: missing-parameter
			TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.LunarPower)
			GetCurrentMoonSpell()
		elseif specId == 2 then
			TRB.Data.character.specName = "feral"
---@diagnostic disable-next-line: missing-parameter
			TRB.Data.character.maxResource = UnitPowerMax("player", Enum.PowerType.Energy)
---@diagnostic disable-next-line: missing-parameter
			local maxComboPoints = UnitPowerMax("player", Enum.PowerType.ComboPoints)
			local settings = TRB.Data.settings.druid.feral

			if settings ~= nil then
				if maxComboPoints ~= TRB.Data.character.maxResource2 then
					TRB.Data.character.maxResource2 = maxComboPoints
					TRB.Functions.Bar:SetPosition(settings, TRB.Frames.barContainerFrame)
				end
			end

			if TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.circleOfLifeAndDeath) then
				TRB.Data.character.pandemicModifier = TRB.Data.spells.circleOfLifeAndDeath.modifier
			end
		elseif specId == 4 then
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
		if specId == 1 and TRB.Data.settings.core.enabled.druid.balance == true then
			TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.druid.balance)
			TRB.Data.specSupported = true
			TRB.Data.resource = Enum.PowerType.LunarPower
			TRB.Data.resourceFactor = 10
			TRB.Data.resource2 = nil
			TRB.Data.resource2Factor = nil
		elseif specId == 2 and TRB.Data.settings.core.enabled.druid.feral == true then
			TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.druid.feral)
			TRB.Data.specSupported = true
			TRB.Data.resource = Enum.PowerType.Energy
			TRB.Data.resourceFactor = 1
			TRB.Data.resource2 = Enum.PowerType.ComboPoints
			TRB.Data.resource2Factor = 1
		elseif specId == 4 and TRB.Data.settings.core.enabled.druid.restoration then
			TRB.Functions.BarText:IsTtdActive(TRB.Data.settings.druid.restoration)
			TRB.Data.specSupported = true
			TRB.Data.resource = Enum.PowerType.Mana
			TRB.Data.resourceFactor = 1
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
			if not TRB.Data.specSupported or force or GetSpecialization() ~= 1 or (not affectingCombat) and
				(not UnitInVehicle("player")) and (
					(not TRB.Data.settings.druid.balance.displayBar.alwaysShow) and (
						(not TRB.Data.settings.druid.balance.displayBar.notZeroShow) or
						(TRB.Data.settings.druid.balance.displayBar.notZeroShow and
							((not TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.naturesBalance) and TRB.Data.snapshot.resource == 0) or
							(TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.naturesBalance) and (TRB.Data.snapshot.resource / TRB.Data.resourceFactor) >= 50))
						)
					)
				) then
				TRB.Frames.barContainerFrame:Hide()
				TRB.Data.snapshot.isTracking = false
			else
				TRB.Data.snapshot.isTracking = true
				if TRB.Data.settings.druid.balance.displayBar.neverShow == true then
					TRB.Frames.barContainerFrame:Hide()
				else
					TRB.Frames.barContainerFrame:Show()
				end
			end
		elseif specId == 2 then
			if not TRB.Data.specSupported or force or ((not affectingCombat) and
				(not UnitInVehicle("player")) and (
					(not TRB.Data.settings.druid.feral.displayBar.alwaysShow) and (
						(not TRB.Data.settings.druid.feral.displayBar.notZeroShow) or
						(TRB.Data.settings.druid.feral.displayBar.notZeroShow and TRB.Data.snapshot.resource == TRB.Data.character.maxResource)
					)
				)) then
				TRB.Frames.barContainerFrame:Hide()
				TRB.Data.snapshot.isTracking = false
			else
				TRB.Data.snapshot.isTracking = true
				if TRB.Data.settings.druid.feral.displayBar.neverShow == true then
					TRB.Frames.barContainerFrame:Hide()
				else
					TRB.Frames.barContainerFrame:Show()
				end
			end
		elseif specId == 4 then
			if not TRB.Data.specSupported or force or ((not affectingCombat) and
				(not UnitInVehicle("player")) and (
					(not TRB.Data.settings.druid.restoration.displayBar.alwaysShow) and (
						(not TRB.Data.settings.druid.restoration.displayBar.notZeroShow) or
						(TRB.Data.settings.druid.restoration.displayBar.notZeroShow and TRB.Data.snapshot.resource == TRB.Data.character.maxResource)
					)
				)) then
				TRB.Frames.barContainerFrame:Hide()
				TRB.Data.snapshot.isTracking = false
			else
				TRB.Data.snapshot.isTracking = true
				if TRB.Data.settings.druid.restoration.displayBar.neverShow == true then
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
				if specId == 1 then -- Balance
					TRB.Data.snapshot.targetData.targets[guid].sunfire = false
					TRB.Data.snapshot.targetData.targets[guid].sunfireRemaining = 0
					TRB.Data.snapshot.targetData.targets[guid].moonfire = false
					TRB.Data.snapshot.targetData.targets[guid].moonfireRemaining = 0
					TRB.Data.snapshot.targetData.targets[guid].stellarFlare = false
					TRB.Data.snapshot.targetData.targets[guid].stellarFlareRemaining = 0
				elseif specId == 2 then -- Feral
					TRB.Data.snapshot.targetData.targets[guid].rake = false
					TRB.Data.snapshot.targetData.targets[guid].rakeRemaining = 0
					TRB.Data.snapshot.targetData.targets[guid].rakeSnapshot = 0
					TRB.Data.snapshot.targetData.targets[guid].rip = false
					TRB.Data.snapshot.targetData.targets[guid].ripRemaining = 0
					TRB.Data.snapshot.targetData.targets[guid].ripSnapshot = 0
					TRB.Data.snapshot.targetData.targets[guid].thrash = false
					TRB.Data.snapshot.targetData.targets[guid].thrashRemaining = 0
					TRB.Data.snapshot.targetData.targets[guid].thrashSnapshot = 0
					TRB.Data.snapshot.targetData.targets[guid].moonfire = false
					TRB.Data.snapshot.targetData.targets[guid].moonfireRemaining = 0
					TRB.Data.snapshot.targetData.targets[guid].moonfireSnapshot = 0
				elseif specId == 4 then -- Restoration
					TRB.Data.snapshot.targetData.targets[guid].sunfire = false
					TRB.Data.snapshot.targetData.targets[guid].sunfireRemaining = 0
					TRB.Data.snapshot.targetData.targets[guid].moonfire = false
					TRB.Data.snapshot.targetData.targets[guid].moonfireRemaining = 0
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
			settings = TRB.Data.settings.druid.balance
		elseif specId == 2 then
			settings = TRB.Data.settings.druid.feral
		elseif specId == 4 then
			settings = TRB.Data.settings.druid.restoration
		end

		local affectingCombat = UnitAffectingCombat("player")

		if specId == 1 then -- Balance
			if var == "$moonkinForm" then
				if TRB.Data.snapshot.moonkinForm.isActive then
					valid = true
				end
			elseif var == "$eclipse" then
				if TRB.Data.snapshot.eclipseSolar.isActive or TRB.Data.spells.eclipseLunar.isActive or TRB.Data.spells.celestialAlignment.isActive or TRB.Data.spells.incarnationChosenOfElune.isActive then
					valid = true
				end
			elseif var == "$solar" or var == "$eclipseSolar" or var == "$solarEclipse" then
				if TRB.Data.snapshot.eclipseSolar.isActive then
					valid = true
				end
			elseif var == "$lunar" or var == "$eclipseLunar" or var == "$lunarEclipse" then
				if TRB.Data.snapshot.eclipseLunar.isActive then
					valid = true
				end
			elseif var == "$celestialAlignment" then
				if TRB.Data.snapshot.celestialAlignment.isActive or TRB.Data.spells.incarnationChosenOfElune.isActive then
					valid = true
				end
			elseif var == "$eclipseTime" then
				if TRB.Data.snapshot.eclipseSolar.isActive or TRB.Data.spells.eclipseLunar.isActive or TRB.Data.spells.celestialAlignment.isActive or TRB.Data.spells.incarnationChosenOfElune.isActive then
					valid = true
				end
			elseif var == "$resource" or var == "$astralPower" then
				if TRB.Data.snapshot.resource > 0 then
					valid = true
				end
			elseif var == "$resourceMax" or var == "$astralPowerMax" then
				valid = true
			elseif var == "$resourceTotal" or var == "$astralPowerTotal" then
				if TRB.Data.snapshot.resource > 0 or
					(TRB.Data.snapshot.casting.resourceRaw ~= nil and TRB.Data.snapshot.casting.resourceRaw > 0) then
					valid = true
				end
			elseif var == "$resourcePlusCasting" or var == "$astralPowerPlusCasting" then
				if TRB.Data.snapshot.resource > 0 or
					(TRB.Data.snapshot.casting.resourceRaw ~= nil and TRB.Data.snapshot.casting.resourceRaw > 0) then
					valid = true
				end
			elseif var == "$overcap" or var == "$astralPowerOvercap" or var == "$resourceOvercap" then
				local threshold = ((TRB.Data.snapshot.resource / TRB.Data.resourceFactor) + TRB.Data.snapshot.casting.resourceFinal)
				if settings.overcap.mode == "relative" and (TRB.Data.character.maxResource + settings.overcap.relative) < threshold then
					return true
				elseif settings.overcap.mode == "fixed" and settings.overcap.fixed < threshold then
					return true
				end
			elseif var == "$resourcePlusPassive" or var == "$astralPowerPlusPassive" then
				if TRB.Data.snapshot.resource > 0 then
					valid = true
				end
			elseif var == "$casting" then
				if TRB.Data.snapshot.casting.resourceRaw ~= nil and TRB.Data.snapshot.casting.resourceRaw > 0 then
					valid = true
				end
			elseif var == "$passive" then
				if (TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.naturesBalance) and (affectingCombat or (TRB.Data.snapshot.resource / TRB.Data.resourceFactor) < 50)) or TRB.Data.snapshot.furyOfElune.astralPower > 0 or TRB.Data.snapshot.sunderedFirmament.astralPower > 0 then
					valid = true
				end
			elseif var == "$sunfireCount" then
				if TRB.Data.snapshot.targetData.sunfire > 0 then
					valid = true
				end
			elseif var == "$sunfireTime" then
				if not UnitIsDeadOrGhost("target") and
					UnitCanAttack("player", "target") and
					TRB.Data.snapshot.targetData.currentTargetGuid ~= nil and
					TRB.Data.snapshot.targetData.targets ~= nil and
					TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid] ~= nil and
					TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].sunfireRemaining > 0 then
					valid = true
				end
			elseif var == "$moonfireCount" then
				if TRB.Data.snapshot.targetData.moonfire > 0 then
					valid = true
				end
			elseif var == "$moonfireTime" then
				if not UnitIsDeadOrGhost("target") and
					UnitCanAttack("player", "target") and
					TRB.Data.snapshot.targetData.currentTargetGuid ~= nil and
					TRB.Data.snapshot.targetData.targets ~= nil and
					TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid] ~= nil and
					TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].moonfireRemaining > 0 then
					valid = true
				end
			elseif var == "$stellarFlareCount" then
				if TRB.Data.snapshot.targetData.stellarFlare > 0 then
					valid = true
				end
			elseif var == "$stellarFlareTime" then
				if not UnitIsDeadOrGhost("target") and
					UnitCanAttack("player", "target") and
					TRB.Data.snapshot.targetData.currentTargetGuid ~= nil and
					TRB.Data.snapshot.targetData.targets ~= nil and
					TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid] ~= nil and
					TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].stellarFlareRemaining > 0 then
					valid = true
				end
			elseif var == "$talentStellarFlare" then
				if TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.stellarFlare) then
					valid = true
				end
			elseif var == "$foeAstralPower" then
				if TRB.Data.snapshot.furyOfElune.astralPower > 0 then
					valid = true
				end
			elseif var == "$foeTicks" then
				if TRB.Data.snapshot.furyOfElune.remainingTicks > 0 then
					valid = true
				end
			elseif var == "$foeTime" then
				if TRB.Data.snapshot.furyOfElune.startTime ~= nil then
					valid = true
				end
			elseif var == "$sunderedFirmamentAstralPower" then
				if TRB.Data.snapshot.sunderedFirmament.astralPower > 0 then
					valid = true
				end
			elseif var == "$sunderedFirmamentTicks" then
				if TRB.Data.snapshot.sunderedFirmament.remainingTicks > 0 then
					valid = true
				end
			elseif var == "$sunderedFirmamentTime" then
				if TRB.Data.snapshot.sunderedFirmament.startTime ~= nil then
					valid = true
				end				
			elseif var == "$starweaverTime" then
				if TRB.Data.snapshot.starweaversWarp.isActive or TRB.Data.spells.starweaversWarp.isActive  then
					valid = true
				end
			elseif var == "$starweaversWarp" then
				if TRB.Data.snapshot.starweaversWarp.isActive then
					valid = true
				end
			elseif var == "$starweaversWeft" then
				if TRB.Data.snapshot.starweaversWarp.isActive then
					valid = true
				end
			elseif var == "$moonAstralPower" then
				if TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.newMoon) then
					valid = true
				end
			elseif var == "$moonCharges" then
				if TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.newMoon) then
					if TRB.Data.snapshot.newMoon.charges > 0 then
						valid = true
					end
				end
			elseif var == "$moonCooldown" then
				if TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.newMoon) then
					if TRB.Data.snapshot.newMoon.cooldown > 0 then
						valid = true
					end
				end
			elseif var == "$moonCooldownTotal" then
				if TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.newMoon) then
					if TRB.Data.snapshot.newMoon.charges < TRB.Data.snapshot.newMoon.maxCharges then
						valid = true
					end
				end
			elseif var == "$pulsarCollected" then
				if TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.primordialArcanicPulsar) then
					valid = true
				end
			elseif var == "$pulsarCollectedPercent" then
				if TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.primordialArcanicPulsar) then
					valid = true
				end
			elseif var == "$pulsarRemaining" then
				if TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.primordialArcanicPulsar) then
					valid = true
				end
			elseif var == "$pulsarRemainingPercent" then
				if TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.primordialArcanicPulsar) then
					valid = true
				end
			elseif var == "$pulsarStarsurgeCount" then
				if TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.primordialArcanicPulsar) then
					valid = true
				end
			elseif var == "$pulsarStarfallCount" then
				if TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.primordialArcanicPulsar) then
					valid = true
				end
			elseif var == "$pulsarNextStarsurge" then
				if TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.primordialArcanicPulsar) and
					(((TRB.Data.spells.primordialArcanicPulsar.maxAstralPower or 0) - (TRB.Data.snapshot.primordialArcanicPulsar.currentAstralPower or 0)) <= TRB.Data.character.starsurgeThreshold) then
					valid = true
				end
			elseif var == "$pulsarNextStarfall" then
				if TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.primordialArcanicPulsar) and
					(((TRB.Data.spells.primordialArcanicPulsar.maxAstralPower or 0) - (TRB.Data.snapshot.primordialArcanicPulsar.currentAstralPower or 0)) <= TRB.Data.character.starfallThreshold) then
					valid = true
				end
			end
		elseif specId == 2 then -- Feral
			if var == "$resource" or var == "$energy" then
				if TRB.Data.snapshot.resource > 0 then
					valid = true
				end
			elseif var == "$resourceMax" or var == "$energyMax" then
				valid = true
			elseif var == "$resourceTotal" or var == "$energyTotal" then
				if TRB.Data.snapshot.resource > 0 or
					(TRB.Data.snapshot.casting.resourceRaw ~= nil and TRB.Data.snapshot.casting.resourceRaw > 0) then
					valid = true
				end
			elseif var == "$resourcePlusCasting" or var == "$energyPlusCasting" then
				if TRB.Data.snapshot.resource > 0 or
					(TRB.Data.snapshot.casting.resourceRaw ~= nil and TRB.Data.snapshot.casting.resourceRaw > 0) then
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
			elseif var == "$comboPoints" then
				valid = true
			elseif var == "$comboPointsMax" then
				valid = true
			elseif var == "$ripCount" then
				if TRB.Data.snapshot.targetData.rip > 0 then
					valid = true
				end
			elseif var == "$ripCurrent" then
				valid = true
			elseif var == "$ripTime" then
				if not UnitIsDeadOrGhost("target") and
					UnitCanAttack("player", "target") and
					TRB.Data.snapshot.targetData.currentTargetGuid ~= nil and
					TRB.Data.snapshot.targetData.targets ~= nil and
					TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid] ~= nil and
					TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].ripRemaining > 0 then
					valid = true
				end
			elseif var == "$ripPercent" then
				if not UnitIsDeadOrGhost("target") and
					UnitCanAttack("player", "target") and
					TRB.Data.snapshot.targetData.currentTargetGuid ~= nil and
					TRB.Data.snapshot.targetData.targets ~= nil and
					TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid] ~= nil and
					TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].ripSnapshot > 0 then
					valid = true
				end
			elseif var == "$ripSnapshot" then
				if not UnitIsDeadOrGhost("target") and
					UnitCanAttack("player", "target") and
					TRB.Data.snapshot.targetData.currentTargetGuid ~= nil and
					TRB.Data.snapshot.targetData.targets ~= nil and
					TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid] ~= nil and
					TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].ripSnapshot > 0 then
					valid = true
				end
			elseif var == "$rakeCount" then
				if TRB.Data.snapshot.targetData.rake > 0 then
					valid = true
				end
			elseif var == "$rakeCurrent" then
				valid = true
			elseif var == "$rakeTime" then
				if not UnitIsDeadOrGhost("target") and
					UnitCanAttack("player", "target") and
					TRB.Data.snapshot.targetData.currentTargetGuid ~= nil and
					TRB.Data.snapshot.targetData.targets ~= nil and
					TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid] ~= nil and
					TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].rakeRemaining > 0 then
					valid = true
				end
			elseif var == "$rakePercent" then
				if not UnitIsDeadOrGhost("target") and
					UnitCanAttack("player", "target") and
					TRB.Data.snapshot.targetData.currentTargetGuid ~= nil and
					TRB.Data.snapshot.targetData.targets ~= nil and
					TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid] ~= nil and
					TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].rakeSnapshot > 0 then
					valid = true
				end
			elseif var == "$rakeSnapshot" then
				if not UnitIsDeadOrGhost("target") and
					UnitCanAttack("player", "target") and
					TRB.Data.snapshot.targetData.currentTargetGuid ~= nil and
					TRB.Data.snapshot.targetData.targets ~= nil and
					TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid] ~= nil and
					TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].rakeSnapshot > 0 then
					valid = true
				end
			elseif var == "$thrashCount" then
				if TRB.Data.snapshot.targetData.thrash > 0 then
					valid = true
				end
			elseif var == "$thrashCurrent" then
				valid = true
			elseif var == "$thrashTime" then
				if not UnitIsDeadOrGhost("target") and
					UnitCanAttack("player", "target") and
					TRB.Data.snapshot.targetData.currentTargetGuid ~= nil and
					TRB.Data.snapshot.targetData.targets ~= nil and
					TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid] ~= nil and
					TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].thrashRemaining > 0 then
					valid = true
				end
			elseif var == "$thrashPercent" then
				if not UnitIsDeadOrGhost("target") and
					UnitCanAttack("player", "target") and
					TRB.Data.snapshot.targetData.currentTargetGuid ~= nil and
					TRB.Data.snapshot.targetData.targets ~= nil and
					TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid] ~= nil and
					TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].thrashSnapshot > 0 then
					valid = true
				end
			elseif var == "$thrashSnapshot" then
				if not UnitIsDeadOrGhost("target") and
					UnitCanAttack("player", "target") and
					TRB.Data.snapshot.targetData.currentTargetGuid ~= nil and
					TRB.Data.snapshot.targetData.targets ~= nil and
					TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid] ~= nil and
					TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].thrashSnapshot > 0 then
					valid = true
				end
			elseif var == "$moonfireCount" then
				if TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.lunarInspiration) == true and TRB.Data.snapshot.targetData.moonfire > 0 then
					valid = true
				end
			elseif var == "$moonfireCurrent" then
				if TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.lunarInspiration) == true then
					valid = true
				end
			elseif var == "$moonfireTime" then
				if TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.lunarInspiration) == true and
					not UnitIsDeadOrGhost("target") and
					UnitCanAttack("player", "target") and
					TRB.Data.snapshot.targetData.currentTargetGuid ~= nil and
					TRB.Data.snapshot.targetData.targets ~= nil and
					TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid] ~= nil and
					TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].moonfireRemaining > 0 then
					valid = true
				end
			elseif var == "$moonfirePercent" then
				if TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.lunarInspiration) == true and
					not UnitIsDeadOrGhost("target") and
					UnitCanAttack("player", "target") and
					TRB.Data.snapshot.targetData.currentTargetGuid ~= nil and
					TRB.Data.snapshot.targetData.targets ~= nil and
					TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid] ~= nil and
					TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].moonfireSnapshot > 0 then
					valid = true
				end
			elseif var == "$moonfireSnapshot" then
				if TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.lunarInspiration) == true and
					not UnitIsDeadOrGhost("target") and
					UnitCanAttack("player", "target") and
					TRB.Data.snapshot.targetData.currentTargetGuid ~= nil and
					TRB.Data.snapshot.targetData.targets ~= nil and
					TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid] ~= nil and
					TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].moonfireSnapshot > 0 then
					valid = true
				end
			elseif var == "$lunarInspiration" then
				if TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.lunarInspiration) == true then
					valid = true
				end
			elseif var == "$brutalSlashCharges" then
				if TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.brutalSlash) then
					if TRB.Data.snapshot.brutalSlash.charges > 0 then
						valid = true
					end
				end
			elseif var == "$brutalSlashCooldown" then
				if TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.brutalSlash) then
					if TRB.Data.snapshot.brutalSlash.cooldown > 0 then
						valid = true
					end
				end
			elseif var == "$brutalSlashCooldownTotal" then
				if TRB.Functions.Talent:IsTalentActive(TRB.Data.spells.brutalSlash) then
					if TRB.Data.snapshot.brutalSlash.charges < TRB.Data.snapshot.brutalSlash.maxCharges then
						valid = true
					end
				end
			elseif var == "$bloodtalonsStacks" then
				if TRB.Data.snapshot.bloodtalons.stacks > 0 then
					valid = true
				end
			elseif var == "$bloodtalonsTime" then
				if TRB.Data.snapshot.bloodtalons.remainingTime > 0 then
					valid = true
				end
			elseif var == "$suddenAmbushTime" then
				if GetSuddenAmbushRemainingTime() > 0 then
					valid = true
				end
			elseif var == "$clearcastingStacks" then
				if TRB.Data.snapshot.clearcasting.stacks > 0 then
					valid = true
				end
			elseif var == "$clearcastingTime" then
				if TRB.Data.snapshot.clearcastingTime.remainingTime > 0 then
					valid = true
				end
			elseif var == "$berserkTime" or var == "$incarnationTime" then
				if GetBerserkRemainingTime() > 0 then
					valid = true
				end
			elseif var == "$apexPredatorsCravingTime" then
				if GetApexPredatorsCravingRemainingTime() > 0 then
					valid = true
				end
			elseif var == "$tigersFuryTime" then
				if TRB.Data.snapshot.tigersFury.duration > 0 then
					valid = true
				end
			elseif var == "$tigersFuryCooldownTime" then
				if TRB.Data.snapshot.tigersFury.cooldown.duration > 0 then
					valid = true
				end
			elseif var == "$predatorRevealedTime" then
				if TRB.Data.snapshot.predatorRevealed.endTime ~= nil then
					valid = true
				end
			elseif var == "$predatorRevealedTicks" then
				if TRB.Data.snapshot.predatorRevealed.endTime ~= nil then
					valid = true
				end
			elseif var == "$predatorRevealedTickTime" then
				if TRB.Data.snapshot.predatorRevealed.endTime ~= nil then
					valid = true
				end
			elseif var == "$inStealth" then
				if IsStealthed() then
					valid = true
				end
			end
		elseif specId == 4 then --Restoration
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
			elseif var == "$efflorescenceTime" then
				if GetEfflorescenceRemainingTime() > 0 then
					valid = true
				end
			elseif var == "$sunfireCount" then
				if TRB.Data.snapshot.targetData.sunfire > 0 then
					valid = true
				end
			elseif var == "$clearcastingTime" then
				if TRB.Data.snapshot.clearcasting.remainingTime > 0 then
					valid = true
				end
			elseif var == "$sunfireTime" then
				if not UnitIsDeadOrGhost("target") and
					UnitCanAttack("player", "target") and
					TRB.Data.snapshot.targetData.currentTargetGuid ~= nil and
					TRB.Data.snapshot.targetData.targets ~= nil and
					TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid] ~= nil and
					TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].sunfireRemaining > 0 then
					valid = true
				end
			elseif var == "$moonfireCount" then
				if TRB.Data.snapshot.targetData.moonfire > 0 then
					valid = true
				end
			elseif var == "$moonfireTime" then
				if not UnitIsDeadOrGhost("target") and
					UnitCanAttack("player", "target") and
					TRB.Data.snapshot.targetData.currentTargetGuid ~= nil and
					TRB.Data.snapshot.targetData.targets ~= nil and
					TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid] ~= nil and
					TRB.Data.snapshot.targetData.targets[TRB.Data.snapshot.targetData.currentTargetGuid].moonfireRemaining > 0 then
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
			elseif var == "$incarnationTime" then
				if GetIncarnationTreeOfLifeRemainingTime() > 0 then
					valid = true
				end
			elseif var == "$reforestationStacks" then
				if TRB.Data.snapshot.reforestation.stacks > 0 then
					valid = true
				end
			end
		else
			valid = false
		end

		return valid
	end

	--HACK to fix FPS
	local updateRateLimit = 0

	function TRB.Functions.Class:TriggerResourceBarUpdates()
		local specId = GetSpecialization()
		if specId ~= 1 and specId ~= 2 and specId ~= 4 then
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