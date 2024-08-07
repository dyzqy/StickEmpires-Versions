package com.brockw.stickwar.engine.multiplayer
{
      import com.brockw.game.Screen;
      import com.brockw.stickwar.BaseMain;
      import com.smartfoxserver.v2.entities.data.*;
      import com.smartfoxserver.v2.requests.*;
      import flash.display.MovieClip;
      import flash.events.Event;
      import flash.events.MouseEvent;
      import flash.net.URLRequest;
      import flash.net.navigateToURL;
      
      public class MainLobbyScreen extends Screen
      {
             
            
            private var mc:realLobbyScreenMc;
            
            private var main:BaseMain;
            
            private var newsIndex:Number;
            
            private var newsPanels:Array;
            
            public function MainLobbyScreen(main:BaseMain)
            {
                  this.mc = new realLobbyScreenMc();
                  addChild(this.mc);
                  this.newsIndex = 0;
                  this.main = main;
                  this.newsPanels = [];
                  super();
            }
            
            public function receiveNewsItem(param:SFSObject) : void
            {
                  var title:String = param.getUtfString("title");
                  var message:String = param.getUtfString("message");
                  var youtubeId:String = param.getUtfString("youtubeId");
                  var date:String = param.getUtfString("date");
                  var type:int = param.getInt("type");
                  var index:int = param.getInt("index");
                  var id:int = param.getInt("id");
                  if(type == -1)
                  {
                        if(index in this.newsPanels)
                        {
                              MovieClip(this.newsPanels[index]).parent.removeChild(MovieClip(this.newsPanels[index]));
                              delete this.newsPanels[index];
                        }
                        return;
                  }
                  if(!(index in this.newsPanels))
                  {
                        this.newsPanels[index] = new NewsPanel(title,message,date,type,index,youtubeId,id);
                        addChild(this.newsPanels[index]);
                        this.newsPanels[index].y = 416;
                        this.newsPanels[index].x += (30 + (this.newsPanels[index].index - this.newsIndex) * 200 - this.newsPanels[index].x) * 1;
                  }
                  else if(this.newsPanels[index].id != id)
                  {
                        MovieClip(this.newsPanels[index]).parent.removeChild(MovieClip(this.newsPanels[index]));
                        this.newsPanels[index] = new NewsPanel(title,message,date,type,index,youtubeId,id);
                        addChild(this.newsPanels[index]);
                        this.newsPanels[index].y = 416;
                        this.newsPanels[index].x += (30 + (this.newsPanels[index].index - this.newsIndex) * 200 - this.newsPanels[index].x) * 1;
                  }
            }
            
            private function update(evt:Event) : void
            {
                  var panel:NewsPanel = null;
                  for each(panel in this.newsPanels)
                  {
                        panel.y = 416;
                        panel.x += (30 + (panel.index - this.newsIndex) * 200 - panel.x) * 1;
                        panel.update();
                  }
            }
            
            override public function enter() : void
            {
                  var params:SFSObject = null;
                  var r:ExtensionRequest = null;
                  this.main.setOverlayScreen("chatOverlay");
                  stage.frameRate = 30;
                  this.mc.playButton.addEventListener(MouseEvent.CLICK,this.playButton);
                  this.mc.tutorialButton.addEventListener(MouseEvent.CLICK,this.tutorialButton);
                  this.mc.gameGuideButton.addEventListener(MouseEvent.CLICK,this.gameGuideButton);
                  this.mc.campaignButton.addEventListener(MouseEvent.CLICK,this.campaignButton);
                  addEventListener(Event.ENTER_FRAME,this.update);
                  params = new SFSObject();
                  params.putInt("index",0);
                  r = new ExtensionRequest("getNews",params);
                  this.main.sfs.send(r);
                  params = new SFSObject();
                  params.putInt("index",1);
                  r = new ExtensionRequest("getNews",params);
                  this.main.sfs.send(r);
                  params = new SFSObject();
                  params.putInt("index",2);
                  r = new ExtensionRequest("getNews",params);
                  this.main.sfs.send(r);
                  params = new SFSObject();
                  params.putInt("index",3);
                  r = new ExtensionRequest("getNews",params);
                  this.main.sfs.send(r);
            }
            
            private function gameGuideButton(e:Event) : void
            {
                  var url:URLRequest = new URLRequest("http://www.stickpage.com/stickempiresguide.shtml");
                  navigateToURL(url,"_blank");
                  if(Boolean(this.main.tracker))
                  {
                        this.main.tracker.trackEvent("link","http://www.stickpage.com/stickempiresguide.shtml");
                  }
            }
            
            private function playButton(evt:MouseEvent) : void
            {
                  this.main.sfs.send(new ExtensionRequest("match"));
                  this.main.soundManager.playSoundFullVolume("StartMatchmaking");
            }
            
            private function campaignButton(e:Event) : void
            {
                  var url:URLRequest = new URLRequest("http://www.stickpage.com/stickwar2gameplay.shtml");
                  navigateToURL(url,"_blank");
                  if(Boolean(this.main.tracker))
                  {
                        this.main.tracker.trackEvent("link","http://www.stickpage.com/stickwar2gameplay.shtml");
                  }
            }
            
            private function tutorialButton(evt:MouseEvent) : void
            {
                  this.main.campaign.currentLevel = 0;
                  this.main.campaign.justTutorial = true;
                  this.main.showScreen("campaignGameScreen");
                  var s:SFSObject = new SFSObject();
                  this.main.sfs.send(new ExtensionRequest("cancelMatch",s));
            }
            
            override public function leave() : void
            {
                  this.mc.playButton.removeEventListener(MouseEvent.CLICK,this.playButton);
                  removeEventListener(Event.ENTER_FRAME,this.update);
                  this.mc.gameGuideButton.removeEventListener(MouseEvent.CLICK,this.gameGuideButton);
                  this.mc.campaignButton.removeEventListener(MouseEvent.CLICK,this.campaignButton);
                  this.mc.tutorialButton.removeEventListener(MouseEvent.CLICK,this.tutorialButton);
            }
      }
}
