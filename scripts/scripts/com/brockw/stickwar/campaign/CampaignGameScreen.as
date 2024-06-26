package com.brockw.stickwar.campaign
{
      import com.brockw.*;
      import com.brockw.game.*;
      import com.brockw.simulationSync.EndOfTurnMove;
      import com.brockw.simulationSync.Move;
      import com.brockw.simulationSync.SimulationSyncronizer;
      import com.brockw.stickwar.BaseMain;
      import com.brockw.stickwar.GameScreen;
      import com.brockw.stickwar.campaign.controllers.CampaignController;
      import com.brockw.stickwar.engine.Ai.command.*;
      import com.brockw.stickwar.engine.StickWar;
      import com.brockw.stickwar.engine.Team.Team;
      import com.brockw.stickwar.engine.Team.Tech;
      import com.brockw.stickwar.engine.UserInterface;
      import com.brockw.stickwar.engine.multiplayer.PostGameScreen;
      import com.brockw.stickwar.engine.multiplayer.moves.*;
      import com.brockw.stickwar.engine.units.*;
      import com.brockw.stickwar.singleplayer.*;
      import com.smartfoxserver.v2.requests.ExtensionRequest;
      import flash.display.*;
      import flash.events.*;
      
      public class CampaignGameScreen extends GameScreen
      {
             
            
            private var enemyTeamAi:EnemyTeamAi;
            
            private var controller:CampaignController;
            
            public var doAiUpdates:Boolean;
            
            public function CampaignGameScreen(main:BaseMain)
            {
                  super(main);
            }
            
            override public function enter() : void
            {
                  var a:int = 0;
                  var b:int = 0;
                  var w:Wall = null;
                  var level:Level = main.campaign.getCurrentLevel();
                  var c:Class = level.controller;
                  if(c != null)
                  {
                        this.controller = new c(this);
                  }
                  else
                  {
                        this.controller = null;
                  }
                  if(!main.stickWar)
                  {
                        main.stickWar = new StickWar(main,this);
                  }
                  game = main.stickWar;
                  simulation = new SimulationSyncronizer(game,main,this.endTurn,this.endGame);
                  simulation.init(0);
                  this.addChild(game);
                  game.initGame(main,this,level.mapName);
                  userInterface = new UserInterface(main,this);
                  addChild(userInterface);
                  a = 0;
                  b = 1;
                  var levelModifier:Number = level.normalModifier;
                  if(main.campaign.difficultyLevel == Campaign.D_HARD)
                  {
                        levelModifier = level.hardModifier;
                  }
                  else if(main.campaign.difficultyLevel == Campaign.D_INSANE)
                  {
                        levelModifier = level.insaneModifier;
                  }
                  var healthModifier:Number = 1;
                  if(main.campaign.difficultyLevel == 1)
                  {
                        healthModifier = level.normalHealthScale;
                  }
                  game.initTeams(Team.getIdFromRaceName(level.player.race),Team.getIdFromRaceName(level.oponent.race),level.player.statueHealth,level.oponent.statueHealth,main.campaign.techAllowed,null,1,level.insaneModifier,1,healthModifier);
                  team = game.teamA;
                  game.team = team;
                  game.teamA.id = a;
                  game.teamB.id = b;
                  game.teamA.unitsAvailable = level.player.unitsAvailable;
                  game.teamB.unitsAvailable = level.oponent.unitsAvailable;
                  game.teamA.name = a;
                  game.teamB.name = b;
                  this.team.enemyTeam.isEnemy = true;
                  this.team.enemyTeam.isAi = true;
                  team.realName = "Player";
                  team.enemyTeam.realName = "Computer";
                  var playerStartingUnits:Array = level.player.startingUnits;
                  if(main.campaign.currentLevel != 0)
                  {
                        if(main.campaign.difficultyLevel == Campaign.D_HARD)
                        {
                              playerStartingUnits.push(game.team.getMinerType());
                        }
                        else if(main.campaign.difficultyLevel == Campaign.D_NORMAL)
                        {
                              playerStartingUnits.push([game.team.getMinerType()]);
                              w = team.addWall(team.homeX + 1200);
                              w.setConstructionAmount(1);
                        }
                  }
                  else
                  {
                        game.teamB.gold = 0;
                  }
                  game.teamA.spawnUnitGroup(level.player.startingUnits);
                  game.teamB.spawnUnitGroup(level.oponent.startingUnits);
                  if(level.oponent.castleArcherLevel >= 1)
                  {
                        game.teamB.tech.isResearchedMap[Tech.CASTLE_ARCHER_1] = 1;
                  }
                  if(level.oponent.castleArcherLevel >= 2)
                  {
                        game.teamB.tech.isResearchedMap[Tech.CASTLE_ARCHER_2] = 1;
                  }
                  if(level.oponent.castleArcherLevel >= 3)
                  {
                        game.teamB.tech.isResearchedMap[Tech.CASTLE_ARCHER_3] = 1;
                  }
                  if(level.oponent.castleArcherLevel >= 4)
                  {
                        game.teamB.tech.isResearchedMap[Tech.CASTLE_ARCHER_4] = 1;
                  }
                  if(level.player.castleArcherLevel >= 1)
                  {
                        game.teamA.tech.isResearchedMap[Tech.CASTLE_ARCHER_1] = 1;
                  }
                  if(level.player.castleArcherLevel >= 2)
                  {
                        game.teamA.tech.isResearchedMap[Tech.CASTLE_ARCHER_2] = 1;
                  }
                  if(level.player.castleArcherLevel >= 3)
                  {
                        game.teamA.tech.isResearchedMap[Tech.CASTLE_ARCHER_3] = 1;
                  }
                  if(level.player.castleArcherLevel >= 4)
                  {
                        game.teamA.tech.isResearchedMap[Tech.CASTLE_ARCHER_4] = 1;
                  }
                  userInterface.init();
                  if(team.enemyTeam.type == Team.T_GOOD)
                  {
                        this.enemyTeamAi = new EnemyGoodTeamAi(team.enemyTeam,main,game);
                  }
                  else
                  {
                        this.enemyTeamAi = new EnemyChaosTeamAi(team.enemyTeam,main,game);
                  }
                  game.init(0);
                  game.postInit();
                  simulation.hasStarted = true;
                  super.enter();
                  this.doAiUpdates = true;
            }
            
            override public function update(evt:Event, timeDiff:Number) : void
            {
                  if(userInterface.keyBoardState.isDown(78))
                  {
                        game.teamB.statue.damage(0,100000000,null);
                  }
                  if(this.doAiUpdates)
                  {
                        this.enemyTeamAi.update(game);
                  }
                  if(this.controller != null)
                  {
                        this.controller.update(this);
                  }
                  super.update(evt,timeDiff);
            }
            
            override public function leave() : void
            {
                  this.cleanUp();
            }
            
            override public function endTurn() : void
            {
                  simulation.endOfTurnMove = new EndOfTurnMove();
                  simulation.endOfTurnMove.expectedNumberOfMoves = this.simulation.movesInTurn;
                  simulation.endOfTurnMove.frameRate = simulation.frameRate;
                  simulation.endOfTurnMove.turnSize = 5;
                  simulation.endOfTurnMove.turn = simulation.turn;
                  simulation.processMove(simulation.endOfTurnMove);
                  simulation.movesInTurn = 0;
            }
            
            override public function endGame() : void
            {
                  var u:int = 0;
                  gameTimer.removeEventListener(TimerEvent.TIMER,updateGameLoop);
                  gameTimer.stop();
                  var e:EndOfGameMove = new EndOfGameMove();
                  e.winner = game.winner.id;
                  e.turn = simulation.turn;
                  simulation.processMove(e);
                  main.campaign.getCurrentLevel().updateTime(game.frame / 30);
                  if(e.winner == team.id)
                  {
                        main.campaign.campaignPoints += main.campaign.getCurrentLevel().points;
                        ++main.campaign.currentLevel;
                  }
                  if(e.winner == team.id)
                  {
                        main.postGameScreen.setTipText("");
                  }
                  else
                  {
                        main.postGameScreen.setTipText(main.campaign.getCurrentLevel().tip);
                  }
                  main.postGameScreen.setWinner(e.winner,team.type,team.realName,team.enemyTeam.realName,team.id);
                  main.postGameScreen.setRecords(game.economyRecords,game.militaryRecords);
                  if(!main.campaign.isGameFinished())
                  {
                        for each(u in main.campaign.getCurrentLevel().unlocks)
                        {
                              main.postGameScreen.appendUnitUnlocked(u,game);
                        }
                  }
                  if(e.winner == team.id)
                  {
                        main.postGameScreen.showNextUnitUnlocked();
                  }
                  main.postGameScreen.setMode(PostGameScreen.M_CAMPAIGN);
                  if(main.campaign.justTutorial)
                  {
                        if(e.winner == team.id)
                        {
                              main.sfs.send(new ExtensionRequest("SetDoneTutorialHandler",null));
                        }
                        main.showScreen("lobby");
                  }
                  else
                  {
                        main.showScreen("postGame",false,true);
                  }
            }
            
            override public function doMove(move:Move, id:int) : void
            {
                  move.init(id,simulation.frame,simulation.turn);
                  simulation.processMove(move);
                  ++simulation.movesInTurn;
            }
            
            override public function cleanUp() : void
            {
                  trace("Do the cleanup");
                  super.cleanUp();
            }
            
            override public function maySwitchOnDisconnect() : Boolean
            {
                  return false;
            }
      }
}
