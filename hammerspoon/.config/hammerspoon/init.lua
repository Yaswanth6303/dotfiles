hs = hs

hs.loadSpoon("AClock")

-- Configure AClock
spoon.AClock.format = "%I:%M %p" -- 12hr format with AM/PM
-- %I → Hour (01–12)
-- %M → Minutes (00–59)
-- %p → AM or PM

hs.hotkey.bind({ "cmd", "alt" }, "C", function()
    spoon.AClock:toggleShow()
end)

-- Open or focus Telegram with Cmd + Alt + T
hs.hotkey.bind({ "cmd", "alt" }, "T", function()
    hs.application.launchOrFocus("Telegram")
end)

hs.hotkey.bind({ "alt" }, "R", function()
    hs.reload()
end)
hs.alert.show("Config loaded")

-- Load the spoon
hs.loadSpoon("CountDown")

-- Optional: set up some preferences
spoon.CountDown.defaultLenMinutes = 5 -- default countdown length
spoon.CountDown.messageDuration = 1.5 -- duration of messages shown
spoon.CountDown.alertLen = 2          -- how long to show final alert
spoon.CountDown.notify = true         -- show notification when time’s up
-- You can tweak more like warningFormat, warningShow etc. as per the API docs

-- Bind hotkeys for using the countdown
spoon.CountDown:bindHotkeys({
    start = { { "cmd", "alt" }, "D" },    -- Cmd+Alt+D starts a new countdown
    cancel = { { "cmd", "alt" }, "C" },   -- Cmd+Alt+C cancels it
    pauseResume = { { "cmd", "alt" }, "P" }, -- Cmd+Alt+P pauses / resumes
})

-- Alternatively: start a countdown with a custom duration, e.g. 10 mins
hs.hotkey.bind({ "cmd", "alt" }, "S", function()
    spoon.CountDown:startFor(10, function(minutes)
        hs.alert.show("⏱ Countdown (" .. minutes .. " min) done!")
    end)
end)
