
local E, C, L = unpack(select(2, ...)) -- Import Functions/Constants, Config, Locales

if C["chat"].enable ~= true then return end

-----------------------------------------------------------------------
-- SETUP ELVUI CHATS
-----------------------------------------------------------------------

local ElvuiChat = CreateFrame("Frame")
local _G = _G
local origs = {}
local type = type

-- function to rename channel and other stuff
local AddMessage = function(self, text, ...)
	if(type(text) == "string") then
		text = text:gsub('|h%[(%d+)%. .-%]|h', '|h[%1]|h')
	end
	return origs[self](self, text, ...)
end

_G.CHAT_BATTLEGROUND_GET = "|Hchannel:Battleground|h"..L.chat_BATTLEGROUND_GET.."|h %s:\32"
_G.CHAT_BATTLEGROUND_LEADER_GET = "|Hchannel:Battleground|h"..L.chat_BATTLEGROUND_LEADER_GET.."|h %s:\32"
_G.CHAT_BN_WHISPER_GET = L.chat_BN_WHISPER_GET.." %s:\32"
_G.CHAT_GUILD_GET = "|Hchannel:Guild|h"..L.chat_GUILD_GET.."|h %s:\32"
_G.CHAT_OFFICER_GET = "|Hchannel:o|h"..L.chat_OFFICER_GET.."|h %s:\32"
_G.CHAT_PARTY_GET = "|Hchannel:Party|h"..L.chat_PARTY_GET.."|h %s:\32"
_G.CHAT_PARTY_GUIDE_GET = "|Hchannel:party|h"..L.chat_PARTY_GUIDE_GET.."|h %s:\32"
_G.CHAT_PARTY_LEADER_GET = "|Hchannel:party|h"..L.chat_PARTY_LEADER_GET.."|h %s:\32"
_G.CHAT_RAID_GET = "|Hchannel:raid|h"..L.chat_RAID_GET.."|h %s:\32"
_G.CHAT_RAID_LEADER_GET = "|Hchannel:raid|h"..L.chat_RAID_LEADER_GET.."|h %s:\32"
_G.CHAT_RAID_WARNING_GET = L.chat_RAID_WARNING_GET.." %s:\32"
_G.CHAT_SAY_GET = "%s:\32"
_G.CHAT_WHISPER_GET = L.chat_WHISPER_GET.." %s:\32"
_G.CHAT_YELL_GET = "%s:\32"
 
_G.CHAT_FLAG_AFK = "|cffFF0000"..L.chat_FLAG_AFK.."|r "
_G.CHAT_FLAG_DND = "|cffE7E716"..L.chat_FLAG_DND.."|r "
_G.CHAT_FLAG_GM = "|cff4154F5"..L.chat_FLAG_GM.."|r "
 
_G.ERR_FRIEND_ONLINE_SS = "|Hplayer:%s|h[%s]|h "..L.chat_ERR_FRIEND_ONLINE_SS.."!"
_G.ERR_FRIEND_OFFLINE_S = "%s "..L.chat_ERR_FRIEND_OFFLINE_S.."!"

-- Hide friends micro button (added in 3.3.5)
E.Kill(FriendsMicroButton)

-- hide chat bubble menu button
E.Kill(ChatFrameMenuButton)

local EditBoxDummy = CreateFrame("Frame", "EditBoxDummy", UIParent)
EditBoxDummy:SetAllPoints(ElvuiInfoLeft)

