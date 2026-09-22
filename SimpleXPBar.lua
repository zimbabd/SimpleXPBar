-- ============================================================================
-- SimpleXPBar — Session XP/Hour System
-- Author: zimbabd
-- ============================================================================

local SimpleXPBar = LibStub("AceAddon-3.0"):NewAddon("SimpleXPBar", "AceConsole-3.0", "AceEvent-3.0")

-- ----------------------------------------------------------------------------
-- Переменные и настройки
-- ----------------------------------------------------------------------------
SimpleXPBar.session = {
    startTime = 0,
    gainedXP = 0,
    lastXP = 0,
    maxXP = 0,
}

local NUM_SEGMENTS = 20            -- Количество сегментов Blizzard (по 5%)
local BAR_WIDTH = 600              -- Ширина полосы
local BAR_HEIGHT = 24              -- Высота полосы

-- ----------------------------------------------------------------------------
-- Утилиты форматирования
-- ----------------------------------------------------------------------------
local function FormatXP(xp)
    if not xp or xp < 0 then return "0" end
    if xp >= 1000000 then
        return string.format("%.1fm", xp / 1000000)
    elseif xp >= 1000 then
        return string.format("%.1fk", xp / 1000)
    else
        return tostring(math.floor(xp))
    end
end

function SimpleXPBar:FormatTime(seconds)
    if not seconds or seconds <= 0 or seconds == math.huge or seconds ~= seconds then
        return "N/A"
    end
    local hours = math.floor(seconds / 3600)
    local mins = math.floor((seconds % 3600) / 60)
    if hours > 0 then
        return string.format("%dh %dm", hours, mins)
    else
        return string.format("%dm", mins)
    end
end

function SimpleXPBar:GetSessionXPHour()
    if self.session.startTime == 0 then return 0 end
    local elapsedSeconds = _G.time() - self.session.startTime
    if elapsedSeconds < 10 then return 0 end
    return math.floor((self.session.gainedXP / elapsedSeconds) * 3600)
end

-- ----------------------------------------------------------------------------
-- Логика событий XP
-- ----------------------------------------------------------------------------
function SimpleXPBar:OnXPUpdate()
    local currentXP = _G.UnitXP("player") or 0
    local maxXP = _G.UnitXPMax("player") or 1

    if self.session.lastXP == 0 then
        self.session.lastXP = currentXP
        self.session.maxXP = maxXP
        return
    end

    local gainedXP = 0
    if currentXP >= self.session.lastXP then
        gainedXP = currentXP - self.session.lastXP
    else
        gainedXP = (self.session.maxXP - self.session.lastXP) + currentXP
    end

    if gainedXP > 0 then
        self.session.gainedXP = self.session.gainedXP + gainedXP
    end

    self.session.lastXP = currentXP
    self.session.maxXP = maxXP
    self:Update()
end

-- ----------------------------------------------------------------------------
-- Создание UI
-- ----------------------------------------------------------------------------
function SimpleXPBar:CreateUI()
    if self.frame then return end

    local backdropTemplate = _G.BackdropTemplateMixin and "BackdropTemplate" or nil

    -- 1. Главный контейнер
    self.frame = CreateFrame("Frame", "SimpleXPBarFrame", UIParent, backdropTemplate)
    self.frame:SetSize(BAR_WIDTH, BAR_HEIGHT)
    self.frame:SetPoint("TOP", UIParent, "TOP", 0, -30)
    self.frame:SetMovable(true)
    self.frame:EnableMouse(true)
    self.frame:RegisterForDrag("LeftButton")
    
    self.frame:SetScript("OnDragStart", function(f)
        if not SimpleXPBarDB.isLocked then f:StartMoving() end
    end)
    self.frame:SetScript("OnDragStop", function(f)
        f:StopMovingOrSizing()
    end)

    -- Фон и обводка (3.3.5 / Retail)
    if self.frame.SetBackdrop then
        self.frame:SetBackdrop({
            bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            tile = true, tileSize = 8, edgeSize = 10,
            insets = { left = 2, right = 2, top = 2, bottom = 2 }
        })
        self.frame:SetBackdropColor(0, 0, 0, 0.7)
    end

    -- 2. StatusBar (Полоса прогресса)
    self.progressBar = CreateFrame("StatusBar", nil, self.frame)
    self.progressBar:SetPoint("TOPLEFT", self.frame, "TOPLEFT", 3, -3)
    self.progressBar:SetPoint("BOTTOMRIGHT", self.frame, "BOTTOMRIGHT", -3, 3)
    self.progressBar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
    self.progressBar:SetStatusBarColor(0.58, 0.0, 0.83)

    -- 3. Сегменты (20 делений)
    self.segments = {}
    local totalWidth = BAR_WIDTH - 6
    local segmentWidth = totalWidth / NUM_SEGMENTS

    for i = 1, NUM_SEGMENTS - 1 do
        local div = self.progressBar:CreateTexture(nil, "OVERLAY")
        div:SetColorTexture(0, 0, 0, 0.8)
        div:SetSize(1, BAR_HEIGHT - 6)
        div:SetPoint("LEFT", self.progressBar, "LEFT", segmentWidth * i, 0)
        self.segments[i] = div
    end

    -- 4. Текст
    self.text = self.progressBar:CreateFontString(nil, "OVERLAY")
    self.text:SetFont("Fonts\\ARIALN.TTF", 12, "OUTLINE")
    self.text:SetPoint("CENTER", self.progressBar, "CENTER", 0, 0)
    self.text:SetTextColor(1, 1, 1, 1)
