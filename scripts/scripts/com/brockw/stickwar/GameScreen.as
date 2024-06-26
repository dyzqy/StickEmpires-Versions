package com.brockw.stickwar
{
      import com.brockw.game.Screen;
      import com.brockw.simulationSync.Move;
      import com.brockw.simulationSync.SimulationSyncronizer;
      import com.brockw.stickwar.engine.StickWar;
      import com.brockw.stickwar.engine.Team.Team;
      import com.brockw.stickwar.engine.UserInterface;
      import com.brockw.stickwar.engine.multiplayer.moves.ScreenPositionUpdateMove;
      import flash.events.Event;
      import flash.events.TimerEvent;
      import flash.ui.Mouse;
      import flash.utils.Timer;
      import flash.utils.getTimer;
      
      public class GameScreen extends Screen
      {
            
            public static const FRAME_RATE:int = 30;
            
            protected static const MAX_SKIPS:int = 3;
             
            
            protected var _game:StickWar;
            
            protected var _simulation:SimulationSyncronizer;
            
            protected var _main:BaseMain;
            
            protected var _team:Team;
            
            protected var _userInterface:UserInterface;
            
            protected var timeOfLastUpdate:Number;
            
            protected var _period:Number = 33.333333333333336;
            
            protected var _beforeTime:int = 0;
            
            protected var _afterTime:int = 0;
            
            protected var _timeDiff:int = 0;
            
            protected var _sleepTime:int = 0;
            
            protected var _overSleepTime:int = 0;
            
            protected var _excess:int = 0;
            
            protected var gameTimer:Timer;
            
            protected var consecutiveSkips:int;
            
            protected var overTime:Number;
            
            private var _isDebug:Boolean;
            
            private var lastPulse:int;
            
            private var _isPaused:Boolean;
            
            private var isGoingSlow:Boolean;
            
            private var skipHeuristic:Number;
            
            private var messagePrompt:inGameMessagePromptMc;
            
            internal var t:int;
            
            private var showingTimeout:Boolean;
            
            private var showingSyncError:Boolean;
            
            public function GameScreen(main:BaseMain)
            {
                  super();
                  this.main = main;
                  this.isDebug = false;
                  this.isGoingSlow = false;
                  this.skipHeuristic = 0;
                  main.loadingFraction = 0;
            }
            
            override public function enter() : void
            {
                  this.stage.frameRate = 0;
                  this.gameTimer = new Timer(this._period,0);
                  this.gameTimer.addEventListener(TimerEvent.TIMER,this.updateGameLoop);
                  this.gameTimer.start();
                  this.consecutiveSkips = 0;
                  this.overTime = 0;
                  this._beforeTime = getTimer();
                  this.isPaused = false;
                  this.lastPulse = 0;
                  this.main.setOverlayScreen("");
                  this.messagePrompt = new inGameMessagePromptMc();
            }
            
            public function u(evt:Event) : void
            {
                  this.t = getTimer();
            }
            
            public function updateGameLoopFrame(evt:Event) : void
            {
                  this.update(evt,0);
            }
            
            public function updateGameLoop(evt:TimerEvent) : void
            {
                  if(!stage)
                  {
                        return;
                  }
                  this.gameTimer.delay = this._period;
                  this.gameTimer.start();
                  var timeForFrame:Number = getTimer() - this._beforeTime;
                  this._beforeTime = getTimer();
                  this._overSleepTime = this._beforeTime - this._afterTime - this._sleepTime;
                  if(this._overSleepTime < 0)
                  {
                        this._overSleepTime = 0;
                  }
                  if(stage != null)
                  {
                        this.update(evt,this._beforeTime - this._afterTime);
                  }
                  this._afterTime = getTimer();
                  this._timeDiff = this._afterTime - this._beforeTime;
                  this._sleepTime = this._period - this._timeDiff;
                  if(this._sleepTime <= 0)
                  {
                        this._excess -= this._sleepTime;
                        this._sleepTime = 2;
                  }
                  this.overTime += timeForFrame - 34;
                  if(this.overTime < 0)
                  {
                        this.overTime = 0;
                  }
                  if(this.overTime < 35 || this.consecutiveSkips > 0)
                  {
                        if(this.skipHeuristic > 5 && !this.isGoingSlow)
                        {
                              this.isGoingSlow = true;
                        }
                        else if(this.skipHeuristic <= 1 && this.isGoingSlow)
                        {
                              this.isGoingSlow = false;
                        }
                        if(stage != null)
                        {
                              if(this.isGoingSlow)
                              {
                                    stage.quality = "LOW";
                              }
                              else
                              {
                                    stage.quality = "HIGH";
                              }
                        }
                        evt.updateAfterEvent();
                        this.consecutiveSkips = 0;
                        this.skipHeuristic -= 1 / 60;
                        if(this.skipHeuristic < 0)
                        {
                              this.skipHeuristic = 0;
                        }
                  }
                  else
                  {
                        ++this.skipHeuristic;
                        if(this.skipHeuristic > 10)
                        {
                              this.skipHeuristic = 10;
                        }
                        this.overTime = 0;
                        ++this.consecutiveSkips;
                        if(Boolean(this.gameTimer))
                        {
                              this.gameTimer.reset();
                              this.gameTimer.delay = 1;
                              this.gameTimer.start();
                        }
                        trace("Skip: ",timeForFrame,this.consecutiveSkips);
                  }
            }
            
            public function update(evt:Event, timeDiff:Number) : void
            {
                  var m:ScreenPositionUpdateMove = null;
                  if(this.simulation.hasStarted)
                  {
                        this.userInterface.update(evt,timeDiff);
                  }
                  this.simulation.update(this);
                  if(Boolean(this.simulation))
                  {
                        if(this.simulation.isStalled)
                        {
                              if(this.lastPulse > 5)
                              {
                                    m = new ScreenPositionUpdateMove();
                                    this.userInterface.lastSentScreenPosition = m.pos = this.game.screenX;
                                    this.doMove(m,this.team.id);
                                    this.lastPulse = 0;
                              }
                              ++this.lastPulse;
                        }
                        else if(this.showingTimeout == true)
                        {
                              this.hideTimeout();
                        }
                        if(this.showingTimeout || this.showingSyncError)
                        {
                              this.messagePrompt.nextFrame();
                        }
                  }
            }
            
            public function showTimeout(user:String, time:int) : void
            {
                  if(!this.showingSyncError)
                  {
                        this.showingTimeout = true;
                        this.showMessage(user + " is lagging and will forfeit in " + Math.floor(time / 1000) + " seconds");
                  }
            }
            
            public function hideTimeout() : void
            {
                  this.hideMessage();
                  this.showingTimeout = false;
            }
            
            public function showSyncError() : void
            {
                  this.showingSyncError = true;
                  this.showMessage("Clients out of Sync. An error report has been submitted.");
            }
            
            public function showMessage(message:String) : void
            {
                  this.messagePrompt.message.text = message;
                  this.messagePrompt.x = stage.stageWidth / 2;
                  this.messagePrompt.y = stage.stageHeight / 2;
                  addChild(this.messagePrompt);
            }
            
            public function hideMessage() : void
            {
                  if(contains(this.messagePrompt))
                  {
                        removeChild(this.messagePrompt);
                  }
            }
            
            public function endGame() : void
            {
            }
            
            public function endTurn() : void
            {
            }
            
            public function doMove(move:Move, id:int) : void
            {
            }
            
            public function cleanUp() : void
            {
                  this.gameTimer.removeEventListener(TimerEvent.TIMER,this.updateGameLoop);
                  this.gameTimer.stop();
                  this.userInterface.cleanUp();
                  this.userInterface = null;
                  this._simulation = null;
                  Mouse.show();
                  this.game.cleanUp();
                  this.game = null;
                  this.gameTimer = null;
                  this.stage.quality = "HIGH";
            }
            
            public function get game() : StickWar
            {
                  return this._game;
            }
            
            public function set game(value:StickWar) : void
            {
                  this._game = value;
            }
            
            public function get simulation() : SimulationSyncronizer
            {
                  return this._simulation;
            }
            
            public function set simulation(value:SimulationSyncronizer) : void
            {
                  this._simulation = value;
            }
            
            public function get team() : Team
            {
                  return this._team;
            }
            
            public function set team(value:Team) : void
            {
                  this._team = value;
            }
            
            public function get main() : BaseMain
            {
                  return this._main;
            }
            
            public function set main(value:BaseMain) : void
            {
                  this._main = value;
            }
            
            public function get userInterface() : UserInterface
            {
                  return this._userInterface;
            }
            
            public function set userInterface(value:UserInterface) : void
            {
                  this._userInterface = value;
            }
            
            public function get isPaused() : Boolean
            {
                  return this._isPaused;
            }
            
            public function set isPaused(value:Boolean) : void
            {
                  this.game.setPaused(value);
                  this._isPaused = value;
            }
            
            public function get isDebug() : Boolean
            {
                  return this._isDebug;
            }
            
            public function set isDebug(value:Boolean) : void
            {
                  this._isDebug = value;
            }
      }
}