-- set the chat style
local function SetChatStyle(frame)
	local id = frame:GetID()
	local chat = frame:GetName()
	local tab = _G[chat.."Tab"]
	
	tab:SetAlpha(1)
	tab.SetAlpha = UIFrameFadeRemoveFrame	
	-- always set alpha to 1, don't fade it anymore
	if C["chat"].showbackdrop ~= true then
		-- hide text when setting chat
		_G[chat.."TabText"]:Hide()

		-- now show text if mouse is found over tab.
		tab:HookScript("OnEnter", function() _G[chat.."TabText"]:Show() end)
		tab:HookScript("OnLeave", function() _G[chat.."TabText"]:Hide() end)
	end
	_G[chat.."TabText"]:SetTextColor(unpack(C["media"].valuecolor))
	_G[chat.."TabText"]:SetFont(C.media.font,C["general"].fontscale,"THINOUTLINE")
	_G[chat.."TabText"].SetTextColor = E.dummy
	local originalpoint = select(2, _G[chat.."TabText"]:GetPoint())
	_G[chat.."TabText"]:SetPoint("LEFT", originalpoint, "RIGHT", 0, -E.mult*2)
	
	--Reposition the "New Message" orange glow so its aligned with the bottom of the chat tab
	for i=1, tab:GetNumRegions() do
		local region = select(i, tab:GetRegions())
		if region:GetObjectType() == "Texture" then
			if region:GetTexture() == "Interface\\ChatFrame\\ChatFrameTab-NewMessage" then
				if C["chat"].showbackdrop == true then
					region:ClearAllPoints()
					region:SetPoint("BOTTOMLEFT", 0, E.Scale(4))
					region:SetPoint("BOTTOMRIGHT", 0, E.Scale(4))
				else
					E.Kill(region)
				end
				if region:GetParent():GetName() == "ChatFrame1Tab" then
					E.Kill(region)
				end
			end
		end
	end
	-- yeah baby
	_G[chat]:SetClampRectInsets(0,0,0,0)
	
	-- Removes crap from the bottom of the chatbox so it can go to the bottom of the screen.
	_G[chat]:SetClampedToScreen(false)
			
	-- Stop the chat chat from fading out
	_G[chat]:SetFading(C["chat"].fadeoutofuse)
	
	-- move the chat edit box
	_G[chat.."EditBox"]:ClearAllPoints();
	_G[chat.."EditBox"]:SetPoint("TOPLEFT", EditBoxDummy, E.Scale(2), E.Scale(-2))
	_G[chat.."EditBox"]:SetPoint("BOTTOMRIGHT", EditBoxDummy, E.Scale(-2), E.Scale(2))
	
	-- Hide textures
	for j = 1, #CHAT_FRAME_TEXTURES do
		_G[chat..CHAT_FRAME_TEXTURES[j]]:SetTexture(nil)
	end

	-- Removes Default ChatFrame Tabs texture				
	E.Kill(_G[format("ChatFrame%sTabLeft", id)])
	E.Kill(_G[format("ChatFrame%sTabMiddle", id)])
	E.Kill(_G[format("ChatFrame%sTabRight", id)])

	E.Kill(_G[format("ChatFrame%sTabSelectedLeft", id)])
	E.Kill(_G[format("ChatFrame%sTabSelectedMiddle", id)])
	E.Kill(_G[format("ChatFrame%sTabSelectedRight", id)])
	
	E.Kill(_G[format("ChatFrame%sTabHighlightLeft", id)])
	E.Kill(_G[format("ChatFrame%sTabHighlightMiddle", id)])
	E.Kill(_G[format("ChatFrame%sTabHighlightRight", id)])

	-- Killing off the new chat tab selected feature
	E.Kill(_G[format("ChatFrame%sTabSelectedLeft", id)])
	E.Kill(_G[format("ChatFrame%sTabSelectedMiddle", id)])
	E.Kill(_G[format("ChatFrame%sTabSelectedRight", id)])

	-- Kills off the new method of handling the Chat Frame scroll buttons as well as the resize button
	-- Note: This also needs to include the actual frame textures for the ButtonFrame onHover
	E.Kill(_G[format("ChatFrame%sButtonFrameUpButton", id)])
	E.Kill(_G[format("ChatFrame%sButtonFrameDownButton", id)])
	E.Kill(_G[format("ChatFrame%sButtonFrameBottomButton", id)])
	E.Kill(_G[format("ChatFrame%sButtonFrameMinimizeButton", id)])
	E.Kill(_G[format("ChatFrame%sButtonFrame", id)])

	-- Kills off the retarded new circle around the editbox
	E.Kill(_G[format("ChatFrame%sEditBoxFocusLeft", id)])
	E.Kill(_G[format("ChatFrame%sEditBoxFocusMid", id)])
	E.Kill(_G[format("ChatFrame%sEditBoxFocusRight", id)])

	-- Kill off editbox artwork
	local a, b, c = select(6, _G[chat.."EditBox"]:GetRegions()); E.Kill (a); E.Kill (b); E.Kill (c)
				
	-- Disable alt key usage
	_G[chat.."EditBox"]:SetAltArrowKeyMode(false)
	
	-- hide editbox on login
	_G[chat.."EditBox"]:Hide()
	
	-- script to hide editbox instead of fading editbox to 0.35 alpha via IM Style
	_G[chat.."EditBox"]:HookScript("OnEditFocusGained", function(self) self:Show() end)
	_G[chat.."EditBox"]:HookScript("OnEditFocusLost", function(self) self:Hide() end)
	
	-- rename combag log to log
	if _G[chat] == _G["ChatFrame2"] then
		FCF_SetWindowName(_G[chat], "Log")
	end

	-- create our own texture for edit box
	local EditBoxBackground = CreateFrame("frame", "ElvuiChatchatEditBoxBackground", _G[chat.."EditBox"])
	E.CreatePanel(EditBoxBackground, 1, 1, "LEFT", _G[chat.."EditBox"], "LEFT", 0, 0)
	E.SetNormTexTemplate(EditBoxBackground)
	EditBoxBackground:ClearAllPoints()
	EditBoxBackground:SetAllPoints(EditBoxDummy)
	EditBoxBackground:SetFrameStrata("LOW")
	EditBoxBackground:SetFrameLevel(1)
	
	local function colorize(r,g,b)
		EditBoxBackground:SetBackdropBorderColor(r, g, b)
	end
	
	-- update border color according where we talk
	hooksecurefunc("ChatEdit_UpdateHeader", function()
		local type = _G[chat.."EditBox"]:GetAttribute("chatType")
		if ( type == "CHANNEL" ) then
		local id = GetChannelName(_G[chat.."EditBox"]:GetAttribute("channelTarget"))
			if id == 0 then
				colorize(unpack(C.media.bordercolor))
			else
				colorize(ChatTypeInfo[type..id].r,ChatTypeInfo[type..id].g,ChatTypeInfo[type..id].b)
			end
		else
			colorize(ChatTypeInfo[type].r,ChatTypeInfo[type].g,ChatTypeInfo[type].b)
		end
	end)
		
	if _G[chat] ~= _G["ChatFrame2"] then
		origs[_G[chat]] = _G[chat].AddMessage
		_G[chat].AddMessage = AddMessage
	end