end

-- ----------------------------------------------------------------------------
-- Обновление UI
-- ----------------------------------------------------------------------------
function SimpleXPBar:Update()
    if not self.frame or not self.frame:IsShown() then return end

    local playerLevel = _G.UnitLevel("player")
    local maxPlayerLevel = _G.GetMaxPlayerLevel and _G.GetMaxPlayerLevel() or 80

    if playerLevel >= maxPlayerLevel then
        self.text:SetText("Max Level Reached")
        self.progressBar:SetMinMaxValues(0, 1)
        self.progressBar:SetValue(1)
        return
    end

    local currentXP = _G.UnitXP("player") or 0
    local maxXP = _G.UnitXPMax("player") or 1
    local remainingXP = maxXP - currentXP

    self.progressBar:SetMinMaxValues(0, maxXP)
    self.progressBar:SetValue(currentXP)

    local sessionXPHour = self:GetSessionXPHour()
    local timeToLevelText = "N/A"

    if sessionXPHour > 0 then
        local secondsLeft = (remainingXP / sessionXPHour) * 3600
        timeToLevelText = self:FormatTime(secondsLeft)
    end

    local pct = (currentXP / maxXP) * 100

    self.text:SetText(string.format(
        "%s / %s (%.1f%%) | %s XP/h | Время до апа: %s",
        FormatXP(currentXP),
        FormatXP(maxXP),
        pct,
        FormatXP(sessionXPHour),
        timeToLevelText
    ))
end

-- ----------------------------------------------------------------------------
-- Обработка Слэш-команд (/sxp)
-- ----------------------------------------------------------------------------
function SimpleXPBar:HandleCommand(input)
    local arg = string.lower(string.trim(input or ""))

    if arg == "lock" then
        SimpleXPBarDB.isLocked = not SimpleXPBarDB.isLocked
        self.frame:EnableMouse(not SimpleXPBarDB.isLocked)
        if SimpleXPBarDB.isLocked then
            self:Print("SimpleXPBar: |cff00ff00Заблокирован|r (закреплен).")
        else
            self:Print("SimpleXPBar: |cffff0000Разблокирован|r (можно перетаскивать).")
        end

    elseif arg == "show" then
        SimpleXPBarDB.hidden = false
        self.frame:Show()
        self:Update()
        self:Print("SimpleXPBar: Полоса показана.")

    elseif arg == "hide" then
        SimpleXPBarDB.hidden = true
        self.frame:Hide()
        self:Print("SimpleXPBar: Полоса скрыта.")

    elseif arg == "toggle" then
        SimpleXPBarDB.hidden = not SimpleXPBarDB.hidden
        if SimpleXPBarDB.hidden then
            self.frame:Hide()
            self:Print("SimpleXPBar: Полоса скрыта.")
        else
            self.frame:Show()
            self:Update()
            self:Print("SimpleXPBar: Полоса показана.")
        end

    elseif arg == "reset" then
        self.frame:ClearAllPoints()
        self.frame:SetPoint("TOP", UIParent, "TOP", 0, -30)
        self:Print("SimpleXPBar: Позиция сброшена по центру.")

    else
        self:Print("Команды аддона (/sxp или /simplexp):")
        print("  |cff00ffff/sxp lock|r - Закрепить / Открепить полосу")
        print("  |cff00ffff/sxp show|r - Показать полосу XP")
        print("  |cff00ffff/sxp hide|r - Скрыть полосу XP")
        print("  |cff00ffff/sxp toggle|r - Показать / Скрыть")
        print("  |cff00ffff/sxp reset|r - Сбросить положение фрейма")
    end
end

-- ----------------------------------------------------------------------------
-- Инициализация и Запуск
-- ----------------------------------------------------------------------------
function SimpleXPBar:CreateTimer()
    if self.UpdateTimer and not self.UpdateTimer:IsCancelled() then
        self.UpdateTimer:Cancel()
    end
    self.UpdateTimer = _G.C_Timer.NewTicker(1.0, function()
        SimpleXPBar:Update()
    end)
end

function SimpleXPBar:OnInitialize()
    -- Инициализация базы сохраненных настроек
    _G.SimpleXPBarDB = _G.SimpleXPBarDB or {}
    if _G.SimpleXPBarDB.isLocked == nil then _G.SimpleXPBarDB.isLocked = false end
    if _G.SimpleXPBarDB.hidden == nil then _G.SimpleXPBarDB.hidden = false end

    self:CreateUI()

    -- Применяем сохраненное состояние мыши и видимости
    self.frame:EnableMouse(not _G.SimpleXPBarDB.isLocked)
    if _G.SimpleXPBarDB.hidden then
        self.frame:Hide()
    else
        self.frame:Show()
    end

    -- Регистрация новых слэш-команд /sxp
    self:RegisterChatCommand("sxp", "HandleCommand")
    self:RegisterChatCommand("simplexp", "HandleCommand")

    self:RegisterEvent("PLAYER_XP_UPDATE", "OnXPUpdate")
    self:RegisterEvent("PLAYER_ENTERING_WORLD", function()
        if self.session.startTime == 0 then
            self.session.startTime = _G.time()
        end
        self.session.lastXP = _G.UnitXP("player") or 0
        self.session.maxXP = _G.UnitXPMax("player") or 1
        self:Update()
    end)

    self:CreateTimer()
end