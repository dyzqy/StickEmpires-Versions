package com.brockw.stickwar
{
      import com.brockw.game.*;
      import com.brockw.stickwar.campaign.*;
      import com.brockw.stickwar.engine.multiplayer.*;
      import com.google.analytics.GATracker;
      import flash.display.*;
      import flash.events.*;
      import flash.external.ExternalInterface;
      
      [Frame(factoryClass="com.brockw.stickwar.CampaignPreloader")]
      [SWF(frameRate="30",width="850",height="700")]
      public class stickwar2 extends BaseMain
      {
             
            
            private var campaignMenuScreen:CampaignMenuScreen;
            
            private var _postGameScreen:PostGameScreen;
            
            public function stickwar2()
            {
                  super();
                  var xmlLoader:XMLLoader = new XMLLoader();
                  this.xml = xmlLoader;
                  isCampaignDebug = xmlLoader.xml.campaignDebug == 1;
                  postGameScreen = new PostGameScreen(this);
                  addScreen("postGame",postGameScreen);
                  addScreen("campaignMap",new CampaignScreen(this));
                  addScreen("campaignGameScreen",new CampaignGameScreen(this));
                  addScreen("campaignUpgradeScreen",new CampaignUpgradeScreen(this));
                  addScreen("summary",new EndOfGameSummary(this));
                  addScreen("mainMenu",this.campaignMenuScreen = new CampaignMenuScreen(this));
                  this.campaign = new Campaign(0,0);
                  this.addEventListener(Event.ADDED_TO_STAGE,this.addedToStage);
            }
            
            private function addedToStage(evt:Event) : void
            {
                  showScreen("mainMenu");
                  tracker = null;
                  if(ExternalInterface.available)
                  {
                        tracker = new GATracker(this,"UA-36522838-2","AS3",false);
                        tracker.trackPageview("/play");
                        tracker.trackEvent("hostname","url",stage.loaderInfo.url);
                  }
            }
      }
}