end

-- Setup chatframes 1 to 10 on login.
local function SetupChat(self)	
	for i = 1, NUM_CHAT_WINDOWS do
		local frame = _G[format("ChatFrame%s", i)]
		SetChatStyle(frame)
		FCFTab_UpdateAlpha(frame)
	end
	
	local var
	if C["chat"].sticky == true then
		var = 1
	else
		var = 0
	end
	-- Remember last channel
	ChatTypeInfo.WHISPER.sticky = var
	ChatTypeInfo.BN_WHISPER.sticky = var
	ChatTypeInfo.OFFICER.sticky = var
	ChatTypeInfo.RAID_WARNING.sticky = var
	ChatTypeInfo.CHANNEL.sticky = var
end


local function SetupChatPosAndFont(self)
	for i = 1, NUM_CHAT_WINDOWS do
		local chat = _G[format("ChatFrame%s", i)]
		local tab = _G[format("ChatFrame%sTab", i)]
		local id = chat:GetID()
		local name = FCF_GetChatWindowInfo(id)
		local point = GetChatWindowSavedPosition(id)
		local _, fontSize = FCF_GetChatWindowInfo(id)
		local button = _G[format("ButtonCF%d", i)]
		local _, _, _, _, _, _, _, _, docked, _ = GetChatWindowInfo(id)
		
		chat:SetFrameStrata("LOW")
		
		-- well... Elvui font under fontsize 10 is unreadable.
		FCF_SetChatWindowFontSize(nil, chat, fontSize)
		
		
		-- force chat position on #1 and #3, needed if we change ui scale or resolution
		if i == 1 then
			chat:ClearAllPoints()
			chat:SetPoint("BOTTOMLEFT", ChatLBackground, "BOTTOMLEFT", E.Scale(2), E.Scale(4))
			_G["ChatFrame"..i]:SetSize(E.Scale(C["chat"].chatwidth - 4), E.Scale(C["chat"].chatheight))
			FCF_SavePositionAndDimensions(chat)
		elseif point == "BOTTOMRIGHT" and C["chat"].rightchat == true and ChatFrame3:IsShown() then
			chatrightfound = true
			E.ChatRightShown = true
			chat:ClearAllPoints()
			chat:SetPoint("BOTTOMLEFT", ChatRBackground, "BOTTOMLEFT", E.Scale(2), E.Scale(4))
			_G["ChatFrame"..i]:SetSize(E.Scale(C["chat"].chatwidth - 4), E.Scale(C["chat"].chatheight))
			FCF_SavePositionAndDimensions(chat)
		end
		
		if C["chat"].rightchat == true then
			if ChatRBG then
				ChatRBG:SetAlpha(1)
			end
		end
				
		if not docked and (chat:GetName() == "ChatFrame3" and C["chat"].rightchat == true) and C["chat"].showbackdrop == true then
			button:ClearAllPoints()
			button:SetAlpha(1)
			button:SetPoint("BOTTOMRIGHT", ChatRBackground, "TOPRIGHT", 0, E.Scale(3))
			button:SetScript("OnEnter", function() end)
			button:SetScript("OnLeave", function() end)
		elseif not docked and not (chat:GetName() == "ChatFrame3" and C["chat"].rightchat == true) and C["chat"].showbackdrop == true then
			button:ClearAllPoints()
			button:SetAlpha(0)
			button:SetPoint("TOPRIGHT", chat, "TOPRIGHT", 0, 0)
			button:SetScript("OnEnter", function() button:SetAlpha(1) end)
			button:SetScript("OnLeave", function() button:SetAlpha(0) end)
		elseif docked and C["chat"].showbackdrop == true then
			button:ClearAllPoints()
			button:SetAlpha(1)
			button:SetPoint("BOTTOMRIGHT", ChatLBackground, "TOPRIGHT", 0, E.Scale(3))
			button:SetScript("OnEnter", function() end)
			button:SetScript("OnLeave", function() end)
		end
		
		tab:HookScript("OnDragStop", function(self)
			local id = self:GetID()
			local chat = _G[format("ChatFrame%d", id)]
			local button = _G[format("ButtonCF%d", id)]
			local _, _, _, _, _, _, _, _, docked, _ = GetChatWindowInfo(id)
			if not docked and (chat:GetName() == "ChatFrame3" and C["chat"].rightchat == true) and C["chat"].showbackdrop == true then
				button:ClearAllPoints()
				button:SetAlpha(1)
				button:SetPoint("BOTTOMRIGHT", ChatRBackground, "TOPRIGHT", 0, E.Scale(3))
				button:SetScript("OnEnter", function() end)
				button:SetScript("OnLeave", function() end)
			elseif not docked and not (chat:GetName() == "ChatFrame3" and C["chat"].rightchat == true) and C["chat"].showbackdrop == true then
				button:ClearAllPoints()
				button:SetAlpha(0)
				button:SetPoint("TOPRIGHT", chat, "TOPRIGHT", 0, 0)
				button:SetScript("OnEnter", function() button:SetAlpha(1) end)
				button:SetScript("OnLeave", function() button:SetAlpha(0) end)
			elseif docked and C["chat"].showbackdrop == true then
				button:ClearAllPoints()
				button:SetAlpha(1)
				button:SetPoint("BOTTOMRIGHT", ChatLBackground, "TOPRIGHT", 0, E.Scale(3))
				button:SetScript("OnEnter", function() end)
				button:SetScript("OnLeave", function() end)
			end
		end)
		
		tab:HookScript("OnDragStart", function(self)
			local id = self:GetID()
			local chat = _G[format("ChatFrame%d", id)]
			local button = _G[format("ButtonCF%d", id)]
			local _, _, _, _, _, _, _, _, docked, _ = GetChatWindowInfo(id)
			if not docked and (chat:GetName() == "ChatFrame3" and C["chat"].rightchat == true) and C["chat"].showbackdrop == true then
				button:ClearAllPoints()
				button:SetAlpha(1)
				button:SetPoint("BOTTOMRIGHT", ChatRBackground, "TOPRIGHT", 0, E.Scale(3))
				button:SetScript("OnEnter", function() end)
				button:SetScript("OnLeave", function() end)
			elseif not docked and not (chat:GetName() == "ChatFrame3" and C["chat"].rightchat == true) and C["chat"].showbackdrop == true then
				button:ClearAllPoints()
				button:SetAlpha(0)
				button:SetPoint("TOPRIGHT", chat, "TOPRIGHT", 0, 0)
				button:SetScript("OnEnter", function() button:SetAlpha(1) end)
				button:SetScript("OnLeave", function() button:SetAlpha(0) end)
			elseif docked and C["chat"].showbackdrop == true then
				button:ClearAllPoints()
				button:SetAlpha(1)
				button:SetPoint("BOTTOMRIGHT", ChatLBackground, "TOPRIGHT", 0, E.Scale(3))
				button:SetScript("OnEnter", function() end)
				button:SetScript("OnLeave", function() end)
			end
		end)
	end
