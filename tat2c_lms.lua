--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("ObjectiveConquest")

function CompileUnitTables()

   unittablemaster1 = {}   
   unittablemaster2 = {}   
      
   if SetHeroClass then
   
      holdsetheroclass = SetHeroClass
      
      SetHeroClass = function(...)
         if arg[1] == 1 then
            table.insert (unittablemaster1, {unitteam = arg[1], unitclass = arg[2]})
         elseif arg[1] == 2 then
            table.insert (unittablemaster2, {unitteam = arg[1], unitclass = arg[2]})            
         end   

      holdsetheroclass(unpack(arg))   
         
      end
         
   end

   if AddUnitClass then
   
      holdaddunitclass = AddUnitClass   
      
      AddUnitClass = function(...)
         if arg[1] == 1 then
            table.insert (unittablemaster1, {unitteam = arg[1], unitclass = arg[2]})
         elseif arg[1] == 2 then
            table.insert (unittablemaster2, {unitteam = arg[1], unitclass = arg[2]})            
         end
         
      holdaddunitclass(unpack(arg))   
         
      end
         
   end

end

function ScriptPostLoad()
    --This defines the CPs.  These need to happen first
    SetProperty("FDL-2", "IsLocked", 1)
    cp1 = CommandPost:New{name = "cp1"}
    cp2 = CommandPost:New{name = "cp2"}
    cp3 = CommandPost:New{name = "cp3"}
	cp6 = CommandPost:New{name = "cp6"}
	cp7 = CommandPost:New{name = "cp7"}
	cp8 = CommandPost:New{name = "cp8"}

	win = CreateTimer("win")
	SetTimerValue(win, 300)
    
    --This sets up the actual objective.  This needs to happen after cp's are defined
    conquest = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF, textATT = "game.modes.con", textDEF = "game.modes.con2", multiplayerRules = true}
    
    --This adds the CPs to the objective.  This needs to happen after the objective is set up
	conquest:AddCommandPost(cp1)
	conquest:AddCommandPost(cp2)
	conquest:AddCommandPost(cp3)

	conquest:AddCommandPost(cp6)
	conquest:AddCommandPost(cp7)
	conquest:AddCommandPost(cp8)
	DisableSmallMapMiniMap()

	EnableSPHeroRules()
	SetProperty("cp1", "CaptureRegion", "")
	SetProperty("cp2", "CaptureRegion", "")
	SetProperty("cp3", "CaptureRegion", "")
	SetProperty("cp6", "CaptureRegion", "")
	SetProperty("cp7", "CaptureRegion", "")
	SetProperty("cp8", "CaptureRegion", "")
	
	SetTeamAsNeutral(3,1)
	SetTeamAsNeutral(3,2)
	SetTeamAsNeutral(3,4)
	SetTeamAsNeutral(3,5)
	SetTeamAsNeutral(5,3)
	SetTeamAsNeutral(1,3)
	SetTeamAsNeutral(2,3)
	SetTeamAsNeutral(1,5)
	SetTeamAsNeutral(2,5)
	SetTeamAsNeutral(4,3)
	
	SetTeamAsNeutral(2,1)
	SetTeamAsNeutral(2,4)
	SetTeamAsNeutral(1,2)
	SetTeamAsNeutral(1,4)
	SetTeamAsEnemy(4,1)
	SetTeamAsEnemy(4,2)
	SetTeamAsEnemy(5,1)
	SetTeamAsEnemy(5,2)
	SetTeamAsFriend(4,4)
	SetTeamAsFriend(5,5)
	SetTeamAsFriend(4,5)
	SetTeamAsFriend(5,4)
	
	--playerInfo = {}
	
	--[[recorder = OnCharacterSpawn(function(character)
		if GetCharacterTeam(character) == 1 or GetCharacterTeam(character) == 2 then
			print("character: ", character)
			print("characterunit: ", GetCharacterUnit(character))
		end
		playerInfo = {
			charNumber = character, 
			charClass1 = unittablemaster1[GetCharacterClass(character) + 1].unitclass, 
			charClass2 = unittablemaster2[GetCharacterClass(character) + 1].unitclass,
			charTeam = GetCharacterTeam(character)
			}
		end)--]]

		
		
	grace = CreateTimer("grace")
	SetTimerValue(grace, 30)
    onfirstspawn = OnCharacterSpawn(
        function(character)
			if IsCharacterHuman(character) then
				ReleaseCharacterSpawn(onfirstspawn)
				onfirstspawn = nil
				StartTimer(grace)
				ShowTimer(grace)
				ShowMessageText("level.0TT.grace")
			end
        end
		)
		

