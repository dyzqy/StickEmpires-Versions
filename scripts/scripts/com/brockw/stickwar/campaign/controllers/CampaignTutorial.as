package com.brockw.stickwar.campaign.controllers
{
      import com.brockw.stickwar.GameScreen;
      import com.brockw.stickwar.campaign.*;
      import com.brockw.stickwar.engine.Ai.*;
      import com.brockw.stickwar.engine.Ai.command.*;
      import com.brockw.stickwar.engine.StickWar;
      import com.brockw.stickwar.engine.Team.*;
      import com.brockw.stickwar.engine.multiplayer.moves.*;
      import com.brockw.stickwar.engine.units.*;
      
      public class CampaignTutorial extends CampaignController
      {
            
            private static const S_SET_UP:int = -1;
            
            private static const S_BOX_UNITS:int = 0;
            
            private static const S_MOVE_UNITS:int = 1;
            
            private static const S_MOVE_SCREEN:int = 2;
            
            private static const S_ATTACK_UNITS:int = 3;
            
            private static const S_MOVE_TO_BASE:int = 4;
            
            private static const S_SELECT_MINER:int = 5;
            
            private static const S_START_MINING:int = 6;
            
            private static const S_SELECT_SECOND_MINER:int = 7;
            
            private static const S_PRAY:int = 8;
            
            private static const S_BUILD_UNIT:int = 9;
            
            private static const S_SHOW_ENEMY:int = 10;
            
            private static const S_SPEARTON_ATTACKING:int = 11;
            
            private static const S_GARRISON:int = 12;
            
            private static const S_CLICK_ON_ARCHERY_RANGE:int = 13;
            
            private static const S_UPGRADE_CASTLE_ARCHER:int = 14;
            
            private static const S_SEND_IN_SPEARTON:int = 15;
            
            private static const S_HIT_DEFEND:int = 16;
            
            private static const S_KILL_SPEARTON:int = 17;
            
            private static const S_GOOD_LUCK:int = 19;
            
            private static const S_GOOD_LUCK_2:int = 21;
            
            private static const S_ALL_DONE:int = 20;
            
            private static const S_TALK_ABOUT_BUILDINGS:int = 22;
            
            private static const S_SELECT_MINER_2:int = 23;
            
            private static const S_PRAY_INFO:int = 23;
            
            private static const S_GOLD_INFO:int = 24;
             
            
            private var state:int;
            
            private var s1:Swordwrath;
            
            private var s2:Swordwrath;
            
            private var o1:Swordwrath;
            
            private var m1:Miner;
            
            private var m2:Miner;
            
            private var spearton1:Spearton;
            
            internal var popBefore:int;
            
            private var counter:int;
            
            private var message:InGameMessage;
            
            private var arrow:tutorialArrow;
            
            public function CampaignTutorial(gameScreen:GameScreen)
            {
                  super(gameScreen);
                  this.state = S_SET_UP;
            }
            
            override public function update(gameScreen:GameScreen) : void
            {
                  var game:StickWar = null;
                  var u1:Swordwrath = null;
                  var u2:Swordwrath = null;
                  var g:Unit = null;
                  var u:UnitMove = null;
                  var notGarrisoned:Boolean = false;
                  var notDefending:Boolean = false;
                  var v1:Miner = null;
                  var v2:Miner = null;
                  super.update(gameScreen);
                  if(Boolean(this.message))
                  {
                        this.message.update();
                  }
                  if(this.arrow != null)
                  {
                        if(this.arrow.currentFrame == this.arrow.totalFrames)
                        {
                              this.arrow.gotoAndPlay(1);
                        }
                        else
                        {
                              this.arrow.nextFrame();
                        }
                  }
                  gameScreen.userInterface.isSlowCamera = false;
                  if(this.state == S_SET_UP)
                  {
                        CampaignGameScreen(gameScreen).doAiUpdates = false;
                        gameScreen.userInterface.isGlobalsEnabled = false;
                        gameScreen.team.gold = 0;
                        gameScreen.team.mana = 0;
                        gameScreen.team.enemyTeam.gold = 0;
                        game = gameScreen.game;
                        u1 = Swordwrath(game.unitFactory.getUnit(Unit.U_SWORDWRATH));
                        u2 = Swordwrath(game.unitFactory.getUnit(Unit.U_SWORDWRATH));
                        gameScreen.team.spawn(u1,game);
                        gameScreen.team.spawn(u2,game);
                        u1.px = gameScreen.team.homeX + 2000 * gameScreen.team.direction;
                        u2.px = gameScreen.team.homeX + 2000 * gameScreen.team.direction;
                        u1.py = game.map.height / 3;
                        u2.py = game.map.height / 3 * 2;
                        u1.ai.setCommand(game,new StandCommand(game));
                        u2.ai.setCommand(game,new StandCommand(game));
                        delete game.team.unitsAvailable[Unit.U_SWORDWRATH];
                        delete game.team.unitsAvailable[Unit.U_MINER];
                        this.s1 = u1;
                        this.s2 = u2;
                        this.message = new InGameMessage("",gameScreen.game);
                        this.message.x = game.stage.stageWidth / 2;
                        this.message.y = game.stage.stageHeight / 4 - 75;
                        this.message.scaleX *= 1.3;
                        this.message.scaleY *= 1.3;
                        gameScreen.addChild(this.message);
                        this.arrow = new tutorialArrow();
                        gameScreen.addChild(this.arrow);
                        this.m1 = Miner(game.unitFactory.getUnit(Unit.U_MINER));
                        gameScreen.team.spawn(this.m1,game);
                        this.m1.px = gameScreen.team.homeX + 400;
                        this.m1.py = game.map.height / 2;
                        this.m1.ai.setCommand(game,new StandCommand(game));
                  }
                  else if(this.state == S_BOX_UNITS)
                  {
                        gameScreen.game.screenX = 2200;
                        gameScreen.userInterface.isSlowCamera = true;
                        gameScreen.game.targetScreenX = 2200;
                        this.arrow.x = this.s1.x + gameScreen.game.battlefield.x;
                        this.arrow.y = this.s1.y - this.s1.pheight * 0.8 + gameScreen.game.battlefield.y;
                        this.message.setMessage("Left click and drag a box over units to select them.","Step #1",0,"voiceTutorial1");
                  }
                  else if(this.state == S_MOVE_UNITS)
                  {
                        if(this.s1.selected == false)
                        {
                              gameScreen.userInterface.selectedUnits.add(this.s1);
                              gameScreen.userInterface.selectedUnits.add(this.s2);
                              this.s1.selected = true;
                              this.s2.selected = true;
                        }
                        this.message.setMessage("Right click here to move your selected units.","Step #2",0,"voiceTutorial2");
                        gameScreen.game.screenX = 2200;
                        gameScreen.game.targetScreenX = 2200;
                        this.arrow.x = 2350 + gameScreen.game.battlefield.x;
                        this.arrow.y = 100 + gameScreen.game.battlefield.y;
                  }
                  else if(this.state == S_MOVE_SCREEN)
                  {
                        this.message.setMessage("Move your mouse here to scroll the screen sideways.","Step #3",0,"voiceTutorial3");
                        if(this.s1.selected == false)
                        {
                              gameScreen.userInterface.selectedUnits.add(this.s1);
                              gameScreen.userInterface.selectedUnits.add(this.s2);
                              this.s1.selected = true;
                              this.s2.selected = true;
                        }
                        this.arrow.x = gameScreen.game.stage.stageWidth - 50;
                        this.arrow.y = gameScreen.game.stage.stageHeight / 4;
                        this.arrow.rotation = -90;
                  }
                  else if(this.state == S_ATTACK_UNITS)
                  {
                        if(this.s1.selected == false)
                        {
                              gameScreen.userInterface.selectedUnits.add(this.s1);
                              gameScreen.userInterface.selectedUnits.add(this.s2);
                              this.s1.selected = true;
                              this.s2.selected = true;
                        }
                        gameScreen.game.targetScreenX = 2800;
                        this.message.setMessage("Right click on this enemy unit to attack.","Step #4",0,"voiceTutorial4");
                        this.arrow.x = this.o1.x + gameScreen.game.battlefield.x;
                        this.arrow.y = this.o1.y - this.o1.pheight * 0.8 + gameScreen.game.battlefield.y;
                        this.arrow.rotation = 0;
                  }
                  else if(this.state == S_MOVE_TO_BASE)
                  {
                        if(this.s1.selected == true)
                        {
                              gameScreen.userInterface.selectedUnits.clear();
                              this.s1.selected = false;
                              this.s2.selected = false;
                        }
                        this.message.setMessage("Click down here on the mini map to quickly navigate back to you castle.","Step #5",0,"voiceTutorial5");
                        this.arrow.x = gameScreen.game.stage.stageWidth / 2 - 90;
                        this.arrow.y = gameScreen.game.stage.stageHeight - 115;
                  }
                  else if(this.state == S_SELECT_MINER)
                  {
                        this.message.setMessage("Click on this miner.","Step #6",0,"voiceTutorial6");
                        gameScreen.userInterface.isSlowCamera = true;
                        gameScreen.game.targetScreenX = gameScreen.team.homeX;
                        this.arrow.x = this.m1.x + gameScreen.game.battlefield.x;
                        this.arrow.y = this.m1.y - this.m1.pheight * 0.8 + gameScreen.game.battlefield.y;
                  }
                  else if(this.state == S_PRAY)
                  {
                        this.message.setMessage("Right click on the statue to begin praying.","Step #7",0,"voiceTutorial8");
                        gameScreen.userInterface.isSlowCamera = true;
                        gameScreen.game.targetScreenX = gameScreen.team.homeX;
                        this.arrow.x = gameScreen.game.team.statue.x + gameScreen.game.battlefield.x;
                        this.arrow.y = gameScreen.game.team.statue.y - gameScreen.game.team.statue.height / 2 + gameScreen.game.battlefield.y;
                        gameScreen.userInterface.selectedUnits.add(this.m1);
                        this.m1.selected = true;
                  }
                  else if(this.state == S_PRAY_INFO)
                  {
                        this.arrow.visible = false;
                        gameScreen.userInterface.isSlowCamera = true;
                        gameScreen.game.targetScreenX = gameScreen.team.homeX;
                        this.message.setMessage("Praying is used to gather mana. Mana is used to build more advanced units, research technologies and cast spells.","",0,"voiceTutorial7");
                  }
                  else if(this.state == S_START_MINING)
                  {
                        this.arrow.visible = true;
                        this.message.setMessage("Right click on a gold mine to gather gold.","Step #8",0,"voiceTutorial9");
                        gameScreen.userInterface.isSlowCamera = true;
                        gameScreen.game.targetScreenX = gameScreen.team.homeX;
                        this.arrow.x = gameScreen.game.map.gold[3].x + gameScreen.game.battlefield.x;
                        this.arrow.y = gameScreen.game.map.gold[3].y - 60 * 0.8 + gameScreen.game.battlefield.y;
                        gameScreen.userInterface.selectedUnits.add(this.m1);
                        this.m1.selected = true;
                  }
                  else if(this.state == S_GOLD_INFO)
                  {
                        this.message.setMessage("Your mana, gold and population are shown at the right of the screen.","",75,"voiceTutorial10");
                        this.arrow.x = 675;
                        this.arrow.y = 40;
                  }
                  else if(this.state == S_BUILD_UNIT)
                  {
                        if(gameScreen.team.buttonInfoMap[Unit.U_SWORDWRATH][3] != 0 || this.arrow.visible == false)
                        {
                              this.message.setMessage("The Swordwrath is a basic infantry unit. Once finished training, he will appear through your castle\'s gates.","",0,"voiceTutorial12");
                              this.arrow.visible = false;
                        }
                        else
                        {
                              this.message.setMessage("Click the icon below to build a Swordwrath unit.","Step #9",0,"voiceTutorial11");
                              this.arrow.x = 95;
                              this.arrow.y = gameScreen.game.stage.stageHeight - 100;
                              this.arrow.visible = true;
                        }
                  }
                  else if(this.state == S_SHOW_ENEMY)
                  {
                        gameScreen.userInterface.isSlowCamera = true;
                        gameScreen.game.targetScreenX = this.spearton1.px - gameScreen.game.map.screenWidth / 2;
                        gameScreen.game.fogOfWar.isFogOn = false;
                        this.message.setMessage("A Spearton is attacking!","",0,"voiceTutorial13");
                        this.arrow.visible = false;
                  }
                  else if(this.state == S_SPEARTON_ATTACKING)
                  {
                        gameScreen.game.fogOfWar.isFogOn = true;
                        gameScreen.userInterface.isSlowCamera = true;
                        gameScreen.game.targetScreenX = gameScreen.team.forwardUnit.px - gameScreen.game.map.screenWidth / 2;
                        gameScreen.userInterface.isGlobalsEnabled = true;
                        for each(g in gameScreen.team.units)
                        {
                              g.selected = false;
                        }
                        this.message.setMessage("Click here to garrison your units inside the castle.","Step #10",0,"voiceTutorial14");
                        this.arrow.x = gameScreen.game.stage.stageWidth / 2 - 90;
                        this.arrow.y = gameScreen.game.stage.stageHeight - 75;
                        this.arrow.visible = true;
                  }
                  else if(this.state == S_GARRISON)
                  {
                        this.message.setMessage("Your units will now run to the safety of your castle.","",0,"voiceTutorial15");
                        this.arrow.visible = false;
                        gameScreen.userInterface.isGlobalsEnabled = false;
                        gameScreen.userInterface.isSlowCamera = true;
                        gameScreen.game.targetScreenX = gameScreen.team.forwardUnit.px - gameScreen.game.map.screenWidth / 2;
                        for each(g in gameScreen.team.units)
                        {
                              g.selected = false;
                        }
                  }
                  else if(this.state == S_CLICK_ON_ARCHERY_RANGE)
                  {
                        gameScreen.userInterface.isSlowCamera = true;
                        gameScreen.game.targetScreenX = 0;
                        this.message.setMessage("Click on the archery range building.","Step #11",250,"voiceTutorial16");
                        gameScreen.team.gold = 400;
                        this.arrow.x = 537 + gameScreen.game.battlefield.x;
                        this.arrow.y = gameScreen.game.battlefield.y - 150;
                        this.arrow.visible = true;
                  }
                  else if(this.state == S_UPGRADE_CASTLE_ARCHER)
                  {
                        this.message.y = gameScreen.game.stage.stageHeight / 4 - 75;
                        this.message.setMessage("Click the icon below to build a Castle Archer.","Step #12",0,"voiceTutorial17");
                        gameScreen.game.targetScreenX = 0;
                        gameScreen.userInterface.selectedUnits.add(Unit(gameScreen.team.buildings["ArcheryBuilding"]));
                        Unit(gameScreen.team.buildings["ArcheryBuilding"]).selected = true;
                        this.arrow.x = gameScreen.game.stage.stageWidth - 170;
                        this.arrow.y = gameScreen.game.stage.stageHeight - 100;
                  }
                  else if(this.state == S_TALK_ABOUT_BUILDINGS)
                  {
                        this.message.setMessage("Each building contains different technologies and upgrades which must be researched to enable them.","",0,"voiceTutorial18");
                  }
                  else if(this.state == S_SEND_IN_SPEARTON)
                  {
                        gameScreen.userInterface.isGlobalsEnabled = true;
                        gameScreen.userInterface.isSlowCamera = true;
                        gameScreen.game.targetScreenX = this.spearton1.px - gameScreen.game.map.screenWidth / 2;
                        u = new UnitMove();
                        u.moveType = UnitCommand.ATTACK_MOVE;
                        u.units.push(this.spearton1);
                        u.owner = gameScreen.team.id;
                        u.arg0 = gameScreen.team.homeX;
                        u.arg1 = gameScreen.team.game.map.height / 2;
                        u.execute(gameScreen.team.game);
                        this.message.setMessage("Hit the defend button below to send out your units.","Step #13",0,"voiceTutorial19");
                        this.message.visible = true;
                        this.arrow.visible = true;
                        this.arrow.x = gameScreen.game.stage.stageWidth / 2;
                        this.arrow.y = gameScreen.game.stage.stageHeight - 75;
                  }
                  else if(this.state == S_HIT_DEFEND)
                  {
                        gameScreen.userInterface.isGlobalsEnabled = false;
                        this.message.setMessage("Use your forces to take down the invading Spearton.","Step #14",0,"voiceTutorial20");
                        this.message.visible = true;
                        this.arrow.visible = true;
                        this.arrow.x = this.spearton1.x + gameScreen.game.battlefield.x;
                        this.arrow.y = this.spearton1.y - this.spearton1.pheight * 0.8 + gameScreen.game.battlefield.y;
                        u = new UnitMove();
                        u.moveType = UnitCommand.ATTACK_MOVE;
                        u.units.push(this.spearton1);
                        u.owner = gameScreen.team.id;
                        u.arg0 = gameScreen.team.homeX;
                        u.arg1 = gameScreen.team.game.map.height / 2;
                        u.execute(gameScreen.team.game);
                  }
                  else if(this.state == S_KILL_SPEARTON)
                  {
                        this.arrow.x = this.spearton1.x + gameScreen.game.battlefield.x;
                        this.arrow.y = this.spearton1.y - this.spearton1.pheight * 0.8 + gameScreen.game.battlefield.y;
                  }
                  else if(this.state == S_GOOD_LUCK)
                  {
                        this.message.setMessage("For a full list of commands, hit \'ESC\' or \'P\' for the pause menu.","",0,"voiceTutorial21");
                        this.arrow.visible = false;
                        CampaignGameScreen(gameScreen).doAiUpdates = true;
                  }
                  else if(this.state == S_GOOD_LUCK_2)
                  {
                        this.message.setMessage("Your mission is to destroy the enemy monument before they destroy yours. Good luck.","",0,"voiceTutorial22");
                        this.arrow.visible = false;
                        CampaignGameScreen(gameScreen).doAiUpdates = true;
                        gameScreen.userInterface.isGlobalsEnabled = true;
                  }
                  if(this.state < S_CLICK_ON_ARCHERY_RANGE)
                  {
                        gameScreen.team.enemyTeam.gold = 0;
                  }
                  if(this.state != S_ALL_DONE)
                  {
                  }
                  if(this.o1 != null)
                  {
                        this.o1.ai.setCommand(game,new StandCommand(game));
                  }
                  if(this.state == S_SET_UP)
                  {
                        this.state = S_BOX_UNITS;
                  }
                  else if(this.state == S_BOX_UNITS)
                  {
                        if(this.s1.selected == true && this.s2.selected == true)
                        {
                              this.state = S_MOVE_UNITS;
                        }
                  }
                  else if(this.state == S_MOVE_UNITS)
                  {
                        if(this.s1.px < 2500 && this.s2.px < 2500)
                        {
                              this.state = S_MOVE_SCREEN;
                              this.o1 = Swordwrath(gameScreen.game.unitFactory.getUnit(Unit.U_SWORDWRATH));
                              gameScreen.team.enemyTeam.spawn(this.o1,gameScreen.game);
                              this.o1.x = this.o1.px = 3350;
                              this.o1.y = this.o1.py = gameScreen.game.map.height / 2;
                        }
                  }
                  else if(this.state == S_MOVE_SCREEN)
                  {
                        if(gameScreen.game.screenX > 2800)
                        {
                              this.state = S_ATTACK_UNITS;
                        }
                  }
                  else if(this.state == S_ATTACK_UNITS)
                  {
                        if(this.o1.isDead == true)
                        {
                              this.o1 = null;
                              this.state = S_MOVE_TO_BASE;
                        }
                  }
                  else if(this.state == S_MOVE_TO_BASE)
                  {
                        if(gameScreen.game.screenX < gameScreen.team.homeX + 300)
                        {
                              this.state = S_SELECT_MINER;
                        }
                  }
                  else if(this.state == S_SELECT_MINER)
                  {
                        if(this.m1.selected == true)
                        {
                              this.state = S_PRAY;
                        }
                  }
                  else if(this.state == S_PRAY)
                  {
                        if(MinerAi(this.m1.ai).targetOre == gameScreen.game.team.statue)
                        {
                              this.state = CampaignTutorial.S_PRAY_INFO;
                              this.counter = 0;
                        }
                  }
                  else if(this.state == S_PRAY_INFO)
                  {
                        if(gameScreen.game.team.mana > 10)
                        {
                              this.state = CampaignTutorial.S_START_MINING;
                        }
                  }
                  else if(this.state == S_SELECT_MINER_2)
                  {
                        if(MinerAi(this.m1.ai).targetOre != null && MinerAi(this.m1.ai).targetOre != gameScreen.game.team.statue)
                        {
                              this.state = CampaignTutorial.S_START_MINING;
                        }
                  }
                  else if(this.state == S_START_MINING)
                  {
                        if(MinerAi(this.m1.ai).targetOre != null && MinerAi(this.m1.ai).targetOre != gameScreen.game.team.statue)
                        {
                              this.state = S_GOLD_INFO;
                              gameScreen.team.gold = 150;
                              this.popBefore = gameScreen.team.units.length;
                              gameScreen.team.defend(true);
                              gameScreen.team.unitsAvailable[Unit.U_SWORDWRATH] = 1;
                              this.counter = 0;
                              this.arrow.scaleY *= -1;
                        }
                  }
                  else if(this.state == S_GOLD_INFO)
                  {
                        ++this.counter;
                        if(this.counter > 150)
                        {
                              this.state = S_BUILD_UNIT;
                              this.arrow.visible = true;
                              this.arrow.scaleY *= -1;
                        }
                  }
                  else if(this.state == S_BUILD_UNIT)
                  {
                        if(gameScreen.team.units.length > this.popBefore)
                        {
                              ++this.counter;
                              delete gameScreen.team.unitsAvailable[Unit.U_SWORDWRATH];
                              if(this.counter > 150)
                              {
                                    this.state = S_SHOW_ENEMY;
                                    gameScreen.userInterface.isGlobalsEnabled = true;
                                    this.spearton1 = Spearton(gameScreen.game.unitFactory.getUnit(Unit.U_SPEARTON));
                                    gameScreen.team.enemyTeam.spawn(this.spearton1,gameScreen.game);
                                    this.spearton1.x = this.spearton1.px = this.spearton1.team.homeX - 400;
                                    this.spearton1.y = this.spearton1.py = gameScreen.game.map.height / 2;
                              }
                        }
                  }
                  else if(this.state == S_SHOW_ENEMY)
                  {
                        if(this.spearton1.px < gameScreen.team.enemyTeam.homeX - 1000)
                        {
                              this.state = S_SPEARTON_ATTACKING;
                        }
                  }
                  else if(this.state == S_SPEARTON_ATTACKING)
                  {
                        notGarrisoned = false;
                        for each(g in gameScreen.team.units)
                        {
                              if(!g.isGarrisoned)
                              {
                                    notGarrisoned = true;
                              }
                        }
                        if(!notGarrisoned)
                        {
                              this.state = S_GARRISON;
                        }
                  }
                  else if(this.state == S_GARRISON)
                  {
                        if(gameScreen.game.team.forwardUnit.px < gameScreen.team.homeX + 200)
                        {
                              this.state = S_CLICK_ON_ARCHERY_RANGE;
                        }
                  }
                  else if(this.state == S_CLICK_ON_ARCHERY_RANGE)
                  {
                        if(Unit(gameScreen.team.buildings["ArcheryBuilding"]).selected)
                        {
                              this.state = S_UPGRADE_CASTLE_ARCHER;
                        }
                  }
                  else if(this.state == S_UPGRADE_CASTLE_ARCHER)
                  {
                        if(gameScreen.team.tech.isResearching(Tech.CASTLE_ARCHER_1))
                        {
                              this.state = S_TALK_ABOUT_BUILDINGS;
                        }
                  }
                  else if(this.state == CampaignTutorial.S_TALK_ABOUT_BUILDINGS)
                  {
                        if(gameScreen.team.tech.isResearched(Tech.CASTLE_ARCHER_1))
                        {
                              this.spearton1.px = gameScreen.team.homeX + 700;
                              this.state = S_SEND_IN_SPEARTON;
                        }
                  }
                  else if(this.state == S_SEND_IN_SPEARTON)
                  {
                        notDefending = false;
                        for each(g in gameScreen.team.units)
                        {
                              if(g.isGarrisoned)
                              {
                                    notDefending = true;
                              }
                        }
                        if(!notDefending)
                        {
                              this.state = S_HIT_DEFEND;
                        }
                  }
                  else if(this.state == S_HIT_DEFEND)
                  {
                        if(gameScreen.team.currentAttackState == Team.G_DEFEND)
                        {
                              this.state = S_KILL_SPEARTON;
                        }
                  }
                  else if(this.state == S_KILL_SPEARTON)
                  {
                        if(this.spearton1.isDead)
                        {
                              this.state = S_GOOD_LUCK;
                              this.popBefore = gameScreen.team.population;
                              gameScreen.team.gold = 150;
                              gameScreen.team.game.team.unitsAvailable[Unit.U_MINER] = 1;
                              game = gameScreen.game;
                              v1 = Miner(game.unitFactory.getUnit(Unit.U_MINER));
                              v2 = Miner(game.unitFactory.getUnit(Unit.U_MINER));
                              gameScreen.team.spawn(v1,game);
                              gameScreen.team.spawn(v2,game);
                              v1.px = gameScreen.team.homeX;
                              v2.px = gameScreen.team.homeX;
                              v1.py = game.map.height / 3;
                              v2.py = game.map.height / 3 * 2;
                              v1.ai.setCommand(game,new StandCommand(game));
                              v2.ai.setCommand(game,new StandCommand(game));
                              game.team.population += 4;
                              v1 = Miner(game.unitFactory.getUnit(Unit.U_MINER));
                              v2 = Miner(game.unitFactory.getUnit(Unit.U_MINER));
                              gameScreen.team.enemyTeam.spawn(v1,game);
                              gameScreen.team.enemyTeam.spawn(v2,game);
                              v1.px = gameScreen.team.enemyTeam.homeX;
                              v2.px = gameScreen.team.enemyTeam.homeX;
                              v1.py = game.map.height / 3;
                              v2.py = game.map.height / 3 * 2;
                              v1.ai.setCommand(game,new StandCommand(game));
                              v2.ai.setCommand(game,new StandCommand(game));
                              game.team.enemyTeam.population += 4;
                              game.team.defend(true);
                        }
                  }
                  else if(this.state == S_GOOD_LUCK)
                  {
                        ++this.counter;
                        gameScreen.team.unitsAvailable[Unit.U_SWORDWRATH] = 1;
                        if(this.counter > 300)
                        {
                              this.state = S_GOOD_LUCK_2;
                              this.counter = 0;
                        }
                  }
                  else if(this.state == S_GOOD_LUCK_2)
                  {
                        ++this.counter;
                        if(this.counter > 300)
                        {
                              this.state = S_ALL_DONE;
                              this.message.visible = false;
                        }
                  }
            }
      }
}