end
hooksecurefunc("FCF_OpenNewWindow", SetupChatPosAndFont)
hooksecurefunc("FCF_DockFrame", SetupChatPosAndFont)

ElvuiChat:RegisterEvent("ADDON_LOADED")
ElvuiChat:RegisterEvent("PLAYER_ENTERING_WORLD")
ElvuiChat:SetScript("OnEvent", function(self, event, ...)
	local addon = ...
	if event == "ADDON_LOADED" then
		if addon == "Blizzard_CombatLog" then
			self:UnregisterEvent("ADDON_LOADED")
			SetupChat(self)
			--return CombatLogQuickButtonFrame_Custom:SetAlpha(.4)
		end
	elseif event == "PLAYER_ENTERING_WORLD" then
			self:UnregisterEvent("PLAYER_ENTERING_WORLD")
			SetupChatPosAndFont(self)
	end
end)

-- Setup temp chat (BN, WHISPER) when needed.
local function SetupTempChat()
	local frame = FCF_GetCurrentChatFrame()
	SetChatStyle(frame)
end
hooksecurefunc("FCF_OpenTemporaryWindow", SetupTempChat)

-- /tt - tell your current target.
for i = 1, NUM_CHAT_WINDOWS do
	local editBox = _G["ChatFrame"..i.."EditBox"]
	editBox:HookScript("OnTextChanged", function(self)
	   local text = self:GetText()
	   if text:len() < 5 then
		  if text:sub(1, 4) == "/tt " then
			 local unitname, realm
			 unitname, realm = UnitName("target")
			 if unitname then unitname = gsub(unitname, " ", "") end
			 if unitname and not UnitIsSameServer("player", "target") then
				unitname = unitname .. "-" .. gsub(realm, " ", "")
			 end
			 ChatFrame_SendTell((unitname or L.chat_invalidtarget), ChatFrame1)
		  end
	   end
	end)