--------------------------------------------------------------------------------
	ready = 0
	check = CreateTimer("check")
	SetTimerValue(check, 1)
	traitorClass = nil
	OnTimerElapse(
	    function(timer)
			if (GetNumTeamMembersAlive(2) + GetNumTeamMembersAlive(1)) >= 2 then
				ShowMessageText("level.0TT.begin")
				peopleAlive = ((GetNumTeamMembersAlive(2) + GetNumTeamMembersAlive(1)) -1)
				print("peopleAlive: ", peopleAlive)
				local traitorNumber = math.random(0, peopleAlive)
				print("traitorNumber: ", traitorNumber)
				print("1: ", GetTeamMember(1, traitorNumber))
				print("2: ", GetTeamMember(2, traitorNumber))
				--print("goodies: ", playerInfo[peopleAlive])
				--print("goodies: ", playerInfo[GetCharacterUnit(peopleAlive)])
				--print("goodies: ", playerInfo[peopleAlive].charTeam)
				print("charunit: ", GetCharacterUnit(traitorNumber))
				if GetCharacterUnit(traitorNumber) then
					print("1")
					--local traitor = GetTeamMember(1, traitorNumber)
					local traitor = traitorNumber
					print("1")
					local traitorMatrix = GetEntityMatrix(GetCharacterUnit(traitor))
					print("traitormatrix: ", traitorMatrix)
					print("1")
					if GetObjectTeam(GetCharacterUnit(traitorNumber)) == 1 then
						traitorClass = unittablemaster1[traitor + 1].unitclass
					elseif GetObjectTeam(GetCharacterUnit(traitorNumber)) == 2 then
						traitorClass = unittablemaster2[traitor + 1].unitclass
					end
					print("1")
					local bodyMatrix = CreateMatrix(3.14159,0,-10,0,0,0,1, traitorMatrix)
					print("1")
					--AddUnitClass(4, traitorClass, 1, 1)
					print("1")
					SetEntityMatrix(GetCharacterUnit(traitor), bodyMatrix)
					print("1")
					KillObject(GetCharacterUnit(traitor))
					print("1")
					SelectCharacterTeam(traitor, 4)
					print("1")
					SelectCharacterClass(traitor, traitorClass)
					print("1")
					SpawnCharacter(traitor, traitorMatrix)
					print("1")
					ready = 1
				--[[elseif GetTeamMember(2, traitorNumber) then
					print("2")
					local traitor = GetTeamMember(2, traitorNumber)
					print("2")
					local traitorMatrix = GetEntityMatrix(traitor)
					print("2")
					local traitorClass = unittablemaster2[traitor + 1].unitclass
					print("2")
					local bodyMatrix = CreateMatrix(3.14159,0,-10,0,0,0,1,GetEntityMatrix(GetCharacterUnit(traitor)))
					print("2")
					AddUnitClass(4, traitorClass, 1, 1)
					print("2")
					SetEntityMatrix(GetCharacterUnit(traitor), bodyMatrix)
					print("2")
					KillObject(GetCharacterUnit(traitor))
					print("2")
					SelectCharacterTeam(traitor, 4)
					print("2")
					SelectCharacterClass(traitor, traitorClass)
					print("2")
					SpawnCharacter(traitor, traitorMatrix)
					print("2")
					ready = 1--]]
				end
				--	playerInfo[peopleAlive].charTeam
				StartTimer(check)
				StartTimer(win)
				ShowTimer(win)
				SetTeamAsNeutral(1,1)
				SetTeamAsNeutral(2,2)
				DestroyTimer(timer)
				SetReinforcementCount(1, 0)
				SetReinforcementCount(2, 0)
			end
		end,
		grace
		)

	OnTimerElapse(
	  function(timer)
		ShowMessageText("level.0TT.innocent", 1)
		ShowMessageText("level.0TT.innocent", 2)
		ShowMessageText("level.0TT.traitor", 4)
		print("messages of sides shown")
		DestroyTimer(timer)
	  end,
	check
	)
	
	OnObjectKill(function(object,killer)
		if ready == 1 then
			DeactivateObject(object)
		end
		if (GetNumTeamMembersAlive(2) + GetNumTeamMembersAlive(1)) == 0 and ready == 1 then
			MissionVictory(4)
			MissionDefeat(1)
			MissionDefeat(2)
		end
		if GetNumTeamMembersAlive(4) == 0 and ready == 1 then
			MissionVictory(1)
			MissionVictory(2)
			MissionDefeat(4)
		end
    end)
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------

	SetClassProperty("all_inf_officer","PointsToUnlock","0")
	SetClassProperty("all_inf_wookiee","PointsToUnlock","0")
	SetClassProperty("imp_inf_officer","PointsToUnlock","0")
	SetClassProperty("imp_inf_dark_trooper","PointsToUnlock","0")
end

---------------------------------------------------------------------------
-- FUNCTION:    ScriptInit
-- PURPOSE:     This function is only run once
-- INPUT:
-- OUTPUT:
-- NOTES:       The name, 'ScriptInit' is a chosen convention, and each
--              mission script must contain a version of this function, as
--              it is called from C to start the mission.
---------------------------------------------------------------------------

