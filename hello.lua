module("extensions.hello", package.seeall)
extension = sgs.Package("hello")
sgs.LoadTranslationTable{
	["hello"] = "你好"
}
herobrine = sgs.General(extension, "herobrine", "god", "3")



HuHou = sgs.CreateMaxCardsSkill{
            name = "HuHou" ,
            extra_func = function(self, target)
            if (target:hasSkill(self:objectName()) and target:hasSkill("mashu")) then
			if (target:aliveCount()>target:getHp()) then
			extra = target:aliveCount() - target:getHp()
            return extra
			end
            else
			return 0
			end
			
			
			end
        }
		
		
GuanshiCard = sgs.CreateSkillCard{
        name = "GuanshiCard",
        target_fixed = true,
        
        on_use = function(self, room, source, targets)
        source:setFlags(flagName)
	    source:setFlags("mashu")
		
		room:setPlayerMark(source,markName,1)
                        

        end
    }
	
	addHpCard = sgs.CreateSkillCard{
        name = "addHpCard",
        target_fixed = false,
		filter = function(self, targets, to_select)
            return #targets == 0 
        end,
        
        on_effect = function(self, effect)
		 
            local room = effect.to:getRoom()
			room:setPlayerProperty(effect.to,"maxhp",sgs.QVariant(effect.to:getMaxHp()+1))
            local recover = sgs.RecoverStruct()
            recover.card = self
            recover.who = effect.from
			recover.recover=1
            room:recover(effect.to, recover)
        end
    }
	
	GBenghuaiCard = sgs.CreateSkillCard{
        name = "GBenghuaiCard",
        target_fixed = false,
		filter = function(self, targets, to_select)
            return #targets == 0 
        end,
        
        on_effect = function(self, effect)
		 
            local room = effect.to:getRoom()
			room:acquireSkill(effect.to,"benghuai")
        end
    }
	
	GTurnOverCard = sgs.CreateSkillCard{
        name = "GTurnOverCard",
        target_fixed = false,
		filter = function(self, targets, to_select)
            return #targets == 0 
        end,
        
        on_effect = function(self, effect)
		 
            effect.to:turnOver()
			
        end
    }
	
	GDrawCard = sgs.CreateSkillCard{
        name = "GDrawCard",
        target_fixed = false,
		filter = function(self, targets, to_select)
            return #targets == 0 
        end,
        
        on_effect = function(self, effect)
		 
            effect.to:drawCards(effect.to:getMaxHp(), self:objectName())
			
        end
    }
	
	Gunshiji = sgs.CreateTriggerSkill{
        name = "Gunshiji",
        events = {sgs.CardFinished,sgs.EventPhaseStart} ,
		frequency = sgs.Skill_Compulsory,
        on_trigger = function(self, event, player, data)
        
		 function  judgeRoundStart(mark,room)
		  for i,markMember in ipairs(mark) do
		   if(player:getMark(markMember)>0) then 
		    room:setPlayerMark(player,markMember,0) 
		return 0
		   end
		  end
		 end 
		mark={"baao","quan_buyi","juxiang","yi_ji"}
		flags={"paoxiao","roulin","xianzhen","fuhun","liegong","qiaomeng","mengjin","lihuo","qiangxi","qixi","tianyi","huxiao","jueqing"}
		local room=player:getRoom()
		if(player:getPhase()==sgs.Player_RoundStart and player:hasSkill(MyLuoyi)) then
		 judgeRoundStart(mark,room)
		end
		
		function acquireOrDetachSkillArmor(mark,skillFirst,skillSecond)
		 for i=1,#mark do
		 if not player:hasSkill(skillFirst[i]) and player:getMark(mark[i])==1 then
		  player:getRoom():acquireSkill(player,skillFirst[i])
		  player:getRoom():acquireSkill(player,skillSecond[i])
		 return 0
	    elseif player:hasSkill(skillFirst[i]) and (not (player:getMark(mark[i])==1)) then
		 player:getRoom():detachSkillFromPlayer(player,skillFirst[i])
		 player:getRoom():detachSkillFromPlayer(player,skillSecond[i])
		return 1
		end
		end
		end
		
		function acquireOrDetachSkillWeapon(flags)
		for i,flag in ipairs(flags) do
		 if (not player:hasSkill(flag) and player:hasFlag(flag)) then
		  player:getRoom():acquireSkill(player,flag)
		return "success acquiring skillWeapon "
		
	    elseif(player:hasSkill(flag) and not player:hasFlag(flag)) then
	      player:getRoom():detachSkillFromPlayer(player,flag)
		return "success detaching skillWeapon "
		end
		end
		end
		
		--if (player:getFlags) then
		 skillFirst={"bazhen","quanji","juxiang","yizhong"}
		 skillSecond={"aocai","buyi","huoshou","jiang"}
		  
		  if (not player:hasSkill("mashu") and player:hasFlag("mashu")) then
		  player:getRoom():acquireSkill(player,"mashu")
		  elseif(player:hasSkill("mashu") and not player:hasFlag("mashu")) then
	      player:getRoom():detachSkillFromPlayer(player,"mashu")
		  end
		  
		  
		acquireOrDetachSkillArmor(mark,skillFirst,skillSecond)
		--return 
		--else
		 acquireOrDetachSkillWeapon(flags)
		--end
		 end,
		
		can_trigger=function(self,target)
		return true
		end
		}
		
	
		--x={flagName}
		--y={markName}
		MyHuchi=sgs.CreateViewAsSkill{
		name="MyHuchi",
		n=1,
		view_filter = function(self, selected, to_select)
		return #selected==0 and to_select:getTypeId()==sgs.Card_TypeEquip
		end,
		view_as = function(self, cards)
	    if #cards == 1 then
                flagName=nil
		markName=nil
		function setSkillNameA(ArmorNames,Mnames)
		 for i,armorName in ipairs(ArmorNames) do
		 if(cards[1]:getClassName()==armorName) then
		  markName=Mnames[i]
		 return 0
		 end
		 end
		 end
		 
		 function setSkillNameW(weaponNames,Fnames)
		  for i,weaponName in ipairs(weaponNames) do
		 if(cards[1]:getClassName()==weaponName) then
		  flagName=Fnames[i]
		 return 1
		 end
		 end
		 end
		 
		 HN={"ChiTu","DaYuan","DiLu","HuaLiu","JueYing","ZhuaHuangFeiDian","ZiXing"}
		 ArmorNames={"Vine","SilverLion","EightDiagram","RenwangShield"}
		 Mnames={"juxiang","quan_buyi","baao","yi_ji"}
		 weaponNames={"Crossbow","DoubleSword","QinggangSword","Spear","Axe","KylinBow","IceSword","Fan","YitianSword","GudingBlade","Halberd","Blade","YxSword"}
		 Fnames={"paoxiao","roulin","xianzhen","fuhun","liegong","qiaomeng","mengjin","lihuo","qiangxi","qixi","tianyi","huxiao","jueqing"}
		 setSkillNameA(ArmorNames,Mnames)
         setSkillNameW(weaponNames,Fnames)
         if(flagName or markName) then
	     local card = GuanshiCard:clone()
         card:addSubcard(cards[1])
         return card
         elseif((cards[1]:getClassName()=="OffensiveHorse" or cards[1]:getClassName()=="DefensiveHorse") and cards[1]:getSuit() == sgs.Card_Spade) then
		 local card = GBenghuaiCard:clone()
         card:addSubcard(cards[1])
         return card
		 elseif((cards[1]:getClassName()=="OffensiveHorse" or cards[1]:getClassName()=="DefensiveHorse") and cards[1]:getSuit() == sgs.Card_Club) then
		 local card = GTurnOverCard:clone()
         card:addSubcard(cards[1])
         return card
		 elseif((cards[1]:getClassName()=="OffensiveHorse" or cards[1]:getClassName()=="DefensiveHorse") and cards[1]:getSuit() == sgs.Card_Diamond) then
		 local card = GDrawCard:clone()
         card:addSubcard(cards[1])
         return card
		 elseif((cards[1]:getClassName()=="OffensiveHorse" or cards[1]:getClassName()=="DefensiveHorse") and cards[1]:getSuit() == sgs.Card_Heart) then
		 local card = addHpCard:clone()
         card:addSubcard(cards[1])
         return card
		
		 end    
		 end
         end,
          
		 enabled_at_play = function(self, player)
           if not player:hasUsed("#GuanshiCard") then
             return true
           end
           return false
         end
		 }
		 
		 
		MyLuoyi = sgs.CreateTriggerSkill{
        name = "MyLuoyi",
        frequency = sgs.Skill_Compulsory,
        events = {sgs.DamageCaused},
        on_trigger = function(self, event, player, data)
            
			if(not player:hasEquip() and player:hasSkill(MyLuoyi)) then
			local damage = data:toDamage()
            if damage.chain or damage.transfer or (not damage.by_user) then return false end
            local reason = damage.card
            if reason and (reason:isKindOf("Slash") or reason:isKindOf("Duel")) then
                damage.damage = damage.damage + 1
                data:setValue(damage)
            end
			end
            return false
			
        end,
        can_trigger = function(self, target)
            return target and  target:isAlive()
        end
    }
herobrine:addSkill(Gunshiji)
herobrine:addSkill(HuHou)
herobrine:addSkill(MyLuoyi)
herobrine:addSkill(MyHuchi)

sgs.LoadTranslationTable{
	
	["herobrine"]="神许褚",
	["Gunshiji"] = "虎士",
	[":Gunshiji"] = "锁定计，若你于出牌阶段发动过虎痴，则你拥有技能马术直到回合结束",
	["HuHou"] = "虎侯",
	[":HuHou"] = "锁定计，若你于出牌阶段发动过虎痴，则你的手牌上限等于场上存活人数直到回合结束",
	["MyLuoyi"] = "裸衣",
	[":MyLuoyi"] = "锁定计，若你装备区内无牌时，你使用的杀和决斗伤害+1",
	["MyHuchi"] = "虎痴",
	[":MyHuchi"] = "出牌阶段限一次，你可以弃置一张装备牌，然后执行以下效果：",
	}
		