end

-----------------------------------------------------------------------------
-- Copy on chatframes feature
-----------------------------------------------------------------------------

local lines = {}
local frame = nil
local editBox = nil
local isf = nil

local function CreatCopyFrame()
	frame = CreateFrame("Frame", "CopyFrame", UIParent)
	frame:SetBackdrop({
			bgFile = C["media"].blank, 
			edgeFile = C["media"].blank, 
			tile = 0, tileSize = 0, edgeSize = E.mult, 
			insets = { left = -E.mult, right = -E.mult, top = -E.mult, bottom = -E.mult }
	})
	frame:SetBackdropColor(unpack(C["media"].backdropcolor))
	frame:SetBackdropBorderColor(unpack(C["media"].bordercolor))
	frame:SetHeight(E.Scale(200))
	frame:SetScale(1)
	frame:SetPoint("BOTTOMLEFT", ElvuiSplitActionBarLeftBackground, "BOTTOMLEFT", 0, 0)
	frame:SetPoint("BOTTOMRIGHT", ElvuiSplitActionBarRightBackground, "BOTTOMRIGHT", 0, 0)
	frame:Hide()
	frame:EnableMouse(true)
	frame:SetFrameStrata("DIALOG")

	
	E.AnimGroup(frame, 0, E.Scale(-220), 0.4)

	local scrollArea = CreateFrame("ScrollFrame", "CopyScroll", frame, "UIPanelScrollFrameTemplate")
	scrollArea:SetPoint("TOPLEFT", frame, "TOPLEFT", E.Scale(8), E.Scale(-30))
	scrollArea:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", E.Scale(-30), E.Scale(8))

	editBox = CreateFrame("EditBox", "CopyBox", frame)
	editBox:SetMultiLine(true)
	editBox:SetMaxLetters(99999)
	editBox:EnableMouse(true)
	editBox:SetAutoFocus(false)
	editBox:SetFontObject(ChatFontNormal)
	editBox:SetWidth(E.Scale(710))
	editBox:SetHeight(E.Scale(200))
	editBox:SetScript("OnEscapePressed", function()
		E.SlideOut(frame)
	end)

	scrollArea:SetScrollChild(editBox)

	local close = CreateFrame("Button", "CopyCloseButton", frame, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", frame, "TOPRIGHT")
	close:EnableMouse(true)
	close:SetScript("OnMouseDown", function()
		E.SlideOut(frame)
	end)
	
	isf = true
	
	frame:HookScript("OnShow", function(self, ...)
		E.SlideIn(frame)
	end)
end

local function GetLines(...)
	--[[		Grab all those lines		]]--
	local ct = 1
	for i = select("#", ...), 1, -1 do
		local region = select(i, ...)
		if region:GetObjectType() == "FontString" then
			lines[ct] = tostring(region:GetText())
			ct = ct + 1
		end
	end
	return ct - 1
end

local function Copy(cf)
	local _, size = cf:GetFont()
	FCF_SetChatWindowFontSize(cf, cf, 0.01)
	local lineCt = GetLines(cf:GetRegions())
	local text = table.concat(lines, "\n", 1, lineCt)
	FCF_SetChatWindowFontSize(cf, cf, size)
	if not isf then CreatCopyFrame() end
	if frame:IsShown() then E.SlideOut(frame) return end
	frame:Show()
	editBox:SetText(text)
end

function E.ChatCopyButtons()
	for i = 1, NUM_CHAT_WINDOWS do
		local cf = _G[format("ChatFrame%d",  i)]
		local tab = _G[format("ChatFrame%dTab", i)]
		local button = CreateFrame("Button", format("ButtonCF%d", i), cf)
		local id = cf:GetID()
		local name = FCF_GetChatWindowInfo(id)
		local point = GetChatWindowSavedPosition(id)
		local _, fontSize = FCF_GetChatWindowInfo(id)
		local button = _G[format("ButtonCF%d", i)]
		local _, _, _, _, _, _, _, _, docked, _ = GetChatWindowInfo(id)
		
		button:SetHeight(E.Scale(22))
		button:SetWidth(E.Scale(20))
		if C["chat"].showbackdrop ~= true or (C["chat"].rightchat ~= true and docked == nil) then
			button:SetAlpha(0)
			button:SetPoint("TOPRIGHT", 0, 0)
		else
			button:SetPoint("BOTTOMRIGHT", ChatLBackground, "TOPRIGHT", 0, E.Scale(3))
		end
		E.SetNormTexTemplate(button)
		E.CreateShadow(button)
		
		local buttontext = button:CreateFontString(nil,"OVERLAY",nil)
		buttontext:SetFont(C.media.font,C["general"].fontscale,"OUTLINE")
		buttontext:SetText("C")
		buttontext:SetPoint("CENTER", E.Scale(1), 0)
		buttontext:SetJustifyH("CENTER")
		buttontext:SetJustifyV("CENTER")
		buttontext:SetTextColor(unpack(C["media"].valuecolor))
		
				
		button:SetScript("OnMouseUp", function(self, btn)
			if i == 1 and btn == "RightButton" then
				ToggleFrame(ChatMenu)
			else
				Copy(cf)
			end
		end)
		
		if C["chat"].showbackdrop ~= true then
			button:SetScript("OnEnter", function() 
				button:SetAlpha(1) 
			end)
			button:SetScript("OnLeave", function() button:SetAlpha(0) end)
		end
	end
end
E.ChatCopyButtons()

------------------------------------------------------------------------
--	Enhance/rewrite a Blizzard feature, chatframe mousewheel.
------------------------------------------------------------------------

local ScrollLines = 3 -- set the jump when a scroll is done !
function FloatingChatFrame_OnMouseScroll(self, delta)
	if delta < 0 then
		if IsShiftKeyDown() then
			self:ScrollToBottom()
		else
			for i = 1, ScrollLines do
				self:ScrollDown()
			end
		end
	elseif delta > 0 then
		if IsShiftKeyDown() then
			self:ScrollToTop()
		else
			for i = 1, ScrollLines do
				self:ScrollUp()
			end
		end
	end
end

------------------------------------------------------------------------
--	Play sound files system
------------------------------------------------------------------------

if C.chat.whispersound then
	local SoundSys = CreateFrame("Frame")
	SoundSys:RegisterEvent("CHAT_MSG_WHISPER")
	SoundSys:RegisterEvent("CHAT_MSG_BN_WHISPER")
	SoundSys:HookScript("OnEvent", function(self, event, ...)
		if event == "CHAT_MSG_WHISPER" or "CHAT_MSG_BN_WHISPER" then
			PlaySoundFile(C["media"].whisper)
		end
	end)
end

----------------------------------------------------------------------
-- Setup animating chat during combat
----------------------------------------------------------------------

local ChatCombatHider = CreateFrame("Frame")
ChatCombatHider:RegisterEvent("PLAYER_REGEN_ENABLED")
ChatCombatHider:RegisterEvent("PLAYER_REGEN_DISABLED")
ChatCombatHider:SetScript("OnEvent", function(self, event)
	if C["chat"].combathide ~= "Left" and C["chat"].combathide ~= "Right" and C["chat"].combathide ~= "Both" then self:UnregisterAllEvents() return end
	if (C["chat"].combathide == "Right" or C["chat"].combathide == "Both") and C["chat"].rightchat ~= true then return end
	
	if event == "PLAYER_REGEN_DISABLED" then
		if C["chat"].combathide == "Both" then	
			if E.ChatRIn ~= false then
				E.SlideOut(ChatRBackground)		
				if IsAddOnLoaded("DXE") and DXEAlertsTopStackAnchor and C["skin"].hookdxeright == true then
					DXEAlertsTopStackAnchor:ClearAllPoints()
					DXEAlertsTopStackAnchor:SetPoint("BOTTOM", ChatRBackground2, "TOP", 13, -5)
				end
				E.ChatRightShown = false
				E.ChatRIn = false
				ElvuiInfoRightRButton.Text:SetTextColor(unpack(C["media"].valuecolor))			
			end
			if E.ChatLIn ~= false then
				E.SlideOut(ChatLBackground)
				E.ChatLIn = false
				ElvuiInfoLeftLButton.Text:SetTextColor(unpack(C["media"].valuecolor))
			end
		elseif C["chat"].combathide == "Right" then
			if E.ChatRIn ~= false then
				E.SlideOut(ChatRBackground)		
				if IsAddOnLoaded("DXE") and DXEAlertsTopStackAnchor and C["skin"].hookdxeright == true then
					DXEAlertsTopStackAnchor:ClearAllPoints()
					DXEAlertsTopStackAnchor:SetPoint("BOTTOM", ChatRBackground2, "TOP", 13, -5)
				end
				E.ChatRightShown = false
				E.ChatRIn = false
				ElvuiInfoRightRButton.Text:SetTextColor(unpack(C["media"].valuecolor))			
			end		
		elseif C["chat"].combathide == "Left" then
			if E.ChatLIn ~= false then
				E.SlideOut(ChatLBackground)
				E.ChatLIn = false
				ElvuiInfoLeftLButton.Text:SetTextColor(unpack(C["media"].valuecolor))
			end		
		end
	else
		if C["chat"].combathide == "Both" then
			if E.ChatRIn ~= true then
				E.SlideIn(ChatRBackground)	
				if IsAddOnLoaded("DXE") and DXEAlertsTopStackAnchor and C["skin"].hookdxeright == true and C["chat"].rightchat == true and C["chat"].showbackdrop == true then
					DXEAlertsTopStackAnchor:ClearAllPoints()
					DXEAlertsTopStackAnchor:SetPoint("BOTTOM", ChatRBackground2, "TOP", 13, 18)
				end				
				E.ChatRightShown = true
				E.ChatRIn = true
				ElvuiInfoRightRButton.Text:SetTextColor(1,1,1)			
			end
			if E.ChatLIn ~= true then
				E.SlideIn(ChatLBackground)
				E.ChatLIn = true
				ElvuiInfoLeftLButton.Text:SetTextColor(1,1,1)
			end
		elseif C["chat"].combathide == "Right" then
			if E.ChatRIn ~= true then
				E.SlideIn(ChatRBackground)	
				if IsAddOnLoaded("DXE") and DXEAlertsTopStackAnchor and C["skin"].hookdxeright == true and C["chat"].rightchat == true and C["chat"].showbackdrop == true then
					DXEAlertsTopStackAnchor:ClearAllPoints()
					DXEAlertsTopStackAnchor:SetPoint("BOTTOM", ChatRBackground2, "TOP", 13, 18)
				end					
				E.ChatRightShown = true
				E.ChatRIn = true
				ElvuiInfoRightRButton.Text:SetTextColor(1,1,1)			
			end		
		elseif C["chat"].combathide == "Left" then
			if E.ChatLIn ~= true then
				E.SlideIn(ChatLBackground)
				E.ChatLIn = true
				ElvuiInfoLeftLButton.Text:SetTextColor(1,1,1)
			end		
		end	
	end
end)

E.SetUpAnimGroup(ElvuiInfoLeft.shadow)
E.SetUpAnimGroup(ElvuiInfoRight.shadow)
local function CheckWhisperWindows(self, event)
	local chat = self:GetName()

	if chat == "ChatFrame1" and E.ChatLIn == false then
		if event == "CHAT_MSG_WHISPER" then
			ElvuiInfoLeft.shadow:SetBackdropBorderColor(ChatTypeInfo["WHISPER"].r,ChatTypeInfo["WHISPER"].g,ChatTypeInfo["WHISPER"].b, 1)
		elseif event == "CHAT_MSG_BN_WHISPER" then
			ElvuiInfoLeft.shadow:SetBackdropBorderColor(ChatTypeInfo["BN_WHISPER"].r,ChatTypeInfo["BN_WHISPER"].g,ChatTypeInfo["BN_WHISPER"].b, 1)
		end
		ElvuiInfoLeft:SetScript("OnUpdate", function(self)
			E.Flash(ElvuiInfoLeft.shadow, 0.5)
		end)
	elseif chat == "ChatFrame3" and C["chat"].rightchat == true and E.ChatRIn == false then
		if event == "CHAT_MSG_WHISPER" then
			ElvuiInfoRight.shadow:SetBackdropBorderColor(ChatTypeInfo["WHISPER"].r,ChatTypeInfo["WHISPER"].g,ChatTypeInfo["WHISPER"].b, 1)
		elseif event == "CHAT_MSG_BN_WHISPER" then
			ElvuiInfoRight.shadow:SetBackdropBorderColor(ChatTypeInfo["BN_WHISPER"].r,ChatTypeInfo["BN_WHISPER"].g,ChatTypeInfo["BN_WHISPER"].b, 1)
		end
		ElvuiInfoRight:SetScript("OnUpdate", function(self)
			E.Flash(ElvuiInfoRight.shadow, 0.5)
		end)	
	end
end
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", CheckWhisperWindows)	
ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER", CheckWhisperWindows)