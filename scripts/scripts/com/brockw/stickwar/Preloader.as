package com.brockw.stickwar
{
      import flash.display.DisplayObject;
      import flash.display.MovieClip;
      import flash.display.Shape;
      import flash.display.StageAlign;
      import flash.display.StageScaleMode;
      import flash.events.Event;
      import flash.system.Capabilities;
      import flash.text.StyleSheet;
      import flash.utils.getDefinitionByName;
      
      public class Preloader extends MovieClip
      {
             
            
            internal var loadingMc:loadingScreenMc;
            
            internal var isLocked:Boolean;
            
            internal var version:int;
            
            internal var minorVersion:int;
            
            public var mainClassName:String = "com.brockw.stickwar.Main";
            
            private var _firstEnterFrame:Boolean;
            
            private var _preloaderBackground:Shape;
            
            private var _preloaderPercent:Shape;
            
            public function Preloader()
            {
                  super();
                  this.loadingMc = new loadingScreenMc();
                  addChild(this.loadingMc);
                  addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
                  stop();
                  this.loadingMc.maskLoader.scaleX = 0;
                  var _fullInfo:String = Capabilities.version;
                  var _osSplitArr:Array = _fullInfo.split(" ");
                  var _versionSplitArr:Array = _osSplitArr[1].split(",");
                  var _versionInfo:Number = Number(_versionSplitArr[0]);
                  var _minerVersion:Number = Number(_versionSplitArr[1]);
                  this.version = _versionInfo;
                  this.minorVersion = _minerVersion;
                  if(this.version < 11 || this.version == 11 && this.minorVersion < 2)
                  {
                        this.isLocked = true;
                  }
            }
            
            public function start() : void
            {
                  this._firstEnterFrame = true;
                  addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
            }
            
            private function onAddedToStage(event:Event) : void
            {
                  removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
                  stage.scaleMode = StageScaleMode.SHOW_ALL;
                  stage.align = StageAlign.TOP_LEFT;
                  this.start();
            }
            
            private function onEnterFrame(event:Event) : void
            {
                  var percent:Number = NaN;
                  if(this._firstEnterFrame)
                  {
                        this._firstEnterFrame = false;
                        if(root.loaderInfo.bytesLoaded >= root.loaderInfo.bytesTotal)
                        {
                              this.dispose();
                              this.run();
                        }
                        else
                        {
                              this.beginLoading();
                        }
                        return;
                  }
                  if(root.loaderInfo.bytesLoaded >= root.loaderInfo.bytesTotal)
                  {
                        this.dispose();
                        this.run();
                  }
                  else
                  {
                        percent = root.loaderInfo.bytesLoaded / root.loaderInfo.bytesTotal;
                        this.updateLoading(percent);
                  }
            }
            
            private function updateLoading(a_percent:Number) : void
            {
                  this.loadingMc.maskLoader.scaleX += (a_percent - this.loadingMc.maskLoader.scaleX) * 0.2;
            }
            
            private function beginLoading() : void
            {
                  trace("begin Loading");
            }
            
            private function dispose() : void
            {
                  trace("dispose preloader");
                  removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
                  if(Boolean(this._preloaderBackground))
                  {
                        removeChild(this._preloaderBackground);
                  }
                  if(Boolean(this._preloaderPercent))
                  {
                        removeChild(this._preloaderPercent);
                  }
                  if(Boolean(this.loadingMc))
                  {
                        removeChild(this.loadingMc);
                  }
                  this._preloaderBackground = null;
                  this._preloaderPercent = null;
            }
            
            private function run() : void
            {
                  var MainClass:Class = null;
                  var main:DisplayObject = null;
                  var locked:lockedMc = null;
                  var u:String = null;
                  var style:StyleSheet = null;
                  var styleObj:Object = null;
                  if(!this.isLocked)
                  {
                        nextFrame();
                        MainClass = getDefinitionByName(this.mainClassName) as Class;
                        if(MainClass == null)
                        {
                              throw new Error("AbstractPreloader:initialize. There was no class matching that name. Did you remember to override mainClassName?");
                        }
                        main = new MainClass() as DisplayObject;
                        if(main == null)
                        {
                              throw new Error("AbstractPreloader:initialize. Main class needs to inherit from Sprite or MovieClip.");
                        }
                        addChildAt(main,0);
                  }
                  else
                  {
                        locked = new lockedMc();
                        u = stage.loaderInfo.url;
                        addChild(locked);
                        if(this.version < 11 || this.version == 11 && this.minorVersion < 2)
                        {
                              style = new StyleSheet();
                              styleObj = new Object();
                              styleObj.color = "#0000FF";
                              style.setStyle(".myText",styleObj);
                              locked.text.styleSheet = style;
                              locked.text.htmlText = "Flash version " + this.version + "." + this.minorVersion + " is out of date\n\nPlease update to the latest version of <a class=\'myText\' href=\'http://get.adobe.com/flashplayer/\'>Flash Player</a>\nor\nUse <a class=\'myText\' href=\'https://www.google.com/intl/en/chrome/browser/\'>Chrome browser</a>";
                              locked.text.selectable = true;
                        }
                  }
            }
      }
}