function ScriptInit()

	CompileUnitTables()
    --  Empire Attacking (attacker is always #1)
    local ALL = 2
    local IMP = 1
    --  These variables do not change
    ATT = 1
    DEF = 2

    -- Designers, these two lines *MUST* be first!
    StealArtistHeap(1024 * 1024)
    SetPS2ModelMemory(2097152 + 65536 * 10)
    ReadDataFile("dc:ingame.lvl")
    ReadDataFile("ingame.lvl")

	AddAIGoal(5,"Deathmatch",1000)
	AddAIGoal(4,"Deathmatch",1000)
	AddAIGoal(1,"Deathmatch",1000)
	AddAIGoal(2,"Deathmatch",1000)
	AddAIGoal(3,"Deathmatch",1000)

    SetMaxFlyHeight(40)
	SetMaxPlayerFlyHeight(40)

    ReadDataFile("sound\\tat.lvl;tat2gcw")
    ReadDataFile("SIDE\\all.lvl",
                    "all_inf_rifleman",
                    "all_inf_rocketeer",
                    "all_inf_sniper",
                    "all_inf_engineer",
                    "all_inf_officer",
                    "all_inf_wookiee",
                    "all_hero_hansolo_tat")
    ReadDataFile("SIDE\\imp.lvl",
                    "imp_inf_rifleman",
                    "imp_inf_rocketeer",
                    "imp_inf_engineer",
                    "imp_inf_sniper",
                    "imp_inf_officer",
                    "imp_inf_dark_trooper",
                    "imp_hero_bobafett",
                    "imp_fly_destroyer_dome" )

    ReadDataFile("SIDE\\des.lvl",
                             "tat_inf_jawa")

    SetTeamName (4, "traitors")
    SetUnitCount (4, 1)
    SetTeamName (5, "traitors2")
    SetUnitCount (5, 1)
	AddUnitClass(4, "all_inf_rifleman", 1)
	AddUnitClass(4, "all_inf_rocketeer", 1)
	AddUnitClass(4, "all_inf_engineer", 1)
	AddUnitClass(4, "all_inf_sniper", 1)
	AddUnitClass(4, "all_inf_officer", 1)
	AddUnitClass(4, "all_inf_wookiee", 1)
	AddUnitClass(4, "imp_inf_rifleman", 1)
	AddUnitClass(4, "imp_inf_rocketeer", 1)
	AddUnitClass(4, "imp_inf_engineer", 1)
	AddUnitClass(4, "imp_inf_sniper", 1)
	AddUnitClass(4, "imp_inf_officer", 1)
	AddUnitClass(4, "imp_inf_dark_trooper", 1)
    -- Jawas --------------------------
    SetTeamName (3, "locals")
    AddUnitClass (3, "tat_inf_jawa", 7)
    SetUnitCount (3, 7)
	-----------------------------------
	
	ReadDataFile("SIDE\\tur.lvl",
						"tur_bldg_tat_barge",	
						"tur_bldg_laser")	
 
	SetupTeams{
		all = {
			team = ALL,
			units = 5,
			reinforcements = -1,
			soldier	= { "all_inf_rifleman",0, 2},
			assault	= { "all_inf_rocketeer",0,2},
			engineer = { "all_inf_engineer",0,2},
			sniper = { "all_inf_sniper",0,2},
			officer	= { "all_inf_officer",0,2},
			special	= { "all_inf_wookiee",0,2},

		},
		imp = {
			team = IMP,
			units = 5,
			reinforcements = -1,
			soldier	= { "imp_inf_rifleman",0,2},
			assault	= { "imp_inf_rocketeer",0,2},
			engineer = { "imp_inf_engineer",0,2},
			sniper	= { "imp_inf_sniper",0,2},
			officer	= { "imp_inf_officer",0,2},
			special	= { "imp_inf_dark_trooper",0,2},
		},
	}
    

    --  Level Stats
    ClearWalkers()
    AddWalkerType(0, 0) -- special -> droidekas
    AddWalkerType(1, 0) -- 1x2 (1 pair of legs)
    AddWalkerType(2, 0) -- 2x2 (2 pairs of legs)
    AddWalkerType(3, 0) -- 3x2 (3 pairs of legs)
    SetMemoryPoolSize("Aimer", 17)
	SetMemoryPoolSize("EntityCloth", 25)
	SetMemoryPoolSize("EntityFlyer", 6) -- to account for rocket upgrade
    SetMemoryPoolSize("MountedTurret", 17)
    SetMemoryPoolSize("Obstacle", 664)
    SetMemoryPoolSize("imp_inf_rifleman", 10)
    SetMemoryPoolSize("imp_inf_rocketeer", 10)
    SetMemoryPoolSize("imp_inf_engineer", 10)
    SetMemoryPoolSize("imp_inf_sniper", 10)
    SetMemoryPoolSize("all_inf_officer", 10)
    SetMemoryPoolSize("imp_inf_dark_trooper", 10)
    SetMemoryPoolSize("all_inf_rifleman", 10)
    SetMemoryPoolSize("all_inf_rocketeer", 10)
    SetMemoryPoolSize("all_inf_engineer", 10)
    SetMemoryPoolSize("all_inf_sniper", 10)
    SetMemoryPoolSize("all_inf_officer", 10)
    SetMemoryPoolSize("all_inf_wookiee", 10)
    SetMemoryPoolSize("SoldierAnimation", 600)
    SetMemoryPoolSize("PathNode", 384)
    SetMemoryPoolSize("TreeGridStack", 500)

    SetSpawnDelay(10.0, 0.25)
    ReadDataFile("TAT\\tat2.lvl", "tat2_con")
    SetDenseEnvironment("false")


    --  Sound Stats
    
    voiceSlow = OpenAudioStream("sound\\global.lvl", "all_unit_vo_slow")
    AudioStreamAppendSegments("sound\\global.lvl", "imp_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "des_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_slow", voiceSlow)
    
    voiceQuick = OpenAudioStream("sound\\global.lvl",  "all_unit_vo_quick")
    AudioStreamAppendSegments("sound\\global.lvl",  "imp_unit_vo_quick", voiceQuick)    
    
    OpenAudioStream("sound\\global.lvl",  "gcw_music")
    OpenAudioStream("sound\\tat.lvl",  "tat2")
    OpenAudioStream("sound\\tat.lvl",  "tat2")
    -- OpenAudioStream("sound\\global.lvl",  "global_vo_quick")
    -- OpenAudioStream("sound\\global.lvl",  "global_vo_slow")

    SetBleedingVoiceOver(ALL, ALL, "all_off_com_report_us_overwhelmed", 1)
    SetBleedingVoiceOver(ALL, IMP, "all_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(IMP, ALL, "imp_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(IMP, IMP, "imp_off_com_report_us_overwhelmed", 1)

    SetLowReinforcementsVoiceOver(ALL, ALL, "all_off_defeat_im", .1, 1)
    SetLowReinforcementsVoiceOver(ALL, IMP, "all_off_victory_im", .1, 1)
    SetLowReinforcementsVoiceOver(IMP, IMP, "imp_off_defeat_im", .1, 1)
    SetLowReinforcementsVoiceOver(IMP, ALL, "imp_off_victory_im", .1, 1)

    SetOutOfBoundsVoiceOver(2, "Allleaving")
    SetOutOfBoundsVoiceOver(1, "Impleaving")

    SetAmbientMusic(ALL, 1.0, "all_tat_amb_start",  0,1)
    SetAmbientMusic(ALL, 0.8, "all_tat_amb_middle", 1,1)
    SetAmbientMusic(ALL, 0.2, "all_tat_amb_end",    2,1)
    SetAmbientMusic(IMP, 1.0, "imp_tat_amb_start",  0,1)
    SetAmbientMusic(IMP, 0.8, "imp_tat_amb_middle", 1,1)
    SetAmbientMusic(IMP, 0.2, "imp_tat_amb_end",    2,1)

    SetVictoryMusic(ALL, "all_tat_amb_victory")
    SetDefeatMusic (ALL, "all_tat_amb_defeat")
    SetVictoryMusic(IMP, "imp_tat_amb_victory")
    SetDefeatMusic (IMP, "imp_tat_amb_defeat")

    SetSoundEffect("ScopeDisplayZoomIn",  "binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut", "binocularzoomout")
    --SetSoundEffect("WeaponUnableSelect",  "com_weap_inf_weaponchange_null")
    --SetSoundEffect("WeaponModeUnableSelect",  "com_weap_inf_modechange_null")
    SetSoundEffect("SpawnDisplayUnitChange",       "shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept",       "shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange", "shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept", "shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack",             "shell_menu_exit")



    SetAttackingTeam(ATT)

    --  Camera Stats
    --Tat2 Mos Eisley
	AddCameraShot(0.974338, -0.222180, 0.035172, 0.008020, -82.664650, 23.668301, 43.955681);
	AddCameraShot(0.390197, -0.089729, -0.893040, -0.205362, 23.563562, 12.914885, -101.465561);
	AddCameraShot(0.169759, 0.002225, -0.985398, 0.012916, 126.972809, 4.039628, -22.020613);
	AddCameraShot(0.677453, -0.041535, 0.733016, 0.044942, 97.517807, 4.039628, 36.853477);
	AddCameraShot(0.866029, -0.156506, 0.467299, 0.084449, 7.685640, 7.130688, -10.895234);
end
