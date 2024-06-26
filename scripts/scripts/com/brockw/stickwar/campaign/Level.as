package com.brockw.stickwar.campaign
{
      import com.brockw.stickwar.campaign.controllers.*;
      import com.brockw.stickwar.market.ItemMap;
      
      public class Level
      {
             
            
            public var title:String;
            
            public var mapName:int;
            
            public var storyName:String;
            
            public var player:Player;
            
            public var oponent:Player;
            
            public var controller:Class;
            
            public var points:int;
            
            private var _normalModifier:Number;
            
            private var _hardModifier:Number;
            
            private var _insaneModifier:Number;
            
            private var _normalHealthScale:Number;
            
            private var _tip:String;
            
            private var _unlocks:Array;
            
            private var _levelXml:XML;
            
            public var totalTime:int;
            
            public var bestTime:int;
            
            public function Level(xml:XML)
            {
                  var x:* = undefined;
                  super();
                  this.title = xml.attribute("title");
                  this.mapName = xml.attribute("map");
                  this.storyName = xml.attribute("story");
                  this.points = xml.attribute("points");
                  this._levelXml = xml;
                  var controllerName:* = xml.attribute("controller");
                  if(controllerName == "CampaignTutorial")
                  {
                        this.controller = CampaignTutorial;
                  }
                  else if(controllerName == "CampaignCutScene1")
                  {
                        this.controller = CampaignCutScene1;
                  }
                  else if(controllerName == "CampaignCutScene2")
                  {
                        this.controller = CampaignCutScene2;
                  }
                  this.unlocks = [];
                  for each(x in xml.unlock)
                  {
                        this.unlocks.push(int(ItemMap.unitNameToType(x)));
                  }
                  this.player = new Player(xml.player);
                  this.oponent = new Player(xml.oponent);
                  this.normalModifier = xml.normal;
                  this.hardModifier = xml.hard;
                  this.insaneModifier = xml.insane;
                  this.normalHealthScale = xml.normalHealthScale;
                  this.tip = xml.tip;
                  this.totalTime = 0;
                  this.bestTime = -1;
            }
            
            public function updateTime(time:Number) : void
            {
                  if(this.bestTime == -1)
                  {
                        this.bestTime = time;
                  }
                  else if(time < this.bestTime)
                  {
                        this.bestTime = time;
                  }
                  this.totalTime += time;
            }
            
            public function toString() : String
            {
                  var s:String = "Level: " + this.title + " (" + this.mapName + ")";
                  s += "\nPlayer: " + this.player;
                  return s + ("\nOponent: " + this.oponent);
            }
            
            public function get normalModifier() : Number
            {
                  return this._normalModifier;
            }
            
            public function set normalModifier(value:Number) : void
            {
                  this._normalModifier = value;
            }
            
            public function get hardModifier() : Number
            {
                  return this._hardModifier;
            }
            
            public function set hardModifier(value:Number) : void
            {
                  this._hardModifier = value;
            }
            
            public function get insaneModifier() : Number
            {
                  return this._insaneModifier;
            }
            
            public function set insaneModifier(value:Number) : void
            {
                  this._insaneModifier = value;
            }
            
            public function get normalHealthScale() : Number
            {
                  return this._normalHealthScale;
            }
            
            public function set normalHealthScale(value:Number) : void
            {
                  this._normalHealthScale = value;
            }
            
            public function get tip() : String
            {
                  return this._tip;
            }
            
            public function set tip(value:String) : void
            {
                  this._tip = value;
            }
            
            public function get unlocks() : Array
            {
                  return this._unlocks;
            }
            
            public function set unlocks(value:Array) : void
            {
                  this._unlocks = value;
            }
            
            public function get levelXml() : XML
            {
                  return this._levelXml;
            }
            
            public function set levelXml(value:XML) : void
            {
                  this._levelXml = value;
            }
      }
}
