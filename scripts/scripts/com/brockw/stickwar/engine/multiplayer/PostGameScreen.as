package com.brockw.stickwar.engine.multiplayer
{
      import com.brockw.game.Screen;
      import com.brockw.stickwar.BaseMain;
      import com.brockw.stickwar.Main;
      import com.brockw.stickwar.engine.StickWar;
      import com.brockw.stickwar.engine.Team.Team;
      import com.brockw.stickwar.engine.units.Unit;
      import flash.display.Sprite;
      import flash.events.Event;
      import flash.events.MouseEvent;
      import flash.text.*;
      
      public class PostGameScreen extends Screen
      {
            
            private static const TEXT_SPACING:Number = 75;
            
            public static const M_CAMPAIGN:int = 0;
            
            public static const M_MULTIPLAYER:int = 1;
            
            public static const M_SINGLEPLAYER:int = 2;
            
            public static const M_SYNC_ERROR:int = 3;
             
            
            private var main:BaseMain;
            
            private var id:int;
            
            private var txtWelcome:GenericText;
            
            internal var btnConnect:GenericButton;
            
            internal var txtReplayFile:TextField;
            
            private var _economyRecords:Array;
            
            private var _militaryRecords:Array;
            
            private var mc:victoryScreenMc;
            
            private var displayGraph:Sprite;
            
            private var D_WIDTH:int = 570;
            
            private var D_HEIGHT:int = 350;
            
            private var textBoxes:Array;
            
            private var mode:int;
            
            private var unitUnlocked:Array;
            
            private var teamAName:String;
            
            private var teamBName:String;
            
            private var showCard:Boolean;
            
            public function PostGameScreen(main:BaseMain)
            {
                  super();
                  this.mode = M_CAMPAIGN;
                  this.textBoxes = [];
                  this.mc = new victoryScreenMc();
                  addChild(this.mc);
                  this.displayGraph = this.mc.graphArea.graph;
                  this.D_WIDTH = this.mc.graphArea.graph.width;
                  this.D_HEIGHT = this.mc.graphArea.graph.height;
                  this.main = main;
                  this.unitUnlocked = [];
                  this.mc.unlockCard.visible = false;
                  this.mc.exit.text.text = "Quit";
                  this.mc.exit.buttonMode = true;
                  this.mc.exit.mouseChildren = false;
                  this.id = -1;
                  this.showCard = false;
            }
            
            public function appendUnitUnlocked(u:int, game:StickWar) : void
            {
                  var unit:Unit = game.unitFactory.getUnit(u);
                  var item:XMLList = game.team.buttonInfoMap[u][2];
                  this.unitUnlocked.push([item.name,item.info,game.unitFactory.getProfile(u)]);
                  game.unitFactory.returnUnit(unit.type,unit);
            }
            
            public function showNextUnitUnlocked() : void
            {
                  var nextUnit:Array = null;
                  if(this.unitUnlocked.length == 0)
                  {
                        this.mc.unlockCard.visible = false;
                        this.showCard = false;
                  }
                  else
                  {
                        this.showCard = true;
                        nextUnit = this.unitUnlocked.shift();
                        this.mc.unlockCard.visible = true;
                        this.mc.unlockCard.alpha = 0;
                        this.mc.unlockCard.description.text = nextUnit[1];
                        this.mc.unlockCard.unitName.text = nextUnit[0];
                        this.mc.unlockCard.profilePictureBacking.addChild(nextUnit[2]);
                  }
            }
            
            public function setMode(m:int) : void
            {
                  this.mode = m;
                  if(this.mode == PostGameScreen.M_CAMPAIGN)
                  {
                        this.mc.exit.text.text = "Continue";
                  }
                  else if(this.mode == PostGameScreen.M_SYNC_ERROR)
                  {
                        this.mc.exit.text.text = "Continue";
                        this.mc.replay.text = "If this continues to happen try installing the latest version of flash player";
                        this.displayGraph.graphics.clear();
                        this.mc.saveReplay.visible = false;
                        this.mc.gameStatus.gotoAndStop("syncError");
                        this.mc.background.gotoAndStop("chaosVictory");
                  }
                  else
                  {
                        this.mc.unlockCard.visible = false;
                        this.mc.exit.text.text = "Quit";
                  }
            }
            
            private function drawGraph() : void
            {
                  var i:int = 0;
                  var box:TextField = null;
                  var newTxt:TextField = null;
                  var t:TextFormat = null;
                  this.displayGraph.graphics.clear();
                  var maxMiners:int = 0;
                  var maxPopulation:int = 0;
                  for(i = 0; i < this.economyRecords.length; i++)
                  {
                        if(this.economyRecords[i] > maxMiners)
                        {
                              maxMiners = int(this.economyRecords[i]);
                        }
                  }
                  for(i = 0; i < this.militaryRecords.length; i++)
                  {
                        if(this.militaryRecords[i] > maxPopulation)
                        {
                              maxPopulation = int(this.militaryRecords[i]);
                        }
                  }
                  this.displayGraph.graphics.endFill();
                  var gapSize:Number = this.D_WIDTH / (this.economyRecords.length / 2 - 1);
                  var incrementSize:Number = this.D_HEIGHT / Math.max(maxMiners,maxPopulation);
                  this.displayGraph.graphics.lineStyle(4,255);
                  for(i = 0; i < this.economyRecords.length; i += 2)
                  {
                        if(i == 0)
                        {
                              this.displayGraph.graphics.moveTo(gapSize * Math.floor(i / 2),this.D_HEIGHT - incrementSize * this.economyRecords[i]);
                        }
                        else
                        {
                              this.displayGraph.graphics.lineTo(gapSize * Math.floor(i / 2),this.D_HEIGHT - incrementSize * this.economyRecords[i]);
                        }
                  }
                  this.displayGraph.graphics.endFill();
                  this.displayGraph.graphics.lineStyle(4,16776960);
                  for(i = 1; i < this.economyRecords.length; i += 2)
                  {
                        if(i == 1)
                        {
                              this.displayGraph.graphics.moveTo(gapSize * Math.floor(i / 2),this.D_HEIGHT - incrementSize * this.economyRecords[i]);
                        }
                        else
                        {
                              this.displayGraph.graphics.lineTo(gapSize * Math.floor(i / 2),this.D_HEIGHT - incrementSize * this.economyRecords[i]);
                        }
                  }
                  this.displayGraph.graphics.endFill();
                  this.displayGraph.graphics.lineStyle(3,65280);
                  for(i = 0; i < this.militaryRecords.length; i += 2)
                  {
                        if(i == 0)
                        {
                              this.displayGraph.graphics.moveTo(gapSize * Math.floor(i / 2),this.D_HEIGHT - incrementSize * this.militaryRecords[i]);
                        }
                        else
                        {
                              this.displayGraph.graphics.lineTo(gapSize * Math.floor(i / 2),this.D_HEIGHT - incrementSize * this.militaryRecords[i]);
                        }
                  }
                  this.displayGraph.graphics.endFill();
                  this.displayGraph.graphics.lineStyle(3,16711680);
                  for(i = 1; i < this.militaryRecords.length; i += 2)
                  {
                        if(i == 1)
                        {
                              this.displayGraph.graphics.moveTo(gapSize * Math.floor(i / 2),this.D_HEIGHT - incrementSize * this.militaryRecords[i]);
                        }
                        else
                        {
                              this.displayGraph.graphics.lineTo(gapSize * Math.floor(i / 2),this.D_HEIGHT - incrementSize * this.militaryRecords[i]);
                        }
                  }
                  this.displayGraph.graphics.endFill();
                  for each(box in this.textBoxes)
                  {
                        this.displayGraph.removeChild(box);
                  }
                  this.textBoxes = [];
                  for(i = 0; i < this.D_WIDTH / TEXT_SPACING; i++)
                  {
                        newTxt = new TextField();
                        newTxt.y = this.D_HEIGHT + 10;
                        newTxt.x = i * TEXT_SPACING - 5;
                        t = new TextFormat();
                        t.color = 16777215;
                        newTxt.defaultTextFormat = t;
                        newTxt.text = this.getTimeFormat(Math.floor(i / (this.D_WIDTH / TEXT_SPACING) * this.militaryRecords.length / 2 * 2));
                        this.displayGraph.addChild(newTxt);
                        this.textBoxes.push(newTxt);
                  }
                  for(i = 0; i < this.D_HEIGHT / TEXT_SPACING + 1; i++)
                  {
                        newTxt = new TextField();
                        newTxt.y = this.D_HEIGHT - i * TEXT_SPACING - 5;
                        newTxt.x = 0 - 30;
                        t = new TextFormat();
                        t.color = 16777215;
                        newTxt.defaultTextFormat = t;
                        newTxt.text = "" + Math.floor(maxPopulation * i / (this.D_WIDTH / TEXT_SPACING));
                        this.displayGraph.addChild(newTxt);
                        this.textBoxes.push(newTxt);
                  }
            }
            
            private function getTimeFormat(seconds:int) : String
            {
                  var minutes:int = Math.floor(seconds / 60);
                  seconds = Math.floor(seconds % 60);
                  var result:String = "";
                  if(minutes < 10)
                  {
                        result += "0";
                  }
                  result += minutes + ":";
                  if(seconds < 10)
                  {
                        result += "0";
                  }
                  return result + ("" + seconds);
            }
            
            public function setRecords(economyRecords:Array, militaryRecords:Array) : void
            {
                  this.economyRecords = economyRecords;
                  this.militaryRecords = militaryRecords;
                  this.drawGraph();
            }
            
            private function btnConnectLogin(evt:Event) : void
            {
                  if(this.mode == PostGameScreen.M_MULTIPLAYER || this.mode == PostGameScreen.M_SYNC_ERROR)
                  {
                        this.main.showScreen("lobby");
                  }
                  else if(this.mode == PostGameScreen.M_CAMPAIGN)
                  {
                        if(this.main.campaign.isGameFinished())
                        {
                              this.main.showScreen("summary",false,true);
                        }
                        else
                        {
                              this.main.showScreen("campaignUpgradeScreen",false,true);
                        }
                  }
                  else if(this.mode == PostGameScreen.M_SINGLEPLAYER)
                  {
                        this.main.showScreen("login");
                  }
            }
            
            override public function enter() : void
            {
                  stage.frameRate = 30;
                  addEventListener(Event.ENTER_FRAME,this.update);
                  this.mc.exit.addEventListener(MouseEvent.CLICK,this.btnConnectLogin);
                  this.mc.saveReplay.text.text = "Save Replay";
                  this.mc.userAButton.addEventListener(MouseEvent.CLICK,this.hitUserA);
                  this.mc.userBButton.addEventListener(MouseEvent.CLICK,this.hitUserB);
                  this.mc.userAButton.buttonMode = true;
                  this.mc.userBButton.buttonMode = true;
                  this.mc.userA.mouseEnabled = false;
                  this.mc.userB.mouseEnabled = false;
                  this.mc.unlockCard.okButton.addEventListener(MouseEvent.CLICK,this.closeCard);
            }
            
            override public function maySwitchOnDisconnect() : Boolean
            {
                  return false;
            }
            
            private function hitUserA(evt:Event) : void
            {
                  this.main.showScreen("profile");
                  if(this.main is Main)
                  {
                        Main(this.main).profileScreen.loadProfile(this.teamAName);
                  }
            }
            
            private function hitUserB(evt:Event) : void
            {
                  this.main.showScreen("profile");
                  if(this.main is Main)
                  {
                        Main(this.main).profileScreen.loadProfile(this.teamBName);
                  }
            }
            
            private function closeCard(evt:Event) : void
            {
                  this.showCard = false;
            }
            
            private function update(evt:Event) : void
            {
                  if(this.showCard)
                  {
                        this.mc.unlockCard.alpha += (1 - this.mc.unlockCard.alpha) * 0.2;
                  }
                  else if(this.mc.unlockCard.visible == true)
                  {
                        this.mc.unlockCard.alpha += (0 - this.mc.unlockCard.alpha) * 0.3;
                        if(this.mc.unlockCard.alpha < 0.01)
                        {
                              this.showNextUnitUnlocked();
                        }
                  }
            }
            
            override public function leave() : void
            {
                  this.mc.exit.removeEventListener(MouseEvent.CLICK,this.btnConnectLogin);
                  removeEventListener(Event.ENTER_FRAME,this.update);
                  this.mc.unlockCard.okButton.removeEventListener(MouseEvent.CLICK,this.closeCard);
                  this.mc.userAButton.removeEventListener(MouseEvent.CLICK,this.hitUserA);
                  this.mc.userBButton.removeEventListener(MouseEvent.CLICK,this.hitUserB);
            }
            
            public function setReplayFile(s:String) : void
            {
                  this.mc.replay.text = s;
                  this.mc.saveReplay.visible = true;
            }
            
            public function setTipText(s:String) : void
            {
                  this.mc.replay.text = s;
                  this.mc.saveReplay.visible = false;
            }
            
            public function setWinner(id:int, race:int, userAName:String, userBName:String, myId:int) : void
            {
                  var s:String = "";
                  if(race == Team.T_GOOD)
                  {
                        s += "order";
                        this.mc.background.gotoAndStop("orderVictory");
                  }
                  else
                  {
                        s += "chaos";
                        this.mc.background.gotoAndStop("chaosVictory");
                  }
                  if(myId != -1)
                  {
                        if(myId == id)
                        {
                              s += "Victory";
                        }
                        else
                        {
                              s += "Defeat";
                        }
                  }
                  this.mc.userA.text = userAName;
                  this.mc.userB.text = userBName;
                  this.teamAName = userAName;
                  this.teamBName = userBName;
                  this.mc.gameStatus.gotoAndStop(s);
                  this.id = id;
            }
            
            public function get economyRecords() : Array
            {
                  return this._economyRecords;
            }
            
            public function set economyRecords(value:Array) : void
            {
                  this._economyRecords = value;
            }
            
            public function get militaryRecords() : Array
            {
                  return this._militaryRecords;
            }
            
            public function set militaryRecords(value:Array) : void
            {
                  this._militaryRecords = value;
            }
      }
}
