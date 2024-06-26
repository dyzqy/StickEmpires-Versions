package com.brockw.stickwar
{
      import flash.display.DisplayObject;
      import flash.display.MovieClip;
      import flash.display.Shape;
      import flash.display.StageAlign;
      import flash.display.StageScaleMode;
      import flash.events.Event;
      import flash.utils.getDefinitionByName;
      
      public class Preloader extends MovieClip
      {
             
            
            internal var loadingMc:loadingScreenMc;
            
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
                  nextFrame();
                  var MainClass:Class = getDefinitionByName(this.mainClassName) as Class;
                  if(MainClass == null)
                  {
                        throw new Error("AbstractPreloader:initialize. There was no class matching that name. Did you remember to override mainClassName?");
                  }
                  var main:DisplayObject = new MainClass() as DisplayObject;
                  if(main == null)
                  {
                        throw new Error("AbstractPreloader:initialize. Main class needs to inherit from Sprite or MovieClip.");
                  }
                  addChildAt(main,0);
            }
      }
}
