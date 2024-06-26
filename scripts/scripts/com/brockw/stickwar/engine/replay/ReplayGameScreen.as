package com.brockw.stickwar.engine.replay
{
      import com.brockw.*;
      import com.brockw.game.*;
      import com.brockw.simulationSync.Move;
      import com.brockw.simulationSync.SimulationSyncronizer;
      import com.brockw.stickwar.GameScreen;
      import com.brockw.stickwar.Main;
      import com.brockw.stickwar.engine.Ai.command.*;
      import com.brockw.stickwar.engine.StickWar;
      import com.brockw.stickwar.engine.UserInterface;
      import com.brockw.stickwar.engine.multiplayer.moves.*;
      import com.brockw.stickwar.engine.units.*;
      import com.liamr.ui.dropDown.DropDown;
      import com.liamr.ui.dropDown.Events.DropDownEvent;
      import flash.display.*;
      import flash.events.*;
      import flash.utils.getTimer;
      
      public class ReplayGameScreen extends GameScreen
      {
             
            
            private var _replayString:String;
            
            private var teamSelect:DropDown;
            
            public function ReplayGameScreen(main:Main)
            {
                  super(main);
            }
            
            override public function enter() : void
            {
                  var a:int = 0;
                  var b:int = 0;
                  main.setOverlayScreen("");
                  if(!main.stickWar)
                  {
                        main.stickWar = new StickWar(main,this);
                  }
                  game = main.stickWar;
                  simulation = new SimulationSyncronizer(game,main,this.endTurn,this.endGame);
                  var isWellFormed:Boolean = simulation.gameReplay.fromString(this._replayString);
                  if(!isWellFormed)
                  {
                        return;
                  }
                  simulation.gameReplay.isPlaying = true;
                  simulation.init(0);
                  this.addChild(game);
                  game.initGame(main,this,simulation.gameReplay.mapId);
                  game.isReplay = true;
                  userInterface = new UserInterface(main,this);
                  addChild(userInterface);
                  a = simulation.gameReplay.teamAId;
                  b = simulation.gameReplay.teamBId;
                  game.initTeams(simulation.gameReplay.teamAType,simulation.gameReplay.teamBType,game.xml.xml.Order.Units.statue.health,game.xml.xml.Order.Units.statue.health);
                  team = game.teamA;
                  game.team = team;
                  game.teamA.id = a;
                  game.teamB.id = b;
                  game.teamA.realName = simulation.gameReplay.teamAName;
                  game.teamB.realName = simulation.gameReplay.teamBName;
                  game.teamA.name = a;
                  game.teamB.name = b;
                  this.team.enemyTeam.isEnemy = true;
                  userInterface.init();
                  game.teamA.spawnMiners();
                  game.teamB.spawnMiners();
                  game.init(0);
                  game.postInit();
                  super.enter();
                  this.teamSelect = new DropDown([game.teamA.realName,game.teamB.realName],"Team Select",true,100);
                  this.teamSelect.addEventListener(DropDown.ITEM_SELECTED,this.statusChanged);
                  addChild(this.teamSelect);
                  this.teamSelect.y = 75;
                  this.teamSelect.x = 600;
                  game.fogOfWar.isFogOn = false;
                  simulation.hasStarted = true;
            }
            
            private function statusChanged(e:DropDownEvent) : void
            {
                  var name:String = e.selectedLabel;
                  if(game.teamA.realName == name)
                  {
                        game.team = game.teamA;
                  }
                  else
                  {
                        game.team = game.teamB;
                  }
                  game.gameScreen.team = game.team;
                  userInterface.isSlowCamera = true;
                  game.targetScreenX = game.team.lastScreenLookPosition;
                  if(Math.abs(game.targetScreenX - game.screenX) > game.map.screenWidth)
                  {
                        game.gameScreen.userInterface.isSlowCamera = false;
                  }
            }
            
            override public function maySwitchOnDisconnect() : Boolean
            {
                  return false;
            }
            
            override public function update(evt:Event, timeDiff:Number) : void
            {
                  super.update(evt,timeDiff);
            }
            
            override public function updateGameLoop(evt:TimerEvent) : void
            {
                  gameTimer.delay = _period;
                  this.gameTimer.start();
                  var timeForFrame:Number = getTimer() - _beforeTime;
                  _beforeTime = getTimer();
                  _overSleepTime = _beforeTime - _afterTime - _sleepTime;
                  if(_overSleepTime < 0)
                  {
                        _overSleepTime = 0;
                  }
                  if(userInterface.keyBoardState.isDown(32))
                  {
                        this.update(evt,_beforeTime - _afterTime);
                        this.update(evt,_beforeTime - _afterTime);
                        this.update(evt,_beforeTime - _afterTime);
                        this.update(evt,_beforeTime - _afterTime);
                        this.update(evt,_beforeTime - _afterTime);
                        this.update(evt,_beforeTime - _afterTime);
                  }
                  else
                  {
                        this.update(evt,_beforeTime - _afterTime);
                  }
                  _afterTime = getTimer();
                  _timeDiff = _afterTime - _beforeTime;
                  _sleepTime = _period - _timeDiff;
                  if(_sleepTime <= 0)
                  {
                        _excess -= _sleepTime;
                        _sleepTime = 2;
                  }
                  overTime += timeForFrame - 34;
                  if(overTime < 0)
                  {
                        overTime = 0;
                  }
                  if(overTime < 35)
                  {
                        evt.updateAfterEvent();
                        consecutiveSkips = 0;
                  }
                  else
                  {
                        ++consecutiveSkips;
                        gameTimer.delay = 1;
                        this.gameTimer.start();
                        trace("Skip: ",timeForFrame,consecutiveSkips,this.stage.stage.frameRate);
                  }
            }
            
            override public function leave() : void
            {
                  this.cleanUp();
                  this.teamSelect.removeEventListener(DropDown.ITEM_SELECTED,this.statusChanged);
                  removeChild(this.teamSelect);
                  this.teamSelect = null;
            }
            
            override public function endTurn() : void
            {
            }
            
            override public function endGame() : void
            {
                  main.showScreen("lobby");
            }
            
            override public function doMove(move:Move, id:int) : void
            {
            }
            
            override public function cleanUp() : void
            {
                  super.cleanUp();
            }
            
            public function get replayString() : String
            {
                  return this._replayString;
            }
            
            public function set replayString(value:String) : void
            {
                  this._replayString = value;
            }
      }
}
